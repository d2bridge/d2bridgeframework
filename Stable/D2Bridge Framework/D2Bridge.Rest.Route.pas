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

unit D2Bridge.Rest.Route;

interface

uses
  Classes, SysUtils, Generics.Collections, DateUtils, Variants,
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
{$IFNDEF FPC}

{$ELSE}

{$ENDIF}
  D2Bridge.Rest.Interfaces, D2Bridge.Rest.Route.CallBack, D2Bridge.Rest.Session.Event,
  Prism.Types, Prism.Server.HTTP.Commom, D2Bridge.Types, D2Bridge.Rest.Entity;


type
 TD2BridgeRestEntityClass = class of TD2BridgeRestEntity;

 TD2BridgeRestRoutes = class;

 { TD2BridgeRestRoute }

 TD2BridgeRestRoute = class(TInterfacedPersistent, ID2BridgeRestRoute)
  private
   FCallBack: TD2BridgeRestRouteCallBack;
{$IFDEF FPC}
   FMethodCallBack: TD2BridgeRestRouteMethodCallBack;
{$ENDIF}
   FPath: string;
   FWebMethod: TPrismWebMethod;
   FNormalizedPath: string;
   FRequireJWT: Boolean;
   FRouteEntityClass: TD2BridgeRestEntityClass;
   function GetCallBack: TD2BridgeRestRouteCallBack;
   function GetPath: string;
   function GetWebMethod: TPrismWebMethod;
   procedure SetCallBack(const Value: TD2BridgeRestRouteCallBack);
   procedure SetPath(const Value: string);
   procedure SetWebMethod(const Value: TPrismWebMethod);
   procedure CheckPathForbidden(const APath: string);
   function GetRequireJWT: Boolean;
   function GetRouteEntityClass: TD2BridgeRestEntityClass;
   function NormalizePath(const APath: string): string;
   procedure ParseParams(AurlPath: string; AParams: TStrings);
   procedure SetRequireJWT(const Value: Boolean);
   procedure SetRouteEntityClass(const Value: TD2BridgeRestEntityClass);
{$IFDEF FPC}
   function GetMethodCallBack: TD2BridgeRestRouteMethodCallBack;
   procedure SetMethodCallBack(const Value: TD2BridgeRestRouteMethodCallBack);
{$ENDIF}
  protected
  public
   constructor Create;

   procedure DoCallBack(const Request: TPrismHTTPRequest; Response: TPrismHTTPResponse);

   function NormalizedPath: string;

{$IFDEF FPC}
   property MethodCallBack: TD2BridgeRestRouteMethodCallBack read GetMethodCallBack write SetMethodCallBack;
{$ENDIF}

   property CallBack: TD2BridgeRestRouteCallBack read GetCallBack write SetCallBack;
   property Path: string read GetPath write SetPath;
   property RequireJWT: Boolean read GetRequireJWT write SetRequireJWT;
   property RouteEntityClass: TD2BridgeRestEntityClass read GetRouteEntityClass write SetRouteEntityClass;
   property WebMethod: TPrismWebMethod read GetWebMethod write SetWebMethod;
 end;



 { TD2BridgeRestRoutes }

 TD2BridgeRestRoutes = class(TInterfacedPersistent, ID2BridgeRestRoutes)
  private
   FItems: TList<ID2BridgeRestRoute>;
   function MatchPath(const RoutePath, UrlPath: string): Boolean;
   function GetRoute(const AWebMethod: TPrismWebMethod; const APath: String): ID2BridgeRestRoute;
  protected

  public
   constructor Create;
   destructor Destroy; override;

   function GetItems: TList<ID2BridgeRestRoute>;

   Procedure Clear;

   procedure Add(AD2BridgeRestRoute: ID2BridgeRestRoute); overload;
   procedure Add(AWebMethod: TPrismWebMethod; APath: string; ARouteCallBack:TD2BridgeRestRouteCallBack); overload;
   procedure Add(AWebMethod: TPrismWebMethod; APath: string; ARouteCallBack:TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;
   procedure Add(AWebMethod: TPrismWebMethod; APath: string; ARouteCallBack:TD2BridgeRestRouteCallBack; RequireAuth: boolean; RestEntityClass: TD2BridgeRestEntityClass); overload;
{$IFDEF FPC}
   procedure Add(AWebMethod: TPrismWebMethod; APath: string; ARouteCallBack:TD2BridgeRestRouteMethodCallBack; RequireAuth: boolean; RestEntityClass: TD2BridgeRestEntityClass); overload;
{$ENDIF}
   procedure AddGet(APath: string; ARouteCallBack:TD2BridgeRestRouteCallBack); overload;
   procedure AddPost(APath: string; ARouteCallBack:TD2BridgeRestRouteCallBack); overload;
   procedure AddPut(APath: string; ARouteCallBack:TD2BridgeRestRouteCallBack); overload;
   procedure AddDelete(APath: string; ARouteCallBack:TD2BridgeRestRouteCallBack); overload;
   procedure AddPatch(APath: string; ARouteCallBack:TD2BridgeRestRouteCallBack); overload;
   procedure AddGet(APath: string; ARouteCallBack:TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;
   procedure AddPost(APath: string; ARouteCallBack:TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;
   procedure AddPut(APath: string; ARouteCallBack:TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;
   procedure AddDelete(APath: string; ARouteCallBack:TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;
   procedure AddPatch(APath: string; ARouteCallBack:TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;

   function Delete(AWebMethod: TPrismWebMethod; APath: string): Boolean;
   function DeleteGet(APath: string): Boolean;
   function DeletePost(APath: string): Boolean;
   function DeletePut(APath: string): Boolean;
   function DeleteDelete(APath: string): Boolean;
   function DeletePatch(APath: string): Boolean;

   function Route(AWebMethod: TPrismWebMethod; APath: string): ID2BridgeRestRoute;
   function RouteGet(APath: string): ID2BridgeRestRoute;
   function RoutePost(APath: string): ID2BridgeRestRoute;
   function RoutePut(APath: string): ID2BridgeRestRoute;
   function RouteDelete(APath: string): ID2BridgeRestRoute;
   function RoutePatch(APath: string): ID2BridgeRestRoute;

   function Exist(AWebMethod: TPrismWebMethod; APath: string): Boolean;

   property Item[const AWebMethod: TPrismWebMethod; const APath: String]: ID2BridgeRestRoute read GetRoute;

   property Items: TList<ID2BridgeRestRoute> read GetItems;
 end;


implementation

Uses
 Prism.BaseClass,
 D2Bridge.Rest.Session, D2Bridge.Rest.Server;


procedure TD2BridgeRestRoute.CheckPathForbidden(const APath: string);
begin
 if SameText(APath, 'websocket') or
    SameText(APath, 'rest') or
    SameText(APath, 'd2bridge') or
    (Pos(APath, 'rest/') = 1) or
    (Pos(APath, 'd2bridge/') = 1) then
 begin
  if IsDebuggerPresent then
   raise Exception.Create('The route "Path" cannot can use, this path is keyword reserved');
 end;

end;

constructor TD2BridgeRestRoute.Create;
begin
 inherited;

 FRequireJWT:= false;
end;

procedure TD2BridgeRestRoute.DoCallBack(const Request: TPrismHTTPRequest; Response: TPrismHTTPResponse);
var
 vRestSession: TD2BridgeRestSession;
 vRestServer: TD2BridgeRestServer;
 vCanExecute: boolean;
 vHttpStatusCode: integer;
begin
 try
  vCanExecute:= true;

  vRestServer:= PrismBaseClass.Rest.Server as TD2BridgeRestServer;


  if Pos(':', FPath) > 0 then
   ParseParams(Request.Path, Request.Params);


  try
   vRestSession:= nil;
   vRestSession:= TD2BridgeRestSession.Create;
  except
   if Assigned(vRestSession) then
    vRestSession.Free;

   exit;
  end;

  vRestSession.Path:= Path;
  vRestSession.RequireJWT:= RequireJWT;
  vRestSession.WebMethod:= WebMethod;


  //OnNewSession
  try
   if Assigned(vRestServer.OnNewRestSession) then
    vRestServer.OnNewRestSession(vRestSession);
  except
  end;
  try
   if Assigned(FRouteEntityClass) then
    FRouteEntityClass.OnNewRestSession(vRestSession);
  except
  end;

  //OnBeforeRestMethod
  try
   if Assigned(vRestServer.OnBeforeRestMethod) then
   begin
    vRestServer.OnBeforeRestMethod(vRestSession, Request, Response, vCanExecute);
    if vCanExecute then
    begin
     if VarIsNumeric(Response.StatusCode) and (TryStrToInt(Response.StatusCode, vHttpStatusCode)) then
      vCanExecute:= vHttpStatusCode in [200..226];
    end;
   end;
  except
  end;
  try
   if Assigned(FRouteEntityClass) then
    FRouteEntityClass.OnBeforeRestMethod(vRestSession, Request, Response, vCanExecute);
  except
  end;

  //Rest Method
  if vCanExecute then
  begin
   try
    PrismBaseClass.DoRoute(vRestSession, Request, Response);
   except
   end;

   try
    if Assigned(CallBack) then
     CallBack(vRestSession, Request, Response);
{$IFDEF FPC}
    if Assigned(MethodCallBack) then
     MethodCallBack(vRestSession, Request, Response);
{$ENDIF}
   except on E: Exception do
{$IFDEF MSWINDOWS}
   try
    if IsDebuggerPresent and (not PrismBaseClass.IsD2DockerContext) then
     raise Exception.Create(E.Message);
   except;
   end;
{$ENDIF}
   end;
  end;

  //OnAfterRestMethod
  try
   if Assigned(vRestServer.OnAfterRestMethod) then
    vRestServer.OnAfterRestMethod(vRestSession, Request, Response);
  except
  end;
  try
   if Assigned(FRouteEntityClass) then
    FRouteEntityClass.OnAfterRestMethod(vRestSession, Request, Response);
  except
  end;

  //OnCloseSession
  try
   if Assigned(vRestServer.OnCloseRestSession) then
    vRestServer.OnCloseRestSession(vRestSession);
  except
  end;
  try
   vRestSession.Free;
  except
  end;
 except on E: Exception do
   if not SameText(e.Message, 'Operation aborted') then
   begin
    try
     if Assigned(vRestSession) then
      vRestSession.Free;
    except
    end;

    try
     PrismBaseClass.DoException(self, E, nil, 'Route: '+Self.FPath);
    except
    end;
   end;
 end;
end;

function TD2BridgeRestRoute.GetCallBack: TD2BridgeRestRouteCallBack;
begin
 Result := FCallBack;
end;

function TD2BridgeRestRoute.GetPath: string;
begin
 Result := FPath;
end;

function TD2BridgeRestRoute.GetRequireJWT: Boolean;
begin
 Result := FRequireJWT;
end;

function TD2BridgeRestRoute.GetRouteEntityClass: TD2BridgeRestEntityClass;
begin
 Result := FRouteEntityClass;
end;

function TD2BridgeRestRoute.GetWebMethod: TPrismWebMethod;
begin
 Result := FWebMethod;
end;

function TD2BridgeRestRoute.NormalizedPath: string;
begin
 result:= FNormalizedPath;
end;

function TD2BridgeRestRoute.NormalizePath(const APath: string): string;
begin
 // Converte {id} ? :id, <id> ? :id
 Result := APath;
 Result := StringReplace(Result, '{', ':', [rfReplaceAll]);
 Result := StringReplace(Result, '}', '', [rfReplaceAll]);
 Result := StringReplace(Result, '<', ':', [rfReplaceAll]);
 Result := StringReplace(Result, '>', '', [rfReplaceAll]);
end;

procedure TD2BridgeRestRoute.ParseParams(AurlPath: string; AParams: TStrings);
var
  RouteParts, UrlParts: TArray<string>;
  I: Integer;
begin
 AParams.Clear;

 RouteParts := Path.Split(['/']);
 UrlParts := AurlPath.Split(['/']);

 for I := 0 to High(RouteParts) do
 begin
  if (RouteParts[I].StartsWith(':')) then
   AParams.Values[Copy(RouteParts[I], 2, MaxInt)] := UrlParts[I];
 end;
end;

procedure TD2BridgeRestRoute.SetCallBack(const Value: TD2BridgeRestRouteCallBack);
begin
 FCallBack := Value;
end;

procedure TD2BridgeRestRoute.SetPath(const Value: string);
begin
 FPath := Value;

 FNormalizedPath:= NormalizePath(FPath);

 CheckPathForbidden(FPath);
end;

procedure TD2BridgeRestRoute.SetRequireJWT(const Value: Boolean);
begin
 FRequireJWT := Value;
end;

procedure TD2BridgeRestRoute.SetRouteEntityClass(const Value: TD2BridgeRestEntityClass);
begin
 FRouteEntityClass := Value;
end;

{$IFDEF FPC}
function TD2BridgeRestRoute.GetMethodCallBack: TD2BridgeRestRouteMethodCallBack;
begin
 result:= FMethodCallBack;
end;
{$ENDIF}

{$IFDEF FPC}
procedure TD2BridgeRestRoute.SetMethodCallBack(const Value: TD2BridgeRestRouteMethodCallBack);
begin
 FMethodCallBack:= Value;
end;
{$ENDIF}

procedure TD2BridgeRestRoute.SetWebMethod(const Value: TPrismWebMethod);
begin
 FWebMethod := Value;
end;

{ TD2BridgeRestRoutes }

procedure TD2BridgeRestRoutes.Add(AD2BridgeRestRoute: ID2BridgeRestRoute);
begin
 FItems.Add(AD2BridgeRestRoute);
end;

procedure TD2BridgeRestRoutes.Add(AWebMethod: TPrismWebMethod; APath: string; ARouteCallBack: TD2BridgeRestRouteCallBack);
begin
 Add(AWebMethod, APath, ARouteCallBack, false);
end;

procedure TD2BridgeRestRoutes.Add(AWebMethod: TPrismWebMethod; APath: string;
  ARouteCallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean);
begin
 Add(AWebMethod, APath, ARouteCallBack, false, nil);
end;

procedure TD2BridgeRestRoutes.Add(AWebMethod: TPrismWebMethod;
  APath: string; ARouteCallBack: TD2BridgeRestRouteCallBack;
  RequireAuth: boolean; RestEntityClass: TD2BridgeRestEntityClass);
var
 vD2BridgeRestRoute: TD2BridgeRestRoute;
begin
 if APath = '' then
  raise Exception.Create('EndPoint is blank');

 if not APath.StartsWith('/') then
  APath:= '/' + APath;

 if APath.EndsWith('/') then
  APath:= Copy(APath, 1, Length(APath)-1);

 if Exist(AWebMethod, APath) then
  raise Exception.Create('An EndPoint with this path already exists'+#13+'Invalid EndPoint: '+APath);

 vD2BridgeRestRoute:= TD2BridgeRestRoute.Create;
 vD2BridgeRestRoute.WebMethod:= AWebMethod;
 vD2BridgeRestRoute.Path:= APath;
 vD2BridgeRestRoute.CallBack:= ARouteCallBack;
 vD2BridgeRestRoute.RequireJWT:= RequireAuth;
 if Assigned(RestEntityClass) then
  vD2BridgeRestRoute.RouteEntityClass:= RestEntityClass;

 FItems.Add(vD2BridgeRestRoute);

end;

{$IFDEF FPC}
procedure TD2BridgeRestRoutes.Add(AWebMethod: TPrismWebMethod; APath: string; ARouteCallBack: TD2BridgeRestRouteMethodCallBack; RequireAuth: boolean; RestEntityClass: TD2BridgeRestEntityClass);
var
 vD2BridgeRestRoute: TD2BridgeRestRoute;
begin
 if APath = '' then
  raise Exception.Create('EndPoint is blank');

 if not APath.StartsWith('/') then
  APath:= '/' + APath;

 if APath.EndsWith('/') then
  APath:= Copy(APath, 1, Length(APath)-1);

 if Exist(AWebMethod, APath) then
  raise Exception.Create('An EndPoint with this path already exists'+#13+'Invalid EndPoint: '+APath);

 vD2BridgeRestRoute:= TD2BridgeRestRoute.Create;
 vD2BridgeRestRoute.WebMethod:= AWebMethod;
 vD2BridgeRestRoute.Path:= APath;
 vD2BridgeRestRoute.MethodCallBack:= ARouteCallBack;
 vD2BridgeRestRoute.RequireJWT:= RequireAuth;
 if Assigned(RestEntityClass) then
  vD2BridgeRestRoute.RouteEntityClass:= RestEntityClass;

 FItems.Add(vD2BridgeRestRoute);

end;
{$ENDIF}

procedure TD2BridgeRestRoutes.AddDelete(APath: string; ARouteCallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean);
begin
 Add(wmtDELETE, APath, ARouteCallBack, RequireAuth);
end;

procedure TD2BridgeRestRoutes.AddDelete(APath: string; ARouteCallBack: TD2BridgeRestRouteCallBack);
begin
 AddDelete(APath, ARouteCallBack, false);
end;

procedure TD2BridgeRestRoutes.AddGet(APath: string; ARouteCallBack: TD2BridgeRestRouteCallBack);
begin
 AddGet(APath, ARouteCallBack, false);
end;

procedure TD2BridgeRestRoutes.AddPatch(APath: string; ARouteCallBack: TD2BridgeRestRouteCallBack);
begin
 AddPatch(APath, ARouteCallBack, false);
end;

procedure TD2BridgeRestRoutes.AddPost(APath: string; ARouteCallBack: TD2BridgeRestRouteCallBack);
begin
 AddPost(APath, ARouteCallBack, false);
end;

procedure TD2BridgeRestRoutes.AddPut(APath: string; ARouteCallBack: TD2BridgeRestRouteCallBack);
begin
 AddPut(APath, ARouteCallBack, false);
end;

procedure TD2BridgeRestRoutes.Clear;
var
 vD2BridgeRestRouteIntf: ID2BridgeRestRoute;
 vD2BridgeRestRoute: TD2BridgeRestRoute;
begin
 while FItems.Count > 0 do
 begin
  vD2BridgeRestRouteIntf:= FItems.Last;
  FItems.Delete(Pred(FItems.Count));

  try
   vD2BridgeRestRoute:= vD2BridgeRestRouteIntf as TD2BridgeRestRoute;
   vD2BridgeRestRouteIntf:= nil;
   vD2BridgeRestRoute.Free;
  except
  end;
 end;
end;

constructor TD2BridgeRestRoutes.Create;
begin
 inherited;

 FItems:= TList<ID2BridgeRestRoute>.Create;
end;

function TD2BridgeRestRoutes.Delete(AWebMethod: TPrismWebMethod; APath: string): Boolean;
var
 vD2BridgeRestRouteIntf: ID2BridgeRestRoute;
 vD2BridgeRestRoute: TD2BridgeRestRoute;
begin
 vD2BridgeRestRouteIntf:= GetRoute(AWebMethod, APath);

 if Assigned(vD2BridgeRestRouteIntf) then
 begin
  try
   vD2BridgeRestRoute:= vD2BridgeRestRouteIntf as TD2BridgeRestRoute;
   FItems.Remove(vD2BridgeRestRouteIntf);
   vD2BridgeRestRouteIntf:= nil;
   vD2BridgeRestRoute.Free;
  except
  end;
 end;
end;

function TD2BridgeRestRoutes.DeleteDelete(APath: string): Boolean;
begin
 Delete(wmtDELETE, APath);
end;

function TD2BridgeRestRoutes.DeleteGet(APath: string): Boolean;
begin
 Delete(wmtGET, APath);
end;

function TD2BridgeRestRoutes.DeletePatch(APath: string): Boolean;
begin
 Delete(wmtPatch, APath);
end;

function TD2BridgeRestRoutes.DeletePost(APath: string): Boolean;
begin
 Delete(wmtPOST, APath);
end;

function TD2BridgeRestRoutes.DeletePut(APath: string): Boolean;
begin
 Delete(wmtPUT, APath);
end;

destructor TD2BridgeRestRoutes.Destroy;
begin
 Clear;

 FItems.Free;

 inherited;
end;

function TD2BridgeRestRoutes.Exist(AWebMethod: TPrismWebMethod; APath: string): Boolean;
begin
 Result:= Assigned(GetRoute(AWebMethod, APath));
end;

function TD2BridgeRestRoutes.GetItems: TList<ID2BridgeRestRoute>;
begin
 result:= FItems;
end;

function TD2BridgeRestRoutes.GetRoute(const AWebMethod: TPrismWebMethod; const APath: String): ID2BridgeRestRoute;
var
 Route: ID2BridgeRestRoute;
begin
 //Result := False;
 for Route in FItems do
 begin
  if Route.WebMethod = AWebMethod then
  begin
   try
    if MatchPath(Route.NormalizedPath, APath) then
    begin
     Result:= Route;
     Break;
    end;
   except
   end;
  end;
 end;
end;

function TD2BridgeRestRoutes.MatchPath(const RoutePath, UrlPath: string): Boolean;
var
  RouteParts, UrlParts: TArray<string>;
  vUrlPath: string;
  I: Integer;
begin
  Result := False;
  vUrlPath:= UrlPath;

  if vUrlPath.EndsWith('/') then
   vUrlPath:= Copy(vUrlPath, 1, Length(vUrlPath)-1);


  RouteParts := RoutePath.Split(['/']);
  UrlParts := vUrlPath.Split(['/']);

  if Length(RouteParts) <> Length(UrlParts) then
    Exit;

  for I := 0 to High(RouteParts) do
  begin
    if (not RouteParts[I].StartsWith(':')) and (not SameText(RouteParts[I], UrlParts[I])) then
      Exit; // mismatch
  end;

  Result := True;
end;

function TD2BridgeRestRoutes.Route(AWebMethod: TPrismWebMethod; APath: string): ID2BridgeRestRoute;
begin
 Result:= GetRoute(AWebMethod, APath);
end;

function TD2BridgeRestRoutes.RouteDelete(APath: string): ID2BridgeRestRoute;
begin
 result:= Route(wmtDELETE, APath);
end;

function TD2BridgeRestRoutes.RouteGet(APath: string): ID2BridgeRestRoute;
begin
 result:= Route(wmtGET, APath);
end;

function TD2BridgeRestRoutes.RoutePatch(APath: string): ID2BridgeRestRoute;
begin
 result:= Route(wmtPATCH, APath);
end;

function TD2BridgeRestRoutes.RoutePost(APath: string): ID2BridgeRestRoute;
begin
 result:= Route(wmtPOST, APath);
end;

function TD2BridgeRestRoutes.RoutePut(APath: string): ID2BridgeRestRoute;
begin
 result:= Route(wmtPUT, APath);
end;

procedure TD2BridgeRestRoutes.AddGet(APath: string; ARouteCallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean);
begin
 Add(wmtGET, APath, ARouteCallBack, RequireAuth);
end;

procedure TD2BridgeRestRoutes.AddPatch(APath: string; ARouteCallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean);
begin
 Add(wmtPATCH, APath, ARouteCallBack, RequireAuth);
end;

procedure TD2BridgeRestRoutes.AddPost(APath: string; ARouteCallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean);
begin
 Add(wmtPOST, APath, ARouteCallBack, RequireAuth);
end;

procedure TD2BridgeRestRoutes.AddPut(APath: string; ARouteCallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean);
begin
 Add(wmtPUT, APath, ARouteCallBack, RequireAuth);
end;

end.
