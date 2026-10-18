{
  ------------------------------------------------------------------------------
  D2Bridge Windows Service Extension
  ------------------------------------------------------------------------------

  Original Framework:
    D2Bridge Framework
    Author: Talis Jonatas Gomes

  This unit adds Windows Service support to the D2Bridge framework,
  enabling D2Bridge Web applications to run as native Windows Services.

  Windows Service integration, architecture adaptation and service lifecycle
  implementation by:
    Hamid Reza Kabiri
	hamid.kabiri@gmail.com
	https://github.com/kabiri
	
  Notes:
    - This extension does not modify the original D2Bridge core.
    - It provides an alternative hosting model (Windows Service).
    - Console and Docker modes remain fully supported.

  ------------------------------------------------------------------------------

  Good Thoughts, Good Words, Good Deeds.
}
unit Unit_D2Bridge_Server_Core;

interface

uses
  System.SysUtils,
  System.Classes,
  Unit1;

type
  T{ProjectName}ServerCore = class
  private
    class var FStarted: Boolean;
	class var vServerPort: Integer;
    class var VServerName: String;
  public
    class procedure Start;
    class procedure Stop;
    class function IsStarted: Boolean;
  end;

implementation

uses
  {ProjectName}WebApp;

{ TD2BridgeServerCore }

class procedure T{ProjectName}ServerCore.Start;
begin
  if FStarted then
    Exit;

  D2BridgeServerController:= T{ProjectName}WebAppGlobal.Create(nil);
  
  vServerPort:= D2BridgeServerController.APPConfig.ServerPort({Server_Port});
  vServerName:= D2BridgeServerController.APPConfig.ServerName('{Server_Name}');

  D2BridgeServerController.APPName:= '{ProjectName}';

  D2BridgeServerController.PrimaryFormClass:= {PrimaryFormClass};


  //D2BridgeServerController.Prism.Options.IncludeJQuery:= true;

  //D2BridgeServerController.Prism.Options.DataSetLog:= true;
  //D2BridgeServerController.Prism.Options.LogAccess:= true;
  //D2BridgeServerController.Prism.Options.LogException:= true;
  //D2BridgeServerController.Prism.Options.LogSecurity:= true;
  //D2BridgeServerController.Prism.Options.LogHang:= true;
  //D2BridgeServerController.Prism.Options.LogFileMode:= lfmDaily;
  //D2BridgeServerController.Prism.Options.ResourceMonitor:= true;
  //D2BridgeServerController.Prism.Options.ResourceMonitorIntervalSec:= 60;
  //D2BridgeServerController.Prism.Options.ResourceMonitorTopProcessCount:= 3;
  //D2BridgeServerController.Prism.Options.ResourceMonitorCPUAlertPercent:= 70;
  //D2BridgeServerController.Prism.Options.ResourceMonitorMemoryAlertMB:= 2048;

  D2BridgeServerController.Prism.Options.CoInitialize:= true;

  //D2BridgeServerController.Prism.Options.VCLStyles:= false;

  //D2BridgeServerController.Prism.Options.ShowError500Page:= false;

  //Uncomment to Dual Mode force http just in Debug Mode
  //if IsDebuggerPresent then
  // D2BridgeServerController.Prism.Options.SSL:= false
  //else
  //D2BridgeServerController.Prism.Options.SSL:= true;

  D2BridgeServerController.Languages:= {Languages};

  if D2BridgeServerController.Prism.Options.SSL then
  begin
   //Cert File
   D2BridgeServerController.Prism.SSLOptions.CertFile:= '{Certificate}';
   //Cert Key Domain File
   D2BridgeServerController.Prism.SSLOptions.KeyFile:= '{Certificate_Key}';
   //Cert Intermediate (case Let�s Encrypt)
   D2BridgeServerController.Prism.SSLOptions.RootCertFile:= '{Certificate Intermediate}';
  end;

  D2BridgeServerController.Prism.Options.PathJS:= '{PathJS}';
  D2BridgeServerController.Prism.Options.PathCSS:= '{PathCSS}';

  //Wait start D2Docker
  if D2BridgeServerController.IsD2DockerContext then
   Exit;

  D2BridgeServerController.Port:= vServerPort;
  D2BridgeServerController.ServerName:= VServerName; 

  D2BridgeServerController.StartServer;

  FStarted := True;
end;

class procedure T{ProjectName}ServerCore.Stop;
begin
  if not FStarted then
    Exit;

  if Assigned(D2BridgeServerController) then
    D2BridgeServerController.StopServer;

  FStarted := False;
end;

class function T{ProjectName}ServerCore.IsStarted: Boolean;
begin
  Result := FStarted;
end;

end.