object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 414
  ClientWidth = 650
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 122
    Height = 25
    Caption = 'Hello World'
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
  object Label4: TLabel
    Left = 8
    Top = 104
    Width = 193
    Height = 13
    Caption = 'Click to Open https://d2bridge.com.br'
  end
  object Label5: TLabel
    Left = 8
    Top = 123
    Width = 150
    Height = 13
    Caption = 'Click to CallBack "LinkCallBack1"'
  end
  object DBText1: TDBText
    Left = 8
    Top = 383
    Width = 209
    Height = 17
    DataField = 'Country'
    DataSource = DSCountry
    OnClick = DBText1Click
  end
  object Label6: TLabel
    Left = 8
    Top = 142
    Width = 121
    Height = 13
    Caption = 'Click direct in Label Event'
    OnClick = Label6Click
  end
  object Label7: TLabel
    Left = 8
    Top = 163
    Width = 125
    Height = 14
    Caption = 'Click Style VCL Label'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 224
    Width = 633
    Height = 153
    DataSource = DSCountry
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'AutoCod'
        Title.Caption = 'Id'
        Width = 30
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Country'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Continent'
        Width = 80
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Capital'
        Title.Caption = 'City'
        Width = 80
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Population'
        Width = 65
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Language'
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CurrencyName'
        Title.Caption = 'Currency Name'
        Width = 90
        Visible = True
      end>
  end
  object CDSCountry: TClientDataSet
    PersistDataPacket.Data = {
      480100009619E0BD01000000180000000A000000000003000000480107417574
      6F436F64040001000200010007535542545950450200490008004175746F696E
      630007436F756E74727901004900000001000557494454480200020064000344
      444901004900000001000557494454480200020014000A506F70756C6174696F
      6E040001000000000009436F6E74696E656E7401004900000001000557494454
      48020002001900084C616E677561676501004900000001000557494454480200
      02000F00074361706974616C0100490000000100055749445448020002001400
      0C43757272656E63794E616D650100490000000100055749445448020002000F
      000E43757272656E637953696D626F6C01004900000001000557494454480200
      02000500084372656174654174040006000000000001000C4155544F494E4356
      414C55450400010001000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'AutoCod'
        Attributes = [faReadonly]
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
      end
      item
        Name = 'CreateAt'
        DataType = ftDate
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 221
    Top = 289
    object CDSCountryAutoCod: TAutoIncField
      FieldName = 'AutoCod'
    end
    object CDSCountryCountry: TStringField
      FieldName = 'Country'
      Size = 100
    end
    object CDSCountryDDI: TStringField
      FieldName = 'DDI'
    end
    object CDSCountryPopulation: TIntegerField
      FieldName = 'Population'
    end
    object CDSCountryContinent: TStringField
      FieldName = 'Continent'
      Size = 25
    end
    object CDSCountryLanguage: TStringField
      FieldName = 'Language'
      Size = 15
    end
    object CDSCountryCapital: TStringField
      FieldName = 'Capital'
    end
    object CDSCountryCurrencyName: TStringField
      FieldName = 'CurrencyName'
      Size = 15
    end
    object CDSCountryCurrencySimbol: TStringField
      FieldName = 'CurrencySimbol'
      Size = 5
    end
    object CDSCountryCreateAt: TDateField
      FieldName = 'CreateAt'
    end
  end
  object DSCountry: TDataSource
    DataSet = CDSCountry
    Left = 328
    Top = 289
  end
end
