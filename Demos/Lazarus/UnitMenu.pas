unit UnitMenu;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, Graphics, Dialogs, Menus, StdCtrls,
  D2Bridge.Forms; //Declare D2Bridge.Forms always in the last unit

type

  { TFormMenu }

  TFormMenu = class(TD2BridgeForm)
    CoreModules1: TMenuItem;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    Module11: TMenuItem;
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure Module11Click(Sender: TObject);
  private

  protected
   procedure ExportD2Bridge; override;
   procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
  public
   procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
  end;

  Function FormMenu: TFormMenu;

implementation

Uses
   LazarusWebApp, UnitControls, UnitDBGrid, unitStringGrid, UnitQRCode,
   unitCardGridDataModel, unitKanban, unitQRCodeReader, unitCamera,
   unitMarkDownEditor, UnitWYSIWYGEditor;

{$R *.lfm}

{ TFormMenu }

Function FormMenu: TFormMenu;
begin
 Result:= (TFormMenu.GetInstance as TFormMenu);
end;

procedure TFormMenu.Module11Click(Sender: TObject);
begin
 if FormControls = nil then
  TFormControls.CreateInstance;
 FormControls.Show;
end;

procedure TFormMenu.MenuItem1Click(Sender: TObject);
begin
 if FormDBGrid = nil then
  TFormDBGrid.CreateInstance;
 FormDBGrid.Show;
end;

procedure TFormMenu.MenuItem10Click(Sender: TObject);
begin
 if FormMarkDownEditor = nil then
  TFormMarkDownEditor.CreateInstance;
 FormMarkDownEditor.Show;
end;

procedure TFormMenu.MenuItem11Click(Sender: TObject);
begin
 if FormWYSIWYGEditor = nil then
  TFormWYSIWYGEditor.CreateInstance;
 FormWYSIWYGEditor.Show;

end;

procedure TFormMenu.MenuItem2Click(Sender: TObject);
begin
 if FormStringGrid = nil then
  TFormStringGrid.CreateInstance;
 FormStringGrid.Show;

end;

procedure TFormMenu.MenuItem3Click(Sender: TObject);
begin
 if FormQRCode = nil then
  TFormQRCode.CreateInstance;
 FormQRCode.Show;
end;

procedure TFormMenu.MenuItem4Click(Sender: TObject);
begin
 if FormCardGridDataModel = nil then
  TFormCardGridDataModel.CreateInstance;
 FormCardGridDataModel.Show;
end;

procedure TFormMenu.MenuItem5Click(Sender: TObject);
begin
 if FormKanban = nil then
  TFormKanban.CreateInstance;
 FormKanban.Show;
end;

procedure TFormMenu.MenuItem6Click(Sender: TObject);
begin
 PrismSession.Close(true);
end;

procedure TFormMenu.MenuItem7Click(Sender: TObject);
begin
 if FormQRCodeReader = nil then
  TFormQRCodeReader.CreateInstance;
 FormQRCodeReader.Show;
end;

procedure TFormMenu.MenuItem8Click(Sender: TObject);
begin
 if FormCamera = nil then
  TFormCamera.CreateInstance;
 FormCamera.Show;
end;

procedure TFormMenu.ExportD2Bridge;
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
   SideMenu(MainMenu1);
  end;
end;

procedure TFormMenu.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
  inherited;

  if PrismControl.VCLComponent = MainMenu1 then
   with PrismControl.AsSideMenu do
   begin
    MenuItemFromCaption('Controls').Icon:= 'fa-solid fa-gamepad';
    MenuItemFromCaption('Grids').Icon:= 'fa-solid fa-table-cells';
    MenuItemFromCaption('DBGrid').Icon:= 'fa-solid fa-square-binary';
    MenuItemFromCaption('StringGrid').Icon:= 'fa-solid fa-table-cells-large';
    MenuItemFromCaption('QRCode').Icon:= 'fa-solid fa-qrcode';
    MenuItemFromCaption('Card Grid Data Model').Icon:= 'fa-solid fa-address-card';
    MenuItemFromCaption('Kanban').Icon:= 'fa-solid fa-table-list';
    MenuItemFromCaption('Editors').Icon:= 'fa-solid fa-font';
    MenuItemFromCaption('MarkDown').Icon:= 'fa-brands fa-markdown';
    MenuItemFromCaption('WYSIWYG').Icon:= 'fa-brands fa-html5';
    MenuItemFromCaption('QRCode Reader').Icon:= 'fa-solid fa-barcode';
    MenuItemFromCaption('Camera').Icon:= 'fa-solid fa-camera';
    MenuItemFromCaption('Close Session').Icon:= 'fa-solid fa-person-walking-dashed-line-arrow-right';
   end;

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

procedure TFormMenu.RenderD2Bridge(const PrismControl: TPrismControl;
  var HTMLControl: string);
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

