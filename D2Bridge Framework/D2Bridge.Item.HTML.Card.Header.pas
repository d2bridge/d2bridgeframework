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

unit D2Bridge.Item.HTML.Card.Header;

interface

uses
  Classes, SysUtils, Generics.Collections,
  Prism.Interfaces,
  D2Bridge.Item.HTML.Card, D2Bridge.Item, D2Bridge.ItemCommon, D2Bridge.BaseClass, D2Bridge.Item.VCLObj,
  D2Bridge.Interfaces;

type
  TD2BridgeItemCardHeader = class(TD2BridgeHTMLTag, ID2BridgeItemHTMLCardHeader)
  private
   FD2BridgeItemHTMLCard: TD2BridgeItemHTMLCard;
   FD2BridgeItems: TD2BridgeItems;
   FText: string;
   function GetText: string;
   procedure SetText(Value: string);
  public
   constructor Create(AOwner: TD2BridgeItemHTMLCard); reintroduce;
   destructor Destroy; override;

   Function Items: ID2BridgeAddItems;

   property Text: string read GetText write SetText;
  end;

implementation

{ TD2BridgeItemCardHeader }

constructor TD2BridgeItemCardHeader.Create(AOwner: TD2BridgeItemHTMLCard);
begin
 inherited Create;

 FD2BridgeItemHTMLCard:= AOwner;
 FD2BridgeItems:= TD2BridgeItems.Create(AOwner.BaseClass);
end;

destructor TD2BridgeItemCardHeader.Destroy;
begin
 FreeAndNil(FD2BridgeItems);

 inherited;
end;

function TD2BridgeItemCardHeader.GetText: string;
begin
 result:= FText;
end;

function TD2BridgeItemCardHeader.Items: ID2BridgeAddItems;
begin
 Result:= FD2BridgeItems;
end;

procedure TD2BridgeItemCardHeader.SetText(Value: string);
begin
 FText:= Value;
end;

end.