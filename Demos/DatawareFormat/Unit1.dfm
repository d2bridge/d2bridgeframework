object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 530
  ClientWidth = 738
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
    Width = 256
    Height = 25
    Caption = 'Dataware Format DEMO'
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
  object Label_ID: TLabel
    Left = 8
    Top = 400
    Width = 11
    Height = 13
    Caption = 'ID'
  end
  object Label_Country: TLabel
    Left = 55
    Top = 400
    Width = 39
    Height = 13
    Caption = 'Country'
  end
  object Label_DDI: TLabel
    Left = 216
    Top = 400
    Width = 18
    Height = 13
    Caption = 'DDI'
  end
  object Label_Population: TLabel
    Left = 270
    Top = 400
    Width = 50
    Height = 13
    Caption = 'Population'
  end
  object Label_Data_Constitution: TLabel
    Left = 351
    Top = 400
    Width = 86
    Height = 13
    Caption = 'Date Constituition'
  end
  object Label_GPD: TLabel
    Left = 455
    Top = 400
    Width = 142
    Height = 13
    Caption = 'Gross Domestic Product (BRL)'
  end
  object Label_Capital: TLabel
    Left = 613
    Top = 400
    Width = 33
    Height = 13
    Caption = 'Capital'
  end
  object Label_Search: TLabel
    Left = 8
    Top = 102
    Width = 37
    Height = 13
    Caption = 'Search:'
  end
  object DBGrid3: TDBGrid
    Left = 8
    Top = 128
    Width = 718
    Height = 249
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
        Width = 30
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
        Width = 40
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Population'
        Title.Alignment = taRightJustify
        Width = 70
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'ConstitutionDate'
        Title.Alignment = taCenter
        Title.Caption = 'Date'
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'GDP_BRL'
        Title.Alignment = taRightJustify
        Title.Caption = 'GDP / BRL'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Capital'
        Width = 100
        Visible = True
      end>
  end
  object DBEdit_ID: TDBEdit
    Left = 8
    Top = 419
    Width = 41
    Height = 21
    DataField = 'AutoCod'
    DataSource = DSCountry
    TabOrder = 1
  end
  object DBEdit_Country: TDBEdit
    Left = 55
    Top = 419
    Width = 154
    Height = 21
    DataField = 'Country'
    DataSource = DSCountry
    TabOrder = 2
  end
  object DBEdit_DDI: TDBEdit
    Left = 216
    Top = 419
    Width = 48
    Height = 21
    DataField = 'DDI'
    DataSource = DSCountry
    TabOrder = 3
  end
  object DBEdit_Population: TDBEdit
    Left = 270
    Top = 419
    Width = 75
    Height = 21
    DataField = 'Population'
    DataSource = DSCountry
    TabOrder = 4
  end
  object DBEdit_Date_Constitution: TDBEdit
    Left = 351
    Top = 419
    Width = 98
    Height = 21
    DataField = 'ConstitutionDate'
    DataSource = DSCountry
    TabOrder = 5
  end
  object DBEdit_GPD: TDBEdit
    Left = 455
    Top = 419
    Width = 152
    Height = 21
    DataField = 'GDP_BRL'
    DataSource = DSCountry
    TabOrder = 6
  end
  object DBEdit_Capital: TDBEdit
    Left = 613
    Top = 419
    Width = 113
    Height = 21
    DataField = 'Capital'
    DataSource = DSCountry
    TabOrder = 7
  end
  object Button_Save: TButton
    Left = 8
    Top = 446
    Width = 97
    Height = 25
    Caption = 'Save'
    TabOrder = 8
    OnClick = Button_SaveClick
  end
  object Button_Deactive_Active: TButton
    Left = 8
    Top = 493
    Width = 97
    Height = 25
    Caption = 'Deative/Active'
    TabOrder = 9
    OnClick = Button_Deactive_ActiveClick
  end
  object Button_No_AutoEdit: TButton
    Left = 111
    Top = 493
    Width = 97
    Height = 25
    Caption = 'Auto Edit/No'
    TabOrder = 10
    OnClick = Button_No_AutoEditClick
  end
  object Edit_Search: TEdit
    Left = 55
    Top = 99
    Width = 121
    Height = 21
    TabOrder = 11
  end
  object Button_Search: TButton
    Left = 182
    Top = 97
    Width = 52
    Height = 25
    Caption = 'Search'
    TabOrder = 12
    OnClick = Button_SearchClick
  end
  object ClientDataSet_Country: TClientDataSet
    PersistDataPacket.Data = {
      F50000009619E0BD010000001800000007000000000003000000F50007417574
      6F436F64040001000200010007535542545950450200490008004175746F696E
      630007436F756E74727901004900000001000557494454480200020064000344
      444901004900000001000557494454480200020014000A506F70756C6174696F
      6E040001000000000010436F6E737469747574696F6E44617465040006000000
      0000074744505F42524C08000400000001000753554254595045020049000600
      4D6F6E657900074361706974616C010049000000010005574944544802000200
      320001000C4155544F494E4356414C55450400010001000000}
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
    object ClientDataSet_CountryConstitutionDate: TDateField
      FieldName = 'ConstitutionDate'
      DisplayFormat = 'DD/MM'
    end
    object ClientDataSet_CountryGDP_BRL: TCurrencyField
      FieldName = 'GDP_BRL'
    end
    object ClientDataSet_CountryCapital: TStringField
      FieldName = 'Capital'
      Size = 50
    end
  end
  object DSCountry: TDataSource
    DataSet = ClientDataSet_Country
    Left = 496
    Top = 24
  end
end
