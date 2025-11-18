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

{$I D2Bridge.inc}

unit D2Bridge.Item.HTML.Card.Grid;

interface

uses
  Classes, SysUtils, Generics.Collections,
{$IFDEF FMX}
{$ELSE}
  ExtCtrls, Graphics,
{$ENDIF}
  Prism.Interfaces,
  D2Bridge.ItemCommon, D2Bridge.Types, D2Bridge.Item, D2Bridge.BaseClass, D2Bridge.Item.VCLObj,
  D2Bridge.Interfaces;

type
  TD2BridgeItemHTMLCardGrid = class(TD2BridgeItem, ID2BridgeItemHTMLCardGrid)
   //events
   procedure BeginReader;
   procedure EndReader;
{$IFNDEF FPC}
  private
{$ELSE}
  protected
{$ENDIF}
   procedure SetCardGridSize(ACardGridSize: string);
   function GetCardGridSize: string;
   procedure SetEqualHeight(AValue: Boolean);
   function GetEqualHeight: Boolean;
   procedure SetSpace(AValue: String);
   function GetSpace: String;
  protected
   FD2BridgeItem: TD2BridgeItem;
   FD2BridgeItems : TD2BridgeItems;
   FColSize: string;
   FCardGridSize: string;
   FEqualHeight: boolean;
   FSpace: string;
   procedure SetColSize(AColSize: string); virtual;
   function GetColSize: string; virtual;
   procedure OnGetCSSClassCads(const AD2BridgeItem: TD2BridgeItem; var Value: string);
  public
   constructor Create(AOwner: TD2BridgeClass); override;
   destructor Destroy; override;

   procedure PreProcess; override;
   procedure Render; override;
   procedure RenderHTML; override;

   function AddCard(ATitle: string = ''; AText: string = ''; AItemID: string = ''; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLCard; overload;

   property ColSize: string read GetColSize write SetColSize;
   property CardGridSize: string read GetCardGridSize write SetCardGridSize;
   property EqualHeight: boolean read GetEqualHeight write SetEqualHeight;
   property Space: string read GetSpace write SetSpace;
   property BaseClass;
  end;

implementation

uses
  D2Bridge.Item.HTML.Card, Prism.Util;

{ TD2BridgeItemHTMLCardGrid }

constructor TD2BridgeItemHTMLCardGrid.Create(AOwner: TD2BridgeClass);
begin
 FD2BridgeItem:= Inherited Create(AOwner);

 FSpace:= 'g-2';

 FColSize:= '';
 FEqualHeight:= true;
 FCardGridSize:= BaseClass.CSSClass.CardGrid.CardGridX4;

 FD2BridgeItems:= TD2BridgeItems.Create(AOwner);

 FD2BridgeItem.OnBeginReader:= BeginReader;
 FD2BridgeItem.OnEndReader:= EndReader;
end;

destructor TD2BridgeItemHTMLCardGrid.Destroy;
begin
 FreeAndNil(FD2BridgeItems);

 inherited;
end;

function TD2BridgeItemHTMLCardGrid.AddCard(ATitle, AText, AItemID, ACSSClass,
  AHTMLExtras, AHTMLStyle: String): ID2BridgeItemHTMLCard;
begin
 if ACSSClass <> '' then
  ACSSClass:= ACSSClass + ' ';
 ACSSClass:= 'd2bridgecardgriditem';

 Result:= FD2BridgeItems.Add.Card(ATitle, '', AText, AItemID, ACSSClass, AHTMLExtras, AHTMLStyle);
 (Result as TD2BridgeItemHTMLCard).OnGetCSSClass:= OnGetCSSClassCads;
end;

procedure TD2BridgeItemHTMLCardGrid.BeginReader;
var
 vCSSClass: string;
begin
 with BaseClass.HTML.Render.Body do
 begin
  if TRIM(FColSize) <> '' then
  begin
   Add('<div class="' + FColSize +'">');
  end;

  vCSSClass:= CSSClasses;
   if (not ExistForClass(vCSSClass, 'm-')) and
      (not ExistForClass(vCSSClass, 'my-') and
      (not ExistForClass(vCSSClass, 'mb-')) and
      (not ExistForClass(vCSSClass, 'mt-'))) then
   vCSSClass:= Trim(vCSSClass + ' mt-2 mb-2');

  Add('<div id="'+AnsiUpperCase(ItemPrefixID)+'" class="d2bridgecardgrid row ' + FSpace + ' ' + vCSSClass + ' ' + FCardGridSize+ '" style="'+ HtmlStyle +'" '+ HtmlExtras +'>');
 end;
end;

procedure TD2BridgeItemHTMLCardGrid.EndReader;
begin
 with BaseClass.HTML.Render.Body do
 begin
  Add('</div>');

  if TRIM(FColSize) <> '' then
   Add('</div>');
 end;

end;

function TD2BridgeItemHTMLCardGrid.GetColSize: string;
begin
 Result:= FColSize;
end;

function TD2BridgeItemHTMLCardGrid.GetEqualHeight: Boolean;
begin
 result:= FEqualHeight;
end;

function TD2BridgeItemHTMLCardGrid.GetCardGridSize: string;
begin
 result:= FCardGridSize;
end;

function TD2BridgeItemHTMLCardGrid.GetSpace: String;
begin
 result:= FSpace;
end;

procedure TD2BridgeItemHTMLCardGrid.OnGetCSSClassCads(
  const AD2BridgeItem: TD2BridgeItem; var Value: string);
begin
 if FEqualHeight then
 Value:= Value + ' h-100';
end;

procedure TD2BridgeItemHTMLCardGrid.PreProcess;
begin

end;

procedure TD2BridgeItemHTMLCardGrid.Render;
var
 I: integer;
begin
 if FD2BridgeItems.Items.Count > 0 then
 begin
  for I := 0 to Pred(FD2BridgeItems.Items.Count) do
  begin
   with BaseClass.HTML.Render.Body do
    Add('<div class="col">');

   BaseClass.RenderD2Bridge(FD2BridgeItems.Items[I]);

   with BaseClass.HTML.Render.Body do
    Add('</div>');
  end;
 end;
end;

procedure TD2BridgeItemHTMLCardGrid.RenderHTML;
begin

end;


procedure TD2BridgeItemHTMLCardGrid.SetColSize(AColSize: string);
begin
 FColSize:= AColSize;
end;

procedure TD2BridgeItemHTMLCardGrid.SetEqualHeight(AValue: Boolean);
begin
 FEqualHeight:= AValue;
end;

procedure TD2BridgeItemHTMLCardGrid.SetCardGridSize(ACardGridSize: string);
begin
 FCardGridSize:= ACardGridSize;
end;

procedure TD2BridgeItemHTMLCardGrid.SetSpace(AValue: String);
begin
 FSpace:= AValue;
end;

end.
