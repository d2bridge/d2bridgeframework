program DownloadFile;

{$APPTYPE CONSOLE}



uses
  Vcl.Forms,
  D2Bridge.ServerControllerBase in '.\..\D2Bridge\D2Bridge Framework\D2Bridge.ServerControllerBase.pas' {D2BridgeServerControllerBase: TDataModule},
  Prism.SessionBase in '.\..\D2Bridge Framework\Prism\Prism.SessionBase.pas' {PrismSessionBase: TPrismSessionBase},
  ServerController in 'ServerController.pas',
  DownloadFile_Session in 'DownloadFile_Session.pas',
  D2BridgeFormTemplate in 'D2BridgeFormTemplate.pas',
  Unit_D2Bridge_Server_Console in 'Unit_D2Bridge_Server_Console.pas',
  D2Bridge.Lang.APP.Core in 'D2Bridge.Lang.APP.Core.pas',
  D2Bridge.Lang.APP.Term in 'D2Bridge.Lang.APP.Term.pas',
  D2Bridge.Lang.APP.English in 'D2Bridge.Lang.APP.English.pas',
  D2Bridge.Lang.APP.Portuguese in 'D2Bridge.Lang.APP.Portuguese.pas',
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar:= False;
  TD2BridgeServerConsole.Run
  
end.
