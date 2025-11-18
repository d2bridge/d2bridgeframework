unit CookiesDemo_Session;

interface

uses
  System.SysUtils, System.Classes,
  Prism.SessionBase;

type
  TCookiesDemoSession = class(TPrismSessionBase)
  private

  public
   constructor Create(APrismSession: TPrismSession); override;  //OnNewSession
  end;


implementation

Uses
  D2Bridge.Instance,
  CookiesDemoWebApp;

{$R *.dfm}

constructor TCookiesDemoSession.Create(APrismSession: TPrismSession); //OnNewSession
begin
 inherited;

 //Your code

end;

end.

