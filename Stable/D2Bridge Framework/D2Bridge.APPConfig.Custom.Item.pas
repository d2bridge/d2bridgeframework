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

unit D2Bridge.APPConfig.Custom.Item;

interface

uses
 Classes, SysUtils, IniFiles, Generics.Collections,
 D2Bridge.Interfaces;


type
 TD2BridgeAPPConfigCustomItem = class(TInterfacedPersistent, ID2BridgeAPPConfigCustomItem)
  private
   FKey: string;
   FValue: string;
   FAPPConfig: ID2BridgeAPPConfig;
   function GetKey: string;
   function GetValue: string;
   procedure SetKey(const Value: string);
   procedure SetValue(const Value: string);
   function INISection: string;
  public
   constructor Create(APPConfig: ID2BridgeAPPConfig); reintroduce;

   property Key: string read GetKey write SetKey;
   property Value: string read GetValue write SetValue;
 end;



implementation

Uses
 D2Bridge.Instance;

constructor TD2BridgeAPPConfigCustomItem.Create(
  APPConfig: ID2BridgeAPPConfig);
begin
 inherited Create;

 FAPPConfig:= APPConfig;
end;

function TD2BridgeAPPConfigCustomItem.GetKey: string;
begin
 Result := FKey;
end;

function TD2BridgeAPPConfigCustomItem.GetValue: string;
begin
 Result := FValue;
end;

function TD2BridgeAPPConfigCustomItem.INISection: string;
begin
 result:= 'App Config Custom Item';
end;

procedure TD2BridgeAPPConfigCustomItem.SetKey(const Value: string);
begin
 FKey := Value;

 if (not IsD2DockerContext) and (FKey <> '') then
 begin
  FValue := FAPPConfig.FileINIConfig.ReadString(INISection, FKey, '');

  if FValue = '' then
   SetValue(FValue);
 end;
end;

procedure TD2BridgeAPPConfigCustomItem.SetValue(const Value: string);
begin
 FValue := Value;

 if (not IsD2DockerContext) and (FKey <> '') then
  FAPPConfig.FileINIConfig.WriteString(INISection, FKey, Value);
end;

end.
