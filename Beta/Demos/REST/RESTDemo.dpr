{$IFDEF D2DOCKER}library{$ELSE}program{$ENDIF} RESTDemo;

{$APPTYPE CONSOLE}

uses
  Vcl.Forms,
  D2Bridge.ServerControllerBase in '..\..\D2Bridge Framework\D2Bridge.ServerControllerBase.pas' {D2BridgeServerControllerBase: TDataModule},
  Prism.SessionBase in '..\..\D2Bridge Framework\Prism\Prism.SessionBase.pas' {PrismSessionBase: TPrismSessionBase},
  ServerController in 'ServerController.pas' {D2BridgeServerController: TDataModule},
  REST_Session in 'REST_Session.pas' {RESTSession: TDataModule},
  D2BridgeFormTemplate in 'D2BridgeFormTemplate.pas',
  Unit_D2Bridge_Server_Console in 'Unit_D2Bridge_Server_Console.pas',
  API.Auth in 'API.Auth.pas',
  API.Products in 'API.Products.pas',
  Unit_GetEP in 'Unit_GetEP.pas' {Form_GetEP},
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar:= False;
  TD2BridgeServerConsole.Run;
end.
