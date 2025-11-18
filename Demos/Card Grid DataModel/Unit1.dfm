object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 546
  ClientWidth = 758
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OnShow = FormShow
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 315
    Height = 25
    Caption = 'Card Grid DataModel Example'
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
    Width = 115
    Height = 13
    Caption = 'by Talis Jonatas  Gomes'
  end
  object Panel1: TPanel
    Left = 72
    Top = 120
    Width = 185
    Height = 137
    TabOrder = 0
    object Label_Country: TLabel
      Left = 11
      Top = 9
      Width = 43
      Height = 13
      Caption = 'Country:'
    end
    object DBText_Country: TDBText
      Left = 65
      Top = 9
      Width = 112
      Height = 17
      DataField = 'Country'
      DataSource = DSCountry
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label_Population: TLabel
      Left = 11
      Top = 41
      Width = 54
      Height = 13
      Caption = 'Population:'
    end
    object DBText_Population: TDBText
      Left = 65
      Top = 41
      Width = 112
      Height = 17
      Alignment = taRightJustify
      DataField = 'Population'
      DataSource = DSCountry
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label_DDI: TLabel
      Left = 11
      Top = 73
      Width = 22
      Height = 13
      Caption = 'DDI:'
    end
    object DBText_DDI: TDBText
      Left = 65
      Top = 73
      Width = 112
      Height = 17
      Alignment = taRightJustify
      DataField = 'DDI'
      DataSource = DSCountry
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Button_View: TButton
      Left = 11
      Top = 103
      Width = 75
      Height = 25
      Caption = 'View'
      TabOrder = 0
      OnClick = Button_ViewClick
    end
  end
  object MainMenu1: TMainMenu
    Left = 656
    Top = 16
    object Module11: TMenuItem
      Caption = 'Main'
      OnClick = Module11Click
    end
    object AppModule21: TMenuItem
      Caption = 'App Module 2'
    end
    object CoreModules1: TMenuItem
      Caption = 'Core Modules'
      object CoreModule11: TMenuItem
        Caption = 'Core Module 1'
      end
      object CoreModule21: TMenuItem
        Caption = 'Core Module 2'
      end
    end
    object Modules1: TMenuItem
      Caption = 'Modules'
      object Module12: TMenuItem
        Caption = 'Module 1'
      end
      object Module21: TMenuItem
        Caption = 'Module 2'
      end
      object SubModules1: TMenuItem
        Caption = 'Sub Modules'
        object SubModule11: TMenuItem
          Caption = 'SubModule 1'
        end
        object SubModule21: TMenuItem
          Caption = 'SubModule 2'
        end
        object SubModule31: TMenuItem
          Caption = 'SubModule 3'
        end
      end
    end
  end
  object ClientDataSet_Country: TClientDataSet
    PersistDataPacket.Data = {
      9C0000009619E0BD0100000018000000040000000000030000009C0007417574
      6F436F64040001000200010007535542545950450200490008004175746F696E
      630007436F756E74727901004900000001000557494454480200020064000344
      444901004900000001000557494454480200020014000A506F70756C6174696F
      6E040001000000000001000C4155544F494E4356414C55450400010001000000}
    Active = True
    Aggregates = <>
    Params = <>
    Left = 527
    Top = 16
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
    Left = 416
    Top = 16
  end
end
