{$IFDEF D2DOCKER}library{$ELSE}program{$ENDIF} D2BridgeWebAppWithLCL;

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
	D2Bridge.Instance,
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

{$IFNDEF D2BRIDGE}
var
  {PrimaryFormUnit}: {PrimaryFormClass};
{$ENDIF}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  {$IFNDEF D2BRIDGE}
  Application.CreateForm({PrimaryFormClass}, {PrimaryFormUnit});
  D2BridgeInstance.AddInstace({PrimaryFormUnit});
  Application.Run;
  {$ELSE}	
  {Server}
  {Application.Run;}
  {$ENDIF}	
end.

