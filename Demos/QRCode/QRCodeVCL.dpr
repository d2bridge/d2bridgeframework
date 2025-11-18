program QRCodeVCL;



uses
  Vcl.Forms,
  D2Bridge.Instance,
  ServerController in 'ServerController.pas',
  QRCode_Session in 'QRCode_Session.pas',  
  
  
  Unit1 in 'Unit1.pas' {Form1};

var
 Form1: TForm;

{$R *.res}



begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar:= True;
  
  Application.CreateForm(TForm1, Form1);
  D2BridgeInstance.AddInstace(Form1);
  Application.Run;
end.
