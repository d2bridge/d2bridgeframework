object Form_Login: TForm_Login
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'D2Bridge Framework - DEMO TI'
  ClientHeight = 154
  ClientWidth = 307
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object Panel1: TPanel
    Left = 20
    Top = 16
    Width = 97
    Height = 25
    Caption = 'Usu'#225'rio:'
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 20
    Top = 52
    Width = 97
    Height = 25
    Caption = 'Senha:'
    TabOrder = 1
  end
  object Edit_Login: TEdit
    Left = 123
    Top = 19
    Width = 154
    Height = 23
    TabOrder = 2
  end
  object Edit_Password: TEdit
    Left = 123
    Top = 55
    Width = 154
    Height = 23
    PasswordChar = '*'
    TabOrder = 3
  end
  object Button_Logar: TButton
    Left = 164
    Top = 108
    Width = 75
    Height = 25
    Caption = 'Login'
    TabOrder = 4
    OnClick = Button_LogarClick
  end
  object Button2: TButton
    Left = 50
    Top = 108
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 5
    OnClick = Button2Click
  end
end
