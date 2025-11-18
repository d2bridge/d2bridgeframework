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

unit D2Bridge.Item.HTML.QRCodeReader;

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
  Prism.Types,
  D2Bridge.Interfaces;


type
  TD2BridgeItemHTMLQRCodeReader = class(TD2BridgeItem, ID2BridgeItemHTMLQRCodeReader)
   //events
   procedure BeginReader;
   procedure EndReader;
  private
   FD2BridgeItem: TD2BridgeItem;
   function GetTextVCLComponent: TComponent;
   procedure SetTextVCLComponent(AComponent: TComponent);
   function GetPressReturnKey: Boolean;
   procedure SetPressReturnKey(const Value: Boolean);
   function GetBorderShaders: Boolean;
   procedure SetBorderShaders(const Value: Boolean);
   procedure SetContinuousScan(const Value: Boolean);
   function GetContinuousScan: Boolean;
   function GetEnableAZTEC: boolean;
   function GetEnableCODABAR: boolean;
   function GetEnableCODE128: boolean;
   function GetEnableCODE39: boolean;
   function GetEnableCODE93: boolean;
   function GetEnableDATAMATRIX: boolean;
   function GetEnableEAN13: boolean;
   function GetEnableEAN8: boolean;
   function GetEnableITF: boolean;
   function GetEnableMAXICODE: boolean;
   function GetEnablePDF417: boolean;
   function GetEnableQRCODE: boolean;
   function GetEnableRSS14: boolean;
   function GetEnableRSSEXPANDED: boolean;
   function GetEnableUPCA: boolean;
   function GetEnableUPCE: boolean;
   function GetEnableUPCEANEXTENSION: boolean;
   procedure SetEnableAZTEC(const Value: boolean);
   procedure SetEnableCODABAR(const Value: boolean);
   procedure SetEnableCODE128(const Value: boolean);
   procedure SetEnableCODE39(const Value: boolean);
   procedure SetEnableCODE93(const Value: boolean);
   procedure SetEnableDATAMATRIX(const Value: boolean);
   procedure SetEnableEAN13(const Value: boolean);
   procedure SetEnableEAN8(const Value: boolean);
   procedure SetEnableITF(const Value: boolean);
   procedure SetEnableMAXICODE(const Value: boolean);
   procedure SetEnablePDF417(const Value: boolean);
   procedure SetEnableQRCODE(const Value: boolean);
   procedure SetEnableRSS14(const Value: boolean);
   procedure SetEnableRSSEXPANDED(const Value: boolean);
   procedure SetEnableUPCA(const Value: boolean);
   procedure SetEnableUPCE(const Value: boolean);
   procedure SetEnableUPCEANEXTENSION(const Value: boolean);
   function GetOnRead: TNotifyEventStr;
   procedure SetOnRead(const Value: TNotifyEventStr);
  public
   constructor Create(AOwner: TD2BridgeClass); override;
   destructor Destroy; override;

   function PrismQRCodeReader: IPrismQRCodeReader;

   procedure PreProcess; override;
   procedure Render; override;
   procedure RenderHTML; override;

   property TextVCLComponent: TComponent read GetTextVCLComponent write SetTextVCLComponent;

   procedure EnableAllCodesFormat;
   procedure DisableAllCodesFormat;

   property EnableQRCODE: boolean read GetEnableQRCODE write SetEnableQRCODE;
   property EnableAZTEC: boolean read GetEnableAZTEC write SetEnableAZTEC;
   property EnableCODABAR: boolean read GetEnableCODABAR write SetEnableCODABAR;
   property EnableCODE39: boolean read GetEnableCODE39 write SetEnableCODE39;
   property EnableCODE93: boolean read GetEnableCODE93 write SetEnableCODE93;
   property EnableCODE128: boolean read GetEnableCODE128 write SetEnableCODE128;
   property EnableDATAMATRIX: boolean read GetEnableDATAMATRIX write SetEnableDATAMATRIX;
   property EnableMAXICODE: boolean read GetEnableMAXICODE write SetEnableMAXICODE;
   property EnableITF: boolean read GetEnableITF write SetEnableITF;
   property EnableEAN13: boolean read GetEnableEAN13 write SetEnableEAN13;
   property EnableEAN8: boolean read GetEnableEAN8 write SetEnableEAN8;
   property EnablePDF417: boolean read GetEnablePDF417 write SetEnablePDF417;
   property EnableRSS14: boolean read GetEnableRSS14 write SetEnableRSS14;
   property EnableRSSEXPANDED: boolean read GetEnableRSSEXPANDED write SetEnableRSSEXPANDED;
   property EnableUPCA: boolean read GetEnableUPCA write SetEnableUPCA;
   property EnableUPCE: boolean read GetEnableUPCE write SetEnableUPCE;
   property EnableUPCEANEXTENSION: boolean read GetEnableUPCEANEXTENSION write SetEnableUPCEANEXTENSION;

   property PressReturnKey: Boolean read GetPressReturnKey write SetPressReturnKey;
   property BorderShaders: Boolean read GetBorderShaders write SetBorderShaders;
   property ContinuousScan: Boolean read GetContinuousScan write SetContinuousScan;

   property OnRead: TNotifyEventStr read GetOnRead write SetOnRead;
  end;

implementation

uses
  Prism.QRCodeReader, Prism.Forms,
  D2Bridge.Util, D2Bridge.QRCodeReader.Image, D2Bridge.Forms, D2Bridge.Forms.Helper;

{ TD2BridgeItemHTMLQRCodeReader }

constructor TD2BridgeItemHTMLQRCodeReader.Create(AOwner: TD2BridgeClass);
begin
 FD2BridgeItem:= Inherited Create(AOwner);

 FPrismControl := TPrismQRCodeReader.Create(nil);
 FPrismControl.Name:= ITemID;

 FD2BridgeItem.OnBeginReader:= BeginReader;
 FD2BridgeItem.OnEndReader:= EndReader;

end;

destructor TD2BridgeItemHTMLQRCodeReader.Destroy;
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


procedure TD2BridgeItemHTMLQRCodeReader.DisableAllCodesFormat;
begin
 PrismQRCodeReader.DisableAllCodesFormat;
end;

procedure TD2BridgeItemHTMLQRCodeReader.BeginReader;
var
 vD2BridgeForm: TD2BridgeForm;
begin
 (BaseClass.Form as TPrismForm).AddControl(FPrismControl);

 if not Renderized then
 begin
  TImage(FPrismControl.VCLComponent).QRCodeReader.PrismControl:= FPrismControl;

  vD2BridgeForm:= (BaseClass.Form as TPrismForm).D2BridgeForm;

  TD2BridgeFormComponentHelper(TImage(FPrismControl.VCLComponent).Tag).D2BridgeFormComponentHelperItems:=
   vD2BridgeForm.D2BridgeFormComponentHelperItems;
 end;
end;

procedure TD2BridgeItemHTMLQRCodeReader.EnableAllCodesFormat;
begin
 PrismQRCodeReader.EnableAllCodesFormat;
end;

procedure TD2BridgeItemHTMLQRCodeReader.EndReader;
begin

end;

function TD2BridgeItemHTMLQRCodeReader.GetBorderShaders: Boolean;
begin
 result:= PrismQRCodeReader.BorderShaders;
end;

function TD2BridgeItemHTMLQRCodeReader.GetContinuousScan: Boolean;
begin
 result:= PrismQRCodeReader.ContinuousScan;
end;

function TD2BridgeItemHTMLQRCodeReader.GetEnableAZTEC: boolean;
begin
 result:= PrismQRCodeReader.EnableAZTEC;
end;

function TD2BridgeItemHTMLQRCodeReader.GetEnableCODABAR: boolean;
begin
 result:= PrismQRCodeReader.EnableCODABAR;
end;

function TD2BridgeItemHTMLQRCodeReader.GetEnableCODE128: boolean;
begin
 result:= PrismQRCodeReader.EnableCODE128;
end;

function TD2BridgeItemHTMLQRCodeReader.GetEnableCODE39: boolean;
begin
 result:= PrismQRCodeReader.EnableCODE39;
end;

function TD2BridgeItemHTMLQRCodeReader.GetEnableCODE93: boolean;
begin
 result:= PrismQRCodeReader.EnableCODE93;
end;

function TD2BridgeItemHTMLQRCodeReader.GetEnableDATAMATRIX: boolean;
begin
 result:= PrismQRCodeReader.EnableDATAMATRIX;
end;

function TD2BridgeItemHTMLQRCodeReader.GetEnableEAN13: boolean;
begin
 result:= PrismQRCodeReader.EnableEAN13;
end;

function TD2BridgeItemHTMLQRCodeReader.GetEnableEAN8: boolean;
begin
 result:= PrismQRCodeReader.EnableEAN8;
end;

function TD2BridgeItemHTMLQRCodeReader.GetEnableITF: boolean;
begin
 result:= PrismQRCodeReader.EnableITF;
end;

function TD2BridgeItemHTMLQRCodeReader.GetEnableMAXICODE: boolean;
begin
 result:= PrismQRCodeReader.EnableMAXICODE;
end;

function TD2BridgeItemHTMLQRCodeReader.GetEnablePDF417: boolean;
begin
 result:= PrismQRCodeReader.EnablePDF417;
end;

function TD2BridgeItemHTMLQRCodeReader.GetEnableQRCODE: boolean;
begin
 result:= PrismQRCodeReader.EnableQRCODE;
end;

function TD2BridgeItemHTMLQRCodeReader.GetEnableRSS14: boolean;
begin
 result:= PrismQRCodeReader.EnableRSS14;
end;

function TD2BridgeItemHTMLQRCodeReader.GetEnableRSSEXPANDED: boolean;
begin
 result:= PrismQRCodeReader.EnableRSSEXPANDED;
end;

function TD2BridgeItemHTMLQRCodeReader.GetEnableUPCA: boolean;
begin
 result:= PrismQRCodeReader.EnableUPCA;
end;

function TD2BridgeItemHTMLQRCodeReader.GetEnableUPCE: boolean;
begin
 result:= PrismQRCodeReader.EnableUPCE;
end;

function TD2BridgeItemHTMLQRCodeReader.GetEnableUPCEANEXTENSION: boolean;
begin
 result:= PrismQRCodeReader.EnableUPCEANEXTENSION;
end;

function TD2BridgeItemHTMLQRCodeReader.GetOnRead: TNotifyEventStr;
begin
 result:= PrismQRCodeReader.OnRead;
end;

function TD2BridgeItemHTMLQRCodeReader.GetPressReturnKey: Boolean;
begin
 result:= PrismQRCodeReader.PressReturnKey;
end;

function TD2BridgeItemHTMLQRCodeReader.GetTextVCLComponent: TComponent;
begin
 result:= PrismQRCodeReader.TextVCLComponent;
end;

procedure TD2BridgeItemHTMLQRCodeReader.PreProcess;
begin

end;

function TD2BridgeItemHTMLQRCodeReader.PrismQRCodeReader: IPrismQRCodeReader;
begin
 result:= GetPrismControl as IPrismQRCodeReader;
end;

procedure TD2BridgeItemHTMLQRCodeReader.Render;
begin
 BaseClass.HTML.Render.Body.Add('{%'+TrataHTMLTag(ItemPrefixID+' class="d2bridgeqrcodereader rounded '+Trim(CSSClasses)+'" style="'+GetHTMLStyle+'"')+'%}');
end;

procedure TD2BridgeItemHTMLQRCodeReader.RenderHTML;
begin

end;


procedure TD2BridgeItemHTMLQRCodeReader.SetBorderShaders(
  const Value: Boolean);
begin
 PrismQRCodeReader.BorderShaders:= Value;
end;

procedure TD2BridgeItemHTMLQRCodeReader.SetContinuousScan(
  const Value: Boolean);
begin
 PrismQRCodeReader.ContinuousScan:= Value;
end;

procedure TD2BridgeItemHTMLQRCodeReader.SetEnableAZTEC(
  const Value: boolean);
begin
 PrismQRCodeReader.EnableAZTEC:= Value;
end;

procedure TD2BridgeItemHTMLQRCodeReader.SetEnableCODABAR(
  const Value: boolean);
begin
 PrismQRCodeReader.EnableCODABAR:= Value;
end;

procedure TD2BridgeItemHTMLQRCodeReader.SetEnableCODE128(
  const Value: boolean);
begin
 PrismQRCodeReader.EnableCODE128:= Value;
end;

procedure TD2BridgeItemHTMLQRCodeReader.SetEnableCODE39(
  const Value: boolean);
begin
 PrismQRCodeReader.EnableCODE39:= Value;
end;

procedure TD2BridgeItemHTMLQRCodeReader.SetEnableCODE93(
  const Value: boolean);
begin
 PrismQRCodeReader.EnableCODE93:= Value;
end;

procedure TD2BridgeItemHTMLQRCodeReader.SetEnableDATAMATRIX(
  const Value: boolean);
begin
 PrismQRCodeReader.EnableDATAMATRIX:= Value;
end;

procedure TD2BridgeItemHTMLQRCodeReader.SetEnableEAN13(
  const Value: boolean);
begin
 PrismQRCodeReader.EnableEAN13:= Value;
end;

procedure TD2BridgeItemHTMLQRCodeReader.SetEnableEAN8(
  const Value: boolean);
begin
 PrismQRCodeReader.EnableEAN8:= Value;
end;

procedure TD2BridgeItemHTMLQRCodeReader.SetEnableITF(const Value: boolean);
begin
 PrismQRCodeReader.EnableITF:= Value;
end;

procedure TD2BridgeItemHTMLQRCodeReader.SetEnableMAXICODE(
  const Value: boolean);
begin
 PrismQRCodeReader.EnableMAXICODE:= Value;
end;

procedure TD2BridgeItemHTMLQRCodeReader.SetEnablePDF417(
  const Value: boolean);
begin
 PrismQRCodeReader.EnablePDF417:= Value;
end;

procedure TD2BridgeItemHTMLQRCodeReader.SetEnableQRCODE(
  const Value: boolean);
begin
 PrismQRCodeReader.EnableQRCODE:= Value;
end;

procedure TD2BridgeItemHTMLQRCodeReader.SetEnableRSS14(
  const Value: boolean);
begin
 PrismQRCodeReader.EnableRSS14:= Value;
end;

procedure TD2BridgeItemHTMLQRCodeReader.SetEnableRSSEXPANDED(
  const Value: boolean);
begin
 PrismQRCodeReader.EnableRSSEXPANDED:= Value;
end;

procedure TD2BridgeItemHTMLQRCodeReader.SetEnableUPCA(
  const Value: boolean);
begin
 PrismQRCodeReader.EnableUPCA:= Value;
end;

procedure TD2BridgeItemHTMLQRCodeReader.SetEnableUPCE(
  const Value: boolean);
begin
 PrismQRCodeReader.EnableUPCE:= Value;
end;

procedure TD2BridgeItemHTMLQRCodeReader.SetEnableUPCEANEXTENSION(
  const Value: boolean);
begin
 PrismQRCodeReader.EnableUPCEANEXTENSION:= Value;
end;

procedure TD2BridgeItemHTMLQRCodeReader.SetOnRead(
  const Value: TNotifyEventStr);
begin
 PrismQRCodeReader.OnRead:= Value;
end;

procedure TD2BridgeItemHTMLQRCodeReader.SetPressReturnKey(const Value: Boolean);
begin
  PrismQRCodeReader.PressReturnKey:= true;
end;

procedure TD2BridgeItemHTMLQRCodeReader.SetTextVCLComponent(
  AComponent: TComponent);
begin
 PrismQRCodeReader.TextVCLComponent:= AComponent;
end;

end.
