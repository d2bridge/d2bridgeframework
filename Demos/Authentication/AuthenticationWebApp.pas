unit AuthenticationWebApp;

interface

Uses
 System.Classes, System.SysUtils, System.UITypes,
 D2Bridge.ServerControllerBase, D2Bridge.Types,
 Prism.Session, Prism.Server.HTTP.Commom, Prism.Types, Prism.Interfaces,
 Authentication_Session, Data.DB, Datasnap.DBClient;

type
 IPrismSession = Prism.Interfaces.IPrismSession;
 TSessionChangeType = Prism.Types.TSessionChangeType;
 TD2BridgeLang = D2Bridge.Types.TD2BridgeLang;


type
 TAuthenticationWebAppGlobal = class(TD2BridgeServerControllerBase)
  private
   procedure OnNewSession(const Request: TPrismHTTPRequest; Response: TPrismHTTPResponse; Session: TPrismSession);
   procedure OnCloseSession(Session: TPrismSession);
   procedure OnDisconnectSession(Session: TPrismSession);
   procedure OnReconnectSession(Session: TPrismSession);
   procedure OnExpiredSession(Session: TPrismSession; var Renew: boolean);
   procedure OnIdleSession(Session: TPrismSession; var Renew: boolean);
   procedure OnException(Form: TObject; Sender: TObject; E: Exception; FormName: String; ComponentName: String; EventName: string; APrismSession: IPrismSession);
  public
   constructor Create(AOwner: TComponent); override;

 end;


var
 D2BridgeServerController: TAuthenticationWebAppGlobal;


Function Authentication: TAuthenticationSession;


implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

Uses
 D2Bridge.Instance;

{$R *.dfm}

Function Authentication: TAuthenticationSession;
begin
 Result:= TAuthenticationSession(D2BridgeInstance.PrismSession.Data);
end;

constructor TAuthenticationWebAppGlobal.Create(AOwner: TComponent);
begin
 inherited;
 {$IFDEF D2BRIDGE} 
  Prism.OnNewSession:= OnNewSession;
  Prism.OnCloseSession:= OnCloseSession;
  Prism.OnDisconnectSession:= OnDisconnectSession;
  Prism.OnReconnectSession:= OnReconnectSession;
  Prism.OnExpiredSession:= OnExpiredSession;
  Prism.OnIdleSession:= OnIdleSession;
  Prism.OnException:= OnException;
 {$ENDIF}

 
 //Our Code
 with D2BridgeManager.API.Auth.Google do
 begin
  Config.ClientID    :='48089097822-t8j04t1k7u08ic0fopckf5tp6n7kesfr.apps.googleusercontent.com';
  Config.ClientSecret:='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';
end;

 with D2BridgeManager.API.Auth.Microsoft do
 begin
  Config.ClientID    :='f04a67e5-7136-4bf0-aba0-de36e006e668';
  Config.ClientSecret:='WVw8Q~R6FJKOTvg_FIP92jNWLvwuYwebgUAkkclK';
 end;


 {$IFNDEF D2BRIDGE}
  OnNewSession(nil, nil, D2BridgeInstance.PrismSession as TPrismSession);
 {$ENDIF}
end;

procedure TAuthenticationWebAppGlobal.OnException(Form, Sender: TObject; E: Exception; FormName, ComponentName, EventName: string; APrismSession: IPrismSession);
begin
 //Show Error Messages
 {
  if Assigned(APrismSession) then
   APrismSession.ShowMessageError(E.Message);
 }
end;

procedure TAuthenticationWebAppGlobal.OnNewSession(const Request: TPrismHTTPRequest; Response: TPrismHTTPResponse; Session: TPrismSession);
begin
 D2BridgeInstance.PrismSession.Data := TAuthenticationSession.Create(Session);

 //Set Language just this Session
 //Session.Language:= TD2BridgeLang.English;

 //Our Code

end;

procedure TAuthenticationWebAppGlobal.OnCloseSession(Session: TPrismSession);
begin
 //Close ALL DataBase connection
 //Ex: Dm.DBConnection.Close;

end;

procedure TAuthenticationWebAppGlobal.OnExpiredSession(Session: TPrismSession; var Renew: boolean);
begin
 //Example of use Renew
 {
  if Session.InfoConnection.Identity = 'UserXYZ' then
   Renew:= true;
 }
end;

procedure TAuthenticationWebAppGlobal.OnIdleSession(Session: TPrismSession; var Renew: boolean);
begin

end;

procedure TAuthenticationWebAppGlobal.OnDisconnectSession(Session: TPrismSession);
begin

end;

procedure TAuthenticationWebAppGlobal.OnReconnectSession(Session: TPrismSession);
begin

end;


{$IFNDEF D2BRIDGE}
initialization
 D2BridgeServerController:= TAuthenticationWebAppGlobal.Create(D2BridgeInstance.Owner);
{$ENDIF}

end.
