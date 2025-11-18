unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Menus, D2Bridge.Forms, Vcl.ExtCtrls, DateUtils, Data.DB, Datasnap.DBClient,
  Vcl.DBCtrls; //Declare D2Bridge.Forms always in the last unit

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
    DSCountry: TDataSource;
    Panel1: TPanel;
    RadioGroup1: TRadioGroup;
    Label_BadgeDynamic: TLabel;
    Button1: TButton;
    Panel2: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Panel3: TPanel;
    Button2: TButton;
    Label20: TLabel;
    Label21: TLabel;
    Button3: TButton;
    Button4: TButton;
    Label22: TLabel;
    Button5: TButton;
    Button6: TButton;
    DBText1: TDBText;
    DBText2: TDBText;
    DBText3: TDBText;
    Button7: TButton;
    DBText4: TDBText;
    DBText5: TDBText;
    Button8: TButton;
    Button9: TButton;
    Label23: TLabel;
    Button10: TButton;
    Label24: TLabel;
    Button11: TButton;
    Label25: TLabel;
    Button12: TButton;
    Label26: TLabel;
    Button13: TButton;
    Label27: TLabel;
    Button14: TButton;
    Label28: TLabel;
    Button15: TButton;
    Label29: TLabel;
    Button16: TButton;
    Label30: TLabel;
    Button17: TButton;
    Label31: TLabel;
    Button18: TButton;
    Label32: TLabel;
    Button19: TButton;
    Label33: TLabel;
    Button20: TButton;
    Label34: TLabel;
    Button21: TButton;
    Label35: TLabel;
    Button22: TButton;
    Label36: TLabel;
    Button23: TButton;
    Label37: TLabel;
    Button24: TButton;
    Label38: TLabel;
    Button25: TButton;
    Label39: TLabel;
    Button26: TButton;
    Label40: TLabel;
    Button27: TButton;
    Label41: TLabel;
    Button28: TButton;
    Label42: TLabel;
    Button29: TButton;
    Label43: TLabel;
    Button30: TButton;
    Label44: TLabel;
    Button31: TButton;
    Label45: TLabel;
    Button32: TButton;
    Label46: TLabel;
    ComboBox1: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Module11Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
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
   BadgeWebApp;

Function Form1: TForm1;
begin
 Result:= TForm1(TForm1.GetInstance);
end;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
 PopuleClientDataSet;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 Label_BadgeDynamic.Caption:= TimeToStr(now);

 Label20.Caption:= IntToStr(SecondOf(now));
 Label22.Caption:= IntToStr(SecondOf(now));
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
 if not ClientDataSet_Country.Bof then
  ClientDataSet_Country.Prior;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
 if not ClientDataSet_Country.Eof then
  ClientDataSet_Country.Next;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
 Label_BadgeDynamic.Visible:= ComboBox1.ItemIndex = 0;
 Label20.Visible:= ComboBox1.ItemIndex = 0;
 Label21.Visible:= ComboBox1.ItemIndex = 0;
 Label22.Visible:= ComboBox1.ItemIndex = 0;
end;

{ TForm1 }

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
  VCLObj(Label1);
  VCLObj(Label2);
  VCLObj(Label3);


  //Dynamic Example
  with Row.Items.Add do
   with Col.Add.Card('Dynamic Badge').Items.Add do
   begin
    with Row.Items.add do
    begin
     ColAuto.Add.VCLObj(Button1);
     ColAuto.Add.VCLObj(RadioGroup1);
     ColAuto.Add.VCLObj(ComboBox1);
    end;

    with Row.Items.add do
    begin
     ColAuto.Add.BadgePillText(Label_BadgeDynamic);
     ColAuto.Add.BadgeButtonText(Button2, Label20);
     ColAuto.Add.BadgeButtonIndicator(Button3, Label21);
     ColAuto.Add.BadgeButtonTopText(Button4, Label22);
    end;
   end;


  //Dataware Example
  with Row.Items.Add do
   with Col.Add.Card('Dataware Badge').Items.Add do
   begin
    with Row.Items.add do
    begin
     ColAuto.Add.VCLObj(Button5, CSSClass.Button.back);
     ColAuto.Add.VCLObj(Button6, CSSClass.Button.next);
    end;

    with Row.Items.add do
    begin
     ColAuto.Add.BadgePillText(DBText1, CSSClass.Color.primary);
     ColAuto.Add.BadgePillText(DBText2, CSSClass.Color.secondary);
     ColAuto.Add.BadgePillText(DBText3, CSSClass.Color.success);
    end;

    with Row.Items.add do
    begin
     ColAuto.Add.BadgeButtonText(Button7, DBText4);
     ColAuto.Add.BadgeButtonTopText(Button8, DBText5, CSSClass.Button.select, CSSClass.Color.danger);
    end;
   end;


  //Static Example
  with Row.Items.Add do
   with Col.Add.Card('Static Badge and Pill').Items.Add do
   begin
    with Row.Items.add do
    begin
     ColAuto.Add.BadgeText(Label4, CSSClass.Color.primary);
     ColAuto.Add.BadgeText(Label5, CSSClass.Color.secondary);
     ColAuto.Add.BadgeText(Label6, CSSClass.Color.success);
     ColAuto.Add.BadgeText(Label7, CSSClass.Color.info);
     ColAuto.Add.BadgeText(Label8, CSSClass.Color.light);
     ColAuto.Add.BadgeText(Label9, CSSClass.Color.warning);
     ColAuto.Add.BadgeText(Label10, CSSClass.Color.danger);
     ColAuto.Add.BadgeText(Label11, CSSClass.Color.dark);
    end;

    with Row.Items.add do
    begin
     ColAuto.Add.BadgePillText(Label12, CSSClass.Color.primary);
     ColAuto.Add.BadgePillText(Label13, CSSClass.Color.secondary);
     ColAuto.Add.BadgePillText(Label14, CSSClass.Color.success);
     ColAuto.Add.BadgePillText(Label15, CSSClass.Color.info);
     ColAuto.Add.BadgePillText(Label16, CSSClass.Color.light);
     ColAuto.Add.BadgePillText(Label17, CSSClass.Color.warning);
     ColAuto.Add.BadgePillText(Label18, CSSClass.Color.danger);
     ColAuto.Add.BadgePillText(Label19, CSSClass.Color.dark);
    end;

    with Row.Items.add do
    begin
     ColAuto.Add.BadgeButtonText(Button9, Label23, '', CSSClass.Color.primary);
     ColAuto.Add.BadgeButtonText(Button10, Label24, '', CSSClass.Color.secondary);
     ColAuto.Add.BadgeButtonText(Button11, Label25, '', CSSClass.Color.success);
     ColAuto.Add.BadgeButtonText(Button12, Label26, '', CSSClass.Color.info);
     ColAuto.Add.BadgeButtonText(Button13, Label27, '', CSSClass.Color.light);
     ColAuto.Add.BadgeButtonText(Button14, Label28, '', CSSClass.Color.warning);
     ColAuto.Add.BadgeButtonText(Button15, Label29, '', CSSClass.Color.danger);
     ColAuto.Add.BadgeButtonText(Button16, Label30, '', CSSClass.Color.dark);
    end;

    with Row.Items.add do
    begin
     ColAuto.Add.BadgeButtonTopText(Button17, Label31, '', CSSClass.Color.primary);
     ColAuto.Add.BadgeButtonTopText(Button18, Label32, '', CSSClass.Color.secondary);
     ColAuto.Add.BadgeButtonTopText(Button19, Label33, '', CSSClass.Color.success);
     ColAuto.Add.BadgeButtonTopText(Button20, Label34, '', CSSClass.Color.info);
     ColAuto.Add.BadgeButtonTopText(Button21, Label35, '', CSSClass.Color.light);
     ColAuto.Add.BadgeButtonTopText(Button22, Label36, '', CSSClass.Color.warning);
     ColAuto.Add.BadgeButtonTopText(Button23, Label37, '', CSSClass.Color.danger);
     ColAuto.Add.BadgeButtonTopText(Button24, Label38, '', CSSClass.Color.dark);
    end;

    with Row.Items.add do
    begin
     ColAuto.Add.BadgeButtonIndicator(Button25, Label39, '', CSSClass.Color.primary);
     ColAuto.Add.BadgeButtonIndicator(Button26, Label40, '', CSSClass.Color.secondary);
     ColAuto.Add.BadgeButtonIndicator(Button27, Label41, '', CSSClass.Color.success);
     ColAuto.Add.BadgeButtonIndicator(Button28, Label42, '', CSSClass.Color.info);
     ColAuto.Add.BadgeButtonIndicator(Button29, Label43, '', CSSClass.Color.light);
     ColAuto.Add.BadgeButtonIndicator(Button30, Label44, '', CSSClass.Color.warning);
     ColAuto.Add.BadgeButtonIndicator(Button31, Label45, '', CSSClass.Color.danger);
     ColAuto.Add.BadgeButtonIndicator(Button32, Label46, '', CSSClass.Color.dark);
    end;
   end;

 end;
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
 TD2BridgeForm(Session.PrimaryForm).Show;
end;

procedure TForm1.PopuleClientDataSet;
begin
  ClientDataSet_Country.Close;
  ClientDataSet_Country.CreateDataSet;

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

  ClientDataSet_Country.First;
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
 if RadioGroup1.ItemIndex = 0 then //Green
 begin
  Label_BadgeDynamic.Color:= clGreen;
  Label_BadgeDynamic.Font.Color:= clWhite;

  Label20.Color:= clGreen;
  Label20.Font.Color:= clWhite;

  Label21.Color:= clGreen;
  Label21.Font.Color:= clWhite;

  Label22.Color:= clGreen;
  Label22.Font.Color:= clWhite;
 end else
  if RadioGroup1.ItemIndex = 1 then //Yellow
  begin
   Label_BadgeDynamic.Color:= clYellow;
   Label_BadgeDynamic.Font.Color:= clBlack;

   Label20.Color:= clYellow;
   Label20.Font.Color:= clBlack;

   Label21.Color:= clYellow;
   Label21.Font.Color:= clBlack;

   Label22.Color:= clYellow;
   Label22.Font.Color:= clBlack;
  end else
   if RadioGroup1.ItemIndex = 2 then //Red
   begin
    Label_BadgeDynamic.Color:= clRed;
    Label_BadgeDynamic.Font.Color:= clWhite;

    Label20.Color:= clRed;
    Label20.Font.Color:= clWhite;

    Label21.Color:= clRed;
    Label21.Font.Color:= clWhite;

    Label22.Color:= clRed;
    Label22.Font.Color:= clWhite;
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
