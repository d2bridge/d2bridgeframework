unit API.Auth;

{ Copyright 2025 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Classes, SysUtils, JSON,
  Prism.Types,
  D2Bridge.JSON,
  D2Bridge.Rest.Server.Functions;


implementation


//Using Basic Auth for User and Password
procedure PostLogin(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest; Response: TPrismHTTPResponse);
var
 vUserID: string;
 vIdentity: string;
begin
 if (Request.User = 'UserD2Bridge') and (Request.Password = '123456') then
 begin
  vUserID:= 'UserD2Bridge'; //ID User *Example
  vIdentity:= 'My Unique Identity'; //Identity of Session *Optional

  Response.JSON.AddPair('accessToken', RestSecurity.JWTAccess.Token(vUserID, vIdentity));
  Response.JSON.AddPair('refreshToken', RestSecurity.JWTRefresh.Token(vUserID, vIdentity));
  Response.JSON.AddPair('expiresIn', TJSONNumber.Create(RestSecurity.JWTAccess.ExpirationSeconds));

  //Custom Login information
  Response.JSON.AddPair('userid', vUserID);
  Response.JSON.AddPair('username', Request.User);
 end;
end;


//Refresh Valid Token
procedure PostRefreshToken(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest; Response: TPrismHTTPResponse);
begin
 if (Request.JWTTokenType = JWTTokenRefresh) and  (Request.JWTvalid) then
 begin
  Response.JSON.AddPair('accessToken', RestSecurity.JWTAccess.Token(Request.JWTsub, Request.JWTidentity));
  Response.JSON.AddPair('expiresIn', TJSONNumber.Create(RestSecurity.JWTAccess.ExpirationSeconds));
 end;
end;


//Get User example
procedure GetCurrentUser(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest; Response: TPrismHTTPResponse);
begin
 //Get User ID from Token
 Response.JSON.AddPair('userid', Request.JWTsub);
end;


//Health example
procedure Health(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest; Response: TPrismHTTPResponse);
begin
 Response.JSON(200, 'ok');
end;


//Event NewSession
procedure OnNewRestSession(const RestSession: TD2BridgeRestSession);
begin

end;


//Event Before Call Rest Method
procedure OnBeforeRestMethod(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest; Response: TPrismHTTPResponse; CanExecute: boolean);
begin

end;

//Event After Call Rest Method
procedure OnAfterRestMethod(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest; Response: TPrismHTTPResponse);
begin

end;


//Event Close Session
procedure OnCloseRestSession(const RestSession: TD2BridgeRestSession);
begin

end;




initialization
 //Event *(Optional)*
 NewRestSession(OnNewRestSession);
 CloseRestSession(OnCloseRestSession);
 BeforeRestMethod(OnBeforeRestMethod);
 AfterRestMethod(OnAfterRestMethod);
 //Register EndPoints
 AddPost('/api/auth/login',        PostLogin);
 AddPost('/api/auth/refreshtoken', PostRefreshToken, true); //True -> Require Auth JWT
  AddGet('/api/auth/currentuser',  GetCurrentUser, true); //True -> Require Auth JWT
  AddGet('/api/health',            Health);


end.
