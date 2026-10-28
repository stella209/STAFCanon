object FormLiveView: TFormLiveView
  Left = 0
  Top = 0
  Caption = 'LiveView Stream'
  ClientHeight = 481
  ClientWidth = 654
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object ImgLiveStream: TImage
    Left = 8
    Top = 8
    Width = 640
    Height = 420
    Proportional = True
  end
  object BtnToggleLive: TButton
    Left = 240
    Top = 440
    Width = 180
    Height = 33
    Caption = 'LiveView Le'#258#711'll'#258#711's'
    TabOrder = 0
    OnClick = BtnToggleLiveClick
  end
end
