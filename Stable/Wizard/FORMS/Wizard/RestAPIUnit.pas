unit <UNITNAME>;

{ Copyright <COPYRIGHTYEAR> D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Classes, SysUtils, JSON,
  Prism.Types,
  D2Bridge.JSON,
  D2Bridge.Rest.Server.Functions,
  D2Bridge.Rest.Session;


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
