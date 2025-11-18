unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.ExtDlgs, Vcl.Imaging.pngimage, Vcl.Imaging.jpeg,
  Vcl.Menus, System.ImageList, Vcl.ImgList, Vcl.Mask, D2Bridge.Forms;

type
  TForm1 = class(TD2BridgeForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel3: TPanel;
    Edit3: TEdit;
    Panel4: TPanel;
    ComboBox1: TComboBox;
    Panel5: TPanel;
    Panel1: TPanel;
    Edit1: TEdit;
    Panel2: TPanel;
    Edit2: TEdit;
    Edit_Credito_Nome: TEdit;
    Edit_Credito_Email: TEdit;
    Panel6: TPanel;
    CheckBox1: TCheckBox;
    Button_Selecionar: TButton;
    ComboBox_Selecionar: TComboBox;
    Panel7: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Label1: TLabel;
    Label_Titulo: TLabel;
    Image_Static: TImage;
    Image_From_Local: TImage;
    Image_From_Web: TImage;
    Button4: TButton;
    Button_Load_from_Web: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    Memo1: TMemo;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    PopupMenu1: TPopupMenu;
    Join1: TMenuItem;
    CreateOption1: TMenuItem;
    Clear1: TMenuItem;
    N1: TMenuItem;
    ShowTab01: TMenuItem;
    ShowTab11: TMenuItem;
    N2: TMenuItem;
    ab0Invisible1: TMenuItem;
    ab1Invisible1: TMenuItem;
    N3: TMenuItem;
    ab0Visible1: TMenuItem;
    ab1Visible1: TMenuItem;
    ButtonedEdit1: TButtonedEdit;
    ImageList1: TImageList;
    ButtonedEdit2: TButtonedEdit;
    LabeledEdit1: TLabeledEdit;
    N4: TMenuItem;
    HideTabs1: TMenuItem;
    ShowTabs1: TMenuItem;
    RadioGroup1: TRadioGroup;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    ButtonedEdit3: TButtonedEdit;
    Label2: TLabel;
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
    procedure ShowTab01Click(Sender: TObject);
    procedure ShowTab11Click(Sender: TObject);
    procedure ab0Invisible1Click(Sender: TObject);
    procedure ab1Invisible1Click(Sender: TObject);
    procedure ab0Visible1Click(Sender: TObject);
    procedure ab1Visible1Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure ButtonedEdit1RightButtonClick(Sender: TObject);
    procedure ButtonedEdit2LeftButtonClick(Sender: TObject);
    procedure ButtonedEdit2RightButtonClick(Sender: TObject);
    procedure ButtonedEdit3LeftButtonClick(Sender: TObject);
    procedure ButtonedEdit3RightButtonClick(Sender: TObject);
    procedure ShowTabs1Click(Sender: TObject);
    procedure HideTabs1Click(Sender: TObject);
  private
    var
     URL_Image_Web : string;
    function OnShowPopupEvent(APopupName: String): string;
    function OnClosePopupEvent(APopupName: String): string;
    procedure Upload(AFiles: TStrings; Sender: TObject); override;
  protected
    procedure ExportD2Bridge; override;
    procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
    procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
    procedure EventD2Bridge(const PrismControl: TPrismControl; const EventType: TPrismEventType; EventParams: TStrings); override;
  public

  end;

 Function Form1: TForm1;


implementation

{$R *.dfm}

Function Form1: TForm1;
begin
 Result:= TForm1(TForm1.GetInstance);
end;

procedure TForm1.ab0Invisible1Click(Sender: TObject);
begin
 D2Bridge.PrismControlFromID('TabControl1').AsTabs.TabVisible[0]:= false;
end;

procedure TForm1.ab0Visible1Click(Sender: TObject);
begin
 D2Bridge.PrismControlFromID('TabControl1').AsTabs.TabVisible[0]:= true;
end;

procedure TForm1.ab1Invisible1Click(Sender: TObject);
begin
 D2Bridge.PrismControlFromID('TabControl1').AsTabs.TabVisible[1]:= false;
end;

procedure TForm1.ab1Visible1Click(Sender: TObject);
begin
 D2Bridge.PrismControlFromID('TabControl1').AsTabs.TabVisible[1]:= true;
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
 RadioGroup1.Caption:= 'New '+DateTimeToStr(now);
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
 RadioGroup1.Items.Add('New Item'+IntToStr(RadioGroup1.Items.Count + 1));
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 if Edit1.Text = '' then
 begin
  MessageDlg('Add the name', TMsgDlgType.mtWarning, [mbok], 0);
  abort;
 end;

 if Edit2.Text = '' then
 begin
  MessageDlg('Add the last name', TMsgDlgType.mtWarning, [mbok], 0);
  abort;
 end;

 Edit3.Text:= Edit1.Text + ' ' + Edit2.Text;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 if messagedlg('Confirm clear all fields?', mtconfirmation, [mbyes,mbno], 0) = mryes then
 begin
  Edit1.Clear;
  Edit2.Clear;
  Edit3.Clear;

  if messagedlg('Confirm clear the options also?', mtconfirmation, [mbyes,mbno], 0) = mryes then
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
  Showmessage('Nothing to create options');
  abort;
 end;

 if messagedlg('Really create the option?', mtconfirmation, [mbyes,mbno], 0) = mryes then
 begin
  Combobox1.Items.Add(Edit3.Text);
  ComboBox_Selecionar.Items:= Combobox1.Items;
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

procedure TForm1.Button9Click(Sender: TObject);
begin
 RadioGroup1.ItemIndex:= 1;
end;

procedure TForm1.ButtonedEdit1RightButtonClick(Sender: TObject);
begin
 Showmessage('Right button click');
end;

procedure TForm1.ButtonedEdit2LeftButtonClick(Sender: TObject);
var
 vInt: integer;
begin
 if TryStrToInt(ButtonedEdit2.Text, vInt) then
  ButtonedEdit2.Text:= IntToStr(vInt - 1);
end;

procedure TForm1.ButtonedEdit2RightButtonClick(Sender: TObject);
var
 vInt: integer;
begin
 if TryStrToInt(ButtonedEdit2.Text, vInt) then
  ButtonedEdit2.Text:= IntToStr(vInt + 1);
end;

procedure TForm1.ButtonedEdit3LeftButtonClick(Sender: TObject);
begin
 if RadioGroup1.Columns > 1 then
  RadioGroup1.Columns:= RadioGroup1.Columns - 1;

 ButtonedEdit3.Text:= IntToStr(RadioGroup1.Columns);
end;

procedure TForm1.ButtonedEdit3RightButtonClick(Sender: TObject);
begin
 RadioGroup1.Columns:= RadioGroup1.Columns + 1;

 ButtonedEdit3.Text:= IntToStr(RadioGroup1.Columns);
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
 CheckBox1.Caption:= 'CheckBox checked'
 else
 CheckBox1.Caption:= 'CheckBox unchecked';
end;

procedure TForm1.Upload(AFiles: TStrings; Sender: TObject);
begin
 inherited;

 Image_From_Local.Picture.LoadFromFile(AFiles[0]);
end;

procedure TForm1.EventD2Bridge(const PrismControl: TPrismControl;
  const EventType: TPrismEventType; EventParams: TStrings);
begin
 if PrismControl.IsTabs then
  if (PrismControl.Name = 'TabControl1') and (EventType = TPrismEventType.EventOnChange) then
  begin
   Showmessage('Tab ' + IntToStr(PrismControl.AsTabs.ActiveTabIndex) + ' Activate');
  end;
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

  with PanelGroup('Full name').Items.Add do
  begin
   with Row.Items.Add do
   FormGroup('Name').AddVCLObj(Edit1);

   with Row.Items.Add do
   FormGroup('Last Name').AddVCLObj(Edit2);
  end;

  with Row.Items.Add do
  begin
   FormGroup('', CSSClass.Col.colauto).AddVCLObj(Button1, CSSClass.Button.config);
   FormGroup('', CSSClass.Col.colauto).AddVCLObj(Button3, CSSClass.Button.add);
   FormGroup('', CSSClass.Col.colauto).AddVCLObj(Button2, CSSClass.Button.delete);
   FormGroup('', CSSClass.Col.colauto).AddVCLObj(Button8, PopupMenu1, CSSClass.Button.options);
  end;

  with Row.Items.Add do
   with Tabs('TabControl1') do
   begin
    //Disable Tabs
    //ShowTabs:= false;

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

   //Radio Buttons
  with Row.Items.Add do
  begin
   with PanelGroup('Select 1 item').Items.Add do
   begin
    VCLObj(RadioButton1);
    VCLObj(RadioButton2);
    VCLObj(RadioButton3);
   end;
  end;

  //RadioGroup
  Row.Items.Add.Col.Add.VCLObj(RadioGroup1);
  with Row.Items.Add do
  begin
   FormGroup.AddVCLObj(Button9);
   FormGroup.AddVCLObj(Button10);
   FormGroup.AddVCLObj(Button11);
   FormGroup('Columns').AddVCLObj(ButtonedEdit3);
  end;

  //Popup
  with Popup('PopupSelecione', 'Select the item').Items.Add do
   with Row.Items.Add do
    FormGroup('Select').AddVCLObj(ComboBox_Selecionar);

  //LabeledEdit
  with Row.Items.Add do
   FormGroup(LabeledEdit1, CSSClass.Col.col);

  //ButtonedEdit
  with Row.Items.Add do
  begin
   FormGroup('ButtonedEdit Info').AddVCLObj(ButtonedEdit1);
   FormGroup('ButtonedEdit + and -').AddVCLObj(ButtonedEdit2);
  end;

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
    with AddAccordionItem('Show information (accordion)').Items.Add do
    begin
     with Row.Items.Add do
      FormGroup('Name').AddVCLObj(Edit_Credito_Nome);
     with Row.Items.Add do
      FormGroup('Contact').AddVCLObj(Edit_Credito_Email);
    end;
 end;

 //Event Upload
 //Use This event or Use Override in Upload method
 //OnUpload:= Upload;
end;

procedure TForm1.HideTabs1Click(Sender: TObject);
begin
 D2Bridge.PrismControlFromID('TabControl1').AsTabs.ShowTabs:= false;
end;

procedure TForm1.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
 if PrismControl.IsMemo then
  PrismControl.AsMemo.Rows:= 5;

 //ButtonedEdit2 Icons
 if PrismControl.VCLComponent = ButtonedEdit2 then
  with PrismControl.AsButtonedEdit do
  begin
   ButtonLeftCSS:= CSSClass.Button.decrease;
   ButtonRightCSS:= CSSClass.Button.increase;
  end;

 //ButtonedEdit3 Icons
 if PrismControl.VCLComponent = ButtonedEdit3 then
  with PrismControl.AsButtonedEdit do
  begin
   ButtonLeftCSS:= CSSClass.Button.decrease;
   ButtonRightCSS:= CSSClass.Button.increase;
  end;
end;

function TForm1.OnClosePopupEvent(APopupName: String): string;
begin
 if SameText(APopupName, 'PopupSelecione') then
  Showmessage('Select: '+ ComboBox_Selecionar.Text);
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

procedure TForm1.ShowTab01Click(Sender: TObject);
begin
 D2Bridge.PrismControlFromID('TabControl1').AsTabs.ActiveTabIndex:= 0;
end;

procedure TForm1.ShowTab11Click(Sender: TObject);
begin
 D2Bridge.PrismControlFromID('TabControl1').AsTabs.ActiveTabIndex:= 1;
end;

procedure TForm1.ShowTabs1Click(Sender: TObject);
begin
 D2Bridge.PrismControlFromID('TabControl1').AsTabs.ShowTabs:= true;
end;

end.
