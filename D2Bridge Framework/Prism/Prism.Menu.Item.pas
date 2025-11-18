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

unit Prism.Menu.Item;

interface

uses
  Classes,
  Prism.Interfaces;

type
 TPrismMenuItem = class(TInterfacedPersistent, IPrismMenuItem)
  private
   FMenuItemGroup: IPrismMenuItemGroup;
   FVCLComponent: TComponent;
   FVisible: Boolean;
   FEnabled: Boolean;
   FIcon: string;
   FCSSClass: string;
   FHTMLExtras: string;
   FHTMLStyle: string;
   FCaption: string;
   FName: string;
   FOwner: TObject;
{$IFDEF FPC}
  protected
{$ENDIF}
   function GetName: String;
   procedure SetName(const Value: String);
   function GetCaption: String;
   procedure SetCaption(const Value: String);
   function GetCSSClass: string;
   procedure SetCSSClass(Value: string);
   function GetHTMLExtras: string;
   procedure SetHTMLExtras(Value: string);
   function GetHTMLStyle: string;
   procedure SetHTMLStyle(Value: string);
   function GetIcon: String;
   procedure SetIcon(const Value: String);
   procedure SetEnabled(AEnabled: Boolean);
   function GetEnabled: Boolean;
   procedure SetVisible(AVisible: Boolean);
   function GetVisible: Boolean;
   function GetMenuItemGroup: IPrismMenuItemGroup;
   procedure SetMenuItemGroup(const Value: IPrismMenuItemGroup);
   function GetGroupIndex: Integer;
   procedure SetGroupIndex(const Value: Integer);
   procedure SetVCLComponent(Value: TComponent);
   function GetVCLComponent: TComponent;
   function GetOwner: TObject;
  protected
   FLevel: Integer;
   FPrismMenu: IPrismMenu;
  public
   constructor Create(AOwner: TObject; APrismMenu: IPrismMenu); virtual;

   function IsLink: Boolean; virtual;
   function IsGroup: Boolean; virtual;
   function IsSubMenu: Boolean; virtual;

   function Level: Integer;

   property Name: String read GetName write SetName;
   property Caption: String read GetCaption write SetCaption;
   property Icon: String read GetIcon write SetIcon;
   property CSSClasses: string read GetCSSClass write SetCSSClass;
   property HTMLExtras: string read GetHTMLExtras write SetHTMLExtras;
   property HTMLStyle: string read GetHTMLStyle write SetHTMLStyle;
   property Enabled: Boolean read GetEnabled write SetEnabled;
   property Visible: Boolean read GetVisible write SetVisible;
   property MenuItemGroup: IPrismMenuItemGroup read GetMenuItemGroup write SetMenuItemGroup;
   property GroupIndex: Integer read GetGroupIndex write SetGroupIndex;
   property VCLComponent: TComponent read GetVCLComponent write SetVCLComponent;
   property Owner: TObject read GetOwner;
 end;

implementation

uses
  Prism.Menu.Group, Prism.Menu.Items, Prism.Menu.SubMenu;


{ TPrismMenuItem }

constructor TPrismMenuItem.Create(AOwner: TObject; APrismMenu: IPrismMenu);
begin
 FPrismMenu:= APrismMenu;
 FOwner:= AOwner;
 FVisible:= true;
 FEnabled:= true;
 FLevel:= 1;

 if AOwner is TPrismMenuItems then
 begin
  FLevel:= TPrismMenuItems(AOwner).Level + 1;
 end else
 if AOwner is TPrismMenuItemSubMenu then
 begin
  FLevel:= TPrismMenuItemSubMenu(AOwner).Level + 1;
 end;
end;

function TPrismMenuItem.GetCaption: String;
begin
 Result:= FCaption;
end;

function TPrismMenuItem.GetCSSClass: string;
begin
 Result:= FCSSClass;
end;

function TPrismMenuItem.GetEnabled: Boolean;
begin
 Result:= FEnabled;
end;

function TPrismMenuItem.GetGroupIndex: Integer;
begin
 if Assigned(FMenuItemGroup) then
  Result:= FMenuItemGroup.GroupIndex
 else
  Result:= -1;
end;

function TPrismMenuItem.GetHTMLExtras: string;
begin
 Result:= FHTMLExtras;
end;

function TPrismMenuItem.GetHTMLStyle: string;
begin
 Result:= FHTMLStyle;
end;

function TPrismMenuItem.GetIcon: String;
begin
 Result:= FIcon;
end;

function TPrismMenuItem.GetMenuItemGroup: IPrismMenuItemGroup;
begin
 Result:= FMenuItemGroup;
end;

function TPrismMenuItem.GetName: String;
begin
 Result:= FName;
end;

function TPrismMenuItem.GetOwner: TObject;
begin
 Result:= FOwner;
end;

function TPrismMenuItem.GetVCLComponent: TComponent;
begin
 Result:= FVCLComponent;
end;

function TPrismMenuItem.GetVisible: Boolean;
begin
 Result:= FVisible;
end;

function TPrismMenuItem.IsGroup: Boolean;
begin
 Result:= false;
end;

function TPrismMenuItem.IsLink: Boolean;
begin
 Result:= false;
end;

function TPrismMenuItem.IsSubMenu: Boolean;
begin
 Result:= false;
end;

function TPrismMenuItem.Level: Integer;
begin
 Result:= FLevel;
end;

procedure TPrismMenuItem.SetCaption(const Value: String);
begin
 FCaption:= Value;
end;

procedure TPrismMenuItem.SetCSSClass(Value: string);
begin
 FCSSClass:= Value;
end;

procedure TPrismMenuItem.SetEnabled(AEnabled: Boolean);
begin
 FEnabled:= AEnabled;
end;

procedure TPrismMenuItem.SetGroupIndex(const Value: Integer);
var
 vMenuGroup: IPrismMenuItemGroup;
 vExists: Boolean;
begin
 vExists:= false;

 for vMenuGroup in FPrismMenu.MenuGroups do
 begin
  if vMenuGroup.GroupIndex = Value then
  begin
   vExists:= true;
   FMenuItemGroup:= vMenuGroup;
  end;
 end;

 if Not vExists then
 begin
  vMenuGroup:= TPrismMenuItemGroup.Create(Owner, FPrismMenu);
  vMenuGroup.GroupIndex:= Value;
  FMenuItemGroup:= vMenuGroup;
 end;
end;

procedure TPrismMenuItem.SetHTMLExtras(Value: string);
begin
 FHTMLExtras:= Value;
end;

procedure TPrismMenuItem.SetHTMLStyle(Value: string);
begin
 FHTMLStyle:= Value;
end;

procedure TPrismMenuItem.SetIcon(const Value: String);
begin
 FIcon:= Value;
end;

procedure TPrismMenuItem.SetMenuItemGroup(const Value: IPrismMenuItemGroup);
begin
 FMenuItemGroup:= Value;
end;

procedure TPrismMenuItem.SetName(const Value: String);
begin
 FName:= Value;
end;

procedure TPrismMenuItem.SetVCLComponent(Value: TComponent);
begin
 FVCLComponent:= Value;
end;

procedure TPrismMenuItem.SetVisible(AVisible: Boolean);
begin
 FVisible:= AVisible;
end;

end.
