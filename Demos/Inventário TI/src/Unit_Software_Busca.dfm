object Form_Software_Busca: TForm_Software_Busca
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Invent'#225'rio TI - Softwares'
  ClientHeight = 584
  ClientWidth = 850
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  DesignSize = (
    850
    584)
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 88
    Height = 25
    Caption = 'Softwares'
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
    Caption = 'Busca:'
    TabOrder = 0
  end
  object Edit_Buscar: TEdit
    Left = 95
    Top = 44
    Width = 234
    Height = 23
    TabOrder = 1
  end
  object cxButton_Buscar: TBitBtn
    Left = 335
    Top = 42
    Width = 90
    Height = 25
    Caption = 'Buscar'
    TabOrder = 2
    OnClick = cxButton_BuscarClick
  end
  object cxButton_Opcoes: TBitBtn
    Left = 447
    Top = 42
    Width = 90
    Height = 25
    Caption = 'Op'#231#245'es'
    TabOrder = 3
  end
  object cxButton_Novo: TBitBtn
    Left = 559
    Top = 42
    Width = 90
    Height = 25
    Caption = 'Novo'
    TabOrder = 4
    OnClick = cxButton_NovoClick
  end
  object cxButton_Editar: TBitBtn
    Left = 655
    Top = 42
    Width = 90
    Height = 25
    Caption = 'Editar'
    TabOrder = 5
    OnClick = cxButton_EditarClick
  end
  object cxButton4: TBitBtn
    Left = 751
    Top = 42
    Width = 90
    Height = 25
    Caption = 'Excluir'
    TabOrder = 6
    OnClick = cxButton4Click
  end
  object DBGrid1: TDBGrid
    Left = 10
    Top = 73
    Width = 824
    Height = 499
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = DM.DSSoftware
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 7
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnDblClick = DBGrid1DblClick
    Columns = <
      item
        Expanded = False
        FieldName = 'Auto_Codigo'
        Title.Caption = 'C'#243'digo'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Nome'
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Marca'
        Width = 120
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Tipo_Software'
        Title.Caption = 'Tipo Software'
        Width = 120
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
