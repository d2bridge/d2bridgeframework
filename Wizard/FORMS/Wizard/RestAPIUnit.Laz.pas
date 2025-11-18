unit <UNITNAME>;

{ Copyright <COPYRIGHTYEAR> D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Classes, SysUtils, fpjson,
  Prism.Types,
  D2Bridge.JSON,
  D2Bridge.Rest.Server.Functions;


implementation

//*My EndPoints
{
procedure GetPing(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest; Response: TPrismHTTPResponse);
begin
 Response.JSON.AddPair('result', 'ping');
end;
}


initialization
//Register EndPoints
{
  AddGet('/api/ping', GetPing);
}

end.
