unit ServerController;

interface

uses
  Classes, SysUtils,
{$IFDEF FPC}
  Dialogs,
{$ELSE}
  Vcl.Dialogs,
{$ENDIF}
  D2Bridge.ServerControllerBase, D2Bridge.Types,
  Prism.Session, Prism.Server.HTTP.Commom, Prism.Types, Prism.Interfaces,
  Maps_Session;

type
  IPrismSession = Prism.Interfaces.IPrismSession;
  TSessionChangeType = Prism.Types.TSessionChangeType;
  TD2BridgeLang = D2Bridge.Types.TD2BridgeLang;

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

function MapSession: TMapsSession;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

uses
  D2Bridge.Instance;

{$IFNDEF FPC}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

function MapSession: TMapsSession;
begin
  Result := TMapsSession(D2BridgeInstance.PrismSession.Data);
end;

constructor TD2BridgeServerController.Create(AOwner: TComponent);
begin
  inherited;
{$IFDEF D2BRIDGE}
  Prism.OnNewSession := OnNewSession;
  Prism.OnCloseSession := OnCloseSession;
  Prism.OnException := OnException;
{$ENDIF}

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
end;

procedure TD2BridgeServerController.OnNewSession(const Request: TPrismHTTPRequest;
  Response: TPrismHTTPResponse; Session: TPrismSession);
begin
  D2BridgeInstance.PrismSession.Data := TMapsSession.Create(Session);
end;

end.
