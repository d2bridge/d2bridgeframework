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

interface

uses
  ToolsAPI,
  D2Bridge.NewForm, D2Bridge.Wizard.Util;

type
 TD2BridgeNewRestAPISessionWizard = class(TNotifierObject, IOTAWizard, IOTAProjectWizard, IOTAFormWizard, IOTARepositoryWizard)
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

{ TD2BridgeNewRestAPISessionWizard }

var
  DelphiCategory: IOTAGalleryCategory;


procedure TD2BridgeNewRestAPISessionWizard.Execute;
begin
  inherited;
  (BorlandIDEServices as IOTAModuleServices).CreateModule(TD2BridgeNewFormModule.Create);
end;

function TD2BridgeNewRestAPISessionWizard.GetAuthor: string;
begin
  Result := 'D2Bridge Framework by Talis Jonatas Gomes';
end;

function TD2BridgeNewRestAPISessionWizard.GetComment: string;
begin
 Result := 'Create Session for REST API Server. Just one Session Unit is necessary';
end;

function TD2BridgeNewRestAPISessionWizard.GetGlyph: {$IF CompilerVersion < 37.0}Cardinal{$ELSE}THandle{$ENDIF};
begin
  Result := LoadIcon(hInstance, 'RESTAPI');
end;

function TD2BridgeNewRestAPISessionWizard.GetIDString: string;
begin
 Result := 'D2Bridge.Unit.API.5';
end;

function TD2BridgeNewRestAPISessionWizard.GetName: string;
begin
  Result := 'D2Bridge REST Session';
end;

function TD2BridgeNewRestAPISessionWizard.GetPage: string;
begin
 Result := 'D2Bridge Framework';
end;

function TD2BridgeNewRestAPISessionWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

function TD2BridgeNewRestAPISessionWizard.IsVisible(Project: IOTAProject): Boolean;
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
  sFile.LoadFromFile(ExtractFileDir(ExcludeTrailingPathDelimiter(D2BridgeFrameworkPath))+ '\Wizard\FORMS\Wizard\D2Bridge.Rest.Context.pas');
  vFileContent:= sFile.DataString;
  sFile.Free;

  Result := StringReplace(Result,'<COPYRIGHTYEAR>',IntToStr(YearOf(Now)) + ' / ' + IntToStr(YearOf(Now) + 1),[rfIgnoreCase]);
  Result := inherited GetSource;
end;

//initialization
//  DelphiCategory := AddDelphiCategory('D2Bridge Form', 'D2Bridge Framework');
//
//finalization
//  RemoveCategory(DelphiCategory);

end.
