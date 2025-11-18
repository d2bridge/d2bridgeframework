unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Data.DB, Datasnap.DBClient, Vcl.Mask,
  vcl.wwdbedit, // edit
  Vcl.Grids, vcl.wwdbigrd, vcl.wwdbgrid, // dbgrid
  vcl.wwdotdot, vcl.wwdbcomb,  // dbcombobox
  vcl.wwbutton,    // button
  vcl.wwdblook,  // wwdblookupcombo
  vcl.wwdbdlg,  // wwdblookupcombodlg
  vcl.wwriched, Vcl.ComCtrls,  // wwdbRichEdit
  vcl.wwdbdatetimepicker,  // Datetimepicker
  vcl.wwcheckbox,  // wwCheckBox
  vcl.wwradiobutton,
  vcl.wwkeycb,  // IncrementalSearch
  vcl.wwdbspin,
  vcl.wwclearbuttongroup,
  vcl.wwradiogroup, // wwRadioGroup
  D2Bridge.Forms
  ;

  //Declare D2Bridge.Forms always in the last unit

type
  TForm1 = class(TD2BridgeForm)
    Label1: TLabel;
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    wwDBEdit1: TwwDBEdit;
    wwDBGrid1: TwwDBGrid;
    wwButton1: TwwButton;
    wwDBComboBox1: TwwDBComboBox;
    wwDBLookupCombo1: TwwDBLookupCombo;
    ClientDataSet2: TClientDataSet;
    DataSource2: TDataSource;
    wwDBComboDlg1: TwwDBComboDlg;
    wwDBLookupComboDlg1: TwwDBLookupComboDlg;
    wwDBRichEdit1: TwwDBRichEdit;
    wwDBDateTimePicker1: TwwDBDateTimePicker;
    wwCheckBox1: TwwCheckBox;
    wwRadioButton1: TwwRadioButton;
    ClientDataSet3: TClientDataSet;
    DataSource3: TDataSource;
    wwIncrementalSearch1: TwwIncrementalSearch;
    wwDBSpinEdit1: TwwDBSpinEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    ClientDataSet1id: TIntegerField;
    ClientDataSet1name: TStringField;
    ClientDataSet1lastname: TStringField;
    ClientDataSet1birthday: TDateField;
    ClientDataSet1phone: TStringField;
    ClientDataSet2animal: TStringField;
    ClientDataSet2species: TStringField;
    ClientDataSet2size: TIntegerField;
    ClientDataSet3car: TStringField;
    ClientDataSet3version: TIntegerField;
    ClientDataSet3manufacturingdate: TDateField;
    ClientDataSet1number: TIntegerField;
    wwButton2: TwwButton;
    ClientDataSet1animalprefer: TStringField;
    ClientDataSet1carprefer: TStringField;
    ClientDataSet1information: TStringField;
    wwButton3: TwwButton;
    wwButton4: TwwButton;
    wwDBEdit2: TwwDBEdit;
    Label11: TLabel;
    wwRadioGroup1: TwwRadioGroup;
    wwRadioGroup2: TwwRadioGroup;
    ClientDataSet4: TClientDataSet;
    StringField1: TStringField;
    DataSource4: TDataSource;
    procedure wwButton1Click(Sender: TObject);
    procedure wwButton2Click(Sender: TObject);
    procedure wwButton3Click(Sender: TObject);
    procedure wwDBEdit2Change(Sender: TObject);
  private
    procedure StartDataSet;
  public

  protected
   procedure ExportD2Bridge; override;
   procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
   procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
  end;

Function Form1: TForm1;

implementation

Uses
   D2B_InfoPowerWebApp, Unit3, D2BridgeFormTemplate;

Function Form1: TForm1;
begin
 Result:= TForm1(TForm1.GetInstance);
end;

{$R *.dfm}

{ TForm1 }

procedure TForm1.ExportD2Bridge;
begin
 inherited;

 Title:= 'My D2Bridge Application';

 D2Bridge.HTML.Render.BodyStyle := 'background-color: lightblue';

 //TemplateClassForm:= TD2BridgeFormTemplate;
 D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '';
 D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

 StartDataSet;

 //Export yours Controls
 with D2Bridge.Items.add do
 begin

  VCLObj(Label1);

  with Row.Items.Add do
  begin
     with FormGroup('Search by ID', CSSClass.Col.colauto) do
          AddVCLObj(wwIncrementalSearch1);
     with FormGroup('', CSSClass.Col.colsize1) do
          AddVCLObj(wwButton3, CSSClass.Button.search);
  end;

  with row.Items.Add do
  begin
      with FormGroup('', CSSClass.Col.colauto) do
           AddVCLObj(wwButton1, CSSClass.Button.edit);

      with FormGroup('Name', CSSClass.Col.colauto) do
           AddVCLObj(wwDBEdit1);

      with FormGroup('Number', CSSClass.Col.colauto) do
           AddVCLObj(wwDBSpinEdit1);

      with FormGroup('New Last Name', CSSClass.Col.colauto) do
           AddVCLObj(wwDBComboBox1);

      with FormGroup('Select Fone List', CSSClass.Col.colauto) do
           AddVCLObj(wwDBComboDlg1);

      with FormGroup('Favorite Animal', CSSClass.Col.colauto) do
           AddVCLObj(wwDBLookupCombo1);

      with FormGroup('Favorite Car', CSSClass.Col.colauto) do
           AddVCLObj(wwDBLookupComboDlg1);
  end;
  with row.Items.Add do
  begin
     with FormGroup('Information', CSSClass.Col.colauto) do
          AddVCLObj(wwDBRichEdit1);

    with FormGroup('RadioGroup', CSSClass.Col.colsize1) do
        AddVCLObj(wwRadioGroup1);

    with FormGroup('RadioGroup', CSSClass.Col.colsize1) do
        AddVCLObj(wwRadioGroup2);
  end;
  with row.Items.Add do
     with FormGroup('Birthday', CSSClass.Col.colauto) do
          AddVCLObj(wwDBDateTimePicker1);
  with row.Items.Add do
  begin
     with FormGroup('Ative', CSSClass.Col.colauto) do
          AddVCLObj(wwCheckBox1);
     with FormGroup('Prefer', CSSClass.Col.colauto) do
          AddVCLObj(wwRadioButton1);
  end;
  with Row.Items.Add do
     with FormGroup('', CSSClass.Col.colsize1) do
          AddVCLObj(wwButton2, CSSClass.Button.save);
  with Row.Items.Add do
     with FormGroup('Grid Example', CSSClass.Col.colsize12) do
          AddVCLObj(wwDBGrid1);

  with Row.Items.Add do
     with FormGroup(Label11.Caption, CSSClass.Col.colsize1) do
          AddVCLObj(wwDBEdit2, CSSClass.Col.colsize1);

  with Row.Items.Add do
    with FormGroup('', CSSClass.Col.colsize1) do
        AddVCLObj(wwButton4, CSSClass.Button.refresh);
 end;
end;

procedure TForm1.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
 inherited;

 //Change Init Property of Prism Controls

//  if PrismControl.VCLComponent = wwDBEdit1 then
//   PrismControl.AsEdit.DataType:= TPrismFieldType.PrismFieldTypeInteger;

  if PrismControl.IsDBGrid then
  begin
   PrismControl.AsDBGrid.RecordsPerPage:= 10;
   PrismControl.AsDBGrid.MaxRecords:= 2000;

   PrismControl.AsDBGrid.ZebraGrid := True;
  end;

 if PrismControl.VCLComponent = wwDBSpinEdit1 then
  with PrismControl.AsButtonedEdit do
  begin
   ButtonLeftCSS:= CSSClass.Button.decrease;
   ButtonRightCSS:= CSSClass.Button.increase;
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

procedure TForm1.StartDataSet;
begin
   ClientDataSet1.CreateDataSet;
   ClientDataSet1.Open;

   with ClientDataSet1 do
   begin
      Insert;
      FieldByName('id').AsInteger         := 1;
      FieldByName('name').AsString        := 'John';
      FieldByName('lastname').AsString    := 'McFish';
      FieldByName('birthday').AsDateTime  := StrToDateTime('25/02/1979');
      FieldByName('phone').AsString       := '(11)11111-2222';
      FieldByName('number').AsInteger     := 100;
      Post;

      Insert;
      FieldByName('id').AsInteger         := 2;
      FieldByName('name').AsString        := 'Joseph';
      FieldByName('lastname').AsString    := 'McDonalds';
      FieldByName('birthday').AsDateTime  := StrToDateTime('01/10/1955');
      FieldByName('phone').AsString       := '(22)22222-3333';
      FieldByName('number').AsInteger     := 200;
      Post;

      Insert;
      FieldByName('id').AsInteger         := 3;
      FieldByName('name').AsString        := 'Lana';
      FieldByName('lastname').AsString    := 'BurguerKing';
      FieldByName('birthday').AsDateTime  := StrToDateTime('12/01/1980');
      FieldByName('phone').AsString       := '(33)33333-4444';
      FieldByName('number').AsInteger     := 300;
      Post;

      Insert;
      FieldByName('id').AsInteger         := 4;
      FieldByName('name').AsString        := 'Pelé';
      FieldByName('lastname').AsString    := 'BigMac';
      FieldByName('birthday').AsDateTime  := StrToDateTime('18/06/1950');
      FieldByName('phone').AsString       := '(11)12345-6789';
      FieldByName('number').AsInteger     := 400;
      Post;

      Insert;
      FieldByName('id').AsInteger         := 5;
      FieldByName('name').AsString        := 'Donald';
      FieldByName('lastname').AsString    := 'Duck';
      FieldByName('birthday').AsDateTime  := StrToDateTime('12/12/1912');
      FieldByName('phone').AsString       := '(55)88788-9999';
      FieldByName('number').AsInteger     := 500;
      Post;

      Insert;
      FieldByName('id').AsInteger         := 6;
      FieldByName('name').AsString        := 'Margareth';
      FieldByName('lastname').AsString    := 'Pig';
      FieldByName('birthday').AsDateTime  := StrToDateTime('12/04/1944');
      FieldByName('phone').AsString       := '(55)54321-9876';
      FieldByName('number').AsInteger     := 500;
      Post;

      Insert;
      FieldByName('id').AsInteger         := 7;
      FieldByName('name').AsString        := 'Calton';
      FieldByName('lastname').AsString    := 'Banks';
      FieldByName('birthday').AsDateTime  := StrToDateTime('01/05/1988');
      FieldByName('phone').AsString       := '(55)88788-1234';
      FieldByName('number').AsInteger     := 500;
      Post;

      Insert;
      FieldByName('id').AsInteger         := 8;
      FieldByName('name').AsString        := 'Will';
      FieldByName('lastname').AsString    := 'Smith';
      FieldByName('birthday').AsDateTime  := StrToDateTime('01/12/1912');
      FieldByName('phone').AsString       := '(55)44544-9999';
      FieldByName('number').AsInteger     := 500;
      Post;

      Insert;
      FieldByName('id').AsInteger         := 9;
      FieldByName('name').AsString        := 'Philipp';
      FieldByName('lastname').AsString    := 'Banks';
      FieldByName('birthday').AsDateTime  := StrToDateTime('12/04/1912');
      FieldByName('phone').AsString       := '(55)77677-9999';
      FieldByName('number').AsInteger     := 700;
      Post;

      Insert;
      FieldByName('id').AsInteger         := 10;
      FieldByName('name').AsString        := 'Michael';
      FieldByName('lastname').AsString    := 'Touch';
      FieldByName('birthday').AsDateTime  := StrToDateTime('12/12/1912');
      FieldByName('phone').AsString       := '(55)99978-9999';
      FieldByName('number').AsInteger     := 900;
      Post;

      Insert;
      FieldByName('id').AsInteger         := 11;
      FieldByName('name').AsString        := 'Albert';
      FieldByName('lastname').AsString    := 'Mayers';
      FieldByName('birthday').AsDateTime  := StrToDateTime('12/08/1912');
      FieldByName('phone').AsString       := '(55)88788-7842';
      FieldByName('number').AsInteger     := 1000;
      Post;

   end;

   ClientDataSet2.CreateDataSet;
   ClientDataSet2.Open;

   with ClientDataSet2 do
   begin
      Insert;
      FieldByName('animal').AsString      := 'Dog';
      FieldByName('species').AsString     := 'canine';
      FieldByName('size').AsInteger       := 5;
      Post;

      Insert;
      FieldByName('animal').AsString      := 'Cat';
      FieldByName('species').AsString     := 'feline';
      FieldByName('size').AsInteger       := 9;
      Post;

      Insert;
      FieldByName('animal').AsString    := 'Mouse';
      FieldByName('species').AsString   := 'rodent';
      FieldByName('size').AsInteger     := 99;
      Post;
   end;

   ClientDataSet3.CreateDataSet;
   ClientDataSet3.Open;

   with ClientDataSet3 do
   begin
      Insert;
      FieldByName('car').AsString                  := 'Eco-Sport';
      FieldByName('version').AsInteger             := 5;
      FieldByName('manufacturingdate').AsDateTime  := StrToDateTime('12/12/2005');
      Post;

      Insert;
      FieldByName('car').AsString                  := 'New Beatle';
      FieldByName('version').AsInteger             := 9;
      FieldByName('manufacturingdate').AsDateTime  := StrToDateTime('12/12/2010');
      Post;

      Insert;
      FieldByName('car').AsString                  := 'Fusion';
      FieldByName('version').AsInteger             := 1;
      FieldByName('manufacturingdate').AsDateTime  := StrToDateTime('12/12/2014');
      Post;
   end;

   ClientDataSet4.CreateDataSet;
   ClientDataSet4.Open;

   with ClientDataSet4 do
   begin
      Insert;
      FieldByName('car').AsString                  := 'Maveric';
      Post;

      Insert;
      FieldByName('car').AsString                  := 'Opala';
      Post;

      Insert;
      FieldByName('car').AsString                  := 'Monster-Truck';
      Post;
   end;
end;

procedure TForm1.wwButton1Click(Sender: TObject);
begin
   ShowMessage('Button wwButton OK');
end;

procedure TForm1.wwButton2Click(Sender: TObject);
begin
   if DataSource1.DataSet.State in [dsEdit] then
   begin
      ClientDataSet1.Post;
      PrismSession.ShowMessage('Save Sucess');
      ClientDataSet1.Refresh;
   end;
end;

procedure TForm1.wwButton3Click(Sender: TObject);
begin
   if wwIncrementalSearch1.Text = emptyStr then
   begin
      ClientDataSet1.Filtered := False;
      ClientDataSet1.Filter   := '';
   end
     else
   begin
      ClientDataSet1.Filtered := False;
      ClientDataSet1.Filter   := 'id = ' + wwIncrementalSearch1.Text;
      ClientDataSet1.Filtered := True;
   end;
end;

procedure TForm1.wwDBEdit2Change(Sender: TObject);
begin
   wwButton4.Caption := wwDBEdit2.Text;
end;

end.
