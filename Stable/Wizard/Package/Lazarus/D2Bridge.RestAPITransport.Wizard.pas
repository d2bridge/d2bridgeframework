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

unit D2Bridge.RestAPITransport.Wizard;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ProjectIntf, Dialogs, LazIDEIntf, DateUtils, Forms,
  LazFileUtils, System.UITypes,
  D2Bridge.Wizard.Util;

type

 { TD2BridgeRestAPITransportWizard }

 TD2BridgeRestAPITransportWizard = class (TProjectFileDescriptor)
 protected
  function Init(var NewFilename: string; NewOwner: TObject; var NewSource: string; Quiet: boolean): TModalResult; override;
  function Initialized({%H-}NewFile: TLazProjectFile): TModalResult; override;
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

{ TD2BridgeRestAPITransportWizard }

constructor TD2BridgeRestAPITransportWizard.Create;
begin
 inherited Create;
 DefaultFilename:= 'D2Bridge.Rest.Http';
 DefaultSourceName:= 'D2Bridge.Rest.Http';
 DefaultFileExt:= '.pas';
 UseCreateFormStatements:= false;
 IsPascalUnit:= true;
 Name := 'D2BridgeWizardAPIClient1'; //CFileDescritor
end;

function TD2BridgeRestAPITransportWizard.Init(var NewFilename: string;
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
 //ResourceClass:= TForm;
end;

function TD2BridgeRestAPITransportWizard.Initialized(NewFile: TLazProjectFile): TModalResult;
begin
 Result:=inherited Initialized(NewFile);
end;

function TD2BridgeRestAPITransportWizard.CreateSource(const Filename: string;
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
  'D2Bridge.Rest.Http.pas';

 vNewFormPASFile:= TStringStream.Create('', TEncoding.UTF8);
 vNewFormPASFile.LoadFromFile(GetRealFilePath(vPathNewFormPas));
 sNewFormPASContent:= vNewFormPASFile.DataString;

 //sNewFormPASContent := StringReplace(sNewFormPASContent, '<DEFINITIONUNIT>', 'D2Bridge.Forms', [rfIgnoreCase]);
 //sNewFormPASContent := StringReplace(sNewFormPASContent, '<COPYRIGHTYEAR>', IntToStr(YearOf(Now)) + ' / ' + IntToStr(YearOf(Now) + 1),[rfIgnoreCase]);
 //sNewFormPASContent := StringReplace(sNewFormPASContent, '<ServerController>', GetUsesServerControllerName,[rfIgnoreCase]);

 //sNewFormPASContent := StringReplace(sNewFormPASContent, '<UNITNAME>', SourceName, [rfIgnoreCase, rfReplaceAll]);
 //sNewFormPASContent := StringReplace(sNewFormPASContent, '<CLASS_ID>', ResourceName, [rfIgnoreCase, rfReplaceAll]);
 //sNewFormPASContent := StringReplace(sNewFormPASContent, '<CLASSINHERITED>', 'TD2BridgeForm', [rfIgnoreCase, rfReplaceAll]);

 result:= sNewFormPASContent;

   //Result := StringReplace(Result, '<ANCESTOR_ID>', FixAncestorClass,
   //  [rfReplaceAll, rfIgnoreCase]);

 vNewFormPASFile.free;
end;

function TD2BridgeRestAPITransportWizard.GetLocalizedName: string;
begin
 Result := 'D2Bridge REST API Transport (HTTP Client)';
end;

function TD2BridgeRestAPITransportWizard.GetLocalizedDescription: string;
begin
 Result:= 'This is the Client Helper for accessing your API endpoints; typically, ' +
          'only one is needed per project. This file implements the communication channel ' +
          'between the REST API server and the client modules.';
end;

procedure Register;
begin
 RegisterProjectFileDescriptor(TD2BridgeRestAPITransportWizard.Create);
end;

end.

