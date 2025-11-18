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

unit D2Bridge.Rest.Security;

interface

uses
  SysUtils, Classes,
{$IFDEF FPC}

{$ELSE}

{$ENDIF}
  Prism.Types,
  D2Bridge.Rest.Interfaces,
  Prism.Security.Interfaces;


type
 TD2BridgeRestSecurity = class(TInterfacedPersistent, ID2BridgeRestSecurity)
  private
   FJWTAccess: IPrismSecurityJWT;
   FJWTRefresh: IPrismSecurityJWT;
  public
   constructor Create;
   destructor Destroy; override;

   function JWTAccess: IPrismSecurityJWT;
   function JWTRefresh: IPrismSecurityJWT;
 end;


const
 AccessJWTDefaultToken = 'D2Bridge_Framework_is_Delphi_Web';
 RefreshJWTDefaultToken = 'D2Bridge_Framework_is_Delphi_Web_with_Token_Refresh';


implementation

Uses
 Prism.Security.JWT;

{ TD2BridgeRestSecurity }

constructor TD2BridgeRestSecurity.Create;
begin
 FJWTAccess:= TPrismSecurityJWT.Create(AccessJWTDefaultToken);
 FJWTAccess.ExpirationMinutes:= 15;

 FJWTRefresh:= TPrismSecurityJWT.Create(RefreshJWTDefaultToken);
 FJWTRefresh.ExpirationDays:= 30;
 FJWTRefresh.TokenType:= TSecurityJWTTokenType.JWTTokenRefresh;
end;

destructor TD2BridgeRestSecurity.Destroy;
var
 vJWTAccess: TPrismSecurityJWT;
 vJWTRefresh: TPrismSecurityJWT;
begin
 vJWTAccess:= FJWTAccess as TPrismSecurityJWT;
 FJWTAccess:= nil;
 vJWTAccess.Free;

 vJWTRefresh:= FJWTRefresh as TPrismSecurityJWT;
 FJWTRefresh:= nil;
 vJWTRefresh.Free;

 inherited;
end;

function TD2BridgeRestSecurity.JWTAccess: IPrismSecurityJWT;
begin
 result:= FJWTAccess;
end;

function TD2BridgeRestSecurity.JWTRefresh: IPrismSecurityJWT;
begin
 result:= FJWTRefresh;
end;

end.