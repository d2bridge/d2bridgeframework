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

unit D2Bridge.API.D2Docker;

interface

{$IFDEF D2DOCKER}
Uses
   Classes, Generics.Collections, SysUtils, Windows,
   D2Bridge.Interfaces, Prism.Interfaces,
  {$IFDEF FMX}

  {$ELSE}

  {$ENDIF}
   D2Bridge.API.D2Docker.Types
  ;


type
 TD2BridgeAPIDocker = class(TInterfacedPersistent, ID2BridgeAPID2Docker)
  private
   FServerHost: string;
   FServerPort: integer;
   FAppId: integer;
   FInstanceNumber: integer;
   FContainerId: integer;
   FPrimaryContainerAPP: Boolean;
   FRTTIObjects: TDictionary<string, TObject>;
   FCBServerStarted: TD2DockerCBServerStarted;
   FCBLog: TD2DockerCBLog;
   FCBSession: TD2DockerCBSession;
   function GetServerHost: string;
   function GetServerPort: integer;
   procedure SetServerHost(const Value: string);
   procedure SetServerPort(const Value: integer);
   function GetAppId: integer;
   function GetInstanceNumber: integer;
   function GetContainerId: integer;
   procedure SetAppId(const Value: integer);
   procedure SetInstanceNumber(const Value: integer);
   procedure SetContainerId(const Value: integer);
   function GetPrimaryContainerAPP: Boolean;
   procedure SetPrimaryContainerAPP(const Value: Boolean);
  protected

  public
   constructor Create;
   destructor Destroy; override;

   function RTTIObject(const Name: string): TObject;

   procedure AddRTTIObjects;

   procedure DoServerStarted;
   procedure DoLogException(AMessage: string);

   procedure DoNewSession(ASession: IPrismSession);
   procedure DoCloseSession(ASession: IPrismSession);
  published
   property AppId: integer read GetAppId write SetAppId;
   property InstanceNumber: integer read GetInstanceNumber write SetInstanceNumber;
   property ContainerId: integer read GetContainerId write SetContainerId;
   property PrimaryContainerAPP: Boolean read GetPrimaryContainerAPP write SetPrimaryContainerAPP;

   property CallBackServerStarted: TD2DockerCBServerStarted read FCBServerStarted write FCBServerStarted;
   property CallBackLog: TD2DockerCBLog read FCBLog write FCBLog;
   property CallBackSession: TD2DockerCBSession read FCBSession write FCBSession;
 end;


implementation

Uses
 D2Bridge.ServerControllerBase, D2Bridge.Manager,
 D2Bridge.Util,
 Prism.BaseClass;

{ TD2BridgeAPIDocker }


procedure TD2BridgeAPIDocker.AddRTTIObjects;
begin
 FRTTIObjects.Add(UpperCase('D2BridgeServerController'), (D2BridgeServerControllerBase as TObject));
 FRTTIObjects.Add(UpperCase('AppConfig'), (D2BridgeServerControllerBase.AppConfig as TObject));
 FRTTIObjects.Add(UpperCase('AppPath'), (D2BridgeServerControllerBase.AppConfig.Path as TObject));
 FRTTIObjects.Add(UpperCase('PrismBaseClass'), PrismBaseClass);
 FRTTIObjects.Add(UpperCase('Prism'), PrismBaseClass);
 FRTTIObjects.Add(UpperCase('D2BridgeManager'), D2BridgeManager);
 FRTTIObjects.Add(UpperCase('APPVersion'), (D2BridgeServerControllerBase.APPVersion as TObject));
 FRTTIObjects.Add(UpperCase('D2Docker'),  (D2BridgeManager.API.D2Docker as TObject));
end;

constructor TD2BridgeAPIDocker.Create;
begin
 inherited;
 //FAgentApp:= TD2DockerAgentApp.Create;

 FRTTIObjects:= TDictionary<string, TObject>.Create;
end;

//function TD2BridgeAPIDocker.CreateTaskFromSession(ASession: IPrismSession): ID2DockerTaskAppSession;
//begin
// result:= TD2DockerTaskAppSession.Create(FAgentApp as TD2DockerAgentApp);
//
// //Default Task
// result.Flow:= FlowSend;
// result.Target:= TAgentType.AgentTypeServer;
// result.Date:= now;
//
// //Default APP
// result.AppID:= AppId;
// result.InstanceNumber:= InstanceNumber;
//
// //Task Session
// result.SessionUUID:= ASession.UUID;
// result.Identify:= ASession.InfoConnection.Identity;
// result.IP:= ASession.InfoConnection.IP;
// result.User:= ASession.InfoConnection.User;
// result.UserAgent:= ASession.InfoConnection.UserAgent;
//end;

destructor TD2BridgeAPIDocker.Destroy;
begin
 //(FAgentApp as TD2DockerAgentApp).Destroy;

 FRTTIObjects.Free;

 inherited;
end;

procedure TD2BridgeAPIDocker.DoCloseSession(ASession: IPrismSession);
begin
 if Assigned(FCBSession) then
  FCBSession(
   TCallBackSessionStatus.scsCloseSession,
   ASession.UUID,
   ASession.InfoConnection.IP,
   ASession.InfoConnection.UserAgent,
   ASession.InfoConnection.User,
   ASession.InfoConnection.Identity
  );
end;

procedure TD2BridgeAPIDocker.DoLogException(AMessage: string);
begin
 if Assigned(FCBLog) then
  FCBLog('Exception', 'App', AMessage);
end;

procedure TD2BridgeAPIDocker.DoNewSession(ASession: IPrismSession);
begin
 if Assigned(FCBSession) then
  FCBSession(
   TCallBackSessionStatus.scsNewSession,
   ASession.UUID,
   ASession.InfoConnection.IP,
   ASession.InfoConnection.UserAgent,
   ASession.InfoConnection.User,
   ASession.InfoConnection.Identity
  );
end;

procedure TD2BridgeAPIDocker.DoServerStarted;
begin
 if Assigned(FCBServerStarted) then
  FCBServerStarted(PrismBaseClass.ServerUUID);
end;

function TD2BridgeAPIDocker.GetAppId: integer;
begin
 result:= FAppId;
end;

function TD2BridgeAPIDocker.GetInstanceNumber: integer;
begin
 result:= FInstanceNumber;
end;

function TD2BridgeAPIDocker.GetContainerId: integer;
begin
 result:= FContainerId;
end;

function TD2BridgeAPIDocker.GetPrimaryContainerAPP: Boolean;
begin
 result:= FPrimaryContainerAPP;
end;

function TD2BridgeAPIDocker.GetServerHost: string;
begin
 Result := FServerHost;
end;

function TD2BridgeAPIDocker.GetServerPort: integer;
begin
 Result := FServerPort;
end;

function TD2BridgeAPIDocker.RTTIObject(const Name: string): TObject;
begin
 if not FRTTIObjects.TryGetValue(UpperCase(Name), Result) then
  Result := nil;
end;

procedure TD2BridgeAPIDocker.SetAppId(const Value: integer);
begin
 FAppId:= Value;
end;

procedure TD2BridgeAPIDocker.SetInstanceNumber(const Value: integer);
begin
 FInstanceNumber:= Value;
end;

procedure TD2BridgeAPIDocker.SetContainerId(const Value: integer);
begin
 FContainerId:= Value;
end;

procedure TD2BridgeAPIDocker.SetPrimaryContainerAPP(const Value: Boolean);
begin
 FPrimaryContainerAPP:= Value;
end;

procedure TD2BridgeAPIDocker.SetServerHost(const Value: string);
begin
 FServerHost := Value;
end;

procedure TD2BridgeAPIDocker.SetServerPort(const Value: integer);
begin
 FServerPort := Value;
end;

{$ELSE}
implementation
{$ENDIF}

end.