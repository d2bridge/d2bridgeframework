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

unit Prism.Card.Model.Template;

interface

uses
  Classes, SysUtils, D2Bridge.JSON, StrUtils,
{$IFDEF FMX}

{$ELSE}

{$ENDIF}
  Prism.Interfaces, Prism.Types,
  Generics.Collections;

type
 TPrismCardModelTemplate = class
  private
   FPrismCardModel: IPrismCardModel;
   FObjectContainer: TObject;
   FRow: integer;
   FIdentify: string;
   FName: string;
   FTitle: string;
   FTitleHeader: string;
   FSubTitle: string;
   FText: string;
   function GetIdentify: string;
   function GetObjectContainer: TObject;
   function GetRow: integer;
   procedure SetIdentify(const Value: string);
   procedure SetObjectContainer(const Value: TObject);
   procedure SetRow(const Value: integer);
   function GetName: string;
   procedure SetName(const Value: string);
   function GetSubTitle: string;
   function GetText: string;
   function GetTitle: string;
   function GetTitleHeader: string;
   procedure SetSubTitle(const Value: string);
   procedure SetText(const Value: string);
   procedure SetTitle(const Value: string);
   procedure SetTitleHeader(const Value: string);
  public
   constructor Create(APrismCardModel: IPrismCardModel);

   property Name: string read GetName write SetName;
   property ObjectContainer: TObject read GetObjectContainer write SetObjectContainer;
   property Row: integer read GetRow write SetRow;
   property Identify: string read GetIdentify write SetIdentify;
   property Title: string read GetTitle write SetTitle;
   property TitleHeader: string read GetTitleHeader write SetTitleHeader;
   property SubTitle: string read GetSubTitle write SetSubTitle;
   property Text: string read GetText write SetText;
 end;

implementation

uses
  Prism.Card.Model;

{ TPrismCardModelTemplate }

constructor TPrismCardModelTemplate.Create(APrismCardModel: IPrismCardModel);
var
 vRow: Integer;
 vCards: TList<TPrismCardModelTemplate>;
 vCard: TPrismCardModelTemplate;
begin
 FPrismCardModel:= APrismCardModel;
 FObjectContainer:= (FPrismCardModel as TPrismCardModel).ObjectContainer;

 vRow:= -1;

 vCards:= (FPrismCardModel as TPrismCardModel).CardsFromContainer;

 for vCard  in vCards do
  if vCard.Row > vRow then
   vRow:= vCard.Row;
 FreeAndNil(vCards);

 FRow:= vRow + 1;

end;

function TPrismCardModelTemplate.GetIdentify: string;
begin
 result:= FIdentify;
end;

function TPrismCardModelTemplate.GetName: string;
begin
 Result:= FName;
end;

function TPrismCardModelTemplate.GetObjectContainer: TObject;
begin
 result:= FObjectContainer;
end;

function TPrismCardModelTemplate.GetRow: integer;
begin
 Result:= FRow;
end;

function TPrismCardModelTemplate.GetSubTitle: string;
begin
 result:= FSubTitle;
end;

function TPrismCardModelTemplate.GetText: string;
begin
 Result:= FText;
end;

function TPrismCardModelTemplate.GetTitle: string;
begin
 Result:= FTitle;
end;

function TPrismCardModelTemplate.GetTitleHeader: string;
begin
 Result:= FTitleHeader;
end;

procedure TPrismCardModelTemplate.SetIdentify(const Value: string);
begin
 FIdentify:= Value;
end;

procedure TPrismCardModelTemplate.SetName(const Value: string);
begin
 FName:= Value;
end;

procedure TPrismCardModelTemplate.SetObjectContainer(const Value: TObject);
begin
 FObjectContainer:= Value;
end;

procedure TPrismCardModelTemplate.SetRow(const Value: integer);
var
 I: integer;
 vLastRow: Integer;
 vRow: integer;
 vThisRow: Integer;
 vArrayRows: Array of Integer;
 vCards: TList<TPrismCardModelTemplate>;
begin
 (FPrismCardModel as TPrismCardModel).ObjectContainer:= ObjectContainer;
 vCards:= (FPrismCardModel as TPrismCardModel).CardsFromContainer;

 vThisRow:= FRow;
 SetLength(vArrayRows, vCards.Count);
 for I := 0 to Pred(vCards.Count) do
  vArrayRows[I]:= vCards[I].Row;

// if Value > Pred(.vCards.Count) then
//  Value:= Pred(.vCards.Count);

 if FRow > Value then
 begin
  vLastRow:= Value;
  vRow:= Value;

  repeat
   for I := 0 to Pred(vCards.Count) do
   begin
    if vArrayRows[I] <> vThisRow then
    if vArrayRows[I] >= Value then
    begin
     if vLastRow = vArrayRows[I] then
     begin
      vCards[I].Row:= vLastRow + 1;
      vLastRow:= vLastRow + 1;
      break;
     end;
    end;
   end;

   vRow:= vRow + 1;
  until vRow > vCards.Count;
 end;


 if FRow < Value then
 begin
  vLastRow:= Value;
  vRow:= Value;

  repeat
   for I := 0 to Pred(vCards.Count) do
   begin
    if vArrayRows[I] <> vThisRow then
    if vArrayRows[I] <= Value then
    begin
     if vLastRow = vArrayRows[I] then
     begin
      vCards[I].FRow:= vLastRow - 1;
      vLastRow:= vLastRow - 1;
      break;
     end;
    end;
   end;

   vRow:= vRow + 1;
  until vRow > vCards.Count;
 end;

 FRow:= Value;

 SetLength(vArrayRows, 0);
 FreeAndNil(vCards);
end;

procedure TPrismCardModelTemplate.SetSubTitle(const Value: string);
begin
 FSubTitle:= Value;
end;

procedure TPrismCardModelTemplate.SetText(const Value: string);
begin
 FText:= Value;
end;

procedure TPrismCardModelTemplate.SetTitle(const Value: string);
begin
 FTitle:= Value;
end;

procedure TPrismCardModelTemplate.SetTitleHeader(const Value: string);
begin
 FTitleHeader:= Value;
end;

end.
