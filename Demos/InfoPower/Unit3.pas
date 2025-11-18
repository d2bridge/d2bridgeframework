unit Unit3;

{ Copyright 2024 / 2025 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, 
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  D2Bridge.Forms, Data.DB, Datasnap.DBClient, Vcl.Mask, vcl.wwbutton;

type
  TForm3 = class(TD2BridgeForm)
    wwButton1: TwwButton;
    Edit1: TEdit;
    procedure wwButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure ExportD2Bridge; override;
    procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
    procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
  end;

function Form3:TForm3;

implementation

Uses
  D2B_InfoPowerWebApp;

{$R *.dfm}

function Form3:TForm3;
begin
  result:= TForm3(TForm3.GetInstance);
end;

procedure TForm3.ExportD2Bridge;
begin
  inherited;

  Title:= 'My D2Bridge Form';
  D2Bridge.HTML.Render.BodyStyle := 'background-color: black';

  //TemplateClassForm:= TD2BridgeFormTemplate;
  D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '';
  D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

  with D2Bridge.Items.add do
  begin
   {Yours Controls}
  with Row.Items.Add do
     with FormGroup('Back', CSSClass.Col.colauto) do
          AddVCLObj(wwButton1, CSSClass.Button.save);

  with row.items.add do
     with FormGroup('PLACA', CSSClass.Col.colauto) do
          AddVCLObj(Edit1);
  end;


end;

procedure TForm3.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
 inherited;

 //Change Init Property of Prism Controls

  if PrismControl.VCLComponent = Edit1 then
  begin
     PrismControl.AsEdit.TextMask := 'AAA\-AAAA;_';
  end;
{
  if PrismControl.IsDBGrid then
  begin
   PrismControl.AsDBGrid.RecordsPerPage:= 10;
   PrismControl.AsDBGrid.MaxRecords:= 2000;
  end;
 }
end;

procedure TForm3.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string);
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

procedure TForm3.wwButton1Click(Sender: TObject);
begin
   Close;
end;

end.