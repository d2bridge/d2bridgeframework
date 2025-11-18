unit Unit2;

{ Copyright 2024 / 2025 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  D2Bridge.Forms, Vcl.Mask, Vcl.ExtCtrls, Vcl.DBCtrls;

type
  TForm2 = class(TD2BridgeForm)
    Label_Auto_Cod: TLabel;
    DBEdit_Auto_Cod: TDBEdit;
    Label_Country: TLabel;
    DBEdit_Country: TDBEdit;
    Label_DDI: TLabel;
    DBEdit_DDI: TDBEdit;
    Label_Population: TLabel;
    DBEdit_Population: TDBEdit;
    Button_Save: TButton;
    Button_Delete: TButton;
    Button_Close: TButton;
    procedure Button_SaveClick(Sender: TObject);
    procedure Button_CloseClick(Sender: TObject);
    procedure Button_DeleteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure ExportD2Bridge; override;
    procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
    procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
  end;

function Form2:TForm2;

implementation

Uses
 Unit1;

{$R *.dfm}

function Form2:TForm2;
begin
  result:= TForm2(TForm2.GetInstance);
end;

procedure TForm2.Button_SaveClick(Sender: TObject);
begin
 Form1.ClientDataSet_Country.Edit;
 Form1.ClientDataSet_Country.Post;

 close;
end;

procedure TForm2.Button_DeleteClick(Sender: TObject);
begin
 if messagedlg('Confirm Delete this record "' + QuotedStr(Form1.ClientDataSet_Country.FieldByName('Country').AsString) + '"?', mtconfirmation, [mbyes,mbno], 0) = mryes then
 begin
  Form1.ClientDataSet_Country.Edit;
  Form1.ClientDataSet_Country.Delete;

  close;
 end;
end;

procedure TForm2.Button_CloseClick(Sender: TObject);
begin
 Form1.ClientDataSet_Country.Edit;
 Form1.ClientDataSet_Country.Cancel;

 close;
end;

procedure TForm2.ExportD2Bridge;
begin
  inherited;

  Title:= 'My D2Bridge Form';

  //TemplateClassForm:= TD2BridgeFormTemplate;
  D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '';
  D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

  with D2Bridge.Items.add do
  begin
   with Row.Items.Add do
   begin
    FormGroup(Label_Auto_Cod.Caption).AddVCLObj(DBEdit_Auto_Cod);
    FormGroup(Label_Country.Caption).AddVCLObj(DBEdit_Country);
    FormGroup(Label_DDI.Caption).AddVCLObj(DBEdit_DDI);
    FormGroup(Label_Population.Caption).AddVCLObj(DBEdit_Population);
   end;

   with Row.Items.Add do
   begin
    FormGroup.AddVCLObj(Button_Save, CSSClass.Button.save);
    FormGroup.AddVCLObj(Button_Delete, CSSClass.Button.delete);
    FormGroup.AddVCLObj(Button_Close, CSSClass.Button.close);
   end;
  end;

end;

procedure TForm2.InitControlsD2Bridge(const PrismControl: TPrismControl);
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

procedure TForm2.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string);
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