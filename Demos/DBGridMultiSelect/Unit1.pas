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
    DBGrid1: TDBGrid;
    Button1: TButton;
    DSCountry: TDataSource;
    ClientDataSet_Country: TClientDataSet;
    ClientDataSet_CountryAutoCod: TAutoIncField;
    ClientDataSet_CountryCountry: TStringField;
    ClientDataSet_CountryDDI: TStringField;
    ClientDataSet_CountryPopulation: TIntegerField;
    ClientDataSet_CountryContinent: TStringField;
    ClientDataSet_CountryLanguage: TStringField;
    ClientDataSet_CountryCapital: TStringField;
    ClientDataSet_CountryCurrencyName: TStringField;
    ClientDataSet_CountryCurrencySimbol: TStringField;
    ClientDataSet_CountryCanSelect: TStringField;
    Label4: TLabel;
    procedure DBGrid1CellClick(Column: TColumn);
    procedure Button1Click(Sender: TObject);
  private
    Procedure PopuleClientDataSet;
  public

  protected
   procedure ExportD2Bridge; override;
   procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
   procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
   procedure BeginTagHTML; override;
  end;

Function Form1: TForm1;

implementation

Function Form1: TForm1;
begin
 Result:= TForm1(TForm1.GetInstance);
end;

{$R *.dfm}

{ TForm1 }

procedure TForm1.BeginTagHTML;
begin
 inherited;

 PopuleClientDataSet;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
 I: integer;
 vCountries: TStrings;
begin
 if (DBGrid1.SelectedRows.Count > 0) then
 begin
  vCountries:= TStringList.Create;

  with DBGrid1 do
  begin
   if SelectedRows.Count > 0 then
    for i := 0 to Pred(SelectedRows.Count) do
    begin
     { posiciona nos registros selecionados do DBGrid }
     DBGrid1.DataSource.Dataset.Bookmark := SelectedRows[i];

     vCountries.Add(DBGrid1.DataSource.Dataset.FieldByName('Country').AsString);
    end;
  end;

  Showmessage('Selected countries: ' + #13 +vCountries.CommaText);

  FreeAndNil(vCountries);
 end;

end;

procedure TForm1.DBGrid1CellClick(Column: TColumn);
begin
 if DBGrid1.SelectedRows.CurrentRowSelected then
  if ClientDataSet_Country.FieldByName('CanSelect').AsString = 'No' then
   DBGrid1.SelectedRows.CurrentRowSelected:= false;
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
  VCLObj(Label4, CSSClass.Text.Size.fs2 + ' ' + CSSClass.Text.Style.bold);
  VCLObj(Button1);
  VCLObj(DBGrid1);
 end;
end;

procedure TForm1.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
 inherited;

  if PrismControl.IsDBGrid then
  begin
   PrismControl.AsDBGrid.RecordsPerPage:= 7;
   PrismControl.AsDBGrid.MaxRecords:= 2000;

   if PrismControl.VCLComponent = DBGrid1 then
   with PrismControl.AsDBGrid do
    with Columns.ColumnByDataField('CanSelect') do
    begin
     HTML:= '<span class="badge ${value === ''Yes'' ? ''bg-success'' : ''bg-danger''} rounded-pill p-2" style="width: 7em;">${value}</span>';
    end;

  end;
end;

procedure TForm1.PopuleClientDataSet;
begin
 ClientDataSet_Country.AppendRecord([1, 'China', '+86', 'Yes', 1444216107, 'Asia', 'Mandarin', 'Beijing', 'Yuan', '¥']);
 ClientDataSet_Country.AppendRecord([2, 'India', '+91', 'No', 1393409038, 'Asia', 'Hindi, English', 'New Delhi', 'Rupee', '₹']);
 ClientDataSet_Country.AppendRecord([3, 'United States', '+1', 'Yes', 332915073, 'North America', 'English', 'Washington, D.C.', 'Dollar', '$']);
 ClientDataSet_Country.AppendRecord([4, 'Indonesia', '+62', 'No', 276361783, 'Asia', 'Indonesian', 'Jakarta', 'Rupiah', 'Rp']);
 ClientDataSet_Country.AppendRecord([5, 'Pakistan', '+92', 'Yes', 225199937, 'Asia', 'Urdu, English', 'Islamabad', 'Rupee', '₨']);
 ClientDataSet_Country.AppendRecord([6, 'Brazil', '+55', 'Yes', 213993437, 'South America', 'Portuguese', 'Brasília', 'Real', 'R$']);
 ClientDataSet_Country.AppendRecord([7, 'Nigeria', '+234', 'Yes', 211400708, 'Africa', 'English', 'Abuja', 'Naira', '₦']);
 ClientDataSet_Country.AppendRecord([8, 'Bangladesh', '+880', 'Yes', 166303498, 'Asia', 'Bengali', 'Dhaka', 'Taka', '৳']);
 ClientDataSet_Country.AppendRecord([9, 'Russia', '+7', 'Yes', 145912025, 'Europe/Asia', 'Russian', 'Moscow', 'Ruble', '₽']);
 ClientDataSet_Country.AppendRecord([10, 'Mexico', '+52', 'No', 130262216, 'North America', 'Spanish', 'Mexico City', 'Peso', '$']);
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
