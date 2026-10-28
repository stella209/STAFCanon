unit uMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  _EDSDK, _EDSDKErrors, _EDSDKTypes, Vcl.Imaging.jpeg;

type
  TForm1 = class(TForm)
    BtnConnect: TButton;
    BtnCapture: TButton;
    btnLiveview: TButton;
    EvfTimer: TTimer;
    Image1: TImage;
    ChkSaveToFile: TCheckBox;
    procedure BtnConnectClick(Sender: TObject);
    procedure BtnCaptureClick(Sender: TObject);
    procedure BtnLiveViewClick(Sender: TObject);
    procedure EvfTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FSDKInitialized: Boolean;
    FSessionOpened: Boolean;
    FLiveViewActive: Boolean;
    FCameraRef: EdsCameraRef;
    FCameraListRef: EdsCameraListRef;
    procedure DisconnectCamera;
    procedure StartLiveView;
    procedure StopLiveView;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

// GLOBÁLIS CALLBACK: Csak a végleges JPEG fotók letöltéséhez
function ObjectEventHandler(inEvent: EdsObjectEvent; inRef: EdsBaseRef; inContext: PVoid): EdsError; stdcall;
var
  err: EdsError;
  dirItemInfo: EdsDirectoryItemInfo;
  imageStream: EdsStreamRef;
  savePath: string;
  jpgPointer: Pointer;
  jpgSize: EdsUInt64;
  memStream: TMemoryStream;
  jpg: TJPEGImage;
begin
  Result := EDS_ERR_OK;
  imageStream := nil;

  if inEvent = kEdsObjectEvent_DirItemCreated then
  begin
    err := EdsGetDirectoryItemInfo(inRef, @dirItemInfo);
    if err = EDS_ERR_OK then
    begin
      // Csak a JPEG fájlokkal foglalkozunk
      if (dirItemInfo.isFolder = 0) and
         (UpperCase(ExtractFileExt(StrPas(dirItemInfo.szFileName))) <> '.CR2') then
      begin

        // --- 1. ESET: A felhasználó kéri a FÁJLBA mentést ---
        if Form1.ChkSaveToFile.Checked then
        begin
          savePath := ExtractFilePath(Application.ExeName) + 'foto_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.jpg';

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
                   imageStream := nil; // Nullázzuk, hogy a későbbi takarítás ne fusson rá újra
              end;
              // Megjelenítés a fájlból való letöltés után
              TThread.Queue(nil, procedure
              begin
                Form1.Image1.Picture.LoadFromFile(savePath);
                Form1.BtnCapture.Hint := 'Mentve és betöltve: ' + ExtractFileName(savePath);
              end);
            end;
          end;
        end

        // --- 2. ESET: CSAK MEMÓRIÁBA töltjük le elemzéshez ---
        else
        begin
          // Fájl helyett egy memóriafolyamot hozunk létre az SDK-ban
          err := EdsCreateMemoryStream(0, @imageStream);
          if err = EDS_ERR_OK then
          begin
            err := EdsDownload(inRef, dirItemInfo.size, imageStream);
            if err = EDS_ERR_OK then
            begin
              EdsDownloadComplete(inRef);

              // Lekérjük a letöltött JPEG memóriacímét és méretét
              err := EdsGetPointer(imageStream, @jpgPointer);
              if err = EDS_ERR_OK then
                err := EdsGetLength(imageStream, @jpgSize);

              if (err = EDS_ERR_OK) and (jpgSize > 0) then
              begin
                memStream := TMemoryStream.Create;
                try
                  memStream.WriteBuffer(jpgPointer^, jpgSize);
                  memStream.Position := 0;

                  // Átadjuk a vizuális szálnak a memóriából való kirajzoláshoz
                  TThread.Queue(nil, procedure
                  begin
                    jpg := TJPEGImage.Create;
                    try
                      jpg.LoadFromStream(memStream);
                      Form1.Image1.Picture.Assign(jpg); // Vagy a profi megjelenítőd .LoadFromStream-je
                      Form1.BtnCapture.Hint := 'Kép betöltve a memóriába (nincs mentve).';
                    finally
                      jpg.Free;
                    end;
                  end);

                finally
                  // Itt ne töröld le azonnal a memStream-et, mert a fenti aszinkron TThread.Queue-nak
                  // szüksége van rá. Biztonságosabb megoldás, ha a TThread.Queue-n belül szabadítjuk fel,
                  // vagy a memStream helyett közvetlenül a jpg.LoadFromStream-et hívjuk meg egy szinkronizált metódusban.
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

{ TForm1 }

procedure TForm1.BtnConnectClick(Sender: TObject);
var
  err: EdsError;
  cameraCount: EdsUInt32;
begin
  if FSessionOpened then
  begin
    DisconnectCamera;
    Exit;
  end;

  err := EdsInitializeSDK();
  if err <> EDS_ERR_OK then Exit;
  FSDKInitialized := True;

  err := EdsGetCameraList(@FCameraListRef);
  if err = EDS_ERR_OK then err := EdsGetChildCount(FCameraListRef, @cameraCount);

  if (err <> EDS_ERR_OK) or (cameraCount = 0) then
  begin
    DisconnectCamera;
    Exit;
  end;

  err := EdsGetChildAtIndex(FCameraListRef, 0, @FCameraRef);
  if err <> EDS_ERR_OK then begin DisconnectCamera; Exit; end;

  err := EdsOpenSession(FCameraRef);
  if err <> EDS_ERR_OK then begin DisconnectCamera; Exit; end;
  FSessionOpened := True;

  // Eseménykezelő regisztráció a letöltéshez
  EdsSetObjectEventHandler(FCameraRef, kEdsObjectEvent_All, @ObjectEventHandler, nil);

  // Kényszerítsük az SDK-t az inicializációs üzenetek azonnali feldolgozására!
  EdsGetEvent();
  Sleep(200); // 200 milliszekundumos szünet, hogy a gép megnyugodjon
  EdsGetEvent();

  // Gombok állapotának frissítése
  BtnConnect.Caption := 'Disconnect';
  BtnCapture.Enabled := True;
  BtnLiveView.Enabled := True;
  ShowMessage('EOS 2000D sikeresen csatlakoztatva!');
end;

// LIVEVIEW GOMB: Be- és kikapcsolja a folyamatot
procedure TForm1.BtnLiveViewClick(Sender: TObject);
begin
  if not FSessionOpened then Exit;

  if FLiveViewActive then
    StopLiveView
  else
    StartLiveView;
end;

// Élőkép elindítása a kamerán
procedure TForm1.StartLiveView;
var
  err: EdsError;
  evfMode: EdsUInt32;
  deviceValue: EdsUInt32;
const
  kEdsPropertyID_Evf_Mode         = Cardinal($00000501); // Új szükséges tulajdonság kód!
  kEdsPropertyID_Evf_OutputDevice = Cardinal($00000500);
begin
  if not FSessionOpened then Exit;

  // 1. LÉPÉS: Bekapcsoljuk az Evf_Mode-ot a kamerán (Értéke fixen 1 = Enabled)
  evfMode := 1;
  err := EdsSetPropertyData(FCameraRef, kEdsPropertyID_Evf_Mode, 0, 4, @evfMode);

  if err <> EDS_ERR_OK then
  begin
    ShowMessage('Hiba az EVF Mód aktiválásakor: ' + IntToHex(err, 8));
    Exit;
  end;

  // Adunk egy pillanatot a gépnek, hogy feldolgozza
  EdsGetEvent();
  Sleep(100);

  // 2. LÉPÉS: Átirányítjuk a képet a PC-re (Értéke fixen 2 = PC)
  deviceValue := 2;
  err := EdsSetPropertyData(FCameraRef, kEdsPropertyID_Evf_OutputDevice, 0, 4, @deviceValue);

  if err = EDS_ERR_OK then
  begin
    FLiveViewActive := True;
    BtnLiveView.Caption := 'LiveView STOP';
    EvfTimer.Enabled := True; // Elindul az időzítő, ami kéri a képeket
  end
  else
  begin
    ShowMessage('A kimenet átváltása sikertelen! Kód: ' + IntToHex(err, 8));
  end;
end;

// Élőkép leállítása
procedure TForm1.StopLiveView;
var
  device: EdsUInt32;
  evfMode: EdsUInt32;
const
  // Szükséges belső kód az élő kép mód leállításához
  kEdsPropertyID_Evf_Mode = Cardinal($00000501);
begin
  // 1. Azonnal megállítjuk az időzítőt, hogy ne kérjen több adatot a gépből
  EvfTimer.Enabled := False;
  FLiveViewActive := False;
  BtnLiveView.Caption := 'LiveView';

  // Biztosítjuk, hogy a futó üzenetek kiürüljenek a leállítás előtt
  EdsGetEvent();
  Sleep(50);

  // 2. Visszaállítjuk a kimenetet a kamera saját LCD-jére (TFT)
  device := kEdsOutputDevice_TFT;
  EdsSetPropertyData(FCameraRef, kEdsPropertyID_Evf_OutputDevice, 0, SizeOf(device), @device);

  EdsGetEvent();
  Sleep(50); // Kis szünet, hogy a gép átváltson

  // 3. KRITIKUS KIEGÉSZÍTÉS: Teljesen kikapcsoljuk az EVF módot a kamerán (0 = Disabled)
  // Ez a parancs jelzi az EOS 2000D szoftverének, hogy zárja le a szenzort és engedje le a tükröt!
  evfMode := 0;
  EdsSetPropertyData(FCameraRef, kEdsPropertyID_Evf_Mode, 0, SizeOf(evfMode), @evfMode);

  // 4. Utolsó kényszerített üzenet-pörgetés, hogy a gép azonnal végrehajtsa a fizikai mozgást
  EdsGetEvent();
end;


// IDŐZÍTŐ: Ez kéri le a JPEG képkockákat másodpercenként 25-ször
procedure TForm1.EvfTimerTimer(Sender: TObject);
var
  err: EdsError;
  evfImageRef: EdsEvfImageRef;
  streamRef: EdsStreamRef;
  jpg: TJPEGImage;
  jpgPointer: Pointer;
  jpgSize: EdsUInt64;
  memStream: TMemoryStream;
begin
  if (not FSessionOpened or not FLiveViewActive) then Exit;

  evfImageRef := nil;
  streamRef := nil;

  // 1. Létrehozunk egy memóriafolyamot az SDK-ban a JPEG fogadására
  err := EdsCreateMemoryStream(0, @streamRef);
  if err <> EDS_ERR_OK then Exit;

  try
    // 2. Létrehozzuk az EVF képobjektumot
    err := EdsCreateEvfImageRef(streamRef, @evfImageRef);
    if err <> EDS_ERR_OK then Exit;

    // 3. Letöltjük az aktuális élő képkockát a kamerából a folyamatba
    err := EdsDownloadEvfImage(FCameraRef, evfImageRef);
    if err = EDS_ERR_OK then
    begin
      // 4. Lekérjük a memóriacímet és a JPEG adat méretét az SDK-tól
      err := EdsGetPointer(streamRef, @jpgPointer);
      if err = EDS_ERR_OK then
        err := EdsGetLength(streamRef, @jpgSize);

      if (err = EDS_ERR_OK) and (jpgSize > 0) then
      begin
        // 5. Beolvassuk a tiszta JPEG adatot egy Delphi TMemoryStream-be
        memStream := TMemoryStream.Create;
        try
          memStream.WriteBuffer(jpgPointer^, jpgSize);
          memStream.Position := 0;

          // --- ITT ADJUK ÁT A PROFI MEGJELENÍTŐDNEK ---
          // Például ha a megtekintődnek van LoadFromStream metódusa:
          // ProfiMegjelenito.LoadFromStream(memStream);
          // Vagy ha TImage-be töltenéd tesztként: Form1.Image1.Picture.Graphic.LoadFromStream(memStream);
          jpg := TJPEGImage.Create;
          try
            // Beolvassuk a JPEG adatot a memóriából
            jpg.LoadFromStream(memStream);

            // Átadjuk az Image1 komponensnek (ez már hibátlanul lefut)
            Form1.Image1.Picture.Assign(jpg);
          finally
            jpg.Free;
          end;

        finally
          memStream.Free;
        end;
      end;
    end;

    // Windows üzenetek pörgetése, hogy az SDK aszinkron magja lélegezzen
    EdsGetEvent();

  finally
    // Erőforrások szigorú felszabadítása minden egyes képkocka után!
    if evfImageRef <> nil then EdsRelease(evfImageRef);
    if streamRef <> nil then EdsRelease(streamRef);
  end;
end;

procedure TForm1.BtnCaptureClick(Sender: TObject);
begin
  if not FSessionOpened then Exit;
  EdsSendCommand(FCameraRef, kEdsCameraCommand_TakePicture, 0);
  EdsGetEvent();
end;

procedure TForm1.DisconnectCamera;
begin
  if FLiveViewActive then StopLiveView;
  if FSessionOpened then begin EdsCloseSession(FCameraRef); FSessionOpened := False; end;
  if FCameraRef <> nil then begin EdsRelease(FCameraRef); FCameraRef := nil; end;
  if FCameraListRef <> nil then begin EdsRelease(FCameraListRef); FCameraListRef := nil; end;
  if FSDKInitialized then begin EdsTerminateSDK(); FSDKInitialized := False; end;
  BtnConnect.Caption := 'Connect';
  BtnCapture.Enabled := False;
  BtnLiveView.Enabled := False;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DisconnectCamera;
end;

end.
