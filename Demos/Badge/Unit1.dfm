object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 547
  ClientWidth = 762
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 132
    Height = 25
    Caption = 'Demo Badge'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 39
    Width = 294
    Height = 18
    Caption = 'This app is created with D2Bridge Framework'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 65
    Width = 130
    Height = 14
    Caption = 'by Talis Jonatas  Gomes'
  end
  object Panel1: TPanel
    Left = 8
    Top = 97
    Width = 605
    Height = 104
    TabOrder = 0
    object Label_BadgeDynamic: TLabel
      Left = 16
      Top = 63
      Width = 87
      Height = 14
      Caption = 'Dynamic Badge '
      Color = clGreen
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label20: TLabel
      Left = 198
      Top = 63
      Width = 14
      Height = 14
      Caption = '01'
      Color = clGreen
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label21: TLabel
      Left = 302
      Top = 55
      Width = 4
      Height = 14
      Color = clGreen
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label22: TLabel
      Left = 388
      Top = 52
      Width = 22
      Height = 14
      Caption = '99+'
      Color = clGreen
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object RadioGroup1: TRadioGroup
      Left = 119
      Top = 8
      Width = 305
      Height = 41
      Caption = 'Dynamic Badge Color'
      Columns = 3
      ItemIndex = 0
      Items.Strings = (
        'Green'
        'Yellow'
        'Red')
      TabOrder = 0
      OnClick = RadioGroup1Click
    end
    object Button1: TButton
      Left = 16
      Top = 13
      Width = 97
      Height = 33
      Caption = 'Change Text'
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 119
      Top = 58
      Width = 75
      Height = 25
      Caption = 'Button Dyn'
      TabOrder = 2
    end
    object Button3: TButton
      Left = 231
      Top = 66
      Width = 75
      Height = 25
      Caption = 'Button Dyn'
      TabOrder = 3
    end
    object Button4: TButton
      Left = 335
      Top = 66
      Width = 75
      Height = 25
      Caption = 'Button Dyn'
      TabOrder = 4
    end
    object ComboBox1: TComboBox
      Left = 442
      Top = 23
      Width = 145
      Height = 22
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 5
      Text = 'Show Label Badge'
      OnChange = ComboBox1Change
      Items.Strings = (
        'Show Label Badge'
        'Hide Label Badge')
    end
  end
  object Panel2: TPanel
    Left = 8
    Top = 355
    Width = 737
    Height = 176
    TabOrder = 1
    object Label4: TLabel
      Left = 16
      Top = 16
      Width = 69
      Height = 14
      Caption = 'Static Badge'
    end
    object Label5: TLabel
      Left = 104
      Top = 16
      Width = 69
      Height = 14
      Caption = 'Static Badge'
    end
    object Label6: TLabel
      Left = 192
      Top = 16
      Width = 69
      Height = 14
      Caption = 'Static Badge'
    end
    object Label7: TLabel
      Left = 280
      Top = 16
      Width = 69
      Height = 14
      Caption = 'Static Badge'
    end
    object Label8: TLabel
      Left = 360
      Top = 16
      Width = 69
      Height = 14
      Caption = 'Static Badge'
    end
    object Label9: TLabel
      Left = 448
      Top = 16
      Width = 69
      Height = 14
      Caption = 'Static Badge'
    end
    object Label10: TLabel
      Left = 536
      Top = 16
      Width = 69
      Height = 14
      Caption = 'Static Badge'
    end
    object Label11: TLabel
      Left = 624
      Top = 16
      Width = 69
      Height = 14
      Caption = 'Static Badge'
    end
    object Label12: TLabel
      Left = 16
      Top = 48
      Width = 69
      Height = 14
      Caption = 'Static Badge'
    end
    object Label13: TLabel
      Left = 104
      Top = 48
      Width = 69
      Height = 14
      Caption = 'Static Badge'
    end
    object Label14: TLabel
      Left = 192
      Top = 48
      Width = 69
      Height = 14
      Caption = 'Static Badge'
    end
    object Label15: TLabel
      Left = 280
      Top = 48
      Width = 69
      Height = 14
      Caption = 'Static Badge'
    end
    object Label16: TLabel
      Left = 360
      Top = 48
      Width = 69
      Height = 14
      Caption = 'Static Badge'
    end
    object Label17: TLabel
      Left = 448
      Top = 48
      Width = 69
      Height = 14
      Caption = 'Static Badge'
    end
    object Label18: TLabel
      Left = 536
      Top = 48
      Width = 69
      Height = 14
      Caption = 'Static Badge'
    end
    object Label19: TLabel
      Left = 624
      Top = 48
      Width = 69
      Height = 14
      Caption = 'Static Badge'
    end
    object Label23: TLabel
      Left = 71
      Top = 88
      Width = 14
      Height = 14
      Caption = '01'
    end
    object Label24: TLabel
      Left = 159
      Top = 88
      Width = 14
      Height = 14
      Caption = '01'
    end
    object Label25: TLabel
      Left = 247
      Top = 88
      Width = 14
      Height = 14
      Caption = '01'
    end
    object Label26: TLabel
      Left = 335
      Top = 88
      Width = 14
      Height = 14
      Caption = '01'
    end
    object Label27: TLabel
      Left = 415
      Top = 88
      Width = 14
      Height = 14
      Caption = '01'
    end
    object Label28: TLabel
      Left = 503
      Top = 88
      Width = 14
      Height = 14
      Caption = '01'
    end
    object Label29: TLabel
      Left = 591
      Top = 88
      Width = 14
      Height = 14
      Caption = '01'
    end
    object Label30: TLabel
      Left = 679
      Top = 88
      Width = 14
      Height = 14
      Caption = '01'
    end
    object Label31: TLabel
      Left = 71
      Top = 119
      Width = 14
      Height = 14
      Caption = '01'
    end
    object Label32: TLabel
      Left = 159
      Top = 119
      Width = 14
      Height = 14
      Caption = '01'
    end
    object Label33: TLabel
      Left = 247
      Top = 119
      Width = 14
      Height = 14
      Caption = '01'
    end
    object Label34: TLabel
      Left = 335
      Top = 119
      Width = 14
      Height = 14
      Caption = '01'
    end
    object Label35: TLabel
      Left = 415
      Top = 119
      Width = 14
      Height = 14
      Caption = '01'
    end
    object Label36: TLabel
      Left = 503
      Top = 119
      Width = 14
      Height = 14
      Caption = '01'
    end
    object Label37: TLabel
      Left = 591
      Top = 119
      Width = 14
      Height = 14
      Caption = '01'
    end
    object Label38: TLabel
      Left = 679
      Top = 119
      Width = 14
      Height = 14
      Caption = '01'
    end
    object Label39: TLabel
      Left = 71
      Top = 150
      Width = 14
      Height = 14
      Caption = '01'
    end
    object Label40: TLabel
      Left = 159
      Top = 150
      Width = 14
      Height = 14
      Caption = '01'
    end
    object Label41: TLabel
      Left = 247
      Top = 150
      Width = 14
      Height = 14
      Caption = '01'
    end
    object Label42: TLabel
      Left = 335
      Top = 150
      Width = 14
      Height = 14
      Caption = '01'
    end
    object Label43: TLabel
      Left = 415
      Top = 150
      Width = 14
      Height = 14
      Caption = '01'
    end
    object Label44: TLabel
      Left = 503
      Top = 150
      Width = 14
      Height = 14
      Caption = '01'
    end
    object Label45: TLabel
      Left = 591
      Top = 150
      Width = 14
      Height = 14
      Caption = '01'
    end
    object Label46: TLabel
      Left = 679
      Top = 150
      Width = 14
      Height = 14
      Caption = '01'
    end
    object Button9: TButton
      Left = 16
      Top = 82
      Width = 51
      Height = 25
      Caption = 'Button'
      TabOrder = 0
    end
    object Button10: TButton
      Left = 104
      Top = 82
      Width = 51
      Height = 25
      Caption = 'Button'
      TabOrder = 1
    end
    object Button11: TButton
      Left = 192
      Top = 82
      Width = 51
      Height = 25
      Caption = 'Button'
      TabOrder = 2
    end
    object Button12: TButton
      Left = 280
      Top = 82
      Width = 51
      Height = 25
      Caption = 'Button'
      TabOrder = 3
    end
    object Button13: TButton
      Left = 360
      Top = 82
      Width = 51
      Height = 25
      Caption = 'Button'
      TabOrder = 4
    end
    object Button14: TButton
      Left = 448
      Top = 82
      Width = 51
      Height = 25
      Caption = 'Button'
      TabOrder = 5
    end
    object Button15: TButton
      Left = 536
      Top = 82
      Width = 51
      Height = 25
      Caption = 'Button'
      TabOrder = 6
    end
    object Button16: TButton
      Left = 624
      Top = 82
      Width = 51
      Height = 25
      Caption = 'Button'
      TabOrder = 7
    end
    object Button17: TButton
      Left = 16
      Top = 113
      Width = 51
      Height = 25
      Caption = 'Button'
      TabOrder = 8
    end
    object Button18: TButton
      Left = 104
      Top = 113
      Width = 51
      Height = 25
      Caption = 'Button'
      TabOrder = 9
    end
    object Button19: TButton
      Left = 192
      Top = 113
      Width = 51
      Height = 25
      Caption = 'Button'
      TabOrder = 10
    end
    object Button20: TButton
      Left = 280
      Top = 113
      Width = 51
      Height = 25
      Caption = 'Button'
      TabOrder = 11
    end
    object Button21: TButton
      Left = 360
      Top = 113
      Width = 51
      Height = 25
      Caption = 'Button'
      TabOrder = 12
    end
    object Button22: TButton
      Left = 448
      Top = 113
      Width = 51
      Height = 25
      Caption = 'Button'
      TabOrder = 13
    end
    object Button23: TButton
      Left = 536
      Top = 113
      Width = 51
      Height = 25
      Caption = 'Button'
      TabOrder = 14
    end
    object Button24: TButton
      Left = 624
      Top = 113
      Width = 51
      Height = 25
      Caption = 'Button'
      TabOrder = 15
    end
    object Button25: TButton
      Left = 16
      Top = 144
      Width = 51
      Height = 25
      Caption = 'Button'
      TabOrder = 16
    end
    object Button26: TButton
      Left = 104
      Top = 144
      Width = 51
      Height = 25
      Caption = 'Button'
      TabOrder = 17
    end
    object Button27: TButton
      Left = 192
      Top = 144
      Width = 51
      Height = 25
      Caption = 'Button'
      TabOrder = 18
    end
    object Button28: TButton
      Left = 280
      Top = 144
      Width = 51
      Height = 25
      Caption = 'Button'
      TabOrder = 19
    end
    object Button29: TButton
      Left = 360
      Top = 144
      Width = 51
      Height = 25
      Caption = 'Button'
      TabOrder = 20
    end
    object Button30: TButton
      Left = 448
      Top = 144
      Width = 51
      Height = 25
      Caption = 'Button'
      TabOrder = 21
    end
    object Button31: TButton
      Left = 536
      Top = 144
      Width = 51
      Height = 25
      Caption = 'Button'
      TabOrder = 22
    end
    object Button32: TButton
      Left = 624
      Top = 144
      Width = 51
      Height = 25
      Caption = 'Button'
      TabOrder = 23
    end
  end
  object Panel3: TPanel
    Left = 8
    Top = 223
    Width = 705
    Height = 114
    TabOrder = 2
    object DBText1: TDBText
      Left = 16
      Top = 35
      Width = 97
      Height = 17
      DataField = 'Country'
      DataSource = DSCountry
    end
    object DBText2: TDBText
      Left = 134
      Top = 35
      Width = 97
      Height = 17
      DataField = 'Country'
      DataSource = DSCountry
    end
    object DBText3: TDBText
      Left = 252
      Top = 35
      Width = 97
      Height = 17
      DataField = 'Country'
      DataSource = DSCountry
    end
    object DBText4: TDBText
      Left = 95
      Top = 78
      Width = 22
      Height = 17
      DataField = 'AutoCod'
      DataSource = DSCountry
    end
    object DBText5: TDBText
      Left = 211
      Top = 58
      Width = 22
      Height = 17
      DataField = 'DDI'
      DataSource = DSCountry
    end
    object Button5: TButton
      Left = 12
      Top = 4
      Width = 55
      Height = 25
      Caption = 'Prior'
      TabOrder = 0
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 73
      Top = 4
      Width = 55
      Height = 25
      Caption = 'Next'
      TabOrder = 1
      OnClick = Button6Click
    end
    object Button7: TButton
      Left = 14
      Top = 74
      Width = 75
      Height = 25
      Caption = 'Button Id'
      TabOrder = 2
    end
    object Button8: TButton
      Left = 158
      Top = 74
      Width = 75
      Height = 25
      Caption = 'Button DDI'
      TabOrder = 3
    end
  end
  object ClientDataSet_Country: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 559
    Top = 24
    object ClientDataSet_CountryAutoCod: TAutoIncField
      FieldName = 'AutoCod'
    end
    object ClientDataSet_CountryCountry: TStringField
      FieldName = 'Country'
      Size = 100
    end
    object ClientDataSet_CountryDDI: TStringField
      FieldName = 'DDI'
    end
    object ClientDataSet_CountryPopulation: TIntegerField
      FieldName = 'Population'
    end
  end
  object DSCountry: TDataSource
    DataSet = ClientDataSet_Country
    Left = 448
    Top = 24
  end
end
