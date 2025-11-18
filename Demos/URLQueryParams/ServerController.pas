unit ServerController;

interface

Uses
 System.Classes, System.SysUtils,
 Web.HTTPApp,
 D2Bridge.ServerControllerBase, D2Bridge.Types,
 Prism.Session, Prism.Server.HTTP.Commom, Prism.Types, Prism.Interfaces,
 UserSessionUnit;

type
 IPrismSession = Prism.Interfaces.IPrismSession;
 TSessionChangeType = Prism.Types.TSessionChangeType;
 TD2BridgeLang = D2Bridge.Types.TD2BridgeLang;


type
 TD2BridgeServerController = class(TD2BridgeServerControllerBase)
  private
   procedure OnNewSession(const Request: TPrismHTTPRequest; Response: TPrismHTTPResponse; Session: TPrismSession);
   procedure OnCloseSession(Session: TPrismSession);
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
 Prism.OnNewSession:= OnNewSession;
 Prism.OnCloseSession:= OnCloseSession;
end;

procedure TD2BridgeServerController.OnCloseSession(Session: TPrismSession);
begin

end;

procedure TD2BridgeServerController.OnNewSession(const Request: TPrismHTTPRequest; Response: TPrismHTTPResponse; Session: TPrismSession);
begin
 D2BridgeInstance.PrismSession.Data := TPrismUserSession.Create(Session);

 //Set Language just this Session
 //Session.Language:= TD2BridgeLang.English;

 //Our Code

end;



end.
