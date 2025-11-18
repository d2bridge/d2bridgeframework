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

unit D2Bridge.FMXObj.TMenuBar;


interface

{$IFDEF FMX}
uses
  Classes, SysUtils,
  FMX.Menus,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass,
  D2Bridge.Prism.Menu, Prism.Interfaces;


type
 TFMXObjTMenuBar = class(TD2BridgeItemVCLObjCore)
  private
   FD2BridgePrismMenu: TD2BridgePrismMenu;
  public
   constructor Create(AOwner: TD2BridgeItemVCLObj); override;
   destructor Destroy; override;

   function VCLClass: TClass; override;
   function CSSClass: String; override;
   Procedure VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle); override;
   procedure ProcessPropertyClass(NewObj: TObject); override;
   procedure ProcessEventClass; override;
   function FrameworkItemClass: ID2BridgeFrameworkItem; override;

   procedure BuildMenuItems(AMainMenu: TMenuBar; APrismMainMenu: IPrismMainMenu);
 end;


implementation

uses
  Prism.Util, D2Bridge.Util, D2Bridge.HTML.CSS, D2Bridge.Item.VCLObj.Style,
  Prism.MainMenu;

{ TFMXObjTMenuBar }


constructor TFMXObjTMenuBar.Create(AOwner: TD2BridgeItemVCLObj);
begin
 inherited;

 FD2BridgePrismMenu:= TD2BridgePrismMenu.Create;
end;

procedure TFMXObjTMenuBar.BuildMenuItems(AMainMenu: TMenuBar;
  APrismMainMenu: IPrismMainMenu);
begin
 FD2BridgePrismMenu.BuildMenuItems(AMainMenu, APrismMainMenu);
end;

function TFMXObjTMenuBar.CSSClass: String;
begin
 result:= 'd2bridgemenu d2bridgemainmenu navbar navbar-expand-lg navbar-dark bg-dark';
end;

destructor TFMXObjTMenuBar.Destroy;
begin
 FreeAndNil(FD2BridgePrismMenu);

 inherited;
end;

function TFMXObjTMenuBar.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.MainMenu;
end;

procedure TFMXObjTMenuBar.ProcessEventClass;
begin

end;

procedure TFMXObjTMenuBar.ProcessPropertyClass(NewObj: TObject);
var
 vPrismMainMenu: TPrismMainMenu;
 vMainMenu: TMenuBar;
begin
 if NewObj is TPrismMainMenu then
 begin
  vPrismMainMenu:= NewObj as TPrismMainMenu;
  vMainMenu:= TMenuBar(FD2BridgeItemVCLObj.Item);

  BuildMenuItems(vMainMenu, vPrismMainMenu);

  vPrismMainMenu.OnMenuItemLinkClick:=
   procedure(EventParams: TStrings)
   begin
    if EventParams.Objects[0] is TMenuItem then
     if TMenuItem(EventParams.Objects[0]).Visible and TMenuItem(EventParams.Objects[0]).Enabled then
      if Assigned(TMenuItem(EventParams.Objects[0]).OnClick) then
       TMenuItem(EventParams.Objects[0]).OnClick(EventParams.Objects[0]);
   end;
 end;
end;

function TFMXObjTMenuBar.VCLClass: TClass;
begin
 Result:= TMenuBar;
end;

procedure TFMXObjTMenuBar.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin

end;

{$ELSE}
implementation
{$ENDIF}


end.