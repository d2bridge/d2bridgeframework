unit REST_Session;

interface

uses
  System.SysUtils, System.Classes,
  Prism.SessionBase;

type
  TRESTSession = class(TPrismSessionBase)
  private
  public
  end;

implementation

uses
  D2Bridge.Instance,
  ServerController;

{$R *.dfm}

end.
