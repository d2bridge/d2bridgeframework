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

unit D2Bridge.NewPrismFormUnit.Wizard;

interface

uses
  ToolsAPI,
  D2Bridge.NewForm, D2Bridge.Wizard.Util;

type
 TD2BridgeNewPrismFormUnitWizard = class(TNotifierObject, IOTAWizard, IOTAProjectWizard, IOTAFormWizard, IOTARepositoryWizard)
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
  public
    class function New: IOTAWizard;
 end;

 TD2BridgeFormFileCreator = class(TModuleCreatorFile)
 public
   function GetSource: string; override;
 end;

 TD2BridgeNewFormModule = class(TFormCreatorModule)
 private
   FUnitName: string;
   FModuleIdent: string;
   FFormIdent: string;
   FAncestorIdent: string;
 public
   function GetCreatorType: string; override;
   function GetImplFileName: string; override;
   function GetAncestorName: string; override;
   function GetImplFile: TModuleCreatorFileClass; override;
   function NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile; override;
   constructor Create(ModuleIdent, FormIdent, AncestorIdent: string);
 end;


implementation

uses
  Winapi.Windows, System.SysUtils, System.DateUtils, Vcl.Dialogs, D2Bridge.ConfigNewUnit.View,
  Vcl.Forms;

{ TD2BridgeNewPrismFormUnitWizard }

var
  DelphiCategory: IOTAGalleryCategory;


procedure TD2BridgeNewPrismFormUnitWizard.Execute;
var
  WizardNewUnitForm: TD2BridgeConfigNewUnitForm;
  vUnitName, vClassName: string;
begin
 WizardNewUnitForm := TD2BridgeConfigNewUnitForm.Create(Application);
 try
  WizardNewUnitForm.Label_ClassType.Caption:= 'Prism Form Unit (TD2BridgePrismForm)';
  WizardNewUnitForm.Edit_ClassName.Text:= 'TD2BridgeFormTemplate';
  WizardNewUnitForm.ShowModal;

  if WizardNewUnitForm.EnableCreateNewUnit then
  begin
   inherited;
    vClassName:= WizardNewUnitForm.Edit_ClassName.Text;
    if vClassName.StartsWith('T') then
     vClassName:= Copy(vClassName, 2);
    vUnitName:= vClassName;

    (BorlandIDEServices as IOTAModuleServices).CreateModule(TD2BridgeNewFormModule.Create
     (
      vUnitName,
      vClassName,
      ''
     ));
  end;
 finally
  WizardNewUnitForm.Close;

  FreeAndNil(WizardNewUnitForm);
 end;
end;

function TD2BridgeNewPrismFormUnitWizard.GetAuthor: string;
begin
  Result := 'D2Bridge Framework by Talis Jonatas Gomes';
end;

function TD2BridgeNewPrismFormUnitWizard.GetComment: string;
begin
 Result := 'Create a new Prism Form Unit to with D2Bridge Framework Web';
end;

function TD2BridgeNewPrismFormUnitWizard.GetGlyph: {$IF CompilerVersion < 37.0}Cardinal{$ELSE}THandle{$ENDIF};
begin
  Result := LoadIcon(hInstance, 'D2BRIDGECODE');
end;

function TD2BridgeNewPrismFormUnitWizard.GetIDString: string;
begin
 Result := 'D2Bridge.Unit';
end;

function TD2BridgeNewPrismFormUnitWizard.GetName: string;
begin
  Result := 'D2Bridge Prism Form Unit';
end;

function TD2BridgeNewPrismFormUnitWizard.GetPage: string;
begin
 Result := 'D2Bridge Framework';
end;

function TD2BridgeNewPrismFormUnitWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

function TD2BridgeNewPrismFormUnitWizard.IsVisible(Project: IOTAProject): Boolean;
begin
 result:= false;
end;

class function TD2BridgeNewPrismFormUnitWizard.New: IOTAWizard;
begin
  Result := Self.Create;
end;

{ TD2BridgeNewFormModule }

constructor TD2BridgeNewFormModule.Create(ModuleIdent, FormIdent, AncestorIdent: string);
begin
 FUnitName:= ModuleIdent+'.pas';
 FModuleIdent:= ModuleIdent;
 FFormIdent:= FormIdent;
 FAncestorIdent:= AncestorIdent;

 inherited Create;
end;

function TD2BridgeNewFormModule.GetAncestorName: string;
begin
 Result:= '';
end;

function TD2BridgeNewFormModule.GetCreatorType: string;
begin
 result:= sUnit;
end;

function TD2BridgeNewFormModule.GetImplFile: TModuleCreatorFileClass;
begin
  Result := TD2BridgeFormFileCreator;
end;

function TD2BridgeNewFormModule.GetImplFileName: string;
begin
 result:= ExtractFilePath(GetCurrentProject.FileName)+FUnitName;
end;

function TD2BridgeNewFormModule.NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
begin
 Result := nil;
 if GetImplFile <> nil then
   Result := GetImplFile.Create(FModuleIdent, FFormIdent, FAncestorIdent, '');
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
  '  System.SysUtils, System.Classes, D2Bridge.Prism.Form;'#13#10#13#10 +

  'type'#13#10 +
  '  <CLASS_ID> = class(TD2BridgePrismForm)'#13#10 +
  '  private'#13#10 +
  '    procedure ProcessHTML(Sender: TObject; var AHTMLText: string);'#13#10 +
  '  protected'#13#10 +
  '    procedure TagHTML(const TagString: string; var ReplaceTag: string); override;'#13#10 +
  '    procedure CallBack(const CallBackName: string; EventParams: TStrings); override;'#13#10 +
  '  public'#13#10 +
  '    constructor Create(AOwner: TComponent; D2BridgePrismFramework: TObject); override;'#13#10 +
  '  end;'#13#10#13#10 +

  'implementation'#13#10#13#10 +

  'Uses'#13#10 +
  '  <ServerController>;'#13#10#13#10 +

  'constructor <CLASS_ID>.Create(AOwner: TComponent; D2BridgePrismFramework: TObject);'#13#10 +
  'begin'#13#10 +
  ' inherited;'#13#10 +
  ''#13#10 +
  ' //Events'#13#10 +
  ' OnProcessHTML:= ProcessHTML;'#13#10 +
  ''#13#10 +
  ' //Your Code'#13#10 +
  ''#13#10 +
  'end;'#13#10#13#10 +

  'procedure <CLASS_ID>.CallBack(const CallBackName: string; EventParams: TStrings);'#13#10 +
  'begin'#13#10 +
  ' //Example'#13#10 +
  ' {'#13#10 +
  ' if SameText(CallBackName, ''OpenLogin'') then'#13#10 +
  ' begin'#13#10 +
  '  if Form_Login = nil then'#13#10 +
  '   TForm_Login.CreateInstance;'#13#10 +
  '  Form_Login.Show;'#13#10 +
  ' end;'#13#10 +
  ' }'#13#10 +
  'end;'#13#10#13#10 +

  'procedure <CLASS_ID>.TagHTML(const TagString: string; var ReplaceTag: string);'#13#10 +
  'begin'#13#10 +
  ' //Example'#13#10 +
  ' {'#13#10 +
  ' if TagString = ''UserName'' then'#13#10 +
  ' begin'#13#10 +
  '  ReplaceTag := ''Name of User'';'#13#10 +
  ' end;'#13#10 +
  ' }'#13#10 +
  'end;'#13#10#13#10 +

  'procedure <CLASS_ID>.ProcessHTML(Sender: TObject; var AHTMLText: string);'#13#10 +
  'begin'#13#10 +
  ' //Intercep HTML Code'#13#10 +
  ''#13#10 +
  'end;'#13#10#13#10 +

  'end.';

  Result:= vFileContent;
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
