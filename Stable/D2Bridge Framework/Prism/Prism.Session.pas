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

unit Prism.Session;

interface

uses
  Classes, Generics.Collections, SysUtils,
  DateUtils, D2Bridge.JSON, Rtti, IdContext,
{$IFDEF HAS_UNIT_SYSTEM_THREADING}
  System.Threading,
{$ENDIF}
{$IFDEF HAS_UNIT_SYSTEM_IOUTILS}
  System.IOUtils,
{$ENDIF}
{$IFDEF FPC}
  LCLType,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Windows, ActiveX,
{$ENDIF}
{$IFDEF FMX}
  FMX.Forms, FMX.Dialogs,
{$ELSE}
  Forms, Dialogs,
{$ENDIF}
{$IFDEF HAS_UNIT_SYSTEM_UITYPES}
  System.UITypes,
{$ENDIF}
  SyncObjs,
  Prism.Interfaces, Prism.Session.Thread.Proc, Prism.Types, Prism.BaseClass.Timer,
  D2Bridge.Interfaces, D2Bridge.Types, D2Bridge.Lang.Interfaces, D2Bridge.Lang.Term,
  D2Bridge.Lang.APP.Term;


type
 TPrismSession = class(TComponent, IPrismSession)
  strict private
   procedure Exec_Proc(varWaitName, varTimeOut, varTaskCompleted: TValue);
   procedure Exec_ProcessMessages;
   function CallBackExecJSResponse(EventParams: TStrings): string;
   procedure Exec_DestroySession;
   procedure Exec_DoDestroy;
  private
   FToken: String;
   FUUID: String;
   FCallBackID: String;
   FPushID: string;
   FAuthID: string;
   FCreateDate: TDateTime;
   FD2BridgeInstance: TObject;
   FPrismBaseClass: IPrismBaseClass;
   FD2BridgeBaseClass: TObject;
   FD2BridgeForms: TList<TObject>;
   FIPrismCallBacks: IPrismCallBacks;
   FData: TObject;
   FLockName: TList<string>;
   FFileDownloads: TDictionary<string, string>;
   FClosing: Boolean;
   FInfoConnection: IPrismSessionInfo;
   FURI: IPrismURI;
   FClipboard: IPrismClipboard;
   FLanguageNav: TD2BridgeLang;
   FLanguage: TD2BridgeLang;
   FScriptJSSafeMode: TStrings;
   FFormatSettings: TFormatSettings;
   FActive: boolean;
   FRecovering: boolean;
   FCookies: IPrismCookies;
   FConnectionStatus: TSessionConnectionStatus;
   FDisconnect: Boolean;
   FDisconnectStartTime: TDateTime;
   FWebSocketContext: TIdContext;
   FSessionTimer: TPrismTimer;
   function GetD2BridgeBaseClass: TObject;
   procedure SetD2BridgeBaseClass(AD2BridgeBaseClass: TObject);
   Function GetD2BridgeInstance: TObject;
   function GetToken: string;
   function GetUUID: string;
   function GetCallBackID: string;
   function GetPushID: string;
   function GetAuthID: string;
   Function GetActiveForm: IPrismForm;
   function GetD2BridgeForms: TList<TObject>;
   function GetCallBacks: IPrismCallBacks;
   procedure SetData(AValue: TObject);
   function GetData: TObject;
   function GetD2BridgeManager: TObject;
   function GetFileDownloads: TDictionary<string, string>;
   function GetLanguageNav: TD2BridgeLang;
   procedure SetLanguageNav(const Value: TD2BridgeLang);
   function GetFormatSettings: TFormatSettings;
   function GetWebSocketContext: TIdContext;
   procedure SetFormatSettings(const Value: TFormatSettings);
   procedure SetWebSocketContext(const Value: TIdContext);
   procedure OnTimerObserver;
   procedure RegisterEvent(AEventName: string; AEvent: TOnEventProc);
   procedure UnRegisterEvent(AEventName: string; AEvent: TOnEventProc);
   procedure CallRegistredEvent(AEventName: string; APrismForm: IPrismForm; AEventParams: TStrings);
  protected
   FD2BridgeFormPrimary: TObject;
   FReloading: boolean;
   FIdle: Boolean;
   FCheckingConn: Boolean;
   FLastHeartBeat: TDateTime;
   FLastActivity: TDateTime;
   FStabilizedConn: boolean;
   FThreads: TList<TPrismSessionThreadProc>;
   FLockThreads: TMultiReadExclusiveWriteSynchronizer;
   FDestroying: Boolean;
   FRegistredEvent: TDictionary<string,TList<TOnEventProc>>;
   Procedure SetActive(Value: Boolean);
   procedure SetRecovering(Value: boolean);
   procedure RenewUUID;
   procedure DoConnectionStatus(AConnectionStatus: TSessionConnectionStatus);
   procedure BeginDisconnect;
   procedure EndDisconnect;
   procedure DoDestroy;
  published

  public
   constructor Create(AOwner: IPrismBaseClass); reintroduce; virtual;
   destructor Destroy; override;

   function Lang: TD2BridgeTerm;
   function LangNav: TD2BridgeTerm;
   function LangAPPIsPresent: Boolean;
   function LangAPP: TD2BridgeAPPTerm;
   function Language: TD2BridgeLang;
   function LangName: string;
   function LangCode: string;

   function URI: IPrismURI;
   function Clipboard: IPrismClipboard;
   function Cookies: IPrismCookies;

   function CreateDate: TDateTime;
   function PathSession: String;
   Function ActiveFormByFormUUID(AFormUUID: String): IPrismForm;
   function PrimaryForm: TForm;

   procedure DoFormPageLoad(APrismForm: IPrismForm; EventParams: TStrings);
   procedure DoFormPageResize(APrismForm: IPrismForm; EventParams: TStrings);
   procedure DoFormOrientationChange(APrismForm: IPrismForm; EventParams: TStrings);
   procedure DoFormCameraInitialize(APrismForm: IPrismForm; EventParams: TStrings);

   procedure ExecJS(ScriptJS: String; SafeMode: Boolean = false);
   function ExecJSResponse(ScriptJS: String; ATimeout: integer = 60; SafeMode: Boolean = false): string;
   procedure Redirect(AURL: string; ANewPage:Boolean = false);
   procedure SendFile(FullFilePath: String; OpenOnFinishDownload: Boolean = false; WebFileName: String = '');
   function SendFileLink(FullFilePath: String): string;

   procedure UnLock(AWaitName: String);
   procedure UnLockAll;
   procedure Lock(const AWaitName: String; const ATimeOut: Integer = 0);
   function LockExists(AWaitName: String): boolean;

   procedure ShowMessageError(const Msg: string; ASyncMode : Boolean = true; useToast: boolean = false; TimerInterval: integer = 4000; ToastPosition: TToastPosition = ToastTopRight); overload;
   procedure ShowMessage(const Msg: string; useToast: boolean; TimerInterval: integer = 4000; DlgType: TMsgDlgType = TMsgDlgType.mtInformation; ToastPosition: TToastPosition = ToastTopRight); overload;
   procedure ShowMessage(const Msg: string; useToast: boolean; ASyncMode : Boolean; TimerInterval: integer = 4000; DlgType: TMsgDlgType = TMsgDlgType.mtInformation; ToastPosition: TToastPosition = ToastTopRight); overload;
   procedure ShowMessage(const Msg: string); overload;
   function MessageDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer; overload;
   function MessageDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint; ACallBackName: string): Integer; overload;
{$IFNDEF FMX}
   function MessageBox(const Text, Caption: PChar; Flags: Longint): Integer;
{$ENDIF}

   procedure Close(ACreateNewSession: Boolean = false);
   function Closing: boolean;
   function Recovering: boolean;
   function Reloading: boolean;

   function Active: boolean;
   function Disconnected: Boolean;
   function DisconnectedInSeconds: integer;
   function ConnectionStatus: TSessionConnectionStatus;
   function LastHeartBeat: TDateTime;
   function LastHeartBeatInSeconds: integer;
   function LastActivity: TDateTime;
   function LastActivityInSeconds: integer;
   function Idle: Boolean;
   function IdleInSeconds: integer;
   function StabilizedConn: boolean;

   function CheckingConn: Boolean;

   function InfoConnection: IPrismSessionInfo;

   procedure ExecThread(AProc: TProc; ASynchronize: Boolean = False); overload;
   procedure ExecThread(AWait: Boolean; AProc: TProc; ASynchronize: Boolean = False); overload;
   procedure ExecThread(AWait: Boolean; AProc: TProc1; var1: TValue; ASynchronize: Boolean = False); overload;
   procedure ExecThread(AWait: Boolean; AProc: TProc2; var1, var2: TValue; ASynchronize: Boolean = False); overload;
   procedure ExecThread(AWait: Boolean; AProc: TProc3; var1, var2, var3: TValue; ASynchronize: Boolean = False); overload;
   procedure ExecThread(AWait: Boolean; AProc: TProc4; var1, var2, var3, var4: TValue; ASynchronize: Boolean = False); overload;

   procedure ExecThreadSynchronize(AProc: TProc); overload;
   procedure ExecThreadSynchronize(AWait: Boolean; AProc: TProc); overload;
   procedure ExecThreadSynchronize(AWait: Boolean; AProc: TProc1; var1: TValue); overload;
   procedure ExecThreadSynchronize(AWait: Boolean; AProc: TProc2; var1, var2: TValue); overload;
   procedure ExecThreadSynchronize(AWait: Boolean; AProc: TProc3; var1, var2, var3: TValue); overload;
   procedure ExecThreadSynchronize(AWait: Boolean; AProc: TProc4; var1, var2, var3, var4: TValue); overload;

   procedure RegisterEventOnPageLoad(AOnPageLoad: TOnEventProc);
   procedure UnRegisterEventOnPageLoad(AOnPageLoad: TOnEventProc);
   procedure RegisterEventOnPageResize(AOnPageResize: TOnEventProc);
   procedure UnRegisterEventOnPageResize(AOnPageResize: TOnEventProc);
   procedure RegisterEventOnOrientationChange(AOnOrientationChange: TOnEventProc);
   procedure UnRegisterEventOnOrientationChange(AOnOrientationChange: TOnEventProc);
   procedure RegisterEventOnCameraInitialize(AOnCameraInitialize: TOnEventProc);
   procedure UnRegisterEventOnCameraInitialize(AOnCameraInitialize: TOnEventProc);

   procedure ThreadAddCurrent;
   procedure ThreadAddFromID(const AThreadID: integer);
   procedure ThreadRemoveCurrent;
   procedure ThreadRemoveFromID(const AThreadID: integer);
   function ThreadIDValid(const AThreadID: integer): boolean; overload;

   procedure DoException(Sender: TObject; E: Exception; EventName: string);

   function Destroying: Boolean;

   function Sessions: IPrismSessions;

   property Token: string read GetToken;
   property UUID: string read GetUUID;
   property CallBackID: string read GetCallBackID;
   property PushID: string read GetPushID;
   property AuthID: string read GetAuthID;
   property ActiveForm: IPrismForm read GetActiveForm;
   property D2BridgeForms: TList<TObject> read GetD2BridgeForms;
   property D2BridgeInstance: TObject read GetD2BridgeInstance;
   property D2BridgeBaseClassActive: TObject read GetD2BridgeBaseClass write SetD2BridgeBaseClass;
   property D2BridgeManager: TObject read GetD2BridgeManager;
   property LanguageNav: TD2BridgeLang read GetLanguageNav write SetLanguageNav;
   property CallBacks: IPrismCallBacks read GetCallBacks;
   property Data: TObject read GetData write SetData;
   property FileDownloads: TDictionary<string, string> read GetFileDownloads;
   property FormatSettings: TFormatSettings read GetFormatSettings write SetFormatSettings;
   property WebSocketContext: TIdContext read GetWebSocketContext write SetWebSocketContext;
 end;

const
 SizeToken = 24;
 SizeUUID = 12;
 SizeCallBackID = 9;
 SizePushID = 16;
 SizeAuthID = 19;

implementation

uses
  Prism.Util, Prism.Forms, Prism.CallBack, Prism.BaseClass, Prism.Session.Info, Prism.URI,
  Prism.Clipboard, Prism.Cookie, Prism.SessionBase, Prism.Session.Helper, Prism.BaseClass.Sessions,
  D2Bridge.Instance, D2Bridge.Manager, D2Bridge.BaseClass, D2Bridge.Forms, D2Bridge.Lang.Core,
  D2Bridge.Lang.Util, D2Bridge.ServerControllerBase, D2Bridge.Lang.APP.Core, D2Bridge.Util;


{ TPrismSession }

function TPrismSession.Active: boolean;
begin
 Result:= FActive;
end;

function TPrismSession.ActiveFormByFormUUID(AFormUUID: String): IPrismForm;
var
 I, J, K, L: Integer;
 D2BridgeClass, vNestedBridgeClass, vNestedBridgeClass2, vNestedBridgeClass3, vNestedBridgeClass4: TD2BridgeClass;
 vBreakAll: boolean;
begin
 System.Initialize(result);

 if Assigned(TD2BridgeClass(D2BridgeBaseClassActive).Form) then
 begin
  vBreakAll:= false;
  D2BridgeClass:= TD2BridgeClass(D2BridgeBaseClassActive);
  if (D2BridgeClass.Form as TPrismForm).FormUUID = AFormUUID then
  Result:= (D2BridgeClass.Form as TPrismForm)
  else
  begin
   for I := 0 to D2BridgeClass.NestedCount-1 do
   begin
    vNestedBridgeClass:= D2BridgeClass.Nested(I);
    if TPrismForm(vNestedBridgeClass.Form).FormUUID = AFormUUID then
    begin
     Result:= TPrismForm(vNestedBridgeClass.Form);
     Break;
    end;

    for J := 0 to Pred(vNestedBridgeClass.NestedCount) do
    begin
     vNestedBridgeClass2:= vNestedBridgeClass.Nested(J);
     if TPrismForm(vNestedBridgeClass2.Form).FormUUID = AFormUUID then
     begin
      Result:= TPrismForm(vNestedBridgeClass2.Form);
      vBreakAll:= true;
      break;
     end;

     for k := 0 to Pred(vNestedBridgeClass2.NestedCount) do
     begin
      vNestedBridgeClass3:= vNestedBridgeClass2.Nested(k);
      if TPrismForm(vNestedBridgeClass3.Form).FormUUID = AFormUUID then
      begin
       Result:= TPrismForm(vNestedBridgeClass3.Form);
       vBreakAll:= true;
       break;
      end;

      for L := 0 to Pred(vNestedBridgeClass3.NestedCount) do
      begin
       vNestedBridgeClass4:= vNestedBridgeClass3.Nested(k);
       if TPrismForm(vNestedBridgeClass4.Form).FormUUID = AFormUUID then
       begin
        Result:= TPrismForm(vNestedBridgeClass4.Form);
        vBreakAll:= true;
        break;
       end;
      end;

      if vBreakAll then
       break;
     end;

     if vBreakAll then
      break;
    end;

    if vBreakAll then
     break;

   end;
  end;
 end;

end;

procedure TPrismSession.BeginDisconnect;
begin
 FDisconnectStartTime:= now;
 FDisconnect:= true;

 if Assigned(PrismBaseClass.OnDisconnectSession) then
  PrismBaseClass.OnDisconnectSession(self);
end;

function TPrismSession.Closing: boolean;
begin
 result:= FClosing;
end;

function TPrismSession.ConnectionStatus: TSessionConnectionStatus;
begin
 Result:= FConnectionStatus;
end;

function TPrismSession.Cookies: IPrismCookies;
begin
 Result:= FCookies;
end;

constructor TPrismSession.Create(AOwner: IPrismBaseClass);
begin
 {$IFDEF D2BRIDGE}
 //PrismBaseClass.CriticalSession.Enter;
 FScriptJSSafeMode:= TStringList.Create;
 FCookies:= TPrismCookies.Create(self);
 FRegistredEvent:= TDictionary<string,TList<TOnEventProc>>.Create;
 {$ENDIF}

 try
  try
   //Inherited Create(TComponent(AOwner));
   Inherited Create(nil);

   FD2BridgeFormPrimary:= nil;

   FActive:= true;
   FRecovering:= false;
   FClosing:= false;
   FCheckingConn:= false;
   FPrismBaseClass:= AOwner;
   FStabilizedConn:= false;

   FReloading:= false;
   FConnectionStatus:= scsNone;
   FDisconnect:= false;

   FLastActivity:= now;
   FLastHeartBeat:= now;

   FDestroying:= false;

   FToken:= GenerateRandomString(SizeToken);
   FUUID:= GenerateRandomString(SizeUUID);
   FCallBackID:= GenerateRandomNumber(SizeCallBackID);
   FPushID:= GenerateRandomString(SizePushID);
   FAuthID:= GenerateRandomString(SizeAuthID);
   FCreateDate:= now;

{$IFDEF D2BRIDGE}
   FD2BridgeForms:= TList<TObject>.Create;
   FIPrismCallBacks:= TPrismCallBacks.Create(self);
{$ENDIF}

{$IFDEF D2BRIDGE}
    FD2BridgeInstance:= TD2BridgeInstance.Create(self);
{$ELSE}
    FD2BridgeInstance:= D2Bridge.Instance.D2BridgeInstance;
{$ENDIF}

{$IFDEF D2BRIDGE}
   if not DirectoryExists(PathSession) then
{$IFDEF HAS_UNIT_SYSTEM_IOUTILS}
     TDirectory.CreateDirectory(TPath.GetDirectoryName(PathSession));
{$ELSE}
     CreateDir(ExtractFileDir(PathSession));
{$ENDIF}
{$ENDIF}

{$IFDEF D2BRIDGE}
   FLockThreads:= TMultiReadExclusiveWriteSynchronizer.Create;
   FLockName:= TList<string>.Create;
   FFileDownloads:= TDictionary<string, string>.Create;
   FThreads:= TList<TPrismSessionThreadProc>.Create;
   FInfoConnection:= TPrismSessionInfo.Create(self);
   FURI:= TPrismURI.Create;
   FClipboard:= TPrismClipboard.Create(Self);
   FSessionTimer:= TPrismTimer.Create(PrismBaseClass.Options.HeartBeatTime, OnTimerObserver);
   FSessionTimer.Resume;
{$ENDIF}
  except
  end;
 finally

 end;
end;

function TPrismSession.CreateDate: TDateTime;
begin
 Result:= FCreateDate;
end;

function TPrismSession.CallBackExecJSResponse(EventParams: TStrings): string;
var
 vJSON: TJSONObject;
begin
 result:= '';

 if Assigned(EventParams) then
 begin
  try
   vJSON:= TJSONObject.ParseJSONValue(EventParams[0]) as TJSONObject;

   if Assigned(vJSON) then
   begin
    result:= vJSON.GetValue('result', '');

    try
     UnLock(vJSON.GetValue('callbackname', ''));
    except
    end;

    vJSON.Free;
   end;
  except
  end;
 end;
end;


procedure TPrismSession.CallRegistredEvent(AEventName: string; APrismForm: IPrismForm; AEventParams: TStrings);
var
 I: Integer;
 vListEvent: TList<TOnEventProc>;
begin
 try
  if (FRegistredEvent.Count > 0) and
     FRegistredEvent.ContainsKey(AEventName) then
  begin
   vListEvent:= FRegistredEvent[AEventName];

   if Assigned(vListEvent) then
   begin
    if Assigned(AEventParams) then
    begin
     if Assigned(APrismForm) then
      AEventParams.Add('Form='+APrismForm.Name);
    end;

    for I := 0 to Pred(vListEvent.Count) do
    begin
     try
      vListEvent[I](AEventParams);
     except
     end;
    end;
   end;
  end;
 except
 end;
end;

function TPrismSession.CheckingConn: Boolean;
begin
 result:= FCheckingConn;
end;

function TPrismSession.Clipboard: IPrismClipboard;
begin
 Result:= FClipboard;
end;

procedure TPrismSession.Close(ACreateNewSession: Boolean = false);
begin
 if not IsD2BridgeContext then
 begin
  Application.Terminate;
  exit;
 end;

 if FDestroying then
  Exit;

 FDestroying:= true;

 if not ACreateNewSession then
 begin
  try
   ExecJS(
    'let iframe = document.getElementById("iframeoverlayerror");' + sLineBreak +
    'if (iframe) {' + sLineBreak +
    '    iframe.parentNode.removeChild(iframe);' + sLineBreak +
    '}' + sLineBreak +
    'prismws = null;' + sLineBreak +
    'window.location.href = ''about:blank'';'
   );
  except
  end;
 end else
 begin
  try
   ExecJS(
     'let iframe = document.getElementById("iframeoverlayerror");' + sLineBreak +
     'if (iframe) {' + sLineBreak +
     '    iframe.parentNode.removeChild(iframe);' + sLineBreak +
     '}' + sLineBreak +
     'prismws = null;' + sLineBreak +
     'setTimeout(function() {' + sLineBreak +
     '    window.location.reload();' + sLineBreak +
     '}, 1500);'
   );
  except
  end;
 end;

 try
  PrismBaseClass.PrismServer.DisconnectWebSocketMessage(Self, true);
 except
 end;

 DoDestroy;
end;

destructor TPrismSession.Destroy;
var
 I: integer;
 vExistD2BridgeForm: Boolean;
 vD2BridgeForm: TComponent;
 vComponentCount: Integer;
 vQtyThread: Integer;
 vThread: TPrismSessionThreadProc;
 vComponent: TComponent;
 vCookies: TPrismCookies;
 vPrismCallBacks: TPrismCallBacks;
 vURI: TPrismURI;
 vClipboard: TPrismClipboard;
 vInfoConnection: TPrismSessionInfo;
begin
 FDestroying:= true;

 try
  {$IFDEF D2BRIDGE}
  try
   if FStabilizedConn then
    if Assigned(PrismBaseClass.ServerController) then
     PrismBaseClass.ServerController.DoSessionChange(scsDestroySession, self);
  except
  end;
  {$ENDIF}

  {$IFDEF D2BRIDGE}
  try
   PrismBaseClass.DoCloseSession(self);
  except
  end;
  {$ENDIF}

  try
   if Assigned(FData) then
   begin
    RemoveComponent(FData as TPrismSessionBase);
    FreeAndNil(FData);
   end;
  except
  end;

  {$IFDEF D2BRIDGE}
  try
   UnLockAll;
  except
  end;
  {$ENDIF}


  {$IFDEF D2BRIDGE}
   try
    vComponentCount:= ComponentCount;
    while (ComponentCount > 0) and (vComponentCount > 0) do
    begin
     try
      vComponent:= Components[ComponentCount-1];
      RemoveComponent(vComponent);

      try
       vComponent.Free;
      except
      end;
     except
     end;

     Dec(vComponentCount);
    end;
   except
   end;
  {$ENDIF}

//  try
//   DestroyComponents;
//  except
//  end;

  FClosing:= true;

  {$IFDEF D2BRIDGE}
  try
   PrismBaseClass.Sessions.Delete(UUID);
  except
  end;
  {$ENDIF}


//{$IFDEF D2BRIDGE}
//  {$IFDEF MSWINDOWS}
//  try
//   if FPrismBaseClass.Options.CoInitialize then
//   begin
//    CoUninitialize;
//   end;
//  except
//  end;
//  {$ENDIF}
//{$ENDIF}

{$IFDEF D2BRIDGE}
 try
  PrismBaseClass.Sessions.RemoveThreadIDsFromSession(self);
 except
 end;
{$ENDIF}


 {$IFDEF D2BRIDGE}
 try
  FD2BridgeForms.Free;
 except
 end;
 {$ENDIF}


{$IFDEF D2BRIDGE}
 try
  vCookies:= FCookies as TPrismCookies;
  FCookies:= nil;
  vCookies.Free;
 except
 end;
{$ENDIF}



{$IFDEF D2BRIDGE}
 try
  vPrismCallBacks:= FIPrismCallBacks as TPrismCallBacks;
  FIPrismCallBacks:= nil;
  vPrismCallBacks.Free;
 except
 end;
{$ENDIF}



{$IFDEF D2BRIDGE}
 try
  vURI:= FURI as TPrismURI;
  FURI:= nil;
  vURI.Free;
 except
 end;
{$ENDIF}


{$IFDEF D2BRIDGE}
 try
  vClipboard:= FClipboard as TPrismClipboard;
  FClipboard:= nil;
  vClipboard.Free;
 except
 end;
{$ENDIF}


{$IFDEF D2BRIDGE}
 try
  FLockThreads.BeginWrite;

  vQtyThread:= FThreads.Count;

  if vQtyThread > 0 then
  repeat
   try
    vThread:= FThreads[vQtyThread-1];
    if FThreads.Contains(vThread) then
     FThreads.Delete(vQtyThread-1); //.Remove(vThread);
    if Assigned(vThread) then
    begin
     vThread.Terminate;
    end;
//    if not vThread.CheckTerminated then
//    begin
//     Windows.TerminateThread(vThread.Handle, 0);
//    end;
   except
   end;

   Dec(vQtyThread);
  until (FThreads.Count <= 0) or (vQtyThread <= 0);

  FLockThreads.EndWrite;

  FLockThreads.Free;
  FThreads.Free;
 except
 end;
{$ENDIF}


  {$IFDEF D2BRIDGE}
  try
   if Assigned(FLockName) then
    FreeAndNil(FLockName);
  except
  end;
  {$ENDIF}

  {$IFDEF D2BRIDGE}
  try
  if Assigned(FScriptJSSafeMode) then
   FScriptJSSafeMode.Free;
  except
  end;

  try
  if Assigned(FD2BridgeInstance) then
   FreeAndNil(FD2BridgeInstance);
  except
  end;
  {$ENDIF}

  {$IFDEF D2BRIDGE}
  try
   if FRegistredEvent.Count > 0 then
   begin
    for I := 0 to Pred(FRegistredEvent.Count) do
     FRegistredEvent.Values.ToArray[I].Free;
   end;
   FRegistredEvent.Free;
  except
  end;
  {$ENDIF}

  try
   if Assigned(FFileDownloads) then
    FreeAndNIl(FFileDownloads);
  except
  end;

  try
   if Assigned(FInfoConnection) then
   begin
    vInfoConnection:= FInfoConnection as TPrismSessionInfo;
    FInfoConnection:= nil;
    vInfoConnection.Free;
   end;
  except
  end;

 finally
  try
   inherited;
  except
  end;
 end;
end;

function TPrismSession.Destroying: Boolean;
begin
 Result:= FDestroying;
end;

procedure TPrismSession.DoConnectionStatus(AConnectionStatus: TSessionConnectionStatus);
begin
 FConnectionStatus:= AConnectionStatus;

 if (FConnectionStatus = scsLostConnectioSession) and (not FReloading) then
 begin
  PrismBaseClass.DoDisconnectSession(self);
 end else
 if (FConnectionStatus = scsReconnectedSession) and (FReloading) then
 begin
  PrismBaseClass.DoReconnectSession(self);
 end;
end;

procedure TPrismSession.DoDestroy;
var
 vProc: TPrismSessionThreadProc;
begin
 FDestroying:= true;

 vProc:= TPrismSessionThreadProc.Create(nil, Exec_DoDestroy);
 vProc.Exec;
end;

procedure TPrismSession.DoException(Sender: TObject; E: Exception; EventName: string);
var
 vPrismControl: IPrismControl;
 vVCLControl: TObject;
begin
 try
  System.Initialize(vPrismControl);

  if Assigned(Sender) and (Supports(Sender, IPrismControl)) then
  begin
   if Supports(Sender, IPrismControl, vPrismControl) and (Assigned(vPrismControl.VCLComponent)) then
    vVCLControl:= vPrismControl.VCLComponent
   else
    vVCLControl:= Sender;
  end else
   vVCLControl:= Sender;
 except
 end;

 PrismBaseClass.DoException(vVCLControl, E, self, EventName);
end;

procedure TPrismSession.DoFormCameraInitialize(APrismForm: IPrismForm;
  EventParams: TStrings);
begin
 CallRegistredEvent('OnCameraInitialize', APrismForm, EventParams);
end;

procedure TPrismSession.DoFormOrientationChange(APrismForm: IPrismForm;
  EventParams: TStrings);
begin
 CallRegistredEvent('OnOrientationChange', APrismForm, EventParams);
end;

procedure TPrismSession.DoFormPageLoad(APrismForm: IPrismForm; EventParams: TStrings);
begin
 if FScriptJSSafeMode.Text <> '' then
 if ActiveForm = APrismForm then
 begin
  ExecJS(FScriptJSSafeMode.Text);

  FScriptJSSafeMode.Clear;
 end;

 CallRegistredEvent('OnPageLoad', APrismForm, EventParams);
end;

procedure TPrismSession.DoFormPageResize(APrismForm: IPrismForm;
  EventParams: TStrings);
begin
 CallRegistredEvent('OnPageResize', APrismForm, EventParams);
end;

procedure TPrismSession.EndDisconnect;
begin
 FDisconnect:= false;
 FDisconnectStartTime:= 0;

 if Assigned(PrismBaseClass.OnReconnectSession) then
  PrismBaseClass.OnReconnectSession(self);
end;

procedure TPrismSession.ExecJS(ScriptJS: String; SafeMode: Boolean = false);
var
 Json: TJSONObject;
 JSonArray: TJSONArray;
begin
 if (not Closing) and Assigned(FWebSocketContext) then
 begin
  if (SafeMode and (not Assigned(FD2BridgeFormPrimary))) or
     (SafeMode and (ActiveForm.FormPageState <> PageStateLoaded)) then
  begin
   FScriptJSSafeMode.Add(ScriptJS);
  end else
  begin
   Json:= TJSONObject.Create;
   JSonArray:= TJSONArray.Create;

   JSonArray.Add(ScriptJS);

   Json.AddPair('ExecJS', JSonArray);

   if Assigned(FPrismBaseClass) then
    (FPrismBaseClass as TPrismBaseClass).PrismServer.SendWebSocketMessage(Json.ToJSON, Self);

   Json.Free;
  end;
 end;
end;

function TPrismSession.ExecJSResponse(ScriptJS: String; ATimeout: integer;
  SafeMode: Boolean): string;
var
 vCallBackName: string;
 vActiveForm: IPrismForm;
 vPrismCallBack: IPrismCallBack;
 vCallBackJS: string;
begin
 result:= '';

 try
  if not Closing then
  begin
   if (SafeMode and (not Assigned(FD2BridgeFormPrimary))) or
      (SafeMode and (ActiveForm.FormPageState <> PageStateLoaded)) then
   begin
    FScriptJSSafeMode.Add(ScriptJS);
   end else
   begin
    vActiveForm:= ActiveForm;
    vCallBackName:= 'ExecJSRespose_'+vActiveForm.FormUUID+GenerateRandomNumber(9);

    vPrismCallBack:= vActiveForm.CallBacks.Register(vCallBackName,
     CallBackExecJSResponse
    );

    vCallBackJS:= CallBacks.CallBackJS(vCallBackName, false, vActiveForm.FormUUID, 'JSON.stringify(response)');

    ExecJS(
           '{                                                                   '+
           'function ExecJSResponse(script) {                                   '+
           '  try {                                                             '+
           '    const _response = eval(script);                                 '+
           '    return Promise.resolve(_response);                              '+
           '  } catch (error) {                                                 '+
           '    return Promise.reject(''Error exec script: '' + error.message); '+
           '  }                                                                 '+
           '}                                                                   '+
           '                                                                    '+
           'ExecJSResponse(' + QuotedStr(ScriptJS) + ').then(result => {        '+
           '    if (typeof result !== ''string'') {                              '+
           '         result = JSON.stringify(result);                               '+
           '    }                                                                '+
           '    response = {"callbackname" : "' + vCallBackName + '", "result" : result};         '+
           '    ' + vCallBackJS + ' '+
           '});                                                                 '+
           '}                                                                   '
    );

    Lock(vCallBackName, ATimeout);

    result:= vPrismCallBack.Response;

    vPrismCallBack:= nil; { #todo -c'Fix Lazarus RefCount' :  }
    vActiveForm.CallBacks.Unregister(vCallBackName);
   end;
  end;
 except
 end;
end;

procedure TPrismSession.ExecThread(AWait: Boolean; AProc: TProc; ASynchronize: Boolean = False);
var
 vPrismSessionThreadProc: TPrismSessionThreadProc;
begin
 if Closing or
    (csDestroying in self.ComponentState) then
  exit;

 try
  vPrismSessionThreadProc:= TPrismSessionThreadProc.Create(self, AProc, AWait, ASynchronize);

  AddThread(vPrismSessionThreadProc);

  vPrismSessionThreadProc.Exec;
 except
 end;

end;

procedure TPrismSession.ExecThread(AWait: Boolean; AProc: TProc1; var1: TValue; ASynchronize: Boolean = False);
var
 vPrismSessionThreadProc: TPrismSessionThreadProc;
begin
 if Closing or
    (csDestroying in self.ComponentState) then
  exit;

 try
  vPrismSessionThreadProc:= TPrismSessionThreadProc.Create(self, AProc, var1, AWait, ASynchronize);

  AddThread(vPrismSessionThreadProc);

  vPrismSessionThreadProc.Exec;
 except
 end;
end;

procedure TPrismSession.ExecThread(AWait: Boolean; AProc: TProc2; var1: TValue; var2: TValue; ASynchronize: Boolean = False);
var
 vPrismSessionThreadProc: TPrismSessionThreadProc;
begin
 if Closing or
    (csDestroying in self.ComponentState) then
  exit;

 try
  vPrismSessionThreadProc:= TPrismSessionThreadProc.Create(self, AProc, var1, var2, AWait, ASynchronize);

  AddThread(vPrismSessionThreadProc);

  vPrismSessionThreadProc.Exec;
 except
 end;
end;

procedure TPrismSession.ExecThread(AWait: Boolean; AProc: TProc3; var1: TValue; var2: TValue; var3: TValue; ASynchronize: Boolean = False);
var
 vPrismSessionThreadProc: TPrismSessionThreadProc;
begin
 if Closing or
    (csDestroying in self.ComponentState) then
  exit;

 try
  vPrismSessionThreadProc:= TPrismSessionThreadProc.Create(self, AProc, var1, var2, var3, AWait, ASynchronize);

  AddThread(vPrismSessionThreadProc);

  vPrismSessionThreadProc.Exec;
 except
 end;
end;

procedure TPrismSession.ExecThread(AWait: Boolean; AProc: TProc4; var1: TValue; var2: TValue; var3: TValue; var4: TValue; ASynchronize: Boolean = False);
var
 vPrismSessionThreadProc: TPrismSessionThreadProc;
begin
 if Closing or
    (csDestroying in self.ComponentState) then
  exit;

 try
  vPrismSessionThreadProc:= TPrismSessionThreadProc.Create(self, AProc, var1, var2, var3, var4, AWait, ASynchronize);

  AddThread(vPrismSessionThreadProc);

  vPrismSessionThreadProc.Exec;
 except
 end;
end;

procedure TPrismSession.ExecThreadSynchronize(AWait: Boolean;  AProc: TProc);
begin
 ExecThread(AWait, AProc, True);
end;

procedure TPrismSession.ExecThreadSynchronize(AWait: Boolean; AProc: TProc1; var1: TValue);
begin
 ExecThread(AWait, AProc, var1, True);
end;

procedure TPrismSession.ExecThreadSynchronize(AWait: Boolean;
  AProc: TProc2; var1, var2: TValue);
begin
 ExecThread(AWait, AProc, Var1, Var2, True);
end;

procedure TPrismSession.ExecThreadSynchronize(AWait: Boolean;
  AProc: TProc3; var1, var2, var3: TValue);
begin
 ExecThread(AWait, AProc, Var1, Var2, Var3, True);
end;

procedure TPrismSession.ExecThreadSynchronize(AWait: Boolean;
  AProc: TProc4; var1, var2, var3, var4: TValue);
begin
 ExecThread(AWait, AProc, var1, var2, var3, var4, True);
end;

procedure TPrismSession.ExecThreadSynchronize(AProc: TProc);
begin
 ExecThread(AProc, True);
end;

procedure TPrismSession.Exec_DestroySession;
begin
 Destroy;
end;

procedure TPrismSession.Exec_DoDestroy;
var
 vProc: TPrismSessionThreadProc;
begin
 {$IFDEF D2BRIDGE}
 try
  if Assigned(FSessionTimer) and (not FSessionTimer.Terminated) then
   FSessionTimer.Terminate;
 except
 end;
 {$ENDIF}


 {$IFDEF D2BRIDGE}
 try
  if Assigned(FWebSocketContext) then
  begin
   ExecJS(
    'let iframe = document.getElementById("iframeoverlayerror");' + sLineBreak +
    'if (iframe) {' + sLineBreak +
    '    iframe.parentNode.removeChild(iframe);' + sLineBreak +
    '}' + sLineBreak +
    'prismws = null;' + sLineBreak +
    'window.location.href = ''about:blank'';'
   );
  end;
 except
 end;
 {$ENDIF}


 try
  PrismBaseClass.PrismServer.DisconnectWebSocketMessage(Self, true);
 except
 end;

 Sleep(2000);

 vProc:= TPrismSessionThreadProc.Create(self, Exec_DestroySession, true, true);
 vProc.UnregisterInSession:= false;
 vProc.Exec;
end;

procedure TPrismSession.Exec_Proc(varWaitName, varTimeOut, varTaskCompleted: TValue);
const
 vSleepTime = 100;
var
 vTimeOut: Integer;
 vWaitName: string;
 vTaskCompleted: TEvent;
 vExistTimeout: boolean;
begin
 try
  vWaitName:= varWaitName.AsString;
  vTimeOut:= varTimeOut.AsInteger * 1000;
  vExistTimeout:= vTimeOut > 0;
  vTaskCompleted:= (varTaskCompleted.AsObject as TEvent);

  repeat
   Sleep(vSleepTime);

   if vTimeOut <> 0 then
    vTimeOut:= vTimeOut - vSleepTime;
  until (Closing) or
        (not (FLockName.Contains(vWaitName))) or
        (vTimeOut < 0) or
        (vExistTimeout and (vTimeOut <= 0));

  vTaskCompleted.SetEvent;
 //   TValue.From<string>(AWaitName),
 //   TValue.From<integer>(ATimeOut),
 //   TValue.From<TEvent>(vTaskCompleted)
 except
 end;
end;

procedure TPrismSession.Exec_ProcessMessages;
begin
 try
  if Assigned(Application) then
   Application.ProcessMessages;
 except
 end;
end;

procedure TPrismSession.ExecThread(AProc: TProc; ASynchronize: Boolean = false);
begin
 ExecThread(False, AProc, ASynchronize);
end;

function TPrismSession.GetActiveForm: IPrismForm;
begin
 System.Initialize(Result);

 if Assigned(TD2BridgeClass(D2BridgeBaseClassActive).Form) then
  Result:= (TD2BridgeClass(D2BridgeBaseClassActive).Form as TPrismForm);
end;

function TPrismSession.GetAuthID: string;
begin
 result:= FAuthID;
end;

function TPrismSession.GetLanguageNav: TD2BridgeLang;
begin
 Result:= FLanguageNav;
end;

function TPrismSession.GetPushID: string;
begin
 result:= FPushID;
end;

function TPrismSession.GetCallBackID: string;
begin
 Result:= FCallBackID;
end;

function TPrismSession.GetCallBacks: IPrismCallBacks;
begin
 Result:= FIPrismCallBacks;
end;

function TPrismSession.GetD2BridgeBaseClass: TObject;
begin
 Result:= FD2BridgeBaseClass;
end;

function TPrismSession.GetD2BridgeInstance: TObject;
begin
 Result:= FD2BridgeInstance;
end;

function TPrismSession.GetD2BridgeManager: TObject;
begin
 Result:= D2Bridge.Manager.D2BridgeManager;
end;

function TPrismSession.GetData: TObject;
begin
 Result:= FData;
end;

function TPrismSession.GetFileDownloads: TDictionary<string, string>;
begin
 Result:= FFileDownloads;
end;

function TPrismSession.GetFormatSettings: TFormatSettings;
begin
 result:= FFormatSettings;
end;

function TPrismSession.Language: TD2BridgeLang;
begin
 Result:= FLanguage;
end;

function TPrismSession.LastActivity: TDateTime;
begin
 result:= FLastActivity;
end;

function TPrismSession.LastActivityInSeconds: integer;
begin
 result:= SecondsBetween(FLastActivity, Now);
end;

function TPrismSession.LastHeartBeat: TDateTime;
begin
 result:= FLastHeartBeat;
end;

function TPrismSession.LastHeartBeatInSeconds: integer;
begin
 result:= SecondsBetween(FLastHeartBeat, Now);
end;

function TPrismSession.GetD2BridgeForms: TList<TObject>;
begin
 Result:= FD2BridgeForms;
end;

function TPrismSession.GetToken: string;
begin
 Result:= FToken;
end;

function TPrismSession.GetUUID: string;
begin
 Result:= FUUID;
end;

function TPrismSession.Disconnected: Boolean;
begin
 Result:= FDisconnect;
end;

function TPrismSession.DisconnectedInSeconds: integer;
begin
 if Disconnected then
  Result:= SecondsBetween(Now, FDisconnectStartTime)
 else
  Result:= 0;
end;

function TPrismSession.GetWebSocketContext: TIdContext;
begin
 Result := FWebSocketContext;
end;

function TPrismSession.Idle: Boolean;
begin
 result:= FIdle;
end;

function TPrismSession.IdleInSeconds: integer;
begin
 if FIdle then
  result:= SecondsBetween(FLastActivity, Now)
 else
  result:= 0;
end;

function TPrismSession.InfoConnection: IPrismSessionInfo;
begin
 Result:= FInfoConnection;
end;

function TPrismSession.Lang: TD2BridgeTerm;
begin
 Result:= (D2BridgeLangCore.LangByTD2BridgeLang(Language) as TD2BridgeTerm);
end;

function TPrismSession.LangAPP: TD2BridgeAPPTerm;
begin
 if LangAPPIsPresent then
   Result:= (D2BridgeLangAPPCore.LangByTD2BridgeLang(Language) as TD2BridgeAPPTerm);
end;

function TPrismSession.LangAPPIsPresent: Boolean;
begin
 Result:= Assigned(D2BridgeLangAPPCore);
end;

function TPrismSession.LangCode: string;
begin
 Result:= LanguageCode(FLanguage);
end;

function TPrismSession.LangName: string;
begin
 Result:= LanguageName(FLanguage);
end;

function TPrismSession.LangNav: TD2BridgeTerm;
begin
 Result:= (D2BridgeLangCore.LangByTD2BridgeLang(LanguageNav) as TD2BridgeTerm);
end;

procedure TPrismSession.Lock(const AWaitName: String; const ATimeOut: Integer);
var
 vProc: TPrismSessionThreadProc;
 vTaskCompleted: TEvent;
begin
 if not FLockName.Contains(AWaitName) then
 begin
  FLockName.Add(AWaitName);

  vTaskCompleted:= TEvent.Create(nil, True, False, '');

  vProc:= TPrismSessionThreadProc.Create(nil,
   Exec_Proc,
   TValue.From<string>(AWaitName),
   TValue.From<integer>(ATimeOut),
   TValue.From<TEvent>(vTaskCompleted)
  );

  vProc.Exec;

  while vTaskCompleted.WaitFor(100) in [wrTimeout] do
  begin
{$IFDEF FPC}
   TThread.Queue(nil, Exec_ProcessMessages);
{$ELSE}
   Exec_ProcessMessages;
{$ENDIF}
  end;

  vTaskCompleted.Free;

  if Closing or Destroying then
   Abort;
 end;
end;

function TPrismSession.LockExists(AWaitName: String): boolean;
begin
 result:= FLockName.Contains(AWaitName);
end;

{$IFNDEF FMX}
function TPrismSession.MessageBox(const Text, Caption: PChar; Flags: Longint): Integer;
var
  vD2Bridge: TD2BridgeClass;
  vD2BridgeForm: TD2BridgeForm;
  vButtons: TMsgDlgButtons;
  vMod10, vIcon: integer;
  vDlgType: TMsgDlgType;
begin
 {$IFDEF D2BRIDGE}
  vMod10:= ExtractHexValue(Flags) mod 10;
  vD2Bridge:= TD2BridgeClass(D2BridgeBaseClassActive);
  vD2BridgeForm:= TD2BridgeForm(TD2BridgeClass(D2BridgeBaseClassActive).FormAOwner);
  vIcon  := Flags and $000000F0;

  case vIcon of
    MB_ICONERROR:       vDlgType := mtError;
    MB_ICONQUESTION:    vDlgType := mtConfirmation;
    MB_ICONWARNING:     vDlgType := mtWarning;
    MB_ICONINFORMATION: vDlgType := mtInformation;
  else
    vDlgType := mtCustom;
  end;

  //Process vMod10
  if vMod10 = MB_OK then
   vButtons:= [TMsgDlgBtn.mbOK]
  else
  if vMod10 = MB_OKCANCEL then
   vButtons:= [TMsgDlgBtn.MBOk, TMsgDlgBtn.MBCancel]
  else
  if vMod10 = MB_ABORTRETRYIGNORE then
   vButtons:= [TMsgDlgBtn.MBAbort, TMsgDlgBtn.MBRetry, TMsgDlgBtn.MBIgnore]
  else
  if vMod10 = MB_YESNOCANCEL then
   vButtons:= [TMsgDlgBtn.MBYes, TMsgDlgBtn.MBNo, TMsgDlgBtn.MBCancel]
  else
  if vMod10 = MB_YESNO then
   vButtons:= [TMsgDlgBtn.MBYes, TMsgDlgBtn.MBNo]
  else
  if vMod10 = MB_RETRYCANCEL then
   vButtons:= [TMsgDlgBtn.MBRetry, TMsgDlgBtn.MBCancel]
  else
   vButtons:= [TMsgDlgBtn.MBOk];

  Result:= vD2BridgeForm.MessageDlg(Text, vDlgType, vButtons, 0);
 {$ELSE}
   Result:= Forms.Application.MessageBox(Text, Caption, Flags);
 {$ENDIF}
end;
{$ENDIF}

function TPrismSession.MessageDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint; ACallBackName: string): Integer;
begin
 {$IFDEF D2BRIDGE}
 if Assigned(ActiveForm) then
  if (ActiveForm as TPrismForm).D2BridgeForm <> nil then
   Result:= (ActiveForm as TPrismForm).D2BridgeForm.MessageDlg(Msg, DlgType, Buttons, HelpCtx, ACallBackName);
 {$ELSE}
  Result:= {$IFDEF FMX}FMX.Dialogs{$ELSE}Dialogs{$ENDIF}.MessageDlg(Msg, DlgType, Buttons, HelpCtx);
 {$ENDIF}
end;

procedure TPrismSession.OnTimerObserver;
var
 vParamTimeOut, vParamIdleTimeOut, vParamHeartBeatTime, vParamWaitIdleResponse: integer;
 vLastHeartBeat, vTimeOut, vIdleTimeOut : integer;
 vInTimeOut, vInIdleTimeOut: Boolean;
 vRenewIdle: boolean;
begin
 try
  if Closing or Destroying then
  begin
   Exit;
  end;

  {$REGION 'Parameters'}
   vParamWaitIdleResponse:= 60;
   vParamHeartBeatTime:= PrismBaseClass.Options.HeartBeatTime div 1000;
   vParamTimeOut := PrismBaseClass.Options.SessionTimeOut;
   if PrismBaseClass.Options.SessionIdleTimeOut  > 0 then
    vParamIdleTimeOut := PrismBaseClass.Options.SessionIdleTimeOut + vParamHeartBeatTime
   else
    vParamIdleTimeOut := 0;
  {$ENDREGION}


  {$REGION 'Set Values'}
   vLastHeartBeat:= LastHeartBeatInSeconds;
  {$ENDREGION}


  //The Session never connected WebSocket
  {$REGION 'not StabilizedConn'}
   if (not StabilizedConn) and (vLastHeartBeat > vParamHeartBeatTime) then
   begin
    try
     //FSessionTimer.Terminate;
     Close(false);
    except
    end;

    Exit;
   end;
  {$ENDREGION}



  {$REGION 'TimeOut'}
  if (vParamTimeOut > 0) then
  begin
   {$REGION 'Calc TimeOut Values'}
   if vLastHeartBeat > vParamHeartBeatTime then
    vTimeOut:= vLastHeartBeat
   else
    vTimeOut:= 0;

   vInTimeOut:= vTimeOut > vParamTimeOut; //Really disconnected mode
  {$ENDREGION}


   {$REGION 'Max TimeOut - Close Session'}
   if (vInTimeOut) then
   begin
    try
     //FSessionTimer.Terminate;
     Close(false);
    except
    end;

    Exit;
   end;
   {$ENDREGION}


   {$REGION 'TimeOut Reconnect process'}
   if (not vInTimeOut) and (Disconnected) and (vTimeOut <= 0) then
   begin
    EndDisconnect;

    Exit;
   end;
   {$ENDREGION}


   {$REGION 'Begin in TimeOut process'}
   if (not vInTimeOut) and (not Disconnected) and (vTimeOut > 0) then
   begin
    BeginDisconnect;

    Exit;
   end;
   {$ENDREGION}
  end;
  {$ENDREGION}


  {$REGION 'Idle TimeOut'}
  if (vParamIdleTimeOut > 0) and StabilizedConn then
  begin
   {$REGION 'Calc Idle TimeOut Values'}
   if LastActivityInSeconds > vParamIdleTimeOut then
    vIdleTimeOut:= LastActivityInSeconds
   else
    vIdleTimeOut:= 0;

   vInIdleTimeOut:= vIdleTimeOut > (vParamIdleTimeOut + vParamWaitIdleResponse);
   {$ENDREGION}


   {$REGION 'Max IDLE TimeOut - Close Session'}
   if (vInIdleTimeOut) then
   begin
    try
     //FSessionTimer.Terminate;
     Close(true);
    except
    end;

    Exit;
   end;
   {$ENDREGION}


   {$REGION 'Exit if Primary Form is Renning'}
   try
    if (PrimaryForm <> nil) and
       (PrimaryForm = TD2BridgeForm(TD2BridgeClass(D2BridgeBaseClassActive).FormAOwner)) then
    begin
     exit;
    end;
   except
   end;
   {$ENDREGION}

   {$REGION 'Begin Idle TimeOut Process'}
   if (not vInIdleTimeOut) and (not Idle) and (vIdleTimeOut > 0) then
   begin
    vRenewIdle:= false;

    if Assigned(PrismBaseClass.OnExpiredSession) then
     PrismBaseClass.OnExpiredSession(self, vRenewIdle);

    if vRenewIdle then
    begin
     FLastActivity:= now;
     Exit;
    end else
    begin
     TThread.CreateAnonymousThread(Exec_ShowMessageSessionIdle).Start;
    end;

    Exit;
   end;
   {$ENDREGION}
  end;
  {$ENDREGION}
 except
 end;
end;

function TPrismSession.MessageDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer;
begin
 result:= MessageDlg(Msg, DlgType, Buttons, HelpCtx, '');
end;

function TPrismSession.PathSession: String;
begin
 Result:= FPrismBaseClass.Options.RootDirectory + FPrismBaseClass.Options.PathTempSessions + UUID + '\';
end;

function TPrismSession.PrimaryForm: TForm;
begin
 if IsD2BridgeContext then
  result:= TForm(FD2BridgeFormPrimary)
 else
  result:= (Application.MainForm as TForm);
end;

function TPrismSession.Recovering: boolean;
begin
 result:= FRecovering;
end;

procedure TPrismSession.Redirect(AURL: string; ANewPage: Boolean);
begin
 if ANewPage then
  ExecJS('window.open('+QuotedStr(AURL)+','+QuotedStr('_blank')+');')
 else
  ExecJS('window.location.assign('+QuotedStr(AURL)+');');
end;

procedure TPrismSession.RegisterEvent(AEventName: string;
  AEvent: TOnEventProc);
begin
  if (FRegistredEvent.Count <= 0) or
     (not FRegistredEvent.ContainsKey(AEventName)) then
  begin
   FRegistredEvent.AddOrSetValue(AEventName, TList<TOnEventProc>.Create);
  end;

 FRegistredEvent[AEventName].Add(AEvent);
end;

procedure TPrismSession.RegisterEventOnCameraInitialize(AOnCameraInitialize: TOnEventProc);
begin
 RegisterEvent('OnCameraInitialize', AOnCameraInitialize);
end;

procedure TPrismSession.RegisterEventOnOrientationChange(
  AOnOrientationChange: TOnEventProc);
begin
 RegisterEvent('OnOrientationChange', AOnOrientationChange);
end;

procedure TPrismSession.RegisterEventOnPageLoad(AOnPageLoad: TOnEventProc);
begin
 RegisterEvent('OnPageLoad', AOnPageLoad);
end;

procedure TPrismSession.RegisterEventOnPageResize(
  AOnPageResize: TOnEventProc);
begin
 RegisterEvent('OnPageResize', AOnPageResize);
end;

function TPrismSession.Reloading: boolean;
begin
 result:= FReloading;
end;

procedure TPrismSession.RenewUUID;
var
 vOLDUUID: string;
begin
 vOLDUUID:= FUUID;
 FUUID:= GenerateRandomString(SizeUUID);
 PrismBaseClass.Sessions.Add(self);
 PrismBaseClass.Sessions.Delete(vOLDUUID);
end;

procedure TPrismSession.SendFile(FullFilePath: String; OpenOnFinishDownload: Boolean = false; WebFileName: String = '');
var
 //vWebPathDownload: String;
 vDownloadCode, vDownloadFullURL: String;
 vScriptJS: TStrings;
 vAppBase: string;
begin
 if FileExists(FullFilePath) then
 begin
  vScriptJS:= TStringList.Create;
  //vWebPathDownload:= SubtractPaths(FPrismBaseClass.Options.RootDirectory, FullFilePath);

  vAppBase:= '';
  if PrismBaseClass.PrismServer.AppBase <> '/' then
   vAppBase:= PrismBaseClass.PrismServer.AppBase;


  vDownloadCode:= GenerateRandomJustString(17);
  FFileDownloads.Add(vDownloadCode, FullFilePath);
  vDownloadFullURL:=
   vAppBase +
   PrismBaseClass.PrismServer.FpathDownload +
   '?file=' +
   vDownloadCode +
   '&token=' +
   Token +
   '&prismsession=' +
   UUID;


  if WebFileName = '' then
  WebFileName:= ExtractFileName(FullFilePath);

  //vWebPathDownload := StringReplace(vWebPathDownload, PathDelim, '/', [rfReplaceAll]);

  with vScriptJS do
  begin
   Add('var fileUrl = "' + vDownloadFullURL + '";');
   if OpenOnFinishDownload then
    Add('var openAfterDownload = true;')
   else
    Add('var openAfterDownload = false;');
   Add('var downloadLink = document.createElement(''a'');');
   Add('downloadLink.href = fileUrl;');
   Add('downloadLink.download = "' + WebFileName + '";');
   Add('downloadLink.click();');
   Add('if (openAfterDownload) {');
   Add('  window.open(fileUrl, ''_blank'');');
   Add('}');
  end;

  ExecJS(vScriptJS.Text);

  vScriptJS.Free;
 end;
end;

function TPrismSession.SendFileLink(FullFilePath: String): string;
var
 vDownloadCode, vDownloadFullURL: String;
 vURI: string;
 LastDelimiterBarPos: Integer;
begin
 Result:= '';
 if FileExists(FullFilePath) then
 begin
  vURI:= URI.URL;

  LastDelimiterBarPos := LastDelimiter('/', vURI);

  if LastDelimiterBarPos = Length(vURI) then
    Delete(vURI, LastDelimiterBarPos, 1);

  vDownloadCode:= GenerateRandomJustString(17);
  FFileDownloads.Add(vDownloadCode, FullFilePath);
  result:= vURI + PrismBaseClass.PrismServer.FpathDownload+'?file='+vDownloadCode+'&token='+Token+'&prismsession='+UUID;
 end;
end;


function TPrismSession.Sessions: IPrismSessions;
begin
 result:= PrismBaseClass.Sessions;
end;

procedure TPrismSession.SetLanguageNav(const Value: TD2BridgeLang);
var
  vLang: TD2BridgeLang;
begin
 FLanguageNav:= Value;

 //Language of Session
 if FLanguageNav in TD2BridgeManager(D2BridgeManager).Languages then
 begin
  FLanguage:= FLanguageNav;
 end else
 if TD2BridgeLang.English in TD2BridgeManager(D2BridgeManager).Languages then
 begin
  FLanguage:= TD2BridgeLang.English;
 end else
 for vLang := Low(TD2BridgeLang) to High(TD2BridgeLang) do
  if vLang in TD2BridgeManager(D2BridgeManager).Languages then
   FLanguage:= vLang;
end;


procedure TPrismSession.SetRecovering(Value: boolean);
begin
 FRecovering:= Value;
end;

procedure TPrismSession.ShowMessage(const Msg: string; useToast: boolean; TimerInterval: integer; DlgType: TMsgDlgType; ToastPosition: TToastPosition);
begin
 {$IFDEF D2BRIDGE}
 if Assigned(ActiveForm) then
  if (ActiveForm as TPrismForm).D2BridgeForm <> nil then
   (ActiveForm as TPrismForm).D2BridgeForm.ShowMessage(Msg, useToast, TimerInterval, DlgType, ToastPosition);
 {$ELSE}
  {$IFDEF FMX}FMX.Dialogs{$ELSE}Dialogs{$ENDIF}.MessageDlg(Msg, DlgType, [TMsgDlgBtn.MBOk], 0);
 {$ENDIF}
end;

procedure TPrismSession.ShowMessage(const Msg: string; useToast, ASyncMode: Boolean; TimerInterval: integer; DlgType: TMsgDlgType; ToastPosition: TToastPosition);
begin
 {$IFDEF D2BRIDGE}
 if Assigned(ActiveForm) then
  if (ActiveForm as TPrismForm).D2BridgeForm <> nil then
   (ActiveForm as TPrismForm).D2BridgeForm.ShowMessage(Msg, useToast, ASyncMode, TimerInterval, DlgType, ToastPosition);
 {$ELSE}
  {$IFDEF FMX}FMX.Dialogs{$ELSE}Dialogs{$ENDIF}.MessageDlg(Msg, DlgType, [TMsgDlgBtn.MBOk], 0);
 {$ENDIF}
end;

procedure TPrismSession.ShowMessage(const Msg: string);
begin
 {$IFDEF D2BRIDGE}
 if Assigned(ActiveForm) then
  if (ActiveForm as TPrismForm).D2BridgeForm <> nil then
   (ActiveForm as TPrismForm).D2BridgeForm.ShowMessage(Msg);
 {$ELSE}
  {$IFDEF FMX}FMX.Dialogs{$ELSE}Dialogs{$ENDIF}.ShowMessage(Msg);
 {$ENDIF}
end;

procedure TPrismSession.ShowMessageError(const Msg: string; ASyncMode, useToast: boolean; TimerInterval: integer; ToastPosition: TToastPosition);
begin
 ShowMessage(Msg, useToast, ASyncMode, TimerInterval, TMsgDlgType.mtError, ToastPosition);
end;

function TPrismSession.StabilizedConn: boolean;
begin
 result:= FStabilizedConn;
end;

procedure TPrismSession.SetActive(Value: Boolean);
begin
 if Value <> FActive then
 begin
  FActive:= Value;
 end;
end;

procedure TPrismSession.SetD2BridgeBaseClass(AD2BridgeBaseClass: TObject);
var
 I: Integer;
 vPriorD2BridgeForm: TD2BridgeForm;
begin
 vPriorD2BridgeForm:= nil;

 if Assigned(FD2BridgeBaseClass) then
 begin
  if Assigned(ActiveForm) then
  begin
   ActiveForm.onFormUnload;

   for I:= 0 to TD2BridgeClass(FD2BridgeBaseClass).NestedCount -1 do
    (TD2BridgeClass(FD2BridgeBaseClass).Nested(I).FrameworkForm as TPrismForm).onFormUnload;
  end;

  if (Assigned(TD2BridgeClass(FD2BridgeBaseClass).FormAOwner)) and
     (TD2BridgeClass(FD2BridgeBaseClass).FormAOwner is TD2BridgeForm) and
     (not (csDestroying in TD2BridgeForm(TD2BridgeClass(FD2BridgeBaseClass).FormAOwner).ComponentState)) then
  vPriorD2BridgeForm:= TD2BridgeForm(TD2BridgeClass(FD2BridgeBaseClass).FormAOwner);
 end;

 FD2BridgeBaseClass:= AD2BridgeBaseClass;

 if (TD2BridgeClass(AD2BridgeBaseClass).D2BridgeOwner = nil) then
 begin
  FD2BridgeForms.Remove(AD2BridgeBaseClass);
  FD2BridgeForms.Add(AD2BridgeBaseClass);

  TD2BridgeForm(TD2BridgeClass(FD2BridgeBaseClass).FormAOwner).PriorD2Bridge:= nil;
  if Assigned(vPriorD2BridgeForm) then
  begin
   if vPriorD2BridgeForm <> TD2BridgeForm(TD2BridgeClass(FD2BridgeBaseClass).FormAOwner) then
   TD2BridgeForm(TD2BridgeClass(FD2BridgeBaseClass).FormAOwner).PriorD2Bridge:= vPriorD2BridgeForm;
  end;
 end;
end;

procedure TPrismSession.SetData(AValue: TObject);
begin
 FData:= AValue;
end;

procedure TPrismSession.SetFormatSettings(const Value: TFormatSettings);
begin
 FFormatSettings:= Value;
end;

procedure TPrismSession.SetWebSocketContext(const Value: TIdContext);
begin
 FWebSocketContext := Value;
end;

procedure TPrismSession.ThreadAddCurrent;
begin
 PrismBaseClass.Sessions.AddThreadhID(TThread.CurrentThread.ThreadID, Self);
end;

procedure TPrismSession.ThreadAddFromID(const AThreadID: integer);
begin
 PrismBaseClass.Sessions.AddThreadhID(AThreadID, Self);
end;

function TPrismSession.ThreadIDValid(const AThreadID: integer): boolean;
var
 vPrismSession: TPrismSession;
begin
 result:= false;

 try
  vPrismSession := PrismBaseClass.Sessions.FromThreadID(AThreadID) as TPrismSession;

  result:= Assigned(vPrismSession) and (vPrismSession = self);
 except
 end;
end;


procedure TPrismSession.ThreadRemoveCurrent;
begin
 PrismBaseClass.Sessions.RemoveThreadID(TThread.CurrentThread.ThreadID);
end;

procedure TPrismSession.ThreadRemoveFromID(const AThreadID: integer);
begin
 PrismBaseClass.Sessions.RemoveThreadID(AThreadID, Self);
end;

procedure TPrismSession.UnLock(AWaitName: String);
begin
 if FLockName.Contains(AWaitName) then
 begin
  FLockName.Remove(AWaitName);
 end;
end;

procedure TPrismSession.UnLockAll;
begin
 FLockName.Clear;
end;

procedure TPrismSession.UnRegisterEvent(AEventName: string; AEvent: TOnEventProc);
{$IFDEF FPC}
var
 vEvent: TOnEventProc;
 vList: TList<TOnEventProc>;
 m1, m2: TMethod;
 I: integer;
{$ENDIF}
begin
 if (FRegistredEvent.Count > 0) and FRegistredEvent.ContainsKey(AEventName) then
 begin
{$IFDEF FPC}
   m2 := TMethod(AEvent);
   vList:= FRegistredEvent[AEventName];
   for i := vList.Count - 1 downto 0 do
   begin
     vEvent := vList[i];
     m1 := TMethod(vEvent);
     if (m1.Code = m2.Code) and (m1.Data = m2.Data) then
     begin
       vList.Delete(i);
       Break;
     end;
   end;
{$ELSE}
   if FRegistredEvent[AEventName].Contains(AEvent) then
    FRegistredEvent[AEventName].Remove(AEvent);
{$ENDIF}

 end;
end;


procedure TPrismSession.UnRegisterEventOnCameraInitialize(AOnCameraInitialize: TOnEventProc);
begin
 UnRegisterEvent('OnCameraInitialize', AOnCameraInitialize);
end;

procedure TPrismSession.UnRegisterEventOnOrientationChange(AOnOrientationChange: TOnEventProc);
begin
 UnRegisterEvent('OnOrientationChange', AOnOrientationChange);
end;

procedure TPrismSession.UnRegisterEventOnPageLoad(AOnPageLoad: TOnEventProc);
begin
 UnRegisterEvent('OnPageLoad', AOnPageLoad);
end;

procedure TPrismSession.UnRegisterEventOnPageResize(AOnPageResize: TOnEventProc);
begin
 UnRegisterEvent('OnPageResize', AOnPageResize);
end;

function TPrismSession.URI: IPrismURI;
begin
 Result:= FURI;
end;


end.