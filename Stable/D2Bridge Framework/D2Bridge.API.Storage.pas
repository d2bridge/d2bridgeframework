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
  Thanks for contribution to this Unit to:
   Joao B. S. Junior
   Phone +55 69 99250-3445
   Email jr.playsoft@gmail.com
 +--------------------------------------------------------------------------+
}

{$I D2Bridge.inc}

unit D2Bridge.API.Storage;

interface

uses
  Classes, SysUtils,
  D2Bridge.Interfaces
  {$IFDEF FMX}

  {$ELSE}

  {$ENDIF}
  ;

type
  TD2BridgeAPIStorage = class(TInterfacedPersistent, ID2BridgeAPIStorage)
   private
{$IFNDEF FPC}
      FAmazonS3: ID2BridgeAPIStorageAmazonS3;
{$ENDIF}
   public
    constructor Create;
    destructor Destroy; override;

{$IFNDEF FPC}
    function AmazonS3: ID2BridgeAPIStorageAmazonS3;
{$ENDIF}
  end;

implementation

uses
  D2Bridge.API.Storage.AmazonS3;

{ TD2BridgeAPIStorage }

constructor TD2BridgeAPIStorage.Create;
begin
 inherited;

{$IFNDEF FPC}
 FAmazonS3:= TD2BridgeAPIStorageAmazonS3.Create;
{$ENDIF}
end;

destructor TD2BridgeAPIStorage.Destroy;
begin
{$IFNDEF FPC}
 (FAmazonS3 as TD2BridgeAPIStorageAmazonS3).Destroy;
 FAmazonS3:= nil;
{$ENDIF}

 inherited;
end;

{$IFNDEF FPC}
function TD2BridgeAPIStorage.AmazonS3: ID2BridgeAPIStorageAmazonS3;
begin
 result:= FAmazonS3;
end;
{$ENDIF}

end.