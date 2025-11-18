object Form_Software_Licenca: TForm_Software_Licenca
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'Invent'#225'rio TI - Licen'#231'as'
  ClientHeight = 437
  ClientWidth = 610
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
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 131
    Height = 25
    Caption = 'Licen'#231'a de Uso'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 8
    Top = 49
    Width = 97
    Height = 25
    BevelKind = bkFlat
    BevelOuter = bvNone
    Caption = 'C'#243'digo:'
    TabOrder = 0
  end
  object DBEdit_Codigo: TDBEdit
    Left = 111
    Top = 51
    Width = 144
    Height = 23
    DataField = 'Auto_Codigo'
    DataSource = DM.DSSoftware_Licenca
    Enabled = False
    TabOrder = 1
  end
  object Panel2: TPanel
    Left = 8
    Top = 79
    Width = 97
    Height = 25
    BevelKind = bkFlat
    BevelOuter = bvNone
    Caption = 'Software:'
    TabOrder = 2
  end
  object DBEdit_Nome: TDBEdit
    Left = 111
    Top = 80
    Width = 490
    Height = 23
    DataField = 'Nome'
    DataSource = DM.DSSoftware
    Enabled = False
    TabOrder = 3
  end
  object Panel7: TPanel
    Left = 8
    Top = 110
    Width = 97
    Height = 25
    BevelKind = bkFlat
    BevelOuter = bvNone
    Caption = 'Chave:'
    TabOrder = 4
  end
  object DBEdit_Chave: TDBEdit
    Left = 111
    Top = 112
    Width = 292
    Height = 23
    DataField = 'Chave'
    DataSource = DM.DSSoftware_Licenca
    TabOrder = 5
  end
  object Panel9: TPanel
    Left = 8
    Top = 172
    Width = 97
    Height = 25
    BevelKind = bkFlat
    BevelOuter = bvNone
    Caption = 'Status:'
    TabOrder = 8
  end
  object DBComboBox_Status: TDBComboBox
    Left = 111
    Top = 174
    Width = 145
    Height = 23
    Style = csDropDownList
    DataField = 'Status'
    DataSource = DM.DSSoftware_Licenca
    Items.Strings = (
      'Ativo'
      'Inativo')
    TabOrder = 9
  end
  object Panel8: TPanel
    Left = 8
    Top = 211
    Width = 97
    Height = 25
    BevelKind = bkFlat
    BevelOuter = bvNone
    Caption = 'Observa'#231#227'o:'
    TabOrder = 10
  end
  object DBMemo_Observacao: TDBMemo
    Left = 111
    Top = 214
    Width = 490
    Height = 89
    DataField = 'Observacao'
    DataSource = DM.DSSoftware_Licenca
    TabOrder = 11
  end
  object Panel4: TPanel
    Left = 8
    Top = 141
    Width = 97
    Height = 25
    BevelKind = bkFlat
    BevelOuter = bvNone
    Caption = 'Data Compra:'
    TabOrder = 12
  end
  object Panel5: TPanel
    Left = 356
    Top = 144
    Width = 97
    Height = 25
    BevelKind = bkFlat
    BevelOuter = bvNone
    Caption = 'Data Suporte:'
    TabOrder = 13
  end
  object cxButton_Salvar: TBitBtn
    Left = 320
    Top = 405
    Width = 90
    Height = 25
    Caption = 'Salvar'
    TabOrder = 14
    OnClick = cxButton_SalvarClick
  end
  object cxButton_Excluir: TBitBtn
    Left = 416
    Top = 405
    Width = 90
    Height = 25
    Caption = 'Excluir'
    TabOrder = 15
    OnClick = cxButton_ExcluirClick
  end
  object cxButton_Sair: TBitBtn
    Left = 512
    Top = 405
    Width = 90
    Height = 25
    Caption = 'Sair'
    TabOrder = 16
    OnClick = cxButton_SairClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 309
    Width = 594
    Height = 88
    Caption = 'Utilizado por'
    TabOrder = 17
    object DBText1: TDBText
      Left = 112
      Top = 25
      Width = 65
      Height = 17
      DataField = 'Auto_Codigo'
      DataSource = DM.DSEquipamento
    end
    object DBText2: TDBText
      Left = 112
      Top = 58
      Width = 470
      Height = 17
      DataField = 'Nome'
      DataSource = DM.DSEquipamento
    end
    object Panel3: TPanel
      Left = 9
      Top = 20
      Width = 97
      Height = 25
      BevelKind = bkFlat
      BevelOuter = bvNone
      Caption = 'C'#243'digo:'
      TabOrder = 0
    end
    object Panel6: TPanel
      Left = 9
      Top = 53
      Width = 97
      Height = 25
      BevelKind = bkFlat
      BevelOuter = bvNone
      Caption = 'Equipamento:'
      TabOrder = 1
    end
  end
  object DBDateEdit_Data_Compra: TDBEdit
    Left = 111
    Top = 145
    Width = 145
    Height = 23
    DataField = 'Data_Compra'
    DataSource = DM.DSSoftware_Licenca
    TabOrder = 6
  end
  object DBDateEdit_Data_Suporte: TDBEdit
    Left = 457
    Top = 143
    Width = 145
    Height = 23
    DataField = 'Data_Suporte'
    DataSource = DM.DSSoftware_Licenca
    TabOrder = 7
  end
end
