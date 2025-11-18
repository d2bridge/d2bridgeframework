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

unit D2Bridge.Item.HTML.Badge.Button;

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
  TD2BridgeItemHTMLBadgeButton = class(TD2BridgeItemHTMLBadge, ID2BridgeItemHTMLBadgeButton)
    //events
    procedure BeginReader; virtual;
    procedure EndReader; virtual;
   private
    FIndicator: Boolean;
    FItemButton: ID2BridgeItemVCLObj;
    FItemLabel: ID2BridgeItemVCLObj;
    FTopPosition: boolean;
    FLabelStyles: ID2BridgeHTMLTag;
    function GetIndicator: Boolean;
    function GetTopPosition: boolean;
    procedure SetIndicator(const Value: Boolean);
    procedure SetTopPosition(const Value: boolean);
   public
    constructor Create(AOwner: TD2BridgeClass); override;
    destructor Destroy; override;

    function LabelStyles: ID2BridgeHTMLTag;

    procedure PreProcess; override;
    procedure Render; override;
    procedure RenderHTML; override;

    property Indicator: Boolean read GetIndicator write SetIndicator;
    property TopPosition: boolean read GetTopPosition write SetTopPosition;
  end;

implementation

uses
  Prism.Forms.Controls, D2Bridge.Util, Prism.Forms,
  Prism.Badge,
  D2Bridge.Item.VCLObj.Style, D2Bridge.HTML.CSS;

{ TD2BridgeItemHTMLBadgeButton }

procedure TD2BridgeItemHTMLBadgeButton.BeginReader;
begin
end;

constructor TD2BridgeItemHTMLBadgeButton.Create(AOwner: TD2BridgeClass);
begin
 Inherited Create(AOwner);

 FPrismControl:= TPrismBadge.Create(FD2BridgeItem.BaseClass.PrismSession);
 FPrismControl.Name:= ITemID;
 AOwner.PrismControlToRegister.Add(FPrismControl);

 FLabelStyles:= TD2BridgeHTMLTag.Create;

 FItemButton:= nil;
 FItemLabel:= nil;
 FTopPosition:= false;
 FIndicator:= false;
end;

destructor TD2BridgeItemHTMLBadgeButton.Destroy;
var
 vItemLabel, vItemButton: TD2BridgeItemVCLObj;
 vLabelStyles: TD2BridgeHTMLTag;
 vPrismControl: TPrismControl;
begin
 if Assigned(FItemLabel) then
 begin
  vItemLabel:= FItemLabel as TD2BridgeItemVCLObj;
  FItemLabel:= nil;
  vItemLabel.Free;
 end;

 if Assigned(FItemButton) then
 begin
  vItemButton:= FItemButton as TD2BridgeItemVCLObj;
  FItemButton:= nil;
  vItemButton.Free;
 end;

 if Assigned(FLabelStyles) then
 begin
  vLabelStyles:= FLabelStyles as TD2BridgeHTMLTag;
  FLabelStyles:= nil;
  vLabelStyles.Free;
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


 inherited;
end;

procedure TD2BridgeItemHTMLBadgeButton.EndReader;
begin

end;

function TD2BridgeItemHTMLBadgeButton.GetIndicator: Boolean;
begin
 Result := FIndicator;
end;

function TD2BridgeItemHTMLBadgeButton.GetTopPosition: boolean;
begin
 result:= FTopPosition;
end;

function TD2BridgeItemHTMLBadgeButton.LabelStyles: ID2BridgeHTMLTag;
begin
 result:= FLabelStyles;
end;

procedure TD2BridgeItemHTMLBadgeButton.PreProcess;
begin
 inherited;

end;

procedure TD2BridgeItemHTMLBadgeButton.Render;
begin
 inherited;

 if Assigned(PrismBadge.LabelHTMLElement) then
 begin
  if FItemLabel = nil then
  begin
   FItemLabel := TD2BridgeItemVCLObj.Create(BaseClass);
   FItemLabel.Item:= PrismBadge.LabelHTMLElement;
   if FIndicator then
    FItemLabel.CSSClasses:= Trim('d2bridgelabelbadge d2bridgelabelbuttonbadge badgeindicator position-absolute top-0 start-100 translate-middle p-2 border border-light rounded-circle ' + LabelStyles.CSSClasses)
   else
    if FTopPosition then
     FItemLabel.CSSClasses:= Trim('d2bridgelabelbadge d2bridgelabelbuttonbadge position-absolute top-0 start-100 translate-middle badge rounded-pill ' + LabelStyles.CSSClasses)
    else
     FItemLabel.CSSClasses:= Trim('d2bridgelabelbadge d2bridgelabelbuttonbadge badge ' + LabelStyles.CSSClasses);
   FItemLabel.HTMLExtras:= LabelStyles.HTMLExtras;
   FItemLabel.HTMLStyle:= LabelStyles.HTMLStyle;

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
 end;


 if Assigned(PrismBadge.ButtonHTMLElement) then
 begin
  if FItemBUtton = nil then
  begin
   FItemBUtton := TD2BridgeItemVCLObj.Create(BaseClass);
   FItemBUtton.Item:= PrismBadge.ButtonHTMLElement;
   CSSClasses:= Trim('d2bridgebuttonbadge ' + CSSClasses);
   if FIndicator then
    CSSClasses:= Trim(CSSClasses + ' me-1')
   else
    if FTopPosition then
     CSSClasses:= Trim(CSSClasses + ' me-3');
   if FTopPosition or FIndicator then
    FItemBUtton.CSSClasses:= Trim(CSSClasses + ' position-relative')
   else
    FItemBUtton.CSSClasses:= CSSClasses;
   FItemBUtton.HTMLExtras:= HTMLExtras;
   FItemBUtton.HTMLStyle:= HTMLStyle;
  end;
 end;


 if Assigned(PrismBadge.ButtonHTMLElement) then
  BaseClass.RenderD2Bridge(FItemButton);


 if Assigned(PrismBadge.LabelHTMLElement) then
 begin
  FItemBUtton.HTMLItems.Clear;
  BaseClass.RenderD2Bridge(FItemLabel, FItemBUtton.HTMLItems);
 end;
end;

procedure TD2BridgeItemHTMLBadgeButton.RenderHTML;
begin
 inherited;

end;

procedure TD2BridgeItemHTMLBadgeButton.SetIndicator(const Value: Boolean);
begin
 FIndicator := Value;
end;

procedure TD2BridgeItemHTMLBadgeButton.SetTopPosition(const Value: boolean);
begin
 FTopPosition:= Value;
end;

end.