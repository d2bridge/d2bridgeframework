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

unit Prism.Options.Security;

interface

uses
  Classes, SysUtils,
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
{$IFDEF FMX}

{$ELSE}

{$ENDIF}
  Prism.Interfaces, Prism.Types;


type
 TPrismOptionSecurity = class(TInterfacedPersistent, IPrismOptionSecurity)
  private
   FEnabled: Boolean;
   FIP: IPrismOptionSecurityIP;
   FUserAgent: IPrismOptionSecurityUserAgent;
   FLoadDefaultSecurity: Boolean;
   function GetEnabled: Boolean;
   procedure SetEnabled(const Value: Boolean);
  public
   constructor Create;
   destructor Destroy; override;

   procedure LoadDefaultSecurity;

   function IP: IPrismOptionSecurityIP;
   function UserAgent: IPrismOptionSecurityUserAgent;

   property Enabled: Boolean read GetEnabled write SetEnabled;
 end;


implementation

uses
  Prism.Options.Security.IP, Prism.Options.Security.UserAgent,
  Prism.Options.Security.IPv4.Blacklist;


{ TPrismOptionSecurity }

constructor TPrismOptionSecurity.Create;
begin
 inherited;

 FLoadDefaultSecurity:= false;
 FEnabled:= true;
 FIP:= TPrismOptionSecurityIP.Create(self);
 FUserAgent:= TPrismOptionSecurityUserAgent.Create;
end;

destructor TPrismOptionSecurity.Destroy;
var
 vIP: TPrismOptionSecurityIP;
 vUserAgent: TPrismOptionSecurityUserAgent;
begin
 vIP:= FIP as TPrismOptionSecurityIP;
 FIP:= nil;
 vIP.Free;

 vUserAgent:= FUserAgent as TPrismOptionSecurityUserAgent;
 FUserAgent:= nil;
 vUserAgent.Free;

 inherited;
end;

function TPrismOptionSecurity.GetEnabled: Boolean;
begin
 Result := FEnabled;
end;

function TPrismOptionSecurity.IP: IPrismOptionSecurityIP;
begin
 result:= FIP;
end;

procedure TPrismOptionSecurity.LoadDefaultSecurity;
begin
 if FEnabled and (not FLoadDefaultSecurity) then
 begin
  (IP.IPv4BlackList as TPrismOptionSecurityIPv4BlackList).LoadDefaultIPv4Blacklist;
  (FUserAgent as TPrismOptionSecurityUserAgent).LoadDefaultBlockedUserAgent;

  FLoadDefaultSecurity:= true;
 end;
end;

procedure TPrismOptionSecurity.SetEnabled(const Value: Boolean);
begin
 FEnabled := Value;
end;

function TPrismOptionSecurity.UserAgent: IPrismOptionSecurityUserAgent;
begin
 result:= FUserAgent;
end;

end.
