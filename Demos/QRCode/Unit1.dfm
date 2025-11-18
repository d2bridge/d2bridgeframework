object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 694
  ClientWidth = 688
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 72
    Height = 13
    Caption = 'DEMO QRCode'
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
  object GroupBox1: TGroupBox
    Left = 24
    Top = 80
    Width = 633
    Height = 169
    Caption = 'VCL and WEB'
    TabOrder = 0
    object Image1: TImage
      Left = 480
      Top = 24
      Width = 137
      Height = 129
      Proportional = True
    end
    object Edit1: TEdit
      Left = 16
      Top = 24
      Width = 369
      Height = 21
      TabOrder = 0
      Text = 'https://www.d2bridge.com.br'
    end
    object Button1: TButton
      Left = 391
      Top = 22
      Width = 75
      Height = 25
      Caption = 'QRCode'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 24
    Top = 255
    Width = 633
    Height = 66
    Caption = 'WEB Static'
    TabOrder = 1
    object Edit2: TEdit
      Left = 16
      Top = 24
      Width = 601
      Height = 21
      Enabled = False
      TabOrder = 0
      Text = 'https://www.d2bridge.com.br'
    end
  end
  object GroupBox3: TGroupBox
    Left = 24
    Top = 327
    Width = 633
    Height = 66
    Caption = 'Web Dynamic'
    TabOrder = 2
    object Edit3: TEdit
      Left = 16
      Top = 24
      Width = 520
      Height = 21
      TabOrder = 0
      Text = 'https://www.d2bridge.com.br'
    end
    object Button2: TButton
      Left = 542
      Top = 22
      Width = 75
      Height = 25
      Caption = 'QRCode'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object GroupBox5: TGroupBox
    Left = 24
    Top = 399
    Width = 633
    Height = 196
    Caption = 'Web Dataware'
    TabOrder = 3
    object DBGrid1: TDBGrid
      Left = 16
      Top = 24
      Width = 601
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
  end
  object DSCountry: TDataSource
    DataSet = CDSCountry
    Left = 336
    Top = 496
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
    Left = 229
    Top = 494
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
end
