unit DatawareFormat_Session;

interface

uses
  System.SysUtils, System.Classes,
  Prism.SessionBase;

type
  TDatawareFormatSession = class(TPrismSessionBase)
  private

  public
   constructor Create(APrismSession: TPrismSession); override;  //OnNewSession
  end;


implementation

Uses
  D2Bridge.Instance,
  DatawareFormatWebApp;

{$R *.dfm}

constructor TDatawareFormatSession.Create(APrismSession: TPrismSession); //OnNewSession
begin
 inherited;

 //Your code

end;

end.

