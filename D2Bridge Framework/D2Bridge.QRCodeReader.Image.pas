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

unit D2Bridge.QRCodeReader.Image;

interface

Uses
 Classes, SysUtils, Generics.Collections,
{$IFnDEF FPC}
 {$IFnDEF FMX}
 ExtCtrls,
 {$ELSE}
 FMX.ExtCtrls,
 {$ENDIF}
{$ELSE}
 ExtCtrls,
{$ENDIF}
 D2Bridge.Interfaces, D2Bridge.Camera,
 Prism.Types, Prism.Interfaces;

type
 TD2BridgeQRCodeReaderImage = class(TD2BridgeCamera, ID2BridgeQRCodeReaderImage)
  private
   FOnChangeDevices: TNotifyEvent;
   FStarted: boolean;
  protected
   procedure DoChangeDevices; override;
   procedure OnPageLoad(EventParams: TStrings); override;
   procedure OnOrientationChange(EventParams: TStrings); override;
   procedure SetPrismControl(const Value: IPrismControl); override;
  public
   constructor Create(ASession: IPrismSession; APrismControl: IPrismControl);
   destructor Destroy; override;

   function IsRectangular: boolean;

   function Started: boolean;

   function Start: boolean;
   function Stop: boolean;

   function PrismControlQRCodeReader: IPrismQRCodeReader;

   property OnChangeDevices: TNotifyEvent read FOnChangeDevices write FOnChangeDevices;
 end;


implementation

Uses
 Prism.QRCodeReader;

{ TD2BridgeImageQRCodeReader }

constructor TD2BridgeQRCodeReaderImage.Create(ASession: IPrismSession; APrismControl: IPrismControl);
begin
 inherited Create(ASession);

 PrismControl:= APrismControl;
end;

destructor TD2BridgeQRCodeReaderImage.Destroy;
begin

 inherited;
end;

procedure TD2BridgeQRCodeReaderImage.DoChangeDevices;
begin
 inherited;

 if Assigned(FOnChangeDevices) then
  FOnChangeDevices(PrismControl.VCLComponent);
end;

function TD2BridgeQRCodeReaderImage.IsRectangular: boolean;
begin
 result:=
  (PrismControlQRCodeReader.EnableQRCODE = false) and
  (PrismControlQRCodeReader.EnableAZTEC = false) and
  (PrismControlQRCodeReader.EnableMAXICODE = false);
end;

procedure TD2BridgeQRCodeReaderImage.OnOrientationChange(EventParams: TStrings);
begin
 inherited;

 if Allowed and FStarted then
 begin
  Stop;
  Sleep(100);
  Start;
 end;
end;

procedure TD2BridgeQRCodeReaderImage.OnPageLoad(EventParams: TStrings);
begin
 inherited;

 FStarted:= false;
end;

function TD2BridgeQRCodeReaderImage.PrismControlQRCodeReader: IPrismQRCodeReader;
begin
 result:= PrismControl as TPrismQRCodeReader;
end;

procedure TD2BridgeQRCodeReaderImage.SetPrismControl(
  const Value: IPrismControl);
begin
 inherited;

 if Assigned(PrismControl) then
  (PrismControl as TPrismQRCodeReader).D2BridgeImageQRCodeReader:= self;
end;

function TD2BridgeQRCodeReaderImage.Start: boolean;
var
 vJS: TStrings;
 vResponseStr: string;
 I: integer;
begin
 result:= false;

 if Allowed then
 begin
  FStarted:= true;

  vJS:= TStringList.Create;

  with vJS do
  begin
   Add('$(document).ready(function() {');

   Add('  let formats = [];');
   if PrismControlQRCodeReader.EnableQRCODE then
     Add('  formats.push(ZXing.BarcodeFormat.QR_CODE);');
   if PrismControlQRCodeReader.EnableAZTEC then
     Add('  formats.push(ZXing.BarcodeFormat.AZTEC);');
   if PrismControlQRCodeReader.EnableCODABAR then
     Add('  formats.push(ZXing.BarcodeFormat.CODABAR);');
   if PrismControlQRCodeReader.EnableCODE39 then
     Add('  formats.push(ZXing.BarcodeFormat.CODE_39);');
   if PrismControlQRCodeReader.EnableCODE93 then
     Add('  formats.push(ZXing.BarcodeFormat.CODE_93);');
   if PrismControlQRCodeReader.EnableCODE128 then
     Add('  formats.push(ZXing.BarcodeFormat.CODE_128);');
   if PrismControlQRCodeReader.EnableMAXICODE then
     Add('  formats.push(ZXing.BarcodeFormat.DATA_MATRIX);');
   if PrismControlQRCodeReader.EnableMAXICODE then
     Add('  formats.push(ZXing.BarcodeFormat.MAXICODE);');
   if PrismControlQRCodeReader.EnableITF then
     Add('  formats.push(ZXing.BarcodeFormat.ITF);');
   if PrismControlQRCodeReader.EnableEAN13 then
     Add('  formats.push(ZXing.BarcodeFormat.EAN_13);');
   if PrismControlQRCodeReader.EnableEAN8 then
     Add('  formats.push(ZXing.BarcodeFormat.EAN_8);');
   if PrismControlQRCodeReader.EnablePDF417 then
     Add('  formats.push(ZXing.BarcodeFormat.PDF_417);');
   if PrismControlQRCodeReader.EnableRSS14 then
     Add('  formats.push(ZXing.BarcodeFormat.RSS_14);');
   if PrismControlQRCodeReader.EnableRSSEXPANDED then
     Add('  formats.push(ZXing.BarcodeFormat.RSS_EXPANDED);');
   if PrismControlQRCodeReader.EnableUPCA then
     Add('  formats.push(ZXing.BarcodeFormat.UPC_A);');
   if PrismControlQRCodeReader.EnableUPCE then
     Add('  formats.push(ZXing.BarcodeFormat.UPC_E);');
   if PrismControlQRCodeReader.EnableUPCEANEXTENSION then
     Add('  formats.push(ZXing.BarcodeFormat.UPC_EAN_EXTENSION);');

   Add('  if ('+AnsiUpperCase(PrismControl.NamePrefix)+'QRCodeReader === null) {');
   Add('   try {');
   Add('    '+AnsiUpperCase(PrismControl.NamePrefix)+'QRCodeReader = new ZXing.BrowserMultiFormatReader();');
   Add('    '+AnsiUpperCase(PrismControl.NamePrefix)+'QRCodeReader.decodeFromVideoDevice(');
   Add('      "'+CurrentDeviceId+'",');
   Add('      "'+AnsiUpperCase(PrismControl.NamePrefix)+'",');
   Add('      function(result, error, controls) {');
   Add('        if (result) {');
   Add('          '+AnsiUpperCase(PrismControl.NamePrefix)+'onScanSuccess(result.getText(), result);');
   Add('        } else if (error) {');
   Add('          '+AnsiUpperCase(PrismControl.NamePrefix)+'onScanFailure(error);');
   Add('        }');
   Add('      },');
   Add('      { formats: formats }');
   Add('    );');
   Add('   } catch (e) {');
   Add('     console.error("Error on access camera: ", e);');
   Add('     '+AnsiUpperCase(PrismControl.NamePrefix)+'onScanFailure(e);');
   Add('   }');
   Add('  }');

   Add(' const isFirefox = navigator.userAgent.toLowerCase().includes("firefox");');
   Add(' if (isFirefox)');
   Add('   D2BridgeSaveCameraListToCookie();');

   Add('});');
  end;

  PrismControl.Session.ExecJS(vJS.Text);

  vJS.Free;

//  I:= 0;
//  vResponseStr:= '';
//  repeat
//   Inc(I);
//
//   Sleep(500);
//
//   vResponseStr:= PrismControl.Session.ExecJSResponse(
//     '('+AnsiUpperCase(PrismControl.NamePrefix)+'videoElement && '+
//     '!'+AnsiUpperCase(PrismControl.NamePrefix)+'videoElement.paused && '+
//     '!'+AnsiUpperCase(PrismControl.NamePrefix)+'videoElement.ended && '+
//     ''+AnsiUpperCase(PrismControl.NamePrefix)+'videoElement.readyState >= 2) === true;'
//   );
//  until (I >= 5) or
//        (vResponseStr = 'true');

  TryStrToBool(vResponseStr, result);
 end;
end;

function TD2BridgeQRCodeReaderImage.Started: boolean;
begin
 result:= FStarted;
end;

function TD2BridgeQRCodeReaderImage.Stop: boolean;
var
 vJS: TStrings;
 vResponseStr: string;
 I: integer;
begin
 result:= false;

 if Allowed then
 begin
  FStarted:= false;
  vJS:= TStringList.Create;

  with vJS do
  begin
   Add('$(document).ready(function() {');
   Add('  if ('+AnsiUpperCase(PrismControl.NamePrefix)+'QRCodeReader !== null) {');
   Add('      setTimeout(function() {');
   Add('        '+AnsiUpperCase(PrismControl.NamePrefix)+'QRCodeReader.reset();');
   Add('        '+AnsiUpperCase(PrismControl.NamePrefix)+'QRCodeReader = null;');
//   if IsRectangular then
//   begin
//    Add('        '+AnsiUpperCase(PrismControl.NamePrefix)+'Element.style.height = Math.floor((('+
//                   AnsiUpperCase(PrismControl.NamePrefix)+'Element.offsetWidth / 16) * 9) * 0.35) + "px";');
//   end else
//   begin
//    Add('        '+AnsiUpperCase(PrismControl.NamePrefix)+'Element.style.height = Math.floor(('+
//                   AnsiUpperCase(PrismControl.NamePrefix)+'Element.offsetWidth / 16) * 9) + "px";');
//   end;
   Add('      }, 10);');
   Add('  }');
   Add('});');
  end;

  PrismControl.Session.ExecJS(vJS.Text);

  vJS.Free;

  I:= 0;
  vResponseStr:= '';
  repeat
   Inc(I);

   Sleep(500);

   vResponseStr:= PrismControl.Session.ExecJSResponse(
     '('+AnsiUpperCase(PrismControl.NamePrefix)+'QRCodeReader === null);'
   );
  until (I >= 5) or
        (vResponseStr = 'true');

  TryStrToBool(vResponseStr, result);
 end;
end;

end.
