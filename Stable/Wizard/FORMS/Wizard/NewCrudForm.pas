unit <UNITNAME>;

{ Copyright <COPYRIGHTYEAR> D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Classes, SysUtils, Controls, Graphics, Dialogs, StdCtrls,  
  <DEFINITIONUNIT>;

type
  T<CLASS_ID> = class(<CLASSINHERITED>)
  private
    { Private declarations }
  protected
    procedure ExportD2Bridge; override;
    procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
    procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
    //CRUD Events
    procedure CrudOnOpen; override;
    procedure CrudOnSearch(AText: string); override;
    function CrudOnEdit: boolean; override;
    function CrudOnInsert: boolean; override;
    function CrudOnSave: boolean; override;
    function CrudOnDelete: boolean; override;
    function CrudOnBack: boolean; override;
    function CrudOnClose: boolean; override;
  public
    { Public declarations }
  end;

function <CLASS_ID>:T<CLASS_ID>;

implementation

Uses
  <ServerController>;

{$R *.lfm}

function <CLASS_ID>:T<CLASS_ID>;
begin
  result:= (T<CLASS_ID>.GetInstance as T<CLASS_ID>);
end;

procedure T<CLASS_ID>.ExportD2Bridge;
begin
  inherited;

  Title:= 'My D2Bridge Form';
  SubTitle:= 'Web APP Form';

  Crud_PanelTitle.Caption:= 'Title of Card';
  Crud_PanelSubTitle.Caption:= 'Title inside the card';

  //TemplateClassForm:= TD2BridgeFormTemplate;
  //D2Bridge.FrameworkExportType.TemplateMasterHTMLFile := '';
  //D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

  with Crud_CardData.Items.Add do
  begin
   { Yours components of tab "Data" }
  end;

  with Crud_CardData.Footer.Items.Add do
  begin
   { Aditional buttons in Footer }
  end;
end;

procedure T<CLASS_ID>.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
 inherited;

 //Change CRUD Component property
 {
  if PrismControl.VCLComponent = Crud_DBGrid_Search then
  begin
   with PrismControl.AsDBGrid do
   begin
    with Columns.ColumnByIndex(0) do
    begin
     //Example button EDIT invisible
     ButtonFromButtonModel(TButtonModel.Edit).Visible:= false;
     //Example button EDIT disabled
     ButtonFromButtonModel(TButtonModel.Edit).Enabled:= false;

     //Example Add new Button
     Width:= 105;
     with Buttons.Add do
     begin
      ButtonModel:= TButtonModel.Options;
      Caption:= '';
     end;
    end;
   end;
  end;
 }
end;

procedure T<CLASS_ID>.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string);
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

procedure T<CLASS_ID>.CrudOnOpen;
begin
 inherited;

 CrudOperation(OpSearch);
end;

procedure T<CLASS_ID>.CrudOnSearch(AText: string);
begin
 inherited;

 {
  //Example1
  Crud_Query.Close;
  Crud_Query.Parameters.ParamByName('Field').Value:= '%' + AText + '%';
  Crud_Query.Open;

  //Example2
   CrudDefaultSearch('TableName', 'FieldName', Crud_EditSearch.Text, 'FiedOrder');

  //Example3
  CrudDefaultSearch(
   'TableName',
   ['FieldOne', 'FieldTwo'], //Search in two fields example
   Crud_EditSearch.Text,
   ['FieldTree = 1', 'FieldFour = ''X'''],
   ['FieldOrder1', 'FieldOrder2']
  );
 }
end;

function T<CLASS_ID>.CrudOnEdit: boolean;
begin
 result:= inherited;

 //Crud_Query.Edit;
end;

function T<CLASS_ID>.CrudOnInsert: boolean;
begin
 result:= inherited;

 {
  if not Crud_Query.IsEmpty then
  begin
   Crud_Query.Insert;
  end;
  Crud_Query.Edit;
 }
end;

function T<CLASS_ID>.CrudOnSave: boolean;
begin
 result:= inherited;

 //Crud_Query.Edit;
 //Crud_Query.Post;
end;

function T<CLASS_ID>.CrudOnDelete: boolean;
begin
 result:= inherited;

 //Crud_Query.Edit;
 //Crud_Query.Delete;
end;

function T<CLASS_ID>.CrudOnBack: boolean;
begin
 result:= inherited;

end;

function T<CLASS_ID>.CrudOnClose: boolean;
begin
 result:= inherited;

 //Crud_Query.Close;
end;

end.