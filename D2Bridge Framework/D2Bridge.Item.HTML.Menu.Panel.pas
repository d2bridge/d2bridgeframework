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

unit D2Bridge.Item.HTML.Menu.Panel;

interface

uses
  Classes, SysUtils, Generics.Collections,
  Prism.Interfaces,
  D2Bridge.Item, D2Bridge.ItemCommon, D2Bridge.BaseClass, D2Bridge.Item.VCLObj,
  D2Bridge.Interfaces, System.UITypes;

type
  TD2BridgeItemMenuPanel = class(TD2BridgeHTMLTag, ID2BridgeItemHTMLMenuPanel)
  private
   FD2BridgeItemHTMLMenu: TObject;
   FD2BridgeItems: TD2BridgeItems;
   function GetColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
   procedure SetColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
  public
   constructor Create(AOwner: TObject);
   destructor Destroy; override;

   Function Items: ID2BridgeAddItems;

   property Color: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF} read GetColor write SetColor;
  end;

implementation

uses
  D2Bridge.Item.HTML.MainMenu;

{ TD2BridgeItemMenuPanel }

constructor TD2BridgeItemMenuPanel.Create(AOwner: TObject);
begin
 inherited Create;

 FD2BridgeItemHTMLMenu:= AOwner;

 if AOwner is TD2BridgeItemHTMLMainMenu then
  FD2BridgeItems:= TD2BridgeItems.Create((AOwner as TD2BridgeItemHTMLMainMenu).BaseClass);
end;

destructor TD2BridgeItemMenuPanel.Destroy;
begin
 FreeAndNil(FD2BridgeItems);

 inherited;
end;

function TD2BridgeItemMenuPanel.GetColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
begin
 if FD2BridgeItemHTMLMenu is TD2BridgeItemHTMLMainMenu then
  Result:= (FD2BridgeItemHTMLMenu as TD2BridgeItemHTMLMainMenu).Options.PanelTop.Color;
end;

function TD2BridgeItemMenuPanel.Items: ID2BridgeAddItems;
begin
 Result:= FD2BridgeItems;
end;

procedure TD2BridgeItemMenuPanel.SetColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
begin
 if FD2BridgeItemHTMLMenu is TD2BridgeItemHTMLMainMenu then
  (FD2BridgeItemHTMLMenu as TD2BridgeItemHTMLMainMenu).Options.PanelTop.Color:= Value;
end;

end.

