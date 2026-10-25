object FormMap: TFormMap
  Left = 0
  Top = 0
  Caption = 'Map'
  ClientHeight = 280
  ClientWidth = 720
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object LabelLatitude: TLabel
    Left = 16
    Top = 16
    Width = 45
    Height = 15
    Caption = 'Latitude'
  end
  object LabelLongitude: TLabel
    Left = 192
    Top = 16
    Width = 56
    Height = 15
    Caption = 'Longitude'
  end
  object EditLatitude: TEdit
    Left = 16
    Top = 36
    Width = 160
    Height = 23
    TabOrder = 0
    Text = '-21.176700'
  end
  object EditLongitude: TEdit
    Left = 192
    Top = 36
    Width = 160
    Height = 23
    TabOrder = 1
    Text = '-47.820800'
  end
  object BtnMarkPoint: TButton
    Left = 368
    Top = 34
    Width = 100
    Height = 25
    Caption = 'Mark point'
    TabOrder = 2
    OnClick = BtnMarkPointClick
  end
  object BtnClear: TButton
    Left = 476
    Top = 34
    Width = 100
    Height = 25
    Caption = 'Clear points'
    TabOrder = 3
    OnClick = BtnClearClick
  end
  object BtnMyLocation: TButton
    Left = 584
    Top = 34
    Width = 130
    Height = 25
    Caption = 'Return to location'
    TabOrder = 4
    OnClick = BtnMyLocationClick
  end
  object MemoResult: TMemo
    Left = 16
    Top = 80
    Width = 678
    Height = 170
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 5
  end
end
