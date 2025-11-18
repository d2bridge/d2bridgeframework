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

{$I ..\D2Bridge.inc}


unit Prism.Menu.SubMenu;

interface

uses
  Classes,
  Prism.Interfaces, Prism.Menu.Item, Generics.Collections;

type
 TPrismMenuItemSubMenu = class(TPrismMenuItem, IPrismMenuItemSubMenu)
  private
   FMenuItems: IPrismMenuItems;
  public
   constructor Create(AOwner: TObject; APrismMenu: IPrismMenu); override;
   destructor Destroy; override;

   function IsSubMenu: Boolean; virtual;

   function MenuItems: IPrismMenuItems;
 end;


implementation

uses
  Prism.Menu.Items;


{ TPrismMenuItemSubMenu }




constructor TPrismMenuItemSubMenu.Create(AOwner: TObject; APrismMenu: IPrismMenu);
begin
 inherited;

 FMenuItems := TPrismMenuItems.Create(Self, APrismMenu);
end;

destructor TPrismMenuItemSubMenu.Destroy;
var
 vMenuItems: TPrismMenuItems;
begin
 vMenuItems:= FMenuItems as TPrismMenuItems;
 FMenuItems:= nil;
 vMenuItems.Free;

 inherited;
end;

function TPrismMenuItemSubMenu.IsSubMenu: Boolean;
begin
 Result:= true;
end;

function TPrismMenuItemSubMenu.MenuItems: IPrismMenuItems;
begin
 Result:= FMenuItems;
end;

end.