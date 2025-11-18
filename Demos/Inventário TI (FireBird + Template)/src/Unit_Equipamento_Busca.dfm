object Form_Equipamento_Busca: TForm_Equipamento_Busca
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Invent'#225'rio TI - Equipamentos'
  ClientHeight = 652
  ClientWidth = 950
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 19
  object Label1: TLabel
    Left = 9
    Top = 9
    Width = 148
    Height = 30
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Equipamentos'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -22
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 9
    Top = 47
    Width = 92
    Height = 29
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    BevelKind = bkFlat
    BevelOuter = bvNone
    Caption = 'Busca:'
    TabOrder = 0
  end
  object Edit_Buscar: TEdit
    Left = 107
    Top = 48
    Width = 264
    Height = 27
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 1
  end
  object cxButton_Buscar: TBitBtn
    Left = 379
    Top = 46
    Width = 102
    Height = 29
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Buscar'
    TabOrder = 2
    OnClick = cxButton_BuscarClick
  end
  object cxButton_Opcoes: TBitBtn
    Left = 503
    Top = 46
    Width = 102
    Height = 29
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Op'#231#245'es'
    TabOrder = 3
    OnClick = cxButton_OpcoesClick
  end
  object cxButton_Novo: TBitBtn
    Left = 629
    Top = 47
    Width = 102
    Height = 29
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Novo'
    TabOrder = 4
    OnClick = cxButton_NovoClick
  end
  object cxButton3: TBitBtn
    Left = 739
    Top = 47
    Width = 102
    Height = 29
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Editar'
    TabOrder = 5
    OnClick = cxButton3Click
  end
  object cxButton4: TBitBtn
    Left = 844
    Top = 46
    Width = 101
    Height = 29
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Excluir'
    TabOrder = 6
    OnClick = cxButton4Click
  end
  object DBGrid1: TDBGrid
    Left = 9
    Top = 84
    Width = 936
    Height = 561
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    DataSource = DM.DSEquipamento
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 7
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -14
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnDblClick = DBGrid1DblClick
    Columns = <
      item
        Expanded = False
        FieldName = 'AUTO_CODIGO'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        Title.Caption = 'Codigo'
        Width = 68
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NOME'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        Width = 450
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MARCA'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        Width = 135
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SETOR'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        Width = 169
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'STATUS'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        Width = 135
        Visible = True
      end>
  end
  object cxButton_Sair: TBitBtn
    Left = 844
    Top = 9
    Width = 101
    Height = 29
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Sair'
    TabOrder = 8
    OnClick = cxButton_SairClick
  end
  object PopupMenu_Opcoes: TPopupMenu
    Left = 496
    Top = 213
    object MensagemOk1: TMenuItem
      Caption = 'Mensagem 1'
      OnClick = MensagemOk1Click
    end
    object Mensagem21: TMenuItem
      Caption = 'Mensagem 2'
      OnClick = Mensagem21Click
    end
  end
end
