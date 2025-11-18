unit unitcontrols;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
 Classes, SysUtils, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, ComCtrls,
 EditBtn, ExtDlgs, Menus, D2Bridge.Forms;

type

 { TFormControls }

 TFormControls = class(TD2BridgeForm)
  ab0Invisible1: TMenuItem;
  ab0Visible1: TMenuItem;
  ab1Invisible1: TMenuItem;
  ab1Visible1: TMenuItem;
  Button1: TButton;
  Button10: TButton;
  Button11: TButton;
  Button12: TButton;
  Button13: TButton;
  Button2: TButton;
  Button3: TButton;
  Button4: TButton;
  Button5: TButton;
  Button6: TButton;
  Button7: TButton;
  Button8: TButton;
  Button9: TButton;
  Button_Load_from_Web: TButton;
  Button_Selecionar: TButton;
  CheckBox1: TCheckBox;
  Clear1: TMenuItem;
  ComboBox1: TComboBox;
  ComboBox_Selecionar: TComboBox;
  CreateOption1: TMenuItem;
  Edit1: TEdit;
  Edit2: TEdit;
  Edit3: TEdit;
  EditButton1: TEditButton;
  Edit_Credito_Email: TEdit;
  Edit_Credito_Nome: TEdit;
  ImageList1: TImageList;
  Image_From_Local: TImage;
  Image_From_Web: TImage;
  Image_Static: TImage;
  Join1: TMenuItem;
  Label1: TLabel;
  Label2: TLabel;
  LabeledEdit1: TLabeledEdit;
  Label_Titulo: TLabel;
  Memo1: TMemo;
  N1: TMenuItem;
  N2: TMenuItem;
  N3: TMenuItem;
  OpenPictureDialog1: TOpenPictureDialog;
  PageControl1: TPageControl;
  Panel1: TPanel;
  Panel2: TPanel;
  Panel3: TPanel;
  Panel4: TPanel;
  Panel5: TPanel;
  Panel6: TPanel;
  Panel7: TPanel;
  PopupMenu1: TPopupMenu;
  RadioButton1: TRadioButton;
  RadioButton2: TRadioButton;
  RadioButton3: TRadioButton;
  RadioGroup1: TRadioGroup;
  ShowTab01: TMenuItem;
  ShowTab11: TMenuItem;
  TabSheet1: TTabSheet;
  TabSheet2: TTabSheet;
  procedure ab0Invisible1Click(Sender: TObject);
  procedure ab0Visible1Click(Sender: TObject);
  procedure ab1Invisible1Click(Sender: TObject);
  procedure ab1Visible1Click(Sender: TObject);
  procedure Button10Click(Sender: TObject);
  procedure Button11Click(Sender: TObject);
  procedure Button12Click(Sender: TObject);
  procedure Button13Click(Sender: TObject);
  procedure Button1Click(Sender: TObject);
  procedure Button2Click(Sender: TObject);
  procedure Button3Click(Sender: TObject);
  procedure Button4Click(Sender: TObject);
  procedure Button5Click(Sender: TObject);
  procedure Button6Click(Sender: TObject);
  procedure Button7Click(Sender: TObject);
  procedure Button9Click(Sender: TObject);
  procedure Button_Load_from_WebClick(Sender: TObject);
  procedure Button_SelecionarClick(Sender: TObject);
  procedure CheckBox1Click(Sender: TObject);
  procedure Clear1Click(Sender: TObject);
  procedure CreateOption1Click(Sender: TObject);
  procedure EditButton1ButtonClick(Sender: TObject);
  procedure Join1Click(Sender: TObject);
  procedure ShowTab01Click(Sender: TObject);
  procedure ShowTab11Click(Sender: TObject);
 private
  URL_Image_Web : string;
 public
  { Public declarations }
 protected
  procedure ExportD2Bridge; override;
  procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
  procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
  procedure EventD2Bridge(const PrismControl: TPrismControl; const EventType: TPrismEventType; EventParams: TStrings); override;
  procedure Upload(AFiles: TStrings; Sender: TObject); override;
 end;

function FormControls: TFormControls;

implementation

uses
 LazarusWebApp, D2BridgeFormTemplate;

{$R *.lfm}

function FormControls: TFormControls;
begin
 result:= (TFormControls.GetInstance as TFormControls);
end;

procedure TFormControls.Button1Click(Sender: TObject);
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

procedure TFormControls.ab0Invisible1Click(Sender: TObject);
begin
 {$IFDEF D2BRIDGE}
  D2Bridge.PrismControlFromID('TabControl1').AsTabs.TabVisible[0]:= false;
 {$ENDIF}
end;

procedure TFormControls.ab0Visible1Click(Sender: TObject);
begin
 {$IFDEF D2BRIDGE}
  D2Bridge.PrismControlFromID('TabControl1').AsTabs.TabVisible[0]:= true;
 {$ENDIF}
end;

procedure TFormControls.ab1Invisible1Click(Sender: TObject);
begin
 {$IFDEF D2BRIDGE}
  D2Bridge.PrismControlFromID('TabControl1').AsTabs.TabVisible[1]:= false;
 {$ENDIF}
end;

procedure TFormControls.ab1Visible1Click(Sender: TObject);
begin
 {$IFDEF D2BRIDGE}
  D2Bridge.PrismControlFromID('TabControl1').AsTabs.TabVisible[1]:= true;
 {$ENDIF}
end;

procedure TFormControls.Button10Click(Sender: TObject);
begin
 RadioGroup1.Caption:= 'New '+DateTimeToStr(now);
end;

procedure TFormControls.Button11Click(Sender: TObject);
begin
 RadioGroup1.Items.Add('New Item'+IntToStr(RadioGroup1.Items.Count + 1));
end;

procedure TFormControls.Button12Click(Sender: TObject);
begin
 if RadioGroup1.Columns > 1 then
  RadioGroup1.Columns:= RadioGroup1.Columns - 1;
end;

procedure TFormControls.Button13Click(Sender: TObject);
begin
 RadioGroup1.Columns:= RadioGroup1.Columns + 1;
end;

procedure TFormControls.Button2Click(Sender: TObject);
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

procedure TFormControls.Button3Click(Sender: TObject);
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

procedure TFormControls.Button4Click(Sender: TObject);
begin
 if OpenPictureDialog1.Execute then
  Image_From_Local.Picture.LoadFromFile(OpenPictureDialog1.FileName);
end;

procedure TFormControls.Button5Click(Sender: TObject);
begin
 Memo1.Lines.Add('Now: ' + DateTimeToStr(now));
end;

procedure TFormControls.Button6Click(Sender: TObject);
begin
 ShowMessage(Memo1.Lines.Text);
 ShowMessage(Memo1.Lines.Text, true, true);
end;

procedure TFormControls.Button7Click(Sender: TObject);
begin
 Memo1.Clear;
end;

procedure TFormControls.Button9Click(Sender: TObject);
begin
 RadioGroup1.ItemIndex:= 1;
end;

procedure TFormControls.Button_Load_from_WebClick(Sender: TObject);
begin
 if not IsD2BridgeContext then
 begin
  MessageDlg('This function run just in D2Bridge Context', mtwarning, [mbok], 0);
 end else
 begin
{$IFDEF D2BRIDGE}
  URL_Image_Web:= 'https://www.d2bridge.com.br/img/d2bridge.png';
  D2Bridge.UpdateD2BridgeControl(Image_From_Web);
{$ENDIF}
 end;
end;

procedure TFormControls.Button_SelecionarClick(Sender: TObject);
begin
 {$IFDEF D2BRIDGE}
   ShowPopup('PopupSelecione');
 {$ELSE}
   Showmessage('Selecionado: '+ ComboBox_Selecionar.Text);
 {$ENDIF}
end;

procedure TFormControls.CheckBox1Click(Sender: TObject);
begin
 if CheckBox1.Checked then
  CheckBox1.Caption:= 'CheckBox checked'
 else
  CheckBox1.Caption:= 'CheckBox unchecked';
end;

procedure TFormControls.Clear1Click(Sender: TObject);
begin
 Button2Click(Button2);
end;

procedure TFormControls.CreateOption1Click(Sender: TObject);
begin
 Button3Click(Button3);
end;

procedure TFormControls.EditButton1ButtonClick(Sender: TObject);
begin
 Showmessage('Right button click');
end;

procedure TFormControls.Join1Click(Sender: TObject);
begin
 Button1Click(Button1);
end;

procedure TFormControls.ShowTab01Click(Sender: TObject);
begin
{$IFDEF D2BRIDGE}
 D2Bridge.PrismControlFromID('TabControl1').AsTabs.ActiveTabIndex:= 0;
{$ENDIF}
end;

procedure TFormControls.ShowTab11Click(Sender: TObject);
begin
 {$IFDEF D2BRIDGE}
  D2Bridge.PrismControlFromID('TabControl1').AsTabs.ActiveTabIndex:= 1;
 {$ENDIF}
end;

procedure TFormControls.ExportD2Bridge;
begin
 inherited;

 Title:= 'Lazarus Controls Demo';

 TemplateClassForm:= TD2BridgeFormTemplate;
 D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '';
 D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

 with D2Bridge.Items.add do
 begin
   LCLObj(Label_Titulo);

   with PanelGroup('Full name').Items.Add do
   begin
    with Row.Items.Add do
    FormGroup('Name').AddLCLObj(Edit1);

    with Row.Items.Add do
    FormGroup('Last Name').AddLCLObj(Edit2);
   end;

   with Row.Items.Add do
   begin
    FormGroup('', CSSClass.Col.colauto).AddLCLObj(Button1, CSSClass.Button.config);
    FormGroup('', CSSClass.Col.colauto).AddLCLObj(Button3, CSSClass.Button.add);
    FormGroup('', CSSClass.Col.colauto).AddLCLObj(Button2, CSSClass.Button.delete);
    FormGroup('', CSSClass.Col.colauto).AddLCLObj(Button8, PopupMenu1, CSSClass.Button.options);
   end;

   with Row.Items.Add do
    with Tabs('TabControl1') do
    begin
     with AddTab(PageControl1.Pages[0].Caption).Items.Add do
     FormGroup(Panel3.Caption, CSSClass.Col.colsize4).AddLCLObj(Edit3);

     with AddTab(PageControl1.Pages[1].Caption).Items.Add do
     FormGroup(Panel4.Caption, CSSClass.Col.colsize4).AddLCLObj(ComboBox1);
    end;

   with Row.Items.Add do
    with PanelGroup('CheckBox').Items.Add do
     LCLObj(CheckBox1);

   with Row.Items.Add do
    FormGroup.AddLCLObj(Button_Selecionar);

    //Combobox
   with Row.Items.Add do
   begin
    with PanelGroup('Select 1 item').Items.Add do
    begin
     LCLObj(RadioButton1);
     LCLObj(RadioButton2);
     LCLObj(RadioButton3);
    end;
   end;


   //RadioGroup
   Row.Items.Add.Col.Add.VCLObj(RadioGroup1);
   with Row.Items.Add do
   begin
    FormGroup.AddVCLObj(Button9);
    FormGroup.AddVCLObj(Button10);
    FormGroup.AddVCLObj(Button11);
    with FormGroup('Columns').Items.Add do
    begin
     VCLObj(Button12, CSSClass.Button.decrease);
     VCLObj(Button13, CSSClass.Button.increase);
    end;
   end;


   //Popup
   with Popup('PopupSelecione', 'Select the item').Items.Add do
    with Row.Items.Add do
     FormGroup('Select').AddLCLObj(ComboBox_Selecionar);

   //LabeledEdit
   with Row.Items.Add do
    FormGroup(LabeledEdit1, CSSClass.Col.col);

   //ButtonedEdit
   with Row.Items.Add do
   begin
    FormGroup('EditButton Info').AddLCLObj(EditButton1);
   end;

   //Images
   with Row.Items.Add do
   begin
    with PanelGroup('Static Image', '', false, CSSClass.Col.colsize2).Items.Add do
     LCLObj(Image_Static);

    with PanelGroup('Upload Image', '', false, CSSClass.Col.colsize6).Items.Add do
    begin
     with Row.Items.Add do
      LCLObj(Image_From_Local);

     with Row.Items.Add do
      Upload;
    end;

    with PanelGroup('Load from Web', '', false, CSSClass.Col.colsize2).Items.Add do
    begin
     with Row.Items.Add do
      Col.Add.LCLObj(Image_From_Web);

     with Row.Items.Add do
      Col.Add.LCLObj(Button_Load_from_Web, CSSClass.Col.colsize12);
    end;
   end;

   //Accordion
   with Row.Items.Add do
    with Accordion do
     with AddAccordionItem('Show information (accordion)').Items.Add do
     begin
      with Row.Items.Add do
       FormGroup('Name').AddLCLObj(Edit_Credito_Nome);
      with Row.Items.Add do
       FormGroup('Contact').AddLCLObj(Edit_Credito_Email);
     end;
 end;

end;

procedure TFormControls.InitControlsD2Bridge(const PrismControl: TPrismControl);
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

procedure TFormControls.RenderD2Bridge(const PrismControl: TPrismControl;
 var HTMLControl: string);
begin
 inherited;

 if PrismControl.VCLComponent = Image_From_Web then
  PrismControl.AsImage.URLImage:= URL_Image_Web;
end;

procedure TFormControls.EventD2Bridge(const PrismControl: TPrismControl;
 const EventType: TPrismEventType; EventParams: TStrings);
begin
 if PrismControl.IsTabs then
  if (PrismControl.Name = 'TabControl1') and (EventType = TPrismEventType.EventOnChange) then
  begin
   Showmessage('Tab ' + IntToStr(PrismControl.AsTabs.ActiveTabIndex) + ' Activate');
  end;
end;

procedure TFormControls.Upload(AFiles: TStrings; Sender: TObject);
begin
 Image_From_Local.Picture.LoadFromFile(AFiles[0]);
end;

end.
