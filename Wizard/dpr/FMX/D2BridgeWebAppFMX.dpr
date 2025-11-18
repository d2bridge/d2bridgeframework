program D2BridgeWebAppFMX;

{$IFDEF D2BRIDGE}
 //{$APPTYPE CONSOLE}
{$ENDIF}

{Language Support Resource}

uses
  System.StartUpCopy,
  FMX.Forms,
  D2Bridge.Instance,
  D2Bridge.ServerControllerBase in '{D2BridgePath}D2Bridge.ServerControllerBase.pas' {D2BridgeServerControllerBase: TDataModule},
  Prism.SessionBase in '{D2BridgePath}Prism\Prism.SessionBase.pas' {PrismSessionBase: TPrismSessionBase},
  {ProjectName}WebApp in '{ProjectName}WebApp.pas' {{ProjectName}WebAppGlobal},
  {ProjectName}_Session in '{ProjectName}_Session.pas' {{ProjectName}Session},
  D2BridgeFormTemplate in 'D2BridgeFormTemplate.pas',
  {Units}
  {Language Support}
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

{$IFNDEF D2BRIDGE}
var
  {PrimaryFormUnit}: {PrimaryFormClass};
{$ENDIF}

begin
  Application.Initialize;
  {$IFNDEF D2BRIDGE}
  Application.CreateForm({PrimaryFormClass}, {PrimaryFormUnit});
  D2BridgeInstance.AddInstace({PrimaryFormUnit});
  Application.Run;
  {$ELSE}
  {Server}
  {$ENDIF}
end.
