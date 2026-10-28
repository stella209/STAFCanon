program StafCanonTeszt;

uses
  Vcl.Forms,
  UFormMain in 'UFormMain.pas' {FormMain},
  UFormLiveview in 'UFormLiveview.pas' {FormLiveView};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormLiveView, FormLiveView);
  Application.Run;
end.
