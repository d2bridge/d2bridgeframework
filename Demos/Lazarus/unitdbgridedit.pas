unit unitDBGridEdit;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
 Classes, SysUtils, Controls, Graphics, Dialogs, StdCtrls, DBCtrls,  
 D2Bridge.Forms;

type

 { TFormDBGridEdit }

 TFormDBGridEdit = class(TD2BridgeForm)
  ButtonSave: TButton;
  ButtonDelete: TButton;
  DBEditCountry: TDBEdit;
  DBEditDDI: TDBEdit;
  DBEditPopulation: TDBEdit;
  DBTextId: TDBText;
  LabelId: TLabel;
  LabelCountry: TLabel;
  LabelDDI: TLabel;
  LabelPopulation: TLabel;
  procedure ButtonDeleteClick(Sender: TObject);
  procedure ButtonSaveClick(Sender: TObject);
 private
  { Private declarations }
 public
  { Public declarations }
 protected
  procedure ExportD2Bridge; override;
  procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
  procedure RenderD2Bridge(const PrismControl: TPrismControl; 
   var HTMLControl: string); override;
 end;

function FormDBGridEdit: TFormDBGridEdit;

implementation

uses
 LazarusWebApp, UnitDBGrid;

{$R *.lfm}

function FormDBGridEdit: TFormDBGridEdit;
begin
 result:= (TFormDBGridEdit.GetInstance as TFormDBGridEdit);
end;

procedure TFormDBGridEdit.ButtonSaveClick(Sender: TObject);
begin
 FormDBGrid.BufDataset1.Edit;
 FormDBGrid.BufDataset1.Post;

 Close;
end;

procedure TFormDBGridEdit.ButtonDeleteClick(Sender: TObject);
begin
 if MessageDlg('Delete this record?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
 begin
  FormDBGrid.BufDataset1.Delete;

  Close;
 end;
end;

procedure TFormDBGridEdit.ExportD2Bridge;
begin
 inherited;

 Title:= 'My D2Bridge Form';

 //TemplateClassForm:= TD2BridgeFormTemplate;
 D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '';
 D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

 with D2Bridge.Items.add do
 begin
  //Example use FormGroup
  with Row.Items.Add do
   FormGroup(LabelId.Caption).AddLCLObj(DBTextId);

  //Example export using full column size
  with Row.Items.Add do
   with Col12.Items.Add do
   begin
    LCLObj(LabelCountry);
    LCLObj(DBEditCountry);
   end;

  //Example export using auto column size
  with Row.Items.Add do
   with ColAuto.Items.Add do
   begin
    LCLObj(LabelDDI);
    LCLObj(DBEditDDI);
   end;

  //Example export using auto column size
  with Row.Items.Add do
   with ColAuto.Items.Add do
   begin
    LCLObj(LabelPopulation);
    LCLObj(DBEditPopulation);
   end;

  //Example export using auto column size
  with Row.Items.Add do
  begin
   ColAuto.Add.LCLObj(ButtonSave, CSSClass.Button.save);
   ColAuto.Add.LCLObj(ButtonDelete, CSSClass.Button.delete);
  end;
 end;

end;

procedure TFormDBGridEdit.InitControlsD2Bridge(const PrismControl: TPrismControl);
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

procedure TFormDBGridEdit.RenderD2Bridge(const PrismControl: TPrismControl;
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

end.
