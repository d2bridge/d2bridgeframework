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