{$IFDEF D2DOCKER}library{$ELSE}program{$ENDIF} TemplateParser;

{$IFDEF D2BRIDGE}
 {$APPTYPE CONSOLE}
{$ENDIF}



uses
  Vcl.Forms,
  D2Bridge.ServerControllerBase in '..\..\D2Bridge Framework\D2Bridge.ServerControllerBase.pas' {D2BridgeServerControllerBase: TDataModule},
  Prism.SessionBase in '..\..\D2Bridge Framework\Prism\Prism.SessionBase.pas' {PrismSessionBase: TPrismSessionBase},
  TemplateParserWebApp in 'TemplateParserWebApp.pas' {TemplateParserWebAppGlobal},
  TemplateParser_Session in 'TemplateParser_Session.pas' {TemplateParserSession},
  D2BridgeFormTemplate in 'D2BridgeFormTemplate.pas',
    API.Auth in 'API.Auth.pas',
  API.Ping in 'API.Ping.pas',
  D2Bridge.Rest.Session in 'D2Bridge.Rest.Session.pas',
  Unit_D2Bridge_Server_Console in 'Unit_D2Bridge_Server_Console.pas',

  
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar:= False;
  TD2BridgeServerConsole.Run
  
end.
