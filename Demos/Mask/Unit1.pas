unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, D2Bridge.Forms,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls;

type
  TForm1 = class(TD2BridgeForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit_Phone: TEdit;
    Edit_Site: TEdit;
    Image_Car: TImage;
    Edit_Email: TEdit;
    Edit_IP: TEdit;
    Edit_CarPlate: TEdit;
  private

  public

  protected
   procedure ExportD2Bridge; override;
   procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
   procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
  end;

Function Form1: TForm1;

implementation

Function Form1: TForm1;
begin
 Result:= TForm1(TForm1.GetInstance);
end;

{$R *.dfm}

{ TForm1 }

procedure TForm1.ExportD2Bridge;
begin
 inherited;

 Title:= 'My D2Bridge Application';

 //TemplateClassForm:= TD2BridgeFormTemplate;
 D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '';
 D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

 //Export yours Controls
 with D2Bridge.Items.add do
 begin
  VCLObj(Label1, CSSClass.Text.Size.fs2 + ' ' + CSSClass.Text.Style.bold);
  VCLObj(Label2, CSSClass.Text.Size.fs3);
  VCLObj(Label3, CSSClass.Text.Size.fs4);

  with Row.Items.Add do
  begin
   FormGroup('', CSSClass.Col.colsize2).AddVCLObj(Edit_Phone);
   FormGroup('', CSSClass.Col.colsize4).AddVCLObj(Edit_Site);
   FormGroup('', CSSClass.Col.colsize4).AddVCLObj(Edit_Email);
   FormGroup('', CSSClass.Col.colsize2).AddVCLObj(Edit_IP);
  end;

  with Row.Items.Add do
  begin
   VCLObj(Image_Car);
   FormGroup('', CSSClass.Col.colsize3).AddVCLObj(Edit_CarPlate);
  end;
 end;
end;

procedure TForm1.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
 inherited;

 if PrismControl.VCLComponent = Edit_Phone then
  PrismControl.AsEdit.TextMask:= TPrismTextMask.Phone;

 if PrismControl.VCLComponent = Edit_Email then
  PrismControl.AsEdit.TextMask:= TPrismTextMask.Email;

 if PrismControl.VCLComponent = Edit_Site then
  PrismControl.AsEdit.TextMask:= TPrismTextMask.URL;

 if PrismControl.VCLComponent = Edit_IP then
  PrismControl.AsEdit.TextMask:= TPrismTextMask.IP;

 //About use Mask
 //when you enter A it will only accept letters
 //when you enter 9 it will only accept numbers
 //when you enter * it will accept any character
 if PrismControl.VCLComponent = Edit_CarPlate then
  PrismControl.AsEdit.TextMask:= '''mask'' : ''AAA-9999''';
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

end.
