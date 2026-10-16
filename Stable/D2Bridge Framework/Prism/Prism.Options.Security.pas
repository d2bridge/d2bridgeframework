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
  D2Bridge.Rest.Interfaces,
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
   function Rest: ID2BridgeRestSecurity;

   property Enabled: Boolean read GetEnabled write SetEnabled;
 end;


implementation

uses
  Prism.BaseClass,
  Prism.Options.Security.IP, Prism.Options.Security.UserAgent,
  Prism.Options.Security.IPv4.Blacklist,
  D2Bridge.Rest;


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

function TPrismOptionSecurity.Rest: ID2BridgeRestSecurity;
begin
 result:= PrismBaseClass.Rest.Security;
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