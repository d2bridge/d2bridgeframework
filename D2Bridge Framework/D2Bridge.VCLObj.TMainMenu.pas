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

unit D2Bridge.VCLObj.TMainMenu;


interface

{$IFNDEF FMX}
uses
  Classes,
{$IFDEF HAS_UNIT_SYSTEM_UITYPES}
  System.UITypes,
{$ENDIF}
  Menus,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass,
  D2Bridge.Prism.Menu, Prism.Interfaces;


type

 TVCLObjTMainMenu = class(TD2BridgeItemVCLObjCore)
  private
   FD2BridgePrismMenu: TD2BridgePrismMenu;
   procedure TMenuItemOnMenuItemLinkClick(EventParams: TStrings);
  public
   constructor Create(AOwner: TD2BridgeItemVCLObj); override;
   destructor Destroy; override;

   function VCLClass: TClass; override;
   function CSSClass: String; override;
   Procedure VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle); override;
   procedure ProcessPropertyClass(NewObj: TObject); override;
   procedure ProcessEventClass; override;
   function FrameworkItemClass: ID2BridgeFrameworkItem; override;

   procedure BuildMenuItems(AMainMenu: TMainMenu; APrismMainMenu: IPrismMainMenu);
 end;


implementation

uses
  SysUtils,
  Prism.Util, D2Bridge.Util, D2Bridge.HTML.CSS, D2Bridge.Item.VCLObj.Style,
  Prism.MainMenu;

{ VCLObjTMainMenu }


constructor TVCLObjTMainMenu.Create(AOwner: TD2BridgeItemVCLObj);
begin
 inherited;

 FD2BridgePrismMenu:= TD2BridgePrismMenu.Create;
end;

procedure TVCLObjTMainMenu.BuildMenuItems(AMainMenu: TMainMenu;
  APrismMainMenu: IPrismMainMenu);
begin
  FD2BridgePrismMenu.BuildMenuItems(AMainMenu, APrismMainMenu);
end;

function TVCLObjTMainMenu.CSSClass: String;
begin
 result:= 'd2bridgemenu d2bridgemainmenu navbar navbar-expand-lg navbar-dark bg-dark';
end;

destructor TVCLObjTMainMenu.Destroy;
begin
 FreeAndNil(FD2BridgePrismMenu);

 inherited;
end;

function TVCLObjTMainMenu.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.MainMenu;
end;

procedure TVCLObjTMainMenu.ProcessEventClass;
begin

end;

procedure TVCLObjTMainMenu.TMenuItemOnMenuItemLinkClick(EventParams: TStrings);
begin
  if EventParams.Objects[0] is TMenuItem then
    if TMenuItem(EventParams.Objects[0]).Visible and TMenuItem(EventParams.Objects[0]).Enabled then
      if Assigned(TMenuItem(EventParams.Objects[0]).OnClick) then
        TMenuItem(EventParams.Objects[0]).OnClick(EventParams.Objects[0]);
end;

procedure TVCLObjTMainMenu.ProcessPropertyClass(NewObj: TObject);
var
 vPrismMainMenu: TPrismMainMenu;
 vMainMenu: TMainMenu;
begin
 if NewObj is TPrismMainMenu then
 begin
  vPrismMainMenu:= NewObj as TPrismMainMenu;
  vMainMenu:= TMainMenu(FD2BridgeItemVCLObj.Item);

  BuildMenuItems(vMainMenu, vPrismMainMenu);

  vPrismMainMenu.OnMenuItemLinkClick:= TMenuItemOnMenuItemLinkClick;
 end;
end;

function TVCLObjTMainMenu.VCLClass: TClass;
begin
 Result:= TMainMenu;
end;

procedure TVCLObjTMainMenu.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin

end;

{$ELSE}
implementation
{$ENDIF}

end.

