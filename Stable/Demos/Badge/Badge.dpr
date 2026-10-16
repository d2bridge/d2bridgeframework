{$IFDEF D2DOCKER}library{$ELSE}program{$ENDIF} Badge;

{$IFDEF D2BRIDGE}
 {$APPTYPE CONSOLE}
{$ENDIF}



uses
  Vcl.Forms,
  D2Bridge.ServerControllerBase in '..\..\D2Bridge Framework\D2Bridge.ServerControllerBase.pas' {D2BridgeServerControllerBase: TDataModule},
  Prism.SessionBase in '..\..\D2Bridge Framework\Prism\Prism.SessionBase.pas' {PrismSessionBase: TPrismSessionBase},
  BadgeWebApp in 'BadgeWebApp.pas' {BadgeWebAppGlobal},
  Badge_Session in 'Badge_Session.pas' {BadgeSession},
  D2BridgeFormTemplate in 'D2BridgeFormTemplate.pas',
    Unit_D2Bridge_Server_Console in 'Unit_D2Bridge_Server_Console.pas',

  
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar:= False;
  TD2BridgeServerConsole.Run
  
end.
