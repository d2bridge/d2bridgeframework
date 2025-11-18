unit unitStringGrid;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
 Classes, SysUtils, BufDataset, DB, Controls, Graphics, Dialogs, StdCtrls,
 Grids, D2Bridge.Forms;

type

 { TFormStringGrid }

 TFormStringGrid = class(TD2BridgeForm)
  BufDataset1: TBufDataset;
  BufDataset1country: TStringField;
  BufDataset1ddi: TStringField;
  BufDataset1id: TLongintField;
  BufDataset1population: TLongintField;
  StringGrid1: TStringGrid;
  procedure FormCreate(Sender: TObject);
  procedure FormShow(Sender: TObject);
 private
  procedure PopuleData;
  procedure PopuleStringGrid;
 public
  { Public declarations }
 protected
  procedure ExportD2Bridge; override;
  procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
  procedure RenderD2Bridge(const PrismControl: TPrismControl; 
   var HTMLControl: string); override;
 end;

function FormStringGrid: TFormStringGrid;

implementation

uses
 LazarusWebApp, D2BridgeFormTemplate;

{$R *.lfm}

function FormStringGrid: TFormStringGrid;
begin
 result:= (TFormStringGrid.GetInstance as TFormStringGrid);
end;

procedure TFormStringGrid.FormShow(Sender: TObject);
begin

end;

procedure TFormStringGrid.FormCreate(Sender: TObject);
begin
 PopuleStringGrid;
end;

procedure TFormStringGrid.PopuleData;
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

procedure TFormStringGrid.PopuleStringGrid;
var
  I, N: integer;
  nLinha: Integer;
begin
 PopuleData;

 { Informa configuração da StringGrid }
 StringGrid1.ColCount:= BufDataset1.FieldCount;
 StringGrid1.RowCount:= BufDataset1.RecordCount + 1;

 { Altura de cada célula }
 StringGrid1.DefaultRowHeight:= 18;

 { Monta coluna da StringGrid }
 for I:= 0 to BufDataset1.FieldCount - 1 do
 begin
   StringGrid1.Cells[I, 0]:= BufDataset1.Fields[I].DisplayLabel;

   { comprimento em pixels da coluna}
   StringGrid1.ColWidths[I]:= BufDataset1.Fields[I].DisplayWidth * 3;
 end;

 { Prenche StringGrid }
 nLinha:= 0;

 BufDataset1.First;
 while not BufDataset1.Eof do
 begin
   Inc(nLinha);

   for N:= 0 to BufDataset1.FieldCount - 1 do
     StringGrid1.Cells[N, nLinha]:= BufDataset1.FieldByName(BufDataset1.Fields[N].DisplayLabel).Text;

   BufDataset1.Next;
 end;
end;

procedure TFormStringGrid.ExportD2Bridge;
begin
 inherited;

 Title:= 'String Grid Example';
 SubTitle:= 'Below is a StringGrid populated with data about countries';

 TemplateClassForm:= TD2BridgeFormTemplate;
 D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '';
 D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

 with D2Bridge.Items.add do
 begin
  LCLObj(StringGrid1);
 end;

end;

procedure TFormStringGrid.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
 inherited;

 //Change Init Property of Prism Controls
 if PrismControl.IsStringGrid then
 begin
  PrismControl.AsStringGrid.RecordsPerPage:= 20;
  PrismControl.AsStringGrid.MaxRecords:= 2000;
 end;
end;

procedure TFormStringGrid.RenderD2Bridge(const PrismControl: TPrismControl;
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
