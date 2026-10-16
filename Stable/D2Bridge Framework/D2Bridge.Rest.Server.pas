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

unit D2Bridge.Rest.Server;

interface

uses
  Classes, SysUtils, Generics.Collections, DateUtils,
{$IFNDEF FPC}

{$ELSE}

{$ENDIF}
  Prism.Server.HTTP.Commom,
  Prism.Types,
  D2Bridge.Rest.Route.CallBack,
  D2Bridge.Rest.Interfaces, D2Bridge.Rest.Session.Event;


type

 { TD2BridgeRestServer }

 TD2BridgeRestServer = class(TInterfacedPersistent, ID2BridgeRestServer)
  private
   FOnCloseRestSession: TOnRestSession;
   FOnNewRestSession: TOnRestSession;
   FOnBeforeRestMethod: TOnBeforeRestMethod;
   FOnAfterRestMethod: TOnAfterRestMethod;
   function GetOnCloseRestSession: TOnRestSession;
   function GetOnNewRestSession: TOnRestSession;
   procedure SetOnCloseRestSession(const Value: TOnRestSession);
   procedure SetOnNewRestSession(const Value: TOnRestSession);
   function GetOnBeforeRestMethod: TOnBeforeRestMethod;
   procedure SetOnBeforeRestMethod(const Value: TOnBeforeRestMethod);
   function GetOnAfterRestMethod: TOnAfterRestMethod;
   procedure SetOnAfterRestMethod(const Value: TOnAfterRestMethod);
  public
   //function EndPoints: ID2BridgeRestRoutes;

   procedure AddEndPoint(AWebMethod: TPrismWebMethod; const Path: string; ACallBack: TD2BridgeRestRouteCallBack); overload;
   procedure AddEndPoint(AWebMethod: TPrismWebMethod; const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;
   procedure AddEndPoint(AWebMethod: TPrismWebMethod; const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean; EntityClass: TClass); overload;
{$IFDEF FPC}
   procedure AddEndPoint(AWebMethod: TPrismWebMethod; const Path: string; ACallBack: TD2BridgeRestRouteMethodCallBack; RequireAuth: boolean; EntityClass: TClass); overload;
{$ENDIF}
   procedure AddGet(const Path: string; ACallBack: TD2BridgeRestRouteCallBack); overload;
   procedure AddGet(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;
   procedure AddGet(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean; EntityClass: TClass); overload;
{$IFDEF FPC}
   procedure AddGet(const Path: string; ACallBack: TD2BridgeRestRouteMethodCallBack; RequireAuth: boolean = false; EntityClass: TClass = nil); overload;
{$ENDIF}
   procedure AddPost(const Path: string; ACallBack: TD2BridgeRestRouteCallBack); overload;
   procedure AddPost(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;
   procedure AddPost(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean; EntityClass: TClass); overload;
{$IFDEF FPC}
   procedure AddPost(const Path: string; ACallBack: TD2BridgeRestRouteMethodCallBack; RequireAuth: boolean = false; EntityClass: TClass = nil); overload;
{$ENDIF}
   procedure AddPut(const Path: string; ACallBack: TD2BridgeRestRouteCallBack); overload;
   procedure AddPut(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;
   procedure AddPut(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean; EntityClass: TClass); overload;
{$IFDEF FPC}
   procedure AddPut(const Path: string; ACallBack: TD2BridgeRestRouteMethodCallBack; RequireAuth: boolean = false; EntityClass: TClass = nil); overload;
{$ENDIF}
   procedure AddPatch(const Path: string; ACallBack: TD2BridgeRestRouteCallBack); overload;
   procedure AddPatch(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;
   procedure AddPatch(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean; EntityClass: TClass); overload;
{$IFDEF FPC}
   procedure AddPatch(const Path: string; ACallBack: TD2BridgeRestRouteMethodCallBack; RequireAuth: boolean = false; EntityClass: TClass = nil); overload;
{$ENDIF}
   procedure AddDelete(const Path: string; ACallBack: TD2BridgeRestRouteCallBack); overload;
   procedure AddDelete(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;
   procedure AddDelete(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean; EntityClass: TClass); overload;
{$IFDEF FPC}
   procedure AddDelete(const Path: string; ACallBack: TD2BridgeRestRouteMethodCallBack; RequireAuth: boolean = false; EntityClass: TClass = nil); overload;
{$ENDIF}

   property OnNewRestSession: TOnRestSession read GetOnNewRestSession write SetOnNewRestSession;
   property OnCloseRestSession: TOnRestSession read GetOnCloseRestSession write SetOnCloseRestSession;
   property OnBeforeRestMethod: TOnBeforeRestMethod read GetOnBeforeRestMethod write SetOnBeforeRestMethod;
   property OnAfterRestMethod: TOnAfterRestMethod read GetOnAfterRestMethod write SetOnAfterRestMethod;
 end;


implementation

Uses
 D2Bridge.Rest, D2Bridge.Rest.Route,
 Prism.BaseClass;

{ TD2BridgeRestServer }

procedure TD2BridgeRestServer.AddEndPoint(AWebMethod: TPrismWebMethod; const Path: string; ACallBack: TD2BridgeRestRouteCallBack);
begin
 AddEndPoint(AWebMethod, Path, ACallBack, false);
end;

procedure TD2BridgeRestServer.AddEndPoint(AWebMethod: TPrismWebMethod; const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean);
begin
 AddEndPoint(AWebMethod, Path, ACallBack, RequireAuth, nil);
end;

procedure TD2BridgeRestServer.AddGet(const Path: string; ACallBack: TD2BridgeRestRouteCallBack);
begin
 AddGet(Path, ACallBack, false);
end;

procedure TD2BridgeRestServer.AddPost(const Path: string; ACallBack: TD2BridgeRestRouteCallBack);
begin
 AddPost(Path, ACallBack, false);
end;

procedure TD2BridgeRestServer.AddPut(const Path: string; ACallBack: TD2BridgeRestRouteCallBack);
begin
 AddPut(Path, ACallBack, false);
end;

procedure TD2BridgeRestServer.AddDelete(const Path: string; ACallBack: TD2BridgeRestRouteCallBack);
begin
 AddDelete(Path, ACallBack, false);
end;

procedure TD2BridgeRestServer.AddPatch(const Path: string; ACallBack: TD2BridgeRestRouteCallBack);
begin
 AddPatch(Path, ACallBack, false);
end;

procedure TD2BridgeRestServer.AddGet(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean);
begin
 AddEndPoint(wmtGET, Path, ACallBack, RequireAuth);
end;

procedure TD2BridgeRestServer.AddPost(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean);
begin
 AddEndPoint(wmtPOST, Path, ACallBack, RequireAuth);
end;

procedure TD2BridgeRestServer.AddPut(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean);
begin
 AddEndPoint(wmtPut, Path, ACallBack, RequireAuth);
end;

procedure TD2BridgeRestServer.AddDelete(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean);
begin
 AddEndPoint(wmtDelete, Path, ACallBack, RequireAuth);
end;

procedure TD2BridgeRestServer.AddPatch(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean);
begin
 AddEndPoint(wmtPatch, Path, ACallBack, RequireAuth);
end;

function TD2BridgeRestServer.GetOnAfterRestMethod: TOnAfterRestMethod;
begin
 result:= FOnAfterRestMethod;
end;

function TD2BridgeRestServer.GetOnBeforeRestMethod: TOnBeforeRestMethod;
begin
 result:= FOnBeforeRestMethod;
end;

function TD2BridgeRestServer.GetOnCloseRestSession: TOnRestSession;
begin
 Result := FOnCloseRestSession;
end;

function TD2BridgeRestServer.GetOnNewRestSession: TOnRestSession;
begin
 Result := FOnNewRestSession;
end;

procedure TD2BridgeRestServer.SetOnAfterRestMethod(const Value: TOnAfterRestMethod);
begin
 FOnAfterRestMethod:= Value;
end;

procedure TD2BridgeRestServer.SetOnBeforeRestMethod(const Value: TOnBeforeRestMethod);
begin
 FOnBeforeRestMethod:= Value;
end;

procedure TD2BridgeRestServer.SetOnCloseRestSession(const Value:
    TOnRestSession);
begin
 FOnCloseRestSession := Value;
end;

procedure TD2BridgeRestServer.SetOnNewRestSession(const Value: TOnRestSession);
begin
 FOnNewRestSession := Value;
end;



procedure TD2BridgeRestServer.AddGet(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean;
  EntityClass: TClass);
begin
 AddEndPoint(wmtGET, Path, ACallBack, RequireAuth, EntityClass);
end;

{$IFDEF FPC}
procedure TD2BridgeRestServer.AddGet(const Path: string; ACallBack: TD2BridgeRestRouteMethodCallBack; RequireAuth: boolean; EntityClass: TClass);
begin
 AddEndPoint(wmtGET, Path, ACallBack, RequireAuth, EntityClass);
end;
{$ENDIF}

procedure TD2BridgeRestServer.AddDelete(const Path: string;
  ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean;
  EntityClass: TClass);
begin
 AddEndPoint(wmtDelete, Path, ACallBack, RequireAuth, EntityClass);
end;

{$IFDEF FPC}
procedure TD2BridgeRestServer.AddDelete(const Path: string; ACallBack: TD2BridgeRestRouteMethodCallBack; RequireAuth: boolean; EntityClass: TClass);
begin
 AddEndPoint(wmtDelete, Path, ACallBack, RequireAuth, EntityClass);
end;
{$ENDIF}

procedure TD2BridgeRestServer.AddEndPoint(AWebMethod: TPrismWebMethod;
  const Path: string; ACallBack: TD2BridgeRestRouteCallBack;
  RequireAuth: boolean; EntityClass: TClass);
var
 vD2BridgeRoutes: TD2BridgeRestRoutes;
begin
{$IFDEF D2BRIDGE}
 if not Assigned(D2Bridge.Rest.D2BridgeRest) then
  TD2BridgeRest.Create;

 vD2BridgeRoutes:= PrismBaseClass.Rest.Routes as TD2BridgeRestRoutes;

 vD2BridgeRoutes.Add(AWebMethod, Path, ACallBack, RequireAuth, TD2BridgeRestEntityClass(EntityClass));
{$ENDIF}
end;

{$IFDEF FPC}
procedure TD2BridgeRestServer.AddEndPoint(AWebMethod: TPrismWebMethod; const Path: string; ACallBack: TD2BridgeRestRouteMethodCallBack; RequireAuth: boolean; EntityClass: TClass);
var
 vD2BridgeRoutes: TD2BridgeRestRoutes;
begin
{$IFDEF D2BRIDGE}
 if not Assigned(D2Bridge.Rest.D2BridgeRest) then
  TD2BridgeRest.Create;

 vD2BridgeRoutes:= PrismBaseClass.Rest.Routes as TD2BridgeRestRoutes;

 if Assigned(EntityClass) then
  vD2BridgeRoutes.Add(AWebMethod, Path, ACallBack, RequireAuth, TD2BridgeRestEntityClass(EntityClass))
 else
  vD2BridgeRoutes.Add(AWebMethod, Path, ACallBack, RequireAuth, nil);
{$ENDIF}
end;
{$ENDIF}

procedure TD2BridgeRestServer.AddPatch(const Path: string;
  ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean;
  EntityClass: TClass);
begin
 AddEndPoint(wmtPATCH, Path, ACallBack, RequireAuth, EntityClass);
end;

{$IFDEF FPC}
procedure TD2BridgeRestServer.AddPatch(const Path: string; ACallBack: TD2BridgeRestRouteMethodCallBack; RequireAuth: boolean; EntityClass: TClass);
begin
 AddEndPoint(wmtPATCH, Path, ACallBack, RequireAuth, EntityClass);
end;
{$ENDIF}

procedure TD2BridgeRestServer.AddPost(const Path: string;
  ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean;
  EntityClass: TClass);
begin
 AddEndPoint(wmtPOST, Path, ACallBack, RequireAuth, EntityClass);
end;

{$IFDEF FPC}
procedure TD2BridgeRestServer.AddPost(const Path: string; ACallBack: TD2BridgeRestRouteMethodCallBack; RequireAuth: boolean; EntityClass: TClass);
begin
 AddEndPoint(wmtPOST, Path, ACallBack, RequireAuth, EntityClass);
end;
{$ENDIF}

procedure TD2BridgeRestServer.AddPut(const Path: string;
  ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean;
  EntityClass: TClass);
begin
 AddEndPoint(wmtPUT, Path, ACallBack, RequireAuth, EntityClass);
end;

{$IFDEF FPC}
procedure TD2BridgeRestServer.AddPut(const Path: string; ACallBack: TD2BridgeRestRouteMethodCallBack; RequireAuth: boolean; EntityClass: TClass);
begin
 AddEndPoint(wmtPUT, Path, ACallBack, RequireAuth, EntityClass);
end;
{$ENDIF}

end.
