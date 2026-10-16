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

unit Prism.BaseClass.Sessions;

interface

uses
  Classes, SysUtils, Generics.Collections, SyncObjs,
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
{$IFDEF FMX}
  FMX.Forms,
{$ELSE}
  Forms,
{$ENDIF}
  Prism.Interfaces, Prism.Session;

type
 TPrismSessions = class(TInterfacedPersistent, IPrismSessions)
  strict private
   procedure Exec_ProcessMessage;
  private
   FDictSessions: TDictionary<string, TPrismSession>;
   FDictInfoSessions: TDictionary<string, string>;
   FLock: TMultiReadExclusiveWriteSynchronizer;
   FDictThreadIDSessions: TDictionary<integer, TPrismSession>;
   FLockIDSession: TMultiReadExclusiveWriteSynchronizer;
   FMainThreadPrismSession: IPrismSession;
   function GetSession(const AUUID: String): IPrismSession;
   function GetSessionsFromIdentity(const Identity: string): TList<IPrismSession>;
   function GetSessionsFromIdentityAndUser(const Identity, User: string): TList<IPrismSession>;
   function GetMainThreadPrismSession: IPrismSession;
   procedure SetMainThreadPrismSession(APrismSession: IPrismSession);
  public
   constructor Create;
   destructor Destroy; override;

   procedure Add(APrismSession: IPrismSession); overload;
   function Count: integer;
   function Delete(AUUID: string): Boolean; overload;
   function Delete(ASession: IPrismSession): Boolean; overload;
   function Exist(AUUID: string): Boolean; overload;
   function Exist(AUUID, AToken: string): Boolean; overload;
   function FromPushID(const APushID: string): IPrismSession;
   function FromAuthID(const AAuthID: string): IPrismSession;
   function Items: TList<IPrismSession>;

   procedure AddThreadhID(AID: integer; APrismSession: IPrismSession);
   procedure RemoveThreadID(AID: integer); overload;
   procedure RemoveThreadID(AID: integer; APrismSession: IPrismSession); overload;
   procedure RemoveThreadIDsFromSession(APrismSession: IPrismSession);
   function FromThreadID(const AThreadID: Integer; AAlertErrorThreadID: Boolean = false): IPrismSession;
   function ThreadhIDs: TList<integer>;

   procedure CloseAll;
   procedure FreeMem;

   property Item[const AUUID: string]: IPrismSession read GetSession;
   property SessionsFromIdentity[const Identity: string]: TList<IPrismSession> read GetSessionsFromIdentity;
   property SessionsFromIdentityAndUser[const Identity, User: string]: TList<IPrismSession> read GetSessionsFromIdentityAndUser;
   property MainThreadPrismSession: IPrismSession read GetMainThreadPrismSession write SetMainThreadPrismSession;
 end;

implementation

Uses
 Prism.Session.Helper,
 Prism.BaseClass;


{ TPrismSessions }

procedure TPrismSessions.Add(APrismSession: IPrismSession);
begin
 FLock.BeginWrite;
 try
  try
   if (FDictSessions.Count <= 0) or
      (not FDictSessions.ContainsKey(APrismSession.UUID)) then
   begin
    FDictSessions.AddOrSetValue(APrismSession.UUID, APrismSession as TPrismSession);
    FDictInfoSessions.AddOrSetValue(APrismSession.UUID, APrismSession.Token);
   end;
  except
  end;
 finally
   FLock.EndWrite;
 end;
end;

procedure TPrismSessions.AddThreadhID(AID: integer; APrismSession: IPrismSession);
begin
 FLockIDSession.BeginWrite;

 try
  if AID <> MainThreadID then
   FDictThreadIDSessions.AddOrSetValue(AID, APrismSession as TPrismSession)
  else
  begin
   if Assigned(APrismSession) then
    SetMainThreadPrismSession(APrismSession);
  end;
 except
 end;

 FLockIDSession.EndWrite;
end;

procedure TPrismSessions.CloseAll;
var
 vPrismSession: IPrismSession;
 vKeys: TList<string>;
 vKey: string;
begin
 try
  vKeys:= nil;

  FLock.BeginRead;
  if FDictSessions.Count > 0 then
  begin
   vKeys:= TList<string>.Create(FDictSessions.Keys);
  end;
  FLock.EndRead;

  if Assigned(vKeys) then
  begin
   for vkey in vKeys do
   begin
    vPrismSession:= Item[vkey];

    try
      if Assigned(vPrismSession) then
       if not vPrismSession.Closing then
        (vPrismSession as TPrismSession).DoClose;
    except
    end;
   end;

   vKeys.Free;
  end;
 finally
 end;
end;

function TPrismSessions.Count: integer;
begin
 result:= 0;

 FLock.BeginRead;
 try
  try
   result:= FDictSessions.Count;
  except
  end;
 finally
   FLock.EndRead;
 end;
end;

constructor TPrismSessions.Create;
begin
 FLock := TMultiReadExclusiveWriteSynchronizer.Create;
 FDictSessions:= TDictionary<string, TPrismSession>.Create;
 FDictInfoSessions:= TDictionary<string, string>.Create;

 FDictThreadIDSessions:= TDictionary<integer, TPrismSession>.Create;
 FLockIDSession:= TMultiReadExclusiveWriteSynchronizer.Create;
end;

function TPrismSessions.Delete(AUUID: string): Boolean;
begin
 Result:= False;

 FLock.BeginWrite;
 try
  try
   if (not (FDictSessions.Count <= 0)) and
      FDictSessions.ContainsKey(AUUID) then
   begin
    FDictSessions.Remove(AUUID);
    FDictInfoSessions.Remove(AUUID);

 {$IFDEF D2BRIDGE}
    if not IsDebuggerPresent then
     if FDictSessions.Count <= 0 then
      FreeMem;
 {$ENDIF}
    result:= true;
   end;
  except
  end;
 finally
   FLock.EndWrite;
 end;
end;

function TPrismSessions.Delete(ASession: IPrismSession): Boolean;
var
 vKey: string;
 vKeysList: TList<string>;
 I: integer;
 vSession: IPrismSession;
begin
 result:= false;

 FLock.BeginWrite;
 try
  try
   vKeysList:= TList<string>.Create(FDictSessions.Keys);

   for I:= 0 to Pred(vKeysList.Count) do
   begin
    vSession:= FDictSessions[vKeysList[I]];

    if vSession = ASession then
    begin
     FDictSessions.Remove(vKeysList[I]);
     FDictInfoSessions.Remove(vKeysList[I]);

     Result:= true;

     Break;
    end;
   end;

   vKeysList.Free;

 {$IFDEF D2BRIDGE}
    if not IsDebuggerPresent then
     if FDictSessions.Count <= 0 then
      FreeMem;
 {$ENDIF}
    result:= true;
  except
  end;
 finally
   FLock.EndWrite;
 end;

end;

destructor TPrismSessions.Destroy;
begin
 FLock.Free;
 FDictSessions.Free;
 FDictInfoSessions.Free;

 FDictThreadIDSessions.Free;
 FLockIDSession.Free;

 inherited;
end;

function TPrismSessions.Exist(AUUID: string): Boolean;
var
 vPrismSession: TPrismSession;
begin
 Result:= false;

 FLock.BeginRead;
 try
  try
   if (not (FDictSessions.Count <= 0)) and
      FDictSessions.ContainsKey(AUUID) then
   begin
    vPrismSession:= FDictSessions.Items[AUUID];
    if Assigned(vPrismSession) then
     if vPrismSession.Closing then
      result:= false
     else
      result:= true
   end;
  except
  end;
 finally
   FLock.EndRead;
 end;
end;

procedure TPrismSessions.Exec_ProcessMessage;
begin
 try
   if Assigned(Application) then
     Application.ProcessMessages;
 except
 end;
end;

function TPrismSessions.Exist(AUUID, AToken: string): Boolean;
var
 vPrismSession: TPrismSession;
begin
 Result:= false;

 FLock.BeginRead;
 try
  try
   if (not (FDictInfoSessions.Count <= 0)) then
    if FDictInfoSessions.ContainsKey(AUUID) then
     if FDictInfoSessions.Items[AUUID] = AToken then
     begin
      vPrismSession:= FDictSessions.Items[AUUID];
      if vPrismSession.Closing then
       result:= false
      else
       result:= true
     end;
  except
  end;
 finally
   FLock.EndRead;
 end;
end;

procedure TPrismSessions.FreeMem;
var
  MainHandle: THandle;
begin
 if IsDebuggerPresent then
  exit;

{$IFDEF MSWINDOWS}
  try
    MainHandle := OpenProcess(PROCESS_ALL_ACCESS, false, GetCurrentProcessID) ;
    SetProcessWorkingSetSize(MainHandle, $FFFFFFFF, $FFFFFFFF) ;
    CloseHandle(MainHandle) ;
  except
  end;

  {$IFDEF FPC}
  TThread.Queue(nil, Exec_ProcessMessage);
  {$ELSE}
  Exec_ProcessMessage;
  {$ENDIF}
{$ENDIF}
end;

function TPrismSessions.FromAuthID(const AAuthID: string): IPrismSession;
var
 I, J: Integer;
 vPrismSession: TPrismSession;
begin
 FLock.BeginRead;

 try
  System.Initialize(Result);

  try
    for I := 0 to Pred(FDictSessions.Count) do
    begin
     for vPrismSession in FDictSessions.Values do
     begin
      try
       if Assigned(vPrismSession) then
       begin
        if vPrismSession.AuthID = AAuthID then
        begin
         Result:= vPrismSession;
         Break;
        end;
       end;
      except
      end;
     end;

     if Assigned(Result) then
     Break;
    end;
  except
  end;
 finally
  FLock.EndRead;
 end;
end;

function TPrismSessions.FromPushID(const APushID: string): IPrismSession;
var
 I, J: Integer;
 vPrismSession: TPrismSession;
begin
 FLock.BeginRead;

 try
  System.Initialize(Result);

  try
    for I := 0 to Pred(FDictSessions.Count) do
    begin
     for vPrismSession in FDictSessions.Values do
     begin
      try
       if Assigned(vPrismSession) then
       begin
        if vPrismSession.PushID = APushID then
        begin
         Result:= vPrismSession;
         Break;
        end;
       end;
      except
      end;
     end;

     if Assigned(Result) then
     Break;
    end;
  except
  end;
 finally
  FLock.EndRead;
 end;

end;

function TPrismSessions.FromThreadID(const AThreadID: Integer; AAlertErrorThreadID: Boolean): IPrismSession;
var
 vExist: boolean;
begin
 System.Initialize(Result);

 FLockIDSession.BeginRead;

 try
  vExist:= false;

  if (not (FDictThreadIDSessions.Count <= 0)) then
   if FDictThreadIDSessions.ContainsKey(AThreadID) then
   begin
    vExist:= true;
    Result:= FDictThreadIDSessions[AThreadID];
   end;

  if (Result = nil) and (not vExist) then
  begin
   try
    if (AThreadID = MainThreadID) and
       (MainThreadPrismSession <> nil )then
    begin
     result:= FMainThreadPrismSession;
    end else
     if AAlertErrorThreadID or
        IsDebuggerPresent or
        PrismBaseClass.IsD2DockerContext then
     begin
{$IFDEF D2DOCKER}
       PrismBaseClass.API.D2Docker.DoLogException('Error searching Session Thread, Session is nil: Error 7002')
{$ELSE}
       raise Exception.Create('Error searching Session Thread, Session is nil: Error 7002');
{$ENDIF}
     end;
   except
   end;
  end;
 except
 end;

 FLockIDSession.EndRead;
end;

function TPrismSessions.GetSession(const AUUID: String): IPrismSession;
begin
 System.Initialize(result);

 FLock.BeginRead;
 try
  try
   if (not (FDictSessions.Count <= 0)) then
    if FDictSessions.ContainsKey(AUUID) then
     result:= FDictSessions.Items[AUUID];
  except
  end;
 finally
  FLock.EndRead;
 end;
end;

function TPrismSessions.GetSessionsFromIdentity(const Identity: string): TList<IPrismSession>;
var
 vPrismSession: TPrismSession;
 I: integer;
begin
 FLock.BeginRead;
 try
  Result:= TList<IPrismSession>.Create;

  try
   for vPrismSession in FDictSessions.Values do
   begin
    try
     if Assigned(vPrismSession) then
      if not vPrismSession.Closing then
       if vPrismSession.InfoConnection <> nil then
        if SameText(vPrismSession.InfoConnection.Identity, Identity) then
         Result.Add(vPrismSession);
    except
    end;
   end;
  except
  end;
 finally
  FLock.EndRead;
 end;
end;

function TPrismSessions.GetSessionsFromIdentityAndUser(const Identity, User: string): TList<IPrismSession>;
var
 vPrismSession: IPrismSession;
 vPrismSessionList: TList<IPrismSession>;
 I: integer;
begin
 try
  Result:= TList<IPrismSession>.Create;
  vPrismSessionList:= SessionsFromIdentity[Identity];

  try
   for vPrismSession in vPrismSessionList do
   begin
    try
     if SameText(vPrismSession.InfoConnection.User, User) then
      Result.Add(vPrismSession);
    except
    end;
   end;
  except
  end;
 finally
  FreeAndNil(vPrismSessionList);
 end;
end;

function TPrismSessions.Items: TList<IPrismSession>;
var
 vPrismSession: TPrismSession;
begin
 System.Initialize(result);

 FLock.BeginRead;
 try
  try
   result:= TList<IPrismSession>.Create;

   for vPrismSession in FDictSessions.Values do
     Result.Add(vPrismSession);
  except
  end;
 finally
   FLock.EndRead;
 end;

end;

function TPrismSessions.GetMainThreadPrismSession: IPrismSession;
var
 vToken: string;
begin
 SYSTEM.Initialize(Result);

 try
  if Assigned(FMainThreadPrismSession) then
  begin
   //Using get Token detect if Prismsession is available in memory
   vToken:= FMainThreadPrismSession.Token;
   Result:= FMainThreadPrismSession;
  end;
 except
  FMainThreadPrismSession:= nil;
 end;
end;

procedure TPrismSessions.RemoveThreadID(AID: integer);
var
 vPrismSession: IPrismSession;
begin
 FLockIDSession.BeginWrite;

 try
  if (not (FDictThreadIDSessions.Count <= 0)) then
   if FDictThreadIDSessions.ContainsKey(AID) then
   begin
    FDictThreadIDSessions.Remove(AID);
   end;
 except
 end;

 if AID = MainThreadID then
 begin
  try
   SetMainThreadPrismSession(nil);
  except
  end;
 end;

 FLockIDSession.EndWrite;
end;

procedure TPrismSessions.RemoveThreadID(AID: integer; APrismSession: IPrismSession);
begin
 FLockIDSession.BeginWrite;

 try
  if (not (FDictThreadIDSessions.Count <= 0)) then
   if FDictThreadIDSessions.ContainsKey(AID) then
   begin
    if FDictThreadIDSessions[AID] = (APrismSession as TPrismSession) then
    begin
     FDictThreadIDSessions.Remove(AID);
    end;
   end;
 except
 end;

 if AID = MainThreadID then
 begin
  try
   SetMainThreadPrismSession(nil);
  except
  end;
 end;

 FLockIDSession.EndWrite;
end;

procedure TPrismSessions.RemoveThreadIDsFromSession(APrismSession: IPrismSession);
var
 vID: integer;
 vRemoveIDsList: TList<Integer>;
begin
 vRemoveIDsList:= TList<Integer>.Create;

 FLockIDSession.BeginWrite;

 try
  try
   for vID in FDictThreadIDSessions.Keys.ToArray do
    if FDictThreadIDSessions[vID] = (APrismSession as TPrismSession) then
     vRemoveIDsList.Add(vID);

   for vID in vRemoveIDsList do
    FDictThreadIDSessions.Remove(vID);
  except
  end;

  vRemoveIDsList.Free;
 except
 end;

 try
  if MainThreadPrismSession = APrismSession then
  begin
   SetMainThreadPrismSession(nil);
  end;
 except
 end;

 FLockIDSession.EndWrite;
end;

procedure TPrismSessions.SetMainThreadPrismSession(APrismSession: IPrismSession);
begin
 if MainThreadPrismSession <> nil then
 begin
  FMainThreadPrismSession := nil;
 end;

 FMainThreadPrismSession:= APrismSession;
end;

function TPrismSessions.ThreadhIDs: TList<integer>;
begin
 FLockIDSession.BeginRead;

 try
  Result:= TList<Integer>.Create(FDictThreadIDSessions.Keys);
 except
 end;

 FLockIDSession.EndRead;
end;

end.