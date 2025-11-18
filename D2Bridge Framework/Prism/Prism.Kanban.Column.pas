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

unit Prism.Kanban.Column;

interface

uses
  Classes, SysUtils, D2Bridge.JSON, StrUtils, Generics.Collections,
  System.UITypes,
{$IFDEF FMX}

{$ELSE}

{$ENDIF}
  Prism.Forms.Controls, Prism.Interfaces, Prism.Types;


type
 TPrismKanbanColumn = class(TInterfacedPersistent, IPrismKanbanColumn)
  private
   FPrismKanban: IPrismKanban;
   FColumnIndex: integer;
   FIdentify: string;
   FName: string;
   FTitle: string;
   FQtyItems: integer;
   FTopColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
   function LastColumnIndex: integer;
   procedure RefreshColName;
   function GetColumnIndex: integer;
   procedure SetColumnIndex(const Value: integer);
   function GetIdentify: string;
   procedure SetIdentify(const Value: string);
   function GetName: String;
   procedure SetName(Value: String);
   function GetTitle: string;
   procedure SetTitle(const Value: string);
   function GetTopColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
   procedure SetTopColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
  protected
  public
   constructor Create(AOwner: IPrismKanban);
   destructor Destroy; override;

   function Kanban: IPrismKanban;

   function CardModelRenderedHTML: string;

   procedure AddCadsToInitialize(AQty: integer);
   function AddCard: IPrismCardModel;

   function Count: integer;

   property Name: String read GetName write SetName;
   property ColumnIndex: integer read GetColumnIndex write SetColumnIndex;
   property Identify: string read GetIdentify write SetIdentify;
   property Title: string read GetTitle write SetTitle;
   property TopColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF} read GetTopColor write SetTopColor;
 end;



implementation

uses
  Prism.Util, Prism.Events, Prism.Forms, Prism.Card.Model,
  Prism.Kanban;

procedure TPrismKanbanColumn.AddCadsToInitialize(AQty: integer);
var
 I: integer;
begin
 FQtyItems:= AQty;

 (Kanban.CardModel as TPrismCardModel).KanbanColumn:= self;

 for I := 0 to pred(AQty) do
 begin
  (Kanban.CardModel as TPrismCardModel).NewCard;
  (Kanban.CardModel as TPrismCardModel).Initialize;
 end;
end;

function TPrismKanbanColumn.AddCard: IPrismCardModel;
begin
 Inc(FQtyItems);

 (Kanban.CardModel as TPrismCardModel).KanbanColumn:= self;
 (Kanban.CardModel as TPrismCardModel).NewCard;

 result:= Kanban.CardModel;
end;

function TPrismKanbanColumn.CardModelRenderedHTML: string;
begin
 (Kanban.CardModel as TPrismCardModel).KanbanColumn:= self;

 result:= (Kanban.CardModel as TPrismCardModel).RenderedHTML.Text;
end;

function TPrismKanbanColumn.Count: integer;
begin
 result:= FQtyItems;
end;

constructor TPrismKanbanColumn.Create(AOwner: IPrismKanban);
begin
 inherited Create;

 FPrismKanban:= AOwner;

 FTopColor:= {$IFNDEF FPC}TColors.SysNone{$ELSE}TColorRec.Black{$ENDIF};

 FQtyItems:= 0;

 FColumnIndex:= LastColumnIndex + 1;
 RefreshColName;
end;

destructor TPrismKanbanColumn.Destroy;
begin
 //Clear;
 //FCards.Clear;
 Kanban.Columns.Remove(self);

 inherited;
end;

function TPrismKanbanColumn.GetColumnIndex: integer;
begin
 result:= FColumnIndex;
end;

function TPrismKanbanColumn.GetIdentify: string;
begin
 result:= FIdentify;
end;

function TPrismKanbanColumn.GetName: String;
begin
 Result:= FName;
end;

function TPrismKanbanColumn.GetTitle: string;
begin
 result:= FTitle;
end;

function TPrismKanbanColumn.GetTopColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
begin
 result:= FTopColor;
end;

function TPrismKanbanColumn.Kanban: IPrismKanban;
begin
 result:= FPrismKanban;
end;

function TPrismKanbanColumn.LastColumnIndex: integer;
var
 I: integer;
 vLastColumnIndex: integer;
begin
 vLastColumnIndex:= -1;

 for I := 0 to Pred(FPrismKanban.Columns.Count) do
 if FPrismKanban.Columns[I].ColumnIndex > vLastColumnIndex then
  vLastColumnIndex:= FPrismKanban.Columns[I].ColumnIndex;

 Result:= vLastColumnIndex;
end;

procedure TPrismKanbanColumn.RefreshColName;
var
 vPseudoName: string;
 vIndex: integer;
 vColName: string;
 vExistDuplicateName: Boolean;
 I: integer;
begin
 vIndex:= 1;

 vPseudoName:= FPrismKanban.Name + 'Column';

 vColName:= vPseudoName;

 repeat
  vExistDuplicateName:= false;

  if FPrismKanban.Columns.Count > 0 then
  begin
   for I := 0 to Pred(FPrismKanban.Columns.Count) do
   begin
    if FPrismKanban.Columns[I].ColumnIndex <> ColumnIndex then
    begin
     vColName:= vPseudoName;

     if vIndex > 0 then
      vColName:= vPseudoName + IntToStr(vIndex);

     if SameText(FPrismKanban.Columns[I].Name, vColName) then
     begin
      vExistDuplicateName:= true;
      inc(vIndex);
      break;
     end;
    end;
   end;
  end else
   vColName:= vPseudoName + '1';
 until not vExistDuplicateName;

 Name:= vColName;
end;

procedure TPrismKanbanColumn.SetColumnIndex(const Value: integer);
var
 I: integer;
 vLastColumnIndex: Integer;
 vColIndex: integer;
 vThisColumnIndex: Integer;
 vArrayCols: Array of Integer;
begin
 vThisColumnIndex:= FColumnIndex;
 SetLength(vArrayCols, FPrismKanban.Columns.Count);
 for I := 0 to Pred(FPrismKanban.Columns.Count) do
  vArrayCols[I]:= FPrismKanban.Columns[I].ColumnIndex;

// if Value > Pred(FPrismKanban.Columns.Count) then
//  Value:= Pred(FPrismKanban.Columns.Count);

 if FColumnIndex > Value then
 begin
  vLastColumnIndex:= Value;
  vColIndex:= Value;

  repeat
   for I := 0 to Pred(FPrismKanban.Columns.Count) do
   begin
    if vArrayCols[I] <> vThisColumnIndex then
    if vArrayCols[I] >= Value then
    begin
     if vLastColumnIndex = vArrayCols[I] then
     begin
      (FPrismKanban.Columns[I] as TPrismKanbanColumn).FColumnIndex:= vLastColumnIndex + 1;
      vLastColumnIndex:= vLastColumnIndex + 1;
      break;
     end;
    end;
   end;

   vColIndex:= vColIndex + 1;
  until vColIndex > FPrismKanban.Columns.Count;
 end;


 if FColumnIndex < Value then
 begin
  vLastColumnIndex:= Value;
  vColIndex:= Value;

  repeat
   for I := 0 to Pred(FPrismKanban.Columns.Count) do
   begin
    if vArrayCols[I] <> vThisColumnIndex then
    if vArrayCols[I] <= Value then
    begin
     if vLastColumnIndex = vArrayCols[I] then
     begin
      (FPrismKanban.Columns[I]).ColumnIndex:= vLastColumnIndex - 1;
      vLastColumnIndex:= vLastColumnIndex - 1;
      break;
     end;
    end;
   end;

   vColIndex:= vColIndex + 1;
  until vColIndex > FPrismKanban.Columns.Count;
 end;

 FColumnIndex:= Value;

 SetLength(vArrayCols, 0);
end;

procedure TPrismKanbanColumn.SetIdentify(const Value: string);
begin
 FIdentify:= Value;
end;

procedure TPrismKanbanColumn.SetName(Value: String);
begin
 FName:= Value;
end;

procedure TPrismKanbanColumn.SetTitle(const Value: string);
begin
 FTitle:= Value;
end;

procedure TPrismKanbanColumn.SetTopColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
begin
 FTopColor:= Value;
end;

end.
