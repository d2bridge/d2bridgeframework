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

unit Prism.Options;

interface

uses
  Classes, SysUtils,
{$IFDEF HAS_UNIT_SYSTEM_IOUTILS}
  System.IOUtils,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
{$IFDEF FMX}

{$ELSE}

{$ENDIF}
  Prism.Interfaces, Prism.Types,
  Prism.DataWare.Mapped;

type
 TPrismOptions = class(TInterfacedPersistent, IPrismOptions)
  private
   FLang: string;
   FLoading: Boolean;
   FPathCSS: string;
   FPathJS: string;
   FPathFont: string;
   FRootDirectory: string;
   FIncludeSweetAlert2: Boolean;
   FIncludeJQuery: Boolean;
   FIncludeJQGrid: Boolean;
   FIncludeStyle: Boolean;
   FIncludeBootStrap: Boolean;
   FIncludeInputMask: Boolean;
   FForceCloseExpired: Boolean;
   FDataSetLog: Boolean;
   FUseSSL: Boolean;
   FUseINIConfig: Boolean;
   FDataBaseFormatSettings: TFormatSettings;
   FHTMLFormatSettings: TFormatSettings;
   FValidateAllControls: Boolean;
   FLogException: Boolean;
   FLogSecurity: Boolean;
   FLogAccess: Boolean;
   FPathLogException: string;
   FPathTemp: string;
   FPathTempSessions: string;
   FCoInitialize: boolean;
   FVCLStyles: boolean;
   FDataWareMapped: TPrismDataWareMapped;
   FSessionTimeOut: integer;
   FSessionIdleTimeOut: integer;
   FHeartBeatTime: integer;
   FShowError500Page: boolean;
   FSecurity: IPrismOptionSecurity;
   FUseMainThread: Boolean;
   FLogFileMode: TPrismLogFileMode;
   function GetLanguage: string;
   procedure SetLanguage(AValue: string);
   function GetLoading: Boolean;
   procedure SetLoading(AValue: Boolean);
   function GetPathCSS: string;
   procedure SetPathCSS(const Value: string);
   function GetRootDirectory: string;
   procedure SetRootDirectory(const Value: string);
   function GetPathJS: string;
   procedure SetPathJS(const Value: string);
   function GetIncludeJQGrid: Boolean;
   function GetIncludeJQuery: Boolean;
   function GetIncludeSweetAlert2: Boolean;
   procedure SetIncludeJQGrid(const Value: Boolean);
   procedure SetIncludeJQuery(const Value: Boolean);
   procedure SetIncludeSweetAlert2(const Value: Boolean);
   function GetIncludeStyle: Boolean;
   procedure SetIncludeStyle(const Value: Boolean);
   function GetForceCloseExpired: Boolean;
   procedure SetForceCloseExpired(AValue: Boolean);
   function GetDataSetLog: Boolean;
   procedure SetDataSetLog(const Value: Boolean);
   function GetUseSSL: Boolean;
   procedure SetUseSSL(const Value: Boolean);
   function GetUseINIConfig: Boolean;
   procedure SetUseINIConfig(const Value: Boolean);
   function GetValidateAllControls: Boolean;
   procedure SetValidateAllControls(const Value: Boolean);
   procedure SetLogException(const Value: Boolean);
   function GetLogException: boolean;
   function GetLogSecurity: Boolean;
   procedure SetLogSecurity(const Value: Boolean);
   function GetLogAccess: Boolean;
   procedure SetLogAccess(const Value: Boolean);
   function GetLogFileMode: TPrismLogFileMode;
   procedure SetLogFileMode(const Value: TPrismLogFileMode);
   procedure SetPathLogException(const Value: string);
   function GetPathLogException: string;
   procedure SetCoInitialize(const Value: Boolean);
   function GetCoInitialize: Boolean;
   procedure SetVCLStyles(const Value: Boolean);
   function GetVCLStyles: Boolean;
   function GetDataBaseFormatSettings: TFormatSettings;
   procedure SetDataBaseFormatSettings(Value: TFormatSettings);
   function GetHTMLFormatSettings: TFormatSettings;
   procedure SetHTMLFormatSettings(Value: TFormatSettings);
   procedure SetDataWareMapped(const Value: TPrismDataWareMapped);
   function GetDataWareMapped: TPrismDataWareMapped;
   procedure SetSessionTimeOut(const Value: Integer);
   function GetSessionTimeOut: integer;
   procedure SetSessionIdleTimeOut(const Value: Integer);
   function GetSessionIdleTimeOut: integer;
   function GetIncludeBootStrap: Boolean;
   procedure SetIncludeBootStrap(const Value: Boolean);
   function GetIncludeInputMask: Boolean;
   procedure SetIncludeInputMask(const Value: Boolean);
   function GetHeartBeatTime: integer;
   procedure SetHeartBeatTime(const Value: integer);
   function GetShowError500Page: boolean;
   function GetUseMainThread: Boolean;
   procedure SetShowError500Page(const Value: boolean);
   procedure SetUseMainThread(const Value: Boolean);
   function GetPathFont: string;
   procedure SetPathFont(const Value: string);
   function GetPathTemp: string;
   function GetPathTempSessions: string;
   procedure SetPathTemp(const Value: string);
   procedure SetPathTempSessions(const Value: string);
  public
   constructor Create;
   destructor Destroy; override;

   function LogFile: string;
   function Security: IPrismOptionSecurity;

   property Language: string read GetLanguage write SetLanguage;
   property Loading: boolean read GetLoading write SetLoading;
   property PathCSS: string read GetPathCSS write SetPathCSS;
   property PathJS: string read GetPathJS write SetPathJS;
   property PathFont: string read GetPathFont write SetPathFont;
   property PathTemp: string read GetPathTemp write SetPathTemp;
   property PathTempSessions: string read GetPathTempSessions write SetPathTempSessions;
   property RootDirectory: string read GetRootDirectory write SetRootDirectory;
   property IncludeSweetAlert2: Boolean read GetIncludeSweetAlert2 write SetIncludeSweetAlert2;
   property IncludeJQuery: Boolean read GetIncludeJQuery write SetIncludeJQuery;
   property IncludeJQGrid: Boolean read GetIncludeJQGrid write SetIncludeJQGrid;
   property IncludeBootStrap: Boolean read GetIncludeBootStrap write SetIncludeBootStrap;
   property IncludeInputMask: Boolean read GetIncludeInputMask write SetIncludeInputMask;
   property IncludeStyle: Boolean read GetIncludeStyle write SetIncludeStyle;
   property ValidateAllControls: Boolean read GetValidateAllControls write SetValidateAllControls;
   property DataSetLog: Boolean read GetDataSetLog write SetDataSetLog;
   property UseINIConfig: Boolean read GetUseINIConfig write SetUseINIConfig;
   property SSL: Boolean read GetUseSSL write SetUseSSL;
   property LogException: Boolean read GetLogException write SetLogException;
   property LogSecurity: Boolean read GetLogSecurity write SetLogSecurity;
   property LogAccess: Boolean read GetLogAccess write SetLogAccess;
   property LogFileMode: TPrismLogFileMode read GetLogFileMode write SetLogFileMode;
   property PathLogException: string read GetPathLogException write SetPathLogException;
   property CoInitialize: boolean read GetCoInitialize write SetCoInitialize;
   property VCLStyles: boolean read GetVCLStyles write SetVCLStyles;
   property DataBaseFormatSettings: TFormatSettings read GetDataBaseFormatSettings Write SetDataBaseFormatSettings;
   property HTMLFormatSettings: TFormatSettings read GetHTMLFormatSettings write SetHTMLFormatSettings;
   property DataWareMapped: TPrismDataWareMapped read GetDataWareMapped write SetDataWareMapped;
   property SessionTimeOut: integer read GetSessionTimeOut write SetSessionTimeOut;
   property SessionIdleTimeOut: integer read GetSessionIdleTimeOut write SetSessionIdleTimeOut;
   property HeartBeatTime: integer read GetHeartBeatTime write SetHeartBeatTime;
   property ShowError500Page: boolean read GetShowError500Page write SetShowError500Page;
   property UseMainThread: Boolean read GetUseMainThread write SetUseMainThread;

 end;

const
  TimeWaitTimeOutSession    = 300000;
  TimeWaitDisconnectSession = 30000;
  TimeWaitIdleSession       = 0;
  TimeHeartBeat             = 60000;

implementation

uses
  Prism.Options.Security,
  Prism.BaseClass;

constructor TPrismOptions.Create;
begin
  Language:= 'en-US';
  FLoading:= true;
  FPathCSS:= 'css';
  FPathJS:= 'js';
  FPathFont:= 'font';
  FPathTemp:= 'temp';
  FPathTempSessions:= 'Sessions';
  FRootDirectory:= 'wwwroot' + PathDelim;
  FIncludeSweetAlert2:= true;
  FIncludeJQuery:= false;
  FIncludeJQGrid:= true;
  FIncludeStyle:= true;
  FIncludeBootStrap:= true;
  FIncludeInputMask:= true;
  FForceCloseExpired:= false;
  FDataSetLog:= false;
  FUseSSL:= false;
  FUseINIConfig:= true;
  FValidateAllControls:= false;
  FLogException:= {$IFDEF MSWINDOWS}not IsDebuggerPresent{$ELSE}false{$ENDIF};
  FLogSecurity:= {$IFDEF MSWINDOWS}not IsDebuggerPresent{$ELSE}false{$ENDIF};
  PathLogException:= 'log' + PathDelim;
  FCoInitialize:= false;
  FVCLStyles:= true;
  FShowError500Page:= IsDebuggerPresent;
  FUseMainThread:= true;
  FLogAccess:= false;
  FLogFileMode:= lfmPerSession;

  FSessionTimeOut:= TimeWaitTimeOutSession div 1000;
  FSessionIdleTimeOut:= TimeWaitIdleSession div 1000;
  FHeartBeatTime:= TimeHeartBeat;

{$IFNDEF FPC}
  FDataBaseFormatSettings:= TFormatSettings.Create(Language);
{$ELSE}
  FDataBaseFormatSettings:= DefaultFormatSettings;

  {$IFDEF MSWINDOWS}
  GetLocaleFormatSettings(GetLocaleLang(Language), FDataBaseFormatSettings);
  {$ENDIF}
{$ENDIF}

  FDataBaseFormatSettings.ShortDateFormat := 'yyyy-mm-dd';
  FDataBaseFormatSettings.DateSeparator:= '-';
  FDataBaseFormatSettings.DecimalSeparator:= '.';
  FDataBaseFormatSettings.ThousandSeparator:= ',';
  FDataBaseFormatSettings.ShortTimeFormat:= 'hh:nn';
  FDataBaseFormatSettings.LongTimeFormat:= 'hh:nn:ss';

{$IFNDEF FPC}
  FHTMLFormatSettings:= TFormatSettings.Create(Language);
{$ELSE}
  FHTMLFormatSettings:= DefaultFormatSettings;

  {$IFDEF MSWINDOWS}
  GetLocaleFormatSettings(GetLocaleLang(Language), FHTMLFormatSettings);
  {$ENDIF}
{$ENDIF}

  FHTMLFormatSettings.ShortDateFormat := 'yyyy-mm-dd';
  FHTMLFormatSettings.DateSeparator:= '-';
  FHTMLFormatSettings.DecimalSeparator:= '.';
  FHTMLFormatSettings.ThousandSeparator:= #0;
  FHTMLFormatSettings.ShortTimeFormat:= 'hh:nn';
  FHTMLFormatSettings.LongTimeFormat:= 'hh:nn:ss';

  FDataWareMapped:= TPrismDataWareMapped.Create;
  FSecurity:= TPrismOptionSecurity.Create;
end;

destructor TPrismOptions.Destroy;
var
 vSecurity: TPrismOptionSecurity;
begin
  FreeAndNil(FDataWareMapped);

  vSecurity:= FSecurity as TPrismOptionSecurity;
  FSecurity:= nil;
  vSecurity.Free;

  inherited;
end;

function TPrismOptions.GetCoInitialize: Boolean;
begin
  Result:= FCoInitialize;
end;

function TPrismOptions.GetDataBaseFormatSettings: TFormatSettings;
begin
  Result:= FDataBaseFormatSettings;
end;

function TPrismOptions.GetDataSetLog: Boolean;
begin
  Result:= FDataSetLog;
end;

function TPrismOptions.GetDataWareMapped: TPrismDataWareMapped;
begin
  Result:= FDataWareMapped;
end;

function TPrismOptions.GetForceCloseExpired: Boolean;
begin
  Result:= FForceCloseExpired;
end;

function TPrismOptions.GetHeartBeatTime: integer;
begin
  Result:= FHeartBeatTime;
end;

function TPrismOptions.GetHTMLFormatSettings: TFormatSettings;
begin
  Result:= FHTMLFormatSettings;
end;

function TPrismOptions.GetIncludeBootStrap: Boolean;
begin
  Result:= FIncludeBootStrap;
end;

function TPrismOptions.GetIncludeInputMask: Boolean;
begin
  Result:= FIncludeInputMask;
end;

function TPrismOptions.GetIncludeJQGrid: Boolean;
begin
  Result:= FIncludeJQGrid;
end;

function TPrismOptions.GetIncludeJQuery: Boolean;
begin
  Result:= FIncludeJQuery;
end;

function TPrismOptions.GetIncludeStyle: Boolean;
begin
  Result:= FIncludeStyle;
end;

function TPrismOptions.GetIncludeSweetAlert2: Boolean;
begin
  Result:= FIncludeSweetAlert2;
end;

function TPrismOptions.GetLanguage: string;
begin
  Result:= FLang;
end;

function TPrismOptions.GetLoading: Boolean;
begin
  Result:= FLoading;
end;

function TPrismOptions.GetLogAccess: Boolean;
begin
 result:= FLogAccess;
end;

function TPrismOptions.GetLogException: boolean;
begin
  Result:= FLogException;
end;

function TPrismOptions.GetLogSecurity: Boolean;
begin
 result:= FLogSecurity;
end;

function TPrismOptions.GetPathCSS: string;
begin
  Result:= FPathCSS;
end;

function TPrismOptions.GetPathFont: string;
begin
 Result:= FPathFont;
end;

function TPrismOptions.GetPathJS: string;
begin
  Result:= FPathJS;
end;

function TPrismOptions.GetPathLogException: string;
begin
 Result:= FPathLogException;

{$IFDEF D2DOCKER}
  result:= IncludeTrailingPathDelimiter(Result + PrismBaseClass.ServerController.D2DockerInstanceAlias);
{$ENDIF}
end;

function TPrismOptions.GetPathTemp: string;
begin
 result:= IncludeTrailingPathDelimiter(FPathTemp);

{$IFDEF D2DOCKER}
  result:= IncludeTrailingPathDelimiter(result + PrismBaseClass.ServerController.D2DockerInstanceAlias);
{$ENDIF}
end;

function TPrismOptions.GetPathTempSessions: string;
begin
 result:= IncludeTrailingPathDelimiter(PathTemp + FPathTempSessions);
end;

function TPrismOptions.GetRootDirectory: string;
begin
  Result:= FRootDirectory;
end;

function TPrismOptions.GetSessionIdleTimeOut: integer;
begin
  Result:= FSessionIdleTimeOut;
end;

function TPrismOptions.GetSessionTimeOut: integer;
begin
  Result:= FSessionTimeOut;
end;

function TPrismOptions.GetShowError500Page: boolean;
begin
  Result:= FShowError500Page;
end;

function TPrismOptions.GetUseINIConfig: Boolean;
begin
  Result:= FUseINIConfig;
end;

function TPrismOptions.GetUseMainThread: Boolean;
begin
 Result := FUseMainThread;
end;

function TPrismOptions.GetUseSSL: Boolean;
begin
  Result:= FUseSSL;
end;

function TPrismOptions.GetValidateAllControls: Boolean;
begin
  Result:= FValidateAllControls;
end;

function TPrismOptions.GetVCLStyles: Boolean;
begin
  Result:= FVCLStyles;
end;

function TPrismOptions.LogFile: string;
var
  vDateTime: string;
begin
  case FLogFileMode of
    lfmDaily:
      Result:= PathLogException + FormatDateTime('yyyy_mm_dd', Now) + '.txt';
  else
    begin
      vDateTime:= DateTimeToStr(Now);
      vDateTime:= StringReplace(vDateTime, '-', '_', [rfReplaceAll]);
      vDateTime:= StringReplace(vDateTime, '/', '_', [rfReplaceAll]);
      vDateTime:= StringReplace(vDateTime, ':', '_', [rfReplaceAll]);
      vDateTime:= StringReplace(vDateTime, ' ', '_', [rfReplaceAll]);
      Result:= PathLogException + vDateTime + '.txt';
    end;
  end;
end;

function TPrismOptions.GetLogFileMode: TPrismLogFileMode;
begin
  Result:= FLogFileMode;
end;

procedure TPrismOptions.SetLogFileMode(const Value: TPrismLogFileMode);
begin
  FLogFileMode:= Value;
end;

function TPrismOptions.Security: IPrismOptionSecurity;
begin
  Result:= FSecurity;
end;

procedure TPrismOptions.SetCoInitialize(const Value: Boolean);
begin
  FCoInitialize:= Value;
end;

procedure TPrismOptions.SetDataBaseFormatSettings(Value: TFormatSettings);
begin
  FDataBaseFormatSettings:= Value;
end;

procedure TPrismOptions.SetDataSetLog(const Value: Boolean);
begin
  FDataSetLog:= Value;
end;

procedure TPrismOptions.SetDataWareMapped(const Value: TPrismDataWareMapped);
begin
  FDataWareMapped:= Value;
end;

procedure TPrismOptions.SetForceCloseExpired(AValue: Boolean);
begin
  FForceCloseExpired:= AValue;
end;

procedure TPrismOptions.SetHeartBeatTime(const Value: integer);
begin
  FHeartBeatTime:= Value * 1000;
end;

procedure TPrismOptions.SetHTMLFormatSettings(Value: TFormatSettings);
begin
  FHTMLFormatSettings:= Value;
end;

procedure TPrismOptions.SetIncludeBootStrap(const Value: Boolean);
begin
  FIncludeBootStrap:= Value;
end;

procedure TPrismOptions.SetIncludeInputMask(const Value: Boolean);
begin
  FIncludeInputMask:= Value;
end;

procedure TPrismOptions.SetIncludeJQGrid(const Value: Boolean);
begin
  FIncludeJQGrid:= Value;
end;

procedure TPrismOptions.SetIncludeJQuery(const Value: Boolean);
begin
  FIncludeJQuery:= Value;
end;

procedure TPrismOptions.SetIncludeStyle(const Value: Boolean);
begin
  FIncludeStyle:= Value;
end;

procedure TPrismOptions.SetIncludeSweetAlert2(const Value: Boolean);
begin
  FIncludeSweetAlert2:= Value;
end;

procedure TPrismOptions.SetLanguage(AValue: string);
begin
  FLang:= AValue;
end;

procedure TPrismOptions.SetLoading(AValue: Boolean);
begin
  FLoading:= AValue;
end;

procedure TPrismOptions.SetLogAccess(const Value: Boolean);
begin
 FLogAccess:= Value;
end;

procedure TPrismOptions.SetLogException(const Value: Boolean);
begin
  FLogException:= Value;
end;

procedure TPrismOptions.SetLogSecurity(const Value: Boolean);
begin
 FLogSecurity:= Value;
end;

procedure TPrismOptions.SetPathCSS(const Value: string);
begin
  FPathCSS:= Value;
end;

procedure TPrismOptions.SetPathFont(const Value: string);
begin
 FPathFont:= Value;
end;

procedure TPrismOptions.SetPathJS(const Value: string);
begin
  FPathJS:= Value;
end;

procedure TPrismOptions.SetPathLogException(const Value: string);
begin
  FPathLogException:= Value;

  try
{$IFDEF HAS_UNIT_SYSTEM_IOUTILS}
    if not DirectoryExists(TPath.GetDirectoryName(FPathLogException)) then
      TDirectory.CreateDirectory(TPath.GetDirectoryName(FPathLogException));
{$ELSE}
    if not DirectoryExists(ExtractFileDir(FPathLogException)) then
      CreateDir(ExtractFileDir(FPathLogException));
{$ENDIF}

//  if DirectoryExists(FPathLogException) then
//   FLogMissing.SaveToFile(PathExportJSON + 'LogLangMissing.txt');
 except
 end;
end;

procedure TPrismOptions.SetPathTemp(const Value: string);
begin
 FPathTemp:= Value;
end;

procedure TPrismOptions.SetPathTempSessions(const Value: string);
begin
 FPathTempSessions:= Value;
end;

procedure TPrismOptions.SetRootDirectory(const Value: string);
begin
  FRootDirectory:= Value;
end;

procedure TPrismOptions.SetSessionIdleTimeOut(const Value: Integer);
begin
  FSessionIdleTimeOut:= Value;
end;

procedure TPrismOptions.SetSessionTimeOut(const Value: Integer);
begin
  if Value >= 0 then
    FSessionTimeOut:= Value
  else
    FSessionTimeOut:= 0;
end;

procedure TPrismOptions.SetShowError500Page(const Value: boolean);
begin
  FShowError500Page:= Value;
end;

procedure TPrismOptions.SetUseINIConfig(const Value: Boolean);
begin
  FUseINIConfig:= Value;
end;

procedure TPrismOptions.SetUseMainThread(const Value: Boolean);
begin
 FUseMainThread := Value;
end;

procedure TPrismOptions.SetUseSSL(const Value: Boolean);
begin
  FUseSSL:= Value;
end;

procedure TPrismOptions.SetValidateAllControls(const Value: Boolean);
begin
  FValidateAllControls:= Value;
end;

procedure TPrismOptions.SetVCLStyles(const Value: Boolean);
begin
  FVCLStyles:= Value;
end;

end.