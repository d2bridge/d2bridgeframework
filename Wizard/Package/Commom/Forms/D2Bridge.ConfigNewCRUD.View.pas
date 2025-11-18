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

unit D2Bridge.ConfigNewCRUD.View;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  SysUtils, Variants, Classes, IniFiles, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, Generics.Collections, Buttons,
{$IFnDEF FPC}
  Winapi.Windows, Winapi.Messages, DesignIntf, ToolsAPI, DesignEditors, Vcl.Imaging.pngimage,
{$ELSE}
  LazFileUtils, FileUtil, ProjectIntf, LazIDEIntf, RegExpr,
{$ENDIF}
  D2Bridge.Wizard.Util, D2Bridge.Wizard.Types;

type

  { TD2BridgeConfigNewCrudForm }

  TD2BridgeConfigNewCrudForm = class(TForm)
    ComboBox_InheritedForms: TComboBox;
    Edit_ClassName: TEdit;
    Edit_ProjectDestination: TEdit;
    Image1: TImage;
    Image_Button_Next: TImage;
    Label1: TLabel;
    Label14: TLabel;
    Label18: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label_Button_Next: TLabel;
    Label_Close: TLabel;
    Label_Wizard_Version: TLabel;
    Panel_Client: TPanel;
    Panel_Client_Button: TPanel;
    Panel_Client_Tabs: TPanel;
    Panel_Client_Top: TPanel;
    Panel_Container: TPanel;
    Panel_Left: TPanel;
    Panel_Left_Button: TPanel;
    Panel_Left_Top: TPanel;
{$IFDEF FPC}
    PathDialog_D2Bridge: TSelectDirectoryDialog;
    SpeedButton_Destination: TSpeedButton;
{$ELSE}
    PathDialog_D2Bridge: TFileOpenDialog;
{$ENDIF}
    procedure Edit_ClassNameExit(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Label_Button_NextClick(Sender: TObject);
    procedure SpeedButton_DestinationClick(Sender: TObject);
    procedure Edit_ProjectDestinationExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label_CloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
{$IFnDEF FPC}
    procedure InheritedInfo(BaseFormName: string; var AClassName: string; var AUnitName: string);
{$ELSE}
    FFormsInfo: TList<TFormInfo>;
{$ENDIF}
    procedure PopulateFormNames;
  public
    FClassInherited: string;
    FUnitInherited: string;
    EnableCreateCRUD: boolean;
  end;

var
  D2BridgeConfigNewCrudForm: TD2BridgeConfigNewCrudForm;

implementation


{$IFnDEF FPC}
  {$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}
{$ELSE}
  {$R *.lfm}
{$ENDIF}


procedure TD2BridgeConfigNewCrudForm.Edit_ClassNameExit(Sender: TObject);
begin
 if Edit_ClassName.Text <> '' then
 if Copy(Edit_ClassName.Text, 1, 1) <> 'T' then
  Edit_ClassName.Text:= 'T'+ Edit_ClassName.Text;
end;

procedure TD2BridgeConfigNewCrudForm.FormDestroy(Sender: TObject);
begin
 {$IFDEF FPC}
 if Assigned(FFormsInfo) then
  FFormsInfo.Free;
 {$ENDIF}
end;

procedure TD2BridgeConfigNewCrudForm.Edit_ProjectDestinationExit(
  Sender: TObject);
begin
 Edit_ProjectDestination.Text:= IncludeTrailingPathDelimiter(Edit_ProjectDestination.Text);
end;

procedure TD2BridgeConfigNewCrudForm.FormCreate(Sender: TObject);
begin
 EnableCreateCRUD:= false;

 Label_Wizard_Version.Caption:= D2BridgeWizardVersionFullToString;
end;

procedure TD2BridgeConfigNewCrudForm.FormShow(Sender: TObject);
begin
 ComboBox_InheritedForms.Clear;

 PopulateFormNames;

 Edit_ClassName.Text:= 'TFormCrudTemplate';
 Edit_ProjectDestination.Text:= IncludeTrailingPathDelimiter(ExtractFileDir({$IFDEF FPC}LazarusIDE.ActiveProject.MainFile.Filename{$ELSE}GetCurrentProject.FileName{$ENDIF}));

 PathDialog_D2Bridge.{$IFDEF FPC}InitialDir{$ELSE}DefaultFolder{$ENDIF}:= Edit_ProjectDestination.Text;
end;

{$IFnDEF FPC}
procedure TD2BridgeConfigNewCrudForm.InheritedInfo(BaseFormName: string; var AClassName, AUnitName: string);
var
 ModServices: IOTAModuleServices;
 Module: IOTAModule;
 vFormModule: IOTAModule;
 ProjectIOTA: IOTAProject;
 vIOTAModuleInfo: IOTAModuleInfo;
 i, j: Integer;
 vFile: TStringStream;
 vFileContent: string;
 vFileUnit: string;
 vFormEditor: IOTAFormEditor;
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

    if (vIOTAModuleInfo.FormName = BaseFormName) then
    begin
     AUnitName:= ChangeFileExt(ExtractFileName(vIOTAModuleInfo.FileName), '');

     vFormModule:= vIOTAModuleInfo.OpenModule;
     if Assigned(vFormModule) then
     begin
      for j := 0 to vFormModule.GetModuleFileCount - 1 do
      if Supports(vFormModule.ModuleFileEditors[j], IOTAFormEditor, vFormEditor) then
      begin
       AClassName:= vFormEditor.GetRootComponent.GetComponentType;
       Break;
      end;
     end;

     Break;
    end;
   end;
  end;
 end;
end;
{$ENDIF}

procedure TD2BridgeConfigNewCrudForm.Label_Button_NextClick(
  Sender: TObject);
var
 I: integer;
begin
 if Edit_ClassName.Text = '' then
 begin
  ShowMessage('Class name is empty');
  exit;
 end;

 if Edit_ProjectDestination.Text = '' then
 begin
  ShowMessage('Destination invalid');
  exit;
 end;

 Edit_ClassNameExit(Edit_ClassName);

 if (Edit_ClassName.Text = '') or (UpperCase(Edit_ClassName.Text) = 'T') then
 begin
  showmessage('Enter class name');
  Edit_ClassName.SetFocus;
  exit;
 end;

 if ComboBox_InheritedForms.Text <> '' then
 begin
{$IFDEF FPC}
  //Check ClassName duplicate
  for i:= 0 to pred(FFormsInfo.Count) do
  begin
   if SameText(FFormsInfo[I].ClassName, Edit_ClassName.Text) then
   begin
    Showmessage('A class with this name already exists in your project!');
    EnableCreateCRUD:= false;
    exit;
    break;
   end;
  end;

  //Store choised FormInfo
  for i:= 0 to pred(FFormsInfo.Count) do
  begin
   if SameText(FFormsInfo[I].Name, ComboBox_InheritedForms.Text) then
   begin
    FUnitInherited:= FFormsInfo[I].UnitName;
    FClassInherited:= FFormsInfo[I].ClassName;
    EnableCreateCRUD:= true;
    break;
   end;
  end;
{$ELSE}
  InheritedInfo(ComboBox_InheritedForms.Text, FClassInherited, FUnitInherited);
{$ENDIF}
 end;

 EnableCreateCRUD:= true;

 self.Close;

end;

procedure TD2BridgeConfigNewCrudForm.Label_CloseClick(Sender: TObject);
begin
 close;
end;

{$IFDEF FPC}
procedure TD2BridgeConfigNewCrudForm.PopulateFormNames;
var
 I: integer;
begin
 FFormsInfo:= FormsInfoFromProject;

 ComboBox_InheritedForms.Clear;

 for I:= 0 to Pred(FFormsInfo.Count) do
  ComboBox_InheritedForms.Items.Add(FFormsInfo[I].Name);
end;
{$ELSE}
procedure TD2BridgeConfigNewCrudForm.PopulateFormNames;
var
 ModServices: IOTAModuleServices;
 Module: IOTAModule;
 ProjectIOTA: IOTAProject;
 vIOTAModuleInfo: IOTAModuleInfo;
 i: Integer;
begin
 ComboBox_InheritedForms.Clear;

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
     ComboBox_InheritedForms.Items.Add(vIOTAModuleInfo.FormName);
    end;
   end;
  end;
 end;
end;
{$ENDIF}

procedure TD2BridgeConfigNewCrudForm.SpeedButton_DestinationClick(Sender: TObject);
begin
 PathDialog_D2Bridge.{$IFDEF FPC}InitialDir{$ELSE}DefaultFolder{$ENDIF}:= Edit_ProjectDestination.Text;

 if PathDialog_D2Bridge.Execute then
 begin
  Edit_ProjectDestination.Text := PathDialog_D2Bridge.FileName;
 end;
end;

end.
