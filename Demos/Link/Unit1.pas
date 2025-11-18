unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, D2Bridge.Forms, Data.DB,
  Vcl.DBCtrls, Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids;

type
  TForm1 = class(TD2BridgeForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    DBGrid1: TDBGrid;
    CDSCountry: TClientDataSet;
    CDSCountryAutoCod: TAutoIncField;
    CDSCountryCountry: TStringField;
    CDSCountryDDI: TStringField;
    CDSCountryPopulation: TIntegerField;
    CDSCountryContinent: TStringField;
    CDSCountryLanguage: TStringField;
    CDSCountryCapital: TStringField;
    CDSCountryCurrencyName: TStringField;
    CDSCountryCurrencySimbol: TStringField;
    CDSCountryCreateAt: TDateField;
    DSCountry: TDataSource;
    DBText1: TDBText;
    Label6: TLabel;
    Label7: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure DBText1Click(Sender: TObject);
  private
   procedure LinkClick(Sender: TObject);
   Procedure PopuleClientDataSet;
  public

  protected
   procedure ExportD2Bridge; override;
   procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
   procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
   procedure CallBack(const CallBackName: string; EventParams: TStrings); override;
  end;

Function Form1: TForm1;

implementation

Uses
   ServerController;

Function Form1: TForm1;
begin
 Result:= TForm1(TForm1.GetInstance);
end;

{$R *.dfm}

{ TForm1 }

procedure TForm1.CallBack(const CallBackName: string; EventParams: TStrings);
begin
 if SameText(CallBackName, 'LinkCallBack1') then
 begin
  showmessage('You clicked in LinkCallBack1');
 end;

 if SameText(CallBackName, 'LinkCallBack2') then
 begin
  showmessage('You clicked in LinkCallBack2');
 end;

end;

procedure TForm1.DBText1Click(Sender: TObject);
begin
 Showmessage(CDSCountry.FieldByName(DBText1.DataField).AsString);
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

  Link(Label4, 'https://www.d2bridge.com.br');
  LinkCallBack(Label5, 'LinkCallBack1');
  Link('Click with Link with Static text and procedure', LinkClick);
  LinkCallBack('Click to CallBack "LinkCallBack2"', 'LinkCallBack2');
  Link(Label6);

  //Items inside the link
  with Link.Items.Add do
  begin
   VCLObj(Label7);
   //..put any VCLObj and D2Bridge item inside
  end;

  VCLObj(DBGrid1);
  Link(DBText1);

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
 end;

end;

procedure TForm1.Label6Click(Sender: TObject);
begin
 Showmessage('Clicked');
end;

procedure TForm1.LinkClick(Sender: TObject);
begin
 showmessage('You clicked in link');
end;

procedure TForm1.PopuleClientDataSet;
begin
 CDSCountry.AppendRecord([1, 'China', '86', 1444216107, 'Asia', 'Mandarin', 'Beijing', 'Yuan', '¥', '01/01/2024']);
 CDSCountry.AppendRecord([2, 'India', '91', 1393409038, 'Asia', 'Hindi, English', 'New Delhi', 'Rupee', '₹', '01/01/2024']);
 CDSCountry.AppendRecord([3, 'United States', '1', 332915073, 'North America', 'English', 'Washington, D.C.', 'Dollar', '$', '02/01/2024']);
 CDSCountry.AppendRecord([4, 'Indonesia', '62', 276361783, 'Asia', 'Indonesian', 'Jakarta', 'Rupiah', 'Rp', '31/12/2024']);
 CDSCountry.AppendRecord([5, 'Pakistan', '92', 225199937, 'Asia', 'Urdu, English', 'Islamabad', 'Rupee', '₨', '01/01/2024']);
 CDSCountry.AppendRecord([6, 'Brazil', '55', 213993437, 'South America', 'Portuguese', 'Brasília', 'Real', 'R$', '01/01/2024']);
 CDSCountry.AppendRecord([7, 'Nigeria', '234', 211400708, 'Africa', 'English', 'Abuja', 'Naira', '₦', '01/01/2024']);
 CDSCountry.AppendRecord([8, 'Bangladesh', '880', 166303498, 'Asia', 'Bengali', 'Dhaka', 'Taka', '৳']);
 CDSCountry.AppendRecord([9, 'Russia', '7', 145912025, 'Europe/Asia', 'Russian', 'Moscow', 'Ruble', '₽']);
 CDSCountry.AppendRecord([10, 'Mexico', '52', 130262216, 'North America', 'Spanish', 'Mexico City', 'Peso', '$']);
 CDSCountry.AppendRecord([11, 'Japan', '81', 125943834, 'Asia', 'Japanese', 'Tokyo', 'Yen', '¥']);
 CDSCountry.AppendRecord([12, 'Ethiopia', '251', 120858976, 'Africa', 'Amharic', 'Addis Ababa', 'Birr', 'Br']);
 CDSCountry.AppendRecord([13, 'Philippines', '63', 113850055, 'Asia', 'Filipino, English', 'Manila', 'Peso', '₱']);
 CDSCountry.AppendRecord([14, 'Egypt', '20', 104258327, 'Africa', 'Arabic', 'Cairo', 'Pound', '£']);
 CDSCountry.AppendRecord([15, 'Vietnam', '84', 97429061, 'Asia', 'Vietnamese', 'Hanoi', 'Dong', '₫']);
 CDSCountry.AppendRecord([16, 'DR Congo', '243', 90003954, 'Africa', 'French', 'Kinshasa', 'Franc', 'FC']);
 CDSCountry.AppendRecord([17, 'Turkey', '90', 84339067, 'Europe/Asia', 'Turkish', 'Ankara', 'Lira', '₺']);
 CDSCountry.AppendRecord([18, 'Iran', '98', 85004578, 'Asia', 'Persian', 'Tehran', 'Rial', '﷼']);
 CDSCountry.AppendRecord([19, 'Germany', '49', 83149300, 'Europe', 'German', 'Berlin', 'Euro', '€']);
 CDSCountry.AppendRecord([20, 'Thailand', '66', 69950807, 'Asia', 'Thai', 'Bangkok', 'Baht', '฿']);
 CDSCountry.AppendRecord([21, 'United Kingdom', '44', 67886011, 'Europe', 'English', 'London', 'Pound', '£']);
 CDSCountry.AppendRecord([22, 'France', '33', 65273511, 'Europe', 'French', 'Paris', 'Euro', '€']);
 CDSCountry.AppendRecord([23, 'Italy', '39', 60244639, 'Europe', 'Italian', 'Rome', 'Euro', '€']);
 CDSCountry.AppendRecord([24, 'South Africa', '27', 60041932, 'Africa', 'Zulu, Xhosa, Afrikaans, English', 'Pretoria', 'Rand', 'R']);
 CDSCountry.AppendRecord([25, 'Tanzania', '255', 59895231, 'Africa', 'Swahili, English', 'Dodoma', 'Shilling', 'TSh']);
 CDSCountry.AppendRecord([26, 'Myanmar', '95', 54409800, 'Asia', 'Burmese', 'Naypyidaw', 'Kyat', 'K']);
 CDSCountry.AppendRecord([27, 'Kenya', '254', 53771296, 'Africa', 'Swahili, English', 'Nairobi', 'Shilling', 'KSh']);
 CDSCountry.AppendRecord([28, 'South Korea', '82', 51606633, 'Asia', 'Korean', 'Seoul', 'Won', '₩']);
 CDSCountry.AppendRecord([29, 'Colombia', '57', 50976248, 'South America', 'Spanish', 'Bogotá', 'Peso', '$']);
 CDSCountry.AppendRecord([30, 'Spain', '34', 46754783, 'Europe', 'Spanish', 'Madrid', 'Euro', '€']);
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
