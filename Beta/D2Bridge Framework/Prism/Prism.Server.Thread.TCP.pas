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

unit Prism.Server.Thread.TCP;

interface

Uses
  Classes, SysUtils, Prism.Server.TCP
{$IFDEF USE_MORMOT2}
  , Prism.MormotCompat, mormot.net.sock, mormot.net.server
{$ELSE}
  , IdSchedulerOfThreadPool
{$ENDIF}
  ,
{$IFDEF MSWINDOWS}
   Windows,
{$ENDIF}
  D2Bridge.DebugUtils
{$IFDEF USE_MORMOT2}
  , mormot.core.base
{$ELSE}
  , IdSSLOpenSSL
{$ENDIF}
  , SyncObjs;

type
 TPrismThreadServerTCP = class(TThread)
  private
   FPrismServerTCP: TPrismServerTCP;
   FStart: Boolean;
   FPort: Integer;
   FConnectEvent: TEvent;
   function GetPort: Integer;
   procedure SetPort(const Value: Integer);
   procedure CreatePrismServerTCP;
   procedure DestroyPrismServerTCP;
  protected
   procedure Execute; override;
  public
   constructor Create;

   procedure StartServer;
   procedure StopServer;

   function SSLOptions: {$IFDEF USE_MORMOT2}TMormotTlsConfig{$ELSE}TIdSSLOptions{$ENDIF};

   function PrismServerTCP: TPrismServerTCP;

   function Active: boolean;

   property Port: Integer read GetPort write SetPort;
 end;


implementation

Uses
{$IFNDEF USE_MORMOT2}
  idGlobal,
{$ENDIF}
  Prism.BaseClass,
  D2Bridge.ServerControllerBase;

{ TPrismThreadServerTCP }

constructor TPrismThreadServerTCP.Create;
begin
 FPort:= 8888;
 FStart:= false;

 inherited Create(false);

 //Priority:= tpIdle;
 FreeOnTerminate:= false;

  FPrismServerTCP:= TPrismServerTCP.Create;
  PrismServer := FPrismServerTCP; // assign global reference
end;

procedure TPrismThreadServerTCP.CreatePrismServerTCP;
begin
 {$IFDEF D2BRIDGE}
  if not Assigned(FPrismServerTCP) then
   FPrismServerTCP:= TPrismServerTCP.Create;

  PrismServer := FPrismServerTCP; // assign global reference

{$IFDEF USE_MORMOT2}
 // mORMot2: configura porta e SSL, StartServer já cria o THttpServer
 FPrismServerTCP.StartServer(FPort, PrismBaseClass.Options.SSL);
{$ELSE}
 // Indy: configura servidor + thread pool + SSL
 FPrismServerTCP.DefaultPort:= FPort;
 FPrismServerTCP.MaxConnections:= MaxInt;
 FPrismServerTCP.ListenQueue:= 2048;
 FPrismServerTCP.ReuseSocket:= rsTrue;

 //Pool
{$IFnDEF FPC}
 if not IsDebuggerPresent then
 begin
  FPrismServerTCP.Scheduler:= TIdSchedulerOfThreadPool.Create(FPrismServerTCP);
  TIdSchedulerOfThreadPool(FPrismServerTCP.Scheduler).PoolSize := 100;
  TIdSchedulerOfThreadPool(FPrismServerTCP.Scheduler).MaxThreads:= 512;
  TIdSchedulerOfThreadPool(FPrismServerTCP.Scheduler).Init;
 end;
{$ENDIF}
{$ENDIF}

 FPrismServerTCP.OnGetHTML:= PrismBaseClass.PrismServerHTML.GetHTML;
 FPrismServerTCP.OnReceiveMessage := PrismBaseClass.PrismServerHTML.ReceiveMessage;
 FPrismServerTCP.OnGetFile:= PrismBaseClass.PrismServerHTML.GetFile;
 FPrismServerTCP.OnFinishedGetHTML:= PrismBaseClass.PrismServerHTML.FinishedGetHTML;
 FPrismServerTCP.OnRESTData:= PrismBaseClass.PrismServerHTML.RESTData;
 FPrismServerTCP.OnDownloadData:= PrismBaseClass.PrismServerHTML.DownloadData;
 FPrismServerTCP.OnParseFile:= PrismBaseClass.PrismServerHTML.ParseFile;

{$IFNDEF USE_MORMOT2}
 {$REGION 'SSL'}
 if PrismBaseClass.Options.SSL then
 begin
  SSLOptions.Mode := sslmServer;
  SSLOptions.VerifyMode := [];
  SSLOptions.VerifyDepth  := 2;
  SSLOptions.SSLVersions := [sslvSSLv2, sslvTLSv1_1, sslvTLSv1_2, sslvSSLv23, sslvSSLv3];
  FPrismServerTCP.IOHandler := FPrismServerTCP.OpenSSL;
 end;
 {$ENDREGION}
{$ENDIF}

 {$ENDIF}
end;

procedure TPrismThreadServerTCP.DestroyPrismServerTCP;
begin
 if Assigned(FPrismServerTCP) then
 begin
  FPrismServerTCP.CloseAllConnection;
{$IFNDEF USE_MORMOT2}
  FPrismServerTCP.Bindings.Clear;
{$ENDIF}
  FPrismServerTCP.Free;
 end;
end;

procedure TPrismThreadServerTCP.Execute;
var
  vStarted : Boolean;
begin
  try
   vStarted:= false;

  while (not Terminated) do
  begin
   if FStart <> vStarted then
   begin
     if FStart then
     begin
      CreatePrismServerTCP;

{$IFDEF D2DOCKER}
      D2BridgeServerControllerBase.D2BridgeManager.API.D2Docker.DoServerStarted;
{$ENDIF}

{$IFDEF USE_MORMOT2}
      // mORMot2: StartServer já foi chamado em CreatePrismServerTCP,
      // aguarda confirmação
      FPrismServerTCP.StartServer(FPort, PrismBaseClass.Options.SSL);
{$ELSE}
      FPrismServerTCP.Bindings.Clear;

      with FPrismServerTCP.Bindings.Add do
      begin
        IP := '0.0.0.0';
        Port := FPort;
        ReuseSocket := rsTrue;
      end;

      try
       FPrismServerTCP.Active := FStart;
      except
       on E: Exception do
       begin
        try
{$IFDEF D2DOCKER}
          PrismBaseClass.API.D2Docker.DoLogException('Server cannot Start on port ' + IntToStr(FPort) + ' ' + E.Message)
{$ELSE}
          raise Exception.Create('Server cannot Start on port ' + IntToStr(FPort) + ' ' + E.Message);
{$ENDIF}
        except
        end;

        if not IsDebuggerPresent then
         Sleep(10000);

        {$IFDEF FPC}
        Halt(0);
        {$ENDIF}
        {$IFDEF MSWINDOWS}
        ExitProcess(0);
        {$ELSE}
        Halt(0);
        {$ENDIF}
       end;
      end;
{$ENDIF}
     end else
     begin
{$IFDEF USE_MORMOT2}
      FPrismServerTCP.StopServer;
{$ELSE}
      FPrismServerTCP.Active := False;
{$ENDIF}

      DestroyPrismServerTCP;
     end;

    if FStart <> vStarted then
     FConnectEvent.SetEvent;

    vStarted:= FStart;
   end;

   Sleep(100);
  end;
 except
  on E: Exception do
  if D2BridgeServerControllerBase.NeedConsole then
   Writeln('Erro no servidor: ', E.Message);
 end;
end;

function TPrismThreadServerTCP.GetPort: Integer;
begin
 Result:= FPort;
end;

function TPrismThreadServerTCP.PrismServerTCP: TPrismServerTCP;
begin
 result:= FPrismServerTCP;
end;

procedure TPrismThreadServerTCP.SetPort(const Value: Integer);
begin
 FPort:= Value;
end;

function TPrismThreadServerTCP.SSLOptions: {$IFDEF USE_MORMOT2}TMormotTlsConfig{$ELSE}TIdSSLOptions{$ENDIF};
begin
{$IFDEF USE_MORMOT2}
 // mORMot2: return TLS config record
 Result := FPrismServerTCP.TLSContext;
{$ELSE}
 result:= FPrismServerTCP.OpenSSL.SSLOptions;
{$ENDIF}
end;

function TPrismThreadServerTCP.Active: boolean;
begin
 Result:= false;
 if Assigned(FPrismServerTCP) then
  result:= FPrismServerTCP.Active;
end;

procedure TPrismThreadServerTCP.StartServer;
begin
  FStart:= true;

 FConnectEvent:= TEvent.Create(nil, true, false, '');
 FConnectEvent.WaitFor(INFINITE);
 FConnectEvent.Free;

{$IFDEF USE_MORMOT2}
 if not FPrismServerTCP.Active then
 begin
  FPrismServerTCP := nil;
  FStart:= false;
  Abort;
 end;
{$ELSE}
 if not FPrismServerTCP.Active then
 begin
  FPrismServerTCP.Free;
  FStart:= false;
  Abort;
 end;
{$ENDIF}
end;

procedure TPrismThreadServerTCP.StopServer;
begin
 if Assigned(FPrismServerTCP) then
 begin
  FStart:= false;

  FConnectEvent:= TEvent.Create(nil, true, false, '');
  FConnectEvent.WaitFor(INFINITE);
  FConnectEvent.Free;

{$IFDEF USE_MORMOT2}
  if FPrismServerTCP.Active then
  begin
   FStart:= true;
   Abort;
  end;
{$ELSE}
  if FPrismServerTCP.Active then
  begin
   FPrismServerTCP.Free;
   FStart:= true;
   Abort;
  end;
{$ENDIF}
 end;
end;



end.
