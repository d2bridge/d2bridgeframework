object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'DEMO - Edit'
  ClientHeight = 196
  ClientWidth = 364
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object Label_Auto_Cod: TLabel
    Left = 16
    Top = 16
    Width = 25
    Height = 15
    Caption = 'Cod:'
  end
  object Label_Country: TLabel
    Left = 16
    Top = 48
    Width = 46
    Height = 15
    Caption = 'Country:'
  end
  object Label_DDI: TLabel
    Left = 16
    Top = 77
    Width = 22
    Height = 15
    Caption = 'DDI:'
  end
  object Label_Population: TLabel
    Left = 16
    Top = 106
    Width = 61
    Height = 15
    Caption = 'Population:'
  end
  object DBEdit_Auto_Cod: TDBEdit
    Left = 85
    Top = 13
    Width = 74
    Height = 23
    DataField = 'AutoCod'
    DataSource = Form1.DSCountry
    TabOrder = 0
  end
  object DBEdit_Country: TDBEdit
    Left = 85
    Top = 45
    Width = 257
    Height = 23
    DataField = 'Country'
    DataSource = Form1.DSCountry
    TabOrder = 1
  end
  object DBEdit_DDI: TDBEdit
    Left = 85
    Top = 74
    Width = 74
    Height = 23
    DataField = 'DDI'
    DataSource = Form1.DSCountry
    TabOrder = 2
  end
  object DBEdit_Population: TDBEdit
    Left = 85
    Top = 103
    Width = 135
    Height = 23
    DataField = 'Population'
    DataSource = Form1.DSCountry
    TabOrder = 3
  end
  object Button_Save: TButton
    Left = 105
    Top = 152
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 4
    OnClick = Button_SaveClick
  end
  object Button_Delete: TButton
    Left = 186
    Top = 152
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 5
    OnClick = Button_DeleteClick
  end
  object Button_Close: TButton
    Left = 267
    Top = 152
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 6
    OnClick = Button_CloseClick
  end
end
