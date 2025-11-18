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

unit D2Bridge.API.Auth.Google.Config;

interface

uses
  Classes, SysUtils,
  D2Bridge.Interfaces
  {$IFDEF FMX}

  {$ELSE}

  {$ENDIF}
  ;

type
  TD2BridgeAPIAuthGoogleConfig = class(TInterfacedPersistent, ID2BridgeAPIAuthGoogleConfig)
   private
    FClientID: string;
    FClienteSecret: string;
    function GetClientID: string;
    procedure SetClientID(const Value: string);
    function GetClientSecret: string;
    procedure SetClientSecret(const Value: string);
   public
    property ClientID: string read GetClientID write SetClientID;
    property ClientSecret: string read GetClientSecret write SetClientSecret;
  end;

implementation

{ TD2BridgeAPIAuthGoogleConfig }

function TD2BridgeAPIAuthGoogleConfig.GetClientID: string;
begin
 result:= FClientID;
end;

function TD2BridgeAPIAuthGoogleConfig.GetClientSecret: string;
begin
 result:= FClienteSecret;
end;

procedure TD2BridgeAPIAuthGoogleConfig.SetClientID(const Value: string);
begin
 FClientID:= Value;
end;

procedure TD2BridgeAPIAuthGoogleConfig.SetClientSecret(const Value: string);
begin
 FClienteSecret:= Value;
end;

end.