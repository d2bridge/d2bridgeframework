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

unit D2Bridge.NewRestAPIAuthUnit.Wizard;

interface

uses
  ToolsAPI,
  D2Bridge.NewForm, D2Bridge.Wizard.Util, System.SysUtils;

type
 TD2BridgeNewRestAPIAuthUnitWizard = class(TNotifierObject, IOTAWizard, IOTAProjectWizard, IOTAFormWizard, IOTARepositoryWizard)
  protected
    function GetIDString: string;
    function GetName: string;
    function GetState: TWizardState;

    procedure Execute;

    function GetAuthor: string;
    function GetComment: string;
    function GetPage: string;

    function GetGlyph: {$IF CompilerVersion < 37.0}Cardinal{$ELSE}THandle{$ENDIF};

    function IsVisible(Project: IOTAProject): Boolean;
  public
    class function New: IOTAWizard;
 end;

 TD2BridgeFormFileCreator = class(TModuleCreatorFile)
 public
   function GetSource: string; override;
 end;

 TD2BridgeNewFormModule = class(TFormCreatorModule)
 private
   FUnitName: string;
   FModuleIdent: string;
   FFormIdent: string;
   FAncestorIdent: string;
 public
   function GetCreatorType: string; override;
   function GetImplFileName: string; override;
   function GetAncestorName: string; override;
   function GetImplFile: TModuleCreatorFileClass; override;
   function NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile; override;
   constructor Create(ModuleIdent, FormIdent, AncestorIdent: string);
 end;


implementation

uses
  Winapi.Windows, System.DateUtils, Vcl.Dialogs, D2Bridge.ConfigNewUnit.View,
  Vcl.Forms, System.Classes;

{ TD2BridgeNewRestAPIAuthUnitWizard }

var
  DelphiCategory: IOTAGalleryCategory;


procedure TD2BridgeNewRestAPIAuthUnitWizard.Execute;
var
  WizardNewUnitForm: TD2BridgeConfigNewUnitForm;
  vUnitName, vClassName: string;
begin
 WizardNewUnitForm := TD2BridgeConfigNewUnitForm.Create(Application);
 try
  WizardNewUnitForm.Label_ClassType.Caption:= 'D2Bridge Rest API Authentication';
  WizardNewUnitForm.Edit_ClassName.Text:= 'TAPIAuth';
  WizardNewUnitForm.ShowModal;

  if WizardNewUnitForm.EnableCreateNewUnit then
  begin
   inherited;
    vClassName:= WizardNewUnitForm.Edit_ClassName.Text;
    if vClassName.StartsWith('T') then
     vClassName:= Copy(vClassName, 2);
    vUnitName:= vClassName;

    (BorlandIDEServices as IOTAModuleServices).CreateModule(TD2BridgeNewFormModule.Create
     (
      vUnitName,
      vClassName,
      ''
     ));
  end;
 finally
  WizardNewUnitForm.Close;

  FreeAndNil(WizardNewUnitForm);
 end;
end;

function TD2BridgeNewRestAPIAuthUnitWizard.GetAuthor: string;
begin
  Result := 'D2Bridge Framework by Talis Jonatas Gomes';
end;

function TD2BridgeNewRestAPIAuthUnitWizard.GetComment: string;
begin
 Result := 'Create a D2Bridge Rest API Authentication';
end;

function TD2BridgeNewRestAPIAuthUnitWizard.GetGlyph: {$IF CompilerVersion < 37.0}Cardinal{$ELSE}THandle{$ENDIF};
begin
  Result := LoadIcon(hInstance, 'RESTAPI');
end;

function TD2BridgeNewRestAPIAuthUnitWizard.GetIDString: string;
begin
 Result := 'D2Bridge.Unit.API.3';
end;

function TD2BridgeNewRestAPIAuthUnitWizard.GetName: string;
begin
  Result := 'D2Bridge REST API Autentication';
end;

function TD2BridgeNewRestAPIAuthUnitWizard.GetPage: string;
begin
 Result := 'D2Bridge Framework';
end;

function TD2BridgeNewRestAPIAuthUnitWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

function TD2BridgeNewRestAPIAuthUnitWizard.IsVisible(Project: IOTAProject): Boolean;
begin
 result:= false;
end;

class function TD2BridgeNewRestAPIAuthUnitWizard.New: IOTAWizard;
begin
  Result := Self.Create;
end;

{ TD2BridgeNewFormModule }

constructor TD2BridgeNewFormModule.Create(ModuleIdent, FormIdent, AncestorIdent: string);
begin
 FUnitName:= ModuleIdent+'.pas';
 FModuleIdent:= ModuleIdent;
 FFormIdent:= FormIdent;
 FAncestorIdent:= AncestorIdent;

 inherited Create;
end;

function TD2BridgeNewFormModule.GetAncestorName: string;
begin
 Result:= '';
end;

function TD2BridgeNewFormModule.GetCreatorType: string;
begin
 result:= sUnit;
end;

function TD2BridgeNewFormModule.GetImplFile: TModuleCreatorFileClass;
begin
  Result := TD2BridgeFormFileCreator;
end;

function TD2BridgeNewFormModule.GetImplFileName: string;
begin
 result:= ExtractFilePath(GetCurrentProject.FileName)+FUnitName;
end;

function TD2BridgeNewFormModule.NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
begin
 Result := nil;
 if GetImplFile <> nil then
   Result := GetImplFile.Create(FModuleIdent, FFormIdent, FAncestorIdent, '');
end;

{ TD2BridgeFormFileCreator }

function TD2BridgeFormFileCreator.GetSource: string;
var
 vFileContent: string;
 sFile: TStringStream;
begin
  sFile:= TStringStream.Create('', TEncoding.UTF8);
  sFile.LoadFromFile(ExtractFileDir(ExcludeTrailingPathDelimiter(D2BridgeFrameworkPath))+ '\Wizard\FORMS\Wizard\RestAPIAuthClass.pas');
  vFileContent:= sFile.DataString;
  sFile.Free;

  Result:= vFileContent;
  Result := StringReplace(Result,'<COPYRIGHTYEAR>',IntToStr(YearOf(Now)) + ' / ' + IntToStr(YearOf(Now) + 1),[rfIgnoreCase]);
  Result := StringReplace(Result,'<ServerController>', GetUsesServerControllerName,[rfIgnoreCase]);
  Result := inherited GetSource;
end;

//initialization
//  DelphiCategory := AddDelphiCategory('D2Bridge Form', 'D2Bridge Framework');
//
//finalization
//  RemoveCategory(DelphiCategory);

end.
