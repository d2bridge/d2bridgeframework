unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  D2Bridge.Forms, Vcl.Mask, Vcl.ExtCtrls; //Declare D2Bridge.Forms always in the last unit

type
  TForm1 = class(TD2BridgeForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label4: TLabel;
    Edit1: TEdit;
    Label5: TLabel;
    Edit2: TEdit;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private

  public

  protected
   procedure ExportD2Bridge; override;
   procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
   procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
  end;

Function Form1: TForm1;

implementation

Uses
   CookiesDemoWebApp;

Function Form1: TForm1;
begin
 Result:= TForm1(TForm1.GetInstance);
end;

{$R *.dfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
 PrismSession.Cookies.Value[Edit1.Text]:= Edit2.Text;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 Showmessage('Cookie Value = ' + PrismSession.Cookies.Value[Edit1.Text]);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 PrismSession.Cookies.Delete(Edit1.Text);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
 PrismSession.Cookies.Add(Edit1.Text, 'Default');
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
  VCLObj(Label1);
  VCLObj(Label2);
  VCLObj(Label3);

  with Row.Items.Add do
  begin
   with PanelGroup('Cookie Name', '', false, CSSClass.Col.colsize3).Items.Add do
   begin
    with FormGroup(Label4.Caption).Items.Add do
    begin
     VCLObj(Edit1);
     VCLObj(Button4);
    end;
   end;

   with PanelGroup('Cookie Value', '', false, CSSClass.Col.colsize3).Items.Add do
   begin
    with FormGroup(Label5.Caption, CSSClass.Col.col).Items.add do
    begin
     VCLObj(Edit2);
     VCLObj(Button1);
    end;
   end;

   with PanelGroup('Cookie Options', '', false, CSSClass.Col.colsize3).Items.Add do
   begin
    VCLObj(Button2);
    VCLObj(Button3);
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
