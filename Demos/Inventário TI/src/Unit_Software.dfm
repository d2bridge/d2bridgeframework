object Form_Software: TForm_Software
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'Invent'#225'rio TI - Software'
  ClientHeight = 409
  ClientWidth = 634
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
    Width = 80
    Height = 25
    Caption = 'Software'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object cxButton_Salvar: TBitBtn
    Left = 340
    Top = 376
    Width = 90
    Height = 25
    Caption = 'Salvar'
    TabOrder = 0
    OnClick = cxButton_SalvarClick
  end
  object cxButton_Excluir: TBitBtn
    Left = 436
    Top = 376
    Width = 90
    Height = 25
    Caption = 'Excluir'
    TabOrder = 1
    OnClick = cxButton_ExcluirClick
  end
  object cxButton_Sair: TBitBtn
    Left = 532
    Top = 376
    Width = 90
    Height = 25
    Caption = 'Sair'
    TabOrder = 2
    OnClick = cxButton_SairClick
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 41
    Width = 618
    Height = 329
    ActivePage = TabSheet2
    TabOrder = 3
    object TabSheet1: TTabSheet
      Caption = 'Principal'
      object Panel1: TPanel
        Left = 6
        Top = 3
        Width = 97
        Height = 25
        BevelKind = bkFlat
        BevelOuter = bvNone
        Caption = 'C'#243'digo:'
        TabOrder = 0
      end
      object DBEdit_Codigo: TDBEdit
        Left = 109
        Top = 5
        Width = 144
        Height = 23
        DataField = 'Auto_Codigo'
        DataSource = DM.DSSoftware
        Enabled = False
        TabOrder = 1
      end
      object Panel2: TPanel
        Left = 6
        Top = 36
        Width = 97
        Height = 25
        BevelKind = bkFlat
        BevelOuter = bvNone
        Caption = 'Nome:'
        TabOrder = 2
      end
      object DBEdit_Nome: TDBEdit
        Left = 109
        Top = 38
        Width = 490
        Height = 23
        DataField = 'Nome'
        DataSource = DM.DSSoftware
        TabOrder = 3
      end
      object DBComboBox_Tipo_Software: TDBComboBox
        Left = 109
        Top = 70
        Width = 145
        Height = 23
        Style = csDropDownList
        DataField = 'Tipo_Software'
        DataSource = DM.DSSoftware
        Items.Strings = (
          'Office'
          'ERP'
          'CRM'
          'An'#225'lise'
          'Log'#237'stica'
          'BI'
          'Dashboard'
          'Sistema Operacional'
          'Ferramentas')
        TabOrder = 4
      end
      object Panel3: TPanel
        Left = 6
        Top = 68
        Width = 97
        Height = 25
        BevelKind = bkFlat
        BevelOuter = bvNone
        Caption = 'Tipo Software:'
        TabOrder = 5
      end
      object DBComboBox_Tipo_Licenca: TDBComboBox
        Left = 109
        Top = 101
        Width = 145
        Height = 23
        Style = csDropDownList
        DataField = 'Tipo_Licenca'
        DataSource = DM.DSSoftware
        Items.Strings = (
          'Chave')
        TabOrder = 6
      end
      object Panel4: TPanel
        Left = 6
        Top = 99
        Width = 97
        Height = 25
        BevelKind = bkFlat
        BevelOuter = bvNone
        Caption = 'Tipo Licen'#231'a:'
        TabOrder = 7
      end
      object Panel5: TPanel
        Left = 6
        Top = 131
        Width = 97
        Height = 25
        BevelKind = bkFlat
        BevelOuter = bvNone
        Caption = 'Marca:'
        TabOrder = 8
      end
      object DBEdit_Marca: TDBEdit
        Left = 109
        Top = 133
        Width = 254
        Height = 23
        DataField = 'Marca'
        DataSource = DM.DSSoftware
        TabOrder = 9
      end
      object Panel8: TPanel
        Left = 6
        Top = 202
        Width = 97
        Height = 25
        BevelKind = bkFlat
        BevelOuter = bvNone
        Caption = 'Observa'#231#227'o:'
        TabOrder = 10
      end
      object DBMemo_Observacao: TDBMemo
        Left = 109
        Top = 202
        Width = 490
        Height = 89
        DataField = 'Observacao'
        DataSource = DM.DSSoftware
        TabOrder = 11
      end
      object Panel9: TPanel
        Left = 6
        Top = 163
        Width = 97
        Height = 25
        BevelKind = bkFlat
        BevelOuter = bvNone
        Caption = 'Status:'
        TabOrder = 12
      end
      object DBComboBox_Status: TDBComboBox
        Left = 109
        Top = 165
        Width = 145
        Height = 23
        Style = csDropDownList
        DataField = 'Status'
        DataSource = DM.DSSoftware
        Items.Strings = (
          'Ativo'
          'Inativo')
        TabOrder = 13
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Licen'#231'as'
      ImageIndex = 1
      object Label2: TLabel
        Left = 3
        Top = 5
        Width = 64
        Height = 21
        Caption = 'Licen'#231'as'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object cxButton_Novo: TBitBtn
        Left = 325
        Top = 3
        Width = 90
        Height = 25
        Caption = 'Novo'
        TabOrder = 0
        OnClick = cxButton_NovoClick
      end
      object cxButton_Editar: TBitBtn
        Left = 421
        Top = 3
        Width = 90
        Height = 25
        Caption = 'Editar'
        TabOrder = 1
        OnClick = cxButton_EditarClick
      end
      object cxButton4: TBitBtn
        Left = 517
        Top = 3
        Width = 90
        Height = 25
        Caption = 'Excluir'
        TabOrder = 2
        OnClick = cxButton4Click
      end
      object DBGrid1: TDBGrid
        Left = 3
        Top = 34
        Width = 603
        Height = 262
        DataSource = DM.DSSoftware_Licenca
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
            FieldName = 'Chave'
            Width = 300
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Data_Compra'
            Title.Caption = 'Compra'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Data_Suporte'
            Title.Caption = 'Suporte'
            Width = 100
            Visible = True
          end>
      end
    end
  end
end
