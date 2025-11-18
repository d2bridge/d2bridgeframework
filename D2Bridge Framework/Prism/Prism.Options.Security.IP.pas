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

unit Prism.Options.Security.IP;

interface

uses
  Classes, SysUtils,
{$IFDEF MSWINDOWS}

{$ENDIF}
{$IFDEF FMX}

{$ELSE}

{$ENDIF}
  Prism.Interfaces, Prism.Types;

type
 TPrismOptionSecurityIP = class(TInterfacedPersistent, IPrismOptionSecurityIP)
  private
   FIPrismOptionSecurity: IPrismOptionSecurity;
   FIPv4BlackList: IPrismOptionSecurityIPv4Blacklist;
   FIPv4WhiteList: IPrismOptionSecurityIPv4Whitelist;
   FIPConnections: IPrismOptionSecurityIPConnections;
  public
   constructor Create(AIPrismOptionSecurity: IPrismOptionSecurity);
   destructor Destroy; override;

   function IPv4BlackList: IPrismOptionSecurityIPv4Blacklist;
   function IPv4WhiteList: IPrismOptionSecurityIPv4Whitelist;
   function IPConnections: IPrismOptionSecurityIPConnections;
 end;

implementation

uses
  Prism.Options.Security.IPv4.Whitelist, Prism.Options.Security.IPv4.Blacklist, Prism.Options.Security.IP.Connections;

{ TPrismOptionSecurityIP }

constructor TPrismOptionSecurityIP.Create(AIPrismOptionSecurity: IPrismOptionSecurity);
begin
 FIPrismOptionSecurity:= AIPrismOptionSecurity;

 FIPv4BlackList:= TPrismOptionSecurityIPv4Blacklist.Create;
 FIPv4WhiteList:= TPrismOptionSecurityIPv4Whitelist.Create;
 FIPConnections:= TPrismOptionSecurityIPConnections.Create(FIPrismOptionSecurity);
end;

destructor TPrismOptionSecurityIP.Destroy;
var
 vIPv4BlackList: TPrismOptionSecurityIPv4Blacklist;
 vIPv4WhiteList: TPrismOptionSecurityIPv4Whitelist;
 vIPConnections: TPrismOptionSecurityIPConnections;
begin
 vIPv4BlackList:= FIPv4BlackList as TPrismOptionSecurityIPv4Blacklist;
 FIPv4BlackList:= nil;
 vIPv4BlackList.Free;

 vIPv4WhiteList:= FIPv4WhiteList as TPrismOptionSecurityIPv4Whitelist;
 FIPv4WhiteList:= nil;
 vIPv4WhiteList.Free;

 vIPConnections:= FIPConnections as TPrismOptionSecurityIPConnections;
 FIPConnections:= nil;
 vIPConnections.Free;

 inherited;
end;

function TPrismOptionSecurityIP.IPConnections: IPrismOptionSecurityIPConnections;
begin
 result:= FIPConnections;
end;

function TPrismOptionSecurityIP.IPv4BlackList: IPrismOptionSecurityIPv4Blacklist;
begin
 result:= FIPv4BlackList;
end;

function TPrismOptionSecurityIP.IPv4WhiteList: IPrismOptionSecurityIPv4Whitelist;
begin
 result:= FIPv4WhiteList;
end;

end.
