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

unit D2Bridge.NewCrud.Wizard.FPC;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, ProjectIntf, Dialogs, LazIDEIntf, DateUtils, System.UITypes, Forms,
  D2Bridge.Wizard.Util, D2Bridge.Wizard.Types,
  D2Bridge.ConfigNewCrud.View;

type

 { TD2BridgeNewCrudWizard }

 TD2BridgeNewCrudWizard = class (TProjectFileDescriptor)
 private
  FNewCrud: TD2BridgeConfigNewCrudForm;
 protected
  function Init(var NewFilename: string; NewOwner: TObject; var NewSource: string; Quiet: boolean): TModalResult; override;
  function Initialized({%H-}NewFile: TLazProjectFile): TModalResult; override;
 public
  FCRUDUnitName: string;
  FCRUDFORMNAME: string;
  constructor Create; override;
  destructor Destroy; override;
  function CreateSource(const Filename     : string;
                        const SourceName   : string;
                        const ResourceName : string): string; override;
  function GetResourceSource(const ResourceName: string): string; override;
  function GetLocalizedName: string; override;
  function GetLocalizedDescription: string; override;
end;


procedure Register;

implementation

{ TD2BridgeNewCrudWizard }

constructor TD2BridgeNewCrudWizard.Create;
begin
 inherited Create;
 DefaultFilename:= 'Unit1';
 DefaultSourceName:= 'Unit1';
 DefaultFileExt:= '.pas';
 UseCreateFormStatements:= True;
 IsPascalUnit:= True;
 Name := 'D2BridgeWizardNewCrud'; //CFileDescritor
 FNewCrud:= TD2BridgeConfigNewCrudForm.Create(nil);
end;

destructor TD2BridgeNewCrudWizard.Destroy;
begin
 FNewCrud.Free;

 inherited Destroy;
end;

function TD2BridgeNewCrudWizard.Init(var NewFilename: string;
  NewOwner: TObject; var NewSource: string; Quiet: boolean): TModalResult;
var
 vPathWizard: string;
begin
 vPathWizard:= ExtractFileDir(ExcludeTrailingPathDelimiter(D2BridgeFrameworkPath)) + PathDelim + 'Wizard';

 if (vPathWizard = '') or (not DirectoryExists(vPathWizard)) then
 begin
  result:= mrAbort;
  MessageDlg('Path of D2Bridge Framework is not been configured', mterror, [mbok], 0);
  exit;
 end;

 FNewCrud.ShowModal;

 if not FNewCrud.EnableCreateCRUD then
 begin
  result:= mrAbort;
  exit;
 end;

 Result:=inherited Init(NewFilename, NewOwner, NewSource, Quiet);
 ResourceClass:= TForm;
end;

function TD2BridgeNewCrudWizard.Initialized(NewFile: TLazProjectFile
  ): TModalResult;
begin
  if Assigned(NewFile) then
   NewFile.Unit_Name:= FCRUDUnitName;

  Result:=inherited Initialized(NewFile);
end;

function TD2BridgeNewCrudWizard.CreateSource(const Filename: string;
 const SourceName: string; const ResourceName: string): string;
var
 vPathNewCrudPAS: string;
 vPathWizard: string;
 sNewCrudPASContent: string;
 vNewCrudPASFile: TStringStream;
 //vFileUnitName: string;
begin
 vPathWizard:= ExtractFileDir(ExcludeTrailingPathDelimiter(D2BridgeFrameworkPath)) + PathDelim + 'Wizard';

 vPathNewCrudPas:= vPathWizard + PathDelim + 'CRUD' + PathDelim + 'LAZARUS'  + PathDelim + 'Unit_CrudTemplate.pas';

 FCRUDFORMNAME:= Copy(FNewCrud.Edit_ClassName.Text,2);
 FCRUDUnitName:= 'Unit_' + FCRUDFORMNAME;
 //vFileUnitName:= FCRUDUnitName + '.pas';

 //DefaultFilename:= vFileUnitName;
 //DefaultSourceName:= vCRUDUnitName;
 //DefaultResourceName:= vCRUDUnitName;

 vNewCrudPASFile:= TStringStream.Create('', TEncoding.UTF8);
 vNewCrudPASFile.LoadFromFile(GetRealFilePath(vPathNewCrudPas));
 sNewCrudPASContent:= vNewCrudPASFile.DataString;

 if FNewCrud.ComboBox_InheritedForms.Text <> '' then
 begin
  sNewCrudPASContent := StringReplace(sNewCrudPASContent, 'class(TD2BridgeForm)', 'class('+ FNewCrud.FClassInherited +')', [rfIgnoreCase, rfReplaceAll]);
  sNewCrudPASContent := StringReplace(sNewCrudPASContent, '{ INHERITED, }', ' ' + FNewCrud.FUnitInherited + ', ', [rfIgnoreCase, rfReplaceAll]);
 end else
  sNewCrudPASContent := StringReplace(sNewCrudPASContent, '{ INHERITED, }', '', [rfIgnoreCase, rfReplaceAll]);
 sNewCrudPASContent := StringReplace(sNewCrudPASContent, 'Unit_CrudTemplate', FCRUDUnitName, [rfIgnoreCase, rfReplaceAll]);
 sNewCrudPASContent := StringReplace(sNewCrudPASContent, 'FormCrudTemplate.', FCRUDFORMNAME + '.', [rfIgnoreCase, rfReplaceAll]);
 sNewCrudPASContent := StringReplace(sNewCrudPASContent, 'Form_CrudTemplate', FCRUDFORMNAME, [rfIgnoreCase, rfReplaceAll]);

 result:= sNewCrudPASContent;

 vNewCrudPASFile.free;
end;

function TD2BridgeNewCrudWizard.GetResourceSource(const ResourceName: string
  ): string;
var
 vPathNewCrudLFM: string;
 vPathWizard: string;
 sNewCrudLFMContent: string;
 vNewCrudLFMFile: TStringStream;
 vCRUDFORMNAME: string;
 vFileFormName: string;
begin
 vPathWizard:= ExtractFileDir(ExcludeTrailingPathDelimiter(D2BridgeFrameworkPath)) + PathDelim + 'Wizard';

 vPathNewCrudLFM:= vPathWizard + PathDelim + 'CRUD' + PathDelim + 'LAZARUS'  + PathDelim + 'Unit_CrudTemplate.lfm';

 vCRUDFORMNAME:= Copy(FNewCrud.Edit_ClassName.Text,2);
 vFileFormName:= 'Unit_' + vCRUDFORMNAME + '.lfm';

 vNewCrudLFMFile:= TStringStream.Create('', TEncoding.UTF8);
 vNewCrudLFMFile.LoadFromFile(GetRealFilePath(vPathNewCrudLFM));
 sNewCrudLFMContent:= vNewCrudLFMFile.DataString;

 if FNewCrud.ComboBox_InheritedForms.Text <> '' then
 begin
  sNewCrudLFMContent := StringReplace(sNewCrudLFMContent, 'object Form_CrudTemplate', 'inherited Form_CrudTemplate', [rfIgnoreCase, rfReplaceAll]);
 end;
 sNewCrudLFMContent := StringReplace(sNewCrudLFMContent, 'Form_CrudTemplate', vCRUDFORMNAME, [rfIgnoreCase, rfReplaceAll]);

 result:= sNewCrudLFMContent;

 vNewCrudLFMFile.free;
end;

function TD2BridgeNewCrudWizard.GetLocalizedName: string;
begin
 Result := 'D2Bridge Framework CRUD Model';
end;

function TD2BridgeNewCrudWizard.GetLocalizedDescription: string;
begin
 Result:= 'D2Bridge CRUD is designed to easy development between LCL and Database. '+
          'This CRUD is based in event Add, Delete, Close, etc, not in component. Event is more applicate to use with CRUD';
end;

procedure Register;
begin
 RegisterProjectFileDescriptor(TD2BridgeNewCrudWizard.Create);
end;

end.

