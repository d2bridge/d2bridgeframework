program TemplateD2Bridge;

uses
  Vcl.Forms,
  MidasLib,
  Unit_Server_D2Bridge in 'Unit_Server_D2Bridge.pas' {Form_Servidor_D2Bridge},
  ServerController in 'ServerController.pas',
  UserSessionUnit in 'UserSessionUnit.pas',
  Unit_Cadastro_Cliente in '..\TemplateW32\Unit_Cadastro_Cliente.pas' {Form_Cadastro_Cliente},
  Unit_Login in '..\TemplateW32\Unit_Login.pas' {Form_Login},
  Unit_Menu in '..\TemplateW32\Unit_Menu.pas' {Form_Menu},
  Unit_Dashboard in 'Unit_Dashboard.pas' {Form_Dashboard},
  D2BridgeFormTemplate in '..\..\src\D2BridgeFormTemplate.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm_Servidor_D2Bridge, Form_Servidor_D2Bridge);
  Application.Run;
end.
