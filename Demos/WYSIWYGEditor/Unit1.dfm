object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 569
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
    Width = 247
    Height = 25
    Caption = 'Demo WYSIWYG Editor'
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
    Top = 119
    Width = 601
    Height = 93
    Lines.Strings = (
      
        '<h1><b>D2Bridge</b> WYSIWYG Editor</h1><br><p>Welcome to the <st' +
        'rong>D2Bridge</strong> <em>Summernote</em> editor demo. This edi' +
        'tor allows you to:</p><ul>  <li>Edit rich text</li>  <li><b>Form' +
        'at</b>, <i>style</i>, <u>underline</u></li>  <li>Create lists an' +
        'd tables</li>  <li>Insert links and images</li></ul><br><h2>'#55357#56960' K' +
        'ey Features</h2><ol>  <li>Lightweight and fast</li>  <li>Easy to' +
        ' integrate</li>  <li>Exports clean HTML</li></ol><p>Here is an i' +
        'mage from<br><img style="width: 400px;" src="https://d2bridge.co' +
        'm.br/images/LogoD2Bridge.png"><br></p><br><h3>'#55358#56809' Code Example</h' +
        '3><pre class="language-delphi"><code class="language-delphi hljs' +
        '" data-highlighted="yes"><span class="hljs-comment">//Renderize ' +
        'Memo1 content</span>'
      
        'WysiwygEditor(Memo1);</code></pre><pre class="language-delphi"><' +
        'code class="language-delphi hljs" data-highlighted="yes"><span c' +
        'lass="hljs-comment">//Renderize Dataware </span>'
      
        'WysiwygEditor(DataSource1, <span class="hljs-string">'#39'YourTextFi' +
        'eld'#39'</span>);'
      
        '</code></pre><p><br></p><h3>'#55357#56522' Simple Table</h3><br><table borde' +
        'r="1" cellpadding="5">  <tbody><tr><th>Feature</th><th>Status</t' +
        'h></tr>  <tr><td>Image Upload</td><td>'#9989'</td></tr>  <tr><td>Code ' +
        'Block</td><td>'#9989'</td></tr></tbody></table><br>')
    TabOrder = 0
    WordWrap = False
  end
  object Button2: TButton
    Left = 136
    Top = 88
    Width = 89
    Height = 25
    Caption = 'Edit/ReadOnly'
    TabOrder = 1
    OnClick = Button2Click
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
  object DBGrid1: TDBGrid
    Left = 8
    Top = 408
    Width = 217
    Height = 129
    DataSource = DataSource1
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 3
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
  object Button3: TButton
    Left = 8
    Top = 377
    Width = 122
    Height = 25
    Caption = 'Enable/Disable Editor'
    TabOrder = 4
    OnClick = Button3Click
  end
  object Memo2: TMemo
    Left = 8
    Top = 236
    Width = 601
    Height = 93
    Lines.Strings = (
      
        '<h1><b>D2Bridge</b> WYSIWYG Editor</h1><br><p>Welcome to the <st' +
        'rong>D2Bridge</strong> <em>Example</em> editor demo. This editor' +
        ' allows you to:</p><ul><li>Edit rich text with inline formatting' +
        '</li><li><b>Bold</b>, <i>italic</i>, <u>underline</u>, and more<' +
        '/li><li>Create lists and tables</li><li>Insert links, images, an' +
        'd files</li></ul><br><h2>Key Features</h2><ol><li>Lightweight an' +
        'd fast</li><li>Easy to integrate with D2Bridge</li><li>Supports ' +
        'both full and Air (inline) modes</li></ol><p><strong>Air Mode</s' +
        'trong> allows editing content inline with a floating toolbar, id' +
        'eal for minimal UI integrations where the toolbar appears only w' +
        'hen text is selected.</p><p>Below is an image from D2Bridge:<br>' +
        '<img alt="D2Bridge Logo" src="https://d2bridge.com.br/images/Log' +
        'oD2Bridge.png" style="width:400px"><br></p><br><h3>Delphi Code E' +
        'xample</h3><pre class="language-delphi"><code class="language-de' +
        'lphi hljs">// Render Memo1 content'
      
        'WysiwygEditor(Memo1);</code></pre><pre class="language-delphi"><' +
        'code class="language-delphi hljs">// Render Data-aware field'
      
        'WysiwygEditor(DataSource1, '#39'Text'#39');</code></pre><h3>Simple Table' +
        '</h3><br><table border="1" cellpadding="5"><tr><th>Feature</th><' +
        'th>Status</th></tr><tr><td>Image Upload</td><td>Yes</td></tr><tr' +
        '><td>Air Mode Support</td><td>Yes</td></tr></table><br>')
    TabOrder = 5
    WordWrap = False
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
      600000009619E0BD010000001800000002000000000003000000600005546974
      6C650100490000000100055749445448020002006400045465787404004B0000
      0002000753554254595045020049000500546578740005574944544802000200
      D0070000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'Title'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'Text'
        DataType = ftMemo
        Size = 2000
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 456
    Top = 32
    object ClientDataSet1Title: TStringField
      FieldName = 'Title'
      Size = 100
    end
    object ClientDataSet1Text: TMemoField
      FieldName = 'Text'
      BlobType = ftMemo
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
