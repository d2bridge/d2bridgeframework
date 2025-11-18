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
    Image1: TImage;
    ComboBox1: TComboBox;
    Button8: TButton;
    Button7: TButton;
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure Module11Click(Sender: TObject);
  private
    procedure UpdateCameraList(Sender: TObject);
    procedure OnQRCodeReader(ACode: string);
  public

  protected
   procedure ExportD2Bridge; override;
   procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
   procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
  end;

Function Form1: TForm1;

implementation

Uses
   QRCodeReaderWebApp;

Function Form1: TForm1;
begin
 Result:= TForm1(TForm1.GetInstance);
end;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
 Memo1.Text:= '';

 if not Image1.QRCodeReader.Allowed then
  Image1.QRCodeReader.RequestPermission;

 Image1.QRCodeReader.Start;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 Image1.QRCodeReader.Stop;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
 Image1.QRCodeReader.RequestPermission;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
 if ComboBox1.Items.Count > 0 then
 begin
  Image1.QRCodeReader.CurrentDevice:= Image1.QRCodeReader.Devices.ItemFromIndex(ComboBox1.ItemIndex);

  //ShowMessage('new camera "' + Image1.QRCodeReader.CurrentDevice.Name + '" selected');

  //Modify QRCodeReader now
  if Image1.QRCodeReader.Started then
  begin
   Image1.QRCodeReader.Stop;
   Image1.QRCodeReader.Start;
  end;
 end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 Image1.QRCodeReader.OnChangeDevices:= UpdateCameraList;
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
  VCLObj(Label1);
  VCLObj(Label2);
  VCLObj(Label3);

  with Row(CSSClass.Col.Align.center).Items.Add do
  begin
   Col4.Add.QRCodeReader(Image1, Memo1);
   //*****Or use Event
   //Col4.Add.QRCodeReader(Image1, OnQRCodeReader)

   {
    *** Options Example ***

    With Col4.Add.QRCodeReader(Image1, OnQRCodeReader) do
    begin
     //--> Shaders code limit
     BorderShaders:= true/false;

     //--> Scan not stop on Read
     ContinuousScan:= true/false;

     //--> Send ENTER on Read the code
     PressReturnKey:= true/false;

     //--> Enable All Code Format
     EnableAllCodesFormat;

     //--> Disable All Code Format
     DisableAllCodesFormat;

     //--> Enable / Disable Code Types
     PressReturnKey:= true/false;
     TextVCLComponent:= true/false;
     EnableQRCODE:= true/false;
     EnableAZTEC:= true/false;
     EnableCODABAR:= true/false;
     EnableCODE39:= true/false;
     EnableCODE93:= true/false;
     EnableCODE128:= true/false;
     EnableDATAMATRIX:= true/false;
     EnableMAXICODE:= true/false;
     EnableITF:= true/false;
     EnableEAN13:= true/false;
     EnableEAN8:= true/false;
     EnablePDF417:= true/false;
     EnableRSS14:= true/false;
     EnableRSSEXPANDED:= true/false;
     EnableUPCA:= true/false;
     EnableUPCE:= true/false;
     EnableUPCEANEXTENSION:= true/false;
    end;
   }
  end;

  with Row(CSSClass.Col.Align.center).Items.Add do
  begin
   with ColAuto.Items.Add do
   begin
    VCLObj(ComboBox1);
    VCLObj(Button8, CSSClass.Button.select);
   end;
  end;

  with Row(CSSClass.Col.Align.center).Items.Add do
  begin
   with ColAuto.Items.Add do
   begin
    VCLObj(Button7, CSSClass.Button.userSecurity);
    VCLObj(Button1, CSSClass.Button.start);
    VCLObj(Button2, CSSClass.Button.stop);
   end;
  end;

  with Row(CSSClass.Col.Align.center).Items.Add do
   FormGroup('Last Code Read', CSSClass.Col.colsize8).AddVCLObj(Memo1);
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

procedure TForm1.Memo1Change(Sender: TObject);
begin
 ShowMessage('New Code Read!', true, true);
end;

procedure TForm1.Module11Click(Sender: TObject);
begin
 Form1.Show;
end;

procedure TForm1.OnQRCodeReader(ACode: string);
begin
 Memo1.Text:= ACode;
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

//Your can use also update camera list in onActivate event
procedure TForm1.UpdateCameraList(Sender: TObject);
var
 I: Integer;
begin
 ComboBox1.Items.Clear;

 if Image1.QRCodeReader.Devices.Count > 0 then
 begin
  for I := 0 to Pred(Image1.QRCodeReader.Devices.Count) do
   ComboBox1.Items.Add(Image1.QRCodeReader.Devices.Items[I].Name);

  ComboBox1.ItemIndex:= Image1.QRCodeReader.CurrentDeviceIndex;
 end;

end;

end.
