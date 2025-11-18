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

unit D2Bridge.NewDataModule.Wizard;

interface

uses
  ToolsAPI,
  D2Bridge.NewForm, D2Bridge.Wizard.Util;

type
 TD2BridgeNewDataModuleWizard = class(TNotifierObject, IOTAWizard, IOTAProjectWizard, IOTAFormWizard, IOTARepositoryWizard)
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
  Winapi.Windows, System.SysUtils, System.DateUtils;

{ TD2BridgeNewDataModuleWizard }

var
  DelphiCategory: IOTAGalleryCategory;


procedure TD2BridgeNewDataModuleWizard.Execute;
begin
  inherited;
  (BorlandIDEServices as IOTAModuleServices).CreateModule(TD2BridgeNewFormModule.Create);
end;

function TD2BridgeNewDataModuleWizard.GetAuthor: string;
begin
  Result := 'D2Bridge Framework by Talis Jonatas Gomes';
end;

function TD2BridgeNewDataModuleWizard.GetComment: string;
begin
 Result := 'Create a new DataModule Session to use VCL/FMX and D2Bridge Framework';
end;

function TD2BridgeNewDataModuleWizard.GetGlyph: {$IF CompilerVersion < 37.0}Cardinal{$ELSE}THandle{$ENDIF};
begin
  Result := LoadIcon(hInstance, 'DATAMODULE');
end;

function TD2BridgeNewDataModuleWizard.GetIDString: string;
begin
 Result := 'D2Bridge.Datamodule';
end;

function TD2BridgeNewDataModuleWizard.GetName: string;
begin
  Result := 'D2Bridge DataModule Session';
end;

function TD2BridgeNewDataModuleWizard.GetPage: string;
begin
 Result := 'D2Bridge Framework';
end;

function TD2BridgeNewDataModuleWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

function TD2BridgeNewDataModuleWizard.IsVisible(Project: IOTAProject): Boolean;
begin
 result:= false;
end;

{ TD2BridgeNewFormModule }

function TD2BridgeNewFormModule.GetAncestorName: string;
begin
 Result:= 'DataModule';
end;

function TD2BridgeNewFormModule.GetImplFile: TModuleCreatorFileClass;
begin
  Result := TD2BridgeFormFileCreator;
end;

{ TD2BridgeFormFileCreator }

function TD2BridgeFormFileCreator.GetSource: string;
var
 vFileContent: string;
begin
  vFileContent :=
  'unit <UNITNAME>;'#13#10#13#10 +

  '{ Copyright <COPYRIGHTYEAR> D2Bridge Framework by Talis Jonatas Gomes }'#13#10#13#10 +

  'interface'#13#10#13#10 +

  'uses'#13#10 +
  '  System.SysUtils, System.Classes;'#13#10#13#10 +

  'type'#13#10 +
  '  T<CLASS_ID> = class(TDataModule)'#13#10 +
  '  private'#13#10 +
  '    { Private declarations }'#13#10 +
  '  public'#13#10 +
  '    class procedure CreateInstance;'#13#10 +
  '    procedure DestroyInstance;'#13#10 +
  '  end;'#13#10#13#10 +

  'function <CLASS_ID>:T<CLASS_ID>;'#13#10#13#10 +

  'implementation'#13#10#13#10 +

  '{%CLASSGROUP ''System.Classes.TPersistent''}'#13#10#13#10 +

  'Uses'#13#10 +
  '  D2Bridge.Instance, <ServerController>;'#13#10#13#10 +

  '{$R *.dfm}'#13#10#13#10 +

  'class procedure T<CLASS_ID>.CreateInstance;'#13#10 +
  'begin'#13#10 +
  ' D2BridgeInstance.CreateInstance(self);'#13#10 +
  'end;'#13#10#13#10 +

  'function <CLASS_ID>:T<CLASS_ID>;'#13#10 +
  'begin'#13#10 +
  ' result:= T<CLASS_ID>(D2BridgeInstance.GetInstance(T<CLASS_ID>));'#13#10 +
  'end;'#13#10#13#10 +

  'procedure T<CLASS_ID>.DestroyInstance;'#13#10 +
  'begin'#13#10 +
  ' D2BridgeInstance.DestroyInstance(self);'#13#10 +
  'end;'#13#10#13#10 +

  'end.';


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
