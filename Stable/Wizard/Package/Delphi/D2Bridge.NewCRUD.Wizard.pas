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

unit D2Bridge.NewCRUD.Wizard;

interface

uses
  System.Generics.Collections,  Winapi.Windows,ToolsAPI,  Vcl.Controls,DccStrs,
  System.IOUtils, VCL.Forms, ShellApi, vcl.Dialogs, IniFiles, System.Classes;

type
  TD2BridgeNewCRUDWizard = class(TNotifierObject, IOTAWizard, IOTAProjectWizard, IOTARepositoryWizard)
  private
    function CopyDir(const Source, Target: string): Boolean;
    function CopyFolderFiles(sourceFolder, targetFolder: string):LongInt;
  protected
    // IOTAWizard
    function  GetIDString : string;
    function  GetName     : string;
    function  GetState    : TWizardState;
    procedure Execute;

    // IOTARepositoryWizard
    function GetAuthor  : string;
    function GetComment : string;
    function GetPage    : string;
    function GetGlyph   : {$IF CompilerVersion < 37.0}Cardinal{$ELSE}THandle{$ENDIF};
  public
    constructor Create;

    class function New: IOTAWizard;
  end;

implementation

Uses
 D2Bridge.ConfigNewCRUD.View,
 D2Bridge.Wizard.Util, System.SysUtils;

{ TD2BridgeNewCRUDWizard }

function TD2BridgeNewCRUDWizard.CopyDir(const Source, Target: string): Boolean;
var
  SHFileOpStruct: TSHFileOpStruct;
begin
  ZeroMemory(@SHFileOpStruct, SizeOf(SHFileOpStruct));
  with SHFileOpStruct do
  begin
    wFunc  := FO_COPY;
    fFlags := FOF_FILESONLY;
    pFrom  := PChar(Source + #0);
    pTo    := PChar(Target)
  end;
  Result := (0 = ShFileOperation(SHFileOpStruct));
end;

function TD2BridgeNewCRUDWizard.CopyFolderFiles(sourceFolder, targetFolder: string): LongInt;
var
 F : TShFileOpStruct;
 sOrigen, sDestino : String;
begin
 Result := 0;
 sOrigen := sourceFolder + #0;
 sDestino := targetFolder + #0;

 with F do
 begin
  Wnd   := Application.Handle;
  wFunc := FO_COPY;
  pFrom := @sOrigen[1];
  pTo   := @sDestino[1];
  fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMATION
 end;

 Result := ShFileOperation(F);
end;

constructor TD2BridgeNewCRUDWizard.Create;
begin
 inherited;
end;

procedure TD2BridgeNewCRUDWizard.Execute;
var
 WizardForm: TD2BridgeConfigNewCrudForm;
 vFileFormName, vFileUnitName: string;
 vCRUDUnitName, vCRUDFormName: string;
 vCRUDUnitFile, vCRUDFormFile: string;
 vD2BridgeFrameworkPath, vCRUDPath, vDestinationPath: string;
 vFile: TStringStream;
 vFileContent: string;
 vModuleServices: IOTAModuleServices;
 vModule: IOTAModule;
begin
 vCRUDUnitFile:= 'Unit_CrudTemplate.pas';
 vCRUDFormFile:= 'Unit_CrudTemplate.dfm';

 if not IsVCLProject then
 begin
  Showmessage('D2Bridge CRUD is compatibility just VCL');
  Exit;
 end;

 if Not IsValidD2BridgeFrameworkPath then
 begin
  ShowMessage('D2Bridge Framework is not found'+#13+'Try reinstall this Wizard');
  Exit;
 end;

 WizardForm := TD2BridgeConfigNewCrudForm.Create(Application);
 try
  WizardForm.ShowModal;
  if WizardForm.EnableCreateCRUD then
  begin
   vCRUDFormName:= Copy(WizardForm.Edit_ClassName.Text,2);
   vCRUDUnitName:= 'Unit_' + vCRUDFormName;
   vFileUnitName:= 'Unit_'+Copy(WizardForm.Edit_ClassName.Text,2)+'.pas';
   vFileFormName:= 'Unit_'+Copy(WizardForm.Edit_ClassName.Text,2)+'.dfm';
   if ExistFileInCurrentProject(vFileFormName) then
   begin
    Showmessage('The file/class name already exists in this project');
    exit;
   end;

   vD2BridgeFrameworkPath:= TPath.GetDirectoryName(TPath.GetDirectoryName(D2BridgeFrameworkPath));
   vCRUDPath:= TPath.Combine(vD2BridgeFrameworkPath, 'Wizard');
   vCRUDPath:= IncludeTrailingPathDelimiter(TPath.Combine(vCRUDPath, 'Crud'));

   vDestinationPath:= WizardForm.Edit_ProjectDestination.Text;

   //----- CREATE CRUD DIRECTORY
   If not DirectoryExists(vDestinationPath) then
    MKdir(vDestinationPath);

   //CopyFile(PWideChar(vCRUDPath + vCRUDUnitFile), PWideChar(vDestinationPath + vFileUnitName), false);
   //CopyFile(PWideChar(vCRUDPath + vCRUDFormFile), PWideChar(vDestinationPath + vFileFormName), false);

   {$REGION 'Unit CRUD'}
   vFile:= TStringStream.Create('', TEncoding.ANSI);
   vFile.LoadFromFile(vCRUDPath + vCRUDUnitFile);
   vFileContent:= vFile.DataString;

   if WizardForm.ComboBox_InheritedForms.Text <> '' then
   begin
    vFileContent := StringReplace(vFileContent, 'class(TD2BridgeForm)', 'class('+ WizardForm.FClassInherited +')', [rfIgnoreCase, rfReplaceAll]);
    vFileContent := StringReplace(vFileContent, '{ INHERITED, }', ' ' + WizardForm.FUnitInherited + ', ', [rfIgnoreCase, rfReplaceAll]);
   end else
    vFileContent := StringReplace(vFileContent, '{ INHERITED, }', '', [rfIgnoreCase, rfReplaceAll]);
   vFileContent := StringReplace(vFileContent, 'Unit_CrudTemplate', vCRUDUnitName, [rfIgnoreCase, rfReplaceAll]);
   vFileContent := StringReplace(vFileContent, 'Form_CrudTemplate', vCRUDFORMNAME, [rfIgnoreCase, rfReplaceAll]);

   vFile.Clear;
   vFile.WriteString(vFileContent);
   vFile.SaveToFile(vDestinationPath + vFileUnitName);
   vFile.Free;
   {$ENDREGION}


   {$REGION 'Form CRUD'}
   vFile:= TStringStream.Create('', TEncoding.UTF8);
   vFile.LoadFromFile(vCRUDPath + vCRUDFormFile);
   vFileContent:= vFile.DataString;

   if WizardForm.ComboBox_InheritedForms.Text <> '' then
    vFileContent := StringReplace(vFileContent, 'object Form_CrudTemplate', 'inherited Form_CrudTemplate', [rfIgnoreCase, rfReplaceAll]);
   vFileContent := StringReplace(vFileContent, 'Form_CrudTemplate', vCRUDFORMNAME, [rfIgnoreCase, rfReplaceAll]);

   vFile.Clear;
   vFile.WriteString(vFileContent);
   vFile.SaveToFile(vDestinationPath + vFileFormName);
   vFile.Free;
   {$ENDREGION}


   //Add Unit
   GetCurrentProject.AddFile(vDestinationPath + vFileUnitName, true);

    vModuleServices := BorlandIDEServices as IOTAModuleServices;
   if Assigned(vModuleServices) then
   begin
    // Tenta abrir a unit no Delphi IDE
    vModule := vModuleServices.OpenModule(vDestinationPath + vFileUnitName);
    if not Assigned(vModule) then
    begin
      raise Exception.Create('Não foi possível abrir a unit: ' + vFileUnitName);
    end else
     vModule.Show;
   end;
  end;
 finally
  FreeAndNil(WizardForm);
 end;

end;

function TD2BridgeNewCRUDWizard.GetAuthor: string;
begin
  Result := 'D2Bridge Framework by Talis Jonatas Gomes';
end;

function TD2BridgeNewCRUDWizard.GetComment: string;
begin
  Result := 'Create a new FORM VCL to CRUD by EVENTs '+
   'The CRUD use events do View, Insert, Edit, Delete data. '+
   'Exists two tabs the first is DBGrid and next is to Dataware components';
end;

function TD2BridgeNewCRUDWizard.GetGlyph: {$IF CompilerVersion < 37.0}Cardinal{$ELSE}THandle{$ENDIF};
begin
  Result := LoadIcon(HInstance, 'D2BRIDGECRUD');
end;

function TD2BridgeNewCRUDWizard.GetIDString: string;
begin
  Result := 'D2Bridge.Form.CRUD';
end;

function TD2BridgeNewCRUDWizard.GetName: string;
begin
  Result := 'D2Bridge CRUD Model';
end;

function TD2BridgeNewCRUDWizard.GetPage: string;
begin
  Result := 'D2Bridge Framework';
end;

function TD2BridgeNewCRUDWizard.GetState: TWizardState;
begin
  if IsVCLProject then
   Result := [wsEnabled]
end;

class function TD2BridgeNewCRUDWizard.New: IOTAWizard;
begin
  Result := Self.Create;
end;

end.
