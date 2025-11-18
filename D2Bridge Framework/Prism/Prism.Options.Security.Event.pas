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
