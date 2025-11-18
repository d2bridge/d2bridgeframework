program NFe_XML2PDF_D2Bridge;

uses
  Vcl.Forms,
  Unit_D2Bridge_Server in '..\..\src\Unit_D2Bridge_Server.pas' {Form_D2Bridge_Sever},
  Unit_Download_NFE in '..\..\src\Unit_Download_NFE.pas' {Form_Download_NFe},
  Unit_Principal in '..\..\src\Unit_Principal.pas' {Form_Principal},
  ServerController in '..\..\src\ServerController.pas',
  UserSessionUnit in '..\..\src\UserSessionUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm_D2Bridge_Sever, Form_D2Bridge_Sever);
  Application.Run;
end.
