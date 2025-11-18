program D2BridgeWebAppWithLCL;

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
  Forms, D2Bridge.Instance, D2Bridge.ServerControllerBase, Prism.SessionBase,
  Lazarus_Session, LazarusWebApp, Unit_D2Bridge_Server_Console, UnitMenu,
  Unit_Login, unitcontrols, unitDBGrid, D2BridgeFormTemplate,
  unitDBGridEdit, unitStringGrid, unitQRCode, unitCardGridDataModel, unitKanban,
  unitAuth, unitQRCodeReader, unitCamera, unitMarkDownEditor, unitWYSIWYGEditor
  { you can add units after this };

{$R *.res}

{$IFNDEF D2BRIDGE}
var
  FormMenu: TFormMenu;
{$ENDIF}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  {$IFNDEF D2BRIDGE}
  Application.CreateForm(TFormMenu, FormMenu);
  D2BridgeInstance.AddInstace(FormMenu);
  Application.Run;
  {$ELSE}	
  TD2BridgeServerConsole.Run;
  
  {$ENDIF}	
end.

