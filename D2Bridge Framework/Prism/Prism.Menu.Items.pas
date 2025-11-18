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


unit Prism.Menu.Items;

interface

uses
  Classes,
  Prism.Interfaces, Prism.Menu.Item, Generics.Collections;

type
 TPrismMenuItems = class(TInterfacedPersistent, IPrismMenuItems)
  private
   FPrismMenu: IPrismMenu;
   FMenuItems: TList<IPrismMenuItem>;
   FOwner: TObject;
   FLevel: Integer;
   function GetMenuItems: TList<IPrismMenuItem>;
   function GetOwner: TObject;
  public
   constructor Create(AOwner: TObject; APrismMenu: IPrismMenu);
   destructor Destroy; override;

   Procedure Clear;
   procedure Add(AMenuItem: IPrismMenuItem); overload;
   function AddLink: IPrismMenuItemLink;
   function AddSubMenu: IPrismMenuItemSubMenu;
   function FromName(AName: string): IPrismMenuItem;
   function FromVCLComponent(AMenuItemComponent: TObject): IPrismMenuItem;

   function PrismMenu: IPrismMenu;

   function Level: Integer;

   property Items: TList<IPrismMenuItem> read GetMenuItems;
   property Owner: TObject read GetOwner;
 end;

implementation

uses
  Prism.Menu.SubMenu,
  Prism.Menu.Link, Prism.Menu;

{ TPrismMenuItems }

procedure TPrismMenuItems.Add(AMenuItem: IPrismMenuItem);
begin
 FMenuItems.Add(AMenuItem);
 (FPrismMenu as TPrismMenu).FMenuItemList.Add(AMenuItem);
end;

function TPrismMenuItems.AddLink: IPrismMenuItemLink;
begin
 Result:= TPrismMenuItemLink.Create(Owner, FPrismMenu);
 FMenuItems.Add(Result);
 (FPrismMenu as TPrismMenu).FMenuItemList.Add(Result);
end;

function TPrismMenuItems.AddSubMenu: IPrismMenuItemSubMenu;
begin
 Result:= TPrismMenuItemSubMenu.Create(Owner, FPrismMenu);
 FMenuItems.Add(Result);
 (FPrismMenu as TPrismMenu).FMenuItemList.Add(Result);
end;

procedure TPrismMenuItems.Clear;
var
 vMenuItemIntf: IPrismMenuItem;
 vMenuItem: TPrismMenuItem;
begin
 while FMenuItems.Count > 0 do
 begin
  vMenuItemIntf:= FMenuItems.Last;
  FMenuItems.Delete(Pred(FMenuItems.Count));

  try
   vMenuItem:= vMenuItemIntf as TPrismMenuItem;
   vMenuItemIntf:= nil;
   vMenuItem.Free;
  except
  end;
 end;

 FMenuItems.Clear;
end;

constructor TPrismMenuItems.Create(AOwner: TObject; APrismMenu: IPrismMenu);
begin
 FPrismMenu:= APrismMenu;
 FOwner:= AOwner;

 if FOwner is TPrismMenu then
 begin
  FLevel:= 0;
 end else
 begin
  FLevel:= TPrismMenuItem(AOwner).Level;
 end;

 FMenuItems:= TList<IPrismMenuItem>.Create;
end;

destructor TPrismMenuItems.Destroy;
begin
 Clear;
 FMenuItems.Free;

 inherited;
end;

function TPrismMenuItems.FromVCLComponent(AMenuItemComponent: TObject): IPrismMenuItem;
begin
 result:= FPrismMenu.MenuItemFromVCLComponent(AMenuItemComponent);
end;

function TPrismMenuItems.FromName(AName: string): IPrismMenuItem;
begin
 result:= FPrismMenu.MenuItemFromName(AName);
end;

function TPrismMenuItems.GetMenuItems: TList<IPrismMenuItem>;
begin
 Result:= FMenuItems;
end;

function TPrismMenuItems.GetOwner: TObject;
begin
 Result:= FOwner;
end;

function TPrismMenuItems.Level: Integer;
begin
 Result:= FLevel;
end;

function TPrismMenuItems.PrismMenu: IPrismMenu;
begin
 Result:= FPrismMenu;
end;


end.
