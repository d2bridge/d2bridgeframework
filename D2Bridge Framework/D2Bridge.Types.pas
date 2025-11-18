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
   Ukrainian,
   Polish);

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