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

unit D2Bridge.NewForm.Wizard;

interface

uses
  ToolsAPI,
  D2Bridge.NewForm, D2Bridge.Wizard.Util;


type
 TD2BridgeNewFormWizard = class(TNotifierObject, IOTAWizard, IOTAProjectWizard, IOTAFormWizard, IOTARepositoryWizard)
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
  Winapi.Windows, System.SysUtils, System.DateUtils, Vcl.Dialogs;

{ TD2BridgeNewFormWizard }

var
  DelphiCategory: IOTAGalleryCategory;


procedure TD2BridgeNewFormWizard.Execute;
begin
  inherited;
  (BorlandIDEServices as IOTAModuleServices).CreateModule(TD2BridgeNewFormModule.Create);
end;

function TD2BridgeNewFormWizard.GetAuthor: string;
begin
  Result := 'D2Bridge Framework by Talis Jonatas Gomes';
end;

function TD2BridgeNewFormWizard.GetComment: string;
begin
 Result := 'Create a new Form to use VCL/FMX and D2Bridge Framework';
end;

function TD2BridgeNewFormWizard.GetGlyph: {$IF CompilerVersion < 37.0}Cardinal{$ELSE}THandle{$ENDIF};
begin
  Result := LoadIcon(hInstance, 'WIZARDFORM');
end;

function TD2BridgeNewFormWizard.GetIDString: string;
begin
 Result := 'D2Bridge.Form';
end;

function TD2BridgeNewFormWizard.GetName: string;
begin
  Result := 'D2Bridge Form';
end;

function TD2BridgeNewFormWizard.GetPage: string;
begin
 Result := 'D2Bridge Framework';
end;

function TD2BridgeNewFormWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

function TD2BridgeNewFormWizard.IsVisible(Project: IOTAProject): Boolean;
begin
 result:= false;
end;

{ TD2BridgeNewFormModule }

function TD2BridgeNewFormModule.GetAncestorName: string;
begin
 Result:= 'Form';
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
   '  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, '#13#10;

  if IsVCLProject then
   vFileContent := vFileContent +
    '  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,'#13#10
  else
   vFileContent := vFileContent +
    '  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,'#13#10;

  vFileContent := vFileContent +
   '  <DEFINITIONUNIT>;'#13#10#13#10 +

   'type'#13#10 +
   '  T<CLASS_ID> = class(TD2BridgeForm)'#13#10 +
   '  private'#13#10 +
   '    { Private declarations }'#13#10 +
   '  public'#13#10 +
   '    { Public declarations }'#13#10 +
   '  protected'#13#10 +
   '    procedure ExportD2Bridge; override;'#13#10 +
   '    procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;'#13#10 +
   '    procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;'#13#10 +
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

   'procedure T<CLASS_ID>.ExportD2Bridge;'#13#10 +
   'begin'#13#10 +
   '  inherited;'#13#10#13#10 +

   '  Title:= ''My D2Bridge Form'';'#13#10#13#10 +

   '  //TemplateClassForm:= TD2BridgeFormTemplate;'#13#10 +
   '  D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '''';'#13#10 +
   '  D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '''';'#13#10#13#10 +

   '  with D2Bridge.Items.add do'#13#10 +
   '  begin'#13#10 +
   '   {Yours Controls}'#13#10 +
   '  end;'#13#10#13#10 +

   'end;'#13#10#13#10 +

   'procedure T<CLASS_ID>.InitControlsD2Bridge(const PrismControl: TPrismControl);'#13#10 +
   'begin'#13#10 +
   ' inherited;'#13#10#13#10 +

   ' //Change Init Property of Prism Controls'#13#10 +
   ' {'#13#10 +
   '  if PrismControl.VCLComponent = Edit1 then'#13#10 +
   '   PrismControl.AsEdit.DataType:= TPrismFieldType.PrismFieldTypeInteger;'#13#10#13#10 +

   '  if PrismControl.IsDBGrid then'#13#10 +
   '  begin'#13#10 +
   '   PrismControl.AsDBGrid.RecordsPerPage:= 10;'#13#10 +
   '   PrismControl.AsDBGrid.MaxRecords:= 2000;'#13#10 +
   '  end;'#13#10 +
   ' }'#13#10 +
   'end;'#13#10#13#10 +

   'procedure T<CLASS_ID>.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string);'#13#10 +
   'begin'#13#10 +
   ' inherited;'#13#10#13#10 +

   ' //Intercept HTML'#13#10 +
   ' {'#13#10 +
   '  if PrismControl.VCLComponent = Edit1 then'#13#10 +
   '  begin'#13#10 +
   '   HTMLControl:= ''</>'';'#13#10 +
   '  end;'#13#10 +
   ' }'#13#10 +
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
