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
    DBGrid1: TDBGrid;
    Button1: TButton;
    Button2: TButton;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    ClientDataSet1Title: TStringField;
    ClientDataSet1Text: TStringField;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
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
   MarkDownEditorWebApp;

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

procedure TForm1.Button4Click(Sender: TObject);
begin

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

  //Markdown with TMemo
  with Row.Items.Add do
   with Col.Add.Card('Markdown Editor').Items.Add do
   begin
    with Row.Items.Add do
    begin
     ColAuto.Add.VCLObj(Button1);
     ColAuto.Add.VCLObj(Button2);
    end;

    with Row.Items.Add do
     Col.Add.MarkdownEditor(Memo1);
   end;

  //Markdown with TMemo
  with Row.Items.Add do
   with Col.Add.Card('Markdown Editor with Database').Items.Add do
   begin
    with Row.Items.Add do
     ColAuto.Add.VCLObj(Button3);

    with Row.Items.Add do
    begin
     Col4.Add.VCLObj(DBGrid1);
     with Col.Add.MarkdownEditor(DataSource1, 'Text') do
     begin
      //Personalize your Markdown
      ShowButtonStrikethrough:= false;
      ShowButtonUpload:= false;
      //Show......
     end;
    end;
   end;
 end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
 PopuleClientDataSet
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
        '# D2Bridge Markdown Editor Documentation                                          ' + sLineBreak +
        '                                                                                  ' + sLineBreak +
        'Welcome to the official documentation for the **D2Bridge Markdown Editor**.       ' + sLineBreak +
        '                                                                                  ' + sLineBreak +
        '## Installation                                                                   ' + sLineBreak +
        '1. **Download D2Bridge** from the official website.                               ' + sLineBreak +
        '2. **Use InstallD2BridgeWizard.exe to install Wizard in your Delphi/Lazarus IDE** ' + sLineBreak +
        '3. **In your IDE use Menu D2Bridge Wizard**                                       '
        ]);

 ClientDataSet1.AppendRecord(['Example 2',
        '# D2Bridge Markdown Editor Documentation' + sLineBreak +
        '                                        ' + sLineBreak +
        '                                        ' + sLineBreak +
        '| Column 1 | Column 2 | Column 3 |      ' + sLineBreak +
        '| -------- | -------- | -------- |      ' + sLineBreak +
        '| Text     | Text     | Text     |      '
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
