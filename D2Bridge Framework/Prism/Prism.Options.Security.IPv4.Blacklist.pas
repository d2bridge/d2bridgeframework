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

unit Prism.Options.Security.IPv4.Blacklist;

interface

uses
  Classes, SysUtils, Generics.Collections, DateUtils, D2Bridge.JSON,
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
{$IFDEF FMX}

{$ELSE}

{$ENDIF}
{$IFDEF FPC}
  LResources, FileUtil, LazFileUtils,
{$ENDIF}
  Prism.Interfaces, Prism.Types, Prism.Options.Security.IPv4.Commom;

type
 TBlackListToken = record
  Token: string;
  ExpireTime: TDateTime;
 end;

type
 TPrismOptionSecurityIPv4BlackList = class(TPrismOptionSecurityIPv4, IPrismOptionSecurityIPv4Blacklist)
  private
   FDrop_v4_json: TStrings;
   FEnableSelfDelist: Boolean;
   FDictTokenDelist: TDictionary<string,TBlackListToken>;
   FLockToken: TMultiReadExclusiveWriteSynchronizer;
   FEnableSpamhausList: Boolean;
   procedure LoadDrop_v4_json;
   function GetEnableSelfDelist: Boolean;
   procedure SetEnableSelfDelist(const Value: Boolean);
   function GetEnableSpamhausList: Boolean;
   procedure SetEnableSpamhausList(const Value: Boolean);
  public
   constructor Create; override;
   destructor Destroy; override;

   function CreateTokenDelist(AIP: string): string;
   function IsValidTokenDelist(AIP: string; AJSON: TJSONObject; ARemoveToken: boolean = false): boolean; overload;
   function IsValidTokenDelist(AIP: string; AToken: string; ARemoveToken: boolean = false): boolean; overload;
   function RemoveTokenDelist(AIP: string): boolean;

   procedure ClearOldTokenDelist;

   procedure LoadDefaultIPv4Blacklist;

   property EnableSpamhausList: Boolean read GetEnableSpamhausList write SetEnableSpamhausList;
   property EnableSelfDelist: Boolean read GetEnableSelfDelist write SetEnableSelfDelist;
 end;

const
  FLengTokenDelist = 29;
  FExpireTokenMin = 5;

implementation

uses
  D2Bridge.Util;

{ TPrismOptionSecurityIPv4BlackList }

procedure TPrismOptionSecurityIPv4BlackList.ClearOldTokenDelist;
var
 vBlackListToken: TBlackListToken;
 vKeys: TArray<string>;
 vIP: string;
 I: integer;
begin
 if not FEnableSelfDelist then
  exit;

 FLockToken.BeginWrite;

 vKeys:= FDictTokenDelist.Keys.ToArray;

 for I:= 0 to Pred(Length(vKeys)) do
 begin
  vIP:= vKeys[I];
  vBlackListToken:= FDictTokenDelist.Items[vIP];

  if vBlackListToken.ExpireTime <= now then
   FDictTokenDelist.Remove(vIP)
 end;

 FLockToken.EndWrite;
end;

constructor TPrismOptionSecurityIPv4BlackList.Create;
begin
 inherited;

 FEnableSpamhausList:= true;
 FEnableSelfDelist:= true;
 FDrop_v4_json:= TStringList.Create;
 FDictTokenDelist:= TDictionary<string,TBlackListToken>.Create;
 FLockToken:= TMultiReadExclusiveWriteSynchronizer.Create;
end;

function TPrismOptionSecurityIPv4BlackList.CreateTokenDelist(AIP: string): string;
var
 vBlackListToken: TBlackListToken;
begin
 result:= '';

 if not FEnableSelfDelist then
  exit;

 FLockToken.BeginRead;

 if not FDictTokenDelist.TryGetValue(AIP, vBlackListToken) then
 begin
  vBlackListToken:= Default(TBlackListToken);
 end;

 vBlackListToken.Token:= GenerateRandomString(FLengTokenDelist);
 vBlackListToken.ExpireTime:= IncMinute(now, FExpireTokenMin);

 FDictTokenDelist.AddOrSetValue(AIP, vBlackListToken);

 result:= vBlackListToken.Token;

 FLockToken.EndWrite;
end;

destructor TPrismOptionSecurityIPv4BlackList.Destroy;
begin
 FDrop_v4_json.Free;
 FDictTokenDelist.Free;
 FLockToken.Free;

 inherited;
end;

function TPrismOptionSecurityIPv4BlackList.GetEnableSelfDelist: Boolean;
begin
 Result := FEnableSelfDelist;
end;

function TPrismOptionSecurityIPv4BlackList.GetEnableSpamhausList: Boolean;
begin
 result:= FEnableSpamhausList;
end;

function TPrismOptionSecurityIPv4BlackList.IsValidTokenDelist(AIP: string; AJSON: TJSONObject; ARemoveToken: boolean = false): boolean;
var
 vToken, vIP: string;
begin
 result:= false;

 vToken:= AJSON.GetValue('token', '');
 vIP:= AJSON.GetValue('ip', '');

 if AIP <> vIP then
  exit;

 if (vToken <> '') and (vIP <> '') then
  Result:= IsValidTokenDelist(AIP, vToken, ARemoveToken);
end;

function TPrismOptionSecurityIPv4BlackList.IsValidTokenDelist(AIP, AToken: string; ARemoveToken: boolean = false): boolean;
var
 vBlackListToken: TBlackListToken;
begin
 result:= false;

 if not FEnableSelfDelist then
  exit;

 FLockToken.BeginRead;

 if FDictTokenDelist.TryGetValue(AIP, vBlackListToken) then
 begin
  Result:= (vBlackListToken.Token = AToken) and (vBlackListToken.ExpireTime > now);

  if ARemoveToken then
   FDictTokenDelist.Remove(AIP);
 end;

 FLockToken.EndRead;
end;

procedure TPrismOptionSecurityIPv4BlackList.LoadDefaultIPv4Blacklist;
var
 I, J: integer;
 vIPv4: string;
begin
 LoadDrop_v4_json;

 if FEnableSpamhausList then
  if FDrop_v4_json.Count > 0 then
  begin
   for I := 0 to Pred(FDrop_v4_json.Count) do
    if Pos('{"cidr":"', FDrop_v4_json[I]) > 0 then
    begin
     vIPv4:= Copy(FDrop_v4_json[I], 10, Pos('","sblid"', FDrop_v4_json[I]) - 10);

     if IsValidIP(vIPv4) then
     begin
      if not FItems.Contains(vIPv4) then
      FItems.Add(vIPv4);
     end;
    end;
  end;
end;

procedure TPrismOptionSecurityIPv4BlackList.LoadDrop_v4_json;
var
 vResInfo:    {$IFNDEF FPC}HRSRC{$ELSE}TLResource{$ENDIF};
 vResStream:  {$IFNDEF FPC}TResourceStream{$ELSE}TLazarusResourceStream{$ENDIF};
 vFileStream: TStringStream;
begin
 {$REGION 'drop_v4.json'}
 FDrop_v4_json.Clear;

{$IFNDEF FPC}
  vResInfo := FindResource(HInstance, PWideChar('PRISM_Support_Security_IPv4Blacklist'), RT_RCDATA);

  if vResInfo <> 0 then
{$ELSE}
  vResInfo:= LazarusResources.Find('PRISM_Support_Security_IPv4Blacklist');

  if vResInfo <> nil then
{$ENDIF}
 begin
  try
   try
{$IFNDEF FPC}
    vResStream := TResourceStream.Create(HInstance, 'PRISM_Support_Security_IPv4Blacklist', RT_RCDATA);
{$ELSE}
    vResStream := TLazarusResourceStream.Create('PRISM_Support_Security_IPv4Blacklist', nil);
{$ENDIF}

    vFileStream:= TStringStream.Create('', TEncoding.UTF8);
    vResStream.SaveToStream(vFileStream);
    FDrop_v4_json.Text:= vFileStream.DataString;
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

function TPrismOptionSecurityIPv4BlackList.RemoveTokenDelist(AIP: string): boolean;
var
 vBlackListToken: TBlackListToken;
begin
 result:= false;

 if not FEnableSelfDelist then
  exit;

 FLockToken.BeginWrite;

 if (not (FDictTokenDelist.Count <= 0)) and
    (FDictTokenDelist.ContainsKey(AIP)) then
 begin
  FDictTokenDelist.Remove(AIP);
  result:= true;
 end;

 FLockToken.EndWrite;
end;

procedure TPrismOptionSecurityIPv4BlackList.SetEnableSelfDelist(const Value:
    Boolean);
begin
 FEnableSelfDelist := Value;
end;

procedure TPrismOptionSecurityIPv4BlackList.SetEnableSpamhausList(
  const Value: Boolean);
begin
 FEnableSpamhausList:= Value;
end;

end.
