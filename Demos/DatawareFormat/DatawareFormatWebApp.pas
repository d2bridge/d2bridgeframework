unit DatawareFormatWebApp;

interface

Uses
 System.Classes, System.SysUtils,
 {$IFNDEF FMX}
 Vcl.Dialogs,
 {$ELSE}
 FMX.Dialogs,
 {$ENDIF}
 D2Bridge.ServerControllerBase, D2Bridge.Types,
 Prism.Session, Prism.Server.HTTP.Commom, Prism.Types, Prism.Interfaces,
 DatawareFormat_Session, Data.DB, Datasnap.DBClient;

type
 IPrismSession = Prism.Interfaces.IPrismSession;
 TSessionChangeType = Prism.Types.TSessionChangeType;
 TD2BridgeLang = D2Bridge.Types.TD2BridgeLang;


type
 TDatawareFormatWebAppGlobal = class(TD2BridgeServerControllerBase)
  private
   procedure OnNewSession(const Request: TPrismHTTPRequest; Response: TPrismHTTPResponse; Session: TPrismSession);
   procedure OnCloseSession(Session: TPrismSession);
   procedure OnException(Form: TObject; Sender: TObject; E: Exception; FormName: String; ComponentName: String; EventName: string; APrismSession: IPrismSession);
  public
   constructor Create(AOwner: TComponent); override;

 end;


var
 D2BridgeServerController: TDatawareFormatWebAppGlobal;


Function DatawareFormat: TDatawareFormatSession;


implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

Uses
 D2Bridge.Instance;

{$R *.dfm}

Function DatawareFormat: TDatawareFormatSession;
begin
 Result:= TDatawareFormatSession(D2BridgeInstance.PrismSession.Data);
end;

constructor TDatawareFormatWebAppGlobal.Create(AOwner: TComponent);
begin
 inherited;
 {$IFDEF D2BRIDGE} 
  Prism.OnNewSession:= OnNewSession;
  Prism.OnCloseSession:= OnCloseSession;
  Prism.OnException:= OnException;
 {$ENDIF} 

 
 //Our Code
 
  
 {$IFNDEF D2BRIDGE}
  OnNewSession(nil, nil, D2BridgeInstance.PrismSession as TPrismSession);
 {$ENDIF}
end;

procedure TDatawareFormatWebAppGlobal.OnCloseSession(Session: TPrismSession);
begin

end;

procedure TDatawareFormatWebAppGlobal.OnException(Form, Sender: TObject;
  E: Exception; FormName, ComponentName, EventName: string;
  APrismSession: IPrismSession);
begin
 //Show Error Messages
 if Assigned(APrismSession) then
  APrismSession.MessageDlg(E.Message, TMsgDlgType.mtError, [mbOk], 0);
end;

procedure TDatawareFormatWebAppGlobal.OnNewSession(const Request: TPrismHTTPRequest; Response: TPrismHTTPResponse; Session: TPrismSession);
begin
 D2BridgeInstance.PrismSession.Data := TDatawareFormatSession.Create(Session);

 //Set Language just this Session
 //Session.Language:= TD2BridgeLang.English;

 //Our Code

end;



{$IFNDEF D2BRIDGE}
initialization
 D2BridgeServerController:= TDatawareFormatWebAppGlobal.Create(D2BridgeInstance.Owner);
{$ENDIF}

end.
