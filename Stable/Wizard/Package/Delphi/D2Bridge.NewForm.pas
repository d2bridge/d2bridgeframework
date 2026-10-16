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

unit D2Bridge.NewForm;

interface

Uses
 Windows, ToolsAPI, System.SysUtils, Vcl.Dialogs,
 D2Bridge.Wizard.Types;

type
 TModuleCreatorFileClass = class of TModuleCreatorFile;

 TD2BridgeWizardFormCreator = class(TInterfacedObject, IOTACreator, IOTAModuleCreator)
 private
   FFormEditor: IOTAFormEditor;
   FCreateD2BridgeFormProperties: boolean;
   FCreateD2BridgeCRUDProperties: boolean;
   FSender: TObject;
 public
   constructor Create;

   { IOTACreator }
   function GetCreatorType: string; virtual; abstract;
   function GetExisting: Boolean;
   function GetFileSystem: string;
   function GetOwner: IOTAModule;
   function GetUnnamed: Boolean;

   { IOTAModuleCreator }
   function GetAncestorName: string; virtual;
   function GetImplFileName: string; virtual;
   function GetIntfFileName: string; virtual;
   function GetFormName: string; virtual;
   function GetMainForm: Boolean;
   function GetShowForm: Boolean;
   function GetShowSource: Boolean;
   function NewFormFile(const FormIdent, AncestorIdent: string): IOTAFile;
   function NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile; virtual;
   function NewIntfSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile; virtual;
   procedure FormCreated(const FormEditor: IOTAFormEditor);

   function GetImplFile: TModuleCreatorFileClass; virtual;
   function GetIntfFile: TModuleCreatorFileClass; virtual;

   property AncestorName: string read GetAncestorName;
   property FormName: string read GetFormName;
   property ImplFileName: string read GetImplFileName;
   property IntfFileName: string read GetIntfFileName;
   property MainForm: Boolean read GetMainForm;
   property ShowForm: Boolean read GetShowForm;
   property ShowSource: Boolean read GetShowSource;
   property Sender: TObject read FSender write FSender;

   //Custom Prop
   property OptionCreateD2BridgeFormProperties: Boolean read FCreateD2BridgeFormProperties write FCreateD2BridgeFormProperties;
   property OptionCreateD2BridgeCRUDProperties: Boolean read FCreateD2BridgeCRUDProperties write FCreateD2BridgeCRUDProperties;
 private

 end;


 TBaseCreatorFile = class(TInterfacedObject, IOTAFile)
 public
  constructor Create(const Source: string);
  function GetSource: string; virtual;
  function GetAge: TDateTime;
 private
   FAge: TDateTime;
 end;


 TModuleCreatorFile = class(TBaseCreatorFile)
 private
   FModuleIdent: String;
   FFormIdent: String;
   FAncestorIdent: string;
   FParameter: string;
   FD2BridgeWizardFormCreator: TD2BridgeWizardFormCreator;
   function ClassNameFromAncestorIdent: string;
 public
   constructor Create(const ModuleIdent, FormIdent, AncestorIdent, AParameter: string); virtual;
   function GetSource: String; override;

   function GetParameter: string;

   property D2BridgeWizardFormCreator: TD2BridgeWizardFormCreator read FD2BridgeWizardFormCreator write FD2BridgeWizardFormCreator;
 end;


 TFormCreatorModule = class(TD2BridgeWizardFormCreator)
 public
   function GetCreatorType: string; override;
   function GetAncestorName: string; override;
 end;


implementation

uses
  D2Bridge.Wizard.Util;

{ TD2BridgeWizardFormCreator }


constructor TD2BridgeWizardFormCreator.Create;
begin
 FCreateD2BridgeFormProperties:= true;
 FCreateD2BridgeCRUDProperties:= false;

 inherited;
end;

procedure TD2BridgeWizardFormCreator.FormCreated(
  const FormEditor: IOTAFormEditor);
begin
 FFormEditor:= FormEditor;

 inherited;
end;

function TD2BridgeWizardFormCreator.GetAncestorName: string;
begin
  Result := '';
end;

function TD2BridgeWizardFormCreator.GetExisting: Boolean;
begin
  Result := False; // Create a new Form
end;

function TD2BridgeWizardFormCreator.GetFileSystem: string;
begin
  Result := ''; // Default File System
end;

function TD2BridgeWizardFormCreator.GetFormName: string;
begin
  Result := '';
end;

function TD2BridgeWizardFormCreator.GetImplFile: TModuleCreatorFileClass;
begin
  Result := TModuleCreatorFile;
end;

function TD2BridgeWizardFormCreator.GetImplFileName: string;
begin
  Result := '';
end;

function TD2BridgeWizardFormCreator.GetIntfFile: TModuleCreatorFileClass;
begin
  Result := TModuleCreatorFile;
end;

function TD2BridgeWizardFormCreator.GetIntfFileName: string;
begin
  Result := '';
end;

function TD2BridgeWizardFormCreator.GetMainForm: Boolean;
begin
  Result := True;
end;

function TD2BridgeWizardFormCreator.GetOwner: IOTAModule;
begin
 Result := GetCurrentProject; // Owned by current project
end;

function TD2BridgeWizardFormCreator.GetShowForm: Boolean;
begin
  Result := True;
end;

function TD2BridgeWizardFormCreator.GetShowSource: Boolean;
begin
  Result := True;
end;

function TD2BridgeWizardFormCreator.GetUnnamed: Boolean;
begin
  Result := True; // Project needs to be named/saved
end;

function TD2BridgeWizardFormCreator.NewFormFile(const FormIdent,
  AncestorIdent: string): IOTAFile;
begin
  Result := nil;
end;

function TD2BridgeWizardFormCreator.NewImplSource(const ModuleIdent, FormIdent,
  AncestorIdent: string): IOTAFile;
begin
  Result := nil;
  if GetImplFile <> nil then
    Result := GetImplFile.Create(ModuleIdent, FormIdent, AncestorIdent, '');
  TModuleCreatorFile(Result).FD2BridgeWizardFormCreator:= self;
end;

function TD2BridgeWizardFormCreator.NewIntfSource(const ModuleIdent, FormIdent,
  AncestorIdent: string): IOTAFile;
begin
  Result := nil;
  if GetIntfFile <> nil then
    Result := GetIntfFile.Create(ModuleIdent, FormIdent, AncestorIdent, '');
  TModuleCreatorFile(Result).FD2BridgeWizardFormCreator:= self;
end;

{ TBaseCreatorFile }

constructor TBaseCreatorFile.Create(const Source: string);
begin
 FAge := -1; // Flag age as New File
end;

function TBaseCreatorFile.GetAge: TDateTime;
begin
 Result := FAge
end;

function TBaseCreatorFile.GetSource: string;
begin
 Result := '';
end;

{ TModuleCreatorFile }

function TModuleCreatorFile.ClassNameFromAncestorIdent: string;
var
 ModServices: IOTAModuleServices;
 Module: IOTAModule;
 ProjectIOTA: IOTAProject;
 vIOTAModuleInfo: IOTAModuleInfo;
 vModule: IOTAModule;
 vFormIOTA: IOTAFormEditor;
 i, j: Integer;
begin
 ModServices := BorlandIDEServices as IOTAModuleServices;

 if Assigned(ModServices) then
 begin
   Module := ModServices.CurrentModule;

   if Assigned(Module) and not Supports(Module, IOTAProject) and (Module.OwnerModuleCount > 0) then
    Module := Module.OwnerModules[0];

   if Assigned(Module) and Supports(Module, IOTAProject, ProjectIOTA) then
   begin
    for I := 0 to pred(ProjectIOTA.GetModuleCount) do
    begin
     vIOTAModuleInfo:= ProjectIOTA.GetModule(I);

     if (vIOTAModuleInfo.ModuleType = utForm) and (vIOTAModuleInfo.FormName <> '') then
     begin
      if SameText(vIOTAModuleInfo.FormName, FAncestorIdent) then
      begin
       vModule:= vIOTAModuleInfo.OpenModule;

       for j := 0 to pred(vModule.ModuleFileCount) do
       begin
        if Supports(vModule.ModuleFileEditors[j], IOTAFormEditor, vFormIOTA) then
        begin
         Result:= vFormIOTA.GetRootComponent.GetComponentType;
         break;
        end;
       end;
      end;
     end;
    end;
   end;
 end;
end;

constructor TModuleCreatorFile.Create(const ModuleIdent, FormIdent, AncestorIdent, AParameter: string);
begin
  FAge := -1; // Flag age as New File
  FModuleIdent := ModuleIdent;
  FFormIdent := FormIdent;
  FAncestorIdent := AncestorIdent;
  FParameter:= AParameter;
end;

function TModuleCreatorFile.GetParameter: string;
begin
 result:= FParameter;
end;

function TModuleCreatorFile.GetSource: String;
var
 FixAncestorClass: string;
begin
 FixAncestorClass:= FAncestorIdent;

 if not SameText(FixAncestorClass, 'TD2BridgeForm') and
    not SameText(FixAncestorClass, 'TDataModule') and
    (FixAncestorClass <> '') then
 begin
  FixAncestorClass:= ClassNameFromAncestorIdent;
 end;



 {$REGION 'D2BridgeForm Properties'}
  if Assigned(D2BridgeWizardFormCreator) then
  begin
   if D2BridgeWizardFormCreator.OptionCreateD2BridgeFormProperties then
   begin
    Result := StringReplace(Result, '<DECLARE_ExportD2Bridge>', '    procedure ExportD2Bridge; override;'#13#10,
      [rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result, '<DECLARE_InitControlsD2Bridge>', '    procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;'#13#10,
      [rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result, '<DECLARE_RenderD2Bridge>', '    procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;'#13#10,
      [rfReplaceAll, rfIgnoreCase]);


    //<METHOD_ExportD2Bridge>
    if D2BridgeWizardFormCreator.OptionCreateD2BridgeCRUDProperties then
    begin
     Result := StringReplace(Result, '<METHOD_ExportD2Bridge>',
       'procedure T<CLASS_ID>.ExportD2Bridge;'#13#10 +
       'begin'#13#10 +
       '  inherited;'#13#10#13#10 +

       '  Title:= ''My D2Bridge Form'';'#13#10 +
       '  SubTitle:= ''Web APP Form'';'#13#10#13#10 +

       '  Crud_PanelTitle.Caption:= ''Title of Card'';'#13#10 +
       '  Crud_PanelSubTitle.Caption:= ''Title inside the card'';'#13#10#13#10 +

       '  //TemplateClassForm:= TD2BridgeFormTemplate;'#13#10 +
       '  //D2Bridge.FrameworkExportType.TemplateMasterHTMLFile := '''';'#13#10 +
       '  //D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '''';'#13#10#13#10 +

       '  with Crud_CardData.Items.Add do'#13#10 +
       '  begin'#13#10 +
       '   { Yours components of tab "Data" }'#13#10 +
       '  end;'#13#10#13#10 +

       '  with Crud_CardData.Footer.Items.Add do'#13#10 +
       '  begin'#13#10 +
       '   { Aditional buttons in Footer }'#13#10 +
       '  end;'#13#10 +

       'end;'#13#10#13#10,
       [rfReplaceAll, rfIgnoreCase]);
    end else
     Result := StringReplace(Result, '<METHOD_ExportD2Bridge>',
       'procedure T<CLASS_ID>.ExportD2Bridge;'#13#10 +
       'begin'#13#10 +
       '  inherited;'#13#10#13#10 +

       '  Title:= ''My D2Bridge Form'';'#13#10#13#10 +

       '  //TemplateClassForm:= TD2BridgeFormTemplate;'#13#10 +
       '  D2Bridge.FrameworkExportType.TemplateMasterHTMLFile := '''';'#13#10 +
       '  D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '''';'#13#10#13#10 +

       '  with D2Bridge.Items.add do'#13#10 +
       '  begin'#13#10 +
       '   {Yours Controls}'#13#10 +
       '  end;'#13#10#13#10 +

       'end;'#13#10#13#10,
       [rfReplaceAll, rfIgnoreCase]);

     //Comment Templates
     if (Assigned(D2BridgeWizardFormCreator.Sender)) and
        (D2BridgeWizardFormCreator.Sender.ClassName = 'TD2BridgeConfigNewInheritedForm') then
     begin
      Result := StringReplace(Result, ' D2Bridge.FrameworkExportType.TemplateMasterHTMLFile := ',  ' //D2Bridge.FrameworkExportType.TemplateMasterHTMLFile := ', []);
      Result := StringReplace(Result, ' D2Bridge.FrameworkExportType.TemplatePageHTMLFile := ',  ' //D2Bridge.FrameworkExportType.TemplatePageHTMLFile := ', []);
     end;



    //<METHOD_InitControlsD2Bridge>
    if D2BridgeWizardFormCreator.OptionCreateD2BridgeCRUDProperties then
    begin
     Result := StringReplace(Result, '<METHOD_InitControlsD2Bridge>',
       'procedure T<CLASS_ID>.InitControlsD2Bridge(const PrismControl: TPrismControl);'#13#10 +
       'begin'#13#10 +
       ' inherited;'#13#10#13#10 +

       ' //Change CRUD Component property'#13#10 +
       ' {'#13#10 +
       '  if PrismControl.VCLComponent = Crud_DBGrid_Search then'#13#10 +
       '  begin'#13#10 +
       '   with PrismControl.AsDBGrid do'#13#10 +
       '   begin'#13#10 +
       '    with Columns.ColumnByIndex(0) do'#13#10 +
       '    begin'#13#10 +
       '     //Example button EDIT invisible'#13#10 +
       '     ButtonFromButtonModel(TButtonModel.Edit).Visible:= false;'#13#10 +
       '     //Example button EDIT disabled'#13#10 +
       '     ButtonFromButtonModel(TButtonModel.Edit).Enabled:= false;'#13#10#13#10 +
       '     //Example Add new Button'#13#10 +
       '     Width:= 105;'#13#10 +
       '     with Buttons.Add do'#13#10 +
       '     begin'#13#10 +
       '      ButtonModel:= TButtonModel.Options;'#13#10 +
       '      Caption:= '''';'#13#10 +
       '     end;'#13#10 +
       '    end;'#13#10 +
       '   end;'#13#10 +
       '  end;'#13#10 +
       ' }'#13#10 +
       'end;'#13#10#13#10,
       [rfReplaceAll, rfIgnoreCase]);
    end else
    begin
     Result := StringReplace(Result, '<METHOD_InitControlsD2Bridge>',
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
       'end;'#13#10#13#10,
       [rfReplaceAll, rfIgnoreCase]);
    end;


    //'<METHOD_RenderD2Bridge>'
    Result := StringReplace(Result, '<METHOD_RenderD2Bridge>',
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
      'end;'#13#10#13#10,
      [rfReplaceAll, rfIgnoreCase]);
   end else
   begin
    //Declare
    Result := StringReplace(Result, '<DECLARE_ExportD2Bridge>', '', [rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result, '<DECLARE_InitControlsD2Bridge>', '', [rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result, '<DECLARE_RenderD2Bridge>', '', [rfReplaceAll, rfIgnoreCase]);

    //Method
    Result := StringReplace(Result, '<METHOD_ExportD2Bridge>', '', [rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result, '<METHOD_InitControlsD2Bridge>', '', [rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result, '<METHOD_RenderD2Bridge>', '', [rfReplaceAll, rfIgnoreCase]);
   end;


   //CRUD Methods
   if D2BridgeWizardFormCreator.OptionCreateD2BridgeCRUDProperties then
   begin
    //Declare
    Result := StringReplace(Result, '<DECLARE_CRUDMethods>',
     '    //CRUD Events'#13#10 +
     '    procedure CrudOnOpen; override;'#13#10 +
     '    procedure CrudOnSearch(AText: string); override;'#13#10 +
     '    function CrudOnEdit: boolean; override;'#13#10 +
     '    function CrudOnInsert: boolean; override;'#13#10 +
     '    function CrudOnSave: boolean; override;'#13#10 +
     '    function CrudOnDelete: boolean; override;'#13#10 +
     '    function CrudOnBack: boolean; override;'#13#10 +
     '    function CrudOnClose: boolean; override;'#13#10,
     [rfReplaceAll, rfIgnoreCase]);

    //Declare
    Result := StringReplace(Result, '<METHOD_CRUDMethods>',
     //CrudOnOpen
     'procedure T<CLASS_ID>.CrudOnOpen;'#13#10 +
     'begin'#13#10 +
     ' inherited;'#13#10#13#10 +
     ' CrudOperation(OpSearch);'#13#10 +
     'end;'#13#10#13#10 +
     //CrudOnOpen
     'procedure T<CLASS_ID>.CrudOnSearch;'#13#10 +
     'begin'#13#10 +
     ' inherited;'#13#10#13#10 +
     ' {'#13#10 +
     '  //Example1'#13#10 +
     '  Crud_Query.Close;'#13#10 +
     '  Crud_Query.Parameters.ParamByName(''Field'').Value:= ''%'' + AText + ''%'';'#13#10 +
     '  Crud_Query.Open;'#13#10#13#10 +
     '  //Example2'#13#10 +
     '   CrudDefaultSearch(''TableName'', ''FieldName'', Crud_EditSearch.Text, ''FiedOrder'');'#13#10#13#10 +
     '  //Example3'#13#10 +
     '  CrudDefaultSearch('#13#10 +
     '   ''TableName'','#13#10 +
     '   [''FieldOne'', ''FieldTwo''], //Search in two fields example'#13#10 +
     '   Crud_EditSearch.Text,'#13#10 +
     '   [''FieldTree = 1'', ''FieldFour = ''''X''''''],'#13#10 +
     '   [''FieldOrder1'', ''FieldOrder2'']'#13#10 +
     '  );'#13#10 +
     ' }'#13#10 +
     'end;'#13#10#13#10 +
     //CrudOnEdit
     'function T<CLASS_ID>.CrudOnEdit: boolean;'#13#10 +
     'begin'#13#10 +
     ' result:= inherited;'#13#10#13#10 +
     ' //Crud_Query.Edit;'#13#10 +
     'end;'#13#10#13#10 +
     //CrudOnInsert
     'function T<CLASS_ID>.CrudOnInsert: boolean;'#13#10 +
     'begin'#13#10 +
     ' result:= inherited;'#13#10#13#10 +
     ' {'#13#10 +
     '  if not Crud_Query.IsEmpty then'#13#10 +
     '  begin'#13#10 +
     '   Crud_Query.Insert;'#13#10 +
     '  end;'#13#10 +
     '  Crud_Query.Edit;'#13#10 +
     ' }'#13#10 +
     'end;'#13#10#13#10 +
     //CrudOnSave
     'function T<CLASS_ID>.CrudOnSave: boolean;'#13#10 +
     'begin'#13#10 +
     ' result:= inherited;'#13#10#13#10 +
     ' //Crud_Query.Edit;'#13#10 +
     ' //Crud_Query.Post;'#13#10 +
     'end;'#13#10#13#10 +
     //CrudOnDelete
     'function T<CLASS_ID>.CrudOnDelete: boolean;'#13#10 +
     'begin'#13#10 +
     ' result:= inherited;'#13#10#13#10 +
     ' //Crud_Query.Edit;'#13#10 +
     ' //Crud_Query.Delete;'#13#10 +
     'end;'#13#10#13#10 +
     //CrudOnBack
     'function T<CLASS_ID>.CrudOnBack: boolean;'#13#10 +
     'begin'#13#10 +
     ' result:= inherited;'#13#10#13#10 +
     'end;'#13#10#13#10 +
     //CrudOnClose
     'function T<CLASS_ID>.CrudOnClose: boolean;'#13#10 +
     'begin'#13#10 +
     ' result:= inherited;'#13#10#13#10 +
     ' //Crud_Query.Close;'#13#10 +
     'end;'#13#10#13#10,
     [rfReplaceAll, rfIgnoreCase]);
   end else
   begin
    //Declare
    Result := StringReplace(Result, '<DECLARE_CRUDMethods>', '', [rfReplaceAll, rfIgnoreCase]);

    //Method
    Result := StringReplace(Result, '<METHOD_CRUDMethods>', '', [rfReplaceAll, rfIgnoreCase]);
   end;
  end;
 {$ENDREGION}



 // Parameterize the code with the current Identifiers
 if FModuleIdent <> '' then
   Result := StringReplace(Result, '<UNITNAME>', FModuleIdent,
     [rfReplaceAll, rfIgnoreCase]);
 if FFormIdent <> '' then
   Result := StringReplace(Result, '<CLASS_ID>', FFormIdent,
     [rfReplaceAll, rfIgnoreCase]);
 if FAncestorIdent <> '' then
   Result := StringReplace(Result, '<ANCESTOR_ID>', FixAncestorClass,
     [rfReplaceAll, rfIgnoreCase]);

 //ServerController UNIT
 Result := StringReplace(Result,'<ServerController>', GetUsesServerControllerName,[rfIgnoreCase]);
end;

{ TFormCreatorModule }

function TFormCreatorModule.GetAncestorName: string;
begin
  Result := 'TD2BridgeForm'
end;

function TFormCreatorModule.GetCreatorType: string;
begin
  Result := sForm;
end;

end.
