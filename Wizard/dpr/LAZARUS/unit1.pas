unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, Graphics, Dialogs, Menus, StdCtrls,
  D2Bridge.Forms; //Declare D2Bridge.Forms always in the last unit

type

  { TForm1 }

  TForm1 = class(TD2BridgeForm)
    AppModule21: TMenuItem;
    CoreModule11: TMenuItem;
    CoreModule21: TMenuItem;
    CoreModules1: TMenuItem;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MainMenu1: TMainMenu;
    Module11: TMenuItem;
    Module12: TMenuItem;
    Module21: TMenuItem;
    Modules1: TMenuItem;
    SubModule11: TMenuItem;
    SubModule21: TMenuItem;
    SubModule31: TMenuItem;
    SubModules1: TMenuItem;
    procedure Module11Click(Sender: TObject);
  private

  protected
   procedure ExportD2Bridge; override;
   procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
   procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
  public

  end;

  Function Form1: TForm1;

implementation

Uses
   {ProjectName}WebApp;

{$R *.lfm}

{ TForm1 }

Function Form1: TForm1;
begin
 Result:= (TForm1.GetInstance as TForm1);
end;

procedure TForm1.Module11Click(Sender: TObject);
begin
  Form1.Show;
end;

procedure TForm1.ExportD2Bridge;
begin
  inherited;

  Title:= 'My D2Bridge Web Application';
  SubTitle:= 'My WebApp';

  //TemplateClassForm:= TD2BridgeFormTemplate;
  D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '{TemplateMasterHTMLFile}';
  D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '{TemplateHTMLFile}';

  //Export yours Controls
  with D2Bridge.Items.add do
  begin
   {MENU};
   LCLObj(Label1);
   LCLObj(Label2);
   LCLObj(Label3);
  end;
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

procedure TForm1.RenderD2Bridge(const PrismControl: TPrismControl;
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

