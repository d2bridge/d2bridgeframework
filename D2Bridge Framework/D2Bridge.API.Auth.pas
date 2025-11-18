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

unit D2Bridge.API.Auth;

interface

uses
  Classes, SysUtils,
  D2Bridge.Interfaces
  {$IFDEF FMX}

  {$ELSE}

  {$ENDIF}
  ;

type
  TD2BridgeAPIAuth = class(TInterfacedPersistent, ID2BridgeAPIAuth)
   private
    FGoogle: ID2BridgeAPIAuthGoogle;
    FMicrosoft: ID2BridgeAPIAuthMicrosoft;
   public
    constructor Create;
    destructor Destroy; override;

    function Google: ID2BridgeAPIAuthGoogle;
    function Microsoft: ID2BridgeAPIAuthMicrosoft;
  end;


const
  APIAuthLockName = 'd2bridgeauthlock';
  APIAuthCallBack = 'd2bridge/api/auth';

implementation

uses
  D2Bridge.API.Auth.Google,
  D2Bridge.API.Auth.Microsoft;

{ TD2BridgeAPIAuth }

constructor TD2BridgeAPIAuth.Create;
begin
 inherited;

 FGoogle:= TD2BridgeAPIAuthGoogle.Create;
 FMicrosoft:= TD2BridgeAPIAuthMicrosoft.Create;
end;

destructor TD2BridgeAPIAuth.Destroy;
begin
 (FGoogle as TD2BridgeAPIAuthGoogle).Destroy;
 FGoogle:= nil;

 (FMicrosoft as TD2BridgeAPIAuthMicrosoft).Destroy;
 FMicrosoft:= nil;


 inherited;
end;

function TD2BridgeAPIAuth.Google: ID2BridgeAPIAuthGoogle;
begin
 result:= FGoogle;
end;

function TD2BridgeAPIAuth.Microsoft: ID2BridgeAPIAuthMicrosoft;
begin
 result:= FMicrosoft;
end;


end.
