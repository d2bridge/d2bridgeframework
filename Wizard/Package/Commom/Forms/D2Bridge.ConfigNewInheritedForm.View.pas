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

unit D2Bridge.ConfigNewInheritedForm.View;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  SysUtils, Variants, Classes, IniFiles, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, Generics.Collections,
{$IFnDEF FPC}
  Winapi.Windows, Winapi.Messages, Vcl.Imaging.pngimage,
  {$IFDEF DESIGNMODE}DesignIntf, ToolsAPI, DesignEditors,{$ENDIF}
{$ELSE}
  LazFileUtils, FileUtil, ProjectIntf, LazIDEIntf, RegExpr,
{$ENDIF}
  D2Bridge.Wizard.Util, D2Bridge.Wizard.Types;

type

  { TD2BridgeConfigNewInheritedForm }

  TD2BridgeConfigNewInheritedForm = class(TForm)
    Panel_Container: TPanel;
    Panel_Left: TPanel;
    Panel_Left_Top: TPanel;
    Image1: TImage;
    Panel_Left_Button: TPanel;
    Label18: TLabel;
    Panel_Client: TPanel;
    Panel_Client_Top: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label_Close: TLabel;
    Label_Wizard_Version: TLabel;
    Panel_Client_Button: TPanel;
    Image_Button_Next: TImage;
    Label_Button_Next: TLabel;
    Panel_Client_Tabs: TPanel;
    Label14: TLabel;
    ComboBox_InheritedForms: TComboBox;
    ComboBox_Create_D2Bridge_Properties: TComboBox;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image_Button_NextClick(Sender: TObject);
    procedure Label_Button_NextClick(Sender: TObject);
    procedure Label_CloseClick(Sender: TObject);
  private
    FFormsInfo: TList<TFormInfo>;
    procedure PopulateFormNames;
    procedure CreateInheritedForm(const BaseFormName: string);
    procedure LoadFromIni;
    procedure SaveToIni;
    function CheckIsCRUD(const BaseFormName: string): boolean;
  public
    EnableCreateInheritedForm: boolean;
    InheritedFormInfo: TFormInfo;

    property FormsInfo: TList<TFormInfo> read FFormsInfo;
  end;

var
  D2BridgeConfigNewInheritedForm: TD2BridgeConfigNewInheritedForm;

implementation

Uses
{$IFDEF FPC}
 D2Bridge.NewInheritedForm.Wizard.FPC;
{$ELSE}
 D2Bridge.NewInheritedForm.Wizard;
{$ENDIF}




{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

{ TForm2 }

{$IFDEF FPC}
function TD2BridgeConfigNewInheritedForm.CheckIsCRUD(const BaseFormName: string): boolean;
begin

end;
{$ELSE}
function TD2BridgeConfigNewInheritedForm.CheckIsCRUD(const BaseFormName: string): boolean;
{$IFnDEF DESIGNMODE}
begin
{$ELSE}
var
 ModServices: IOTAModuleServices;
 Module: IOTAModule;
 ProjectIOTA: IOTAProject;
 vIOTAModuleInfo: IOTAModuleInfo;
 i: Integer;
 vFile: TStringStream;
 vFileContent: string;
 vFileUnit: string;
begin
 Result:= false;

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
     vFileUnit:= ChangeFileExt(vIOTAModuleInfo.FileName, '.pas');

     if FileExists(vFileUnit) then
     begin
      vFile:= TStringStream.Create('', TEncoding.ANSI);
      vFile.LoadFromFile(vFileUnit);
      vFileContent:= vFile.DataString;

      if POS('procedure CrudOnOpen; virtual;', vFileContent) > 0 then
       Result:= true;
      vFile.Free;
     end;

     Break;
    end;
   end;
  end;
 end;
{$ENDIF}
end;
{$ENDIF}

{$IFDEF FPC}
procedure TD2BridgeConfigNewInheritedForm.CreateInheritedForm(const BaseFormName: string);
begin

end;
{$ELSE}
procedure TD2BridgeConfigNewInheritedForm.CreateInheritedForm(const BaseFormName: string);
{$IFnDEF DESIGNMODE}
begin
{$ELSE}
var
  ModServices: IOTAModuleServices;
  vAncestralModule: IOTAModule;
  vFormEditor: IOTAFormEditor;
  vFormCreatorModule: TD2BridgeNewFormModule;
begin
 ModServices := BorlandIDEServices as IOTAModuleServices;

 vFormCreatorModule:= TD2BridgeNewFormModule.Create(BaseFormName);
 vFormCreatorModule.OptionCreateD2BridgeFormProperties:= ComboBox_Create_D2Bridge_Properties.Text = 'Yes';
 if IsVCLProject then
  vFormCreatorModule.OptionCreateD2BridgeCRUDProperties:= CheckIsCRUD(BaseFormName);
 vFormCreatorModule.Sender:= self;

 ModServices.CreateModule(vFormCreatorModule);

 close;
{$ENDIF}
end;
{$ENDIF}

procedure TD2BridgeConfigNewInheritedForm.FormCreate(Sender: TObject);
begin
 EnableCreateInheritedForm:= false;

 Label_Wizard_Version.Caption:= D2BridgeWizardVersionFullToString;
end;

procedure TD2BridgeConfigNewInheritedForm.FormDestroy(Sender: TObject);
begin
 if Assigned(FFormsInfo) then
 FFormsInfo.Free;
end;

procedure TD2BridgeConfigNewInheritedForm.FormShow(Sender: TObject);
begin
 PopulateFormNames;

 LoadFromIni;
end;

procedure TD2BridgeConfigNewInheritedForm.Image_Button_NextClick(Sender:
    TObject);
begin
 Label_Button_Next.OnClick(Label_Button_Next);
end;

procedure TD2BridgeConfigNewInheritedForm.Label_Button_NextClick(
  Sender: TObject);
var
 i: integer;
 UNITFileContent: string;
 vTempFormInfo: TFormInfo;
begin
 if ComboBox_InheritedForms.Text <> '' then
 begin
  SaveToIni;

{$IFDEF FPC}
  //Store choised FormInfo
  for i:= 0 to pred(FFormsInfo.Count) do
  begin
   if SameText(FFormsInfo[I].Name, ComboBox_InheritedForms.Text) then
   begin
    //Checa se é CRUD
    if FileExists(FFormsInfo[I].UnitFileName) then
    begin
     UNITFileContent := ReadFileToString(FFormsInfo[I].UnitFileName);

     if ANSIPOS('procedure CrudOnOpen; virtual;', UNITFileContent) > 0 then
     begin
      vTempFormInfo:= FFormsInfo[I];
      vTempFormInfo.IsCrud:= true;
      FFormsInfo[I] := vTempFormInfo;
     end;
    end;

    InheritedFormInfo:= FFormsInfo[I];
    EnableCreateInheritedForm:= true;
    Close;
    break;
   end;
  end;
{$ELSE}
  CreateInheritedForm(ComboBox_InheritedForms.Text);
{$ENDIF}
 end else
  showmessage('Select the ancestral TD2BridgeForm');
end;

procedure TD2BridgeConfigNewInheritedForm.Label_CloseClick(Sender: TObject);
begin
 self.Close;
end;

procedure TD2BridgeConfigNewInheritedForm.LoadFromIni;
var
 ArqIni: TIniFile;
begin
 ArqIni   := TIniFile.Create(ExtractFilePath(GetModuleName(HInstance))+'Config.ini');

 //----- FORM
 if ComboBox_InheritedForms.Items.IndexOf(ArqIni.ReadString('Config', 'Inherited TD2BridgeForm', '')) >= 0 then
  ComboBox_InheritedForms.ItemIndex:= ComboBox_InheritedForms.Items.IndexOf(ArqIni.ReadString('Config', 'Inherited TD2BridgeForm', ''));

 //----- Inherited Copy Properties
 if ComboBox_Create_D2Bridge_Properties.Items.IndexOf(ArqIni.ReadString('Config', 'Inherited Copy Properties', 'Yes')) >= 0 then
  ComboBox_Create_D2Bridge_Properties.ItemIndex:= ComboBox_Create_D2Bridge_Properties.Items.IndexOf(ArqIni.ReadString('Config', 'Inherited Copy Properties', ''));
 if ComboBox_Create_D2Bridge_Properties.ItemIndex < 0 then
  ComboBox_Create_D2Bridge_Properties.ItemIndex:= 0;

 ArqIni.Free;
end;

{$IFDEF FPC}
procedure TD2BridgeConfigNewInheritedForm.PopulateFormNames;
var
 I: integer;
begin
 FFormsInfo:= FormsInfoFromProject;

 ComboBox_InheritedForms.Clear;

 for I:= 0 to Pred(FFormsInfo.Count) do
  ComboBox_InheritedForms.Items.Add(FFormsInfo[I].Name);
end;
{$ELSE}
procedure TD2BridgeConfigNewInheritedForm.PopulateFormNames;
{$IFnDEF DESIGNMODE}
begin
{$ELSE}
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
{$ENDIF}
end;
{$ENDIF}


procedure TD2BridgeConfigNewInheritedForm.SaveToIni;
var
 ArqIni: TIniFile;
 PathInfi: string;
begin
 PathInfi := ExtractFilePath(GetModuleName(HInstance))+'Config.ini';
 ArqIni   := TIniFile.Create(ExtractFilePath(GetModuleName(HInstance))+'Config.ini');

 //----- FORM
 ArqIni.WriteString('Config', 'Inherited TD2BridgeForm', ComboBox_InheritedForms.Text);

 //----- Inherited Copy Properties
 ArqIni.WriteString('Config', 'Inherited Copy Properties', ComboBox_Create_D2Bridge_Properties.Text);

 ArqIni.Free;
end;

end.
