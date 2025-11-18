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
  D2Bridge.Prism.Menu;


type
  TD2BridgeItemHTMLSideMenu = class(TD2BridgeItem, ID2BridgeItemHTMLSideMenu)
   //events
   procedure BeginReader;
   procedure EndReader;
  private
   FD2BridgeItem: TD2BridgeItem;
   FD2BridgePrismMenu: TD2BridgePrismMenu;
   procedure OnClickMenuItem(EventParams: TStrings);
  public
   constructor Create(AOwner: TD2BridgeClass); override;
   destructor Destroy; override;

   procedure PreProcess; override;
   procedure Render; override;
   procedure RenderHTML; override;

   function Options: IPrismSideMenu;

   property BaseClass;
  end;

implementation

uses
  D2Bridge.Util,
  Prism.Forms, Prism.SideMenu;

{ TD2BridgeItemHTMLSideMenu }

constructor TD2BridgeItemHTMLSideMenu.Create(AOwner: TD2BridgeClass);
begin
 FD2BridgeItem:= Inherited Create(AOwner);

 FD2BridgeItem.OnBeginReader:= BeginReader;
 FD2BridgeItem.OnEndReader:= EndReader;

 FPrismControl:= TPrismSideMenu.Create(nil);

 FD2BridgePrismMenu:= TD2BridgePrismMenu.Create;
end;

destructor TD2BridgeItemHTMLSideMenu.Destroy;
var
 vPrismSideMenu: TPrismSideMenu;
begin
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


procedure TD2BridgeItemHTMLSideMenu.BeginReader;
begin
 (BaseClass.Form as TPrismForm).AddControl(FPrismControl);
end;

procedure TD2BridgeItemHTMLSideMenu.EndReader;
begin

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
begin
 if not FPrismControl.Initilized then
 begin
  if not Assigned((FPrismControl as TPrismSideMenu).OnMenuItemLinkClick) then
   (FPrismControl as TPrismSideMenu).OnMenuItemLinkClick:= OnClickMenuItem;
 end;

 FD2BridgePrismMenu.BuildMenuItems({$IFNDEF FMX}TMainMenu{$ELSE}TMenuBar{$ENDIF}(FPrismControl.VCLComponent), Options);
 BaseClass.HTML.Render.Body.Add('{%'+TrataHTMLTag(ItemPrefixID+' class="d2bridgemenu d2bridgesidemenu '+Trim(CSSClasses)+'" style="'+GetHTMLStyle+'"')+'%}');
end;

procedure TD2BridgeItemHTMLSideMenu.RenderHTML;
begin

end;


end.

