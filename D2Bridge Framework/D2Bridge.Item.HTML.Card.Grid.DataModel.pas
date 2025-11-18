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

unit D2Bridge.Item.HTML.Card.Grid.DataModel;

interface

{$IFNDEF FMX}

uses
  Classes, SysUtils, Generics.Collections,
{$IFDEF FMX}

{$ELSE}
  DB,
{$ENDIF}
  Prism.Interfaces, D2Bridge.Interfaces, Prism.Card.Grid.DataModel,
  D2Bridge.Item.HTML.Card.Grid, D2Bridge.Item.HTML.Card,
  D2Bridge.BaseClass;

type
  TD2BridgeItemHTMLCardGridDataModel = class(TD2BridgeItemHTMLCardGrid, ID2BridgeItemHTMLCardGridDataModel)
   private
    FD2BridgeItemHTMLCard: ID2BridgeItemHTMLCard;
    //events
    procedure BeginReader;
    procedure EndReader;

{$IFNDEF FMX}
    procedure SetDataSource(const Value: TDataSource);
    function GetDataSource: TDataSource;
{$ENDIF}
   public
    constructor Create(AOwner: TD2BridgeClass); override;
    destructor Destroy; override;

    procedure PreProcess; override;
    procedure Render; override;
    procedure RenderHTML; override;

    function PrismControl: TPrismCardGridDataModel; reintroduce;

    function CardDataModel(ATitle: string = ''; AText: string = ''; AItemID: string = ''; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLCard; overload;
{$IFNDEF FMX}
    property DataSource: TDataSource read GetDataSource write SetDataSource;
{$ENDIF}
  end;


implementation

uses
  D2Bridge.Util, D2Bridge.HTML,
  Prism.Util, Prism.Forms;


{ TD2BridgeItemHTMLCardGridDataModel }

procedure TD2BridgeItemHTMLCardGridDataModel.BeginReader;
begin
 if not Assigned(FPrismControl.Form) then
 begin
  (BaseClass.Form as TPrismForm).AddControl(FPrismControl);
 end;
end;

function TD2BridgeItemHTMLCardGridDataModel.CardDataModel(ATitle, AText,
  AItemID, ACSSClass, AHTMLExtras,
  AHTMLStyle: String): ID2BridgeItemHTMLCard;
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

constructor TD2BridgeItemHTMLCardGridDataModel.Create(AOwner: TD2BridgeClass);
begin
 inherited;

 FPrismControl := TPrismCardGridDataModel.Create(nil);
 AOwner.PrismControlToRegister.Add(FPrismControl);

 FD2BridgeItemHTMLCard:= TD2BridgeItemHTMLCard.Create(AOwner, FPrismControl);

 if FD2BridgeItemHTMLCard.CSSClasses <> '' then
  FD2BridgeItemHTMLCard.CSSClasses:= FD2BridgeItemHTMLCard.CSSClasses + ' ';
 FD2BridgeItemHTMLCard.CSSClasses:= 'd2bridgecardgriditem';

 FD2BridgeItemHTMLCard.ItemID:= AOwner.CreateItemID('Card');
 (FD2BridgeItemHTMLCard as TD2BridgeItemHTMLCard).OnGetCSSClass:= OnGetCSSClassCads;

 PrismControl.CardDataModel:= FD2BridgeItemHTMLCard.PrismControl as IPrismCard;

 FD2BridgeItem.OnBeginReader:= nil;
 FD2BridgeItem.OnEndReader:= nil;
end;

destructor TD2BridgeItemHTMLCardGridDataModel.Destroy;
var
 vD2BridgeItemHTMLCard: TD2BridgeItemHTMLCard;
 vPrismControl: TPrismCardGridDataModel;
begin
 vD2BridgeItemHTMLCard:= FD2BridgeItemHTMLCard as TD2BridgeItemHTMLCard;
 FD2BridgeItemHTMLCard:= nil;
 vD2BridgeItemHTMLCard.Free;

// if Assigned(FPrismControl) then
// begin
//  vPrismControl:= FPrismControl as TPrismCardGridDataModel;
//  FPrismControl:= nil;
//  vPrismControl.Free;
// end;


 FD2BridgeItem.OnBeginReader:= BeginReader;
 FD2BridgeItem.OnEndReader:= EndReader;

 inherited;
end;

procedure TD2BridgeItemHTMLCardGridDataModel.EndReader;
begin

end;

{$IFNDEF FMX}
function TD2BridgeItemHTMLCardGridDataModel.GetDataSource: TDataSource;
begin
 Result:= PrismControl.DataSource;
end;

procedure TD2BridgeItemHTMLCardGridDataModel.PreProcess;
begin

end;

function TD2BridgeItemHTMLCardGridDataModel.PrismControl: TPrismCardGridDataModel;
begin
 Result:= FPrismControl as TPrismCardGridDataModel;
end;

procedure TD2BridgeItemHTMLCardGridDataModel.Render;
var
 vCardDataModelItems: TList<ID2BridgeItem>;
 vFHTMLControls: TDictionary<string, TD2BridgeGenericHTMLControl>;
 vD2BridgeGenericHTMLControl, vHTMLControlTemp: TD2BridgeGenericHTMLControl;
 vCSSClass: string;
 vExistNamePrefix: boolean;
 item: TPair<string, TD2BridgeGenericHTMLControl>;
begin
// inherited;
 if Pos('carddatamodel', FD2BridgeItemHTMLCard.CSSClasses) <= 0 then
  FD2BridgeItemHTMLCard.CSSClasses := Trim(FD2BridgeItemHTMLCard.CSSClasses + ' ' + 'carddatamodel');
 if Pos('DataModelProperty', FD2BridgeItemHTMLCard.HTMLExtras) <= 0 then
  FD2BridgeItemHTMLCard.HTMLExtras := Trim(FD2BridgeItemHTMLCard.HTMLExtras + ' ' + 'DataModelProperty');

 vCSSClass:= CSSClasses;
  if (not ExistForClass(vCSSClass, 'm-')) and
     (not ExistForClass(vCSSClass, 'my-') and
     (not ExistForClass(vCSSClass, 'mb-')) and
     (not ExistForClass(vCSSClass, 'mt-'))) then
  vCSSClass:= Trim(vCSSClass + ' mt-2 mb-2');

 BaseClass.HTML.Render.Body.Add('{%'+TrataHTMLTag(ItemPrefixID+' class="d2bridgecardgrid row ' + FSpace + ' ' + vCSSClass + ' ' + FCardGridSize+ ' mb-3" style="'+ GetHtmlStyle +'" '+ GetHtmlExtras) + '%}');

 vCardDataModelItems:= TList<ID2BridgeItem>.Create;
 vCardDataModelItems.Add(FD2BridgeItemHTMLCard);

 vFHTMLControls:= TDictionary<string, TD2BridgeGenericHTMLControl>.Create;

 for item in BaseClass.HTML.Render.HTMLControls do
   vFHTMLControls.AddOrSetValue(item.Key, item.Value);

 HTMLItems.Clear;
 HTMLItems.Add('<div class="col">');
 BaseClass.RenderD2Bridge(vCardDataModelItems, HTMLItems);
 HTMLItems.Add('</div>');
 PrismControl.CardDataModelHTML:= HTMLItems.Text;

 vCardDataModelItems.Free;

 try
  PrismControl.PrismControlIDS.Clear;
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
    PrismControl.PrismControlIDS.Add(vD2BridgeGenericHTMLControl.NamePrefix);
  end;
 except
 end;

 vFHTMLControls.Destroy;

 PrismControl.ColSize:= ColSize;
end;

procedure TD2BridgeItemHTMLCardGridDataModel.RenderHTML;
begin

end;

procedure TD2BridgeItemHTMLCardGridDataModel.SetDataSource(const Value: TDataSource);
begin
 PrismControl.DataSource:= Value;
end;
{$ENDIF}

{$ELSE}
implementation
{$ENDIF}

end.
