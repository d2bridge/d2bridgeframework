program InventarioTIPrism;

uses
  Vcl.Forms,
  Unit2 in 'Unit2.pas' {Form2},
  Unit_DM in '..\..\src\Unit_DM.pas' {DM: TDataModule},
  Unit_Equipamento in '..\..\src\Unit_Equipamento.pas' {Form_Equipamento},
  Unit_Equipamento_Busca in '..\..\src\Unit_Equipamento_Busca.pas' {Form_Equipamento_Busca},
  Unit_Equipamento_Licenca in '..\..\src\Unit_Equipamento_Licenca.pas' {Form_Equipamento_Licenca},
  Unit_Menu in '..\..\src\Unit_Menu.pas' {Form_Menu},
  Unit_Software in '..\..\src\Unit_Software.pas' {Form_Software},
  Unit_Software_Busca in '..\..\src\Unit_Software_Busca.pas' {Form_Software_Busca},
  Unit_Software_Licenca in '..\..\src\Unit_Software_Licenca.pas' {Form_Software_Licenca},
  UserSessionUnit in 'UserSessionUnit.pas',
  ServerController in 'ServerController.pas',
  Unit_Equipamento_e_Software in '..\..\src\Unit_Equipamento_e_Software.pas' {Form_Equipamento_e_Software};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
