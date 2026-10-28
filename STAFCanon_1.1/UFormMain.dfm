object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'STAF Canon SDK Test Bench'
  ClientHeight = 568
  ClientWidth = 646
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 15
  object Label2: TLabel
    Left = 15
    Top = 152
    Width = 18
    Height = 15
    Caption = 'ISO'
  end
  object Label4: TLabel
    Left = 15
    Top = 179
    Width = 11
    Height = 15
    Caption = 'Tv'
  end
  object Label12: TLabel
    Left = 105
    Top = 176
    Width = 18
    Height = 15
    Caption = 'WB'
  end
  object Label13: TLabel
    Left = 93
    Top = 150
    Width = 38
    Height = 15
    Caption = 'Quality'
  end
  object Label6: TLabel
    Left = 24
    Top = 73
    Width = 38
    Height = 15
    Caption = 'Owner:'
  end
  object Label7: TLabel
    Left = 74
    Top = 73
    Width = 110
    Height = 15
    Alignment = taCenter
    AutoSize = False
  end
  object lbAE: TLabel
    Left = 16
    Top = 120
    Width = 4
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object SpeedButton1: TSpeedButton
    Left = 158
    Top = 100
    Width = 23
    Height = 22
  end
  object Label3: TLabel
    Left = 16
    Top = 401
    Width = 37
    Height = 15
    Caption = 'Bettery'
  end
  object BtnConnect: TButton
    Left = 16
    Top = 32
    Width = 77
    Height = 35
    Caption = 'Connect'
    TabOrder = 0
    OnClick = BtnConnectClick
  end
  object BtnDisconnect: TButton
    Left = 99
    Top = 32
    Width = 85
    Height = 35
    Caption = 'Disconnect'
    TabOrder = 1
    OnClick = BtnDisconnectClick
  end
  object BtnCapture: TButton
    Left = 16
    Top = 204
    Width = 177
    Height = 35
    Caption = 'Exp (Normal)'
    TabOrder = 2
    OnClick = BtnCaptureClick
  end
  object BtnBulbStart: TButton
    Left = 16
    Top = 254
    Width = 97
    Height = 35
    Caption = 'BULB Start (10s)'
    TabOrder = 3
    OnClick = BtnBulbStartClick
  end
  object BtnBulbStop: TButton
    Left = 119
    Top = 254
    Width = 74
    Height = 35
    Caption = 'BULB End'
    TabOrder = 4
    OnClick = BtnBulbStopClick
  end
  object BtnOpenLiveView: TButton
    Left = 16
    Top = 326
    Width = 177
    Height = 35
    Caption = 'LiveView'
    TabOrder = 5
    OnClick = BtnOpenLiveViewClick
  end
  object MemoLog: TMemo
    Left = 0
    Top = 439
    Width = 646
    Height = 110
    Align = alBottom
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 6
  end
  object CheckBox1: TCheckBox
    Left = 64
    Top = 298
    Width = 97
    Height = 17
    Caption = 'Save To File'
    TabOrder = 7
    OnClick = CheckBox1Click
  end
  object ComboBox1: TComboBox
    Left = 39
    Top = 147
    Width = 49
    Height = 23
    TabOrder = 8
    OnChange = ComboBox1Change
  end
  object ComboBox2: TComboBox
    Left = 39
    Top = 176
    Width = 49
    Height = 23
    TabOrder = 9
    OnChange = ComboBox2Change
  end
  object ComboBox3: TComboBox
    Left = 130
    Top = 173
    Width = 63
    Height = 23
    TabOrder = 10
    OnChange = ComboBox3Change
  end
  object ComboBox4: TComboBox
    Left = 130
    Top = 147
    Width = 63
    Height = 23
    TabOrder = 11
    OnChange = ComboBox4Change
  end
  object Panel1: TPanel
    Left = 216
    Top = 0
    Width = 430
    Height = 439
    Align = alRight
    TabOrder = 12
    object Image1: TImage
      Left = 1
      Top = 1
      Width = 428
      Height = 437
      Align = alClient
      Center = True
      Proportional = True
      Stretch = True
      ExplicitLeft = 0
      ExplicitTop = 2
    end
  end
  object cbCameralist: TComboBox
    Left = 50
    Top = 4
    Width = 134
    Height = 23
    TabOrder = 13
  end
  object Button1: TButton
    Left = 14
    Top = 3
    Width = 36
    Height = 25
    Caption = 'Scan'
    TabOrder = 14
    OnClick = Button1Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 549
    Width = 646
    Height = 19
    Panels = <
      item
        Width = 200
      end
      item
        Width = 50
      end>
  end
  object ProgressBar1: TProgressBar
    Left = 16
    Top = 422
    Width = 175
    Height = 11
    TabOrder = 16
  end
  object ProgressBar2: TProgressBar
    Left = 14
    Top = 378
    Width = 177
    Height = 11
    TabOrder = 17
  end
end
