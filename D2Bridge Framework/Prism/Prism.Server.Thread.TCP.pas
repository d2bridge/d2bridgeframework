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

unit Prism.Server.Thread.TCP;

interface

Uses
 Classes, SysUtils, Prism.Server.TCP, IdSchedulerOfThreadPool,
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
 IdSSLOpenSSL, SyncObjs;

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

   function SSLOptions: TIdSSLOptions;

   function PrismServerTCP: TPrismServerTCP;

   function Active: boolean;

   property Port: Integer read GetPort write SetPort;
 end;

implementation

Uses
 Prism.BaseClass, IdGlobal;

{ TPrismThreadServerTCP }

constructor TPrismThreadServerTCP.Create;
begin
 FPort:= 8888;
 FStart:= false;

 inherited Create(false);

 //Priority:= tpIdle;
 FreeOnTerminate:= true;

 FPrismServerTCP:= TPrismServerTCP.Create;
end;

procedure TPrismThreadServerTCP.CreatePrismServerTCP;
begin
 {$IFDEF D2BRIDGE}
 if not Assigned(FPrismServerTCP) then
  FPrismServerTCP:= TPrismServerTCP.Create;
 FPrismServerTCP.DefaultPort:= FPort;
 FPrismServerTCP.MaxConnections:= MaxInt;
 FPrismServerTCP.ListenQueue:= 0;

 //Pool
{$IFnDEF FPC}
 if not IsDebuggerPresent then
 begin
  FPrismServerTCP.ReuseSocket:= rsTrue;
  FPrismServerTCP.Scheduler:= TIdSchedulerOfThreadPool.Create(FPrismServerTCP);
  TIdSchedulerOfThreadPool(FPrismServerTCP.Scheduler).PoolSize := 100;
 end;
{$ENDIF}

 FPrismServerTCP.OnGetHTML:= PrismBaseClass.PrismServerHTML.GetHTML;
 FPrismServerTCP.OnReceiveMessage := PrismBaseClass.PrismServerHTML.ReceiveMessage;
 FPrismServerTCP.OnGetFile:= PrismBaseClass.PrismServerHTML.GetFile;
 FPrismServerTCP.OnFinishedGetHTML:= PrismBaseClass.PrismServerHTML.FinishedGetHTML;
 FPrismServerTCP.OnRESTData:= PrismBaseClass.PrismServerHTML.RESTData;
 FPrismServerTCP.OnDownloadData:= PrismBaseClass.PrismServerHTML.DownloadData;

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
end;

procedure TPrismThreadServerTCP.DestroyPrismServerTCP;
begin
 if Assigned(FPrismServerTCP) then
 begin
  FPrismServerTCP.CloseAllConnection;
  FPrismServerTCP.Bindings.Clear;
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

     FPrismServerTCP.Bindings.Clear;
     FPrismServerTCP.DefaultPort := FPort;
     FPrismServerTCP.Active := FStart;
    end else
    begin
     FPrismServerTCP.Active := False;

     DestroyPrismServerTCP;
    end;

    FConnectEvent.SetEvent;

    vStarted:= FStart;
   end;

   Sleep(100);
  end;
 except
  on E: Exception do
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

function TPrismThreadServerTCP.SSLOptions: TIdSSLOptions;
begin
 result:= FPrismServerTCP.OpenSSL.SSLOptions;
end;

function TPrismThreadServerTCP.Active: boolean;
begin
 Result:= false;

 if Assigned(FPrismServerTCP) then
 begin
  result:= FPrismServerTCP.Active;
 end;

end;

procedure TPrismThreadServerTCP.StartServer;
begin
 FStart:= true;

 FConnectEvent:= TEvent.Create(nil, true, false, '');
 FConnectEvent.WaitFor(INFINITE);
 FConnectEvent.Free;

 if not FPrismServerTCP.Active then
 begin
  FPrismServerTCP.Free;
  FStart:= false;
  Abort;
 end;

end;

procedure TPrismThreadServerTCP.StopServer;
begin
 if Assigned(FPrismServerTCP) then
 begin
  FStart:= false;

  FConnectEvent:= TEvent.Create(nil, true, false, '');
  FConnectEvent.WaitFor(INFINITE);
  FConnectEvent.Free;

  if FPrismServerTCP.Active then
  begin
   FPrismServerTCP.Free;
   FStart:= true;
   Abort;
  end;
 end;
end;

end.
