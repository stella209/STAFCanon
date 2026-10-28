unit UFormLiveView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, 
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  STAFCanon;

type
  TFormLiveView = class(TForm)
    ImgLiveStream: TImage;
    BtnToggleLive: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnToggleLiveClick(Sender: TObject);
  private
    procedure OnLiveViewFrameReceived(Sender: TObject; ABitmap: TBitmap);
  end;

var
  FormLiveView: TFormLiveView;

implementation

uses UFormMain;

{$R *.dfm}

procedure TFormLiveView.FormShow(Sender: TObject);
begin
  DoubleBuffered := True;
  if FormMain.Canon.IsConnected then
  begin
    FormMain.Canon.OnLiveViewFrame := OnLiveViewFrameReceived;
    FormMain.Canon.StartLiveView;
    BtnToggleLive.Caption := 'LiveView Leállítás';
  end;
end;

procedure TFormLiveView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FormMain.Canon.IsLiveViewActive then
    FormMain.Canon.StopLiveView;
    
  FormMain.Canon.OnLiveViewFrame := nil;
  Action := caFree;
  FormLiveView := nil;
end;

procedure TFormLiveView.BtnToggleLiveClick(Sender: TObject);
begin
  if FormMain.Canon.IsLiveViewActive then
  begin
    FormMain.Canon.StopLiveView;
    BtnToggleLive.Caption := 'LiveView Indítás';
  end
  else
  begin
    FormMain.Canon.StartLiveView;
    BtnToggleLive.Caption := 'LiveView Leállítás';
  end;
end;

procedure TFormLiveView.OnLiveViewFrameReceived(Sender: TObject; ABitmap: TBitmap);
begin
  ImgLiveStream.Picture.Assign(ABitmap);
end;

end.