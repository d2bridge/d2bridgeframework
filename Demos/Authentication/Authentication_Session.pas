unit Authentication_Session;

interface

uses
  System.SysUtils, System.Classes,
  Prism.SessionBase;

type
  TAuthenticationSession = class(TPrismSessionBase)
  private

  public
   UserLoginMode: string;
   UserID: string;
   UserName: string;
   UserEmail: string;
   UserURLPicture: string;


   constructor Create(APrismSession: TPrismSession); override;  //OnNewSession
   destructor Destroy; override; //OnCloseSession
  end;


implementation

Uses
  D2Bridge.Instance,
  AuthenticationWebApp;

{$R *.dfm}

constructor TAuthenticationSession.Create(APrismSession: TPrismSession); //OnNewSession
begin
 inherited;

 //Your code

end;

destructor TAuthenticationSession.Destroy; //OnCloseSession
begin
 //Close ALL DataBase connection
 //Ex: Dm.DBConnection.Close;

 inherited;
end;

end.

