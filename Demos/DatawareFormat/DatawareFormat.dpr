program DatawareFormat;

{$IFDEF D2BRIDGE}
 {$APPTYPE CONSOLE}
{$ENDIF}



uses
  Vcl.Forms,
  D2Bridge.Instance,
  D2Bridge.ServerControllerBase in '..\..\D2Bridge Framework\D2Bridge.ServerControllerBase.pas' {D2BridgeServerControllerBase: TDataModule},
  Prism.SessionBase in '..\..\D2Bridge Framework\Prism\Prism.SessionBase.pas' {PrismSessionBase: TPrismSessionBase},
  DatawareFormatWebApp in 'DatawareFormatWebApp.pas',
  DatawareFormat_Session in 'DatawareFormat_Session.pas',
  D2BridgeFormTemplate in 'D2BridgeFormTemplate.pas',
  Unit_D2Bridge_Server_Console in 'Unit_D2Bridge_Server_Console.pas',
  
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

{$IFNDEF D2BRIDGE}
var
  Form1: TForm1;
{$ENDIF}


begin
  Application.Initialize;
  Application.MainFormOnTaskbar:= False;
  {$IFNDEF D2BRIDGE}
  Application.CreateForm(TForm1, Form1);
  D2BridgeInstance.AddInstace(Form1);
  Application.Run;
  {$ELSE}
  TD2BridgeServerConsole.Run
  
  {$ENDIF}
end.
