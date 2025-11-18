object Form_Equipamento_Licenca: TForm_Equipamento_Licenca
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'Invent'#225'rio TI - Selecione a Licen'#231'a de Uso'
  ClientHeight = 133
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 235
    Height = 25
    Caption = 'Selecione a Licen'#231'a de Uso'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 8
    Top = 42
    Width = 81
    Height = 25
    BevelKind = bkFlat
    BevelOuter = bvNone
    Caption = 'Licen'#231'a:'
    TabOrder = 0
  end
  object DBLookupComboBox_Licenca: TDBLookupComboBox
    Left = 95
    Top = 43
    Width = 510
    Height = 23
    DataField = 'Auto_Codigo_Software_Licenca'
    DataSource = DM.DSAux_Equipamento_Licenca
    KeyField = 'Auto_Codigo'
    ListField = 'Nome;Chave'
    ListFieldIndex = 1
    ListSource = DM.DSSoftware_Licenca
    TabOrder = 1
  end
  object cxButton_Salvar: TBitBtn
    Left = 329
    Top = 82
    Width = 90
    Height = 25
    Caption = 'Salvar'
    TabOrder = 2
    OnClick = cxButton_SalvarClick
  end
  object cxButton_Excluir: TBitBtn
    Left = 425
    Top = 82
    Width = 90
    Height = 25
    Caption = 'Excluir'
    TabOrder = 3
    OnClick = cxButton_ExcluirClick
  end
  object cxButton_Sair: TBitBtn
    Left = 521
    Top = 82
    Width = 90
    Height = 25
    Caption = 'Sair'
    TabOrder = 4
    OnClick = cxButton_SairClick
  end
end
