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

unit D2Bridge.Prism.Menu;

interface

uses
  Classes, SysUtils,
 {$IFDEF FMX}
  FMX.Menus,
 {$ELSE}
  Menus,
 {$ENDIF}
  Prism.Interfaces;


type
 TD2BridgePrismMenu = class
  private
   Procedure AddMenuItems(APrismMenuItems: IPrismMenuItems; AMenuItem: TMenuItem);
  public
   Procedure BuildMenuItems(AMainMenu: {$IFNDEF FMX}TMainMenu{$ELSE}TMenuBar{$ENDIF}; APrismMenu: IPrismMenu);
 end;


implementation

uses
  Prism.Menu.Group;


{ TD2BridgeMenu }

procedure TD2BridgePrismMenu.AddMenuItems(APrismMenuItems: IPrismMenuItems; AMenuItem: TMenuItem);
var
 I: Integer;
begin
 if AMenuItem.{$IFNDEF FMX}Caption{$ELSE}Text{$ENDIF} = '-' then
  exit;

 if AMenuItem.{$IFNDEF FMX}Count{$ELSE}ItemsCount{$ENDIF} > 0 then
 begin
  if Assigned(APrismMenuItems.FromName(AMenuItem.Name)) then
  begin
   with APrismMenuItems.FromName(AMenuItem.Name) do
   begin
    Visible:= AMenuItem.Visible;
    Enabled:= AMenuItem.Enabled;
    Caption:= StringReplace(AMenuItem.{$IFNDEF FMX}Caption{$ELSE}Text{$ENDIF}, '&', '', [rfReplaceAll]);
    {$IFNDEF FMX}
     {$IFDEF DELPHIX_SYDNEY_UP} // Delphi 10.4 Sydney or Upper
     Icon:= AMenuItem.ImageName;
     {$ENDIF}
    {$ENDIF}
   end;
  end else
   with APrismMenuItems.AddSubMenu do
   begin
    Caption:= StringReplace(AMenuItem.{$IFNDEF FMX}Caption{$ELSE}Text{$ENDIF}, '&', '', [rfReplaceAll]);
    GroupIndex:= AMenuItem.GroupIndex;
    Name:= AMenuItem.Name;
    VCLComponent:= AMenuItem;
    Visible:= AMenuItem.Visible;
    Enabled:= AMenuItem.Enabled;
    {$IFNDEF FMX}
     {$IFDEF DELPHIX_SYDNEY_UP} // Delphi 10.4 Sydney or Upper
     Icon:= AMenuItem.ImageName;
     {$ENDIF}
    {$ENDIF}
    for I := 0 to Pred(AMenuItem.{$IFNDEF FMX}Count{$ELSE}ItemsCount{$ENDIF}) do
     AddMenuItems(MenuItems, AMenuItem.Items[I]);
   end;
 end else
 begin
  if Assigned(APrismMenuItems.FromName(AMenuItem.Name)) then
  begin
   with APrismMenuItems.FromName(AMenuItem.Name) do
   begin
    Caption:= StringReplace(AMenuItem.{$IFNDEF FMX}Caption{$ELSE}Text{$ENDIF}, '&', '', [rfReplaceAll]);
    Visible:= AMenuItem.Visible;
    Enabled:= AMenuItem.Enabled;
    {$IFNDEF FMX}
     {$IFDEF DELPHIX_SYDNEY_UP} // Delphi 10.4 Sydney or Upper
     Icon:= AMenuItem.ImageName;
     {$ENDIF}
    {$ENDIF}
   end;
  end else
   with APrismMenuItems.AddLink do
   begin
    Caption:= StringReplace(AMenuItem.{$IFNDEF FMX}Caption{$ELSE}Text{$ENDIF}, '&', '', [rfReplaceAll]);
    GroupIndex:= AMenuItem.GroupIndex;
    Name:= AMenuItem.Name;
    VCLComponent:= AMenuItem;
    Visible:= AMenuItem.Visible;
    Enabled:= AMenuItem.Enabled;
    {$IFNDEF FMX}
     {$IFDEF DELPHIX_SYDNEY_UP} // Delphi 10.4 Sydney or Upper
     Icon:= AMenuItem.ImageName;
     {$ENDIF}
    {$ENDIF}
   end;
 end;
end;

procedure TD2BridgePrismMenu.BuildMenuItems(AMainMenu: {$IFNDEF FMX}TMainMenu{$ELSE}TMenuBar{$ENDIF}; APrismMenu: IPrismMenu);
var
 I: Integer;
begin
 for I := 0 to Pred(AMainMenu.{$IFNDEF FMX}Items.Count{$ELSE}ItemsCount{$ENDIF}) do
 begin
  if AMainMenu.Items[I] is TMenuItem then
   AddMenuItems(APrismMenu.MenuItems, AMainMenu.Items[I] {$IFDEF FMX}as TMenuItem{$ENDIF});
 end;
end;

end.