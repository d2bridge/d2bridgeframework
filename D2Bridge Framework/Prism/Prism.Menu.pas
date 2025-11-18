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

unit Prism.Menu;

interface

uses
  Classes, SysUtils, D2Bridge.JSON,
  D2Bridge.Image.Interfaces, Prism.Forms.Controls, Prism.Interfaces, Prism.Types,
  Generics.Collections, System.UITypes;


type
 TPrismMenu = class(TPrismControl, IPrismMenu)
  private
   FTitle: String;
   FMenuItems: IPrismMenuItems;
   FImage: ID2BridgeImage;
   FGroups: TList<IPrismMenuItemGroup>;
   FMenuItemLinkClick: TOnEventProc;
   FDark: Boolean;
   FColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF}; //Dark:#212529  Light:#fff
   FTitleColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF}; //Dark:#FFFFFF  Light:#000000e6
   FMenuTextColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF}; //Dark:#ffffffbf  Light:#0000008c
{$IFDEF FPC}
  protected
{$ENDIF}
   function GetTitle: string;
   procedure SetTitle(Value: String);
   function GetMenuGroup(Index: Integer): IPrismMenuItemGroup;
   function GetColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
   function GetTitleColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
   procedure SetColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
   procedure SetTitleColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
   function GetMenuTextColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
   procedure SetMenuTextColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
  protected
   procedure MenuItemLinkClick(EventParams: TStrings);
   function GetDark: boolean; virtual;
   procedure SetDark(const Value: boolean); virtual;
  public
   FMenuItemList: TList<IPrismMenuItem>;
   constructor Create(AOwner: TObject); override;
   destructor Destroy; override;

   function MenuItems: IPrismMenuItems;
   function MenuItemFromVCLComponent(AMenuItemComponent: TObject): IPrismMenuItem; overload;
   function MenuItemFromName(AName: String): IPrismMenuItem; overload;
   function MenuItemFromCaption(AText: String): IPrismMenuItem;
   function MenuGroups: TList<IPrismMenuItemGroup>;
   function Image: ID2BridgeImage;

   property Title: String read GetTitle write SetTitle;
   property MenuGroup[Index: Integer]: IPrismMenuItemGroup read GetMenuGroup;
   property Dark: boolean read GetDark write SetDark;
   property Color: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF} read GetColor write SetColor;
   property TitleColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF} read GetTitleColor write SetTitleColor;
   property MenuTextColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF} read GetMenuTextColor write SetMenuTextColor;
  published
   property OnMenuItemLinkClick: TOnEventProc read FMenuItemLinkClick write FMenuItemLinkClick;
 end;

const
 DefaulDarkColor = '#212529';
 DefaulLightColor = '#FFFFFF';
 DefaultDarkTitleColor = '#FFFFFF';
 DefaultLightTitleColor = '#000000E6';
 DefaultDarkMenuTextColor = '#ffffffbf';
 DefaultLightMenuTextColor = '#0000008c';


implementation

uses
  Prism.Util, D2Bridge.Util,
  Prism.Menu.Items, Prism.Menu.Group,
  D2Bridge.Image, Prism.Events;

{ TPrismMenu }

constructor TPrismMenu.Create(AOwner: TObject);
var
 vEventMenuLinkClick: TPrismControlEvent;
begin
 inherited;

 Dark:= true;

 FMenuItems:= TPrismMenuItems.Create(self, self);
 FMenuItemList:= TList<IPrismMenuItem>.Create;
 FGroups:= TList<IPrismMenuItemGroup>.Create;
 FImage:= TD2BridgeImage.Create;

 vEventMenuLinkClick:= TPrismControlEvent.Create(self, EventOnSelect);
 vEventMenuLinkClick.SetOnEvent(MenuItemLinkClick);
 Events.Add(vEventMenuLinkClick);
end;

destructor TPrismMenu.Destroy;
var
 vMenuItems: TPrismMenuItems;
 vImage: TD2BridgeImage;
 vItemGroupIntf: IPrismMenuItemGroup;
 vItemGroup: TPrismMenuItemGroup;
begin
 FMenuItemList.Free;

 vMenuItems:= FMenuItems as TPrismMenuItems;
 FMenuItems:= nil;
 vMenuItems.Free;

 vImage:= FImage as TD2BridgeImage;
 FImage:= nil;
 vImage.Free;

 while FGroups.Count > 0 do
 begin
  vItemGroupIntf:= FGroups.Last;
  FGroups.Delete(Pred(FGroups.Count));

  try
   vItemGroup:= vItemGroupIntf as TPrismMenuItemGroup;
   vItemGroupIntf:= nil;
   vItemGroup.Free;
  except
  end;
 end;
 FGroups.Free;

 inherited;
end;

function TPrismMenu.GetColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
begin
 Result:= FColor;
end;

function TPrismMenu.GetDark: boolean;
begin
 Result:= FDark;
end;

function TPrismMenu.GetMenuGroup(Index: Integer): IPrismMenuItemGroup;
var
 vPrismMenuItemGroup: IPrismMenuItemGroup;
begin
 for vPrismMenuItemGroup in FGroups do
  if vPrismMenuItemGroup.GroupIndex = Index then
  begin
   Result:= vPrismMenuItemGroup;
   break;
  end;
end;

function TPrismMenu.GetMenuTextColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
begin
 Result:= FMenuTextColor;
end;

function TPrismMenu.GetTitleColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
begin
 Result:= FTitleColor;
end;

function TPrismMenu.GetTitle: string;
begin
 Result:= FTitle;
end;

function TPrismMenu.Image: ID2BridgeImage;
begin
 Result:= FImage;
end;

function TPrismMenu.MenuGroups: TList<IPrismMenuItemGroup>;
begin
 Result:= FGroups;
end;

function TPrismMenu.MenuItemFromCaption(AText: String): IPrismMenuItem;
var
 vMenuItem: IPrismMenuItem;
begin
 System.Initialize(result);

 for vMenuItem in FMenuItemList do
  if SameText(vMenuItem.Caption, AText) then
  begin
   Result:= vMenuItem;
   Break;
  end;
end;

function TPrismMenu.MenuItemFromName(AName: String): IPrismMenuItem;
var
 vMenuItem: IPrismMenuItem;
begin
 System.Initialize(result);

 for vMenuItem in FMenuItemList do
  if SameText(vMenuItem.Name, AName) then
  begin
   Result:= vMenuItem;
   Break;
  end;
end;

function TPrismMenu.MenuItemFromVCLComponent(AMenuItemComponent: TObject): IPrismMenuItem;
begin
 System.Initialize(result);

 if AMenuItemComponent is TComponent then
  result:= MenuItemFromName(TComponent(AMenuItemComponent).Name);
end;

procedure TPrismMenu.MenuItemLinkClick(EventParams: TStrings);
var
 vEvent: TStrings;
 vMenuItemName: String;
 vMenuItem: IPrismMenuItem;
begin
 try
  vMenuItemName:= EventParams[0];

  if vMenuItemName <> '' then
   for vMenuItem in FMenuItemList do
    if Assigned(vMenuItem) then
     if vMenuItem.IsLink then
      if SameText(vMenuItemName, vMenuItem.Name) then
      begin
       if vMenuItem.Visible and vMenuItem.Enabled then
        if Assigned(vMenuItem.VCLComponent) then
        begin
         if Assigned(OnMenuItemLinkClick) then
         begin
          vEvent:= TStringList.Create;
          vEvent.AddObject(vMenuItem.Name, vMenuItem.VCLComponent);
          OnMenuItemLinkClick(vEvent);
          vEvent.Free;
         end;
        end;
       Break;
      end;
 except
 end;
end;

function TPrismMenu.MenuItems: IPrismMenuItems;
begin
 Result:= FMenuItems;
end;

procedure TPrismMenu.SetColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
begin
 FColor:= Value;
end;

procedure TPrismMenu.SetDark(const Value: boolean);
begin
 FDark:= Value;

 if Value then
 begin
  FColor:= HexToTColor(DefaulDarkColor);
  FTitleColor:= HexToTColor(DefaultDarkTitleColor);
  FMenuTextColor:= HexToTColor(DefaultDarkMenuTextColor);
 end else
 begin
  FColor:= HexToTColor(DefaulLightColor);
  FTitleColor:= HexToTColor(DefaultLightTitleColor);
  FMenuTextColor:= HexToTColor(DefaultLightMenuTextColor);
 end;
end;

procedure TPrismMenu.SetMenuTextColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
begin
 FMenuTextColor:= Value;
end;

procedure TPrismMenu.SetTitleColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
begin
 FTitleColor:= Value;
end;

//function TPrismMenu.IsLabel: Boolean;
//begin
// Result:= true;
//end;

procedure TPrismMenu.SetTitle(Value: String);
begin
 FTitle:= Value;
end;

end.
