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

unit D2Bridge.Rest.Server.Functions;

interface

uses
  Classes, SysUtils, Generics.Collections, DateUtils, DB,
{$IFNDEF FPC}
  JSON,
{$ELSE}
  fpjson, jsonparser,
{$ENDIF}
  D2Bridge.Rest.Route.CallBack, D2Bridge.Rest.Request, D2Bridge.Rest.Interfaces,
  D2Bridge.Rest.Session, D2Bridge.Rest.Session.Event,
  D2Bridge.JSON, D2Bridge.Interfaces,
  Prism.Server.HTTP.Commom, Prism.Server.HTTP.Commom.StatusCode, Prism.Session,
  Prism.Security.JWT,
  Prism.Types, Prism.Interfaces;


type
 TPrismHTTPRequest = Prism.Server.HTTP.Commom.TPrismHTTPRequest;
 TPrismHTTPResponse = Prism.Server.HTTP.Commom.TPrismHTTPResponse;
 TD2BridgeRestRouteCallBack = D2Bridge.Rest.Route.CallBack.TD2BridgeRestRouteCallBack;
 TD2BridgeRestRequest = D2Bridge.Rest.Request.TD2BridgeRestRequest;
 TD2BridgeRestSession = D2Bridge.Rest.Session.TD2BridgeRestSession;
 TPrismSecurityJWT = Prism.Security.JWT.TPrismSecurityJWT;
 TPrismSession = Prism.Session.TPrismSession;


{$I D2Bridge.Rest.Commom.Intf.inc}



//EndPoint
procedure AddEndPoint(AWebMethod: TPrismWebMethod; const Path: string; ACallBack: TD2BridgeRestRouteCallBack); overload;
procedure AddEndPoint(AWebMethod: TPrismWebMethod; const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;
procedure AddGet(const Path: string; ACallBack: TD2BridgeRestRouteCallBack); overload;
procedure AddPost(const Path: string; ACallBack: TD2BridgeRestRouteCallBack); overload;
procedure AddPut(const Path: string; ACallBack: TD2BridgeRestRouteCallBack); overload;
procedure AddDelete(const Path: string; ACallBack: TD2BridgeRestRouteCallBack); overload;
procedure AddPatch(const Path: string; ACallBack: TD2BridgeRestRouteCallBack); overload;
procedure AddGet(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;
procedure AddPost(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;
procedure AddPut(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;
procedure AddDelete(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;
procedure AddPatch(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;

procedure NewRestSession(const EventOnNewRestSession: TOnRestSession);
procedure CloseRestSession(const EventOnNewRestSession: TOnRestSession);
procedure BeforeRestMethod(const EventOnBeforeRestMethod: TOnBeforeRestMethod);
procedure AfterRestMethod(const EventAfterRestMethod: TOnAfterRestMethod);


//Functions
function RestSecurity: ID2BridgeRestSecurity;
function RestOptions: ID2BridgeRestOptions;
function D2BridgeSessions: IPrismSessions;
function Sessions: IPrismSessions;
function AppConfig: ID2BridgeAPPConfig;
function D2BridgeServerController: ID2BridgeServerControllerBase;

implementation

Uses
 D2Bridge.Rest.Server,
 Prism.BaseClass, IdGlobal;


{$I D2Bridge.Rest.Commom.Impl.inc}


procedure AddEndPoint(AWebMethod: TPrismWebMethod; const Path: string; ACallBack: TD2BridgeRestRouteCallBack);
begin
{$IFDEF D2BRIDGE}
 PrismBaseClass.Rest.Server.AddEndPoint(AWebMethod, Path, ACallBack);
{$ENDIF}
end;

procedure AddEndPoint(AWebMethod: TPrismWebMethod; const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;
begin
{$IFDEF D2BRIDGE}
 PrismBaseClass.Rest.Server.AddEndPoint(AWebMethod, Path, ACallBack, RequireAuth);
{$ENDIF}
end;

procedure AddGet(const Path: string; ACallBack: TD2BridgeRestRouteCallBack);
begin
{$IFDEF D2BRIDGE}
 PrismBaseClass.Rest.Server.AddGet(Path, ACallBack);
{$ENDIF}
end;

procedure AddPost(const Path: string; ACallBack: TD2BridgeRestRouteCallBack);
begin
{$IFDEF D2BRIDGE}
 PrismBaseClass.Rest.Server.AddPost(Path, ACallBack);
{$ENDIF}
end;

procedure AddPut(const Path: string; ACallBack: TD2BridgeRestRouteCallBack);
begin
{$IFDEF D2BRIDGE}
 PrismBaseClass.Rest.Server.AddPut(Path, ACallBack);
{$ENDIF}
end;

procedure AddDelete(const Path: string; ACallBack: TD2BridgeRestRouteCallBack);
begin
{$IFDEF D2BRIDGE}
 PrismBaseClass.Rest.Server.AddDelete(Path, ACallBack);
{$ENDIF}
end;

procedure AddPatch(const Path: string; ACallBack: TD2BridgeRestRouteCallBack);
begin
{$IFDEF D2BRIDGE}
 PrismBaseClass.Rest.Server.AddPatch(Path, ACallBack);
{$ENDIF}
end;

procedure AddGet(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;
begin
{$IFDEF D2BRIDGE}
 PrismBaseClass.Rest.Server.AddGet(Path, ACallBack, RequireAuth);
{$ENDIF}
end;

procedure AddPost(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;
begin
{$IFDEF D2BRIDGE}
 PrismBaseClass.Rest.Server.AddPost(Path, ACallBack, RequireAuth);
{$ENDIF}
end;

procedure AddPut(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;
begin
{$IFDEF D2BRIDGE}
 PrismBaseClass.Rest.Server.AddPut(Path, ACallBack, RequireAuth);
{$ENDIF}
end;

procedure AddDelete(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;
begin
{$IFDEF D2BRIDGE}
 PrismBaseClass.Rest.Server.AddDelete(Path, ACallBack, RequireAuth);
{$ENDIF}
end;

procedure AddPatch(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;
begin
{$IFDEF D2BRIDGE}
 PrismBaseClass.Rest.Server.AddPatch(Path, ACallBack, RequireAuth);
{$ENDIF}
end;


procedure NewRestSession(const EventOnNewRestSession: TOnRestSession);
begin
{$IFDEF D2BRIDGE}
 if Assigned(EventOnNewRestSession) then
  PrismBaseClass.Rest.Server.OnNewRestSession:= EventOnNewRestSession;
{$ENDIF}
end;


procedure CloseRestSession(const EventOnNewRestSession: TOnRestSession);
begin
{$IFDEF D2BRIDGE}
 if Assigned(EventOnNewRestSession) then
  PrismBaseClass.Rest.Server.OnCloseRestSession:= EventOnNewRestSession;
{$ENDIF}
end;


procedure BeforeRestMethod(const EventOnBeforeRestMethod: TOnBeforeRestMethod);
begin
{$IFDEF D2BRIDGE}
 if Assigned(EventOnBeforeRestMethod) then
  PrismBaseClass.Rest.Server.OnBeforeRestMethod:= EventOnBeforeRestMethod;
{$ENDIF}
end;


procedure AfterRestMethod(const EventAfterRestMethod: TOnAfterRestMethod);
begin
{$IFDEF D2BRIDGE}
 if Assigned(EventAfterRestMethod) then
  PrismBaseClass.Rest.Server.OnAfterRestMethod:= EventAfterRestMethod;
{$ENDIF}
end;



//Functions
function RestSecurity: ID2BridgeRestSecurity;
begin
 result:= PrismBaseClass.Options.Security.Rest;
end;

function RestOptions: ID2BridgeRestOptions;
begin
 result:= PrismBaseClass.Rest.Options;
end;

function D2BridgeSessions: IPrismSessions;
begin
 result:= PrismBaseClass.Sessions;
end;

function Sessions: IPrismSessions;
begin
 result:= D2BridgeSessions;
end;

function AppConfig: ID2BridgeAPPConfig;
begin
 result:= PrismBaseClass.ServerController.AppConfig;
end;

function D2BridgeServerController: ID2BridgeServerControllerBase;
begin
 result:= PrismBaseClass.ServerController;
end;

end.
