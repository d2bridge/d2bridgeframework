unit CardGridDataModel_Session;

interface

uses
  System.SysUtils, System.Classes,
  Prism.SessionBase;

type
  TCardGridDataModelSession = class(TPrismSessionBase)
  private

  public
   constructor Create(APrismSession: TPrismSession); override;  //OnNewSession
   destructor Destroy; override; //OnCloseSession
  end;


implementation

Uses
  D2Bridge.Instance,
  CardGridDataModelWebApp;

{$R *.dfm}

constructor TCardGridDataModelSession.Create(APrismSession: TPrismSession); //OnNewSession
begin
 inherited;

 //Your code

end;

destructor TCardGridDataModelSession.Destroy; //OnCloseSession
begin
 //Close ALL DataBase connection
 //Ex: Dm.DBConnection.Close;

 inherited;
end;

end.

