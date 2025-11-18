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

unit Prism.Form.Timer;

interface

uses
  Classes, SysUtils, SyncObjs,
  Prism.Interfaces, Prism.Types;

type
  TPrismFormTimer = class(TThread)
  private
    FInterval: Integer;
    FOnTimer: TThreadProcedure;
    //FPauseEvent: TEvent;
    FTerminated: Boolean;
    FPaused: Boolean;
    FPrismForm: IPrismForm;
  protected
    procedure Execute; override;
  public
    constructor Create(APrismForm: IPrismForm; Interval: Integer; OnTimer: TThreadProcedure);
    destructor Destroy; override;
    procedure Pause;
    procedure Resume;
    procedure Terminate; reintroduce;
    property Terminated: Boolean read FTerminated;
    property PrismForm: IPrismForm read FPrismForm write FPrismForm;
  end;

implementation

uses
{$IFDEF FMX}
  FMX.Forms,
{$ELSE}
  Forms,
{$ENDIF}
  Prism.Forms;

{ TPrismFormTimer }

constructor TPrismFormTimer.Create(APrismForm: IPrismForm; Interval: Integer; OnTimer: TThreadProcedure);
begin
  FPrismForm:= APrismForm;
  FPaused:= true;

  inherited Create(False);
  Priority:= tpIdle;
  FInterval := Interval;
  FOnTimer := OnTimer;
  FreeOnTerminate:= true;
  //FPauseEvent := TEvent.Create(nil, True, True, '');
end;

destructor TPrismFormTimer.Destroy;
begin
  FTerminated:= true;
  //FPaused:= true;
  //Terminate;
  //FPauseEvent.Free;
  //FOnTimer:= nil;

  if Assigned(FPrismForm) then
  begin
   try
    (FPrismForm as TPrismForm).FormTimer:= nil;
    FPrismForm:= nil;
   except
   end;
  end;

  inherited;
end;

procedure TPrismFormTimer.Pause;
begin
  FPaused := True;
end;

procedure TPrismFormTimer.Resume;
begin
  FPaused := False;
  //FPauseEvent.SetEvent;
end;

procedure TPrismFormTimer.Terminate;
begin
  FTerminated := True;
end;

procedure TPrismFormTimer.Execute;
begin
 try
  if (not FTerminated) and Assigned(FPrismForm) then
   while (not FTerminated) and
         (not (FPrismForm as TPrismForm).Destroying) and
         (not FPrismForm.Session.Destroying) and
         (not FPrismForm.Session.Closing) do
   begin
     //Yield;
     Sleep(FInterval);

     if (not FPaused) and (not FTerminated) then
     begin
       if Assigned(FOnTimer) then
       begin
        try
         //Synchronize(CurrentThread, FOnTimer);
         //TThread.Synchronize(nil, FOnTimer);
         FOnTimer();
        except
        end;
       end;
     end;

 //    Application.ProcessMessages;
 //    if not FTerminated then
 //    Sleep(FInterval);
 //    if not FTerminated then
 //    if Assigned(self) then
 //    FPauseEvent.WaitFor(INFINITE); // Pauses execution if paused
   end;

 except
  FTerminated := True;
 end;
end;

end.