unit QRCodeReaderWebApp;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

Uses
 Classes, SysUtils,
 System.UITypes,
 D2Bridge.ServerControllerBase, D2Bridge.Types,
 Prism.Session, Prism.Server.HTTP.Commom, Prism.Types, Prism.Interfaces,
 QRCodeReader_Session;

type
 IPrismSession = Prism.Interfaces.IPrismSession;
 TSessionChangeType = Prism.Types.TSessionChangeType;
 TD2BridgeLang = D2Bridge.Types.TD2BridgeLang;


type
 TQRCodeReaderWebAppGlobal = class(TD2BridgeServerControllerBase)
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
 D2BridgeServerController: TQRCodeReaderWebAppGlobal;


Function QRCodeReader: TQRCodeReaderSession;


implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

Uses
 D2Bridge.Instance;

{$IFNDEF FPC}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF} 

Function QRCodeReader: TQRCodeReaderSession;
begin
 Result:= TQRCodeReaderSession(D2BridgeInstance.PrismSession.Data);
end;

constructor TQRCodeReaderWebAppGlobal.Create(AOwner: TComponent);
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

 
 //Our Code
 
  
 {$IFNDEF D2BRIDGE}
  OnNewSession(nil, nil, D2BridgeInstance.PrismSession as TPrismSession);
 {$ENDIF}
end;

procedure TQRCodeReaderWebAppGlobal.OnException(Form, Sender: TObject; E: Exception; FormName, ComponentName, EventName: string; APrismSession: IPrismSession);
begin
 //Show Error Messages
 {
  if Assigned(APrismSession) then
   APrismSession.ShowMessageError(E.Message);
 }
end;

procedure TQRCodeReaderWebAppGlobal.OnNewSession(const Request: TPrismHTTPRequest; Response: TPrismHTTPResponse; Session: TPrismSession);
begin
 D2BridgeInstance.PrismSession.Data := TQRCodeReaderSession.Create(Session);

 //Set Language just this Session
 //Session.Language:= TD2BridgeLang.English;

 //Our Code

end;

procedure TQRCodeReaderWebAppGlobal.OnCloseSession(Session: TPrismSession);
begin
 //Close ALL DataBase connection
 //Ex: Dm.DBConnection.Close;

end;

procedure TQRCodeReaderWebAppGlobal.OnExpiredSession(Session: TPrismSession; var Renew: boolean);
begin
 //Example of use Renew
 {
  if Session.InfoConnection.Identity = 'UserXYZ' then
   Renew:= true;
 }
end;

procedure TQRCodeReaderWebAppGlobal.OnIdleSession(Session: TPrismSession; var Renew: boolean);
begin

end;

procedure TQRCodeReaderWebAppGlobal.OnDisconnectSession(Session: TPrismSession);
begin

end;

procedure TQRCodeReaderWebAppGlobal.OnReconnectSession(Session: TPrismSession);
begin

end;

procedure TQRCodeReaderWebAppGlobal.OnSecurity(const SecEventInfo: TSecuritEventInfo);
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
 D2BridgeServerController:= TQRCodeReaderWebAppGlobal.Create(D2BridgeInstance.Owner);
{$ENDIF}

end.
