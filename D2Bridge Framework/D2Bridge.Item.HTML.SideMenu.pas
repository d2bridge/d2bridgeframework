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

unit D2Bridge.Item.HTML.SideMenu;

interface

uses
  Classes, SysUtils, Generics.Collections,
  {$IFDEF FMX}
   FMX.Menus,
  {$ELSE}
   Menus,
  {$ENDIF}
  Prism.Interfaces,
  D2Bridge.Item, D2Bridge.BaseClass, D2Bridge.Item.VCLObj, D2Bridge.Interfaces,
  D2Bridge.Image.Interfaces,
  D2Bridge.ItemCommon, D2Bridge.Prism.Menu,
  System.UITypes;


type
  TD2BridgeItemHTMLSideMenu = class(TD2BridgeItem, ID2BridgeItemHTMLSideMenu)
   //events
   procedure BeginReader;
   procedure EndReader;
  private
   FD2BridgeItem: TD2BridgeItem;
   FD2BridgePrismMenu: TD2BridgePrismMenu;
   FD2BridgeAccessoryItems : TD2BridgeItems;
   procedure OnClickMenuItem(EventParams: TStrings);
   function GetTitle: string;
   procedure SetTitle(const Value: string);
   function GetColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
   function GetDark: boolean;
   function GetMenuTextColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
   function GetTitleColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
   procedure SetColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
   procedure SetDark(const Value: boolean);
   procedure SetMenuTextColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
   procedure SetTitleColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
  public
   constructor Create(AOwner: TD2BridgeClass); override;
   destructor Destroy; override;

   procedure PreProcess; override;
   procedure Render; override;
   procedure RenderHTML; override;

   function AccessoryItems: ID2BridgeAddItems;
   function Image: ID2BridgeImage;

   function Options: IPrismSideMenu;

   property BaseClass;
   property Title: string read GetTitle write SetTitle;
   property Dark: boolean read GetDark write SetDark;
   property Color: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF} read GetColor write SetColor;
   property TitleColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF} read GetTitleColor write SetTitleColor;
   property MenuTextColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF} read GetMenuTextColor write SetMenuTextColor;

  end;

implementation

uses
  D2Bridge.Util,
  Prism.Forms, Prism.SideMenu;

{ TD2BridgeItemHTMLSideMenu }

constructor TD2BridgeItemHTMLSideMenu.Create(AOwner: TD2BridgeClass);
begin
 FD2BridgeItem:= Inherited Create(AOwner);

 FD2BridgeAccessoryItems:= TD2BridgeItems.Create(BaseClass);

 FD2BridgeItem.OnBeginReader:= BeginReader;
 FD2BridgeItem.OnEndReader:= EndReader;

 FPrismControl:= TPrismSideMenu.Create(nil);

 FD2BridgePrismMenu:= TD2BridgePrismMenu.Create;
end;

destructor TD2BridgeItemHTMLSideMenu.Destroy;
var
 vPrismSideMenu: TPrismSideMenu;
begin
 FD2BridgeAccessoryItems.Free;

 try
 if Assigned(FPrismControl) then
  if not Assigned(FPrismControl.Form) then
  begin
   vPrismSideMenu:= (FPrismControl as TPrismSideMenu);
   FPrismControl:= nil;
   vPrismSideMenu.Free;
  end;
 except
 end;

 FreeAndNil(FD2BridgePrismMenu);

 inherited;
end;


function TD2BridgeItemHTMLSideMenu.AccessoryItems: ID2BridgeAddItems;
begin
 result:= FD2BridgeAccessoryItems;
end;

procedure TD2BridgeItemHTMLSideMenu.BeginReader;
begin
 (BaseClass.Form as TPrismForm).AddControl(FPrismControl);
end;

procedure TD2BridgeItemHTMLSideMenu.EndReader;
begin

end;

function TD2BridgeItemHTMLSideMenu.GetColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
begin
 Result:= Options.Color;
end;

function TD2BridgeItemHTMLSideMenu.GetDark: boolean;
begin
 Result:= Options.Dark;
end;

function TD2BridgeItemHTMLSideMenu.GetMenuTextColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
begin
 Result:= Options.MenuTextColor;
end;

function TD2BridgeItemHTMLSideMenu.GetTitle: string;
begin
 Result:= Options.Title;
end;

function TD2BridgeItemHTMLSideMenu.GetTitleColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
begin
 Result:= Options.TitleColor;
end;

function TD2BridgeItemHTMLSideMenu.Image: ID2BridgeImage;
begin
 result:= Options.Image;
end;

procedure TD2BridgeItemHTMLSideMenu.OnClickMenuItem(EventParams: TStrings);
begin
 if EventParams.Objects[0] is TMenuItem then
  if TMenuItem(EventParams.Objects[0]).Visible and TMenuItem(EventParams.Objects[0]).Enabled then
   if Assigned(TMenuItem(EventParams.Objects[0]).OnClick) then
    TMenuItem(EventParams.Objects[0]).OnClick(EventParams.Objects[0]);
end;

function TD2BridgeItemHTMLSideMenu.Options: IPrismSideMenu;
begin
 result:= FPrismControl as IPrismSideMenu;
end;

procedure TD2BridgeItemHTMLSideMenu.PreProcess;
begin

end;

procedure TD2BridgeItemHTMLSideMenu.Render;
var
 vAccessoryItems: TStrings;
begin
 if not FPrismControl.Initilized then
 begin
  if not Assigned((FPrismControl as TPrismSideMenu).OnMenuItemLinkClick) then
   (FPrismControl as TPrismSideMenu).OnMenuItemLinkClick:= OnClickMenuItem;
 end;

 FD2BridgePrismMenu.BuildMenuItems({$IFNDEF FMX}TMainMenu{$ELSE}TMenuBar{$ENDIF}(FPrismControl.VCLComponent), Options);
 BaseClass.HTML.Render.Body.Add('{%'+TrataHTMLTag(ItemPrefixID+' class="d2bridgemenu d2bridgesidemenu '+Trim(CSSClasses)+'" style="'+GetHTMLStyle+'"')+'%}');

 //Accessory Items
 if FD2BridgeAccessoryItems.Count > 0 then
 begin
  vAccessoryItems:= TStringList.Create;
  vAccessoryItems.Add('<div class="d2bridgesideaccessory d-flex align-items-center">');
  BaseClass.RenderD2Bridge(FD2BridgeAccessoryItems.Items, vAccessoryItems);
  vAccessoryItems.Add('</div>');
  (Options as TPrismSideMenu).AccessoryItemsHTML:= vAccessoryItems.Text;
  vAccessoryItems.Free;
 end;
end;

procedure TD2BridgeItemHTMLSideMenu.RenderHTML;
begin

end;


procedure TD2BridgeItemHTMLSideMenu.SetColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
begin
 Options.Color := Value;
end;

procedure TD2BridgeItemHTMLSideMenu.SetDark(const Value: boolean);
begin
 Options.Dark := Value;
end;

procedure TD2BridgeItemHTMLSideMenu.SetMenuTextColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
begin
 Options.MenuTextColor := Value;
end;

procedure TD2BridgeItemHTMLSideMenu.SetTitle(const Value: string);
begin
 Options.Title:= Value;
end;

procedure TD2BridgeItemHTMLSideMenu.SetTitleColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
begin
 Options.TitleColor := Value;
end;

end.