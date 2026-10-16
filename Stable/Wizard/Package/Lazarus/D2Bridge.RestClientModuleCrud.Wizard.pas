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

unit D2Bridge.RestClientModuleCrud.Wizard;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ProjectIntf, Dialogs, LazIDEIntf, DateUtils, Forms,
  LazFileUtils, System.UITypes,
  D2Bridge.Wizard.Util,
  D2Bridge.ConfigNewUnit.View;

type

 { TD2BridgeNewRestCrudAPIUnitWizard }

 TD2BridgeNewRestCrudAPIUnitWizard = class (TProjectFileDescriptor)
 private
  FNewUnitForm: TD2BridgeConfigNewUnitForm;
  FClassName: string;
  FUnitName: string;
  FTable: string;
 protected
  function Init(var NewFilename: string; NewOwner: TObject; var NewSource: string; Quiet: boolean): TModalResult; override;
  function Initialized({%H-}NewFile: TLazProjectFile): TModalResult; override;
 public
  constructor Create; override;
  destructor Destroy; override;
  function CreateSource(const Filename     : string;
                        const SourceName   : string;
                        const ResourceName : string): string; override;
  function GetLocalizedName: string; override;
  function GetLocalizedDescription: string; override;
end;

procedure Register;

implementation

{ TD2BridgeNewRestCrudAPIUnitWizard }

constructor TD2BridgeNewRestCrudAPIUnitWizard.Create;
begin
 inherited Create;
 DefaultFilename:= 'CrudEndPoint.API';
 DefaultSourceName:= 'CrudEndPoint.API';
 DefaultFileExt:= '.pas';
 UseCreateFormStatements:= False;
 IsPascalUnit:= True;
 Name := 'D2BridgeWizardAPIClient5'; //CFileDescritor
 FNewUnitForm:= TD2BridgeConfigNewUnitForm.Create(nil);
end;

destructor TD2BridgeNewRestCrudAPIUnitWizard.Destroy;
begin
 FNewUnitForm.Free;

 inherited Destroy;
end;

function TD2BridgeNewRestCrudAPIUnitWizard.Init(var NewFilename: string;
  NewOwner: TObject; var NewSource: string; Quiet: boolean): TModalResult;
var
 vPathWizard: string;
begin
 vPathWizard:= ExtractFileDir(ExcludeTrailingPathDelimiter(D2BridgeFrameworkPath))+ PathDelim + 'Wizard';

 if (vPathWizard = '') or (not DirectoryExists(vPathWizard)) then
 begin
  result:= mrAbort;
  MessageDlg('Path of D2Bridge Framework is not been configured', mterror, [mbok], 0);
  exit;
 end;

 FNewUnitForm.Label_ClassType.Caption:= 'D2Bridge Rest API Client Module Crud';
 FNewUnitForm.Edit_ClassName.Text:= 'TMyEndPointsAPI';
 FNewUnitForm.Label3.Caption:= 'Class Name:';
 FNewUnitForm.EnableCreateNewUnit:= false;
 FNewUnitForm.Edit_TableName.Visible:= true;
 FNewUnitForm.Edit_TableName.Text:= 'MyTable';
 FNewUnitForm.ShowModal;

 if not FNewUnitForm.EnableCreateNewUnit then
 begin
  result:= mrAbort;
  exit;
 end;

 FTable:= Trim(FNewUnitForm.Edit_TableName.Text);

 //Fix ClassName and UnitName
 FClassName:= FNewUnitForm.Edit_ClassName.Text;
 if FClassName.StartsWith('T') then
  FClassName:= Copy(FClassName, 2, 99999999);
 FUnitName:= FClassName;

 Result:=inherited Init(NewFilename, NewOwner, NewSource, Quiet);
 //ResourceClass:= TForm;
end;

function TD2BridgeNewRestCrudAPIUnitWizard.Initialized(NewFile: TLazProjectFile): TModalResult;
begin
 Result:=inherited Initialized(NewFile);
end;

function TD2BridgeNewRestCrudAPIUnitWizard.CreateSource(const Filename: string;
 const SourceName: string; const ResourceName: string): string;
var
 vPathNewFormPAS: string;
 vPathWizard: string;
 sNewFormPASContent: string;
 vNewFormPASFile: TStringStream;
begin
 vPathWizard:= ExtractFileDir(ExcludeTrailingPathDelimiter(D2BridgeFrameworkPath)) + PathDelim + 'Wizard';

 vPathNewFormPas:=
  vPathWizard + PathDelim +
  'FORMS' + PathDelim +
  'Wizard'  + PathDelim +
  'Crud.API.Client.pas';

 vNewFormPASFile:= TStringStream.Create('', TEncoding.UTF8);
 vNewFormPASFile.LoadFromFile(GetRealFilePath(vPathNewFormPas));
 sNewFormPASContent:= vNewFormPASFile.DataString;

 sNewFormPASContent := StringReplace(sNewFormPASContent, '<DEFINITIONUNIT>', 'D2Bridge.Forms', [rfIgnoreCase]);
 sNewFormPASContent := StringReplace(sNewFormPASContent, '<COPYRIGHTYEAR>', IntToStr(YearOf(Now)) + ' / ' + IntToStr(YearOf(Now) + 1),[rfIgnoreCase]);
 sNewFormPASContent := StringReplace(sNewFormPASContent, '<ServerController>', GetUsesServerControllerName,[rfIgnoreCase]);

 sNewFormPASContent := StringReplace(sNewFormPASContent, '<UNITNAME>', SourceName, [rfIgnoreCase, rfReplaceAll]);
 sNewFormPASContent := StringReplace(sNewFormPASContent, '<CLASS_ID>', FClassName, [rfIgnoreCase, rfReplaceAll]);
 sNewFormPASContent := StringReplace(sNewFormPASContent, '<CLASSINHERITED>', 'TD2BridgeForm', [rfIgnoreCase, rfReplaceAll]);

 sNewFormPASContent := StringReplace(sNewFormPASContent, '<ApiClientModuleName>', FClassName, [rfIgnoreCase, rfReplaceAll]);

 sNewFormPASContent := StringReplace(sNewFormPASContent, '<TABLENAME>', FTable, [rfIgnoreCase, rfReplaceAll]);
 sNewFormPASContent := StringReplace(sNewFormPASContent, '<TABLENAMELOWER>', LowerCase(FTable), [rfIgnoreCase, rfReplaceAll]);

 result:= sNewFormPASContent;

   //Result := StringReplace(Result, '<ANCESTOR_ID>', FixAncestorClass,
   //  [rfReplaceAll, rfIgnoreCase]);

 //ShowMessage(result);

 vNewFormPASFile.free;
end;

function TD2BridgeNewRestCrudAPIUnitWizard.GetLocalizedName: string;
begin
 Result := 'D2Bridge REST API Module Client CRUD';
end;

function TD2BridgeNewRestCrudAPIUnitWizard.GetLocalizedDescription: string;
begin
 Result:= 'Create a new D2Bridge Rest API Module Client Crud from List All, Get, Post, Put and Delete for use with Root API';
end;

procedure Register;
begin
 RegisterProjectFileDescriptor(TD2BridgeNewRestCrudAPIUnitWizard.Create);
end;

end.

