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

unit Prism.BaseClass.Timer;

interface

uses
  Classes, SysUtils,
{$IFDEF HAS_UNIT_SYSTEM_THREADING}
  System.Threading,
{$ENDIF}
  Prism.Interfaces, Prism.Types;


type
 TPrismTimer = class(TThread)
  private
    FInterval: Integer;
    FOnTimer: TThreadProcedure;
    FTerminated: Boolean;
    FPaused: Boolean;
    FTickCount: int64;
    procedure Exec_OnTimer;
  protected
    procedure Execute; override;
  public
    constructor Create(Interval: Integer; OnTimer: TThreadProcedure);
    destructor Destroy; override;
    procedure Pause;
    procedure Resume;
    procedure Terminate;
    property Terminated: Boolean read FTerminated;
  end;

implementation

{ TPrismTimer }

constructor TPrismTimer.Create(Interval: Integer; OnTimer: TThreadProcedure);
begin
 FPaused:= true;
 FInterval := Interval;
 FOnTimer := OnTimer;

 inherited Create(False);

 Priority:= tpIdle;
 FreeOnTerminate:= true;
end;

destructor TPrismTimer.Destroy;
begin
  FPaused:= true;
  Terminate;

//  if Assigned(FOnTimer) then
//  FOnTimer:= nil;

  inherited;
end;

procedure TPrismTimer.Execute;
var
 vTickCountNow: Int64;
begin
 while (not FTerminated) do
 begin
  if (not FPaused) then
  begin
   vTickCountNow:= GetTickCount;

   if (vTickCountNow - FTickCount) >= FInterval then
   begin
    if (not FTerminated) then
    begin
     if Assigned(FOnTimer) then
     begin
      try
       FOnTimer();
      except
      end;
     end;
    end;

    FTickCount:= GetTickCount;
   end;
  end;

  Sleep(1);
 end;
end;

procedure TPrismTimer.Exec_OnTimer;
begin
 FOnTimer();
end;

procedure TPrismTimer.Pause;
begin
 FPaused := True;
end;

procedure TPrismTimer.Resume;
begin
 FTickCount:= GetTickCount;
 FPaused := False;
end;

procedure TPrismTimer.Terminate;
begin
 FTerminated := True;
end;

end.
