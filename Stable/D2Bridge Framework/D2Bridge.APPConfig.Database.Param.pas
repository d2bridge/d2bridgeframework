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

unit D2Bridge.APPConfig.Database.Param;

interface

uses
 Classes, SysUtils, IniFiles,
 D2Bridge.Interfaces;

type
 TD2BridgeAPPConfigDatabaseParam = class(TInterfacedPersistent, ID2BridgeAPPConfigDatabaseParam)
  private
   FAppConfig: ID2BridgeAPPConfig;
   FMultiTenancy: boolean;
   FDatabaseType: string;
   FDatabase: string;
   FDatabaseFile: string;
   FHost: string;
   FPassword: string;
   FPort: Integer;
   FD2BridgeAPPConfigDatabase: ID2BridgeAPPConfigDatabase;
   FUser: string;
   FINIReference: boolean;
   function INISection: string;
   function GetDatabase: string;
   function GetDatabaseFile: string;
   function GetHost: string;
   function GetPassword: string;
   function GetPort: Integer;
   function GetUser: string;
   procedure SetDatabase(const Value: string);
   procedure SetDatabaseFile(const Value: string);
   procedure SetHost(const Value: string);
   procedure SetPassword(const Value: string);
   procedure SetPort(const Value: Integer);
   procedure SetUser(const Value: string);
   procedure LoadFromINI;
   procedure CreateToINI;
  public
   constructor Create(AappConfig: ID2BridgeAPPConfig; AD2BridgeAPPConfigDatabase: ID2BridgeAPPConfigDatabase; ADatabaseType: string; AMultiTenancy: boolean = false); reintroduce;

  published
   property Database: string read GetDatabase write SetDatabase;
   property DatabaseFile: string read GetDatabaseFile write SetDatabaseFile;
   property Host: string read GetHost write SetHost;
   property Password: string read GetPassword write SetPassword;
   property Port: Integer read GetPort write SetPort;
   property User: string read GetUser write SetUser;
 end;

implementation

Uses
 D2Bridge.Instance;

{ TD2BridgeAPPConfigDatabaseParam }

constructor TD2BridgeAPPConfigDatabaseParam.Create(AappConfig: ID2BridgeAPPConfig; AD2BridgeAPPConfigDatabase: ID2BridgeAPPConfigDatabase; ADatabaseType: string; AMultiTenancy: boolean = false);
begin
 FINIReference:= false;

 FAppConfig:= AappConfig;
 FD2BridgeAPPConfigDatabase:= AD2BridgeAPPConfigDatabase;

 FDatabaseType:= ADatabaseType;
 FMultiTenancy:= AMultiTenancy;

 if not IsD2DockerContext then
  LoadFromINI;
end;

procedure TD2BridgeAPPConfigDatabaseParam.CreateToINI;
begin
 FAppConfig.FileINIConfig.WriteString(INISection, 'DatabaseType', FDatabaseType);
 FAppConfig.FileINIConfig.WriteString(INISection, 'Database', FDatabase);
 FAppConfig.FileINIConfig.WriteString(INISection, 'File', FDatabaseFile);
 FAppConfig.FileINIConfig.WriteString(INISection, 'Host', FHost);
 FAppConfig.FileINIConfig.WriteInteger(INISection, 'Port', FPort);
 FAppConfig.FileINIConfig.WriteString(INISection, 'User', FUser);
 FAppConfig.FileINIConfig.WriteString(INISection, 'Password', FPassword);

 FINIReference:= true;
end;

function TD2BridgeAPPConfigDatabaseParam.GetDatabase: string;
begin
 Result := FDatabase;

 if (not IsD2DockerContext) and (not FINIReference) then
  CreateToINI;
end;

function TD2BridgeAPPConfigDatabaseParam.GetDatabaseFile: string;
begin
 Result := FDatabaseFile;

 if (not IsD2DockerContext) and (not FINIReference) then
  CreateToINI;

end;

function TD2BridgeAPPConfigDatabaseParam.GetHost: string;
begin
 Result := FHost;

 if (not IsD2DockerContext) and (not FINIReference) then
  CreateToINI;

end;

function TD2BridgeAPPConfigDatabaseParam.GetPassword: string;
begin
 Result := FPassword;

 if (not IsD2DockerContext) and (not FINIReference) then
  CreateToINI;
end;

function TD2BridgeAPPConfigDatabaseParam.GetPort: Integer;
begin
 Result := FPort;

 if (not IsD2DockerContext) and (not FINIReference) then
  CreateToINI;

end;

function TD2BridgeAPPConfigDatabaseParam.GetUser: string;
begin
 Result := FUser;

 if (not IsD2DockerContext) and (not FINIReference) then
  CreateToINI;

end;

function TD2BridgeAPPConfigDatabaseParam.INISection: string;
begin
 result:= 'App Config ' + FDatabaseType + '';
 if FMultiTenancy then
  result:= result + ' Tenancy';
end;

procedure TD2BridgeAPPConfigDatabaseParam.LoadFromINI;
begin
 FINIReference:= FAppConfig.FileINIConfig.ReadString(INISection, 'DatabaseType', '') = FDatabaseType;
 FDatabase:= FAppConfig.FileINIConfig.ReadString(INISection, 'Database', '');
 FDatabaseFile:= FAppConfig.FileINIConfig.ReadString(INISection, 'File', '');
 FHost:= FAppConfig.FileINIConfig.ReadString(INISection, 'Host', '');
 FPort:= FAppConfig.FileINIConfig.ReadInteger(INISection, 'Port', 0);
 FUser:= FAppConfig.FileINIConfig.ReadString(INISection, 'User', '');
 FPassword:= FAppConfig.FileINIConfig.ReadString(INISection, 'Password', '');
end;

procedure TD2BridgeAPPConfigDatabaseParam.SetDatabase(const Value: string);
begin
 FDatabase := Value;

 if (not IsD2DockerContext) then
  FAppConfig.FileINIConfig.WriteString(INISection, 'Database', Value);
end;

procedure TD2BridgeAPPConfigDatabaseParam.SetDatabaseFile(const Value: string);
begin
 FDatabaseFile := Value;

 if (not IsD2DockerContext) then
  FAppConfig.FileINIConfig.WriteString(INISection, 'File', Value);
end;

procedure TD2BridgeAPPConfigDatabaseParam.SetHost(const Value: string);
begin
 FHost := Value;

 if (not IsD2DockerContext) then
  FAppConfig.FileINIConfig.WriteString(INISection, 'Host', Value);
end;

procedure TD2BridgeAPPConfigDatabaseParam.SetPassword(const Value: string);
begin
 FPassword := Value;

 if (not IsD2DockerContext) then
  FAppConfig.FileINIConfig.WriteString(INISection, 'Password', Value);
end;

procedure TD2BridgeAPPConfigDatabaseParam.SetPort(const Value: Integer);
begin
 FPort := Value;

 if (not IsD2DockerContext) then
  FAppConfig.FileINIConfig.WriteInteger(INISection, 'Port', Value);
end;

procedure TD2BridgeAPPConfigDatabaseParam.SetUser(const Value: string);
begin
 FUser := Value;

 if (not IsD2DockerContext) then
  FAppConfig.FileINIConfig.WriteString(INISection, 'User', Value);
end;

end.
