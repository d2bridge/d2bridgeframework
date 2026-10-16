unit <UNITNAME>;

{ Copyright <COPYRIGHTYEAR> D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Classes, SysUtils, JSON,
  Prism.Types,
  D2Bridge.JSON, D2Bridge.Rest.Entity,
  D2Bridge.Rest.Server.Functions,
  D2Bridge.Rest.Session;


type
 T<CLASS_ID> = class(TD2BridgeRestEntity)
  private
   //My Class Var
   //class var FValueStr: string;
   //My EndPoints
   //class procedure GetPing(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest; Response: TPrismHTTPResponse);
  protected
   //Register EndPoints
   class procedure RegisterEndPoints; override;
   // *Events*
   //class procedure OnNewRestSession(const RestSession: TD2BridgeRestSession); override;
   //class procedure OnCloseRestSession(const RestSession: TD2BridgeRestSession); override;
   //class procedure OnBeforeRestMethod(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest; Response: TPrismHTTPResponse; CanExecute: boolean); override;
   //class procedure OnAfterRestMethod(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest; Response: TPrismHTTPResponse); override;
  public
   //class constructor Create;
   //class destructor Destroy;
 end;


implementation

{ T<CLASS_ID>  }


//Register Endpoints
class procedure T<CLASS_ID>.RegisterEndPoints;
begin
 //AddGet('/api/ping', GetPing); //True -> Require Auth JWT
end;



initialization
 T<CLASS_ID>.Initialize;


end.
