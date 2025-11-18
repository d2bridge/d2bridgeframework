object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 402
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 54
    Height = 13
    Caption = 'Hello World'
  end
  object Label2: TLabel
    Left = 24
    Top = 35
    Width = 215
    Height = 13
    Caption = 'This app is created with D2Bridge Framework'
  end
  object Label3: TLabel
    Left = 24
    Top = 54
    Width = 115
    Height = 13
    Caption = 'by Talis Jonatas  Gomes'
  end
  object Label4: TLabel
    Left = 24
    Top = 75
    Width = 255
    Height = 13
    Caption = 'This DEMO shows how to use Multi Select with DBGrid'
  end
  object DBGrid1: TDBGrid
    Left = 24
    Top = 136
    Width = 577
    Height = 233
    DataSource = DSCountry
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgMultiSelect, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnCellClick = DBGrid1CellClick
    Columns = <
      item
        Expanded = False
        FieldName = 'AutoCod'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Country'
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DDI'
        Width = 30
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CanSelect'
        Title.Caption = 'Can Select?'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Population'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Continent'
        Width = 90
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Language'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Capital'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CurrencyName'
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CurrencySimbol'
        Title.Caption = '$'
        Width = 30
        Visible = True
      end>
  end
  object Button1: TButton
    Left = 24
    Top = 105
    Width = 97
    Height = 25
    Caption = 'View selected'
    TabOrder = 1
    OnClick = Button1Click
  end
  object DSCountry: TDataSource
    DataSet = ClientDataSet_Country
    Left = 193
    Top = 198
  end
  object ClientDataSet_Country: TClientDataSet
    PersistDataPacket.Data = {
      550100009619E0BD01000000180000000A000000000003000000550107417574
      6F436F64040001000000010007535542545950450200490008004175746F696E
      630007436F756E74727901004900000001000557494454480200020064000344
      444901004900000001000557494454480200020014000943616E53656C656374
      01004900000001000557494454480200020003000A506F70756C6174696F6E04
      0001000000000009436F6E74696E656E74010049000000010005574944544802
      0002001900084C616E6775616765010049000000010005574944544802000200
      0F00074361706974616C01004900000001000557494454480200020014000C43
      757272656E63794E616D650100490000000100055749445448020002000F000E
      43757272656E637953696D626F6C010049000000010005574944544802000200
      050001000C4155544F494E4356414C55450400010001000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'AutoCod'
        DataType = ftAutoInc
      end
      item
        Name = 'Country'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'DDI'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'CanSelect'
        DataType = ftString
        Size = 3
      end
      item
        Name = 'Population'
        DataType = ftInteger
      end
      item
        Name = 'Continent'
        DataType = ftString
        Size = 25
      end
      item
        Name = 'Language'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'Capital'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'CurrencyName'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'CurrencySimbol'
        DataType = ftString
        Size = 5
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 293
    Top = 198
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
    object ClientDataSet_CountryCanSelect: TStringField
      FieldName = 'CanSelect'
      Size = 3
    end
    object ClientDataSet_CountryPopulation: TIntegerField
      FieldName = 'Population'
    end
    object ClientDataSet_CountryContinent: TStringField
      FieldName = 'Continent'
      Size = 25
    end
    object ClientDataSet_CountryLanguage: TStringField
      FieldName = 'Language'
      Size = 15
    end
    object ClientDataSet_CountryCapital: TStringField
      FieldName = 'Capital'
    end
    object ClientDataSet_CountryCurrencyName: TStringField
      FieldName = 'CurrencyName'
      Size = 15
    end
    object ClientDataSet_CountryCurrencySimbol: TStringField
      FieldName = 'CurrencySimbol'
      Size = 5
    end
  end
end
