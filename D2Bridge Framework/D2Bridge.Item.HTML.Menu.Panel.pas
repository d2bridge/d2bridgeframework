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

unit D2Bridge.Item.HTML.Menu.Panel;

interface

uses
  Classes, SysUtils, Generics.Collections,
  Prism.Interfaces,
  D2Bridge.Item, D2Bridge.ItemCommon, D2Bridge.BaseClass, D2Bridge.Item.VCLObj,
  D2Bridge.Interfaces, System.UITypes;

type
  TD2BridgeItemMenuPanel = class(TD2BridgeHTMLTag, ID2BridgeItemHTMLMenuPanel)
  private
   FD2BridgeItemHTMLMenu: TObject;
   FD2BridgeItems: TD2BridgeItems;
   function GetColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
   procedure SetColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
  public
   constructor Create(AOwner: TObject);
   destructor Destroy; override;

   Function Items: ID2BridgeAddItems;

   property Color: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF} read GetColor write SetColor;
  end;

implementation

uses
  D2Bridge.Item.HTML.MainMenu;

{ TD2BridgeItemMenuPanel }

constructor TD2BridgeItemMenuPanel.Create(AOwner: TObject);
begin
 inherited Create;

 FD2BridgeItemHTMLMenu:= AOwner;

 if AOwner is TD2BridgeItemHTMLMainMenu then
  FD2BridgeItems:= TD2BridgeItems.Create((AOwner as TD2BridgeItemHTMLMainMenu).BaseClass);
end;

destructor TD2BridgeItemMenuPanel.Destroy;
begin
 FreeAndNil(FD2BridgeItems);

 inherited;
end;

function TD2BridgeItemMenuPanel.GetColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
begin
 if FD2BridgeItemHTMLMenu is TD2BridgeItemHTMLMainMenu then
  Result:= (FD2BridgeItemHTMLMenu as TD2BridgeItemHTMLMainMenu).Options.PanelTop.Color;
end;

function TD2BridgeItemMenuPanel.Items: ID2BridgeAddItems;
begin
 Result:= FD2BridgeItems;
end;

procedure TD2BridgeItemMenuPanel.SetColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
begin
 if FD2BridgeItemHTMLMenu is TD2BridgeItemHTMLMainMenu then
  (FD2BridgeItemHTMLMenu as TD2BridgeItemHTMLMainMenu).Options.PanelTop.Color:= Value;
end;

end.