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

unit Prism.Server.TCP;

interface

uses
  SysUtils, Classes, StrUtils, DateUtils, Generics.Collections, RTTI, Variants,
  D2Bridge.JSON,
{$IFNDEF FPC}
  NetEncoding,
{$ELSE}
  LazUtf8, base64,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  IdCustomTCPServer, IdCustomHTTPServer, IdContext, IdSSL, IdSSLOpenSSL, IdURI, IdCoderMIME,
  IdHashSHA, IdGlobal, IdIOHandler,
  Prism.WebSocketContext, Prism.Server.HTTP.Commom, Prism.Types, Prism.Util, Prism.Interfaces,
  Prism.Session.Thread.Proc;



type
 TIdContext = IdContext.TIdContext;
 TPrismHTTPRequest = Prism.Server.HTTP.Commom.TPrismHTTPRequest;
 TPrismHTTPResponse = Prism.Server.HTTP.Commom.TPrismHTTPResponse;
 TPrismWebSocketContext = Prism.WebSocketContext.TPrismWebSocketContext;
 TPrismWebSocketMessage = Prism.Server.HTTP.Commom.TPrismWebSocketMessage;

 TStreamFileStatus = (SFSNone, SFSWaitingFile, SFSCreateFile, SFSWriteFile, SFSEndFile);

 TOnGetHTML = procedure(APrismRequest: TPrismHTTPRequest; var APrismReponse: TPrismHTTPResponse; var APrismWSContext: TPrismWebSocketContext) of object;
 TOnRESTData = procedure(APrismRequest: TPrismHTTPRequest; var APrismReponse: TPrismHTTPResponse; var APrismWSContext: TPrismWebSocketContext) of object;
 TOnDownloadData = procedure(APrismRequest: TPrismHTTPRequest; var APrismReponse: TPrismHTTPResponse; var APrismWSContext: TPrismWebSocketContext) of object;
 TOnFinishedGetHTML = procedure(APrismWSContext: TPrismWebSocketContext) of object;
 TOnGetFile = procedure(const APrismRequest: TPrismHTTPRequest; const AGetFileName: string; var AResponseFileName: string; var AResponseFileContent: string; var AResponseRedirect: string; var AMimeType: string) of object;
 TOnReceiveMessage = function(AMessage: TPrismWebSocketMessage; PrismWSContext: TPrismWebSocketContext): string of object;
 TOnParseFile = procedure(AFileName: string; AContext: TIdContext; APrismRequest: TPrismHTTPRequest; var APrismReponse: TPrismHTTPResponse; var APrismWSContext: TPrismWebSocketContext) of object;

type

  { TPrismServerTCP }

  TPrismServerTCP = class(TIdCustomTCPServer)
  strict private
{$IFDEF D2BRIDGE}
   procedure Exec_OpenForm(varContext, varPrismHTTPRequest, varPrismWSContext: TValue);
   procedure Exec_RouteAuth(varContext, varPrismHTTPRequest: TValue);
   procedure Exec_ReceiveMessage(varPrismWebSocketMessage, varPrismWSContext: TValue);
{$ENDIF}
  private
   FOnGetHTML: TOnGetHTML;
   FOnReceiveMessage: TOnReceiveMessage;
   FOnGetFile: TOnGetFile;
   FOnFinishedGetHTML: TOnFinishedGetHTML;
   FOnRESTData: TOnRESTData;
   FOnDownloadData: TOnDownloadData;
   FOnParseFile: TOnParseFile;
   IdServerIOHandlerSSLOpenSSL: TIdServerIOHandlerSSLOpenSSL;
   FRootDirectory: string;
   FMimesType: TPrismServerFileExtensions;
   FAppBase: string;
   function IdContextConnected(AContext: TIdContext): boolean;
   function MimesType: TPrismServerFileExtensions;
   procedure InterceptExecute(AContext: TIdContext);
   procedure DoGetHTML(AContext: TIdContext; APrismRequest: TPrismHTTPRequest; var APrismReponse: TPrismHTTPResponse; var PrismWSContext: TPrismWebSocketContext); virtual;
   procedure DoDownloadData(AContext: TIdContext; APrismRequest: TPrismHTTPRequest; var APrismReponse: TPrismHTTPResponse; var PrismWSContext: TPrismWebSocketContext); virtual;
   procedure DoRESTData(AContext: TIdContext; APrismRequest: TPrismHTTPRequest; var APrismReponse: TPrismHTTPResponse; var PrismWSContext: TPrismWebSocketContext); virtual;
   procedure DoParseFile(AFileName: string; AContext: TIdContext; APrismRequest: TPrismHTTPRequest; var APrismReponse: TPrismHTTPResponse; var APrismWSContext: TPrismWebSocketContext); virtual;
   procedure DoFinishedGetHTML(APrismWSContext: TPrismWebSocketContext);
   function DoReceiveMessage(AMessage: string; PrismWSContext: TPrismWebSocketContext): string; virtual;
   procedure DoUploadFile(AFiles: TStrings; PrismSession: IPrismSession; AFormUUID, ASender: string);
   function FormatReceivedMesssage(AMessage: string): TPrismWebSocketMessage;
   procedure RemoveEscapeFromFileURL(var vFileName: string);
   procedure InsertEscapeToFileURL(var vFileName: string);
   function GetAppBase: string;
   procedure SetAppBase(const Value: string);
  protected
{$IFDEF D2BRIDGE}
   procedure DoConnect(AContext: TIdContext); override;
   procedure DoDisconnect(AContext: TIdContext); override;
   function DoExecute(AContext: TIdContext): Boolean; override;
{$ENDIF}
  public
   const
   FpathWebSocket = '/websocket';
   FpathRESTServer = '/rest';
   FpathDownload = '/d2bridge/download';
   FpathUpload = '/d2bridge/upload';
   Fhtmlconnectiontimeout = 64000;
   Fhtmlconnectionmax = 0;
   fServerName = 'PrismServer with D2Bridge Framework Server';
   constructor Create;
   destructor Destroy; override;

   function ParseHeaders(AContext: TIdContext; const AHTMLHeader: string): TPrismHTTPRequest;

   procedure ReadMultipartFormData(IOHandler: TIdIOHandler; Boundary: String; ContentLength: Integer; AFiles: TStrings; ASender: string; PrismWSContext: TPrismWebSocketContext);
   function ReadBodyStringFromData(IOHandler: TIdIOHandler; ContentLength: Integer): string;
   function ReadBodyStreamFromData(IOHandler: TIdIOHandler; ContentLength: Integer): TMemoryStream;

   procedure SendWebSocketMessage(AMessage: string; APrismSession: IPrismSession);
   procedure DisconnectWebSocketMessage(APrismSession: IPrismSession; NilPrismSession: Boolean = false);
   procedure CloseAllConnection;
   procedure InitSSL(AIdServerIOHandlerSSLOpenSSL: TIdServerIOHandlerSSLOpenSSL);

   function OpenSSL: TIdServerIOHandlerSSLOpenSSL;

   property AppBase: string read GetAppBase write SetAppBase;

   property OnGetHTML: TOnGetHTML read FOnGetHTML write FOnGetHTML;
   property OnGetFile: TOnGetFile read FOnGetFile write FOnGetFile;
   property OnFinishedGetHTML: TOnFinishedGetHTML read FOnFinishedGetHTML write FOnFinishedGetHTML;
   property OnReceiveMessage: TOnReceiveMessage read FOnReceiveMessage write FOnReceiveMessage;
   property OnRESTData: TOnRestData read FOnRestData write FOnRestData;
   property OnDownloadData: TOnDownloadData read FOnDownloadData write FOnDownloadData;
   property OnParseFile: TOnParseFile read FOnParseFile write FOnParseFile;
   property RootDirectory: string read FRootDirectory write FRootDirectory;
   //property OnCommandGet;
   //property OnExecute;
  end;


type
  TWebSocketIOHandlerHelper = class(TIdIOHandler)
  public
    function ReadBytes: TArray<byte>;
    function ReadString: string;

    procedure WriteBytes(RawData: TArray<byte>);
    procedure WriteString(const str: string);
  end;

const
 URLInternalAPI = '/d2bridge/api';
 URLAPIAuth = URLInternalAPI + '/auth';

var
  PrismServer: TPrismServerTCP;

implementation

uses
  Prism.BaseClass, Prism.Session, Prism.Session.Helper, Prism.Options.Security.Event,
  D2Bridge.Lang.Core, D2Bridge.API.Auth, D2Bridge.Util,
  D2Bridge.Rest.Route,
  IdTCPConnection;


{ TPrismServerTCP }

procedure TPrismServerTCP.CloseAllConnection;
var
 Clients: TList;
 I: Integer;
begin
 if self <> nil then
 begin
  if (Contexts = nil) and (not Assigned(Contexts)) then
  exit;

  Clients := Contexts.LockList;

  try
    for i := 0 to Clients.Count - 1 do
       TIdContext(Clients[i]).Connection.Disconnect;
  finally
   Contexts.UnlockList;
  end;
 end;
end;

constructor TPrismServerTCP.Create;
begin
  inherited Create;

  FMimesType:= TPrismServerFileExtensions.Create;

  IdServerIOHandlerSSLOpenSSL := nil;

  FRootDirectory:= 'wwwroot' + PathDelim;

  FAppBase:= '/';


  //OnExecute := InterceptExecute;

  //OnCommandGet:= CommandGetEvent;
end;

destructor TPrismServerTCP.Destroy;
begin
 FreeAndNil(FMimesType);

 inherited;
end;

procedure TPrismServerTCP.DisconnectWebSocketMessage(APrismSession: IPrismSession; NilPrismSession: Boolean = false);
var
 vContext: TIdContext;
begin

 try
  vContext:= (APrismSession as TPrismSession).WebSocketContext;

  (APrismSession as TPrismSession).WebSocketContext:= nil;

  if Assigned(vContext) then
  begin
   try
    if NilPrismSession then
     if (vContext.Data is TPrismWebSocketContext) then
     begin
      try
       (vContext.Data as TPrismWebSocketContext).Destroy;
       vContext.Data:= nil;
      except
      end;
     end;
   except
   end;

   try
    if Assigned(vContext.Connection) then
     if Assigned(vContext.Connection.IOHandler) then
      if vContext.Connection.Connected then
      begin
       vContext.Connection.Disconnect(true);
      end;
   except
   end;
  end;
 except
 end;
end;

//procedure TPrismServerTCP.DoCommandGet(AContext: TIdContext;
//  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
//begin
// inherited;
//
//// if ARequestInfo.Document = '/' then
// var a:= '';
//
//end;

{$IFDEF D2BRIDGE}
procedure TPrismServerTCP.DoConnect(AContext: TIdContext);
var
 URLPath: string;
 URI: TIdURI;
 Params: TStrings;
begin
 if AContext.Connection.IOHandler is TIdSSLIOHandlerSocketBase then
 begin
    TIdSSLIOHandlerSocketBase(AContext.Connection.IOHandler).PassThrough := false;
 end;

// URLPath := AContext.Connection.IOHandler.ReadLn;
// URLPath:= Copy(URLPath, AnsiPos('/', URLPath));
// URLPath:= Copy(URLPath, 1, AnsiPos(' ', URLPath)-1);
//
//
// //'GET / HTTP/1.1'
//
// if URLPath = '/ws' then
// begin
//  URI := TIdURI.Create(URLPath);
//  Params:= TStringList.Create;
//  try
//   Params.LineBreak:= '&';
//   Params.Text := URI.Params;
//
// if not Assigned(AContext.Data) then
//  AContext.Data:= TPrismWebSocketContext.Create;
//    (
//      Params.Values['token'],
//      Params.Values['channelname'],
//      Params.Values['prismsession'],
//      Params.Values['formuuid']
//    );
//
//  finally
//   URI.Free;
//   Params.Free;
//  end;
// end;

 inherited;
end;
{$ENDIF}

{$IFDEF D2BRIDGE}
procedure TPrismServerTCP.DoDisconnect(AContext: TIdContext);
var
 vWebSocketContext: TPrismWebSocketContext;
 vPrismSession: TPrismSession;
begin
 try
  if Assigned(AContext.Data) and
     (AContext.Data is TPrismWebSocketContext) then
  begin
   try
    vWebSocketContext:= TPrismWebSocketContext(AContext.Data);
    vPrismSession:= vWebSocketContext.PrismSession;

    if Assigned(vPrismSession) and
       (not vPrismSession.Destroying) then
    begin
     try
      if Assigned(vPrismSession.WebSocketContext) then
      begin
       if vPrismSession.WebSocketContext = AContext then
       begin
        vPrismSession.WebSocketContext:= nil;

        if not vPrismSession.Destroying then
         PrismBaseClass.ServerController.DoSessionChange(scsLostConnectioSession, vPrismSession);
       end;
      end else
      begin
       if not vPrismSession.Destroying then
        PrismBaseClass.ServerController.DoSessionChange(scsLostConnectioSession, vPrismSession);
      end;
     except
     end;
    end;

    try
     FreeAndNil(vWebSocketContext);
    except
    end;
   except
   end;
  end;

  try
   AContext.Data:= nil;
  except
  end;
 except
 end;

 inherited;
end;
{$ENDIF}

procedure TPrismServerTCP.DoDownloadData(AContext: TIdContext;
  APrismRequest: TPrismHTTPRequest; var APrismReponse: TPrismHTTPResponse;
  var PrismWSContext: TPrismWebSocketContext);
begin
 if Assigned(FOnDownloadData) then
  FOnDownloadData(APrismRequest, APrismReponse, PrismWSContext);
end;

{$IFDEF D2BRIDGE}
function TPrismServerTCP.DoExecute(AContext: TIdContext): Boolean;
var
  I: integer;
  c: TIdIOHandler;
  vPrismWSContext: TPrismWebSocketContext;
  SecWebSocketKey, Hash: string;
  vPrismRequest: TPrismHTTPRequest;
  vPrismResponse: TPrismHTTPResponse;
  RequestLine, Headers, Line: string;
  vPrismSession: TPrismSession;
  vFileName: String;
  ContentLength: integer;
  vResponseFileName, vResponseFileContent, vResponseRedirect, vResponseContent, vMimeType: string;
  vCloseConnection: boolean;
  vProc: TPrismSessionThreadProc;
  vIsProc: Boolean;
  vJSON: TJSONObject;
  vPOSTStrContent: string;
  vPageError403BlackList: string;
  vContentLength: Integer;
  vContentStr: string;
  idHashSHA1: TIdHashSHA1;
  vUploadOrigin: string;
  vUploadFilesList: TStrings;
  vURLUploadFile, vUploadSender: string;
  vJSONViewportinfo: TJSONObject;
begin
 result:= false;
 vIsProc:= false;
 vPrismWSContext:= nil;

 try
  c := AContext.Connection.IOHandler;
 except
  Result:= false;
  exit;
 end;

 InterceptExecute(AContext);

 RequestLine := '';
 //c.CheckForDataOnSource(10);
 vCloseConnection:= true;

 try
  if (c.Tag <> 99) and (AContext.Connection.Connected) then
  begin
   RequestLine := AContext.Connection.IOHandler.ReadLn;
  end;
 except
  RequestLine:= '';
 end;


 if RequestLine <> '' then
 begin
  // Read string and parse HTTP headers

  c.Tag:= 99;

  try
   Headers := RequestLine + sLineBreak;
   repeat
    Line := AContext.Connection.IOHandler.ReadLn;
    Headers := Headers + Line + sLineBreak;

//      if AContext.Connection <> nil then
//        if AContext.Connection.Connected then
//         AContext.Connection.IOHandler.Connected

   until (Headers = sLineBreak) or (Line = '') or
         (AContext.Connection = nil) or
         (not AContext.Connection.Connected) or
         (not Assigned(AContext.Connection.IOHandler)) or
         (not AContext.Connection.IOHandler.Connected)
  except
   result:= false;

   exit;
  end;

  vPrismRequest:= ParseHeaders(AContext, Headers);


  if (not Assigned(vPrismRequest.Route)) and (not Assigned(PrismBaseClass.ServerController.PrimaryFormClass)) then
  begin
   vPrismRequest.Free;

   try
    if AContext.Connection <> nil then
     if AContext.Connection.Connected then
     begin
      AContext.Connection.IOHandler.Close;
      AContext.Connection.IOHandler.Free;
      AContext.Connection.Disconnect;
     end;
   except
   end;
  end else
  if (vPrismRequest.IPListedInBlackList) then  //BlackList
  begin
   if (vPrismRequest.WebMethod = wmtPOST) and
      (PrismBaseClass.Options.Security.IP.IPv4BlackList.EnableSelfDelist) and
      (not vPrismRequest.UserAgentBlocked) and
      (AnsiPos('/security/blacklist/delist', vPrismRequest.Path) > 0) and
      (vPrismRequest.ContentType = 'application/json') and
      (TryStrToInt(vPrismRequest.ContentLength, vContentLength)) and
      (PrismBaseClass.Options.Security.IP.IPConnections.IsIPAllowed(vPrismRequest.ClientIP)) then
   begin
    try
     vPOSTStrContent:= ReadBodyStringFromData(c, vContentLength);

     if (IsJSONValid(vPOSTStrContent)) then
      vJSON:= TJSONObject.ParseJSONValue(vPOSTStrContent) as TJSONObject;

     if Assigned(vJSON) and PrismBaseClass.Options.Security.IP.IPv4BlackList.IsValidTokenDelist(vPrismRequest.ClientIP, vJSON, true) then
     begin
      EventDelistIPBlackList(vPrismRequest.ClientIP, vPrismRequest.UserAgent);

      PrismBaseClass.Options.Security.IP.IPv4WhiteList.Add(vPrismRequest.ClientIP);

      vResponseContent:= '{"success" : true, "message" : "Delist Ok"}';
      c.WriteLn('HTTP/1.1 200 OK');
      c.WriteLn('Server: '+fServerName);
      c.WriteLn('Content-Type: application/json; charset=UTF-8');
      c.WriteLn('Content-Length: ' + IntToStr(Length(vResponseContent)));
      c.WriteLn('Connection: Close');
{$IFDEF D2DOCKER}
       c.WriteLn('D2DockerInstance: ' + PrismBaseClass.ServerController.D2DockerInstanceAlias);
{$ENDIF}
      c.WriteLn('');
      c.Write(vResponseContent, IndyTextEncoding_UTF8);
     end else
     begin
      EventNotDelistIPBlackList(vPrismRequest.ClientIP, vPrismRequest.UserAgent);

      vResponseContent:= '{success: false, message: "Invalid token or request not allowed"}';
      c.WriteLn('HTTP/1.1 403 Forbidden');
      c.WriteLn('Server: '+fServerName);
      c.WriteLn('Content-Type: application/json; charset=UTF-8');
      c.WriteLn('Content-Length: ' + IntToStr(Length(vResponseContent)));
      c.WriteLn('Connection: Close');
{$IFDEF D2DOCKER}
       c.WriteLn('D2DockerInstance: ' + PrismBaseClass.ServerController.D2DockerInstanceAlias);
{$ENDIF}
      c.WriteLn('');
      c.WriteLn(vResponseContent, IndyTextEncoding_UTF8);
     end;
    except
    end;
    vJSON.Free;
   end else
   if (vPrismRequest.WebMethod = wmtGET) and
      (PrismBaseClass.Options.Security.IP.IPv4BlackList.EnableSelfDelist) and
      (not vPrismRequest.UserAgentBlocked) and
      ((vPrismRequest.Path = '/') or (vPrismRequest.Path = '') or (Copy(vPrismRequest.Path, 1,2) = '/?') or (vPrismRequest.Path = '/')) and //VirtualPath
      (PrismBaseClass.Options.Security.IP.IPConnections.IsIPAllowed(vPrismRequest.ClientIP)) then
   begin
    EventBlockIPBlackList(vPrismRequest.ClientIP, vPrismRequest.UserAgent);

    vPageError403BlackList:= PrismBaseClass.PrismServerHTML.GetErrorBlackList(vPrismRequest.AcceptLanguage);
    vPageError403BlackList:= StringReplace(vPageError403BlackList, '{{ip}}', vPrismRequest.ClientIP, [rfReplaceAll]);
    vPageError403BlackList:= StringReplace(vPageError403BlackList, '{{token}}', PrismBaseClass.Options.Security.IP.IPv4BlackList.CreateTokenDelist(vPrismRequest.ClientIP), [rfReplaceAll]);

    c.WriteLn('HTTP/1.1 403 Forbidden');
    c.WriteLn('Content-Type: text/html; charset=UTF-8');
{$IFDEF D2DOCKER}
     c.WriteLn('D2DockerInstance: ' + PrismBaseClass.ServerController.D2DockerInstanceAlias);
{$ENDIF}
    //c.WriteLn('Content-Length: ' + IntToStr(IndyLength(vPageError403BlackList)));
    c.WriteLn('');
    c.Write(vPageError403BlackList, IndyTextEncoding_UTF8);
   end else
   begin
    EventBlockIPBlackList(vPrismRequest.ClientIP, vPrismRequest.UserAgent);

    c.WriteLn('HTTP/1.1 403 Forbidden');
    c.WriteLn('Content-Type: text/plain');
{$IFDEF D2DOCKER}
     c.WriteLn('D2DockerInstance: ' + PrismBaseClass.ServerController.D2DockerInstanceAlias);
{$ENDIF}
    c.WriteLn('');
    c.WriteLn('D2Bridge Framework Application');
    c.WriteLn('Access Denied');
    c.Write('Your IP ' + vPrismRequest.ClientIP + ' listed in BlackList');
   end;

   vPrismRequest.Free;

   try
    if AContext.Connection <> nil then
     if AContext.Connection.Connected then
     begin
      AContext.Connection.IOHandler.Close;
      AContext.Connection.IOHandler.Free;
      AContext.Connection.Disconnect;
     end;
   except
   end;
  end else
  if (vPrismRequest.UserAgentBlocked)  then
  begin
   EventBlockUserAgent(vPrismRequest.ClientIP, vPrismRequest.UserAgent);

   c.WriteLn('HTTP/1.1 451 Unavailable For Legal Reasons');
   c.WriteLn('Content-Type: text/plain');
{$IFDEF D2DOCKER}
    c.WriteLn('D2DockerInstance: ' + PrismBaseClass.ServerController.D2DockerInstanceAlias);
{$ENDIF}
   c.WriteLn('');
   c.WriteLn('Blocked by User-Agent Policy');

   vPrismRequest.Free;

   try
    if AContext.Connection <> nil then
     if AContext.Connection.Connected then
     begin
      AContext.Connection.IOHandler.Close;
      AContext.Connection.IOHandler.Free;
      AContext.Connection.Disconnect;
     end;
   except
   end;
  end else
  if (vPrismRequest.Purpose = 'prefetch')  then
  begin
   vContentStr:= '{"status":204,"serveruuid":"'+PrismBaseClass.ServerUUID+'"}';
   if SameText(vPrismRequest.Accept, 'application/json') then
    c.WriteLn('HTTP/1.1 200 OK')
   else
    c.WriteLn('HTTP/1.1 204 Found');
   c.WriteLn('Connection: Close');
   c.WriteLn('Server: '+fServerName);
   if SameText(vPrismRequest.Accept, 'application/json') then
   begin
    c.WriteLn('Content-Type: application/json; charset=UTF-8');
    c.WriteLn('Content-Length: ' + IntToStr(Length(vContentStr)));
   end;
{$IFDEF D2DOCKER}
    c.WriteLn('D2DockerInstance: ' + PrismBaseClass.ServerController.D2DockerInstanceAlias);
{$ENDIF}
   c.WriteLn('');
   if SameText(vPrismRequest.Accept, 'application/json') then
    c.WriteLn(vContentStr);

   vPrismRequest.Free;

   try
    if AContext.Connection <> nil then
     if AContext.Connection.Connected then
     begin
      AContext.Connection.IOHandler.Close;
      AContext.Connection.IOHandler.Free;
      AContext.Connection.Disconnect;
     end;
   except
   end;
  end else
  if (vPrismRequest.WebMethod = wmtHEAD) and (AnsiPos('reconnect?token=', vPrismRequest.Path) > 0)  then
  begin
   if PrismBaseClass.Sessions.Exist(vPrismRequest.QueryParams.Values['prismsession'], vPrismRequest.QueryParams.Values['token']) then
   begin
    c.WriteLn('HTTP/1.1 202 Accepted');
    c.WriteLn('Connection: Close');
    c.WriteLn('Server: '+fServerName);
{$IFDEF D2DOCKER}
     c.WriteLn('D2DockerInstance: ' + PrismBaseClass.ServerController.D2DockerInstanceAlias);
{$ENDIF}
    c.WriteLn('');
   end else
   begin
    c.WriteLn('HTTP/1.1 401 Unauthorized');
    c.WriteLn('Connection: Close');
    c.WriteLn('Server: '+fServerName);
{$IFDEF D2DOCKER}
     c.WriteLn('D2DockerInstance: ' + PrismBaseClass.ServerController.D2DockerInstanceAlias);
{$ENDIF}
    c.WriteLn('');
   end;

   vPrismRequest.Free;

   try
    if AContext.Connection <> nil then
     if AContext.Connection.Connected then
     begin
      AContext.Connection.IOHandler.Close;
      AContext.Connection.IOHandler.Free;
      AContext.Connection.Disconnect;
     end;
   except
   end;
  end else
  if (AnsiPos(FpathUpload, vPrismRequest.Path) > 0) or (vPrismRequest.IsUploadFile) then
  begin
   if (vPrismRequest.Boundary <> '') and TryStrToInt(vPrismRequest.ContentLength, ContentLength) and (ContentLength > 0)  then
   begin
    vPrismWSContext := TPrismWebSocketContext.Create;

    vPrismWSContext.Token := vPrismRequest.QueryParams.Values['token'];
    vPrismWSContext.ChannelName := vPrismRequest.QueryParams.Values['channelname'];
    vPrismWSContext.PrismSessionUUID := vPrismRequest.QueryParams.Values['prismsession'];
    vPrismWSContext.FormUUID := vPrismRequest.QueryParams.Values['formuuid'];
    vUploadOrigin:= vPrismRequest.QueryParams.Values['origin'];
    vUploadSender:= vPrismRequest.QueryParams.Values['sender'];

    if (vPrismWSContext.PrismSessionUUID <> '') and
       (vPrismWSContext.FormUUID <> '') and
       (vPrismWSContext.Token <> '') then
    begin
     if PrismBaseClass.Sessions.Exist(vPrismWSContext.PrismSessionUUID) then
     begin
      vPrismSession:= PrismBaseClass.Sessions.Item[vPrismWSContext.PrismSessionUUID] as TPrismSession;

      if vPrismSession.Token = vPrismWSContext.Token then
      begin
       vPrismWSContext.PrismSession:= vPrismSession;

       vUploadFilesList:= TStringList.Create;
       ReadMultipartFormData(c, vPrismRequest.Boundary, ContentLength, vUploadFilesList, vUploadSender, vPrismWSContext);

       c.WriteLn('HTTP/1.1 200 OK');
       c.WriteLn('Connection: Close');
       c.WriteLn('Server: '+fServerName);
{$IFDEF D2DOCKER}
        c.WriteLn('D2DockerInstance: ' + PrismBaseClass.ServerController.D2DockerInstanceAlias);
{$ENDIF}
       c.WriteLn('');
       if (vUploadOrigin = 'editor') and (vUploadFilesList.Count > 0) then
       begin
        vURLUploadFile:= RelativeFileFromRoot(vUploadFilesList[0]);
        vURLUploadFile:= StringReplace(vURLUploadFile, '\', '/', [rfReplaceAll]);
        vURLUploadFile:= URLEncode(vURLUploadFile);
        vURLUploadFile:= StringReplace(vURLUploadFile, '%2F', '/', [rfReplaceAll]);
        c.WriteLn('{"data": {"filePath": "' + vURLUploadFile + '"}}');
       end;

       vUploadFilesList.Free;
      end;
     end;
    end;

    FreeAndNil(vPrismWSContext);
   end;

   vPrismRequest.Free;

   try
    if AContext.Connection <> nil then
     if AContext.Connection.Connected then
     begin
      AContext.Connection.IOHandler.Close;
      AContext.Connection.IOHandler.Free;
      AContext.Connection.Disconnect;
     end;
   except
   end;
  end else
  if (AnsiPos(FpathDownload+'?file=', vPrismRequest.Path) > 0) then
  begin
   vPrismResponse:= TPrismHTTPResponse.Create;

   if not Assigned(AContext.Data) then
    AContext.Data:= TPrismWebSocketContext.Create;
   vPrismWSContext := TPrismWebSocketContext(AContext.Data);

   vPrismWSContext.Token := vPrismRequest.QueryParams.Values['token'];
   vPrismWSContext.ChannelName := vPrismRequest.QueryParams.Values['channelname'];
   vPrismWSContext.PrismSessionUUID := vPrismRequest.QueryParams.Values['prismsession'];
   vPrismWSContext.FormUUID := vPrismRequest.QueryParams.Values['FormUUID'];

   DoDownloadData(AContext, vPrismRequest, vPrismResponse, vPrismWSContext);

   if vPrismResponse.FileName <> '' then
   begin
    vFileName:= ExtractFileName(vPrismResponse.FileName);

    c.WriteLn('HTTP/1.1 ' + HttpParseStatusCode(vPrismResponse.StatusCode));
    c.WriteLn('Content-Type: '+MimesType.GetMimeType(vFileName)+'; charset='+vPrismResponse.charset);
    c.WriteLn('Content-Disposition: attachment; filename="'+ExtractFileName(vFileName)+'"');
    c.WriteLn('Connection: Close');
    c.WriteLn('Server: '+fServerName);
{$IFDEF D2DOCKER}
     c.WriteLn('D2DockerInstance: ' + PrismBaseClass.ServerController.D2DockerInstanceAlias);
{$ENDIF}
    c.WriteLn('');

    c.WriteFile(vPrismResponse.FileName);
   end;

   //FreeAndNil(vPrismRequest);
   FreeAndNil(vPrismResponse);

   vPrismRequest.Free;

   try
    if AContext.Connection <> nil then
     if AContext.Connection.Connected then
     begin
      AContext.Connection.IOHandler.Close;
      AContext.Connection.IOHandler.Free;
      AContext.Connection.Disconnect;
     end;
   except
   end;
  end else
  if (AnsiPos(FpathRESTServer+'/json/jqgrid/post', vPrismRequest.Path) > 0) then
  begin
   vPrismResponse:= TPrismHTTPResponse.Create;

   if not Assigned(AContext.Data) then
    AContext.Data:= TPrismWebSocketContext.Create;
   vPrismWSContext := TPrismWebSocketContext(AContext.Data);

   vPrismWSContext.Token := vPrismRequest.QueryParams.Values['token'];
   vPrismWSContext.ChannelName := vPrismRequest.QueryParams.Values['channelname'];
   vPrismWSContext.PrismSessionUUID := vPrismRequest.QueryParams.Values['prismsession'];
   vPrismWSContext.FormUUID := vPrismRequest.QueryParams.Values['FormUUID'];

   DoRESTData(AContext, vPrismRequest, vPrismResponse, vPrismWSContext);

   if (vPrismResponse.Content <> '') or
      ((AnsiPos(FpathRESTServer+'/json/jqgrid/post', vPrismRequest.Path) > 0) and (not vPrismResponse.Error)) then
   begin
    c.WriteLn('HTTP/1.1 ' + HttpParseStatusCode(vPrismResponse.StatusCode));
    c.WriteLn('Content-Type: '+vPrismResponse.ContentType+'; charset='+vPrismResponse.charset);
    c.WriteLn('Connection: Close');
    c.WriteLn('Server: '+fServerName);
{$IFDEF D2DOCKER}
     c.WriteLn('D2DockerInstance: ' + PrismBaseClass.ServerController.D2DockerInstanceAlias);
{$ENDIF}
    c.WriteLn('');

    if vPrismResponse.Content <> '' then
    C.Write(vPrismResponse.Content, IndyTextEncoding_UTF8);
   end;

   //FreeAndNil(vPrismRequest);
   FreeAndNil(vPrismResponse);

   vPrismRequest.Free;

   try
    if AContext.Connection <> nil then
     if AContext.Connection.Connected then
     begin
      AContext.Connection.IOHandler.Close;
      AContext.Connection.IOHandler.Free;
      AContext.Connection.Disconnect;
     end;
   except
   end;
  end else
  if (AnsiPos(URLAPIAuth, vPrismRequest.Path) > 0) then  //Auth
  begin
   vProc:= TPrismSessionThreadProc.Create(nil,
    Exec_RouteAuth,
    TValue.From<TIdContext>(AContext),
    TValue.From<TPrismHTTPRequest>(vPrismRequest)
   );

   vIsProc:= true;

   vProc.Exec;
  end else
  if vPrismRequest.WebMethod in [wmtGET, wmtPOST, wmtPUT, wmtDELETE, wmtPATCH] then
  begin
   if (vPrismRequest.WebMethod in [wmtGET, wmtPOST]) and
      (vPrismRequest.Upgrade = 'websocket') and (vPrismRequest.SecWebSocketKey <> '') and
      ((AnsiPos(FpathWebSocket+'/connectionparams', vPrismRequest.Path) > 0) or (AnsiPos(FpathWebSocket+'/connectionresponseparams', vPrismRequest.Path) > 0)) and
      ((not Assigned(AContext.Data)) or (Assigned(AContext.Data) and (AContext.Data is TPrismWebSocketContext) and (not vPrismWSContext.Established))) then
   begin
    {$REGION 'Handshaking WebSockets'}
    if not Assigned(AContext.Data) then
     AContext.Data:= TPrismWebSocketContext.Create;
    vPrismWSContext := TPrismWebSocketContext(AContext.Data);

    if vPrismWSContext.Token = '' then
    begin
     vPrismWSContext.Token := vPrismRequest.QueryParams.Values['token'];
     vPrismWSContext.ChannelName := vPrismRequest.QueryParams.Values['channelname'];
     vPrismWSContext.PrismSessionUUID := vPrismRequest.QueryParams.Values['prismsession'];
     vPrismWSContext.FormUUID := vPrismRequest.QueryParams.Values['FormUUID'];
     if not Assigned(vPrismWSContext.PrismSession) then
      vPrismWSContext.PrismSession:= PrismBaseClass.Sessions.Item[vPrismWSContext.PrismSessionUUID] as TPrismSession;
     if (AnsiPos(FpathWebSocket+'/connectionparams', vPrismRequest.Path) > 0) then
     vPrismWSContext.ChannelName:= 'PrismSocketConnection'
     else
     if (AnsiPos(FpathWebSocket+'/connectionresponseparams', vPrismRequest.Path) > 0) then
     vPrismWSContext.ChannelName:= 'PrismSocketResponse';

     if Assigned(vPrismWSContext.PrismSession) then
      (vPrismWSContext.PrismSession as TPrismSession).WebSocketContext:= AContext;
    end;

    if (vPrismWSContext.Token <> '') and (Assigned(vPrismWSContext.PrismSession)) and (vPrismWSContext.Token <> vPrismWSContext.PrismSession.Token) then
    begin
     vPrismRequest.Free;

     try
      if AContext.Connection <> nil then
       if AContext.Connection.Connected then
       begin
        AContext.Connection.IOHandler.Close;
        AContext.Connection.IOHandler.Free;
        AContext.Connection.Disconnect;
       end;
     except
     end;
     //AContext.Connection.IOHandler.CloseGracefully;

     exit;
    end else
    begin
     if (vPrismWSContext.Token <> '') and (not Assigned(vPrismWSContext.PrismSession)) then
     if PrismBaseClass.Sessions.Exist(vPrismWSContext.PrismSessionUUID) and (vPrismWSContext.Token = PrismBaseClass.Sessions.Item[vPrismWSContext.PrismSessionUUID].Token) then
      vPrismWSContext.PrismSession:= PrismBaseClass.Sessions.Item[vPrismWSContext.PrismSessionUUID] as TPrismSession
     else
     begin
      vPrismRequest.Free;

      try
       if AContext.Connection <> nil then
        if AContext.Connection.Connected then
        begin
         AContext.Connection.IOHandler.Close;
         AContext.Connection.IOHandler.Free;
         AContext.Connection.Disconnect;
        end;
      except
      end;
      //AContext.Connection.IOHandler.CloseGracefully;

      exit;
     end;
    end;


    //Screen Size
    if vPrismRequest.QueryParams.Values['viewportinfo'] <> '' then
    begin
     try
      vPrismWSContext.PrismSession.InfoConnection.Screen.ProcessScreenInfo(vPrismRequest.QueryParams.Values['viewportinfo']);
     except
     end;
    end else
    begin
     vPrismRequest.Free;

     try
      if AContext.Connection <> nil then
       if AContext.Connection.Connected then
       begin
        AContext.Connection.IOHandler.Close;
        AContext.Connection.IOHandler.Free;
        AContext.Connection.Disconnect;
       end;
     except
     end;
    end;


    SecWebSocketKey := vPrismRequest.SecWebSocketKey;

    // Send handshake response
    idHashSHA1:= TIdHashSHA1.Create;
    Hash := TIdEncoderMIME.EncodeBytes(idHashSHA1.HashString(SecWebSocketKey + '258EAFA5-E914-47DA-95CA-C5AB0DC85B11'));
    idHashSHA1.Free;

    try
      c.Write('HTTP/1.1 101 Switching Protocols' + sLineBreak
        + 'Upgrade: websocket' + sLineBreak
        + 'Connection: Upgrade' + sLineBreak
        + 'Sec-WebSocket-Accept: ' + Hash
        + sLineBreak + sLineBreak, IndyTextEncoding_UTF8);
    except
    end;

    // Mark IOHandler as handshaked
    vPrismWSContext.Established:= true;

    if Assigned(vPrismWSContext.PrismSession) then
    begin
     PrismBaseClass.ServerController.DoSessionChange(scsStabilizedConnectioSession, TPrismWebSocketContext(AContext.Data).PrismSession);
    end;

    //result:= true;

    vPrismRequest.Free;

    {$ENDREGION}
   end else
   begin
    if (vPrismRequest.WebMethod in [wmtGET]) and
       ((vPrismRequest.Path = '/') or (vPrismRequest.Path = '') or (Copy(vPrismRequest.Path, 1,2) = '/?') or (vPrismRequest.Path = '/')) then //VirtualPath
    begin
     {$REGION 'Open Form'}
//     vProc:= TPrismSessionThreadProc.Create(nil,
//      Exec_OpenForm,
//      TValue.From<TIdContext>(AContext),
//      TValue.From<TPrismHTTPRequest>(vPrismRequest),
//      TValue.From<TPrismWebSocketContext>(vPrismWSContext)
//     );
//
//     vIsProc:= true;
//
//     vProc.Exec;

//     vProc:= TPrismSessionThreadProc.Create(nil,
//      Exec_OpenForm,
//      TValue.From<TIdContext>(AContext),
//      TValue.From<TPrismHTTPRequest>(vPrismRequest),
//      TValue.From<TPrismWebSocketContext>(vPrismWSContext),
//      true,
//      true
//     );
//
//     vIsProc:= true;
//
//     vProc.Exec;

      Exec_OpenForm(AContext, vPrismRequest, vPrismWSContext);
     {$ENDREGION }
    end else
    if Assigned(vPrismRequest.Route) and
       ((vPrismRequest.Route as TD2BridgeRestRoute).RequireJWT) and (not vPrismRequest.JWTvalid) then //Route not Authenticated
    begin
     c.WriteLn('HTTP/1.1 403 Forbidden');
     c.WriteLn('Content-Type: application/json; charset=UTF-8');
     c.WriteLn('Content-Length: 98');
     c.WriteLn('Connection: Close');
     c.WriteLn('Server: '+fServerName);
     c.WriteLn('');
     c.WriteLn('{"error":"forbidden","error_description":"You are not authorized to access this endpoint."}');

     //vPrismResponse.Free;
     vPrismRequest.Free;

     try
      if AContext.Connection <> nil then
       if AContext.Connection.Connected then
       begin
        AContext.Connection.IOHandler.Close;
        AContext.Connection.IOHandler.Free;
        AContext.Connection.Disconnect;
       end;
     except
     end;
    end else
    if PrismBaseClass.Rest.Options.EnableRESTServerExternal and Assigned(vPrismRequest.Route) then //Route //EndPoint
    begin
     vPrismResponse:= TPrismHTTPResponse.Create;
     vPrismResponse.ContentType:= vPrismRequest.ContentType;


     try
      try
       PrismBaseClass.Sessions.AddThreadhID(TThread.CurrentThread.ThreadID, nil);
       (vPrismRequest.Route as TD2BridgeRestRoute).DoCallBack(vPrismRequest, vPrismResponse);
       PrismBaseClass.Sessions.RemoveThreadID(TThread.CurrentThread.ThreadID);
      except
      end;

      if (vPrismResponse.FileName = '') and (vPrismResponse.Content = '')  and (vPrismResponse.Redirect = '') and (not vPrismResponse.InitializedJSON) then
      begin
       if (vPrismResponse.StatusCode = '200') then
       begin
        vPrismResponse.StatusCode:= '422';
        vPrismResponse.ContentType:= 'application/json';
       end else
       if (vPrismResponse.StatusCode = '404') then
       begin
        vPrismResponse.ContentType:= 'application/json';
       end;
      end;


      c.WriteLn('HTTP/1.1 ' + ifThen(vPrismResponse.StatusMessage <> '', vPrismResponse.StatusMessage, HttpParseStatusCode(vPrismResponse.StatusCode)));
      if vPrismResponse.ContentType <> '' then
      c.WriteLn('Content-Type: '+vPrismResponse.ContentType+'; charset='+vPrismResponse.charset);
      for i:= 0 to pred(vPrismResponse.Headers.Count) do
       if vPrismResponse.Headers[i] <> '' then
        c.WriteLn(vPrismResponse.Headers[i]);
      if vPrismResponse.FileName <> '' then
       c.WriteLn('Content-Disposition: attachment; filename="'+ExtractFileName(vFileName)+'"');
      if vPrismResponse.Redirect <> '' then
      begin
       c.WriteLn('Location: '+vPrismResponse.Redirect);
       c.WriteLn('Content-Type: '+MimesType.GetMimeType(vPrismResponse.Redirect));
      end;
      c.WriteLn('Connection: Close');
      c.WriteLn('Server: '+fServerName);
      c.WriteLn('');

      if VarToStr(vPrismResponse.StatusCode) <> '204' then
      begin
       if vPrismResponse.Content <> '' then
       begin
        C.Write(vPrismResponse.Content, IndyTextEncoding_UTF8)
       end else
        if vPrismResponse.InitializedJSON then
        begin
         if vPrismResponse.IsJSONArray then
          C.Write(vPrismResponse.JSON.GetValue('jsonarray').ToJSON, IndyTextEncoding_UTF8)
         else
          C.Write(vPrismResponse.JSON.ToJSON, IndyTextEncoding_UTF8)
        end else
         if vPrismResponse.FileName <> '' then
         begin
          vFileName:= vPrismResponse.FileName;

          if FileExists(vFileName) then
           c.WriteFile(vPrismResponse.FileName);
         end else
         begin
          if vPrismResponse.StatusCode = '422' then
           c.WriteLn('{"error":"unprocessable_entity","error_description":"The request could not be processed due to semantic errors."}')
          else
           if vPrismResponse.StatusCode = '404' then
            c.WriteLn('{"error":"not_found","error_description":"The requested resource was not found."}');
         end;
      end;
     except
     end;

     //vPrismRequest.Free;
     vPrismResponse.Free;
     vPrismRequest.Free;

     try
      if AContext.Connection <> nil then
       if AContext.Connection.Connected then
       begin
        AContext.Connection.IOHandler.Close;
        AContext.Connection.IOHandler.Free;
        AContext.Connection.Disconnect;
       end;
     except
     end;
    end else
    if (vPrismRequest.WebMethod in [wmtGET]) then
    begin
     {$REGION 'Open File'}
     try
      vFileName:= StringReplace(RootDirectory + StringReplace(vPrismRequest.Path,'/',PathDelim, [rfReplaceAll]), PathDelim + PathDelim, PathDelim, [rfReplaceAll]);
      RemoveEscapeFromFileURL(vFileName);
      vFileName:= URLDecode(vFileName);
      if AnsiPos('?', vFileName) > 0 then
      vFileName:= Copy(vFileName, 1, AnsiPos('?', vFileName) -1);

      if (not FileExists(vFileName)) or (vFileName = 'error500.html') then
      begin
       vPrismResponse:= TPrismHTTPResponse.Create;
       if not Assigned(vPrismWSContext) then
        vPrismWSContext:= TPrismWebSocketContext.Create;

       if Assigned(FOnGetFile) then
       begin
        FOnGetFile(vPrismRequest, vFileName, vResponseFileName, vResponseFileContent, vResponseRedirect, vMimeType);

        if (vResponseFileName <> '') and FileExists(vResponseFileName) then
        begin
         c.WriteLn('HTTP/1.1 ' + HttpParseStatusCode(vPrismResponse.StatusCode));
         if MimesType.GetMimeType(vFileName) <> '' then
          c.WriteLn('Content-Type: '+vMimeType+'; charset='+vPrismResponse.charset);
         c.WriteLn('Connection: Close');
         c.WriteLn('Server: '+fServerName);
{$IFDEF D2DOCKER}
          c.WriteLn('D2DockerInstance: ' + PrismBaseClass.ServerController.D2DockerInstanceAlias);
{$ENDIF}
         c.WriteLn('');

         c.WriteFile(vResponseFileName);
        end else
        if (vResponseFileContent <> '') then
        begin
         c.WriteLn('HTTP/1.1 ' + HttpParseStatusCode(vPrismResponse.StatusCode));
         if MimesType.GetMimeType(vFileName) <> '' then
          c.WriteLn('Content-Type: '+MimesType.GetMimeType(vFileName)+'; charset='+vPrismResponse.charset);
         c.WriteLn('Connection: Close');
         c.WriteLn('Server: '+fServerName);
{$IFDEF D2DOCKER}
          c.WriteLn('D2DockerInstance: ' + PrismBaseClass.ServerController.D2DockerInstanceAlias);
{$ENDIF}
         c.WriteLn('');

         c.Write(vResponseFileContent, IndyTextEncoding_UTF8);
        end else
        if (vResponseRedirect <> '') then
        begin
         c.WriteLn('HTTP/1.1 302 Found');
         c.WriteLn('Connection: Close');
         c.WriteLn('Location: '+vResponseRedirect);
         if MimesType.GetMimeType(vResponseRedirect) <> '' then
          c.WriteLn('Content-Type: '+MimesType.GetMimeType(vResponseRedirect)+'; charset='+vPrismResponse.charset);
         c.WriteLn('Server: '+fServerName);
{$IFDEF D2DOCKER}
          c.WriteLn('D2DockerInstance: ' + PrismBaseClass.ServerController.D2DockerInstanceAlias);
{$ENDIF}
         c.WriteLn('');
        end else
        begin
         c.WriteLn('HTTP/1.1 404 Not Found');
         c.WriteLn('Connection: Close');
         c.WriteLn('Server: '+fServerName);
{$IFDEF D2DOCKER}
          c.WriteLn('D2DockerInstance: ' + PrismBaseClass.ServerController.D2DockerInstanceAlias);
{$ENDIF}
         c.WriteLn('');

         //PrismBaseClass.Log('', 'PrismServerTCP', 'GetFile', 'DoExecute', 'File not Found: '+vFileName);
        end;
       end;

       FreeAndNil(vPrismRequest);
       FreeAndNil(vPrismResponse);
       if Assigned(vPrismWSContext) then
        FreeAndNil(vPrismWSContext);

       vPrismRequest.Free;
      end else
      begin
       c.WriteLn('HTTP/1.1 200 OK');
       if MimesType.GetMimeType(vFileName) <> '' then
        c.WriteLn('Content-Type: '+MimesType.GetMimeType(vFileName)+'; charset=UTF-8');
       c.WriteLn('Connection: Close');
       c.WriteLn('Server: '+fServerName);
{$IFDEF D2DOCKER}
        c.WriteLn('D2DockerInstance: ' + PrismBaseClass.ServerController.D2DockerInstanceAlias);
{$ENDIF}
       c.WriteLn('');


       if SameText(vPrismRequest.Query('prismparse'), 'true') then
       begin
        vPrismResponse:= TPrismHTTPResponse.Create;

        if not Assigned(AContext.Data) then
         AContext.Data:= TPrismWebSocketContext.Create;
        vPrismWSContext := TPrismWebSocketContext(AContext.Data);

        vPrismWSContext.Token := vPrismRequest.QueryParams.Values['token'];
        vPrismWSContext.PrismSessionUUID := vPrismRequest.QueryParams.Values['uuid'];
        vPrismWSContext.FormUUID := vPrismRequest.QueryParams.Values['formuuid'];

        DoParseFile(vFileName, AContext, vPrismRequest, vPrismResponse, vPrismWSContext);

        if (vPrismResponse.Content <> '') and (not vPrismResponse.Error) then
         C.Write(vPrismResponse.Content, IndyTextEncoding_UTF8);

        FreeAndNil(vPrismResponse);
       end else
        c.WriteFile(vFileName);


       vPrismRequest.Free;
      end;
     except
     end;

     try
      if AContext.Connection <> nil then
       if AContext.Connection.Connected then
       begin
        AContext.Connection.IOHandler.Close;
        AContext.Connection.IOHandler.Free;
        AContext.Connection.Disconnect;
       end;
     except
      result:= false;
     end;
     {$ENDREGION}
    end else
    begin
     try
      c.WriteLn('HTTP/1.1 404 Not Found');
      c.WriteLn('Connection: Close');
      c.WriteLn('Server: '+fServerName);
      c.WriteLn('');

      vPrismRequest.Free;

      if AContext.Connection <> nil then
       if AContext.Connection.Connected then
       begin
        AContext.Connection.IOHandler.Close;
        AContext.Connection.IOHandler.Free;
        AContext.Connection.Disconnect;
       end;
     except
      result:= false;
   end;

    end;
   end;
  end else
  begin
   //OTHERS

   vPrismRequest.Free;

   try
    if AContext.Connection <> nil then
     if AContext.Connection.Connected then
     begin
      AContext.Connection.IOHandler.Close;
      AContext.Connection.IOHandler.Free;
      AContext.Connection.Disconnect;
     end;
   except
   end;
  end;


  //vPrismRequest.DisposeOf;
 end;


 if vIsProc then
  Result := true
 else
 begin
  try
   if AContext <> nil then
   begin
    try
     if AContext.Connection <> nil then
     begin
      try
       Result := AContext.Connection.Connected;
      except
       Result := false;
      end;
     end;
    except
    end;
   end;
  except
  end;
 end;
end;
{$ENDIF}

procedure TPrismServerTCP.DoFinishedGetHTML(APrismWSContext: TPrismWebSocketContext);
begin
 if Assigned(FOnFinishedGetHTML) then
  FOnFinishedGetHTML(APrismWSContext);
end;

procedure TPrismServerTCP.DoGetHTML(AContext: TIdContext; APrismRequest: TPrismHTTPRequest; var APrismReponse: TPrismHTTPResponse; var PrismWSContext: TPrismWebSocketContext);
begin
 if Assigned(FOnGetHTML) then
  FOnGetHTML(APrismRequest, APrismReponse, PrismWSContext);
end;

procedure TPrismServerTCP.DoParseFile(AFileName: string; AContext: TIdContext; APrismRequest: TPrismHTTPRequest;
  var APrismReponse: TPrismHTTPResponse;
  var APrismWSContext: TPrismWebSocketContext);
begin
 if Assigned(FOnParseFile) then
  FOnParseFile(AFileName, AContext, APrismRequest, APrismReponse, APrismWSContext);
end;

function TPrismServerTCP.DoReceiveMessage(AMessage: string; PrismWSContext: TPrismWebSocketContext): string;
var
 vPrismWSMessage: TPrismWebSocketMessage;
 vToken: string;
begin
 Result:= '';

 {$IFDEF D2BRIDGE}
 try
  if Assigned(PrismWSContext) and Assigned(PrismWSContext.PrismSession) then
  begin
   if Assigned(PrismWSContext.PrismSession) then
   begin
    if (csDestroying in TPrismSession(PrismWSContext.PrismSession).ComponentState) then
    begin
     exit;
    end else
    begin
     vPrismWSMessage:= FormatReceivedMesssage(AMessage);

     try
      try
       if vPrismWSMessage.Parameters.TryGetValue('Token', vToken)
          and (PrismWSContext.PrismSession.Token = vToken) then
       begin
        if Assigned(FOnReceiveMessage) then
        begin
         //Result:= FOnReceiveMessage(vPrismWSMessage, PrismWSContext);
//         PrismWSContext.PrismSession.ExecThread(False,
//          Exec_ReceiveMessage,
//          TValue.From<TPrismWebSocketMessage>(vPrismWSMessage),
//          TValue.From<TPrismWebSocketContext>(PrismWSContext)
//         );
         FOnReceiveMessage(vPrismWSMessage, PrismWSContext);;
        end else
         FreeAndNil(vPrismWSMessage);
       end else
       begin
        try
         if not PrismWSContext.PrismSession.Closing then
          PrismWSContext.PrismSession.Close;

         FreeAndNil(vPrismWSMessage);
        except
        end;
       end;

       if Assigned(vPrismWSMessage) then
        FreeAndNil(vPrismWSMessage);
      except

      end;
     finally
      //vPrismWSMessage.Free;
     end;
    end;
    //OutputDebugString(PWideChar(AMessage));
   end;
  end;
 except
 end;
 {$ENDIF}
end;

procedure TPrismServerTCP.DoRESTData(AContext: TIdContext;
  APrismRequest: TPrismHTTPRequest; var APrismReponse: TPrismHTTPResponse;
  var PrismWSContext: TPrismWebSocketContext);
begin
 if Assigned(FOnRESTData) then
  FOnRESTData(APrismRequest, APrismReponse, PrismWSContext);
end;

procedure TPrismServerTCP.DoUploadFile(AFiles: TStrings; PrismSession: IPrismSession; AFormUUID, ASender: string);
var
 vPrismForm: IPrismForm;
 vSender: TObject;
 I: integer;
begin
 vSender:= nil;
 PrismSession.ThreadAddCurrent;

 try
  vPrismForm:= PrismSession.ActiveFormByFormUUID(AFormUUID);

  if Assigned(vPrismForm) then
  begin
   if (ASender <> '') then
   begin
    try
     for I := 0 to Pred(vPrismForm.Controls.Count) do
     begin
      if SameText(vPrismForm.Controls[I].NamePrefix, ASender) then
      begin
       vSender:= vPrismForm.Controls[I] as TObject;

       break;
      end;
     end;
    except
    end;
   end;

   if Supports(vPrismForm, IPrismForm) then
    vPrismForm.DoUpload(AFiles, vSender)
   else
    PrismSession.ActiveForm.DoUpload(AFiles, vSender);
  end;
 finally
  PrismSession.ThreadRemoveCurrent;
 end;
end;

{$IFDEF D2BRIDGE}
procedure TPrismServerTCP.Exec_OpenForm(varContext, varPrismHTTPRequest, varPrismWSContext: TValue);
var
 xPrismRequest: TPrismHTTPRequest;
 xPrismResponse: TPrismHTTPResponse;
 xPrismWSContext: TPrismWebSocketContext;
 xIOHandle: TIdIOHandler;
 xContext: TIdContext;
 xFileName: string;
 xResponseFileName, xResponseFileContent, xResponseRedirect, xMimeType: string;
 xPage429: string;
 vAppBase: string;
begin
 try
  xContext:= TIdContext(varContext.AsObject);

  try
   xPrismRequest:= TPrismHTTPRequest(varPrismHTTPRequest.AsObject);

   if (xContext.Connection = nil) or
      (not xContext.Connection.Connected) or
      (not Assigned(xContext.Connection.IOHandler)) or
      (not xContext.Connection.IOHandler.Connected) or
      (xPrismRequest = nil) or (not Assigned(xPrismRequest)) then
   begin
    if Assigned(xPrismRequest) then
     FreeAndNil(xPrismRequest);

    exit;
   end;
  except
  end;

  xIOHandle:= xContext.Connection.IOHandler;
  xPrismResponse:= TPrismHTTPResponse.Create;
  xPrismWSContext:= TPrismWebSocketContext.Create;

  if (xPrismRequest.Path = '/') or (xPrismRequest.Path = '') or (Copy(xPrismRequest.Path, 1,2) = '/?') or (xPrismRequest.Path = '/') then //VirtualPath
  begin
   try
    if xPrismRequest.ReloadPage then
    begin
     xPrismWSContext.Token:= xPrismRequest.D2BridgeToken;
     xPrismWSContext.PrismSessionUUID:= xPrismRequest.SessionUUID;
     xPrismWSContext.Reloading:= true;
    end;

    try
     DoGetHTML(xContext, xPrismRequest, xPrismResponse, xPrismWSContext);
    except
    end;

    if IdContextConnected(xContext) then
     if not xPrismRequest.TooManyConnFromIP then
     begin
      xIOHandle.WriteLn('HTTP/1.1 ' + HttpParseStatusCode(xPrismResponse.StatusCode));
      xIOHandle.WriteLn('Content-Type: '+xPrismResponse.ContentType+'; charset='+xPrismResponse.charset);
      xIOHandle.WriteLn('Connection: Close');
      //     xIOHandle.WriteLn('Connection: Keep-Alive');
      //     xIOHandle.WriteLn('Keep-Alive: timeout='+IntToStr(Fhtmlconnectiontimeout)+', max='+IntToStr(Fhtmlconnectionmax));
      xIOHandle.WriteLn('Server: '+fServerName);
      //xIOHandle.WriteLn('Link: </error500.html>; rel=prefetch');
      //if (AnsiPos('/reloadpage?token=', xPrismRequest.Path) > 0) then
      if xPrismRequest.ReloadPage then
      begin
       vAppBase:= xPrismRequest.AppBase;
       if not vAppBase.EndsWith('/') then
        vAppBase:= vAppBase + '/';
       xIOHandle.WriteLn('Set-Cookie: D2Bridge_Token=; Max-Age=0; path='+ vAppBase);
       xIOHandle.WriteLn('Set-Cookie: D2Bridge_PrismSession=; Max-Age=0; path='+ vAppBase);
       xIOHandle.WriteLn('Set-Cookie: D2Bridge_ReloadPage=; Max-Age=0; path='+ vAppBase);
       xIOHandle.WriteLn('Set-Cookie: D2DockerInstance=; Max-Age=0; path='+ vAppBase);
      end;
{$IFDEF D2DOCKER}
       xIOHandle.WriteLn('D2DockerInstance: ' + PrismBaseClass.ServerController.D2DockerInstanceAlias);
{$ENDIF}
      xIOHandle.WriteLn('');

      if xPrismResponse.Content <> '' then
       if Assigned(xIOHandle) and (xContext.Connection <> nil) then
        xIOHandle.Write(xPrismResponse.Content, IndyTextEncoding_UTF8);

      try
       DoFinishedGetHTML(xPrismWSContext);
      except
      end;
     end else
     begin
      xPage429:= PrismBaseClass.PrismServerHTML.GetError429(xPrismRequest.AcceptLanguage);
      xIOHandle.WriteLn('HTTP/1.1 429 Too Many Requests');
      xIOHandle.WriteLn('Retry-After: 60'); // Tempo em segundos até tentar novamente
      xIOHandle.WriteLn('Content-Type: text/html; charset=UTF-8');
      //xIOHandle.WriteLn('Content-Length: ' + IntToStr(Length(xPage429)));
{$IFDEF D2DOCKER}
       xIOHandle.WriteLn('D2DockerInstance: ' + PrismBaseClass.ServerController.D2DockerInstanceAlias);
{$ENDIF}
      xIOHandle.WriteLn('');
      xIOHandle.Write(xPage429, IndyTextEncoding_UTF8);
     end;
   except
   end;

   //Result:= true;
  end;

  // Encerre a conexão
  try
   if xContext.Connection <> nil then
    if xContext.Connection.Connected then
    begin
     try
      xContext.Connection.IOHandler.Close;
  except
  end;
     try
      xContext.Connection.IOHandler.Free;
     except
     end;
     try
      xContext.Connection.Disconnect;
     except
     end;
     //xContext.Connection.IOHandler.CloseGracefully;
    end;
  except
  end;

  //FreeAndNil(xPrismRequest);
  FreeAndNil(xPrismResponse);
  FreeAndNil(xPrismWSContext);
  FreeAndNil(xPrismRequest);
  FreeAndNil(xPrismRequest);
 except
 end;
end;

procedure TPrismServerTCP.Exec_ReceiveMessage(varPrismWebSocketMessage, varPrismWSContext: TValue);
var
 vPrismWebSocketMessage: TPrismWebSocketMessage;
 vPrismWSContext: TPrismWebSocketContext;
begin
 try
  vPrismWebSocketMessage:= varPrismWebSocketMessage.AsObject as TPrismWebSocketMessage;
  vPrismWSContext:= varPrismWSContext.AsObject as TPrismWebSocketContext;

  FOnReceiveMessage(vPrismWebSocketMessage, vPrismWSContext);
 except
 end;

 try
  vPrismWebSocketMessage.Free;
 except
 end;
end;

procedure TPrismServerTCP.Exec_RouteAuth(varContext, varPrismHTTPRequest: TValue);
var
 xIOHandle: TIdIOHandler;
 xContext: TIdContext;
 xPrismRequest: TPrismHTTPRequest;
 xContentLength: Integer;
 vPrismSession: TPrismSession;
begin
 try
  xContext:= TIdContext(varContext.AsObject);

  if xContext.Connection = nil then
   Exit;

  xIOHandle:= xContext.Connection.IOHandler;
  xPrismRequest:= TPrismHTTPRequest(varPrismHTTPRequest.AsObject);

  //Process Auth
  if (AnsiPos(URLAPIAuth + '/google', xPrismRequest.Path) > 0) then
  begin
   {$REGION 'Google'}
    if xPrismRequest.QueryParams.Values['state'] <> '' then
    begin
      vPrismSession:= PrismBaseClass.Sessions.FromPushID(xPrismRequest.QueryParams.Values['state']) as TPrismSession;

      if Assigned(vPrismSession) then
      begin
        vPrismSession.UnLock(APIAuthLockName);
        vPrismSession.URI.QueryParams.Update(xPrismRequest.QueryParams);
      end;
    end;
  {$ENDREGION}
  end else
  if (AnsiPos(URLAPIAuth + '/apple', xPrismRequest.Path) > 0) then
  begin
   {$REGION 'Apple'}

   //Checar se PrismSession é valido

    if xPrismRequest.WebMethod = wmtPOST then
    begin
      if TryStrToInt(xPrismRequest.ContentLength, xContentLength) then
      begin
       //var MyBodyResponse: string := ReadBodyStringFromData(xIOHandle, xContentLength);
      end;
    end;
   {$ENDREGION}
  end;
  if (AnsiPos(URLAPIAuth + '/microsoft', xPrismRequest.Path) > 0) then
  begin
   {$REGION 'Azure'}
    if xPrismRequest.QueryParams.Values['state'] <> '' then
    begin
     vPrismSession:= PrismBaseClass.Sessions.FromPushID(xPrismRequest.QueryParams.Values['state']) as TPrismSession;

     if Assigned(vPrismSession) then
     begin
      vPrismSession.UnLock(APIAuthLockName);
      vPrismSession.URI.QueryParams.Update(xPrismRequest.QueryParams);
     end;
    end;

   {$ENDREGION}
  end;

  {$REGION 'Close Web Navigator'}
   xIOHandle.WriteLn('HTTP/1.1 200 OK');
   xIOHandle.WriteLn('Content-Type: text/html; charset=UTF-8');
   xIOHandle.WriteLn('Connection: Close');
   xIOHandle.WriteLn('Server: ' + fServerName);
{$IFDEF D2DOCKER}
    xIOHandle.WriteLn('D2DockerInstance: ' + PrismBaseClass.ServerController.D2DockerInstanceAlias);
{$ENDIF}
   xIOHandle.WriteLn('');

   xIOHandle.WriteLn('<html>');
   xIOHandle.WriteLn('<head>');
   xIOHandle.WriteLn('<title>D2Bridger Framework</title>');
   xIOHandle.WriteLn('</head>');
   xIOHandle.WriteLn('<body>');
   xIOHandle.WriteLn('<h1>Closing...</h1>');
   xIOHandle.WriteLn('<script type="text/javascript">');
   xIOHandle.WriteLn('  window.close();');
   xIOHandle.WriteLn('</script>');
   xIOHandle.WriteLn('</body>');
   xIOHandle.WriteLn('</html>');
  {$ENDREGION}
 except
 end;

 // Encerre a conexão
 try
  if xContext.Connection <> nil then
   if xContext.Connection.Connected then
    xContext.Connection.IOHandler.CloseGracefully;
 except
 end;

 try
  FreeAndNil(xPrismRequest);
 except
 end;
end;
{$ENDIF}


function TPrismServerTCP.IdContextConnected(AContext: TIdContext): boolean;
begin
 result:= false;

 try
  result:= (AContext.Connection <> nil) and
           (AContext.Connection.Connected) and
           (Assigned(AContext.Connection.IOHandler)) and
           (AContext.Connection.IOHandler.Connected);
 except
 end;
end;


function TPrismServerTCP.FormatReceivedMesssage(AMessage: string): TPrismWebSocketMessage;
var
 MSGJSONObject: TJSONObject;
 MSGParameters: TJSONArray;
 I: Integer;
 vParamName, vParamValue: string;
begin
 Result:= TPrismWebSocketMessage.Create;

 try
  if IsJSONValid(AMessage) then
  begin
   Result.IsFormatted:= true;

   MSGJSONObject:= TJSONObject.ParseJSONValue(AMessage) as TJSONObject;

   Result.Name := MSGJSONObject.GetValue('name','');

   if SameText(MSGJSONObject.GetValue('type',''), 'CallBack') then
    Result.MessageType:= wsMsgCallBack
   else
    if SameText(MSGJSONObject.GetValue('type',''), 'Procedure') then
     Result.MessageType:= wsMsgProcedure
    else
    if SameText(MSGJSONObject.GetValue('type',''), 'Function') then
     Result.MessageType:= wsMsgFunction
    else
    if SameText(MSGJSONObject.GetValue('type',''), 'Text') then
     Result.MessageType:= wsMsgText
     else
      if SameText(MSGJSONObject.GetValue('type',''), 'Heartbeat') then
       Result.MessageType:= wsMsgHeartbeat
       else
        Result.MessageType:= wsNone;


   MSGParameters:= MSGJSONObject.GetValue('parameters') as TJSONArray;

   if Assigned(MSGParameters) then
    for I := 0 to Pred(MSGParameters.Count) do
    begin
     vParamName:= (MSGParameters.Items[I] as TJSONObject).GetJsonStringValue(0);
     vParamValue:= (MSGParameters.Items[I] as TJSONObject).GetJsonValue(0).Value;

     Result.Parameters.Add
      (
       vParamName,
       vParamValue
      );
    end;

   Result.Wait:= SameText(MSGJSONObject.GetValue('wait',''), 'true');

   MSGJSONObject.Free;
  end;

  Result.RawMessage:= AMessage;
 except
 end;
end;


function TPrismServerTCP.GetAppBase: string;
begin
 result:= FAppBase;
end;


procedure TPrismServerTCP.InitSSL(
  AIdServerIOHandlerSSLOpenSSL: TIdServerIOHandlerSSLOpenSSL);
var
  CurrentActive: boolean;
begin
  CurrentActive := Active;
  if CurrentActive then
    Active := false;

  IdServerIOHandlerSSLOpenSSL := AIdServerIOHandlerSSLOpenSSL;
  IOHandler := AIdServerIOHandlerSSLOpenSSL;

  if CurrentActive then
    Active := true;

end;

procedure TPrismServerTCP.InsertEscapeToFileURL(var vFileName: string);
const
  EscapeChars: array[0..32] of string = (
    '%20', '%21', '%22', '%23', '%24', '%25', '%26', '%27', '%28', '%29',
    '%2A', '%2B', '%2C', '%2D', '%2E', '%2F', '%3A', '%3B', '%3C', '%3D',
    '%3E', '%3F', '%40', '%5B', '%5C', '%5D', '%5E', '%5F', '%60', '%7B',
    '%7C', '%7D', '%7E'
  );
var
  i: Integer;
begin
  for i := 0 to High(EscapeChars) do
    vFileName := StringReplace(vFileName, Char(StrToInt('$' + Copy(EscapeChars[i], 2, 2))), EscapeChars[i], [rfReplaceAll]);

  // Reverter a substituição do espaço em branco para o sinal de mais
  vFileName := StringReplace(vFileName, ' ', '%2B', [rfReplaceAll]);
end;

procedure TPrismServerTCP.InterceptExecute(AContext: TIdContext);
var
 WebSocketData: TIdBytes;
 WebSocketString, RequestLine, Headers, Line: string;
 vResponse: string;
 msg: string;
begin
 //AContext.Connection.IOHandler.CheckForDataOnSource(90);
 //AContext.Connection.IOHandler.ReadBytes(WebSocketData, -1, False);

 try
  if (AContext.Connection.Connected) then
  begin
   if Assigned(AContext.Data) and
      (AContext.Data is TPrismWebSocketContext) and
      (TPrismWebSocketContext(AContext.Data).Established) then
   begin
    WebSocketString:= TWebSocketIOHandlerHelper(AContext.Connection.IOHandler).ReadString;

 //   if Assigned(TPrismWebSocketContext(AContext.Data).PrismSession) and
 //      (csDestroying in TPrismSession(TPrismWebSocketContext(AContext.Data)).ComponentState) then
 //   begin
 //    if Assigned(TPrismWebSocketContext(AContext.Data).PrismSession) then
 //     TPrismWebSocketContext(AContext.Data).PrismSession.RenewExpireDate;
 //   end;

    if WebSocketString <> '' then
    begin
     vResponse:= DoReceiveMessage(WebSocketString, TPrismWebSocketContext(AContext.Data));

     AContext.Connection.IOHandler.Tag:= 99;

     if (vResponse <> '') then
     begin
      TWebSocketIOHandlerHelper(AContext.Connection.IOHandler).WriteString(vResponse);
     end;
    end;
   end;
  end;
 except
 end;

// RequestLine := AContext.Connection.IOHandler.ReadLn;
//
// if RequestLine <> '' then
// begin
//  // Read string and parse HTTP headers
//  try
//   Headers := RequestLine + sLineBreak;
//   repeat
//    Line := AContext.Connection.IOHandler.ReadLn;
//    Headers := Headers + Line + sLineBreak;
//   until (Headers = sLineBreak) or (Line = '');
//  except
//  end;
// end;

//  io := TWebSocketIOHandlerHelper(AContext.Connection.IOHandler);
//  io.CheckForDataOnSource(10);
//  msg := io.ReadString;
//  if msg <> '' then
//  begin
//   //OutputDebugString(PWideChar('Intercept MSG: ' + msg));
//   //io.WriteString(msg);
//   if Assigned(AContext.Data) and (AContext.Data is TPrismWebSocketContext) then
//   DoReceiveMessage(msg, TPrismWebSocketContext(AContext.Data));
//  end;
end;

function TPrismServerTCP.MimesType: TPrismServerFileExtensions;
begin
 Result:= FMimesType;
end;

function TPrismServerTCP.OpenSSL: TIdServerIOHandlerSSLOpenSSL;
begin
 if not Assigned(IdServerIOHandlerSSLOpenSSL) then
 IdServerIOHandlerSSLOpenSSL:= TIdServerIOHandlerSSLOpenSSL.Create(self);

 result:= IdServerIOHandlerSSLOpenSSL;
end;

function TPrismServerTCP.ParseHeaders(AContext: TIdContext; const AHTMLHeader: string): TPrismHTTPRequest;
var
 lines: TArray<string>;
 line: string;
 SplittedLine: TArray<string>;
 vPortString: string;
 vPortInt: Integer;
 URI: TIdURI;
 vCookies, vCookieParts: TStrings;
 vCookiePair: string;
 vExistBoundary: boolean;
 I: integer;
 vContentLength: Integer;
 vEncoded, vDecoded: string;
 vPayLoad: TJSONObject;
 vIp: string;
begin
 result := TPrismHTTPRequest.Create;

 try
  if Assigned(AContext) then
   result.IOHandler:= AContext.Connection.IOHandler;
 except
 end;

 //GetRemoteIP
 if Assigned(AContext) then
  if AContext.Connection.Socket <> nil then
   if AContext.Connection.Socket <> nil then
   begin
    result.RemoteIP := AContext.Connection.Socket.Binding.PeerIP;
    result.RemotePort:= AContext.Connection.Socket.Binding.PeerPort;
   end;


 lines := AHTMLHeader.Split([sLineBreak]);
 for line in lines do
 begin
  result.RawHeaders.Add(line);

  SplittedLine := line.Split([': ']);
  if Length(SplittedLine) > 1 then
  begin
   if SameText(Trim(SplittedLine[0]), 'pragma') then result.Pragma:= Trim(SplittedLine[1]);
   if SameText(Trim(SplittedLine[0]), 'cache-control') then result.CacheControl:= Trim(SplittedLine[1]);
   if SameText(Trim(SplittedLine[0]), 'user-agent') then result.UserAgent:= Trim(SplittedLine[1]);
   if SameText(Trim(SplittedLine[0]), 'Origin') then result.Origin:= Trim(SplittedLine[1]);
   if SameText(Trim(SplittedLine[0]), 'connection') then result.Connection:= Trim(SplittedLine[1]);
   if SameText(Trim(SplittedLine[0]), 'upgrade') then result.Upgrade:= Trim(SplittedLine[1]);
   if SameText(Trim(SplittedLine[0]), 'Sec-WebSocket-Key') then result.SecWebSocketKey:= Trim(SplittedLine[1]);
   if SameText(Trim(SplittedLine[0]), 'Accept') then result.Accept:= Trim(SplittedLine[1]);
   if SameText(Trim(SplittedLine[0]), 'Accept-Encoding') then result.AcceptEncoding:= Trim(SplittedLine[1]);
   if SameText(Trim(SplittedLine[0]), 'Accept-Language') then result.AcceptLanguage:= Trim(SplittedLine[1]);
   if SameText(Trim(SplittedLine[0]), 'Content-Length') then result.ContentLength:= Trim(SplittedLine[1]);
   if SameText(Trim(SplittedLine[0]), 'Purpose') then result.Purpose:= Trim(SplittedLine[1]);
   if SameText(Trim(SplittedLine[0]), 'x-real-ip') then
   begin
    result.ForwardedIP:= Trim(SplittedLine[1]);

    if (result.RemoteIP = '127.0.0.1') or (result.RemoteIP = 'localhost') then
     result.RemoteIP:= result.ForwardedIP;
   end else
   if SameText(Trim(SplittedLine[0]), 'App-Base') then
   begin
    result.AppBase:= Trim(SplittedLine[1]);

    AppBase:= result.AppBase;
   end else
   if SameText(Trim(SplittedLine[0]), 'X-App-Base') then
   begin
    result.AppBase:= Trim(SplittedLine[1]);

    AppBase:= result.AppBase;
   end else
   if SameText(Trim(SplittedLine[0]), 'x-forwarded-for') then
   begin
    vIp:= Trim(SplittedLine[1]);

    result.ForwardedIP:= vIP.Split([','])[0];// Trim(SplittedLine[1]);
   end else
   if SameText(Trim(SplittedLine[0]), 'referer') then
   begin
    result.Referer:= Trim(SplittedLine[1]);
    if AnsiPos(':', Trim(result.Referer)) > 0 then
    begin
     if AnsiPos(AnsiUpperCase('https://'), AnsiUpperCase(Trim(result.Referer))) = 1 then
     begin
      result.Protocol:= 'https';

      if AnsiPos(':', Copy(Trim(result.Referer), 9)) > 0 then
      begin
       if TryStrToInt(Copy(Trim(Copy(Trim(result.Referer), 9)), AnsiPos(':', Trim(Copy(Trim(result.Referer), 9)))+1), vPortInt) then
       begin
        result.ServerPort:= vPortInt;
        vPortString:= IntToStr(vPortInt);
       end;
      end else
      begin
       result.ServerPort:= 443;
       vPortString:= '443';
      end;
     end else
     if AnsiPos(AnsiUpperCase('http://'), AnsiUpperCase(Trim(result.Referer))) = 1 then
     begin

     end;
    end;


    URI := TIdURI.Create(Result.Referer);
    try
     Result.RefererQueryParams.LineBreak:= '&';
     Result.RefererQueryParams.Text := TIdURI.URLDecode(URI.Params);
    finally
     URI.Free;
    end;
   end else
   if SameText(Trim(SplittedLine[0]), 'X-Forwarded-Scheme') then
   begin
    if Pos(AnsiUpperCase(Trim(SplittedLine[1])), AnsiUpperCase('https')) > 0 then
    begin
      vPortString:= '443';
      Result.Protocol:= 'https';
    end
    else
    begin
      Result.Protocol:= 'http';
      vPortString:= '80';
    end;
    TryStrToInt(vPortString, Result.ServerPort);
   end else
   if SameText(Trim(SplittedLine[0]), 'host') then
   begin
    if AnsiPos(':', Trim(SplittedLine[1])) > 0 then
    begin
     vPortString:= Copy(Trim(SplittedLine[1]), AnsiPos(':', Trim(SplittedLine[1]))+1)
    end else
    begin
     if Result.Protocol = 'https' then
      vPortString:= '443'
     else
      vPortString:= '80';
    end;

    if (AnsiPos(':', Trim(SplittedLine[1])) > 0) and
       ((Result.Protocol = 'https') and (vPortString <> '443')) and
       ((Result.Protocol = 'http') and (vPortString <> '80')) then
     result.host:= Copy(Trim(SplittedLine[1]), 1, AnsiPos(':', Trim(SplittedLine[1]))-1)
    else
     result.host:= Trim(SplittedLine[1]);

    TryStrToInt(vPortString, Result.ServerPort);
   end else
   if SameText(Trim(SplittedLine[0]), 'Content-Type') then
   begin
    if AnsiPos(';', Trim(SplittedLine[1])) > 0 then
     result.ContentType:= Trim(Copy(Trim(SplittedLine[1]), 1, AnsiPos(';', Trim(SplittedLine[1]))-1))
    else
     result.ContentType:= Trim(SplittedLine[1]);

    if AnsiPos('boundary', Trim(SplittedLine[1])) > 0 then
    begin
     result.Boundary:= Trim(Copy(Trim(SplittedLine[1]), AnsiPos('boundary', Trim(SplittedLine[1]))));
     result.Boundary:= Trim(Copy(result.Boundary, AnsiPos('=', result.Boundary)+1));
    end;
   end else
   if SameText(Trim(SplittedLine[0]), 'Cookie') then
   begin
    try
     result.Cookies:= Trim(SplittedLine[1]);

     vCookies:= TStringList.Create;
     vCookieParts:= TStringList.Create;
     vCookies.LineBreak:= ';';
     vCookieParts.Delimiter:= '=';
     vCookies.Text:= Trim(SplittedLine[1]);

     for vCookiePair in vCookies do
     begin
      vCookieParts.DelimitedText := vCookiePair;
      if vCookieParts[0] = 'D2Bridge_Token' then
      result.D2BridgeToken:= vCookieParts[1]
      else
      if vCookieParts[0] = 'D2Bridge_PrismSession' then
      result.SessionUUID:= vCookieParts[1]
      else
      if vCookieParts[0] = 'D2Bridge_ServerUUID' then
      result.ServerUUID:= vCookieParts[1]
      else
      if vCookieParts[0] = 'D2Bridge_ReloadPage' then
      result.ReloadPage:= SameText(vCookieParts[1], 'true');
     end;
    finally
     vCookies.Free;
     vCookieParts.Free;
    end;
   end else
   if (SameText(Trim(SplittedLine[0]), 'Content-Disposition')) and Result.IsUploadFile then
   begin
    result.FileName:= copy(Trim(SplittedLine[1]), AnsiPos('filename="', Trim(SplittedLine[1]))+10);
    result.FileName:= copy(result.FileName, 1, AnsiPos('"',result.FileName));
   end else
   if SameText(Trim(SplittedLine[0]), 'Authorization') then
   begin
    Result.Authorization:= Trim(SplittedLine[1]);

    if Pos(UpperCase('basic '), UpperCase(Trim(SplittedLine[1]))) = 1 then
    begin
     result.AuthorizationType:= 'Basic';

     vEncoded := Copy(SplittedLine[1], 7, MaxInt);
     vEncoded := Trim(vEncoded);

     // Decodifica Base64
     {$IFDEF FPC}
     vDecoded := DecodeStringBase64(vEncoded);
     {$ELSE}
     vDecoded := TNetEncoding.Base64.Decode(vEncoded);
     {$ENDIF}

     // Divide no separador ':'
     I := Pos(':', vDecoded);
     if I > 0 then
     begin
      Result.User := Copy(vDecoded, 1, I - 1);
      Result.Password := Copy(vDecoded, I + 1);
     end;
    end else
    if Pos(UpperCase('bearer '), UpperCase(Trim(SplittedLine[1]))) = 1 then
    begin
     result.AuthorizationType:= 'Bearer';

     result.JWTtoken:= Copy(SplittedLine[1], 8, MaxInt);

     if Pos(Uppercase('"token_type":"refresh"'),
        Uppercase(PrismBaseClass.Options.Security.Rest.JWTAccess.Payload(result.JWTtoken))) > 0 then
     begin
      result.JWTvalid:= PrismBaseClass.Options.Security.Rest.JWTRefresh.Valid(result.JWTtoken);
      result.JWTPayLoad:= PrismBaseClass.Options.Security.Rest.JWTRefresh.Payload(result.JWTtoken);
      result.JWTTokenType:= TSecurityJWTTokenType.JWTTokenRefresh;
     end else
     begin
      result.JWTvalid:= PrismBaseClass.Options.Security.Rest.JWTAccess.Valid(result.JWTtoken);
      result.JWTPayLoad:= PrismBaseClass.Options.Security.Rest.JWTAccess.Payload(result.JWTtoken);
     end;

     if result.JWTPayLoad <> '' then
     begin
      try
       vPayLoad:= TJSONObject.ParseJSONValue(result.JWTPayLoad) as TJSONObject;
       result.JWTsub:= vPayLoad.GetValue('sub', '');
       result.JWTidentity:= {$IFDEF FPC}DecodeStringBase64{$ELSE}TNetEncoding.Base64.Decode{$ENDIF}(vPayLoad.GetValue('identity', ''));
       vPayLoad.Free;
      except
      end;
     end;
    end;
   end;

   //result.AddOrSetValue(Trim(SplittedLine[0]), Trim(SplittedLine[1]));
  end else
  begin
   if (AnsiPos('GET /', AnsiUpperCase(line)) > 0) or
      (AnsiPos('POST /', AnsiUpperCase(line)) > 0) or
      (AnsiPos('HEAD /', AnsiUpperCase(line)) > 0) or
      (AnsiPos('PUT /', AnsiUpperCase(line)) > 0) or
      (AnsiPos('DELETE /', AnsiUpperCase(line)) > 0) or
      (AnsiPos('PATCH /', AnsiUpperCase(line)) > 0) then
   begin
    if (AnsiPos('GET /', AnsiUpperCase(line)) > 0) then
     result.WebMethod:= wmtGET
    else
    if (AnsiPos('POST /', AnsiUpperCase(line)) > 0) then
     result.WebMethod:= wmtPOST
    else
    if (AnsiPos('HEAD /', AnsiUpperCase(line)) > 0) then
     result.WebMethod:= wmtHEAD
    else
    if (AnsiPos('PUT /', AnsiUpperCase(line)) > 0) then
     result.WebMethod:= wmtPUT
    else
    if (AnsiPos('DELETE /', AnsiUpperCase(line)) > 0) then
     result.WebMethod:= wmtDELETE
    else
    if (AnsiPos('PATCH /', AnsiUpperCase(line)) > 0) then
    result.WebMethod:= wmtPATCH;


    Result.Path:= Copy(line, AnsiPos(' /', line) + 1, AnsiPos(' ', Copy(line, AnsiPos(' /', line) + 1)) -1);

    if AnsiPos('HTTP/', AnsiUpperCase(Copy(line, 6 + Length(Result.Path)))) > 0 then
    begin
     if PrismBaseClass.Options.SSL then
      Result.Protocol:= 'https'
     else
      Result.Protocol:= 'http'
    end else
    if AnsiPos('HTTPS/', AnsiUpperCase(Copy(line, 6 + Length(Result.Path)))) > 0 then
     Result.Protocol:= 'https';

    URI := TIdURI.Create(Result.Path);
    try
     Result.QueryParams.LineBreak:= '&';
     Result.QueryParams.Text := TIdURI.URLDecode(URI.Params);
    finally
     URI.Free;
    end;
   end;
  end;
 end;


 if PrismBaseClass.Options.Security.Enabled then
 begin
  {$REGION 'IP Blacklist check'}
   if PrismBaseClass.Options.Security.IP.IPv4BlackList.ExistIP(Result.ClientIP) then
    if not PrismBaseClass.Options.Security.IP.IPv4WhiteList.ExistIP(Result.ClientIP) then
     Result.IPListedInBlackList:= true;
  {$ENDREGION}

  {$REGION 'UserAgent Blocked'}
   if PrismBaseClass.Options.Security.UserAgent.UserAgentBlocked(Result.UserAgent) then
    Result.UserAgentBlocked:= true;
  {$ENDREGION}
 end;


 if not (Result.IPListedInBlackList and Result.UserAgentBlocked) then
 begin
  //Pos Process
  if (AnsiPos(FpathRESTServer+'/json/jqgrid/post', Result.Path) > 0) and
     TryStrToInt(Result.ContentLength, vContentLength) then
  begin
   Result.Content:= AContext.Connection.IOHandler.ReadString(vContentLength, IndyTextEncoding_UTF8);
  end;

  //Check Routes
  if (result.Path <> '/') and (result.Path <> '') and (result.Path <> '/') then //VirtualPath
  begin
   if (result.WebMethod in [wmtGET, wmtPOST, wmtPUT, wmtDELETE, wmtPATCH]) then
   begin
    result.Route:= PrismBaseClass.Rest.Routes.Item[result.WebMethod, result.PathWithoutParams] as TObject;
   end;
  end;
 end;
end;

function TPrismServerTCP.ReadBodyStringFromData(IOHandler: TIdIOHandler; ContentLength: Integer): string;
var
 vBodyContent: TBytes;
begin
 result:= '';

 if ContentLength > 0 then
 begin
  IOHandler.ReadBytes(TIDBytes(vBodyContent), ContentLength);

  result:= TIdURI.URLDecode(TEncoding.Default.GetString(vBodyContent));
 end;
end;

function TPrismServerTCP.ReadBodyStreamFromData(IOHandler: TIdIOHandler; ContentLength: Integer): TMemoryStream;
var
 vBodyContent: TBytes;
 vArrayLines: TArray<string>;
 I: Integer;
begin
 result:= nil;

 if ContentLength > 0 then
 begin
  result:= TMemoryStream.Create;

  IOHandler.ReadBytes(TIDBytes(vBodyContent), ContentLength);

  result.WriteBuffer(vBodyContent[0], ContentLength);
  result.Position := 0;
 end;
end;

procedure TPrismServerTCP.ReadMultipartFormData(IOHandler: TIdIOHandler; Boundary: String; ContentLength: Integer; AFiles: TStrings; ASender: string; PrismWSContext: TPrismWebSocketContext);
var
 Line: {$IFNDEF FPC}String{$ELSE}UnicodeString{$ENDIF};
 lines: TArray<string>;
 Files: TStrings;
 FileStatus: TStreamFileStatus;
 Filename: String;
 FileMemoryStream: TMemoryStream;
 partContent: TBytes;
 I, Z: Integer;
begin
 if (ContentLength > 0) then
 begin
  FileStatus:= SFSNone;

  Files:= TStringList.Create;

  IOHandler.ReadBytes(TIDBytes(partContent), ContentLength);

{$IFNDEF FPC}
  lines:= TEncoding.ANSI.GetString(partContent).Split([sLineBreak]);
{$ELSE}
  lines:= UTF16ToUTF8(TEncoding.ANSI.GetString(partContent)).Split([sLineBreak]);
{$ENDIF}

  I:= 0;
  repeat
{$IFNDEF FPC}
   Line:= lines[I];
{$ELSE}
   Line:= UTF8ToUTF16(lines[I]);
{$ENDIF}

   if (FileStatus = SFSWaitingFile) and (Line = '') then
    FileStatus := SFSCreateFile;

   if (FileStatus = SFSCreateFile) and (Line <> '') then
   begin
    FileMemoryStream:= TMemoryStream.Create;
    FileStatus:= SFSWriteFile;
   end;

   if (FileStatus = SFSWriteFile) and ((Line = '--'+Boundary+'--') or (Line = '--'+Boundary)) then
   begin
    FileStatus:= SFSNone;

    Z:= 1;
    if FileExists(PrismWSContext.PrismSession.PathSession+FileName) then
    repeat
     FileName:= Format('%s%d%s', [ChangeFileExt(FileName, ''), Z, ExtractFileExt(FileName)]);
     Inc(Z);
    until not FileExists(PrismWSContext.PrismSession.PathSession+FileName);

    FileMemoryStream.SaveToFile(PrismWSContext.PrismSession.PathSession+FileName);
    Files.Add(PrismWSContext.PrismSession.PathSession+FileName);
    FileMemoryStream.Free;
    Filename:= '';
   end;

   if (FileStatus = SFSWriteFile) and (Line <> '') and (Line <> '--'+Boundary) then
    FileMemoryStream.Write(TEncoding.ANSI.GetBytes(Line + sLineBreak)[0], Length(Line + sLineBreak));

   if (FileStatus = SFSNone) and (AnsiPOS('Content-Disposition:', Line) > 0) then
   begin
    Filename:= copy(Line, AnsiPos('filename="', Line) + 10);
    FileName:= copy(FileName, 1, AnsiPos('"', FileName)-1);

    FileStatus:= SFSWaitingFile;
   end;

   Inc(I);
  until I >= Length(Lines);

  DoUploadFile(Files, PrismWSContext.PrismSession, PrismWSContext.FormUUID, ASender);

  if Assigned(AFiles) then
   AFiles.Text:= Files.Text;

  Files.Free;
 end;

 partContent:= nil;
 lines:= nil;
end;


procedure TPrismServerTCP.RemoveEscapeFromFileURL(var vFileName: string);
const
  EscapeChars: array[0..32] of string = (
    '%20', '%21', '%22', '%23', '%24', '%25', '%26', '%27', '%28', '%29',
    '%2A', '%2B', '%2C', '%2D', '%2E', '%2F', '%3A', '%3B', '%3C', '%3D',
    '%3E', '%3F', '%40', '%5B', '%5C', '%5D', '%5E', '%5F', '%60', '%7B',
    '%7C', '%7D', '%7E'
  );
var
  i: Integer;
begin
  for i := 0 to High(EscapeChars) do
    vFileName := StringReplace(vFileName, EscapeChars[i], Char(StrToInt('$' + Copy(EscapeChars[i], 2, 2))), [rfReplaceAll]);

  // Além disso, substituir o sinal de mais por espaço em branco
  vFileName := StringReplace(vFileName, '%2B', ' ', [rfReplaceAll]);
end;

procedure TPrismServerTCP.SendWebSocketMessage(AMessage: string; APrismSession: IPrismSession);
var
 vContext: TIdContext;
begin
 if AMessage <> '' then
 begin
  try
   vContext:= (APrismSession as TPrismSession).WebSocketContext;

   if Assigned(vContext) then
    if Assigned(vContext.Connection) then
     if vContext.Connection.Connected then
      if Assigned(vContext.Connection.IOHandler) then
       if vContext.Connection.Connected then
        TWebSocketIOHandlerHelper(vContext.Connection.IOHandler).WriteString(AMessage);
  except
  end;
 end;
end;


procedure TPrismServerTCP.SetAppBase(const Value: string);
begin
 if FAppBase = '/' then
 begin
  FAppBase:= Value;

  if FAppBase.EndsWith('/') then
   FAppBase:= Copy(FAppBase, 1, Length(FAppBase) - 1);

  if not FAppBase.StartsWith('/') then
   FAppBase:= '/' + FAppBase;
 end;
end;

{ TWebSocketIOHandlerHelper }


function TWebSocketIOHandlerHelper.ReadBytes: TArray<Byte>;
var
  l: Byte;
  b: array [0..7] of Byte;
  i, DecodedSize: {$IFNDEF FPC}Int64{$ELSE}SizeInt{$ENDIF};
  Mask: array [0..3] of Byte;
begin
  try
    Result:= [];

    if ReadByte = $81 then
    begin
      l := ReadByte;
      case l of
        $FE:
          begin
            b[1] := ReadByte;
            b[0] := ReadByte;
            b[2] := 0;
            b[3] := 0;
            b[4] := 0;
            b[5] := 0;
            b[6] := 0;
            b[7] := 0;
            DecodedSize := PInt64(@b)^;
          end;
        $FF:
          begin
            b[7] := ReadByte;
            b[6] := ReadByte;
            b[5] := ReadByte;
            b[4] := ReadByte;
            b[3] := ReadByte;
            b[2] := ReadByte;
            b[1] := ReadByte;
            b[0] := ReadByte;
            DecodedSize := PInt64(@b)^;
          end;
        else
          DecodedSize := l - 128;
      end;
      Mask[0] := ReadByte;
      Mask[1] := ReadByte;
      Mask[2] := ReadByte;
      Mask[3] := ReadByte;

      if DecodedSize < 1 then
      begin
        Result := [];
        Exit;
      end;

      SetLength(Result, DecodedSize);
      inherited ReadBytes(TIdBytes(Result), DecodedSize, False);
      for i := 0 to DecodedSize - 1 do
        Result[i] := Result[i] xor Mask[i mod 4];
    end;
  except
    on E: Exception do
    begin
     Result:= [];

     //OutputDebugString(PWideChar(E.Message));
    end;
  end;
end;


//function TWebSocketIOHandlerHelper.ReadBytes: TArray<byte>;
//var
//  l: byte;
//  b: array [0..7] of byte;
//  i, DecodedSize: int64;
//  Mask: array [0..3] of byte;
//begin
//  // https://stackoverflow.com/questions/8125507/how-can-i-send-and-receive-websocket-messages-on-the-server-side
//
//  try
//    if ReadByte = $81 then
//    begin
//      l := ReadByte;
//      case l of
//        $FE:
//          begin
//            b[1] := ReadByte; b[0] := ReadByte;
//            b[2] := 0; b[3] := 0; b[4] := 0; b[5] := 0; b[6] := 0; b[7] := 0;
//            DecodedSize := Int64(b);
//          end;
//        $FF:
//          begin
//            b[7] := ReadByte; b[6] := ReadByte; b[5] := ReadByte; b[4] := ReadByte;
//            b[3] := ReadByte; b[2] := ReadByte; b[1] := ReadByte; b[0] := ReadByte;
//            DecodedSize := Int64(b);
//          end;
//        else
//          DecodedSize := l - 128;
//      end;
//      Mask[0] := ReadByte; Mask[1] := ReadByte; Mask[2] := ReadByte; Mask[3] := ReadByte;
//
//      if DecodedSize < 1 then
//      begin
//        result := [];
//        exit;
//      end;
//
//      SetLength(result, DecodedSize);
//      inherited ReadBytes(TIdBytes(result), DecodedSize, False);
//      for i := 0 to DecodedSize - 1 do
//        result[i] := result[i] xor Mask[i mod 4];
//    end;
//  except
//  end;
//end;

procedure TWebSocketIOHandlerHelper.WriteBytes(RawData: TArray<byte>);
var
  Msg: TArray<byte>;
begin
  // https://stackoverflow.com/questions/8125507/how-can-i-send-and-receive-websocket-messages-on-the-server-side

  Msg := [$81];

  if Length(RawData) <= 125 then
    Msg := Msg + [Length(RawData)]
  else if (Length(RawData) >= 126) and (Length(RawData) <= 65535) then
    Msg := Msg + [126, (Length(RawData) shr 8) and 255, Length(RawData) and 255]
  else
    Msg := Msg + [127, (int64(Length(RawData)) shr 56) and 255, (int64(Length(RawData)) shr 48) and 255,
      (int64(Length(RawData)) shr 40) and 255, (int64(Length(RawData)) shr 32) and 255,
      (Length(RawData) shr 24) and 255, (Length(RawData) shr 16) and 255, (Length(RawData) shr 8) and 255, Length(RawData) and 255];

  Msg := Msg + RawData;

  try
    Write(TIdBytes(Msg), Length(Msg));
  except
  end;
end;




function TWebSocketIOHandlerHelper.ReadString: string;
var
  Bytes: TBytes;
begin
 try
  Bytes := ReadBytes;

  if (Assigned(Bytes)) and (Length(Bytes) > 0) then
  begin
    Result := TEncoding.UTF8.GetString(Bytes);
  end
  else
  begin
    Result := '';
  end;
 except
  Result:= '';
 end;
end;



procedure TWebSocketIOHandlerHelper.WriteString(const str: string);
begin
  WriteBytes(TArray<byte>(IndyTextEncoding_UTF8.GetBytes(str)));
end;

end.