unit Unit4;

{ Copyright 2024 / 2025 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  D2Bridge.Forms, Vcl.Imaging.pngimage, Vcl.ExtCtrls;

type
  TForm4 = class(TD2BridgeForm)
    Panel_Card5: TPanel;
    Image_Card_Login: TImage;
    Edit_Login: TEdit;
    Edit_Password: TEdit;
    Button_Login: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure ExportD2Bridge; override;
    procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
    procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
  end;

function Form4:TForm4;

implementation

{$R *.dfm}

function Form4:TForm4;
begin
  result:= TForm4(TForm4.GetInstance);
end;

procedure TForm4.ExportD2Bridge;
begin
  inherited;

  Title:= 'My D2Bridge Form';

  D2Bridge.HTML.Render.BodyStyle:= 'background-color: #e3e3e7;';

  //TemplateClassForm:= TD2BridgeFormTemplate;
  D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '';
  D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

  with D2Bridge.Items.add do
  begin
   with HTMLDIV('', '', '' ,'display: flex; align-items: center; justify-content: center; height: 100vh;').Items.Add do
    with Card do
    begin
     ColSize:= 'col-8';
     CSSClassesBody:= 'd-flex align-items-center h-100';

     Image(TD2BridgeCardImagePosition.D2BridgeCardImagePositionLeft, Image_Card_Login, 'col-md-6');

     with Items.Add do
     begin
      with Row('row', '', false, 'm-5').Items.Add do
      begin
       Row.Items.Add.FormGroup('Login').AddVCLObj(Edit_Login);
       Row.Items.Add.FormGroup('Password').AddVCLObj(Edit_Password);
       Row.Items.Add.FormGroup.AddVCLObj(Button_Login);
      end;
     end;
    end;
  end;

end;

procedure TForm4.InitControlsD2Bridge(const PrismControl: TPrismControl);
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

procedure TForm4.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string);
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