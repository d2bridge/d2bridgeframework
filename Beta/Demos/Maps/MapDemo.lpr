{$IFDEF D2DOCKER}library{$ELSE}program{$ENDIF} MapDemo;

{$mode delphi}{$H+}

{$IFDEF D2BRIDGE}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Interfaces,
  Forms,
  D2Bridge.ServerControllerBase,
  Prism.SessionBase,
  ServerController,
  Maps_Session,
  D2BridgeFormTemplate,
  Unit_D2Bridge_Server_Console,
  Unit_Map;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Scaled := True;
  Application.Initialize;
  TD2BridgeServerConsole.Run;
end.
