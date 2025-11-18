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
   Jo�o B. S. Junior
   Phone +55 69 99250-3445
   Email jr.playsoft@gmail.com
 +--------------------------------------------------------------------------+
}

{$I D2Bridge.inc}

unit D2Bridge.API.Auth.Microsoft.Response;

interface

uses
  Classes, SysUtils,
  D2Bridge.Interfaces
  {$IFDEF FMX}

  {$ELSE}

  {$ENDIF}
  ;


type
 TD2BridgeAPIAuthMicrosoftResponse = class(TInterfacedPersistent, ID2BridgeAPIAuthMicrosoftResponse)
  private
   FID: string;
   FName: string;
   FEmail: string;
   FPictureBase64: string;
   FFirstName: string;
   FSurName: string;
   FMobilePhone: string;
   FPreferredLanguage:string;
   FJobTitle: string;
   FSuccess: boolean;
  public
   constructor Create(ASuccess: Boolean;
                      AID: string = '';
                      AName: string = '';
                      AEmail: string = '';
                      APictureBase64: string = '';
                      AFirstName: string = '';
                      ASurName: string = '';
                      AMobilePhone: string = '';
                      APreferredLanguage:String = '';
                      AJobTitle: string='');

   function ID: string;
   function Name: string;
   function Email: string;
   function PictureBase64: string;
   function FirstName: string;
   function SurName: string;
   function MobilePhone: string;
   function PreferredLanguage:string;
   function JobTitle: string;
   function Success: boolean;
 end;

implementation

{ TD2BridgeAPIAuthMicrosoftResponse }

constructor TD2BridgeAPIAuthMicrosoftResponse.Create(ASuccess: Boolean;
                                                     AID: string = '';
                                                     AName: string = '';
                                                     AEmail: string = '';
                                                     APictureBase64: string = '';
                                                     AFirstName: string = '';
                                                     ASurName: string = '';
                                                     AMobilePhone: string = '';
                                                     APreferredLanguage:String = '';
                                                     AJobTitle: string='');

begin
 FSuccess:= ASuccess;
 FID:= AID;
 FName:= AName;
 FEmail:= AEmail;
 FPictureBase64:= APictureBase64;
 FFirstName:=AFirstName;
 FSurName:=ASurName;
 FMobilePhone:=AMobilePhone;
 FPreferredLanguage:=APreferredLanguage;
 FJobTitle:=AJobTitle;

end;

function TD2BridgeAPIAuthMicrosoftResponse.Email: string;
begin
 result:= FEmail;
end;

function TD2BridgeAPIAuthMicrosoftResponse.FirstName: string;
begin
 result:=FFirstName;
end;

function TD2BridgeAPIAuthMicrosoftResponse.ID: string;
begin
 result:= FID;
end;

function TD2BridgeAPIAuthMicrosoftResponse.JobTitle: string;
begin
 result:=FJobTitle;
end;

function TD2BridgeAPIAuthMicrosoftResponse.MobilePhone: string;
begin
 result:=FMobilePhone;
end;

function TD2BridgeAPIAuthMicrosoftResponse.Name: string;
begin
 result:= FName;
end;

function TD2BridgeAPIAuthMicrosoftResponse.PreferredLanguage: string;
begin
 result:=FPreferredLanguage;
end;

function TD2BridgeAPIAuthMicrosoftResponse.Success: boolean;
begin
 result:= FSuccess;
end;

function TD2BridgeAPIAuthMicrosoftResponse.SurName: string;
begin
 result:=FSurName;
end;

function TD2BridgeAPIAuthMicrosoftResponse.PictureBase64: string;
begin
 result:= FPictureBase64;
end;

end.