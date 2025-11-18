unit UnitWYSIWYGEditor;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
 Classes, SysUtils, DB, BufDataset, Controls, Graphics, Dialogs, StdCtrls, DBGrids,  
 D2Bridge.Forms;

type

 { TFormWYSIWYGEditor }

 TFormWYSIWYGEditor = class(TD2BridgeForm)
  BufDataset1: TBufDataset;
  BufDataset1Text: TStringField;
  BufDataset1Title: TStringField;
  Button1: TButton;
  Button2: TButton;
  Button3: TButton;
  DataSource1: TDataSource;
  DBGrid1: TDBGrid;
  Memo1: TMemo;
  Memo2: TMemo;
  procedure Button1Click(Sender: TObject);
  procedure Button2Click(Sender: TObject);
  procedure Button3Click(Sender: TObject);
  procedure FormCreate(Sender: TObject);
 private
  procedure PopuleData;
 public
  { Public declarations }
 protected
  procedure Upload(AFiles: TStrings; Sender: TObject); override;
  procedure ExportD2Bridge; override;
  procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
  procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
 end;

function FormWYSIWYGEditor: TFormWYSIWYGEditor;

implementation

uses
 LazarusWebApp, D2BridgeFormTemplate;

{$R *.lfm}

function FormWYSIWYGEditor: TFormWYSIWYGEditor;
begin
 result:= (TFormWYSIWYGEditor.GetInstance as TFormWYSIWYGEditor);
end;

procedure TFormWYSIWYGEditor.Button1Click(Sender: TObject);
begin
 Memo1.Enabled:= not Memo1.Enabled;
end;

procedure TFormWYSIWYGEditor.Button2Click(Sender: TObject);
begin
 Memo1.ReadOnly:= not Memo1.ReadOnly;
end;

procedure TFormWYSIWYGEditor.Button3Click(Sender: TObject);
begin
 if BufDataset1.State in [dsEdit] then
  BufDataset1.Post
 else
  BufDataset1.Edit;
end;

procedure TFormWYSIWYGEditor.FormCreate(Sender: TObject);
begin
 PopuleData;
end;

procedure TFormWYSIWYGEditor.PopuleData;
begin
 BufDataset1.Close;

 BufDataset1.CreateDataSet;

 BufDataset1.AppendRecord(['Example 1',
          '<h1><b>Example 1:</b> D2Bridge WYSIWYG Editor</h1><br><p>Welcome to the <strong>D2Bridge</strong> <em>WYSIWYG Editor</em> demo. It provides the following features:</p><ul><li><b>Text formatting</b> with bold, italic, underline</li><li>' + sLineBreak +
          'Live HTML editing</li><li>Supports tables, lists, links</li><li>Image and file insertion</li></ul><br><h2>Editor Highlights</h2><ol><li>Fully integrated with D2Bridge Framework</li><li>Simple and extensible toolbar</li><li>100% HTML output' + sLineBreak +
          '</li></ol><p><img alt="D2Bridge Logo" src="https://d2bridge.com.br/images/LogoD2Bridge.png" style="width:350px"><br></p><br><h3>Delphi Code Example</h3><pre class="language-delphi"><code class="language-delphi hljs">// Render static content' + sLineBreak +
          'WysiwygEditor(Memo1);</code></pre><pre class="language-delphi"><code class="language-delphi hljs">// Render data-aware field' + sLineBreak +
          'WysiwygEditor(DataSource1, ''FieldName'');</code></pre><h3>Features Table</h3><table border="1" cellpadding="5"><tr><th>Feature</th><th>Available</th></tr><tr><td>Bold/Italic</td><td>Yes</td></tr><tr><td>Image Upload</td><td>Yes</td></tr>' + sLineBreak +
          '</table><br>'
        ]);

 BufDataset1.AppendRecord(['Example 2',
          '<h1><b>Example 2:</b> D2Bridge Documentation Editor</h1><br><p>This is an example of how the <strong>D2Bridge Editors</strong> editor can be used to write simple documentation:</p><ul><li>Create headings and formatted paragraphs</li><li>' + sLineBreak +
          'Use bullet and numbered lists</li><li>Insert inline code or code blocks</li><li>Embed media and tables</li></ul><br><h2>Highlights</h2><ol><li>Intuitive user interface</li><li>Custom toolbar integration</li><li>Cross-browser support</li>' + sLineBreak +
          '</ol><p><img alt="D2Bridge" src="https://d2bridge.com.br/images/LogoD2Bridge.png" style="width:300px"><br></p><br><h3>Example Snippets</h3><pre class="language-delphi"><code class="language-delphi hljs">// Auto-rendering field content' + sLineBreak +
          'WysiwygEditor(DataSource1, ''FieldName'');</code></pre><pre class="language-delphi"><code class="language-delphi hljs">// Rendering manual content' + sLineBreak +
          'WysiwygEditor(MemoEditor);</code></pre><h3>Output Options</h3><table border="1" cellpadding="5"><tr><th>Output Type</th><th>Status</th></tr><tr><td>HTML Export</td><td>Yes</td></tr><tr><td>Live Preview</td><td>Yes</td></tr></table><br>'
        ]);
end;

procedure TFormWYSIWYGEditor.Upload(AFiles: TStrings; Sender: TObject);
begin
 //Handle the attachment here

 //Ex:
 // AFiles[0]:= 'NewLocation\NameFile.jpg';
end;

procedure TFormWYSIWYGEditor.ExportD2Bridge;
begin
 inherited;

 Title:= 'My D2Bridge Form';

 TemplateClassForm:= TD2BridgeFormTemplate;
 D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '';
 D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

 with D2Bridge.Items.add do
 begin
  //WYSIWYG with TMemo
  with Row.Items.Add do
   with Col.Add.Card('WYSIWYG Editor').Items.Add do
   begin
    with Row.Items.Add do
    begin
     ColAuto.Add.VCLObj(Button1);
     ColAuto.Add.VCLObj(Button2);
    end;

    with Row.Items.Add do
     Col.Add.WYSIWYGEditor(Memo1, 450);
   end;

  //WYSIWYG Air Mode with TMemo
  with Row.Items.Add do
   with Col.Add.Card('WYSIWYG Editor in Air Mode').Items.Add do
   begin
    with Row.Items.Add do
     Col.Add.WYSIWYGEditor(Memo2, true);
   end;

  with Row.Items.Add do
   with Col.Add.Card('WYSIWYG Editor with Database').Items.Add do
   begin
    with Row.Items.Add do
     ColAuto.Add.VCLObj(Button3);

    with Row.Items.Add do
    begin
     Col4.Add.VCLObj(DBGrid1);
     with Col.Add.WYSIWYGEditor(DataSource1, 'Text') do
     begin
      //Personalize your WYSIWYG
      Height:= 400; //0 is auto
      ShowButtonHelp:= false;
      //ShowButtonUpload:= false;
      //Show......
     end;
    end;
   end;
 end;

end;

procedure TFormWYSIWYGEditor.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
 inherited;

 //Change Init Property of Prism Controls
 {
 if PrismControl.VCLComponent = Edit1 then
  PrismControl.AsEdit.DataType:= TPrismFieldType.PrismFieldTypeInteger;

 if PrismControl.IsDBGrid then
 begin
  PrismControl.AsDBGrid.RecordsPerPage:= 10;
  PrismControl.AsDBGrid.MaxRecords:= 2000;
 end;
 }
end;

procedure TFormWYSIWYGEditor.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string);
begin
 inherited;

 //Intercept HTML
 {
 if PrismControl.VCLComponent = Edit1 then
 begin
  HTMLControl:= '</>';
 end;
 }
end;

end.
