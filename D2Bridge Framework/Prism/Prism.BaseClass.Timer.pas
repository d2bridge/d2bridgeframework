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