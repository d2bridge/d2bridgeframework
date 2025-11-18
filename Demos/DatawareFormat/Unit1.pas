unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  D2Bridge.Forms, Data.DB, Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids,
  Vcl.Mask, Vcl.ExtCtrls, Vcl.DBCtrls; //Declare D2Bridge.Forms always in the last unit

type
  TForm1 = class(TD2BridgeForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ClientDataSet_Country: TClientDataSet;
    ClientDataSet_CountryAutoCod: TAutoIncField;
    ClientDataSet_CountryCountry: TStringField;
    ClientDataSet_CountryDDI: TStringField;
    ClientDataSet_CountryPopulation: TIntegerField;
    ClientDataSet_CountryConstitutionDate: TDateField;
    ClientDataSet_CountryGDP_BRL: TCurrencyField;
    DSCountry: TDataSource;
    DBGrid3: TDBGrid;
    ClientDataSet_CountryCapital: TStringField;
    Label_ID: TLabel;
    DBEdit_ID: TDBEdit;
    Label_Country: TLabel;
    DBEdit_Country: TDBEdit;
    Label_DDI: TLabel;
    DBEdit_DDI: TDBEdit;
    Label_Population: TLabel;
    DBEdit_Population: TDBEdit;
    DBEdit_Date_Constitution: TDBEdit;
    Label_Data_Constitution: TLabel;
    DBEdit_GPD: TDBEdit;
    Label_GPD: TLabel;
    DBEdit_Capital: TDBEdit;
    Label_Capital: TLabel;
    Button_Save: TButton;
    Button_Deactive_Active: TButton;
    Button_No_AutoEdit: TButton;
    Label_Search: TLabel;
    Edit_Search: TEdit;
    Button_Search: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button_SaveClick(Sender: TObject);
    procedure Button_Deactive_ActiveClick(Sender: TObject);
    procedure Button_No_AutoEditClick(Sender: TObject);
    procedure Button_SearchClick(Sender: TObject);
  private
    Procedure PopuleClientDataSet;
  public

  protected
   procedure ExportD2Bridge; override;
   procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
   procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
  end;

Function Form1: TForm1;

implementation

Uses
   DatawareFormatWebApp;

Function Form1: TForm1;
begin
 Result:= TForm1(TForm1.GetInstance);
end;

{$R *.dfm}

{ TForm1 }

procedure TForm1.Button_Deactive_ActiveClick(Sender: TObject);
begin
 ClientDataSet_Country.Active:= not ClientDataSet_Country.Active;
end;

procedure TForm1.Button_No_AutoEditClick(Sender: TObject);
begin
 DSCountry.AutoEdit:= not DSCountry.AutoEdit;
end;

procedure TForm1.Button_SaveClick(Sender: TObject);
begin
 ClientDataSet_Country.Edit;
 ClientDataSet_Country.Post;
end;

procedure TForm1.Button_SearchClick(Sender: TObject);
begin
 ClientDataSet_Country.Filtered:= false;
 ClientDataSet_Country.FilterOptions := [foCaseInsensitive];
 ClientDataSet_Country.Filter := 'Country like '+QuotedStr('%'+ Edit_Search.Text +'%');
 ClientDataSet_Country.Filtered:= true;
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
   with FormGroup('Buscar', CSSClass.Col.colsize4).Items.Add do
   begin
    VCLObj(Edit_Search);
    VCLObj(Button_Search, CSSClass.Button.search);
   end;
  end;

  VCLObj(DBGrid3);

  with Row.Items.Add do
  begin
   FormGroup(Label_ID.Caption, CSSClass.Col.colsize1).AddVCLObj(DBEdit_ID);
   FormGroup(Label_Country.Caption, CSSClass.Col.colsize5).AddVCLObj(DBEdit_Country);
   FormGroup(Label_DDI.Caption, CSSClass.Col.colsize2).AddVCLObj(DBEdit_DDI);
   FormGroup(Label_Population.Caption, CSSClass.Col.colsize3).AddVCLObj(DBEdit_Population);
  end;

  with Row.Items.Add do
  begin
   FormGroup(Label_Data_Constitution.Caption, CSSClass.Col.colsize3).AddVCLObj(DBEdit_Date_Constitution);
   FormGroup(Label_GPD.Caption, CSSClass.Col.colsize5).AddVCLObj(DBEdit_GPD);
   FormGroup(Label_Capital.Caption, CSSClass.Col.colsize3).AddVCLObj(DBEdit_Capital);
  end;

  with Row.Items.Add do
   FormGroup.AddVCLObj(Button_Save, CSSClass.Button.save);

  with Row.Items.Add do
  begin
   FormGroup.AddVCLObj(Button_Deactive_Active, CSSClass.Button.refresh);
   FormGroup.AddVCLObj(Button_No_AutoEdit, CSSClass.Button.refresh);
  end;

 end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 PopuleClientDataSet;
end;

procedure TForm1.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
 inherited;

  if PrismControl.IsDBGrid then
  begin
   PrismControl.AsDBGrid.RecordsPerPage:= 10;
   PrismControl.AsDBGrid.MaxRecords:= 2000;
  end;
end;

procedure TForm1.PopuleClientDataSet;
begin
  ClientDataSet_Country.AppendRecord([1, 'China', '+86', 1444216107, EncodeDate(1949, 10, 1), 10743000000000, 'Beijing']);
  ClientDataSet_Country.AppendRecord([2, 'India', '+91', 1393409038, EncodeDate(1947, 8, 15), 1413700000000, 'New Delhi']);
  ClientDataSet_Country.AppendRecord([3, 'United States', '+1', 332915073, EncodeDate(1776, 7, 4), 22675000000000, 'Washington D.C.']);
  ClientDataSet_Country.AppendRecord([4, 'Indonesia', '+62', 276361783, EncodeDate(1945, 8, 17), 1125200000000, 'Jakarta']);
  ClientDataSet_Country.AppendRecord([5, 'Pakistan', '+92', 225199937, EncodeDate(1947, 8, 14), 376500000000, 'Islamabad']);
  ClientDataSet_Country.AppendRecord([6, 'Brazil', '+55', 213993437, EncodeDate(1822, 9, 7), 1493400000000, 'Brasilia']);
  ClientDataSet_Country.AppendRecord([7, 'Nigeria', '+234', 211400708, EncodeDate(1960, 10, 1), 432290000000, 'Abuja']);
  ClientDataSet_Country.AppendRecord([8, 'Bangladesh', '+880', 166303498, EncodeDate(1971, 3, 26), 397400000000, 'Dhaka']);
  ClientDataSet_Country.AppendRecord([9, 'Russia', '+7', 145912025, EncodeDate(1991, 12, 26), 1657000000000, 'Moscow']);
  ClientDataSet_Country.AppendRecord([10, 'Mexico', '+52', 130262216, EncodeDate(1810, 9, 16), 1293000000000, 'Mexico City']);
  ClientDataSet_Country.AppendRecord([11, 'Japan', '+81', 125943834, EncodeDate(1947, 5, 3), 4933000000000, 'Tokyo']);
  ClientDataSet_Country.AppendRecord([12, 'Ethiopia', '+251', 120858976, EncodeDate(1995, 8, 21), 96570000000, 'Addis Ababa']);
  ClientDataSet_Country.AppendRecord([13, 'Philippines', '+63', 113850055, EncodeDate(1946, 7, 4), 361500000000, 'Manila']);
  ClientDataSet_Country.AppendRecord([14, 'Egypt', '+20', 104258327, EncodeDate(1953, 6, 18), 394300000000, 'Cairo']);
  ClientDataSet_Country.AppendRecord([15, 'Vietnam', '+84', 97429061, EncodeDate(1976, 7, 2), 271200000000, 'Hanoi']);
  ClientDataSet_Country.AppendRecord([16, 'DR Congo', '+243', 90003954, EncodeDate(1960, 6, 30), 49750000000, 'Kinshasa']);
  ClientDataSet_Country.AppendRecord([17, 'Turkey', '+90', 84339067, EncodeDate(1923, 10, 29), 743700000000, 'Ankara']);
  ClientDataSet_Country.AppendRecord([18, 'Iran', '+98', 85004578, EncodeDate(1979, 4, 1), 439500000000, 'Tehran']);
  ClientDataSet_Country.AppendRecord([19, 'Germany', '+49', 83149300, EncodeDate(1949, 5, 23), 4217000000000, 'Berlin']);
  ClientDataSet_Country.AppendRecord([20, 'Thailand', '+66', 69950807, EncodeDate(1238, 12, 5), 543700000000, 'Bangkok']);
  ClientDataSet_Country.AppendRecord([21, 'United Kingdom', '+44', 67886011, EncodeDate(1707, 5, 1), 3150000000000, 'London']);
  ClientDataSet_Country.AppendRecord([22, 'France', '+33', 65273511, EncodeDate(1792, 9, 22), 2715000000000, 'Paris']);
  ClientDataSet_Country.AppendRecord([23, 'Italy', '+39', 60244639, EncodeDate(1946, 6, 2), 2077000000000, 'Rome']);
  ClientDataSet_Country.AppendRecord([24, 'South Africa', '+27', 60041932, EncodeDate(1961, 5, 31), 418000000000, 'Pretoria']);
  ClientDataSet_Country.AppendRecord([25, 'Tanzania', '+255', 59895231, EncodeDate(1964, 4, 26), 64390000000, 'Dodoma']);
  ClientDataSet_Country.AppendRecord([26, 'Myanmar', '+95', 54409800, EncodeDate(1948, 1, 4), 76090000000, 'Naypyidaw']);
  ClientDataSet_Country.AppendRecord([27, 'Kenya', '+254', 53771296, EncodeDate(1963, 12, 12), 101000000000, 'Nairobi']);
  ClientDataSet_Country.AppendRecord([28, 'South Korea', '+82', 51606633, EncodeDate(1948, 8, 15), 1655000000000, 'Seoul']);
  ClientDataSet_Country.AppendRecord([29, 'Colombia', '+57', 50976248, EncodeDate(1810, 7, 20), 342400000000, 'Bogotá']);
  ClientDataSet_Country.AppendRecord([30, 'Spain', '+34', 46754783, EncodeDate(1812, 3, 19), 1423000000000, 'Madrid']);
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
