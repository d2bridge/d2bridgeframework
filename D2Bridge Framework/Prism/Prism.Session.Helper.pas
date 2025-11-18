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

unit Prism.Session.Helper;

interface

uses
  Classes, SysUtils,
{$IFDEF HAS_UNIT_SYSTEM_UITYPES}
  System.UITypes,
{$ENDIF}
  DateUtils,
{$IFDEF FMX}
  FMX.Dialogs, FMX.Controls,
{$ELSE}
  Dialogs, Controls,
{$ENDIF}
  Prism.Session, Prism.Session.Thread.Proc, Prism.Types;

type
 TPrismSessionStatusHelper = class helper for TPrismSession
  strict private
   //Thread Exec
   procedure Exec_WaitResponseMessageSessionIdle;
  public
   procedure Exec_ShowMessageSessionIdle;
   procedure DoDeActive;
   procedure DoRestore;
   procedure DoRecovering;
   procedure DoRecovered;
   procedure DoRenewUUID;
   procedure DoHeartBeat;
   procedure DoClose;
   procedure SetPrimaryForm(AD2BridgePrimaryForm: TObject);
   procedure SetConnectionStatus(AConnectionStatus: TSessionConnectionStatus);
   procedure SetReloading(AReloading: boolean);
   procedure SetDisconnect(ADisconnect: boolean);
   procedure SetIdle(AIdle: boolean);
   procedure SetIdleSeconds(ASeconds: integer);
   procedure SetCheckingConn(ACheckingConn: boolean);
   procedure SetStabilizedConn(AStabilizedConn: boolean);
   procedure ShowMessageSessionIdle;
   procedure AddThread(AThread: TPrismSessionThreadProc);
   procedure RemoveThread(AThread: TPrismSessionThreadProc);
   function ThreadCount: integer;
   function LastThread: TPrismSessionThreadProc;
 end;


implementation


{ TPrismSessionStatusHelper }

procedure TPrismSessionStatusHelper.AddThread(AThread: TPrismSessionThreadProc);
begin
 FLockThreads.BeginWrite;

 try
  FThreads.Add(AThread);
 except
 end;

 FLockThreads.EndWrite;
end;

procedure TPrismSessionStatusHelper.DoClose;
begin
 DoDestroy;
end;

procedure TPrismSessionStatusHelper.DoDeActive;
begin
 SetActive(False);
end;

procedure TPrismSessionStatusHelper.DoHeartBeat;
begin
 FLastHeartBeat:= now;
end;

procedure TPrismSessionStatusHelper.DoRecovered;
begin
 SetRecovering(False);
end;

procedure TPrismSessionStatusHelper.DoRecovering;
begin
 SetRecovering(True);
end;

procedure TPrismSessionStatusHelper.DoRenewUUID;
begin
 RenewUUID;
end;

procedure TPrismSessionStatusHelper.DoRestore;
begin
 SetActive(True);
end;

procedure TPrismSessionStatusHelper.Exec_ShowMessageSessionIdle;
begin
 try
  if Self.MessageDlg(Self.LangNav.Messages.SessionIdleTimeOut, TMsgDlgType.mtwarning, [TMsgDlgBtn.mbyes,TMsgDlgBtn.mbno], 0) = mrYes then
  begin
   if (not (Self.Closing)) and (not (csDestroying in self.ComponentState)) then
    if not (Self.Closing) then
     Self.Close(true);
  end else
  begin
   Self.SetIdleSeconds(0);
   Self.SetIdle(false);
  end;
 except
 end;

end;

procedure TPrismSessionStatusHelper.Exec_WaitResponseMessageSessionIdle;
begin
 try
  Sleep(60000);

  if Idle and
     (not (Closing)) and
     (not (csDestroying in Self.ComponentState)) then
   Close(false);
 except
 end;
end;

function TPrismSessionStatusHelper.LastThread: TPrismSessionThreadProc;
begin
 FLockThreads.BeginRead;

 try
  Result:= FThreads[FThreads.Count-1];
 except
 end;

 FLockThreads.EndRead;
end;

procedure TPrismSessionStatusHelper.RemoveThread(
  AThread: TPrismSessionThreadProc);
begin
 FLockThreads.BeginWrite;

 try
  if FThreads.Contains(AThread) then
   FThreads.Remove(AThread);
 except
 end;

 FLockThreads.EndWrite;

end;

procedure TPrismSessionStatusHelper.SetCheckingConn(ACheckingConn: boolean);
begin
 FCheckingConn:= ACheckingConn;
end;

procedure TPrismSessionStatusHelper.SetConnectionStatus(AConnectionStatus: TSessionConnectionStatus);
begin
 DoConnectionStatus(AConnectionStatus);
end;

procedure TPrismSessionStatusHelper.SetDisconnect(ADisconnect: boolean);
begin
 if ADisconnect then
  BeginDisconnect
 else
  EndDisconnect;
end;

procedure TPrismSessionStatusHelper.SetIdle(AIdle: boolean);
begin
 FIdle:= AIdle;
end;

procedure TPrismSessionStatusHelper.SetIdleSeconds(ASeconds: integer);
var
 vTempLastActivity: TDateTime;
begin
 vTempLastActivity:= IncSecond(Now, ASeconds * (-1));
 if vTempLastActivity > FLastActivity then
  FLastActivity:= vTempLastActivity;
end;

procedure TPrismSessionStatusHelper.SetPrimaryForm(AD2BridgePrimaryForm: TObject);
begin
 FD2BridgeFormPrimary:= AD2BridgePrimaryForm;
end;

procedure TPrismSessionStatusHelper.SetReloading(AReloading: boolean);
begin
 FReloading:= AReloading;
end;

procedure TPrismSessionStatusHelper.SetStabilizedConn(AStabilizedConn: boolean);
begin
 FStabilizedConn:= AStabilizedConn;
end;

procedure TPrismSessionStatusHelper.ShowMessageSessionIdle;
begin
 TThread.CreateAnonymousThread(Exec_ShowMessageSessionIdle).Start;

 TThread.CreateAnonymousThread(Exec_WaitResponseMessageSessionIdle).Start;
end;

function TPrismSessionStatusHelper.ThreadCount: integer;
begin
 FLockThreads.BeginRead;

 try
  Result:= FThreads.Count;
 except
 end;

 FLockThreads.EndRead;

end;

end.