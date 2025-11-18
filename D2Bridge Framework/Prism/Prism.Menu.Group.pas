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
