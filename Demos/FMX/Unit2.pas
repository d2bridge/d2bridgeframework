unit Unit2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.ComboEdit, FMX.Edit, FMX.ListBox, FMX.TabControl, FMX.Memo.Types, FMX.ScrollBox,
  FMX.Memo, FMX.Objects, D2Bridge.API.QRCode, D2Bridge.Forms, System.Rtti,
  {$IF CompilerVersion >= 34}FMX.Grid.Style,{$ENDIF} Data.DB, Datasnap.DBClient,
  FMX.Grid, FMX.Layouts;

type
  TForm2 = class(TD2BridgeForm)
    Label_Titulo: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    Panel4: TPanel;
    Label3: TLabel;
    Panel5: TPanel;
    Panel6: TPanel;
    Label4: TLabel;
    Edit3: TEdit;
    Panel7: TPanel;
    Label5: TLabel;
    ComboBox1: TComboBox;
    Button_Selecionar: TButton;
    ComboBox_Selecionar: TComboBox;
    Image_Static: TImage;
    Image_From_Local: TImage;
    Image_From_Web: TImage;
    Button4: TButton;
    Button_Load_from_Web: TButton;
    Memo1: TMemo;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Edit_Credito_Email: TEdit;
    Edit_Credito_Nome: TEdit;
    CheckBox1: TCheckBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    OpenDialog1: TOpenDialog;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Edit4: TEdit;
    Button8: TButton;
    Image1: TImage;
    Edit5: TEdit;
    Edit6: TEdit;
    Button9: TButton;
    StringGrid1: TStringGrid;
    ClientDataSet_Country: TClientDataSet;
    ClientDataSet_CountryAutoCod: TAutoIncField;
    ClientDataSet_CountryCountry: TStringField;
    ClientDataSet_CountryDDI: TStringField;
    ClientDataSet_CountryPopulation: TIntegerField;
    StringColumn1: TStringColumn;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button_Load_from_WebClick(Sender: TObject);
    procedure Button_SelecionarClick(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
  private
    { Private declarations }
    URL_Image_Web: string;
    FD2BridgeAPIQRCode: TD2BridgeAPIQRCode;
    function OnShowPopupEvent(APopupName: String): string;
    function OnClosePopupEvent(APopupName: String): string;
    procedure Upload(AFiles: TStrings; Sender: TObject);
    Procedure PopuleClientDataSet;
    procedure PopuleStringGrid;
  protected
    procedure ExportD2Bridge; override;
    procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
    procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
  public
    { Public declarations }
  end;

{$IFDEF D2BRIDGE}
 function Form2: TForm2;
{$ELSE}
 var
   Form2: TForm2;
{$ENDIF}

implementation

{$R *.fmx}

{$IFDEF D2BRIDGE}
function Form2: TForm2;
begin
  Result:= TForm2(TForm2.GetInstance);
end;
{$ENDIF}

procedure TForm2.FormDestroy(Sender: TObject);
begin
 FreeAndNil(FD2BridgeAPIQRCode);
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
 FD2BridgeAPIQRCode:= TD2BridgeAPIQRCode.Create;

 PopuleClientDataSet;
 PopuleStringGrid;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  if Edit1.Text = '' then
  begin
    ShowMessage('Add the First Name');
    Abort;
  end;

  if Edit2.Text = '' then
  begin
    ShowMessage('Add the Last Name');
    Abort;
  end;

  Edit3.Text:= Edit1.Text + ' ' + Edit2.Text;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  if MessageDlg('Clean all fields?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrYes then
  begin
    Edit1.Text:= '';
    Edit2.Text:= '';
    Edit3.Text:= '';

    if MessageDlg('Clean options also?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrYes then
    begin
      ComboBox1.Clear;
      ComboBox_Selecionar.Clear;
    end;
   end;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  if Edit3.Text = '' then
  begin
    ShowMessage('None to create the option');
    Abort;
  end;

  if MessageDlg('Create option?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrYes then
  begin
    Combobox1.Items.Add(Edit3.Text);
    ComboBox_Selecionar.Items:= Combobox1.Items;
  end;
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    Image_From_Local.Bitmap.LoadFromFile(OpenDialog1.FileName);
end;

procedure TForm2.Button5Click(Sender: TObject);
begin
  Memo1.Lines.Add('Now: ' + DateTimeToStr(Now));
end;

procedure TForm2.Button6Click(Sender: TObject);
begin
  ShowMessage(Memo1.Lines.Text);
end;

procedure TForm2.Button7Click(Sender: TObject);
begin
  Memo1.Lines.Clear;
end;

procedure TForm2.Button8Click(Sender: TObject);
begin
 FD2BridgeAPIQRCode.Text:= Edit4.Text;
 Image1.Bitmap.Assign(FD2BridgeAPIQRCode.QRCodeJPG);
end;

procedure TForm2.Button9Click(Sender: TObject);
begin
 if IsD2BridgeContext then
  D2Bridge.PrismControlFromID('QRCodeDynamic').AsQRCode.Text:= Edit6.Text
 else
  Showmessage('Just D2Bridge Web');
end;

procedure TForm2.Button_Load_from_WebClick(Sender: TObject);
begin
  if not IsD2BridgeContext then
  begin
    MessageDlg('This function run just in D2Bridge Context', TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
  end else
  begin
    URL_Image_Web:= 'https://www.d2bridge.com.br/img/d2bridge.png';
    D2Bridge.UpdateD2BridgeControl(Image_From_Web);
  end;
end;

procedure TForm2.Button_SelecionarClick(Sender: TObject);
begin
{$IFDEF D2BRIDGE}
  ShowPopup('PopupSelecione');
{$ELSE}
  if ComboBox_Selecionar.Selected <> nil then
    ShowMessage('Selected: ' + ComboBox_Selecionar.Selected.Text)
  else
    ShowMessage('Selectd: None');
{$ENDIF}
end;

procedure TForm2.CheckBox1Change(Sender: TObject);
begin
  if CheckBox1.IsChecked then
    CheckBox1.Text:= 'CheckBox checked'
  else
    CheckBox1.Text:= 'CheckBox unchecked';
end;

procedure TForm2.ExportD2Bridge;
begin
  inherited;

  //Evento do Popup
  OnShowPopup:= OnShowPopupEvent;
  OnClosePopup:= OnClosePopupEvent;

  with D2Bridge.Items.Add do
  begin
    VCLObj(Label_Titulo, CSSClass.Text.Size.fs3+' '+CSSClass.Text.Style.bold);

    with PanelGroup('Full Name').Items.Add do
    begin
      with Row.Items.Add do
        FormGroup('First Name').AddVCLObj(Edit1);

      with Row.Items.Add do
        FormGroup('Last Name').AddVCLObj(Edit2);
    end;

    with Row.Items.Add do
    begin
      FormGroup('', CSSClass.Col.colauto).AddVCLObj(Button1);
      FormGroup('', CSSClass.Col.colauto).AddVCLObj(Button3);
      FormGroup('', CSSClass.Col.colauto).AddVCLObj(Button2);
    end;

    VCLObj(StringGrid1);

    with Row.Items.Add do
      with Tabs do
      begin
        with AddTab(TabControl1.Tabs[0].Text).Items.Add do
          FormGroup(Label4.Text, CSSClass.Col.colsize4).AddVCLObj(Edit3);

        with AddTab(TabControl1.Tabs[1].Text).Items.Add do
          FormGroup(Label5.Text, CSSClass.Col.colsize4).AddVCLObj(ComboBox1);
      end;

    with Row.Items.Add do
      with PanelGroup('CheckBox').Items.Add do
        VCLObj(CheckBox1);

    with Row.Items.Add do
      FormGroup.AddVCLObj(Button_Selecionar);

    //Combobox
    with Row.Items.Add do
    begin
      with PanelGroup('Select one item').Items.Add do
      begin
        VCLObj(RadioButton1);
        VCLObj(RadioButton2);
        VCLObj(RadioButton3);
      end;
    end;

    //Popup
    with Popup('PopupSelecione', 'Select on Item').Items.Add do
      with Row.Items.Add do
        FormGroup('Select').AddVCLObj(ComboBox_Selecionar);

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

    with row.Items.Add do
    begin
     with HTMLDiv(CSSClass.Col.col).Items.Add do
     with  CardGrid do
     begin
      ColSize:= 'row-cols-md-1 row-cols-lg-1';
      EqualHeight:= true;

      //VCL and WEB
      with AddCard(GroupBox1.Text).Items.Add do
      begin
       with Row.Items.Add do
       begin
        with HTMLDiv(CSSClass.Col.colsize8).Items.Add do
         with Row.Items.Add do
         begin
          FormGroup('', CSSClass.Col.col).AddVCLObj(Edit4);
          FormGroup.AddVCLObj(Button8);
         end;

        with HTMLDiv(CSSClass.Col.colsize4).Items.Add do
         VCLObj(Image1);
       end;
      end;

      //VCL Static
      with AddCard(GroupBox2.Text).Items.Add do
      begin
       with Row.Items.Add do
       begin
        with HTMLDiv(CSSClass.Col.colsize8).Items.Add do
         with Row.Items.Add do
          FormGroup('', CSSClass.Col.col).AddVCLObj(Edit5);

        with HTMLDiv(CSSClass.Col.colsize4).Items.Add do
         QRCode(Edit5.Text);
       end;
      end;

      //WEB Dynamic
      with AddCard(GroupBox3.Text).Items.Add do
      begin
       with Row.Items.Add do
       begin
        with HTMLDiv(CSSClass.Col.colsize8).Items.Add do
         with Row.Items.Add do
         begin
          FormGroup('', CSSClass.Col.col).AddVCLObj(Edit6);
          FormGroup.AddVCLObj(Button9);
         end;

        with HTMLDiv(CSSClass.Col.colsize4).Items.Add do
         QRCode(Edit6.Text, 'QRCodeDynamic');
       end;
      end;
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
        with AddAccordionItem('Show Credits').Items.Add do
        begin
          with Row.Items.Add do
            FormGroup('Name').AddVCLObj(Edit_Credito_Nome);

          with Row.Items.Add do
            FormGroup('Email').AddVCLObj(Edit_Credito_Email);
        end;
  end;

  //Event Upload
  OnUpload:= Upload;
end;

procedure TForm2.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string);
begin
  inherited;

  if PrismControl.VCLComponent = Image_From_Web then
    PrismControl.AsImage.URLImage:= URL_Image_Web;
end;

procedure TForm2.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
  if PrismControl.IsMemo then
    PrismControl.AsMemo.Rows:= 5;

  if PrismControl.IsStringGrid then
  begin
    PrismControl.AsStringGrid.RecordsPerPage:= 10;
    PrismControl.AsStringGrid.MaxRecords:= 2000;
  end;
end;

function TForm2.OnClosePopupEvent(APopupName: String): string;
begin
  if SameText(APopupName, 'PopupSelecione') then
    if ComboBox_Selecionar.Selected <> nil then
      ShowMessage('Selecionado: ' + ComboBox_Selecionar.Selected.Text)
    else
      ShowMessage('Selecionado: Nenhum');
end;

function TForm2.OnShowPopupEvent(APopupName: String): string;
begin
  if SameText(APopupName, 'PopupSelecione') then
    ComboBox_Selecionar.ItemIndex:= -1;
end;

procedure TForm2.PopuleClientDataSet;
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

procedure TForm2.PopuleStringGrid;
var
  I, N, nLinha: integer;
  StringColumn: TStringColumn;
begin
  { Informa configuração da StringGrid }
  {$IF CompilerVersion >= 34} // Delphi 10.4 Sydney or Upper
  StringGrid1.ClearColumns;
  {$ELSE}
  for I := Pred(StringGrid1.ColumnCount) downto 0 do
   StringGrid1.Columns[0].Destroy;
  {$ENDIF}
  StringGrid1.RowCount:= ClientDataSet_Country.RecordCount;

  { Altura de cada célula }
  StringGrid1.RowHeight:= 21;

  { Monta coluna da StringGrid }
  for I:= 0 to ClientDataSet_Country.FieldCount - 1 do
  begin
    StringColumn:= TStringColumn.Create(StringGrid1);

    StringColumn.Header:= ClientDataSet_Country.Fields[I].DisplayLabel;

    { comprimento em pixels da coluna}
    StringColumn.Width:= ClientDataSet_Country.Fields[I].DisplayWidth * 2;

    { alinhamento da coluna}
    {$IF CompilerVersion >= 34} // Delphi 10.4 Sydney or Upper
    case ClientDataSet_Country.Fields[I].Alignment of
      TAlignment.taLeftJustify:  StringColumn.HorzAlign:= TTextAlign.Leading;
      TAlignment.taCenter:       StringColumn.HorzAlign:= TTextAlign.Center;
      TAlignment.taRightJustify: StringColumn.HorzAlign:= TTextAlign.Trailing;
    end;
    {$ENDIF}

    StringGrid1.AddObject(StringColumn);
  end;

  { Prenche StringGrid }
  nLinha:= 0;

  ClientDataSet_Country.First;
  while not ClientDataSet_Country.Eof do
  begin
    for N:= 0 to ClientDataSet_Country.FieldCount - 1 do
      StringGrid1.Cells[N, nLinha]:= ClientDataSet_Country.FieldByName(ClientDataSet_Country.Fields[N].DisplayLabel).Text;

    Inc(nLinha);

    ClientDataSet_Country.Next;
  end;
end;

procedure TForm2.Upload(AFiles: TStrings; Sender: TObject);
begin
  inherited;

  Image_From_Local.Bitmap.LoadFromFile(AFiles[0]);
end;

end.
