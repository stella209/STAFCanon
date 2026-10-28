object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Canon EOS test'
  ClientHeight = 481
  ClientWidth = 894
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 13
    Top = 178
    Width = 249
    Height = 243
  end
  object Label1: TLabel
    Left = 33
    Top = 8
    Width = 228
    Height = 13
    Hint = 'Camera name'
    Alignment = taCenter
    AutoSize = False
    Color = clGray
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 197
    Width = 18
    Height = 13
    Caption = 'ISO'
  end
  object Shape1: TShape
    Left = 8
    Top = 5
    Width = 16
    Height = 17
    Shape = stCircle
  end
  object Label4: TLabel
    Left = 16
    Top = 224
    Width = 12
    Height = 13
    Caption = 'Tv'
  end
  object Label6: TLabel
    Left = 100
    Top = 82
    Width = 36
    Height = 13
    Caption = 'Owner:'
  end
  object Label7: TLabel
    Left = 140
    Top = 82
    Width = 105
    Height = 13
    Alignment = taCenter
    AutoSize = False
  end
  object Label5: TLabel
    Left = 25
    Top = 398
    Width = 36
    Height = 13
    Caption = 'Battery'
  end
  object Label12: TLabel
    Left = 140
    Top = 219
    Width = 16
    Height = 13
    Caption = 'WB'
  end
  object Label13: TLabel
    Left = 124
    Top = 196
    Width = 34
    Height = 13
    Caption = 'Quality'
  end
  object Label15: TLabel
    Left = 296
    Top = 90
    Width = 37
    Height = 13
    Caption = 'Label15'
  end
  object Label16: TLabel
    Left = 9
    Top = 438
    Width = 47
    Height = 13
    Caption = 'Download'
  end
  object Label3: TLabel
    Left = 19
    Top = 135
    Width = 81
    Height = 13
    Caption = 'Filename prefix>'
  end
  object Gauge1: TGauge
    Left = 65
    Top = 431
    Width = 196
    Height = 25
    ForeColor = clNavy
    Progress = 0
  end
  object Label8: TLabel
    Left = 19
    Top = 110
    Width = 83
    Height = 13
    Caption = 'Image directory :'
  end
  object SpeedButton1: TSpeedButton
    Left = 244
    Top = 106
    Width = 23
    Height = 22
    Caption = '...'
    OnClick = SpeedButton1Click
  end
  object Label9: TLabel
    Left = 76
    Top = 159
    Width = 69
    Height = 13
    Caption = 'Camera Time: '
  end
  object Label10: TLabel
    Left = 151
    Top = 161
    Width = 21
    Height = 13
    Caption = '000'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label11: TLabel
    Left = 19
    Top = 284
    Width = 53
    Height = 13
    Caption = 'FILENAME:'
  end
  object Label17: TLabel
    Left = 277
    Top = 253
    Width = 33
    Height = 13
    Caption = 'Count:'
  end
  object Label20: TLabel
    Left = 22
    Top = 159
    Width = 13
    Height = 13
    Caption = 'AE'
  end
  object lbAE: TLabel
    Left = 41
    Top = 154
    Width = 14
    Height = 19
    Caption = 'M'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label21: TLabel
    Left = 102
    Top = 253
    Width = 49
    Height = 13
    Caption = 'EXP. TIME'
  end
  object Label22: TLabel
    Left = 207
    Top = 253
    Width = 23
    Height = 13
    Caption = 'SEC,'
  end
  object ComboBox1: TComboBox
    Left = 40
    Top = 192
    Width = 73
    Height = 21
    TabOrder = 0
    OnChange = ComboBox1Change
  end
  object Button1: TButton
    Left = 298
    Top = 1
    Width = 75
    Height = 25
    Caption = 'Connect'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 298
    Top = 137
    Width = 75
    Height = 46
    Caption = 'Photo'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 296
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Disconnect'
    TabOrder = 3
    OnClick = Button3Click
  end
  object ComboBox2: TComboBox
    Left = 40
    Top = 216
    Width = 73
    Height = 21
    TabOrder = 4
    OnChange = ComboBox2Change
  end
  object ProgressBar1: TProgressBar
    Left = 65
    Top = 398
    Width = 150
    Height = 17
    TabOrder = 5
  end
  object ComboBox3: TComboBox
    Left = 168
    Top = 216
    Width = 73
    Height = 21
    TabOrder = 6
    OnChange = ComboBox3Change
  end
  object ComboBox4: TComboBox
    Left = 168
    Top = 192
    Width = 73
    Height = 21
    TabOrder = 7
    OnChange = ComboBox4Change
  end
  object Button7: TButton
    Left = 296
    Top = 59
    Width = 75
    Height = 25
    Caption = 'GetTime'
    TabOrder = 8
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 296
    Top = 109
    Width = 75
    Height = 25
    Caption = 'SetTime now'
    TabOrder = 9
    OnClick = Button8Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 462
    Width = 894
    Height = 19
    Panels = <
      item
        Width = 50
      end
      item
        Text = 'Picture file name'
        Width = 50
      end>
  end
  object Edit1: TEdit
    Left = 115
    Top = 132
    Width = 126
    Height = 21
    TabOrder = 11
    Text = 'Canon'
    OnExit = Edit1Exit
  end
  object Edit2: TEdit
    Left = 116
    Top = 106
    Width = 123
    Height = 21
    TabOrder = 12
    Text = 'Edit2'
  end
  object CheckBox1: TCheckBox
    Left = 41
    Top = 303
    Width = 80
    Height = 17
    Caption = 'Date'
    Checked = True
    State = cbChecked
    TabOrder = 13
    OnClick = CheckBox1Click
  end
  object CheckBox2: TCheckBox
    Left = 42
    Top = 324
    Width = 97
    Height = 17
    Caption = 'Julian Date'
    TabOrder = 14
    OnClick = CheckBox1Click
  end
  object CheckBox3: TCheckBox
    Left = 42
    Top = 347
    Width = 75
    Height = 17
    Caption = 'User Tag :'
    TabOrder = 15
    OnClick = CheckBox1Click
  end
  object CheckBox4: TCheckBox
    Left = 142
    Top = 301
    Width = 53
    Height = 17
    Caption = 'Time'
    Checked = True
    State = cbChecked
    TabOrder = 16
    OnClick = CheckBox1Click
  end
  object edUserTag: TEdit
    Left = 140
    Top = 345
    Width = 105
    Height = 21
    TabOrder = 17
    Text = 'Stella'
  end
  object cbSeries: TCheckBox
    Left = 274
    Top = 229
    Width = 97
    Height = 17
    Caption = 'SERIES'
    TabOrder = 18
  end
  object spCount: TSpinEdit
    Left = 316
    Top = 248
    Width = 55
    Height = 22
    MaxValue = 100000
    MinValue = 1
    TabOrder = 19
    Value = 1
  end
  object btnSTART: TButton
    Left = 282
    Top = 365
    Width = 95
    Height = 25
    Caption = 'SERIES START'
    TabOrder = 20
    OnClick = btnSTARTClick
  end
  object Panel1: TPanel
    Left = 268
    Top = 272
    Width = 113
    Height = 89
    Enabled = False
    TabOrder = 21
    object Label14: TLabel
      Left = 8
      Top = 44
      Width = 22
      Height = 13
      Caption = 'Exp.'
    end
    object Label18: TLabel
      Left = 8
      Top = 69
      Width = 31
      Height = 13
      Caption = 'Delay:'
    end
    object Label19: TLabel
      Left = 10
      Top = 22
      Width = 27
      Height = 13
      Caption = 'COM:'
    end
    object CheckBox6: TCheckBox
      Left = 8
      Top = 0
      Width = 97
      Height = 17
      Caption = 'BULB Cabel'
      TabOrder = 0
    end
    object cbExpTime: TComboBox
      Left = 63
      Top = 41
      Width = 40
      Height = 21
      TabOrder = 1
      Text = '60'
      Items.Strings = (
        '10'
        '20'
        '30'
        '60'
        '90'
        '120'
        '180'
        '240'
        '300')
    end
    object ComboBox6: TComboBox
      Left = 62
      Top = 19
      Width = 41
      Height = 21
      TabOrder = 2
      Text = '5'
    end
    object edDelay: TEdit
      Left = 64
      Top = 64
      Width = 41
      Height = 21
      TabOrder = 3
      Text = '10'
    end
  end
  object ListBox1: TListBox
    Left = 97
    Top = 27
    Width = 164
    Height = 50
    ItemHeight = 13
    TabOrder = 22
    OnClick = ListBox1Click
  end
  object Button4: TButton
    Left = 16
    Top = 28
    Width = 75
    Height = 45
    Caption = 'SCAN'
    TabOrder = 23
    OnClick = Button4Click
  end
  object Panel2: TPanel
    Left = 397
    Top = 0
    Width = 497
    Height = 462
    Align = alRight
    TabOrder = 24
    object ALZ: TALZoomImage
      Left = 1
      Top = 42
      Width = 495
      Height = 419
      Align = alClient
      ClipBoardAction = cbaTotal
      BackColor = clSilver
      BackCross = False
      Centered = False
      CentralCross = True
      CircleWindow = False
      CursorCross = False
      EnableFocus = True
      EnableSelect = True
      EnableActions = True
      Fitting = False
      Grid.Fix = False
      Grid.GridDistance = 100.000000000000000000
      Grid.GridPen.Color = clGray
      Grid.SubGridPen.Color = 6250335
      Grid.SubGridDistance = 10.000000000000000000
      Grid.PixelGrid = False
      Grid.Scale = False
      Grid.ScaleFont.Charset = DEFAULT_CHARSET
      Grid.ScaleFont.Color = clWhite
      Grid.ScaleFont.Height = -11
      Grid.ScaleFont.Name = 'Arial'
      Grid.ScaleFont.Style = []
      Grid.ScaleBrush.Color = clGray
      Grid.Visible = False
      OverMove = False
      RGBList.MonoRGB = False
      RGBList.RGB = True
      TabStop = True
      Zoom = 1.000000000000000000
    end
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 495
      Height = 41
      Align = alTop
      TabOrder = 1
    end
  end
  object Button5: TButton
    Left = 267
    Top = 396
    Width = 113
    Height = 60
    Caption = 'LIVE VIEW'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 25
    OnClick = Button5Click
  end
  object ComboBox5: TComboBox
    Left = 298
    Top = 189
    Width = 75
    Height = 21
    ItemIndex = 0
    TabOrder = 26
    Text = 'toFileto'
    OnClick = ComboBox5Click
    Items.Strings = (
      'toFileto'
      'toMemory')
  end
  object ComboBox7: TComboBox
    Left = 157
    Top = 250
    Width = 44
    Height = 21
    AutoDropDown = True
    TabOrder = 27
    Text = '30'
    Items.Strings = (
      '30'
      '60'
      '80'
      '120'
      '150'
      '160'
      '240'
      '300')
  end
  object Button6: TButton
    Left = 42
    Top = 246
    Width = 49
    Height = 25
    Caption = 'BULB'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 28
    OnClick = Button6Click
  end
  object CheckBox5: TCheckBox
    Left = 142
    Top = 324
    Width = 97
    Height = 17
    Caption = 'UT'
    TabOrder = 29
    OnClick = CheckBox1Click
  end
  object ApplicationEvents1: TApplicationEvents
    OnMessage = ApplicationEvents1Message
    Left = 450
    Top = 130
  end
end
