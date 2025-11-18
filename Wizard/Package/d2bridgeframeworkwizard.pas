{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit d2bridgeframeworkwizard;

{$warn 5023 off : no warning about unused units}
interface

uses
  D2Bridge.NewProject.Wizard.FPC, D2Bridge.NewForm.Wizard.FPC, 
  D2Bridge.NewDataModule.Wizard.FPC, D2Bridge.NewInheritedForm.Wizard.FPC, 
  D2Bridge.NewCrud.Wizard.FPC, D2Bridge.NewForm.Wizard.Commom, 
  D2Bridge.ConfigNewCRUD.View, D2Bridge.ConfigNewInheritedForm.View, 
  D2Bridge.ConfigNewProject.View, D2Bridge.NewProject.Wizard.Common, 
  D2Bridge.BuildEvents, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('D2Bridge.NewProject.Wizard.FPC', 
    @D2Bridge.NewProject.Wizard.FPC.Register);
  RegisterUnit('D2Bridge.NewForm.Wizard.FPC', 
    @D2Bridge.NewForm.Wizard.FPC.Register);
  RegisterUnit('D2Bridge.NewDataModule.Wizard.FPC', 
    @D2Bridge.NewDataModule.Wizard.FPC.Register);
  RegisterUnit('D2Bridge.NewInheritedForm.Wizard.FPC', 
    @D2Bridge.NewInheritedForm.Wizard.FPC.Register);
  RegisterUnit('D2Bridge.NewCrud.Wizard.FPC', 
    @D2Bridge.NewCrud.Wizard.FPC.Register);
  RegisterUnit('D2Bridge.BuildEvents',
    @D2Bridge.BuildEvents.Register);
end;

initialization
  RegisterPackage('d2bridgeframeworkwizard', @Register);
end.
