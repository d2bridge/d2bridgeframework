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
   João B. S. Junior
   Phone +55 69 99250-3445
   Email jr.playsoft@gmail.com
 +--------------------------------------------------------------------------+
}

{$I D2Bridge.inc}

unit D2Bridge.API.Auth.Google;

interface

uses
  Classes, SysUtils, System.UITypes, D2Bridge.JSON,
{$IFNDEF FPC}
  Rest.Utils, System.Net.HttpClient, System.Net.HttpClientComponent,
{$ELSE}
  fphttpclient, httpprotocol, opensslsockets,
{$ENDIF}
  D2Bridge.Interfaces, Prism.Interfaces, D2Bridge.API.Auth
  {$IFDEF FMX}

  {$ELSE}

  {$ENDIF}
  ;

type
  TD2BridgeAPIAuthGoogle = class(TInterfacedPersistent, ID2BridgeAPIAuthGoogle)
   private
    FConfig: ID2BridgeAPIAuthGoogleConfig;

   public
    constructor Create;
    destructor Destroy; override;

    function Config: ID2BridgeAPIAuthGoogleConfig;

    function Login: ID2BridgeAPIAuthGoogleResponse;
    procedure Logout;
  end;



const
 GoogleAuthScope = 'https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email';
 GoogleCallBackReturn = 'oauth2callback=google';
 APIAuthCallBackGoogle = APIAuthCallBack + '/google';


implementation

uses
  D2Bridge.API.Auth.Google.Config, D2Bridge.API.Auth.Google.Response,
  D2Bridge.Instance, IdURI;

{ TD2BridgeAPIAuthGoogle }

function TD2BridgeAPIAuthGoogle.Config: ID2BridgeAPIAuthGoogleConfig;
begin
 result:= FConfig;
end;

constructor TD2BridgeAPIAuthGoogle.Create;
begin
 FConfig:= TD2BridgeAPIAuthGoogleConfig.Create;
end;

destructor TD2BridgeAPIAuthGoogle.Destroy;
var
 vConfig: TD2BridgeAPIAuthGoogleConfig;
begin
 vConfig:= FConfig as TD2BridgeAPIAuthGoogleConfig;
 FConfig:= nil;
 vConfig.Free;

 inherited;
end;

function TD2BridgeAPIAuthGoogle.Login: ID2BridgeAPIAuthGoogleResponse;
var
 vRedirectURI, vURL: string;
 vPrismSession: IPrismSession;
 vCode: string;
 vtoken : string;
 vResponseStatusText: string;
 vResponseContent: string;
 vHttp : {$IFNDEF FPC}TNetHTTPClient{$ELSE}TFPHTTPClient{$ENDIF};
 vParams : Tstringlist;
 vResponse : {$IFNDEF FPC}IHTTPresponse{$ELSE}TStringStream{$ENDIF};
 vResponseJSON: TJSONObject;
begin
 try
  vPrismSession:= PrismSession;

  Result:= nil;

  vRedirectURI:= vPrismSession.URI.URL + APIAuthCallBackGoogle;

  vURL := 'https://accounts.google.com/o/oauth2/auth';
  vURL := vURL + '?response_type=' + {$IFNDEF FPC}URIEncode{$ELSE}HTTPEncode{$ENDIF}('code');
  vURL := vURL + '&client_id='     + {$IFNDEF FPC}URIEncode{$ELSE}HTTPEncode{$ENDIF}(Config.ClientID);
  vURL := vURL + '&redirect_uri='  + vRedirectURI;
  vURL := vURL + '&scope='         + {$IFNDEF FPC}URIEncode{$ELSE}HTTPEncode{$ENDIF}(GoogleAuthScope);
  vURL := vURL + '&state='         + {$IFNDEF FPC}URIEncode{$ELSE}HTTPEncode{$ENDIF}(PrismSession.PushID);

  vPrismSession.Redirect(vURL, true);

  if vPrismSession.MessageDlg('Fazendo Login', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbCancel], 0, APIAuthLockName) = mrCancel then
  begin
   result:= TD2BridgeAPIAuthGoogleResponse.Create(false);
  end else
  begin
   if vPrismSession.URI.QueryParams.ValueFromKey('code') <> '' then
   begin
    vCode:= vPrismSession.URI.QueryParams.ValueFromKey('code');

    vHttp := {$IFNDEF FPC}TNetHTTPClient{$ELSE}TFPHTTPClient{$ENDIF}.Create(nil);
    vParams := Tstringlist.Create;
    vParams.Add('code=' + vCode);
    vParams.Add('client_id=' + Config.ClientID);
    vParams.Add('client_secret='+ Config.ClientSecret);
    vParams.Add('redirect_uri=' + vRedirectURI);
    vParams.Add('grant_type=authorization_code');

{$IFNDEF FPC}
    vResponse := vhttp.Post('https://oauth2.googleapis.com/token', vParams);

    vResponseStatusText:= vResponse.StatusText;
    vResponseContent:= vResponse.ContentAsString;
{$ELSE}
    vHttp.AllowRedirect := true;

    vResponse := TStringStream.Create('');

    vHttp.FormPost('https://oauth2.googleapis.com/token', vParams, vResponse);

    vResponseStatusText:= vHttp.ResponseStatusText;
    vResponseContent:= vResponse.DataString;
{$ENDIF}

    if vResponseStatusText = 'OK' then
    begin
     Try
      vResponseJSON := TJSONObject.ParseJSONValue(vResponseContent) as TJSONObject;
      vtoken := vResponseJSON.GetValue('access_token', '');
     finally
      vResponseJSON.Free;
     End;
    end else
    begin
     vHttp.Free;
     vParams.Free;

     result:= TD2BridgeAPIAuthGoogleResponse.Create(false);

     exit;
    end;

{$IFNDEF FPC}
    vResponse := vhttp.get ('https://www.googleapis.com/oauth2/v2/userinfo?'+'access_token=' + vtoken);

    vResponseStatusText:= vResponse.StatusText;
    vResponseContent:= vResponse.ContentAsString;
{$ELSE}
    vHttp.AllowRedirect := true;

    vResponse := TStringStream.Create('');

    vHttp.Get('https://www.googleapis.com/oauth2/v2/userinfo?'+'access_token=' + vtoken, vResponse);

    vResponseStatusText:= vHttp.ResponseStatusText;
    vResponseContent:= vResponse.DataString;
{$ENDIF}

    if vResponseStatusText = 'OK' then
    begin
     vResponseJSON := TJSONObject.ParseJSONValue(vResponseContent) as TJSONObject;
     try
      result:= TD2BridgeAPIAuthGoogleResponse.Create(
       true,
       vResponseJSON.GetValue('id', ''),
       vResponseJSON.GetValue('name', ''),
       vResponseJSON.GetValue('email', ''),
       vResponseJSON.GetValue('picture', '')
      );
     finally
      vResponseJSON.Free;
     end;

    end;

    vHttp.Free;
    vParams.Free;
   end;
  end;
 except
 end;
end;

procedure TD2BridgeAPIAuthGoogle.Logout;
begin
 try
  PrismSession.Redirect('https://mail.google.com/mail/u/0/?logout&hl=ptBR',true);
 except
 end;
end;


end.