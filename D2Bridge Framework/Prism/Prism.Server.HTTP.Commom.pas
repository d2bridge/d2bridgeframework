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

{$I ..\D2Bridge.inc}

unit Prism.Server.HTTP.Commom;

interface

uses
  Classes, SysUtils, DateUtils, Generics.Collections,
  Prism.Types;

type
 TPrismHTTPHeader = class
  private
  public
   WebMethod: TWebMethod;
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
   Token: string;
   PrismSession: string;
   ServerUUID: string;
   Cookies: string;
   //WebSocket
   Connection: string;
   Upgrade: string;
   SecWebSocketKey: string;
   Boundary: string;
   IPListedInBlackList: boolean;
   TooManyConnFromIP: boolean;

   function FullURL: string;
   function URL: string;
   function PathWithoutParams: string;

   function ClientIP: string;

   constructor Create;
   destructor Destroy; override;
 end;



 TPrismHTTPRequest = class
  strict private
   FHeader: TPrismHTTPHeader;
  public
   constructor Create;
   destructor Destroy; override;

   property Header: TPrismHTTPHeader read FHeader write FHeader;
 end;


 TPrismHTTPResponse = class
  strict private
  public
   Headers: TStrings;
   ContentType: string;
   StatusCode: string;
   charset: string;
   Content: String;
   FileName: string;
   Error: boolean;
   ErrorMessage: string;

   constructor Create;
   destructor Destroy; override;
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

implementation

{ TPrismHTTPRequest }

constructor TPrismHTTPRequest.Create;
begin
end;

destructor TPrismHTTPRequest.Destroy;
begin
 inherited;
end;

{ TPrismHTTPHeader }

function TPrismHTTPHeader.ClientIP: string;
begin
 result:= '';

 if ForwardedIP <> '' then
  result:= ForwardedIP
 else
  result:= RemoteIP;
end;

constructor TPrismHTTPHeader.Create;
begin
 RawHeaders:= TStringList.Create;
 QueryParams:= TStringList.Create;
 RefererQueryParams:= TStringList.Create;
 ReloadPage:= false;
 IPListedInBlackList:= false;
 UserAgentBlocked:= false;
 TooManyConnFromIP:= false;
 IsUploadFile:= false;
end;

destructor TPrismHTTPHeader.Destroy;
begin
 RawHeaders.Free;
 QueryParams.Free;
 RefererQueryParams.Free;

 inherited;
end;

function TPrismHTTPHeader.FullURL: string;
begin
 result:= Protocol + '://' + Host + ':' + IntToStr(ServerPort) + Path;
end;

function TPrismHTTPHeader.PathWithoutParams: string;
var
 vPathWithoutParams: string;
begin
 if AnsiPos('?', Path) > 0 then
  vPathWithoutParams:= Copy(Path, 1, AnsiPos('?', Path)-1)
 else
  vPathWithoutParams:= Path;

 Result:= vPathWithoutParams;
end;

function TPrismHTTPHeader.URL: string;
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

 ContentType:= 'text/html';
 charset:= 'UTF-8';
 StatusCode:= '200 OK';
 Error:= false;
end;

destructor TPrismHTTPResponse.Destroy;
begin
 Headers.Free;
 inherited;
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

end.
