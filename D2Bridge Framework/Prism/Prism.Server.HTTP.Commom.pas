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

unit Prism.Server.HTTP.Commom;

interface

uses
  Classes, SysUtils, DateUtils, Generics.Collections,
  IdIOHandler,
  D2Bridge.JSON, Prism.Util,
  Prism.Types;

type
 TPrismHTTPRequest = class
  private
   FAppBase: string;
   FBody: string;
   FBodyJSON: TJSONObject;
   FBodyJSONArray: TJSONArray;
   procedure SetBody(const Value: string);
   function GetBody: string;
   function GetAppBase: string;
   procedure SetAppBase(const Value: string);
  public
   Authorization: string;
   AuthorizationType: string;
   User: string;
   Password: string;
   JWTtoken: string;
   JWTvalid: boolean;
   JWTPayLoad: string;
   JWTsub: string;
   JWTidentity: string;
   JWTTokenType: TSecurityJWTTokenType;
   WebMethod: TPrismWebMethod;
   Protocol: string;
   Path: string;
   Host: string;
   ServerPort : Integer;
   ForwardedIP: string;
   RemoteIP: string;
   RemotePort: Integer;
   RawHeaders: TStrings;
   QueryParams: TStrings;
   RefererQueryParams: TStrings;
   Params: TStrings;
   Pragma: string;
   CacheControl: string;
   UserAgent: string;
   UserAgentBlocked: boolean;
   Origin: string;
   Accept: string;
   AcceptEncoding: string;
   AcceptLanguage: string;
   ContentType: string;
   ContentLength: string;
   Content: string;
   Referer: string;
   Purpose: string;
   IsUploadFile: Boolean;
   FileName: string;
   ReloadPage: Boolean;
   D2BridgeToken: string;
   SessionUUID: string;
   ServerUUID: string;
   Cookies: string;
   //WebSocket
   Connection: string;
   Upgrade: string;
   SecWebSocketKey: string;
   Boundary: string;
   IPListedInBlackList: boolean;
   TooManyConnFromIP: boolean;
   InternalRequest: Boolean;
   Route: TObject;
   IOHandler: TIdIOHandler;

   constructor Create;
   destructor Destroy; override;

   function ServerURL: string;
   function FullURL: string;
   function URL: string;
   function PathWithoutParams: string;

   function Param(AName: string): string; overload;
   function ParamInt(AName: string): integer; overload;
   function ParamCount: integer;
   function ExistParam(AName: string): boolean;

   function Query(AName: string): string; overload;
   function QueryInt(AName: string): integer; overload;
   function QueryCount: integer;
   function ExistQuery(AName: string): boolean;

   function ClientIP: string;

   function BodyJSON: TJSONObject;
   function BodyJSONArray: TJSONArray;
   function BodyIsJSONValue: Boolean;

   property Body: string read GetBody write SetBody;
   property AppBase: string read GetAppBase write SetAppBase;
 end;



// TPrismHTTPRequest = class(TPrismHTTPRequest)
//  public
//   constructor Create;
//   destructor Destroy; override;
// end;


 TPrismHTTPResponse = class
  strict private
  private
   FContent: string;
   FRedirect: string;
   FJSON: TJSONObject;
   FJSONArray: TJSONArray;
   function GetJSONObjResponse: TJSONObject;
   function GetJSONArrayResponse: TJSONArray;
   function GetContent: string;
   procedure SetContent(const Value: string);
   function GetRedirect: string;
   procedure SetRedirect(const Value: string);
  public
   Headers: TStrings;
   ContentType: string;
   StatusCode: variant;
   StatusMessage: string;
   charset: string;
   FileName: string;
   Error: boolean;
   ErrorMessage: string;
   InitializedJSON: Boolean;
   IsJSONArray: boolean;

   constructor Create;
   destructor Destroy; override;

   function JSON: TJSONObject; overload;
   function AsJSONArray: TJSONArray;

   property Content: string read GetContent write SetContent;
   property Redirect: string read GetRedirect write SetRedirect;
 end;


 TPrismWebSocketMessage = class
  private

  public
   IsFormatted: boolean;
   RawMessage: String;
   MessageType: TWebSocketMessageType;
   Name: String;
   Parameters: TDictionary<string, string>;
   Wait: boolean;

   constructor Create;
   destructor Destroy; override;
 end;


 TPrismServerFileExtensions = class
  private
   const
    defaultMimeType = 'application/octet-stream';
   var
   FExtentions: TDictionary<string, string>;
  public
   constructor Create;
   destructor Destroy; override;

   function GetMimeType(AFileName: string): string;
   procedure Add(AExtension, MimeType: string);
 end;

type
  THTMLStatusCodeMap = record
    Code: Integer;
    Text: string;
  end;

const
  HTMLStatusCodeMap: array[0..61] of THTMLStatusCodeMap = (
    (Code: 100; Text: 'Continue'),
    (Code: 101; Text: 'Switching Protocols'),
    (Code: 102; Text: 'Processing'),
    (Code: 103; Text: 'Early Hints'),

    (Code: 200; Text: 'OK'),
    (Code: 201; Text: 'Created'),
    (Code: 202; Text: 'Accepted'),
    (Code: 203; Text: 'Non-Authoritative Information'),
    (Code: 204; Text: 'No Content'),
    (Code: 205; Text: 'Reset Content'),
    (Code: 206; Text: 'Partial Content'),
    (Code: 207; Text: 'Multi-Status'),
    (Code: 208; Text: 'Already Reported'),
    (Code: 226; Text: 'IM Used'),

    (Code: 300; Text: 'Multiple Choices'),
    (Code: 301; Text: 'Moved Permanently'),
    (Code: 302; Text: 'Found'),
    (Code: 303; Text: 'See Other'),
    (Code: 304; Text: 'Not Modified'),
    (Code: 305; Text: 'Use Proxy'),
    (Code: 307; Text: 'Temporary Redirect'),
    (Code: 308; Text: 'Permanent Redirect'),

    (Code: 400; Text: 'Bad Request'),
    (Code: 401; Text: 'Unauthorized'),
    (Code: 402; Text: 'Payment Required'),
    (Code: 403; Text: 'Forbidden'),
    (Code: 404; Text: 'Not Found'),
    (Code: 405; Text: 'Method Not Allowed'),
    (Code: 406; Text: 'Not Acceptable'),
    (Code: 407; Text: 'Proxy Authentication Required'),
    (Code: 408; Text: 'Request Timeout'),
    (Code: 409; Text: 'Conflict'),
    (Code: 410; Text: 'Gone'),
    (Code: 411; Text: 'Length Required'),
    (Code: 412; Text: 'Precondition Failed'),
    (Code: 413; Text: 'Payload Too Large'),
    (Code: 414; Text: 'URI Too Long'),
    (Code: 415; Text: 'Unsupported Media Type'),
    (Code: 416; Text: 'Range Not Satisfiable'),
    (Code: 417; Text: 'Expectation Failed'),
    (Code: 418; Text: 'I''m a teapot'),
    (Code: 421; Text: 'Misdirected Request'),
    (Code: 422; Text: 'Unprocessable Entity'),
    (Code: 423; Text: 'Locked'),
    (Code: 424; Text: 'Failed Dependency'),
    (Code: 425; Text: 'Too Early'),
    (Code: 426; Text: 'Upgrade Required'),
    (Code: 428; Text: 'Precondition Required'),
    (Code: 429; Text: 'Too Many Requests'),
    (Code: 431; Text: 'Request Header Fields Too Large'),
    (Code: 451; Text: 'Unavailable For Legal Reasons'),

    (Code: 500; Text: 'Internal Server Error'),
    (Code: 501; Text: 'Not Implemented'),
    (Code: 502; Text: 'Bad Gateway'),
    (Code: 503; Text: 'Service Unavailable'),
    (Code: 504; Text: 'Gateway Timeout'),
    (Code: 505; Text: 'HTTP Version Not Supported'),
    (Code: 506; Text: 'Variant Also Negotiates'),
    (Code: 507; Text: 'Insufficient Storage'),
    (Code: 508; Text: 'Loop Detected'),
    (Code: 510; Text: 'Not Extended'),
    (Code: 511; Text: 'Network Authentication Required')
  );

function HttpParseStatusCode(const AStatusCode: string): string;

implementation

Uses
 Prism.BaseClass;

{ TPrismHTTPRequest }

//constructor TPrismHTTPRequest.Create;
//begin
//end;
//
//destructor TPrismHTTPRequest.Destroy;
//begin
// inherited;
//end;

{ TPrismHTTPRequest }

function TPrismHTTPRequest.BodyIsJSONValue: Boolean;
begin
 result:= IsJSONValid(Body);
end;

function TPrismHTTPRequest.BodyJSON: TJSONObject;
begin
 if not Assigned(FBodyJSON) then
 begin
  FBodyJSON:= TJSONObject.ParseJSONValue(Body) as TJSONObject;
 end;

 result:= FBodyJSON;
end;

function TPrismHTTPRequest.BodyJSONArray: TJSONArray;
begin
 if not Assigned(FBodyJSONArray) then
 begin
  FBodyJSONArray:= TJSONObject.ParseJSONValue(Body) as TJSONArray;
 end;

 result:= FBodyJSONArray;
end;

function TPrismHTTPRequest.ClientIP: string;
begin
 result:= '';

 if ForwardedIP <> '' then
  result:= ForwardedIP
 else
  result:= RemoteIP;
end;

constructor TPrismHTTPRequest.Create;
begin
 inherited;

 FAppBase:= '/';
 JWTvalid:= false;
 JWTTokenType:= TSecurityJWTTokenType.JWTTokenAccess;
 RawHeaders:= TStringList.Create;
 QueryParams:= TStringList.Create;
 Params:= TStringList.Create;
 RefererQueryParams:= TStringList.Create;
 ReloadPage:= false;
 IPListedInBlackList:= false;
 UserAgentBlocked:= false;
 TooManyConnFromIP:= false;
 IsUploadFile:= false;
 FBody:= '';
 FAppBase:= '';
 Route:= nil;
 FBodyJSON:= nil;
 FBodyJSONArray:= nil;
end;

destructor TPrismHTTPRequest.Destroy;
begin
 RawHeaders.Free;
 QueryParams.Free;
 RefererQueryParams.Free;
 Params.Free;

 try
  if Assigned(FBodyJSON) then
   FBodyJSON.Free;

  if Assigned(FBodyJSONArray) then
   FBodyJSONArray.Free;
 except
 end;

 inherited;
end;

function TPrismHTTPRequest.ExistParam(AName: string): boolean;
begin
 result:= Params.IndexOfName(AName) >= 0;
end;

function TPrismHTTPRequest.ExistQuery(AName: string): boolean;
begin
 result:= QueryParams.IndexOfName(AName) >= 0;
end;

function TPrismHTTPRequest.FullURL: string;
begin
 result:= Protocol + '://' + Host + Path;
end;

function TPrismHTTPRequest.GetAppBase: string;
begin
 if FAppBase <> '' then
 begin
  if not FAppBase.StartsWith('/') then
  begin
   result:= '/' +  FAppBase;

   if not FAppBase.EndsWith('/') then
    result:=  Copy(result, 1, Length(result) - 1);
  end else
   result:= FAppBase;
 end else
  result:= '/';
end;

function TPrismHTTPRequest.GetBody: string;
var
 vContentLength: integer;
begin
 try
  if FBody = '' then
   if TryStrToInt(ContentLength, vContentLength) then
    if Assigned(IOHandler) then
     if vContentLength > 0 then
      FBody:= PrismBaseClass.PrismServer.ReadBodyStringFromData(IOHandler, vContentLength);
 except
 end;

 result:= FBody;
end;

function TPrismHTTPRequest.Param(AName: string): string;
begin
 result:= '';

 if ExistParam(AName) then
  result:= Params.Values[AName]
end;

function TPrismHTTPRequest.ParamCount: integer;
begin
 result:= Params.Count;
end;

function TPrismHTTPRequest.ParamInt(AName: string): integer;
begin
 result:= 0;

 TryStrToInt(Param(AName), result);
end;

function TPrismHTTPRequest.PathWithoutParams: string;
var
 vPathWithoutParams: string;
begin
 if AnsiPos('?', Path) > 0 then
  vPathWithoutParams:= Copy(Path, 1, AnsiPos('?', Path)-1)
 else
  vPathWithoutParams:= Path;

 Result:= vPathWithoutParams;
end;

function TPrismHTTPRequest.ServerURL: string;
begin
 result:= Protocol + '://' + Host + AppBase;
end;

procedure TPrismHTTPRequest.SetAppBase(const Value: string);
begin
 FAppBase:= Value;
end;

function TPrismHTTPRequest.Query(AName: string): string;
begin
 result:= '';

 if ExistQuery(AName) then
  result:= QueryParams.Values[AName]
end;

function TPrismHTTPRequest.QueryCount: integer;
begin
 result:= QueryParams.Count;
end;

function TPrismHTTPRequest.QueryInt(AName: string): integer;
begin
 result:= 0;

 TryStrToInt(Query(AName), result);
end;

procedure TPrismHTTPRequest.SetBody(const Value: string);
begin
 FBody:= Value;
end;

function TPrismHTTPRequest.URL: string;
begin
 if ((Protocol = 'https') and (ServerPort <> 443)) and
    ((Protocol = 'http') and (ServerPort <> 80)) then
  result:= Protocol + '://' + Host + ':' + IntToStr(ServerPort) + PathWithoutParams
 else
  result:= Protocol + '://' + Host + PathWithoutParams;
end;

{ TPrismHTTPResponse }

constructor TPrismHTTPResponse.Create;
begin
 Headers:= TStringList.Create;

 FJSON:= nil;
 FJSONArray:= nil;

 ContentType:= 'text/html';
 charset:= 'UTF-8';
 StatusCode:= '200';
 Error:= false;
 InitializedJSON:= false;
 IsJSONArray:= false;
end;

destructor TPrismHTTPResponse.Destroy;
begin
 Headers.Free;

 try
  if Assigned(FJSON) then
   FJSON.Free;
 except
 end;

 try
  if Assigned(FJSONArray) then
   FJSONArray.Free;
 except
 end;

 inherited;
end;

function TPrismHTTPResponse.GetContent: string;
begin
// Result:= '';
//
// if FContent = '' then
// begin
//  if Assigned(FJSON) then
//   result:= FJSON.ToJSON;
// end else
//  Result:= FContent;
 Result:= FContent;
end;

function TPrismHTTPResponse.GetJSONObjResponse: TJSONObject;
begin
 if not Assigned(FJSON) then
 begin
  InitializedJSON:= true;
  FJSON:= TJSONObject.Create;
  ContentType:= 'application/json';
 end;

 result:= FJSON;
end;

function TPrismHTTPResponse.GetRedirect: string;
begin
 result:= FRedirect;
end;

function TPrismHTTPResponse.GetJSONArrayResponse: TJSONArray;
begin
 if not Assigned(FJSONArray) then
 begin
  FJSONArray:= TJSONArray.Create;
 end else
 begin
  FJSONArray.Free;
  FJSONArray:= TJSONArray.Create;
 end;

 try
  if IsJSONArray then
   FJSONArray.Add(JSON.GetValue('jsonarray').NewClone as TJSONArray);
 except
 end;

 result:= FJSONArray;
end;

function TPrismHTTPResponse.JSON: TJSONObject;
begin
 result:= GetJSONObjResponse;
end;

function TPrismHTTPResponse.AsJSONArray: TJSONArray;
begin
 result:= GetJSONArrayResponse;
end;

procedure TPrismHTTPResponse.SetContent(const Value: string);
begin
 FContent:= Value;
end;

procedure TPrismHTTPResponse.SetRedirect(const Value: string);
begin
 FRedirect:= value;
 StatusCode:= '302';
 StatusMessage:= '302 Found';
end;

{ TPrismWebSocketMessage }

constructor TPrismWebSocketMessage.Create;
begin
 Parameters:= TDictionary<string, string>.create;
 IsFormatted:= false;
 Wait:= false;
end;

destructor TPrismWebSocketMessage.Destroy;
begin
 FreeAndNil(Parameters);
 inherited;
end;

{ TPrismServerFileExtensions }

procedure TPrismServerFileExtensions.Add(AExtension, MimeType: string);
begin
 if (FExtentions.Count <= 0) or
    (not FExtentions.ContainsKey(AExtension)) then
  FExtentions.Add(AExtension, MimeType);
end;

constructor TPrismServerFileExtensions.Create;
begin
 FExtentions:= TDictionary<string, string>.Create;

 FExtentions.Add('css','text/css');
 FExtentions.Add('js','text/javascript');
 FExtentions.Add('png','image/png');
 FExtentions.Add('txt','text/html');
 FExtentions.Add('html','text/html');
 FExtentions.Add('htm','text/html');
 FExtentions.Add('jpg','image/jpeg');
 FExtentions.Add('jpeg','image/jpeg');
 FExtentions.Add('jpe','image/jpeg');
 FExtentions.Add('gif','image/gif');
 FExtentions.Add('woff','application/font-woff');
 FExtentions.Add('svgz','image/svg+xml');
 FExtentions.Add('svg','image/svg+xml');
 FExtentions.Add('woff2','application/font-woff2');
 FExtentions.Add('pdf','application/pdf');
 FExtentions.Add('bmp','image/bmp');
 FExtentions.Add('tiff','image/tiff');
 FExtentions.Add('tif','image/tiff');
 FExtentions.Add('ico','image/vnd.microsoft.icon');
 FExtentions.Add('mp3','audio/mpeg');
 FExtentions.Add('wav','audio/wav');
 FExtentions.Add('mp4','video/mp4');
 FExtentions.Add('mjs','application/javascript');
 FExtentions.Add('zip','application/zip');
 FExtentions.Add('exe','application/x-executable');
 FExtentions.Add('webp','image/webp');

end;

destructor TPrismServerFileExtensions.Destroy;
begin
 FreeAndNil(FExtentions);

 inherited;
end;

function TPrismServerFileExtensions.GetMimeType(AFileName: string): string;
begin
 if (not FExtentions.Count <= 0) and
    FExtentions.ContainsKey(Copy(ExtractFileExt(AFileName),2)) then
  result:= FExtentions[Copy(ExtractFileExt(AFileName),2)]
 else
  result:= defaultMimeType;
end;

function HttpParseStatusCode(const AStatusCode: string): string;
var
  I, Code: Integer;
begin
  if not TryStrToInt(AStatusCode, Code) then
    Code := 404; // default fallback if parsing fails

  for I := Low(HTMLStatusCodeMap) to High(HTMLStatusCodeMap) do
  begin
    if HTMLStatusCodeMap[I].Code = Code then
      Exit(IntToStr(Code) + ' ' + HTMLStatusCodeMap[I].Text);
  end;

  // fallback if code not in known list
  Result := IntToStr(Code) + ' Unknown Status';
end;

end.