program Link;

{$APPTYPE CONSOLE}



uses
  Vcl.Forms,
  D2Bridge.ServerControllerBase in '..\..\D2Bridge Framework\D2Bridge.ServerControllerBase.pas' {D2BridgeServerControllerBase: TDataModule},
  Prism.SessionBase in '..\..\D2Bridge Framework\Prism\Prism.SessionBase.pas' {PrismSessionBase: TPrismSessionBase},
  ServerController in 'ServerController.pas',
  Link_Session in 'Link_Session.pas',
  D2BridgeFormTemplate in 'D2BridgeFormTemplate.pas',
  Unit_D2Bridge_Server_Console in 'Unit_D2Bridge_Server_Console.pas',
  
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar:= False;
  TD2BridgeServerConsole.Run
  
end.
