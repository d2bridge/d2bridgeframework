object Form_Cadastro_Cliente: TForm_Cadastro_Cliente
  Left = 0
  Top = 0
  Caption = 'D2Bridge - Cadastro Cliente'
  ClientHeight = 203
  ClientWidth = 524
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 124
    Height = 15
    Caption = 'CADASTRO DE CLIENTE'
  end
  object Panel1: TPanel
    Left = 8
    Top = 47
    Width = 97
    Height = 23
    Caption = 'Nome:'
    TabOrder = 0
  end
  object Edit_Nome: TEdit
    Left = 120
    Top = 48
    Width = 393
    Height = 23
    TabOrder = 1
  end
  object Panel2: TPanel
    Left = 8
    Top = 76
    Width = 97
    Height = 23
    Caption = 'Telefone:'
    TabOrder = 2
  end
  object Edit_Telefone: TEdit
    Left = 120
    Top = 77
    Width = 201
    Height = 23
    TabOrder = 3
  end
  object Button_Salvar: TButton
    Left = 441
    Top = 170
    Width = 75
    Height = 25
    Caption = 'Salvar'
    TabOrder = 4
    OnClick = Button_SalvarClick
  end
end
