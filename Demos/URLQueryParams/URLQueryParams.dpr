program URLQueryParams;

//{$APPTYPE CONSOLE}

uses
  Vcl.Forms,
  D2Bridge.ServerControllerBase in '..\..\D2Bridge Framework\D2Bridge.ServerControllerBase.pas' {D2BridgeServerControllerBase: TDataModule},
  Prism.SessionBase in '..\..\D2Bridge Framework\Prism\Prism.SessionBase.pas' {PrismSessionBase: TPrismSessionBase},
  ServerController in 'ServerController.pas',
  UserSessionUnit in 'UserSessionUnit.pas',
  D2BridgeFormTemplate in 'D2BridgeFormTemplate.pas',
  Unit_D2Bridge_Server in 'Unit_D2Bridge_Server.pas',
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar:= True;
  Application.CreateForm(TForm_D2Bridge_Server, Form_D2Bridge_Server);
  Application.Run;
end.
