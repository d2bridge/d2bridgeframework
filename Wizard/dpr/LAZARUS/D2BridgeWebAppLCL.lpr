program D2BridgeWebAppLCL;

{$mode delphi}{$H+}

{$IFDEF D2BRIDGE}
//{$APPTYPE CONSOLE}
{$ENDIF}

uses
  {$IFDEF UNIX}
  cthreads, clocale,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,   
  D2Bridge.ServerControllerBase,
  Prism.SessionBase,
  D2BridgeFormTemplate,	
  {ProjectName}_Session,
  {ProjectName}WebApp,
  {Units}
  {Language Support}
  unit1
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  {Server}
  {Application.Run;}
end.

