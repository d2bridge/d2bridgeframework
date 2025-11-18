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

unit D2Bridge.Item.HTML.PanelGroup;

interface

uses
  Classes, SysUtils, Generics.Collections,
  Prism.Interfaces,
  D2Bridge.Item, D2Bridge.BaseClass, D2Bridge.HTML.CSS, D2Bridge.Item.VCLObj, D2Bridge.Interfaces,
  D2Bridge.ItemCommon;

type
  TD2BridgeItemHTMLPanelGroup = class(TD2BridgeItem, ID2BridgeItemHTMLPanelGroup)
    //events
    procedure BeginReader;
    procedure EndReader;
  private
   FD2BridgeItem: TD2BridgeItem;
   FD2BridgeItems : TD2BridgeItems;
   FColSize: string;
   FTitle: String;
   FInLine: Boolean;
   procedure SetColSize(AColSize: string);
   function GetColSize: string;
   function GetTitle: string;
   procedure SetTitle(ATitle: string);
   function GetInLine: Boolean;
   procedure SetInLine(Value: Boolean);
  public
   constructor Create(AOwner: TD2BridgeClass); override;
   destructor Destroy; override;

   procedure PreProcess; override;
   procedure Render; override;
   procedure RenderHTML; override;

   Function Items: ID2BridgeAddItems;

   property BaseClass;
   property ColSize: string read GetColSize write SetColSize;
   property HTMLInLine: Boolean read GetInLine write SetInLine default false;
   property Title: string read GetTitle write SetTitle;
  end;

implementation

uses
  Prism.Forms.Controls,
  D2Bridge.Render, Prism.ControlGeneric;

{ TD2BridgeItemHTMLPanelGroup }


procedure TD2BridgeItemHTMLPanelGroup.BeginReader;
begin
 with BaseClass.HTML.Render.Body do
 begin
  Add('<div class="'+ColSize+' pt-2">');
  Add('<div class="expanel '+CSSClasses+'" style="'+HTMLStyle+'" '+HTMLExtras+' id="' + ItemID + '">');
  Add('<div class="expanel-heading">');
  Add('<h3 class="expanel-title">'+Title+'</h3>');
  Add('</div>');
  add('<div class="expanel-body">');
 end;
end;

constructor TD2BridgeItemHTMLPanelGroup.Create(AOwner: TD2BridgeClass);
begin
 FD2BridgeItem:= Inherited Create(AOwner);

 FD2BridgeItems:= TD2BridgeItems.Create(BaseClass);

 FColSize:= 'col-xl-auto';
 CSSClasses:= BaseClass.CSSClass.PanelColor.default;

 FD2BridgeItem.OnBeginReader:= BeginReader;
 FD2BridgeItem.OnEndReader:= EndReader;

 FPrismControl:= TPrismControlGeneric.Create(nil);
end;

destructor TD2BridgeItemHTMLPanelGroup.Destroy;
var
 vPrismControl: TPrismControl;
begin
 FD2BridgeItems.Free;

 try
  if Assigned(FPrismControl) then
   if not Assigned(FPrismControl.Form) then
   begin
    vPrismControl:= (FPrismControl as TPrismControl);
    FPrismControl:= nil;
    vPrismControl.Free;
   end;
 except
 end;

 inherited;
end;

procedure TD2BridgeItemHTMLPanelGroup.EndReader;
begin
 with BaseClass.HTML.Render.Body do
 begin
  add('</div>');
  add('</div>');
  add('</div>');
 end;
end;

function TD2BridgeItemHTMLPanelGroup.GetColSize: string;
begin
 Result:= FColSize;
end;

function TD2BridgeItemHTMLPanelGroup.GetInLine: Boolean;
begin
 Result:= FInLine;
end;

function TD2BridgeItemHTMLPanelGroup.GetTitle: string;
begin
 Result:= FTitle;
end;


function TD2BridgeItemHTMLPanelGroup.Items: ID2BridgeAddItems;
begin
 Result:= FD2BridgeItems;
end;

procedure TD2BridgeItemHTMLPanelGroup.PreProcess;
begin

end;

procedure TD2BridgeItemHTMLPanelGroup.Render;
begin
 if Items.Items.Count > 0 then
 begin
  BaseClass.RenderD2Bridge(Items.Items);
 end;
end;

procedure TD2BridgeItemHTMLPanelGroup.RenderHTML;
begin

end;

procedure TD2BridgeItemHTMLPanelGroup.SetColSize(AColSize: string);
begin
 FColSize:= AColSize;
end;

procedure TD2BridgeItemHTMLPanelGroup.SetInLine(Value: Boolean);
begin
 FInLine:= Value;
end;

procedure TD2BridgeItemHTMLPanelGroup.SetTitle(ATitle: string);
begin
 FTitle:= ATitle;
end;

end.
