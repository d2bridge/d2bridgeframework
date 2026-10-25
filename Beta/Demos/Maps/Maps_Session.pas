unit Maps_Session;

interface

uses
  SysUtils, Classes,
  Prism.SessionBase;

type
  TMapsSession = class(TPrismSessionBase)
  end;

implementation

{$IFNDEF FPC}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

end.
