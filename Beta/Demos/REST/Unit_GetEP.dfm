object Form_GetEP: TForm_GetEP
  Left = 0
  Top = 0
  Caption = 'Endpoint data'
  ClientHeight = 530
  ClientWidth = 760
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object LabelTitle: TLabel
    Left = 16
    Top = 16
    Width = 114
    Height = 19
    Caption = 'Endpoint data'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LabelUrl: TLabel
    Left = 16
    Top = 48
    Width = 370
    Height = 14
    Caption = 
      'POST /api/auth/login, then GET http://localhost:8888/api/product' +
      's'
  end
  object LabelStatus: TLabel
    Left = 16
    Top = 72
    Width = 186
    Height = 14
    Caption = 'Endpoint has not been called yet.'
  end
  object LabelUser: TLabel
    Left = 16
    Top = 104
    Width = 24
    Height = 14
    Caption = 'User'
  end
  object LabelPassword: TLabel
    Left = 208
    Top = 104
    Width = 51
    Height = 14
    Caption = 'Password'
  end
  object LabelToken: TLabel
    Left = 16
    Top = 156
    Width = 73
    Height = 14
    Caption = 'Access token'
  end
  object LabelId: TLabel
    Left = 16
    Top = 208
    Width = 11
    Height = 14
    Caption = 'Id'
  end
  object LabelName: TLabel
    Left = 112
    Top = 208
    Width = 31
    Height = 14
    Caption = 'Name'
  end
  object LabelPrice: TLabel
    Left = 408
    Top = 208
    Width = 26
    Height = 14
    Caption = 'Price'
  end
  object EditUser: TEdit
    Left = 16
    Top = 122
    Width = 180
    Height = 22
    TabOrder = 0
    Text = 'UserD2Bridge'
  end
  object EditPassword: TEdit
    Left = 208
    Top = 122
    Width = 120
    Height = 22
    TabOrder = 1
    Text = '123456'
  end
  object ButtonGetToken: TButton
    Left = 340
    Top = 118
    Width = 110
    Height = 28
    Caption = 'Get token'
    TabOrder = 2
    OnClick = ButtonGetTokenClick
  end
  object EditToken: TEdit
    Left = 16
    Top = 174
    Width = 700
    Height = 22
    TabOrder = 3
  end
  object EditId: TEdit
    Left = 16
    Top = 226
    Width = 80
    Height = 22
    TabOrder = 4
  end
  object EditName: TEdit
    Left = 112
    Top = 226
    Width = 280
    Height = 22
    TabOrder = 5
  end
  object EditPrice: TEdit
    Left = 408
    Top = 226
    Width = 100
    Height = 22
    TabOrder = 6
  end
  object ButtonLoad: TButton
    Left = 16
    Top = 264
    Width = 100
    Height = 28
    Caption = 'Load'
    TabOrder = 7
    OnClick = ButtonLoadClick
  end
  object ButtonInsert: TButton
    Left = 128
    Top = 264
    Width = 100
    Height = 28
    Caption = 'Insert'
    TabOrder = 8
    OnClick = ButtonInsertClick
  end
  object ButtonUpdate: TButton
    Left = 240
    Top = 264
    Width = 100
    Height = 28
    Caption = 'Update'
    TabOrder = 9
    OnClick = ButtonUpdateClick
  end
  object ButtonDelete: TButton
    Left = 352
    Top = 264
    Width = 100
    Height = 28
    Caption = 'Delete'
    TabOrder = 10
    OnClick = ButtonDeleteClick
  end
  object DBGrid1: TDBGrid
    Left = 16
    Top = 308
    Width = 720
    Height = 196
    DataSource = DSProducts
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 11
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnCellClick = DBGrid1CellClick
  end
  object CDSProducts: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 640
    Top = 160
    object CDSProductsId: TIntegerField
      FieldName = 'Id'
    end
    object CDSProductsName: TStringField
      FieldName = 'Name'
      Size = 80
    end
    object CDSProductsPrice: TFloatField
      FieldName = 'Price'
    end
  end
  object DSProducts: TDataSource
    DataSet = CDSProducts
    Left = 688
    Top = 160
  end
end
