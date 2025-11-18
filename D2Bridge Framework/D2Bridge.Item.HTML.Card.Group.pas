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

{$I D2Bridge.inc}

unit D2Bridge.Item.HTML.Card.Group;

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
  TD2BridgeItemHTMLCardGroup = class(TD2BridgeItem, ID2BridgeItemHTMLCardGroup)
   //events
   procedure BeginReader;
   procedure EndReader;
  private
   FD2BridgeItem: TD2BridgeItem;
   FD2BridgeItems : TD2BridgeItems;
   FColSize: string;
   FMarginCardsSize: string;
   procedure SetColSize(AColSize: string);
   function GetColSize: string;
   procedure SetMarginCardsSize(AValue: string);
   function GetMarginCardsSize: string;
   procedure OnGetCSSClassCads(const AD2BridgeItem: TD2BridgeItem; var Value: string);
  public
   constructor Create(AOwner: TD2BridgeClass); override;
   destructor Destroy; override;

   procedure PreProcess; override;
   procedure Render; override;
   procedure RenderHTML; override;

   function AddCard(ATitle: string = ''; AText: string = ''; AItemID: string = ''; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLCard; overload;

   property ColSize: string read GetColSize write SetColSize;
   property MarginCardsSize: string read GetMarginCardsSize write SetMarginCardsSize;
   property BaseClass;
  end;

implementation

uses
  D2Bridge.Item.HTML.Card;

{ TD2BridgeItemHTMLCardGroup }

constructor TD2BridgeItemHTMLCardGroup.Create(AOwner: TD2BridgeClass);
begin
 FD2BridgeItem:= Inherited Create(AOwner);

 FD2BridgeItems:= TD2BridgeItems.Create(AOwner);

 FD2BridgeItem.OnBeginReader:= BeginReader;
 FD2BridgeItem.OnEndReader:= EndReader;
end;

destructor TD2BridgeItemHTMLCardGroup.Destroy;
begin
 FreeAndNil(FD2BridgeItems);

 inherited;
end;


function TD2BridgeItemHTMLCardGroup.AddCard(ATitle, AText, AItemID, ACSSClass, AHTMLExtras, AHTMLStyle: String): ID2BridgeItemHTMLCard;
begin
 Result:= FD2BridgeItems.Add.Card(ATitle, '', AText, AItemID, ACSSClass, AHTMLExtras, AHTMLStyle);
 (result as TD2BridgeItemHTMLCard).OnGetCSSClass:= OnGetCSSClassCads;
end;

procedure TD2BridgeItemHTMLCardGroup.BeginReader;
begin

end;

procedure TD2BridgeItemHTMLCardGroup.EndReader;
begin

end;

function TD2BridgeItemHTMLCardGroup.GetColSize: string;
begin
 Result:= FColSize;
end;

function TD2BridgeItemHTMLCardGroup.GetMarginCardsSize: string;
begin
 Result:= FMarginCardsSize;
end;

procedure TD2BridgeItemHTMLCardGroup.OnGetCSSClassCads(const AD2BridgeItem: TD2BridgeItem; var Value: string);
begin
 Value:= Value + FMarginCardsSize;
end;

procedure TD2BridgeItemHTMLCardGroup.PreProcess;
begin

end;

procedure TD2BridgeItemHTMLCardGroup.Render;
begin
 with BaseClass.HTML.Render.Body do
  Add('<div id="'+AnsiUpperCase(ItemPrefixID)+'" class="d2bridgecardgroup card-group ' + CSSClasses + ' '+ FColSize +'" style="'+ HtmlStyle +'" '+ HtmlExtras +'>');

 if FD2BridgeItems.Items.Count > 0 then
  BaseClass.RenderD2Bridge(FD2BridgeItems.Items);

 with BaseClass.HTML.Render.Body do
  Add('</div>');
end;

procedure TD2BridgeItemHTMLCardGroup.RenderHTML;
begin

end;


procedure TD2BridgeItemHTMLCardGroup.SetColSize(AColSize: string);
begin
 FColSize:= AColSize;
end;

procedure TD2BridgeItemHTMLCardGroup.SetMarginCardsSize(AValue: string);
begin
 FMarginCardsSize:= AValue;
end;

end.