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

unit D2Bridge.NewRestAPISession.Wizard;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ProjectIntf, Dialogs, LazIDEIntf, DateUtils, Forms,
  LazFileUtils, ProjPackIntf, System.UITypes,
  D2Bridge.Wizard.Util;

type

 { TD2BridgeNewRestAPISessionWizard }

 TD2BridgeNewRestAPISessionWizard = class (TProjectFileDescriptor)
 protected
  function Init(var NewFilename: string; NewOwner: TObject; var NewSource: string; Quiet: boolean): TModalResult; override;
  function Initialized({%H-}NewFile: TLazProjectFile): TModalResult; override;
  procedure AddCustomCompilerDirective;
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

{ TD2BridgeNewRestAPISessionWizard }

constructor TD2BridgeNewRestAPISessionWizard.Create;
begin
 inherited Create;
 DefaultFilename:= 'D2Bridge.Rest.Session';
 DefaultSourceName:= 'D2Bridge.Rest.Session';
 DefaultFileExt:= '.pas';
 UseCreateFormStatements:= True;
 IsPascalUnit:= True;
 Name := 'D2BridgeWizardAPINewUnit6'; //CFileDescritor
end;

function TD2BridgeNewRestAPISessionWizard.Init(var NewFilename: string;
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

 Result:=inherited Init(NewFilename, NewOwner, NewSource, Quiet);

 //ResourceClass:= TDataModule;
end;

function TD2BridgeNewRestAPISessionWizard.Initialized(NewFile: TLazProjectFile): TModalResult;
begin
 Result:=inherited Initialized(NewFile);
end;

procedure TD2BridgeNewRestAPISessionWizard.AddCustomCompilerDirective;
begin
 if LazProject1 = nil then Exit;

 if Pos('-d' + 'D2BridgeCustomRestSession', LazProject1.LazCompilerOptions.CustomOptions) = 0 then
   LazProject1.LazCompilerOptions.CustomOptions :=
     Trim(LazProject1.LazCompilerOptions.CustomOptions + ' -d' + 'D2BridgeCustomRestSession');
end;

function TD2BridgeNewRestAPISessionWizard.CreateSource(const Filename: string;
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
  'D2Bridge.Rest.Session.Laz.pas';

 vNewFormPASFile:= TStringStream.Create('', TEncoding.UTF8);
 vNewFormPASFile.LoadFromFile(GetRealFilePath(vPathNewFormPas));
 sNewFormPASContent:= vNewFormPASFile.DataString;

 sNewFormPASContent := StringReplace(sNewFormPASContent, '<DEFINITIONUNIT>', 'D2Bridge.Forms', [rfIgnoreCase]);
 sNewFormPASContent := StringReplace(sNewFormPASContent, '<COPYRIGHTYEAR>', IntToStr(YearOf(Now)) + ' / ' + IntToStr(YearOf(Now) + 1),[rfIgnoreCase]);
 sNewFormPASContent := StringReplace(sNewFormPASContent, '<ServerController>', GetUsesServerControllerName,[rfIgnoreCase]);

 sNewFormPASContent := StringReplace(sNewFormPASContent, '<UNITNAME>', SourceName, [rfIgnoreCase, rfReplaceAll]);
 sNewFormPASContent := StringReplace(sNewFormPASContent, '<CLASS_ID>', ResourceName, [rfIgnoreCase, rfReplaceAll]);
 sNewFormPASContent := StringReplace(sNewFormPASContent, '<CLASSINHERITED>', 'TD2BridgeForm', [rfIgnoreCase, rfReplaceAll]);

 result:= sNewFormPASContent;

   //Result := StringReplace(Result, '<ANCESTOR_ID>', FixAncestorClass,
   //  [rfReplaceAll, rfIgnoreCase]);

 vNewFormPASFile.free;


 AddCustomCompilerDirective;
end;

function TD2BridgeNewRestAPISessionWizard.GetLocalizedName: string;
begin
 Result := 'D2Bridge REST Session';
end;

function TD2BridgeNewRestAPISessionWizard.GetLocalizedDescription: string;
begin
 Result:= 'Create Session for REST API Server. Just one Session Unit is necessary';
end;

procedure Register;
begin
 RegisterProjectFileDescriptor(TD2BridgeNewRestAPISessionWizard.Create);
end;

end.

