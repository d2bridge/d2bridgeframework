unit ServerController;

interface

Uses
 System.Classes, System.SysUtils,
 Web.HTTPApp,
 D2Bridge.ServerControllerBase,
 Prism.Session, Prism.Server.HTTP.Commom,
 UserSessionUnit;


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

Uses
 D2Bridge.Instance;

{ TD2BridgeServerController }


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

 //Our Code

end;



end.
