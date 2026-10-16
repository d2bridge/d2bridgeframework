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
   //EndPoint
   function Get<TableName>s: ID2BridgeRestResponse;
   function Get<TableName>(AId: integer): ID2BridgeRestResponse;
   function New<TableName>(ADataSet: TDataSet): ID2BridgeRestResponse;
   function Save<TableName>(ADataSet: TDataSet): ID2BridgeRestResponse;
   function Delete<TableName>(ADataSet: TDataSet): ID2BridgeRestResponse;
 end;

implementation

{ T<ApiClientModuleName> }

function T<ApiClientModuleName>.Route: string;
begin
 result:= '<TABLENAMELOWER>';
end;


function T<ApiClientModuleName>.Get<TableName>s: ID2BridgeRestResponse;
var
 vURL: string;
begin
 result:= nil;

 vURL:=
  BuildURL(FullEndpoint);

 try
  result:= RESTGetToJSON(vURL, Token);
 except
 end;
end;


function T<ApiClientModuleName>.Get<TableName>(AId: integer): ID2BridgeRestResponse;
var
 vURL: string;
begin
 result:= nil;

 vURL:=
  BuildURL(FullEndpoint, [IntToStr(AId)]);

 try
  result:= RESTGetToJSON(vURL, Token);
 except
 end;

end;


function T<ApiClientModuleName>.New<TableName>(ADataSet: TDataSet): ID2BridgeRestResponse;
var
 vURL: string;
 vJSONBody: TJSONObject;
begin
 result:= nil;

 vURL:=
  BuildURL(FullEndpoint, [ADataSet.fieldByName('id').asstring]);

 vJSONBody:= DataSetRowToJSON(ADataSet);

 try
  result:= RESTPostToJSON(vURL, Token, vJSONBody);
 except
 end;

 vJSONBody.Free;
end;


function T<ApiClientModuleName>.Save<TableName>(ADataSet: TDataSet): ID2BridgeRestResponse;
var
 vURL: string;
 vJSONBody: TJSONObject;
begin
 result:= nil;

 vURL:=
  BuildURL(FullEndpoint, [ADataSet.fieldByName('id').asstring]);

 vJSONBody:= DataSetRowToJSON(ADataSet);

 try
  result:= RESTPutToJSON(vURL, Token, vJSONBody);
 except
 end;

 vJSONBody.Free;
end;


function T<ApiClientModuleName>.Delete<TableName>(ADataSet: TDataSet): ID2BridgeRestResponse;
var
 vURL: string;
begin
 result:= nil;

 vURL:=
  BuildURL(FullEndpoint, [ADataSet.fieldByName('id').asstring]);

 try
  result:= RESTDeleteToJSON(vURL, Token);
 except
 end;
end;


end.
