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

{$IFDEF D2BRIDGE}
  {$I D2Bridge.inc}
{$ENDIF}

unit D2Bridge.Types;

interface

uses
  Classes;

type
 TD2BridgeCardImagePosition =
   (D2BridgeCardImagePositionTop = 0,
    D2BridgeCardImagePositionBottom,
    D2BridgeCardImagePositionLeft,
    D2BridgeCardImagePositionRight,
    D2BridgeCardImagePositionIco,
    D2BridgeCardImagePositionFull);


type
 TD2BridgeColumnsAlignment =
   (D2BridgeAlignColumnsNone = 0,
   D2BridgeAlignColumnsLeft,
   D2BridgeAlignColumnsRight,
   D2BridgeAlignColumnsCenter,
   D2BridgeAlignColumnsJustified);

type
 TD2BridgeLang =
  (English = 0,
   Portuguese,
   Spanish,
   Arabic,
   Italian,
   French,
   German,
   Japanese,
   Russian,
   Chinese,
   Czech,
   Turkish,
   Korean,
   Romanian,
   Persian,
   Thai,
   Ukrainian);

 TD2BridgeLangs = set of TD2BridgeLang;


type
 TD2BridgeFrameworkTypeClass = class of TObject;

type
 TD2BridgeFormClass = class of TObject;

type
 TToastPosition =
  (
    ToastTop,
    ToastTopLeft,
    ToastTopRight,
    ToastCenter,
    ToastCenterLeft,
    ToastCenterRight,
    ToastBottom,
    ToastBottomLeft,
    ToastBottomRight
  );


implementation


end.
