unit ServerController;

interface

Uses
 System.Classes, System.SysUtils,
 Web.HTTPApp,
 D2Bridge.ServerControllerBase, D2Bridge.Types,
 Prism.Session, Prism.Server.HTTP.Commom, Prism.Types, Prism.Interfaces,
 UserSessionUnit, Data.DB, Datasnap.DBClient;

type
 IPrismSession = Prism.Interfaces.IPrismSession;
 TSessionChangeType = Prism.Types.TSessionChangeType;
 TD2BridgeLang = D2Bridge.Types.TD2BridgeLang;


type
 TD2BridgeServerController = class(TD2BridgeServerControllerBase)
  private
   procedure OnNewSession(const Request: TPrismHTTPRequest; Response: TPrismHTTPResponse; Session: TPrismSession);
   procedure OnCloseSession(Session: TPrismSession);
   procedure OnException(Form: TObject; Sender: TObject; E: Exception; FormName: String; ComponentName: String; EventName: string; APrismSession: IPrismSession);
  public
   constructor Create(AOwner: TComponent); override;

 end;


var
 D2BridgeServerController: TD2BridgeServerController;


Function UserSession: TPrismUserSession;


implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

Uses
 D2Bridge.Instance;

{$R *.dfm}

Function UserSession: TPrismUserSession;
begin
 Result:= TPrismUserSession(D2BridgeInstance.PrismSession.Data);
end;

constructor TD2BridgeServerController.Create(AOwner: TComponent);
begin
 inherited;
 {$IFDEF D2BRIDGE} 
  Prism.OnNewSession:= OnNewSession;
  Prism.OnCloseSession:= OnCloseSession;
 {$ENDIF} 

 
 //Our Code
 
  
 {$IFNDEF D2BRIDGE}
  OnNewSession(TPrismHTTPRequest.Create, TPrismHTTPResponse.Create, D2BridgeInstance.PrismSession as TPrismSession);
 {$ENDIF} 
end;

procedure TD2BridgeServerController.OnCloseSession(Session: TPrismSession);
begin

end;

procedure TD2BridgeServerController.OnException(Form, Sender: TObject;
  E: Exception; FormName, ComponentName, EventName: string;
  APrismSession: IPrismSession);
begin
 //D2Bridge Exception Events

 //Uncomment to show error message in Client
 {
  if Assigned(APrismSession) then
   APrismSession.ShowMessage(E.Message, TMsgDlgType.mtError);
 }
end;

procedure TD2BridgeServerController.OnNewSession(const Request: TPrismHTTPRequest; Response: TPrismHTTPResponse; Session: TPrismSession);
begin
 D2BridgeInstance.PrismSession.Data := TPrismUserSession.Create(Session);

 //your Code

end;



{$IFNDEF D2BRIDGE}
initialization
 D2BridgeServerController:= TD2BridgeServerController.Create(D2BridgeInstance.Owner);
{$ENDIF}

end.
