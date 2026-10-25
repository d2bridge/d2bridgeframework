{
 +--------------------------------------------------------------------------+
  D2Bridge Framework Content

  Author: Alisson Suart
  Email: alisson@deuxsoftware.com.br

  Module: Console D2Bridge Server

  This source code is provided 'as-is', without any express or implied
  warranty. In no event will the author be held liable for any damages
  arising from the use of this code.

  However, it is granted that this code may be used for any purpose,
  including commercial applications, but it may not be sublicensed without
  express written authorization from the author (Alisson Suart).
  This includes creating derivative works or distributing the source code
  through any means.

  If you use this software in a product, an acknowledgment in the product
  documentation would be appreciated but is not required.

  God bless you
 +--------------------------------------------------------------------------+
}


unit Unit_D2Bridge_Server_Console;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, D2Bridge.DebugUtils,
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  DateUtils;

type
  TD2BridgeServerConsole = class
  private
    class
     var
{$IFDEF MSWINDOWS}
      hIn: THandle;
      hTimer: THandle;
      threadID: cardinal;
{$ENDIF}
      TimeoutAt: TDateTime;
      WaitingForReturn: boolean;
      TimerThreadTerminated: boolean;
      vServerPort: Integer;
      VServerName: String;
      vInputConsole: String;
    class procedure DisplayInfo;
    class procedure DisplayStartConfigServer;
    class procedure ClearLine(Line: Integer);
    class procedure SetCursorPosition(X, Y: Integer);
    class function ConsoleWidth: Integer;

{$IFNDEF MSWINDOWS}
    class procedure ReadLineWithTimeout(const TimeoutSec: Integer);
{$ENDIF}

  public
    class procedure Run;
  end;

implementation

uses
{$IFDEF FPC}
  Forms,
{$ELSE}
  Vcl.Forms,
{$ENDIF}
  ServerController, Unit_Map;

{ Windows: timer thread using BeginThread + WriteConsoleInput }

{$IFDEF MSWINDOWS}

function TimerThread(Parameter: pointer): {$IFDEF CPU32}Longint{$ELSE}{$IFNDEF FPC}Integer{$ELSE}Int64{$ENDIF}{$ENDIF};
var
  IR: TInputRecord;
  amt: cardinal;
begin
  result := 0;
  IR.EventType := KEY_EVENT;
  IR.Event.KeyEvent.bKeyDown := true;
  IR.Event.KeyEvent.wVirtualKeyCode := VK_RETURN;
  while not TD2BridgeServerConsole.TimerThreadTerminated do
  begin
    if TD2BridgeServerConsole.WaitingForReturn and (Now >= TD2BridgeServerConsole.TimeoutAt) then
      WriteConsoleInput(TD2BridgeServerConsole.hIn, IR, 1, amt);
    sleep(500);
  end;
end;

procedure StartTimerThread;
begin
  TD2BridgeServerConsole.hTimer := BeginThread(nil, 0, TimerThread, nil, 0, TD2BridgeServerConsole.threadID);
end;

procedure EndTimerThread;
begin
  TD2BridgeServerConsole.TimerThreadTerminated := true;
  WaitForSingleObject(TD2BridgeServerConsole.hTimer, 1000);
  CloseHandle(TD2BridgeServerConsole.hTimer);
end;

procedure TimeoutWait(const Time: cardinal);
var
  IR: TInputRecord;
  nEvents: cardinal;
begin

  TD2BridgeServerConsole.TimeOutAt := IncSecond(Now, Time);
  TD2BridgeServerConsole.WaitingForReturn := true;

  while ReadConsoleInput(TD2BridgeServerConsole.hIn, IR, 1, nEvents) do
  begin
    if (IR.EventType = KEY_EVENT) and
      (TKeyEventRecord(IR.Event).wVirtualKeyCode = VK_RETURN)
      and (TKeyEventRecord(IR.Event).bKeyDown) then
      begin
        TD2BridgeServerConsole.WaitingForReturn := false;
        break;
      end;

      if (TKeyEventRecord(IR.Event).bKeyDown) and (TKeyEventRecord(IR.Event).AsciiChar <> #0) then
      begin
       if Char(TKeyEventRecord(IR.Event).AsciiChar) = Char(VK_Back) then
       begin
        if TD2BridgeServerConsole.vInputConsole <> '' then
        begin
         Write(char(TKeyEventRecord(IR.Event).AsciiChar));
         Write(StringOfChar(' ', 1));
         Write(char(TKeyEventRecord(IR.Event).AsciiChar));

         TD2BridgeServerConsole.vInputConsole := Copy(TD2BridgeServerConsole.vInputConsole, 1, Length(TD2BridgeServerConsole.vInputConsole)-1);
        end;
       end else
       begin
        Write(char(TKeyEventRecord(IR.Event).AsciiChar));
        TD2BridgeServerConsole.vInputConsole := TD2BridgeServerConsole.vInputConsole + TKeyEventRecord(IR.Event).AsciiChar;
       end;

       TD2BridgeServerConsole.TimeOutAt := IncSecond(Now, Time);
      end;
  end;
end;

{$ENDIF}

{ Linux: timer thread using TThread + standard I/O }

{$IFNDEF MSWINDOWS}

type
  TLinuxTimerThread = class(TThread)
  protected
    procedure Execute; override;
  end;

var
  GLinuxTimerThread: TLinuxTimerThread = nil;

procedure TLinuxTimerThread.Execute;
begin
  while not TD2BridgeServerConsole.TimerThreadTerminated do
  begin
    if TD2BridgeServerConsole.WaitingForReturn and
       (Now >= TD2BridgeServerConsole.TimeoutAt) then
      TD2BridgeServerConsole.WaitingForReturn := False;
    Sleep(200);
  end;
end;

procedure StartTimerThread;
begin
  TD2BridgeServerConsole.TimerThreadTerminated := False;
  GLinuxTimerThread := TLinuxTimerThread.Create(False);
end;

procedure EndTimerThread;
begin
  TD2BridgeServerConsole.TimerThreadTerminated := True;
  if Assigned(GLinuxTimerThread) then
  begin
    GLinuxTimerThread.WaitFor;
    FreeAndNil(GLinuxTimerThread);
  end;
end;

class procedure TD2BridgeServerConsole.ReadLineWithTimeout(const TimeoutSec: Integer);
begin
  TD2BridgeServerConsole.TimeoutAt := IncSecond(Now, TimeoutSec);
  TD2BridgeServerConsole.WaitingForReturn := True;

  while TD2BridgeServerConsole.WaitingForReturn do
    Sleep(100);
end;

procedure TimeoutWait(const Time: Cardinal);
var
  userInput: String;
begin
  TD2BridgeServerConsole.TimeoutAt := IncSecond(Now, Time);
  TD2BridgeServerConsole.WaitingForReturn := True;

  userInput := '';
  while TD2BridgeServerConsole.WaitingForReturn do
    Sleep(100);

  if userInput <> '' then
    TD2BridgeServerConsole.vInputConsole := userInput;
end;

{$ENDIF}

class procedure TD2BridgeServerConsole.ClearLine(Line: Integer);
begin
  SetCursorPosition(0, Line);
  Write(StringOfChar(' ', ConsoleWidth));
  SetCursorPosition(0, Line);
end;

class function TD2BridgeServerConsole.ConsoleWidth: Integer;
{$IFDEF MSWINDOWS}
var
  ConsoleInfo: TConsoleScreenBufferInfo;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE), ConsoleInfo);
  Result := ConsoleInfo.dwSize.X;
{$ELSE}
  Result := 80;
{$ENDIF}
end;

class procedure TD2BridgeServerConsole.SetCursorPosition(X, Y: Integer);
{$IFDEF MSWINDOWS}
var
  Coord: TCoord;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  Coord.X := X;
  Coord.Y := Y;
  SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), Coord);
{$ELSE}
  Write(Format(#27'[%d;%dH', [Y + 1, X + 1]));
{$ENDIF}
end;

class procedure TD2BridgeServerConsole.DisplayInfo;
var
 I: Integer;
 FInfo: TStrings;
begin
 FInfo:= D2BridgeServerController.ServerInfoConsole;

 for I := 0 to Pred(FInfo.Count) do
 begin
  ClearLine(I);
  Writeln(FInfo[I]);
 end;

 FreeAndNil(FInfo);
end;

class procedure TD2BridgeServerConsole.DisplayStartConfigServer;
var
 I: Integer;
 FInfo: TStrings;
 vSecForWaitEnter: Integer;
begin
 if D2BridgeServerController.IsD2DockerContext then
  Exit;

 WaitingForReturn:= false;
 TimerThreadTerminated:= false;

 if not IsDebuggerPresent then
  vSecForWaitEnter:= 5
 else
  vSecForWaitEnter:= 1;

{$IFDEF MSWINDOWS}
 hIn := GetStdHandle(STD_INPUT_HANDLE);
{$ENDIF}

 StartTimerThread;

 FInfo:= D2BridgeServerController.ServerInfoConsoleHeader;

 for I := 0 to Pred(FInfo.Count) do
 begin
  ClearLine(I);
  Writeln(FInfo[I]);
 end;

 vInputConsole:= IntToStr(vServerPort);
 Writeln('Enter the Server Port and press [ENTER]');
 Write('Server Port: '+TD2BridgeServerConsole.vInputConsole);
 TimeoutWait(vSecForWaitEnter);
 if vInputConsole <> '' then
   vServerPort := StrToIntDef(vInputConsole, vServerPort);

 Writeln('');
 Writeln('');

 vInputConsole:= vServerName;
 Writeln('Enter the Server Name and press [ENTER]');
 Write('Server Name: '+TD2BridgeServerConsole.vInputConsole);
 TimeoutWait(vSecForWaitEnter);
 vServerName:= vInputConsole;

 SetCursorPosition(0, 0);

 FreeAndNil(FInfo);
 EndTimerThread;
end;

class procedure TD2BridgeServerConsole.Run;
begin
 D2BridgeServerController:= TD2BridgeServerController.Create(Application);
 vServerPort:= D2BridgeServerController.AppConfig.ServerPort(8888);
 vServerName:= D2BridgeServerController.AppConfig.ServerName('Map Demo');

 D2BridgeServerController.APPName:= 'Map Demo';
 D2BridgeServerController.ServerAppTitle:= 'Map Demo';
 D2BridgeServerController.ServerAppAuthor:= 'Alisson Suart - alisson@deuxsoftware.com.br';
 D2BridgeServerController.PrimaryFormClass:= TFormMap;
 D2BridgeServerController.Languages:= [TD2BridgeLang.English];
 D2BridgeServerController.Prism.Options.IncludeJQuery:= true;
 D2BridgeServerController.Prism.Options.CoInitialize:= true;
 D2BridgeServerController.Prism.Options.PathJS:= 'js';
 D2BridgeServerController.Prism.Options.PathCSS:= 'css';

 { Free map.
   RequestLocation, LockOrigin, Route and ClearRoute run without a key.
   Route returns the straight-line distance only. }

 { Street route. Leave this block commented.
   The key stays on the server and is never sent to the page.
   Uncomment only when Prism.Options exposes these properties.
   An empty ApiKey must not call the provider.

   D2BridgeServerController.Prism.Options.Map.Provider := 'openrouteservice';
   D2BridgeServerController.Prism.Options.Map.ApiKey := '';
   D2BridgeServerController.Prism.Options.Map.BaseURL := 'https://api.openrouteservice.org';
   D2BridgeServerController.Prism.Options.Map.Profile := 'driving-car';

   Other providers, same place:
   D2BridgeServerController.Prism.Options.Map.Provider := 'google';
   D2BridgeServerController.Prism.Options.Map.Provider := 'mapbox';
 }

 if D2BridgeServerController.IsD2DockerContext then
  Exit;

 DisplayStartConfigServer;

 D2BridgeServerController.Port:= vServerPort;
 D2BridgeServerController.ServerName:= VServerName;

 if D2BridgeServerController.IsD2DockerContext then
  Exit;

 D2BridgeServerController.StartServer;

 try
  while D2BridgeServerController.Started do
  begin
   DisplayInfo;
   Sleep(100);
   SetCursorPosition(0, 0);
  end;
 except
  on E: Exception do
   Writeln('Error: ', E.Message);
 end;
end;

end.
