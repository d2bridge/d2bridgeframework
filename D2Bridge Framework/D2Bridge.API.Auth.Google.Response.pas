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
  Thanks for contribution to this Unit to:
   Joao B. S. Junior
   Phone +55 69 99250-3445
   Email jr.playsoft@gmail.com
 +--------------------------------------------------------------------------+
}

{$I D2Bridge.inc}

unit D2Bridge.API.Auth.Google.Response;

interface

uses
  Classes, SysUtils,
  D2Bridge.Interfaces
  {$IFDEF FMX}

  {$ELSE}

  {$ENDIF}
  ;


type
 TD2BridgeAPIAuthGoogleResponse = class(TInterfacedPersistent, ID2BridgeAPIAuthGoogleResponse)
  private
   FID: string;
   FName: string;
   FEmail: string;
   FURLPicture: string;
   FSuccess: boolean;
  public
   constructor Create(ASuccess: Boolean; AID: string = ''; AName: string = ''; AEmail: string = ''; AURLPicture: string = '');

   function ID: string;
   function Name: string;
   function Email: string;
   function URLPicture: string;
   function Success: boolean;
 end;

implementation

{ TD2BridgeAPIAuthGoogleResponse }

constructor TD2BridgeAPIAuthGoogleResponse.Create(ASuccess: Boolean; AID,
  AName, AEmail, AURLPicture: string);
begin
 FSuccess:= ASuccess;
 FID:= AID;
 FName:= AName;
 FEmail:= AEmail;
 FURLPicture:= AURLPicture;
end;

function TD2BridgeAPIAuthGoogleResponse.Email: string;
begin
 result:= FEmail;
end;

function TD2BridgeAPIAuthGoogleResponse.ID: string;
begin
 result:= FID;
end;

function TD2BridgeAPIAuthGoogleResponse.Name: string;
begin
 result:= FName;
end;

function TD2BridgeAPIAuthGoogleResponse.Success: boolean;
begin
 result:= FSuccess;
end;

function TD2BridgeAPIAuthGoogleResponse.URLPicture: string;
begin
 result:= FURLPicture;
end;

end.