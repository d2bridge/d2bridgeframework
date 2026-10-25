{$IFDEF D2DOCKER}library{$ELSE}program{$ENDIF} Maps;

{$APPTYPE CONSOLE}

uses
  Vcl.Forms,
  D2Bridge.ServerControllerBase in '..\..\D2Bridge Framework\D2Bridge.ServerControllerBase.pas' {D2BridgeServerControllerBase: TDataModule},
  Prism.SessionBase in '..\..\D2Bridge Framework\Prism\Prism.SessionBase.pas' {PrismSessionBase: TPrismSessionBase},
  ServerController in 'ServerController.pas' {D2BridgeServerController: TDataModule},
  Maps_Session in 'Maps_Session.pas' {MapsSession: TDataModule},
  D2BridgeFormTemplate in 'D2BridgeFormTemplate.pas',
  Unit_D2Bridge_Server_Console in 'Unit_D2Bridge_Server_Console.pas',
  Unit_Map in 'Unit_Map.pas' {FormMap};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := False;
  TD2BridgeServerConsole.Run;
end.
