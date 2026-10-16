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

unit D2Bridge.NewInheritedForm.Wizard.FPC;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, ProjectIntf, Dialogs, LazIDEIntf, DateUtils, System.UITypes, Forms,
  D2Bridge.Wizard.Util, D2Bridge.Wizard.Types,
  D2Bridge.ConfigNewInheritedForm.View;

type

 { TD2BridgeNewInheritedFormWizard }

 TD2BridgeNewInheritedFormWizard = class (TProjectFileDescriptor)
 private
  FNewInheritedForm: TD2BridgeConfigNewInheritedForm;
 protected
  function Init(var NewFilename: string; NewOwner: TObject; var NewSource: string; Quiet: boolean): TModalResult; override;
  function Initialized(NewFile: TLazProjectFile): TModalResult; override;
 public
  FFormName: string;
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

{ TD2BridgeNewInheritedFormWizard }

constructor TD2BridgeNewInheritedFormWizard.Create;
begin
 inherited Create;
 DefaultFilename:= 'Unit1';
 DefaultSourceName:= 'Unit1';
 DefaultFileExt:= '.pas';
 UseCreateFormStatements:= True;
 IsPascalUnit:= True;
 Name := 'D2BridgeWizardNewInheritedForm'; //CFileDescritor
 FNewInheritedForm:= TD2BridgeConfigNewInheritedForm.Create(nil);
end;

destructor TD2BridgeNewInheritedFormWizard.Destroy;
begin
 FNewInheritedForm.Free;

 inherited Destroy;
end;

function TD2BridgeNewInheritedFormWizard.Init(var NewFilename: string;
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

 FNewInheritedForm.ShowModal;

 if not FNewInheritedForm.EnableCreateInheritedForm then
 begin
  result:= mrAbort;
  exit;
 end;

 Result:=inherited Init(NewFilename, NewOwner, NewSource, Quiet);
 ResourceClass:= TForm;
end;

function TD2BridgeNewInheritedFormWizard.Initialized(NewFile: TLazProjectFile
  ): TModalResult;
begin
 Result:=inherited Initialized(NewFile);
end;

function TD2BridgeNewInheritedFormWizard.CreateSource(const Filename: string;
 const SourceName: string; const ResourceName: string): string;
var
 vPathNewInheritedFormPAS: string;
 vPathWizard: string;
 sNewFormPASContent: string;
 vNewFormPASFile: TStringStream;
begin
 FFormName:= ResourceName;

 vPathWizard:= ExtractFileDir(ExcludeTrailingPathDelimiter(D2BridgeFrameworkPath)) + PathDelim + 'Wizard';

 if FNewInheritedForm.InheritedFormInfo.IsCrud then
 begin
  vPathNewInheritedFormPas:= vPathWizard + PathDelim + 'FORMS' + PathDelim + 'Wizard'  + PathDelim + 'NewCrudForm.pas';
 end else
  vPathNewInheritedFormPas:= vPathWizard + PathDelim + 'FORMS' + PathDelim + 'Wizard'  + PathDelim + 'NewForm.pas';

 vNewFormPASFile:= TStringStream.Create('', TEncoding.UTF8);
 vNewFormPASFile.LoadFromFile(GetRealFilePath(vPathNewInheritedFormPas));
 sNewFormPASContent:= vNewFormPASFile.DataString;

 sNewFormPASContent := StringReplace(sNewFormPASContent, '<DEFINITIONUNIT>', FNewInheritedForm.InheritedFormInfo.UnitName + ', D2Bridge.Forms', [rfIgnoreCase]);
 sNewFormPASContent := StringReplace(sNewFormPASContent, '<COPYRIGHTYEAR>', IntToStr(YearOf(Now)) + ' / ' + IntToStr(YearOf(Now) + 1),[rfIgnoreCase]);
 sNewFormPASContent := StringReplace(sNewFormPASContent, '<ServerController>', GetUsesServerControllerName,[rfIgnoreCase]);

 sNewFormPASContent := StringReplace(sNewFormPASContent, '<UNITNAME>', SourceName, [rfIgnoreCase, rfReplaceAll]);
 sNewFormPASContent := StringReplace(sNewFormPASContent, '<CLASS_ID>', ResourceName, [rfIgnoreCase, rfReplaceAll]);
 sNewFormPASContent := StringReplace(sNewFormPASContent, '<CLASSINHERITED>', FNewInheritedForm.InheritedFormInfo.ClassName, [rfIgnoreCase, rfReplaceAll]);

 if FNewInheritedForm.InheritedFormInfo.IsCrud then
 begin

 end;

 result:= sNewFormPASContent;

   //Result := StringReplace(Result, '<ANCESTOR_ID>', FixAncestorClass,
   //  [rfReplaceAll, rfIgnoreCase]);

 vNewFormPASFile.free;
end;

function TD2BridgeNewInheritedFormWizard.GetResourceSource(
  const ResourceName: string): string;
begin
 result:=
   'inherited ' + FFormName + ': T' + FFormName + ' ' + LineEnding +
   'end';
end;

function TD2BridgeNewInheritedFormWizard.GetLocalizedName: string;
begin
 Result := 'D2Bridge Framework Inherited Form';
end;

function TD2BridgeNewInheritedFormWizard.GetLocalizedDescription: string;
begin
 Result:= 'Designed to inherit class of the another Form and insert D2Bridge export events';
end;

procedure Register;
begin
 RegisterProjectFileDescriptor(TD2BridgeNewInheritedFormWizard.Create);
end;

end.

