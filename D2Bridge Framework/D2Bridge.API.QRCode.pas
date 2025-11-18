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

unit D2Bridge.API.QRCode;

interface

uses
  Classes, Types,
{$IFDEF HAS_UNIT_SYSTEM_UITYPES}
  System.UITypes,
{$ENDIF}
  D2Bridge.Interfaces, D2Bridge.Vendor.DelphiZXIngQRCode
{$IFDEF FMX}
  , FMX.Graphics, FMX.Objects, FMX.ExtCtrls
{$ELSE}
  , Graphics, ExtCtrls
  {$IFDEF BORLAND}
    {$IF CompilerVersion > 22}
    , Vcl.Imaging.jpeg
    {$ELSE}
    , jpeg
    {$IFEND}
  {$ENDIF}
{$ENDIF}
 ;


type
 TD2BridgeAPIQRCode = class(TInterfacedPersistent, ID2BridgeAPIQRCode)
  private
   FText: string;
   FSize: integer;
   FColorCode: string;
   FColorBackground: string;
   FQRCode  :TDelphiZXingQRCode;
   FQRCodeJPG: TJPEGImage;
   FQRCodeBitmap: TBitmap;
   FImage: TImage;
   function GetText: string;
   procedure SetText(const Value: string);
   function GetSize: integer;
   procedure SetSize(const Value: integer);
   function GetColorCode: string;
   procedure SetColorCode(const Value: string);
   function GetColorBackground: string;
   procedure SetColorBackground(const Value: string);
   function ZXingQRCode: TDelphiZXingQRCode;
  public
   constructor Create;
   destructor Destroy; override;

   function QRCodeBitmap: TBitmap;
   function QRCodeJPG: TJPEGImage;
   function QRCodeImage: TImage;
   function QRCodeBase64: String;

   property Text: string read GetText write SetText;
   property Size: integer read GetSize write SetSize;
   property ColorCode: string read GetColorCode write SetColorCode;
   property ColorBackground: string read GetColorBackground write SetColorBackground;
 end;


implementation

uses
  D2Bridge.Util;


{ TD2BridgeAPIQRCode }

constructor TD2BridgeAPIQRCode.Create;
begin
 inherited;

 FText:= '';
 FSize:= 500;
 FColorCode:= '#000000';
 FColorBackground:= '#ffffff';

 FQRCode:= TDelphiZXingQRCode.Create;
 FQRCode.Encoding:= qrAuto;
 FQRCode.QuietZone:= 2;

 FQRCodeBitmap:= TBitmap.Create;

 FQRCodeJPG:= TJPEGImage.Create;
{$IFNDEF FMX}
 FQRCodeJPG.CompressionQuality := 100;
 FQRCodeJPG.PixelFormat := {$IFNDEF FPC}jf24bit{$ELSE}pf24bit{$ENDIF};
{$ENDIF}

 FImage:= TImage.Create(nil);
end;

destructor TD2BridgeAPIQRCode.Destroy;
begin
 FQRCode.Free;

 FQRCodeBitmap.Free;
 FQRCodeJPG.Free;

 FImage.Free;

 inherited;
end;

function TD2BridgeAPIQRCode.GetColorBackground: string;
begin
 result:= FColorBackground;
end;

function TD2BridgeAPIQRCode.GetColorCode: string;
begin
 result:= FColorCode;
end;

function TD2BridgeAPIQRCode.GetSize: integer;
begin
 result:= FSize;
end;

function TD2BridgeAPIQRCode.GetText: string;
begin
 result:= FText;
end;

function TD2BridgeAPIQRCode.QRCodeBase64: String;
begin

end;

function TD2BridgeAPIQRCode.QRCodeBitmap: TBitmap;
var
 vRow, vColumn: Integer;
 vScale:        Double;
 pixelColor:    {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
begin
 FQRCode.Data:= Text;

{$IFNDEF FMX}
 FQRCodeBitmap.SetSize(FQRCode.Rows, FQRCode.Columns);
{$ELSE}
 FQRCodeBitmap.SetSize(FSize, FSize);

 vScale:= FSize / FQRCode.Rows;
{$ENDIF}

 for vRow := 0 to FQRCode.Rows-1 do
 begin
  for vColumn := 0 to FQRCode.Columns-1 do
  begin
   if (FQRCode.IsBlack[vRow, vColumn]) then
     pixelColor := HexToTColor(ColorCode)
   else
     pixelColor := HexToTColor(ColorBackground);

{$IFNDEF FMX}
    FQRCodeBitmap.Canvas.Pixels[vColumn, vRow]:= pixelColor;
{$ELSE}
    FQRCodeBitmap.ClearRect(TRectF.Create(PointF(vColumn, vRow) * vScale, vScale, vScale), pixelColor);
{$ENDIF}
  end;
 end;

{$IFNDEF FMX}
 if (FQRCodeBitmap.Width>0) and (FQRCodeBitmap.Height>0) then
 begin
  if FSize > FQRCodeBitmap.Width then
   vScale := FSize / FQRCodeBitmap.Width
  else
   vScale := FQRCodeBitmap.Width / FSize;
 end;

 FQRCodeBitmap.SetSize(FSize, FSize);
 FQRCodeBitmap.Canvas.StretchDraw(Rect(0,0, Trunc(vScale * FQRCodeBitmap.Width), Trunc(vScale * FQRCodeBitmap.Height)), FQRCodeBitmap);
{$ENDIF}

 Result:= FQRCodeBitmap;
end;

function TD2BridgeAPIQRCode.QRCodeImage: TImage;
begin
 FImage.{$IFNDEF FMX}Picture{$ELSE}Bitmap{$ENDIF}.Assign(QRCodeBitmap);

 Result:= FImage;
end;

function TD2BridgeAPIQRCode.QRCodeJPG: TJPEGImage;
begin
 FQRCodeJPG.Assign(nil);
 FQRCodeJPG.Assign(QRCodeBitmap);

 Result:= FQRCodeJPG;
end;


procedure TD2BridgeAPIQRCode.SetColorBackground(const Value: string);
begin
 FColorBackground:= Value;
end;

procedure TD2BridgeAPIQRCode.SetColorCode(const Value: string);
begin
 FColorCode:= Value;
end;

procedure TD2BridgeAPIQRCode.SetSize(const Value: integer);
begin
 FSize:= Value;
end;

procedure TD2BridgeAPIQRCode.SetText(const Value: string);
begin
 FText:= Value;
end;

function TD2BridgeAPIQRCode.ZXingQRCode: TDelphiZXingQRCode;
var
 FRow, FColumn: Integer;
 FScale : Double;
begin
 FQRCode.Data       := Text;
 FQRCode.Encoding   := qrAuto;
 //FQRCode.QuietZone  := QuietZone;

end;

end.
