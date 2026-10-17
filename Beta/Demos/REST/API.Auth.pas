unit API.Auth;

{ Copyright 2026 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Classes, SysUtils, JSON,
  Prism.Types,
  D2Bridge.JSON,
  D2Bridge.Rest.Server.Functions;

implementation

const
  DemoUser = 'UserD2Bridge';
  DemoPassword = '123456';

procedure PostLogin(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest; Response: TPrismHTTPResponse);
var
  vUserID, vIdentity: string;
begin
  if (Request.User <> DemoUser) or (Request.Password <> DemoPassword) then
  begin
    Response.StatusCode := HTTPStatus.ErrorUnauthorized;
    Response.JSON.AddPair('error', 'Invalid user or password');
    Exit;
  end;

  vUserID := DemoUser;
  vIdentity := 'rest-demo';

  Response.StatusCode := HTTPStatus.SuccessOK;
  Response.JSON.AddPair('accessToken', RestSecurity.JWTAccess.Token(vUserID, vIdentity));
  Response.JSON.AddPair('refreshToken', RestSecurity.JWTRefresh.Token(vUserID, vIdentity));
  Response.JSON.AddPair('expiresIn', TJSONNumber.Create(RestSecurity.JWTAccess.ExpirationSeconds));
  Response.JSON.AddPair('userid', vUserID);
  Response.JSON.AddPair('username', Request.User);
end;

procedure PostRefreshToken(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest; Response: TPrismHTTPResponse);
begin
  if (Request.JWTTokenType = JWTTokenRefresh) and Request.JWTvalid then
  begin
    Response.StatusCode := HTTPStatus.SuccessOK;
    Response.JSON.AddPair('accessToken', RestSecurity.JWTAccess.Token(Request.JWTsub, Request.JWTidentity));
    Response.JSON.AddPair('expiresIn', TJSONNumber.Create(RestSecurity.JWTAccess.ExpirationSeconds));
    Exit;
  end;

  Response.StatusCode := HTTPStatus.ErrorUnauthorized;
  Response.JSON.AddPair('error', 'Refresh token required');
end;

procedure GetCurrentUser(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest; Response: TPrismHTTPResponse);
begin
  Response.StatusCode := HTTPStatus.SuccessOK;
  Response.JSON.AddPair('userid', Request.JWTsub);
  Response.JSON.AddPair('identity', Request.JWTidentity);
end;

procedure GetHealth(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest; Response: TPrismHTTPResponse);
begin
  Response.StatusCode := HTTPStatus.SuccessOK;
  Response.JSON.AddPair('status', 'ok');
end;

procedure GetPing(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest; Response: TPrismHTTPResponse);
var
  vMessage: string;
begin
  vMessage := Request.Query('message');
  if vMessage = '' then
  begin
    Response.StatusCode := HTTPStatus.ErrorBadRequest;
    Response.JSON.AddPair('error', 'Query parameter message is required');
    Exit;
  end;

  Response.StatusCode := HTTPStatus.SuccessOK;
  Response.JSON.AddPair('message', vMessage);
end;

initialization
  AddPost('/api/auth/login', PostLogin);
  AddPost('/api/auth/refreshtoken', PostRefreshToken, True);
  AddGet('/api/auth/currentuser', GetCurrentUser, True);
  AddGet('/api/health', GetHealth);
  AddGet('/api/ping', GetPing);

end.
