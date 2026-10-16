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

unit D2Bridge.Rest.Request;

interface

uses
  Classes, SysUtils, Generics.Collections, DateUtils,
{$IFNDEF FPC}
  NetEncoding,
{$ELSE}
  base64,
{$ENDIF}
  D2Bridge.JSON,
  Prism.Server.HTTP.Commom,
  Prism.Types,
  D2Bridge.Rest.Interfaces;


type
 TD2BridgeRestRequest = class(TInterfacedPersistent, ID2BridgeRestRequest)
  private
   FEndPoint: string;
   FAuthTokenBearer: string;
   FContentType: string;
   FUserAgent: string;
   FHeaders: TStringList;
   FParams: TStringList;
   FQueryString: TStringList;
   FAuthorization: string;
   FBody: string;
   FHost: string;
   FWebMethod: TPrismWebMethod;
   function BuildQueryString: string;
   function BuildParams: string;
   function GetEndPoint: string;
   function GetAuthTokenBearer: string;
   function GetContentType: string;
   function GetHost: string;
   function GetUserAgent: string;
   function GetWebMethod: TPrismWebMethod;
   procedure SetEndPoint(const Value: string);
   procedure SetAuthTokenBearer(const Value: string);
   procedure SetContentType(const Value: string);
   procedure SetHost(const Value: string);
   procedure SetUserAgent(const Value: string);
   procedure SetWebMethod(const Value: TPrismWebMethod);
  public
   constructor Create(AEndPoint: string; AWebMethod: TPrismWebMethod = TPrismWebMethod.wmtGET);
   constructor CreateGET(AEndPoint: string);
   constructor CreatePOST(AEndPoint: string);
   constructor CreatePUT(AEndPoint: string);
   constructor CreatePATCH(AEndPoint: string);
   constructor CreateDELETE(AEndPoint: string);
   destructor Destroy; override;

   function RawRequest: string;

   procedure AuthBasic(AUserName, APassword: string);

   procedure AddHeader(const AName, AValue: string);
   procedure AddParam(const AName, AValue: string);
   procedure AddQuery(const AName, AValue: string);

   procedure Body(const AText: string); overload;
   procedure Body(const AStream: TStream); overload;
   procedure SetBodyFromFile(const AFileName: string);

   function Send: TPrismHTTPResponse; overload;
   procedure Send(out AResponse: TPrismHTTPResponse); overload;

   procedure WebMethodGet;
   procedure WebMethodPost;
   procedure WebMethodPut;
   procedure WebMethodPatch;
   procedure WebMethodDelete;

   property EndPoint: string read GetEndPoint write SetEndPoint;
   property AuthTokenBearer: string read GetAuthTokenBearer write SetAuthTokenBearer;
   property ContentType: string read GetContentType write SetContentType;
   property Host: string read GetHost write SetHost;
   property UserAgent: string read GetUserAgent write SetUserAgent;
   property WebMethod: TPrismWebMethod read GetWebMethod write SetWebMethod;

 end;

implementation

Uses
 D2Bridge.Rest;

{ TD2BridgeRestRequest }

{$IFDEF FPC}
procedure EncodeStreamBase64(InputStream, OutputStream: TStream);
const
  Base64Table: string = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
var
  InBuffer: array[0..2] of Byte;
  OutBuffer: array[0..3] of Char;
  BytesRead, i: Integer;
begin
  while True do
  begin
    BytesRead := InputStream.Read(InBuffer, 3);
    if BytesRead = 0 then
      Break;

    // Zera bytes restantes se não forem lidos todos
    for i := BytesRead to 2 do
      InBuffer[i] := 0;

    OutBuffer[0] := Base64Table[(InBuffer[0] shr 2) + 1];
    OutBuffer[1] := Base64Table[(((InBuffer[0] and $03) shl 4) or (InBuffer[1] shr 4)) + 1];
    if BytesRead > 1 then
      OutBuffer[2] := Base64Table[(((InBuffer[1] and $0F) shl 2) or (InBuffer[2] shr 6)) + 1]
    else
      OutBuffer[2] := '=';

    if BytesRead > 2 then
      OutBuffer[3] := Base64Table[(InBuffer[2] and $3F) + 1]
    else
      OutBuffer[3] := '=';

    OutputStream.WriteBuffer(OutBuffer, 4);
  end;
end;


function EncodeBytesBase64(const ABytes: TBytes): string;
var
  InputStream, OutputStream: TMemoryStream;
  StringStream: TStringStream;
begin
  InputStream := TMemoryStream.Create;
  OutputStream := TMemoryStream.Create;
  try
    InputStream.WriteBuffer(ABytes[0], Length(ABytes));
    InputStream.Position := 0;

    EncodeStreamBase64(InputStream, OutputStream);
    OutputStream.Position := 0;

    StringStream := TStringStream.Create('');
    try
      StringStream.CopyFrom(OutputStream, OutputStream.Size);
      Result := Trim(StringStream.DataString);
    finally
      StringStream.Free;
    end;
  finally
    InputStream.Free;
    OutputStream.Free;
  end;
end;
{$ENDIF}

procedure TD2BridgeRestRequest.AddHeader(const AName, AValue: string);
begin
 FHeaders.Values[AName] := AValue;
end;

procedure TD2BridgeRestRequest.AddParam(const AName, AValue: string);
begin
 FParams.Values[AName] := AValue;
end;

procedure TD2BridgeRestRequest.AddQuery(const AName, AValue: string);
begin
 FQueryString.Values[AName] := AValue;
end;

procedure TD2BridgeRestRequest.AuthBasic(AUserName, APassword: string);
var
 Credentials, Encoded: string;
begin
 Credentials := AUserName + ':' + APassword;

{$IFnDEF FPC}
 Encoded := TNetEncoding.Base64.Encode(Credentials);
{$ELSE}
 Encoded := EncodeStringBase64(Credentials);
{$ENDIF}

 FAuthorization := 'Basic ' + Encoded;
end;

procedure TD2BridgeRestRequest.Body(const AStream: TStream);
var
  SL: TStringList;
begin
  AStream.Position := 0;

  SL := TStringList.Create;
  try
    SL.LoadFromStream(AStream, TEncoding.UTF8); // usa UTF-8 para compatibilidade com JSON
    FBody := SL.Text;
  finally
    SL.Free;
  end;
end;

function TD2BridgeRestRequest.BuildParams: string;
var
  ResultPath: string;
  ParamName, ParamValue: string;
  I: Integer;
begin
  ResultPath := FEndPoint;

  for I := 0 to FParams.Count - 1 do
  begin
    ParamName := FParams.Names[I];
    ParamValue := FParams.ValueFromIndex[I];

    // Substitui :param
    ResultPath := StringReplace(ResultPath, ':' + ParamName, ParamValue, [rfReplaceAll, rfIgnoreCase]);

    // Substitui {param}
    ResultPath := StringReplace(ResultPath, '{' + ParamName + '}', ParamValue, [rfReplaceAll, rfIgnoreCase]);

    // Substitui <param>
    ResultPath := StringReplace(ResultPath, '<' + ParamName + '>', ParamValue, [rfReplaceAll, rfIgnoreCase]);
  end;

  Result := ResultPath;
end;

function TD2BridgeRestRequest.BuildQueryString: string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to FQueryString.Count - 1 do
  begin
    if I > 0 then
      Result := Result + '&';
    Result := Result + FQueryString.Names[I] + '=' + FQueryString.ValueFromIndex[I];
  end;

  if Result <> '' then
    Result := '?' + Result;
end;

procedure TD2BridgeRestRequest.Body(const AText: string);
begin
 FBody:= Atext;
end;

constructor TD2BridgeRestRequest.Create(AEndPoint: string; AWebMethod: TPrismWebMethod = TPrismWebMethod.wmtGET);
begin
 inherited Create;

 WebMethod:= AWebMethod;
 EndPoint:= AEndPoint;

 FHost:= 'localhost';

 FUserAgent:= 'D2Bridge Restful Internal';

 FHeaders := TStringList.Create;
 FParams := TStringList.Create;
 FQueryString := TStringList.Create;

 FHeaders.Sorted := false;
 FHeaders.Duplicates := dupAccept;
 FHeaders.CaseSensitive := False;

 FParams.Sorted := false;
 FParams.Duplicates := dupAccept;
 FParams.CaseSensitive := False;

 FQueryString.Sorted := false;
 FQueryString.Duplicates := dupAccept;
 FQueryString.CaseSensitive := False;
end;

constructor TD2BridgeRestRequest.CreateDELETE(AEndPoint: string);
begin
 Create(AEndPoint, TPrismWebMethod.wmtDELETE);
end;

constructor TD2BridgeRestRequest.CreateGET(AEndPoint: string);
begin
 Create(AEndPoint, TPrismWebMethod.wmtGET);
end;

constructor TD2BridgeRestRequest.CreatePATCH(AEndPoint: string);
begin
 Create(AEndPoint, TPrismWebMethod.wmtPATCH);
end;

constructor TD2BridgeRestRequest.CreatePost(AEndPoint: string);
begin
 Create(AEndPoint, TPrismWebMethod.wmtPOST);
end;

constructor TD2BridgeRestRequest.CreatePUT(AEndPoint: string);
begin
 Create(AEndPoint, TPrismWebMethod.wmtPUT);
end;

destructor TD2BridgeRestRequest.Destroy;
begin
 FHeaders.Free;
 FParams.Free;
 FQueryString.Free;

 inherited;
end;

function TD2BridgeRestRequest.GetEndPoint: string;
begin
 Result := FEndPoint;
end;

function TD2BridgeRestRequest.GetAuthTokenBearer: string;
begin
 Result := FAuthTokenBearer;
end;

function TD2BridgeRestRequest.GetContentType: string;
begin
 Result := FContentType;
end;

function TD2BridgeRestRequest.GetHost: string;
begin
 Result := FHost;
end;

function TD2BridgeRestRequest.GetUserAgent: string;
begin
 Result := FUserAgent;
end;

function TD2BridgeRestRequest.GetWebMethod: TPrismWebMethod;
begin
 Result := FWebMethod;
end;

function TD2BridgeRestRequest.RawRequest: string;
var
 LineBreak: string;
 Raw: TStringList;
 FullPath: string;
 I: Integer;
 vWebMethodStr: string;
begin
 LineBreak := sLineBreak;
 Raw := TStringList.Create;
 try
   vWebMethodStr:= 'GET';

   // Monta o path com parâmetros e query string
   FullPath := BuildParams + BuildQueryString;

   // Primeira linha do request
   if WebMethod = TPrismWebMethod.wmtGET then
    vWebMethodStr:= 'GET'
   else
    if WebMethod = TPrismWebMethod.wmtPOST then
     vWebMethodStr:= 'POST'
    else
     if WebMethod = TPrismWebMethod.wmtPUT then
      vWebMethodStr:= 'PUT'
     else
      if WebMethod = TPrismWebMethod.wmtDELETE then
       vWebMethodStr:= 'DELETE'
      else
       if WebMethod = TPrismWebMethod.wmtPATCH then
        vWebMethodStr:= 'PATCH'
       else
        if WebMethod = TPrismWebMethod.wmtHEAD then
         vWebMethodStr:= 'HEAD';


    Raw.Add(vWebMethodStr + ' ' + FullPath + ' HTTP/1.1');

   // Cabeçalhos padrão
   Raw.Add('Host: ' + FHost);
   if FUserAgent <> '' then
     Raw.Add('User-Agent: ' + FUserAgent);
   if FContentType <> '' then
     Raw.Add('Content-Type: ' + FContentType);
   if FAuthTokenBearer <> '' then
   begin
     FAuthTokenBearer:= StringReplace(FAuthTokenBearer, 'Bearer ', '', [rfIgnoreCase]);
     Raw.Add('Authorization: Bearer ' + FAuthTokenBearer);
   end else
   if FAuthorization <> '' then
     Raw.Add('Authorization: ' + FAuthorization);

   // Headers adicionais
   for I := 0 to FHeaders.Count - 1 do
     Raw.Add(FHeaders.Names[I] + ': ' + FHeaders.ValueFromIndex[I]);

   // Linha em branco separando headers do body
   Raw.Add('');

   // Corpo
   if FBody <> '' then
     Raw.Add(FBody);

   Result := Raw.Text;
 finally
   Raw.Free;
 end;
end;

procedure TD2BridgeRestRequest.SetEndPoint(const Value: string);
begin
 FEndPoint := Value;
end;

function TD2BridgeRestRequest.Send: TPrismHTTPResponse;
begin
 result:= D2BridgeRest.Client.Send(self);
end;

procedure TD2BridgeRestRequest.WebMethodGet;
begin
 WebMethod:= TPrismWebMethod.wmtGET;
end;

procedure TD2BridgeRestRequest.Send(out AResponse: TPrismHTTPResponse);
begin
 AResponse:= Send;
end;

procedure TD2BridgeRestRequest.SetAuthTokenBearer(const Value: string);
begin
 FAuthTokenBearer := Value;
end;

procedure TD2BridgeRestRequest.SetBodyFromFile(const AFileName: string);
var
  FileStream: TFileStream;
  Bytes: TBytes;
  Encoded: string;
begin
  FileStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    SetLength(Bytes, FileStream.Size);
    FileStream.ReadBuffer(Bytes[0], FileStream.Size);

    {$IFDEF FPC}
    Encoded := EncodeBytesBase64(Bytes);
    {$ELSE}
    Encoded := TNetEncoding.Base64.EncodeBytesToString(Bytes);
    {$ENDIF}

    FBody := Encoded;
  finally
    FileStream.Free;
  end;
end;


procedure TD2BridgeRestRequest.SetContentType(const Value: string);
begin
 FContentType := Value;
end;

procedure TD2BridgeRestRequest.WebMethodDelete;
begin
 WebMethod:= TPrismWebMethod.wmtDELETE;
end;

procedure TD2BridgeRestRequest.SetHost(const Value: string);
begin
 FHost := Value;
end;

procedure TD2BridgeRestRequest.WebMethodPatch;
begin
 WebMethod:= TPrismWebMethod.wmtPATCH;
end;

procedure TD2BridgeRestRequest.WebMethodPost;
begin
 WebMethod:= TPrismWebMethod.wmtPOST;
end;

procedure TD2BridgeRestRequest.WebMethodPut;
begin
 WebMethod:= TPrismWebMethod.wmtPUT;
end;

procedure TD2BridgeRestRequest.SetUserAgent(const Value: string);
begin
 FUserAgent := Value;
end;

procedure TD2BridgeRestRequest.SetWebMethod(const Value: TPrismWebMethod);
begin
 FWebMethod := Value;
end;

end.