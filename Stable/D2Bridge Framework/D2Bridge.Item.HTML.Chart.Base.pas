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

unit D2Bridge.Item.HTML.Chart.Base;

interface

uses
  Classes, SysUtils,
  D2Bridge.Interfaces, Prism.Interfaces,
  D2Bridge.BaseClass, D2Bridge.Item, D2Bridge.ItemCommon;


type
  TD2BridgeItemHTMLChartBar = class(TD2BridgeItem, ID2BridgeItemHTMLChart)
   //events
   procedure BeginReader; virtual;
   procedure EndReader; virtual;
  private

  protected
   FD2BridgeItem: TD2BridgeItem;
   function PrismChart: IPrismChartBase;
  public
   constructor Create(AOwner: TD2BridgeClass); override;
   destructor Destroy; override;

   procedure PreProcess; override;
   procedure Render; override;
   procedure RenderHTML; override;

   property BaseClass;
  end;


implementation

uses
 D2Bridge.Util,
 Prism.Forms, Prism.Forms.Controls;

{ TD2BridgeItemHTMLChartBar }

procedure TD2BridgeItemHTMLChartBar.BeginReader;
begin
 (BaseClass.Form as TPrismForm).AddControl(FPrismControl);
end;

constructor TD2BridgeItemHTMLChartBar.Create(AOwner: TD2BridgeClass);
begin
 FD2BridgeItem:= Inherited Create(AOwner);

 FD2BridgeItem.OnBeginReader:= BeginReader;
 FD2BridgeItem.OnEndReader:= EndReader;
end;

destructor TD2BridgeItemHTMLChartBar.Destroy;
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

procedure TD2BridgeItemHTMLChartBar.EndReader;
begin

end;

procedure TD2BridgeItemHTMLChartBar.PreProcess;
begin
  inherited;

end;

function TD2BridgeItemHTMLChartBar.PrismChart: IPrismChartBase;
begin
 result:= GetPrismControl as IPrismChartBase;
end;

procedure TD2BridgeItemHTMLChartBar.Render;
begin
 inherited;

 BaseClass.HTML.Render.Body.Add('{%'+TrataHTMLTag(ItemPrefixID+' class="d2bridgechart '+Trim(CSSClasses)+'" style="'+GetHTMLStyle+'" '+ GetHTMLExtras) + '%}');
end;

procedure TD2BridgeItemHTMLChartBar.RenderHTML;
begin
  inherited;

end;

end.