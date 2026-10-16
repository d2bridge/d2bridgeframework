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

unit D2Bridge.Rest.Interfaces;

interface

Uses
 Classes, SysUtils, Generics.Collections,
 Prism.Types,
 Prism.Server.HTTP.Commom, Prism.Security.Interfaces,
 D2Bridge.Rest.Route.CallBack, D2Bridge.Rest.Session.Event;


type
 ID2BridgeRestRequest = interface;
 ID2BridgeRestSecurity = interface;
 ID2BridgeRestOptions = interface;


 ID2BridgeRestClient = interface
  ['{D3CDBE09-C101-41FA-828A-82A172F522A0}']
   //function Post(AEndPoint: string): ID2BridgeRestRequest;
   function Send(ARestRequest: ID2BridgeRestRequest): TPrismHTTPResponse;
 end;

 ID2BridgeRestServer = interface
  ['{4EFFBC40-FA8B-444C-BB6C-0600F7FC0B5E}']
   function GetOnCloseRestSession: TOnRestSession;
   function GetOnNewRestSession: TOnRestSession;
   procedure SetOnCloseRestSession(const Value: TOnRestSession);
   procedure SetOnNewRestSession(const Value: TOnRestSession);
   function GetOnBeforeRestMethod: TOnBeforeRestMethod;
   procedure SetOnBeforeRestMethod(const Value: TOnBeforeRestMethod);
   function GetOnAfterRestMethod: TOnAfterRestMethod;
   procedure SetOnAfterRestMethod(const Value: TOnAfterRestMethod);

   procedure AddEndPoint(AWebMethod: TPrismWebMethod; const Path: string; ACallBack: TD2BridgeRestRouteCallBack); overload;
   procedure AddEndPoint(AWebMethod: TPrismWebMethod; const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;
   procedure AddGet(const Path: string; ACallBack: TD2BridgeRestRouteCallBack); overload;
   procedure AddGet(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;
   procedure AddGet(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean; EntityClass: TClass); overload;
 {$IFDEF FPC}
    procedure AddGet(const Path: string; ACallBack: TD2BridgeRestRouteMethodCallBack; RequireAuth: boolean; EntityClass: TClass); overload;
 {$ENDIF}
   procedure AddPost(const Path: string; ACallBack: TD2BridgeRestRouteCallBack); overload;
   procedure AddPost(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;
   procedure AddPost(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean; EntityClass: TClass); overload;
{$IFDEF FPC}
   procedure AddPost(const Path: string; ACallBack: TD2BridgeRestRouteMethodCallBack; RequireAuth: boolean; EntityClass: TClass); overload;
{$ENDIF}
   procedure AddPut(const Path: string; ACallBack: TD2BridgeRestRouteCallBack); overload;
   procedure AddPut(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;
   procedure AddPut(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean; EntityClass: TClass); overload;
{$IFDEF FPC}
   procedure AddPut(const Path: string; ACallBack: TD2BridgeRestRouteMethodCallBack; RequireAuth: boolean; EntityClass: TClass); overload;
{$ENDIF}
   procedure AddPatch(const Path: string; ACallBack: TD2BridgeRestRouteCallBack); overload;
   procedure AddPatch(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;
   procedure AddPatch(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean; EntityClass: TClass); overload;
{$IFDEF FPC}
   procedure AddPatch(const Path: string; ACallBack: TD2BridgeRestRouteMethodCallBack; RequireAuth: boolean; EntityClass: TClass); overload;
{$ENDIF}
   procedure AddDelete(const Path: string; ACallBack: TD2BridgeRestRouteCallBack); overload;
   procedure AddDelete(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;
   procedure AddDelete(const Path: string; ACallBack: TD2BridgeRestRouteCallBack; RequireAuth: boolean; EntityClass: TClass); overload;
{$IFDEF FPC}
   procedure AddDelete(const Path: string; ACallBack: TD2BridgeRestRouteMethodCallBack; RequireAuth: boolean; EntityClass: TClass); overload;
{$ENDIF}

   property OnCloseRestSession: TOnRestSession read GetOnCloseRestSession write SetOnCloseRestSession;
   property OnNewRestSession: TOnRestSession read GetOnNewRestSession write SetOnNewRestSession;
   property OnBeforeRestMethod: TOnBeforeRestMethod read GetOnBeforeRestMethod write SetOnBeforeRestMethod;
   property OnAfterRestMethod: TOnAfterRestMethod read GetOnAfterRestMethod write SetOnAfterRestMethod;
 end;

 ID2BridgeRestEntity = interface
  ['{E75562D7-0244-441C-AAEF-3500BFE9B3FC}']
 end;

 ID2BridgeRestRoute = interface
  ['{7631BDA1-C873-4725-918F-3E208F94C441}']
   function GetCallBack: TD2BridgeRestRouteCallBack;
   function GetPath: string;
   function GetWebMethod: TPrismWebMethod;
   procedure SetCallBack(const Value: TD2BridgeRestRouteCallBack);
   procedure SetPath(const Value: string);
   procedure SetWebMethod(const Value: TPrismWebMethod);
   function GetRequireJWT: Boolean;
   procedure SetRequireJWT(const Value: Boolean);
{$IFDEF FPC}
   function GetMethodCallBack: TD2BridgeRestRouteMethodCallBack;
   procedure SetMethodCallBack(const Value: TD2BridgeRestRouteMethodCallBack);
{$ENDIF}

   function NormalizedPath: string;

   property WebMethod: TPrismWebMethod read GetWebMethod write SetWebMethod;
   property Path: string read GetPath write SetPath;
   property CallBack: TD2BridgeRestRouteCallBack read GetCallBack write SetCallBack;
{$IFDEF FPC}
   property MethodCallBack: TD2BridgeRestRouteMethodCallBack read GetMethodCallBack write SetMethodCallBack;
{$ENDIF}
   property RequireJWT: Boolean read GetRequireJWT write SetRequireJWT;
 end;


 ID2BridgeRestRoutes = interface
   ['{748C58AA-1465-4515-A451-7BEEAD591517}']
   function GetItems: TList<ID2BridgeRestRoute>;

   Procedure Clear;

   procedure Add(AD2BridgeRestRoute: ID2BridgeRestRoute); overload;
   procedure Add(AWebMethod: TPrismWebMethod; APath: string; ARouteCallBack:TD2BridgeRestRouteCallBack); overload;
   procedure Add(AWebMethod: TPrismWebMethod; APath: string; ARouteCallBack:TD2BridgeRestRouteCallBack; RequireAuth: boolean); overload;
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

   function GetRoute(const AWebMethod: TPrismWebMethod; const APath: String): ID2BridgeRestRoute;

   property Item[const AWebMethod: TPrismWebMethod; const APath: String]: ID2BridgeRestRoute read GetRoute;

   property Items: TList<ID2BridgeRestRoute> read GetItems;
 end;


 ID2BridgeRest = interface
  ['{D3CDBE09-C101-41FA-828A-82A172F522A0}']
   function Routes: ID2BridgeRestRoutes;
   function Client: ID2BridgeRestClient;
   function Server: ID2BridgeRestServer;
   function Security: ID2BridgeRestSecurity;
   function Options: ID2BridgeRestOptions;
 end;


 ID2BridgeRestRequest = interface
  ['{99B0BF97-FBAA-4C45-87DF-80BAD517FE30}']
   function GetEndPoint: string;
   function GetAuthTokenBearer: string;
   function GetContentType: string;
   function GetHost: string;
   function GetUserAgent: string;
   function GetWebMethod: TPrismWebMethod;
   procedure SetEndPoint(const Value: string);
   procedure SetAuthTokenBearer(const Value: string);
   procedure SetContentType(const Value: string);
   procedure SetHost(const Value: string);
   procedure SetUserAgent(const Value: string);
   procedure SetWebMethod(const Value: TPrismWebMethod);

   function RawRequest: string;

   procedure AuthBasic(AUserName, APassword: string);

   procedure AddHeader(const AName, AValue: string);
   procedure AddParam(const AName, AValue: string);
   procedure AddQuery(const AName, AValue: string);

   procedure Body(const AText: string); overload;
   procedure Body(const AStream: TStream); overload;
   procedure SetBodyFromFile(const AFileName: string);

   function Send: TPrismHTTPResponse; overload;
   procedure Send(out AResponse: TPrismHTTPResponse); overload;

   procedure WebMethodGet;
   procedure WebMethodPost;
   procedure WebMethodPut;
   procedure WebMethodPatch;
   procedure WebMethodDelete;

   property EndPoint: string read GetEndPoint write SetEndPoint;
   property AuthTokenBearer: string read GetAuthTokenBearer write SetAuthTokenBearer;
   property ContentType: string read GetContentType write SetContentType;
   property Host: string read GetHost write SetHost;
   property UserAgent: string read GetUserAgent write SetUserAgent;
   property WebMethod: TPrismWebMethod read GetWebMethod write SetWebMethod;
 end;


 ID2BridgeRestSecurity = interface
  ['{E0043FEA-C143-4143-A596-0F92BFCDE85D}']
   function JWTAccess: IPrismSecurityJWT;
   function JWTRefresh: IPrismSecurityJWT;
 end;


 ID2BridgeRestOptions = interface
  ['{BD76B1A4-9F99-470F-9EDE-056F328E09A4}']
   function GetFieldNameLowerCase: Boolean;
   function GetFormatSettings: TFormatSettings;
   function GetMaxRecord: Integer;
   procedure SetFieldNameLowerCase(const Value: Boolean);
   procedure SetFormatSettings(const Value: TFormatSettings);
   procedure SetMaxRecord(const Value: Integer);
   procedure SetShowMetadata(const Value: Boolean);
   function GetShowMetadata: Boolean;
   function GetEnableRESTServerExternal: Boolean;
   procedure SetEnableRESTServerExternal(const Value: Boolean);

   function Security: ID2BridgeRestSecurity;

   property FieldNameLowerCase: Boolean read GetFieldNameLowerCase write SetFieldNameLowerCase;
   property FormatSettings: TFormatSettings read GetFormatSettings write SetFormatSettings;
   property MaxRecord: Integer read GetMaxRecord write SetMaxRecord;
   property ShowMetadata: Boolean read GetShowMetadata write SetShowMetadata;
   property EnableRESTServerExternal: Boolean read GetEnableRESTServerExternal write SetEnableRESTServerExternal;
 end;


implementation

end.
