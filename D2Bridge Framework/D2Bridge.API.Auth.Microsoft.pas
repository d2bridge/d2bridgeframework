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

unit D2Bridge.API.Auth.Microsoft;

interface

uses
  Classes, SysUtils, System.UITypes, D2Bridge.JSON,
{$IFNDEF FPC}
  Rest.Utils, System.Net.HttpClient, System.Net.HttpClientComponent,System.Net.URLClient,
  {$IFDEF HAS_UNIT_SYSTEM_NETENCODING}
  System.NetEncoding,
  {$ELSE}
  EncdDecd,
  {$ENDIF}
{$ELSE}
  fphttpclient, httpprotocol, opensslsockets, base64,
{$ENDIF}

  D2Bridge.Interfaces, Prism.Interfaces, D2Bridge.API.Auth
  {$IFDEF FMX}

  {$ELSE}

  {$ENDIF}
  ;

type
  TD2BridgeAPIAuthMicrosoft = class(TInterfacedPersistent, ID2BridgeAPIAuthMicrosoft)
   private
    FConfig: ID2BridgeAPIAuthMicrosoftConfig;
    function GetProfilePhotoAsBase64(const AccessToken: string): string;

   public
    constructor Create;
    destructor Destroy; override;

    function Config: ID2BridgeAPIAuthMicrosoftConfig;

    function Login: ID2BridgeAPIAuthMicrosoftResponse;
    procedure Logout;
  end;



const
 MicrosoftAuthScope = 'https://graph.microsoft.com/user.read';
 MicrosoftCallBackReturn = 'oauth2callback=microsoft';
 APIAuthCallBackMicrosoft = APIAuthCallBack + '/microsoft';


implementation

uses
  D2Bridge.API.Auth.Microsoft.Config, D2Bridge.API.Auth.Microsoft.Response,
  D2Bridge.Instance, IdURI;

{ TD2BridgeAPIAuthMicrosoft }

function TD2BridgeAPIAuthMicrosoft.Config: ID2BridgeAPIAuthMicrosoftConfig;
begin
 result:= FConfig;
end;

constructor TD2BridgeAPIAuthMicrosoft.Create;
begin
 FConfig:= TD2BridgeAPIAuthMicrosoftConfig.Create;
end;

destructor TD2BridgeAPIAuthMicrosoft.Destroy;
var
 vConfig: TD2BridgeAPIAuthMicrosoftConfig;
begin
 vConfig:= FConfig as TD2BridgeAPIAuthMicrosoftConfig;
 FConfig:= nil;
 vConfig.Free;

 inherited;
end;

function TD2BridgeAPIAuthMicrosoft.GetProfilePhotoAsBase64(const AccessToken: string): string;
var
  vResponseStatusCode: Integer;
  vResponseContent: TStream;
  HTTPClient: {$IFNDEF FPC}TNetHTTPClient{$ELSE}TFPHTTPClient{$ENDIF};
  Response: {$IFNDEF FPC}IHTTPresponse{$ELSE}TStringStream{$ENDIF};
  PhotoStream: TMemoryStream;
  Base64Stream: TStringStream;
{$IFDEF FPC}
  Encoder: TBase64EncodingStream;
{$ENDIF}
begin
  HTTPClient := {$IFNDEF FPC}TNetHTTPClient{$ELSE}TFPHTTPClient{$ENDIF}.Create(nil);
  PhotoStream := TMemoryStream.Create;
  Base64Stream := TStringStream.Create;
  try
{$IFNDEF FPC}
    HTTPClient.CustomHeaders['Authorization'] := 'Bearer ' + AccessToken;

    Response := HTTPClient.Get('https://graph.microsoft.com/v1.0/me/photo/$value');

    vResponseStatusCode:= Response.StatusCode;
    vResponseContent:= Response.ContentStream;
{$ELSE}
    HTTPClient.AddHeader('Authorization', 'Bearer ' + AccessToken);

    HTTPClient.AllowRedirect := true;

    Response := TStringStream.Create('');

    HTTPClient.Get('https://graph.microsoft.com/v1.0/me/photo/$value', Response);

    vResponseStatusCode:= HTTPClient.ResponseStatusCode;
    vResponseContent:= Response;
{$ENDIF}

    if vResponseStatusCode = 200 then
    begin
      PhotoStream.LoadFromStream(vResponseContent);
      PhotoStream.Position := 0; // Reseta a posi��o do stream para leitura

{$IFNDEF FPC}
  {$IFDEF HAS_UNIT_SYSTEM_NETENCODING}
      TNetEncoding.Base64.Encode(PhotoStream, Base64Stream);
  {$ELSE}
      EncodeStream(PhotoStream, Base64Stream);
  {$ENDIF}
{$ELSE}
      Encoder:= TBase64EncodingStream.Create(Base64Stream);
      Encoder.CopyFrom(PhotoStream, PhotoStream.Size);
      Encoder.Flush;
{$ENDIF}

      Base64Stream.Position := 0;

      Result := 'data:image/jpeg;base64,' + Base64Stream.DataString;
    end
    else
    begin
      Result:='';
    end;
  finally
    HTTPClient.Free;
    PhotoStream.Free;
    Base64Stream.Free;
{$IFDEF FPC}
    Encoder.Free;
{$ENDIF}
  end;
end;

function TD2BridgeAPIAuthMicrosoft.Login: ID2BridgeAPIAuthMicrosoftResponse;
var
 vCode_challenge:string;

 vMicrosoftResponse: TD2BridgeAPIAuthMicrosoftResponse;
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

  vRedirectURI:= vPrismSession.URI.URL + APIAuthCallBackMicrosoft;

  vCode_challenge:= 'E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM';
  vURL := 'https://login.microsoftonline.com/common/oauth2/v2.0/authorize';
  vURL := vURL + '?response_type=' + {$IFNDEF FPC}URIEncode{$ELSE}HTTPEncode{$ENDIF}('code');
  vURL := vURL + '&client_id='     + {$IFNDEF FPC}URIEncode{$ELSE}HTTPEncode{$ENDIF}(Config.ClientID);
  vURL := vURL + '&redirect_uri='  + {$IFNDEF FPC}URIEncode{$ELSE}HTTPEncode{$ENDIF}(vRedirectURI);
  vURL := vURL + '&response_mode=' + {$IFNDEF FPC}URIEncode{$ELSE}HTTPEncode{$ENDIF}('query');
  vURL := vURL + '&scope='         + {$IFNDEF FPC}URIEncode{$ELSE}HTTPEncode{$ENDIF}(MicrosoftAuthScope);
  vURL := vURL + '&state='         + {$IFNDEF FPC}URIEncode{$ELSE}HTTPEncode{$ENDIF}(PrismSession.PushID);

  vPrismSession.Redirect(vURL, true);

  if vPrismSession.MessageDlg('Fazendo Login', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbCancel], 0, APIAuthLockName) = mrCancel then
  begin
   result:= TD2BridgeAPIAuthMicrosoftResponse.Create(false);
  end else
  begin
   if vPrismSession.URI.QueryParams.ValueFromKey('code') <> '' then
   begin
    vCode:= vPrismSession.URI.QueryParams.ValueFromKey('code');


    vhttp := {$IFNDEF FPC}TNetHTTPClient{$ELSE}TFPHTTPClient{$ENDIF}.Create(nil);
    vparams := Tstringlist.Create;
    vparams.Add('code='         + vCode);
    vparams.Add('client_id='    + Config.ClientID);
    vparams.Add('scope='        + MicrosoftAuthScope);
    vparams.Add('redirect_uri=' + vRedirectURI);
    vparams.Add('grant_type=authorization_code');

{$IFNDEF FPC}
    vResponse := vhttp.Post('https://login.microsoftonline.com/common/oauth2/v2.0/token', vParams);

    vResponseStatusText:= vResponse.StatusText;
    vResponseContent:= vResponse.ContentAsString;
{$ELSE}
    vHttp.AllowRedirect := true;

    vResponse := TStringStream.Create('');

    vHttp.FormPost('https://login.microsoftonline.com/common/oauth2/v2.0/token', vParams, vResponse);

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

     result:= TD2BridgeAPIAuthMicrosoftResponse.Create(false);

     exit;
    end;

    vToken := stringreplace (vToken,'"','',[rfreplaceall]);

{$IFNDEF FPC}
    vResponse := vHttp.get ('https://graph.microsoft.com/v1.0/me',nil,[TNetHeader.Create('Authorization','Bearer ' + VToken)]);

    vResponseStatusText:= vResponse.StatusText;
    vResponseContent:= vResponse.ContentAsString;
{$ELSE}
    vHttp.AddHeader('Authorization', 'Bearer ' + VToken);

    vHttp.AllowRedirect := true;

    vResponse := TStringStream.Create('');

    vHttp.Get('https://graph.microsoft.com/v1.0/me', vResponse);

    vResponseStatusText:= vHttp.ResponseStatusText;
    vResponseContent:= vResponse.DataString;
{$ENDIF}

    if vResponseStatusText = 'OK' then
    begin
     vResponseJSON := TJSONObject.ParseJSONValue(vResponseContent) as TJSONObject;
     try
      result:= TD2BridgeAPIAuthMicrosoftResponse.Create(
       true,
       vResponseJSON.GetValue('id', ''),
       vResponseJSON.GetValue('displayName', ''),
       vResponseJSON.GetValue('mail', ''),
       //'',//Microsoft n�o devolve foto em URL e sim em bytes vou tratar depois
       GetProfilePhotoAsBase64(VToken),
       vResponseJSON.GetValue('givenName', ''),
       vResponseJSON.GetValue('surname', ''),
       vResponseJSON.GetValue('mobilePhone', ''),
       vResponseJSON.GetValue('preferredLanguage', ''),
       vResponseJSON.GetValue('jobTitle', '')
      );
      //'{"@odata.context":"https://graph.microsoft.com/v1.0/$metadata#users/$entity","userPrincipalName":"juniorcsa@hotmail.com","id":"0e25e97482beb893","displayName":"Jo�o B S Junior","surname":"B S Junior","givenName":"Jo�o","preferredLanguage":"pt-BR","mail":"juniorcsa@hotmail.com","mobilePhone":null,"jobTitle":null,"officeLocation":null,"businessPhones":[]}'
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

procedure TD2BridgeAPIAuthMicrosoft.Logout;
begin
 try
  PrismSession.Redirect('https://login.microsoftonline.com/common/oauth2/v2.0/logout',true);
 except
 end;
end;


end.