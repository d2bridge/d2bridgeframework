unit Unit_Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Menus, D2Bridge.Forms, Vcl.Imaging.pngimage, Vcl.ExtCtrls; //Declare D2Bridge.Forms always in the last unit

type
  TForm_Login = class(TD2BridgeForm)
    Panel1: TPanel;
    Image_Logo: TImage;
    Label_Login: TLabel;
    Edit_UserName: TEdit;
    Edit_Password: TEdit;
    Button_Login: TButton;
    Image_BackGround: TImage;
    Button_LoginGoogle: TButton;
    Button_LoginMicrosoft: TButton;
    procedure Button_LoginClick(Sender: TObject);
    procedure Button_LoginGoogleClick(Sender: TObject);
    procedure Button_LoginMicrosoftClick(Sender: TObject);
  private

  public

  protected
   procedure ExportD2Bridge; override;
   procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
   procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
  end;

Function Form_Login: TForm_Login;

implementation

Uses
   AuthenticationWebApp, Unit1;

Function Form_Login: TForm_Login;
begin
 Result:= TForm_Login(TForm_Login.GetInstance);
end;

{$R *.dfm}

{ TForm_Login }

procedure TForm_Login.Button_LoginClick(Sender: TObject);
begin
 //Your Code

 //***EXAMPLE***
 if (Edit_UserName.Text = 'admin') and (Edit_Password.Text = 'admin') then
 begin
  Authentication.UserLoginMode:='Manual';

  Authentication.UserID:= '';
  Authentication.UserName:= Edit_UserName.Text;
  Authentication.UserEmail:= '';
  Authentication.UserURLPicture:= '';

  if Form1 = nil then
   TForm1.CreateInstance;
  Form1.Show;
 end else
 begin
  D2Bridge.Validation(Edit_UserName, false);
  D2Bridge.Validation(Edit_Password, false, 'Invalid username or password');
  Exit;
 end;

end;

procedure TForm_Login.Button_LoginGoogleClick(Sender: TObject);
begin
 Authentication.UserLoginMode:='Google';

 With D2Bridge.API.Auth.Google.Login do
 begin
  if Success then
  begin
   Authentication.UserID:= ID;
   Authentication.UserName:= Name;
   Authentication.UserEmail:= Email;
   Authentication.UserURLPicture:= URLPicture;

   if Form1 = nil then
    TForm1.CreateInstance;

   Form1.Show;
  end;
 end;
end;

procedure TForm_Login.Button_LoginMicrosoftClick(Sender: TObject);
begin
 Authentication.UserLoginMode:='Microsoft';

 With D2Bridge.API.Auth.Microsoft.Login do
 begin
  if Success then
  begin
   Authentication.UserID:= ID;
   Authentication.UserName:= Name;
   Authentication.UserEmail:= Email;
   Authentication.UserURLPicture:= PictureBase64;

   if Form1 = nil then
    TForm1.CreateInstance;

   Form1.Show;
  end;
 end;
end;

procedure TForm_Login.ExportD2Bridge;
begin
 inherited;

 Title:= 'My D2Bridge Web Application';
 SubTitle:= 'My WebApp';

 //Background color
 D2Bridge.HTML.Render.BodyStyle:= 'background-color: #f0f0f0;';

 //TemplateClassForm:= TD2BridgeFormTemplate;
 D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '';
 D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

 //Export yours Controls
 with D2Bridge.Items.add do
 begin
  //Image Backgroup Full Size *Use also ImageFromURL...
  ImageFromTImage(Image_BackGround, CSSClass.Image.Image_BG20_FullSize);

  with Card do
  begin
   CSSClasses:= CSSClass.Card.Card_Center;

   ImageICOFromTImage(Image_Logo, CSSClass.Col.ColSize4);

   with BodyItems.Add do
   begin
    with Row.Items.Add do
     VCLObj(Label_Login);

    with Row.Items.Add do
     VCLObj(Edit_UserName, 'ValidationLogin', true);
    with Row.Items.Add do
     VCLObj(Edit_Password, 'ValidationLogin', true);
    with Row.Items.Add do
     VCLObj(Button_Login, 'ValidationLogin', false);
    with Row.Items.Add do

     VCLObj(Button_LoginGoogle, CSSClass.Button.google);
    with Row.Items.Add do
     VCLObj(Button_LoginMicrosoft, CSSClass.Button.microsoft);

   end;
  end;
 end;
end;

procedure TForm_Login.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
 inherited;

end;

procedure TForm_Login.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string);
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
