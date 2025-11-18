object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 526
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OnShow = FormShow
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 122
    Height = 25
    Caption = 'Hello World'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 39
    Width = 294
    Height = 18
    Caption = 'This app is created with D2Bridge Framework'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 65
    Width = 115
    Height = 13
    Caption = 'by Talis Jonatas  Gomes'
  end
  object Memo1: TMemo
    Left = 8
    Top = 117
    Width = 609
    Height = 185
    Lines.Strings = (
      '# D2Bridge Framework - Markdown Editor'
      ''
      
        'Markdown is a **lightweight markup language** that is easy to us' +
        'e.'
      ''
      '## '#55357#56524' Key Features'
      '- **Bold** '#8594' `**bold text**`'
      '- *Italics* '#8594' `*italic text*`'
      
        '- [Links](https://d2bridge.com.br) '#8594' `[Link Text](https://d2brid' +
        'ge.com.br)`'
      '- Numbered lists:'
      '  1. First item'
      '  2. Second item'
      '  3. Third item'
      '- Bullet point lists:'
      '  - Item A'
      '  - Item B'
      '  - Item C'
      ''
      '## '#55356#57092' Adding Images'
      'To insert an image:'
      '![](https://d2bridge.com.br/images/LogoD2Bridge.png)'
      ''
      '## '#55357#56524' Usage'
      
        'Use direct with TMemo, TLabel, TEdit, TDBMemo, TDBText and TDBEd' +
        'it'
      '```delphi'
      '//Renderize Memo1 content'
      'MarkdownEditor(Memo1);'
      '```'
      ''
      'Use with Datasource (Dataware mode)'
      '```delphi'
      '//Renderize Dataware '
      'MarkdownEditor(DataSource1, '#39'Text'#39');'
      '```')
    TabOrder = 0
    WordWrap = False
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 376
    Width = 217
    Height = 129
    DataSource = DataSource1
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'Title'
        Width = 150
        Visible = True
      end>
  end
  object Button1: TButton
    Left = 8
    Top = 88
    Width = 122
    Height = 25
    Caption = 'Enable/Disable Editor'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 136
    Top = 88
    Width = 89
    Height = 25
    Caption = 'Edit/ReadOnly'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 8
    Top = 345
    Width = 122
    Height = 25
    Caption = 'Enable/Disable Editor'
    TabOrder = 4
    OnClick = Button3Click
  end
  object MainMenu1: TMainMenu
    Left = 360
    Top = 32
    object Module11: TMenuItem
      Caption = 'Main'
      OnClick = Module11Click
    end
    object AppModule21: TMenuItem
      Caption = 'App Module 2'
    end
    object CoreModules1: TMenuItem
      Caption = 'Core Modules'
      object CoreModule11: TMenuItem
        Caption = 'Core Module 1'
      end
      object CoreModule21: TMenuItem
        Caption = 'Core Module 2'
      end
    end
    object Modules1: TMenuItem
      Caption = 'Modules'
      object Module12: TMenuItem
        Caption = 'Module 1'
      end
      object Module21: TMenuItem
        Caption = 'Module 2'
      end
      object SubModules1: TMenuItem
        Caption = 'Sub Modules'
        object SubModule11: TMenuItem
          Caption = 'SubModule 1'
        end
        object SubModule21: TMenuItem
          Caption = 'SubModule 2'
        end
        object SubModule31: TMenuItem
          Caption = 'SubModule 3'
        end
      end
    end
  end
  object ClientDataSet1: TClientDataSet
    PersistDataPacket.Data = {
      4D0000009619E0BD0100000018000000020000000000030000004D0005546974
      6C65010049000000010005574944544802000200640004546578740200490000
      00010005574944544802000200D0070000}
    Active = True
    Aggregates = <>
    Params = <>
    Left = 456
    Top = 32
    object ClientDataSet1Title: TStringField
      FieldName = 'Title'
      Size = 100
    end
    object ClientDataSet1Text: TStringField
      FieldName = 'Text'
      Size = 2000
    end
  end
  object DataSource1: TDataSource
    AutoEdit = False
    DataSet = ClientDataSet1
    Left = 544
    Top = 32
  end
end
