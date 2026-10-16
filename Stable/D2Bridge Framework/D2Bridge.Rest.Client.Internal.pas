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

unit D2Bridge.Rest.Client.Internal;

interface

uses
  Classes, SysUtils, Generics.Collections, DateUtils,
{$IFNDEF FPC}

{$ELSE}

{$ENDIF}
  Prism.Types, Prism.Server.HTTP.Commom,
  D2Bridge.JSON, D2Bridge.Rest.Interfaces, D2Bridge.Rest.Request;


type
 TD2BridgeRestClient = class(TInterfacedPersistent, ID2BridgeRestClient)
  private

  public
   function Send(ARestRequest: ID2BridgeRestRequest): TPrismHTTPResponse;
 end;

implementation

uses
 D2Bridge.Rest, D2Bridge.Rest.Route,
 Prism.Util, Prism.BaseClass;

{ TD2BridgeRestClient }

function TD2BridgeRestClient.Send(ARestRequest: ID2BridgeRestRequest): TPrismHTTPResponse;
var
 vRequest: TPrismHTTPRequest;
 vResponse: TPrismHTTPResponse;
 vRestRequest: TD2BridgeRestRequest;
begin
 vResponse:= TPrismHTTPResponse.Create;
 vRequest:= PrismBaseClass.PrismServer.ParseHeaders(nil, ARestRequest.RawRequest);

 if Assigned(vRequest.Route) and
    ((vRequest.Route as TD2BridgeRestRoute).RequireJWT) and (not vRequest.JWTvalid) then //Route not Authenticate
 begin
  vResponse.StatusCode:= 403;
  vResponse.ContentType:= 'application/json; charset=UTF-8';
  vResponse.Error:= true;
  vResponse.JSON.AddPair('error', 'forbidden');
  vResponse.JSON.AddPair('error_description', 'You are not authorized to access this endpoint.');
 end else
  if Assigned(vRequest.Route) then
  begin
   (vRequest.Route as TD2BridgeRestRoute).DoCallBack(vRequest, vResponse);

   if (vResponse.FileName = '') and (vResponse.Content = '') and (not vResponse.InitializedJSON) then
   begin
    vResponse.ContentType:= 'application/json';
    if vResponse.StatusCode = '200' then
    begin
     vResponse.Error:= true;
     vResponse.StatusCode := '422';
     vResponse.JSON.AddPair('error', 'unprocessable_entity');
     vResponse.JSON.AddPair('error_description', 'The request could not be processed due to semantic errors.');
    end else
     if vResponse.StatusCode = '404' then
     begin
      vResponse.Error:= true;
      vResponse.JSON.AddPair('error', 'unprocessable_entity');
      vResponse.JSON.AddPair('error_description', 'The requested resource was not found.');
     end;
   end;
  end else //no route
  begin
   vResponse.StatusCode:= '403';
   vResponse.ContentType:= 'application/json; charset=UTF-8';
   vResponse.Error:= true;
   vResponse.JSON.AddPair('error', 'Forbidden');
   vResponse.JSON.AddPair('error_description', 'You are not authorized to access this endpoint');
  end;

 vRequest.Free;

// if vResponse.IsJSONArray then
//  result:= vResponse.JSON.GetValue('jsonarray');
// else
  result:= vResponse;
end;

end.