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

unit Prism.Options.Security.UserAgent;

interface

uses
  Classes, SysUtils, Generics.Collections,
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
{$IFDEF FMX}

{$ELSE}

{$ENDIF}
{$IFDEF FPC}
  LResources, FileUtil, LazFileUtils,
{$ENDIF}
  Prism.Interfaces, Prism.Types;

type
 TPrismOptionSecurityUserAgent = class(TInterfacedPersistent, IPrismOptionSecurityUserAgent)
  private
   FCrawler_user_agents_json: TStrings;
   FLock: TMultiReadExclusiveWriteSynchronizer;
   FItems: TList<string>;
   FEnableCrawlerUserAgents: Boolean;
   procedure LoadCrawler_user_agents_json;
   function GetEnableCrawlerUserAgents: Boolean;
   procedure SetEnableCrawlerUserAgents(const Value: Boolean);
  public
   constructor Create;
   destructor Destroy; override;

   procedure Clear;
   procedure Add(AUserAgent: string);
   function Count: integer;
   function Delete(AUserAgent: string): Boolean;
   function Exist(AUserAgent: string): Boolean;
   function UserAgentBlocked(AHeaderUserAgent: string): Boolean;
   function Items: TList<string>;

   procedure LoadDefaultBlockedUserAgent;

   property EnableCrawlerUserAgents: Boolean read GetEnableCrawlerUserAgents write SetEnableCrawlerUserAgents;
 end;

implementation

uses
{$IFDEF HAS_UNIT_REGULAREXPRESSIONSAPI}
  System.RegularExpressions;
{$ELSE}
  RegExpr;
{$ENDIF}

{ TPrismOptionSecurityUserAgent }

procedure TPrismOptionSecurityUserAgent.Add(AUserAgent: string);
begin
 FLock.BeginWrite;

 if not FItems.Contains(AUserAgent) then
  FItems.Add(AUserAgent);

 FLock.EndWrite;
end;

procedure TPrismOptionSecurityUserAgent.Clear;
begin
 FLock.BeginWrite;

 try
  FItems.Clear;
 except
 end;

 FLock.EndWrite;
end;

function TPrismOptionSecurityUserAgent.Count: integer;
begin
 FLock.BeginRead;

 try
  result:= FItems.Count;
 except
 end;

 FLock.EndRead;
end;

constructor TPrismOptionSecurityUserAgent.Create;
begin
 inherited;

 FEnableCrawlerUserAgents:= true;
 FLock:= TMultiReadExclusiveWriteSynchronizer.Create;
 FItems:= TList<string>.Create;
 FCrawler_user_agents_json:= TStringList.Create;
end;

function TPrismOptionSecurityUserAgent.Delete(AUserAgent: string): Boolean;
begin
 result:= false;

 FLock.BeginWrite;

 try
  if not FItems.Contains(AUserAgent) then
  begin
   result:= true;
   FItems.Remove(AUserAgent);
  end;
 except
 end;

 FLock.EndWrite;
end;

destructor TPrismOptionSecurityUserAgent.Destroy;
begin
 FLock.Free;
 FItems.Free;
 FCrawler_user_agents_json.Free;

 inherited;
end;

function TPrismOptionSecurityUserAgent.Exist(AUserAgent: string): Boolean;
begin
 FLock.BeginRead;

 try
  result:= FItems.Contains(AUserAgent);
 except
 end;

 FLock.EndRead;
end;

function TPrismOptionSecurityUserAgent.GetEnableCrawlerUserAgents: Boolean;
begin
 result:= FEnableCrawlerUserAgents;
end;

function TPrismOptionSecurityUserAgent.Items: TList<string>;
begin
 FLock.BeginRead;

 Result:= TList<string>.Create;

 result.AddRange(FItems.ToArray);

 FLock.EndRead;
end;

procedure TPrismOptionSecurityUserAgent.LoadCrawler_user_agents_json;
var
 vResInfo:    {$IFNDEF FPC}HRSRC{$ELSE}TLResource{$ENDIF};
 vResStream:  {$IFNDEF FPC}TResourceStream{$ELSE}TLazarusResourceStream{$ENDIF};
 vFileStream: TStringStream;
begin
 {$REGION 'drop_v4.json'}
 FCrawler_user_agents_json.Clear;

{$IFNDEF FPC}
  vResInfo := FindResource(HInstance, PWideChar('PRISM_Support_Security_UserAgent'), RT_RCDATA);

  if vResInfo <> 0 then
{$ELSE}
  vResInfo:= LazarusResources.Find('PRISM_Support_Security_UserAgent');

  if vResInfo <> nil then
{$ENDIF}
 begin
  try
   try
{$IFNDEF FPC}
    vResStream := TResourceStream.Create(HInstance, 'PRISM_Support_Security_UserAgent', RT_RCDATA);
{$ELSE}
    vResStream := TLazarusResourceStream.Create('PRISM_Support_Security_UserAgent', nil);
{$ENDIF}

    vFileStream:= TStringStream.Create('', TEncoding.UTF8);
    vResStream.SaveToStream(vFileStream);
    FCrawler_user_agents_json.Text:= vFileStream.DataString;
   except
   end;
   if Assigned(vResStream) then
    vResStream.Free;
   if Assigned(vFileStream) then
    vFileStream.Free;
  except
  end;
 end;
 {$ENDREGION}
end;

procedure TPrismOptionSecurityUserAgent.LoadDefaultBlockedUserAgent;
var
 I, J: integer;
 vAgent: string;
 vPosSearch: string;
 vPosInit, vPosEnd: integer;
begin
 LoadCrawler_user_agents_json;
 vPosSearch:= '"pattern": "';

 if FEnableCrawlerUserAgents then
  if FCrawler_user_agents_json.Count > 0 then
  begin
   for I := 0 to Pred(FCrawler_user_agents_json.Count) do
   begin
    vPosInit:= Pos(vPosSearch, FCrawler_user_agents_json[I]);
    if vPosInit > 0 then
    begin
     vPosInit:= vPosInit + Length(vPosSearch);

     vAgent:= Copy(FCrawler_user_agents_json[I], vPosInit);

     vPosEnd:= Pos('"', vAgent);

     vAgent:= Copy(vAgent, 1, vPosEnd -1);

     if not FItems.Contains(vAgent) then
      FItems.Add(vAgent);
    end;
   end;
  end;
end;

procedure TPrismOptionSecurityUserAgent.SetEnableCrawlerUserAgents(
  const Value: Boolean);
begin
 FEnableCrawlerUserAgents:= Value;
end;

function TPrismOptionSecurityUserAgent.UserAgentBlocked(AHeaderUserAgent: string): Boolean;
var
 I: integer;
begin
 Result:= false;

 FLock.BeginRead;

 for I := 0 to Pred(FItems.Count) do
{$IFDEF HAS_UNIT_REGULAREXPRESSIONSAPI}
  if TRegEx.IsMatch(AHeaderUserAgent, FItems[I], [roIgnoreCase]) then
{$ELSE}
  if ExecRegExpr(AHeaderUserAgent, FItems[I]) then
{$ENDIF}
  begin
   Result:= true;
   break;
  end;

 FLock.EndRead;
end;

end.
