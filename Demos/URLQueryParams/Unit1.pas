unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Clipbrd, D2Bridge.Forms;

type
  TForm1 = class(TD2BridgeForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label_Query_Params: TLabel;
    Label_Usage: TLabel;
    Edit_Your_URL_Example: TEdit;
    Button_Copy: TButton;
    procedure Button_CopyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
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

procedure TForm1.Button_CopyClick(Sender: TObject);
begin
 Clipboard.AsText:= Edit_Your_URL_Example.Text;
 Showmessage('URL copied successfully');
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
  VCLObj(Label1, CSSClass.Text.Size.fs2 + ' ' + CSSClass.Text.Style.bold);
  VCLObj(Label2, CSSClass.Text.Size.fs3);
  VCLObj(Label3, CSSClass.Text.Size.fs4);
  VCLObj(Label_Usage, CSSClass.Text.Size.fs3);

  FormGroup('Example URL to Copy and Test in new Session').AddVCLObj(Edit_Your_URL_Example);
  VCLObj(Button_Copy, CSSClass.Button.copy);

  VCLObj(Label_Query_Params, CSSClass.Text.Size.fs4);
 end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 Edit_Your_URL_Example.Text:= PrismSession.URI.URL+'?param1=ThisParameter1&param2=Random'+IntToStr(Random(999999))+'&param3=Random'+IntToStr(Random(999999));
end;

procedure TForm1.FormShow(Sender: TObject);
var
 I: integer;
begin
 //if exists QueryParams
 if PrismSession.URI.QueryParams.Items.Count > 0 then
 begin
  Label_Query_Params.Caption:= '';

  Label_Query_Params.Caption:= 'Result = ' + IntToStr(PrismSession.URI.QueryParams.Items.Count) + ' Parameters';

  for I := 0 to Pred(PrismSession.URI.QueryParams.Items.Count) do
  begin
   Label_Query_Params.Caption:= Label_Query_Params.Caption + sLineBreak +
     IntToStr(I+1) + ' -> Key = ' + PrismSession.URI.QueryParams.Items[I].Key + sLineBreak +
     IntToStr(I+1) + ' -> Value = '  + PrismSession.URI.QueryParams.Items[I].Value;
  end;
 end else
  Label_Query_Params.Caption:= 'Result = No Query Params';
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
