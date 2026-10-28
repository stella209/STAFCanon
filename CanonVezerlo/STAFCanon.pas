unit STAFCanon;

interface

uses
  System.SysUtils, System.Classes, Vcl.ExtCtrls, Vcl.Imaging.jpeg, Vcl.Graphics,
  _EDSDK, _EDSDKErrors, _EDSDKTypes;

type
  TLiveViewFrameEvent = procedure(Sender: TObject; ABitmap: TBitmap) of object;
  TPhotoCapturedEvent = procedure(Sender: TObject; AMemStream: TMemoryStream; const ASavedPath: string) of object;
  TCanonErrorEvent    = procedure(Sender: TObject; const AMsg: string) of object;

  TCanon = class(TComponent)
  private
    FSDKInitialized: Boolean;
    FSessionOpened: Boolean;
    FLiveViewActive: Boolean;
    FCameraRef: EdsCameraRef;
    FCameraListRef: EdsCameraListRef;
    FEvfTimer: TTimer;
    FSaveToFile: Boolean;

    FOnConnect: TNotifyEvent;
    FOnDisconnect: TNotifyEvent;
    FOnLiveViewFrame: TLiveViewFrameEvent;
    FOnPhotoCaptured: TPhotoCapturedEvent;
    FOnError: TCanonErrorEvent;

    procedure SetSaveToFile(const Value: Boolean);
    procedure OnTimerTick(Sender: TObject);
    procedure DoError(const AMsg: string; AErrCode: EdsError);
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Connect;
    procedure Disconnect;
    procedure StartLiveView;
    procedure StopLiveView;
    procedure Capture;

    function HandleObjectEvent(inEvent: EdsObjectEvent; inRef: EdsBaseRef): EdsError;

    property IsConnected: Boolean read FSessionOpened;
    property IsLiveViewActive: Boolean read FLiveViewActive;
  published
    property SaveToFile: Boolean read FSaveToFile write SetSaveToFile default True;

    property OnConnect: TNotifyEvent read FOnConnect write FOnConnect;
    property OnDisconnect: TNotifyEvent read FOnDisconnect write FOnDisconnect;
    property OnLiveViewFrame: TLiveViewFrameEvent read FOnLiveViewFrame write FOnLiveViewFrame;
    property OnPhotoCaptured: TPhotoCapturedEvent read FOnPhotoCaptured write FOnPhotoCaptured;
    property OnError: TCanonErrorEvent read FOnError write FOnError;
  end;

procedure Register;

implementation

function GlobalObjectEventHandler(inEvent: EdsObjectEvent; inRef: EdsBaseRef; inContext: PEdsVoid): EdsError; stdcall;
begin
  Result := EDS_ERR_OK;
  if inContext <> nil then
    Result := TCanon(inContext).HandleObjectEvent(inEvent, inRef);
end;

constructor TCanon.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSDKInitialized := False;
  FSessionOpened := False;
  FLiveViewActive := False;
  FSaveToFile := True;
  FCameraRef := nil;
  FCameraListRef := nil;

  FEvfTimer := TTimer.Create(Self);
  FEvfTimer.Enabled := False;
  FEvfTimer.Interval := 40;
  FEvfTimer.OnTimer := OnTimerTick;
end;

destructor TCanon.Destroy;
begin
  Disconnect;
  inherited Destroy;
end;

procedure TCanon.Loaded;
begin
  inherited Loaded;
end;

procedure TCanon.DoError(const AMsg: string; AErrCode: EdsError);
begin
  if Assigned(FOnError) then
    FOnError(Self, AMsg + ' (Kód: $' + IntToHex(AErrCode, 8) + ')');
end;

procedure TCanon.Connect;
var
  err: EdsError;
  cameraCount: EdsUInt32;
begin
  if FSessionOpened then Exit;

  err := EdsInitializeSDK();
  if err <> EDS_ERR_OK then
  begin
    DoError('SDK inicializálás sikertelen!', err);
    Exit;
  end;
  FSDKInitialized := True;

  err := EdsGetCameraList(FCameraListRef);
  if err = EDS_ERR_OK then
    err := EdsGetChildCount(FCameraListRef, @cameraCount);

  if (err <> EDS_ERR_OK) or (cameraCount = 0) then
  begin
    DoError('Nem található csatlakoztatott Canon kamera!', err);
    Disconnect;
    Exit;
  end;

  err := EdsGetChildAtIndex(FCameraListRef, 0, @FCameraRef);
  if err <> EDS_ERR_OK then
  begin
    Disconnect;
    Exit;
  end;

  err := EdsOpenSession(FCameraRef);
  if err <> EDS_ERR_OK then
  begin
    DoError('Session megnyitása sikertelen!', err);
    Disconnect;
    Exit;
  end;
  FSessionOpened := True;

  EdsSetObjectEventHandler(FCameraRef, kEdsObjectEvent_All, @GlobalObjectEventHandler, Self);
  EdsGetEvent();

  if Assigned(FOnConnect) then
    FOnConnect(Self);
end;

procedure TCanon.Disconnect;
begin
  if FLiveViewActive then StopLiveView;

  if FSessionOpened then
  begin
    EdsCloseSession(FCameraRef);
    FSessionOpened := False;
  end;

  if FCameraRef <> nil then
  begin
    EdsRelease(FCameraRef);
    FCameraRef := nil;
  end;

  if FCameraListRef <> nil then
  begin
    EdsRelease(FCameraListRef);
    FCameraListRef := nil;
  end;

  if FSDKInitialized then
  begin
    EdsTerminateSDK();
    FSDKInitialized := False;
  end;

  if Assigned(FOnDisconnect) then
    FOnDisconnect(Self);
end;

procedure TCanon.StartLiveView;
var
  err: EdsError;
  evfMode, deviceValue: EdsUInt32;
begin
  if not FSessionOpened or FLiveViewActive then Exit;

  evfMode := 1;
  err := EdsSetPropertyData(FCameraRef, kEdsPropertyID_Evf_Mode, 0, 4, @evfMode);
  if err <> EDS_ERR_OK then
  begin
    DoError('EVF Mód nem aktiválható!', err);
    Exit;
  end;

  EdsGetEvent();

  deviceValue := kEdsOutputDevice_PC;
  err := EdsSetPropertyData(FCameraRef, kEdsPropertyID_Evf_OutputDevice, 0, 4, @deviceValue);

  if err = EDS_ERR_OK then
  begin
    FLiveViewActive := True;
    FEvfTimer.Enabled := True;
  end
  else
    DoError('LiveView kimenet átváltása sikertelen (BUSY?).', err);
end;

procedure TCanon.StopLiveView;
var
  deviceValue: EdsUInt32;
  evfMode: EdsUInt32;
const
  kEdsPropertyID_Evf_Mode         = Cardinal($00000501);
  kEdsPropertyID_Evf_OutputDevice = Cardinal($00000500);
begin
  if not FLiveViewActive then Exit;

  // 1. Azonnal leállítjuk az idõzítõt, hogy ne kérjen be több képkockát
  FEvfTimer.Enabled := False;
  FLiveViewActive := False;

  // Kipörgetjük az utolsó folyamatban lévõ Windows/SDK eseményeket
  EdsGetEvent();
  Sleep(50);

  // 2. LÉPÉS: Visszaállítjuk a kimeneti eszközt a kamera saját kijelzõjére (TFT = 1)
  deviceValue := kEdsOutputDevice_TFT;
  EdsSetPropertyData(FCameraRef, kEdsPropertyID_Evf_OutputDevice, 0, 4, @deviceValue);

  EdsGetEvent();
  Sleep(50); // Kis szünet, hogy a gép feldolgozza az átváltást

  // 3. LÉPÉS (A KRITIKUS PONT): Explicit módon KIKAPCSOLJUK az EVF módot (evfMode = 0)
  // Ez jelzi az EOS 2000D-nek, hogy teljesen lezárult a LiveView folyamat, ekkor fog kattanni a tükör!
  evfMode := 0;
  EdsSetPropertyData(FCameraRef, kEdsPropertyID_Evf_Mode, 0, 4, @evfMode);

  // 4. LÉPÉS: Kényszerített puffer-ürítés. Addig pörgetjük az eseményeket, amíg a gép fizikailag le nem zárja
  EdsGetEvent();
end;

procedure TCanon.Capture;
var
  err: EdsError;
begin
  if not FSessionOpened then Exit;
  err := EdsSendCommand(FCameraRef, kEdsCameraCommand_TakePicture, 0);
  if err <> EDS_ERR_OK then
    DoError('Exponálás parancs elutasítva!', err);
  EdsGetEvent();
end;

procedure TCanon.OnTimerTick(Sender: TObject);
var
  err: EdsError;
  evfImageRef: EdsEvfImageRef;
  streamRef: EdsStreamRef;
  jpgPointer: Pointer;
  jpgSize: EdsUInt64;
  memStream: TMemoryStream;
  jpg: TJPEGImage;
  bmp: TBitmap;
begin
  if not FSessionOpened or not FLiveViewActive then Exit;

  evfImageRef := nil;
  streamRef := nil;

  err := EdsCreateMemoryStream(0, @streamRef);
  if err <> EDS_ERR_OK then Exit;

  try
    err := EdsCreateEvfImageRef(streamRef, @evfImageRef);
    if err <> EDS_ERR_OK then Exit;

    err := EdsDownloadEvfImage(FCameraRef, evfImageRef);
    if err = EDS_ERR_OK then
    begin
      err := EdsGetPointer(streamRef, @jpgPointer);
      if err = EDS_ERR_OK then err := EdsGetLength(streamRef, @jpgSize);

      if (err = EDS_ERR_OK) and (jpgSize > 0) then
      begin
        memStream := TMemoryStream.Create;
        try
          memStream.WriteBuffer(jpgPointer^, jpgSize);
          memStream.Position := 0;

          jpg := TJPEGImage.Create;
          bmp := TBitmap.Create;
          try
            jpg.LoadFromStream(memStream);
            bmp.Assign(jpg);

            if Assigned(FOnLiveViewFrame) then
              FOnLiveViewFrame(Self, bmp);
          finally
            jpg.Free;
            bmp.Free;
          end;
        finally
          memStream.Free;
        end;
      end;
    end;
    EdsGetEvent();
  finally
    if evfImageRef <> nil then EdsRelease(evfImageRef);
    if streamRef <> nil then EdsRelease(streamRef);
  end;
end;

function TCanon.HandleObjectEvent(inEvent: EdsObjectEvent; inRef: EdsBaseRef): EdsError;
var
  err: EdsError;
  dirItemInfo: EdsDirectoryItemInfo;
  imageStream: EdsStreamRef;
  savePath: string;
  jpgPointer: Pointer;
  jpgSize: EdsUInt64;
  memStream: TMemoryStream;
begin
  Result := EDS_ERR_OK;
  imageStream := nil;

  if inEvent = kEdsObjectEvent_DirItemCreated then
  begin
    err := EdsGetDirectoryItemInfo(inRef, @dirItemInfo);
    if err = EDS_ERR_OK then
    begin
      if (dirItemInfo.isFolder = 0) and (UpperCase(ExtractFileExt(StrPas(dirItemInfo.szFileName))) <> '.CR2') then
      begin
        if FSaveToFile then
        begin
          savePath := ExtractFilePath(ParamStr(0)) + 'foto_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.jpg';
          err := EdsCreateFileStream(PAnsiChar(AnsiString(savePath)),
                 kEdsFileCreateDisposition_CreateAlways, kEdsAccess_ReadWrite, @imageStream);
          if err = EDS_ERR_OK then
          begin
            err := EdsDownload(inRef, dirItemInfo.size, imageStream);
            if err = EDS_ERR_OK then
            begin
              EdsDownloadComplete(inRef);
              if imageStream <> nil then
              begin
                   EdsRelease(imageStream);
                   imageStream := nil; // Nullázzuk, hogy a késõbbi takarítás ne fusson rá újra
              end;
              if Assigned(FOnPhotoCaptured) then
                TThread.Synchronize(nil, procedure
                begin
                  FOnPhotoCaptured(Self, nil, savePath);
                end);
            end;
          end;
          if imageStream <> nil then EdsRelease(imageStream);
        end
        else
        begin
          err := EdsCreateMemoryStream(0, @imageStream);
          if err = EDS_ERR_OK then
          begin
            err := EdsDownload(inRef, dirItemInfo.size, imageStream);
            if err = EDS_ERR_OK then
            begin
              EdsDownloadComplete(inRef);
              err := EdsGetPointer(imageStream, @jpgPointer);
              if err = EDS_ERR_OK then err := EdsGetLength(imageStream, @jpgSize);

              if (err = EDS_ERR_OK) and (jpgSize > 0) then
              begin
                memStream := TMemoryStream.Create;
                try
                  memStream.WriteBuffer(jpgPointer^, jpgSize);
                  memStream.Position := 0;

                  if Assigned(FOnPhotoCaptured) then
                  begin
                    TThread.Synchronize(nil, procedure
                    begin
                      FOnPhotoCaptured(Self, memStream, '');
                    end);
                  end;
                finally
                  memStream.Free;
                end;
              end;
            end;
          end;
          if imageStream <> nil then EdsRelease(imageStream);
        end;
      end;
    end;
  end;
end;

procedure TCanon.SetSaveToFile(const Value: Boolean);
begin
  FSaveToFile := Value;
end;

procedure Register;
begin
  RegisterComponents('CanonSDK', [TCanon]);
end;

end.

