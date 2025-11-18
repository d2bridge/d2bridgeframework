unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, D2Bridge.Forms, Data.DB,
  Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids;

type
  TForm1 = class(TD2BridgeForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    DSCountry: TDataSource;
    ClientDataSet_Country: TClientDataSet;
    ClientDataSet_CountryAutoCod: TAutoIncField;
    ClientDataSet_CountryCountry: TStringField;
    ClientDataSet_CountryDDI: TStringField;
    ClientDataSet_CountryPopulation: TIntegerField;
    DBGrid1: TDBGrid;
    StringGrid1: TStringGrid;
    procedure FormCreate(Sender: TObject);
  private
    Procedure PopuleClientDataSet;
    procedure PopuleStringGrid;
    function BuildDataTable: string;
  public

  protected
   procedure ExportD2Bridge; override;
   procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
   procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
   procedure CellButtonClick(APrismDBGrid: TPrismDBGrid; APrismCellButton: TPrismGridColumnButton; AColIndex: Integer; ARow: Integer); override;
   procedure CallBack(const CallBackName: string; EventParams: TStrings); override;
  end;

{$IFNDEF D2BRIDGE}
var Form1: TForm1;
{$ELSE}
Function Form1: TForm1;
{$ENDIF}

implementation

{$IFDEF D2BRIDGE}
Function Form1: TForm1;
begin
 Result:= TForm1(TForm1.GetInstance);
end;
{$ENDIF}

{$R *.dfm}

{ TForm1 }

function TForm1.BuildDataTable: string;
var
 vDataTables: TStrings;
begin
 vDataTables:= TStringList.Create;

 ClientDataSet_Country.First;
 ClientDataSet_Country.DisableControls;

 //HTMLElement
 with vDataTables do
 begin
  add('<div class="table-responsive">');
  add('    <table id="autofill-table" class="display compact table table-bordered text-nowrap mb-0">');
  add('        <thead>');
  add('            <tr>');
  add('                <th>Cod</th>');
  add('                <th>Country</th>');
  add('                <th>DDI</th>');
  add('                <th>Population</th>');
  add('                <th>Detail</th>');
  add('                <th>Options</th>');
  add('            </tr>');
  add('        </thead>');
  add('        <tbody>');

  //Popule Recs
  repeat
   with ClientDataSet_Country do
   begin
    add('<tr> ');
    add('    <td>'+FieldByName('AutoCod').AsString+'</td> ');
    add('    <td>'+FieldByName('Country').AsString+'</td> ');
    add('    <td>'+FieldByName('DDI').AsString+'</td> ');
    add('    <td>'+FieldByName('Population').AsString+'</td> ');
    add('    <td><span class="badge bg-success rounded-pill p-2" style="width: 7em;">Example</span></td> ');
    add('    <td class="text-center"> ');
    add('        <button id="bEdit" type="button" class="btn btn-sm btn-primary" onclick="{{CallBack=ButtonGrid(RecNo=' + IntToStr(RecNo) + ')}}"><span class="fa fa-edit"></span></button> ');
    add('    </td> ');
    add('</tr>');
   end;


   ClientDataSet_Country.Next;
  until ClientDataSet_Country.Eof;

  add('        </tbody>');
  add('    </table>');
  add('</div>');
 end;

 ClientDataSet_Country.EnableConstraints;

 Result:= vDataTables.Text;

 FreeAndNil(vDataTables);
end;

procedure TForm1.CallBack(const CallBackName: string; EventParams: TStrings);
begin
 if SameText('ButtonGrid', CallBackName) then
 begin
  showmessage('Click on Button Edit'+'RecNo: '+EventParams.Values['RecNo']);
 end;

end;

procedure TForm1.CellButtonClick(APrismDBGrid: TPrismDBGrid;
  APrismCellButton: TPrismGridColumnButton; AColIndex, ARow: Integer);
begin
 if APrismDBGrid.VCLComponent = DBGrid1 then
 begin
  if APrismCellButton.Identify = 'edit' then
  begin
   showmessage('Click on Button Edit'+'Rec '+IntToStr(ARow));
  end;
 end;

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

  with Row.Items.Add do
   HTMLElement(BuildDataTable);

  with Row.Items.Add do
   VCLObj(DBGrid1);

  with Row.Items.Add do
   VCLObj(StringGrid1);
 end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
{$IFDEF D2BRIDGE}
 CallBacks.Register('ButtonGrid');
{$ENDIF}

 PopuleClientDataSet;
 PopuleStringGrid;
end;

procedure TForm1.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
 inherited;


 if PrismControl.VCLComponent = DBGrid1 then
  with PrismControl.AsDBGrid do
  begin
   with Columns.Add do
   begin
    Title:= 'Detail';
    Width:= 50;
    HTML:= '<span class="badge bg-success rounded-pill p-2" style="width: 7em;">Example</span>';
   end;

   with Columns.Add do
   begin
    Title:= 'Options';
    with Buttons.Add do
    begin
     ButtonModel:= TButtonModel.Edit;
     Caption:= '';
    end;
  end;
  end;


 if PrismControl.IsDBGrid then
 begin
  PrismControl.AsDBGrid.RecordsPerPage:= 10;
  PrismControl.AsDBGrid.MaxRecords:= 2000;
 end;

 if PrismControl.IsStringGrid then
 begin
  PrismControl.AsStringGrid.RecordsPerPage:= 10;
  PrismControl.AsStringGrid.MaxRecords:= 2000;
 end;
end;

procedure TForm1.PopuleClientDataSet;
begin
  ClientDataSet_Country.AppendRecord([1, 'China', '+86', 1444216107]);
  ClientDataSet_Country.AppendRecord([2, 'India', '+91', 1393409038]);
  ClientDataSet_Country.AppendRecord([3, 'United States', '+1', 332915073]);
  ClientDataSet_Country.AppendRecord([4, 'Indonesia', '+62', 276361783]);
  ClientDataSet_Country.AppendRecord([5, 'Pakistan', '+92', 225199937]);
  ClientDataSet_Country.AppendRecord([6, 'Brazil', '+55', 213993437]);
  ClientDataSet_Country.AppendRecord([7, 'Nigeria', '+234', 211400708]);
  ClientDataSet_Country.AppendRecord([8, 'Bangladesh', '+880', 166303498]);
  ClientDataSet_Country.AppendRecord([9, 'Russia', '+7', 145912025]);
  ClientDataSet_Country.AppendRecord([10, 'Mexico', '+52', 130262216]);
  ClientDataSet_Country.AppendRecord([11, 'Japan', '+81', 125943834]);
  ClientDataSet_Country.AppendRecord([12, 'Ethiopia', '+251', 120858976]);
  ClientDataSet_Country.AppendRecord([13, 'Philippines', '+63', 113850055]);
  ClientDataSet_Country.AppendRecord([14, 'Egypt', '+20', 104258327]);
  ClientDataSet_Country.AppendRecord([15, 'Vietnam', '+84', 97429061]);
  ClientDataSet_Country.AppendRecord([16, 'DR Congo', '+243', 90003954]);
  ClientDataSet_Country.AppendRecord([17, 'Turkey', '+90', 84339067]);
  ClientDataSet_Country.AppendRecord([18, 'Iran', '+98', 85004578]);
  ClientDataSet_Country.AppendRecord([19, 'Germany', '+49', 83149300]);
  ClientDataSet_Country.AppendRecord([20, 'Thailand', '+66', 69950807]);
  ClientDataSet_Country.AppendRecord([21, 'United Kingdom', '+44', 67886011]);
  ClientDataSet_Country.AppendRecord([22, 'France', '+33', 65273511]);
  ClientDataSet_Country.AppendRecord([23, 'Italy', '+39', 60244639]);
  ClientDataSet_Country.AppendRecord([24, 'South Africa', '+27', 60041932]);
  ClientDataSet_Country.AppendRecord([25, 'Tanzania', '+255', 59895231]);
  ClientDataSet_Country.AppendRecord([26, 'Myanmar', '+95', 54409800]);
  ClientDataSet_Country.AppendRecord([27, 'Kenya', '+254', 53771296]);
  ClientDataSet_Country.AppendRecord([28, 'South Korea', '+82', 51606633]);
  ClientDataSet_Country.AppendRecord([29, 'Colombia', '+57', 50976248]);
  ClientDataSet_Country.AppendRecord([30, 'Spain', '+34', 46754783]);
end;

procedure TForm1.PopuleStringGrid;
var
  I, N: integer;
  nLinha: Integer;
begin
  { Informa configuração da StringGrid }
  StringGrid1.ColCount:= ClientDataSet_Country.FieldCount;
  StringGrid1.RowCount:= ClientDataSet_Country.RecordCount + 1;

  { Altura de cada célula }
  StringGrid1.DefaultRowHeight:= 18;

  { Monta coluna da StringGrid }
  for I:= 0 to ClientDataSet_Country.FieldCount - 1 do
  begin
    StringGrid1.Cells[I, 0]:= ClientDataSet_Country.Fields[I].DisplayLabel;

    { comprimento em pixels da coluna}
    StringGrid1.ColWidths[I]:= ClientDataSet_Country.Fields[I].DisplayWidth * 3;
    { alinhamento da coluna}

    {$IF CompilerVersion >= 34}
    StringGrid1.ColAlignments[I]:= ClientDataSet_Country.Fields[I].Alignment;
    {$ENDIF}
  end;

  { Prenche StringGrid }
  nLinha:= 0;

  ClientDataSet_Country.First;
  while not ClientDataSet_Country.Eof do
  begin
    Inc(nLinha);

    for N:= 0 to ClientDataSet_Country.FieldCount - 1 do
      StringGrid1.Cells[N, nLinha]:= ClientDataSet_Country.FieldByName(ClientDataSet_Country.Fields[N].DisplayLabel).Text;

    ClientDataSet_Country.Next;
  end;
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
