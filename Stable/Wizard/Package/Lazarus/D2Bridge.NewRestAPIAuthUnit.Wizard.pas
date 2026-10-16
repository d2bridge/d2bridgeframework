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

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ProjectIntf, Dialogs, LazIDEIntf, DateUtils, Forms,
  LazFileUtils, System.UITypes,
  D2Bridge.Wizard.Util,
  D2Bridge.ConfigNewUnit.View;

type

 { TD2BridgeNewRestAPIAuthUnitWizard }

 TD2BridgeNewRestAPIAuthUnitWizard = class (TProjectFileDescriptor)
 private
  FNewUnitForm: TD2BridgeConfigNewUnitForm;
  FClassName: string;
  FUnitName: string;
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

{ TD2BridgeNewRestAPIAuthUnitWizard }

constructor TD2BridgeNewRestAPIAuthUnitWizard.Create;
begin
 inherited Create;
 DefaultFilename:= 'Unit1';
 DefaultSourceName:= 'Unit1';
 DefaultFileExt:= '.pas';
 UseCreateFormStatements:= false;
 IsPascalUnit:= True;
 Name := 'D2BridgeWizardAPINewUnit3'; //CFileDescritor
 FNewUnitForm:= TD2BridgeConfigNewUnitForm.Create(nil);
end;

destructor TD2BridgeNewRestAPIAuthUnitWizard.Destroy;
begin
 FNewUnitForm.Free;

 inherited Destroy;
end;

function TD2BridgeNewRestAPIAuthUnitWizard.Init(var NewFilename: string;
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

 FNewUnitForm.Label_ClassType.Caption:= 'D2Bridge Rest API Authentication';
 FNewUnitForm.Edit_ClassName.Text:= 'TAPIAuth';
 FNewUnitForm.EnableCreateNewUnit:= false;
 FNewUnitForm.ShowModal;

 if not FNewUnitForm.EnableCreateNewUnit then
 begin
  result:= mrAbort;
  exit;
 end;

 //Fix ClassName and UnitName
 FClassName:= FNewUnitForm.Edit_ClassName.Text;
 if FClassName.StartsWith('T') then
  FClassName:= Copy(FClassName, 2, 99999999);
 FUnitName:= FClassName;


 Result:=inherited Init(NewFilename, NewOwner, NewSource, Quiet);
 //ResourceClass:= TForm;
end;

function TD2BridgeNewRestAPIAuthUnitWizard.Initialized(NewFile: TLazProjectFile): TModalResult;
begin
 Result:=inherited Initialized(NewFile);
end;

function TD2BridgeNewRestAPIAuthUnitWizard.CreateSource(const Filename: string;
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
  'RestAPIAuth.Laz.pas';

 vNewFormPASFile:= TStringStream.Create('', TEncoding.UTF8);
 vNewFormPASFile.LoadFromFile(GetRealFilePath(vPathNewFormPas));
 sNewFormPASContent:= vNewFormPASFile.DataString;

 sNewFormPASContent := StringReplace(sNewFormPASContent, '<DEFINITIONUNIT>', 'D2Bridge.Forms', [rfIgnoreCase]);
 sNewFormPASContent := StringReplace(sNewFormPASContent, '<COPYRIGHTYEAR>', IntToStr(YearOf(Now)) + ' / ' + IntToStr(YearOf(Now) + 1),[rfIgnoreCase]);
 sNewFormPASContent := StringReplace(sNewFormPASContent, '<ServerController>', GetUsesServerControllerName,[rfIgnoreCase]);

 sNewFormPASContent := StringReplace(sNewFormPASContent, '<UNITNAME>', SourceName, [rfIgnoreCase, rfReplaceAll]);
 sNewFormPASContent := StringReplace(sNewFormPASContent, '<CLASS_ID>', FClassName, [rfIgnoreCase, rfReplaceAll]);
 sNewFormPASContent := StringReplace(sNewFormPASContent, '<CLASSINHERITED>', 'TD2BridgeForm', [rfIgnoreCase, rfReplaceAll]);

 result:= sNewFormPASContent;

   //Result := StringReplace(Result, '<ANCESTOR_ID>', FixAncestorClass,
   //  [rfReplaceAll, rfIgnoreCase]);

 vNewFormPASFile.free;
end;

function TD2BridgeNewRestAPIAuthUnitWizard.GetLocalizedName: string;
begin
 Result := 'D2Bridge REST API Autentication';
end;

function TD2BridgeNewRestAPIAuthUnitWizard.GetLocalizedDescription: string;
begin
 Result:= 'Create a D2Bridge Rest API Authentication with JWT native';
end;

procedure Register;
begin
 RegisterProjectFileDescriptor(TD2BridgeNewRestAPIAuthUnitWizard.Create);
end;

end.

