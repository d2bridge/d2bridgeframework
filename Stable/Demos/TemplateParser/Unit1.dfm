object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 319
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 14
  object Edit1: TEdit
    Left = 16
    Top = 15
    Width = 121
    Height = 22
    TabOrder = 0
  end
  object Button1: TButton
    Left = 16
    Top = 48
    Width = 105
    Height = 25
    Caption = 'Save to Session'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 16
    Top = 79
    Width = 161
    Height = 25
    Caption = 'Read Session Data via API'
    TabOrder = 2
  end
  object Button3: TButton
    Left = 16
    Top = 110
    Width = 75
    Height = 25
    Caption = 'Call Callback'
    TabOrder = 3
  end
  object Button4: TButton
    Left = 97
    Top = 110
    Width = 80
    Height = 25
    Caption = 'Call Callback2'
    TabOrder = 4
  end
end
