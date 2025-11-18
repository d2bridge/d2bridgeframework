unit Lazarus_Session;

interface

uses
  SysUtils, Classes,
  Prism.SessionBase;

type
  TLazarusDemoSession = class(TPrismSessionBase)
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
  LazarusWebApp, UnitMenu;

{$IFNDEF FPC}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF} 

constructor TLazarusDemoSession.Create(APrismSession: TPrismSession); //OnNewSession
begin
 inherited;

 //Your code

end;

destructor TLazarusDemoSession.Destroy; //OnCloseSession
begin
 //Close ALL DataBase connection
 //Ex: Dm.DBConnection.Close;

 inherited;
end;

end.

