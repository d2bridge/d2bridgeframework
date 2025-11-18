unit unitKanban;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
 Classes, SysUtils, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,  
 D2Bridge.Forms;

type

 { TFormKanban }

 TFormKanban = class(TD2BridgeForm)
  Button_Config: TButton;
  Label_CardStr: TLabel;
  Label_Title: TLabel;
  Panel1: TPanel;
 private
  procedure PopuleKanban(AKanban: IPrismKanban);
  procedure KanbanMoveCard(const AKanbanCard: IPrismCardModel; const IsColumnMoved, IsPositionMoved: boolean); override;
  procedure KanbanClick(const AKanbanCard: IPrismCardModel; const PrismControlClick: TPrismControl); override;
  procedure OnClickAddCard(Sender: TObject);
 public
  { Public declarations }
 protected
  procedure ExportD2Bridge; override;
  procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
  procedure RenderD2Bridge(const PrismControl: TPrismControl; 
   var HTMLControl: string); override;
 end;

function FormKanban: TFormKanban;

implementation

uses
 LazarusWebApp, D2BridgeFormTemplate;

{$R *.lfm}

function FormKanban: TFormKanban;
begin
 result:= (TFormKanban.GetInstance as TFormKanban);
end;

procedure TFormKanban.PopuleKanban(AKanban: IPrismKanban);
var
 I: integer;
begin
 with AKanban do
 begin
  //TO DO
  with AddColumn do
  begin
   Title:= 'TO DO';
   Identify:= 'Column1';

   //Card
   for I := 1 to 2 do
   with AddCard do
   begin
    Identify:= KanbanColumn.Title + '_Row'+IntToStr(Row);
    Label_Title.Caption:= 'Card of ' + KanbanColumn.Title;
    Label_CardStr.Caption:= 'This card is item ' + IntToStr(Row) + ' from column ' + KanbanColumn.Title;
    //Mandatory
    Initialize;
   end;
  end;


  //RUNNING
  with AddColumn do
  begin
   Title:= 'Running';
   Identify:= 'Column2';

   //Card
   for I := 1 to 3 do
   with AddCard do
   begin
    Identify:= KanbanColumn.Title + '_Row'+IntToStr(Row);
    Label_Title.Caption:= 'Card of ' + KanbanColumn.Title;
    Label_CardStr.Caption:= 'This card is item ' + IntToStr(Row) + ' from column ' + KanbanColumn.Title;
    //Mandatory
    Initialize;
   end;
  end;




  //Finished
  with AddColumn do
  begin
   Title:= 'Finished';
   Identify:= 'Column3';

   //Card
   for I := 1 to 5 do
   with AddCard do
   begin
    Identify:= KanbanColumn.Title + '_Row'+IntToStr(Row);
    Label_Title.Caption:= 'Card of ' + KanbanColumn.Title;
    Label_CardStr.Caption:= 'This card is item ' + IntToStr(Row) + ' from column ' + KanbanColumn.Title;
    //Mandatory
    Initialize;
   end;
  end;
 end;
end;

procedure TFormKanban.KanbanMoveCard(const AKanbanCard: IPrismCardModel;
 const IsColumnMoved, IsPositionMoved: boolean);
begin
 if IsColumnMoved and IsPositionMoved then
 begin
  Showmessage('Column and position has been moved', true, true);
 end else
  if IsColumnMoved then
  begin
   Showmessage('Just Column has been moved', true, true);
  end else
   if IsPositionMoved then
   begin
    Showmessage('Just position is moved', true, true);
   end;
end;

procedure TFormKanban.KanbanClick(const AKanbanCard: IPrismCardModel;
 const PrismControlClick: TPrismControl);
begin
 //MykanbanId := AKanbanCard.Identify;

 if Assigned(PrismControlClick) then
  if PrismControlClick.VCLComponent = Button_Config then
  begin
   Showmessage('Click on Config Button');
  end;
end;

procedure TFormKanban.OnClickAddCard(Sender: TObject);
var
 vKanbanColumn: IPrismKanbanColumn;
begin
 if Supports(Sender, IPrismKanbanColumn, vKanbanColumn) then
 begin
  //vKanbanColumn.Identify ....

  showmessage('Add Card');

  //Update Kanban and Renderize
  //D2Bridge.UpdateD2BridgeControl()
  UpdateD2BridgeControls(vKanbanColumn.Kanban as TPrismControl);
 end;

end;

procedure TFormKanban.ExportD2Bridge;
begin
 inherited;

 Title:= 'Kanban Example';
 SubTitle:= 'D2Bridge native Kanban Support';

 TemplateClassForm:= TD2BridgeFormTemplate;
 D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '';
 D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

 //Export yours Controls
 with D2Bridge.Items.add do
 begin
  with Row.Items.Add do
   with Kanban('Kanban1') do
   begin
    OnAddClick:= @OnClickAddCard;

    //CardModel
    with CardModel do
    begin
     with BodyItems.Add do
     begin
      with Row.Items.Add do
      begin
       Col.Add.VCLObj(Label_Title);
       ColAuto.Add.VCLObj(Button_Config, CSSClass.Button.config + ' ' + CSSClass.Button.TypeButton.Default.light);
      end;

      with Row.Items.Add do
       Col.Add.VCLObj(Label_CardStr);
     end;
    end;
   end;
 end;
end;

procedure TFormKanban.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
 {$REGION 'Popule Kanban Mode 1'}
 if PrismControl.IsKanban then
 begin
  with PrismControl.AsKanban.AddColumn do
  begin
   Title:= 'TO DO';
   Identify:= 'Column1';
   AddCadsToInitialize(2);
  end;

  with PrismControl.AsKanban.AddColumn do
  begin
   Title:= 'Running';
   Identify:= 'Column2';
   AddCadsToInitialize(3);
  end;

  with PrismControl.AsKanban.AddColumn do
  begin
   Title:= 'Finished';
   Identify:= 'Column3';
   AddCadsToInitialize(5);
  end;
 end;

 if PrismControl.IsCardModel then
  if PrismControl.AsCardModel.IsKanbanContainer then
  with PrismControl.AsCardModel do
  begin
   Identify:= KanbanColumn.Title + '_Row'+IntToStr(Row);

   Label_Title.Caption:= 'Card of ' + KanbanColumn.Title;

   Label_CardStr.Caption:= 'This card is item ' + IntToStr(Row) + ' from column ' + KanbanColumn.Title;
  end;
 {$ENDREGION}


 {$REGION 'Popule Kanban Mode 2'}
// if PrismControl.IsKanban then
//  PopuleKanban(PrismControl as IPrismKanban);
 {$ENDREGION}
end;

procedure TFormKanban.RenderD2Bridge(const PrismControl: TPrismControl;
 var HTMLControl: string);
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
