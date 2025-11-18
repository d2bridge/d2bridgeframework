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

unit D2Bridge.Image;

interface

uses
  Classes,
{$IFNDEF FPC}
  {$IFDEF HAS_UNIT_SYSTEM_NETENCODING}
  System.NetEncoding,
  {$ELSE}
  EncdDecd,
  {$ENDIF}
{$ELSE}
  base64,
{$ENDIF}
{$IFDEF FMX}
  FMX.Objects, FMX.Graphics,
{$ELSE}
  ExtCtrls, Graphics,
{$ENDIF}
  D2Bridge.Image.Interfaces;

type
 TD2BridgeImage = class(TInterfacedPersistent, ID2BridgeImage)
  private
   FLocal: string;
   FImageFromBase64: string;
   FPicture: {$IFNDEF FMX}TPicture{$ELSE}TBitmap{$ENDIF};
   FURL: string;
   FIsEmpty: Boolean;
   function getImageFromBase64: string;
   function getLocal: string;
   function GetPicture: {$IFNDEF FMX}TPicture{$ELSE}TBitmap{$ENDIF};
   function getURL: string;
   procedure setImageFromBase64(const Value: string);
   procedure SetImage(const Value: TImage);
   procedure setLocal(const Value: string);
   procedure SetPicture(const Value: {$IFNDEF FMX}TPicture{$ELSE}TBitmap{$ENDIF});
   procedure setURL(const Value: string);
   function ConvertLocalToBase64: string;
   function ConvertPictureToBase64: string;
   function HasImage(const ATImage: TImage): boolean; overload;
   function HasImage(const ATPicture: {$IFNDEF FMX}TPicture{$ELSE}TBitmap{$ENDIF}): boolean; overload;
  public
   constructor Create;
   destructor Destroy; override;

   function IsEmpty: Boolean;
   function IsBase64: Boolean;
   function ImageToBase64: string;

   function ImageToSrc: string;

   property Image: TImage write SetImage;
   property Picture: {$IFNDEF FMX}TPicture{$ELSE}TBitmap{$ENDIF} read GetPicture write SetPicture;
   property URL: string read getURL write setURL;
   property Local: string read getLocal write setLocal;
   property ImageFromBase64: string read getImageFromBase64 write setImageFromBase64;
 end;


implementation

uses
  SysUtils;

{ TD2BridgeImage }

function TD2BridgeImage.ConvertLocalToBase64: string;
var
  FileStream: TFileStream;
  Output:     TStringStream;
{$IFDEF FPC}
  Encoder:    TBase64EncodingStream;
{$ENDIF}
begin
 try
  Result := '';
  if not FileExists(FLocal) then
    Exit;

  FileStream := TFileStream.Create(FLocal, fmOpenRead or fmShareDenyWrite);
  Output := TStringStream.Create;
  try
   FileStream.Position:= 0;

{$IFNDEF FPC}
  {$IFDEF HAS_UNIT_SYSTEM_NETENCODING}
    TNetEncoding.Base64.Encode(FileStream, Output);
  {$ELSE}
    EncodeStream(FileStream, Output);
  {$ENDIF}
{$ELSE}
    Encoder:= TBase64EncodingStream.Create(Output);
    Encoder.CopyFrom(FileStream, FileStream.Size);
    Encoder.Flush;
{$ENDIF}

    Output.Position := 0;

    Result := Output.DataString;
  finally
    FileStream.Free;
    Output.Free;
{$IFDEF FPC}
    Encoder.Free;
{$ENDIF}
  end;
 except
 end;
end;


function TD2BridgeImage.ConvertPictureToBase64: string;
var
  Output, Input: TStringStream;
{$IFDEF FPC}
  Encoder:       TBase64EncodingStream;
{$ENDIF}
begin
  try
    if Assigned(FPicture) then
    begin
{$IFNDEF FMX}
      if Assigned(FPicture.Graphic) then
      begin
{$ENDIF}
        if FPicture.Width = 0 then
          Exit;

        try
          Input := TStringStream.Create;
          Output := TStringStream.Create;

          FPicture.{$IFNDEF FMX}Graphic.{$ENDIF}SaveToStream(Input);
          Input.Position := 0;

{$IFNDEF FPC}
  {$IFDEF HAS_UNIT_SYSTEM_NETENCODING}
          TNetEncoding.Base64.Encode(Input, Output);
  {$ELSE}
          EncodeStream(Input, Output);
  {$ENDIF}
{$ELSE}
          Encoder:= TBase64EncodingStream.Create(Output);
          Encoder.CopyFrom(Input, Input.Size);
          Encoder.Flush;
{$ENDIF}

          Output.Position := 0;

          Result := Output.DataString;
        finally
          Input.Free;
          Output.Free;
{$IFDEF FPC}
          Encoder.Free;
{$ENDIF}
        end;
{$IFNDEF FMX}
      end;
{$ENDIF}
    end;
  except
  end;
end;

constructor TD2BridgeImage.Create;
begin
 FIsEmpty:= true;
end;

destructor TD2BridgeImage.Destroy;
begin
 inherited;
end;

function TD2BridgeImage.getImageFromBase64: string;
begin

end;

function TD2BridgeImage.getLocal: string;
begin
 result:= FLocal;
end;

function TD2BridgeImage.GetPicture: {$IFNDEF FMX}TPicture{$ELSE}TBitmap{$ENDIF};
begin
 Result:= FPicture;
end;

function TD2BridgeImage.getURL: string;
begin
 Result:= FURL;
end;

function TD2BridgeImage.HasImage(const ATPicture: {$IFNDEF FMX}TPicture{$ELSE}TBitmap{$ENDIF}): boolean;
begin
 {$IFDEF FMX}
  Result := Assigned(ATPicture) and (not ATPicture.IsEmpty);
 {$ELSE}
  Result := Assigned(ATPicture.Graphic) and (not ATPicture.Graphic.Empty);
 {$ENDIF}
end;

function TD2BridgeImage.HasImage(const ATImage: TImage): boolean;
begin
 {$IFDEF FMX}
  Result := Assigned(ATImage.Bitmap) and (not ATImage.Bitmap.IsEmpty);
 {$ELSE}
  Result := Assigned(ATImage.Picture.Graphic) and (not ATImage.Picture.Graphic.Empty);
 {$ENDIF}
end;

function TD2BridgeImage.ImageToBase64: string;
begin
 Result:= '';

 if not FIsEmpty then
  if (FImageFromBase64 <> '') then
   Result:= FImageFromBase64
  else
   if (FLocal <> '') then
    Result:= ConvertLocalToBase64
   else
    if Assigned(FPicture) then
     Result:= ConvertPictureToBase64;
end;

function TD2BridgeImage.ImageToSrc: string;
begin
 Result:= '';

 if not FIsEmpty then
  if (FImageFromBase64 <> '') then
   Result:= 'data:image/jpeg;base64, '+ FImageFromBase64
  else
   if (FLocal <> '') then
    Result:= 'data:image/jpeg;base64, '+ ConvertLocalToBase64
   else
    if Assigned(FPicture) then
     Result:= 'data:image/jpeg;base64, '+ ConvertPictureToBase64
    else
     Result:= FURL;
end;

function TD2BridgeImage.IsBase64: Boolean;
begin
 result:=false;

 if not FIsEmpty then
  if (FImageFromBase64 <> '') or (FLocal <> '') or Assigned(FPicture) then
   Result:= true;
end;

function TD2BridgeImage.IsEmpty: Boolean;
begin
 result:= FIsEmpty;
end;

procedure TD2BridgeImage.SetImage(const Value: TImage);
begin
 if HasImage(Value) then
 begin
  FIsEmpty:= false;
  FPicture := TImage(Value).{$IFNDEF FMX}Picture{$ELSE}Bitmap{$ENDIF};
 end;
end;

procedure TD2BridgeImage.setImageFromBase64(const Value: string);
begin
 FIsEmpty:= false;
 FImageFromBase64:= Value;
end;

procedure TD2BridgeImage.setLocal(const Value: string);
begin
 FIsEmpty:= false;
 FLocal:= Value;
end;

procedure TD2BridgeImage.SetPicture(const Value: {$IFNDEF FMX}TPicture{$ELSE}TBitmap{$ENDIF});
begin
 if HasImage(Value) then
 begin
  FIsEmpty:= false;
  FPicture:= Value;
 end;
end;

procedure TD2BridgeImage.setURL(const Value: string);
begin
 FIsEmpty:= false;
 FURL:= Value;
end;

end.
