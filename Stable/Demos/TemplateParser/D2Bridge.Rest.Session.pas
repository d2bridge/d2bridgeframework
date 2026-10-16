unit D2Bridge.Rest.Session;

{ Copyright 2025 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Classes, SysUtils,
  Prism.Types,
  D2Bridge.Rest.Session.Interfaces,
  D2Bridge.Rest.Session.BaseClass; //, Adds Your Uses units


type
 TD2BridgeRestSession = class(TD2BridgeRestSessionBaseClass, ID2BridgeRestSession)
  private

  public
   //DM: TDM;
   //Variables
   //Classes

   constructor Create;
   destructor Destroy; override;
 end;


implementation


{ TD2BridgeRestSession }

constructor TD2BridgeRestSession.Create;
begin
 inherited;

{
  Data:= TMyCLass.Create;
}

{
 if WebMetho = wmtGET then //Get
 begin
  if Path = '/api/ping' then
  begin
   //Instance Class...
  end;

  if RequireJWT then
  begin

  end;
 end;
}
end;


destructor TD2BridgeRestSession.Destroy;
begin
 //Destroy all instanced Object

 inherited;
end;

end.

