object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 298
  ClientWidth = 634
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 122
    Height = 13
    Caption = 'DEMO URL Query Params'
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
  object Label_Query_Params: TLabel
    Left = 24
    Top = 158
    Width = 377
    Height = 51
    AutoSize = False
    Caption = 'Result = No Query Params'
    WordWrap = True
  end
  object Label_Usage: TLabel
    Left = 24
    Top = 73
    Width = 191
    Height = 13
    Caption = 'Usage: Paste in your URL query params'
  end
  object Edit_Your_URL_Example: TEdit
    Left = 24
    Top = 112
    Width = 377
    Height = 21
    ReadOnly = True
    TabOrder = 0
    Text = 'Your URL Example'
  end
  object Button_Copy: TButton
    Left = 407
    Top = 110
    Width = 75
    Height = 25
    Caption = 'Copy'
    TabOrder = 1
    OnClick = Button_CopyClick
  end
end
