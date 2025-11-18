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

unit D2Bridge.Item.HTML.QRCode;

interface

uses
  Classes, SysUtils, Generics.Collections,
  Prism.Interfaces,
  D2Bridge.Item, D2Bridge.BaseClass, D2Bridge.Item.VCLObj, D2Bridge.Interfaces
  {$IFDEF FMX}

  {$ELSE}

  {$ENDIF}
  ;

type
  TD2BridgeItemHTMLQRCode = class(TD2BridgeItem, ID2BridgeItemHTMLQRCode)
   //events
   procedure BeginReader;
   procedure EndReader;
  private
   FD2BridgeItem: TD2BridgeItem;
  public
   constructor Create(AOwner: TD2BridgeClass); override;
   destructor Destroy; override;

   function PrismQRCode: IPrismQRCode;

   procedure PreProcess; override;
   procedure Render; override;
   procedure RenderHTML; override;

   property BaseClass;
  end;

implementation

uses
  Prism.Forms.Controls,
  Prism.QRCode, Prism.Forms, D2Bridge.Util;

{ TD2BridgeItemHTMLQRCode }

constructor TD2BridgeItemHTMLQRCode.Create(AOwner: TD2BridgeClass);
begin
 FD2BridgeItem:= Inherited Create(AOwner);

 FPrismControl := TPrismQRCode.Create(BaseClass.PrismSession);
 FPrismControl.Name:= ITemID;

 FD2BridgeItem.OnBeginReader:= BeginReader;
 FD2BridgeItem.OnEndReader:= EndReader;

end;

destructor TD2BridgeItemHTMLQRCode.Destroy;
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


procedure TD2BridgeItemHTMLQRCode.BeginReader;
begin
 (BaseClass.Form as TPrismForm).AddControl(FPrismControl);
end;

procedure TD2BridgeItemHTMLQRCode.EndReader;
begin

end;

procedure TD2BridgeItemHTMLQRCode.PreProcess;
begin

end;

function TD2BridgeItemHTMLQRCode.PrismQRCode: IPrismQRCode;
begin
 result:= GetPrismControl as IPrismQRCode;
end;

procedure TD2BridgeItemHTMLQRCode.Render;
begin
 BaseClass.HTML.Render.Body.Add('{%'+TrataHTMLTag(ItemPrefixID+' class="d2bridgeqrcode img-fluid '+Trim(CSSClasses)+'" style="'+GetHTMLStyle+'"')+'%}');
end;

procedure TD2BridgeItemHTMLQRCode.RenderHTML;
begin

end;


end.