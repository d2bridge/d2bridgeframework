program DEMOControls;

{$IFDEF D2BRIDGE}
 {$APPTYPE CONSOLE}
{$ENDIF}



uses
  Vcl.Forms,
  D2Bridge.Instance,
  D2Bridge.ServerControllerBase in '..\..\D2Bridge Framework\D2Bridge.ServerControllerBase.pas' {D2BridgeServerControllerBase: TDataModule},
  Prism.SessionBase in '..\..\D2Bridge Framework\Prism\Prism.SessionBase.pas' {PrismSessionBase: TPrismSessionBase},
  ControlsWebApp in 'ControlsWebApp.pas' {ControlsWebAppGlobal},
  Controls_Session in 'Controls_Session.pas' {ControlsSession},
  D2BridgeFormTemplate in 'D2BridgeFormTemplate.pas',
  Unit_D2Bridge_Server_Console in 'Unit_D2Bridge_Server_Console.pas',

  
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

{$IFNDEF D2BRIDGE}
var
  Unit1: TForm1;
{$ENDIF}


begin
  Application.Initialize;
  Application.MainFormOnTaskbar:= False;
  {$IFNDEF D2BRIDGE}
  Application.CreateForm(TForm1, Unit1);
  D2BridgeInstance.AddInstace(Unit1);
  Application.Run;
  {$ELSE}
  TD2BridgeServerConsole.Run
  
  {$ENDIF}
end.
