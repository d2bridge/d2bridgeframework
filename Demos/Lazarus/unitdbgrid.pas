unit unitDBGrid;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
 Classes, SysUtils, DB, BufDataset, Controls, Graphics, Dialogs, StdCtrls,
 DBGrids, UnitMenu, D2Bridge.Forms;

type

 { TFormDBGrid }

 TFormDBGrid = class(TD2BridgeForm)
  BufDataset1: TBufDataset;
  BufDataset1country: TStringField;
  BufDataset1ddi: TStringField;
  BufDataset1id: TLongintField;
  BufDataset1population: TLongintField;
  CheckBox1: TCheckBox;
  DataSource1: TDataSource;
  DBGrid1: TDBGrid;
  procedure CheckBox1Click(Sender: TObject);
  procedure FormShow(Sender: TObject);
 private
  procedure PopuleData;
  //Simulate Button Insert Click
  procedure InsertNewRecClick(Sender: TObject);
 public
  { Public declarations }
 protected
  procedure ExportD2Bridge; override;
  procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
  procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
  procedure CallBack(const CallBackName: String; EventParams: TStrings); override;
  procedure CellButtonClick(APrismDBGrid: TPrismDBGrid; APrismCellButton: TPrismDBGridColumnButton; AColIndex: Integer; ARow: Integer); overload; override;
 end;

function FormDBGrid: TFormDBGrid;

implementation

uses
 LazarusWebApp, D2BridgeFormTemplate, UnitDBGridEdit;

{$R *.lfm}

function FormDBGrid: TFormDBGrid;
begin
 result:= (TFormDBGrid.GetInstance as TFormDBGrid);
end;

procedure TFormDBGrid.FormShow(Sender: TObject);
begin
 PopuleData;
end;

procedure TFormDBGrid.CheckBox1Click(Sender: TObject);
begin
 if CheckBox1.Checked then
  DBGrid1.Options:= DBGrid1.Options - [dgRowSelect] + [dgEditing]
 else
  DBGrid1.Options:= DBGrid1.Options - [dgEditing] + [dgRowSelect];
end;

procedure TFormDBGrid.PopuleData;
begin
 BufDataset1.Close;
 BufDataset1.CreateDataset;

 BufDataset1.AppendRecord([1, 'China', '+86', 1444216107]);
 BufDataset1.AppendRecord([2, 'India', '+91', 1393409038]);
 BufDataset1.AppendRecord([3, 'United States', '+1', 332915073]);
 BufDataset1.AppendRecord([4, 'Indonesia', '+62', 276361783]);
 BufDataset1.AppendRecord([5, 'Pakistan', '+92', 225199937]);
 BufDataset1.AppendRecord([6, 'Brazil', '+55', 213993437]);
 BufDataset1.AppendRecord([7, 'Nigeria', '+234', 211400708]);
 BufDataset1.AppendRecord([8, 'Bangladesh', '+880', 166303498]);
 BufDataset1.AppendRecord([9, 'Russia', '+7', 145912025]);
 BufDataset1.AppendRecord([10, 'Mexico', '+52', 130262216]);
 BufDataset1.AppendRecord([11, 'Japan', '+81', 125943834]);
 BufDataset1.AppendRecord([12, 'Ethiopia', '+251', 120858976]);
 BufDataset1.AppendRecord([13, 'Philippines', '+63', 113850055]);
 BufDataset1.AppendRecord([14, 'Egypt', '+20', 104258327]);
 BufDataset1.AppendRecord([15, 'Vietnam', '+84', 97429061]);
 BufDataset1.AppendRecord([16, 'DR Congo', '+243', 90003954]);
 BufDataset1.AppendRecord([17, 'Turkey', '+90', 84339067]);
 BufDataset1.AppendRecord([18, 'Iran', '+98', 85004578]);
 BufDataset1.AppendRecord([19, 'Germany', '+49', 83149300]);
 BufDataset1.AppendRecord([20, 'Thailand', '+66', 69950807]);
 BufDataset1.AppendRecord([21, 'United Kingdom', '+44', 67886011]);
 BufDataset1.AppendRecord([22, 'France', '+33', 65273511]);
 BufDataset1.AppendRecord([23, 'Italy', '+39', 60244639]);
 BufDataset1.AppendRecord([24, 'South Africa', '+27', 60041932]);
 BufDataset1.AppendRecord([25, 'Tanzania', '+255', 59895231]);
 BufDataset1.AppendRecord([26, 'Myanmar', '+95', 54409800]);
 BufDataset1.AppendRecord([27, 'Kenya', '+254', 53771296]);
 BufDataset1.AppendRecord([28, 'South Korea', '+82', 51606633]);
 BufDataset1.AppendRecord([29, 'Colombia', '+57', 50976248]);
 BufDataset1.AppendRecord([30, 'Spain', '+34', 46754783]);
end;

procedure TFormDBGrid.InsertNewRecClick(Sender: TObject);
begin
 BufDataset1.Append;

 ShowPopup('PopupDBGridEdit');
end;

procedure TFormDBGrid.ExportD2Bridge;
begin
 inherited;

 Title:= 'DBGrid Example';

 TemplateClassForm:= TD2BridgeFormTemplate;
 D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '';
 D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

 //Add Form Nested
 if FormDBGridEdit = nil then
  TFormDBGridEdit.CreateInstance;
 D2Bridge.AddNested(FormDBGridEdit);

 with D2Bridge.Items.add do
 begin
  with Row.Items.Add do
   ColAuto.Add.LCLObj(CheckBox1);

  with Row.Items.Add do
   LCLObj(DBGrid1);

  with Popup('PopupDBGridEdit', 'Lazarus DBGrid DEMO').Items.Add do
   Nested(FormDBGridEdit);
 end;
end;

procedure TFormDBGrid.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
 {$REGION 'DBGrid1'}
  if PrismControl.VCLComponent = DBGrid1 then
  with PrismControl.AsDBGrid do
  begin
   //HTML with <a> hhtml element and Button and CallBack
   with Columns.Add do
   begin
    ColumnIndex:= 0;
    Width:= 30;
    Title:= 'Print';
    HTML:= '<a onclick="{{CallBack=CellPrint(recno=${data.PrismRecNo})}}"> <span> <i class="fa fa-print fa-2x fixed-plugin-button-nav cursor-pointer" aria-hidden="false" style="color:SteelBlue" align:"left"> </i> </span> </a>';
   end;

   with Columns.Add do
   begin
    ColumnIndex:= 1;
    Title:= D2Bridge.LangNav.Button.CaptionOptions;
    Width:= 80;

    //Create Popup + Button
    with Buttons.Add do
    begin
     ButtonModel:= TButtonModel.Config;

     //New
     with Add do
     begin
      ButtonModel:= TButtonModel.Add;
      OnClick:= InsertNewRecClick; //Simulate Button Click
     end;

     //Edit
     with Add do
     begin
      ButtonModel:= TButtonModel.Edit;
     end;

     //Delete
     with Add do
     begin
      ButtonModel:= TButtonModel.Delete;
     end;
    end;
   end;
  end;
 {$ENDREGION}
end;

procedure TFormDBGrid.RenderD2Bridge(const PrismControl: TPrismControl;
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

procedure TFormDBGrid.CallBack(const CallBackName: String; EventParams: TStrings);
begin
 if SameText('CellPrint', CallBackName) then
 begin
  Showmessage('Prin Row ' + EventParams.Values['recno']);
 end;
end;

procedure TFormDBGrid.CellButtonClick(APrismDBGrid: TPrismDBGrid;
 APrismCellButton: TPrismDBGridColumnButton; AColIndex: Integer; ARow: Integer);
begin
 if APrismDBGrid.VCLComponent = DBGrid1 then
 begin
  if APrismCellButton.Identify = TButtonModel.Edit.Identity then
  begin
   ShowPopup('PopupDBGridEdit');
  end;

  if APrismCellButton.Identify = TButtonModel.Delete.Identity then
  begin
   if MessageDlg('Delete this record?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    FormDBGrid.BufDataset1.Delete;
  end;
 end;
end;

end.
