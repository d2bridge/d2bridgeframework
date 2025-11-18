unit Unit_Server_D2Bridge;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  MidasLib,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Imaging.pngimage, Data.DB, Vcl.Grids, Vcl.DBGrids,
  ServerController, Vcl.Menus;

type
  TForm_Servidor_D2Bridge = class(TForm)
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
  Form_Servidor_D2Bridge: TForm_Servidor_D2Bridge;

implementation

Uses
 Unit_login,
 D2BridgeFormTemplate, D2Bridge.BaseClass;


{$R *.dfm}


procedure TForm_Servidor_D2Bridge.Button_OptionsClick(Sender: TObject);
begin
 with Button_Options.ClientToScreen(point(0, 1 + Button_Options.Height)) do
  PopupMenu_Options.Popup(x, Y)
end;

procedure TForm_Servidor_D2Bridge.Button_StartClick(Sender: TObject);
begin
 D2BridgeServerController.PrimaryFormClass:= TForm_Login;

// if IsDebuggerPresent then
//  D2BridgeServerController.Prism.Options.SSL:= False
// else
//  D2BridgeServerController.Prism.Options.SSL:= True;

 if D2BridgeServerController.Prism.Options.SSL then
 begin
  //Cert Key Domain File
  D2BridgeServerController.Prism.SSLOptions.KeyFile:= 'SSL' + PathDelim + 'certificado_d2bridge_key.txt';
  //Cert File
  D2BridgeServerController.Prism.SSLOptions.CertFile:= 'SSL' + PathDelim + 'certificado_d2bridge_crt.txt';
  //Cert Intermediate (case Let’s Encrypt)
  D2BridgeServerController.Prism.SSLOptions.RootCertFile:= 'SSL' + PathDelim + 'certificado_d2bridge_ca-crt.txt';
 end;

 D2BridgeServerController.Prism.Options.PathJS:= 'assets/js';
 D2BridgeServerController.Prism.Options.PathCSS:= 'assets/css';
 D2BridgeServerController.Prism.Options.IncludeJQuery:= true;
 D2BridgeServerController.Prism.Options.DataSetLog:= true;

 D2BridgeServerController.Port:= StrToInt(Edit_Port.Text);
 D2BridgeServerController.StartServer;

 Status_Buttons;
end;

procedure TForm_Servidor_D2Bridge.Button_StopClick(Sender: TObject);
begin
 D2BridgeServerController.StopServer;

 Status_Buttons;
end;

procedure TForm_Servidor_D2Bridge.CloseAllSessions1Click(Sender: TObject);
begin
 D2BridgeServerController.CloseAllSessions;
end;

procedure TForm_Servidor_D2Bridge.CloseSession1Click(Sender: TObject);
begin
 D2BridgeServerController.CloseSession(DBGrid_Log.DataSource.DataSet.FieldByName('UUID').AsString);
end;

procedure TForm_Servidor_D2Bridge.FormCreate(Sender: TObject);
begin
 D2BridgeServerController:= TD2BridgeServerController.Create(Application);
 D2BridgeServerController.OnSessionChange:= SessionChange;
 DBGrid_Log.DataSource:= D2BridgeServerController.DataSourceLog;

 Label_Version.Caption:= 'D2Bridge Version: '+D2BridgeServerController.D2BridgeManager.Version;
end;

procedure TForm_Servidor_D2Bridge.FormShow(Sender: TObject);
begin
 Button_Start.Click;
 Status_Buttons;
end;

procedure TForm_Servidor_D2Bridge.SendPushMessage1Click(Sender: TObject);
var
 vResp: String;
begin
 vResp:= InputBox('PUSH', 'Message', '');

 D2BridgeServerController.SendMessageToSession(DBGrid_Log.DataSource.DataSet.FieldByName('UUID').AsString,vResp);
end;

procedure TForm_Servidor_D2Bridge.SendPushMessageAllSessions1Click(Sender: TObject);
var
 vResp: String;
begin
 vResp:= InputBox('PUSH', 'Message', '');

 D2BridgeServerController.SendMessageToAllSession(vResp);
end;

procedure TForm_Servidor_D2Bridge.SessionChange(AChangeType: TSessionChangeType; APrismSession: IPrismSession);
begin
 Label_Sessions.Caption:= IntToStr(D2BridgeServerController.Prism.Sessions.Count);
end;

procedure TForm_Servidor_D2Bridge.Status_Buttons;
begin
 Button_Start.Enabled:= not D2BridgeServerController.Started;
 Button_Stop.Enabled:= D2BridgeServerController.Started;
 Edit_Port.Enabled:= not D2BridgeServerController.Started;
end;

end.
