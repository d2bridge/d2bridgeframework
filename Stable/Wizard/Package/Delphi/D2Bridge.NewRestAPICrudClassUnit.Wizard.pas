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

unit D2Bridge.NewRestAPICrudClassUnit.Wizard;

interface

uses
  ToolsAPI,
  D2Bridge.NewForm, D2Bridge.Wizard.Util, System.SysUtils;

type
 TD2BridgeNewRestAPICrudClassUnitWizard = class(TNotifierObject, IOTAWizard, IOTAProjectWizard, IOTAFormWizard, IOTARepositoryWizard)
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
 private
 public
   function GetSource: string; override;
 end;

 TD2BridgeNewFormModule = class(TFormCreatorModule)
 private
   FUnitName: string;
   FModuleIdent: string;
   FFormIdent: string;
   FAncestorIdent: string;
   FParameter: string;
 public
   function GetCreatorType: string; override;
   function GetImplFileName: string; override;
   function GetAncestorName: string; override;
   function GetParameter: string;
   function GetImplFile: TModuleCreatorFileClass; override;
   function NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile; override;
   constructor Create(ModuleIdent, FormIdent, AncestorIdent, AParameter: string);
 end;


implementation

uses
  Winapi.Windows, System.DateUtils, Vcl.Dialogs, D2Bridge.ConfigNewUnit.View,
  Vcl.Forms, System.Classes;

{ TD2BridgeNewRestAPICrudClassUnitWizard }

var
  DelphiCategory: IOTAGalleryCategory;


procedure TD2BridgeNewRestAPICrudClassUnitWizard.Execute;
var
  WizardNewUnitForm: TD2BridgeConfigNewUnitForm;
  vUnitName, vClassName: string;
  vModule: IOTAModule;
begin
 WizardNewUnitForm := TD2BridgeConfigNewUnitForm.Create(Application);
 try
  WizardNewUnitForm.Label_ClassType.Caption:= 'D2Bridge Rest API Crud';
  WizardNewUnitForm.Label3.Caption:= 'Table Name:';
  WizardNewUnitForm.Edit_ClassName.Text:= 'MyTable';
  //WizardNewUnitForm.Edit_TableName.Visible:= true;
  //WizardNewUnitForm.Edit_TableName.Text:= 'MyTable';
  WizardNewUnitForm.ShowModal;

  if WizardNewUnitForm.EnableCreateNewUnit then
  begin
   inherited;
    vClassName:= 'ApiCrud' + WizardNewUnitForm.Edit_ClassName.Text;
    if vClassName.StartsWith('T') then
     vClassName:= Copy(vClassName, 2);
    vUnitName:= vClassName;

    vModule:= (BorlandIDEServices as IOTAModuleServices).CreateModule(TD2BridgeNewFormModule.Create
     (
      vUnitName,
      vClassName,
      '',
      Trim(WizardNewUnitForm.Edit_ClassName.Text)
     ));
  end;
 finally
  WizardNewUnitForm.Close;

  FreeAndNil(WizardNewUnitForm);
 end;
end;

function TD2BridgeNewRestAPICrudClassUnitWizard.GetAuthor: string;
begin
  Result := 'D2Bridge Framework by Talis Jonatas Gomes';
end;

function TD2BridgeNewRestAPICrudClassUnitWizard.GetComment: string;
begin
 Result := 'Create a new D2Bridge Rest API Crud Unit';
end;

function TD2BridgeNewRestAPICrudClassUnitWizard.GetGlyph: {$IF CompilerVersion < 37.0}Cardinal{$ELSE}THandle{$ENDIF};
begin
  Result := LoadIcon(hInstance, 'RESTAPI');
end;

function TD2BridgeNewRestAPICrudClassUnitWizard.GetIDString: string;
begin
 Result := 'D2Bridge.Unit.API.4';
end;

function TD2BridgeNewRestAPICrudClassUnitWizard.GetName: string;
begin
  Result := 'D2Bridge REST API Crud Unit';
end;

function TD2BridgeNewRestAPICrudClassUnitWizard.GetPage: string;
begin
 Result := 'D2Bridge Framework';
end;

function TD2BridgeNewRestAPICrudClassUnitWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

function TD2BridgeNewRestAPICrudClassUnitWizard.IsVisible(Project: IOTAProject): Boolean;
begin
 result:= false;
end;

class function TD2BridgeNewRestAPICrudClassUnitWizard.New: IOTAWizard;
begin
  Result := Self.Create;
end;

{ TD2BridgeNewFormModule }

constructor TD2BridgeNewFormModule.Create(ModuleIdent, FormIdent, AncestorIdent, AParameter: string);
begin
 FUnitName:= ModuleIdent+'.pas';
 FModuleIdent:= ModuleIdent;
 FFormIdent:= FormIdent;
 FAncestorIdent:= AncestorIdent;
 FParameter:= AParameter;

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

function TD2BridgeNewFormModule.GetParameter: string;
begin
 result:= FParameter;
end;

function TD2BridgeNewFormModule.NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
begin
 Result := nil;
 if GetImplFile <> nil then
 begin
   Result := GetImplFile.Create(FModuleIdent, FFormIdent, FAncestorIdent, FParameter);
   TModuleCreatorFile(Result).D2BridgeWizardFormCreator:= self;
 end;
end;

{ TD2BridgeFormFileCreator }

function TD2BridgeFormFileCreator.GetSource: string;
var
 vFileContent: string;
 sFile: TStringStream;
begin
  sFile:= TStringStream.Create('', TEncoding.UTF8);
  sFile.LoadFromFile(ExtractFileDir(ExcludeTrailingPathDelimiter(D2BridgeFrameworkPath))+ '\Wizard\FORMS\Wizard\RestAPICrudUnit.pas');
  vFileContent:= sFile.DataString;
  sFile.Free;

  Result:= vFileContent;
  Result := StringReplace(Result,'<COPYRIGHTYEAR>',IntToStr(YearOf(Now)) + ' / ' + IntToStr(YearOf(Now) + 1),[rfIgnoreCase]);
  Result := StringReplace(Result,'<ServerController>', GetUsesServerControllerName,[rfIgnoreCase]);

  Result := StringReplace(Result, '<TABLENAME>', GetParameter, [rfIgnoreCase, rfReplaceAll]);
  Result := StringReplace(Result, '<TABLENAMELOWER>', LowerCase(GetParameter), [rfIgnoreCase, rfReplaceAll]);

  Result := inherited GetSource;
end;

//initialization
//  DelphiCategory := AddDelphiCategory('D2Bridge Form', 'D2Bridge Framework');
//
//finalization
//  RemoveCategory(DelphiCategory);

end.
