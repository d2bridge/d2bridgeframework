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

unit Prism.Options.Security.IP.Connections;

interface

uses
  Classes, SysUtils, Generics.Collections,
{$IFDEF MSWINDOWS}

{$ENDIF}
{$IFDEF FMX}

{$ELSE}

{$ENDIF}
  Prism.Interfaces, Prism.Types;

type
 TIPConnectionInfo = record
  Count: Integer;
  StartTime: TDateTime;
 end;


type
 TPrismOptionSecurityIPConnections = class(TInterfacedPersistent, IPrismOptionSecurityIPConnections)
  private
   FIPsDict: TDictionary<string, TIPConnectionInfo>;
   FSessionIPsDict: TDictionary<string, TList<IPrismSession>>;
   FPrismOptionSecurity: IPrismOptionSecurity;
   FLock: TMultiReadExclusiveWriteSynchronizer;
   FLimitNewConnPerIPMin: Integer;
   FLimitActiveSessionsPerIP: Integer;
   function GetLimitNewConnPerIPMin: Integer;
   procedure SetLimitNewConnPerIPMin(const Value: Integer);
   function GetLimitActiveSessionsPerIP: Integer;
   procedure SetLimitActiveSessionsPerIP(const Value: Integer);
   function CountIPFromSession(AIP: string): integer;
  public
   constructor Create(APrismOptionSecurity: IPrismOptionSecurity);
   destructor Destroy; override;

   procedure AddSession(APrismSession: IPrismSession);
   procedure RemoveSession(APrismSession: IPrismSession);

   procedure Clear;
   function IsIPAllowed(AIP: string): boolean; overload;
   function IsIPAllowed(AIP: string; out ABlockIPLimitConn: boolean; out ABlockIPLimitSession: Boolean): boolean; overload;
   function IPCount(AIP: string): integer;
   function Delete(AIP: string): Boolean;

   property LimitActiveSessionsPerIP: Integer read GetLimitActiveSessionsPerIP write SetLimitActiveSessionsPerIP;
   property LimitNewConnPerIPMin: Integer read GetLimitNewConnPerIPMin write SetLimitNewConnPerIPMin; //per Minute
 end;

const
  IPConnectionsBlockInterval = 1 / (24 * 60);

implementation

{ TPrismOptionSecurityIPConnections }

procedure TPrismOptionSecurityIPConnections.AddSession(APrismSession: IPrismSession);
var
 vList: TList<IPrismSession>;
begin
 FLock.BeginWrite;

 try
  if not FSessionIPsDict.TryGetValue(APrismSession.InfoConnection.IP, vList) then
  begin
   vList:= TList<IPrismSession>.Create;
   FSessionIPsDict.Add(APrismSession.InfoConnection.IP, vList);
  end;
 except
 end;

 vList.Add(APrismSession);

 FLock.EndWrite;
end;

procedure TPrismOptionSecurityIPConnections.Clear;
begin
 FLock.BeginWrite;

 FIPsDict.Clear;

 FLock.EndWrite;
end;


function TPrismOptionSecurityIPConnections.CountIPFromSession(AIP: string): integer;
var
 vList: TList<IPrismSession>;
begin
 result:= 0;

 if (FLimitActiveSessionsPerIP <= 0) then
 begin
  result:= 0;
  exit;
 end;

 if FSessionIPsDict.TryGetValue(AIP, vList) then
 begin
  result:= vList.Count;
 end else
  result:= 0;
end;

constructor TPrismOptionSecurityIPConnections.Create(APrismOptionSecurity: IPrismOptionSecurity);
begin
 inherited Create;

 FLimitNewConnPerIPMin:= 20;
 FLimitActiveSessionsPerIP:= 50;

 FPrismOptionSecurity:= APrismOptionSecurity;

 FIPsDict:= TDictionary<string, TIPConnectionInfo>.Create;
 FSessionIPsDict:= TDictionary<string, TList<IPrismSession>>.Create;

 FLock:= TMultiReadExclusiveWriteSynchronizer.Create;
end;

function TPrismOptionSecurityIPConnections.Delete(AIP: string): Boolean;
begin
 Result:= true;

 FLock.BeginWrite;

 try
  FIPsDict.ExtractPair(AIP);
  FIPsDict.Remove(AIP);
 finally
 end;

 FLock.EndWrite;
end;

destructor TPrismOptionSecurityIPConnections.Destroy;
begin
 FIPsDict.Free;
 FSessionIPsDict.Free;

 FLock.Free;

 inherited;
end;

function TPrismOptionSecurityIPConnections.GetLimitActiveSessionsPerIP: Integer;
begin
 result:= FLimitActiveSessionsPerIP;
end;

function TPrismOptionSecurityIPConnections.GetLimitNewConnPerIPMin: Integer;
begin
 result:= FLimitNewConnPerIPMin;
end;

function TPrismOptionSecurityIPConnections.IPCount(AIP: string): integer;
begin
 FLock.BeginRead;

 try
  Result:= FIPsDict.Count;
 except
 end;

 FLock.EndRead;
end;

function TPrismOptionSecurityIPConnections.IsIPAllowed(AIP: string; out ABlockIPLimitConn, ABlockIPLimitSession: Boolean): boolean;
var
 vIPConnectionsInfo: TIPConnectionInfo;
 NowTime: TDateTime;
begin
 ABlockIPLimitConn:= false;
 ABlockIPLimitSession:= false;

 if (FLimitNewConnPerIPMin <= 0) and (FLimitActiveSessionsPerIP <= 0) then
  Exit(True);

// if FPrismOptionSecurity.IP.IPv4WhiteList.ExistIP(AIP) then
//  Exit(True);

 NowTime := Now;
 Result:= false;


 FLock.BeginWrite;

 ABlockIPLimitSession:= (FLimitActiveSessionsPerIP > 0) and (CountIPFromSession(AIP) > FLimitActiveSessionsPerIP);

 try
  if (FLimitActiveSessionsPerIP <= 0) or (not ABlockIPLimitSession) then
  begin
   // Se o IP já existe no dicionário
   if FIPsDict.TryGetValue(AIP, vIPConnectionsInfo) then
   begin
    // Verifica se o intervalo expirou
    if (NowTime - vIPConnectionsInfo.StartTime > IPConnectionsBlockInterval) then
    begin
     // Reinicia o contador para um novo intervalo
     vIPConnectionsInfo.Count := 1;
     vIPConnectionsInfo.StartTime := NowTime;
     FIPsDict[AIP] := vIPConnectionsInfo;
     result:= true;
    end
    else
    begin
     // Incrementa o contador e verifica o limite
     if vIPConnectionsInfo.Count >= FLimitNewConnPerIPMin then
     begin
      ABlockIPLimitConn:= true;
      result:= false
     end else
     begin
      Inc(vIPConnectionsInfo.Count);
      FIPsDict[AIP] := vIPConnectionsInfo;
      result:= true;
     end;
    end;
   end
   else
   begin
    // Novo IP: adiciona ao dicionário
    vIPConnectionsInfo.Count := 1;
    vIPConnectionsInfo.StartTime := NowTime;
    FIPsDict.Add(AIP, vIPConnectionsInfo);

    result:= true;
   end;
  end;
 except
 end;

 FLock.EndWrite;
end;

function TPrismOptionSecurityIPConnections.IsIPAllowed(AIP: string): boolean;
var
 vBlockIPLimitConn, vBlockIPLimitSession: boolean;
begin
 result:= IsIPAllowed(AIP, vBlockIPLimitConn, vBlockIPLimitSession);
end;

procedure TPrismOptionSecurityIPConnections.RemoveSession(APrismSession: IPrismSession);
var
 vList: TList<IPrismSession>;
begin
 FLock.BeginWrite;

 try
  if FSessionIPsDict.TryGetValue(APrismSession.InfoConnection.IP, vList) then
  begin
   if vList.Contains(APrismSession) then
    vList.Remove(APrismSession);

   if vList.Count <= 0 then
   begin
    FSessionIPsDict.Remove(APrismSession.InfoConnection.IP);
    vList.Free;
   end;
  end;
 except
 end;

 FLock.EndWrite;
end;

procedure TPrismOptionSecurityIPConnections.SetLimitActiveSessionsPerIP(
  const Value: Integer);
begin
 FLimitActiveSessionsPerIP:= Value;
end;

procedure TPrismOptionSecurityIPConnections.SetLimitNewConnPerIPMin(const Value: Integer);
begin
 FLimitNewConnPerIPMin:= Value;
end;

end.
