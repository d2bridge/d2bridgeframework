object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 613
  ClientWidth = 864
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 254
    Height = 25
    Caption = 'InfoPower Components '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 69
    Width = 54
    Height = 13
    Caption = 'wwDBEdit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 16
    Top = 173
    Width = 93
    Height = 13
    Caption = 'wwDBComboBox'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 16
    Top = 213
    Width = 113
    Height = 13
    Caption = 'wwDBLookupCombo'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 16
    Top = 253
    Width = 90
    Height = 13
    Caption = 'wwDBComboDlg'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 16
    Top = 297
    Width = 131
    Height = 13
    Caption = 'wwDBLookupComboDlg'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 16
    Top = 339
    Width = 78
    Height = 13
    Caption = 'wwDBRichEdit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label8: TLabel
    Left = 424
    Top = 93
    Width = 123
    Height = 13
    Caption = 'wwDBDateTimePicker'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label9: TLabel
    Left = 432
    Top = 213
    Width = 127
    Height = 13
    Caption = 'wwIncrementalSearch'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label10: TLabel
    Left = 432
    Top = 258
    Width = 81
    Height = 13
    Caption = 'wwDBSpinEdit '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label11: TLabel
    Left = 16
    Top = 447
    Width = 128
    Height = 13
    Caption = 'Update Button Caption'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object wwDBEdit1: TwwDBEdit
    Left = 16
    Top = 88
    Width = 201
    Height = 21
    DataField = 'name'
    DataSource = DataSource1
    TabOrder = 0
    UnboundDataType = wwDefault
    WantReturns = False
    WordWrap = False
  end
  object wwDBGrid1: TwwDBGrid
    Left = 432
    Top = 321
    Width = 320
    Height = 120
    Selected.Strings = (
      'id'#9'10'#9'id'#9'F'#9
      'name'#9'50'#9'name'#9'F'#9
      'lastname'#9'50'#9'lastname'#9'F'#9
      'birthday'#9'20'#9'birthday'#9'F'#9
      'phone'#9'25'#9'phone'#9'F'#9
      'number'#9'10'#9'number'#9'F'#9
      'animalprefer'#9'50'#9'animal'#9'F'#9
      'carprefer'#9'50'#9'car'#9'F'#9
      'information'#9'50'#9'information'#9'F'#9)
    IniAttributes.Delimiter = ';;'
    IniAttributes.UnicodeIniFile = False
    TitleColor = clBtnFace
    FixedCols = 0
    ShowHorzScrollBar = True
    DataSource = DataSource1
    TabOrder = 1
    TitleAlignment = taLeftJustify
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    TitleLines = 1
    TitleButtons = False
  end
  object wwButton1: TwwButton
    Left = 16
    Top = 139
    Width = 137
    Height = 25
    Caption = 'wwButton1'
    Color = clGray
    DataSource = DataSource1
    DataField = 'id'
    DitherColor = clWhite
    DitherStyle = wwdsDither
    ShadeStyle = wwbsNormal
    TabOrder = 2
    TextOptions.Alignment = taCenter
    TextOptions.VAlignment = vaVCenter
    OnClick = wwButton1Click
    ImageIndex = -1
  end
  object wwDBComboBox1: TwwDBComboBox
    Left = 16
    Top = 192
    Width = 201
    Height = 21
    ShowButton = True
    Style = csDropDown
    MapList = False
    AllowClearKey = False
    DataField = 'lastname'
    DataSource = DataSource1
    DropDownCount = 8
    ItemHeight = 0
    Items.Strings = (
      'Robison'
      'Astely'
      'Marcondes')
    Sorted = False
    TabOrder = 3
    UnboundDataType = wwDefault
  end
  object wwDBLookupCombo1: TwwDBLookupCombo
    Left = 16
    Top = 232
    Width = 201
    Height = 21
    DropDownAlignment = taLeftJustify
    Selected.Strings = (
      'name'#9'100'#9'name'#9'F')
    DataField = 'animalprefer'
    DataSource = DataSource1
    LookupTable = ClientDataSet2
    LookupField = 'animal'
    TabOrder = 4
    AutoDropDown = False
    ShowButton = True
    UseTFields = False
    PreciseEditRegion = False
    AllowClearKey = False
  end
  object wwDBComboDlg1: TwwDBComboDlg
    Left = 16
    Top = 272
    Width = 201
    Height = 21
    ShowButton = True
    Style = csDropDown
    DataField = 'phone'
    DataSource = DataSource1
    TabOrder = 5
    WordWrap = False
    UnboundDataType = wwDefault
  end
  object wwDBLookupComboDlg1: TwwDBLookupComboDlg
    Left = 16
    Top = 312
    Width = 201
    Height = 21
    GridOptions = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgPerfectRowFit]
    GridColor = clWhite
    GridTitleAlignment = taLeftJustify
    Caption = 'Lookup'
    MaxWidth = 0
    MaxHeight = 372
    Selected.Strings = (
      'Nome'#9'50'#9'Nome da Pess'#245'a'#9'F'
      'Numero'#9'10'#9'Numero da Pessoa'#9'F'
      'Sobrenome'#9'50'#9'Sobren'#244'me da Pessoa'#9'F')
    DataField = 'carprefer'
    DataSource = DataSource1
    LookupTable = ClientDataSet3
    LookupField = 'car'
    TabOrder = 6
    AutoDropDown = False
    ShowButton = True
    AllowClearKey = False
  end
  object wwDBRichEdit1: TwwDBRichEdit
    Left = 16
    Top = 352
    Width = 185
    Height = 89
    AutoURLDetect = False
    DataField = 'information'
    DataSource = DataSource1
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    GutterWidth = 3
    HideSelection = False
    ParentFont = False
    Title = 'Teste'
    PrintJobName = 'D2B_InfoPower - Delphi 10.4 - Unit1 [Built]'
    TabOrder = 7
    EditorOptions = [reoShowSaveExit, reoShowPrint, reoShowPrintPreview, reoShowPageSetup, reoShowFormatBar, reoShowToolBar, reoShowStatusBar, reoShowHints, reoShowRuler, reoShowInsertObject, reoCloseOnEscape, reoFlatButtons, reoShowSpellCheck, reoShowMainMenuIcons, reoShowZoomCombo]
    EditorCaption = 'Edit Rich Text'
    EditorPosition.Left = 0
    EditorPosition.Top = 0
    EditorPosition.Width = 0
    EditorPosition.Height = 0
    MeasurementUnits = muInches
    PrintMargins.Top = 1.000000000000000000
    PrintMargins.Bottom = 1.000000000000000000
    PrintMargins.Left = 1.000000000000000000
    PrintMargins.Right = 1.000000000000000000
    PrintHeader.VertMargin = 0.500000000000000000
    PrintHeader.Font.Charset = DEFAULT_CHARSET
    PrintHeader.Font.Color = clWindowText
    PrintHeader.Font.Height = -11
    PrintHeader.Font.Name = 'Tahoma'
    PrintHeader.Font.Style = []
    PrintFooter.VertMargin = 0.500000000000000000
    PrintFooter.Font.Charset = DEFAULT_CHARSET
    PrintFooter.Font.Color = clWindowText
    PrintFooter.Font.Height = -11
    PrintFooter.Font.Name = 'Tahoma'
    PrintFooter.Font.Style = []
    DoubleBuffered = False
    ParentDoubleBuffered = False
    RichEditVersion = 2
    Data = {
      760000007B5C727466315C616E73695C616E7369637067313235325C64656666
      305C6465666C616E67313034367B5C666F6E7474626C7B5C66305C666E696C5C
      666368617273657430205461686F6D613B7D7D0D0A5C766965776B696E64345C
      7563315C706172645C66305C667331365C7061720D0A7D0D0A00}
  end
  object wwDBDateTimePicker1: TwwDBDateTimePicker
    Left = 424
    Top = 112
    Width = 169
    Height = 21
    CalendarAttributes.Font.Charset = DEFAULT_CHARSET
    CalendarAttributes.Font.Color = clWindowText
    CalendarAttributes.Font.Height = -11
    CalendarAttributes.Font.Name = 'Tahoma'
    CalendarAttributes.Font.Style = []
    DataField = 'birthday'
    DataSource = DataSource1
    Epoch = 1950
    ShowButton = True
    TabOrder = 8
  end
  object wwCheckBox1: TwwCheckBox
    Left = 424
    Top = 154
    Width = 97
    Height = 17
    DisableThemes = False
    AlwaysTransparent = False
    ValueChecked = 'True'
    ValueUnchecked = 'False'
    DisplayValueChecked = 'True'
    DisplayValueUnchecked = 'False'
    NullAndBlankState = cbUnchecked
    Caption = 'wwCheckBox1'
    TabOrder = 9
  end
  object wwRadioButton1: TwwRadioButton
    Left = 552
    Top = 154
    Width = 113
    Height = 17
    Caption = 'wwRadioButton1'
    TabOrder = 10
    AlwaysTransparent = False
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object wwIncrementalSearch1: TwwIncrementalSearch
    Left = 432
    Top = 232
    Width = 193
    Height = 21
    DataSource = DataSource2
    SearchField = 'animal'
    TabOrder = 11
  end
  object wwDBSpinEdit1: TwwDBSpinEdit
    Left = 432
    Top = 272
    Width = 193
    Height = 21
    Increment = 1.000000000000000000
    DataField = 'number'
    DataSource = DataSource1
    TabOrder = 12
    UnboundDataType = wwDefault
  end
  object wwButton2: TwwButton
    Left = 159
    Top = 139
    Width = 137
    Height = 25
    Caption = 'Save'
    Color = clGreen
    DitherColor = clWhite
    DitherStyle = wwdsDither
    ShadeStyle = wwbsNormal
    TabOrder = 13
    TextOptions.Alignment = taCenter
    TextOptions.VAlignment = vaVCenter
    OnClick = wwButton2Click
    ImageIndex = -1
  end
  object wwButton3: TwwButton
    Left = 223
    Top = 81
    Width = 73
    Height = 25
    Caption = 'Search'
    Color = clBlue
    DitherColor = clWhite
    DitherStyle = wwdsDither
    ShadeStyle = wwbsNormal
    TabOrder = 14
    TextOptions.Alignment = taCenter
    TextOptions.VAlignment = vaVCenter
    OnClick = wwButton3Click
    ImageIndex = -1
  end
  object wwButton4: TwwButton
    Left = 16
    Top = 490
    Width = 137
    Height = 25
    Caption = 'Update Caption'
    Color = clGray
    DitherColor = clWhite
    DitherStyle = wwdsDither
    ShadeStyle = wwbsNormal
    TabOrder = 15
    TextOptions.Alignment = taCenter
    TextOptions.VAlignment = vaVCenter
    ImageIndex = -1
  end
  object wwDBEdit2: TwwDBEdit
    Left = 16
    Top = 463
    Width = 201
    Height = 21
    DataField = 'name'
    DataSource = DataSource1
    TabOrder = 16
    UnboundDataType = wwDefault
    WantReturns = False
    WordWrap = False
    OnChange = wwDBEdit2Change
  end
  object wwRadioGroup1: TwwRadioGroup
    Left = 440
    Top = 456
    Width = 107
    Height = 105
    DisableThemes = False
    Caption = 'Items by String'
    DataSource = DataSource1
    Items.Strings = (
      'Item 1'
      'Item 2'
      'Item 3')
    TabOrder = 17
  end
  object wwRadioGroup2: TwwRadioGroup
    Left = 558
    Top = 456
    Width = 107
    Height = 105
    DisableThemes = False
    Caption = 'Items by DataSource'
    DataField = 'car'
    DataSource = DataSource4
    Items.Strings = (
      'Saveiro'
      'Monster-Truck'
      'Onix')
    TabOrder = 18
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 768
    Top = 24
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 768
    Top = 80
    object ClientDataSet1id: TIntegerField
      DisplayWidth = 10
      FieldName = 'id'
    end
    object ClientDataSet1name: TStringField
      DisplayWidth = 50
      FieldName = 'name'
      Size = 50
    end
    object ClientDataSet1lastname: TStringField
      DisplayWidth = 50
      FieldName = 'lastname'
      Size = 50
    end
    object ClientDataSet1birthday: TDateField
      DisplayWidth = 20
      FieldName = 'birthday'
    end
    object ClientDataSet1phone: TStringField
      DisplayWidth = 25
      FieldName = 'phone'
      Size = 25
    end
    object ClientDataSet1number: TIntegerField
      DisplayWidth = 10
      FieldName = 'number'
    end
    object ClientDataSet1animalprefer: TStringField
      DisplayLabel = 'animal'
      DisplayWidth = 50
      FieldName = 'animalprefer'
      Size = 100
    end
    object ClientDataSet1carprefer: TStringField
      DisplayLabel = 'car'
      DisplayWidth = 50
      FieldName = 'carprefer'
      Size = 100
    end
    object ClientDataSet1information: TStringField
      DisplayWidth = 50
      FieldName = 'information'
      Size = 100
    end
  end
  object ClientDataSet2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 768
    Top = 152
    object ClientDataSet2animal: TStringField
      FieldName = 'animal'
      Size = 30
    end
    object ClientDataSet2species: TStringField
      FieldName = 'species'
    end
    object ClientDataSet2size: TIntegerField
      FieldName = 'size'
    end
  end
  object DataSource2: TDataSource
    DataSet = ClientDataSet2
    Left = 768
    Top = 208
  end
  object ClientDataSet3: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 768
    Top = 264
    object ClientDataSet3car: TStringField
      FieldName = 'car'
    end
    object ClientDataSet3version: TIntegerField
      FieldName = 'version'
    end
    object ClientDataSet3manufacturingdate: TDateField
      FieldName = 'manufacturingdate'
    end
  end
  object DataSource3: TDataSource
    DataSet = ClientDataSet3
    Left = 768
    Top = 320
  end
  object ClientDataSet4: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 776
    Top = 392
    object StringField1: TStringField
      FieldName = 'car'
    end
  end
  object DataSource4: TDataSource
    DataSet = ClientDataSet4
    Left = 776
    Top = 448
  end
end
