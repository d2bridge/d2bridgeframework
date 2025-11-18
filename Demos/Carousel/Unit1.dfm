object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 360
  ClientWidth = 635
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
    Width = 74
    Height = 13
    Caption = 'DEMO Carousel'
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
    Top = 136
    Width = 585
    Height = 145
    DataSource = DM.DSImages
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'ImageName'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Path'
        Width = 400
        Visible = True
      end>
  end
end
