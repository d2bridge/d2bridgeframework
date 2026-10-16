unit TemplateParser_Session;

interface

uses
  SysUtils, Classes,
  Prism.SessionBase;

type
  TTemplateParserSession = class(TPrismSessionBase)
  private

  public
   FValueTest: string;

   constructor Create(APrismSession: TPrismSession); override;  //OnNewSession
   destructor Destroy; override; //OnCloseSession
  end;


implementation

Uses
  D2Bridge.Instance,
  TemplateParserWebApp;

{$IFNDEF FPC}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF} 

constructor TTemplateParserSession.Create(APrismSession: TPrismSession); //OnNewSession
begin
 inherited;

 //Your code
 FValueTest:= '';
end;

destructor TTemplateParserSession.Destroy; //OnCloseSession
begin
 //Close ALL DataBase connection
 //Ex: Dm.DBConnection.Close;

 inherited;
end;

end.

