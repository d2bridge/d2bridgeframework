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

unit Prism.Session.Info;

interface

uses
  Classes, SysUtils,
{$IFDEF FMX}
  FMX.Forms,
{$ELSE}
  Forms,
{$ENDIF}
  Prism.Interfaces;


type
 TPrismSessionInfo = class(TInterfacedPersistent, IPrismSessionInfo)
  private
   FPrismSession: IPrismSession;
   FIP: string;
   FUser: String;
   FIdentity: string;
   FUserAgent: string;
   FFormName: string;
   FScreen: IPrismSessionInfoScreen;
   function GetIP: string;
   procedure SetIP(AValue: string);
   function GetUser: string;
   procedure SetUser(AValue: string);
   function GetIdentity: string;
   procedure SetIdentity(AValue: string);
   function GetUserAgent: string;
   procedure SetUserAgent(AValue: string);
  public
   constructor Create(APrismSession: IPrismSession);
   destructor Destroy; override;

   function FormName: string;

   function Screen: IPrismSessionInfoScreen;

   property IP: string read GetIP write SetIP;
   property User: string read GetUser write SetUser;
   property Identity: string read GetIdentity write SetIdentity;
   property UserAgent: string read GetUserAgent write SetUserAgent;

end;



implementation

uses
  Prism.Util, Prism.Session.Info.Screen,
  D2Bridge.BaseClass, D2Bridge.Forms;

{ TPrismSessionInfo }

constructor TPrismSessionInfo.Create(APrismSession: IPrismSession);
begin
 FPrismSession:= APrismSession;

 FUser:= 'anonymous';
 FIdentity:= 'main';
 FFormName:= '';

 FScreen:= TPrismSessionInfoScreen.Create;
end;

destructor TPrismSessionInfo.Destroy;
var
 vScreen: TPrismSessionInfoScreen;
begin
 vScreen:= FScreen as TPrismSessionInfoScreen;
 FScreen:= nil;
 vScreen.Free;

 inherited;
end;

function TPrismSessionInfo.FormName: string;
begin
 Result:= FFormName;

 try
  if Assigned(FPrismSession.D2BridgeBaseClassActive) then
  if Assigned(TD2BridgeClass(FPrismSession.D2BridgeBaseClassActive).FormAOwner) then
   Result:= TForm(TD2BridgeClass(FPrismSession.D2BridgeBaseClassActive).FormAOwner).ClassName;
 except

 end;

 FFormName:= Result;
end;

function TPrismSessionInfo.GetIdentity: string;
begin
 Result:= FIdentity;
end;

function TPrismSessionInfo.GetIP: string;
begin
 Result:= FIP;
end;

function TPrismSessionInfo.GetUser: string;
begin
 Result:= FUser;
end;

function TPrismSessionInfo.GetUserAgent: string;
begin
 Result:= FUserAgent;
end;

function TPrismSessionInfo.Screen: IPrismSessionInfoScreen;
begin
 result:= FScreen;
end;

procedure TPrismSessionInfo.SetIdentity(AValue: string);
begin
 FIdentity:= AValue;
end;

procedure TPrismSessionInfo.SetIP(AValue: string);
begin
 FIP:= AValue;
end;

procedure TPrismSessionInfo.SetUser(AValue: string);
begin
 FUser:= AValue;
end;

procedure TPrismSessionInfo.SetUserAgent(AValue: string);
begin
 FUserAgent:= AValue;
end;

end.
