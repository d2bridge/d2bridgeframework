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

unit D2Bridge.APPConfig;

interface

uses
 Classes, SysUtils, IniFiles,
 D2Bridge.Interfaces;


type
 TD2BridgeAPPConfig = class(TInterfacedPersistent, ID2BridgeAPPConfig)
  private
   FFileINIConfig: TIniFile;
   FConfigCustom: ID2BridgeAPPConfigCustom;
   FConfigDatabase: ID2BridgeAPPConfigDatabase;
   FConfigDatabaseTenancy: ID2BridgeAPPConfigDatabase;
   FVersion: ID2BridgeAPPConfigVersion;
   FPath: ID2BridgeAPPConfigPath;
   FINIConfig: ID2BridgeAPPConfigINIConfig;
  public
   constructor Create;
   destructor Destroy; override;

  published
   function ServerPort(ADefaultPort: Integer = 8888): Integer;
   function ServerName(ADefaultServerName: String = 'D2Bridge Server'): String;
   function ServerDescription(ADefaultServerDescription: String = 'D2Bridge Primary Server'): String;

   function Version: ID2BridgeAPPConfigVersion;

   function Custom: ID2BridgeAPPConfigCustom;
   function Database: ID2BridgeAPPConfigDatabase;
   function DatabaseTenancy: ID2BridgeAPPConfigDatabase;
   function Path: ID2BridgeAPPConfigPath;

   function FileINIConfig: TIniFile;

{$IFDEF D2DOCKER}
   procedure ParserD2DockerAppConfig(AConfigJSONStr: string);
{$ENDIF}

   function INIConfig: ID2BridgeAPPConfigINIConfig;

 end;

implementation

Uses
 D2Bridge.APPConfig.Database, D2Bridge.AppConfig.Version, D2Bridge.AppConfig.Path, D2Bridge.APPConfig.INIConfig,
 D2Bridge.APPConfig.Custom, D2Bridge.JSON;

{ TD2BridgeAPPConfig }

constructor TD2BridgeAPPConfig.Create;
begin
 FPath:= TD2BridgeAPPConfigPath.Create;

 //FFileINIConfig:= TIniFile.Create(ExtractFilePath(GetModuleName(HInstance))+'Config.ini');
 FFileINIConfig:= TIniFile.Create(FPath.App + 'Config.ini');

 FConfigCustom:= TD2BridgeAPPConfigCustom.Create(self);
 FConfigDatabase:= TD2BridgeAPPConfigDatabase.Create(self);
 FConfigDatabaseTenancy:= TD2BridgeAPPConfigDatabase.Create(self);
 FVersion:= TD2BridgeAPPConfigVersion.Create;
 FINIConfig:= TD2BridgeAPPConfigINIConfig.Create(Self);

end;

function TD2BridgeAPPConfig.Custom: ID2BridgeAPPConfigCustom;
begin
 result:= FConfigCustom;
end;

function TD2BridgeAPPConfig.Database: ID2BridgeAPPConfigDatabase;
begin
 result:= FConfigDatabase;
end;

function TD2BridgeAPPConfig.DatabaseTenancy: ID2BridgeAPPConfigDatabase;
begin
 result:= FConfigDatabaseTenancy;
end;

destructor TD2BridgeAPPConfig.Destroy;
var
 vVersion: TD2BridgeAPPConfigVersion;
 vDataBase, vDataBaseTenancy: TD2BridgeAPPConfigDatabase;
 vPath: TD2BridgeAPPConfigPath;
 vINIConfig: TD2BridgeAPPConfigINIConfig;
 vCustom: TD2BridgeAPPConfigCustom;
begin
 FFileINIConfig.Free;

 vCustom:= FConfigCustom as TD2BridgeAPPConfigCustom;
 FConfigCustom:= nil;
 vCustom.Free;

 vDataBase:= FConfigDatabase as TD2BridgeAPPConfigDatabase;
 FConfigDatabase:= nil;
 vDataBase.Free;

 vDataBaseTenancy:= FConfigDatabaseTenancy as TD2BridgeAPPConfigDatabase;
 FConfigDatabaseTenancy:= nil;
 vDataBaseTenancy.Free;

 vVersion:= FVersion as TD2BridgeAPPConfigVersion;
 FVersion:= nil;
 vVersion.Free;

 vPath:= FPath as TD2BridgeAPPConfigPath;
 FPath:= nil;
 vPath.Free;

 vINIConfig:= FINIConfig as TD2BridgeAPPConfigINIConfig;
 FINIConfig:= nil;
 vINIConfig.Free;

 inherited;
end;

function TD2BridgeAPPConfig.FileINIConfig: TIniFile;
begin
 Result:= FFileINIConfig;
end;

function TD2BridgeAPPConfig.INIConfig: ID2BridgeAPPConfigINIConfig;
begin
 result:= FINIConfig;
end;

{$IFDEF D2DOCKER}
procedure TD2BridgeAPPConfig.ParserD2DockerAppConfig(AConfigJSONStr: string);
var
 I: integer;
 vAppConfigVersion: Extended;
 vJSONRoot: TJSONObject;
 vJSONMethods: TJSONArray;
 vJSONConfig: TJSONObject;
 vDataBase: ID2BridgeAPPConfigDatabase;
 vDataBaseType: ID2BridgeAPPConfigDatabaseParam;
 vAppConfigType: string;
 vAppConfigName: string;
begin
 vJSONRoot:= nil;

 try
  vJSONRoot:= TJSONObject.ParseJSONValue(AConfigJSONStr) as TJSONObject;

  if Assigned(vJSONRoot) and (vJSONRoot.GetValue('appconfig') <> nil) then
  begin
   vJSONMethods:= vJSONRoot.GetValue('appconfig') as TJSONArray;

   if Assigned(vJSONMethods) and (vJSONMethods.Count > 0) then
   begin
    vAppConfigVersion:= (vJSONRoot.GetValue('version') as TJSONFloatNumber).{$IFnDEF FPC}AsDouble{$ELSE}AsFloat{$ENDIF};

    for I := 0 to Pred(vJSONMethods.Count) do
    begin
     vJSONConfig:= vJSONMethods[I] as TJSONObject;

     vAppConfigType:= vJSONConfig.GetValue('appconfigtype', '');
     vAppConfigName:= vJSONConfig.GetValue('appconfigname','');


     {$REGION 'Custom'}
      if SameText(vAppConfigType, 'custom') then
      begin
       FConfigCustom.Item[vAppConfigName].Value:= vJSONConfig.GetValue('value','');
      end;
     {$ENDREGION}


     {$REGION 'Database'}
      if SameText(vAppConfigType, 'database') or SameText(vAppConfigType, 'database Tenancy') then
      begin
       vDataBaseType:= nil;

       if SameText(vAppConfigType, 'database') then
        vDataBase:= FConfigDatabase
       else
        vDataBase:= FConfigDatabaseTenancy;

       if SameText(vAppConfigName, 'Firebird') then
        vDataBaseType:= vDataBase.Firebird
       else
       if SameText(vAppConfigName, 'Firebird 2.5') then
        vDataBaseType:= vDataBase.Firebird25
       else
       if SameText(vAppConfigName, 'Firebird 3.0') then
        vDataBaseType:= vDataBase.Firebird30
       else
       if SameText(vAppConfigName, 'Firebird 4.0') then
        vDataBaseType:= vDataBase.Firebird40
       else
       if SameText(vAppConfigName, 'Firebird 5.0') then
        vDataBaseType:= vDataBase.Firebird50
       else
       if SameText(vAppConfigName, 'MariaDB') then
        vDataBaseType:= vDataBase.MariaDB
       else
       if SameText(vAppConfigName, 'MySQL') then
        vDataBaseType:= vDataBase.MySQL
       else
       if SameText(vAppConfigName, 'PostgreSQL') then
        vDataBaseType:= vDataBase.PostgreSQL
       else
       if SameText(vAppConfigName, 'SQL Server') then
        vDataBaseType:= vDataBase.SQLServer
       else
       if SameText(vAppConfigName, 'Oracle') then
        vDataBaseType:= vDataBase.Oracle
       else
       if SameText(vAppConfigName, 'Custom') then
        vDataBaseType:= vDataBase.Custom;


       if Assigned(vDataBaseType) then
       begin
        vDataBaseType.Database:= vJSONConfig.GetValue('database','');
        vDataBaseType.DatabaseFile:= vJSONConfig.GetValue('file','');
        vDataBaseType.Host:= vJSONConfig.GetValue('host','');
        vDataBaseType.Port:= vJSONConfig.GetValue('port',0);
        vDataBaseType.User:= vJSONConfig.GetValue('user','');
        vDataBaseType.Password:= vJSONConfig.GetValue('password','');
       end;
      end;
     {$ENDREGION}

    end;
   end;
  end;
 except
 end;
end;
{$ENDIF}

function TD2BridgeAPPConfig.Path: ID2BridgeAPPConfigPath;
begin
 result:= FPath;
end;

function TD2BridgeAPPConfig.ServerDescription(ADefaultServerDescription: String): String;
begin
 Result:= FFileINIConfig.ReadString('D2Bridge Server Config', 'Server Name', ADefaultServerDescription);
end;

function TD2BridgeAPPConfig.ServerName(ADefaultServerName: String): String;
begin
 Result:= FFileINIConfig.ReadString('D2Bridge Server Config', 'Server Name', ADefaultServerName);
end;

function TD2BridgeAPPConfig.ServerPort(ADefaultPort: Integer): Integer;
begin
 Result:= FFileINIConfig.ReadInteger('D2Bridge Server Config', 'Server Port', ADefaultPort);
end;

function TD2BridgeAPPConfig.Version: ID2BridgeAPPConfigVersion;
begin
 result:= FVersion;
end;

end.
