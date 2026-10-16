unit Auth.API.Client;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

interface

uses
 Classes, SysUtils, DateUtils, DB,
{$IFnDEF FPC}
  JSON,
{$ELSE}
  fpjson,
{$ENDIF}
 D2Bridge.Rest.Http;


type

 { TAuthRestAPIClient }

 TAuthRestAPIClient = class(TD2BridgeRestClientModule)
  private
   FUser: string;
   FPassword: string;
   FUserId: string;
   FUserName: string;
   FToken: string;
   FTokenRefresh: string;
   FTokenExpires: TDateTime;
   FLogged: boolean;
  protected
  public
   constructor Create(APICore: TObject);

   function Route: string; override;

   procedure Logout;

   function UserId: string;
   function UserName: string;

   function Token: string;
   function TokenExpires: TDateTime;

   function Logged: boolean;

   //Class API
   function Login(AUser, APassword: string): ID2BridgeRestResponse;
   function RefreshToken(ARefreshToken: string): ID2BridgeRestResponse;
   function CurrentUser: ID2BridgeRestResponse;

   //Your other Class API

 end;


implementation

{ TAuthRestAPIClient }

function TAuthRestAPIClient.RefreshToken(ARefreshToken: string): ID2BridgeRestResponse;
var
 vURL: string;
 vJSONAuth: TJSONObject;
begin
 result:= nil;

 vURL:=
  BuildURL(FullEndpoint, 'refreshtoken', []);

 try
  result:= RESTPostToJSON(vURL, ARefreshToken);
 except
 end;

 if not result.Success then
 begin
  if (Result.StatusCode = HTTPStatus.ErrorUnauthorized) then
   Logout;

  exit;
 end;

 FLogged:= true;
 vJSONAuth:= result.AsJSONObject;

 FToken:= vJSONAuth.Get('accessToken');
 FTokenRefresh:= ARefreshToken;
 FTokenExpires:= IncSecond(IncSecond(now, vJSONAuth.Get('expiresIn')),-20);
end;

function TAuthRestAPIClient.CurrentUser: ID2BridgeRestResponse;
var
 vURL: string;
begin
 result:= nil;

 vURL:=
  BuildURL(FullEndpoint, 'currentuser', []);

 try
  result:= RESTGetToJSON(vURL, FToken);
 except
 end;

 if not result.Success then
 begin
  if (Result.StatusCode = HTTPStatus.ErrorForbidden) then
   Logout;

  exit;
 end;
end;

function TAuthRestAPIClient.Route: string;
begin
 result:= 'auth';
end;

constructor TAuthRestAPIClient.Create(APICore: TObject);
begin
 FTokenExpires:= 0;
 FLogged:= false;

 inherited Create(APICore);

 TD2BridgeRestClientCore(APICore).OnGetToken:= Token;
end;

function TAuthRestAPIClient.Login(AUser, APassword: string): ID2BridgeRestResponse;
var
 vURL: string;
 vJSONAuth: TJSONObject;
begin
 FUser:= AUser;
 FPassword:= APassword;

 result:= nil;

 vURL:=
  BuildURL(FullEndpoint, 'login', []);

 try
  result:= RESTPostToJSON(vURL, FUser, FPassword);
 except
 end;

 if not result.Success then
 begin
  Logout;
  exit;
 end;

 FLogged:= true;
 vJSONAuth:= result.AsJSONObject;

 FToken:= vJSONAuth.Get('accessToken');
 FTokenRefresh:= vJSONAuth.Get('refreshToken');
 FTokenExpires:= IncSecond(IncSecond(now, vJSONAuth.Get('expiresIn'))-20);
end;

procedure TAuthRestAPIClient.Logout;
begin
 FTokenExpires:= 0;
 FToken:= '';
 FTokenRefresh:= '';
 FUserName:= '';
 FUserId:= '';
end;

function TAuthRestAPIClient.UserId: string;
begin
 result:= FUserId;
end;

function TAuthRestAPIClient.UserName: string;
begin
 result:= FUserName;
end;

function TAuthRestAPIClient.Token: string;
begin
 result:= '';

 if (FLogged) and (FTokenExpires < now) and (FTokenRefresh <> '') then
 begin
 if (not RefreshToken(FTokenRefresh).Success) and (FUser <> '') and (FPassword <> '') then
  Login(FUser, FPassword);
 end else
  if (not FLogged) and (FUser <> '') and (FPassword <> '') then
   Login(FUser, FPassword);

 result:= FToken; 
end;

function TAuthRestAPIClient.TokenExpires: TDateTime;
begin
 result:= FTokenExpires;
end;

function TAuthRestAPIClient.Logged: boolean;
begin
 result:= FLogged and (FToken <> '');
end;

end.
