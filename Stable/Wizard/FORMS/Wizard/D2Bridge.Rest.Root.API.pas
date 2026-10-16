unit <UNITNAME>;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}


interface

uses
 Classes, SysUtils,
 //Your Rest API Client Modules
 Auth.API.Client, //Insert Module Client Auth or comment this module
  //API Transport Client
 D2Bridge.Rest.Http; 


type
 ID2BridgeRestResponse = D2Bridge.Rest.Http.ID2BridgeRestResponse;
 HTTPStatus = D2Bridge.Rest.Http.THTTPStatus;

type
 { T<ApiName> }
 T<ApiName> = class(TD2BridgeRestRootClient)
  private
   FAuth: TAuthRestAPIClient; //Rest API Auth Module
   //Your Variables API Client Modules
  public
   constructor Create;
   destructor Destroy; override;

   //Your Class API Function
   function Auth: TAuthRestAPIClient;
 end;


const
 <ApiName>UrlProd = 'http://127.0.0.1:8888/api';
 <ApiName>UrlTest = 'http://127.0.0.1:8888/api';


var
 <ApiName>: T<ApiName>;


implementation




{ T<ApiName> }

constructor T<ApiName>.Create;
begin
 inherited;

 Core.URLBaseProduction:= <ApiName>UrlProd;
 Core.URLBaseTest:= <ApiName>UrlTest;

 D2Bridge.Rest.Http.FormatSettings:= Core.FormatSettings;
 
 //Instance Auth Module Client
 FAuth:= TAuthRestAPIClient.Create(Core);

 //Instance Client Modules


end;

destructor T<ApiName>.Destroy;
begin
 FAuth.Free;

 //Destroy Client Module


 inherited Destroy;
end;


function T<ApiName>.Auth: TAuthRestAPIClient;
begin
 result:= FAuth;
end;


end.
