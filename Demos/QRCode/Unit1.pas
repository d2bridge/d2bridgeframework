unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Imaging.pngimage,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, D2Bridge.Forms, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, D2Bridge.API.QRCode, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Datasnap.DBClient;

type
  TForm1 = class(TD2BridgeForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    GroupBox1: TGroupBox;
    Image1: TImage;
    Edit1: TEdit;
    Button1: TButton;
    GroupBox2: TGroupBox;
    Edit2: TEdit;
    GroupBox3: TGroupBox;
    Edit3: TEdit;
    Button2: TButton;
    GroupBox5: TGroupBox;
    DBGrid1: TDBGrid;
    DSCountry: TDataSource;
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
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FD2BridgeAPIQRCode: TD2BridgeAPIQRCode;
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
   ServerController;

Function Form1: TForm1;
begin
 Result:= TForm1(TForm1.GetInstance);
end;

{$R *.dfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
 FD2BridgeAPIQRCode.Text:= Edit1.Text;
 Image1.Picture.Assign(FD2BridgeAPIQRCode.QRCodeJPG);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 if IsD2BridgeContext then
  D2Bridge.PrismControlFromID('QRCodeDynamic').AsQRCode.Text:= Edit3.Text
 else
  Showmessage('Just D2Bridge Web');
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

  with row.Items.Add do
  begin
   with HTMLDiv(CSSClass.Col.col).Items.Add do
   with  CardGrid do
   begin
    ColSize:= 'row-cols-md-1 row-cols-lg-1';
    EqualHeight:= true;

    //VCL and WEB
    with AddCard(GroupBox1.Caption).Items.Add do
    begin
     with Row.Items.Add do
     begin
      with HTMLDiv(CSSClass.Col.colsize8).Items.Add do
       with Row.Items.Add do
       begin
        FormGroup('', CSSClass.Col.col).AddVCLObj(Edit1);
        FormGroup.AddVCLObj(Button1);
       end;

      with HTMLDiv(CSSClass.Col.colsize4).Items.Add do
       VCLObj(Image1);
     end;
    end;

    //VCL Static
    with AddCard(GroupBox2.Caption).Items.Add do
    begin
     with Row.Items.Add do
     begin
      with HTMLDiv(CSSClass.Col.colsize8).Items.Add do
       with Row.Items.Add do
        FormGroup('', CSSClass.Col.col).AddVCLObj(Edit2);

      with HTMLDiv(CSSClass.Col.colsize4).Items.Add do
       QRCode(Edit2.Text);
     end;
    end;

    //WEB Dynamic
    with AddCard(GroupBox3.Caption).Items.Add do
    begin
     with Row.Items.Add do
     begin
      with HTMLDiv(CSSClass.Col.colsize8).Items.Add do
       with Row.Items.Add do
       begin
        FormGroup('', CSSClass.Col.col).AddVCLObj(Edit3);
        FormGroup.AddVCLObj(Button2);
       end;

      with HTMLDiv(CSSClass.Col.colsize4).Items.Add do
       QRCode(Edit3.Text, 'QRCodeDynamic');
     end;
    end;
   end;
  end;

  //Web Dataware
  with Row.Items.Add do
   with HTMLDiv(CSSClass.Col.col).Items.Add do
    with Card(GroupBox5.Caption).Items.Add do
    begin
     with Row.Items.Add do
     begin
      with HTMLDiv(CSSClass.Col.colsize10).Items.Add do
       VCLObj(DBGrid1);

      with HTMLDiv(CSSClass.Col.colsize2).Items.Add do
       QRCode(DSCountry, 'Country');
     end;
    end;
 end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 PopuleClientDataSet;

 FD2BridgeAPIQRCode:= TD2BridgeAPIQRCode.Create;

 //Button1Click(Button1);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
 FreeAndNil(FD2BridgeAPIQRCode);
end;

procedure TForm1.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
 inherited;

  if PrismControl.IsDBGrid then
  begin
   PrismControl.AsDBGrid.RecordsPerPage:= 5;
  end;
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
