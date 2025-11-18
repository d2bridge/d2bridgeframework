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

unit D2Bridge.Prism.Button;

interface

uses
  Classes,
{$IFDEF FMX}
{$ELSE}
  StdCtrls, Controls,
{$ENDIF}
  D2Bridge.Interfaces, D2Bridge.Prism, D2Bridge.Prism.Item;



type
 PrismButton = class(TD2BridgePrismItem, ID2BridgeFrameworkItemButton)
  private
   FProcGetCaption: TOnGetValue;
   FCSSButtonIcon: string;
   function GetOnGetCaption: TOnGetValue;
   procedure SetOnGetCaption(const Value: TOnGetValue);
   function GetCSSButtonIcon: string;
   procedure SetCSSButtonIcon(const Value: string);
  public
   procedure Clear; override;
   function FrameworkClass: TClass; override;
   procedure ProcessPropertyClass(VCLObj, NewObj: TObject); override;
   procedure ProcessEventClass(VCLObj, NewObj: TObject); override;
   procedure ProcessPropertyByName(VCLObj, NewObj: TObject; PropertyName: string; PropertyValue: Variant); override;

   property OnGetCaption: TOnGetValue read GetOnGetCaption write SetOnGetCaption;
   property CSSButtonIcon: string read GetCSSButtonIcon write SetCSSButtonIcon;
  end;


implementation

uses
  SysUtils, Prism.Button;

{ PrismButton }

procedure PrismButton.Clear;
begin
 inherited;

 FProcGetCaption:= nil;
 FCSSButtonIcon:= '';
end;

function PrismButton.FrameworkClass: TClass;
begin
 inherited;

 Result:= TPrismButton;
end;

function PrismButton.GetCSSButtonIcon: string;
begin
 result:= FCSSButtonIcon;
end;

function PrismButton.GetOnGetCaption: TOnGetValue;
begin
 result:= FProcGetCaption;
end;

procedure PrismButton.ProcessEventClass(VCLObj, NewObj: TObject);
begin
 inherited;

end;

procedure PrismButton.ProcessPropertyByName(VCLObj, NewObj: TObject;
  PropertyName: string; PropertyValue: Variant);
begin
 inherited;
end;

procedure PrismButton.ProcessPropertyClass(VCLObj, NewObj: TObject);
begin
 inherited;

 TPrismButton(NewObj).CSSButtonIcon:= FCSSButtonIcon;

 if Assigned(FProcGetCaption) then
  TPrismButton(NewObj).ProcGetCaption:= FProcGetCaption;
end;

procedure PrismButton.SetCSSButtonIcon(const Value: string);
begin
 FCSSButtonIcon:= Value;
end;

procedure PrismButton.SetOnGetCaption(const Value: TOnGetValue);
begin
 FProcGetCaption:= Value;
end;

{ TD2BridgeProxyButton }



end.