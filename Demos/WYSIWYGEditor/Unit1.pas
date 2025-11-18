unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Menus, D2Bridge.Forms, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Datasnap.DBClient; //Declare D2Bridge.Forms always in the last unit

type
  TForm1 = class(TD2BridgeForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MainMenu1: TMainMenu;
    Module11: TMenuItem;
    AppModule21: TMenuItem;
    Modules1: TMenuItem;
    Module12: TMenuItem;
    Module21: TMenuItem;
    SubModules1: TMenuItem;
    SubModule11: TMenuItem;
    SubModule21: TMenuItem;
    SubModule31: TMenuItem;
    CoreModules1: TMenuItem;
    CoreModule11: TMenuItem;
    CoreModule21: TMenuItem;
    Memo1: TMemo;
    Button2: TButton;
    Button1: TButton;
    DBGrid1: TDBGrid;
    Button3: TButton;
    ClientDataSet1: TClientDataSet;
    ClientDataSet1Title: TStringField;
    DataSource1: TDataSource;
    ClientDataSet1Text: TMemoField;
    Memo2: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Module11Click(Sender: TObject);
  private
    procedure PopuleClientDataSet;
  public

  protected
   procedure Upload(AFiles: TStrings; Sender: TObject); override;
   procedure ExportD2Bridge; override;
   procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
   procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
  end;

Function Form1: TForm1;

implementation

Uses
   WYSIWYGEditorWebApp;

Function Form1: TForm1;
begin
 Result:= TForm1(TForm1.GetInstance);
end;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
 Memo1.Enabled:= not Memo1.Enabled;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 Memo1.ReadOnly:= not Memo1.ReadOnly;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 if ClientDataSet1.State in [dsEdit] then
  ClientDataSet1.Post
 else
  ClientDataSet1.Edit;
end;

{ TForm1 }

procedure TForm1.ExportD2Bridge;
begin
 inherited;

 Title:= 'My D2Bridge Web Application';
 SubTitle:= 'My WebApp';

 //TemplateClassForm:= TD2BridgeFormTemplate;
 D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '';
 D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

 //Export yours Controls
 with D2Bridge.Items.add do
 begin
  VCLObj(MainMenu1);
  VCLObj(Label1);
  VCLObj(Label2);
  VCLObj(Label3);

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

procedure TForm1.FormShow(Sender: TObject);
begin
 PopuleClientDataSet;
end;

procedure TForm1.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
 inherited;

 //Menu example
 {
  if PrismControl.VCLComponent = MainMenu1 then
   PrismControl.AsMainMenu.Title:= 'AppTeste'; //or in SideMenu use asSideMenu

  if PrismControl.VCLComponent = MainMenu1 then
   PrismControl.AsMainMenu.Image.URL:= 'https://d2bridge.com.br/images/LogoD2BridgeTransp.png'; //or in SideMenu use asSideMenu

  //GroupIndex example
  if PrismControl.VCLComponent = MainMenu1 then
   with PrismControl.AsMainMenu do  //or in SideMenu use asSideMenu
   begin
    MenuGroups[0].Caption:= 'Principal';
    MenuGroups[1].Caption:= 'Services';
    MenuGroups[2].Caption:= 'Items';
   end;

  //Chance Icon and Propertys MODE 1 *Using MenuItem component
  PrismControl.AsMainMenu.MenuItemFromVCLComponent(Abrout1).Icon:= 'fa-solid fa-rocket';

  //Chance Icon and Propertys MODE 2 *Using MenuItem name
  PrismControl.AsMainMenu.MenuItemFromName('Abrout1').Icon:= 'fa-solid fa-rocket';
 }

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

procedure TForm1.Module11Click(Sender: TObject);
begin
 Form1.Show;
end;

procedure TForm1.PopuleClientDataSet;
begin
 ClientDataSet1.Close;

 ClientDataSet1.CreateDataSet;

 ClientDataSet1.AppendRecord(['Example 1',
          '<h1><b>Example 1:</b> D2Bridge WYSIWYG Editor</h1><br><p>Welcome to the <strong>D2Bridge</strong> <em>WYSIWYG Editor</em> demo. It provides the following features:</p><ul><li><b>Text formatting</b> with bold, italic, underline</li><li>' + sLineBreak +
          'Live HTML editing</li><li>Supports tables, lists, links</li><li>Image and file insertion</li></ul><br><h2>Editor Highlights</h2><ol><li>Fully integrated with D2Bridge Framework</li><li>Simple and extensible toolbar</li><li>100% HTML output' + sLineBreak +
          '</li></ol><p><img alt="D2Bridge Logo" src="https://d2bridge.com.br/images/LogoD2Bridge.png" style="width:350px"><br></p><br><h3>Delphi Code Example</h3><pre class="language-delphi"><code class="language-delphi hljs">// Render static content' + sLineBreak +
          'WysiwygEditor(Memo1);</code></pre><pre class="language-delphi"><code class="language-delphi hljs">// Render data-aware field' + sLineBreak +
          'WysiwygEditor(DataSource1, ''FieldName'');</code></pre><h3>Features Table</h3><table border="1" cellpadding="5"><tr><th>Feature</th><th>Available</th></tr><tr><td>Bold/Italic</td><td>Yes</td></tr><tr><td>Image Upload</td><td>Yes</td></tr>' + sLineBreak +
          '</table><br>'
        ]);

 ClientDataSet1.AppendRecord(['Example 2',
          '<h1><b>Example 2:</b> D2Bridge Documentation Editor</h1><br><p>This is an example of how the <strong>D2Bridge Editors</strong> editor can be used to write simple documentation:</p><ul><li>Create headings and formatted paragraphs</li><li>' + sLineBreak +
          'Use bullet and numbered lists</li><li>Insert inline code or code blocks</li><li>Embed media and tables</li></ul><br><h2>Highlights</h2><ol><li>Intuitive user interface</li><li>Custom toolbar integration</li><li>Cross-browser support</li>' + sLineBreak +
          '</ol><p><img alt="D2Bridge" src="https://d2bridge.com.br/images/LogoD2Bridge.png" style="width:300px"><br></p><br><h3>Example Snippets</h3><pre class="language-delphi"><code class="language-delphi hljs">// Auto-rendering field content' + sLineBreak +
          'WysiwygEditor(DataSource1, ''FieldName'');</code></pre><pre class="language-delphi"><code class="language-delphi hljs">// Rendering manual content' + sLineBreak +
          'WysiwygEditor(MemoEditor);</code></pre><h3>Output Options</h3><table border="1" cellpadding="5"><tr><th>Output Type</th><th>Status</th></tr><tr><td>HTML Export</td><td>Yes</td></tr><tr><td>Live Preview</td><td>Yes</td></tr></table><br>'
        ]);
end;

procedure TForm1.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string);
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

procedure TForm1.Upload(AFiles: TStrings; Sender: TObject);
begin
 //Handle the attachment here

 //Ex:
 // AFiles[0]:= 'NewLocation\NameFile.jpg';

end;

end.
