unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Menus, D2Bridge.Forms, Vcl.ExtCtrls; //Declare D2Bridge.Forms always in the last unit

type
  TForm1 = class(TD2BridgeForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MainMenu1: TMainMenu;
    Module11: TMenuItem;
    AppModule21: TMenuItem;
    Modules1: TMenuItem;
    Module12: TMenuItem;
    Module21: TMenuItem;
    SubModules1: TMenuItem;
    SubModule11: TMenuItem;
    SubModule21: TMenuItem;
    SubModule31: TMenuItem;
    CoreModules1: TMenuItem;
    CoreModule11: TMenuItem;
    CoreModule21: TMenuItem;
    Panel1: TPanel;
    Label_CardStr: TLabel;
    Label_Title: TLabel;
    Button_Config: TButton;
    procedure Module11Click(Sender: TObject);
  private
    procedure PopuleKanban(AKanban: IPrismKanban);
    procedure OnClickAddCard(Sender: TObject);
    procedure KanbanMoveCard(const AKanbanCard: IPrismCardModel; const IsColumnMoved, IsPositionMoved: boolean); override;
    procedure KanbanClick(const AKanbanCard: IPrismCardModel; const PrismControlClick: TPrismControl); override;
  public

  protected
   procedure ExportD2Bridge; override;
   procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
   procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
  end;

Function Form1: TForm1;

implementation

Uses
   KanbanWebApp;

Function Form1: TForm1;
begin
 Result:= TForm1(TForm1.GetInstance);
end;

{$R *.dfm}

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
  VCLObj(MainMenu1);
  VCLObj(Label1);
  VCLObj(Label2);
  VCLObj(Label3);

  with Row.Items.Add do
   with Kanban('Kanban1') do
   begin
    OnAddClick:= OnClickAddCard;

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

procedure TForm1.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
 inherited;

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

procedure TForm1.KanbanClick(const AKanbanCard: IPrismCardModel; const PrismControlClick: TPrismControl);
begin
 //MykanbanId := AKanbanCard.Identify;

 if Assigned(PrismControlClick) then
  if PrismControlClick.VCLComponent = Button_Config then
  begin
   //
  end;
end;

procedure TForm1.KanbanMoveCard(const AKanbanCard: IPrismCardModel; const IsColumnMoved, IsPositionMoved: boolean);
begin
 if IsColumnMoved then
 begin
  //CardModel Column moved
 end;

 if IsPositionMoved then
 begin
  //CardModel Position moved
 end;
end;

procedure TForm1.Module11Click(Sender: TObject);
begin
 Form1.Show;
end;

procedure TForm1.OnClickAddCard(Sender: TObject);
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

procedure TForm1.PopuleKanban(AKanban: IPrismKanban);
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
