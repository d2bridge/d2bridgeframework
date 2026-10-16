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
var
 vGoogle: TD2BridgeAPIAuthGoogle;
 vMicrosoft: TD2BridgeAPIAuthMicrosoft;
begin
 vGoogle:= FGoogle as TD2BridgeAPIAuthGoogle;
 FGoogle:= nil;
 vGoogle.Free;

 vMicrosoft:= FMicrosoft as TD2BridgeAPIAuthMicrosoft;
 FMicrosoft:= nil;
 vMicrosoft.Free;

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