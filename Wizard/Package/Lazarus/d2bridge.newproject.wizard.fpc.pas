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

unit D2Bridge.NewProject.Wizard.FPC;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LazIDEIntf, ProjectIntf, Forms, System.UITypes,
  D2Bridge.ConfigNewProject.View, D2Bridge.NewProject.Wizard.Common;

type
  { TD2BridgeNewProjectDescriptor }
  TD2BridgeNewProjectDescriptor = class(TProjectDescriptor)
  private
    FProject: TLazProject;
    FNewProjectWizardCommon: TD2BridgeNewProjectWizardCommon;
    procedure ReopenProject(Data: PtrInt);
  public
    constructor Create; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
    function DoInitDescriptor: TModalResult; override;
    function InitProject(AProject: TLazProject): TModalResult; override;
  end;


procedure Register;

implementation

{ TD2BridgeNewProjectDescriptor }

procedure TD2BridgeNewProjectDescriptor.ReopenProject(Data: PtrInt);
begin
 if Assigned(FProject) then
 begin
  LazarusIDE.DoOpenProjectFile(FProject.ProjectInfoFile, [ofProjectLoading]);
 end;
end;

constructor TD2BridgeNewProjectDescriptor.Create;
begin
  inherited Create;
  Name := 'D2Bridge Framework Lazarus Web Project';
end;

function TD2BridgeNewProjectDescriptor.GetLocalizedName: string;
begin
  //Result:=inherited GetLocalizedName;
  Result := 'D2Bridge Framework Lazarus Web Project';
end;

function TD2BridgeNewProjectDescriptor.GetLocalizedDescription: string;
begin
  Result:=
    'Create a new D2Bridge Framework Lazarus Web Project' + #13#13 +
    'D2Bridge Framework is Lazarus Web' + #13 +
    'Your Lazarus/Delphi code compiling for the Web using the Lazarus way, synchronous on the Web. D2Bridge is Open Source';
end;

function TD2BridgeNewProjectDescriptor.DoInitDescriptor: TModalResult;
begin
  Result:=inherited DoInitDescriptor;

  FNewProjectWizardCommon:= TD2BridgeNewProjectWizardCommon.Create;
  FNewProjectWizardCommon.Execute;

  if FNewProjectWizardCommon.WizardForm.EnableCreateProject then
   Result:= mrOk
  else
  begin
   FreeAndNil(FNewProjectWizardCommon);
   Result:= mrAbort;
  end;
end;

function TD2BridgeNewProjectDescriptor.InitProject(AProject: TLazProject): TModalResult;
begin
 inherited InitProject(AProject);

 FProject:= AProject;

 try
  if FNewProjectWizardCommon.WizardForm.EnableCreateProject then
  begin
   AProject.ProjectInfoFile:= FNewProjectWizardCommon.PathPROJ;

   Result := mrOk;

   Application.QueueAsyncCall(@ReopenProject, {%H-}0);
  end else
  begin
   Result := mrAbort;
  end;
 finally
  FreeAndNil(FNewProjectWizardCommon);
 end;

  //// Chama o form para configurar o projeto
  //if D2BridgeConfigNewProject.EnableCreateProject then  // Chama o form e espera por "salvar" ou "cancelar"
  //begin
  //  // Aqui você define as propriedades do projeto, adicionar units, etc.
  //  //AProject.MainFileID := AProject.AddFile('Unit1.pas', True);
  //  //AProject.Session.FileList.Add(AProject.MainFileID);
  //  //AProject.AddFile('Unit1.pas', True);
  //  //AProject.MainFileID := AProject.FileCount - 1;
  //  Result := mrOk;  // Confirma a criação do projeto
  //end
  //else
  //  Result := mrCancel;  // Cancela a criação do projeto
  //
  //FreeAndNil(D2BridgeConfigNewProject);
end;

procedure Register;
begin
  // Registra o wizard para aparecer em "File -> New -> Project"
  RegisterProjectDescriptor(TD2BridgeNewProjectDescriptor.Create);
end;


end.

