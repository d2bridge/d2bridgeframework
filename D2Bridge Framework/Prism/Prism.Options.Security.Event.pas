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

unit Prism.Options.Security.Event;

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
 TOnSecurityEvent = procedure(const SecEventInfo: TSecuritEventInfo) of object;

 procedure EventSecurity(const AIP, AAgent: string; const ASecurityEvent: TSecurityEvent);

 procedure EventBlockIPBlackList(const AIP, AAgent: string);
 procedure EventDelistIPBlackList(const AIP, AAgent: string);
 procedure EventNotDelistIPBlackList(const AIP, AAgent: string);
 procedure EventBlockUserAgent(const AIP, AAgent: string);
 procedure EventBlockIPLimitConn(const AIP, AAgent: string);
 procedure EventBlockIPLimitSession(const AIP, AAgent: string);

implementation

uses
  Prism.BaseClass;

procedure EventSecurity(const AIP, AAgent: string; const ASecurityEvent: TSecurityEvent);
var
 vSecurityEvent: TSecuritEventInfo;
begin
 vSecurityEvent:= Default(TSecuritEventInfo);
 vSecurityEvent.IP:= AIP;
 vSecurityEvent.IsIPV6:= false;
 vSecurityEvent.UserAgent:= AAgent;
 vSecurityEvent.Event:= ASecurityEvent;

 PrismBaseClass.DoSecurity(vSecurityEvent);
end;

procedure EventBlockIPBlackList(const AIP, AAgent: string);
begin
 EventSecurity(AIP, AAgent, TSecurityEvent.secBlockBlackList);
end;

procedure EventDelistIPBlackList(const AIP, AAgent: string);
begin
 EventSecurity(AIP, AAgent, TSecurityEvent.secDelistIPBlackList);
end;

procedure EventNotDelistIPBlackList(const AIP, AAgent: string);
begin
 EventSecurity(AIP, AAgent, TSecurityEvent.secNotDelistIPBlackList);
end;

procedure EventBlockUserAgent(const AIP, AAgent: string);
begin
 EventSecurity(AIP, AAgent, TSecurityEvent.secBlockUserAgent);
end;

procedure EventBlockIPLimitConn(const AIP, AAgent: string);
begin
 EventSecurity(AIP, AAgent, TSecurityEvent.secBlockIPLimitConn);
end;

procedure EventBlockIPLimitSession(const AIP, AAgent: string);
begin
 EventSecurity(AIP, AAgent, TSecurityEvent.secBlockIPLimitSession);
end;

end.