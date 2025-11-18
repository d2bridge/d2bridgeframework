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
    Button_ShowPass: TButton;
    procedure Button_LoginClick(Sender: TObject);
    procedure Button_ShowPassClick(Sender: TObject);
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
   {ProjectName}WebApp, Unit1;

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
  if Form1 = nil then
   TForm1.CreateInstance;
  Form1.Show;
 end else
 begin
  if IsD2BridgeContext then
  begin
   D2Bridge.Validation(Edit_UserName, false);
   D2Bridge.Validation(Edit_Password, false, 'Invalid username or password');
  end else
   MessageDlg('Invalid username or password', TMsgDlgType.mtWarning, [mbok], 0);
	 
  Exit;
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
