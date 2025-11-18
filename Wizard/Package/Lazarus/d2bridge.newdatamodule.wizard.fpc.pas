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

unit D2Bridge.NewDataModule.Wizard.FPC;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ProjectIntf, Dialogs, LazIDEIntf, DateUtils, System.UITypes, Forms,
  D2Bridge.Wizard.Util;

type

 { TD2BridgeNewDataModuleWizard }

 TD2BridgeNewDataModuleWizard = class (TProjectFileDescriptor)
 protected
  function Init(var NewFilename: string; NewOwner: TObject; var NewSource: string; Quiet: boolean): TModalResult; override;
 public
  constructor Create; override;
  function CreateSource(const Filename     : string;
                        const SourceName   : string;
                        const ResourceName : string): string; override;
  function GetLocalizedName: string; override;
  function GetLocalizedDescription: string; override;
end;

procedure Register;

implementation

{ TD2BridgeNewDataModuleWizard }

constructor TD2BridgeNewDataModuleWizard.Create;
begin
 inherited Create;
 DefaultFilename:= 'Unit1';
 DefaultSourceName:= 'Unit1';
 DefaultFileExt:= '.pas';
 UseCreateFormStatements:= True;
 IsPascalUnit:= True;
 Name := 'D2BridgeWizardNewDataModule'; //CFileDescritor
end;

function TD2BridgeNewDataModuleWizard.Init(var NewFilename: string;
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

  Result:=inherited Init(NewFilename, NewOwner, NewSource, Quiet);
  ResourceClass:= TDataModule;
end;

function TD2BridgeNewDataModuleWizard.CreateSource(const Filename: string;
 const SourceName: string; const ResourceName: string): string;
var
 vPathNewDataModulePAS: string;
 vPathWizard: string;
 sNewDataModulePASContent: string;
 vNewDataModulePASFile: TStringStream;
begin
 vPathWizard:= ExtractFileDir(ExcludeTrailingPathDelimiter(D2BridgeFrameworkPath)) + PathDelim + 'Wizard';

 vPathNewDataModulePas:= vPathWizard + PathDelim + 'FORMS' + PathDelim + 'Wizard' + PathDelim + 'NewDataModule.pas';

 vNewDataModulePASFile:= TStringStream.Create('', TEncoding.UTF8);
 vNewDataModulePASFile.LoadFromFile(GetRealFilePath(vPathNewDataModulePas));
 sNewDataModulePASContent:= vNewDataModulePASFile.DataString;

 sNewDataModulePASContent := StringReplace(sNewDataModulePASContent, '<DEFINITIONUNIT>', 'D2Bridge.Forms', [rfIgnoreCase]);
 sNewDataModulePASContent := StringReplace(sNewDataModulePASContent, '<COPYRIGHTYEAR>', IntToStr(YearOf(Now)) + ' / ' + IntToStr(YearOf(Now) + 1),[rfIgnoreCase]);
 sNewDataModulePASContent := StringReplace(sNewDataModulePASContent, '<ServerController>', GetUsesServerControllerName,[rfIgnoreCase]);

 sNewDataModulePASContent := StringReplace(sNewDataModulePASContent, '<UNITNAME>', SourceName, [rfIgnoreCase, rfReplaceAll]);
 sNewDataModulePASContent := StringReplace(sNewDataModulePASContent, '<CLASS_ID>', ResourceName, [rfIgnoreCase, rfReplaceAll]);
 sNewDataModulePASContent := StringReplace(sNewDataModulePASContent, '<CLASSINHERITED>', 'TDataModule', [rfIgnoreCase, rfReplaceAll]);

 result:= sNewDataModulePASContent;

   //Result := StringReplace(Result, '<ANCESTOR_ID>', FixAncestorClass,
   //  [rfReplaceAll, rfIgnoreCase]);

 vNewDataModulePASFile.free;
end;

function TD2BridgeNewDataModuleWizard.GetLocalizedName: string;
begin
 Result := 'D2Bridge Framework DataModule';
end;

function TD2BridgeNewDataModuleWizard.GetLocalizedDescription: string;
begin
 Result:= 'D2Bridge DataModule is session DataModule designed to use from Web and LCL';
end;

procedure Register;
begin
 RegisterProjectFileDescriptor(TD2BridgeNewDataModuleWizard.Create);
end;

end.

