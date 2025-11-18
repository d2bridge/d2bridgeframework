unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, D2Bridge.Forms;

type
  TForm1 = class(TD2BridgeForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Edit_FirstName: TEdit;
    Edit_LastName: TEdit;
    Button_CheckName: TButton;
    Label6: TLabel;
    Edit_CarBrand: TEdit;
    Edit_CarModel: TEdit;
    Label7: TLabel;
    Button_CheckCar: TButton;
    Label8: TLabel;
    Edit_NumberMinor: TEdit;
    Edit_NumberBigger: TEdit;
    Label9: TLabel;
    Button_CheckNumber: TButton;
    procedure Button_CheckNameClick(Sender: TObject);
    procedure Button_CheckCarClick(Sender: TObject);
    procedure Button_CheckNumberClick(Sender: TObject);
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

procedure TForm1.Button_CheckCarClick(Sender: TObject);
begin
 showmessage('Brand and Model OK');
end;

procedure TForm1.Button_CheckNameClick(Sender: TObject);
begin
 showmessage('Names OK');
end;

procedure TForm1.Button_CheckNumberClick(Sender: TObject);
var
 vNumberMinor, vNumberBigger: Integer;
 vValid: boolean;
begin
 vValid:= true;

 if TryStrToInt(Edit_NumberMinor.Text, vNumberMinor) then
 begin
  if vNumberMinor >= 10 then
  begin
   vValid:= false;
   D2Bridge.Validation(Edit_NumberMinor, false, 'Insert Number < 10');
  end else
   D2Bridge.Validation(Edit_NumberMinor, true, 'Number OK')
 end else
 begin
  vValid:= false;
  D2Bridge.Validation(Edit_NumberMinor, false);
 end;


 if TryStrToInt(Edit_NumberBigger.Text, vNumberBigger) then
 begin
  if vNumberBigger <= 10 then
  begin
   vValid:= false;
   D2Bridge.Validation(Edit_NumberBigger, false, 'Insert Number > 10');
  end else
   D2Bridge.Validation(Edit_NumberBigger, true, 'Number OK')
 end else
 begin
  vValid:= false;
  D2Bridge.Validation(Edit_NumberBigger, false, 'Number invalid');
 end;


 if not vValid then
  Abort;


 Showmessage('The numbers are OK');
end;

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
  //Title
  VCLObj(Label1, CSSClass.Text.Size.fs2 + ' ' + CSSClass.Text.Style.bold);
  VCLObj(Label2, CSSClass.Text.Size.fs3);
  VCLObj(Label3, CSSClass.Text.Size.fs4);

  with Row.Items.Add do
  begin
   //Required 1
   with PanelGroup('Required 1', '', false, CSSClass.Col.colsize4).Items.Add do
   begin
    FormGroup('First Name').AddVCLObj(Edit_FirstName, 'Required1', true);
    FormGroup('Last Name').AddVCLObj(Edit_LastName, 'Required1', true);
    FormGroup.AddVCLObj(Button_CheckName, 'Required1', false);
   end;

   //Required 2
   with PanelGroup('Required 2', '', false, CSSClass.Col.colsize4).Items.Add do
   begin
    FormGroup('Car Brand').AddVCLObj(Edit_CarBrand, 'Required2', true);
    FormGroup('Last Name').AddVCLObj(Edit_CarModel, 'Required2', true);
    FormGroup.AddVCLObj(Button_CheckCar, 'Required2', false);
   end;

   //Number (Server Validation)
   with PanelGroup('Validation Server Side', '', false, CSSClass.Col.colsize4).Items.Add do
   begin
    FormGroup('Number < 10').AddVCLObj(Edit_NumberMinor);
    FormGroup('Number > 10').AddVCLObj(Edit_NumberBigger);
    FormGroup.AddVCLObj(Button_CheckNumber);
   end;
  end;


 end;
end;

procedure TForm1.InitControlsD2Bridge(const PrismControl: TPrismControl);
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
