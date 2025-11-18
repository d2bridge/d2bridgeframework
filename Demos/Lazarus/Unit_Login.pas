unit Unit_Login;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes,
  Graphics, Controls, Forms, Dialogs, StdCtrls,
  Menus, D2Bridge.Forms, ExtCtrls; //Declare D2Bridge.Forms always in the last unit

type

  { TForm_Login }

  TForm_Login = class(TD2BridgeForm)
   Button_ShowPass: TButton;
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
    procedure Button_ShowPassClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private

  public

  protected
   procedure PageLoaded; override;
   procedure ExportD2Bridge; override;
   procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
   procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
  end;

Function Form_Login: TForm_Login;

implementation

uses
  LazarusWebApp, Lazarus_Session, unitAuth, UnitControls, Prism.Session, Prism.BaseClass;

Function Form_Login: TForm_Login;
begin
 Result:= TForm_Login(TForm_Login.GetInstance);
end;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

{ TForm_Login }

procedure TForm_Login.Button_LoginClick(Sender: TObject);
begin
 LazarusDemo.UserLoginMode:='Manual';

 //***EXAMPLE***
 if (Edit_UserName.Text = 'admin') and (Edit_Password.Text = 'admin') then
 begin
  LazarusDemo.UserID:= '';
  LazarusDemo.UserName:= Edit_UserName.Text;
  LazarusDemo.UserEmail:= '';
  LazarusDemo.UserURLPicture:= '';

  PrismSession.Cookies.Add('UserLogin', PrismSession.UUID);

  if FormControls = nil then
   TFormControls.CreateInstance;
  FormControls.Show;
 end else
 begin
  D2Bridge.Validation(Edit_UserName, false);
  D2Bridge.Validation(Edit_Password, false, 'Invalid username or password');
  Exit;
 end;

end;

procedure TForm_Login.Button_LoginGoogleClick(Sender: TObject);
begin
 LazarusDemo.UserLoginMode:='Google';

 With D2Bridge.API.Auth.Google.Login do
 begin
  if Success then
  begin
   LazarusDemo.UserID:= ID;
   LazarusDemo.UserName:= Name;
   LazarusDemo.UserEmail:= Email;
   LazarusDemo.UserURLPicture:= URLPicture;

   PrismSession.Cookies.Add('UserLogin', PrismSession.UUID);

   if FormAuth = nil then
    TFormAuth.CreateInstance;

   FormAuth.Show;
  end;
 end;
end;

procedure TForm_Login.Button_LoginMicrosoftClick(Sender: TObject);
begin
 LazarusDemo.UserLoginMode:='Microsoft';

 With D2Bridge.API.Auth.Microsoft.Login do
 begin
  if Success then
  begin
   LazarusDemo.UserID:= ID;
   LazarusDemo.UserName:= Name;
   LazarusDemo.UserEmail:= Email;
   LazarusDemo.UserURLPicture:= PictureBase64;

   PrismSession.Cookies.Add('UserLogin', PrismSession.UUID);

   if FormAuth = nil then
    TFormAuth.CreateInstance;

   FormAuth.Show;
  end;
 end;
end;

procedure TForm_Login.Button_ShowPassClick(Sender: TObject);
begin
 if Edit_Password.PasswordChar = '*' then
 begin
  Edit_Password.PasswordChar:= #0;

  if IsD2BridgeContext then
   D2Bridge.PrismControlFromVCLObj(Edit_Password).AsEdit.DataType:= TPrismFieldType.PrismFieldTypeString;
 end else
 begin
  Edit_Password.PasswordChar:= '*';

  if IsD2BridgeContext then
   D2Bridge.PrismControlFromVCLObj(Edit_Password).AsEdit.DataType:= TPrismFieldType.PrismFieldTypePassword;
 end;

end;

procedure TForm_Login.FormActivate(Sender: TObject);
begin
 if IsDebuggerPresent then
 begin
  Edit_UserName.Text:= 'admin';
  Edit_Password.Text:= 'admin';
 end;

 ShowMessage('Use for login: Admin and for Password: Admin', true, true);
end;

procedure TForm_Login.PageLoaded;
var
  vPrismSession: TPrismSession;
  vLazarusDemoSession: TLazarusDemoSession;
begin
  inherited;

  //if PrismBaseClass.Sessions.Exist(PrismSession.Cookies.GetCookieValue('UserLogin')) then
  //begin
  //  vPrismSession:= PrismBaseClass.Sessions.Item[PrismSession.Cookies.GetCookieValue('UserLogin')] as TPrismSession;
  //
  //  vLazarusDemoSession:= TLazarusDemoSession(vPrismSession.Data);
  //
  //  LazarusDemo.UserLoginMode:=  vLazarusDemoSession.UserLoginMode;
  //  LazarusDemo.UserID:=         vLazarusDemoSession.UserID;
  //  LazarusDemo.UserName:=       vLazarusDemoSession.UserName;
  //  LazarusDemo.UserEmail:=      vLazarusDemoSession.UserEmail;
  //  LazarusDemo.UserURLPicture:= vLazarusDemoSession.UserURLPicture;
  //
  //  PrismSession.Cookies.Add('UserLogin', PrismSession.UUID);
  //
  //  if FormControls = nil then
  //    TFormControls.CreateInstance;
  //
  //  FormControls.Show;
  //end;
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
     Col.Add.VCLObj(Label_Login);

    with Row.Items.Add do
     Col.Add.VCLObj(Edit_UserName, 'ValidationLogin', true);

    with Row.Items.Add do
     with Col.Items.add do //Example Edit + Button same row and col
     begin
      VCLObj(Edit_Password, 'ValidationLogin', true);
      VCLObj(Button_ShowPass, CSSClass.Button.view);
     end;

    with Row.Items.Add do
     Col.Add.VCLObj(Button_Login, 'ValidationLogin', false, CSSClass.Col.colsize12);

    with Row.Items.Add do
     Col.Add.VCLObj(Button_LoginGoogle, 'ValidationLogin', false, CSSClass.Button.google + ' ' + CSSClass.Col.colsize12);

    with Row.Items.Add do
     Col.Add.VCLObj(Button_LoginMicrosoft, 'ValidationLogin', false, CSSClass.Button.microsoft + ' ' + CSSClass.Col.colsize12);
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
