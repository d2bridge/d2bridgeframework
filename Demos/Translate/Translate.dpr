program Translate;

//{$APPTYPE CONSOLE}



uses
  Vcl.Forms,
  D2Bridge.ServerControllerBase in '..\..\D2Bridge Framework\D2Bridge.ServerControllerBase.pas' {D2BridgeServerControllerBase: TDataModule},
  Prism.SessionBase in '..\..\D2Bridge Framework\Prism\Prism.SessionBase.pas' {PrismSessionBase: TPrismSessionBase},
  ServerController in 'ServerController.pas',
  UserSessionUnit in 'UserSessionUnit.pas',
  D2BridgeFormTemplate in 'D2BridgeFormTemplate.pas',
  Unit_D2Bridge_Server in 'Unit_D2Bridge_Server.pas',
  D2Bridge.Lang.APP.Core in 'D2Bridge.Lang.APP.Core.pas',
  D2Bridge.Lang.APP.Term in 'D2Bridge.Lang.APP.Term.pas',
  D2Bridge.Lang.APP.English in 'D2Bridge.Lang.APP.English.pas',
  D2Bridge.Lang.APP.Portuguese in 'D2Bridge.Lang.APP.Portuguese.pas',
  D2Bridge.Lang.APP.Spanish in 'D2Bridge.Lang.APP.Spanish.pas',
  D2Bridge.Lang.APP.Italian in 'D2Bridge.Lang.APP.Italian.pas',
  D2Bridge.Lang.APP.German in 'D2Bridge.Lang.APP.German.pas',
  D2Bridge.Lang.APP.French in 'D2Bridge.Lang.APP.French.pas',
  D2Bridge.Lang.APP.Russian in 'D2Bridge.Lang.APP.Russian.pas',
  D2Bridge.Lang.APP.Arabic in 'D2Bridge.Lang.APP.Arabic.pas',
  D2Bridge.Lang.APP.Japanese in 'D2Bridge.Lang.APP.Japanese.pas',
  D2Bridge.Lang.APP.Chinese in 'D2Bridge.Lang.APP.Chinese.pas',
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar:= True;
  Application.CreateForm(TForm_D2Bridge_Server, Form_D2Bridge_Server);
  Application.Run;
end.
