program MaskVCL;

uses
  Vcl.Forms,
  D2Bridge.Instance,
  
  Unit1 in 'Unit1.pas' {Form1};

var
 MainForm: TForm;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar:= True;
  
  Application.CreateForm(TForm1, MainForm);
  D2BridgeInstance.AddInstace(MainForm);
  Application.Run;
end.
