object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Canon EOS 2000D Vez'#258#169'rl'#313#8216
  ClientHeight = 360
  ClientWidth = 663
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 152
    Top = 10
    Width = 497
    Height = 331
    Stretch = True
  end
  object BtnConnect: TButton
    Left = 14
    Top = 13
    Width = 120
    Height = 40
    Caption = 'Connect'
    TabOrder = 0
    OnClick = BtnConnectClick
  end
  object BtnCapture: TButton
    Left = 14
    Top = 59
    Width = 120
    Height = 40
    Caption = 'Expon'#225'l'#225's'
    Enabled = False
    TabOrder = 1
    OnClick = BtnCaptureClick
  end
  object btnLiveview: TButton
    Left = 19
    Top = 282
    Width = 115
    Height = 45
    Caption = 'Liveview'
    TabOrder = 2
    OnClick = btnLiveviewClick
  end
  object ChkSaveToFile: TCheckBox
    Left = 23
    Top = 116
    Width = 97
    Height = 17
    Caption = 'Ment'#233's Fileba'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object EvfTimer: TTimer
    OnTimer = EvfTimerTimer
    Left = 48
    Top = 174
  end
end
