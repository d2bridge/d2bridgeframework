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
