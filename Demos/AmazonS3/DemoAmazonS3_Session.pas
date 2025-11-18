unit DemoAmazonS3_Session;

interface

uses
  System.SysUtils, System.Classes,
  Prism.SessionBase;

type
  TDemoAmazonS3Session = class(TPrismSessionBase)
  private

  public
   constructor Create(APrismSession: TPrismSession); override;  //OnNewSession
   destructor Destroy; override; //OnCloseSession
  end;


implementation

Uses
  D2Bridge.Instance,
  DemoAmazonS3WebApp;

{$R *.dfm}

constructor TDemoAmazonS3Session.Create(APrismSession: TPrismSession); //OnNewSession
begin
 inherited;

 //Your code

end;

destructor TDemoAmazonS3Session.Destroy; //OnCloseSession
begin
 //Close ALL DataBase connection
 //Ex: Dm.DBConnection.Close;

 inherited;
end;

end.

