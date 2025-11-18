unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, D2Bridge.Forms, Data.DB,
  Vcl.Grids, Vcl.DBGrids, Datasnap.DBClient;

type
  TForm1 = class(TD2BridgeForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ClientDataSet_Country: TClientDataSet;
    DSCountry: TDataSource;
    DBGrid1: TDBGrid;
    ClientDataSet_CountryCountry: TStringField;
    ClientDataSet_CountryDDI: TStringField;
    ClientDataSet_CountryPopulation: TIntegerField;
    ClientDataSet_CountryAutoCod: TAutoIncField;
    Button_New: TButton;
    Button_Edit: TButton;
    Button_Delete: TButton;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure Button_EditClick(Sender: TObject);
    procedure Button_NewClick(Sender: TObject);
    procedure Button_DeleteClick(Sender: TObject);
  private
    Procedure PopuleClientDataSet;
  public

  protected
   procedure ExportD2Bridge; override;
   procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
   procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
   procedure CellButtonClick(APrismDBGrid: TPrismDBGrid; APrismCellButton: TPrismDBGridColumnButton; AColIndex: Integer; ARow: Integer); override;
   procedure TagTranslate(const Language: TD2BridgeLang; const AContext: string; const ATerm: string; var ATranslated: string); override;
   procedure CallBack(const CallBackName: string; EventParams: TStrings); override;
  end;

Function Form1: TForm1;

implementation

uses Unit2;

Function Form1: TForm1;
begin
 Result:= TForm1(TForm1.GetInstance);
end;

{$R *.dfm}

{ TForm1 }

procedure TForm1.Button_DeleteClick(Sender: TObject);
begin
 if Form2 = nil then
  TForm2.CreateInstance;
 Form2.Button_DeleteClick(Sender);
end;

procedure TForm1.Button_EditClick(Sender: TObject);
begin
 if Form2 = nil then
  TForm2.CreateInstance;
 Form2.Show;
end;

procedure TForm1.Button_NewClick(Sender: TObject);
begin
 ClientDataSet_Country.Insert;

 if Form2 = nil then
  TForm2.CreateInstance;
 Form2.Show;

end;

procedure TForm1.CallBack(const CallBackName: string; EventParams: TStrings);
begin
  inherited;

  if SameText('CellPrint', CallBackName) then
  begin
   Showmessage('Prin Row ' + EventParams.Values['recno']);
  end;
end;

procedure TForm1.CellButtonClick(APrismDBGrid: TPrismDBGrid;
  APrismCellButton: TPrismDBGridColumnButton; AColIndex, ARow: Integer);
begin
 if APrismDBGrid.VCLComponent = DBGrid2 then
 begin
  if APrismCellButton.Identify = 'del rec' then
  begin
   showmessage('Delete Button');
  end;
 end;
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

  with HTMLDIV.Items.Add do
  begin
   VCLObj(Button_New, CSSClass.Button.add);
   VCLObj(Button_Edit, CSSClass.Button.edit);
   VCLObj(Button_Delete, CSSClass.Button.delete);
  end;

  with Row.Items.Add do
   VCLObj(DBGrid1);

  with Row.Items.Add do
   VCLObj(DBGrid2);

  with Row.Items.Add do
   VCLObj(DBGrid3);
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
  PrismControl.AsDBGrid.RecordsPerPage:= 5;

 {$REGION 'DBGrid1'}
  if PrismControl.VCLComponent = DBGrid1 then
  with PrismControl.AsDBGrid do
  begin
   //HTML with static Text
   with Columns.Add do
   begin
    Title:= 'Phone Ico';
    HTML:= '<i class="fa-solid fa-phone" aria-hidden="true"></i><span>Phone</span>';
   end;

   //HTML with use "data" form DataField Value
   with Columns.Add do
   begin
    Title:= 'Phone Ico 2';
    HTML:= '<i class="fa-solid fa-phone" aria-hidden="true"></i><span>${data.DDI}</span>';
   end;

   //HTML with static Text
   with Columns.Add do
   begin
    DataField:= 'DDI'; //Column DataField
    Title:= 'Phone Ico 2';
    HTML:= '<i class="fa-solid fa-phone" aria-hidden="true"></i><span>${value}</span>';
   end;
  end;
 {$ENDREGION}

 {$REGION 'DBGrid2'}
  if PrismControl.VCLComponent = DBGrid2 then
  with PrismControl.AsDBGrid do
  begin
   with Columns.Add do
   begin
    Title:= 'Example 1';
    Width:= 50;
    HTML:= '<span class="badge bg-success rounded-pill p-2" style="width: 7em;">Country</span>';
   end;

   with Columns.Add do
   begin
    Title:= 'Example 2';
    Width:= 50;
    HTML:= '<span class="badge ${data.Population >= 1444216107 ? ''bg-primary'' : data.Population >= 1393409038 ? ''bg-info'' : ''bg-secondary''} rounded-pill p-2" style="width: 7em;">Rank</span>';
   end;

   with Columns.Add do
   begin
    Title:= D2Bridge.LangNav.Button.CaptionOptions;
    ColumnIndex:= 0;
    Width:= 70;

    //New
    with Buttons.Add do
    begin
     ButtonModel:= TButtonModel.Add;
     Caption:= ''; //Remove Caption
     {Option 1
      This option use OnClick from ButtonNew}
     OnClick:= Button_NewClick;
    end;

    //Edit
    with Buttons.Add do
    begin
     ButtonModel:= TButtonModel.Edit;
     Caption:= ''; //Remove Caption
     {Option 2
      This option use TProc inLine}
     ClickProc:=
      procedure
      begin
       Form1.Button_EditClick(Button_Edit);
      end;
    end;

    //Delete
    with Buttons.Add do
    begin
     {Option 3
      This option get Indentity value in CellButtonClick event}
     ButtonModel:= TButtonModel.Delete;
     Caption:= ''; //Remove Caption
    end;

   end;
  end;
 {$ENDREGION}

 {$REGION 'DBGrid3'}
  if PrismControl.VCLComponent = DBGrid3 then
  with PrismControl.AsDBGrid do
  begin
   //HTML with <a> hhtml element and Button and CallBack
   with Columns.Add do
   begin
    ColumnIndex:= 0;
    Width:= 50;
    Title:= 'Print';
    HTML:= '<a onclick="{{CallBack=CellPrint(recno=${data.PrismRecNo})}}"> <span> <i class="fa fa-print fa-2x fixed-plugin-button-nav cursor-pointer" aria-hidden="false" style="color:SteelBlue" align:"left"> </i> </span> </a>';
   end;

   with Columns.Add do
   begin
    Title:= D2Bridge.LangNav.Button.CaptionOptions;
    Width:= 50;

    //Create Popup + Button
    with Buttons.Add do
    begin
     ButtonModel:= TButtonModel.Config;

     //New
     with Add do
     begin
      ButtonModel:= TButtonModel.Add;
      OnClick:= Button_NewClick;
     end;

     //Edit
     with Add do
     begin
      ButtonModel:= TButtonModel.Edit;
      ClickProc:=
       procedure
       begin
        Form1.Button_EditClick(Button_Edit);
       end;
     end;

     //Delete
     with Add do
     begin
      ButtonModel:= TButtonModel.Delete;
     end;
    end;
   end;
  end;
 {$ENDREGION}

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

procedure TForm1.TagTranslate(const Language: TD2BridgeLang; const AContext,
  ATerm: string; var ATranslated: string);
begin
 if SameText(ATerm, 'New') then
  ATranslated:= D2Bridge.LangNav.Button.CaptionAdd;

 if SameText(ATerm, 'Edit') then
  ATranslated:= D2Bridge.LangNav.Button.CaptionEdit;

 if SameText(ATerm, 'Delete') then
  ATranslated:= D2Bridge.LangNav.Button.CaptionDelete;
end;

end.
