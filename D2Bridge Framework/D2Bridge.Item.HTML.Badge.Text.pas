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

unit D2Bridge.Item.HTML.Badge.Text;

interface

uses
  Classes, SysUtils, Generics.Collections,
  Prism.Interfaces,
  D2Bridge.Item, D2Bridge.BaseClass, D2Bridge.Item.VCLObj, D2Bridge.Interfaces,
  D2Bridge.Item.HTML.Badge, D2Bridge.Forms
  {$IFDEF FMX}

  {$ELSE}

  {$ENDIF}
  ;


type
  TD2BridgeItemHTMLBadgeText = class(TD2BridgeItemHTMLBadge, ID2BridgeItemHTMLBadgeText)
    //events
    procedure BeginReader; virtual;
    procedure EndReader; virtual;
   private
    FItemLabel: ID2BridgeItemVCLObj;
    FPill: boolean;
    function GetPill: boolean;
    procedure SetPill(const Value: boolean);
   public
    constructor Create(AOwner: TD2BridgeClass); override;
    destructor Destroy; override;

    procedure PreProcess; override;
    procedure Render; override;
    procedure RenderHTML; override;

    property Pill: boolean read GetPill write SetPill;
  end;



implementation

uses
  Prism.Forms.Controls, D2Bridge.Util, Prism.Forms,
  Prism.Badge,
  D2Bridge.Item.VCLObj.Style, D2Bridge.HTML.CSS;


{ TD2BridgeItemHTMLBadgeText }

procedure TD2BridgeItemHTMLBadgeText.BeginReader;
begin

end;

constructor TD2BridgeItemHTMLBadgeText.Create(AOwner: TD2BridgeClass);
begin
 Inherited Create(AOwner);

 FPrismControl:= TPrismBadge.Create(FD2BridgeItem.BaseClass.PrismSession);
 FPrismControl.Name:= ITemID;
 AOwner.PrismControlToRegister.Add(FPrismControl);

 FItemLabel:= nil;
 FPill:= false;
end;

destructor TD2BridgeItemHTMLBadgeText.Destroy;
var
 vItemLabel: TD2BridgeItemVCLObj;
 vPrismControl: TPrismControl;
begin
 if Assigned(FItemLabel) then
 begin
  vItemLabel:= FItemLabel as TD2BridgeItemVCLObj;
  FItemLabel:= nil;
  vItemLabel.Free;
 end;

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

 //FreeAndNil(FD2BridgeItems);

 inherited;
end;

procedure TD2BridgeItemHTMLBadgeText.EndReader;
begin

end;

function TD2BridgeItemHTMLBadgeText.GetPill: boolean;
begin
 Result := FPill;
end;

procedure TD2BridgeItemHTMLBadgeText.PreProcess;
begin
  inherited;

end;


procedure TD2BridgeItemHTMLBadgeText.Render;
var
 vD2BridgeItems : TList<ID2BridgeItem>;
begin
 inherited;

 if Assigned(PrismBadge.LabelHTMLElement) then
 begin
  if FItemLabel = nil then
  begin
   FItemLabel := TD2BridgeItemVCLObj.Create(BaseClass);
   FItemLabel.Item:= PrismBadge.LabelHTMLElement;
   if FPill then
    FItemLabel.CSSClasses:= Trim('d2bridgelabelbadge badge rounded-pill ' + CSSClasses)
   else
    FItemLabel.CSSClasses:= Trim('d2bridgelabelbadge badge ' + CSSClasses);
   FItemLabel.HTMLExtras:= HTMLExtras;
   FItemLabel.HTMLStyle:= HTMLStyle;

   if pos(UpperCase('bg-'), UpperCase(FItemLabel.CSSClasses)) <= 0 then
    FItemLabel.CSSClasses:= Trim(FItemLabel.CSSClasses + ' ' + 'bg-auto')
   else
   begin
    if (pos(UpperCase('bg-primary'), UpperCase(FItemLabel.CSSClasses)) > 0) or
       (pos(UpperCase('bg-secondary'), UpperCase(FItemLabel.CSSClasses)) > 0) or
       (pos(UpperCase('bg-success'), UpperCase(FItemLabel.CSSClasses)) > 0) or
       (pos(UpperCase('bg-danger'), UpperCase(FItemLabel.CSSClasses)) > 0) or
       (pos(UpperCase('bg-dark'), UpperCase(FItemLabel.CSSClasses)) > 0) then
    begin
     FItemLabel.CSSClasses:= Trim(FItemLabel.CSSClasses + ' ' + 'text-light')
    end else
     FItemLabel.CSSClasses:= Trim(FItemLabel.CSSClasses + ' ' + 'text-dark');
   end;
  end;

  vD2BridgeItems:= TList<ID2BridgeItem>.Create;

  try
   vD2BridgeItems.Add(FItemLabel);

   BaseClass.RenderD2Bridge(vD2BridgeItems);
  finally
   vD2BridgeItems.Free;
  end;
 end;
end;

procedure TD2BridgeItemHTMLBadgeText.RenderHTML;
begin
  inherited;

end;

procedure TD2BridgeItemHTMLBadgeText.SetPill(const Value: boolean);
begin
 FPill := Value;
end;

end.