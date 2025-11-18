object Form_Equipamento: TForm_Equipamento
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'Invenst'#225'rio TI - Equipamentos'
  ClientHeight = 595
  ClientWidth = 609
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 119
    Height = 25
    Caption = 'Equipamento'
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
    DataSource = DM.DSEquipamento
    Enabled = False
    TabOrder = 1
  end
  object Panel2: TPanel
    Left = 8
    Top = 82
    Width = 97
    Height = 25
    BevelKind = bkFlat
    BevelOuter = bvNone
    Caption = 'Nome:'
    TabOrder = 2
  end
  object DBEdit_Nome: TDBEdit
    Left = 114
    Top = 84
    Width = 490
    Height = 23
    DataField = 'Nome'
    DataSource = DM.DSEquipamento
    TabOrder = 3
  end
  object Panel3: TPanel
    Left = 8
    Top = 144
    Width = 97
    Height = 25
    BevelKind = bkFlat
    BevelOuter = bvNone
    Caption = 'Tipo Aquisi'#231#227'o:'
    TabOrder = 4
  end
  object DBComboBox_Tipo_Aquisicao: TDBComboBox
    Left = 111
    Top = 146
    Width = 145
    Height = 23
    Style = csDropDownList
    DataField = 'Tipo_Aquisicao'
    DataSource = DM.DSEquipamento
    Items.Strings = (
      'Novo'
      'Usado')
    TabOrder = 5
  end
  object Panel4: TPanel
    Left = 8
    Top = 175
    Width = 97
    Height = 25
    BevelKind = bkFlat
    BevelOuter = bvNone
    Caption = 'Data Compra:'
    TabOrder = 6
  end
  object Panel5: TPanel
    Left = 355
    Top = 175
    Width = 97
    Height = 25
    BevelKind = bkFlat
    BevelOuter = bvNone
    Caption = 'Data Garantia:'
    TabOrder = 7
  end
  object Panel6: TPanel
    Left = 8
    Top = 206
    Width = 97
    Height = 25
    BevelKind = bkFlat
    BevelOuter = bvNone
    Caption = 'Setor:'
    TabOrder = 9
  end
  object DBComboBox_Setor: TDBComboBox
    Left = 111
    Top = 206
    Width = 339
    Height = 23
    Style = csDropDownList
    DataField = 'Setor'
    DataSource = DM.DSEquipamento
    Items.Strings = (
      'Administra'#231#227'o'
      'Produ'#231#227'o'
      'Call Center'
      'Financeiro'
      'Log'#237'stica'
      'Faturamento'
      'Vendas'
      'TI'
      'Suporte')
    TabOrder = 11
  end
  object Panel7: TPanel
    Left = 8
    Top = 113
    Width = 97
    Height = 25
    BevelKind = bkFlat
    BevelOuter = bvNone
    Caption = 'Marca:'
    TabOrder = 12
  end
  object DBEdit_Marca: TDBEdit
    Left = 111
    Top = 115
    Width = 145
    Height = 23
    DataField = 'Marca'
    DataSource = DM.DSEquipamento
    TabOrder = 13
  end
  object Panel8: TPanel
    Left = 8
    Top = 276
    Width = 97
    Height = 25
    BevelKind = bkFlat
    BevelOuter = bvNone
    Caption = 'Observa'#231#227'o:'
    TabOrder = 14
  end
  object Panel9: TPanel
    Left = 8
    Top = 237
    Width = 97
    Height = 25
    BevelKind = bkFlat
    BevelOuter = bvNone
    Caption = 'Status:'
    TabOrder = 15
  end
  object cxButton_Salvar: TBitBtn
    Left = 319
    Top = 569
    Width = 90
    Height = 25
    Caption = 'Salvar'
    TabOrder = 16
    OnClick = cxButton_SalvarClick
  end
  object cxButton_Excluir: TBitBtn
    Left = 415
    Top = 569
    Width = 90
    Height = 25
    Caption = 'Excluir'
    TabOrder = 17
    OnClick = cxButton_ExcluirClick
  end
  object cxButton_Sair: TBitBtn
    Left = 511
    Top = 569
    Width = 90
    Height = 25
    Caption = 'Sair'
    TabOrder = 18
    OnClick = cxButton_SairClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 369
    Width = 593
    Height = 194
    Caption = 'Licen'#231'as'
    TabOrder = 19
    object cxButton_Editar: TBitBtn
      Left = 103
      Top = 15
      Width = 90
      Height = 25
      Caption = 'Editar'
      TabOrder = 0
      OnClick = cxButton_EditarClick
    end
    object cxButton4: TBitBtn
      Left = 199
      Top = 15
      Width = 90
      Height = 25
      Caption = 'Excluir'
      TabOrder = 1
      OnClick = cxButton4Click
    end
    object cxButton_Novo: TBitBtn
      Left = 7
      Top = 15
      Width = 90
      Height = 25
      Caption = 'Novo'
      TabOrder = 2
      OnClick = cxButton_NovoClick
    end
    object DBGrid1: TDBGrid
      Left = 7
      Top = 46
      Width = 580
      Height = 140
      DataSource = DSAux_Equipamento_Licenca
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 3
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      OnDblClick = DBGrid1DblClick
      Columns = <
        item
          Expanded = False
          FieldName = 'Nome'
          Width = 200
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Chave'
          Width = 200
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Observacao'
          Width = 350
          Visible = True
        end>
    end
  end
  object DBMemo_Observacao: TDBMemo
    Left = 111
    Top = 274
    Width = 490
    Height = 89
    DataField = 'Observacao'
    DataSource = DM.DSEquipamento
    TabOrder = 20
  end
  object DBCheckBox_Status: TDBCheckBox
    Left = 111
    Top = 242
    Width = 97
    Height = 17
    Caption = 'Ativo'
    DataField = 'Status'
    DataSource = DM.DSEquipamento
    TabOrder = 21
    ValueChecked = 'Ativo'
    ValueUnchecked = 'Inativo'
    OnClick = DBCheckBox_StatusClick
  end
  object DBEdit_Data_Compra: TDBEdit
    Left = 111
    Top = 177
    Width = 144
    Height = 23
    DataField = 'Data_Compra'
    DataSource = DM.DSEquipamento
    TabOrder = 8
  end
  object DBEdit_Data_Garantia: TDBEdit
    Left = 458
    Top = 177
    Width = 144
    Height = 23
    DataField = 'Data_Garantia'
    DataSource = DM.DSEquipamento
    TabOrder = 10
  end
  object Aux_Equipamento_Licenca: TADOQuery
    Connection = DM.DBInventarioTI
    CursorLocation = clUseServer
    Parameters = <
      item
        Name = 'Auto_Codigo_Equipamento'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = 0
      end>
    SQL.Strings = (
      'Select AEL.*, SL.Nome, SL.Chave from Aux_Equipamento_Licenca AEL'
      
        'Join Software_Licenca SL on SL.Auto_Codigo = AEL.Auto_Codigo_Sof' +
        'tware_Licenca'
      'Join Software S on S.Auto_Codigo = SL.Auto_Codigo_Software'
      'Where AEL.Auto_Codigo_Equipamento = :Auto_Codigo_Equipamento'
      'Order by S.Nome, SL.Chave')
    Left = 468
    Top = 461
  end
  object DSAux_Equipamento_Licenca: TDataSource
    DataSet = Aux_Equipamento_Licenca
    Left = 303
    Top = 460
  end
end
