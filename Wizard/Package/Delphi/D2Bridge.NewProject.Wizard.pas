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

unit D2Bridge.NewProject.Wizard;

interface

uses
  System.Generics.Collections,  Winapi.Windows,ToolsAPI,  Vcl.Controls,DccStrs,
  System.IOUtils, VCL.Forms, ShellApi, vcl.Dialogs, IniFiles, System.Classes;

type
  TD2BridgeNewProjectWizard = class(TNotifierObject, IOTAWizard, IOTAProjectWizard, IOTARepositoryWizard)
  private
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

uses
  D2Bridge.ConfigNewProject.View, D2Bridge.Wizard.Templates, D2Bridge.Lang.Util,
  D2Bridge.NewProject.Wizard.Common, D2Bridge.Wizard.Util,
  System.SysUtils, System.Zip;


{ TD2BridgeNewProjectWizard }

procedure TD2BridgeNewProjectWizard.Execute;
var
 NewProjectWizardCommon: TD2BridgeNewProjectWizardCommon;
begin
 try
  NewProjectWizardCommon:= TD2BridgeNewProjectWizardCommon.Create;
  NewProjectWizardCommon.Execute;
 finally
  FreeAndNil(NewProjectWizardCommon);
 end;
end;

function TD2BridgeNewProjectWizard.GetAuthor: string;
begin
  Result := 'D2Bridge Framework by Talis Jonatas Gomes';
end;

function TD2BridgeNewProjectWizard.GetComment: string;
begin
  Result := 'Create a new Delphi Web project with D2Bridge Framework. '+
   'Use this wizard to create your project and choose the type of server '+
   '(Full, Compact, Console), also choose the template and several options including SSL';
end;

function TD2BridgeNewProjectWizard.GetGlyph: {$IF CompilerVersion < 37.0}Cardinal{$ELSE}THandle{$ENDIF};
begin
  Result := LoadIcon(HInstance, 'D2BRIDGEPROJECT');
end;

function TD2BridgeNewProjectWizard.GetIDString: string;
begin
  Result:= 'D2Bridge';
end;

function TD2BridgeNewProjectWizard.GetName: string;
begin
  Result := 'D2Bridge Framework Delphi Web Project';
end;

function TD2BridgeNewProjectWizard.GetPage: string;
begin
  Result := 'D2Bridge Framework';
end;


function TD2BridgeNewProjectWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

class function TD2BridgeNewProjectWizard.New: IOTAWizard;
begin
  Result := Self.Create;
end;

constructor TD2BridgeNewProjectWizard.Create;
begin
 inherited;

end;

end.
