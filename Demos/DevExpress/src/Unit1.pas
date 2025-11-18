unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.ExtDlgs,
  Vcl.Imaging.pngimage, Vcl.Imaging.jpeg,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore, dxSkinBasic, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkroom, dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans,
  dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin,
  dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray, dxSkinOffice2013White,
  dxSkinOffice2016Colorful, dxSkinOffice2016Dark, dxSkinOffice2019Black, dxSkinOffice2019Colorful,
  dxSkinOffice2019DarkGray, dxSkinOffice2019White, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp,
  dxSkinSharpPlus, dxSkinSilver, dxSkinSpringtime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinTheBezier, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxButtons, cxTextEdit, cxDropDownEdit, cxCheckBox,
  cxRadioGroup, cxLabel, cxImage, cxMemo, Vcl.Menus, cxMaskEdit, Data.DB, Datasnap.DBClient, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxNavigator, dxDateRanges, dxScrollbarAnnotations, cxDBData,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, D2Bridge.Forms,
  cxButtonEdit;

type
  TForm1 = class(TD2BridgeForm)
    Button1: TcxButton;
    Button2: TcxButton;
    Button3: TcxButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel3: TPanel;
    Edit3: TcxTextEdit;
    Panel4: TPanel;
    ComboBox1: TcxComboBox;
    Panel5: TPanel;
    Panel1: TPanel;
    Edit1: TcxTextEdit;
    Panel2: TPanel;
    Edit2: TcxTextEdit;
    Edit_Credito_Nome: TcxTextEdit;
    Edit_Credito_Email: TcxTextEdit;
    Panel6: TPanel;
    CheckBox1: TcxCheckBox;
    Button_Selecionar: TcxButton;
    ComboBox_Selecionar: TcxComboBox;
    Panel7: TPanel;
    RadioButton1: TcxRadioButton;
    RadioButton2: TcxRadioButton;
    RadioButton3: TcxRadioButton;
    Label1: TcxLabel;
    Label_Titulo: TcxLabel;
    Image_Static: TcxImage;
    Image_From_Local: TcxImage;
    Image_From_Web: TcxImage;
    Button4: TcxButton;
    Button_Load_from_Web: TcxButton;
    OpenPictureDialog1: TOpenPictureDialog;
    Memo1: TcxMemo;
    Button5: TcxButton;
    Button6: TcxButton;
    Button7: TcxButton;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    ClientDataSet1Id: TIntegerField;
    ClientDataSet1Nome: TStringField;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1Id: TcxGridDBColumn;
    cxGrid1DBTableView1Nome: TcxGridDBColumn;
    cxButtonEdit1: TcxButtonEdit;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button_SelecionarClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button_Load_from_WebClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure ComboBox_SelecionarPropertiesChange(Sender: TObject);
    procedure ComboBox1PropertiesChange(Sender: TObject);
    procedure cxButtonEdit1PropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    var
     URL_Image_Web : string;
    function OnShowPopupEvent(APopupName: String): string;
    function OnClosePopupEvent(APopupName: String): string;
    procedure Upload(AFiles: TStrings; Sender: TObject);
  protected
    procedure ExportD2Bridge; override;
    procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
    procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
  public

  end;


{$IFDEF D2BRIDGE}
 Function Form1: TForm1;
{$ELSE}
 var
   Form1: TForm1;
{$ENDIF}


implementation

{$R *.dfm}


{$IFDEF D2BRIDGE}
 Function Form1: TForm1;
 begin
  Result:= TForm1(TForm1.GetInstance);
 end;
{$ENDIF}


procedure TForm1.FormCreate(Sender: TObject);
begin
  ClientDataSet1.CreateDataSet;

  ClientDataSet1.Append;
  ClientDataSet1Id.Value:= 1;
  ClientDataSet1Nome.Value:= 'Test';
  ClientDataSet1.Post;

  ClientDataSet1.Append;
  ClientDataSet1Id.Value:= 2;
  ClientDataSet1Nome.Value:= 'Test2';
  ClientDataSet1.Post;

  ClientDataSet1.Append;
  ClientDataSet1Id.Value:= 3;
  ClientDataSet1Nome.Value:= 'Test3';
  ClientDataSet1.Post;

  ClientDataSet1.Append;
  ClientDataSet1Id.Value:= 4;
  ClientDataSet1Nome.Value:= 'Test4';
  ClientDataSet1.Post;

    ClientDataSet1.Append;
  ClientDataSet1Id.Value:= 5;
  ClientDataSet1Nome.Value:= 'Test5';
  ClientDataSet1.Post;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 if Edit1.Text = '' then
 begin
  Showmessage('Inclua o Nome');
  abort;
 end;

 if Edit2.Text = '' then
 begin
  Showmessage('Inclua o Sobre Nome');
  abort;
 end;

 Edit3.Text:= Edit1.Text + ' ' + Edit2.Text;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 if messagedlg('Deseja Limpar os campos?', mtconfirmation, [mbyes,mbno], 0) = mryes then
 begin
  Edit1.Clear;
  Edit2.Clear;
  Edit3.Clear;

  if messagedlg('Deseja Limpar os opções também?', mtconfirmation, [mbyes,mbno], 0) = mryes then
  begin
   ComboBox1.Clear;
   ComboBox_Selecionar.Clear;
  end;
 end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 if Edit3.Text = '' then
 begin
  Showmessage('Nada para criar opção');
  abort;
 end;

 if messagedlg('Deseja realmente criar a opção?', mtconfirmation, [mbyes,mbno], 0) = mryes then
 begin
  Combobox1.Properties.Items.Add(Edit3.Text);
  ComboBox_Selecionar.Properties.Items:= Combobox1.Properties.Items;
 end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
 if OpenPictureDialog1.Execute then
 Image_From_Local.Picture.LoadFromFile(OpenPictureDialog1.FileName);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
 Memo1.Lines.Add('Now: ' + DateTimeToStr(now));
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
 showmessage(Memo1.Lines.Text, true, true);
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
 Memo1.Clear;
end;

procedure TForm1.Button_Load_from_WebClick(Sender: TObject);
begin
 if not IsD2BridgeContext then
 begin
  MessageDlg('This function run just in D2Bridge Context', mtwarning, [mbok], 0);
 end else
 begin
  URL_Image_Web:= 'https://www.d2bridge.com.br/img/d2bridge.png';
  D2Bridge.UpdateD2BridgeControl(Image_From_Web);
 end;
end;

procedure TForm1.Button_SelecionarClick(Sender: TObject);
begin
 {$IFDEF D2BRIDGE}
  ShowPopup('PopupSelecione');
 {$ELSE}
  Showmessage('Selecionado: '+ ComboBox_Selecionar.Text);
 {$ENDIF}
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
 if CheckBox1.Checked then
 CheckBox1.Caption:= 'CheckBox marcado'
 else
 CheckBox1.Caption:= 'CheckBox não marcado';
end;

procedure TForm1.ComboBox1PropertiesChange(Sender: TObject);
begin
  ShowMessage(ComboBox1.Text, true, true);
end;

procedure TForm1.ComboBox_SelecionarPropertiesChange(Sender: TObject);
begin
  ShowMessage(ComboBox_Selecionar.Text, true, true);
end;

procedure TForm1.cxButtonEdit1PropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
 showmessage('cxButtonedit Click');
end;

procedure TForm1.Upload(AFiles: TStrings; Sender: TObject);
begin
 inherited;

 Image_From_Local.Picture.LoadFromFile(AFiles[0]);
end;

procedure TForm1.ExportD2Bridge;
begin
 inherited;

 //Evento do Popup
 OnShowPopup:= OnShowPopupEvent;
 OnClosePopup:= OnClosePopupEvent;


 with D2Bridge.Items.Add do
 begin
  VCLObj(Label_Titulo, CSSClass.Text.Size.fs3+' '+CSSClass.Text.Style.bold);

  with PanelGroup('Nome e Sobrenome').Items.Add do
  begin
   with Row.Items.Add do
   FormGroup('Nome').AddVCLObj(Edit1);

   with Row.Items.Add do
   FormGroup('Sobrenome').AddVCLObj(Edit2);
  end;

  VCLObj(cxGrid1DBTableView1);

  with Row.Items.Add do
  begin
   FormGroup('', CSSClass.Col.colauto).AddVCLObj(Button1);
   FormGroup('', CSSClass.Col.colauto).AddVCLObj(Button3);
   FormGroup('', CSSClass.Col.colauto).AddVCLObj(Button2);
  end;

  with Row.Items.Add do
   with Tabs do
   begin
    with AddTab(PageControl1.Pages[0].Caption).Items.Add do
    FormGroup(Panel3.Caption, CSSClass.Col.colsize4).AddVCLObj(Edit3);

    with AddTab(PageControl1.Pages[1].Caption).Items.Add do
    FormGroup(Panel4.Caption, CSSClass.Col.colsize4).AddVCLObj(ComboBox1);
   end;

  with Row.Items.Add do
   with PanelGroup('CheckBox').Items.Add do
    VCLObj(CheckBox1);

  with Row.Items.Add do
   FormGroup.AddVCLObj(Button_Selecionar);

   //Combobox
  with Row.Items.Add do
  begin
   with PanelGroup('Selecione 1 item').Items.Add do
   begin
    VCLObj(RadioButton1);
    VCLObj(RadioButton2);
    VCLObj(RadioButton3);
   end;
  end;

  //Popup
  with Popup('PopupSelecione', 'Selecione o Item').Items.Add do
   with Row.Items.Add do
    FormGroup('Selecione').AddVCLObj(ComboBox_Selecionar);

  //cxButtonEdit
  with Row.Items.Add do
   FormGroup('cxButtonEdit Example').AddVCLObj(cxButtonEdit1);

  //Images
  with Row.Items.Add do
  begin
   with PanelGroup('Static Image', '', false, CSSClass.Col.colsize2).Items.Add do
    VCLObj(Image_Static);

   with PanelGroup('Upload Image', '', false, CSSClass.Col.colsize6).Items.Add do
   begin
    VCLObj(Image_From_Local);
    Upload;
   end;

   with PanelGroup('Load from Web', '', false, CSSClass.Col.colsize2).Items.Add do
   begin
    VCLObj(Image_From_Web);
    VCLObj(Button_Load_from_Web);
   end;
  end;


  //Memo
  with Row.Items.Add do
  begin
   with HTMLDIV.Items.Add do
   begin
    VCLObj(Button5);
    VCLObj(Button6);
    VCLObj(Button7);
   end;

   HTMLDIV('mb1');

   VCLObj(Memo1);
  end;


  //Accordion
  with Row.Items.Add do
   with Accordion do
    with AddAccordionItem('Mostrar créditos').Items.Add do
    begin
     with Row.Items.Add do
      FormGroup('Nome').AddVCLObj(Edit_Credito_Nome);
     with Row.Items.Add do
      FormGroup('Contato').AddVCLObj(Edit_Credito_Email);
    end;

 end;

 //Event Upload
 OnUpload:= Upload;
end;

procedure TForm1.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
 if PrismControl.IsMemo then
  PrismControl.AsMemo.Rows:= 5;
end;

function TForm1.OnClosePopupEvent(APopupName: String): string;
begin
 if SameText(APopupName, 'PopupSelecione') then
  Showmessage('Selecionado: '+ ComboBox_Selecionar.Text);
end;

function TForm1.OnShowPopupEvent(APopupName: String): string;
begin
 if SameText(APopupName, 'PopupSelecione') then
  ComboBox_Selecionar.Text:= '';
end;

procedure TForm1.RenderD2Bridge(const PrismControl: TPrismControl;
  var HTMLControl: string);
begin
 inherited;

 if PrismControl.VCLComponent = Image_From_Web then
  PrismControl.AsImage.URLImage:= URL_Image_Web;

end;

end.
