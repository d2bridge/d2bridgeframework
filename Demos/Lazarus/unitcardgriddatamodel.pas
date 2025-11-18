unit unitCardGridDataModel;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
 Classes, SysUtils, BufDataset, DB, Controls, Graphics, Dialogs, StdCtrls, DBCtrls,
 ExtCtrls, D2Bridge.Forms;

type

 { TFormCardGridDataModel }

 TFormCardGridDataModel = class(TD2BridgeForm)
  BufDataset1: TBufDataset;
  BufDataset1Capital: TStringField;
  BufDataset1Continent: TStringField;
  BufDataset1country: TStringField;
  BufDataset1CreateAt: TDateField;
  BufDataset1CurrencyName: TStringField;
  BufDataset1CurrencySimbol: TStringField;
  BufDataset1ddi: TStringField;
  BufDataset1id: TLongintField;
  BufDataset1Language: TStringField;
  BufDataset1population: TLongintField;
  Button_View: TButton;
  DataSource1: TDataSource;
  DBText_Country: TDBText;
  DBText_DDI: TDBText;
  DBText_Population: TDBText;
  Label_Country: TLabel;
  Label_DDI: TLabel;
  Label_Population: TLabel;
  Panel9: TPanel;
  procedure Button_ViewClick(Sender: TObject);
  procedure FormShow(Sender: TObject);
 private
  procedure PopuleData;
  procedure CardGridClick(PrismControlClick: TPrismControl; ARow: Integer; APrismCardGrid: TPrismCardGridDataModel); override;
 public
  { Public declarations }
 protected
  procedure ExportD2Bridge; override;
  procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
  procedure RenderD2Bridge(const PrismControl: TPrismControl; 
   var HTMLControl: string); override;
 end;

function FormCardGridDataModel: TFormCardGridDataModel;

implementation

uses
 LazarusWebApp, D2BridgeFormTemplate;

{$R *.lfm}

function FormCardGridDataModel: TFormCardGridDataModel;
begin
 result:= (TFormCardGridDataModel.GetInstance as TFormCardGridDataModel);
end;

procedure TFormCardGridDataModel.Button_ViewClick(Sender: TObject);
begin
 ShowMessage(BufDataset1.FieldByName('Country').AsString);
end;

procedure TFormCardGridDataModel.FormShow(Sender: TObject);
begin
 PopuleData;
end;

procedure TFormCardGridDataModel.PopuleData;
begin
 BufDataset1.Close;
 BufDataset1.CreateDataset;

 BufDataset1.AppendRecord([1, 'China', '86', 1444216107, 'Asia', 'Mandarin', 'Beijing', 'Yuan', '¥']);
 BufDataset1.AppendRecord([2, 'India', '91', 1393409038, 'Asia', 'Hindi, English', 'New Delhi', 'Rupee', '₹']);
 BufDataset1.AppendRecord([3, 'United States', '1', 332915073, 'North America', 'English', 'Washington, D.C.', 'Dollar', '$']);
 BufDataset1.AppendRecord([4, 'Indonesia', '62', 276361783, 'Asia', 'Indonesian', 'Jakarta', 'Rupiah', 'Rp']);
 BufDataset1.AppendRecord([5, 'Pakistan', '92', 225199937, 'Asia', 'Urdu, English', 'Islamabad', 'Rupee', '₨']);
 BufDataset1.AppendRecord([6, 'Brazil', '55', 213993437, 'South America', 'Portuguese', 'Brasília', 'Real', 'R$']);
 BufDataset1.AppendRecord([7, 'Nigeria', '234', 211400708, 'Africa', 'English', 'Abuja', 'Naira', '₦']);
 BufDataset1.AppendRecord([8, 'Bangladesh', '880', 166303498, 'Asia', 'Bengali', 'Dhaka', 'Taka', '৳']);
 BufDataset1.AppendRecord([9, 'Russia', '7', 145912025, 'Europe/Asia', 'Russian', 'Moscow', 'Ruble', '₽']);
 BufDataset1.AppendRecord([10, 'Mexico', '52', 130262216, 'North America', 'Spanish', 'Mexico City', 'Peso', '$']);
 BufDataset1.AppendRecord([11, 'Japan', '81', 125943834, 'Asia', 'Japanese', 'Tokyo', 'Yen', '¥']);
 BufDataset1.AppendRecord([12, 'Ethiopia', '251', 120858976, 'Africa', 'Amharic', 'Addis Ababa', 'Birr', 'Br']);
 BufDataset1.AppendRecord([13, 'Philippines', '63', 113850055, 'Asia', 'Filipino, English', 'Manila', 'Peso', '₱']);
 BufDataset1.AppendRecord([14, 'Egypt', '20', 104258327, 'Africa', 'Arabic', 'Cairo', 'Pound', '£']);
 BufDataset1.AppendRecord([15, 'Vietnam', '84', 97429061, 'Asia', 'Vietnamese', 'Hanoi', 'Dong', '₫']);
 BufDataset1.AppendRecord([16, 'DR Congo', '243', 90003954, 'Africa', 'French', 'Kinshasa', 'Franc', 'FC']);
 BufDataset1.AppendRecord([17, 'Turkey', '90', 84339067, 'Europe/Asia', 'Turkish', 'Ankara', 'Lira', '₺']);
 BufDataset1.AppendRecord([18, 'Iran', '98', 85004578, 'Asia', 'Persian', 'Tehran', 'Rial', '﷼']);
 BufDataset1.AppendRecord([19, 'Germany', '49', 83149300, 'Europe', 'German', 'Berlin', 'Euro', '€']);
 BufDataset1.AppendRecord([20, 'Thailand', '66', 69950807, 'Asia', 'Thai', 'Bangkok', 'Baht', '฿']);
 BufDataset1.AppendRecord([21, 'United Kingdom', '44', 67886011, 'Europe', 'English', 'London', 'Pound', '£']);
 BufDataset1.AppendRecord([22, 'France', '33', 65273511, 'Europe', 'French', 'Paris', 'Euro', '€']);
 BufDataset1.AppendRecord([23, 'Italy', '39', 60244639, 'Europe', 'Italian', 'Rome', 'Euro', '€']);
 BufDataset1.AppendRecord([24, 'South Africa', '27', 60041932, 'Africa', 'Zulu, Xhosa, Afrikaans, English', 'Pretoria', 'Rand', 'R']);
 BufDataset1.AppendRecord([25, 'Tanzania', '255', 59895231, 'Africa', 'Swahili, English', 'Dodoma', 'Shilling', 'TSh']);
 BufDataset1.AppendRecord([26, 'Myanmar', '95', 54409800, 'Asia', 'Burmese', 'Naypyidaw', 'Kyat', 'K']);
 BufDataset1.AppendRecord([27, 'Kenya', '254', 53771296, 'Africa', 'Swahili, English', 'Nairobi', 'Shilling', 'KSh']);
 BufDataset1.AppendRecord([28, 'South Korea', '82', 51606633, 'Asia', 'Korean', 'Seoul', 'Won', '₩']);
 BufDataset1.AppendRecord([29, 'Colombia', '57', 50976248, 'South America', 'Spanish', 'Bogotá', 'Peso', '$']);
 BufDataset1.AppendRecord([30, 'Spain', '34', 46754783, 'Europe', 'Spanish', 'Madrid', 'Euro', '€']);
end;

procedure TFormCardGridDataModel.CardGridClick(
 PrismControlClick: TPrismControl; ARow: Integer;
 APrismCardGrid: TPrismCardGridDataModel);
begin
 inherited CardGridClick(PrismControlClick, ARow, APrismCardGrid);
end;

procedure TFormCardGridDataModel.ExportD2Bridge;
begin
 inherited;

 Title:= 'My D2Bridge Form';

 TemplateClassForm:= TD2BridgeFormTemplate;
 D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '';
 D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

 //Export yours Controls
 with D2Bridge.Items.add do
 begin
  with CardGrid(DataSource1) do
  begin
   //EqualHeight:= true;
   //CardGridSize:= CSSClass.CardGrid.CardGridX2;
   //Space:= CSSClass.Space.gutter4;

   with CardDataModel.Items.Add do
   begin
    //Country
    with Row.Items.Add do
    begin
     ColAuto.Add.VCLObj(Label_Country);
     Col.Add.VCLObj(DBText_Country);
    end;

    //Population
    with Row.Items.Add do
    begin
     ColAuto.Add.VCLObj(Label_Population);
     Col.Add.VCLObj(DBText_Population);
    end;

    //DDI
    with Row.Items.Add do
    begin
     ColAuto.Add.VCLObj(Label_DDI);
     Col.Add.VCLObj(DBText_DDI);
    end;

    with Row.Items.Add do
     ColAuto.Add.VCLObj(Button_View, CSSClass.Button.view);
   end;
  end;
 end;
end;

procedure TFormCardGridDataModel.InitControlsD2Bridge(const PrismControl: TPrismControl);
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

procedure TFormCardGridDataModel.RenderD2Bridge(const PrismControl: TPrismControl;
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
