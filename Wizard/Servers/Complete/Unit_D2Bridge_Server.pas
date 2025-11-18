{
 +--------------------------------------------------------------------------+
  D2Bridge Framework Content

  Author: Talis Jonatas Gomes
  Email: talisjonatas@me.com

  Module: Complete D2Bridge Server

  This source code is provided 'as-is', without any express or implied
  warranty. In no event will the author be held liable for any damages
  arising from the use of this code.

  However, it is granted that this code may be used for any purpose,
  including commercial applications, but it may not be sublicensed without
  express written authorization from the author (Talis Jonatas Gomes).
  This includes creating derivative works or distributing the source code
  through any means.

  If you use this software in a product, an acknowledgment in the product
  documentation would be appreciated but is not required.

  God bless you
 +--------------------------------------------------------------------------+
}


unit Unit_D2Bridge_Server;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  MidasLib,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Imaging.pngimage, Data.DB, Vcl.Grids, Vcl.DBGrids,
  {ProjectName}WebApp, Vcl.Menus;

type
  TForm_D2Bridge_Server = class(TForm)
    Label1: TLabel;
    Button_Start: TButton;
    Edit_Port: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label_Version: TLabel;
    Button_Stop: TButton;
    DBGrid_Log: TDBGrid;
    Label4: TLabel;
    Label_Sessions: TLabel;
    Button_Options: TButton;
    PopupMenu_Options: TPopupMenu;
    CloseSession1: TMenuItem;
    SendPushMessage1: TMenuItem;
    N1: TMenuItem;
    CloseAllSessions1: TMenuItem;
    SendPushMessageAllSessions1: TMenuItem;
    Panel_Logo_D2Bridge: TPanel;
    Image_Logo_D2Bridge: TImage;
    Edit_ServerName: TEdit;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button_StartClick(Sender: TObject);
    procedure Button_StopClick(Sender: TObject);
    procedure Status_Buttons;
    procedure FormShow(Sender: TObject);
    procedure Button_OptionsClick(Sender: TObject);
    procedure CloseSession1Click(Sender: TObject);
    procedure SendPushMessage1Click(Sender: TObject);
    procedure CloseAllSessions1Click(Sender: TObject);
    procedure SendPushMessageAllSessions1Click(Sender: TObject);
  private
    procedure SessionChange(AChangeType: TSessionChangeType; APrismSession: IPrismSession);
  public
    { Public declarations }
  end;

var
  Form_D2Bridge_Server: TForm_D2Bridge_Server;

implementation

Uses
 {PrimaryFormUnit},
 D2Bridge.BaseClass;


{$R *.dfm}


procedure TForm_D2Bridge_Server.Button_OptionsClick(Sender: TObject);
begin
 with Button_Options.ClientToScreen(point(0, 1 + Button_Options.Height)) do
  PopupMenu_Options.Popup(x, Y)
end;

procedure TForm_D2Bridge_Server.Button_StartClick(Sender: TObject);
begin
 D2BridgeServerController.PrimaryFormClass:= {PrimaryFormClass};

 D2BridgeServerController.APPName:= '{ProjectName}';
 //D2BridgeServerController.APPDescription:= 'My D2Bridge Web APP';

 //Security
 {
 D2BridgeServerController.Prism.Options.Security.Enabled:= false; //True Default
 D2BridgeServerController.Prism.Options.Security.IP.IPv4BlackList.EnableSpamhausList:= false; //Disable Default Blocked Spamhaus list
 D2BridgeServerController.Prism.Options.Security.IP.IPv4BlackList.Add('192.168.10.31'); //Block just IP
 D2BridgeServerController.Prism.Options.Security.IP.IPv4BlackList.Add('200.200.200.0/24'); //Block CDIR
 D2BridgeServerController.Prism.Options.Security.IP.IPv4BlackList.EnableSelfDelist:= false; //Disable Delist
 D2BridgeServerController.Prism.Options.Security.IP.IPv4WhiteList.Add('192.168.0.1'); //Add IP or CDIR to WhiteList
 D2BridgeServerController.Prism.Options.Security.IP.IPConnections.LimitNewConnPerIPMin:= 30; //Limite Connections from IP *minute
 D2BridgeServerController.Prism.Options.Security.IP.IPConnections.LimitActiveSessionsPerIP:= 50; //Limite Sessions from IP
 D2BridgeServerController.Prism.Options.Security.UserAgent.EnableCrawlerUserAgents:= false; //Disable Default Blocked Crawler User Agents
 D2BridgeServerController.Prism.Options.Security.UserAgent.Add('NewUserAgent'); //Block User Agent
 D2BridgeServerController.Prism.Options.Security.UserAgent.Delete('MyUserAgent'); //Allow User Agent
 }

 //seconds to Send Session to TimeOut and Destroy after Disconnected
 //D2BridgeServerController.Prism.Options.SessionTimeOut:= 300;

 //secounds to set Session in Idle
 //D2BridgeServerController.Prism.Options.SessionIdleTimeOut:= 0;


 //D2BridgeServerController.Prism.Options.IncludeJQuery:= true;

 D2BridgeServerController.Prism.Options.DataSetLog:= true;

 //D2BridgeServerController.Prism.Options.CoInitialize:= true;

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

 D2BridgeServerController.Port:= StrToInt(Edit_Port.Text);
 D2BridgeServerController.ServerName:= Edit_ServerName.Text;
 D2BridgeServerController.ServerDescription:= 'Complete D2Bridge Server';
 D2BridgeServerController.StartServer;

 Status_Buttons;
end;

procedure TForm_D2Bridge_Server.Button_StopClick(Sender: TObject);
begin
 D2BridgeServerController.StopServer;

 Status_Buttons;
end;

procedure TForm_D2Bridge_Server.CloseAllSessions1Click(Sender: TObject);
begin
 D2BridgeServerController.CloseAllSessions;
end;

procedure TForm_D2Bridge_Server.CloseSession1Click(Sender: TObject);
begin
 D2BridgeServerController.CloseSession(DBGrid_Log.DataSource.DataSet.FieldByName('UUID').AsString);
end;

procedure TForm_D2Bridge_Server.FormCreate(Sender: TObject);
begin
 D2BridgeServerController:= T{ProjectName}WebAppGlobal.Create(Application);
 D2BridgeServerController.OnSessionChange:= SessionChange;
 DBGrid_Log.DataSource:= D2BridgeServerController.DataSourceLog;

 Edit_Port.Text:= IntToStr(D2BridgeServerController.Prism.INIConfig.ServerPort(StrToInt(Edit_Port.Text)));
 Edit_ServerName.Text:= D2BridgeServerController.Prism.INIConfig.ServerName(Edit_ServerName.Text);

 Label_Version.Caption:= 'D2Bridge Version: '+D2BridgeServerController.D2BridgeManager.Version;
end;

procedure TForm_D2Bridge_Server.FormShow(Sender: TObject);
begin
 Button_Start.Click;
 Status_Buttons;
end;

procedure TForm_D2Bridge_Server.SendPushMessage1Click(Sender: TObject);
var
 vResp: String;
begin
 vResp:= InputBox('PUSH', 'Message', '');

 D2BridgeServerController.SendMessageToSession(DBGrid_Log.DataSource.DataSet.FieldByName('UUID').AsString,vResp);
end;

procedure TForm_D2Bridge_Server.SendPushMessageAllSessions1Click(Sender: TObject);
var
 vResp: String;
begin
 vResp:= InputBox('PUSH', 'Message', '');

 D2BridgeServerController.SendMessageToAllSession(vResp);
end;

procedure TForm_D2Bridge_Server.SessionChange(AChangeType: TSessionChangeType; APrismSession: IPrismSession);
begin
 Label_Sessions.Caption:= IntToStr(D2BridgeServerController.Prism.Sessions.Count);
end;

procedure TForm_D2Bridge_Server.Status_Buttons;
begin
 Button_Start.Enabled:= not D2BridgeServerController.Started;
 Button_Stop.Enabled:= D2BridgeServerController.Started;
 Edit_Port.Enabled:= not D2BridgeServerController.Started;
 Edit_ServerName.Enabled:= not D2BridgeServerController.Started;
end;

end.
