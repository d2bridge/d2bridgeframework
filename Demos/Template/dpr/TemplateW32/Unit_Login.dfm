object Form_Login: TForm_Login
  Left = 0
  Top = 0
  Caption = 'D2Bridge - Login'
  ClientHeight = 442
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnActivate = FormActivate
  TextHeight = 15
  object Edit_Login: TEdit
    Left = 256
    Top = 144
    Width = 150
    Height = 23
    TabOrder = 0
  end
  object Edit_Senha: TEdit
    Left = 256
    Top = 192
    Width = 150
    Height = 23
    PasswordChar = '*'
    TabOrder = 1
  end
  object BUTTON_LOGAR: TButton
    Left = 256
    Top = 248
    Width = 75
    Height = 25
    Caption = 'Login'
    TabOrder = 2
    OnClick = BUTTON_LOGARClick
  end
  object Panel1: TPanel
    Left = 144
    Top = 139
    Width = 97
    Height = 31
    Caption = 'Login:'
    TabOrder = 3
  end
  object Panel2: TPanel
    Left = 144
    Top = 187
    Width = 97
    Height = 31
    Caption = 'Senha:'
    TabOrder = 4
  end
end
