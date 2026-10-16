{
 +--------------------------------------------------------------------------+
  D2Bridge Framework Content

  Author: Talis Jonatas Gomes
  Email: talisjonatas@me.com

  This source code is distributed under the terms of the
  GNU Lesser General Public License (LGPL) version 2.1.

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Lesser General Public License as published by
  the Free Software Foundation; either version 2.1 of the License, or
  (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License
  along with this library; if not, see <https://www.gnu.org/licenses/>.

  If you use this software in a product, an acknowledgment in the product
  documentation would be appreciated but is not required.

  God bless you
 +--------------------------------------------------------------------------+
}

{$I ..\D2Bridge.inc}

unit Prism.Kanban;

interface

uses
  Classes, SysUtils, D2Bridge.JSON, StrUtils, Generics.Collections,
  System.UITypes,
{$IFDEF FMX}

{$ELSE}

{$ENDIF}
  Prism.Forms.Controls, Prism.Interfaces, Prism.Types;


type
 TPrismKanban = class(TPrismControl, IPrismKanban)
  private
   FColumns: TList<IPrismKanbanColumn>;
   FCardModel: IPrismCardModel;
   FCardsModelHTML: TStrings;
   FEventCardModelClick: string;
   FTopColorAuto: boolean;
   FOnAddClick: TNotifyEvent;
   FAddClickProc: TProc;
   const
   FTopColors: array[0..23] of string =
    (
     '#d573b6','#fea065','#fed565','#92a5fb','#e18abf',
     '#ffb280','#ffe380','#a1b1fd','#cd629c','#e69253',
     '#f6c853','#8597f4','#f4a6d1','#ffad74','#ffdf74',
     '#8da4f3','#e389bb','#ffa877','#ffd877','#9cabf9',
     '#c95c95','#eb9c60','#ffd460','#7e8ff3'
    );
   function GetAddClickProc: TProc;
   function GetOnAddClick: TNotifyEvent;
   procedure SetAddClickProc(const Value: TProc);
   procedure SetOnAddClick(const Value: TNotifyEvent);
   function GetTopColorAuto: boolean;
   procedure SetTopColorAuto(const Value: boolean);
   procedure OnDragEndEvent(EventParams: TStrings);
   procedure OnColumnButtonClick(EventParams: TStrings);
   procedure OnCardModelClick(EventParams: TStrings);
   function GetColumn(const ItemIndex: integer): IPrismKanbanColumn;
   function GetColumnFromName(const AName: string): IPrismKanbanColumn;
   function GetColumnFromIdentify(const AIdentify: string): IPrismKanbanColumn;
   function GetCardModel: IPrismCardModel;
   procedure SetCardModel(const Value: IPrismCardModel);
   procedure PopuleCardModel;
   function TopColorWeb(AColumnIndex: Integer): string;
  protected
   function AlwaysInitialize: boolean; override;
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   function IsKanban: boolean; override;
  public
   constructor Create(AOwner: TObject); override;
   destructor Destroy; override;

   function Columns: TList<IPrismKanbanColumn>;
   function AddColumn: IPrismKanbanColumn;

   procedure Clear;

   property ColumnFromName[const AName: string]: IPrismKanbanColumn read GetColumnFromName;
   property ColumnFromIdentify[const AIdentify: string]: IPrismKanbanColumn read GetColumnFromIdentify;
   property Column[const ItemIndex: integer]: IPrismKanbanColumn read GetColumn;
   property CardModel: IPrismCardModel read GetCardModel write SetCardModel;
   property TopColorAuto: boolean read GetTopColorAuto write SetTopColorAuto;
   property OnAddClick: TNotifyEvent read GetOnAddClick write SetOnAddClick;
   property AddClickProc: TProc read GetAddClickProc write SetAddClickProc;
 end;



implementation

uses
  D2Bridge.Util,
  Prism.Util, Prism.Events, Prism.Forms,
  Prism.Kanban.Column, Prism.Card.Model, Prism.Card.Model.Template,
  Prism.BaseClass;


function TPrismKanban.AddColumn: IPrismKanbanColumn;
begin
 result:= TPrismKanbanColumn.Create(self);
 FColumns.Add(Result);
end;

function TPrismKanban.AlwaysInitialize: boolean;
begin
 result:= true;
end;

procedure TPrismKanban.Clear;
var
 vColumnIntf: IPrismKanbanColumn;
 vColumn: TPrismKanbanColumn;
begin
 while FColumns.Count > 0 do
 begin
  vColumnIntf:= FColumns.Last;
  FColumns.Delete(Pred(FColumns.Count));

  try
   vColumn:= vColumnIntf as TPrismKanbanColumn;
   vColumnIntf:= nil;
   vColumn.Free;
  except
  end;
 end;
end;

function TPrismKanban.Columns: TList<IPrismKanbanColumn>;
begin
 result:= FColumns;
end;

constructor TPrismKanban.Create(AOwner: TObject);
var
 vEventDragEnd, vCardModelClick, vButtonClick: TPrismControlEvent;
begin
 inherited;

 FTopColorAuto:= true;

 FColumns:= TList<IPrismKanbanColumn>.Create;

 vEventDragEnd := TPrismControlEvent.Create(self, EventOnDragEnd);
 vEventDragEnd.AutoPublishedEvent:= false;
 vEventDragEnd.SetOnEvent(OnDragEndEvent);
 Events.Add(vEventDragEnd);

 vButtonClick := TPrismControlEvent.Create(self, EventOnButtonClick);
 vButtonClick.AutoPublishedEvent:= false;
 vButtonClick.SetOnEvent(OnColumnButtonClick);
 Events.Add(vButtonClick);

 vCardModelClick := TPrismControlEvent.Create(self, EventOnItemClick);
 vCardModelClick.AutoPublishedEvent:= false;
 vCardModelClick.SetOnEvent(OnCardModelClick);
 Events.Add(vCardModelClick);

end;

destructor TPrismKanban.Destroy;
var
 I: integer;
 vColumn: TPrismKanbanColumn;
 vColumnIntf: IPrismKanbanColumn;
begin
 while FColumns.Count > 0 do
 begin
  vColumnIntf:= FColumns.Last;
  FColumns.Delete(Pred(FColumns.Count));

  vColumn:= vColumnIntf as TPrismKanbanColumn;
  vColumnIntf:= nil;
  vColumn.Free;
 end;

 FreeAndNil(FColumns);

 inherited;
end;

function TPrismKanban.GetAddClickProc: TProc;
begin
 result:= FAddClickProc;
end;

function TPrismKanban.GetCardModel: IPrismCardModel;
begin
 result:= FCardModel;
end;

function TPrismKanban.GetColumn(const ItemIndex: integer): IPrismKanbanColumn;
var
 vColumn: IPrismKanbanColumn;
begin
 System.Initialize(result);

 for vColumn in FColumns do
  if vColumn.ColumnIndex = ItemIndex then
  begin
   result:= vColumn;
   break;
  end;
end;

function TPrismKanban.GetColumnFromIdentify(const AIdentify: string): IPrismKanbanColumn;
var
 vColumn: IPrismKanbanColumn;
begin
 System.Initialize(result);

 for vColumn in FColumns do
  if SameText(vColumn.Identify, AIdentify) then
  begin
   result:= vColumn;
   break;
  end;
end;

function TPrismKanban.GetColumnFromName(const AName: string): IPrismKanbanColumn;
var
 vColumn: IPrismKanbanColumn;
begin
 System.Initialize(result);

 for vColumn in FColumns do
  if SameText(vColumn.Name, AName) then
  begin
   result:= vColumn;
   break;
  end;
end;

function TPrismKanban.GetEnableComponentState: Boolean;
begin
 Result:= true;
end;

function TPrismKanban.GetOnAddClick: TNotifyEvent;
begin
 result:= FOnAddClick;
end;

function TPrismKanban.GetTopColorAuto: boolean;
begin
 Result:= FTopColorAuto;
end;

procedure TPrismKanban.Initialize;
begin
 (CardModel as TPrismCardModel).clear;

 Clear;

 inherited;
end;

function TPrismKanban.IsKanban: boolean;
begin
 result:= true;
end;

procedure TPrismKanban.OnCardModelClick(EventParams: TStrings);
var
 vCardId, vComponentName: string;
 vCard: TPrismCardModelTemplate;
 vPrismControl: IPrismControl;
begin
 vCardId:= EventParams.Values['cardId'];
 vComponentName:= EventParams.Values['elementId'];
 System.Initialize(vPrismControl);

 if vCardId <> '' then
 begin
  vCard:= (CardModel as TPrismCardModel).CardFromId(vCardId);
  (CardModel as TPrismCardModel).Card:= vCard;

  if Assigned(vCard) then
  begin
   if vComponentName <> '' then
    vPrismControl:= (CardModel as TPrismCardModel).PrismControlFromName[vComponentName];

   (Form as TPrismForm).DoKanbanClick(CardModel, vPrismControl as TPrismControl);

   if Assigned(vPrismControl) then
   begin
    if Assigned(vPrismControl.Events.Item(EventOnClick)) then
    begin
     if vPrismControl.Enabled and vPrismControl.Visible and (not vPrismControl.ReadOnly) then
      vPrismControl.Events.Item(EventOnClick).CallEvent(EventParams);
    end;
   end;
  end;
 end;
end;

procedure TPrismKanban.OnColumnButtonClick(EventParams: TStrings);
var
 vSender: string;
begin
 if Assigned(FOnAddClick) then
 begin
  vSender:= EventParams.Values['sender'];

  if Assigned(ColumnFromName[vSender]) then
   FOnAddClick(ColumnFromName[vSender] as TObject);
 end;
end;

procedure TPrismKanban.OnDragEndEvent(EventParams: TStrings);
var
 vSourceColumn, vDestColumn: TPrismKanbanColumn;
 vCardId, vSourceColumnId, vDestColumnId: string;
 vSourcePos, vMoveToPos: integer;
 vCard: TPrismCardModelTemplate;
begin
 vCardId:= EventParams.Values['cardId'];
 vCard:= (CardModel as TPrismCardModel).CardFromId(vCardId);

 if not Assigned(vCard) then
  exit;

 if not TryStrToInt(EventParams.Values['sourcePos'], vSourcePos) then
  exit;

 vSourceColumnId:= EventParams.Values['sourceColumnId'];
 vDestColumnId:= EventParams.Values['moveToColumnId'];

 if not TryStrToInt(EventParams.Values['moveToPos'], vMoveToPos) then
  exit;

 vSourceColumn:= ColumnFromName[vSourceColumnId] as TPrismKanbanColumn;
 vDestColumn:= ColumnFromName[vDestColumnId] as TPrismKanbanColumn;
 if Assigned(vSourceColumn) and Assigned(vDestColumn) then
 begin
  vCard.ObjectContainer:= vDestColumn;
  (CardModel as TPrismCardModel).Card:= vCard;
  vCard.Row:= vMoveToPos;

  (Form as TPrismForm).D2BridgeForm.DoKanbanMoveCard(CardModel, vSourceColumn <> vDestColumn, vSourcePos <> vMoveToPos);
 end;
//
//
//cardId=KANBANCARD4
//sourceColumnId=KANBAN1COLUMN2
//sourcePos=2
//moveToColumnId=KANBAN1COLUMN1
//moveToPos=2
//


end;

procedure TPrismKanban.PopuleCardModel;
begin
//var
// vPos: integer;
// vCardHTML: string;
// vDataModelProperty: string;
//begin
//
// FRow:= -1;
// FCardsModelHTML.Clear;
// FEventCardModelClick:= AnsiUpperCase(NamePrefix)+'_OnCardClick(event, this)';
//
// if Assigned(FCardModel) then
// begin
//  vPos:= FDataLink.DataSet.RecNo;
//
//  try
//   try
//    repeat
//     try
//      FRow:= FDataLink.DataSet.RecNo;
//      vCardHTML:= FCardDataModelHTML;
//
//      //DataModelProperty
//      vDataModelProperty:= 'recno="' + IntToStr(FDataLink.DataSet.RecNo) + '"';
//      if FCardClick then
//      begin
//       vDataModelProperty:= vDataModelProperty + ' onclick="' + FEventCardModelClick + '"';
//       if FCardClickCursor then
//        vDataModelProperty:= vDataModelProperty + ' clickable';
//      end;
//      vCardHTML:= StringReplace(vCardHTML, 'DataModelProperty', vDataModelProperty, [rfReplaceAll]);
//
//      TPrismForm(Form).D2BridgeForm.DoInitPrismControl(CardDataModel as TPrismCardDataModel);
//      InitCardPrismControls;
//      Form.ProcessControlsToHTML(vCardHTML);
//      //TPrismForm(Form).D2BridgeForm.DoRenderPrismControl(CardDataModel as TPrismControl, vCardHTML);
//
//      FCardsModelHTML.Add(vCardHTML);
//     except
//     end;
//
//     FDataLink.DataSet.Next;
//    until FDataLink.DataSet.Eof or (FCardsModelHTML.Count = MaxRecords);
//   except
//   end;
//  finally
//
//  end;
// end;
end;

procedure TPrismKanban.ProcessComponentState(const ComponentStateInfo: TJSONObject);
begin
 inherited;

end;

procedure TPrismKanban.ProcessEventParameters(Event: IPrismControlEvent;
  Parameters: TStrings);
begin
  inherited;

end;

procedure TPrismKanban.ProcessHTML;
var
 vHTMLControl: TStrings;
 I: integer;
 vEventDragEnd, vEventItemClick, vScriptJS: string;
begin
 inherited;

// (CardModel as TPrismCardModel).

 vHTMLControl:= TStringList.Create;
 vHTMLControl.Clear;

 try
  try
   with vHTMLControl do
    Add('<div ' + HTMLCore + '>');

   if FColumns.Count > 0 then
    for I := 0 to Pred(FColumns.Count) do
    begin
     with vHTMLControl do
     begin
      Add('<div id="'+AnsiUpperCase(FColumns[I].Name)+'" topcolor="' + TopColorWeb(FColumns[I].ColumnIndex) + '" class="kanban-column">');
      Add('  <div class="kanban-column-title">');
      Add('    <h3>' + FColumns[I].Title + '</h3>');
      if Assigned(FAddClickProc) or Assigned(FOnAddClick) then
       Add('    <button class="kanban-add-column" sender="'+AnsiUpperCase(FColumns[I].Name)+'" data-add onclick="' + Events.Item(EventOnButtonClick).EventJS(ExecEventProc, '''sender='' + this.getAttribute(''sender'')') +'"><i class="fa-solid fa-plus"></i></button>');
      Add('  </div>');
     end;

     with vHTMLControl do
      Add('<div class="kanbancards">');

//     (CardModel as TPrismCardModel).KanbanColumn:= FColumns[I];
//     (CardModel as TPrismCardModel).Renderize(FColumns[I].QtyItems);

     with vHTMLControl do
      Add((FColumns[I] as TPrismKanbanColumn).CardModelRenderedHTML);

     with vHTMLControl do
      Add('</div>');

     with vHTMLControl do
      Add('</div>');
    end;

   with vHTMLControl do
    Add('</div>');
  except
  end;


  {$REGION 'JS'}
  if not (Form.ServerControlsUpdating) then
  begin
   vEventDragEnd:=
      Events.Item(EventOnDragEnd).EventJS(
         Session,
         Form.FormUUID,
         ExecEventProc,
            '''cardId=''+cardId+'+
            '''&sourceColumnId=''+KanbanSourceColumnId+'+
            '''&sourcePos=''+KanbanSourcePos+'+
            '''&moveToColumnId=''+KanbanDestinationColumnId+'+
            '''&moveToPos=''+KanbanDestinationPos'
         );

   vEventItemClick:=
      Events.Item(EventOnItemClick).EventJS(
         Session,
         Form.FormUUID,
         ExecEventProc,
            '''cardId=''+cardId+'+
            '''&sourceColumnId=''+sourceColumnId+'+
            '''&elementId=''+elementId'
         );

   vScriptJS:= PrismBaseClass.PrismServerHTMLHeaders.FCoreD2BridgeKanban;

   vScriptJS:=
    StringReplace(
      vScriptJS,
      '[EventOnDragEnd]',
      vEventDragEnd,
      []
    );

   vScriptJS:=
    StringReplace(
      vScriptJS,
      '[EventOnCardModelClick]',
      vEventItemClick,
      []
    );

    with vHTMLControl do
     Add(vScriptJS);
  end;
  {$ENDREGION}

  //HTML
  HTMLControl:= vHTMLControl.Text;

 finally
  vHTMLControl.Free;
 end;
end;

procedure TPrismKanban.SetAddClickProc(const Value: TProc);
begin
 FAddClickProc:= Value;
end;

procedure TPrismKanban.SetCardModel(const Value: IPrismCardModel);
begin
 FCardModel:= Value;
end;

procedure TPrismKanban.SetOnAddClick(const Value: TNotifyEvent);
begin
 FOnAddClick:= Value;
end;

procedure TPrismKanban.SetTopColorAuto(const Value: boolean);
begin
 FTopColorAuto:= Value;
end;

function TPrismKanban.TopColorWeb(AColumnIndex: Integer): string;
begin
 result:= '';

 if Column[AColumnIndex].TopColor <> {$IFNDEF FPC}TColors.SysNone{$ELSE}TColorRec.Black{$ENDIF} then
  result:= ColorToHex(Column[AColumnIndex].TopColor)
 else
  if TopColorAuto and (AColumnIndex <= (Length(FTopColors)-1)) then
   result:= FTopColors[AColumnIndex];
end;

procedure TPrismKanban.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
begin
 inherited;

 if (AForceUpdate) then
 begin
  Initialize;

  ProcessHTML;

  ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").outerHTML = '+ FormatValueHTML(HTMLControl) +';');
  ScriptJS.Add('initializekanban();');

 end;

end;

end.