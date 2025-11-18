unit LazarusWebApp;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

Uses
 Classes, SysUtils,
 System.UITypes,
 D2Bridge.ServerControllerBase, D2Bridge.Types,
 Prism.Session, Prism.Server.HTTP.Commom, Prism.Types, Prism.Interfaces,
 Lazarus_Session;

type
 IPrismSession = Prism.Interfaces.IPrismSession;
 TSessionChangeType = Prism.Types.TSessionChangeType;
 TD2BridgeLang = D2Bridge.Types.TD2BridgeLang;


type
 TLazarusWebAppGlobal = class(TD2BridgeServerControllerBase)
  private
   procedure OnNewSession(const Request: TPrismHTTPRequest; Response: TPrismHTTPResponse; Session: TPrismSession);
   procedure OnCloseSession(Session: TPrismSession);
   procedure OnDisconnectSession(Session: TPrismSession);
   procedure OnReconnectSession(Session: TPrismSession);
   procedure OnExpiredSession(Session: TPrismSession; var Renew: boolean);
   procedure OnIdleSession(Session: TPrismSession; var Renew: boolean);
   procedure OnException(Form: TObject; Sender: TObject; E: Exception; FormName: String; ComponentName: String; EventName: string; APrismSession: IPrismSession);
   procedure OnSecurity(const SecEventInfo: TSecuritEventInfo);
  public
   constructor Create(AOwner: TComponent); override;

 end;


var
 D2BridgeServerController: TLazarusWebAppGlobal;


Function LazarusDemo: TLazarusDemoSession;


implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

Uses
 D2Bridge.Instance;

{$IFNDEF FPC}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF} 

Function LazarusDemo: TLazarusDemoSession;
begin
 Result:= TLazarusDemoSession(D2BridgeInstance.PrismSession.Data);
end;

constructor TLazarusWebAppGlobal.Create(AOwner: TComponent);
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
  Prism.OnSecurity:= OnSecurity;
 {$ENDIF}

 if IsD2BridgeContext then
 begin
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
 end;

  
 {$IFNDEF D2BRIDGE}
  OnNewSession(nil, nil, D2BridgeInstance.PrismSession as TPrismSession);
 {$ENDIF}
end;

procedure TLazarusWebAppGlobal.OnException(Form, Sender: TObject; E: Exception; FormName, ComponentName, EventName: string; APrismSession: IPrismSession);
begin
 //Show Error Messages
 {
  if Assigned(APrismSession) then
   APrismSession.ShowMessageError(E.Message);
 }
end;

procedure TLazarusWebAppGlobal.OnNewSession(const Request: TPrismHTTPRequest; Response: TPrismHTTPResponse; Session: TPrismSession);
begin
 D2BridgeInstance.PrismSession.Data := TLazarusDemoSession.Create(Session);

 //Set Language just this Session
 //Session.Language:= TD2BridgeLang.English;

 //Our Code

end;

procedure TLazarusWebAppGlobal.OnCloseSession(Session: TPrismSession);
begin
 //Close ALL DataBase connection
 //Ex: Dm.DBConnection.Close;

end;

procedure TLazarusWebAppGlobal.OnExpiredSession(Session: TPrismSession; var Renew: boolean);
begin
 //Example of use Renew
 {
  if Session.InfoConnection.Identity = 'UserXYZ' then
   Renew:= true;
 }
end;

procedure TLazarusWebAppGlobal.OnIdleSession(Session: TPrismSession; var Renew: boolean);
begin

end;

procedure TLazarusWebAppGlobal.OnDisconnectSession(Session: TPrismSession);
begin

end;

procedure TLazarusWebAppGlobal.OnReconnectSession(Session: TPrismSession);
begin

end;

procedure TLazarusWebAppGlobal.OnSecurity(const SecEventInfo: TSecuritEventInfo);
begin
{
 if SecEventInfo.Event = TSecurityEvent.secNotDelistIPBlackList then
 begin
  //Write IP Delist to Reload in WhiteList
  SecEventInfo.IP...
 end;
}
end;


{$IFNDEF D2BRIDGE}
initialization
 D2BridgeServerController:= TLazarusWebAppGlobal.Create(D2BridgeInstance.Owner);
{$ENDIF}

end.
