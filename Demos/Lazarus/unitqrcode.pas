unit unitQRCode;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
 Classes, SysUtils, BufDataset, DB, Controls, Graphics, Dialogs, StdCtrls, DBGrids, ExtCtrls,
 D2Bridge.API.QRCode, D2Bridge.Forms;

type

 { TFormQRCode }

 TFormQRCode = class(TD2BridgeForm)
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
  Button1: TButton;
  Button2: TButton;
  DataSource1: TDataSource;
  DBGrid1: TDBGrid;
  Edit1: TEdit;
  Edit2: TEdit;
  Edit3: TEdit;
  GroupBox1: TGroupBox;
  GroupBox2: TGroupBox;
  GroupBox3: TGroupBox;
  GroupBox5: TGroupBox;
  Image1: TImage;
  procedure Button1Click(Sender: TObject);
  procedure Button2Click(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  procedure FormShow(Sender: TObject);
 private
  FD2BridgeAPIQRCode: TD2BridgeAPIQRCode;
  Procedure PopuleData;
 public
  { Public declarations }
 protected
  procedure ExportD2Bridge; override;
  procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
  procedure RenderD2Bridge(const PrismControl: TPrismControl; 
   var HTMLControl: string); override;
 end;

function FormQRCode: TFormQRCode;

implementation

uses
 LazarusWebApp, D2BridgeFormTemplate;

{$R *.lfm}

function FormQRCode: TFormQRCode;
begin
 result:= (TFormQRCode.GetInstance as TFormQRCode);
end;

procedure TFormQRCode.FormCreate(Sender: TObject);
begin
 FD2BridgeAPIQRCode:= TD2BridgeAPIQRCode.Create;
end;

procedure TFormQRCode.Button1Click(Sender: TObject);
begin
 FD2BridgeAPIQRCode.Text:= Edit1.Text;
 Image1.Picture.Assign(FD2BridgeAPIQRCode.QRCodeJPG);

end;

procedure TFormQRCode.Button2Click(Sender: TObject);
begin
 if IsD2BridgeContext then
  D2Bridge.PrismControlFromID('QRCodeDynamic').AsQRCode.Text:= Edit3.Text
 else
  Showmessage('Just D2Bridge Web');
end;

procedure TFormQRCode.FormShow(Sender: TObject);
begin
 PopuleData;
end;

procedure TFormQRCode.PopuleData;
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

procedure TFormQRCode.ExportD2Bridge;
begin
 inherited;

 Title:= 'QRCode Example';
 SubTitle:= 'D2Bridge Native QRCode generation';

 TemplateClassForm:= TD2BridgeFormTemplate;
 D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '';
 D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

 //Export yours Controls
 with D2Bridge.Items.add do
 begin
  with row.Items.Add do
  begin
   with HTMLDiv(CSSClass.Col.col).Items.Add do
   with  CardGrid do
   begin
    //ColSize:= 'row-cols-md-1 row-cols-lg-1';
    CardGridSize:= CSSClass.CardGrid.CardGridX2;
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
       QRCode(DataSource1, 'Country');
     end;
    end;
 end;
end;

procedure TFormQRCode.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
 if PrismControl.IsDBGrid then
 begin
  PrismControl.AsDBGrid.RecordsPerPage:= 5;
 end;
end;

procedure TFormQRCode.RenderD2Bridge(const PrismControl: TPrismControl;
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
