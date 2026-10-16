unit API.Ping;

{ Copyright 2025 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Classes, SysUtils, JSON,
  Prism.Types,
  D2Bridge.JSON,
  D2Bridge.Rest.Server.Functions;


implementation

Uses
 TemplateParser_Session;


//*My EndPoints
procedure GetPing(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest; Response: TPrismHTTPResponse);
var
 vToken: string;
 I: integer;
 vResponseTxt: string;
begin
 vResponseTxt:= '';
 vToken:= Request.Query('token');

 if vToken = '' then
 begin
  Response.JSON(HTTPStatus.ErrorBadRequest);
  exit;
 end;

 for I := 0 to Pred(D2BridgeSessions.Count) do
 begin
  if D2BridgeSessions.Items.Items[I].Token = vToken then
  begin
   vResponseTxt:= TTemplateParserSession(D2BridgeSessions.Items.Items[I].Data).FValueTest;
   break;
  end;
 end;

 Response.JSON.AddPair('result', vResponseTxt);
end;


initialization
 AddGet('/api/ping', GetPing);


end.
