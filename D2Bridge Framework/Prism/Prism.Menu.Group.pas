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


unit Prism.Menu.Group;

interface

uses
  Classes,
  Prism.Interfaces, Prism.Menu.Item, Generics.Collections;

type
 TPrismMenuItemGroup = class(TPrismMenuItem, IPrismMenuItemGroup)
  private
   FGroupIndex: integer;
   function GetGroupIndex: Integer;
   procedure SetGroupIndex(const Value: Integer);
  public
   constructor Create(AOwner: TObject; APrismMenu: IPrismMenu); override;
   destructor Destroy; override;

   function IsGroup: Boolean; virtual;

   property GroupIndex: Integer read GetGroupIndex write SetGroupIndex;
 end;


implementation

uses
  Prism.Menu.Items;


{ TPrismMenuItemGroup }

constructor TPrismMenuItemGroup.Create(AOwner: TObject; APrismMenu: IPrismMenu);
begin
 inherited;

 APrismMenu.MenuGroups.Add(self);
end;

destructor TPrismMenuItemGroup.Destroy;
begin
 inherited;
end;

function TPrismMenuItemGroup.GetGroupIndex: Integer;
begin
 Result:= FGroupIndex;
end;

function TPrismMenuItemGroup.IsGroup: Boolean;
begin
 Result:=  true;
end;

procedure TPrismMenuItemGroup.SetGroupIndex(const Value: Integer);
begin
 FGroupIndex:= Value;
end;

end.