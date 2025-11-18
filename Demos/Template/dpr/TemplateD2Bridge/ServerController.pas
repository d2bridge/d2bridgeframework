unit ServerController;

interface

Uses
 System.Classes, System.SysUtils,
 Web.HTTPApp,
 D2Bridge.ServerControllerBase,
 Prism.Session, Prism.Server.HTTP.Commom, Prism.Types, Prism.Interfaces,
 UserSessionUnit;


type
 IPrismSession = Prism.Interfaces.IPrismSession;
 TSessionChangeType = Prism.Types.TSessionChangeType;


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
 D2Bridge.Instance,
 Unit_Menu;

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
 D2BridgeInstance.DestroyInstance(TForm_Menu);
end;

procedure TD2BridgeServerController.OnNewSession(const Request: TPrismHTTPRequest; Response: TPrismHTTPResponse; Session: TPrismSession);
begin
 Session.Data := TPrismUserSession.Create(Session);

 //Our Code
 if Form_Menu = nil then
  D2BridgeInstance.CreateInstance(TForm_Menu);

end;



end.
