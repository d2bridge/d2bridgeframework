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

unit D2Bridge.NewInheritedForm.Wizard;

interface

{$IFDEF DESIGNMODE}

Uses
  ToolsAPI, System.IOUtils, VCL.Forms, ShellApi, D2Bridge.NewForm,
  System.Classes;

type
 TD2BridgeNewInheritedFormWizard = class(TNotifierObject, IOTAWizard, IOTAProjectWizard, IOTAFormWizard, IOTARepositoryWizard)
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
   constructor Create(const ModuleIdent, FormIdent, AncestorIdent, AParameter: string); override;
 end;

 TD2BridgeNewFormModule = class(TFormCreatorModule)
 private
  FAncestorName: string;
 public
   function GetAncestorName: string; override;
   function GetImplFile: TModuleCreatorFileClass; override;
   constructor Create(AAncestorName: string);
 end;



implementation

Uses
  D2Bridge.ConfigNewInheritedForm.View, Winapi.Windows, Vcl.Dialogs,
  System.SysUtils, DateUtils, D2Bridge.Wizard.Util;

{ TD2BridgeNewInheritedFormWizard }

procedure TD2BridgeNewInheritedFormWizard.Execute;
var
  WizardInheritedForm: TD2BridgeConfigNewInheritedForm;
begin
 WizardInheritedForm := TD2BridgeConfigNewInheritedForm.Create(Application);
 try
  WizardInheritedForm.ShowModal;

  if WizardInheritedForm.EnableCreateInheritedForm then
  begin

  end;
 finally
  WizardInheritedForm.Close;

  FreeAndNil(WizardInheritedForm);
 end;

end;

function TD2BridgeNewInheritedFormWizard.GetAuthor: string;
begin
  Result := 'D2Bridge Framework by Talis Jonatas Gomes';
end;

function TD2BridgeNewInheritedFormWizard.GetComment: string;
begin
  Result := 'Create a new Inherited Form to use in D2Bridge Framework.';
end;

function TD2BridgeNewInheritedFormWizard.GetGlyph: {$IF CompilerVersion < 37.0}Cardinal{$ELSE}THandle{$ENDIF};
begin
  Result := LoadIcon(hInstance, 'INHERITEDFORM');
end;

function TD2BridgeNewInheritedFormWizard.GetIDString: string;
begin
 Result := 'D2Bridge.FormInherited';
end;

function TD2BridgeNewInheritedFormWizard.GetName: string;
begin
 Result := 'D2Bridge Inherited Form';
end;

function TD2BridgeNewInheritedFormWizard.GetPage: string;
begin
 Result := 'D2Bridge Framework';
end;

function TD2BridgeNewInheritedFormWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

function TD2BridgeNewInheritedFormWizard.IsVisible(
  Project: IOTAProject): Boolean;
begin
 result:= false;
end;

class function TD2BridgeNewInheritedFormWizard.New: IOTAWizard;
begin
  Result := Self.Create;
end;

{ TD2BridgeFormFileCreator }

constructor TD2BridgeFormFileCreator.Create(const ModuleIdent, FormIdent, AncestorIdent, AParameter: string);
begin
 inherited;
end;

function TD2BridgeFormFileCreator.GetSource: string;
var
 vFileContent: string;
begin

  vFileContent :=
  'unit <UNITNAME>;'#13#10#13#10 +

  '{ Copyright <COPYRIGHTYEAR> D2Bridge Framework by Talis Jonatas Gomes }'#13#10#13#10 +

  'interface'#13#10#13#10 +

  'uses'#13#10 +
  '  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,'#13#10;

  if IsVCLProject then
   vFileContent := vFileContent +
    '  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,'#13#10
  else
   vFileContent := vFileContent +
    '  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,'#13#10;

  vFileContent := vFileContent +
   '  <DEFINITIONUNIT>;'#13#10#13#10 +

   'type'#13#10 +
   '  T<CLASS_ID> = class(<ANCESTOR_ID>)'#13#10 +
   '  private'#13#10 +
   '    { Private declarations }'#13#10 +
   '  public'#13#10 +
   '    { Public declarations }'#13#10 +
   '  protected'#13#10 +
   '<DECLARE_ExportD2Bridge>'+
   '<DECLARE_InitControlsD2Bridge>'+
   '<DECLARE_RenderD2Bridge>'+
   '<DECLARE_CRUDMethods>'+
   '  end;'#13#10#13#10 +
   'function <CLASS_ID>:T<CLASS_ID>;'#13#10#13#10 +

   'implementation'#13#10#13#10 +

   'Uses'#13#10 +
   '  <ServerController>;'#13#10#13#10;

  if IsVCLProject then
   vFileContent := vFileContent +
    '{$R *.dfm}'#13#10#13#10
  else
   vFileContent := vFileContent +
    '{$R *.fmx}'#13#10#13#10;

  vFileContent := vFileContent +
   'function <CLASS_ID>:T<CLASS_ID>;'#13#10 +
   'begin'#13#10 +
   '  result:= T<CLASS_ID>(T<CLASS_ID>.GetInstance);'#13#10 +
   'end;'#13#10#13#10 +

   '<METHOD_ExportD2Bridge>'+

   '<METHOD_InitControlsD2Bridge>'+

   '<METHOD_RenderD2Bridge>'+

   '<METHOD_CRUDMethods>'+

   'end.';


  Result := StringReplace(vFileContent, '<DEFINITIONUNIT>', 'D2Bridge.Forms', [rfIgnoreCase]);
  Result := StringReplace(Result,'<COPYRIGHTYEAR>',IntToStr(YearOf(Now)) + ' / ' + IntToStr(YearOf(Now) + 1),[rfIgnoreCase]);
  Result := StringReplace(Result,'<ServerController>', GetUsesServerControllerName,[rfIgnoreCase]);
  Result := inherited GetSource;
end;

{ TD2BridgeNewFormModule }


constructor TD2BridgeNewFormModule.Create(AAncestorName: string);
begin
 FAncestorName:= AAncestorName;

 inherited Create;
end;

function TD2BridgeNewFormModule.GetAncestorName: string;
begin
 Result:= FAncestorName;
end;

function TD2BridgeNewFormModule.GetImplFile: TModuleCreatorFileClass;
begin
  Result := TD2BridgeFormFileCreator;
end;

{$ELSE}
implementation
{$ENDIF}

end.
