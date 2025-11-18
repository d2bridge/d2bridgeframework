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

unit D2Bridge.APPConfig.INIConfig;

interface

uses
 Classes, SysUtils, IniFiles,
 D2Bridge.Interfaces;


type
 TD2BridgeAPPConfigINIConfig = class(TInterfacedPersistent, ID2BridgeAPPConfigINIConfig)
  private
   FD2BridgeAppCOnfig: ID2BridgeAPPConfig;
  public
   constructor Create(AD2BridgeAppConfig: ID2BridgeAPPConfig);
   destructor Destroy; override;

   function ServerPort(ADefaultPort: Integer): Integer;
   function ServerName(ADefaultServerName: String): String;
   function ServerDescription(ADefaultServerDescription: String): String;

   function FileINIConfig: TIniFile;

 end;


implementation

{ TD2BridgeAPPConfigINIConfig }

constructor TD2BridgeAPPConfigINIConfig.Create(AD2BridgeAppConfig: ID2BridgeAPPConfig);
begin
 inherited Create;

 FD2BridgeAppConfig:= AD2BridgeAppConfig;
end;

destructor TD2BridgeAPPConfigINIConfig.Destroy;
begin

  inherited;
end;

function TD2BridgeAPPConfigINIConfig.FileINIConfig: TIniFile;
begin
 result:= FD2BridgeAppCOnfig.FileINIConfig
end;

function TD2BridgeAPPConfigINIConfig.ServerDescription(ADefaultServerDescription: String): String;
begin
 result:= FD2BridgeAppCOnfig.ServerDescription(ADefaultServerDescription);
end;

function TD2BridgeAPPConfigINIConfig.ServerName(ADefaultServerName: String): String;
begin
 result:= FD2BridgeAppCOnfig.ServerName(ADefaultServerName);
end;

function TD2BridgeAPPConfigINIConfig.ServerPort(ADefaultPort: Integer): Integer;
begin
 result:= FD2BridgeAppCOnfig.ServerPort(ADefaultPort);
end;

end.