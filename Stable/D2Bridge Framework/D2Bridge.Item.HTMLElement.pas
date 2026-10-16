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

unit D2Bridge.Item.HTMLElement;

interface

uses
  Classes, SysUtils, Generics.Collections,
  Prism.Interfaces,
  D2Bridge.Item, D2Bridge.BaseClass, D2Bridge.Item.VCLObj, D2Bridge.Interfaces;

type
  TD2BridgeItemHTMLElement = class(TD2BridgeItem, ID2BridgeItemHTMLElement)
   //events
   procedure BeginReader;
   procedure EndReader;
  private
   FD2BridgeItem: TD2BridgeItem;
   function GetHTML: string;
   procedure SetHTML(AHTML: string);
   procedure SetItemID(AItemID: String); override;
   function GetComponentHTMLElement: TComponent;
   procedure SetComponentHTMLElement(AComponent: TComponent);
  public
   constructor Create(AOwner: TD2BridgeClass); override;
   destructor Destroy; override;

   procedure PreProcess; override;
   procedure Render; override;
   procedure RenderHTML; override;

   property BaseClass;
   property HTML: String read GetHTML write SetHTML;
   property ComponentHTMLElement: TComponent read GetComponentHTMLElement write SetComponentHTMLElement;
  end;

implementation

uses
  Prism.Forms.Controls,
  Prism.Forms, Prism.HTMLElement;

{ TD2BridgeItemHTMLElement }

constructor TD2BridgeItemHTMLElement.Create(AOwner: TD2BridgeClass);
begin
 FD2BridgeItem:= Inherited Create(AOwner);

 FPrismControl := TPrismHTMLElement.Create(nil);
 FPrismControl.Name:= ITemID;

 FD2BridgeItem.OnBeginReader:= BeginReader;
 FD2BridgeItem.OnEndReader:= EndReader;
end;

destructor TD2BridgeItemHTMLElement.Destroy;
var
 vPrismControl: TPrismControl;
begin
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


function TD2BridgeItemHTMLElement.GetComponentHTMLElement: TComponent;
begin
 Result:= (FPrismControl as TPrismHTMLElement).LabelHTMLElement;
end;

function TD2BridgeItemHTMLElement.GetHTML: string;
begin
 Result:= (FPrismControl as TPrismHTMLElement).HTML;
end;

procedure TD2BridgeItemHTMLElement.BeginReader;
begin
 (BaseClass.Form as TPrismForm).AddControl(FPrismControl);
end;

procedure TD2BridgeItemHTMLElement.EndReader;
begin

end;

procedure TD2BridgeItemHTMLElement.PreProcess;
begin

end;

procedure TD2BridgeItemHTMLElement.Render;
begin
 BaseClass.HTML.Render.Body.Add('{%'+ ItemPrefixID +'%}');
end;

procedure TD2BridgeItemHTMLElement.RenderHTML;
begin

end;

procedure TD2BridgeItemHTMLElement.SetComponentHTMLElement(AComponent: TComponent);
begin
 (FPrismControl as TPrismHTMLElement).LabelHTMLElement:= AComponent;
end;

procedure TD2BridgeItemHTMLElement.SetHTML(AHTML: string);
begin
 (FPrismControl as TPrismHTMLElement).HTML:= AHTML;
end;

procedure TD2BridgeItemHTMLElement.SetItemID(AItemID: String);
begin
 inherited;

 if Assigned(FPrismControl) then
  FPrismControl.Name:= ItemID;
end;

end.