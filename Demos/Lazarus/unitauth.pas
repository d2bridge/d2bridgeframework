unit unitAuth;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
 Classes, SysUtils, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,  
 D2Bridge.Forms;

type

 { TFormAuth }

 TFormAuth = class(TD2BridgeForm)
  Button_Logout: TButton;
  Image_Photo: TImage;
  Label_Email: TLabel;
  Label_EmailValue: TLabel;
  Label_ID: TLabel;
  Label_IDValue: TLabel;
  Label_Mode: TLabel;
  Label_ModeValue: TLabel;
  Label_Name: TLabel;
  Label_NameValue: TLabel;
  procedure Button_LogoutClick(Sender: TObject);
  procedure FormShow(Sender: TObject);
 private
  { Private declarations }
 public
  { Public declarations }
 protected
  procedure ExportD2Bridge; override;
  procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
  procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
  procedure EndRender; override;
 end;

function FormAuth: TFormAuth;

implementation

uses
 LazarusWebApp, D2BridgeFormTemplate;

{$R *.lfm}

function FormAuth: TFormAuth;
begin
 result:= (TFormAuth.GetInstance as TFormAuth);
end;

procedure TFormAuth.FormShow(Sender: TObject);
begin
 Label_ModeValue.Caption:= LazarusDemo.UserLoginMode;
 Label_IDValue.Caption:= LazarusDemo.UserID;
 Label_NameValue.Caption:= LazarusDemo.UserName;
 Label_EmailValue.Caption:= LazarusDemo.UserEmail;
end;

procedure TFormAuth.Button_LogoutClick(Sender: TObject);
begin
 if LazarusDemo.UserLoginMode = 'Google' then
  D2Bridge.API.Auth.Google.Logout
 else
 if LazarusDemo.UserLoginMode = 'Microsoft' then
  D2Bridge.API.Auth.Microsoft.Logout;

 PrismSession.Close(true);
end;

procedure TFormAuth.ExportD2Bridge;
begin
 inherited;

 Title:= 'My D2Bridge Form';

 TemplateClassForm:= TD2BridgeFormTemplate;
 D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '';
 D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

 //Export yours Controls
 with D2Bridge.Items.add do
 begin
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

procedure TFormAuth.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
 inherited;

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

procedure TFormAuth.RenderD2Bridge(const PrismControl: TPrismControl;
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

procedure TFormAuth.EndRender;
begin
 D2Bridge.PrismControlFromVCLObj(Image_Photo).AsImage.URLImage:= LazarusDemo.UserURLPicture;
end;

end.
