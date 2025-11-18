program CardsVCL;



uses
  Vcl.Forms,
  D2Bridge.Instance,
  ServerController in 'ServerController.pas' {D2BridgeServerController: TDataModule},
  UserSessionUnit in 'UserSessionUnit.pas' {PrismUserSession: TDataModule},
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {Form2},
  Unit3 in 'Unit3.pas' {Form3},
  Unit4 in 'Unit4.pas' {Form4};

var
 Form1: TForm1;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar:= True;
  Application.CreateForm(TForm1, Form1);
  D2BridgeInstance.AddInstace(Form1);
  Application.Run;
end.
