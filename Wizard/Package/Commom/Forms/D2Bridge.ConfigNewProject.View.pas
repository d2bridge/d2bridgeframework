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

unit D2Bridge.ConfigNewProject.View;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

Uses
  SysUtils, Variants, Classes, IniFiles,
{$IFDEF DESIGNMODE}
{$IFDEF FPC}
  LazIDEIntf,
{$ENDIF}
{$ENDIF}
{$IFDEF FPC}
  LCLType, LMessages, LResources, LCLProc, LCLClasses, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ComCtrls, CheckLst, fpjson, jsonparser, regexpr, LCLintf,
  FileUtil,
{$IFDEF WINDOWS}
  //ShellApi,
{$ENDIF}
{$ELSE}
  Winapi.Messages, Winapi.Windows, Winapi.ShellAPI, System.RegularExpressions, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Imaging.pngimage, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Buttons, Vcl.CheckLst, System.IOUtils,
  System.JSON,
{$ENDIF}
  D2Bridge.Wizard.Templates, D2Bridge.Wizard.Util;

type

  { TD2BridgeConfigNewProject }

  TD2BridgeConfigNewProject = class(TForm)
    Panel_Left: TPanel;
    Panel_Client: TPanel;
    Panel_Left_Top: TPanel;
    Image1: TImage;
    Panel_Left_Button: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel_Client_Top: TPanel;
    Panel_Client_Button: TPanel;
    Panel_Client_Tabs: TPanel;
{$IFDEF FPC}
    PathDialog_D2Bridge: TSelectDirectoryDialog;
{$ELSE}
    PathDialog_D2Bridge: TFileOpenDialog;
{$ENDIF}
    Label1: TLabel;
    Label2: TLabel;
    Image_Button_Next: TImage;
    Image_Button_Back: TImage;
    Label_Button_Next: TLabel;
    Label_Button_Back: TLabel;
    Image_Status_Options: TImage;
    Label_Status_Options: TLabel;
    Panel6: TPanel;
    Image_Status_UseSSL: TImage;
    Label_Status_UseSSL: TLabel;
    Panel7: TPanel;
    Image_Status_Template: TImage;
    Label_Status_Template: TLabel;
    Panel8: TPanel;
    Image_Status_Initial_Config: TImage;
    Label_Status_Initial_Config: TLabel;
    Image_Example_Status_None: TImage;
    Image_Example_Status_Checked: TImage;
    Image_Example_Status_Working: TImage;
    Image_Example_Status_Error: TImage;
    Label_Close: TLabel;
    Panel9: TPanel;
    Image_Status_Path_Framework: TImage;
    Label_Status_Path_Framework: TLabel;
    Label18: TLabel;
    Label_Wizard_Version: TLabel;
    Panel11: TPanel;
    Image_Status_Language: TImage;
    Label_Status_Language: TLabel;
    Panel_Container: TPanel;
    PageControl1: TPageControl;
    TabSheet5: TTabSheet;
    Panel10: TPanel;
    Label24: TLabel;
    SpeedButton4: TSpeedButton;
    Label_Path_D2Bridge: TLabel;
    Edit_Path_D2Bridge: TEdit;
    TabSheet1: TTabSheet;
    Panel_Tab1: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    SpeedButton_Destination: TSpeedButton;
    Label8: TLabel;
    Label14: TLabel;
    Label25: TLabel;
    Label15: TLabel;
    Edit_ProjectDestination: TEdit;
    ComboBox_Server_Type: TComboBox;
    Edit_Server_Port: TEdit;
    Edit_ProjectName: TEdit;
    Edit_Server_Name: TEdit;
    CheckBox_Create_Project_Folder: TCheckBox;
    ComboBox_Platform: TComboBox;
    CheckBox_Add_Project_Platform: TCheckBox;
    TabSheet2: TTabSheet;
    Panel3: TPanel;
    Label9: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label4: TLabel;
    Label_Template_Site: TLabel;
    Label21: TLabel;
    Label_Template_Licence: TLabel;
    Label_Template_Description: TLabel;
    Label26: TLabel;
    ComboBox_Template: TComboBox;
    Edit_Template_Maste_Page: TEdit;
    Edit_Template_Page: TEdit;
    ScrollBox1: TScrollBox;
    Image_Template: TImage;
    TabSheet6: TTabSheet;
    Panel12: TPanel;
    Label7: TLabel;
    Image2: TImage;
    Image_SideBar: TImage;
    RadioButton_Menu_SideBar: TRadioButton;
    RadioButton_Menu_Top: TRadioButton;
    TabSheet3: TTabSheet;
    Panel4: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    SpeedButton1: TSpeedButton;
    Label13: TLabel;
    SpeedButton3: TSpeedButton;
    Label12: TLabel;
    SpeedButton2: TSpeedButton;
    ComboBox_UseSSL: TComboBox;
    Edit_SSL_Certificate: TEdit;
    Edit_SSL_Intermediate: TEdit;
    Edit_SSL_Key: TEdit;
    TabSheet_Language: TTabSheet;
    Panel_Language: TPanel;
    Label27: TLabel;
    Label28: TLabel;
    Label_Select_Language: TLabel;
    Label_Select_Language_All: TLabel;
    Label_Select_Language_None: TLabel;
    Label_Embed_Tranlation_Files: TLabel;
    Label_About_Embed_Translation_Files: TLabel;
    ComboBox_Language: TComboBox;
    ComboBox_Enabled_Multi_Languages: TComboBox;
    CheckListBox_Languages: TCheckListBox;
    ComboBox_Embed_Translation_Files: TComboBox;
    TabSheet4: TTabSheet;
    Panel5: TPanel;
    Label16: TLabel;
    Label17: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label3: TLabel;
    Label_Select_ThirdParty_All: TLabel;
    Label_Select_ThirdParty_None: TLabel;
    ComboBox_Option_JQuery: TComboBox;
    ComboBox_Option_BootStrap: TComboBox;
    Edit_Path_CSS: TEdit;
    Edit_Path_JS: TEdit;
    CheckListBox_ThirdParty: TCheckListBox;
    CheckBox_FormDashboard: TCheckBox;
    CheckBox_SignUp: TCheckBox;
    CheckBox_Form_Login: TCheckBox;
    Label29: TLabel;
    Panel13: TPanel;
    Image_Status_NativeLayout: TImage;
    Label_Status_NativeLayout: TLabel;
    Image_Button_Licence: TImage;
    Label_Button_Licence: TLabel;
    Label30: TLabel;
    ComboBox_RestAPIServer: TComboBox;
    CheckBox_RestAPIServer_UseClass: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure Label_CloseClick(Sender: TObject);
    procedure Image_Button_NextClick(Sender: TObject);
    procedure Image_Button_BackClick(Sender: TObject);
    procedure Label_Button_BackClick(Sender: TObject);
    procedure Label_Button_NextClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ComboBox_TemplateSelect(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure Label_Template_SiteClick(Sender: TObject);
    procedure Edit_ProjectNameExit(Sender: TObject);
    procedure SpeedButton_DestinationClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure ComboBox_Enabled_Multi_LanguagesChange(Sender: TObject);
    procedure ComboBox_LanguageChange(Sender: TObject);
    procedure Label_Select_Language_NoneClick(Sender: TObject);
    procedure Label_Select_Language_AllClick(Sender: TObject);
    procedure Label_Select_ThirdParty_AllClick(Sender: TObject);
    procedure Label_Select_ThirdParty_NoneClick(Sender: TObject);
    procedure ComboBox_PlatformChange(Sender: TObject);
    procedure Image_Button_LicenceClick(Sender: TObject);
    procedure Label_Button_LicenceClick(Sender: TObject);
  private
    FEnableCreateProject: Boolean;
    FCloseAPP: Boolean;
    FTemplates: TD2BridgeTemplates;
    FJSOND2BridgeWizard: TJSONObject;
    FJSONArrayTemplates: TJSONArray;
    procedure LoadAvailableLanguages;
    procedure Popule_ComboBox_Platform;
    procedure AjustarQuebraDeLinha(ALabel: TLabel);
    function isProjectNameValid: Boolean;
    procedure CheckValidD2BridgePath(var ACheckPath: String; out ACheckedValidPath: String);
    function isValidatePageSheet: Boolean;
    function isValidD2BridgePath: Boolean;
    procedure PopulateTemplates;
    Procedure Check_Status_Components;
    Procedure LoadJSOND2BridgeWizard;
    procedure LoadFromIni;
    procedure SaveToIni;
  public
    property EnableCreateProject: Boolean read FEnableCreateProject;

    property TemplatesList: TD2BridgeTemplates read FTemplates;
  end;

var
  D2BridgeConfigNewProject: TD2BridgeConfigNewProject;

implementation

{$IFDEF FPC}
   {$R *.lfm}
{$ELSE}
   {$R *.dfm}
{$ENDIF}

procedure TD2BridgeConfigNewProject.AjustarQuebraDeLinha(ALabel: TLabel);
var
  DC: HDC;
  TextoOriginal, TextoModificado, TextoLinha: string;
  TamanhoMaximo, LarguraAtual, i: Integer;
begin
{$IFNDEF FPC}
  // Armazenar o texto original
  TextoOriginal := ALabel.Caption;

  // Definir o tamanho máximo desejado (largura do Label)
  TamanhoMaximo := ALabel.Width;

  // Inicializar o texto modificado
  TextoModificado := '';

  // Obter um dispositivo de contexto de dispositivo para medir a largura do texto
  DC := GetDC(0);
  try
    // Inicializar a largura atual
    LarguraAtual := 0;
    TextoLinha:= '';

    // Processar o texto original
    for i := 1 to Length(TextoOriginal) do
    begin
      // Adicionar caractere ao texto modificado
      TextoModificado := TextoModificado + TextoOriginal[i];
      TextoLinha:= TextoLinha + TextoOriginal[i];

      // Medir a largura atual do texto considerando a escala de DPI
      LarguraAtual := MulDiv(Canvas.TextWidth(TextoLinha), GetDeviceCaps(DC, LOGPIXELSX), 96);

      // Se atingir o tamanho máximo, adicionar quebra de linha
      if (LarguraAtual >= TamanhoMaximo) and (i < Length(TextoOriginal)) then
      begin
        TextoModificado := TextoModificado + #13#10;
        TextoLinha:= '';
      end;
    end;
  finally
    // Liberar o dispositivo de contexto do dispositivo
    ReleaseDC(0, DC);
  end;

  // Atualizar o texto do Label com as quebras de linha
  ALabel.Caption := TextoModificado;
{$ENDIF}
end;

procedure TD2BridgeConfigNewProject.CheckValidD2BridgePath(var ACheckPath: String; out ACheckedValidPath: String);
var
 vFile, vFolder: string;
begin
 vFile:= 'D2Bridge.BaseClass.pas';
 vFolder:= 'D2Bridge Framework';

{$IFDEF FPC}
  vFile := ConcatPaths([ACheckPath, vFile]);
  vFolder := ConcatPaths([ACheckPath, vFolder]);
{$ELSE}
  vFile := TPath.Combine(ACheckPath, vFile);
  vFolder := TPath.Combine(ACheckPath, vFolder);
{$ENDIF}

 if FileExists(vFile) then
 begin
  ACheckedValidPath:= ACheckPath;
 end else
 begin
  if DirectoryExists(vFolder) then
  ACheckedValidPath:= vFolder;
 end;
end;

procedure TD2BridgeConfigNewProject.Check_Status_Components;
begin
 Label_Button_Next.Caption:= 'Next';
 Image_Status_Path_Framework.Picture.Assign(Image_Example_Status_None.Picture);
 Image_Status_Initial_Config.Picture.Assign(Image_Example_Status_None.Picture);
 Image_Status_Template.Picture.Assign(Image_Example_Status_None.Picture);
 Image_Status_UseSSL.Picture.Assign(Image_Example_Status_None.Picture);
 Image_Status_Language.Picture.Assign(Image_Example_Status_None.Picture);
 Image_Status_Options.Picture.Assign(Image_Example_Status_None.Picture);
 Image_Status_NativeLayout.Picture.Assign(Image_Example_Status_None.Picture);
 Label_Status_Path_Framework.Font.Style:= [];
 Label_Status_Initial_Config.Font.Style:= [];
 Label_Status_Template.Font.Style:= [];
 Label_Status_UseSSL.Font.Style:= [];
 Label_Status_Language.Font.Style:= [];
 Label_Status_Options.Font.Style:= [];
 Label_Status_NativeLayout.Font.Style:= [];

 if PageControl1.ActivePageIndex = 0 then //Path Framework
 begin
  Image_Button_Back.Visible:= false;

  Image_Status_Path_Framework.Picture.Assign(Image_Example_Status_Working.Picture);
  Label_Status_Path_Framework.Font.Style:= [fsbold];
 end else
 if PageControl1.ActivePageIndex = 1 then //Initial
 begin
  Label_Wizard_Version.Caption:= D2BridgeWizardVersionFullToString;

  LoadAvailableLanguages;

  Image_Button_Back.Visible:= true;

  Edit_ProjectDestination.SelStart:= 0;

  //Path Framework
  Image_Status_Path_Framework.Picture.Assign(Image_Example_Status_Checked.Picture);
  Label_Status_Path_Framework.Font.Style:= [];
  //Status Initial
  Image_Status_Initial_Config.Picture.Assign(Image_Example_Status_Working.Picture);
  Label_Status_Initial_Config.Font.Style:= [fsbold];
 end else
 if PageControl1.ActivePageIndex = 2 then //Template
 begin
  Image_Button_Back.Visible:= true;

  //Path Framework
  Image_Status_Path_Framework.Picture.Assign(Image_Example_Status_Checked.Picture);
  Label_Status_Path_Framework.Font.Style:= [];
  //Status Initial
  Image_Status_Initial_Config.Picture.Assign(Image_Example_Status_Checked.Picture);
  Label_Status_Initial_Config.Font.Style:= [];
  //Template
  Image_Status_Template.Picture.Assign(Image_Example_Status_Working.Picture);
  Label_Status_Template.Font.Style:= [fsbold];
 end else
  if PageControl1.ActivePageIndex = 3 then //Native Layout
 begin
  Image_Button_Back.Visible:= true;

  //Path Framework
  Image_Status_Path_Framework.Picture.Assign(Image_Example_Status_Checked.Picture);
  Label_Status_Path_Framework.Font.Style:= [];
  //Status Initial
  Image_Status_Initial_Config.Picture.Assign(Image_Example_Status_Checked.Picture);
  Label_Status_Initial_Config.Font.Style:= [];
  //Template
  Image_Status_Template.Picture.Assign(Image_Example_Status_Checked.Picture);
  Label_Status_Template.Font.Style:= [];
  //NativeLayout
  Image_Status_NativeLayout.Picture.Assign(Image_Example_Status_Working.Picture);
  Label_Status_NativeLayout.Font.Style:= [fsbold];
 end else
 if PageControl1.ActivePageIndex = 4 then //Use SSL
 begin
  Image_Button_Back.Visible:= true;

  //Path Framework
  Image_Status_Path_Framework.Picture.Assign(Image_Example_Status_Checked.Picture);
  Label_Status_Path_Framework.Font.Style:= [];
  //Status Initial
  Image_Status_Initial_Config.Picture.Assign(Image_Example_Status_Checked.Picture);
  Label_Status_Initial_Config.Font.Style:= [];
  //Template
  Image_Status_Template.Picture.Assign(Image_Example_Status_Checked.Picture);
  Label_Status_Template.Font.Style:= [];
  //NativeLayout
  Image_Status_NativeLayout.Picture.Assign(Image_Example_Status_Checked.Picture);
  Label_Status_NativeLayout.Font.Style:= [];
  //USE SSL
  Image_Status_UseSSL.Picture.Assign(Image_Example_Status_Working.Picture);
  Label_Status_UseSSL.Font.Style:= [fsBold];
 end else
 if PageControl1.ActivePageIndex = 5 then //Language
 begin
  Image_Button_Back.Visible:= true;

  //Path Framework
  Image_Status_Path_Framework.Picture.Assign(Image_Example_Status_Checked.Picture);
  Label_Status_Path_Framework.Font.Style:= [];
  //Status Initial
  Image_Status_Initial_Config.Picture.Assign(Image_Example_Status_Checked.Picture);
  Label_Status_Initial_Config.Font.Style:= [];
  //Template
  Image_Status_Template.Picture.Assign(Image_Example_Status_Checked.Picture);
  Label_Status_Template.Font.Style:= [];
  //NativeLayout
  Image_Status_NativeLayout.Picture.Assign(Image_Example_Status_Checked.Picture);
  Label_Status_NativeLayout.Font.Style:= [];
  //USE SSL
  Image_Status_UseSSL.Picture.Assign(Image_Example_Status_Checked.Picture);
  Label_Status_UseSSL.Font.Style:= [];
  //USE LANGUAGE
  Image_Status_Language.Picture.Assign(Image_Example_Status_Working.Picture);
  Label_Status_Language.Font.Style:= [fsBold];
 end else
 if PageControl1.ActivePageIndex = 6 then //Config
 begin
  Image_Button_Back.Visible:= true;

  //Path Framework
  Image_Status_Path_Framework.Picture.Assign(Image_Example_Status_Checked.Picture);
  Label_Status_Path_Framework.Font.Style:= [];
  //Status Initial
  Image_Status_Initial_Config.Picture.Assign(Image_Example_Status_Checked.Picture);
  Label_Status_Initial_Config.Font.Style:= [];
  //Template
  Image_Status_Template.Picture.Assign(Image_Example_Status_Checked.Picture);
  Label_Status_Template.Font.Style:= [];
  //NativeLayout
  Image_Status_NativeLayout.Picture.Assign(Image_Example_Status_Checked.Picture);
  Label_Status_NativeLayout.Font.Style:= [];
  //USE SSL
  Image_Status_UseSSL.Picture.Assign(Image_Example_Status_Checked.Picture);
  Label_Status_UseSSL.Font.Style:= [];
  //USE LANGUAGE
  Image_Status_Language.Picture.Assign(Image_Example_Status_Checked.Picture);
  Label_Status_Language.Font.Style:= [];
  //Options
  Image_Status_Options.Picture.Assign(Image_Example_Status_Working.Picture);
  Label_Status_Options.Font.Style:= [fsBold];
 end;


 Label_Button_Back.Visible:= Image_Button_Back.Visible;
 Label_Button_Next.Visible:= Image_Button_Next.Visible;

 if PageControl1.ActivePageIndex = Pred(PageControl1.PageCount) then
  Label_Button_Next.Caption:= 'Done';
end;

procedure TD2BridgeConfigNewProject.ComboBox_Enabled_Multi_LanguagesChange(
  Sender: TObject);
begin
 if ComboBox_Enabled_Multi_Languages.Text = 'No' then
 begin
  Label_Select_Language.Visible:= false;
  Label_Select_Language_All.Visible:= false;
  Label_Select_Language_None.Visible:= false;
  Label_About_Embed_Translation_Files.Visible:= false;
  CheckListBox_Languages.Visible:= false;
  Label_Embed_Tranlation_Files.Visible:= false;
  ComboBox_Embed_Translation_Files.Visible:= false;
 end else
 begin
  ComboBox_LanguageChange(ComboBox_Language);
  Label_Select_Language.Visible:= true;
  Label_Select_Language_All.Visible:= true;
  Label_Select_Language_None.Visible:= true;
  Label_About_Embed_Translation_Files.Visible:= true;
  CheckListBox_Languages.Visible:= true;
  Label_Embed_Tranlation_Files.Visible:= true;
  ComboBox_Embed_Translation_Files.Visible:= true;
 end;

end;

procedure TD2BridgeConfigNewProject.ComboBox_LanguageChange(Sender: TObject);
var
 I: integer;
begin
 CheckListBox_Languages.CheckAll(cbUnchecked);

 for I := 0 to Pred(CheckListBox_Languages.Count) do
  CheckListBox_Languages.ItemEnabled[I]:= true;

 CheckListBox_Languages.Checked[CheckListBox_Languages.Items.IndexOf(ComboBox_Language.Text)]:= true;
 CheckListBox_Languages.ItemEnabled[CheckListBox_Languages.Items.IndexOf(ComboBox_Language.Text)]:= false;
end;

procedure TD2BridgeConfigNewProject.ComboBox_PlatformChange(Sender: TObject);
begin
 if POS('VCL', ComboBox_Platform.Text) > 0 then
 begin
  CheckBox_Add_Project_Platform.Caption:= 'Add VCL Project';
 end else
 if POS('LCL', ComboBox_Platform.Text) > 0 then
 begin
  CheckBox_Add_Project_Platform.Caption:= 'Add LCL Project';
 end else
 begin
  CheckBox_Add_Project_Platform.Caption:= 'Add Firemonkey Project';
 end;

 Popule_ComboBox_Platform;
end;

procedure TD2BridgeConfigNewProject.ComboBox_TemplateSelect(Sender: TObject);
var
 vPathImage: String;
begin
 with FTemplates.Items[ComboBox_Template.ItemIndex] do
 begin
  Label_Template_Site.Caption:= Site;
  AjustarQuebraDeLinha(Label_Template_Site);
  Label_Template_Licence.Caption:= Licence;
  Label_Template_Description.Caption:= Description;

  ScrollBox1.HorzScrollBar.Position:= 0;
  ScrollBox1.VertScrollBar.Position:= 0;

  vPathImage:= IncludeTrailingPathDelimiter(ExtractFileDir(ExcludeTrailingPathDelimiter(Edit_Path_D2Bridge.Text))) + 'Wizard';

  Image_Template.Picture.LoadFromFile(GetRealFilePath(IncludeTrailingPathDelimiter(vPathImage) + PathImage));
  Edit_Template_Maste_Page.Text:= MasterPageHTML;
  Edit_Template_Page.Text:= PageHTML;
 end;
end;

procedure TD2BridgeConfigNewProject.Edit_ProjectNameExit(Sender: TObject);
begin
 isProjectNameValid;
end;

procedure TD2BridgeConfigNewProject.FormCreate(Sender: TObject);
begin
 PageControl1.Visible:= false;

 FEnableCreateProject:= false;

 ComboBox_Platform.Clear;
{$IFDEF FPC}
 ComboBox_Platform.Items.text:= 'LCL for WEB';
{$ELSE}
 ComboBox_Platform.Clear;
 ComboBox_Platform.Items.Add('VCL for WEB');
 ComboBox_Platform.Items.Add('FMX for WEB');
{$ENDIF}


 LoadFromIni;
 FCloseAPP:= false;
 ComboBox_Template.Clear;

 if isValidD2BridgePath then
 begin
  LoadJSOND2BridgeWizard;

  LoadAvailableLanguages;

  PageControl1.ActivePageIndex:= 1;
 end else
 PageControl1.ActivePageIndex:= 0;

 TPanel(PageControl1.ActivePage.Controls[0]).Parent:= Panel_Client_Tabs;

 Label_Wizard_Version.Caption:= D2BridgeWizardVersionFullToString;
end;

procedure TD2BridgeConfigNewProject.FormDestroy(Sender: TObject);
begin
 FreeAndNil(FTemplates);
end;

procedure TD2BridgeConfigNewProject.FormShow(Sender: TObject);
begin
 Check_Status_Components;

 ComboBox_PlatformChange(ComboBox_Platform);

 if FCloseAPP then
 Close;
end;

procedure TD2BridgeConfigNewProject.Image_Button_BackClick(Sender: TObject);
begin
 SetFocus;

 Panel_Client_Tabs.Controls[0].Parent:= PageControl1.ActivePage;

 if (PageControl1.ActivePageIndex = 4) and (ComboBox_Template.Text <> 'None') then
 begin
  PageControl1.ActivePageIndex:= PageControl1.ActivePageIndex - 2;
 end else
 begin
  PageControl1.ActivePageIndex:= PageControl1.ActivePageIndex - 1;
 end;

 TPanel(PageControl1.ActivePage.Controls[0]).Parent:= Panel_Client_Tabs;

 SaveToIni;

 Check_Status_Components;
end;

procedure TD2BridgeConfigNewProject.Image_Button_LicenceClick(Sender: TObject);
var
 vMSG: string;
begin

vMSG:=
  '+--------------------------------------------------------------------------+'+sLineBreak+
  ' D2Bridge Framework Content                                                 '+sLineBreak+
  '                                                                            '+sLineBreak+
  ' Author: Talis Jonatas Gomes                                                '+sLineBreak+
  ' Email: talisjonatas@me.com                                                 '+sLineBreak+
  '                                                                            '+sLineBreak+
  ' Copyright (c) 2024 Talis Jonatas Gomes - talisjonatas@me.com               '+sLineBreak+
  ' Intellectual property of computer programs protected by international and  '+sLineBreak+
  ' brazilian (9.609/1998) laws.                                               '+sLineBreak+
  ' Software licensed under "opensource" license.                              '+sLineBreak+
  '                                                                            '+sLineBreak+
  ' Rules:                                                                     '+sLineBreak+
  ' Everone is permitted to copy and distribute verbatim copies of this license'+sLineBreak+
  ' document, but changing it is not allowed.                                  '+sLineBreak+
  '                                                                            '+sLineBreak+
  ' This source code is provided "as-is", without any express or implied       '+sLineBreak+
  ' warranty. In no event will the author be held liable for any damages       '+sLineBreak+
  ' arising from the use of this code.                                         '+sLineBreak+
  '                                                                            '+sLineBreak+
  ' However, it is granted that this code may be used for any purpose,         '+sLineBreak+
  ' including commercial applications, but it may not be modified,             '+sLineBreak+
  ' distributed, or sublicensed without express written authorization from     '+sLineBreak+
  ' the author (Talis Jonatas Gomes). This includes creating derivative works  '+sLineBreak+
  ' or distributing the source code through any means.                         '+sLineBreak+
  '                                                                            '+sLineBreak+
  ' If you use this software in a product, an acknowledgment in the product    '+sLineBreak+
  ' documentation would be appreciated but is not required.                    '+sLineBreak+
  '                                                                            '+sLineBreak+
  ' God bless you                                                              '+sLineBreak+
  '+--------------------------------------------------------------------------+';

  ShowMessage(vMSG);

end;

procedure TD2BridgeConfigNewProject.Image_Button_NextClick(Sender: TObject);
begin
 SetFocus;

 if isValidatePageSheet then
 begin
  if PageControl1.ActivePageIndex = Pred(PageControl1.PageCount) then
  begin
   FEnableCreateProject:= true;
   SaveToIni;
   close;
   Exit;
  end else
  begin
   Panel_Client_Tabs.Controls[0].Parent:= PageControl1.ActivePage;

   if (PageControl1.ActivePageIndex = 2) and (ComboBox_Template.Text <> 'None') then
   begin
    PageControl1.ActivePageIndex:= PageControl1.ActivePageIndex + 2;
   end else
   begin
    PageControl1.ActivePageIndex:= PageControl1.ActivePageIndex + 1;
   end;

   TPanel(PageControl1.ActivePage.Controls[0]).Parent:= Panel_Client_Tabs;
  end;

  SaveToIni;

  Check_Status_Components;
 end;
end;

function TD2BridgeConfigNewProject.isValidatePageSheet: Boolean;
begin
 Result:= true;

 {$REGION 'Path Framework'}
  //Fix \ end path
  if Edit_Path_D2Bridge.Text <> '' then
   Edit_Path_D2Bridge.Text:= IncludeTrailingPathDelimiter(Edit_Path_D2Bridge.Text);

  if PageControl1.ActivePageIndex = 0 then
  begin
   //----- CHECK PATH D2BRIDGE
   if not isValidD2BridgePath then
   begin
    Result:= false;
    MessageDlg(Label_Path_D2Bridge.Caption, mterror, [mbok], 0);
   end else
    LoadJSOND2BridgeWizard;
  end;
 {$ENDREGION}

 {$REGION 'Initial Config'}
  if PageControl1.ActivePageIndex = 1 then
  begin
   //----- PROJECT NAME
   if not isProjectNameValid then
   begin
    Result:= false;
    MessageDlg('Check Project Name', mterror, [mbok], 0);
    Exit;
   end;

   //----- PROJECT NAME DUPLICATE
   if CheckBox_Create_Project_Folder.Checked then
    Edit_ProjectDestination.Text:= IncludeTrailingPathDelimiter(Edit_ProjectDestination.Text)
   else
    Edit_ProjectDestination.Text:= ExcludeTrailingBackslash(Edit_ProjectDestination.Text);
   if (CheckBox_Create_Project_Folder.Checked) and DirectoryExists(Edit_ProjectDestination.Text+Edit_ProjectName.Text) then
   begin
     Result:= false;
     MessageDlg('The project name already exists in the destination folder', mterror, [mbok], 0);
     Edit_ProjectName.SetFocus;
     Exit;
   end;

   //----- DESTINATION PATH
   if not DirectoryExists(Edit_ProjectDestination.Text) then
   begin
    Result:= false;
    MessageDlg('Check Project Destination Path', mterror, [mbok], 0);
    Edit_ProjectDestination.SetFocus;
    Exit;
   end;

   if StrToInt(Edit_Server_Port.Text) <= 0 then
   begin
    Result:= false;
    MessageDlg('Check Port Server number', mterror, [mbok], 0);
    Exit;
   end;
  end;
 {$ENDREGION}

end;

function TD2BridgeConfigNewProject.isValidD2BridgePath: Boolean;
var
 vPath, vCheckedPath: String;
begin
 vPath:= Edit_Path_D2Bridge.Text;

 CheckValidD2BridgePath(vPath, vCheckedPath);

 if Edit_Path_D2Bridge.Text = '' then
  Label_Path_D2Bridge.Caption:= '';

 if vCheckedPath = '' then
 begin
  Label_Path_D2Bridge.Caption:= '* Invalid Path from D2Bridge Framework';
  Result:= false;
 end else
 begin
  Label_Path_D2Bridge.Caption:= 'Path D2Bridge Framework is valid';
  Edit_Path_D2Bridge.Text:= vCheckedPath;
  Result:= true;
 end;
end;

procedure TD2BridgeConfigNewProject.Label_Button_BackClick(Sender: TObject);
begin
 Image_Button_BackClick(Sender);
end;

procedure TD2BridgeConfigNewProject.Label_Button_NextClick(Sender: TObject);
begin
 Image_Button_NextClick(Sender);
end;

procedure TD2BridgeConfigNewProject.Label_CloseClick(Sender: TObject);
begin
 Close;
end;

procedure TD2BridgeConfigNewProject.Label_Select_Language_AllClick(
  Sender: TObject);
begin
 CheckListBox_Languages.CheckAll(cbChecked);
end;

procedure TD2BridgeConfigNewProject.Label_Select_Language_NoneClick(
  Sender: TObject);
var
 I: integer;
begin
 for I := 0 to Pred(CheckListBox_Languages.Count) do
 begin
  if CheckListBox_Languages.ItemEnabled[I] then
  begin
   CheckListBox_Languages.Checked[I]:= false;
  end;
 end;
end;

procedure TD2BridgeConfigNewProject.Label_Select_ThirdParty_AllClick(
  Sender: TObject);
begin
 CheckListBox_ThirdParty.CheckAll(cbChecked);
end;

procedure TD2BridgeConfigNewProject.Label_Select_ThirdParty_NoneClick(
  Sender: TObject);
begin
 CheckListBox_ThirdParty.CheckAll(cbUnchecked);
end;

procedure TD2BridgeConfigNewProject.Label_Template_SiteClick(Sender: TObject);
begin
 if Label_Template_Site.Caption <> '' then
  OpenURLExt(Label_Template_Site.Caption);
end;

procedure TD2BridgeConfigNewProject.LoadAvailableLanguages;
var
 vLanguages: TStrings;
begin
 if isValidD2BridgePath then
 begin
  vLanguages:= AvailableLanguages(D2BridgeFrameworkPath);
  ComboBox_Language.Items.Text:= vLanguages.Text;
  vLanguages.Free;

  CheckListBox_Languages.Items.Clear;
  CheckListBox_Languages.Items.Text:= ComboBox_Language.Items.Text;

  ComboBox_Language.ItemIndex:= ComboBox_Language.Items.IndexOf('English');

  ComboBox_Enabled_Multi_LanguagesChange(ComboBox_Enabled_Multi_Languages);
 end;
end;

procedure TD2BridgeConfigNewProject.LoadFromIni;
var
 ArqIni: TIniFile;
 vSelectedThirdParty: TStrings;
 I, X: Integer;
begin
 ArqIni   := TIniFile.Create(ExtractFilePath(GetModuleName(HInstance))+'Config.ini');

 //----- PATH D2BRIDGE FRAMEWORK
 if ArqIni.ReadString('Config', 'Path D2Bridge Framework', '') <> '' then
  Edit_Path_D2Bridge.Text:= ArqIni.ReadString('Config', 'Path D2Bridge Framework', '');
 {$IFDEF FPC}
  {$IFDEF DESIGNMODE}
  if Edit_Path_D2Bridge.Text = '' then
  begin
   if GetOPMPath <> '' then
    Edit_Path_D2Bridge.Text := ExpandFileName(GetOPMPath);
  end;
  {$ENDIF}
 {$ENDIF}

 //----- PROJECT NAME
 if ArqIni.ReadString('Config', 'ProjectName', '') <> '' then
  Edit_ProjectName.Text:= ArqIni.ReadString('Config', 'ProjectName', '')
 else
  Edit_ProjectName.Text:= 'D2BridgeProject1';

 //----- DESTINATION
 if ArqIni.ReadString('Config', 'PathDestination', '') <> '' then
  Edit_ProjectDestination.Text:= ArqIni.ReadString('Config', 'PathDestination', '')
 else
  Edit_ProjectDestination.Text:= GetDocumentPath;

 //----- PLATAFORM
 if ComboBox_Platform.Items.IndexOf(ArqIni.ReadString('Config', 'Plataform', '')) >= 0 then
  ComboBox_Platform.ItemIndex:= ComboBox_Platform.Items.IndexOf(ArqIni.ReadString('Config', 'Plataform', ''));
 if ComboBox_Platform.ItemIndex < 0 then
  ComboBox_Platform.ItemIndex := 0;

 //----- SERVER TYPE
 if ComboBox_Server_Type.Items.IndexOf(ArqIni.ReadString('Config', 'Server Type', '')) >= 0 then
  ComboBox_Server_Type.ItemIndex:= ComboBox_Server_Type.Items.IndexOf(ArqIni.ReadString('Config', 'Server Type', ''));

 //----- SERVER PORT
 if ArqIni.ReadString('Config', 'Server Port', '') <> '' then
  Edit_Server_Port.Text:= ArqIni.ReadString('Config', 'Server Port', '');

 //----- REST API Server
 if ComboBox_Server_Type.Items.IndexOf(ArqIni.ReadString('Config', 'REST API Server', '')) >= 0 then
  ComboBox_RestAPIServer.ItemIndex:= ComboBox_Server_Type.Items.IndexOf(ArqIni.ReadString('Config', 'REST API Server', 'Enabled (Includes Authentication)'));

 //----- REST API Server - Use Classes
 CheckBox_RestAPIServer_UseClass.Checked:= ArqIni.ReadBool('Config', 'REST API Server - Use Classes', false);

 //----- SERVER NAME
 Edit_Server_Name.Text:= ArqIni.ReadString('Config', 'Server Name', 'D2Bridge Server');

 //----- TEMPLATE
 if ComboBox_Template.Items.IndexOf(ArqIni.ReadString('Config', 'Template Name', '')) >= 0 then
  ComboBox_Template.ItemIndex:= ComboBox_Template.Items.IndexOf(ArqIni.ReadString('Config', 'Template Name', ''));

 //----- TEMPLATE MASTER PAGE HTML
 if ArqIni.ReadString('Config', 'Template Master Page HTML', '') <> '' then
  Edit_Template_Maste_Page.Text:= ArqIni.ReadString('Config', 'Template Master Page HTML', '');

 //----- TEMPLATE MASTER PAGE HTML
 if ArqIni.ReadString('Config', 'Template Page HTML', '') <> '' then
  Edit_Template_Page.Text:= ArqIni.ReadString('Config', 'Template Page HTML', '');

 //----- USE SSL
 if ComboBox_UseSSL.Items.IndexOf(ArqIni.ReadString('Config', 'Use SSL', '')) >= 0 then
  ComboBox_UseSSL.ItemIndex:= ComboBox_UseSSL.Items.IndexOf(ArqIni.ReadString('Config', 'Use SSL', ''));

 if ComboBox_UseSSL.Text = 'Yes' then
 begin
  //----- SSL CERTIFICATE
  if ArqIni.ReadString('Config', 'SSL Certificate', '') <> '' then
   Edit_SSL_Certificate.Text:= ArqIni.ReadString('Config', 'SSL Certificate', '');

  //----- SSL KEY
  if ArqIni.ReadString('Config', 'SSL Key', '') <> '' then
   Edit_SSL_Key.Text:= ArqIni.ReadString('Config', 'SSL Key', '');

  //----- SSL KEY
  if ArqIni.ReadString('Config', 'SSL Intermiate', '') <> '' then
   Edit_SSL_Intermediate.Text:= ArqIni.ReadString('Config', 'SSL Intermiate', '');
 end;

 //----- LANGUAGE
 //if ComboBox_Language.Items.IndexOf(ArqIni.ReadString('Config', 'Language', '')) >= 0 then
 // ComboBox_Language.ItemIndex:= ComboBox_Language.Items.IndexOf(ArqIni.ReadString('Config', 'Language', ''));
 if ComboBox_Embed_Translation_Files.Items.IndexOf(ArqIni.ReadString('Config', 'Embed Translation Files', '')) >= 0 then
  ComboBox_Embed_Translation_Files.ItemIndex:= ComboBox_Embed_Translation_Files.Items.IndexOf(ArqIni.ReadString('Config', 'Embed Translation Files', ''));
 if ComboBox_Enabled_Multi_Languages.Items.IndexOf(ArqIni.ReadString('Config', 'Multi Language Support', '')) >= 0 then
  ComboBox_Enabled_Multi_Languages.ItemIndex:= ComboBox_Enabled_Multi_Languages.Items.IndexOf(ArqIni.ReadString('Config', 'Multi Language Support', ''));
  //ComboBox_Enabled_Multi_LanguagesChange(ComboBox_Enabled_Multi_Languages);

 //----- JQUERY
 if ComboBox_Option_JQuery.Items.IndexOf(ArqIni.ReadString('Config', 'Use jQuery', '')) >= 0 then
  ComboBox_Option_JQuery.ItemIndex:= ComboBox_Option_JQuery.Items.IndexOf(ArqIni.ReadString('Config', 'Use jQuery', ''));

 //----- BootStrap
 if ComboBox_Option_BootStrap.Items.IndexOf(ArqIni.ReadString('Config', 'Use BootStrap', '')) >= 0 then
  ComboBox_Option_BootStrap.ItemIndex:= ComboBox_Option_BootStrap.Items.IndexOf(ArqIni.ReadString('Config', 'Use BootStrap', ''));

 //----- Path CSS
 if ArqIni.ReadString('Config', 'Path CSS', '') <> '' then
  Edit_Path_CSS.Text:= ArqIni.ReadString('Config', 'Path CSS', '');

 //----- Path JS
 if ArqIni.ReadString('Config', 'Path JS', '') <> '' then
  Edit_Path_JS.Text:= ArqIni.ReadString('Config', 'Path JS', '');

 //----- Third Party
 if ArqIni.ReadString('Config', 'Third Party Components', '') <> '' then
 begin
  vSelectedThirdParty := TStringList.Create;
  vSelectedThirdParty.LineBreak:= ';';
  vSelectedThirdParty.CommaText:= ArqIni.ReadString('Config', 'Third Party Components', '');
  for I := 0 to Pred(vSelectedThirdParty.Count) do
   for X := 0 to Pred(CheckListBox_ThirdParty.Items.Count) do
    if CheckListBox_ThirdParty.Items[X] = vSelectedThirdParty[I] then
    begin
     CheckListBox_ThirdParty.Checked[X]:= true;
     break;
    end;
  vSelectedThirdParty.Free;
 end;

 ArqIni.Free;
end;

procedure TD2BridgeConfigNewProject.LoadJSOND2BridgeWizard;
var
 sFileContent: string;
 sFile: TStringStream;
begin
 if not Assigned(FTemplates) then
 begin
  sFile:= TStringStream.Create('', TEncoding.UTF8);
  sFile.LoadFromFile(GetRealFilePath(IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(ExtractFileDir(ExcludeTrailingPathDelimiter(Edit_Path_D2Bridge.Text))) + 'Wizard') + 'D2BridgeWizard.json'));


  FJSOND2BridgeWizard:= {$IFDEF FPC}GetJSON{$ELSE}TJSONObject.ParseJSONValue{$ENDIF}(sFile.DataString) as TJSONObject;

  FJSONArrayTemplates := {$IFDEF FPC}
                           GetJSON(FJSOND2BridgeWizard.Find('templates').AsJSON) as TJSONArray
                         {$ELSE}
                           TJSONObject.ParseJSONValue(FJSOND2BridgeWizard.GetValue('templates').ToJSON) as TJSONArray
                         {$ENDIF};

  FTemplates:= TD2BridgeTemplates.Create(FJSONArrayTemplates);

  sFile.Free;

  //Check Version
  if TJSONObject(FJSOND2BridgeWizard).{$IFDEF FPC}Get{$ELSE}GetValue{$ENDIF}('minimum version', 1.0) > D2BridgeWizardVersion then
  begin
   MessageDlg('This Wizard is out of date, please synchronize your D2Bridge Framework sources to continue', mtwarning, [mbok], 0);
   FCloseAPP:= true;
  end else
  if FJSOND2BridgeWizard.{$IFDEF FPC}Get{$ELSE}GetValue{$ENDIF}('last version', 1.0) > D2BridgeWizardVersion then
  begin
   MessageDlg('There is a new update for this Wizard, update your D2Bridge Framerwork sources as soon as possible', mtinformation, [mbok], 0);
  end;

  PopulateTemplates;
 end;

end;

procedure TD2BridgeConfigNewProject.PopulateTemplates;
var
 I: Integer;
begin
 ComboBox_Template.Clear;

 for I := 0 to Pred(FTemplates.Items.Count) do
  ComboBox_Template.Items.Add(FTemplates.Items[I].Name);

 ComboBox_Template.ItemIndex:= 0;
 ComboBox_Template.OnSelect(ComboBox_Template);
end;

procedure TD2BridgeConfigNewProject.Popule_ComboBox_Platform;
var
 vSelected: string;
begin
 if (ComboBox_Platform.Text = 'FMX for WEB') or (ComboBox_Platform.Text = 'LCL for WEB') then
 begin
  ComboBox_Server_Type.ItemIndex:= ComboBox_Server_Type.Items.IndexOf('Server Console (Recommended)');
  if ComboBox_Server_Type.ItemIndex < 0 then
   ComboBox_Server_Type.ItemIndex:= 0;
  ComboBox_Server_Type.Enabled:= false;
 end else
 begin
  ComboBox_Server_Type.Enabled:= true;
 end;
end;

function TD2BridgeConfigNewProject.isProjectNameValid: Boolean;
const
  ComAcentos = 'áàãâéèêíìóòõôúùüçÁÀÃÂÉÈÊÍÌÓÒÕÔÚÙÜÇ';
  SemAcentos = 'aaaaeeeiiioooouuucAAAAEEEIIIOOOOUUUC';
var
 I: integer;
{$IFDEF FPC}
 RegExpr: TRegExpr;
{$ENDIF}
begin
 Result:= false;

 if Edit_ProjectName.Text <> '' then
 begin
  for I := 1 to Length(ComAcentos) do
   Edit_ProjectName.Text := StringReplace(Edit_ProjectName.Text, ComAcentos[I], SemAcentos[I], [rfReplaceAll, rfIgnoreCase]);

{$IFDEF FPC}
   RegExpr := TRegExpr.Create;
   try
     // Remove caracteres inválidos, exceto \ e /.
     RegExpr.Expression := '[^\w\d_\/\\]';
     Edit_ProjectName.Text := RegExpr.Replace(Edit_ProjectName.Text, '', True);

     // Remove apenas "\" ou "/" no final do caminho
     RegExpr.Expression := '[\/\\]+$';
     Edit_ProjectName.Text := RegExpr.Replace(Edit_ProjectName.Text, '', True);
   finally
     RegExpr.Free;
   end;
{$ELSE}
   // No Delphi, usando TRegEx
   Edit_ProjectName.Text := TRegEx.Replace(Edit_ProjectName.Text, '[^\w\d_\/\\]', '', [roIgnoreCase]);
   Edit_ProjectName.Text := TRegEx.Replace(Edit_ProjectName.Text, '[\/\\]+$', '', [roIgnoreCase]);
{$ENDIF}

  if Edit_ProjectName.Text <> '' then
  Result:= true;
 end;
end;

procedure TD2BridgeConfigNewProject.Label_Button_LicenceClick(Sender: TObject);
begin
 Image_Button_LicenceClick(Sender);
end;

procedure TD2BridgeConfigNewProject.SaveToIni;
var
 ArqIni: TIniFile;
 PathInfi: string;
 vSelectedThirdParty: TStrings;
 I: Integer;
begin
 PathInfi := ExtractFilePath(GetModuleName(HInstance))+'Config.ini';
 ArqIni   := TIniFile.Create(ExtractFilePath(GetModuleName(HInstance))+'Config.ini');

 //----- PATH D2BRIDGE FRAMEWORK
 ArqIni.WriteString('Config', 'Path D2Bridge Framework', Edit_Path_D2Bridge.Text);

 //----- PROJECT NAME
 ArqIni.WriteString('Config', 'ProjectName', Edit_ProjectName.Text);

 //----- DESTINATION
  ArqIni.WriteString('Config', 'PathDestination', Edit_ProjectDestination.Text);

 //----- PLATAFORM
 ArqIni.WriteString('Config', 'Plataform', ComboBox_Platform.Text);

 //----- SERVER TYPE
 ArqIni.WriteString('Config', 'Server Type', ComboBox_Server_Type.Text);

 //----- SERVER PORT
 ArqIni.WriteString('Config', 'Server Port', Edit_Server_Port.Text);

 //----- REST API Server
 ArqIni.WriteString('Config', 'REST API Server', ComboBox_RestAPIServer.Text);

 //----- REST API Server - Use Classes
 ArqIni.WriteBool('Config', 'REST API Server - Use Classes', CheckBox_RestAPIServer_UseClass.Checked);

 //----- SERVER NAME
 ArqIni.WriteString('Config', 'Server Name', Edit_Server_Name.Text);

 //----- TEMPLATE
 ArqIni.WriteString('Config', 'Template Name', ComboBox_Template.Text);

 //----- TEMPLATE MASTER PAGE HTML
 ArqIni.WriteString('Config', 'Template Master Page HTML', Edit_Template_Maste_Page.Text);

 //----- TEMPLATE MASTER PAGE HTML
 ArqIni.WriteString('Config', 'Template Page HTML', Edit_Template_Page.Text);

 //----- USE SSL
 ArqIni.WriteString('Config', 'Use SSL', ComboBox_UseSSL.Text);

 //----- SSL CERTIFICATE
 ArqIni.WriteString('Config', 'SSL Certificate', Edit_SSL_Certificate.Text);

 //----- SSL KEY
 ArqIni.WriteString('Config', 'SSL Key', Edit_SSL_Key.Text);

 //----- SSL KEY
 ArqIni.WriteString('Config', 'SSL Intermiate', Edit_SSL_Intermediate.Text);

 //----- LANGUAGE
 ArqIni.WriteString('Config', 'Language', ComboBox_Language.Text);
 ArqIni.WriteString('Config', 'Multi Language Support', ComboBox_Enabled_Multi_Languages.Text);
 ArqIni.WriteString('Config', 'Embed Translation Files', ComboBox_Embed_Translation_Files.Text);

 //----- JQUERY
 ArqIni.WriteString('Config', 'Use jQuery', ComboBox_Option_JQuery.Text);

 //----- BootStrap
 ArqIni.WriteString('Config', 'Use BootStrap', ComboBox_Option_BootStrap.Text);

 //----- Path CSS
 ArqIni.WriteString('Config', 'Path CSS', Edit_Path_CSS.Text);

 //----- Path JS
 ArqIni.WriteString('Config', 'Path JS', Edit_Path_JS.Text);

//----- Third Party Components
 vSelectedThirdParty := TStringList.Create;
 vSelectedThirdParty.LineBreak:= ';';
 for I := 0 to Pred(CheckListBox_ThirdParty.Items.Count) do
  if CheckListBox_ThirdParty.Checked[I] then
   vSelectedThirdParty.Add(CheckListBox_ThirdParty.Items[I]);
 ArqIni.WriteString('Config', 'Third Party Components', vSelectedThirdParty.CommaText);
 vSelectedThirdParty.Free;

 ArqIni.Free;
end;

procedure TD2BridgeConfigNewProject.SpeedButton1Click(Sender: TObject);
begin
 PathDialog_D2Bridge.{$IFDEF FPC}InitialDir{$ELSE}DefaultFolder{$ENDIF}:= Edit_SSL_Certificate.Text;

 if PathDialog_D2Bridge.Execute then
 begin
  Edit_SSL_Certificate.Text := PathDialog_D2Bridge.FileName;
 end;

end;

procedure TD2BridgeConfigNewProject.SpeedButton2Click(Sender: TObject);
begin
 PathDialog_D2Bridge.{$IFDEF FPC}InitialDir{$ELSE}DefaultFolder{$ENDIF}:= Edit_SSL_Key.Text;

 if PathDialog_D2Bridge.Execute then
 begin
  Edit_SSL_Key.Text := PathDialog_D2Bridge.FileName;
 end;

end;

procedure TD2BridgeConfigNewProject.SpeedButton3Click(Sender: TObject);
begin
 PathDialog_D2Bridge.{$IFDEF FPC}InitialDir{$ELSE}DefaultFolder{$ENDIF}:= Edit_SSL_Intermediate.Text;

 if PathDialog_D2Bridge.Execute then
 begin
  Edit_SSL_Intermediate.Text := PathDialog_D2Bridge.FileName;
 end;

end;

procedure TD2BridgeConfigNewProject.SpeedButton4Click(Sender: TObject);
begin
 PathDialog_D2Bridge.{$IFDEF FPC}InitialDir{$ELSE}DefaultFolder{$ENDIF} := Edit_Path_D2Bridge.Text;

 if PathDialog_D2Bridge.Execute then
 begin
  Edit_Path_D2Bridge.Text := PathDialog_D2Bridge.FileName;

  if isValidD2BridgePath then
   Image_Button_NextClick(Sender);
 end;
end;

procedure TD2BridgeConfigNewProject.SpeedButton_DestinationClick(Sender: TObject);
begin
 PathDialog_D2Bridge.{$IFDEF FPC}InitialDir{$ELSE}DefaultFolder{$ENDIF}:= Edit_ProjectDestination.Text;

 if PathDialog_D2Bridge.Execute then
 begin
  Edit_ProjectDestination.Text := PathDialog_D2Bridge.FileName;
 end;

end;

end.
