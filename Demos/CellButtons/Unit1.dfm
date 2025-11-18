object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 617
  ClientWidth = 750
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 82
    Height = 13
    Caption = 'Demo Cell Button'
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
  object DBGrid1: TDBGrid
    Left = 24
    Top = 112
    Width = 705
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
        Title.Caption = 'Cod'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Country'
        Width = 300
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DDI'
        Width = 40
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Population'
        Width = 140
        Visible = True
      end>
  end
  object Button_New: TButton
    Left = 24
    Top = 81
    Width = 75
    Height = 25
    Caption = '{{_New_}}'
    TabOrder = 1
    OnClick = Button_NewClick
  end
  object Button_Edit: TButton
    Left = 103
    Top = 81
    Width = 75
    Height = 25
    Caption = '{{_Edit_}}'
    TabOrder = 2
    OnClick = Button_EditClick
  end
  object Button_Delete: TButton
    Left = 184
    Top = 81
    Width = 75
    Height = 25
    Caption = '{{_Delete_}}'
    TabOrder = 3
    OnClick = Button_DeleteClick
  end
  object DBGrid2: TDBGrid
    Left = 24
    Top = 271
    Width = 705
    Height = 153
    DataSource = DSCountry
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 4
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'AutoCod'
        Title.Caption = 'Cod'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Country'
        Width = 300
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DDI'
        Width = 40
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Population'
        Width = 140
        Visible = True
      end>
  end
  object DBGrid3: TDBGrid
    Left = 24
    Top = 430
    Width = 705
    Height = 153
    DataSource = DSCountry
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 5
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'AutoCod'
        Title.Caption = 'Cod'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Country'
        Width = 300
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DDI'
        Width = 40
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Population'
        Width = 140
        Visible = True
      end>
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
    Left = 616
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
    Left = 496
    Top = 24
  end
end
