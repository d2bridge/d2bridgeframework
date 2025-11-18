{
 +--------------------------------------------------------------------------+
  D2Bridge Framework Content

  Author: Talis Jonatas Gomes
  Email: talisjonatas@me.com

  This source code is provided 'as-is', without any express or implied
  warranty. In no event will the author be held liable for any damages
  arising from the use of this code.

  However, it is granted that this code may be used for any purpose,
  including commercial applications, but it may not be modified,
  distributed, or sublicensed without express written authorization from
  the author (Talis Jonatas Gomes). This includes creating derivative works
  or distributing the source code through any means.

  If you use this software in a product, an acknowledgment in the product
  documentation would be appreciated but is not required.

  God bless you
 +--------------------------------------------------------------------------+
}

{$I ..\D2Bridge.inc}

unit Prism.Card.Model;

interface

uses
  Classes, SysUtils, D2Bridge.JSON, StrUtils, Generics.Collections,
{$IFDEF FMX}

{$ELSE}

{$ENDIF}
  Prism.Forms.Controls, Prism.Interfaces, Prism.Types, Prism.Card,
  Prism.Card.Model.Template;

type
 TPrismCardModel = class(TPrismCard, IPrismCardModel)
  private
   FIsKanbanContainer: boolean;
   FKanban: IPrismKanban;
   FKanbanColumn: IPrismKanbanColumn;
   FCoreHTML: string;
   FPrismControlIDS: TList<string>;
   FPrismControls: TList<IPrismControl>;
   FRenderedHTML: TDictionary<TObject,TStrings>;
   FCards: TDictionary<string,TPrismCardModelTemplate>;
   FRenderRow: boolean;
   FCardsId: integer;
   FCard: TPrismCardModelTemplate;
{$IFDEF FPC}
  protected
{$ENDIF}
   function GetCoreHTML: string;
   procedure SetCoreHTML(const Value: string);
   procedure InitPrismControls;
   function GetKanbanColumn: IPrismKanbanColumn;
   procedure SetKanbanColumn(const Value: IPrismKanbanColumn);
   function GetIdentify: string;
   procedure SetIdentify(const Value: string);
   function GetRow: integer;
   procedure SetRow(const Value: integer);
   function GetRenderRow: boolean;
   procedure SetRenderRow(const Value: boolean);
   procedure OnChangePrismControlIDS(ASender: TObject; {$IFNDEF FPC}const{$ELSE}constref{$ENDIF} AItem: string; AAction: TCollectionNotification);
   function GetObjectContainer: TObject;
   procedure SetObjectContainer(const Value: TObject);
   function GetCard: TPrismCardModelTemplate;
   procedure SetCard(const Value: TPrismCardModelTemplate);
    function getPrismControlFromName(const AName: string): IPrismControl;
  public
   constructor Create(PrismControlContainer: IPrismControl); reintroduce;
   destructor Destroy; override;

   function PrismControlIDS: TList<string>;

   procedure Initialize; override;

   function IsCardModel: boolean; override;

   procedure Clear;

   function IsKanbanContainer: Boolean;

   function RenderedHTML: TStrings;

   procedure NewCard;

   function CardsFromContainer: TList<TPrismCardModelTemplate>;
   function CardFromId(const AId: string): TPrismCardModelTemplate;

   property Card: TPrismCardModelTemplate read GetCard write SetCard;
   property KanbanColumn: IPrismKanbanColumn read GetKanbanColumn write SetKanbanColumn;
   property CoreHTML: string read GetCoreHTML write SetCoreHTML;
   property Identify: string read GetIdentify write SetIdentify;
   property Row: integer read GetRow write SetRow;
   property RenderRow: boolean read GetRenderRow write SetRenderRow;
   property ObjectContainer: TObject read GetObjectContainer write SetObjectContainer;
   property PrismControlFromName[const AName: string]: IPrismControl read getPrismControlFromName;
 end;

implementation

uses
  Prism.Forms, Prism.Kanban, Prism.Kanban.Column;

{ TPrismCard }

function TPrismCardModel.GetKanbanColumn: IPrismKanbanColumn;
begin
 result:= FKanbanColumn;
end;


function TPrismCardModel.GetRenderRow: boolean;
begin
 result:= FRenderRow;
end;

function TPrismCardModel.GetRow: integer;
begin
 Result:= -1;

 if Assigned(FCard) then
  result:= FCard.Row;
end;

function TPrismCardModel.PrismControlIDS: TList<string>;
begin
 result:= FPrismControlIDS;
end;

function TPrismCardModel.RenderedHTML: TStrings;
begin
 result:= nil;

 if GetObjectContainer <> nil then
 begin
  if (FRenderedHTML.Count <= 0) or
     (not FRenderedHTML.ContainsKey(GetObjectContainer)) then
  begin
   Result:= TStringList.Create;
   FRenderedHTML.Add(GetObjectContainer, Result);
  end else
   result:= FRenderedHTML[GetObjectContainer];
 end;
end;

procedure TPrismCardModel.SetCard(const Value: TPrismCardModelTemplate);
begin
 FCard:= Value;
 ObjectContainer:= FCard.ObjectContainer;
end;

procedure TPrismCardModel.SetCoreHTML(const Value: string);
begin
 FCoreHTML:= Value;
end;

procedure TPrismCardModel.SetIdentify(const Value: string);
begin
 if Assigned(FCard) then
  FCard.Identify:= Value;
end;

procedure TPrismCardModel.SetKanbanColumn(const Value: IPrismKanbanColumn);
begin
 FKanbanColumn:= Value;
end;


procedure TPrismCardModel.SetObjectContainer(const Value: TObject);
begin
 if IsKanbanContainer then
 begin
  if Assigned(Value) then
   FKanbanColumn:= Value as TPrismKanbanColumn;
 end;
end;

procedure TPrismCardModel.SetRenderRow(const Value: boolean);
begin
 FRenderRow:= Value;
end;

procedure TPrismCardModel.SetRow(const Value: integer);
begin
 if Assigned(FCard) then
  FCard.Row:= Value;
end;

function TPrismCardModel.CardFromId(const AId: string): TPrismCardModelTemplate;
var
 vCard: TPrismCardModelTemplate;
begin
 result:= nil;

 for vCard in FCards.Values do
  if SameText(vCard.Name, AId) then
  begin
   Result:= vCard;
   break;
  end;
end;

function TPrismCardModel.CardsFromContainer: TList<TPrismCardModelTemplate>;
var
 I: integer;
begin
 Result:= TList<TPrismCardModelTemplate>.Create;

 for I := 0 to pred(FCards.Count) do
  if FCards.Values.ToArray[I].ObjectContainer = GetObjectContainer then
   Result.Add(FCards.Values.ToArray[I]);
end;

procedure TPrismCardModel.Clear;
var
 vString: TStrings;
 vKey: TObject;
 vPrismCardModelTemplate: TPrismCardModelTemplate;
 vCardId: string;
begin
 FCardsId:= 0;

 while FRenderedHTML.Count > 0 do
 begin
  vKey:= FRenderedHTML.Keys.ToArray[0];
  vString:= FRenderedHTML[vKey];
  FRenderedHTML.Remove(vKey);
  vString.Free;
 end;
 FRenderedHTML.Clear;

 while FCards.Count > 0 do
 begin
  vCardId:= FCards.Keys.ToArray[0];
  vPrismCardModelTemplate:= FCards[vCardId];
  FCards.Remove(vCardId);
  vPrismCardModelTemplate.Free;
 end;
 FCards.Clear;
end;

constructor TPrismCardModel.Create(PrismControlContainer: IPrismControl);
begin
 FCardsId:= 0;
 FIsKanbanContainer:= false;
 FKanbanColumn:= nil;

 FRenderRow:= false;

 if PrismControlContainer is TPrismKanban then
 begin
  FKanban:= PrismControlContainer as TPrismKanban;
  FIsKanbanContainer:= true;
 end;

 FPrismControlIDS:= TList<string>.Create;
 FPrismControlIDS.OnNotify:= OnChangePrismControlIDS;
 FPrismControls:= TList<IPrismControl>.Create;
 FRenderedHTML:= TDictionary<TObject,TStrings>.Create;
 FCards:= TDictionary<string,TPrismCardModelTemplate>.Create;

 inherited Create(PrismControlContainer.Form as TPrismForm);
end;

function TPrismCardModel.IsKanbanContainer: Boolean;
begin
 result:= FIsKanbanContainer;
end;

procedure TPrismCardModel.NewCard;
var
 I: integer;
 vCard: TPrismCardModelTemplate;
begin
 Inc(FCardsId);

 vCard:= TPrismCardModelTemplate.Create(self);
 vCard.Name:= AnsiUpperCase(NamePrefix) + '_' + IntToStr(FCardsId);
 vCard.TitleHeader:= TitleHeader;
 vCard.Title:= Title;
 vCard.SubTitle:= SubTitle;
 vCard.Text:= Text;
 FCards.Add(vCard.Name, vCard);

 Card:= vCard;

// Row:= Row + 1;
// vRow:= Row;

end;

function TPrismCardModel.GetObjectContainer: TObject;
begin
 Result:= nil;

 if IsKanbanContainer then
 begin
  if Assigned(KanbanColumn) then
   result:= KanbanColumn as TObject;
 end;
end;

function TPrismCardModel.getPrismControlFromName(const AName: string): IPrismControl;
var
 vPrismControl: IPrismControl;
begin
 System.Initialize(Result);

 for vPrismControl in FPrismControls do
 begin
  if SameText(vPrismControl.Name, AName) then
  begin
   result:= vPrismControl;

   break;
  end;
 end;
end;

procedure TPrismCardModel.OnChangePrismControlIDS(ASender: TObject; {$IFNDEF FPC}const{$ELSE}constref{$ENDIF} AItem: string; AAction: TCollectionNotification);
var
 I: integer;
begin
 if AAction = cnAdded then
 begin
  if AItem = NamePrefix then
    exit;

   for I := 0 to Pred(Form.Controls.Count) do
   begin
    if SameText(Form.Controls[I].NamePrefix, AItem) then
    begin
     Form.Controls[I].Updatable:= false;
     FPrismControls.Add(Form.Controls[I]);

     break;
    end;
   end;
 end;
end;


destructor TPrismCardModel.Destroy;
begin
 Clear;

 FreeAndNil(FPrismControlIDS);
 FreeAndNil(FPrismControls);
 FreeAndNil(FRenderedHTML);
 FreeAndNil(FRenderedHTML);
 FreeAndNil(FCards);

 inherited;
end;

function TPrismCardModel.GetCard: TPrismCardModelTemplate;
begin
 result:= FCard;
end;

function TPrismCardModel.GetCoreHTML: string;
begin
 result:= FCoreHTML;
end;

function TPrismCardModel.GetIdentify: string;
begin
 result:= '';

 if Assigned(FCard) then
  Result:= FCard.Identify;
end;

procedure TPrismCardModel.Initialize;
var
 vCardHTML, vDataModelProperty: string;
begin
 //inherited;
 vCardHTML:= FCoreHTML;

 vDataModelProperty:= '';
 if FRenderRow then
  vDataModelProperty:= 'row="' + IntToStr(Row) + '"';
 //  if FCardClick then
 //  begin
 //   vDataModelProperty:= vDataModelProperty + ' onclick="' + FEventCardClick + '"';
 //   if FCardClickCursor then
 //    vDataModelProperty:= vDataModelProperty + ' clickable';
 //  end;
 vCardHTML:= StringReplace(vCardHTML, 'DataModelProperty', vDataModelProperty, [rfReplaceAll]);

 (Form as TPrismForm).D2BridgeForm.DoInitPrismControl(self);
 InitPrismControls;
 Form.ProcessControlsToHTML(vCardHTML);
 //TPrismForm(Form).D2BridgeForm.DoRenderPrismControl(CardDataModel as TPrismControl, vCardHTML);

// Card.TitleHeader:=

 {$REGION 'CardModelAttr'}
  //id
  vCardHTML:= StringReplace(vCardHTML, '{{CardModelAtt=id}}', AnsiUpperCase(Card.Name), [rfReplaceAll]);
  vCardHTML:= StringReplace(vCardHTML, '{{CardModelAtt=Title}}', AnsiUpperCase(Card.Title), [rfReplaceAll]);
  vCardHTML:= StringReplace(vCardHTML, '{{CardModelAtt=SubTitle}}', AnsiUpperCase(Card.SubTitle), [rfReplaceAll]);
  vCardHTML:= StringReplace(vCardHTML, '{{CardModelAtt=TitleHeader}}', AnsiUpperCase(Card.TitleHeader), [rfReplaceAll]);
  vCardHTML:= StringReplace(vCardHTML, '{{CardModelAtt=Text}}', AnsiUpperCase(Card.Text), [rfReplaceAll]);
 {$ENDREGION} //Id


 RenderedHTML.Add(vCardHTML);
end;


procedure TPrismCardModel.InitPrismControls;
var
 vPrismControl: IPrismControl;
 vStringTemp: TStrings;
begin
 try
  vStringTemp:= TStringList.Create;

  for vPrismControl in FPrismControls do
  begin
   vStringTemp.Clear;
   try
//    if not vPrismControl.Initilized then
     //vPrismControl.Initialize;
    vPrismControl.UpdateServerControls(vStringTemp, false);
    vPrismControl.ProcessHTML;
   except
   end;
  end;

  vStringTemp.Free;
 except
 end;

end;

function TPrismCardModel.IsCardModel: boolean;
begin
 result:= true;
end;

end.
