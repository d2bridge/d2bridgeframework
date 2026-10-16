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

unit Prism.Security.JWT;

interface

uses
  SysUtils, Classes, DateUtils,
{$IFDEF FPC}
  base64, HMAC, fpjson, jsonparser, Prism.Security.JWT.Laz,
{$ELSE}
  System.NetEncoding, System.Hash, System.JSON,
{$ENDIF}
  Prism.Types, Prism.Security.Interfaces,
  D2Bridge.JSON;

type
  TPrismSecurityJWT = class(TInterfacedPersistent, IPrismSecurityJWT)
  private
    FAlgorithm: TSecurityJWTAlgorithm;
    FSecret: string;
    FTokenType: TSecurityJWTTokenType;
    FExpirationMinutes: Integer;
    function GetAlgorithm: TSecurityJWTAlgorithm;
    function GetSecret: string;
    procedure SetAlgorithm(const Value: TSecurityJWTAlgorithm);
    procedure SetSecret(const Value: string);
    function Expired(const PayloadJson: string): Boolean;
    function GetTokenType: TSecurityJWTTokenType;
    function GetExpirationMinutes: Integer;
    function GetExpirationDays: Integer;
    function GetExpirationHours: Integer;
    function GetExpirationSeconds: Integer;
    procedure SetTokenType(const Value: TSecurityJWTTokenType);
    procedure SetExpirationDays(const Value: Integer);
    procedure SetExpirationHours(const Value: Integer);
    procedure SetExpirationSeconds(const Value: Integer);
    procedure SetExpirationMinutes(const Value: Integer);
  public
    constructor Create(ASecret: string = '');

    function Token(ASub: string; AIdentity: string = ''): string; overload;
    function Token(APayLoad: TJSONObject): string; overload;

    function Valid(AToken: string): boolean;

    function Payload(const AToken: string): string;

    function HeaderAuthorized(const AuthorizationHeader: string): Boolean;

    property Algorithm: TSecurityJWTAlgorithm read GetAlgorithm write SetAlgorithm;
    property Secret: string read GetSecret write SetSecret;
    property TokenType: TSecurityJWTTokenType read GetTokenType write SetTokenType;
    property ExpirationDays: Integer read GetExpirationDays write SetExpirationDays;
    property ExpirationHours: Integer read GetExpirationHours write SetExpirationHours;
    property ExpirationMinutes: Integer read GetExpirationMinutes write SetExpirationMinutes;
    property ExpirationSeconds: Integer read GetExpirationSeconds write SetExpirationSeconds;

  end;

implementation

uses
  D2Bridge.Util,
  D2Bridge.Rest.Security;

{$IFDEF FPC}
function HMAC_SHA256_UTF8Msg_ASCIIKey(const AMessage, AKey: string): TBytes;
const
  BLOCK_SIZE = 64;
var
  i: Integer;
  KeyBlock, o_key_pad, i_key_pad: array[0..BLOCK_SIZE-1] of Byte;
  ctx: TSHA256Context;
  hash_inner: array[0..31] of Byte;
  msgBytes, keyBytes: TBytes;
begin
  FillChar(KeyBlock, SizeOf(KeyBlock), 0);

  // Codificação correta:
  msgBytes := SysUtils.TEncoding.UTF8.GetBytes(AMessage);
  keyBytes := SysUtils.TEncoding.ASCII.GetBytes(AKey);

  if Length(keyBytes) > BLOCK_SIZE then
  begin
    SHA256Init(ctx);
    SHA256Update(ctx, keyBytes[0], Length(keyBytes));
    SHA256Final(ctx, KeyBlock);
  end
  else
    Move(keyBytes[0], KeyBlock[0], Length(keyBytes));

  for i := 0 to BLOCK_SIZE - 1 do
  begin
    i_key_pad[i] := KeyBlock[i] xor $36;
    o_key_pad[i] := KeyBlock[i] xor $5C;
  end;

  SHA256Init(ctx);
  SHA256Update(ctx, i_key_pad, BLOCK_SIZE);
  SHA256Update(ctx, msgBytes[0], Length(msgBytes));
  SHA256Final(ctx, hash_inner);

  SHA256Init(ctx);
  SHA256Update(ctx, o_key_pad, BLOCK_SIZE);
  SHA256Update(ctx, hash_inner[0], Length(hash_inner));
  SetLength(Result, 32);
  SHA256Final(ctx, Result);
end;
{$ENDIF}

function Base64UrlEncodeBytes(const ABytes: TBytes): string;
var
  S: RawByteString;
begin
  {$IFDEF FPC}
  SetLength(S, Length(ABytes));
  if Length(ABytes) > 0 then
    Move(ABytes[0], S[1], Length(ABytes));
  Result := EncodeStringBase64(S);
  {$ELSE}
  Result := TNetEncoding.Base64.EncodeBytesToString(ABytes);
  {$ENDIF}
  Result := StringReplace(Result, sLineBreak, '', [rfReplaceAll]);
  Result := StringReplace(Result, #13, '', [rfReplaceAll]);
  Result := StringReplace(Result, #10, '', [rfReplaceAll]);
  Result := StringReplace(Result, '+', '-', [rfReplaceAll]);
  Result := StringReplace(Result, '/', '_', [rfReplaceAll]);
  Result := StringReplace(Result, '=', '', [rfReplaceAll]);
end;

function Base64UrlDecodeString(const Input: string): string;
var
  Padded: string;
  PadLen: Integer;
begin
  Padded := Input;
  PadLen := (4 - Length(Padded) mod 4) mod 4;
  Padded := Padded + StringOfChar('=', PadLen);
  Padded := StringReplace(Padded, '-', '+', [rfReplaceAll]);
  Padded := StringReplace(Padded, '_', '/', [rfReplaceAll]);
  {$IFDEF FPC}
  Result := DecodeStringBase64(Padded);
  {$ELSE}
  Result := TEncoding.UTF8.GetString(TNetEncoding.Base64.DecodeStringToBytes(Padded));
  {$ENDIF}
end;

function Base64UrlEncodeString(const AStr: string): string;
begin
  {$IFDEF FPC}
  Result := Base64UrlEncodeBytes(BytesOf(AStr));
  {$ELSE}
  Result := Base64UrlEncodeBytes(TEncoding.UTF8.GetBytes(AStr));
  {$ENDIF}
end;

constructor TPrismSecurityJWT.Create(ASecret: string);
begin
  if ASecret = '' then
    FSecret := GenerateRandomString(64)
  else
    FSecret := ASecret;

  FAlgorithm := JWTHS256;
  FExpirationMinutes := 15;
  FTokenType := JWTTokenAccess;
end;

function TPrismSecurityJWT.Expired(const PayloadJson: string): Boolean;
var
  Json: TJSONObject;
  ExpUnix, NowUnix: Int64;
begin
  Result := True;
  Json := TJSONObject.ParseJSONValue(PayloadJson) as TJSONObject;
  try
    if Json.GetValue('exp', 0) <> 0 then
    begin
      ExpUnix := Json.GetValue('exp', 0);
      NowUnix := DateTimeToUnix(Now);
      Result := NowUnix >= ExpUnix;
    end;
  finally
    Json.Free;
  end;
end;

function TPrismSecurityJWT.GetAlgorithm: TSecurityJWTAlgorithm;
begin
  Result := FAlgorithm;
end;

function TPrismSecurityJWT.GetSecret: string;
begin
  Result := FSecret;
end;

function TPrismSecurityJWT.GetTokenType: TSecurityJWTTokenType;
begin
  Result := FTokenType;
end;

function TPrismSecurityJWT.GetExpirationDays: Integer;
begin
 Result := FExpirationMinutes div MinsPerDay;
end;

function TPrismSecurityJWT.GetExpirationHours: Integer;
begin
 Result := FExpirationMinutes div MinsPerHour;
end;

function TPrismSecurityJWT.GetExpirationMinutes: Integer;
begin
  Result := FExpirationMinutes;
end;

function TPrismSecurityJWT.GetExpirationSeconds: Integer;
begin
 Result := FExpirationMinutes * SecsPerMin;
end;

function TPrismSecurityJWT.HeaderAuthorized(const AuthorizationHeader: string): Boolean;
const
  BearerPrefix = 'Bearer ';
var
  vToken: string;
begin
  Result := False;
  if AuthorizationHeader.StartsWith(BearerPrefix) then
  begin
    vToken := Copy(AuthorizationHeader, Length(BearerPrefix) + 1, MaxInt);
    Result := Valid(vToken);
  end;
end;

function TPrismSecurityJWT.Payload(const AToken: string): string;
var
  Parts: TArray<string>;
begin
  Parts := AToken.Split(['.']);
  if Length(Parts) <> 3 then Exit('');
  Result := Base64UrlDecodeString(Parts[1]);
end;

function TPrismSecurityJWT.Valid(AToken: string): Boolean;
var
  Parts: TArray<string>;
  SigningInput, Signature, ExpectedSignature: string;
  HMACBytes: TBytes;
  PayloadJson: string;
begin
  Result := False;

  if (Secret = AccessJWTDefaultToken) or
     (Secret = RefreshJWTDefaultToken) then
   exit;


  Parts := AToken.Split(['.']);
  if Length(Parts) <> 3 then Exit;

  SigningInput := Parts[0] + '.' + Parts[1];
  Signature := Parts[2];

  if FAlgorithm = JWTHS256 then
  begin
    {$IFDEF FPC}
    HMACBytes := HMAC_SHA256_UTF8Msg_ASCIIKey(SigningInput, Secret);
    {$ELSE}
    HMACBytes := THashSHA2.GetHMACAsBytes(
      TEncoding.UTF8.GetBytes(SigningInput),
      TEncoding.ASCII.GetBytes(Secret),
      SHA256
    );
    {$ENDIF}
  end;

  ExpectedSignature := Base64UrlEncodeBytes(HMACBytes);
  if Signature <> ExpectedSignature then Exit;

  PayloadJson := Base64UrlDecodeString(Parts[1]);
  if Expired(PayloadJson) then Exit;

  Result := True;
end;

procedure TPrismSecurityJWT.SetAlgorithm(const Value: TSecurityJWTAlgorithm);
begin
  FAlgorithm := Value;
end;

procedure TPrismSecurityJWT.SetSecret(const Value: string);
begin
  FSecret := Value;
end;

procedure TPrismSecurityJWT.SetTokenType(const Value: TSecurityJWTTokenType);
begin
  FTokenType := Value;
end;

procedure TPrismSecurityJWT.SetExpirationDays(const Value: Integer);
begin
 FExpirationMinutes:= Value * MinsPerDay;
end;

procedure TPrismSecurityJWT.SetExpirationHours(const Value: Integer);
begin
 FExpirationMinutes:= Value * MinsPerHour;
end;

procedure TPrismSecurityJWT.SetExpirationMinutes(const Value: Integer);
begin
  FExpirationMinutes := Value;
end;

procedure TPrismSecurityJWT.SetExpirationSeconds(const Value: Integer);
begin
 FExpirationMinutes:= Value div SecsPerMin;
end;

function TPrismSecurityJWT.Token(ASub, AIdentity: string): string;
var
  vPayload: TJSONObject;
begin
  vPayload := TJSONObject.Create;
  vPayload.AddPair('sub', ASub);
  vPayload.AddPair('iss', 'D2Bridge access JWT');
  vPayload.AddPair('iat', {$IFnDEF FPC}TJSONNumber.Create({$ENDIF}DateTimeToUnix(Now){$IFnDEF FPC}){$ENDIF});
  vPayload.AddPair('exp', {$IFnDEF FPC}TJSONNumber.Create({$ENDIF}DateTimeToUnix(IncMinute(Now, FExpirationMinutes)){$IFnDEF FPC}){$ENDIF});
  if FTokenType = JWTTokenRefresh then
    vPayload.AddPair('token_type', 'refresh')
  else
    vPayload.AddPair('token_type', 'access');

  if AIdentity <> '' then
  begin
    {$IFDEF FPC}
    AIdentity := EncodeStringBase64(AIdentity);
    {$ELSE}
    AIdentity := TNetEncoding.Base64.Encode(AIdentity);
    {$ENDIF}
    vPayload.AddPair('identity', AIdentity);
  end;

  Result := Token(vPayload);
  vPayload.Free;
end;

function TPrismSecurityJWT.Token(APayload: TJSONObject): string;
var
 vHeader: string;
 EncHeader, EncPayload, SigningInput, Signature: string;
 HMACBytes: TBytes;
begin
 if FAlgorithm = JWTHS256 then
  vHeader:= '{"alg":"HS256","typ":"JWT"}';

 {$IFDEF FPC}
 APayload.CompressedJSON:= true;
 EncHeader := Base64UrlEncodeString(vHeader);
 EncPayload := Base64UrlEncodeString(APayload.AsJSON);
 {$ELSE}
 EncHeader := Base64UrlEncodeString(vHeader);
 EncPayload := Base64UrlEncodeString(APayload.ToJSON);
 {$ENDIF}

  SigningInput := EncHeader + '.' + EncPayload;

  {$IFDEF FPC}
  HMACBytes := HMAC_SHA256_UTF8Msg_ASCIIKey(SigningInput, Secret);
  {$ELSE}
  HMACBytes := THashSHA2.GetHMACAsBytes(
    TEncoding.UTF8.GetBytes(SigningInput),
    TEncoding.ASCII.GetBytes(Secret),
    SHA256
  );
  {$ENDIF}

  Signature := Base64UrlEncodeBytes(HMACBytes);
  Result := SigningInput + '.' + Signature;
end;

end.