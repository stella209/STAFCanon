unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Gauges, Buttons,
  FileCtrl, Vcl.Samples.Spin, Vcl.AppEvnts,
  _EDSDK, _EDSDKTYPES, _EDSDKERRORS, STAFCanon, AL_ZoomImg;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    Button1: TButton;
    Shape1: TShape;
    Button2: TButton;
    Button3: TButton;
    Label4: TLabel;
    ComboBox2: TComboBox;
    Label6: TLabel;
    Label7: TLabel;
    ProgressBar1: TProgressBar;
    Label5: TLabel;
    Label12: TLabel;
    ComboBox3: TComboBox;
    Label13: TLabel;
    ComboBox4: TComboBox;
    Button7: TButton;
    Label15: TLabel;
    Button8: TButton;
    StatusBar1: TStatusBar;
    Label16: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Gauge1: TGauge;
    Bevel1: TBevel;
    Label8: TLabel;
    Edit2: TEdit;
    SpeedButton1: TSpeedButton;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    edUserTag: TEdit;
    cbSeries: TCheckBox;
    Label17: TLabel;
    spCount: TSpinEdit;
    btnSTART: TButton;
    Panel1: TPanel;
    CheckBox6: TCheckBox;
    cbExpTime: TComboBox;
    Label14: TLabel;
    ComboBox6: TComboBox;
    Label18: TLabel;
    edDelay: TEdit;
    Label19: TLabel;
    ListBox1: TListBox;
    Button4: TButton;
    Panel2: TPanel;
    ALZ: TALZoomImage;
    Panel3: TPanel;
    Button5: TButton;
    ComboBox5: TComboBox;
    Label20: TLabel;
    lbAE: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    ComboBox7: TComboBox;
    Button6: TButton;
    CheckBox5: TCheckBox;
    ApplicationEvents1: TApplicationEvents;
    procedure SpeedButton1Click(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Canon1Connect(Sender: TObject; Connected: Boolean);
    procedure Canon1NewFile(Sender: TObject; SavedFile: string);
    procedure Canon1Progress(Sender: TObject; Percent: Cardinal);
    procedure Canon1ChangeParams(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure btnSTARTClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ComboBox5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
  private
    procedure OnAfterDownload(Sender: TObject);
    procedure SetComment(fn, s: string);
    { Private declarations }
  public
    Canon1: TCanon;
    procedure FileNameGenerate;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Canon1:= TCanon.Create(Form1);
//  Canon1.Parent := Form1;
  Canon1.Name   := 'Canon1';
  Canon1.OnConnect := Canon1Connect;
  Canon1.OnNewFile := Canon1NewFile;
  Canon1.OnChangeParams  := Canon1ChangeParams;
  Canon1.OnProgress  := Canon1Progress;
  Canon1.Connect(0);
  canon1.FilePath := ExtractFilePath(application.exename);
  Edit2.Text := canon1.FilePath;
  canon1.OnAfterDownload := OnAfterDownload;
end;

procedure TForm1.Canon1Connect(Sender: TObject; Connected: Boolean);
begin
  Canon1ChangeParams(Sender);
  Label1.Caption := Canon1.CameraName;
  if Connected then begin
     Shape1.Brush.Color := clLime;
     Canon1.GetProperty(kEdsPropID_OwnerName);
     Label7.caption := Canon1.CameraString;
     Canon1.GetProperty(kEdsPropID_BatteryLevel);
     ProgressBar1.Position := Canon1.cameraint;
     Canon1.GetProperty(kEdsPropID_WhiteBalance);
     Label10.Caption := DateTimeToStr(Canon1.GetTime);
//     Canon1.TransferMode := toMemory;
  end
  else begin
     Shape1.Brush.Color := clWhite;
  end;
  Edit2.Text := canon1.FilePath;
  ComboBox1.Enabled:=Connected;
  ComboBox2.Enabled:=Connected;
end;

procedure TForm1.FileNameGenerate;
begin
  with Canon1.FileNameProc do begin
       if Edit1.Text<>'' then begin
          lPrefix:= True;
          Prefix := Edit1.Text;
       end;
          lDate  := CheckBox1.Checked;
          lTime  := CheckBox4.Checked;
          lUT    := CheckBox5.Checked;
          lJD    := CheckBox2.Checked;

       StatusBar1.Panels[1].Text := Canon1.FileNameProc.FileName;
  end;
end;


procedure TForm1.ListBox1Click(Sender: TObject);
begin
  Label1.Caption := ListBox1.Items[ListBox1.ItemIndex];
end;

procedure TForm1.OnAfterDownload(Sender: TObject);
var s: string;
begin
     s:='EQ 13:13:22,3 -12:12:14'+chr(13)+chr(10)+
        'OBJ NGC 18884'+chr(13)+chr(10)+
        'CONST CYG';
     s:= 'STELLA';
     SetComment(Canon1.NewFile,s)
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Canon1.Connect(ListBox1.ItemIndex);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Canon1.TakePicture;
  ALZ.OrigBMP.Assign(Canon1.BMP);
  ALZ.RestoreOriginal;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Canon1.DisConnect;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Canon1.ScanCameras( ListBox1.Items );
end;

procedure TForm1.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
var err: EdsError;
begin
  Handled := false;
  Case Msg.message of

  WM_USER+2: { Object Event occurred }
      begin
        err:= Canon1.getImageData( EdsBaseRef(Msg.lParam), Edit2.Text, '' );
        if err <> EDS_ERR_OK then
          StatusBar1.SimpleText := 'Download error occurred!';

        Handled := true;
      end;

  End;
end;

procedure TForm1.btnSTARTClick(Sender: TObject);
begin
  With Canon1.Expositions do begin
    Series    := cbSeries.Checked;
    BulbCable := CheckBox6.Checked;
    BulbPort  := StrToInt(ComboBox6.Text);
    Count     := spCount.Value;
    ExpTime   := StrToInt(cbExpTime.Text);
    Delay     := StrToInt(edDelay.Text);
  end;
  Canon1.TakePictureSeries;
end;

procedure TForm1.Button5Click(Sender: TObject);
var iso,res,data: EdsUInt32;
    sIso: string;
begin
  ISO := $14;
  sIso:='400';
  Canon1.SetISO('400');
  Canon1.SetPropertyInt(kEdsPropID_TV,ISO);
  Label3.Caption := inttostr(Canon1.iso);
  ComboBox1.Items:=Canon1.GetISOList;
     ComboBox1.Text := Canon1.GetISO;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  Canon1.SetTv('Bulb');
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  Canon1.SetISO(ComboBox1.Text);
end;

procedure TForm1.ComboBox2Change(Sender: TObject);
begin
  Canon1.SetTv(ComboBox2.Text);
end;

procedure TForm1.Canon1ChangeParams(Sender: TObject);
begin
  If Canon1.IsConnect then begin
     ComboBox1.Items:= Canon1.GetISOList;
     ComboBox1.Text := Canon1.GetISO;
     ComboBox2.Items:= Canon1.GetTvList;
     ComboBox2.Text := Canon1.GetTv;
     Panel1.Enabled := Canon1.Tv=$0C;
     ComboBox3.Items:= Canon1.GetWBList;
     ComboBox3.Text := Canon1.GetWB;
     ComboBox4.Items:= Canon1.GetQualityList;
     ComboBox4.Text := Canon1.GetQuality;
     lbAE.Caption   := Canon1.GetAEMode;
  end else begin
     ComboBox1.Text := '';
     ComboBox2.Text := '';
  end;
     Canon1.GetProperty(kEdsPropID_BatteryLevel);
     ProgressBar1.Position := Canon1.cameraint;
     Canon1.GetProperty(kEdsPropID_WhiteBalance);
     Canon1.GetProperty(kEdsPropID_ImageQuality);
end;

procedure TForm1.ComboBox3Change(Sender: TObject);
begin
  Canon1.SetWB(ComboBox3.Text);
end;

procedure TForm1.ComboBox4Change(Sender: TObject);
begin
  Canon1.SetQuality(ComboBox4.Text);
end;

procedure TForm1.ComboBox5Click(Sender: TObject);
begin
  Canon1.TransferMode := TTransferMode(ComboBox5.ItemIndex);
end;

procedure TForm1.Button7Click(Sender: TObject);
var d: TDateTime;
begin
  d:=Canon1.gettime;
  Label15.caption:=datetimetostr(d); 
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  Canon1.settime(now);
end;

procedure TForm1.Canon1Progress(Sender: TObject; Percent: Cardinal);
var s: string;
begin
  Gauge1.Progress := Percent;
  IF Percent=100 then begin
     Sleep(1000);
     Gauge1.Progress := 0;
  end;
  Gauge1.Repaint;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
     Canon1.FileNameProc.Extension := '.JPG';
     FileNameGenerate;
end;

procedure TForm1.SetComment(fn,s: string);
var fStream: TFileStream;
    access: boolean;
    ext: string;
    i: integer;
    ch: BYTE;
begin
  if FileExists(fn) then
  Try
  Try
    fStream:= TFileStream.Create(fn,fmOpenWrite);
    access := True;
  except
    access := False;
  end;
  if access then begin
    ext := UpperCase(ExtractFileExt(fn));
    fStream.Seek(0,2);
    ch := $FF; fStream.write(ch,1);
    for i:=1 to Length(s) do
        fStream.write(s[i],1);
    ch := Length(s);
        fStream.write(ch,1);
  end;
  finally
    fStream.Free;
  end;
end;

procedure TForm1.Canon1NewFile(Sender: TObject; SavedFile: string);
begin
  StatusBar1.Panels[1].Text := SavedFile;
end;

procedure TForm1.Edit1Exit(Sender: TObject);
begin
  canon1.FileName := Edit1.Text;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
var dir : string;
begin
     if SelectDirectory('Select photo directory :',
                             Dir, Dir) then
     begin
        canon1.FilePath := Dir;
        Edit2.Text := Dir;
     end;
end;

end.


