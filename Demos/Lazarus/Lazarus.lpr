{$IFDEF D2DOCKER}library{$ELSE}program{$ENDIF} D2BridgeWebAppWithLCL;

{$mode delphi}{$H+}

{$IFDEF D2BRIDGE}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  {$IFDEF UNIX}
  cthreads, clocale,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, D2Bridge.Instance, D2Bridge.API.D2Docker.Comm, D2Bridge.ServerControllerBase, Prism.SessionBase,
  Lazarus_Session, LazarusWebApp, Unit_D2Bridge_Server_Console, UnitMenu,
  Unit_Login, unitcontrols, unitDBGrid, D2BridgeFormTemplate,
  unitDBGridEdit, unitStringGrid, unitQRCode, unitCardGridDataModel, unitKanban,
  unitAuth, unitQRCodeReader, unitCamera, unitMarkDownEditor, unitWYSIWYGEditor
  { you can add units after this };

{$R *.res}

{$IFNDEF D2BRIDGE}
var
  FormLogin: TForm_Login;
{$ENDIF}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  {$IFNDEF D2BRIDGE}
  Application.CreateForm(TForm_Login, FormLogin);
  D2BridgeInstance.AddInstace(FormLogin);
  Application.Run;
  {$ELSE}	
  TD2BridgeServerConsole.Run;
  
  {$ENDIF}	
end.

