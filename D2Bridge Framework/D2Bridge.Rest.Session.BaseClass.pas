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

unit D2Bridge.Rest.Session.BaseClass;

interface

uses
  Classes, SysUtils,
  Prism.Types,
  D2Bridge.Rest.Session.Interfaces;


type
 TD2BridgeRestSessionBaseClass = class(TComponent, ID2BridgeRestSessionBaseClass)
  private
   FData: TObject;
   FPath: string;
   FRequireJWT: Boolean;
   FWebMethod: TPrismWebMethod;
  protected
   function GetData: TObject;
   function GetPath: string;
   function GetRequireJWT: Boolean;
   function GetWebMethod: TPrismWebMethod;
   procedure SetData(const Value: TObject);
   procedure SetPath(const Value: string);
   procedure SetRequireJWT(const Value: Boolean);
   procedure SetWebMethod(const Value: TPrismWebMethod);

  public
   constructor Create; reintroduce;

   function WebMethodStr: string;

   property Data: TObject read GetData write SetData;

   property Path: string read GetPath write SetPath;
   property RequireJWT: Boolean read GetRequireJWT write SetRequireJWT;
   property WebMethod: TPrismWebMethod read GetWebMethod write SetWebMethod;
 end;


implementation

{ TD2BridgeRestSessionBaseClass }

constructor TD2BridgeRestSessionBaseClass.Create;
begin
 inherited Create(nil);

end;

function TD2BridgeRestSessionBaseClass.GetData: TObject;
begin
 Result := FData;
end;

function TD2BridgeRestSessionBaseClass.GetPath: string;
begin
 Result := FPath;
end;

function TD2BridgeRestSessionBaseClass.GetRequireJWT: Boolean;
begin
 Result := FRequireJWT;
end;

function TD2BridgeRestSessionBaseClass.GetWebMethod: TPrismWebMethod;
begin
 Result := FWebMethod;
end;

procedure TD2BridgeRestSessionBaseClass.SetData(const Value: TObject);
begin
 FData := Value;
end;

procedure TD2BridgeRestSessionBaseClass.SetPath(const Value: string);
begin
 FPath := Value;
end;

procedure TD2BridgeRestSessionBaseClass.SetRequireJWT(const Value: Boolean);
begin
 FRequireJWT := Value;
end;

procedure TD2BridgeRestSessionBaseClass.SetWebMethod(const Value:
    TPrismWebMethod);
begin
 FWebMethod := Value;
end;


function TD2BridgeRestSessionBaseClass.WebMethodStr: string;
begin
 result:= '';

 if WebMethod = TPrismWebMethod.wmtGET then
  result:= 'GET'
  else
   if WebMethod = TPrismWebMethod.wmtPOST then
    result:= 'POST'
   else
    if WebMethod = TPrismWebMethod.wmtPUT then
     result:= 'PUT'
    else
     if WebMethod = TPrismWebMethod.wmtDELETE then
      result:= 'DELETE'
     else
      if WebMethod = TPrismWebMethod.wmtPATCH then
       result:= 'PATCH'
      else
       if WebMethod = TPrismWebMethod.wmtHEAD then
        result:= 'HEAD'
end;

end.