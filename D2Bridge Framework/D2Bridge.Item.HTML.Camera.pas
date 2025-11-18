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

unit D2Bridge.Item.HTML.Camera;

interface

uses
  Classes, SysUtils, Generics.Collections,
  Prism.Interfaces,
  D2Bridge.Item, D2Bridge.BaseClass, D2Bridge.Item.VCLObj,
{$IFnDEF FPC}
  {$IFnDEF FMX}
  ExtCtrls,
  {$ELSE}
  FMX.ExtCtrls, FMX.Objects,
  {$ENDIF}
{$ELSE}
  ExtCtrls,
{$ENDIF}
{$IFDEF FMX}

{$ELSE}

{$ENDIF}
  D2Bridge.Interfaces;


type
  TD2BridgeItemHTMLCamera = class(TD2BridgeItem, ID2BridgeItemHTMLCamera)
   //events
   procedure BeginReader;
   procedure EndReader;
  private
   FD2BridgeItem: TD2BridgeItem;
  public
   constructor Create(AOwner: TD2BridgeClass); override;
   destructor Destroy; override;

   function PrismCamera: IPrismCamera;

   procedure PreProcess; override;
   procedure Render; override;
   procedure RenderHTML; override;
  end;

implementation

uses
  Prism.Camera, Prism.Forms,
  D2Bridge.Util, D2Bridge.Camera.Image, D2Bridge.Forms, D2Bridge.Forms.Helper;

{ TD2BridgeItemHTMLCamera }

constructor TD2BridgeItemHTMLCamera.Create(AOwner: TD2BridgeClass);
begin
 FD2BridgeItem:= Inherited Create(AOwner);

 FPrismControl := TPrismCamera.Create(nil);
 FPrismControl.Name:= ITemID;

 FD2BridgeItem.OnBeginReader:= BeginReader;
 FD2BridgeItem.OnEndReader:= EndReader;

end;

destructor TD2BridgeItemHTMLCamera.Destroy;
var
 vPrismControl: TPrismControl;
begin
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


procedure TD2BridgeItemHTMLCamera.BeginReader;
var
 vD2BridgeForm: TD2BridgeForm;
begin
 (BaseClass.Form as TPrismForm).AddControl(FPrismControl);

 if not Renderized then
 begin
  TImage(FPrismControl.VCLComponent).Camera.PrismControl:= FPrismControl;

  vD2BridgeForm:= (BaseClass.Form as TPrismForm).D2BridgeForm;

  TD2BridgeFormComponentHelper(TImage(FPrismControl.VCLComponent).Tag).D2BridgeFormComponentHelperItems:=
   vD2BridgeForm.D2BridgeFormComponentHelperItems;
 end;
end;

procedure TD2BridgeItemHTMLCamera.EndReader;
begin

end;

procedure TD2BridgeItemHTMLCamera.PreProcess;
begin

end;

function TD2BridgeItemHTMLCamera.PrismCamera: IPrismCamera;
begin
 result:= GetPrismControl as IPrismCamera;
end;

procedure TD2BridgeItemHTMLCamera.Render;
begin
 BaseClass.HTML.Render.Body.Add('{%'+TrataHTMLTag(ItemPrefixID+' class="d2bridgecamera '+Trim(CSSClasses)+'" style="'+GetHTMLStyle+'"')+'%}');
end;

procedure TD2BridgeItemHTMLCamera.RenderHTML;
begin

end;


end.
