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

unit D2Bridge.Rest;

interface

uses
  Classes, SysUtils, Generics.Collections, DateUtils,
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
{$IFNDEF FPC}

{$ELSE}

{$ENDIF}
  Prism.Server.HTTP.Commom,
  D2Bridge.Rest.Client.Internal, D2Bridge.Rest.Request, D2Bridge.Rest.Route.CallBack,
  D2Bridge.Rest.Interfaces, D2Bridge.Rest.Session;


type
 TPrismHTTPRequest = Prism.Server.HTTP.Commom.TPrismHTTPRequest;
 TPrismHTTPResponse = Prism.Server.HTTP.Commom.TPrismHTTPResponse;
 TD2BridgeRestRouteCallBack = D2Bridge.Rest.Route.CallBack.TD2BridgeRestRouteCallBack;
 TD2BridgeRestRequest = D2Bridge.Rest.Request.TD2BridgeRestRequest;
 TD2BridgeRestSession = D2Bridge.Rest.Session.TD2BridgeRestSession;


type
 TD2BridgeRest = class(TInterfacedPersistent, ID2BridgeRest)
  private
   FRoutes: ID2BridgeRestRoutes;
   FClient: ID2BridgeRestClient;
   FServer: ID2BridgeRestServer;
   FSecurity: ID2BridgeRestSecurity;
   FOptions: ID2BridgeRestOptions;
  public
   constructor Create;
   destructor Destroy; override;

   function Routes: ID2BridgeRestRoutes;
   function Client: ID2BridgeRestClient;
   function Server: ID2BridgeRestServer;
   function Security: ID2BridgeRestSecurity;
   function Options: ID2BridgeRestOptions;
 end;

var
 D2BridgeRest: TD2BridgeRest;

implementation

uses
 Prism.BaseClass,
 D2Bridge.Rest.Server, D2Bridge.Rest.Route, D2Bridge.Rest.Security, D2Bridge.Rest.Options;



{ TD2BridgeRest }

function TD2BridgeRest.Client: ID2BridgeRestClient;
begin
 result:= FClient;
end;

constructor TD2BridgeRest.Create;
begin
 inherited;

 D2BridgeRest:= self;

 FRoutes:= TD2BridgeRestRoutes.Create;
 FClient:= TD2BridgeRestClient.Create;
 FServer:= TD2BridgeRestServer.Create;
 FSecurity:= TD2BridgeRestSecurity.Create;
 FOptions:= TD2BridgeRestOptions.Create;
end;

destructor TD2BridgeRest.Destroy;
var
 vRoutes: TD2BridgeRestRoutes;
 vClient: TD2BridgeRestClient;
 vServer: TD2BridgeRestServer;
 vSecurity: TD2BridgeRestSecurity;
 vOptions: TD2BridgeRestOptions;
begin
 vRoutes:= FRoutes as TD2BridgeRestRoutes;
 FRoutes:= nil;
 vRoutes.Free;

 vClient:= FClient as TD2BridgeRestClient;
 FClient:= nil;
 vClient.Free;

 vServer:= FServer as TD2BridgeRestServer;
 FServer:= nil;
 vServer.Free;

 vSecurity:= FSecurity as TD2BridgeRestSecurity;
 FSecurity:= nil;
 vSecurity.Free;

 vOptions:= FOptions as TD2BridgeRestOptions;
 FOptions:= nil;
 vOptions.Free;

 inherited;
end;

function TD2BridgeRest.Options: ID2BridgeRestOptions;
begin
 result:= FOptions;
end;

function TD2BridgeRest.Routes: ID2BridgeRestRoutes;
begin
 Result:= FRoutes;
end;

function TD2BridgeRest.Security: ID2BridgeRestSecurity;
begin
 result:= FSecurity;
end;

function TD2BridgeRest.Server: ID2BridgeRestServer;
begin
 result:= FServer;
end;

end.