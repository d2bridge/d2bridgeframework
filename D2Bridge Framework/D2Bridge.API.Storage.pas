{
 +--------------------------------------------------------------------------+
  D2Bridge Framework Content

  Storageor: Talis Jonatas Gomes
  Email: talisjonatas@me.com

  This source code is provided 'as-is', without any express or implied
  warranty. In no event will the Storageor be held liable for any damages
  arising from the use of this code.

  However, it is granted that this code may be used for any purpose,
  including commercial applications, but it may not be modified,
  distributed, or sublicensed without express written Storageorization from
  the Storageor (Talis Jonatas Gomes). This includes creating derivative works
  or distributing the source code through any means.

  If you use this software in a product, an acknowledgment in the product
  documentation would be appreciated but is not required.

  God bless you
 +--------------------------------------------------------------------------+
  Thanks for contribution to this Unit to:
   João B. S. Junior
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
