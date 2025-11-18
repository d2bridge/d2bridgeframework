program DataTables;

//{$APPTYPE CONSOLE}

uses
  Vcl.Forms,
  ServerController in 'ServerController.pas' {D2BridgeServerController: TDataModule},
  UserSessionUnit in 'UserSessionUnit.pas' {PrismUserSession: TDataModule},
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
