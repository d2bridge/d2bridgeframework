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

unit Prism.BaseClass;

interface

uses
  Classes, SysUtils, IniFiles, Generics.Collections,
  SyncObjs, D2Bridge.JSON, Rtti,
{$IFDEF HAS_UNIT_SYSTEM_THREADING}
  System.Threading,
{$ENDIF}
{$IFDEF HAS_UNIT_SYSTEM_IOUTILS}
  System.IOUtils,
{$ENDIF}
{$IFDEF FPC}
  LResources, FileUtil, LazFileUtils,
{$ENDIF}
{$IFDEF MSWINDOWS}
  ActiveX, Windows, ShellApi,
{$ENDIF}
{$IFDEF FMX}
  FMX.Forms,
{$ELSE}
  Forms,
{$ENDIF}
  IdGlobal, IdSSLOpenSSL,
  Prism.Server.HTML.Headers, Prism.Session.Event, Prism.Types, Prism.Log, Prism.Server.Thread.TCP,
  Prism.Server.TCP, Prism.Server.HTTP.Commom,
  {$IFDEF D2BRIDGE}Prism.Server.HTML,{$ENDIF}
{$IFDEF FMX}
  D2Bridge.FMX.FakeForm,
{$ENDIF}
  D2Bridge.Interfaces, D2Bridge.Rest.Interfaces, D2Bridge.Rest.Session,
  Prism.Interfaces, Prism.DataWare.Mapped, Prism.BaseClass.Sessions,
  Prism.BaseClass.Timer, Prism.Options, Prism.Options.Security.Event;


type
 TOnPrismException = procedure(Form: TObject; Sender: TObject; E: Exception; FormName: String; ComponentName: String; EventName: string; APrismSession: IPrismSession) of object;


type
 TPrismBaseClass = class(TInterfacedPersistent, IPrismBaseClass)
  strict private
   procedure Exec_DoCloseSessionSessionChange(varPrismSession: TValue);
   procedure Exec_DoCloseSessionOnCloseSession(varPrismSession: TValue);
   procedure Exec_DoIdleSession(varPrismSession: TValue);
   procedure Exec_DoDisconnectSession(varPrismSession: TValue);
   procedure Exec_DoNewSessionDoSessionChange(varPrismSession: TValue);
   procedure Exec_DoNewSessionOnNewSession(varPrismRequest, varPrismResponse, varPrismSession: TValue);
   procedure Exec_DoReconnectSession(varPrismSession: TValue);
   procedure Exec_ProcDoSecurity(varSecEventInfo: TValue);
   procedure Exec_ProcDoException(varExceptionInfo: TValue);
  Private
   FPrismThreadServerTCP: TPrismThreadServerTCP;
   {$IFDEF D2BRIDGE}FPrismServerHTML: TPrismServerHTML;{$ENDIF}
   FPrismServerHTMLHeaders: TPrismServerHTMLHeaders;
   FOnNewSession: TOnNewSession;
   FOnCloseSession: TOnCloseSession;
   FOnPrismException: TOnPrismException;
   FOnDisconnectSession :TOnSessionEvent;
   FOnExpiredSession: TOnExpiredSession;
   FOnIdleSession: TOnIdleSession;
   FOnReconnectSession :TOnSessionEvent;
   FOnSecurity: TOnSecurityEvent;
   FOnRoute: TOnRouteEvent;
   FOnBeforeServerStart: TOnServerEvent;
   FOnAfterServerStart: TOnServerEvent;
   FOnBeforeServerStop: TOnServerEvent;
   FOnAfterServerStop: TOnServerEvent;
   FPrismOptions: IPrismOptions;
   FServerController: ID2BridgeServerControllerBase;
   FPrismLog: TPrismLog;
   FServerUUID: string;
   FSessions: IPrismSessions;
   FPrismTimer: TPrismTimer;
   function GetServerPort: Integer;
   procedure SetServerPort(APort: Integer);
   function GetOptions: IPrismOptions;
   procedure OnTimerObserver;
{$IFDEF D2BRIDGE}
   procedure SupportFileFromRC(AResourceName: string; AFileName: string; APath: string; ASaveFilesonDisk: boolean); overload;
   procedure SupportFileFromRC(AResourceName: string; var AFileContent: string); overload;
   procedure SavePrismSupportFiles(ASaveFilesonDisk: boolean);
{$ENDIF}
   function GetPrismServerTCP: TPrismServerTCP;
  Public
   constructor Create(AOwner: TComponent); virtual;
   destructor Destroy; override;

   procedure InstancePrimaryForm(APrismSession: IPrismSession);

   procedure DoNewSession(const Request: TPrismHTTPRequest; const Response: TPrismHTTPResponse; const Session: IPrismSession); virtual;
   procedure DoCloseSession(const Session: IPrismSession); virtual;
   procedure DoReconnectSession(const Session: IPrismSession); virtual;
   procedure DoExpireSession(const Session: IPrismSession); virtual;
   procedure DoIdleSession(const Session: IPrismSession); virtual;
   procedure DoDisconnectSession(const Session: IPrismSession); virtual;
   procedure DoException(Sender: TObject; E: Exception; APrismSession: IPrismSession; EventName: string); virtual;
   procedure DoSecurity(const SecEventInfo: TSecuritEventInfo); virtual;
   procedure DoRoute(const RestSession: TD2BridgeRestSession; const Request: TPrismHTTPRequest; const Response: TPrismHTTPResponse); virtual;
   procedure Log(const SessionIdenty, ErrorForm, ErrorObject, ErrorEvent, ErrorMsg: string);
   procedure LogSecurity(const SecEventInfo: TSecuritEventInfo);
   procedure LogAccess(const APrismSessionInfo: IPrismSessionInfo);
  published
   function Started: boolean;
   procedure StartServer;
   procedure StopServer;
   function SSLOptions: TIdSSLOptions;
   function ServerUUID: string;

   function Sessions: IPrismSessions;

   function Rest: ID2BridgeRest;

   function IsD2DockerContext: boolean;
   function IsD2BridgeContext: boolean;

   function API: ID2BridgeAPI;

   function INIConfig: ID2BridgeAPPConfigINIConfig;

   property PrismServer: TPrismServerTCP read GetPrismServerTCP;
   property ServerController: ID2BridgeServerControllerBase read FServerController write FServerController;
   property ServerPort: integer read GetServerPort write SetServerPort;
   //property Sessions: TDictionary<string, IPrismSession> read GetSessions;
   property PrismServerHTMLHeaders: TPrismServerHTMLHeaders read FPrismServerHTMLHeaders;
{$IFDEF D2BRIDGE}
   property PrismServerHTML: TPrismServerHTML read FPrismServerHTML;
{$ENDIF}
   property OnNewSession: TOnNewSession read FOnNewSession write FOnNewSession;
   property OnCloseSession: TOnCloseSession read FOnCloseSession write FOnCloseSession;
   property OnException: TOnPrismException read FOnPrismException write FOnPrismException;
   property OnDisconnectSession: TOnSessionEvent read FOnDisconnectSession write FOnDisconnectSession;
   property OnReconnectSession: TOnSessionEvent read FOnReconnectSession write FOnReconnectSession;
   property OnExpiredSession: TOnExpiredSession read FOnExpiredSession write FOnExpiredSession;
   property OnIdleSession: TOnIdleSession read FOnIdleSession write FOnIdleSession;
   property OnBeforeServerStart: TOnServerEvent read FOnBeforeServerStart write FOnBeforeServerStart;
   property OnAfterServerStart: TOnServerEvent read FOnAfterServerStart write FOnAfterServerStart;
   property OnBeforeServerStop: TOnServerEvent read FOnBeforeServerStop write FOnBeforeServerStop;
   property OnAfterServerStop: TOnServerEvent read FOnAfterServerStop write FOnAfterServerStop;
   property OnSecurity: TOnSecurityEvent read FOnSecurity write FOnSecurity;
   property OnRoute: TOnRouteEvent read FOnRoute write FOnRoute;
   property Options: IPrismOptions read GetOptions;
 end;


function PrismBaseClass: TPrismBaseClass;

const
 SizeServerUUID = 22;


implementation

uses
  D2Bridge.Manager, D2Bridge.Forms, D2Bridge.Instance, Prism.Session, Prism.Session.Helper, Prism.Forms, Prism.Util,
  D2Bridge.Util, D2Bridge.Rest,
  Prism.Session.Thread.Proc;

var PrismBaseClassInstance: TPrismBaseClass;

function PrismBaseClass: TPrismBaseClass;
begin
 Result:= PrismBaseClassInstance;
end;

function D2BridgeManager: TD2BridgeManager;
begin
 Result:= D2Bridge.Manager.D2BridgeManager;
end;


{ TPrismBaseClass }

function TPrismBaseClass.API: ID2BridgeAPI;
begin
 result:= D2BridgeManager.API;
end;

constructor TPrismBaseClass.Create(AOwner: TComponent);
begin
 //FOwner:= AOwner;
 Inherited Create;;

 PrismBaseClassInstance:= self;

{$IFDEF D2BRIDGE}
 FSessions:= TPrismSessions.Create;

 if not Assigned(D2Bridge.Rest.D2BridgeRest) then
  TD2BridgeRest.Create;

 FPrismOptions:= TPrismOptions.Create;

 FPrismTimer:= TPrismTimer.Create(Options.HeartBeatTime, OnTimerObserver); 

 FPrismThreadServerTCP:= TPrismThreadServerTCP.Create;

// FPrismServerTCP:= TPrismServerTCP.Create;
// FPrismServerTCP.DefaultPort:= 8888;
// FPrismServerTCP.MaxConnections:= MaxInt;
// FPrismServerTCP.ListenQueue:= 0;

 FPrismServerHTML:= TPrismServerHTML.Create(nil);

// FPrismServerTCP.OnGetHTML:= FPrismServerHTML.GetHTML;
// FPrismServerTCP.OnReceiveMessage := FPrismServerHTML.ReceiveMessage;
// FPrismServerTCP.OnGetFile:= FPrismServerHTML.GetFile;
// FPrismServerTCP.OnFinishedGetHTML:= FPrismServerHTML.FinishedGetHTML;
// FPrismServerTCP.OnRESTData:= FPrismServerHTML.RESTData;
// FPrismServerTCP.OnDownloadData:= FPrismServerHTML.DownloadData;

{$IFDEF FMX}
{$IFnDEF D2Docker}
 FMXFakeForm:= TFMXFakeForm.Create(Application);
 FMXFakeForm.Hide;
{$ENDIF}
{$ENDIF}
{$ENDIF}

 FPrismServerHTMLHeaders:= TPrismServerHTMLHeaders.Create(nil);
end;


destructor TPrismBaseClass.Destroy;
var
 vSessions: TPrismSessions;
 vPrismOptions: TPrismOptions;
begin
{$IFDEF FMX}
 if Assigned(FMXFakeForm) then
  FreeAndNil(FMXFakeForm);
{$ENDIF}

{$IFDEF D2BRIDGE}
 vSessions:= FSessions as TPrismSessions;
 FSessions:= nil;
 vSessions.Free;


 FPrismTimer.Terminate;
 Sleep(100);

 //**The PrismServerTCP is Terminated**
 FPrismThreadServerTCP.Terminate;
 Sleep(100);
 FPrismThreadServerTCP.free;
 Sleep(200);

 D2BridgeRest.Free;

 //FPrismThreadServerTCP.Free;
// if FPrismServerTCP.Active then
//  FPrismServerTCP.Active:= false;

 //FreeAndNil(FPrismServerTCP);
 FreeAndNil(FPrismServerHTMLHeaders);

 FreeAndNil(FPrismServerHTML);

 vPrismOptions:= FPrismOptions as TPrismOptions;
 FPrismOptions:= nil;
 vPrismOptions.Free;
{$ENDIF}

 inherited;
end;

procedure TPrismBaseClass.DoCloseSession(const Session: IPrismSession);
begin
 if Assigned(FServerController) then
 begin
  Options.Security.IP.IPConnections.RemoveSession(Session);

  TPrismSessionThreadProc.Create(
    Session,
    Exec_DoCloseSessionSessionChange,
    TValue.From<TPrismSession>(Session as TPrismSession),
    true
   ).Exec;
 end;

 if Assigned(FOnCloseSession) then
 begin
  TPrismSessionThreadProc.Create(
   Session,
   Exec_DoCloseSessionOnCloseSession,
   TValue.From<TPrismSession>(Session as TPrismSession),
   true
  ).Exec;
 end;


// I:= Pred(FSessions.Count);
// repeat
//  if (FSessions.ToArray[I].Value.Closing) and (FSessions.ToArray[I].Value.ThreadIDs.Count <= 0) then
//  begin
//   CriticalSession.Enter;
//   try
//    TPrismSession(FSessions.ToArray[I].Value).Destroy;
//    FSessions.Remove(FSessions.ToArray[I].Value.UUID);
//   finally
//    CriticalSession.Leave;
//   end;
//  end;
//
//  Dec(I);
// until I < 0;




// for I:= 0 to Pred(FSessions.Count) do
// if (FSessions.ToArray[I].Value.Closing) and (FSessions.ToArray[I].Value.ThreadIDs.Count <= 0) then
// begin
//  CriticalSession.Enter;
//  try
//   TPrismSession(FSessions.ToArray[I].Value).Destroy;
//   FSessions.Remove(FSessions.ToArray[I].Value.UUID);
//   //break;
//  finally
//   CriticalSession.Leave;
//  end;
// end;
end;

procedure TPrismBaseClass.DoException(Sender: TObject; E: Exception; APrismSession: IPrismSession; EventName: string);
var
 vComponentName, vFormName: String;
 vForm: TObject;
 vProc: TPrismSessionThreadProc;
 vListParam: TList<TValue>;
begin
 try
  vComponentName:= '';
  vFormName:= '';
  vForm:= nil;

  if Assigned(Sender) then
   if Sender is TComponent then
    vComponentName:= TComponent(Sender).Name;

  if Assigned(APrismSession) then
   if Assigned(APrismSession.ActiveForm) then
   begin
    if (APrismSession.ActiveForm as TPrismForm).D2BridgeForm <> nil then
    begin
     vForm:= (APrismSession.ActiveForm as TPrismForm).D2BridgeForm;
     vFormName:= TD2BridgeForm(vForm).Name;
    end;
   end;


  if Assigned(Options) then
   if Options.LogException then
   begin
    if Assigned(APrismSession) then
     FPrismLog.Log
      (
       APrismSession.InfoConnection.Identity,
       APrismSession.ActiveForm.Name,
       vComponentName,
       EventName,
       E.Message
      )
    else
     FPrismLog.Log
      (
       '',
       '',
       vComponentName,
       EventName,
       E.Message
      )

   end;

  if Assigned(FOnPrismException) then
  begin
   vListParam:= TList<TValue>.Create;
   vListParam.Add(vForm);
   vListParam.Add(Sender);
   vListParam.Add(CopyException(E));
   vListParam.Add(vFormName);
   vListParam.Add(vComponentName);
   vListParam.Add(EventName);
   vListParam.Add(APrismSession as TPrismSession);

   vProc:= TPrismSessionThreadProc.Create(nil,
    Exec_ProcDoException,
    TValue.From<TObject>(vListParam)
   );
   vProc.Exec;
   //FOnPrismException(vForm, Sender, E, vFormName, vComponentName, EventName, APrismSession);
  end;
 except
 end;

{$IFDEF D2BRIDGE}
 {$IFDEF MSWINDOWS}
 if IsDebuggerPresent and (not IsD2DockerContext) then
  raise Exception.Create(E.Message);
 {$ENDIF}
{$ENDIF}
end;

procedure TPrismBaseClass.DoExpireSession(const Session: IPrismSession);
begin

end;


procedure TPrismBaseClass.DoIdleSession(const Session: IPrismSession);
begin
 if Assigned(FServerController) then
 begin
  try
   (Session as TPrismSession).SetCheckingConn(True);

   Session.ExecThread(false,
    Exec_DoIdleSession,
    TValue.From<TPrismSession>(Session as TPrismSession)
   );
  except
  end;
 end;
end;

procedure TPrismBaseClass.DoDisconnectSession(const Session: IPrismSession);
begin
 if Assigned(FServerController) then
 begin
  try
   (Session as TPrismSession).SetCheckingConn(True);

   Session.ExecThread(false,
    Exec_DoDisconnectSession,
    TValue.From<TPrismSession>(Session as TPrismSession)
   );
  except
  end;
 end;
end;

procedure TPrismBaseClass.DoNewSession(const Request: TPrismHTTPRequest; const Response: TPrismHTTPResponse; const Session: IPrismSession);
begin
 if Assigned(FServerController) then
 begin
  Options.Security.IP.IPConnections.AddSession(Session);

  Session.ExecThread(true,
   Exec_DoNewSessionDoSessionChange,
   TValue.From<TPrismSession>(Session as TPrismSession)
  );
 end;

 if Assigned(FOnNewSession) then
 begin
  Session.ExecThread(true,
   Exec_DoNewSessionOnNewSession,
   TValue.From<TPrismHTTPRequest>(Request),
   TValue.From<TPrismHTTPResponse>(Response),
   TValue.From<TPrismSession>(Session as TPrismSession)
  );
 end;
end;


procedure TPrismBaseClass.DoReconnectSession(const Session: IPrismSession);
begin
 if Assigned(FServerController) then
 begin
  Session.ExecThread(false,
   Exec_DoReconnectSession,
   TValue.From<TPrismSession>(Session as TPrismSession)
  );
 end;
end;


procedure TPrismBaseClass.DoRoute(const RestSession: TD2BridgeRestSession; const Request: TPrismHTTPRequest; const Response: TPrismHTTPResponse);
begin
 if Assigned(FOnRoute) then
  FOnRoute(RestSession, Request, Response);
end;


procedure TPrismBaseClass.DoSecurity(const SecEventInfo: TSecuritEventInfo);
var
 vProc: TPrismSessionThreadProc;
 vListParam: TList<TValue>;
begin
 if Assigned(FOnSecurity) then
 begin
  vListParam:= TList<TValue>.Create;

  vListParam.Add(SecEventInfo.IP);
  vListParam.Add(SecEventInfo.IsIPV6);
  vListParam.Add(SecEventInfo.UserAgent);
  vListParam.Add(Ord(SecEventInfo.Event));

  vProc:= TPrismSessionThreadProc.Create(nil,
   Exec_ProcDoSecurity,
   TValue.From<TObject>(vListParam)
  );
  vProc.Exec;
 end;

 LogSecurity(SecEventInfo);
end;

procedure TPrismBaseClass.Exec_DoCloseSessionOnCloseSession(varPrismSession: TValue);
var
 vPrismSession: TPrismSession;
begin
 try
  vPrismSession:= (varPrismSession.AsObject as TPrismSession);

  PrismBaseClass.FOnCloseSession(vPrismSession);
 except
 end;
end;

procedure TPrismBaseClass.Exec_DoCloseSessionSessionChange(varPrismSession: TValue);
var
 vPrismSession: TPrismSession;
begin
 try
  vPrismSession:= (varPrismSession.AsObject as TPrismSession);

  FServerController.DoSessionChange(scsCloseSession, vPrismSession);
 except
 end;

end;

procedure TPrismBaseClass.Exec_DoDisconnectSession(varPrismSession: TValue);
var
 vSession: TPrismSession;
 vSecondsInDisconnect: Integer;
 vRenewTimeOut: Boolean;
 vDestroy: Boolean;
begin
// try
//  try
//   vSession:= (varPrismSession.AsObject as TPrismSession);
//
//   Sleep(TimeWaitDisconnectSession);
//
//   if (not (csDestroying in (vSession as TPrismSession).ComponentState)) then
//    if Assigned(vSession) and (not vSession.Closing) then
//    begin
//     if ((vSession.ConnectionStatus = scsLostConnectioSession) or
//         (vSession.LastHeartBeatInSeconds > (PrismBaseClass.Options.HeartBeatTime / 1000))) and
//        (not vSession.Disconnected) then
//     begin
//      try
//       vSession.SetDisconnect(true);
//      except
//      end;
//
//      if Assigned(PrismBaseClass.FOnDisconnectSession) then
//      begin
//       try
//        PrismBaseClass.FOnDisconnectSession(vSession);
//       except
//       end;
//      end;
//
//      {$REGION 'Session Expire'}
//      vRenewTimeOut:= false;
//      vSecondsInDisconnect:= vSession.DisconnectedInSeconds;
//
//      repeat
//        try
//          vDestroy:= False;
//
//          Sleep(PrismBaseClass.Options.SessionTimeOut * 1000);
//
//          if Assigned(vSession) and (not vSession.Closing) then
//            if ((vSession.ConnectionStatus = scsLostConnectioSession) or
//                (vSession.LastHeartBeatInSeconds > (PrismBaseClass.Options.HeartBeatTime / 1000))) and
//               (vSession.Disconnected) then
//            begin
//              if Assigned(PrismBaseClass.FOnExpiredSession) then
//              begin
//                try
//                 PrismBaseClass.FOnExpiredSession(vSession, vRenewTimeOut);
//                except
//                end;
//              end;
//
//              if not vRenewTimeOut then
//              begin
//                try
//                 vSession.Close(false);
//                 vDestroy:= True;
//                except
//                end;
//                break;
//              end else
//                try
//                 vSecondsInDisconnect:= vSession.DisconnectedInSeconds;
//                except
//                end;
//            end;
//        except
//        end;
//      until (not Assigned(vSession)) or
//            (vSecondsInDisconnect > vSession.DisconnectedInSeconds) or
//            (not vSession.Disconnected) or
//            (vSession.Closing) or
//            (not vRenewTimeOut);
//
//      if not vDestroy then
//       vSession.SetCheckingConn(False);
//      {$ENDREGION}
//     end else
//      vSession.SetCheckingConn(False);
//    end else
//     vSession.SetCheckingConn(False);
//  except
//  end;
// except
// end;
end;

procedure TPrismBaseClass.Exec_DoIdleSession(varPrismSession: TValue);
var
  vSession: TPrismSession;
  vRenewTimeOut: Boolean;
begin
 try
  try
   vSession:= (varPrismSession.AsObject as TPrismSession);

   if Assigned(vSession) and (not vSession.Closing) and (not (csDestroying in (vSession as TPrismSession).ComponentState)) then
    if (not vSession.Disconnected) and (not vSession.Idle) then
    begin
     vSession.SetIdle(True);

     vRenewTimeOut:= false;

     repeat
      try
       if Assigned(PrismBaseClass.FOnIdleSession) then
        PrismBaseClass.FOnIdleSession(vSession, vRenewTimeOut);

       if not vRenewTimeOut then
       begin
        vSession.ShowMessageSessionIdle;
        break;
       end else
        Sleep(PrismBaseClass.Options.SessionIdleTimeOut);
      except
      end;
     until (not vSession.Idle) or (vSession.Disconnected) or (vSession.Closing) or (not vRenewTimeOut);
    end;
  finally
   try
    if (not (csDestroying in (vSession as TPrismSession).ComponentState))  then
     (vSession as TPrismSession).SetCheckingConn(False);
   except
   end;
  end;
 except
 end;
end;

procedure TPrismBaseClass.Exec_DoNewSessionDoSessionChange(varPrismSession: TValue);
var
 vPrismSession: TPrismSession;
begin
 try
  vPrismSession:= (varPrismSession.AsObject as TPrismSession);

  FServerController.DoSessionChange(scsNewSession, vPrismSession);
 except
 end;
end;

procedure TPrismBaseClass.Exec_DoNewSessionOnNewSession(varPrismRequest, varPrismResponse, varPrismSession: TValue);
var
 vPrismRequest: TPrismHTTPRequest;
 vPrismResponse: TPrismHTTPResponse;
 vPrismSession: TPrismSession;
begin
 try
  vPrismRequest:= (varPrismRequest.AsObject as TPrismHTTPRequest);
  vPrismResponse:= (varPrismResponse.AsObject as TPrismHTTPResponse);
  vPrismSession:= (varPrismSession.AsObject as TPrismSession);

  PrismBaseClass.FOnNewSession(vPrismRequest, vPrismResponse, vPrismSession);
 except
 end;
end;

procedure TPrismBaseClass.Exec_DoReconnectSession(varPrismSession: TValue);
var
 vSession: TPrismSession;
begin
// try
//  vSession:= TPrismSession(varPrismSession.AsObject);
//  //Sleep(5000);
//
//  if Assigned(vSession) and (not vSession.Closing) and (not (csDestroying in (vSession as TPrismSession).ComponentState)) then
//   if (vSession.ConnectionStatus = scsActiveSession) and (vSession.Disconnected) then
//   begin
//    try
//     vSession.SetDisconnect(false);
//    except
//    end;
//
//    try
//     if Assigned(PrismBaseClass.FOnReconnectSession) then
//      PrismBaseClass.FOnReconnectSession(vSession);
//    except
//    end;
//   end;
// except
// end;
end;

procedure TPrismBaseClass.Exec_ProcDoException(varExceptionInfo: TValue);
var
 vListParam: TList<TValue>;
 vExcept: Exception;
 vExceptionStr: string;
begin
 try
  vListParam:= TList<TValue>(varExceptionInfo.AsObject);

  vExcept:= Exception(vListParam[2].AsObject);

  if not Assigned(vExcept) then
   vExcept:= Exception.Create('Error');

  if (not vListParam[6].IsEmpty) and
     (vListParam[6].IsObject) and
     (vListParam[6].AsObject is TPrismSession) then
   PrismBaseClass.FOnPrismException(
     vListParam[0].AsObject,
     vListParam[1].AsObject,
     vExcept,
     vListParam[3].AsString,
     vListParam[4].AsString,
     vListParam[5].AsString,
     (vListParam[6].AsObject as TPrismSession));


  if ServerController.IsD2DockerContext then
  begin
   vExceptionStr:= vExcept.Message;

   if vListParam[3].AsString <> '' then
   begin
    if vExceptionStr <> '' then
     vExceptionStr:= vExceptionStr + ' | ';
    vExceptionStr:= vExceptionStr + 'Form: ' + vListParam[3].AsString;
   end;

   if vListParam[4].AsString <> '' then
   begin
    if vExceptionStr <> '' then
     vExceptionStr:= vExceptionStr + ' | ';
    vExceptionStr:= vExceptionStr + 'Component: ' + vListParam[4].AsString;
   end;

   if vListParam[5].AsString <> '' then
   begin
    if vExceptionStr <> '' then
     vExceptionStr:= vExceptionStr + ' | ';
    vExceptionStr:= vExceptionStr + 'Event: ' + vListParam[5].AsString;
   end;

{$IFDEF D2DOCKER}
   D2BridgeManager.API.D2Docker.DoLogException(vExceptionStr);
{$ENDIF}
  end;


  vExcept.Free;
  vListParam.Free;
 except
 end;
end;

procedure TPrismBaseClass.Exec_ProcDoSecurity(varSecEventInfo: TValue);
var
 vListParam: TList<TValue>;
 vSecEventInfo: TSecuritEventInfo;
begin
 try
  vListParam:= TList<TValue>(varSecEventInfo.AsObject);

  vSecEventInfo:= Default(TSecuritEventInfo);
  vSecEventInfo.IP:= vListParam[0].AsString;
  vSecEventInfo.IsIPV6:= vListParam[1].AsBoolean;
  vSecEventInfo.UserAgent:= vListParam[2].AsString;
  vSecEventInfo.Event:= TSecurityEvent(vListParam[3].AsInteger);

  vListParam.Free;

  PrismBaseClass.FOnSecurity(vSecEventInfo);
 except
 end;
end;

function TPrismBaseClass.GetOptions: IPrismOptions;
begin
 Result:= FPrismOptions;
end;

function TPrismBaseClass.GetPrismServerTCP: TPrismServerTCP;
begin
 result:= FPrismThreadServerTCP.PrismServerTCP;
end;

function TPrismBaseClass.GetServerPort: Integer;
begin
 Result:= FPrismThreadServerTCP.Port;
end;

function TPrismBaseClass.INIConfig: ID2BridgeAPPConfigINIConfig;
begin
 result:= AppConfig.INIConfig;
end;

procedure TPrismBaseClass.InstancePrimaryForm(APrismSession: IPrismSession);
var
 vD2BridgeForm: TD2BridgeForm;
begin
{$IFDEF D2BRIDGE}
 if D2BridgeManager.PrimaryFormClass <> nil then
 begin
  vD2BridgeForm:= TD2BridgeFormClass(D2BridgeManager.PrimaryFormClass).Create(APrismSession as TPrismSession, APrismSession as TPrismSession);
  TD2BridgeInstance(APrismSession.D2BridgeInstance).AddInstace(vD2BridgeForm);
  (APrismSession as TPrismSession).SetPrimaryForm(vD2BridgeForm);
  vD2BridgeForm.DoShow;

  //vD2BridgeForm.show;// WindowAsync(vD2BridgeForm.Handle, SW_HIDE);
  //vD2BridgeForm.Show;
  //vD2BridgeForm.Show;


  //TD2BridgeFormClass(D2BridgeManager.PrimaryFormClass).CreateInstance(TPrismSession(APrismSession));
 end else
 raise Exception.Create('Error Instance Primary Form: Error 1001');
{$ELSE}

{$ENDIF}
end;

function TPrismBaseClass.IsD2BridgeContext: boolean;
begin
 {$IFDEF D2BRIDGE}
 Result := True;
 {$ELSE}
 Result := False;
 {$ENDIF}
end;

function TPrismBaseClass.IsD2DockerContext: boolean;
begin
 result:= ServerController.IsD2DockerContext;
end;

procedure TPrismBaseClass.Log(const SessionIdenty, ErrorForm, ErrorObject, ErrorEvent, ErrorMsg: string);
begin
 if FPrismOptions.LogException then
  if Assigned(FPrismLog) then
   FPrismLog.Log(SessionIdenty, ErrorForm, ErrorObject, ErrorEvent, ErrorMsg);
end;

procedure TPrismBaseClass.LogAccess(const APrismSessionInfo: IPrismSessionInfo);
begin
 if Assigned(FPrismLog) then
  FPrismLog.LogAccess(
  APrismSessionInfo.IP,
  APrismSessionInfo.UserAgent,
  APrismSessionInfo.User,
  APrismSessionInfo.Identity,
  '');
end;

procedure TPrismBaseClass.LogSecurity(const SecEventInfo: TSecuritEventInfo);
begin
 if FPrismOptions.LogSecurity then
  if Assigned(FPrismLog) then
   FPrismLog.LogSecurity(
    SecEventInfo.Event,
    SecEventInfo.IP,
    SecEventInfo.UserAgent,
    '',
    SecEventInfo.IsIPV6);
end;

procedure TPrismBaseClass.OnTimerObserver;
var
 vSessions: TList<IPrismSession>;
 vSession: IPrismSession;
begin
 exit;

 FPrismTimer.Pause;

 try
  try
   vSessions:= Sessions.Items;

   for vSession in vSessions do
   begin
    try
//     try
//      if Not Assigned(vSession) then
//      begin
//       Sessions.Delete(vSession);
//
//       Continue;
//      end;
//
//      try
//       //Check if Fail
//       if vSession.LastActivityInSeconds >= 3600 then
//       begin
//        (Sessions as TPrismSession).Destroy;
//
//        Continue;
//       end;
//      except
//       try
//       except
//        Sessions.Delete(vSession);
//        Continue;
//       end;
//      end;
//     except
//     end;

     if Assigned(vSession) and ((vSession as TPrismSession).CheckingConn) then
       Continue;

     if Assigned(vSession) and
        (not vSession.Closing) and
        (not (csDestroying in (vSession as TPrismSession).ComponentState)) then
     begin
      if ((not vSession.StabilizedConn) and
         (vSession.LastActivityInSeconds > 300)) or
         ((Options.SessionTimeOut > 0) and
         (vSession.LastHeartBeatInSeconds > (Options.HeartBeatTime / 1000)) and
         (not vSession.Disconnected)) then
      begin
       DoDisconnectSession(vSession);
      end else
       if Options.SessionIdleTimeOut > 0 then
       begin
        if (vSession.StabilizedConn) and
           (vSession.LastActivityInSeconds > Options.SessionIdleTimeOut) and
           (not vSession.Disconnected) then
        begin
         DoIdleSession(vSession);
        end;
       end else
       if (vSession.LastActivityInSeconds <= Options.SessionIdleTimeOut) and
          (vSession.Idle) then
       begin
        (vSession as TPrismSession).SetIdle(false);
       end;
     end;
    except
    end;
   end;
  except
  end;
 finally
  FreeAndNil(vSessions);
  FPrismTimer.Resume;
 end;
end;


function TPrismBaseClass.Rest: ID2BridgeRest;
begin
 if Not Assigned(D2Bridge.Rest.D2BridgeRest) then
  TD2BridgeRest.Create;

 result:= D2BridgeRest;
end;

{$IFDEF D2BRIDGE}
procedure TPrismBaseClass.SavePrismSupportFiles(ASaveFilesonDisk: boolean);
begin
 SupportFileFromRC('PRISM_Support_Assets_JS_PrismServer', 'prismserver.js', '', ASaveFilesonDisk);

 SupportFileFromRC('PRISM_Support_Assets_JS_D2BridgeLoader', FPrismServerHTML.FFileD2BridgeLoader);

{$IFDEF D2DOCKER}
 SupportFileFromRC('PRISM_Support_Assets_JS_D2docker', FPrismServerHTML.FFileD2dockerJS);
{$ENDIF}

 SupportFileFromRC('PRISM_Support_Assets_CSS_D2Bridge', 'd2bridge.css', '', ASaveFilesonDisk);

 SupportFileFromRC('PRISM_Support_HTML_Error500', FPrismServerHTML.FFileError500);

 SupportFileFromRC('PRISM_Support_HTML_Error429', FPrismServerHTML.FFileError429);

 SupportFileFromRC('PRISM_Support_HTML_Error403blacklist', FPrismServerHTML.FFileErrorBlackList);

 if PrismBaseClass.Options.IncludeInputMask then
  SupportFileFromRC('PRISM_Support_Assets_JS_JQInputMask', 'jquery.inputmask.js', '', ASaveFilesonDisk);

 if PrismBaseClass.Options.IncludeJQuery then
  SupportFileFromRC('PRISM_Support_Assets_JS_JQuery_3_6_4', 'jquery-3.6.4.js', '', ASaveFilesonDisk);

 if PrismBaseClass.Options.IncludeSweetAlert2 then
 begin
  SupportFileFromRC('PRISM_Support_Assets_CSS_SweetAlert2', 'sweetalert2.css', '', ASaveFilesonDisk);
  SupportFileFromRC('PRISM_Support_Assets_JS_SweetAlert2', 'sweetalert2.js', '', ASaveFilesonDisk);
 end;

 if PrismBaseClass.Options.IncludeJQGrid then
 begin
  SupportFileFromRC('PRISM_Support_Assets_JS_JQGrid', 'jquery.jqgrid.min.js', '', ASaveFilesonDisk);
  SupportFileFromRC('PRISM_Support_Assets_CSS_JQGrid', 'ui.jqgrid-bootstrap5.css', '', ASaveFilesonDisk);
 end;

{$REGION 'Editor'}
  SupportFileFromRC('PRISM_Support_Assets_JS_Highlight', 'highlight.min.js', '', ASaveFilesonDisk);
{$ENDREGION}

{$REGION 'MarkDown Editor'}
  SupportFileFromRC('PRISM_Support_Assets_JS_MarkDownEditor', 'easymde.min.js', '', ASaveFilesonDisk);
  SupportFileFromRC('PRISM_Support_Assets_CSS_MarkDownEditor', 'easymde.min.css', '', ASaveFilesonDisk);
{$ENDREGION}

{$REGION 'WYSIWYG Editor'}
  SupportFileFromRC('PRISM_Support_Assets_JS_WYSIWYGEditor', 'summernote-bs5.js', '', ASaveFilesonDisk);
  SupportFileFromRC('PRISM_Support_Assets_JS_WYSIWYGEditorPlugin', 'summernote-ext-highlight.js', '', ASaveFilesonDisk);
  SupportFileFromRC('PRISM_Support_Assets_CSS_WYSIWYGEditor', 'summernote-bs5.css', '', ASaveFilesonDisk);
  SupportFileFromRC('PRISM_Support_Assets_FONT_WYSIWYGEditor1', 'summernote.woff2', '', ASaveFilesonDisk);
{$ENDREGION}

{$REGION 'Camera'}
  SupportFileFromRC('PRISM_Support_Assets_JS_D2BRIDGECAMERA', 'd2bridgecamera.js', '', ASaveFilesonDisk);
{$ENDREGION}

{$REGION 'QRCode Reader'}
  SupportFileFromRC('PRISM_Support_Assets_JS_D2BRIDGEQRCodeReader', 'zxing.browser.min.js', '', ASaveFilesonDisk);
{$ENDREGION}

{$REGION 'CORE'}
 SupportFileFromRC('PRISM_Support_Core_Variables', FPrismServerHTMLHeaders.FCoreVariable);

 SupportFileFromRC('PRISM_Support_Core_SetConnection', FPrismServerHTMLHeaders.FCoreSetConnection);

 SupportFileFromRC('PRISM_Support_Core_PrismWS', FPrismServerHTMLHeaders.FCorePrismWS);

 SupportFileFromRC('PRISM_Support_Core_PrismMethods', FPrismServerHTMLHeaders.FCorePrismMethods);

 SupportFileFromRC('PRISM_Support_Core_CallbackPrismMethods', FPrismServerHTMLHeaders.FCoreCallBackPrismMethods);

 SupportFileFromRC('PRISM_Support_Core_D2BridgeKanban', FPrismServerHTMLHeaders.FCoreD2BridgeKanban);
{$ENDREGION}
end;
{$ENDIF}

function TPrismBaseClass.ServerUUID: string;
begin
 result:= FServerUUID;
end;


function TPrismBaseClass.Sessions: IPrismSessions;
begin
 Result:= FSessions;
end;


procedure TPrismBaseClass.SetServerPort(APort: Integer);
begin
 FPrismThreadServerTCP.Port:= APort;
end;

function TPrismBaseClass.SSLOptions: TIdSSLOptions;
begin
 result:= FPrismThreadServerTCP.SSLOptions;
end;

function TPrismBaseClass.Started: boolean;
begin
 Result:= FPrismThreadServerTCP.Active;
end;

procedure TPrismBaseClass.StartServer;
begin
 if not Started then
 begin
  FServerUUID:= GenerateRandomString(SizeServerUUID);

  {$REGION 'INI Config'}
  if not ServerController.IsD2DockerContext then
   if Options.UseINIConfig then
   begin
    ServerController.APPConfig.FileINIConfig.WriteInteger('D2Bridge Server Config', 'Server Port', ServerPort);
    ServerController.APPConfig.FileINIConfig.WriteString('D2Bridge Server Config', 'Server Name', ServerController.ServerName);
    ServerController.APPConfig.FileINIConfig.WriteString('D2Bridge Server Config', 'Server Description', ServerController.ServerName);

    if SameText(ServerController.APPConfig.FileINIConfig.ReadString('D2Bridge Log', 'LogFileMode', 'session'), 'daily') then
     FPrismOptions.LogFileMode:= lfmDaily;
   end;
  {$ENDREGION}

  FPrismThreadServerTCP.Port:= ServerPort;

  if (FPrismOptions.LogException) or (FPrismOptions.LogSecurity) then
   FPrismLog:= TPrismLog.Create(FPrismOptions.LogFile, FPrismOptions.LogFileMode = lfmDaily);

  if not DirectoryExists(Options.RootDirectory) then
  MkDir(Options.RootDirectory);

  if not DirectoryExists(Options.RootDirectory + PrismBaseClass.Options.PathCSS) then
  MkDir(Options.RootDirectory + PrismBaseClass.Options.PathCSS);

  if not DirectoryExists(Options.RootDirectory + PrismBaseClass.Options.PathJS) then
  MkDir(Options.RootDirectory + PrismBaseClass.Options.PathJS);

  if not DirectoryExists(Options.RootDirectory + PrismBaseClass.Options.PathFont) then
  MkDir(Options.RootDirectory + PrismBaseClass.Options.PathFont);

  if not DirectoryExists(Options.RootDirectory + Options.PathTemp) then
   ForceDirectories(Options.RootDirectory + Options.PathTemp);

  if DirectoryExists(Options.RootDirectory + Options.PathTempSessions) then
  begin
   {$IFDEF HAS_UNIT_SYSTEM_IOUTILS}
      TDirectory.Delete(Options.RootDirectory + Options.PathTempSessions, true);
   {$ELSE}
      DeleteDirectory(Options.RootDirectory + Options.PathTempSessions,True);
      RemoveDirUTF8(Options.RootDirectory + Options.PathTempSessions);
   {$ENDIF}
  end;
  if not DirectoryExists(Options.RootDirectory + Options.PathTempSessions) then
  MkDir(Options.RootDirectory + Options.PathTempSessions);

  //Expand Files Support
 {$IFDEF D2BRIDGE}
  {$IFDEF D2DOCKER}
   if D2BridgeManager.API.D2Docker.PrimaryContainerAPP then
    SavePrismSupportFiles(true)
   else
    SavePrismSupportFiles(false);
  {$ELSE}
   SavePrismSupportFiles(true);
  {$ENDIF}
 {$ENDIF}

  try
   if Assigned(FOnBeforeServerStart) then
    FOnBeforeServerStart;
  except
  end;

  FPrismThreadServerTCP.StartServer;

  try
   if Assigned(FOnAfterServerStart) then
    FOnAfterServerStart;
  except
  end;

  //FPrismTimer.Resume;
 end;
end;

procedure TPrismBaseClass.StopServer;
begin
 try
  if Assigned(FOnBeforeServerStop) then
   FOnBeforeServerStop;
 except
 end;

 try
  FPrismThreadServerTCP.StopServer;
 except
 end;

 try
  if Assigned(FOnAfterServerStop) then
   FOnAfterServerStop;
 except
 end;


 if Assigned(FPrismLog) then
  FreeAndNil(FPrismLog);

 if Assigned(FPrismTimer) then
  FPrismTimer.Pause;
end;

{$IFDEF D2BRIDGE}
procedure TPrismBaseClass.SupportFileFromRC(AResourceName: string; var AFileContent: string);
var
 ResInfo:     {$IFNDEF FPC}HRSRC{$ELSE}TLResource{$ENDIF};
 ResStream:   {$IFNDEF FPC}TResourceStream{$ELSE}TLazarusResourceStream{$ENDIF};
 vFileStream: TStringStream;
begin
 {$IFNDEF FPC}
   ResInfo := FindResource(HInstance, PWideChar(AResourceName), RT_RCDATA);

   if ResInfo <> 0 then
 {$ELSE}
   ResInfo:= LazarusResources.Find(AResourceName);

   if ResInfo <> nil then
 {$ENDIF}
  begin
   try
    {$IFNDEF FPC}
        ResStream := TResourceStream.Create(HInstance, AResourceName, RT_RCDATA);
    {$ELSE}
        ResStream := TLazarusResourceStream.Create(AResourceName, nil);
    {$ENDIF}

    vFileStream:= TStringStream.Create('', TEncoding.UTF8);
    ResStream.SaveToStream(vFileStream);
    AFileContent:= vFileStream.DataString;

    vFileStream.Free;
    ResStream.Free;
   except
    FPrismServerHTML.Free;
   end;
  end;
end;

procedure TPrismBaseClass.SupportFileFromRC(AResourceName, AFileName, APath: string; ASaveFilesonDisk: boolean);
var
 ResInfo:     {$IFNDEF FPC}HRSRC{$ELSE}TLResource{$ENDIF};
 ResStream:   {$IFNDEF FPC}TResourceStream{$ELSE}TLazarusResourceStream{$ENDIF};
 vFileStream: TStringStream;
begin
 if APath = '' then
 begin
  if SameText(ExtractFileExt(AFileName), '.CSS') then
   APath:= Options.RootDirectory + PrismBaseClass.Options.PathCSS + PathDelim
  else
   if SameText(ExtractFileExt(AFileName), '.JS') then
    APath:= Options.RootDirectory + PrismBaseClass.Options.PathJS + PathDelim
   else
    if SameText(ExtractFileExt(AFileName), '.eot') or
       SameText(ExtractFileExt(AFileName), '.ttf') or
       SameText(ExtractFileExt(AFileName), '.woff') or
       SameText(ExtractFileExt(AFileName), '.woff2') then
     APath:= Options.RootDirectory + PrismBaseClass.Options.PathFont + PathDelim
    else
     raise Exception.Create('Support File Path not defined');
 end;

 {$IFNDEF FPC}
   ResInfo := FindResource(HInstance, PWideChar(AResourceName), RT_RCDATA);

   if ResInfo <> 0 then
 {$ELSE}
   ResInfo:= LazarusResources.Find(AResourceName);

   if ResInfo <> nil then
 {$ENDIF}
  begin
   try
    {$IFNDEF FPC}
        ResStream := TResourceStream.Create(HInstance, AResourceName, RT_RCDATA);
    {$ELSE}
        ResStream := TLazarusResourceStream.Create(AResourceName, nil);
    {$ENDIF}

    ResStream.SaveToFile(IncludeTrailingPathDelimiter(APath) + AFileName);
    ResStream.Free;
   except
    ResStream.Free;
   end;
  end;
end;
{$ENDIF}


end.