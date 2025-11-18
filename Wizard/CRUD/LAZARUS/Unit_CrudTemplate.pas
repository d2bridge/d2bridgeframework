unit Unit_CrudTemplate;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{ Copyright 2024 / 2025 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Classes, SysUtils, DB, SQLDB, Controls, Graphics, Dialogs, DBGrids,
  StdCtrls, ExtCtrls, ComCtrls,
  D2Bridge.Item.HTML.Card, D2Bridge.Item.HTML.Row,
  { INHERITED, }D2Bridge.Forms;

type
 CrudOperation =
  (OpOpen = 0,
   OpSearch,
   OpInsert,
   OpEdit,
   OpSave,
   OpDelete,
   OpBack,
   OpClose);

 CrudPermission =
  (PermTotal = 0,
   PermSearch,
   PermEdit,
   PermInsert,
   PermSave,
   PermDelete);

  TCrudPermissions = set of CrudPermission;


type

  { TForm_CrudTemplate }

  TForm_CrudTemplate = class(TD2BridgeForm)
    Crud_PageControl: TPageControl;
    Crud_TabSheetSearch: TTabSheet;
    Crud_PanelSearchFor: TPanel;
    Crud_EditSearch: TEdit;
    Crud_ButtonSearch: TButton;
    Crud_ButtonNew: TButton;
    Crud_DBGrid_Search: TDBGrid;
    Crud_TabSheetData: TTabSheet;
    Crud_ButtonSave: TButton;
    Crud_ButtonDelete: TButton;
    Crud_ButtonBack: TButton;
    Crud_PanelTitle: TPanel;
    Crud_PanelSubTitle: TPanel;
    Crud_DSQuery: TDataSource;
    Crud_Query: TSQLQuery;
    procedure Crud_ButtonNewClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Crud_ButtonSearchClick(Sender: TObject);
    procedure Crud_ButtonSaveClick(Sender: TObject);
    procedure Crud_ButtonDeleteClick(Sender: TObject);
    procedure Crud_ButtonBackClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  strict private
    FCrudValidationGroup: string;
    //Start Card
    FStartCard: TD2BridgeItemHTMLCard;
    //Types
    FCrudPermissions: TCrudPermissions;
    //Card
    FCrud_CardSearch: TD2BridgeItemHTMLCard;
    FCrud_CardData: TD2BridgeItemHTMLCard;
    //Row
    FCrud_RowContainer: TD2BridgeItemHTMLRow;
    FCrud_RowBarSearch: TD2BridgeItemHTMLRow;
    FCrud_RowGrid: TD2BridgeItemHTMLRow;
    //CSS
    FColSize: string;
    FColAlign: string;
    //Active Operation
    FActiveOperation: CrudOperation;
    //Set/Get Property
    function GetCrudPermissions: TCrudPermissions;
    procedure SetCrudPermissions(APermissions: TCrudPermissions);
    function GetColSize: string;
    procedure SetColSize(AValue: string);
  private
    function CrudOperationPermission(ACrudOperation: CrudOperation): boolean;
    procedure Crud_DoExportCardSearch; virtual;
    procedure Crud_DoExportCardData; virtual;
    function GetColAlign: string;
    procedure SetColAlign(const Value: string);
  public
    //Start
    procedure StartCardSearch;
    procedure StartCardData;
    procedure CrudDefaultSearch(ATable: string; AFieldWhere: string; ASearch: string; AFieldOrder: string); overload;
    procedure CrudDefaultSearch(ATable: string; AWhereFields: array of string; ASearch: string); overload;
    procedure CrudDefaultSearch(ATable: string; AWhereFields: array of string; ASearch: string; AAnd: TArray<string>); overload;
    procedure CrudDefaultSearch(ATable: string; AWhereFields: array of string; ASearch: string; AAnd: TArray<string>; AOr: TArray<string>); overload;
    procedure CrudDefaultSearch(ATable: string; AWhereFields: array of string; ASearch: string; AAnd: TArray<string>; AOr: TArray<string>; AOrderFields: TArray<string>); overload;
  protected
    //Crud Operations
    procedure CrudOperation(ACrudOperation: CrudOperation);
    //Crud Events
    procedure CrudOnOpen; virtual;
    procedure CrudOnSearch(AText: string); virtual;
    function CrudOnEdit: boolean; virtual;
    function CrudOnInsert: boolean; virtual;
    function CrudOnSave: boolean; virtual;
    function CrudOnDelete: boolean; virtual;
    function CrudOnBack: boolean; virtual;
    function CrudOnClose: boolean; virtual;

    //GridEvents
    procedure OnEditClick(Sender: TObject); virtual;
    procedure OnDeleteClick(Sender: TObject); virtual;

    //D2Bridge
    procedure ExportD2Bridge; override;
    procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
    procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
    procedure BeginRender; override;
    procedure EndRender; override;

  published
    property ActiveOperation: CrudOperation read FActiveOperation;
    property StartCard: TD2BridgeItemHTMLCard read FStartCard;
    property CrudColAlign: string read GetColAlign write SetColAlign;
    property CrudValidationGroup: string read FCrudValidationGroup write FCrudValidationGroup;
    property CrudColSize: string read GetColSize write SetColSize;
    property Crud_CardSearch: TD2BridgeItemHTMLCard read FCrud_CardSearch;
    property Crud_CardData: TD2BridgeItemHTMLCard read FCrud_CardData;
    property Crud_RowBarSearch: TD2BridgeItemHTMLRow read FCrud_RowBarSearch;
    property Crud_RowGrid: TD2BridgeItemHTMLRow read FCrud_RowGrid;
    property CrudPermissions: TCrudPermissions read GetCrudPermissions write SetCrudPermissions;
  end;

function Form_CrudTemplate:TForm_CrudTemplate;

implementation

{$R *.lfm}

function Form_CrudTemplate:TForm_CrudTemplate;
begin
  result:= TForm_CrudTemplate(TForm_CrudTemplate.GetInstance);
end;

procedure TForm_CrudTemplate.StartCardData;
begin
 FStartCard:= FCrud_CardData;
end;

procedure TForm_CrudTemplate.StartCardSearch;
begin
 FStartCard:= FCrud_CardSearch;
end;

procedure TForm_CrudTemplate.BeginRender;
begin
if FStartCard = FCrud_CardSearch then
  FCrud_CardSearch.PrismControl.Visible:= true
 else
  FCrud_CardSearch.PrismControl.Visible:= false;

 FCrud_CardData.PrismControl.Visible:= not FCrud_CardSearch.PrismControl.Visible;

 if not isNestedContext then
 if Crud_PanelTitle.Caption <> '' then
 begin
  FCrud_CardSearch.TitleHeader:= Crud_PanelTitle.Caption;
  FCrud_CardData.TitleHeader:= Crud_PanelTitle.Caption;
 end else
 begin
  FCrud_CardSearch.TitleHeader:= SubTitle;
  FCrud_CardData.TitleHeader:= SubTitle;
 end;

 if not isNestedContext then
 if Crud_PanelSubTitle.Caption <> '' then
 begin
  FCrud_CardSearch.Title:= Crud_PanelSubTitle.Caption;
  FCrud_CardData.Title:= Crud_PanelSubTitle.Caption;
 end;

 inherited;

end;

procedure TFormCrudTemplate.CrudDefaultSearch(ATable: string; AFieldWhere: string; ASearch: string; AFieldOrder: string);
begin
  CrudDefaultSearch(ATable, [AFieldWhere], ASearch, [], [], [AFieldOrder]);
end;

procedure TFormCrudTemplate.CrudDefaultSearch(ATable: string; AWhereFields: array of string; ASearch: string);
begin
  CrudDefaultSearch(ATable, AWhereFields, ASearch, [], [], []);
end;

procedure TFormCrudTemplate.CrudDefaultSearch(ATable: string; AWhereFields: array of string; ASearch: string; AAnd: TArray<string>);
begin
  CrudDefaultSearch(ATable, AWhereFields, ASearch, AAnd, [], []);
end;

procedure TFormCrudTemplate.CrudDefaultSearch(ATable: string; AWhereFields: array of string; ASearch: string; AAnd: TArray<string>; AOr: TArray<string>);
begin
  CrudDefaultSearch(ATable, AWhereFields, ASearch, AAnd, AOr, []);
end;

procedure TFormCrudTemplate.CrudDefaultSearch(ATable: string; AWhereFields: array of string; ASearch: string; AAnd: TArray<string>; AOr: TArray<string>; AOrderFields: TArray<string>);
var
  I: integer;
  vWhere, vAnd, vOR, vOrderBy: string;
begin
  with Crud_Query do
  begin
  close;
  SQL.Clear;
  SQL.Add('Select * from '+ATable);
  //Where
  if (Length(AWhereFields) > 0) and (AWhereFields[0] <> '') then
  begin
    vWhere:= '';
    for I := 0 to Pred(Length(AWhereFields)) do
    begin
    if vWhere <> '' then
      vWhere:= vWhere +' or ';
    vWhere:= vWhere + AWhereFields[i] + ' like ' + QuotedStr('%' + ASearch + '%');
    end;
    SQL.Add('Where (' + vWhere + ')');
  end;
  //And
  if (Length(AAnd) > 0) and (AAnd[0] <> '') then
  begin
    vAnd:= '';
    for I := 0 to Pred(Length(AAnd)) do
    begin
    if vAnd <> '' then
      vAnd:= vAnd +' and ';
    vAnd:= vAnd + AAnd[i];
    end;
    SQL.Add('and (' + vAnd + ')');
  end;
  //Or
  if (Length(AOr) > 0) and (AOr[0] <> '') then
  begin
    vOr:= '';
    for I := 0 to Pred(Length(AOr)) do
    begin
    if vOr <> '' then
      vOr:= vOr +' or ';
    vOr:= vOr + AOr[i];
    end;
    SQL.Add('or (' + vOr + ')');
  end;
  //Order by
  if (Length(AOrderFields) > 0) and (AOrderFields[0] <> '') then
  begin
    vOrderBy:= '';
    for I := 0 to Pred(Length(AOrderFields)) do
    begin
    if vOrderBy <> '' then
      vOrderBy:= vOrderBy +', ';
    vOrderBy:= vOrderBy + AOrderFields[i];
    end;
    SQL.Add('Order by ' + vOrderBy);
  end;
  Open;
  end;
end;

function TForm_CrudTemplate.CrudOnBack: boolean;
begin
 result:= true;
end;

function TForm_CrudTemplate.CrudOnClose: boolean;
begin
 result:= true;
end;

procedure TForm_CrudTemplate.OnEditClick(Sender: TObject);
begin
 CrudOperation(OpEdit);
end;

procedure TForm_CrudTemplate.OnDeleteClick(Sender: TObject);
begin
 CrudOperation(OpDelete);
end;

function TForm_CrudTemplate.CrudOnDelete: boolean;
begin
 result:= true;
end;

function TForm_CrudTemplate.CrudOnEdit: boolean;
begin
 result:= true;
end;

function TForm_CrudTemplate.CrudOnInsert: boolean;
begin
 result:= true;
end;

procedure TForm_CrudTemplate.CrudOnOpen;
begin

end;

function TForm_CrudTemplate.CrudOnSave: boolean;
begin
 result:= true;
end;

procedure TForm_CrudTemplate.CrudOnSearch(AText: string);
begin

end;

procedure TForm_CrudTemplate.Crud_ButtonBackClick(Sender: TObject);
begin
 inherited;

 CrudOperation(OPBack);
end;

procedure TForm_CrudTemplate.FormDestroy(Sender: TObject);
begin
 
 inherited;
end;

procedure TForm_CrudTemplate.Crud_ButtonDeleteClick(Sender: TObject);
begin
 inherited;

 CrudOperation(OPDelete);
end;

procedure TForm_CrudTemplate.Crud_ButtonNewClick(Sender: TObject);
begin
 CrudOperation(OpInsert);
end;

procedure TForm_CrudTemplate.Crud_ButtonSaveClick(Sender: TObject);
begin
 inherited;

 CrudOperation(OPSave);
end;

procedure TForm_CrudTemplate.Crud_ButtonSearchClick(Sender: TObject);
begin
 inherited;

 CrudOperation(OpSearch);
end;

procedure TForm_CrudTemplate.Crud_DoExportCardData;
begin
 with FCrud_CardData do
 begin
  with Footer.Items.Add do
  begin
   VCLObj(Crud_ButtonSave, CrudValidationGroup, false, CSSClass.Button.save);
   VCLObj(Crud_ButtonDelete, CSSClass.Button.delete);
   VCLObj(Crud_ButtonBack, CSSClass.Button.close);
  end;
 end;
end;

procedure TForm_CrudTemplate.Crud_DoExportCardSearch;
begin
 with FCrud_RowBarSearch.Items.Add do
 begin
  with FormGroup(Crud_PanelSearchFor.Caption, CSSClass.Col.colsize5).Items.Add do
  begin
   VCLObj(Crud_EditSearch);
   VCLObj(Crud_ButtonSearch, CSSClass.Button.search);
   VCLObj(Crud_ButtonNew, CSSClass.Button.add);
  end;
 end;
 FCrud_CardSearch.Items.Add(FCrud_RowBarSearch);

 with FCrud_RowGrid.Items.Add do
 begin
  with HTMLDIV('my-3').Items.Add do
   VCLObj(Crud_DBGrid_Search);
 end;
 FCrud_CardSearch.Items.Add(FCrud_RowGrid);
end;

procedure TForm_CrudTemplate.CrudOperation(ACrudOperation: CrudOperation);
begin
 if CrudOperationPermission(ACrudOperation) then
 begin
  if ACrudOperation in [OpOpen] then
  begin
   FActiveOperation:= ACrudOperation;

   if FStartCard = FCrud_CardData then
   begin
    CrudOnOpen;
    CrudOperation(OpEdit);
   end else
   begin
    FCrud_CardSearch.PrismControl.AsControl.Visible:= true;
    FCrud_CardData.PrismControl.AsControl.Visible:= not FCrud_CardSearch.PrismControl.AsControl.Visible;
    CrudOnOpen;
   end;
  end else
  if ACrudOperation in [OpSearch] then
  begin
   FActiveOperation:= ACrudOperation;

   CrudOnSearch(Crud_EditSearch.Text);
  end else
  if ACrudOperation in [OpInsert] then
  begin
   if CrudOnInsert then
   begin
    FActiveOperation:= ACrudOperation;

    FCrud_CardSearch.PrismControl.AsControl.Visible:= false;
    FCrud_CardData.PrismControl.AsControl.Visible:= not FCrud_CardSearch.PrismControl.AsControl.Visible;
   end;
  end else
  if ACrudOperation in [OpEdit] then
  begin
   if CrudOnEdit then
   begin
    FActiveOperation:= ACrudOperation;

    if FStartCard <> FCrud_CardData then
    begin
     FCrud_CardSearch.PrismControl.AsControl.Visible:= false;
     FCrud_CardData.PrismControl.AsControl.Visible:= not FCrud_CardSearch.PrismControl.AsControl.Visible;
    end;
   end;
  end else
  if ACrudOperation in [OpSave] then
  begin
   if CrudOnSave then
   begin
    FActiveOperation:= ACrudOperation;

    Showmessage('Record saved', true, true);

    CrudOperation(OpBack);
   end;
  end else
  if ACrudOperation in [OpDelete] then
  begin
   if MessageDlg('Do you confirm to delete this record?', mtconfirmation, [mbyes,mbno], 0) = mryes then
   if CrudOnDelete then
   begin
    FActiveOperation:= ACrudOperation;

    Showmessage('Record deleted', true, true);

    CrudOperation(OpBack);
   end;
  end else
  if ACrudOperation in [OpBack] then
  begin
   if FActiveOperation = OpInsert then
    if MessageDlg('Do you cancel this record?', mtconfirmation, [mbyes,mbno], 0) = mrNo then
     exit;

   if CrudOnBack then
   begin
    FActiveOperation:= ACrudOperation;

    if FStartCard = FCrud_CardData then
    begin
     close;
    end else
    begin
     FCrud_CardSearch.PrismControl.AsControl.Visible:= true;
     FCrud_CardData.PrismControl.AsControl.Visible:= not FCrud_CardSearch.PrismControl.AsControl.Visible;

     CrudOperation(OPOpen);
    end;
   end;
  end else
  if ACrudOperation in [OpClose] then
  begin
   if CrudOnClose then
   begin
    FActiveOperation:= ACrudOperation;

    CrudOperation(OpBack);

    if FStartCard = FCrud_CardSearch then
     close;
   end;
  end;
 end;
end;

function TForm_CrudTemplate.CrudOperationPermission(ACrudOperation: CrudOperation): boolean;
begin
 result:= true;

 if PermTotal in CrudPermissions then
  result:= true
 else
 if (ACrudOperation = OpSearch) and (not (PermSearch in CrudPermissions)) then
  result:= false
 else
 if (ACrudOperation = OpEdit) and (not (PermEdit in CrudPermissions)) then
  result:= false
 else
 if (ACrudOperation = OpInsert) and (not (PermInsert in CrudPermissions)) then
  result:= false
 else
 if (ACrudOperation = OpSave) and (not (PermSave in CrudPermissions)) then
  result:= false
 else
 if (ACrudOperation = OpDelete) and (not (PermDelete in CrudPermissions)) then
  result:= false

end;

procedure TForm_CrudTemplate.EndRender;
begin
 inherited;

 CrudOperation(OPOpen);
end;

procedure TForm_CrudTemplate.ExportD2Bridge;
begin
  inherited;

  Title:= 'My Form D2Bridge';
  SubTitle:= 'Principal';

  //TemplateClassForm:= TD2BridgeFormTemplate;
  //D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '';
  //D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

  with FCrud_RowContainer.Items.Add do
  begin
   Crud_DoExportCardSearch;
   D2BridgeItem(FCrud_CardSearch);

   Crud_DoExportCardData;
   D2BridgeItem(FCrud_CardData);
  end;


  with D2Bridge.Items.add do
  begin
   with Row('d2bridgecrudtemplate ' + CrudColAlign).Items.Add do
    D2BridgeItem(FCrud_RowContainer);
  end;
end;

procedure TForm_CrudTemplate.FormCreate(Sender: TObject);
begin
 CrudPermissions:= [PermTotal];
 FColSize:= 'col';
 FColAlign:= CSSClass.Col.Align.left;

 inherited;

 FCrudValidationGroup:= 'validation'+Self.Name;

 FCrud_RowContainer:= TD2BridgeItemHTMLRow.Create(D2Bridge.BaseClass);
 FCrud_RowContainer.ItemID:= 'Crud_RowContainer';
 FCrud_RowContainer.CSSClasses:= CSSClass.Col.colsize12;
 FCrud_CardSearch:= TD2BridgeItemHTMLCard.Create(D2Bridge.BaseClass);
 FCrud_CardSearch.ItemID:= 'Crud_CardSearch';
 FCrud_CardData:= TD2BridgeItemHTMLCard.Create(D2Bridge.BaseClass);
 FCrud_CardData.ItemID:= 'Crud_CardData';
 FCrud_RowBarSearch := TD2BridgeItemHTMLRow.Create(D2Bridge.BaseClass);
 FCrud_RowBarSearch.ItemID:= 'Crud_RowBarSearch';
 FCrud_RowGrid := TD2BridgeItemHTMLRow.Create(D2Bridge.BaseClass);
 FCrud_RowGrid.ItemID:= 'Crud_RowGrid';

 FStartCard:= FCrud_CardSearch;
end;

procedure TForm_CrudTemplate.FormShow(Sender: TObject);
begin
  if isNestedContext then
   CrudOperation(OPOpen);

  inherited;
end;

function TForm_CrudTemplate.GetColAlign: string;
begin
 result:= FColAlign;
end;

function TForm_CrudTemplate.GetColSize: string;
begin
 Result:= FColSize;
end;

function TForm_CrudTemplate.GetCrudPermissions: TCrudPermissions;
begin
 result:= FCrudPermissions;
end;

procedure TForm_CrudTemplate.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
 inherited;

 if (PermEdit in FCrudPermissions) or (PermDelete in FCrudPermissions) then
 if PrismControl.IsDBGrid and (PrismControl.VCLComponent = Crud_DBGrid_Search) then
  with PrismControl.AsDBGrid do
   with Columns.Add do
   begin
    ColumnIndex:= 0;
    Width:= 5;
    Title:= 'Options';

    //Button Edit
    if (PermEdit in FCrudPermissions) then
    begin
     Width:= Width + 26;
     with Buttons.Add do
     begin
      ButtonModel:= TButtonModel.Edit;
      Caption:= '';
      OnClick:= OnEditClick;
     end;
    end;

    //Button Delete
    if (PermDelete in FCrudPermissions) then
    begin
     Width:= Width + 26;
     with Buttons.Add do
     begin
      ButtonModel:= TButtonModel.Delete;
      Caption:= '';
      OnClick:= OnDeleteClick;
     end;
    end;
   end;
end;

procedure TForm_CrudTemplate.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string);
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

procedure TForm_CrudTemplate.SetColAlign(const Value: string);
begin
 FColAlign:= Value;
end;

procedure TForm_CrudTemplate.SetColSize(AValue: string);
begin
 FColSize:= AValue;

 FCrud_RowContainer.CSSClasses:= AValue;
end;

procedure TForm_CrudTemplate.SetCrudPermissions(APermissions: TCrudPermissions);
begin
 //Fix PermTotal
 if PermTotal in APermissions then
  FCrudPermissions:= [PermSearch, PermEdit, PermInsert, PermSave, PermDelete]
 else
  FCrudPermissions:= APermissions;

 //Search
 Crud_ButtonSearch.Visible:= (PermSearch in FCrudPermissions);

 //Insert
 Crud_ButtonNew.Visible:= (PermInsert in FCrudPermissions);

 //Save
 Crud_ButtonSave.Visible:= (PermSave in FCrudPermissions) or (PermInsert in FCrudPermissions);

 //Delete
 Crud_ButtonDelete.Visible:= (PermDelete in FCrudPermissions);
end;

end.