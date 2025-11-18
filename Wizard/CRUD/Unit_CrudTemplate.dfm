object Form_CrudTemplate: TForm_CrudTemplate
  Left = 0
  Top = 0
  Caption = 'FormCrudTemplate'
  ClientHeight = 577
  ClientWidth = 829
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 14
  object Crud_PageControl: TPageControl
    Left = 0
    Top = 60
    Width = 829
    Height = 517
    ActivePage = Crud_TabSheetSearch
    Align = alClient
    TabOrder = 0
    object Crud_TabSheetSearch: TTabSheet
      Caption = 'Search'
      DesignSize = (
        821
        488)
      object Crud_PanelSearchFor: TPanel
        Left = 8
        Top = 8
        Width = 81
        Height = 23
        Caption = 'Search:'
        TabOrder = 0
      end
      object Crud_EditSearch: TEdit
        Left = 95
        Top = 8
        Width = 197
        Height = 22
        TabOrder = 1
      end
      object Crud_ButtonSearch: TButton
        Left = 298
        Top = 7
        Width = 87
        Height = 25
        Caption = 'Find'
        TabOrder = 2
        OnClick = Crud_ButtonSearchClick
      end
      object Crud_ButtonNew: TButton
        Left = 391
        Top = 7
        Width = 82
        Height = 25
        Caption = 'New'
        TabOrder = 3
        OnClick = Crud_ButtonNewClick
      end
      object Crud_DBGrid_Search: TDBGrid
        Left = 3
        Top = 37
        Width = 815
        Height = 449
        Anchors = [akLeft, akTop, akRight, akBottom]
        DataSource = Crud_DSQuery
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        TabOrder = 4
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
    end
    object Crud_TabSheetData: TTabSheet
      Caption = 'Data'
      ImageIndex = 1
      DesignSize = (
        821
        488)
      object Crud_ButtonSave: TButton
        Left = 558
        Top = 5
        Width = 85
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Save'
        TabOrder = 0
        OnClick = Crud_ButtonSaveClick
      end
      object Crud_ButtonDelete: TButton
        Left = 645
        Top = 5
        Width = 85
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Delete'
        TabOrder = 1
        OnClick = Crud_ButtonDeleteClick
      end
      object Crud_ButtonBack: TButton
        Left = 733
        Top = 5
        Width = 85
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Back'
        TabOrder = 2
        OnClick = Crud_ButtonBackClick
      end
    end
  end
  object Crud_PanelTitle: TPanel
    Left = 0
    Top = 0
    Width = 829
    Height = 33
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object Crud_PanelSubTitle: TPanel
    Left = 0
    Top = 33
    Width = 829
    Height = 27
    Align = alTop
    TabOrder = 2
  end
  object Crud_DSQuery: TDataSource
    DataSet = Crud_Query
    Left = 280
    Top = 8
  end
  object Crud_Query: TFDQuery
    Left = 392
    Top = 8
  end
end
