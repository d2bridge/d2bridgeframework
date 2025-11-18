program InventarioTID2Bridge;

//{$APPTYPE CONSOLE}

uses
  Vcl.Forms,
  ServerController in 'ServerController.pas',
  UserSessionUnit in 'UserSessionUnit.pas',
  D2BridgeFormTemplate in 'D2BridgeFormTemplate.pas',
  Unit_D2Bridge_Server in 'Unit_D2Bridge_Server.pas',
  Unit_DashBoard in 'Unit_DashBoard.pas' {Form_Dashboard},
  Unit_DM in '..\..\src\Unit_DM.pas' {DM: TDataModule},
  Unit_Equipamento in '..\..\src\Unit_Equipamento.pas' {Form_Equipamento},
  Unit_Equipamento_Busca in '..\..\src\Unit_Equipamento_Busca.pas' {Form_Equipamento_Busca},
  Unit_Equipamento_e_Software in '..\..\src\Unit_Equipamento_e_Software.pas' {Form_Equipamento_e_Software},
  Unit_Equipamento_Licenca in '..\..\src\Unit_Equipamento_Licenca.pas' {Form_Equipamento_Licenca},
  Unit_Software in '..\..\src\Unit_Software.pas' {Form_Software},
  Unit_Software_Busca in '..\..\src\Unit_Software_Busca.pas' {Form_Software_Busca},
  Unit_Software_Licenca in '..\..\src\Unit_Software_Licenca.pas' {Form_Software_Licenca},
  Unit_Login in '..\..\src\Unit_Login.pas' {Form_Login};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar:= True;
  Application.CreateForm(TForm_D2Bridge_Server, Form_D2Bridge_Server);
  Application.Run;
end.
