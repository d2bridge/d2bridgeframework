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

{$I D2Bridge.inc}

unit D2Bridge.API.Mail.Config;

interface

uses
  Classes, SysUtils,
  D2Bridge.Interfaces
  {$IFDEF FMX}

  {$ELSE}

  {$ENDIF}
  ;


type
 TD2BridgeAPIMailConfig = class(TInterfacedPersistent, ID2BridgeAPIMailConfig)
  private
   FUseThread: boolean;
   FHost: string;
   FPassword: string;
   FPort: integer;
   FUserName: string;
   FUserSSL: boolean;
   FUseTLS: boolean;
   function GetUseThread: boolean;
   procedure SetHost(const Value: string);
   procedure SetPassword(const Value: string);
   procedure SetPort(const Value: integer);
   procedure SetUserName(const Value: string);
   procedure SetUseSSL(const Value: boolean);
   procedure SetUseThread(const Value: boolean);
   procedure SetUseTLS(const Value: boolean);
   function GetHost: string;
   function GetPassword: string;
   function GetPort: integer;
   function GetUserName: string;
   function GetUseSSL: boolean;
   function GetUseTLS: boolean;
  public
   constructor Create;

   property Host: string read GetHost write SetHost;
   property Port: integer read GetPort write SetPort;
   property UserName: string read GetUserName write SetUserName;
   property Password: string read GetPassword write SetPassword;
   property UseSSL: boolean read GetUseSSL write SetUseSSL;
   property UseTLS: boolean read GetUseTLS write SetUseTLS;
   property UseThread: boolean read GetUseThread write SetUseThread;
 end;


implementation

{ TD2BridgeAPIMailConfig }

constructor TD2BridgeAPIMailConfig.Create;
begin
 inherited;

 FUseThread:= true;
 FUserSSL:= true;
 FUseTLS:= false;
end;

function TD2BridgeAPIMailConfig.GetHost: string;
begin
 Result:= FHost;
end;

function TD2BridgeAPIMailConfig.GetPassword: string;
begin
 Result:= FPassword;
end;

function TD2BridgeAPIMailConfig.GetPort: integer;
begin
 Result:= FPort;
end;

function TD2BridgeAPIMailConfig.GetUserName: string;
begin
 Result:= FUserName;
end;

function TD2BridgeAPIMailConfig.GetUseSSL: boolean;
begin
 Result:= FUserSSL;
end;

function TD2BridgeAPIMailConfig.GetUseThread: boolean;
begin
 result:= FUseThread;
end;

function TD2BridgeAPIMailConfig.GetUseTLS: boolean;
begin
 Result:= FUseTLS;
end;

procedure TD2BridgeAPIMailConfig.SetHost(const Value: string);
begin
 FHost:= Value;
end;

procedure TD2BridgeAPIMailConfig.SetPassword(const Value: string);
begin
 FPassword:= Value;
end;

procedure TD2BridgeAPIMailConfig.SetPort(const Value: integer);
begin
 FPort:= Value;
end;

procedure TD2BridgeAPIMailConfig.SetUserName(const Value: string);
begin
 FUserName:= Value;
end;

procedure TD2BridgeAPIMailConfig.SetUseSSL(const Value: boolean);
begin
 FUserSSL:= Value;
end;

procedure TD2BridgeAPIMailConfig.SetUseThread(const Value: boolean);
begin
 FUseThread:= Value;
end;

procedure TD2BridgeAPIMailConfig.SetUseTLS(const Value: boolean);
begin
 FUseTLS:= Value;
end;

end.