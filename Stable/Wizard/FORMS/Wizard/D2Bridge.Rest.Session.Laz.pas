unit D2Bridge.Rest.Session;

{ Copyright <COPYRIGHTYEAR> D2Bridge Framework by Talis Jonatas Gomes }

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}  

interface

uses
  Classes, SysUtils,
  Prism.Types,
  D2Bridge.Rest.Session.Interfaces,
  D2Bridge.Rest.Session.BaseClass; //, Adds Your Uses units


type
 TD2BridgeRestSession = class(TD2BridgeRestSessionBaseClass, ID2BridgeRestSession)
  strict private
   procedure Exec_CreateDM;
   procedure Exec_DestroyDM;   
  private
   //FDM: TDM;
  public
   //Variables
   //Classes

   //function DM: TDM;
 
   constructor Create;
   destructor Destroy; override;
 end;


implementation


{ TD2BridgeRestSession }


procedure TD2BridgeRestSession.Exec_CreateDM;
begin
{ 
 if Assigned(FDM) then
  exit;

 FDM:= TDM.Create(nil);
} 
end;

procedure TD2BridgeRestSession.Exec_DestroyDM;
begin
{
 try
 //Destroy all instanced Object
 if Assigned(FDM) then
  FDM.Free;
 except
 end;
}
end;

constructor TD2BridgeRestSession.Create;
begin
 inherited;

{
 FDM:= nil;

 Data:= TMyCLass.Create;
 
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
{
 if Assigned(FDM) then
  TThread.Synchronize(nil, Exec_DestroyDM);
}

 //Destroy all instanced Object


 inherited;
end;



//function TD2BridgeRestSession.DM: TDM;
//begin
// if FDM = nil then
//  TThread.Synchronize(nil, Exec_CreateDM); 
//
// result:= FDM;
//end;



end.

