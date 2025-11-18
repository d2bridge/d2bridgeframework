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
