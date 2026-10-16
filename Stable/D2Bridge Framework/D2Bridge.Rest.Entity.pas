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

unit D2Bridge.Rest.Entity;

interface

uses
  Classes, SysUtils, Generics.Collections, DateUtils,
  Prism.Types,
  Prism.Server.HTTP.Commom,
  D2Bridge.Rest.Interfaces, D2Bridge.Rest.Route.CallBack,
  D2Bridge.Rest.Session;


type

 { TD2BridgeRestEntity }

 TD2BridgeRestEntity = class(TInterfacedPersistent, ID2BridgeRestEntity)
  private

  protected
   //Initialize
   class procedure Initialize;

   //Register
   class procedure RegisterEndPoints; virtual; abstract;

   //WebMetods
   class procedure AddGet(const Path: string; ACallBack: {$IFDEF FPC}TD2BridgeRestRouteMethodCallBack{$ELSE}TD2BridgeRestRouteCallBack{$ENDIF}); overload;
   class procedure AddGet(const Path: string; ACallBack: {$IFDEF FPC}TD2BridgeRestRouteMethodCallBack{$ELSE}TD2BridgeRestRouteCallBack{$ENDIF}; RequireAuth: boolean); overload;
   class procedure AddPost(const Path: string; ACallBack: {$IFDEF FPC}TD2BridgeRestRouteMethodCallBack{$ELSE}TD2BridgeRestRouteCallBack{$ENDIF}); overload;
   class procedure AddPost(const Path: string; ACallBack: {$IFDEF FPC}TD2BridgeRestRouteMethodCallBack{$ELSE}TD2BridgeRestRouteCallBack{$ENDIF}; RequireAuth: boolean); overload;
   class procedure AddPut(const Path: string; ACallBack: {$IFDEF FPC}TD2BridgeRestRouteMethodCallBack{$ELSE}TD2BridgeRestRouteCallBack{$ENDIF}); overload;
   class procedure AddPut(const Path: string; ACallBack: {$IFDEF FPC}TD2BridgeRestRouteMethodCallBack{$ELSE}TD2BridgeRestRouteCallBack{$ENDIF}; RequireAuth: boolean); overload;
   class procedure AddPatch(const Path: string; ACallBack: {$IFDEF FPC}TD2BridgeRestRouteMethodCallBack{$ELSE}TD2BridgeRestRouteCallBack{$ENDIF}); overload;
   class procedure AddPatch(const Path: string; ACallBack: {$IFDEF FPC}TD2BridgeRestRouteMethodCallBack{$ELSE}TD2BridgeRestRouteCallBack{$ENDIF}; RequireAuth: boolean); overload;
   class procedure AddDelete(const Path: string; ACallBack: {$IFDEF FPC}TD2BridgeRestRouteMethodCallBack{$ELSE}TD2BridgeRestRouteCallBack{$ENDIF}); overload;
   class procedure AddDelete(const Path: string; ACallBack: {$IFDEF FPC}TD2BridgeRestRouteMethodCallBack{$ELSE}TD2BridgeRestRouteCallBack{$ENDIF}; RequireAuth: boolean); overload;
  public
   //Events
   class procedure OnNewRestSession(const RestSession: TD2BridgeRestSession); virtual;
   class procedure OnCloseRestSession(const RestSession: TD2BridgeRestSession); virtual;
   class procedure OnBeforeRestMethod(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest; Response: TPrismHTTPResponse; CanExecute: boolean); virtual;
   class procedure OnAfterRestMethod(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest; Response: TPrismHTTPResponse); virtual;
 end;


implementation

Uses
 D2Bridge.Rest;


{ TD2BridgeRestEntity }

class procedure TD2BridgeRestEntity.AddGet(const Path: string; ACallBack: {$IFDEF FPC}TD2BridgeRestRouteMethodCallBack{$ELSE}TD2BridgeRestRouteCallBack{$ENDIF});
begin
 AddGet(Path, ACallBack, false);
end;

class procedure TD2BridgeRestEntity.AddDelete(const Path: string;
  ACallBack: {$IFDEF FPC}TD2BridgeRestRouteMethodCallBack{$ELSE}TD2BridgeRestRouteCallBack{$ENDIF}; RequireAuth: boolean);
begin
{$IFDEF D2BRIDGE}
 if not Assigned(D2BridgeRest) then
  TD2BridgeRest.Create;

 D2BridgeRest.Server.AddDelete(Path, ACallBack, RequireAuth, self);
{$ENDIF}
end;

class procedure TD2BridgeRestEntity.AddDelete(const Path: string;
  ACallBack: {$IFDEF FPC}TD2BridgeRestRouteMethodCallBack{$ELSE}TD2BridgeRestRouteCallBack{$ENDIF});
begin
 AddDelete(Path, ACallBack, false);
end;

class procedure TD2BridgeRestEntity.AddGet(const Path: string; ACallBack: {$IFDEF FPC}TD2BridgeRestRouteMethodCallBack{$ELSE}TD2BridgeRestRouteCallBack{$ENDIF}; RequireAuth: boolean);
begin
{$IFDEF D2BRIDGE}
 if not Assigned(D2BridgeRest) then
  TD2BridgeRest.Create;

 D2BridgeRest.Server.AddGet(Path, ACallBack, RequireAuth, self);
{$ENDIF}
end;

class procedure TD2BridgeRestEntity.AddPatch(const Path: string;
  ACallBack: {$IFDEF FPC}TD2BridgeRestRouteMethodCallBack{$ELSE}TD2BridgeRestRouteCallBack{$ENDIF});
begin
 AddPatch(Path, ACallBack, false);
end;

class procedure TD2BridgeRestEntity.AddPatch(const Path: string;
  ACallBack: {$IFDEF FPC}TD2BridgeRestRouteMethodCallBack{$ELSE}TD2BridgeRestRouteCallBack{$ENDIF}; RequireAuth: boolean);
begin
{$IFDEF D2BRIDGE}
 if not Assigned(D2BridgeRest) then
  TD2BridgeRest.Create;

 D2BridgeRest.Server.AddPut(Path, ACallBack, RequireAuth, self);
{$ENDIF}
end;

class procedure TD2BridgeRestEntity.AddPost(const Path: string;
  ACallBack: {$IFDEF FPC}TD2BridgeRestRouteMethodCallBack{$ELSE}TD2BridgeRestRouteCallBack{$ENDIF}; RequireAuth: boolean);
begin
{$IFDEF D2BRIDGE}
 if not Assigned(D2BridgeRest) then
  TD2BridgeRest.Create;

 D2BridgeRest.Server.AddPost(Path, ACallBack, RequireAuth, self);
{$ENDIF}
end;

class procedure TD2BridgeRestEntity.AddPost(const Path: string; ACallBack: {$IFDEF FPC}TD2BridgeRestRouteMethodCallBack{$ELSE}TD2BridgeRestRouteCallBack{$ENDIF});
begin
 AddPost(Path, ACallBack, false);
end;

class procedure TD2BridgeRestEntity.AddPut(const Path: string;
  ACallBack: {$IFDEF FPC}TD2BridgeRestRouteMethodCallBack{$ELSE}TD2BridgeRestRouteCallBack{$ENDIF});
begin
 AddPut(Path, ACallBack, false);
end;

class procedure TD2BridgeRestEntity.AddPut(const Path: string;
  ACallBack: {$IFDEF FPC}TD2BridgeRestRouteMethodCallBack{$ELSE}TD2BridgeRestRouteCallBack{$ENDIF}; RequireAuth: boolean);
begin
{$IFDEF D2BRIDGE}
 if not Assigned(D2BridgeRest) then
  TD2BridgeRest.Create;

 D2BridgeRest.Server.AddPut(Path, ACallBack, RequireAuth, self);
{$ENDIF}
end;

class procedure TD2BridgeRestEntity.Initialize;
begin
 RegisterEndPoints;
end;

class procedure TD2BridgeRestEntity.OnAfterRestMethod(
  const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest;
  Response: TPrismHTTPResponse);
begin

end;

class procedure TD2BridgeRestEntity.OnBeforeRestMethod(
  const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest;
  Response: TPrismHTTPResponse; CanExecute: boolean);
begin

end;

class procedure TD2BridgeRestEntity.OnCloseRestSession(const RestSession: TD2BridgeRestSession);
begin

end;

class procedure TD2BridgeRestEntity.OnNewRestSession(const RestSession: TD2BridgeRestSession);
begin

end;

end.
