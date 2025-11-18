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

unit D2Bridge.Item.HTML.MainMenu;

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
  D2Bridge.Prism.Menu, D2Bridge.ItemCommon, D2Bridge.Image.Interfaces, Prism.Types,
  System.UITypes;


type
  TD2BridgeItemHTMLMainMenu = class(TD2BridgeItem, ID2BridgeItemHTMLMainMenu)
   //events
   procedure BeginReader;
   procedure EndReader;
  private
   FD2BridgeItem: TD2BridgeItem;
   FD2BridgePrismMenu: TD2BridgePrismMenu;
   FD2BridgeRightItems : TD2BridgeItems;
   FD2BridgeAccessoryItems : TD2BridgeItems;
   FPanelTop: ID2BridgeItemHTMLMenuPanel;
   FPanelBottom: ID2BridgeItemHTMLMenuPanel;
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
   function GetTransparent: Boolean;
   procedure SetTransparent(const Value: Boolean);
  public
   constructor Create(AOwner: TD2BridgeClass); override;
   destructor Destroy; override;

   procedure PreProcess; override;
   procedure Render; override;
   procedure RenderHTML; override;

   function Options: IPrismMainMenu;

   function PanelTop: ID2BridgeItemHTMLMenuPanel;
   function PanelBottom: ID2BridgeItemHTMLMenuPanel;

   function RightItems: ID2BridgeAddItems;
   function AccessoryItems: ID2BridgeAddItems;
   function Image: ID2BridgeImage;

   procedure MenuAlignLeft;
   procedure MenuAlignCenter;
   procedure MenuAlignRight;

   property BaseClass;
   property Title: string read GetTitle write SetTitle;
   property Dark: boolean read GetDark write SetDark;
   property Color: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF} read GetColor write SetColor;
   property TitleColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF} read GetTitleColor write SetTitleColor;
   property MenuTextColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF} read GetMenuTextColor write SetMenuTextColor;
   property Transparent: Boolean read GetTransparent write SetTransparent;
  end;

implementation

uses
  D2Bridge.Util, D2Bridge.Item.HTML.Menu.Panel,
  Prism.Forms.Controls,
  Prism.ControlGeneric, Prism.Forms, Prism.MainMenu;

{ TD2BridgeItemHTMLMainMenu }

constructor TD2BridgeItemHTMLMainMenu.Create(AOwner: TD2BridgeClass);
begin
 FD2BridgeItem:= Inherited Create(AOwner);

 FD2BridgeRightItems:= TD2BridgeItems.Create(BaseClass);
 FD2BridgeAccessoryItems:= TD2BridgeItems.Create(BaseClass);

 FD2BridgeItem.OnBeginReader:= BeginReader;
 FD2BridgeItem.OnEndReader:= EndReader;

 FPrismControl:= TPrismMainMenu.Create(nil);

 FD2BridgePrismMenu:= TD2BridgePrismMenu.Create;

 FPanelTop:= TD2BridgeItemMenuPanel.Create(self);
 FPanelBottom:= TD2BridgeItemMenuPanel.Create(self);
end;

destructor TD2BridgeItemHTMLMainMenu.Destroy;
var
 vPanelTop: TD2BridgeItemMenuPanel;
 vPanelBottom: TD2BridgeItemMenuPanel;
 vPrismControl: TPrismControl;
begin
 FD2BridgeRightItems.Free;

 FD2BridgeAccessoryItems.Free;

 vPanelTop:= FPanelTop as TD2BridgeItemMenuPanel;
 FPanelTop:= nil;
 vPanelTop.Free;

 vPanelBottom:= FPanelBottom as TD2BridgeItemMenuPanel;
 FPanelBottom:= nil;
 vPanelBottom.Free;

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

 FreeAndNil(FD2BridgePrismMenu);

 inherited;
end;


function TD2BridgeItemHTMLMainMenu.AccessoryItems: ID2BridgeAddItems;
begin
  Result:= FD2BridgeAccessoryItems;
end;

procedure TD2BridgeItemHTMLMainMenu.BeginReader;
begin
 (BaseClass.Form as TPrismForm).AddControl(FPrismControl);
end;

procedure TD2BridgeItemHTMLMainMenu.EndReader;
begin

end;

function TD2BridgeItemHTMLMainMenu.GetColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
begin
 Result:= Options.Color;
end;

function TD2BridgeItemHTMLMainMenu.GetDark: boolean;
begin
 Result:= Options.Dark;
end;

function TD2BridgeItemHTMLMainMenu.GetMenuTextColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
begin
 Result:= Options.MenuTextColor;
end;

function TD2BridgeItemHTMLMainMenu.GetTitle: string;
begin
 Result:= Options.Title;
end;

function TD2BridgeItemHTMLMainMenu.GetTitleColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
begin
 Result:= Options.TitleColor;
end;

function TD2BridgeItemHTMLMainMenu.GetTransparent: Boolean;
begin
 result:= Options.Transparent;
end;

function TD2BridgeItemHTMLMainMenu.Image: ID2BridgeImage;
begin
 result:= Options.Image;
end;

procedure TD2BridgeItemHTMLMainMenu.MenuAlignCenter;
begin
 Options.MenuAlign:= TPrismAlignment.PrismAlignCenter;
end;

procedure TD2BridgeItemHTMLMainMenu.MenuAlignLeft;
begin
 Options.MenuAlign:= TPrismAlignment.PrismAlignLeft;
end;

procedure TD2BridgeItemHTMLMainMenu.MenuAlignRight;
begin
 Options.MenuAlign:= TPrismAlignment.PrismAlignRight;
end;

procedure TD2BridgeItemHTMLMainMenu.OnClickMenuItem(EventParams: TStrings);
begin
 if EventParams.Objects[0] is TMenuItem then
  if TMenuItem(EventParams.Objects[0]).Visible and TMenuItem(EventParams.Objects[0]).Enabled then
   if Assigned(TMenuItem(EventParams.Objects[0]).OnClick) then
    TMenuItem(EventParams.Objects[0]).OnClick(EventParams.Objects[0]);
end;

function TD2BridgeItemHTMLMainMenu.Options: IPrismMainMenu;
begin
 result:= FPrismControl as IPrismMainMenu;
end;

function TD2BridgeItemHTMLMainMenu.PanelBottom: ID2BridgeItemHTMLMenuPanel;
begin
 Result:= FPanelBottom;
end;

function TD2BridgeItemHTMLMainMenu.PanelTop: ID2BridgeItemHTMLMenuPanel;
begin
 Result:= FPanelTop;
end;

procedure TD2BridgeItemHTMLMainMenu.PreProcess;
begin

end;

procedure TD2BridgeItemHTMLMainMenu.Render;
var
 vRightItems: TStrings;
 vPanelTOPItems, vPanelBOTTOMItems: TStrings;
 vAccessoryItems: TStrings;
begin
 if not FPrismControl.Initilized then
 begin
  if not Assigned((FPrismControl as TPrismMainMenu).OnMenuItemLinkClick) then
   (FPrismControl as TPrismMainMenu).OnMenuItemLinkClick:= OnClickMenuItem;
 end;

 FD2BridgePrismMenu.BuildMenuItems({$IFNDEF FMX}TMainMenu{$ELSE}TMenuBar{$ENDIF}(FPrismControl.VCLComponent), Options);

 //BaseClass.HTML.Render.Body.Add('{%'+TrataHTMLTag(ItemPrefixID+' class="d2bridgemenu d2bridgemainmenu navbar navbar-expand-lg navbar-dark bg-dark '+Trim(CSSClasses)+'" style="'+GetHTMLStyle+'"')+'%}');
 BaseClass.HTML.Render.Body.Add('{%'+TrataHTMLTag(ItemPrefixID+' class="d2bridgemenu d2bridgemainmenu navbar navbar-expand-lg '+Trim(CSSClasses)+'" style="'+GetHTMLStyle+'"')+'%}');

 //Right Items
 //if not FPrismControl.Initilized then
 begin
  if FD2BridgeRightItems.Count > 0 then
  begin
   vRightItems:= TStringList.Create;
   vRightItems.Add('<div class="d2bridgemenuright row">');
   BaseClass.RenderD2Bridge(FD2BridgeRightItems.Items, vRightItems);
   vRightItems.Add('</div>');
   (Options as TPrismMainMenu).RightItemsHTML:= vRightItems.Text;
   vRightItems.Free;
  end;

  //Accessory Items
  if FD2BridgeAccessoryItems.Count > 0 then
  begin
   vAccessoryItems:= TStringList.Create;
   vAccessoryItems.Add('<div class="d2bridgemenuaccessory d-flex align-items-center">');
   BaseClass.RenderD2Bridge(FD2BridgeAccessoryItems.Items, vAccessoryItems);
   vAccessoryItems.Add('</div>');
   (Options as TPrismMainMenu).AccessoryItemsHTML:= vAccessoryItems.Text;
   vAccessoryItems.Free;
  end;

 //Panel TOP
  if FPanelTop.Items.Items.Count > 0 then
  begin
   vPanelTOPItems:= TStringList.Create;
   vPanelTOPItems.Add('<div class="d2bridgemainmenupaneltop container-fluid '+Trim(FPanelTop.CSSClasses)+'" style="'+FPanelTop.HTMLStyle+'" '+ FPanelTop.HTMLExtras +'>');
   vPanelTOPItems.Add('<div class="container-fluid pt-2 pb-2">');
   BaseClass.RenderD2Bridge(FPanelTop.Items.Items, vPanelTOPItems);
   vPanelTOPItems.Add('</div>');
   vPanelTOPItems.Add('</div>');
   (Options as TPrismMainMenu).PanelTopItemsHTML:= vPanelTOPItems.Text;
   vPanelTOPItems.Free;
  end;

 //Panel Bottom
  if FPanelBottom.Items.Items.Count > 0 then
  begin
   vPanelBOTTOMItems:= TStringList.Create;
   vPanelBOTTOMItems.Add('<div class="d2bridgemainmenupanelbottom container-fluid '+Trim(FPanelBottom.CSSClasses)+'" style="'+FPanelBottom.HTMLStyle+'" '+ FPanelBottom.HTMLExtras +'>');
   vPanelBOTTOMItems.Add('<div class="container-fluid pt-2 pb-2">');
   BaseClass.RenderD2Bridge(FPanelBottom.Items.Items, vPanelBOTTOMItems);
   vPanelBOTTOMItems.Add('</div>');
   vPanelBOTTOMItems.Add('</div>');
   (Options as TPrismMainMenu).PanelBottomItemsHTML:= vPanelBOTTOMItems.Text;
   vPanelBOTTOMItems.Free;
  end;
 end;
end;

procedure TD2BridgeItemHTMLMainMenu.RenderHTML;
begin

end;


function TD2BridgeItemHTMLMainMenu.RightItems: ID2BridgeAddItems;
begin
 Result:= FD2BridgeRightItems;
end;

procedure TD2BridgeItemHTMLMainMenu.SetColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
begin
 Options.Color := Value;
end;

procedure TD2BridgeItemHTMLMainMenu.SetDark(const Value: boolean);
begin
 Options.Dark := Value;
end;

procedure TD2BridgeItemHTMLMainMenu.SetMenuTextColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
begin
 Options.MenuTextColor := Value;
end;

procedure TD2BridgeItemHTMLMainMenu.SetTitle(const Value: string);
begin
 Options.Title:= Value;
end;

procedure TD2BridgeItemHTMLMainMenu.SetTitleColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
begin
 Options.TitleColor := Value;
end;

procedure TD2BridgeItemHTMLMainMenu.SetTransparent(const Value: Boolean);
begin
 Options.Transparent:= Value;
end;

end.