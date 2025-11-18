program TemplateW32;

uses
  Vcl.Forms,
  D2Bridge.Instance,
  Unit_Login in 'Unit_Login.pas' {Form_Login},
  Unit_Menu in 'Unit_Menu.pas' {Form_Menu},
  Unit_Cadastro_Cliente in 'Unit_Cadastro_Cliente.pas' {Form_Cadastro_Cliente},
  D2BridgeFormTemplate in '..\..\src\D2BridgeFormTemplate.pas',
  Unit_Dashboard in '..\TemplateD2Bridge\Unit_Dashboard.pas' {Form_Dashboard},
  ServerController in '..\TemplateD2Bridge\ServerController.pas',
  UserSessionUnit in '..\TemplateD2Bridge\UserSessionUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TForm_Login.CreateInstance;
  Form_Login.ShowModal;
  Application.Run;
end.
