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
  ServerController, Vcl.Menus, D2Bridge.Types;

type
  TD2BridgeLang = D2Bridge.Types.TD2BridgeLang;

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
 Unit1,
 D2Bridge.BaseClass;


{$R *.dfm}


procedure TForm_D2Bridge_Server.Button_OptionsClick(Sender: TObject);
begin
 with Button_Options.ClientToScreen(point(0, 1 + Button_Options.Height)) do
  PopupMenu_Options.Popup(x, Y)
end;

procedure TForm_D2Bridge_Server.Button_StartClick(Sender: TObject);
begin
 D2BridgeServerController.PrimaryFormClass:= TForm1;

 D2BridgeServerController.Prism.Options.IncludeJQuery:= true;

 D2BridgeServerController.Prism.Options.DataSetLog:= true;

 //Denife your Language
 //D2BridgeServerController.Language:= TD2BridgeLang.English;

 //Uncomment to Dual Mode force http just in Debug Mode
 //if IsDebuggerPresent then
 // D2BridgeServerController.Prism.Options.SSL:= false
 //else
 //D2BridgeServerController.Prism.Options.SSL:= true;

 if D2BridgeServerController.Prism.Options.SSL then
 begin
  //Cert File
  D2BridgeServerController.Prism.SSLOptions.CertFile:= '';
  //Cert Key Domain File
  D2BridgeServerController.Prism.SSLOptions.KeyFile:= '';
  //Cert Intermediate (case Let�s Encrypt)
  D2BridgeServerController.Prism.SSLOptions.RootCertFile:= '';
 end;

 D2BridgeServerController.Prism.Options.PathJS:= 'js';
 D2BridgeServerController.Prism.Options.PathCSS:= 'css';

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
 D2BridgeServerController:= TD2BridgeServerController.Create(Application);
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
