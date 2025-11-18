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

unit Prism.Session.Thread.Proc;

interface

uses
  Classes, SysUtils, SyncObjs, Rtti,
{$IFnDEF FMX}
  Forms,
{$ELSE}
  FMX.Forms,
{$ENDIF}
{$IFDEF HAS_UNIT_SYSTEM_THREADING}
  System.Threading,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  Prism.Types, Prism.Interfaces;

type
  TTypePrismSessionThreadProc = (pmtNone, pmtOne, pmtTwo, pmtThree, pmtFour);

  TPrismSessionThreadProc = class(TThread)
  private
   FPrismSession: IPrismSession;
   FSincronize: Boolean;
   FWait: Boolean;
   fTypePrismSessionThreadProc: TTypePrismSessionThreadProc;
   FThreadID: integer;
   FFinished: boolean;
   FProc:  TProc;
   FProc1: TProc1;
   FProc2: TProc2;
   FProc3: TProc3;
   FProc4: TProc4;
   FProcVar1: TValue;
   FProcVar2: TValue;
   FProcVar3: TValue;
   FProcVar4: TValue;
   FUnregisterInSession: Boolean;
   procedure ProcExec;
  protected
   procedure Execute; override;
   procedure DoTerminate; override;
  public
   constructor Create(APrismSession: IPrismSession; AWait: Boolean; ASincronize: Boolean); overload;
   constructor Create(APrismSession: IPrismSession; AProc: TProc; AWait: Boolean = False; ASincronize: Boolean = False); overload;
   constructor Create(APrismSession: IPrismSession; AProc: TProc1; AVar1: TValue; AWait: Boolean = False; ASincronize: Boolean = False); overload;
   constructor Create(APrismSession: IPrismSession; AProc: TProc2; AVar1: TValue; AVar2: TValue; AWait: Boolean = False; ASincronize: Boolean = False); overload;
   constructor Create(APrismSession: IPrismSession; AProc: TProc3; AVar1: TValue; AVar2: TValue; AVar3: TValue; AWait: Boolean = False; ASincronize: Boolean = False); overload;
   constructor Create(APrismSession: IPrismSession; AProc: TProc4; AVar1: TValue; AVar2: TValue; AVar3: TValue; AVar4: TValue; AWait: Boolean = False; ASincronize: Boolean = False); overload;
   destructor Destroy; override;

   procedure Exec;

   function PrismSession: IPrismSession;

   property Proc: TProc read FProc;
   property Proc1: TProc1 read FProc1;
   property Proc2: TProc2 read FProc2;
   property Proc3: TProc3 read FProc3;
   property Proc4: TProc4 read FProc4;
   property ProcVar1: TValue read FProcVar1 write FProcVar1;
   property ProcVar2: TValue read FProcVar2 write FProcVar2;
   property ProcVar3: TValue read FProcVar3 write FProcVar3;
   property ProcVar4: TValue read FProcVar4 write FProcVar4;
   property Wait: Boolean read FWait;
   property Sincronize: Boolean read FSincronize;
   property TypePrismSessionThreadProc: TTypePrismSessionThreadProc read fTypePrismSessionThreadProc;
   property UnregisterInSession: Boolean read FUnregisterInSession write FUnregisterInSession;
 end;


{$IFNDEF SUPPORTS_FUNCTION_REFERENCES}
 TThreadHelper = class helper for TThread
   class function CreateAnonymousThread(aMethod: TThreadMethod): TThread; static;
 end;
{$ENDIF}

implementation

Uses
 Prism.BaseClass, Prism.Session, Prism.Session.Helper;


{$IFNDEF SUPPORTS_FUNCTION_REFERENCES}
type
  TAnonymousThread = class(TThread)
  private
    FProc: TProc;
  protected
    procedure Execute; override;
  public
    constructor Create(const AProc: TProc);
  end;
{$ENDIF}


{$IFNDEF SUPPORTS_FUNCTION_REFERENCES}
{ TAnonymousThread }

constructor TAnonymousThread.Create(const AProc: TProc);
begin
 inherited Create(True);
 FreeOnTerminate := True;
 FProc := AProc;
end;

procedure TAnonymousThread.Execute;
begin
 FProc();
end;

{ TThreadHelper }

class function TThreadHelper.CreateAnonymousThread(aMethod: TThreadMethod): TThread;
begin
 Result:= TAnonymousThread.Create(aMethod);
end;
{$ENDIF}


{ TPrismSessionThreadProc }

constructor TPrismSessionThreadProc.Create(APrismSession: IPrismSession; AProc: TProc; AWait: Boolean; ASincronize: Boolean);
begin
 FProc:= AProc;
 fTypePrismSessionThreadProc:= pmtNone;

 Create(APrismSession, AWait, ASincronize);
end;

constructor TPrismSessionThreadProc.Create(APrismSession: IPrismSession; AProc: TProc1; AVar1: TValue; AWait: Boolean; ASincronize: Boolean);
begin
 FProc1:= AProc;
 FProcVar1:= AVar1;
 fTypePrismSessionThreadProc:= pmtOne;

 Create(APrismSession, AWait, ASincronize);
end;

constructor TPrismSessionThreadProc.Create(APrismSession: IPrismSession; AProc: TProc2; AVar1: TValue; AVar2: TValue; AWait: Boolean; ASincronize: Boolean);
begin
 FProc2:= AProc;
 FProcVar1:= AVar1;
 FProcVar2:= AVar2;
 fTypePrismSessionThreadProc:= pmtTwo;

 Create(APrismSession, AWait, ASincronize);
end;

constructor TPrismSessionThreadProc.Create(APrismSession: IPrismSession; AProc: TProc3; AVar1: TValue; AVar2: TValue; AVar3: TValue; AWait: Boolean; ASincronize: Boolean);
begin
 FProc3:= AProc;
 FProcVar1:= AVar1;
 FProcVar2:= AVar2;
 FProcVar3:= AVar3;
 fTypePrismSessionThreadProc:= pmtThree;

 Create(APrismSession, AWait, ASincronize);
end;

constructor TPrismSessionThreadProc.Create(APrismSession: IPrismSession; AProc: TProc4; AVar1: TValue; AVar2: TValue; AVar3: TValue; AVar4: TValue; AWait: Boolean; ASincronize: Boolean);
begin
 FProc4:= AProc;
 FProcVar1:= AVar1;
 FProcVar2:= AVar2;
 FProcVar3:= AVar3;
 FProcVar4:= AVar4;
 fTypePrismSessionThreadProc:= pmtFour;

 Create(APrismSession, AWait, ASincronize);
end;

constructor TPrismSessionThreadProc.Create(APrismSession: IPrismSession; AWait: Boolean; ASincronize: Boolean);
begin
 FWait:= AWait;
 FPrismSession:= APrismSession;
 FSincronize:= ASincronize;
 FUnregisterInSession:= true;

 inherited Create(true);

 //Priority:= tpIdle;
 FreeOnTerminate:= (not AWait) and (not ASincronize);
end;

destructor TPrismSessionThreadProc.Destroy;
begin
 //Delete this Thread from Session
 try
  if Assigned(FPrismSession) then
  begin
   //(FPrismSession as TPrismSession).ThreadRemoveFromID(FThreadID);
   if FUnregisterInSession then
   begin
    if (not FPrismSession.Closing) then
     (FPrismSession as TPrismSession).RemoveThread(self);
   end;

   FPrismSession:= nil;
  end;
 except
 end;

 inherited;
end;

procedure TPrismSessionThreadProc.DoTerminate;
begin
 inherited;
end;

procedure TPrismSessionThreadProc.Exec;
begin
 try
  FFinished:= false;

  if FSincronize then
  begin
   Queue(ProcExec);
  end else
   Start;

  if FWait then
  begin
   if FSincronize then
   begin
    repeat
//     try
      //Yield;
//      if GetCurrentThreadId = MainThreadID then
//      begin
//       CheckSynchronize;
//       Application.ProcessMessages;
//      end;
//     except
//     end;

     sleep(1);
    until FFinished;
   end else
   begin
    WaitFor;
   end;

   try
    Free;
   except
   end;
  end;
 except
 end;
end;

procedure TPrismSessionThreadProc.Execute;
begin
 if FSincronize then
  Queue(ProcExec)
 else
  ProcExec;
end;

function TPrismSessionThreadProc.PrismSession: IPrismSession;
begin
  Result:= FPrismSession;
end;

procedure TPrismSessionThreadProc.ProcExec;
var
 vIsMainThread: Boolean;
begin
 try
  FThreadID:= TThread.CurrentThread.ThreadID;

  vIsMainThread:= FThreadID = MainThreadID;

  if Assigned(FPrismSession) then
   FPrismSession.ThreadAddFromID(FThreadID)
  else
   if vIsMainThread then
    PrismBaseClass.Sessions.MainThreadPrismSession:= nil;
 except
 end;

 try
  if not UnregisterInSession then
   if Assigned(FPrismSession) then
    FPrismSession:= nil;
 finally
 end;

 try
  case fTypePrismSessionThreadProc of
    pmtNone:  FProc();
    pmtOne:   FProc1(FProcVar1);
    pmtTwo:   FProc2(FProcVar1, FProcVar2);
    pmtThree: FProc3(FProcVar1, FProcVar2, FProcVar3);
    pmtFour:  FProc4(FProcVar1, FProcVar2, FProcVar3, FProcVar4);
  end;
 except on E: Exception do
{$IFDEF MSWINDOWS}
   if IsDebuggerPresent then
     raise Exception.Create(E.Message);
{$ENDIF}
 end;

 try
  if vIsMainThread then
   if Assigned(FPrismSession) then
    if PrismBaseClass.Sessions.MainThreadPrismSession = FPrismSession then
     PrismBaseClass.Sessions.MainThreadPrismSession := nil;
    //FPrismSession.ThreadRemoveFromID(FThreadID);
 except
 end;

 FFinished:= true;
end;

end.
