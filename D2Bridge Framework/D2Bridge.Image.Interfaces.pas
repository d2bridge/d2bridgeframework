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

unit D2Bridge.Image.Interfaces;

interface

uses
  Classes,
 {$IFDEF FMX}
  FMX.Graphics, FMX.Objects
 {$ELSE}
  Graphics, ExtCtrls
 {$ENDIF}
  ;



type
 ID2BridgeImage = interface;

 ID2BridgeImage = interface
  ['{4FE0BCDC-39E1-474B-A1E4-30F72170AA26}']
  function getImageFromBase64: string;
  function getLocal: string;
  function GetPicture: {$IFNDEF FMX}TPicture{$ELSE}TBitmap{$ENDIF};
  function getURL: string;
  procedure setImageFromBase64(const Value: string);
  procedure SetImage(const Value: TImage);
  procedure setLocal(const Value: string);
  procedure SetPicture(const Value: {$IFNDEF FMX}TPicture{$ELSE}TBitmap{$ENDIF});
  procedure setURL(const Value: string);

  function IsEmpty: Boolean;
  function IsBase64: Boolean;
  function ImageToBase64: string;

  property Image: TImage write SetImage;
  property Picture: {$IFNDEF FMX}TPicture{$ELSE}TBitmap{$ENDIF} read GetPicture write SetPicture;
  property URL: string read getURL write setURL;
  property Local: string read getLocal write setLocal;
  property ImageFromBase64: string read getImageFromBase64 write setImageFromBase64;

 end;

implementation

end.
