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

unit Prism.Log;

interface

uses
  Classes, SysUtils, SyncObjs,
{$IFDEF HAS_UNIT_SYSTEM_IOUTILS}
  System.IOUtils,
{$ENDIF}
  Prism.Types
;

type
 TPrismLog = class
  private
    FLogFile: TextFile;
    FCriticalSection: TCriticalSection;
    FFileName: string;
  public
    constructor Create(const FileName: string);
    destructor Destroy; override;
    procedure Log(const SessionIdenty, ErrorForm, ErrorObject, ErrorEvent, ErrorMsg: string);
    procedure LogSecurity(const AEvent: TSecurityEvent; const AIP, AUserAgent, ADescription: string; const AIsIPV6: boolean);
    procedure LogAccess(const AIP, AUserAgent, ASessionUser, ASessionIdentity, APrismDescription: string);
  end;

implementation

{ TPrismLog }

constructor TPrismLog.Create(const FileName: string);
begin
 FFileName:= FileName;

 if DirectoryExists(ExtractFileDir(FileName)) then
 begin
  AssignFile(FLogFile, FileName);
  Rewrite(FLogFile);
  FCriticalSection := TCriticalSection.Create;

  WriteLn(FLogFile, 'D2Bridge Framework');
  WriteLn(FLogFile, 'by Talis Jonatas Gomes');
  WriteLn(FLogFile, 'https://www.d2bridge.com.br');
  WriteLn(FLogFile, '');
  WriteLn(FLogFile, 'LOG Started in '+DateTimeToStr(Now));
  WriteLn(FLogFile, '');

  Flush(FLogFile);
 end;
end;

destructor TPrismLog.Destroy;
begin
  if FileExists(FFileName) then
  begin
   CloseFile(FLogFile);
   FCriticalSection.Free;
  end;

  inherited;
end;

procedure TPrismLog.Log(const SessionIdenty, ErrorForm, ErrorObject, ErrorEvent, ErrorMsg: string);
var
 vMsg: string;
begin
 if FileExists(FFileName) then
 begin
  FCriticalSection.Enter;
  try
    vMsg:= DateTimeToStr(Now);

    if SessionIdenty <> '' then
     vMsg:= vMsg + ' | Identy = ' + SessionIdenty;

    if ErrorForm <> '' then
     vMsg:= vMsg + ' | Form = ' + ErrorForm;

    if ErrorObject <> '' then
     vMsg:= vMsg + ' | Component = ' + ErrorObject;

    if ErrorEvent <> '' then
     vMsg:= vMsg + ' | Event = ' + ErrorEvent;

    if ErrorMsg <> '' then
     vMsg:= vMsg + ' | Error = ' + ErrorMsg;

    try
     WriteLn(FLogFile, vMsg);
     Flush(FLogFile);
    except

    end;
  finally
    FCriticalSection.Leave;
  end;
 end;
end;

procedure TPrismLog.LogAccess(const AIP, AUserAgent, ASessionUser, ASessionIdentity, APrismDescription: string);
var
 vMsg: string;
begin
 if FileExists(FFileName) then
 begin
  FCriticalSection.Enter;
  try
   vMsg:= DateTimeToStr(Now);

   vMsg:= vMsg + ' | New Access';

   if AIP <> '' then
    vMsg:= vMsg + ' | IP = ' + AIP;

   if AUserAgent <> '' then
    vMsg:= vMsg + ' | UserAgent = ' + AUserAgent;

   if ASessionUser <> '' then
    vMsg:= vMsg + ' | User = ' + ASessionUser;

   if ASessionIdentity <> '' then
    vMsg:= vMsg + ' | Identity = ' + ASessionIdentity;

   try
    WriteLn(FLogFile, vMsg);
    Flush(FLogFile);
   except
   end;
  finally
   FCriticalSection.Leave;
  end;
 end;

end;

procedure TPrismLog.LogSecurity(const AEvent: TSecurityEvent; const AIP, AUserAgent, ADescription: string; const AIsIPV6: boolean);
var
 vMsg: string;
begin
 if FileExists(FFileName) then
 begin
  FCriticalSection.Enter;
  try
   vMsg:= DateTimeToStr(Now);

   case AEvent of
    secBlockBlackList : vMsg:= vMsg + ' | Event = ' + 'Blocked BlackList';
    secDelistIPBlackList : vMsg:= vMsg + ' | Event = ' + 'Delist IP BlackList';
    secNotDelistIPBlackList : vMsg:= vMsg + ' | Event = ' + 'Not Delist IP BlackList';
    secBlockUserAgent : vMsg:= vMsg + ' | Event = ' + 'Blocked Agent';
    secBlockIPLimitConn : vMsg:= vMsg + ' | Event = ' + 'Blocked IP Limit Conn';
    secBlockIPLimitSession : vMsg:= vMsg + ' | Event = ' + 'Blocked IP Limit Session';
   end;

   if AIP <> '' then
    vMsg:= vMsg + ' | IP = ' + AIP;

   if AUserAgent <> '' then
    vMsg:= vMsg + ' | UserAgent = ' + AUserAgent;

   if AIsIPV6 then
    vMsg:= vMsg + ' | IPV6 = ' + 'True'
   else
    vMsg:= vMsg + ' | IPV6 = ' + 'False';

   if ADescription <> '' then
    vMsg:= vMsg + ' | Description = ' + ADescription;

   try
    WriteLn(FLogFile, vMsg);
    Flush(FLogFile);
   except
   end;
  finally
   FCriticalSection.Leave;
  end;
 end;

end;

end.
