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

unit D2Bridge.NewRestAPIUnit.Wizard;

interface

uses
  ToolsAPI,
  D2Bridge.NewForm, D2Bridge.Wizard.Util;

type
 TD2BridgeNewRestAPIUnitWizard = class(TNotifierObject, IOTAWizard, IOTAProjectWizard, IOTAFormWizard, IOTARepositoryWizard)
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
 end;

 TD2BridgeFormFileCreator = class(TModuleCreatorFile)
 public
   function GetSource: string; override;
 end;

 TD2BridgeNewFormModule = class(TFormCreatorModule)
 public
   function GetAncestorName: string; override;
   function GetImplFile: TModuleCreatorFileClass; override;
 end;


implementation

uses
  Winapi.Windows, System.SysUtils, System.DateUtils, System.Classes;

{ TD2BridgeNewRestAPIUnitWizard }

var
  DelphiCategory: IOTAGalleryCategory;


procedure TD2BridgeNewRestAPIUnitWizard.Execute;
begin
  inherited;
  (BorlandIDEServices as IOTAModuleServices).CreateModule(TD2BridgeNewFormModule.Create);
end;

function TD2BridgeNewRestAPIUnitWizard.GetAuthor: string;
begin
  Result := 'D2Bridge Framework by Talis Jonatas Gomes';
end;

function TD2BridgeNewRestAPIUnitWizard.GetComment: string;
begin
 Result := 'Create a new simple D2Bridge Rest API Unit';
end;

function TD2BridgeNewRestAPIUnitWizard.GetGlyph: {$IF CompilerVersion < 37.0}Cardinal{$ELSE}THandle{$ENDIF};
begin
  Result := LoadIcon(hInstance, 'RESTAPI');
end;

function TD2BridgeNewRestAPIUnitWizard.GetIDString: string;
begin
 Result := 'D2Bridge.Unit.API.1';
end;

function TD2BridgeNewRestAPIUnitWizard.GetName: string;
begin
  Result := 'D2Bridge REST API Unit';
end;

function TD2BridgeNewRestAPIUnitWizard.GetPage: string;
begin
 Result := 'D2Bridge Framework';
end;

function TD2BridgeNewRestAPIUnitWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

function TD2BridgeNewRestAPIUnitWizard.IsVisible(Project: IOTAProject): Boolean;
begin
 result:= false;
end;

{ TD2BridgeNewFormModule }

function TD2BridgeNewFormModule.GetAncestorName: string;
begin
 Result:= '';
end;

function TD2BridgeNewFormModule.GetImplFile: TModuleCreatorFileClass;
begin
  Result := TD2BridgeFormFileCreator;
end;

{ TD2BridgeFormFileCreator }

function TD2BridgeFormFileCreator.GetSource: string;
var
 vFileContent: string;
 sFile: TStringStream;
begin
  sFile:= TStringStream.Create('', TEncoding.UTF8);
  sFile.LoadFromFile(ExtractFileDir(ExcludeTrailingPathDelimiter(D2BridgeFrameworkPath))+ '\Wizard\FORMS\Wizard\RestAPIUnit.pas');
  vFileContent:= sFile.DataString;
  sFile.Free;

  Result := StringReplace(vFileContent, '<DEFINITIONUNIT>', 'D2Bridge.Forms', [rfIgnoreCase]);
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
