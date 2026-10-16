unit <UNITNAME>;

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
 { T<ApiClientModuleName> }
 T<ApiClientModuleName> = class(TD2BridgeRestClientModule)
  private

  public   
   function Route: string; override;

   //EndPoints
   function MyEndPoint: ID2BridgeRestResponse;
 end;


implementation

{ T<ApiClientModuleName> }

function T<ApiClientModuleName>.Route: string;
begin
 result:= 'mypath';
end;

function T<ApiClientModuleName>.MyEndPoint: ID2BridgeRestResponse;
var
 vURL: string;
 vMyJSON: TJSONObject;
begin
 result:= nil;

 vURL:=
  BuildURL(FullEndpoint, ['myendpoint']);

 vMyJSON:= TJSONObject.Create;
 //vMyJSON.Add('prop', 'value');

 try
  result:= RESTPostToJSON(vURL, Token, vMyJSON);
 except
 end;
end;

end.
