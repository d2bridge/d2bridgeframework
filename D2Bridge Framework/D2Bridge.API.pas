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

unit D2Bridge.API;

interface

uses
  Classes, SysUtils,
  D2Bridge.Interfaces, Prism.Interfaces
  {$IFDEF FMX}

  {$ELSE}

  {$ENDIF}
  ;


type
 TD2BridgeAPI = class(TInterfacedPersistent, ID2BridgeAPI)
  private
   FMail: ID2BridgeAPIMail;
   FAuth: ID2BridgeAPIAuth;
   FEvolution: ID2BridgeAPIEvolution;
   FStorage: ID2BridgeAPIStorage;
   FD2Docker: ID2BridgeAPID2Docker;
  public
   constructor Create;
   destructor Destroy; override;

   function Mail: ID2BridgeAPIMail;
   function Auth: ID2BridgeAPIAuth;
   function Evolution: ID2BridgeAPIEvolution;
   function Storage: ID2BridgeAPIStorage;
{$IFDEF D2DOCKER}
   function D2Docker: ID2BridgeAPID2Docker;
{$ENDIF}
 end;


implementation

uses
  D2Bridge.API.Mail,
  D2Bridge.API.Auth,
{$IFDEF D2DOCKER}
  D2Bridge.API.D2Docker,
{$ENDIF}
  D2Bridge.API.Storage;

{ TD2BridgeAPI }

constructor TD2BridgeAPI.Create;
begin
 inherited;

 FMail := TD2BridgeAPIMail.Create;
 FAuth := TD2BridgeAPIAuth.Create;
 //FEvolution := TD2BridgeAPIEvolution.Create;
 FStorage := TD2BridgeAPIStorage.Create;

{$IFDEF D2DOCKER}
 FD2Docker:= TD2BridgeAPIDocker.Create;
{$ENDIF}
end;

{$IFDEF D2DOCKER}
function TD2BridgeAPI.D2Docker: ID2BridgeAPID2Docker;
begin
 result:= FD2Docker;
end;
{$ENDIF}

destructor TD2BridgeAPI.Destroy;
var
 vMail: TD2BridgeAPIMail;
 vAuth: TD2BridgeAPIAuth;
 vStorage: TD2BridgeAPIStorage;
{$IFDEF D2DOCKER}
 vD2Docker: TD2BridgeAPIDocker;
{$ENDIF}
begin
 vMail:= FMail as TD2BridgeAPIMail;
 FMail:= nil;
 vMail.Free;

 vAuth:= FAuth as TD2BridgeAPIAuth;
 FAuth:= nil;
 vAuth.Free;

 vStorage:= FStorage as TD2BridgeAPIStorage;
 FStorage:= nil;
 vStorage.Free;

{$IFDEF D2DOCKER}
 vD2Docker:= FD2Docker as TD2BridgeAPIDocker;
 FD2Docker:= nil;
 vD2Docker.Free;
{$ENDIF}

 inherited;
end;

function TD2BridgeAPI.Storage: ID2BridgeAPIStorage;
begin
 result:= FStorage;
end;

function TD2BridgeAPI.Evolution: ID2BridgeAPIEvolution;
begin
 result:= FEvolution;
end;

function TD2BridgeAPI.Auth: ID2BridgeAPIAuth;
begin
 result:= FAuth;
end;

function TD2BridgeAPI.Mail: ID2BridgeAPIMail;
begin
 result:= FMail;
end;

end.