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

unit D2Bridge.Item.HTML.Card.Footer;

interface

uses
  Classes, SysUtils, Generics.Collections,
  Prism.Interfaces,
  D2Bridge.Item.HTML.Card, D2Bridge.Item, D2Bridge.ItemCommon, D2Bridge.BaseClass, D2Bridge.Item.VCLObj,
  D2Bridge.Interfaces;

type
  TD2BridgeItemCardFooter = class(TD2BridgeHTMLTag, ID2BridgeItemHTMLCardFooter)
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

{ TD2BridgeItemCardFooter }

constructor TD2BridgeItemCardFooter.Create(AOwner: TD2BridgeItemHTMLCard);
begin
 inherited Create;

 FD2BridgeItemHTMLCard:= AOwner;
 FD2BridgeItems:= TD2BridgeItems.Create(AOwner.BaseClass);
end;

destructor TD2BridgeItemCardFooter.Destroy;
begin
 FreeAndNil(FD2BridgeItems);

 inherited;
end;

function TD2BridgeItemCardFooter.GetText: string;
begin
 result:= FText;
end;

function TD2BridgeItemCardFooter.Items: ID2BridgeAddItems;
begin
 Result:= FD2BridgeItems;
end;

procedure TD2BridgeItemCardFooter.SetText(Value: string);
begin
 FText:= Value;
end;

end.

