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

unit D2Bridge.APPConfig.Database;

interface

uses
 Classes, SysUtils, IniFiles,
 D2Bridge.Interfaces;

type
 TD2BridgeAPPConfigDatabase = class(TInterfacedPersistent, ID2BridgeAPPConfigDatabase)
  private
   FMultiTenancy: boolean;
   FAPPConfig: ID2BridgeAPPConfig;
   FFirebird: ID2BridgeAPPConfigDatabaseParam;
   FFirebird25: ID2BridgeAPPConfigDatabaseParam;
   FFirebird30: ID2BridgeAPPConfigDatabaseParam;
   FFirebird40: ID2BridgeAPPConfigDatabaseParam;
   FFirebird50: ID2BridgeAPPConfigDatabaseParam;
   FMariaDB: ID2BridgeAPPConfigDatabaseParam;
   FMySQL: ID2BridgeAPPConfigDatabaseParam;
   FPostgreSQL: ID2BridgeAPPConfigDatabaseParam;
   FSQLServer: ID2BridgeAPPConfigDatabaseParam;
   FOracle: ID2BridgeAPPConfigDatabaseParam;
   FCustom: ID2BridgeAPPConfigDatabaseParam;
   function GetFirebird: ID2BridgeAPPConfigDatabaseParam;
   function GetFirebird25: ID2BridgeAPPConfigDatabaseParam;
   function GetFirebird30: ID2BridgeAPPConfigDatabaseParam;
   function GetFirebird40: ID2BridgeAPPConfigDatabaseParam;
   function GetFirebird50: ID2BridgeAPPConfigDatabaseParam;
   function GetMariaDB: ID2BridgeAPPConfigDatabaseParam;
   function GetMySQL: ID2BridgeAPPConfigDatabaseParam;
   function GetPostgreSQL: ID2BridgeAPPConfigDatabaseParam;
   function GetSQLServer: ID2BridgeAPPConfigDatabaseParam;
   function GetOracle: ID2BridgeAPPConfigDatabaseParam;
   function GetCustom: ID2BridgeAPPConfigDatabaseParam;
  public
   constructor Create(APPConfig: ID2BridgeAPPConfig; AMultiTenancy: Boolean = false);
   destructor Destroy; override;

   property Firebird: ID2BridgeAPPConfigDatabaseParam read GetFirebird;
   property Firebird25: ID2BridgeAPPConfigDatabaseParam read GetFirebird25;
   property Firebird30: ID2BridgeAPPConfigDatabaseParam read GetFirebird30;
   property Firebird40: ID2BridgeAPPConfigDatabaseParam read GetFirebird40;
   property Firebird50: ID2BridgeAPPConfigDatabaseParam read GetFirebird50;
   property MariaDB: ID2BridgeAPPConfigDatabaseParam read GetMariaDB;
   property MySQL: ID2BridgeAPPConfigDatabaseParam read GetMySQL;
   property PostgreSQL: ID2BridgeAPPConfigDatabaseParam read GetPostgreSQL;
   property SQLServer: ID2BridgeAPPConfigDatabaseParam read GetSQLServer;
   property Oracle: ID2BridgeAPPConfigDatabaseParam read GetOracle;
   property Custom: ID2BridgeAPPConfigDatabaseParam read GetCustom;
 end;

implementation

Uses
 D2Bridge.APPConfig.Database.Param;

{ TD2BridgeAPPConfigDatabase }

constructor TD2BridgeAPPConfigDatabase.Create(APPConfig: ID2BridgeAPPConfig; AMultiTenancy: Boolean);
begin
 FAPPConfig:= APPConfig;
 FMultiTenancy:= AMultiTenancy;

 FFirebird:= TD2BridgeAPPConfigDatabaseParam.Create(FAPPConfig, self, 'Firebird', AMultiTenancy);
 FFirebird25:= TD2BridgeAPPConfigDatabaseParam.Create(FAPPConfig, self, 'Firebird 2.5', AMultiTenancy);
 FFirebird30:= TD2BridgeAPPConfigDatabaseParam.Create(FAPPConfig, self, 'Firebird 3.0', AMultiTenancy);
 FFirebird40:= TD2BridgeAPPConfigDatabaseParam.Create(FAPPConfig, self, 'Firebird 4.0', AMultiTenancy);
 FFirebird50:= TD2BridgeAPPConfigDatabaseParam.Create(FAPPConfig, self, 'Firebird 5.0', AMultiTenancy);
 FMariaDB:= TD2BridgeAPPConfigDatabaseParam.Create(FAPPConfig, self, 'MariaDB', AMultiTenancy);
 FMySQL:= TD2BridgeAPPConfigDatabaseParam.Create(FAPPConfig, self, 'MySQL', AMultiTenancy);
 FPostgreSQL:= TD2BridgeAPPConfigDatabaseParam.Create(FAPPConfig, self, 'PostgreSQL', AMultiTenancy);
 FSQLServer:= TD2BridgeAPPConfigDatabaseParam.Create(FAPPConfig, self, 'SQL Server', AMultiTenancy);
 FOracle:= TD2BridgeAPPConfigDatabaseParam.Create(FAPPConfig, self, 'Oracle', AMultiTenancy);
 FCustom:= TD2BridgeAPPConfigDatabaseParam.Create(FAPPConfig, self, 'Custom Database', AMultiTenancy);
end;

destructor TD2BridgeAPPConfigDatabase.Destroy;
var
 vFirebird: TD2BridgeAPPConfigDatabaseParam;
 vFirebird25: TD2BridgeAPPConfigDatabaseParam;
 vFirebird30: TD2BridgeAPPConfigDatabaseParam;
 vFirebird40: TD2BridgeAPPConfigDatabaseParam;
 vFirebird50: TD2BridgeAPPConfigDatabaseParam;
 vMariaDB: TD2BridgeAPPConfigDatabaseParam;
 vMySQL: TD2BridgeAPPConfigDatabaseParam;
 vPostgreSQL: TD2BridgeAPPConfigDatabaseParam;
 vSQLServer: TD2BridgeAPPConfigDatabaseParam;
 vOracle: TD2BridgeAPPConfigDatabaseParam;
 vCustom: TD2BridgeAPPConfigDatabaseParam;
begin
 vFirebird:= FFirebird as TD2BridgeAPPConfigDatabaseParam;
 FFirebird:= nil;
 vFirebird.Free;

 vFirebird25:= FFirebird25 as TD2BridgeAPPConfigDatabaseParam;
 FFirebird25:= nil;
 vFirebird25.Free;

 vFirebird30:= FFirebird30 as TD2BridgeAPPConfigDatabaseParam;
 FFirebird30:= nil;
 vFirebird30.Free;

 vFirebird40:= FFirebird40 as TD2BridgeAPPConfigDatabaseParam;
 FFirebird40:= nil;
 vFirebird40.Free;

 vFirebird50:= FFirebird50 as TD2BridgeAPPConfigDatabaseParam;
 FFirebird50:= nil;
 vFirebird50.Free;

 vMariaDB:= FMariaDB as TD2BridgeAPPConfigDatabaseParam;
 FMariaDB:= nil;
 vMariaDB.Free;

 vMySQL:= FMySQL as TD2BridgeAPPConfigDatabaseParam;
 FMySQL:= nil;
 vMySQL.Free;

 vPostgreSQL:= FPostgreSQL as TD2BridgeAPPConfigDatabaseParam;
 FPostgreSQL:= nil;
 vPostgreSQL.Free;

 vSQLServer:= FSQLServer as TD2BridgeAPPConfigDatabaseParam;
 FSQLServer:= nil;
 vSQLServer.Free;

 vOracle:= FOracle as TD2BridgeAPPConfigDatabaseParam;
 FOracle:= nil;
 vOracle.Free;

 vCustom:= FOracle as TD2BridgeAPPConfigDatabaseParam;
 FCustom:= nil;
 vCustom.Free;

 inherited;
end;

function TD2BridgeAPPConfigDatabase.GetCustom: ID2BridgeAPPConfigDatabaseParam;
begin
 result:= FCustom;
end;

function TD2BridgeAPPConfigDatabase.GetFirebird: ID2BridgeAPPConfigDatabaseParam;
begin
 Result := FFirebird;
end;

function TD2BridgeAPPConfigDatabase.GetFirebird25: ID2BridgeAPPConfigDatabaseParam;
begin
 Result := FFirebird25;
end;

function TD2BridgeAPPConfigDatabase.GetFirebird30: ID2BridgeAPPConfigDatabaseParam;
begin
 Result := FFirebird30;
end;

function TD2BridgeAPPConfigDatabase.GetFirebird40: ID2BridgeAPPConfigDatabaseParam;
begin
 Result := FFirebird40;
end;

function TD2BridgeAPPConfigDatabase.GetFirebird50: ID2BridgeAPPConfigDatabaseParam;
begin
 Result := FFirebird50;
end;

function TD2BridgeAPPConfigDatabase.GetMariaDB: ID2BridgeAPPConfigDatabaseParam;
begin
 Result := FMariaDB;
end;

function TD2BridgeAPPConfigDatabase.GetMySQL: ID2BridgeAPPConfigDatabaseParam;
begin
 Result := FMySQL;
end;

function TD2BridgeAPPConfigDatabase.GetOracle: ID2BridgeAPPConfigDatabaseParam;
begin
 result:= FOracle;
end;

function TD2BridgeAPPConfigDatabase.GetPostgreSQL: ID2BridgeAPPConfigDatabaseParam;
begin
 Result := FPostgreSQL;
end;

function TD2BridgeAPPConfigDatabase.GetSQLServer: ID2BridgeAPPConfigDatabaseParam;
begin
 Result := FSQLServer;
end;

end.
