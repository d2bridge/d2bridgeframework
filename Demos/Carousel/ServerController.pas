unit ServerController;

interface

Uses
 System.Classes, System.SysUtils,
 Web.HTTPApp, Vcl.Dialogs,
 D2Bridge.ServerControllerBase, D2Bridge.Types,
 Prism.Session, Prism.Server.HTTP.Commom, Prism.Types, Prism.Interfaces,
 Carousel_Session, Data.DB, Datasnap.DBClient;

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


Function Carousel: TCarouselSession;


implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

Uses
 D2Bridge.Instance, Unit_DM;

{$R *.dfm}

Function Carousel: TCarouselSession;
begin
 Result:= TCarouselSession(D2BridgeInstance.PrismSession.Data);
end;

constructor TD2BridgeServerController.Create(AOwner: TComponent);
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

procedure TD2BridgeServerController.OnCloseSession(Session: TPrismSession);
begin

end;

procedure TD2BridgeServerController.OnException(Form, Sender: TObject;
  E: Exception; FormName, ComponentName, EventName: string;
  APrismSession: IPrismSession);
begin
 //Show Error Messages
 {
 if Assigned(APrismSession) then
  APrismSession.ShowMessage(E.Message, TMsgDlgType.mtError);
 }
end;

procedure TD2BridgeServerController.OnNewSession(const Request: TPrismHTTPRequest; Response: TPrismHTTPResponse; Session: TPrismSession);
begin
 D2BridgeInstance.PrismSession.Data := TCarouselSession.Create(Session);

 //Set Language just this Session
 //Session.Language:= TD2BridgeLang.English;

 //Our Code
 //Is necessary create DM before will instancie Form1
 TDM.CreateInstance;
end;



{$IFNDEF D2BRIDGE}
initialization
 D2BridgeServerController:= TD2BridgeServerController.Create(D2BridgeInstance.Owner);
{$ENDIF}

end.
