{
 +--------------------------------------------------------------------------+
  D2Bridge Framework Content

  Author: Talis Jonatas Gomes
  Email: talisjonatas@me.com

  Copyright (c) 2024 Talis Jonatas Gomes - talisjonatas@me.com
  Intellectual property of computer programs protected by international and
  brazilian (9.609/1998) laws.
  Software licensed under "opensource" license.

  Rules:
  Everone is permitted to copy and distribute verbatim copies of this license
  document, but changing it is not allowed.

  This source code is provided 'as-is', without any express or implied
  warranty. In no event will the author be held liable for any damages
  arising from the use of this code.

  However, it is granted that this code may be used for any purpose,
  including commercial applications, but it may not be modified,
  distributed, or sublicensed without express written authorization from
  the author (Talis Jonatas Gomes). This includes creating derivative works
  or distributing the source code through any means.

  If you use this software in a product, an acknowledgment in the product
  documentation would be appreciated but is not required.

  God bless you
 +--------------------------------------------------------------------------+
}

unit D2Bridge.Registration;

interface

uses
 ToolsApi,
 DesignIntf,
 DesignEditors,
 System.SysUtils,
 System.Classes,
 D2Bridge.NewProject.Wizard,
 D2Bridge.NewDataModule.Wizard,
 D2Bridge.NewForm.Wizard,
 D2Bridge.NewPrismFormUnit.Wizard,
 D2Bridge.NewRestAPIClassUnit.Wizard,
 D2Bridge.NewRestAPIUnit.Wizard,
 D2Bridge.NewRestAPIAuthUnit.Wizard,
 D2Bridge.NewRestAPICrudClassUnit.Wizard,
 D2Bridge.NewRestAPISession.Wizard,
 D2Bridge.NewInheritedForm.Wizard,
 D2Bridge.ConfigNewProject.View,
 D2Bridge.NewCRUD.Wizard,
 D2Bridge.Wizard.Information,
 D2Bridge.BuildEvents,
// Prism,
// D2Bridge.ServerControllerBase,
 Winapi.Windows;

//type
// TCustomDataModule = TCustomModule;

procedure Register;



implementation

procedure Register;
begin
  ForceDemandLoadState(dlDisable);


//  RegisterCustomModule(TPrism, TCustomDataModule);
//  RegisterCustomModule(TD2BridgeServerControllerBase, TCustomDataModule);

  RegisterPackageWizard(TD2BridgeNewProjectWizard.New);
  RegisterPackageWizard(TD2BridgeNewFormWizard.Create);
  RegisterPackageWizard(TD2BridgeNewDataModuleWizard.Create);
  RegisterPackageWizard(TD2BridgeNewInheritedFormWizard.Create);
  RegisterPackageWizard(TD2BridgeNewPrismFormUnitWizard.Create);
  RegisterPackageWizard(TD2BridgeNewRestAPIClassUnitWizard.Create);
  RegisterPackageWizard(TD2BridgeNewRestAPIAuthUnitWizard.Create);
  RegisterPackageWizard(TD2BridgeNewRestAPIUnitWizard.Create);
  RegisterPackageWizard(TD2BridgeNewRestAPICrudClassUnitWizard.Create);
  RegisterPackageWizard(TD2BridgeNewRestAPISessionWizard.Create);
  RegisterPackageWizard(TD2BridgeNewCRUDWizard.Create);

  RegisterGlobalBuildNotifier;

//  SplashScreenServices.AddPluginBitmap(
//    'Delphi Web with D2Bridge Framework',
//    LoadBitmap(HInstance, 'SPLASH'));

  //RegisterPackageWizard(TD2BridgeViewsNewProject);
//  RegisterNewControllerBinding;
end;



initialization

finalization
 UnregisterGlobalBuildNotifier;


end.


