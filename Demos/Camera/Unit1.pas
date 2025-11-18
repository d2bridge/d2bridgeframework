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
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Module11Click(Sender: TObject);
  private
    procedure UpdateCameraList(Sender: TObject);
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
   CameraWebApp;

Function Form1: TForm1;
begin
 Result:= TForm1(TForm1.GetInstance);
end;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
 Image1.Camera.OnChangeDevices:= UpdateCameraList;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 if not Image1.Camera.Allowed then
  Image1.Camera.RequestPermission;

 Image1.Camera.Start;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 Image1.Camera.Stop;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 Image1.Camera.TakePicture;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
 if not Image1.Camera.Allowed then
  Image1.Camera.RequestPermission;

 Image1.Camera.RecordVideo;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
 Image1.Camera.SaveVideo;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
 Image1.Camera.CancelVideo;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
 Image1.Camera.RequestPermission;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
 if ComboBox1.Items.Count > 0 then
 begin
  Image1.Camera.CurrentDevice:= Image1.Camera.Devices.ItemFromIndex(ComboBox1.ItemIndex);

  //ShowMessage('new camera "' + Image1.Camera.CurrentDevice.Name + '" selected');

  //Modify camera now
  if Image1.Camera.Started then
  begin
   Image1.Camera.Stop;
   Image1.Camera.Start;
  end;
 end;
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
   Col6.Add.Camera(Image1);

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

   ColAuto.Items.Add.VCLObj(Button3, CSSClass.Button.camera);

   with ColAuto.Items.Add do
   begin
    VCLObj(Button4, CSSClass.Button.video);
    VCLObj(Button5, CSSClass.Button.videofile);
    VCLObj(Button6, CSSClass.Button.videoNo);
   end;
  end;
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

procedure TForm1.Module11Click(Sender: TObject);
begin
 Form1.Show;
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

 if Image1.Camera.Devices.Count > 0 then
 begin
  for I := 0 to Pred(Image1.Camera.Devices.Count) do
   ComboBox1.Items.Add(Image1.Camera.Devices.Items[I].Name);

  ComboBox1.ItemIndex:= Image1.Camera.CurrentDeviceIndex;
 end;

end;

procedure TForm1.Upload(AFiles: TStrings; Sender: TObject);
begin
 inherited;

 ShowMessage('New file received on '+ ExtractFileName(AFiles[0]), true, true);

 //Example identify sender
 {
 if Sender is TPrismControl then
  if (Sender as TPrismControl).VCLComponent = Image1 then
  begin
   ///
  end;
 }
end;

end.
