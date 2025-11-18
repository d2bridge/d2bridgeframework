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

unit D2Bridge.Item.Default;

interface

uses
  Classes, SysUtils, Generics.Collections,
  Prism.Interfaces,
  D2Bridge.Item, D2Bridge.BaseClass, D2Bridge.Item.VCLObj, D2Bridge.Interfaces
  {$IFDEF FMX}

  {$ELSE}

  {$ENDIF}
  ;


type
  TD2BridgeItemDefault = class(TD2BridgeItem)
   //events
   procedure BeginReader;
   procedure EndReader;
  private
   FD2BridgeItem: TD2BridgeItem;
  public
   constructor Create(AOwner: TD2BridgeClass); override;
   destructor Destroy; override;

   procedure PreProcess;
   procedure Render;
   procedure RenderHTML;

   property BaseClass;
  end;

implementation

uses
  Prism.ControlGeneric, Prism.Forms;

{ TD2BridgeItemDefault }

constructor TD2BridgeItemDefault.Create(AOwner: TD2BridgeClass);
begin
 FD2BridgeItem:= Inherited Create(AOwner);

 FD2BridgeItem.OnBeginReader:= BeginReader;
 FD2BridgeItem.OnEndReader:= EndReader;

 FPrismControl:= TPrismControlGeneric.Create(nil);
end;

destructor TD2BridgeItemDefault.Destroy;
var
 vPrismControl: TPrismControlGeneric;
begin
 if Assigned(FPrismControl) then
 begin
  vPrismControl:= FPrismControl as TPrismControlGeneric;
  FPrismControl:= nil;
  vPrismControl.Free;
 end;

 inherited;
end;


procedure TD2BridgeItemDefault.BeginReader;
begin
 (BaseClass.Form as TPrismForm).AddControl(FPrismControl);
end;

procedure TD2BridgeItemDefault.EndReader;
begin

end;

procedure TD2BridgeItemDefault.PreProcess;
begin

end;

procedure TD2BridgeItemDefault.Render;
begin

end;

procedure TD2BridgeItemDefault.RenderHTML;
begin

end;


end.
