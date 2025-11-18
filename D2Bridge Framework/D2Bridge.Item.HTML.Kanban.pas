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

unit D2Bridge.Item.HTML.Kanban;

interface

uses
  Classes, SysUtils,
  System.UITypes, Generics.Collections,
  {$IFDEF FMX}

  {$ELSE}

  {$ENDIF}
  D2Bridge.Interfaces, D2Bridge.Image, D2Bridge.Item, D2Bridge.BaseClass,
  Prism.Kanban, Prism.Interfaces;

type
  TD2BridgeItemHTMLKanban = class(TD2BridgeItem, ID2BridgeItemHTMLKanban)
   //events
   procedure BeginReader;
   procedure EndReader;
  private
   FColSize: string;
   FD2BridgeItemHTMLCard: ID2BridgeItemHTMLCard;
   function GetColSize: string;
   procedure SetColSize(const Value: string);
   function GetTopColorAuto: boolean;
   procedure SetTopColorAuto(const Value: boolean);
   procedure OnGetCSSClassCads(const AD2BridgeItem: TD2BridgeItem; var Value: string);
   function GetAddClickProc: TProc;
   function GetOnAddClick: TNotifyEvent;
   procedure SetAddClickProc(const Value: TProc);
   procedure SetOnAddClick(const Value: TNotifyEvent);
  public
   constructor Create(AOwner: TD2BridgeClass); override;
   destructor Destroy; override;
   //Functions
   procedure PreProcess; override;
   procedure Render; override;
   procedure RenderHTML; override;

   function CardModel(ATitle: string = ''; AText: string = ''; AItemID: string = ''; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLCard; overload;

   function PrismControl: TPrismKanban; reintroduce;

   property ColSize: string read GetColSize write SetColSize;
   property TopColorAuto: boolean read GetTopColorAuto write SetTopColorAuto;
   property OnAddClick: TNotifyEvent read GetOnAddClick write SetOnAddClick;
   property AddClickProc: TProc read GetAddClickProc write SetAddClickProc;

   property BaseClass;
  end;


implementation

uses
  D2Bridge.Util, D2Bridge.HTML,
  D2Bridge.Forms,
  Prism.BaseClass, Prism.Types,
  D2Bridge.Item.HTML.Card;

{ TD2BridgeItemHTMLKanban }

function TD2BridgeItemHTMLKanban.CardModel(ATitle, AText, AItemID,
  ACSSClass, AHTMLExtras, AHTMLStyle: String): ID2BridgeItemHTMLCard;
begin
 if ATitle <> '' then
  FD2BridgeItemHTMLCard.Title:= ATitle;
 if AText <> '' then
  FD2BridgeItemHTMLCard.Text:= AText;
 if AItemID <> '' then
  FD2BridgeItemHTMLCard.ItemID:= AItemID;
 if ACSSClass <> '' then
  FD2BridgeItemHTMLCard.CSSClasses:= ACSSClass;
 if AHTMLExtras <> '' then
  FD2BridgeItemHTMLCard.HTMLExtras:= AHTMLExtras;
 if AHTMLStyle <> '' then
  FD2BridgeItemHTMLCard.HTMLStyle:= AHTMLStyle;

 Result:= FD2BridgeItemHTMLCard;
end;


constructor TD2BridgeItemHTMLKanban.Create(AOwner: TD2BridgeClass);
begin
 Inherited;

 OnBeginReader:= BeginReader;
 OnEndReader:= EndReader;

 FPrismControl:= TPrismKanban.Create(nil);
// AOwner.PrismControlToRegister.Add(FPrismControl);

 AOwner.PrismControlToRegister.Add(FPrismControl);

 FD2BridgeItemHTMLCard:= TD2BridgeItemHTMLCard.Create(AOwner, true, FPrismControl);

 FD2BridgeItemHTMLCard.CSSClasses:= trim(FD2BridgeItemHTMLCard.CSSClasses + ' kanbancard');
 FD2BridgeItemHTMLCard.HTMLExtras:= Trim(FD2BridgeItemHTMLCard.HTMLExtras + ' draggable="true"');

 FD2BridgeItemHTMLCard.ItemID:= AOwner.CreateItemID('Card');
 (FD2BridgeItemHTMLCard as TD2BridgeItemHTMLCard).OnGetCSSClass:= OnGetCSSClassCads;

 PrismControl.CardModel:= FD2BridgeItemHTMLCard.PrismControl as IPrismCardModel;
end;

destructor TD2BridgeItemHTMLKanban.Destroy;
var
 vD2BridgeItemHTMLCard: TD2BridgeItemHTMLCard;
 vPrismControl: TPrismControl;
begin

 vD2BridgeItemHTMLCard:= FD2BridgeItemHTMLCard as TD2BridgeItemHTMLCard;
 FD2BridgeItemHTMLCard:= nil;
 vD2BridgeItemHTMLCard.Free;

 try
  if Assigned(FPrismControl) then
   if not Assigned(FPrismControl.Form) then
   begin
    vPrismControl:= (FPrismControl as TPrismControl);
    FPrismControl:= nil;
    vPrismControl.Free;
   end;
 except
 end;

 inherited;
end;

procedure TD2BridgeItemHTMLKanban.BeginReader;
begin

end;

procedure TD2BridgeItemHTMLKanban.EndReader;
begin
end;

function TD2BridgeItemHTMLKanban.GetAddClickProc: TProc;
begin
 result:= PrismControl.AddClickProc;
end;

function TD2BridgeItemHTMLKanban.GetColSize: string;
begin
 result:= FColSize;
end;

function TD2BridgeItemHTMLKanban.GetOnAddClick: TNotifyEvent;
begin
 result:= PrismControl.OnAddClick;
end;

function TD2BridgeItemHTMLKanban.GetTopColorAuto: boolean;
begin
 Result:= PrismControl.TopColorAuto;
end;

procedure TD2BridgeItemHTMLKanban.OnGetCSSClassCads(
  const AD2BridgeItem: TD2BridgeItem; var Value: string);
begin

end;

procedure TD2BridgeItemHTMLKanban.PreProcess;
begin

end;

function TD2BridgeItemHTMLKanban.PrismControl: TPrismKanban;
begin
 result:= FPrismControl as TPrismKanban;
end;

procedure TD2BridgeItemHTMLKanban.Render;
var
 I, X: integer;
 vCardDataModelItems: TList<ID2BridgeItem>;
 vFHTMLControls: TDictionary<string, TD2BridgeGenericHTMLControl>;
 vD2BridgeGenericHTMLControl, vHTMLControlTemp: TD2BridgeGenericHTMLControl;
 vExistNamePrefix: boolean;
 item: TPair<string, TD2BridgeGenericHTMLControl>;
begin
 BaseClass.HTML.Render.Body.Add('{%'+TrataHTMLTag(ItemPrefixID+' class="d2bridgekanban ' + CSSClasses + ' ' + ColSize + '" style="'+ GetHtmlStyle +'" '+ GetHtmlExtras) + '%}');

 {$REGION 'CardModel'}
  vCardDataModelItems:= TList<ID2BridgeItem>.Create;
  vCardDataModelItems.Add(FD2BridgeItemHTMLCard);

  vFHTMLControls:= TDictionary<string, TD2BridgeGenericHTMLControl>.Create;

  for item in BaseClass.HTML.Render.HTMLControls do
    vFHTMLControls.AddOrSetValue(item.Key, item.Value);

  HTMLItems.Clear;
  //HTMLItems.Add('<div class="col">');
  BaseClass.RenderD2Bridge(vCardDataModelItems, HTMLItems);
  //HTMLItems.Add('</div>');
  (FD2BridgeItemHTMLCard.PrismControl as IPrismCardModel).CoreHTML:= HTMLItems.Text;

  vCardDataModelItems.Free;

  try
   (FD2BridgeItemHTMLCard.PrismControl as IPrismCardModel).PrismControlIDS.Clear;
   for vD2BridgeGenericHTMLControl in BaseClass.HTML.Render.HTMLControls.Values do
   begin
    vExistNamePrefix:= false;

    for vHTMLControlTemp in vFHTMLControls.Values do
     if vHTMLControlTemp.NamePrefix = vD2BridgeGenericHTMLControl.NamePrefix then
     begin
      vExistNamePrefix:= true;
      break;
     end;

    if not vExistNamePrefix then
     (FD2BridgeItemHTMLCard.PrismControl as IPrismCardModel).PrismControlIDS.Add(vD2BridgeGenericHTMLControl.NamePrefix);
   end;
  except
  end;

  vFHTMLControls.Destroy;
 {$ENDREGION}
end;

procedure TD2BridgeItemHTMLKanban.RenderHTML;
begin
 //BaseClass.HTML.Render.Body.Add('<img class="'+ CSSClasses +'" src="'+ FImage.ImageToSrc +'" style="'+HTMLStyle+'" '+HTMLExtras+'/>');
end;

procedure TD2BridgeItemHTMLKanban.SetAddClickProc(const Value: TProc);
begin
 PrismControl.AddClickProc:= Value;
end;

procedure TD2BridgeItemHTMLKanban.SetColSize(const Value: string);
begin
 FColSize:= Value;
end;

procedure TD2BridgeItemHTMLKanban.SetOnAddClick(const Value: TNotifyEvent);
begin
 PrismControl.OnAddClick:= Value;
end;

procedure TD2BridgeItemHTMLKanban.SetTopColorAuto(const Value: boolean);
begin
 PrismControl.TopColorAuto:= Value;
end;


end.

