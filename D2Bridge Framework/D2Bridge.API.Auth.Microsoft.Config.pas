{
 +--------------------------------------------------------------------------+
  D2Bridge Framework Content

  Author: Talis Jonatas Gomes
  Email: talisjonatas@me.com

  This source code is provided 'as-is', without any express or implied
  warranty. In no event will the author be held liable for any damages
  arising from the use of this code.

  However, it is granted that this code may be used for any purpose,
  including commercial applications, but it may not be modified,
  distributed, or sublicensed without express written authorization from
  the author (Talis Jonatas Gomes). This includes creating derivative works
  or distributing the source code through any means.

  If you use this software in a product, an acknowledgment in the product
  documentation would be appreciated but is not required.

  God bless you
 +--------------------------------------------------------------------------+
  Thanks for contribution to this Unit to:
   João B. S. Junior
   Phone +55 69 99250-3445
   Email jr.playsoft@gmail.com
 +--------------------------------------------------------------------------+
}

{$I D2Bridge.inc}

unit D2Bridge.API.Auth.Microsoft.Config;

interface

uses
  Classes, SysUtils,
  D2Bridge.Interfaces
  {$IFDEF FMX}

  {$ELSE}

  {$ENDIF}
  ;

type
  TD2BridgeAPIAuthMicrosoftConfig = class(TInterfacedPersistent, ID2BridgeAPIAuthMicrosoftConfig)
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

{ TD2BridgeAPIAuthMicrosoftConfig }

function TD2BridgeAPIAuthMicrosoftConfig.GetClientID: string;
begin
 result:= FClientID;
end;

function TD2BridgeAPIAuthMicrosoftConfig.GetClientSecret: string;
begin
 result:= FClienteSecret;
end;


procedure TD2BridgeAPIAuthMicrosoftConfig.SetClientID(const Value: string);
begin
 FClientID:= Value;
end;

procedure TD2BridgeAPIAuthMicrosoftConfig.SetClientSecret(const Value: string);
begin
 FClienteSecret:= Value;
end;

end.
