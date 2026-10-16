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

unit D2Bridge.APPConfig.Path;

interface

uses
 Classes, SysUtils, IniFiles,
{$IFDEF MSWINDOWS}
 windows,
{$ENDIF}
 D2Bridge.Interfaces;

type
 TD2BridgeAPPConfigPath = class(TInterfacedPersistent, ID2BridgeAPPConfigPath)
  private
   FApp: string;
   FData: string;
   function GetData: string;
   procedure SetData(const Value: string);
  public
   constructor Create;

  published
   function App: string;
   function wwwroot: string;
   function DB: string;
   function Script: string;

   property Data: string read GetData write SetData;
 end;

implementation

Uses
 Prism.BaseClass;

function TD2BridgeAPPConfigPath.App: string;
var
 Buffer: array[0..MAX_PATH-1] of Char;
begin
 if FApp = '' then
 begin
{$IFDEF D2DOCKER}
  SetString(FApp, Buffer, GetModuleFileName(hInstance, Buffer, MAX_PATH));
  FApp:= ExtractFilePath(FApp);
{$ELSE}
  FApp:= ExtractFilePath(ParamStr(0));
{$ENDIF}
 end;

 result:= FApp;
end;

constructor TD2BridgeAPPConfigPath.Create;
begin
 inherited;

 FApp:= '';
end;

function TD2BridgeAPPConfigPath.DB: string;
begin
 result:= ExpandFileName(App + '..' + PathDelim + 'db' + PathDelim);
end;

function TD2BridgeAPPConfigPath.GetData: string;
begin
 if FData <> '' then
  Result:= FData
 else
  Result:= FApp
end;

function TD2BridgeAPPConfigPath.Script: string;
begin
 result:= ExpandFileName(App + '..' + PathDelim + 'script' + PathDelim);
end;

procedure TD2BridgeAPPConfigPath.SetData(const Value: string);
begin
 FData := IncludeTrailingPathDelimiter(Value);
end;

function TD2BridgeAPPConfigPath.wwwroot: string;
begin
 result:= IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(App) + PrismBaseClass.Options.RootDirectory)
end;

end.