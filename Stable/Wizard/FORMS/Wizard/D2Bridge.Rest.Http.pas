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


unit D2Bridge.Rest.Http;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, DB,
{$IFnDEF FMX}
  Dialogs,
{$ELSE}
{$ENDIF}
{$IFnDEF FPC}
  Net.HttpClient, Net.URLClient, System.NetEncoding,
{$ELSE}
  jsonparser, base64, fphttpclient, URIParser, opensslsockets,
{$ENDIF}
{$IFnDEF FPC}
  JSON;
{$ELSE}
  fpjson;
{$ENDIF}



type

 { ID2BridgeRestResponse }

 ID2BridgeRestResponse = interface
  ['{497FD4DB-FC0B-41E9-B8C9-29AC808C30BF}']

  function StatusCode: Integer;
  function StatusText: string;

  function Content: string;
  function ContentType: string;
  function ContentLength: Int64;

  function Headers: TStrings;
  function Cookies: TStrings;

  function Success: Boolean;
  function SuccessWithContent: Boolean;	
  function URL: string;
  function Method: string;

  function AsJSONObject: TJSONObject;
  function AsJSONArray: TJSONArray;

  procedure ToDataSet(ADataSet: TDataset); overload;
  procedure ToDataSet(ADataSet: TDataset; ADataArrayName: string); overload;
  procedure ToDataSet(ADataSet: TDataset; ADataArrayName: string; ADataSetChild: TDataset; ADataChildArrayName: string); overload;
  procedure ToDataSet(ADataSet: TDataset; ADataSetChild: TDataset; ADataChildArrayName: string); overload;
 end;



type

 { TD2BridgeRestResponse }

 TD2BridgeRestResponse = class(TInterfacedObject, ID2BridgeRestResponse)
 private
  FStatusCode: Integer;
  FStatusText: string;

  FContent: string;
  FContentType: string;
  FContentLength: Int64;

  FHeaders: TStringList;
  FCookies: TStringList;

  FURL: string;
  FMethod: string;

  FJSONParsed: Boolean;
  FJSONValue: {$IFNDEF FPC}TJSONValue{$ELSE}TJSONData{$ENDIF};

  procedure ParseJSONIfNeeded;

  procedure PopuleDataSet(ADataSet: TDataset; AJSONArray: TJSONArray);
 public
  constructor Create;
  destructor Destroy; override;

  // ID2BridgeRestResponse
  function StatusCode: Integer;
  function StatusText: string;

  function Content: string;
  function ContentType: string;
  function ContentLength: Int64;

  function Headers: TStrings;
  function Cookies: TStrings;

  function Success: Boolean;
  function SuccessWithContent: Boolean;
  function URL: string;
  function Method: string;

  function AsJSONObject: TJSONObject;
  function AsJSONArray: TJSONArray;

  procedure ToDataSet(ADataSet: TDataset); overload;
  procedure ToDataSet(ADataSet: TDataset; ADataArrayName: string); overload;
  procedure ToDataSet(ADataSet: TDataset; ADataArrayName: string; ADataSetChild: TDataset; ADataChildArrayName: string); overload;
  procedure ToDataSet(ADataSet: TDataset; ADataSetChild: TDataset; ADataChildArrayName: string); overload;
 end;






type
 THTTPStatus = record
 public
   // 1xx Informational
   //    const Continue_ = 100;
   //    const SwitchingProtocols = 101;
   //    const Processing = 102;
   //    const EarlyHints = 103;
   // 2xx Success
   const SuccessOK = 200;
   const SuccessCreated = 201;
   const SuccessAccepted = 202;
   const SuccessNonAuthoritativeInformation = 203;
   const SuccessNoContent = 204;
   const SuccessResetContent = 205;
   const SuccessPartialContent = 206;
   const SuccessMultiStatus = 207;
   const SuccessAlreadyReported = 208;
   const SuccessIMUsed = 226;
   // 3xx Redirection
   //    const MultipleChoices = 300;
   //    const MovedPermanently = 301;
   //    const Found = 302;
   //    const SeeOther = 303;
   //    const NotModified = 304;
   //    const UseProxy = 305;
   //    const SwitchProxy = 306; // Unused
   //    const TemporaryRedirect = 307;
   //    const PermanentRedirect = 308;
   // 4xx Client Error
   const ErrorBadRequest = 400;
   const ErrorUnauthorized = 401;
   const ErrorPaymentRequired = 402;
   const ErrorForbidden = 403;
   const ErrorNotFound = 404;
   const ErrorMethodNotAllowed = 405;
   const ErrorNotAcceptable = 406;
   const ErrorProxyAuthenticationRequired = 407;
   const ErrorRequestTimeout = 408;
   const ErrorConflict = 409;
   const ErrorGone = 410;
   const ErrorLengthRequired = 411;
   const ErrorPreconditionFailed = 412;
   const ErrorPayloadTooLarge = 413;
   const ErrorURITooLong = 414;
   const ErrorUnsupportedMediaType = 415;
   const ErrorRangeNotSatisfiable = 416;
   const ErrorExpectationFailed = 417;
   const ErrorImATeapot = 418;
   const ErrorMisdirectedRequest = 421;
   const ErrorUnprocessableEntity = 422;
   const ErrorLocked = 423;
   const ErrorFailedDependency = 424;
   const ErrorTooEarly = 425;
   const ErrorUpgradeRequired = 426;
   const ErrorPreconditionRequired = 428;
   const ErrorTooManyRequests = 429;
   const ErrorRequestHeaderFieldsTooLarge = 431;
   const ErrorUnavailableForLegalReasons = 451;
   // 5xx Server Error
   //    const InternalServerError = 500;
   //    const NotImplemented = 501;
   //    const BadGateway = 502;
   //    const ServiceUnavailable = 503;
   //    const GatewayTimeout = 504;
   //    const HTTPVersionNotSupported = 505;
   //    const VariantAlsoNegotiates = 506;
   //    const InsufficientStorage = 507;
   //    const LoopDetected = 508;
   //    const NotExtended = 510;
   //    const NetworkAuthenticationRequired = 511;
 end;




type
 TD2BridgeRestClientGetToken = function: string of object;

 TD2BridgeRestClientCore = class;

 { TD2BridgeRestRootClient }
 TD2BridgeRestRootClient = class
  private
   FCore: TD2BridgeRestClientCore;
  public
   constructor Create;
   destructor Destroy; override;

   function Core: TD2BridgeRestClientCore;
 end;


 { TD2BridgeRestClientCore }
 TD2BridgeRestClientCore = class
  private
   FAPI: TObject;
   FProduction: Boolean;
   FURLBaseProduction: string;
   FURLBaseTest: string;
   FFormatSettings: TFormatSettings;
   FOnGetToken: TD2BridgeRestClientGetToken;

   function GetFormatSettings: TFormatSettings;
   procedure SetFormatSettings(const Value: TFormatSettings);
  public
   constructor Create(API: TObject); reintroduce;
   destructor Destroy; override;

   function URLBase: string; virtual;

   procedure SetProductionMode;
   procedure SetTestMode;

   property URLBaseProduction: string read FURLBaseProduction write FURLBaseProduction;
   property URLBaseTest: string read FURLBaseTest write FURLBaseTest;
   property OnGetToken: TD2BridgeRestClientGetToken read FOnGetToken write FOnGetToken;

   property FormatSettings: TFormatSettings read GetFormatSettings write SetFormatSettings;
 end;


 { TD2BridgeRestClientModule }
 TD2BridgeRestClientModule = class
  private
   FAPICore: TObject;
  public
   constructor Create(APICore: TObject); reintroduce;
   destructor Destroy; override;

   function Route: string; virtual; abstract;

   function Token: string;

   function FullEndpoint: string;
 end;


//Rest Functions
function BuildURL(const BaseURL: string): string; overload;
function BuildURL(const BaseURL: string; const Segments: array of string): string; overload;
function BuildURL(const BaseURL: string; const Segments: array of string; const AQuerys: array of string): string; overload;
function BuildURL(const BaseURL: string; const ARoute: string; const Segments: array of string): string; overload;
function BuildURL(const BaseURL: string; const ARoute: string; const Segments: array of string; const AQuerys: array of string): string; overload;

function CombineURL(const BaseURL, Endpoint: string): string;

//Method
function RestMethodToJSON(const AURL: string; AHTTPMethod: string; AHearders: TStrings = nil; AJSON: TJSONObject = nil): ID2BridgeRestResponse;
//Get
function RESTGetToJSON(const AURL: string; AHearders: TStrings = nil): ID2BridgeRestResponse; overload;
function RESTGetToJSON(const AURL: string; AToken: string): ID2BridgeRestResponse; overload;
function RESTGetToJSON(const AURL: string; AUser, APassword: string): ID2BridgeRestResponse; overload;
//Post
function RESTPostToJSON(const AURL: string; AJSON: TJSONObject = nil): ID2BridgeRestResponse; overload;
function RESTPostToJSON(const AURL: string; AHearders: TStrings; AJSON: TJSONObject = nil): ID2BridgeRestResponse; overload;
function RESTPostToJSON(const AURL: string; AToken: string; AJSON: TJSONObject = nil): ID2BridgeRestResponse; overload;
function RESTPostToJSON(const AURL, AUser, APassword: string; AJSON: TJSONObject = nil): ID2BridgeRestResponse; overload;
//Put
function RESTPutToJSON(const AURL: string; AJSON: TJSONObject = nil): ID2BridgeRestResponse; overload;
function RESTPutToJSON(const AURL: string; AHearders: TStrings; AJSON: TJSONObject = nil): ID2BridgeRestResponse; overload;
function RESTPutToJSON(const AURL: string; AToken: string; AJSON: TJSONObject = nil): ID2BridgeRestResponse; overload;
function RESTPutToJSON(const AURL, AUser, APassword: string; AJSON: TJSONObject = nil): ID2BridgeRestResponse; overload;
//Delete
function RESTDeleteToJSON(const AURL: string; AJSON: TJSONObject = nil): ID2BridgeRestResponse; overload;
function RESTDeleteToJSON(const AURL: string; AHearders: TStrings; AJSON: TJSONObject = nil): ID2BridgeRestResponse; overload;
function RESTDeleteToJSON(const AURL: string; AToken: string; AJSON: TJSONObject = nil): ID2BridgeRestResponse; overload;
function RESTDeleteToJSON(const AURL, AUser, APassword: string; AJSON: TJSONObject = nil): ID2BridgeRestResponse; overload;
//Patch
function RESTPatchToJSON(const AURL: string; AJSON: TJSONObject = nil): ID2BridgeRestResponse; overload;
function RESTPatchToJSON(const AURL: string; AHearders: TStrings; AJSON: TJSONObject = nil): ID2BridgeRestResponse; overload;
function RESTPatchToJSON(const AURL: string; AToken: string; AJSON: TJSONObject = nil): ID2BridgeRestResponse; overload;
function RESTPatchToJSON(const AURL, AUser, APassword: string; AJSON: TJSONObject = nil): ID2BridgeRestResponse; overload;
//RawFile
function RESTPostRawFile(const AURL: string; const AFileName: string; const AToken: string = ''): ID2BridgeRestResponse;
//Download File
function DownloadFileFromURL(const AURL, ADestFile: string; AToken: string = ''): Boolean;

function GetPrefetch(const AURL: string): string;




//DataSet
function DataSetToJSONArray(ADataSet: TDataSet): TJSONArray; overload;
function DataSetToJSONArray(ADataSet: TDataSet; AExcludeFields: array of string): TJSONArray; overload;
function DataSetToJSON(ADataSet: TDataSet; ADataArrayName: string = 'data'): TJSONObject; overload;
function DataSetToJSON(ADataSet: TDataSet; ADataArrayName: string = 'data'; AExcludeFields: array of string): TJSONObject; overload;
function DataSetRowToJSON(ADataSet: TDataSet): TJSONObject; overload;
function DataSetRowToJSON(ADataSet: TDataSet; AExcludeFields: array of string): TJSONObject; overload;




{$IFDEF FPC}
  { TJSONFloatNumberFixed }
type
  TJSONFloatNumberFixed = class(TJSONFloatNumber)
   public
    function GetAsString: TJSONStringType; override;
  end;
{$ENDIF}



//Event
{$IFnDEF FPC}
type
  THTTPClientHelper = class
  public
    class procedure ValidateServerCertificate(const Sender: TObject;
      const ARequest: TURLRequest; const Certificate: TCertificate;
      var Accepted: Boolean);
  end;
{$ENDIF}


var
  FormatSettings: TFormatSettings;


const
  HTTPStatus: THTTPStatus = ();


implementation

{$IFnDEF FPC}
function EncodeURLElement(const S: string): string;
const
  NotAllowed: TSysCharSet = [';', '/', '?', ':', '@', '=', '&', '#', '+', '_', '<', '>',
                              '"', '%', '{', '}', '|', '\', '^', '~', '[', ']', '`'];
var
  i: Integer;
  c: Char;
begin
  Result := '';
  for i := 1 to Length(S) do
  begin
    c := S[i];
    if (Ord(c) <= $20) or (Ord(c) >= $7F) or (c in NotAllowed) then
      Result := Result + '%' + IntToHex(Ord(c), 2)
    else
      Result := Result + c;
  end;
end;
{$ENDIF}

function FormatToken(AToken: string): string;
begin
 result:= AToken;

 if Pos(' ', AToken) <= 0  then
  result:= 'Bearer ' + AToken;
end;


function URLEncodeSegment(const S: string): string;
begin
  {$IFDEF FPC}
  Result := EncodeURLElement(S);
  {$ELSE}
  Result := EncodeURLElement(S);
  {$ENDIF}
end;


function EncodeStrBase64(AString: String): string;
begin
 {$IFNDEF FPC}
  result:= TNetEncoding.Base64.Encode(AString);
 {$ELSE}
  result:= EncodeStringBase64(AString);
 {$ENDIF}
end;

function BuildURL(const BaseURL: string): string;
begin
 result:= BuildURL(BaseURL, []);
end;

function BuildURL(const BaseURL: string; const Segments: array of string): string;
var
  i: Integer;
  CleanBase: string;
begin
  // Remove barra final da base se existir
  CleanBase := BaseURL;
  while (Length(CleanBase) > 0) and (CleanBase[Length(CleanBase)] = '/') do
    Delete(CleanBase, Length(CleanBase), 1);

  Result := CleanBase;

  // Adiciona cada segmento encodado com /
  for i := 0 to High(Segments) do
    Result := Result + '/' + URLEncodeSegment(Segments[i]);
end;

function BuildURL(const BaseURL: string; const Segments: array of string; const AQuerys: array of string): string;
begin
 result:= BuildURL(BaseURL, '', Segments, AQuerys);
end;

function BuildURL(const BaseURL: string; const ARoute: string; const Segments: array of string): string;
var
 vURL: string;
 vRoute: string;
begin
 vURL:= BaseURL;
 vRoute:= ARoute;

 if not vURL.EndsWith('/') then
  vURL:= vURL + '/';

 if vRoute <> '' then
  if vRoute.StartsWith('/') then
   vRoute:= Copy(vRoute, 2);

 result:= BuildURL(vURL + vRoute, Segments);
end;

function BuildURL(const BaseURL: string; const ARoute: string; const Segments: array of string; const AQuerys: array of string): string;
var
 i: integer;
begin
 result:= BuildURL(BaseURL, ARoute, Segments);

 if Length(AQuerys) > 0 then
 begin
  if result.EndsWith('/') then
   result:= Copy(result, 1, Length(result) -1);

  result:= result + '?';

  for i := 0 to High(AQuerys) do
  begin
   if i > 0 then
    Result := Result + '&';

   Result := Result + AQuerys[i];
  end;
 end;
end;


function CombineURL(const BaseURL, Endpoint: string): string;
var
  CleanBase, CleanEndpoint: string;
begin
 try
  // Força todas as barras para o padrão web: /
  CleanBase := StringReplace(BaseURL, '\', '/', [rfReplaceAll]);
  CleanEndpoint := StringReplace(Endpoint, '\', '/', [rfReplaceAll]);

  // Remove barra final da base
  while (Length(CleanBase) > 0) and (CleanBase[Length(CleanBase)] = '/') do
    Delete(CleanBase, Length(CleanBase), 1);

  // Remove barra inicial do endpoint
  while (Length(CleanEndpoint) > 0) and (CleanEndpoint[1] = '/') do
    Delete(CleanEndpoint, 1, 1);

  // Junta com uma única barra
  Result := CleanBase + '/' + CleanEndpoint;
 except
{$IFnDEF FMX}
  {$IFnDEF NOGUI}
   on E: Exception do
    MessageDlg('Cannot inspecione this Docker URL', mterror, [mbok], 0);
  {$ENDIF}
{$ENDIF}
 end;
end;


function RESTGetToJSON(const AURL: string; AToken: string): ID2BridgeRestResponse; overload;
var
 AHearders: TStrings;
begin
 AHearders:= TStringList.Create;

 if (AToken <> '') then
 begin
  if POS('=', AToken) > 0 then
   AHearders.Add(AToken)
  else
   AHearders.AddPair('Authorization', FormatToken(AToken));
 end;
 AHearders.AddPair('Content-Type', 'application/json');
 AHearders.AddPair('Accept', 'application/json');

 result:= RESTGetToJSON(AURL, AHearders);

 AHearders.Free;
end;

function RESTGetToJSON(const AURL: string; AUser, APassword: string): ID2BridgeRestResponse; overload;
var
 AuthValue: string;
 AHearders: TStrings;
begin
 AHearders:= TStringList.Create;

 if (AUser <> '') or (APassword <> '') then
 begin
  AuthValue := 'Basic ' + EncodeStrBase64(AUser + ':' + APassword);
  AHearders.AddPair('Authorization', AuthValue);
 end;
 AHearders.AddPair('Content-Type', 'application/json');

 result:= RESTGetToJSON(AURL, AHearders);

 AHearders.Free;
end;

function RestMethodToJSON(const AURL: string; AHTTPMethod: string; AHearders: TStrings; AJSON: TJSONObject): ID2BridgeRestResponse;
var
 Client: {$IFNDEF FPC}THTTPClient{$ELSE}TFPHTTPClient{$ENDIF};
{$IFNDEF FPC}
 vClientResponse: IHTTPResponse;
 vHeader: TNetHeader;
 vCookie: TCookie;
{$ENDIF}
 RequestBody, Response: TStringStream;
 I: integer;
 vResp: TD2BridgeRestResponse;
begin
 vResp:= TD2BridgeRestResponse.Create;

 Result := vResp;

 vResp.FURL:= AURL;
 vResp.FMethod:= AHTTPMethod;


 Client := {$IFNDEF FPC}THTTPClient.Create{$ELSE}TFPHTTPClient.Create(nil){$ENDIF};

{$IFNDEF FPC}
 Client.AllowCookies := True;
{$ENDIF}

 if Assigned(AJSON) then
  RequestBody := TStringStream.Create(AJSON.{$IFNDEF FPC}ToJSON{$ELSE}AsJSON{$ENDIF})
 else
  RequestBody := TStringStream.Create;

 Response := TStringStream.Create('');
 try
  try
   {$IFNDEF FPC}
   Client.OnValidateServerCertificate:= THTTPClientHelper.ValidateServerCertificate;
   if Assigned(AHearders) then
   begin
    for I := 0 to Pred(AHearders.Count) do
     Client.CustomHeaders[AHearders.Names[I]]:= AHearders.ValueFromIndex[I];
   end else
   begin
    Client.CustomHeaders['Content-Type'] := 'application/json';
    Client.CustomHeaders['Accept'] := 'application/json';
   end;
   {$ELSE}
   if Assigned(AHearders) then
   begin
    for I := 0 to Pred(AHearders.Count) do
    begin
     Client.AddHeader(AHearders.Names[I], AHearders.ValueFromIndex[I]);
    end;
   end else
   begin
    Client.AddHeader('Content-Type', 'application/json');
    Client.AddHeader('Accept', 'application/json');
   end;
   Client.RequestBody := RequestBody;
   Client.IOTimeout:= 180000;
   {$ENDIF}


   try
    if SameText(AHTTPMethod, 'GET') then //GET
    begin
     {$IFNDEF FPC}vClientResponse:={$ENDIF}
      Client.Get(AURL, Response);
    end else
     if SameText(AHTTPMethod, 'POST') then //POST
     begin
      {$IFNDEF FPC}vClientResponse:={$ENDIF}
       Client.Post(
        AURL
        {$IFNDEF FPC}, RequestBody{$ENDIF},
        Response
       );
     end else
      if SameText(AHTTPMethod, 'PUT') then //PUT
      begin
       {$IFNDEF FPC}vClientResponse:={$ENDIF}
        Client.Put(
         AURL
         {$IFNDEF FPC}, RequestBody{$ENDIF},
         Response
        );
      end else
       if SameText(AHTTPMethod, 'DELETE') then //DELETE
       begin
        {$IFNDEF FPC}vClientResponse:={$ENDIF}
         Client.Delete(
          AURL
          {$IFNDEF FPC}, RequestBody{$ENDIF},
          Response{$IFnDEF FPC}, nil{$ENDIF}
         );
       end else
        if SameText(AHTTPMethod, 'PATCH') then //PATCH
        begin
         {$IFNDEF FPC}
          vClientResponse:=
           Client.PATCH(
            AURL
            {$IFNDEF FPC}, RequestBody{$ENDIF},
            Response
          );
         {$ELSE}
          Client.HTTPMethod('PATCH', AURL, Response, [200, 201, 202, 203, 204, 205, 206]);
         {$ENDIF}
        end;
   except
    // Silenciar falha
   end;


   vResp.FStatusCode:= {$IFnDEF FPC}vClientResponse.StatusCode{$ELSE}Client.ResponseStatusCode{$ENDIF};
   vResp.FStatusText:= {$IFnDEF FPC}vClientResponse.StatusText{$ELSE}Client.ResponseStatusText{$ENDIF};

   vResp.FContent:= Response.DataString;
   vResp.FContentLength:= Length(vResp.FContent);

{$IFnDEF FPC}
   for vHeader in vClientResponse.Headers do
    vResp.FHeaders.Values[vHeader.Name] := vHeader.Value;
{$ELSE}
   vResp.FHeaders.Text:= Client.ResponseHeaders.Text;
{$ENDIF}

{$IFnDEF FPC}
   for vCookie in vClientResponse.Cookies do
    vResp.FCookies.Values[vCookie.Name] := vCookie.Value;
{$ELSE}
   vResp.FCookies.Text:= Client.Cookies.Text;
{$ENDIF}

{$IFnDEF FPC}
   vResp.FContentType:= vClientResponse.HeaderValue['Content-Type'];
{$ELSE}
   vResp.FContentType:= Client.ResponseHeaders.Values['Content-Type'];
{$ENDIF}


  except
  end;
 finally
  {$IFNDEF FPC}
   vClientResponse:= nil;
  {$ENDIF}

  RequestBody.Free;
  Response.Free;
  Client.Free;
 end;
end;

function RESTGetToJSON(const AURL: string; AHearders: TStrings = nil): ID2BridgeRestResponse; overload;
begin
 result:= RestMethodToJSON(AURL, 'GET', AHearders, nil);
end;

function RESTDeleteToJSON(const AURL: string; AJSON: TJSONObject): ID2BridgeRestResponse;
begin
 result:= RESTDeleteToJSON(AURL, nil, AJSON);
end;

function RESTDeleteToJSON(const AURL: string; AHearders: TStrings; AJSON: TJSONObject): ID2BridgeRestResponse;
begin
 result:= RestMethodToJSON(AURL, 'DELETE', AHearders, AJSON);
end;

function RESTDeleteToJSON(const AURL: string; AToken: string; AJSON: TJSONObject): ID2BridgeRestResponse;
var
 AHearders: TStrings;
begin
 AHearders:= TStringList.Create;

 if (AToken <> '') then
 begin
  if POS('=', AToken) > 0 then
   AHearders.Add(AToken)
  else
   AHearders.AddPair('Authorization', FormatToken(AToken));
 end;
 AHearders.AddPair('Content-Type', 'application/json');
 AHearders.AddPair('Accept', 'application/json');

 result:= RESTDeleteToJSON(AURL, AHearders, AJSON);

 AHearders.Free;
end;

function RESTDeleteToJSON(const AURL, AUser, APassword: string; AJSON: TJSONObject): ID2BridgeRestResponse;
var
 AuthValue: string;
 AHearders: TStrings;
begin
 AHearders:= TStringList.Create;

 if (AUser <> '') or (APassword <> '') then
 begin
  AuthValue := 'Basic ' + EncodeStrBase64(AUser + ':' + APassword);
  AHearders.AddPair('Authorization', AuthValue);
 end;
 AHearders.AddPair('Content-Type', 'application/json');

 result:= RESTDeleteToJSON(AURL, AHearders, AJSON);

 AHearders.Free;

end;


function RESTPatchToJSON(const AURL: string; AJSON: TJSONObject): ID2BridgeRestResponse;
begin
 result:= RESTPatchToJSON(AURL, nil, AJSON);
end;

function RESTPatchToJSON(const AURL: string; AHearders: TStrings; AJSON: TJSONObject): ID2BridgeRestResponse;
begin
 result:= RestMethodToJSON(AURL, 'PATCH', AHearders, AJSON);
end;

function RESTPatchToJSON(const AURL: string; AToken: string; AJSON: TJSONObject): ID2BridgeRestResponse;
var
 AHearders: TStrings;
begin
 AHearders:= TStringList.Create;

 if (AToken <> '') then
 begin
  if POS('=', AToken) > 0 then
   AHearders.Add(AToken)
  else
   AHearders.AddPair('Authorization', FormatToken(AToken));
 end;
 AHearders.AddPair('Content-Type', 'application/json');
 AHearders.AddPair('Accept', 'application/json');

 result:= RESTPatchToJSON(AURL, AHearders, AJSON);

 AHearders.Free;

end;

function RESTPatchToJSON(const AURL, AUser, APassword: string; AJSON: TJSONObject): ID2BridgeRestResponse;
var
 AuthValue: string;
 AHearders: TStrings;
begin
 AHearders:= TStringList.Create;

 if (AUser <> '') or (APassword <> '') then
 begin
  AuthValue := 'Basic ' + EncodeStrBase64(AUser + ':' + APassword);
  AHearders.AddPair('Authorization', AuthValue);
 end;
 AHearders.AddPair('Content-Type', 'application/json');

 result:= RESTPatchToJSON(AURL, AHearders, AJSON);

 AHearders.Free;

end;

function RESTPostRawFile(const AURL: string; const AFileName, AToken: string): ID2BridgeRestResponse;
var
 Client: {$IFnDEF FPC}THTTPClient{$ELSE}TFPHTTPClient{$ENDIF};
 FileStream: TFileStream;
 Response: TStringStream;
 vResp: TD2BridgeRestResponse;
begin
 vResp:= TD2BridgeRestResponse.Create;

 Result := vResp;

 vResp.FURL:= AURL;
 vResp.FMethod:= 'POST';


 Client := {$IFnDEF FPC}THTTPClient.Create{$ELSE}TFPHTTPClient.Create(nil){$ENDIF};
{$IFnDEF FPC}
 Client.OnValidateServerCertificate:= THTTPClientHelper.ValidateServerCertificate;
{$ENDIF}
 Response := TStringStream.Create('');
 FileStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);


 try
{$IFDEF FPC}
  FileStream.Position := 0;
  Client.RequestBody := FileStream;
{$ENDIF}

  if (AToken <> '') then
  begin
   if POS('=', AToken) > 0 then
   begin
    Client.{$IFnDEF FPC}CustHeaders.Add{$ELSE}AddHeader{$ENDIF}(AToken.Split(['='])[0], AToken.Split(['='])[1]);
   end else
    Client.{$IFnDEF FPC}CustHeaders.Add{$ELSE}AddHeader{$ENDIF}('Authorization', FormatToken(AToken));
  end;

  Client.{$IFnDEF FPC}CustHeaders.Add{$ELSE}AddHeader{$ENDIF}('Content-Type', 'application/octet-stream');


  try
   try
    Client.Post(AURL{$IFnDEF FPC}, FileStream{$ENDIF}, Response);
   except
   end;

   vResp.FStatusCode:= {$IFnDEF FPC}vClientResponse.StatusCode{$ELSE}Client.ResponseStatusCode{$ENDIF};
   vResp.FStatusText:= {$IFnDEF FPC}vClientResponse.StatusText{$ELSE}Client.ResponseStatusText{$ENDIF};

   vResp.FContent:= Response.DataString;
   vResp.FContentLength:= Length(vResp.FContent);


{$IFnDEF FPC}
   for vHeader in vClientResponse.Headers do
    vResp.FHeaders.Values[vHeader.Name] := vHeader.Value;
{$ELSE}
   vResp.FHeaders.Text:= Client.ResponseHeaders.Text;
{$ENDIF}

{$IFnDEF FPC}
   for vCookie in vClientResponse.Cookies do
    vResp.FCookies.Values[vCookie.Name] := vCookie.Value;
{$ELSE}
   vResp.FCookies.Text:= Client.Cookies.Text;
{$ENDIF}

{$IFnDEF FPC}
   vResp.FContentType:= vClientResponse.HeaderValue['Content-Type'];
{$ELSE}
   vResp.FContentType:= Client.ResponseHeaders.Values['Content-Type'];
{$ENDIF}

  except
  end;
 finally
  FileStream.Free;
  Response.Free;
  Client.Free;
 end;
end;


function DownloadFileFromURL(const AURL, ADestFile: string; AToken: string): Boolean;
var
  {$IFNDEF FPC}
  Client: THTTPClient;
  Response: IHTTPResponse;
  FileStream: TFileStream;
  {$ELSE}
  Client: TFPHTTPClient;
  {$ENDIF}
begin
  Result := False;

  {$IFNDEF FPC}
  Client := THTTPClient.Create;
  try
    // Adiciona header de autorização, se existir
    if AToken <> '' then
    begin
      if Pos('=', AToken) > 0 then
        Client.CustomHeaders[AToken.Split(['='])[0]] := AToken.Split(['='])[1]
      else
        Client.CustomHeaders['Authorization'] := 'Bearer ' + AToken;
    end;

    FileStream := TFileStream.Create(ADestFile, fmCreate);
    try
      Response := Client.Get(AURL, FileStream);
      Result := Response.StatusCode = 200;
    finally
      FileStream.Free;
    end;
  finally
    Client.Free;
  end;
  {$ELSE}
  Client := TFPHTTPClient.Create(nil);
  try
    if AToken <> '' then
    begin
      if Pos('=', AToken) > 0 then
        Client.AddHeader(AToken.Split(['='])[0], AToken.Split(['='])[1])
      else
        Client.AddHeader('Authorization', 'Bearer ' + AToken);
    end;

    Client.AllowRedirect := True;
    Client.Get(AURL, ADestFile);
    Result := FileExists(ADestFile);
  finally
    Client.Free;
  end;
  {$ENDIF}
end;



function RESTPostToJSON(const AURL: string; AJSON: TJSONObject): ID2BridgeRestResponse;
begin
 result:= RESTPostToJSON(AURL, nil, AJSON);
end;

function RESTPostToJSON(const AURL: string; AHearders: TStrings; AJSON: TJSONObject = nil): ID2BridgeRestResponse;
begin
 result:= RestMethodToJSON(AURL, 'POST', AHearders, AJSON);
end;

function RESTPostToJSON(const AURL: string; AToken: string; AJSON: TJSONObject): ID2BridgeRestResponse;
var
 AHearders: TStrings;
begin
 AHearders:= TStringList.Create;

 if (AToken <> '') then
 begin
  if POS('=', AToken) > 0 then
   AHearders.Add(AToken)
  else
   AHearders.AddPair('Authorization', FormatToken(AToken));
 end;
 AHearders.AddPair('Content-Type', 'application/json');
 AHearders.AddPair('Accept', 'application/json');

 result:= RESTPostToJSON(AURL, AHearders, AJSON);

 AHearders.Free;
end;

function RESTPostToJSON(const AURL, AUser, APassword: string; AJSON: TJSONObject = nil): ID2BridgeRestResponse;
var
 AuthValue: string;
 AHearders: TStrings;
begin
 AHearders:= TStringList.Create;

 if (AUser <> '') or (APassword <> '') then
 begin
  AuthValue := 'Basic ' + EncodeStrBase64(AUser + ':' + APassword);
  AHearders.AddPair('Authorization', AuthValue);
 end;
 AHearders.AddPair('Content-Type', 'application/json');

 result:= RESTPostToJSON(AURL, AHearders, AJSON);

 AHearders.Free;
end;

function RESTPutToJSON(const AURL: string; AJSON: TJSONObject): ID2BridgeRestResponse;
begin
 result:= RESTPutToJSON(AURL, nil, AJSON);
end;

function RESTPutToJSON(const AURL: string; AHearders: TStrings; AJSON: TJSONObject): ID2BridgeRestResponse;
begin
 result:= RestMethodToJSON(AURL, 'PUT', AHearders, AJSON);
end;

function RESTPutToJSON(const AURL: string; AToken: string; AJSON: TJSONObject): ID2BridgeRestResponse;
var
 AHearders: TStrings;
begin
 AHearders:= TStringList.Create;

 if (AToken <> '') then
 begin
  if POS('=', AToken) > 0 then
   AHearders.Add(AToken)
  else
   AHearders.AddPair('Authorization', FormatToken(AToken));
 end;
 AHearders.AddPair('Content-Type', 'application/json');
 AHearders.AddPair('Accept', 'application/json');

 result:= RESTPutToJSON(AURL, AHearders, AJSON);

 AHearders.Free;
end;

function RESTPutToJSON(const AURL, AUser, APassword: string; AJSON: TJSONObject = nil): ID2BridgeRestResponse;
var
 AuthValue: string;
 AHearders: TStrings;
begin
 AHearders:= TStringList.Create;

 if (AUser <> '') or (APassword <> '') then
 begin
  AuthValue := 'Basic ' + EncodeStrBase64(AUser + ':' + APassword);
  AHearders.AddPair('Authorization', AuthValue);
 end;
 AHearders.AddPair('Content-Type', 'application/json');

 result:= RESTPutToJSON(AURL, AHearders, AJSON);

 AHearders.Free;
end;


function GetPrefetch(const AURL: string): string;
var
  Response: TStringStream;
  Client: {$IFnDEF FPC}THTTPClient{$ELSE}TFPHTTPClient{$ENDIF};
begin
  Result := '';
  Response := TStringStream.Create('');
  Client := {$IFnDEF FPC}THTTPClient.Create{$ELSE}TFPHTTPClient.Create(nil){$ENDIF};
{$IFnDEF FPC}
 Client.OnValidateServerCertificate:= THTTPClientHelper.ValidateServerCertificate;
{$ENDIF}
  try
    Client.{$IFnDEF FPC}CustHeaders.Add{$ELSE}AddHeader{$ENDIF}('Host', '127.0.0.1');
    Client.{$IFnDEF FPC}CustHeaders.Add{$ELSE}AddHeader{$ENDIF}('User-Agent', 'D2DockerLoader');
    Client.{$IFnDEF FPC}CustHeaders.Add{$ELSE}AddHeader{$ENDIF}('Accept', 'application/json');
    Client.{$IFnDEF FPC}CustHeaders.Add{$ELSE}AddHeader{$ENDIF}('Purpose', 'prefetch');
    Client.{$IFnDEF FPC}CustHeaders.Add{$ELSE}AddHeader{$ENDIF}('Sec-Fetch-Dest', 'script');
    Client.{$IFnDEF FPC}CustHeaders.Add{$ELSE}AddHeader{$ENDIF}('Sec-Fetch-Mode', 'no-cors');
    Client.{$IFnDEF FPC}CustHeaders.Add{$ELSE}AddHeader{$ENDIF}('Sec-Fetch-Site', 'same-origin');

   try
    Client.Get(AURL, Response);
   except
   end;

   result:= Response.DataString
  finally
   Response.Free;
   Client.Free;
  end;
end;

function DataSetToJSONArray(ADataSet: TDataSet): TJSONArray;
begin
 result:= DataSetToJSONArray(ADataSet, []);
end;


function DataSetToJSONArray(ADataSet: TDataSet; AExcludeFields: array of string): TJSONArray;
var
 vPos: Integer;
 vJSONArray: TJSONArray;
begin
 result:= nil;

 vJSONArray:= TJSONArray.Create;

 vPos:= ADataset.RecNo;

 ADataSet.DisableControls;
 try
  ADataSet.First;

  while ADataSet.EOF do
  begin
   try
    vJSONArray.Add(DataSetRowToJSON(ADataSet, AExcludeFields));
   except
   end;

   ADataSet.Next;
  end;

  result:= vJSONArray.Clone as TJSONArray;

  try
   ADataSet.RecNo:= vPos;
  except
  end;
 finally
  ADataSet.EnableControls;
 end;
end;


function DataSetToJSON(ADataSet: TDataSet; ADataArrayName: string): TJSONObject;
begin
 result:= DataSetToJSON(ADataSet, ADataArrayName, []);
end;


function DataSetToJSON(ADataSet: TDataSet; ADataArrayName: string; AExcludeFields: array of string): TJSONObject;
var
 vJSON: TJSONObject;
begin
 vJSON:= TJSONObject.Create;

 vJSON.{$IFnDEF FPC}AddPair{$ELSE}Add{$ENDIF}(ADataArrayName, DataSetToJSONArray(ADataSet, AExcludeFields));

 result:= vJSON.Clone as TJSONObject;
end;


function DataSetRowToJSON(ADataSet: TDataSet): TJSONObject;
begin
 result:= DataSetRowToJSON(ADataSet, []);
end;


function DataSetRowToJSON(ADataSet: TDataSet; AExcludeFields: array of string): TJSONObject;
var
  lColsArray:  Integer;
  lColName:              String;
  lHexString:            string;
  lByteValue:            Byte;
  SkipeField:            Boolean;
  lStreamIn:             TStream;
  lStreamOut:            TStringStream;
  lJSONObject:           TJSONObject;
  vExcFieldName:         string;
{$IFDEF FPC}
  Encoder:               TBase64EncodingStream;
{$ENDIF}
begin
 result:= nil;

 if not Assigned(ADataSet) then
  exit;

 try
  //ADataSet.First;

  try
   lJSONObject:= TJSONObject.Create;

   for lColsArray:= 0 to Pred(ADataSet.Fields.Count) do
   begin
    lColName:= ADataSet.Fields[lColsArray].FieldName;


    SkipeField:= false;
    if Length(AExcludeFields) > 0 then
     for vExcFieldName in AExcludeFields do
     begin
      if SameText(vExcFieldName, lColName) then
      begin
       SkipeField:= true;
       break;
      end;
     end;
     if SkipeField then
      Continue;


     //lJSONWriter.WritePropertyName(ADataSet.Fields[lCols].FieldName);
     if ADataSet.Fields[lColsArray].IsNull then
       case ADataSet.Fields[lColsArray].DataType of
         // númericos
         ftFloat{$IFDEF SUPPORTS_FTEXTENDED}, ftCurrency, ftExtended{$ENDIF}, ftFMTBcd,
         ftSmallint{$IFDEF SUPPORTS_FTEXTENDED}, ftShortint, ftSingle{$ENDIF}, ftWord, ftInteger, ftAutoInc,
         ftLargeint{$IFDEF SUPPORTS_FTEXTENDED}, ftLongWord{$ENDIF}, ftBCD:
         begin
          lJSONObject.{$IFnDEF FPC}AddPair{$ELSE}Add{$ENDIF}(lColName, TJSONFloatNumber.Create(0));
         end;
         //string
         ftString, ftFmtMemo, ftMemo, ftWideString, ftWideMemo, ftUnknown :
           lJSONObject.{$IFnDEF FPC}AddPair{$ELSE}Add{$ENDIF}(lColName, '');
         // DateTime
         ftDateTime:
           begin
//                       if (ADataSet.Fields[lColsArray] as TDateTimeField).DisplayFormat <> '' then
//                        lJSONObject.AddPair(lColName, FormatDatetime((ADataSet.Fields[lColsArray] as TDateTimeField).DisplayFormat, ADataSet.Fields[lColsArray].AsDateTime))
//                       else
             lJSONObject.{$IFnDEF FPC}AddPair{$ELSE}Add{$ENDIF}(lColName, '');
           end;
         //Date
         ftDate:
           begin
//                       if (ADataSet.Fields[lColsArray] as TDateField).DisplayFormat <> '' then
//                        lJSONObject.AddPair(lColName, FormatDatetime((ADataSet.Fields[lColsArray] as TDateTimeField).DisplayFormat, ADataSet.Fields[lColsArray].AsDateTime))
//                       else
             lJSONObject.{$IFnDEF FPC}AddPair{$ELSE}Add{$ENDIF}(lColName, '');
           end;
         //Time
         ftTime:
           begin
//                       if (ADataSet.Fields[lColsArray] as TTimeField).DisplayFormat <> '' then
//                        lJSONObject.AddPair(lColName, FormatDatetime((ADataSet.Fields[lColsArray] as TDateTimeField).DisplayFormat, ADataSet.Fields[lColsArray].AsDateTime))
//                       else
             lJSONObject.{$IFnDEF FPC}AddPair{$ELSE}Add{$ENDIF}(lColName, '');
           end;
         //TimeStamp
         ftTimeStamp:
           begin
{$IFNDEF FPC}
//                       if (ADataSet.Fields[lColsArray] as TSQLTimeStampField).DisplayFormat <> '' then
//                        lJSONObject.AddPair(lColName, FormatDatetime((ADataSet.Fields[lColsArray] as TSQLTimeStampField).DisplayFormat, ADataSet.Fields[lColsArray].AsDateTime))
//                       else
{$ENDIF}
             lJSONObject.{$IFnDEF FPC}AddPair{$ELSE}Add{$ENDIF}(lColName, '');
           end;

         else
          lJSONObject.{$IFnDEF FPC}AddPair{$ELSE}Add{$ENDIF}(lColName, TJSONNull.Create)
       end
     else
       case ADataSet.Fields[lColsArray].DataType of
         ftBlob:
           begin
             lStreamIn := ADataSet.CreateBlobStream(ADataSet.Fields[lColsArray], bmRead);
             lStreamOut := TStringStream.Create;
             lStreamIn.Position:= 0;

{$IFNDEF FPC}
{$IFDEF HAS_UNIT_SYSTEM_NETENCODING}
             TNetEncoding.Base64.Encode(lStreamIn, lStreamOut);
{$ELSE}
             EncodeStream(lStreamIn, lStreamOut);
{$ENDIF}
{$ELSE}
             Encoder:= TBase64EncodingStream.Create(lStreamOut);
             Encoder.CopyFrom(lStreamIn, lStreamIn.Size);
             Encoder.Flush;
{$ENDIF}

             lStreamOut.Position := 0;

             lJSONObject.{$IFnDEF FPC}AddPair{$ELSE}Add{$ENDIF}(ADataSet.Fields[lColsArray].FieldName, lStreamOut.DataString);
             lStreamOut.Free;
           end;
         ftBoolean:
           begin
             if ADataSet.Fields[lColsArray].AsBoolean then
               lJSONObject.{$IFnDEF FPC}AddPair{$ELSE}Add{$ENDIF}(lColName, {$IFnDEF FPC}GetTJSONTrue{$ELSE}True{$ENDIF})
             else
               lJSONObject.{$IFnDEF FPC}AddPair{$ELSE}Add{$ENDIF}(lColName, {$IFnDEF FPC}GetTJSONFalse{$ELSE}False{$ENDIF});
           end;
         // númericos
         ftFloat{$IFDEF SUPPORTS_FTEXTENDED}, ftExtended{$ENDIF}, ftFMTBcd, ftBCD:
         begin
           if (ADataSet.Fields[lColsArray] as TNumericField).DisplayFormat <> '' then
            lJSONObject.{$IFnDEF FPC}AddPair{$ELSE}Add{$ENDIF}(lColName, FormatFloat((ADataSet.Fields[lColsArray] as TNumericField).DisplayFormat, ADataSet.fields[lColsArray].AsFloat, FormatSettings))
           else
            lJSONObject.{$IFnDEF FPC}AddPair{$ELSE}Add{$ENDIF}(lColName, {$IFnDEF FPC}TJSONFloatNumber{$ELSE}TJSONFloatNumberFixed{$ENDIF}.Create(ADataSet.Fields[lColsArray].AsFloat));
         end;
         ftCurrency:
         begin
           if (ADataSet.Fields[lColsArray] as TCurrencyField).DisplayFormat <> '' then
            lJSONObject.{$IFnDEF FPC}AddPair{$ELSE}Add{$ENDIF}(lColName, FormatFloat((ADataSet.Fields[lColsArray] as TCurrencyField).DisplayFormat, ADataSet.fields[lColsArray].AsCurrency, FormatSettings))
           else
            lJSONObject.{$IFnDEF FPC}AddPair{$ELSE}Add{$ENDIF}(lColName, {$IFnDEF FPC}TJSONFloatNumber{$ELSE}TJSONFloatNumberFixed{$ENDIF}.Create(ADataSet.Fields[lColsArray].AsCurrency));
         end;
         ftSmallint{$IFDEF SUPPORTS_FTEXTENDED}, ftShortint, ftSingle{$ENDIF}, ftWord, ftInteger, ftAutoInc,
         ftLargeint{$IFDEF SUPPORTS_FTEXTENDED}, ftLongWord{$ENDIF}:
           lJSONObject.{$IFnDEF FPC}AddPair{$ELSE}Add{$ENDIF}(lColName, TJSONInt64Number.Create(Int64(ADataSet.Fields[lColsArray].Value)));
         //string
         ftString, ftFmtMemo, ftMemo, ftWideString, ftWideMemo, ftUnknown :
           lJSONObject.{$IFnDEF FPC}AddPair{$ELSE}Add{$ENDIF}(lColName, Trim(ADataSet.Fields[lColsArray].Value));
         // DateTime
         ftDateTime:
           begin
            if (ADataSet.Fields[lColsArray] as TDateTimeField).DisplayFormat <> '' then
             lJSONObject.{$IFnDEF FPC}AddPair{$ELSE}Add{$ENDIF}(lColName, FormatDatetime((ADataSet.Fields[lColsArray] as TDateTimeField).DisplayFormat, ADataSet.Fields[lColsArray].AsDateTime))
            else
             lJSONObject.{$IFnDEF FPC}AddPair{$ELSE}Add{$ENDIF}(lColName, FormatDatetime(FormatSettings.ShortDateFormat + ' ' + FormatSettings.LongTimeFormat, ADataSet.Fields[lColsArray].AsDateTime));
           end;
         ftDate:
           begin
            if (ADataSet.Fields[lColsArray] as TDateField).DisplayFormat <> '' then
             lJSONObject.{$IFnDEF FPC}AddPair{$ELSE}Add{$ENDIF}(lColName, FormatDatetime((ADataSet.Fields[lColsArray] as TDateField).DisplayFormat, ADataSet.Fields[lColsArray].AsDateTime))
            else
             lJSONObject.{$IFnDEF FPC}AddPair{$ELSE}Add{$ENDIF}(lColName, FormatDatetime(FormatSettings.ShortDateFormat, ADataSet.fields[lColsArray].AsDateTime));
           end;
         ftTime:
           begin
            if (ADataSet.Fields[lColsArray] as TTimeField).DisplayFormat <> '' then
             lJSONObject.{$IFnDEF FPC}AddPair{$ELSE}Add{$ENDIF}(lColName, FormatDatetime((ADataSet.Fields[lColsArray] as TTimeField).DisplayFormat, ADataSet.Fields[lColsArray].AsDateTime))
            else
             lJSONObject.{$IFnDEF FPC}AddPair{$ELSE}Add{$ENDIF}(lColName, FormatDatetime(FormatSettings.LongTimeFormat, ADataSet.Fields[lColsArray].AsDateTime));
           end;
         ftTimeStamp:
           begin
{$IFNDEF FPC}
            if (ADataSet.Fields[lColsArray] as TSQLTimeStampField).DisplayFormat <> '' then
             lJSONObject.AddPair(lColName, FormatDatetime((ADataSet.Fields[lColsArray] as TSQLTimeStampField).DisplayFormat, ADataSet.Fields[lColsArray].AsDateTime))
            else
{$ENDIF}
             lJSONObject.{$IFnDEF FPC}AddPair{$ELSE}Add{$ENDIF}(lColName, FormatDatetime(FormatSettings.ShortDateFormat + ' ' + FormatSettings.LongTimeFormat, ADataSet.Fields[lColsArray].AsDateTime)); //'DD/MM/YYYY hh:nn:ss'
           end;
         ftBytes:
         begin
           LHexString:= EmptyStr;

           for LByteValue in ADataSet.fields[lColsArray].AsBytes do
             LHexString:= LHexString + IntToHex(LByteValue, 2);

           lJSONObject.{$IFnDEF FPC}AddPair{$ELSE}Add{$ENDIF}(lColName, LHexString);
         end;
       end;
   end;
  except

  end;

  Result:= lJSONObject.Clone as TJSONObject;
 finally
  lJSONObject.Free;
 end;
end;


{ TD2BridgeRestResponse }

procedure TD2BridgeRestResponse.ParseJSONIfNeeded;
begin
 if FJSONParsed then
   Exit;

 FJSONParsed := True;
 FJSONValue := nil;

 if FContent.Trim = '' then
   Exit;

 // só tenta se for JSON
 //if Pos('json', LowerCase(FContentType)) = 0 then
 //  Exit;

 try
   {$IFNDEF FPC}
     FJSONValue := TJSONObject.ParseJSONValue(FContent);
   {$ELSE}
     //SetJSONInstanceType(jitNumberFloat, TJSONFloatNumberFixed);
     FJSONValue := GetJSON(FContent);
   {$ENDIF}
 except
   FJSONValue := nil;
 end;
end;


function FindJSONValue(AObj: TJSONObject; const AName: string): TJSONData;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to AObj.Count - 1 do
    if SameText(AObj.Names[I], AName) then
      Exit(AObj.Items[I]);
end;


procedure TD2BridgeRestResponse.PopuleDataSet(ADataSet: TDataset; AJSONArray: TJSONArray);
var
  LItem: TJSONObject;
  LValue: TJSONData;
  I, B, F: Integer;
  Field: TField;
  Bytes: TBytes;
  P: Integer;
  vFieldName: string;
begin
  if not Assigned(ADataSet) then
    Exit;

  if not Assigned(AJSONArray) then
    Exit;

  // ISO / JSON settings
  //FS := DefaultFormatSettings;
  //FS.DecimalSeparator := '.';
  //FS.DateSeparator := '-';
  //FS.TimeSeparator := ':';
  //FS.ShortDateFormat := 'yyyy-mm-dd';
  //FS.LongTimeFormat := 'hh:nn:ss';

  ADataSet.DisableControls;
  try
    //ADataSet.Close;
    //ADataSet.Open;

    for I := 0 to AJSONArray.Count - 1 do
    begin
      if not (AJSONArray.Items[I] is TJSONObject) then
        Continue;

      LItem := AJSONArray.Objects[I];

      if I = 0 then
       ADataSet.Edit
      else
       ADataSet.Append;

      for F := 0 to ADataSet.FieldCount - 1 do
      begin
        Field := ADataSet.Fields[F];
        vFieldName:= Field.FieldName;

        // Proteções importantes
        if Field.ReadOnly or Field.Calculated or Field.Lookup then
          Continue;

        LValue := FindJSONValue(LItem, vFieldName);
        if LValue = nil then
          Continue;

        if LValue.JSONType = jtNull then
        begin
          Field.Clear;
          Continue;
        end;


        case Field.DataType of

          // Inteiros
          ftSmallint, {$IFnDEF FPC}ftShortint,{$ENDIF} ftWord, ftInteger, ftAutoInc,
          ftLargeint {$IFnDEF FPC}, ftLongWord{$ENDIF}:
            Field.AsLargeInt := LValue.AsLargeInt;

          // Float / Extended / BCD
          ftFloat, {$IFnDEF FPC}ftExtended, ftSingle,{$ENDIF} ftFMTBcd, ftBCD:
            Field.AsFloat := StrToFloat(LValue.AsString, FormatSettings);

          ftCurrency:
            Field.AsCurrency := StrToFloat(LValue.AsString, FormatSettings);

          // Boolean
          ftBoolean:
            Field.AsBoolean := SameText(LValue.AsString, 'true') or (LValue.AsString = '1');

          // Strings
          ftString, ftWideString, ftMemo, ftFmtMemo, ftWideMemo, ftUnknown:
            Field.AsString := LValue.AsString;

          // Datas
          ftDate:
            Field.AsDateTime := StrToDate(LValue.AsString, FormatSettings);

          ftTime:
            Field.AsDateTime := StrToTime(LValue.AsString, FormatSettings);

          ftDateTime, ftTimeStamp:
            Field.AsDateTime := StrToDateTime(LValue.AsString, FormatSettings);

          // Bytes (hex)
          ftBytes:
          begin
            SetLength(Bytes, Length(LValue.AsString) div 2);
            P := 1;
            for B := 0 to High(Bytes) do
            begin
              Bytes[B] := StrToInt('$' + Copy(LValue.AsString, P, 2));
              Inc(P, 2);
            end;
            Field.AsBytes := Bytes;
          end;

          // Blob (Base64 – compatível com seu serializer)
          ftBlob:
            Field.AsString := LValue.AsString;

        else
          // fallback seguro
          Field.AsString := LValue.AsString;
        end;
      end;

      ADataSet.Post;
    end;

  finally
    //ADataSet.First;
    ADataSet.EnableControls;
  end;
end;


constructor TD2BridgeRestResponse.Create;
begin
 inherited Create;
 FHeaders := TStringList.Create;
 FCookies := TStringList.Create;

 FStatusCode := HTTPStatus.ErrorBadRequest;
 FStatusText := 'Endpoint not available';

 FJSONParsed:= false;

 FJSONValue:= nil;
end;

destructor TD2BridgeRestResponse.Destroy;
begin
 FHeaders.Free;
 FCookies.Free;

 try
  if Assigned(FJSONValue) then
   FreeAndNil(FJSONValue);
 except
 end;

 inherited Destroy;
end;

function TD2BridgeRestResponse.StatusCode: Integer;
begin
 result:= FStatusCode;
end;

function TD2BridgeRestResponse.StatusText: string;
begin
 result:= FStatusText;
end;

function TD2BridgeRestResponse.Content: string;
begin
 result:= FContent;
end;

function TD2BridgeRestResponse.ContentType: string;
begin
 result:= FContentType;
end;

function TD2BridgeRestResponse.ContentLength: Int64;
begin
 result:= FContentLength;
end;

function TD2BridgeRestResponse.Headers: TStrings;
begin
 result:= FHeaders;
end;

function TD2BridgeRestResponse.Cookies: TStrings;
begin
 result:= FCookies;
end;

function TD2BridgeRestResponse.Success: Boolean;
begin
 Result := (FStatusCode >= 200) and (FStatusCode < 300);
end;

function TD2BridgeRestResponse.SuccessWithContent: Boolean;
begin
 result:= Success and (FStatusCode <> 204);
end;

function TD2BridgeRestResponse.URL: string;
begin
 Result := FURL;
end;

function TD2BridgeRestResponse.Method: string;
begin
 Result := FMethod;
end;

function TD2BridgeRestResponse.AsJSONObject: TJSONObject;
begin
 Result := nil;
 ParseJSONIfNeeded;

 {$IFNDEF FPC}
   if FJSONValue is TJSONObject then
     Result := TJSONObject(FJSONValue);
 {$ELSE}
   if FJSONValue is TJSONObject then
     Result := TJSONObject(FJSONValue);
 {$ENDIF}
end;

function TD2BridgeRestResponse.AsJSONArray: TJSONArray;
begin
 Result := nil;
 ParseJSONIfNeeded;

 {$IFNDEF FPC}
   if FJSONValue is TJSONArray then
     Result := TJSONArray(FJSONValue);
 {$ELSE}
   if FJSONValue is TJSONArray then
     Result := TJSONArray(FJSONValue);
 {$ENDIF}
end;

procedure TD2BridgeRestResponse.ToDataSet(ADataSet: TDataset);
var
 vJSONArray: TJSONArray;
begin
 if not Assigned(ADataSet) then
  Exit;

 ParseJSONIfNeeded;

 if FJSONValue is TJSONArray then
 begin
  vJSONArray:= AsJSONArray;

  if not Assigned(vJSONArray) then
   Exit;

  PopuleDataSet(ADataSet, vJSONArray);
 end else
  exit;
end;


procedure TD2BridgeRestResponse.ToDataSet(ADataSet: TDataset; ADataArrayName: string);
var
 vJSONArray: TJSONArray;
begin
 if not Assigned(ADataSet) then
  Exit;

 if AsJSONObject.Find(ADataArrayName) = nil then
  exit;

 if (AsJSONObject.Find(ADataArrayName) is TJSONArray) then
 begin
  vJSONArray:= AsJSONObject.Find(ADataArrayName) as TJSONArray;

  PopuleDataSet(ADataSet, vJSONArray);
 end else
 begin
  vJSONArray:= TJSONArray.Create;
  vJSONArray.Add(AsJSONObject.Find(ADataArrayName).Clone as TJSONObject);

  PopuleDataSet(ADataSet, vJSONArray);

  vJSONArray.Free;
 end;
end;


procedure TD2BridgeRestResponse.ToDataSet(ADataSet: TDataset; ADataArrayName: string; ADataSetChild: TDataset; ADataChildArrayName: string);
var
 I: integer;
 vJSONArray, vJSONArrayChild: TJSONArray;
 vFreeJSONArray: boolean;
begin
 vFreeJSONArray:= false;

 if not Assigned(ADataSet) then
  Exit;

 if not Assigned(ADataSetChild) then
  Exit;

 if ADataArrayName = '' then
  Exit;

 if ADataChildArrayName = '' then
  Exit;

 if AsJSONObject.Find(ADataArrayName) = nil then
  exit;

 if (AsJSONObject.Find(ADataArrayName) is TJSONArray) then
 begin
  vJSONArray:= AsJSONObject.Find(ADataArrayName) as TJSONArray;

  PopuleDataSet(ADataSet, vJSONArray);
 end else
 begin
  vJSONArray:= TJSONArray.Create;
  vJSONArray.Add(AsJSONObject.Find(ADataArrayName).Clone as TJSONObject);

  PopuleDataSet(ADataSet, vJSONArray);

  vFreeJSONArray:= true;
 end;

 for I:= 0 to Pred(vJSONArray.Count) do
 begin
  vJSONArrayChild:= (vJSONArray[I] as TJSONObject).Arrays[ADataChildArrayName];

  if vJSONArrayChild <> nil then
  begin
   ADataSetChild.Append;
   PopuleDataSet(ADataSetChild, vJSONArrayChild);
  end;
 end;

 if vFreeJSONArray then
  vJSONArray.Free;
end;


procedure TD2BridgeRestResponse.ToDataSet(ADataSet: TDataset; ADataSetChild: TDataset; ADataChildArrayName: string);
var
 I: integer;
 vJSONArrayChild: TJSONArray;
begin
 if not Assigned(ADataSet) then
  Exit;

 if not Assigned(ADataSetChild) then
  Exit;

 if ADataChildArrayName = '' then
  Exit;

 ToDataSet(ADataSet);


 for I:= 0 to Pred(AsJSONArray.Count) do
 begin
  vJSONArrayChild:= (AsJSONArray[I] as TJSONObject).Arrays[ADataChildArrayName];

  if vJSONArrayChild <> nil then
  begin
   ADataSetChild.Append;
   PopuleDataSet(ADataSetChild, vJSONArrayChild);
  end;
 end;
end;


//Event
{ THTTPClientHelper }
{$IFnDEF FPC}
class procedure THTTPClientHelper.ValidateServerCertificate(
  const Sender: TObject; const ARequest: TURLRequest;
  const Certificate: TCertificate; var Accepted: Boolean);
begin
 Accepted:= true;
end;
{$ENDIF}




{ TD2BridgeRestRootClient }

constructor TD2BridgeRestRootClient.Create;
begin
 inherited;

 FCore:= TD2BridgeRestClientCore.Create(self);
end;

destructor TD2BridgeRestRootClient.Destroy;
begin
 FCore.Free;

 inherited Destroy;
end;

function TD2BridgeRestRootClient.Core: TD2BridgeRestClientCore;
begin
 result:= FCore;
end;




{ TD2BridgeRestClientCore }

function TD2BridgeRestClientCore.GetFormatSettings: TFormatSettings;
begin
 result:= FFormatSettings;
end;

procedure TD2BridgeRestClientCore.SetFormatSettings(const Value: TFormatSettings);
begin
 FFormatSettings:= Value;
end;

constructor TD2BridgeRestClientCore.Create(API: TObject);
begin
 inherited Create;

 FAPI:= API;
 FProduction:= true;

 FFormatSettings:= {$IFnDEF FPC}TFormatSettings.Create('en-US'){$ELSE}DefaultFormatSettings{$ENDIF};
 FFormatSettings.ShortDateFormat := 'yyyy-mm-dd';
 FFormatSettings.DateSeparator:= '-';
 FFormatSettings.DecimalSeparator:= '.';
 FFormatSettings.ThousandSeparator:= ',';
 FFormatSettings.TimeSeparator:= ':';
 FFormatSettings.ShortTimeFormat:= 'hh:nn';
 FFormatSettings.LongTimeFormat:= 'hh:nn:ss';
end;

destructor TD2BridgeRestClientCore.Destroy;
begin
 inherited Destroy;
end;

function TD2BridgeRestClientCore.URLBase: string;
begin
 if FProduction then
  result:= CombineURL(FURLBaseProduction, '')
 else
  result:= CombineURL(FURLBaseTest, '');
end;

procedure TD2BridgeRestClientCore.SetProductionMode;
begin
 FProduction:= true;
end;

procedure TD2BridgeRestClientCore.SetTestMode;
begin
 FProduction:= false;
end;



{ TD2BridgeRestClientModule }

constructor TD2BridgeRestClientModule.Create(APICore: TObject);
begin
 inherited Create;

 FAPICore:= APICore;
end;

destructor TD2BridgeRestClientModule.Destroy;
begin
 inherited Destroy;
end;

function TD2BridgeRestClientModule.Token: string;
begin
 if Assigned(TD2BridgeRestClientCore(FAPICore).OnGetToken) then
  result:= TD2BridgeRestClientCore(FAPICore).OnGetToken;
end;

function TD2BridgeRestClientModule.FullEndpoint: string;
begin
 result:= CombineURL(TD2BridgeRestClientCore(FAPICore).URLBase, Route);
end;


{ TJSONFloatNumberFixed }

{$IFDEF FPC}
function TJSONFloatNumberFixed.GetAsString: TJSONStringType;
var
  F: TJSONFloat;
  fs: TFormatSettings;
begin
  fs := DefaultFormatSettings;
  fs.DecimalSeparator := '.';
  fs.ThousandSeparator:= #0;
  F := GetAsFloat;
  Result := FormatFloat('0.0#########', F, fs); // format with your preferences
end;
{$ENDIF}



end.
