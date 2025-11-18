unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Menus, D2Bridge.Forms, Data.DB, Datasnap.DBClient, Vcl.ExtCtrls,
  Vcl.DBCtrls; //Declare D2Bridge.Forms always in the last unit

type
  TForm1 = class(TD2BridgeForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MainMenu1: TMainMenu;
    Module11: TMenuItem;
    AppModule21: TMenuItem;
    Modules1: TMenuItem;
    Module12: TMenuItem;
    Module21: TMenuItem;
    SubModules1: TMenuItem;
    SubModule11: TMenuItem;
    SubModule21: TMenuItem;
    SubModule31: TMenuItem;
    CoreModules1: TMenuItem;
    CoreModule11: TMenuItem;
    CoreModule21: TMenuItem;
    ClientDataSet_Country: TClientDataSet;
    ClientDataSet_CountryAutoCod: TAutoIncField;
    ClientDataSet_CountryCountry: TStringField;
    ClientDataSet_CountryDDI: TStringField;
    ClientDataSet_CountryPopulation: TIntegerField;
    DSCountry: TDataSource;
    Panel1: TPanel;
    Label_Country: TLabel;
    DBText_Country: TDBText;
    Label_Population: TLabel;
    DBText_Population: TDBText;
    Label_DDI: TLabel;
    DBText_DDI: TDBText;
    Button_View: TButton;
    procedure Button_ViewClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Module11Click(Sender: TObject);
  private
    Procedure PopuleClientDataSet;
    procedure CardGridClick(PrismControlClick: TPrismControl; ARow: Integer; APrismCardGrid: TPrismCardGridDataModel); override;
  public

  protected
   procedure ExportD2Bridge; override;
   procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
   procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
  end;

Function Form1: TForm1;

implementation

Uses
   CardGridDataModelWebApp;

Function Form1: TForm1;
begin
 Result:= TForm1(TForm1.GetInstance);
end;

{$R *.dfm}

procedure TForm1.Button_ViewClick(Sender: TObject);
begin
 ShowMessage(ClientDataSet_Country.FieldByName('Country').AsString);
end;

{ TForm1 }

procedure TForm1.CardGridClick(PrismControlClick: TPrismControl; ARow: Integer; APrismCardGrid: TPrismCardGridDataModel);
begin
  inherited;

end;

procedure TForm1.ExportD2Bridge;
begin
 inherited;

 Title:= 'My D2Bridge Web Application';
 SubTitle:= 'My WebApp';

 //TemplateClassForm:= TD2BridgeFormTemplate;
 D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '';
 D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

 //Export yours Controls
 with D2Bridge.Items.add do
 begin
  VCLObj(MainMenu1);
  VCLObj(Label1);
  VCLObj(Label2);
  VCLObj(Label3);

  with CardGrid(DSCountry) do
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

procedure TForm1.FormShow(Sender: TObject);
begin
 PopuleClientDataSet;
end;

procedure TForm1.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
 inherited;

 //Menu example
 {
  if PrismControl.VCLComponent = MainMenu1 then
   PrismControl.AsMainMenu.Title:= 'AppTeste'; //or in SideMenu use asSideMenu

  if PrismControl.VCLComponent = MainMenu1 then
   PrismControl.AsMainMenu.Image.URL:= 'https://d2bridge.com.br/images/LogoD2BridgeTransp.png'; //or in SideMenu use asSideMenu

  //GroupIndex example
  if PrismControl.VCLComponent = MainMenu1 then
   with PrismControl.AsMainMenu do  //or in SideMenu use asSideMenu
   begin
    MenuGroups[0].Caption:= 'Principal';
    MenuGroups[1].Caption:= 'Services';
    MenuGroups[2].Caption:= 'Items';
   end;

  //Chance Icon and Propertys MODE 1 *Using MenuItem component
  PrismControl.AsMainMenu.MenuItemFromVCLComponent(Abrout1).Icon:= 'fa-solid fa-rocket';

  //Chance Icon and Propertys MODE 2 *Using MenuItem name
  PrismControl.AsMainMenu.MenuItemFromName('Abrout1').Icon:= 'fa-solid fa-rocket';
 }

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

procedure TForm1.Module11Click(Sender: TObject);
begin
 Form1.Show;
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
