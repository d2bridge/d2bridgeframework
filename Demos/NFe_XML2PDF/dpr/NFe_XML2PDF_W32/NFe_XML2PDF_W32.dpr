program NFe_XML2PDF_W32;

uses
  Vcl.Forms,
  D2Bridge.Instance,
  Unit_Principal in '..\..\src\Unit_Principal.pas' {Form_Principal},
  Unit_Download_NFE in '..\..\src\Unit_Download_NFE.pas' {Form_Download_NFe};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TForm_Principal.CreateInstance;
  Form_Principal.ShowModal;
  Application.Run;
end.
