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

unit D2Bridge.API;

interface

uses
  Classes, SysUtils,
  D2Bridge.Interfaces, Prism.Interfaces
  {$IFDEF FMX}

  {$ELSE}

  {$ENDIF}
  ;


type
 TD2BridgeAPI = class(TInterfacedPersistent, ID2BridgeAPI)
  private
   FMail: ID2BridgeAPIMail;
   FAuth: ID2BridgeAPIAuth;
   FEvolution: ID2BridgeAPIEvolution;
   FStorage: ID2BridgeAPIStorage;
  public
   constructor Create;
   destructor Destroy; override;

   function Mail: ID2BridgeAPIMail;

   function Auth: ID2BridgeAPIAuth;

   function Evolution: ID2BridgeAPIEvolution;

   function Storage: ID2BridgeAPIStorage;
 end;


implementation

uses
  D2Bridge.API.Mail, D2Bridge.API.Auth, D2Bridge.API.Storage;

{ TD2BridgeAPI }

constructor TD2BridgeAPI.Create;
begin
 inherited;

 FMail := TD2BridgeAPIMail.Create;
 FAuth := TD2BridgeAPIAuth.Create;
 //FEvolution := TD2BridgeAPIEvolution.Create;
 FStorage := TD2BridgeAPIStorage.Create;
end;

destructor TD2BridgeAPI.Destroy;
begin
 (FMail as TD2BridgeAPIMail).Destroy;
 (FAuth as TD2BridgeAPIAuth).Destroy;
 //(FEvolution as TD2BridgeAPIEvolution).Destroy;
 (FStorage as TD2BridgeAPIStorage).Destroy;

 inherited;
end;

function TD2BridgeAPI.Storage: ID2BridgeAPIStorage;
begin
 result:= FStorage;
end;

function TD2BridgeAPI.Evolution: ID2BridgeAPIEvolution;
begin
 result:= FEvolution;
end;

function TD2BridgeAPI.Auth: ID2BridgeAPIAuth;
begin
 result:= FAuth;
end;

function TD2BridgeAPI.Mail: ID2BridgeAPIMail;
begin
 result:= FMail;
end;

end.
