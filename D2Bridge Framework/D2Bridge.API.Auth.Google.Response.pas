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
