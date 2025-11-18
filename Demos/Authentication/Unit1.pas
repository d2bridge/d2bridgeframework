unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Menus, D2Bridge.Forms, Vcl.ExtCtrls; //Declare D2Bridge.Forms always in the last unit

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
    Label_Name: TLabel;
    Label_Email: TLabel;
    Label_ID: TLabel;
    Button_Logout: TButton;
    Label_IDValue: TLabel;
    Image_Photo: TImage;
    Label_NameValue: TLabel;
    Label_EmailValue: TLabel;
    Label_Mode: TLabel;
    Label_ModeValue: TLabel;
    procedure Button_LogoutClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Module11Click(Sender: TObject);
  private

  public

  protected
   procedure ExportD2Bridge; override;
   procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
   procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
       procedure EndRender; override;
  end;

Function Form1: TForm1;

implementation

Uses
   AuthenticationWebApp;

Function Form1: TForm1;
begin
 Result:= TForm1(TForm1.GetInstance);
end;

{$R *.dfm}

procedure TForm1.Button_LogoutClick(Sender: TObject);
begin
 if Authentication.UserLoginMode = 'Google' then
  D2Bridge.API.Auth.Google.Logout
 else
 if Authentication.UserLoginMode = 'Microsoft' then
  D2Bridge.API.Auth.Microsoft.Logout;

 Close;
end;

{ TForm1 }

procedure TForm1.EndRender;
begin
 D2Bridge.PrismControlFromVCLObj(Image_Photo).AsImage.URLImage:= Authentication.UserURLPicture;
end;

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

  with Row.Items.Add do
   with Card('User Information', CSSClass.Col.colsize6) do
   begin
    Title:= 'Bellow about your login';

    with BodyItems.Add do
    begin
     //Image
     with Row.Items.add do
      Col6.Add.VCLObj(Image_Photo);

     //Login Mode
     with Row.Items.add do
     begin
      ColAuto.Add.VCLObj(Label_Mode);
      ColAuto.Add.VCLObj(Label_ModeValue);
     end;

     //ID
     with Row.Items.add do
     begin
      ColAuto.Add.VCLObj(Label_ID);
      ColAuto.Add.VCLObj(Label_IDValue);
     end;

     //User Name
     with Row.Items.add do
     begin
      ColAuto.Add.VCLObj(Label_Name);
      ColAuto.Add.VCLObj(Label_NameValue);
     end;

     //User Email
     with Row.Items.add do
     begin
      ColAuto.Add.VCLObj(Label_Email);
      ColAuto.Add.VCLObj(Label_EmailValue);
     end;

     //Close
     with Row.Items.add do
      ColAuto.Add.VCLObj(Button_Logout, CSSClass.Button.close);
    end;
   end;
 end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
 Label_ModeValue.Caption:= Authentication.UserLoginMode;
 Label_IDValue.Caption:= Authentication.UserID;
 Label_NameValue.Caption:= Authentication.UserName;
 Label_EmailValue.Caption:= Authentication.UserEmail;
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

procedure TForm1.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string);
begin
 inherited;

// if PrismControl.VCLComponent = Image_Photo then
//  with PrismControl.AsImage do
//   URLImage:= Authentication.UserURLPicture;
end;

end.
