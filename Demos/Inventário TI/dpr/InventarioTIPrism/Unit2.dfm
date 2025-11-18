object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'D2Bridge'
  ClientHeight = 114
  ClientWidth = 194
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 32
    Top = 24
    Width = 31
    Height = 15
    Caption = 'Porta:'
  end
  object Button1: TButton
    Left = 32
    Top = 64
    Width = 121
    Height = 25
    Caption = 'Iniciar'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 80
    Top = 21
    Width = 73
    Height = 23
    TabOrder = 1
    Text = '8888'
  end
end
