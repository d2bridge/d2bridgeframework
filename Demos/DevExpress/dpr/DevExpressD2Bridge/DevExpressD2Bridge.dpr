program DevExpressD2Bridge;

uses
  Vcl.Forms,
  Unit2 in '..\..\src\Unit2.pas' {Form2},
  ServerController in '..\..\src\ServerController.pas',
  UserSessionUnit in '..\..\src\UserSessionUnit.pas',
  Unit1 in '..\..\src\Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
