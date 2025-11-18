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

{$I ..\D2Bridge.inc}

unit Prism.Security.Interfaces;

interface

Uses
 Classes, SysUtils,
 D2Bridge.JSON,
 Prism.Types;


type
 IPrismSecurityJWT = interface
  ['{940B6F91-3E32-4383-BAB8-F9D0E5EFB319}']
   function GetAlgorithm: TSecurityJWTAlgorithm;
   procedure SetAlgorithm(const Value: TSecurityJWTAlgorithm);
   function GetSecret: string;
   procedure SetSecret(const Value: string);
   function GetTokenType: TSecurityJWTTokenType;
   procedure SetTokenType(const Value: TSecurityJWTTokenType);
   function Expired(const PayloadJson: string): Boolean;
   function GetExpirationMinutes: Integer;
   function GetExpirationDays: Integer;
   function GetExpirationHours: Integer;
   function GetExpirationSeconds: Integer;
   procedure SetExpirationDays(const Value: Integer);
   procedure SetExpirationHours(const Value: Integer);
   procedure SetExpirationSeconds(const Value: Integer);
   procedure SetExpirationMinutes(const Value: Integer);

   function Token(ASub: string; AIdentity: string = ''): string; overload;
   function Token(APayLoad: TJSONObject): string; overload;

   function Valid(AToken: string): boolean;

   function Payload(const AToken: string): string;

   function HeaderAuthorized(const AuthorizationHeader: string): Boolean;

   property Algorithm: TSecurityJWTAlgorithm read GetAlgorithm write SetAlgorithm;
   property TokenType: TSecurityJWTTokenType read GetTokenType write SetTokenType;
   property Secret: string read GetSecret write SetSecret;
   property ExpirationDays: Integer read GetExpirationDays write SetExpirationDays;
   property ExpirationHours: Integer read GetExpirationHours write SetExpirationHours;
   property ExpirationMinutes: Integer read GetExpirationMinutes write SetExpirationMinutes;
   property ExpirationSeconds: Integer read GetExpirationSeconds write SetExpirationSeconds;
 end;

implementation

end.