unit UFormMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, 
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.jpeg, STAFCanon, _EDSDK, _EDSDKTypes, _EDSDKErrors, Vcl.Buttons,
  Vcl.ComCtrls;

type
  TFormMain = class(TForm)
    BtnConnect: TButton;
    BtnDisconnect: TButton;
    BtnCapture: TButton;
    BtnBulbStart: TButton;
    BtnBulbStop: TButton;
    BtnOpenLiveView: TButton;
    MemoLog: TMemo;
    CheckBox1: TCheckBox;
    Label2: TLabel;
    Label4: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    Panel1: TPanel;
    Image1: TImage;
    Label6: TLabel;
    Label7: TLabel;
    cbCameralist: TComboBox;
    Button1: TButton;
    lbAE: TLabel;
    SpeedButton1: TSpeedButton;
    StatusBar1: TStatusBar;
    ProgressBar1: TProgressBar;
    Label3: TLabel;
    ProgressBar2: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnConnectClick(Sender: TObject);
    procedure BtnDisconnectClick(Sender: TObject);
    procedure BtnCaptureClick(Sender: TObject);
    procedure BtnBulbStartClick(Sender: TObject);
    procedure BtnBulbStopClick(Sender: TObject);
    procedure BtnOpenLiveViewClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    FCanon: TCanon;
    procedure OnCanonConnect(Sender: TObject);
    procedure OnCanonDisconnect(Sender: TObject);
    procedure OnCanonPhotoCaptured(Sender: TObject; ABitmap: TBitmap; AMemStream: TMemoryStream; const ASavedPath: string);
    procedure OnCanonPropertyChange(Sender: TObject; APropertyID: EdsPropertyID; AParam: EdsUInt32);
    procedure OnCanonStateChange(Sender: TObject; AStateEventID: EdsStateEvent; AParam: EdsUInt32);
    procedure OnCanonProgress(Sender: TObject; APercent: EdsUInt32; var ABreak: Boolean);
    procedure OnCanonError(Sender: TObject; const AMsg: string);
    procedure OpenDialog1Click(Sender: TObject);
  public
    property Canon: TCanon read FCanon;
  end;

var
  FormMain: TFormMain;

implementation

uses UFormLiveView;

{$R *.dfm}

procedure TFormMain.FormCreate(Sender: TObject);
begin
  FCanon := TCanon.Create(nil);
  FCanon.OnConnect := OnCanonConnect;
  FCanon.OnDisconnect := OnCanonDisconnect;
  FCanon.OnPhotoCaptured := OnCanonPhotoCaptured;
  FCanon.OnPropertyChange := OnCanonPropertyChange;
  FCanon.OnStateChange := OnCanonStateChange;
  FCanon.OnProgress := OnCanonProgress;
  FCanon.OnError := OnCanonError;
//  Label1.Caption := Canon.FileNameGenerate(Canon.FilePath+Canon.FileName+'.JPG');
  Button1Click(Sender);
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  FCanon.Free;
end;

procedure TFormMain.BtnConnectClick(Sender: TObject);
begin
  MemoLog.Lines.Add('Kapcsolódás kezdeményezése...');
  FCanon.Connect;
end;

procedure TFormMain.BtnDisconnectClick(Sender: TObject);
begin
  FCanon.Disconnect;
end;

procedure TFormMain.BtnCaptureClick(Sender: TObject);
begin
  if FCanon.IsConnected then FCanon.Capture;
end;

procedure TFormMain.BtnBulbStartClick(Sender: TObject);
begin
  if FCanon.IsConnected then
  begin
    MemoLog.Lines.Add('10 másodperces BULB expozíció indítása...');
    FCanon.BulbCapture(10000);
  end;
end;

procedure TFormMain.BtnBulbStopClick(Sender: TObject);
begin
  FCanon.EndBulbCapture;
  MemoLog.Lines.Add('BULB expozíció manuálisan megszakítva.');
end;

procedure TFormMain.BtnOpenLiveViewClick(Sender: TObject);
begin
  if FormLiveView = nil then
    FormLiveView := TFormLiveView.Create(Self);
  FormLiveView.Show;
end;

procedure TFormMain.Button1Click(Sender: TObject);
begin
  Canon.ScanCameras( cbCameralist.Items );
  cbCameralist.ItemIndex := 0;
  cbCameralist.Text := cbCameralist.Items[0];
end;

procedure TFormMain.OnCanonConnect(Sender: TObject);
begin
  If Canon.IsConnected then begin
     ComboBox1.Items:= Canon.GetISOList;
     ComboBox1.Text := Canon.GetISO;
     ComboBox2.Items:= Canon.GetTvList;
     ComboBox2.Text := Canon.GetTv;
     ComboBox3.Items:= Canon.GetWBList;
     ComboBox3.Text := Canon.GetWB;
     ComboBox4.Items:= Canon.GetQualityList;
     ComboBox4.Text := Canon.GetQuality;
     lbAE.Caption   := Canon.GetAEMode;
     Label7.Caption := Canon.GetOwnerName;
   end;
   MemoLog.Lines.Add('Kamera csatlakoztatva online.');
end;

procedure TFormMain.OnCanonDisconnect(Sender: TObject);
begin
  If not Canon.IsConnected then begin
     ComboBox1.Items.Clear;
     ComboBox1.Text := '';
     ComboBox2.Items.Clear;
     ComboBox2.Text := '';
     ComboBox3.Items.Clear;
     ComboBox3.Text := '';
     ComboBox4.Items.Clear;
     ComboBox4.Text := '';
     Label7.Caption := '';
   end;
  MemoLog.Lines.Add('Kamera lecsatlakoztatva offline.');
end;

procedure TFormMain.OnCanonPhotoCaptured(Sender: TObject; ABitmap: TBitmap; AMemStream: TMemoryStream; const ASavedPath: string);
var
  delphiFileStream: TMemoryStream; // Lokálisan deklarálva, így nem maradhat ki!
  delphiMemStream: TMemoryStream;
  jpg: TJPEGImage;
  pSrc, pEnd: PByte;
  FoundJPG: Boolean;
begin
  MemoLog.Lines.Add('Új kép elkészült: ' + ASavedPath);
  Image1.Picture.Assign(ABitmap);
  Image1.Repaint;
  StatusBar1.Panels[0].Text := Inttostr(ABitmap.Width)+' x '+
                               Inttostr(ABitmap.Height);
end;

procedure TFormMain.OnCanonPropertyChange(Sender: TObject;
          APropertyID: EdsPropertyID; AParam: EdsUInt32);
begin
  If Canon.IsConnected then
  case APropertyID of
  kEdsPropID_ISOSpeed    : ComboBox1.Text := Canon.GetISO;
  kEdsPropID_Tv          : ComboBox2.Text := Canon.GetTv;
  kEdsPropID_Av          : ComboBox4.Text := Canon.GetQuality;
  kEdsPropID_WhiteBalance: ComboBox3.Text := Canon.GetWB;
  kEdsPropID_AEMode      : lbAE.Caption   := Canon.GetAEMode;
  end;

  MemoLog.Lines.Add(Format('[Property] Változás észlelve - ID: $%X, Paraméter: %d', [APropertyID, AParam]));
end;

procedure TFormMain.OnCanonStateChange(Sender: TObject; AStateEventID: EdsStateEvent; AParam: EdsUInt32);
begin
  MemoLog.Lines.Add(Format('[State] Állapotváltozás - EventID: %d, Paraméter: %d', [AStateEventID, AParam]));
end;

procedure TFormMain.OnCanonProgress(Sender: TObject; APercent: EdsUInt32; var ABreak: Boolean);
begin
  MemoLog.Lines.Add(Format('[Progress] Fájlátvitel folyamatban: %d%%', [APercent]));
  ProgressBar2.Position := APercent;
end;

procedure TFormMain.OnCanonError(Sender: TObject; const AMsg: string);
begin
  MemoLog.Lines.Add('[SDK HIBA]: ' + AMsg);
end;

procedure TFormMain.OpenDialog1Click(Sender: TObject);
begin
end;

procedure TFormMain.CheckBox1Click(Sender: TObject);
begin
     Canon.SaveToFile := CheckBox1.Checked;
end;

procedure TFormMain.ComboBox1Change(Sender: TObject);
begin
  Canon.setIso(ComboBox1.Text);
end;

procedure TFormMain.ComboBox2Change(Sender: TObject);
begin
  Canon.setTv(ComboBox2.Text);
end;

procedure TFormMain.ComboBox3Change(Sender: TObject);
begin
  Canon.setWB(ComboBox3.Text);
end;

procedure TFormMain.ComboBox4Change(Sender: TObject);
begin
  Canon.setQuality(ComboBox4.Text);
end;

end.
