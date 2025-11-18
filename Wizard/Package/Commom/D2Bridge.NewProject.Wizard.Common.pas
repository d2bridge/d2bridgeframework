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

unit D2Bridge.NewProject.Wizard.Common;

{$IFDEF FPC}
  {$MODE Delphi}
  //{$DEFINE LCLLIB}
{$ELSE}
  {$DEFINE DELPHI}
{$ENDIF}



interface

Uses
{$IFDEF FPC}
  FileUtil, {$IFDEF LCLLIB}ProjectIntf,{$ENDIF}
{$ELSE}
  Winapi.Windows, ToolsAPI, System.Zip, System.IOUtils, DateUtils,
{$ENDIF}
  Classes, SysUtils, Forms, Dialogs, D2Bridge.ConfigNewProject.View;


type
  TTypeServer =
    ({$IFDEF DELPHI}tsWebFMX,tsWebAndFMX,{$ENDIF}
     {$IFDEF FPC}tsWebLCL{$ELSE}tsWebVCL{$ENDIF},
     {$IFDEF FPC}tsWebAndLCL{$ELSE}tsWebAndVCL{$ENDIF});

type

  { TD2BridgeNewProjectWizardCommon }

  TD2BridgeNewProjectWizardCommon = class
  private
{$IFDEF FPC}
{$IFDEF LCLLIB}
   //FLazProject: TLazProject;
{$ENDIF}
{$ENDIF}
  public
   WizardForm: TD2BridgeConfigNewProject;
   PathPROJ: string;

   constructor Create;
   destructor Destroy; override;

{$IFDEF FPC}
{$IFDEF LCLLIB}
   //property LazProject: TLazProject read FLazProject write FLazProject;
{$ENDIF}
{$ENDIF}

   procedure Execute;
  end;

implementation

Uses
 D2Bridge.Wizard.Util,
 D2Bridge.Lang.Util;


{ TD2BridgeNewProjectWizardCommon }

constructor TD2BridgeNewProjectWizardCommon.Create;
begin
 inherited;

 PathPROJ:= '';
 WizardForm:= TD2BridgeConfigNewProject.Create(Application);
end;

destructor TD2BridgeNewProjectWizardCommon.Destroy;
begin
 if Assigned(WizardForm) then
  FreeAndNil(WizardForm);

 inherited Destroy;
end;

{
DELHI   LAZARUS          TIPO DE ARQUIVO
.DPR	.LPR	         Arquivo principal do projeto. Contém o ponto de entrada do programa.
.DPROJ	.LPI	         Arquivo do projeto que contém configurações específicas do Lazarus, equivalente ao .dproj no Delphi.
.RES	.LRS ou .RES	 Arquivo de recursos. Lazarus usa .lrs gerado pelo Lazarus Resource Editor, mas também pode usar .res.
.DFM	.LFM	         Arquivo de descrição do formulário. Em Lazarus, os formulários são descritos no formato .lfm.
.PAS	.PAS	         Arquivo de código-fonte Pascal. O código .pas é idêntico tanto no Delphi quanto no Lazarus.
}

procedure TD2BridgeNewProjectWizardCommon.Execute;
var
  I: Integer;
{$IFDEF DELPHI}
  services: IOTAModuleServices;
  sSourceWebFMXDPROJFile, sSourceFMXDPROJFile: string;
  sSourceWebFMXDPRFile, sSourceFMXDPRFile: string;
  sSourceWebFMXRESFile, sSourceFMXRESFile: string;
{$ENDIF}
{$IFDEF FPC}
  sSourceFixD2BridgeLazCompile, sSourceFixD2BridgeLazBuild: string;
{$ENDIF}
  sProjectNameLogical,sTyperProject,sProjectName,sDestinationPath,sSourceFiles:string;
  sDestinationPathWeb, sDestinationPathBinWeb, sDestinationPathCommonUnit,sD2BridgeFrameworkSearchPath,sD2BridgeFrameworkPath: String;
  sD2BridgeDirectives: TStrings;
  sLangCode, sLangCodeUnderline: string;
  sLanguageUnitSourcePath: string;
  sLanguageJSONPath: string;
  sLanguagesUnitsDPR, sLanguagesJSON, sLanguagesUSES, sLanguagesCREATE, sLanguagesDESTROY, sLanguagesSET, sUNITs: TStrings;
  sPathBINWEB, sPathBIN: string;
  sPathwwwroot: string;
  sPathWEBDPROJFile, sPathWEBRESFile, sPathWEBICOFile, sPathWizard, sPathUnitBase, sPathUnitServer, sPathDFMServer: string;
  sSourceWebVCLDPROJFile, sSourceVCLDPROJFile: string;
  sSourceWebDPRFile, sSourceVCLDPRFile: string;
  sSourceWebRESFile, sSourceVCLRESFile: string;
  sSourceWebICOFile, sSourceVCLICOFile: string;
  sFileContent: string;
  sFile: TStringStream;
  sClassPrimaryForm, sUnitPrimaryForm: string;
  sUnitLogin, sFormLogin: string;
  sTypeServer: TTypeServer;
  sRESTAPIServerUnitAuthFile, sRESTAPIServerUnitPingFile: string;
  sRESTAPIServerUnitAuthClassFile, sRESTAPIServerUnitPingClassFile: string;
  sRESTAPIServerSessionFile: string;
begin
  try
   WizardForm.ShowModal;
   if WizardForm.EnableCreateProject then
   begin

     //----- PROJECT TYPE
{$IFDEF FPC}
    if WizardForm.ComboBox_Platform.Text = 'LCL for WEB' then
    begin
     if WizardForm.CheckBox_Add_Project_Platform.Checked then
      sTypeServer:= tsWebAndLCL
     else
      sTypeServer:= tsWebLCL;
    end;
{$ELSE}
    if WizardForm.ComboBox_Platform.Text = 'VCL for WEB' then
    begin
     if WizardForm.CheckBox_Add_Project_Platform.Checked then
      sTypeServer:= tsWebAndVCL
     else
      sTypeServer:= tsWebVCL;
    end else
    begin
     if WizardForm.CheckBox_Add_Project_Platform.Checked then
      sTypeServer:= tsWebAndFMX
     else
      sTypeServer:= tsWebFMX;
    end;
{$ENDIF}

     //D2Bridge Framework Path
     sD2BridgeFrameworkPath:= ExcludeTrailingPathDelimiter(WizardForm.Edit_Path_D2Bridge.Text);
     sD2BridgeFrameworkSearchPath:= WizardForm.Edit_Path_D2Bridge.Text+';'+WizardForm.Edit_Path_D2Bridge.Text+'Prism'+';'+WizardForm.Edit_Path_D2Bridge.Text+'Others VCL'+';';

     sProjectName    := WizardForm.Edit_ProjectName.Text;

     sPathWizard:= ExtractFileDir(ExcludeTrailingPathDelimiter(WizardForm.Edit_Path_D2Bridge.Text))+ PathDelim + 'Wizard';
     sPathUnitBase:= ExtractFileDir(ExcludeTrailingPathDelimiter(WizardForm.Edit_Path_D2Bridge.Text))+ PathDelim + 'Unit Base';

{$IFDEF FPC}
     sSourceWebVCLDPROJFile:= sPathWizard + PathDelim + 'dpr'+ PathDelim + 'LAZARUS'+ PathDelim + 'D2BridgeWebAppLCL.lpi';
{$ELSE}
     sSourceWebVCLDPROJFile:= sPathWizard + '\dpr\' + 'D2BridgeWebAppVCL.dproj';
{$ENDIF}

{$IFDEF DELPHI}
     sSourceWebFMXDPROJFile:= sPathWizard + '\dpr\FMX\' + 'D2BridgeWebAppFMX.dproj';
{$ENDIF}

{$IFDEF FPC}
     sSourceVCLDPROJFile:= sPathWizard + PathDelim + 'dpr' + PathDelim + 'LAZARUS' + PathDelim + 'D2BridgeWebAppWithLCL.lpi';
{$ELSE}
     sSourceVCLDPROJFile:= sPathWizard + '\dpr\' + 'D2BridgeWebAppWithVCL.dproj';
{$ENDIF}

{$IFDEF DELPHI}
     sSourceFMXDPROJFile:= sPathWizard + '\dpr\FMX\' + 'D2BridgeWebAppWithFMX.dproj';
{$ENDIF}

{$IFDEF FPC}
     sSourceWebDPRFile:= sPathWizard + PathDelim + 'dpr' + PathDelim + 'LAZARUS' + PathDelim + 'D2BridgeWebAppLCL.lpr';
{$ELSE}
     sSourceWebDPRFile:= sPathWizard + '\dpr\' + 'D2BridgeWebAppVCL.dpr';
{$ENDIF}

{$IFDEF DELPHI}
     sSourceWebFMXDPRFile:= sPathWizard + '\dpr\FMX\' + 'D2BridgeWebAppFMX.dpr';
{$ENDIF}

{$IFDEF FPC}
     sSourceVCLDPRFile:= sPathWizard + PathDelim + 'dpr' + PathDelim + 'LAZARUS' + PathDelim + 'D2BridgeWebAppWithLCL.lpr';
{$ELSE}
     sSourceVCLDPRFile:= sPathWizard + '\dpr\' + 'D2BridgeWebAppWithVCL.dpr';
{$ENDIF}

{$IFDEF DELPHI}
     sSourceFMXDPRFile:= sPathWizard + '\dpr\FMX\' + 'D2BridgeWebAppWithFMX.dpr';
{$ENDIF}

{$IFDEF FPC}
     sSourceWebRESFile:= sPathWizard + PathDelim + 'dpr' + PathDelim + 'LAZARUS' + PathDelim + 'D2BridgeWebAppLCL.res';
{$ELSE}
     sSourceWebRESFile:= sPathWizard + '\dpr\' + 'D2BridgeWebAppVCL.res';
{$ENDIF}

{$IFDEF FPC}
     sSourceWebICOFile:= sPathWizard + PathDelim + 'dpr' + PathDelim + 'LAZARUS' + PathDelim + 'D2BridgeWebAppLCL.ico';
{$ELSE}
     sSourceWebICOFile:= sPathWizard + '\dpr\' + 'D2BridgeApp.ico';
{$ENDIF}

{$IFDEF DELPHI}
     sSourceWebFMXRESFile:= sPathWizard + '\dpr\FMX\' + 'D2BridgeWebAppFMX.res';
{$ENDIF}

{$IFDEF FPC}
     sSourceVCLRESFile:= sPathWizard + PathDelim + 'dpr' + PathDelim + 'LAZARUS' + PathDelim + '' + 'D2BridgeWebAppWithLCL.res';
{$ELSE}
     sSourceVCLRESFile:= sPathWizard + '\dpr\' + 'D2BridgeWebAppWithVCL.res';
{$ENDIF}

{$IFDEF FPC}
     sSourceVCLICOFile:= sPathWizard + PathDelim + 'dpr' + PathDelim + 'LAZARUS' + PathDelim + 'D2BridgeWebAppWithLCL.ico';
{$ELSE}
     sSourceVCLICOFile:= sPathWizard + '\dpr\' + 'D2BridgeApp.ico';
{$ENDIF}

{$IFDEF DELPHI}
     sSourceFMXRESFile:= sPathWizard + '\dpr\FMX\' + 'D2BridgeWebAppWithFMX.res';
{$ENDIF}

{$IFDEF FPC}
     sSourceFixD2BridgeLazCompile := sPathWizard + PathDelim + 'dpr' + PathDelim + 'LAZARUS' + PathDelim + 'FixD2BridgeLazCompile.bat';
     sSourceFixD2BridgeLazBuild := sPathWizard + PathDelim + 'dpr' + PathDelim + 'LAZARUS' + PathDelim + 'FixD2BridgeLazBuild.bat';
{$ENDIF}

     if WizardForm.CheckBox_Create_Project_Folder.Checked then
      sDestinationPath     := PChar(WizardForm.Edit_ProjectDestination.Text+sProjectName)
     else
      sDestinationPath     := PChar(WizardForm.Edit_ProjectDestination.Text);

     sDestinationPathWeb := sDestinationPath;
     sDestinationPathCommonUnit:= sDestinationPath;

     sDestinationPathBinWeb := sDestinationPathWeb + PathDelim + 'Web';
     sPathwwwroot := sDestinationPathBinWeb + PathDelim + 'wwwroot';

     sProjectNameLogical:= sDestinationPathWeb+ PathDelim +sProjectName+{$IFDEF FPC}'.lpr'{$ELSE}'.dpr'{$ENDIF};
     sPathWEBDPROJFile:= sDestinationPathWeb+ PathDelim +sProjectName+{$IFDEF FPC}'.lpi'{$ELSE}'.dproj'{$ENDIF};
     sPathWEBRESFile:= sDestinationPathWeb+ PathDelim +sProjectName+{$IFDEF FPC}'.res'{$ELSE}'.res'{$ENDIF};
     sPathWEBICOFile:= sDestinationPathWeb+ PathDelim +sProjectName+{$IFDEF FPC}'.ico'{$ELSE}'.ico'{$ENDIF};

     sLanguageUnitSourcePath:= sPathWizard + PathDelim + 'Lang Support' + PathDelim + 'D2Bridge.Lang.APP.Language.pas';

     sLanguageJSONPath:= sPathWizard + PathDelim + 'Lang Support' + PathDelim + 'lang';

     //REST API Server
     sRESTAPIServerUnitAuthClassFile:= sPathWizard + PathDelim + 'FORMS' + PathDelim + 'Wizard' + PathDelim + 'RestAPIAuthClass' + {$IFDEF FPC} '.Laz' +{$ENDIF} '.pas';
     sRESTAPIServerUnitAuthFile:= sPathWizard + PathDelim + 'FORMS' + PathDelim + 'Wizard' + PathDelim + 'RestAPIAuth' + {$IFDEF FPC} '.Laz' +{$ENDIF} '.pas';
     sRESTAPIServerUnitPingClassFile:= sPathWizard + PathDelim + 'FORMS' + PathDelim + 'Wizard' + PathDelim + 'RestAPIUnitClass' + {$IFDEF FPC} '.Laz' +{$ENDIF} '.pas';
     sRESTAPIServerUnitPingFile:= sPathWizard + PathDelim + 'FORMS' + PathDelim + 'Wizard' + PathDelim + 'RestAPIUnit' + {$IFDEF FPC} '.Laz' +{$ENDIF} '.pas';
     sRESTAPIServerSessionFile:= sPathWizard + PathDelim + 'FORMS' + PathDelim + 'Wizard' + PathDelim + 'D2Bridge.Rest.Session.pas';

     sClassPrimaryForm:= 'TForm1';
     sUnitPrimaryForm:= 'Unit1';

     sUNITs:= TStringList.Create;
{$IFDEF FPC}
     sUnitLogin:= sPathWizard + PathDelim + 'FORMS' + PathDelim + 'Native' + PathDelim + 'Lazarus' + PathDelim + 'Login' + PathDelim + 'Unit_Login.pas';
     sFormLogin:= sPathWizard + PathDelim + 'FORMS' + PathDelim + 'Native' + PathDelim + 'Lazarus' + PathDelim + 'Login' + PathDelim + 'Unit_Login.lfm';
{$ELSE}
     if (sTypeServer = tsWebFMX) or (sTypeServer = tsWebAndFMX) then
     begin
      sUnitLogin:= sPathWizard + '\FORMS\Native\FMX\Login\Unit_Login.pas';
      sFormLogin:= sPathWizard + '\FORMS\Native\FMX\Login\Unit_Login.fmx';
     end else
     begin
      sUnitLogin:= sPathWizard + '\FORMS\Native\Login\Unit_Login.pas';
      sFormLogin:= sPathWizard + '\FORMS\Native\Login\Unit_Login.dfm';
     end;
{$ENDIF}

     //----- D2Bridge Directives
     sD2BridgeDirectives:= TStringList.Create;
     sD2BridgeDirectives.LineBreak:= ';';
     sD2BridgeDirectives.Add('D2Bridge');
{$IFDEF DELPHI}
    if sTypeServer in [tsWebFMX, tsWebAndFMX] then
     sD2BridgeDirectives.Add('FMX');
{$ENDIF}
     if WizardForm.CheckListBox_ThirdParty.Checked[WizardForm.CheckListBox_ThirdParty.Items.IndexOf('RXLIB')] then
      sD2BridgeDirectives.Add('RXLIB_AVAILABLE');
     if WizardForm.CheckListBox_ThirdParty.Checked[WizardForm.CheckListBox_ThirdParty.Items.IndexOf('SMComponents')] then
      sD2BridgeDirectives.Add('SMCOMPONENTS_AVAILABLE');
     if WizardForm.CheckListBox_ThirdParty.Checked[WizardForm.CheckListBox_ThirdParty.Items.IndexOf('DevExpress')] then
      sD2BridgeDirectives.Add('DEVEXPRESS_AVAILABLE');
     if WizardForm.CheckListBox_ThirdParty.Checked[WizardForm.CheckListBox_ThirdParty.Items.IndexOf('JVCL')] then
      sD2BridgeDirectives.Add('JVCL_AVAILABLE');


     //----- CREATE PROJECT DIRECTORY
     If not DirectoryExists(sDestinationPath) then
      MKdir(sDestinationPath);
     If not DirectoryExists(sDestinationPathWeb) then
      MKdir(sDestinationPathWeb);
     If not DirectoryExists(sDestinationPathWeb + PathDelim + 'Web') then
      MKdir(sDestinationPathWeb + PathDelim + 'Web');
     If not DirectoryExists(sPathwwwroot) then
      MKdir(sPathwwwroot);
     if WizardForm.ComboBox_Enabled_Multi_Languages.Text = 'Yes' then
     If not DirectoryExists(sDestinationPathBinWeb+ PathDelim + 'lang') then
      MKdir(sDestinationPathBinWeb+ PathDelim + 'lang');

//     //----- COPY DPR
//     if sTypeServer = {$IFDEF FPC}tsWebAndLCL{$ELSE}tsWebAndVCL{$ENDIF} then
//      {$IFDEF FPC}CopyFile{$ELSE}TFile.Copy{$ENDIF}(sSourceVCLDPRFile, sProjectNameLogical, false)
//     else
//{$IFDEF DELPHI}
//     if sTypeServer = tsWebAndFMX then
//      CopyFile(PWideChar(sSourceFMXDPRFile), PWideChar(sProjectNameLogical), false)
//     else
//     if sTypeServer = tsWebFMX then
//      CopyFile(PWideChar(sSourceWebFMXDPRFile), PWideChar(sProjectNameLogical), false)
//     else
//{$ENDIF}
//      {$IFDEF FPC}CopyFile{$ELSE}TFile.Copy{$ENDIF}(sSourceWebDPRFile, sProjectNameLogical, false);

     //----- COPY RES
     if FileExists(sSourceWebRESFile) then
     begin
       if sTypeServer = {$IFDEF FPC}tsWebAndLCL{$ELSE}tsWebAndVCL{$ENDIF} then
        {$IFDEF FPC}CopyFile{$ELSE}TFile.Copy{$ENDIF}(sSourceVCLRESFile, sPathWEBRESFile, false)
       else
{$IFDEF DELPHI}
       if sTypeServer = tsWebAndFMX then
        CopyFile(PWideChar(sSourceFMXRESFile), PWideChar(sPathWEBRESFile), false)
       else
       if sTypeServer = tsWebFMX then
        CopyFile(PWideChar(sSourceWebFMXRESFile), PWideChar(sPathWEBRESFile), false)
       else
{$ENDIF}
        {$IFDEF FPC}CopyFile{$ELSE}TFile.Copy{$ENDIF}(sSourceWebRESFile, sPathWEBRESFile, false);
     end;

     //----- COPY ICO
     if FileExists(sSourceVCLICOFile) then
     begin
       if sTypeServer = {$IFDEF FPC}tsWebAndLCL{$ELSE}tsWebAndVCL{$ENDIF} then
        {$IFDEF FPC}CopyFile{$ELSE}TFile.Copy{$ENDIF}(sSourceVCLICOFile, sPathWEBICOFile, false)
       else
{$IFDEF DELPHI}
       if sTypeServer = tsWebAndFMX then
        CopyFile(PWideChar(sSourceFMXRESFile), PWideChar(sPathWEBICOFile), false)
       else
       if sTypeServer = tsWebFMX then
        CopyFile(PWideChar(sSourceWebFMXRESFile), PWideChar(sPathWEBICOFile), false)
       else
{$ENDIF}
        {$IFDEF FPC}CopyFile{$ELSE}TFile.Copy{$ENDIF}(sSourceWebICOFile, sPathWEBICOFile, false);
     end;

{$IFDEF FPC}
    if sTypeServer in [tsWebLCL, tsWebAndLCL] then
    begin
     //----- COPY .PAS
     CopyFolderFiles(sPathWizard + PathDelim + 'dpr' + PathDelim + 'LAZARUS' + PathDelim + '*.pas', sDestinationPathWeb);
     //----- COPY .DFM
     CopyFolderFiles(sPathWizard + PathDelim + 'dpr' + PathDelim + 'LAZARUS' + PathDelim + '*.lfm', sDestinationPathWeb);
    end;
{$ELSE}
    if sTypeServer in [tsWebFMX, tsWebAndFMX] then
    begin
     //----- COPY .PAS
     CopyFolderFiles(PWideChar(sPathWizard+'\dpr\FMX\*.pas'), sDestinationPathWeb);
     //----- COPY .DFM
     CopyFolderFiles(PWideChar(sPathWizard+'\dpr\FMX\*.fmx'), sDestinationPathWeb);
    end else
    begin
     //----- COPY .PAS
     CopyFolderFiles(PWideChar(sPathWizard+'\dpr\*.pas'), sDestinationPathWeb);
     //----- COPY .DFM
     CopyFolderFiles(PWideChar(sPathWizard+'\dpr\*.dfm'), sDestinationPathWeb);
    end;
{$ENDIF}


//----- COPY FixD2BridgeLazBuild
{$IFDEF FPC}
     CopyFolderFiles(sSourceFixD2BridgeLazBuild, sDestinationPathWeb);
     CopyFolderFiles(sSourceFixD2BridgeLazCompile, sDestinationPathWeb);
{$ENDIF}


     {$REGION 'Language Support'}
      sLanguagesUnitsDPR:= TStringList.Create;
      sLanguagesJSON:= TStringList.Create;
      sLanguagesUSES:= TStringList.Create;
      sLanguagesCREATE:= TStringList.Create;
      sLanguagesDESTROY:= TStringList.Create;
      sLanguagesSET:= TStringList.Create;
      if WizardForm.ComboBox_Enabled_Multi_Languages.Text = 'Yes' then
      begin
       {$REGION 'Prepare Units Name to DPR'}
        sLanguagesUnitsDPR.Add('  D2Bridge.Lang.APP.Core in ''D2Bridge.Lang.APP.Core.pas'',');
        sLanguagesUnitsDPR.Add('  D2Bridge.Lang.APP.Term in ''D2Bridge.Lang.APP.Term.pas'',');
       {$ENDREGION}


       {$REGION 'Copy Language Support UNITs'}
        {$IFDEF FPC}CopyFile{$ELSE}TFile.Copy{$ENDIF}
                (sPathWizard + PathDelim + 'Lang Support' + PathDelim + 'D2Bridge.Lang.APP.Term.pas', sDestinationPathWeb + PathDelim + 'D2Bridge.Lang.APP.Term.pas', false);
       {$ENDREGION}

       {$REGION 'Copy Languages Units'}
        for I := 0 to Pred(WizardForm.CheckListBox_Languages.Count) do
         if WizardForm.CheckListBox_Languages.Checked[I] then
         begin
          sFile:= TStringStream.Create('', TEncoding.UTF8);
          sFile.LoadFromFile(GetRealFilePath(sLanguageUnitSourcePath));
          sFileContent:= sFile.DataString;

          sFileContent:= StringReplace(sFileContent, '{Language}', WizardForm.CheckListBox_Languages.Items[I], [rfIgnoreCase, rfReplaceAll]);

          //Add Unit in Project
          sLanguagesUnitsDPR.Add('  D2Bridge.Lang.APP.' + WizardForm.CheckListBox_Languages.Items[I] + ' in ''D2Bridge.Lang.APP.' + WizardForm.CheckListBox_Languages.Items[I] + '.pas'',');
          //Add Language Code JSON
          sLangCode:= LanguageCode(D2BridgeLangbyLanguageName(WizardForm.CheckListBox_Languages.Items[I]));
          sLangCodeUnderline:= StringReplace(sLangCode, '-', '_', []);
          if WizardForm.ComboBox_Embed_Translation_Files.Text = 'Yes' then //Embed JSON
          sLanguagesJSON.Add('D2Bridge_Lang_APP_' + sLangCodeUnderline + ' RCDATA "lang\\'+ sLangCode +'.json"');

          {$IFDEF FPC}CopyFile{$ELSE}TFile.Copy{$ENDIF}
                  (sLanguageJSONPath + PathDelim + 'language.json',
                   sDestinationPathBinWeb + PathDelim + 'lang' + PathDelim + sLangCode + '.json', false);
          //Add USES language
          sLanguagesUSES.Add(' D2Bridge.Lang.APP.' + WizardForm.CheckListBox_Languages.Items[I]+',');
          //Add Language Create
          sLanguagesCREATE.Add(' ' + WizardForm.CheckListBox_Languages.Items[I] + ':= ' + 'TD2BridgeLangAPP' + WizardForm.CheckListBox_Languages.Items[I] + '.Create(self, TD2BridgeAPPTerm);');
          //Add Language Destroy
          sLanguagesDESTROY.Add(' TD2BridgeLangAPP' + WizardForm.CheckListBox_Languages.Items[I] + '('+ WizardForm.CheckListBox_Languages.Items[I] +').Destroy;');
          //Add Set Languages
          sLanguagesSET.Add('TD2BridgeLang.' + WizardForm.CheckListBox_Languages.Items[I]);

          sFile.Clear;
          sFile.WriteString(sFileContent);
          sFile.SaveToFile(sDestinationPathWeb + PathDelim + 'D2Bridge.Lang.APP.'+WizardForm.CheckListBox_Languages.Items[I]+'.pas');
          sFile.Free;
         end;
       {$ENDREGION}

       {$REGION 'Copy D2Bridge.Lang.APP.Core'}
        for I := 0 to Pred(WizardForm.CheckListBox_Languages.Count) do
         if WizardForm.CheckListBox_Languages.Checked[I] then
         begin
          sFile:= TStringStream.Create('', TEncoding.UTF8);
          sFile.LoadFromFile(GetRealFilePath(sPathWizard + PathDelim + 'Lang Support' + PathDelim + 'D2Bridge.Lang.APP.Core.pas'));
          sFileContent:= sFile.DataString;

          sFileContent:= StringReplace(sFileContent, '{Uses_Languages}', sLanguagesUSES.Text, [rfIgnoreCase, rfReplaceAll]);
          sFileContent:= StringReplace(sFileContent, '{Create_Languages}', sLanguagesCREATE.Text, [rfIgnoreCase, rfReplaceAll]);
          sFileContent:= StringReplace(sFileContent, '{Destroy_Languages}', sLanguagesDESTROY.Text, [rfIgnoreCase, rfReplaceAll]);

          if WizardForm.ComboBox_Embed_Translation_Files.Text = 'No' then
           sFileContent:= StringReplace(sFileContent, '{EmbedJSON}', 'false', [rfIgnoreCase, rfReplaceAll])
          else
           sFileContent:= StringReplace(sFileContent, '{EmbedJSON}', 'true', [rfIgnoreCase, rfReplaceAll]);

          sFile.Clear;
          sFile.WriteString(sFileContent);
          sFile.SaveToFile(sDestinationPathWeb + PathDelim + 'D2Bridge.Lang.APP.Core.pas');
          sFile.Free;
         end;
       {$ENDREGION}

       {$REGION 'Copy Language RC File'}
        if WizardForm.ComboBox_Embed_Translation_Files.Text = 'Yes' then //Embed JSON
        for I := 0 to Pred(WizardForm.CheckListBox_Languages.Count) do
         if WizardForm.CheckListBox_Languages.Checked[I] then
         begin
          sFile:= TStringStream.Create('', TEncoding.UTF8);
          sFileContent:= sLanguagesJSON.Text;

          sFileContent:= StringReplace(sFileContent, '{Language}', WizardForm.CheckListBox_Languages.Items[I], [rfIgnoreCase, rfReplaceAll]);

          sFile.Clear;
          sFile.WriteString(sFileContent);
          sFile.SaveToFile(sDestinationPathWeb + PathDelim + 'D2Bridge.Lang.APP.rc');
          sFile.Free;
         end;
       {$ENDREGION}
      end else
      begin
       sLanguagesSET.Add('TD2BridgeLang.' + WizardForm.ComboBox_Language.Text);
      end;
     {$ENDREGION}


     {$REGION 'UNIT BASE'}
      {$REGION 'ServerController.pas'}
       sFile:= TStringStream.Create('', TEncoding.UTF8);
       sFile.LoadFromFile(GetRealFilePath(sPathUnitBase + PathDelim + 'ServerController.pas'));
       sFileContent:= sFile.DataString;

       sFileContent:= StringReplace(sFileContent, '{ProjectName}', sProjectName, [rfIgnoreCase, rfReplaceAll]);

       sFile.Clear;
       sFile.WriteString(sFileContent);
       sFile.SaveToFile(sDestinationPathWeb + PathDelim + sProjectName + 'WebApp.pas');
       sFile.Free;
      {$ENDREGION}

      {$REGION 'ServerController.dfm'}
       sFile:= TStringStream.Create('', TEncoding.UTF8);
       sFile.LoadFromFile(GetRealFilePath(sPathUnitBase+{$IFDEF FPC} PathDelim + 'ServerController.lfm'{$ELSE}'\ServerController.dfm'{$ENDIF}));
       sFileContent:= sFile.DataString;

       sFileContent:= StringReplace(sFileContent, '{ProjectName}', sProjectName, [rfIgnoreCase, rfReplaceAll]);

       sFile.Clear;
       sFile.WriteString(sFileContent);
       sFile.SaveToFile(sDestinationPathWeb+ PathDelim + sProjectName+{$IFDEF FPC}'WebApp.lfm'{$ELSE}'WebApp.dfm'{$ENDIF});
       sFile.Free;
      {$ENDREGION}

      {$REGION 'UserSessionUnit.pas'}
       sFile:= TStringStream.Create('', TEncoding.UTF8);
       sFile.LoadFromFile(GetRealFilePath(sPathUnitBase + PathDelim + 'UserSessionUnit.pas'));
       sFileContent:= sFile.DataString;

       sFileContent:= StringReplace(sFileContent, '{ProjectName}', sProjectName, [rfIgnoreCase, rfReplaceAll]);

       sFile.Clear;
       sFile.WriteString(sFileContent);
       sFile.SaveToFile(sDestinationPathWeb + PathDelim + sProjectName+'_Session.pas');
       sFile.Free;
      {$ENDREGION}

      {$REGION 'UserSessionUnit.dfm'}
       sFile:= TStringStream.Create('', TEncoding.UTF8);
       sFile.LoadFromFile(GetRealFilePath(sPathUnitBase + {$IFDEF FPC} PathDelim + 'UserSessionUnit.lfm'{$ELSE}'\UserSessionUnit.dfm'{$ENDIF}));
       sFileContent:= sFile.DataString;

       sFileContent:= StringReplace(sFileContent, '{ProjectName}', sProjectName, [rfIgnoreCase, rfReplaceAll]);

       sFile.Clear;
       sFile.WriteString(sFileContent);
       sFile.SaveToFile(sDestinationPathWeb + PathDelim + sProjectName+{$IFDEF FPC}'_Session.lfm'{$ELSE}'_Session.dfm'{$ENDIF});
       sFile.Free;
      {$ENDREGION}

      {$REGION 'D2BridgeFormTemplate.pas'}
       sFile:= TStringStream.Create('', TEncoding.UTF8);
       sFile.LoadFromFile(GetRealFilePath(sPathUnitBase + PathDelim + 'D2BridgeFormTemplate.pas'));
       sFileContent:= sFile.DataString;

       sFileContent:= StringReplace(sFileContent, '{ProjectName}', sProjectName, [rfIgnoreCase, rfReplaceAll]);

       sFile.Clear;
       sFile.WriteString(sFileContent);
       sFile.SaveToFile(sDestinationPathWeb + PathDelim + 'D2BridgeFormTemplate.pas');
       sFile.Free;
      {$ENDREGION}
     {$ENDREGION}



     {$REGION 'Login'}
      if WizardForm.CheckBox_Form_Login.Checked then
      begin
       {$IFDEF FPC}
         CopyFolderFiles(sUnitLogin, sDestinationPathWeb);
         CopyFolderFiles(sFormLogin, sDestinationPathWeb);
       {$ELSE}
         CopyFolderFiles(PWideChar(sUnitLogin), sDestinationPathWeb);
         CopyFolderFiles(PWideChar(sFormLogin), sDestinationPathWeb);
       {$ENDIF}

       //Set Primary Form
       sClassPrimaryForm:= 'TForm_Login';
       sUnitPrimaryForm:= 'Unit_Login';

       //Unit Login
       sUNITs.Add('Unit_Login in ''Unit_Login.pas'' {Form_Login},');

       sFile:= TStringStream.Create('', TEncoding.UTF8);
       sFile.LoadFromFile(GetRealFilePath(sDestinationPathWeb + PathDelim + ExtractFileName(sUnitLogin)));
       sFileContent:= sFile.DataString;

       //----- Template HTML Files
       sFileContent := StringReplace(sFileContent, '{ProjectName}', sProjectName, [rfIgnoreCase, rfReplaceAll]);

       sFile.Clear;
       sFile.WriteString(sFileContent);
       sFile.SaveToFile(GetRealFilePath(sDestinationPathWeb + PathDelim + ExtractFileName(sUnitLogin)));
       sFile.Free;
      end;
     {$ENDREGION}



     {$REGION 'REST SERVER API'}
      if (WizardForm.ComboBox_RestAPIServer.ItemIndex = 0) or (WizardForm.ComboBox_RestAPIServer.ItemIndex = 1) then //Auth
      begin
       {$REGION 'AUTH CLASS FILE'}
       if Pos(UpperCase('Includes Authentication'), UpperCase(WizardForm.ComboBox_RestAPIServer.Text)) > 0 then
       begin
        sFile:= TStringStream.Create('', TEncoding.UTF8);
        if WizardForm.CheckBox_RestAPIServer_UseClass.Checked then //Use Classes in API
         sFile.LoadFromFile(GetRealFilePath(sRESTAPIServerUnitAuthClassFile))
        else
         sFile.LoadFromFile(GetRealFilePath(sRESTAPIServerUnitAuthFile));
        sFileContent:= sFile.DataString;

        sFileContent := StringReplace(sFileContent, '<UNITNAME>', 'API.Auth', [rfIgnoreCase, rfReplaceAll]);
        sFileContent := StringReplace(sFileContent, '<COPYRIGHTYEAR>', IntToStr(CurrentYear), [rfIgnoreCase, rfReplaceAll]);
        sFileContent := StringReplace(sFileContent, '<ServerController>', sProjectName + 'WebApp', [rfIgnoreCase, rfReplaceAll]);
        sFileContent := StringReplace(sFileContent, '<CLASS_ID>', 'APIAuth', [rfIgnoreCase, rfReplaceAll]);

        sFile.Clear;
        sFile.WriteString(sFileContent);
        sFile.SaveToFile(GetRealFilePath(sDestinationPathWeb+ PathDelim + 'API.Auth.pas'));
        sFile.Free;
       end;
       {$ENDREGION}


       {$REGION 'PING CLASS FILE'}
        sFile:= TStringStream.Create('', TEncoding.UTF8);
        if WizardForm.CheckBox_RestAPIServer_UseClass.Checked then //Use Classes in API
         sFile.LoadFromFile(GetRealFilePath(sRESTAPIServerUnitPingClassFile))
        else
         sFile.LoadFromFile(GetRealFilePath(sRESTAPIServerUnitPingFile));
        sFileContent:= sFile.DataString;

        sFileContent := StringReplace(sFileContent, '<UNITNAME>', 'API.Ping', [rfIgnoreCase, rfReplaceAll]);
        sFileContent := StringReplace(sFileContent, '<COPYRIGHTYEAR>', IntToStr(CurrentYear), [rfIgnoreCase, rfReplaceAll]);
        sFileContent := StringReplace(sFileContent, '<ServerController>', sProjectName + 'WebApp', [rfIgnoreCase, rfReplaceAll]);
        sFileContent := StringReplace(sFileContent, '<CLASS_ID>', 'APIPing', [rfIgnoreCase, rfReplaceAll]);

        sFile.Clear;
        sFile.WriteString(sFileContent);
        sFile.SaveToFile(GetRealFilePath(sDestinationPathWeb+ PathDelim + 'API.Ping.pas'));
        sFile.Free;
       {$ENDREGION}


       {$REGION 'SESSION FILE'}
        sFile:= TStringStream.Create('', TEncoding.UTF8);
        sFile.LoadFromFile(GetRealFilePath(sRESTAPIServerSessionFile));
        sFileContent:= sFile.DataString;

        sFileContent := StringReplace(sFileContent, '<COPYRIGHTYEAR>', IntToStr(CurrentYear), [rfIgnoreCase, rfReplaceAll]);

        sFile.Clear;
        sFile.WriteString(sFileContent);
        sFile.SaveToFile(GetRealFilePath(sDestinationPathWeb+ PathDelim + 'D2Bridge.Rest.Session.pas'));
        sFile.Free;
       {$ENDREGION}

       sUNITs.Add('  API.Auth in ''API.Auth.pas'',');
       sUNITs.Add('  API.Ping in ''API.Ping.pas'',');
       sUNITs.Add('  D2Bridge.Rest.Session in ''D2Bridge.Rest.Session.pas'',');
      end;

     {$ENDREGION}



     {$REGION 'WEB dpropj'}
      //----- COPY DProj
      if sTypeServer = {$IFDEF FPC}tsWebAndLCL{$ELSE}tsWebAndVCL{$ENDIF} then
       {$IFDEF FPC}CopyFile{$ELSE}TFile.Copy{$ENDIF}(sSourceVCLDPROJFile, sPathWEBDPROJFile, false)
      else
{$IFDEF DELPHI}
      if sTypeServer = tsWebAndFMX then
       CopyFile(PWideChar(sSourceFMXDPROJFile), PWideChar(sPathWEBDPROJFile), false)
      else
      if sTypeServer = tsWebFMX then
       CopyFile(PWideChar(sSourceWebFMXDPROJFile), PWideChar(sPathWEBDPROJFile), false)
      else
{$ENDIF}
       {$IFDEF FPC}CopyFile{$ELSE}TFile.Copy{$ENDIF}(sSourceWebVCLDPROJFile, sPathWEBDPROJFile, false);

      sFile:= TStringStream.Create('', TEncoding.UTF8);
      sFile.LoadFromFile(GetRealFilePath(sPathWEBDPROJFile));
      sFileContent:= sFile.DataString;

      sFileContent := StringReplace(sFileContent, 'D2BridgeWebAppVCL', sProjectName, [rfIgnoreCase,rfReplaceAll]);
      sFileContent := StringReplace(sFileContent, 'D2BridgeWebAppFMX', sProjectName, [rfIgnoreCase,rfReplaceAll]);
      sFileContent := StringReplace(sFileContent, 'D2BridgeWebAppWithVCL', sProjectName, [rfIgnoreCase,rfReplaceAll]);
      sFileContent := StringReplace(sFileContent, 'D2BridgeWebAppWithFMX', sProjectName, [rfIgnoreCase,rfReplaceAll]);
      sFileContent := StringReplace(sFileContent, '{D2BridgeFrameworkPath}', sD2BridgeFrameworkSearchPath, [rfIgnoreCase,rfReplaceAll]);
      sFileContent:= StringReplace(sFileContent, '{ProjectName}', sProjectName, [rfIgnoreCase, rfReplaceAll]);
      sFileContent:= StringReplace(sFileContent, '{D2BridgeDirectives}', sD2BridgeDirectives.Text, [rfIgnoreCase, rfReplaceAll]);
      sFileContent:= StringReplace(sFileContent, '{D2BridgePath}', IncludeTrailingPathDelimiter(WizardForm.Edit_Path_D2Bridge.Text), [rfIgnoreCase, rfReplaceAll]);
      sFileContent:= StringReplace(sFileContent, '{PathDelim}', PathDelim, [rfIgnoreCase, rfReplaceAll]);

{$IFDEF FPC}
      if WizardForm.ComboBox_Server_Type.Text = 'Server Console (Recommended)' then
       sFileContent:= StringReplace(sFileContent, '{D2BridgeServerUnit}', 'Unit_D2Bridge_Server_Console.pas', [rfIgnoreCase, rfReplaceAll]);
{$ENDIF}

      //Replace Language Support Resource
      if (WizardForm.ComboBox_Enabled_Multi_Languages.Text = 'Yes') and (WizardForm.ComboBox_Embed_Translation_Files.Text = 'Yes') then
       sFileContent:= StringReplace(sFileContent, '{Language Support Resource}', '<RcCompile Include="D2Bridge.Lang.APP.rc"><Form>D2Bridge.Lang.APP.res</Form></RcCompile>', [rfIgnoreCase])
      else
       sFileContent:= StringReplace(sFileContent, '{Language Support Resource}', '', [rfIgnoreCase]);

      sFile.Clear;
      sFile.WriteString(sFileContent);
      SFile.SaveToFile(GetRealFilePath(sPathWEBDPROJFile));
      sFile.Free;
     {$ENDREGION}



     {$REGION 'WEB dpr'}
      if sTypeServer = {$IFDEF FPC}tsWebAndLCL{$ELSE}tsWebAndVCL{$ENDIF} then
       {$IFDEF FPC}CopyFile{$ELSE}TFile.Copy{$ENDIF}(sSourceVCLDPRFile, sProjectNameLogical, false)
      else
{$IFDEF DELPHI}
      if sTypeServer = tsWebAndFMX then
       CopyFile(PWideChar(sSourceFMXDPRFile), PWideChar(sProjectNameLogical), false)
      else
      if sTypeServer = tsWebFMX then
       CopyFile(PWideChar(sSourceWebFMXDPRFile), PWideChar(sProjectNameLogical), false)
      else
{$ENDIF}
       {$IFDEF FPC}CopyFile{$ELSE}TFile.Copy{$ENDIF}(sSourceWebDPRFile, sProjectNameLogical, false);


      sFile:= TStringStream.Create('', TEncoding.UTF8);
      sFile.LoadFromFile(GetRealFilePath(sProjectNameLogical));
      sFileContent:= sFile.DataString;

      if WizardForm.ComboBox_Server_Type.Text = 'Server Complete' then
      begin
       sPathUnitServer:= sDestinationPathWeb + PathDelim + 'Unit_D2Bridge_Server.pas';
       sPathDFMServer:= sDestinationPathWeb + PathDelim + 'Unit_D2Bridge_Server.dfm';
       sUNITs.Add('  Unit_D2Bridge_Server in ''Unit_D2Bridge_Server.pas'' {Form_D2Bridge_Server},');

       CopyFolderFiles(PWideChar(sPathWizard + PathDelim + 'Servers\Complete\*.*'), sDestinationPathWeb);

       sFileContent:= StringReplace(sFileContent, '{Units}', sUNITs.Text, [rfIgnoreCase]);
       sFileContent:= StringReplace(sFileContent, '{Server}', 'Application.CreateForm(TForm_D2Bridge_Server, Form_D2Bridge_Server);', []);
       sFileContent:= StringReplace(sFileContent, '{Application.Run;}', 'Application.Run;', [rfIgnoreCase]);
      end else
      if WizardForm.ComboBox_Server_Type.Text = 'Server Compact' then
      begin
       sPathUnitServer:= sDestinationPathWeb + PathDelim + 'Unit_D2Bridge_Server_Compact.pas';
       sPathDFMServer:= sDestinationPathWeb + PathDelim + 'Unit_D2Bridge_Server_Compact.dfm';
       sUNITs.Add('  Unit_D2Bridge_Server_Compact in ''Unit_D2Bridge_Server_Compact.pas'' {Form_D2Bridge_Server_Compact},');

       CopyFolderFiles(PWideChar(sPathWizard + PathDelim + 'Servers' + PathDelim + 'Compact' + PathDelim + '*.*'), sDestinationPathWeb);

       sFileContent:= StringReplace(sFileContent, '{Units}', sUNITs.Text, [rfIgnoreCase]);
       sFileContent:= StringReplace(sFileContent, '{Server}', 'Application.CreateForm(TForm_D2Bridge_Server_Compact, Form_D2Bridge_Server_Compact);', []);
       sFileContent:= StringReplace(sFileContent, '{Application.Run;}', 'Application.Run;', [rfIgnoreCase]);
      end else
      if WizardForm.ComboBox_Server_Type.Text = 'Server Console (Recommended)' then
      begin
       sPathUnitServer:= sDestinationPathWeb + PathDelim + 'Unit_D2Bridge_Server_Console.pas';
       sPathDFMServer:= '';
       sUNITs.Add('  Unit_D2Bridge_Server_Console in ''Unit_D2Bridge_Server_Console.pas'',');

{$IFDEF FPC}
       CopyFolderFiles(sPathWizard + PathDelim + 'Servers' + PathDelim + 'Console' + PathDelim + '*.*', sDestinationPathWeb);
{$ELSE}
       CopyFolderFiles(PWideChar(sPathWizard+'\Servers\Console\*.*'), sDestinationPathWeb);
{$ENDIF}

       sFileContent:= StringReplace(sFileContent, '{Units}', sUNITs.Text, [rfIgnoreCase]);
       sFileContent:= StringReplace(sFileContent, '//{$APPTYPE CONSOLE}', '{$APPTYPE CONSOLE}', [rfIgnoreCase]);
       sFileContent:= StringReplace(sFileContent, 'Application.MainFormOnTaskbar:= True;', 'Application.MainFormOnTaskbar:= False;', [rfIgnoreCase]);
       sFileContent:= StringReplace(sFileContent, '{Server}', 'TD2BridgeServerConsole.Run', [rfIgnoreCase]);
       sFileContent:= StringReplace(sFileContent, '{Application.Run;}', '', [rfIgnoreCase]);
      end;

      //Replace Language Support Resource
      if (WizardForm.ComboBox_Enabled_Multi_Languages.Text = 'Yes') and (WizardForm.ComboBox_Embed_Translation_Files.Text = 'Yes') then
       sFileContent:= StringReplace(sFileContent, '{Language Support Resource}', '{$R D2Bridge.Lang.APP.res D2Bridge.Lang.APP.rc}', [rfIgnoreCase])
      else
       sFileContent:= StringReplace(sFileContent, '{Language Support Resource}', '', [rfIgnoreCase]);

      //Replace Language Support
      sFileContent:= StringReplace(sFileContent, '{Language Support}', sLanguagesUnitsDPR.Text, [rfIgnoreCase]);

      sFileContent := StringReplace(sFileContent, 'D2BridgeWebAppVCL', sProjectName, [rfIgnoreCase,rfReplaceAll]);
      sFileContent := StringReplace(sFileContent, 'D2BridgeWebAppFMX', sProjectName, [rfIgnoreCase,rfReplaceAll]);
      sFileContent := StringReplace(sFileContent, 'D2BridgeWebAppWithVCL', sProjectName, [rfIgnoreCase,rfReplaceAll]);
      sFileContent := StringReplace(sFileContent, 'D2BridgeWebAppWithFMX', sProjectName, [rfIgnoreCase,rfReplaceAll]);
      sFileContent:= StringReplace(sFileContent, '{D2BridgePath}', IncludeTrailingPathDelimiter(WizardForm.Edit_Path_D2Bridge.Text), [rfIgnoreCase, rfReplaceAll]);
      sFileContent:= StringReplace(sFileContent, '{ProjectName}', sProjectName, [rfIgnoreCase, rfReplaceAll]);

      //----- PrimaryForm / Class
      sFileContent := StringReplace(sFileContent, '{PrimaryFormClass}', sClassPrimaryForm, [rfIgnoreCase, rfReplaceAll]);
      sFileContent := StringReplace(sFileContent, '{PrimaryFormUnit}', sUnitPrimaryForm, [rfIgnoreCase, rfReplaceAll]);

      sFile.Clear;
      sFile.WriteString(sFileContent);
      sFile.SaveToFile(GetRealFilePath(sProjectNameLogical));
      sFile.Free;
     {$ENDREGION}



     {$REGION 'Unit Server Properties'}
      sFile:= TStringStream.Create('', TEncoding.UTF8);
      sFile.LoadFromFile(GetRealFilePath(sPathUnitServer));
      sFileContent:= sFile.DataString;

      //----- PrimaryForm / Class
      sFileContent := StringReplace(sFileContent, '{PrimaryFormClass}', sClassPrimaryForm, [rfIgnoreCase, rfReplaceAll]);
      sFileContent := StringReplace(sFileContent, '{PrimaryFormUnit}', sUnitPrimaryForm, [rfIgnoreCase, rfReplaceAll]);

      //----- SSL
      if WizardForm.ComboBox_UseSSL.Text = 'Yes' then
      begin
       sFileContent := StringReplace(sFileContent, '//D2BridgeServerController.Prism.Options.SSL:= true;', 'D2BridgeServerController.Prism.Options.SSL:= true;', [rfIgnoreCase]);
      end;
      sFileContent := StringReplace(sFileContent, '{Certificate}', WizardForm.Edit_SSL_Certificate.Text, [rfIgnoreCase]);
      sFileContent := StringReplace(sFileContent, '{Certificate_Key}', WizardForm.Edit_SSL_Key.Text, [rfIgnoreCase]);
      sFileContent := StringReplace(sFileContent, '{Certificate Intermediate}', WizardForm.Edit_SSL_Intermediate.Text, [rfIgnoreCase]);
      sFileContent := StringReplace(sFileContent, '{ProjectName}', sProjectName, [rfIgnoreCase, rfReplaceAll]);

      //----- Server Port
      sFileContent := StringReplace(sFileContent, '{Server_Port}', WizardForm.Edit_Server_Port.Text, [rfIgnoreCase]);

      //----- Server Name
      sFileContent := StringReplace(sFileContent, '{Server_Name}', WizardForm.Edit_Server_Name.Text, [rfIgnoreCase]);

      //----- Path JS
      sFileContent := StringReplace(sFileContent, '{PathJS}', WizardForm.Edit_Path_JS.Text, [rfIgnoreCase]);
      //----- Path CSS
      sFileContent := StringReplace(sFileContent, '{PathCSS}', WizardForm.Edit_Path_CSS.Text, [rfIgnoreCase]);

      //----- Language
      sFileContent := StringReplace(sFileContent, '{Languages}', '[' + sLanguagesSET.CommaText + ']', [rfIgnoreCase, rfReplaceAll]);

      //----- Options jQuery
      sFileContent := StringReplace(sFileContent, '//D2BridgeServerController.Prism.Options.IncludeJQuery:= true;', 'D2BridgeServerController.Prism.Options.IncludeJQuery:= true;', [rfIgnoreCase]);

      sFile.Clear;
      sFile.WriteString(sFileContent);
      sFile.SaveToFile(GetRealFilePath(sPathUnitServer));
      sFile.Free;
     {$ENDREGION}


     {$REGION 'Form Server Properties'}
      if sPathDFMServer <> '' then
      begin
       sFile:= TStringStream.Create('', TEncoding.UTF8);
       sFile.LoadFromFile(GetRealFilePath(sPathDFMServer));
       sFileContent:= sFile.DataString;

       //----- SERVER PORT
       sFileContent := StringReplace(sFileContent, '{Server_Port}', WizardForm.Edit_Server_Port.Text, [rfIgnoreCase]);

       //----- SERVER NAME
       sFileContent := StringReplace(sFileContent, '{Server_Name}', WizardForm.Edit_Server_Name.Text, [rfIgnoreCase]);

       sFile.Clear;
       sFile.WriteString(sFileContent);
       sFile.SaveToFile(GetRealFilePath(sPathDFMServer));
       sFile.Free;
      end;
     {$ENDREGION}



     {$REGION 'Unit Form1'}
      sFile:= TStringStream.Create('', TEncoding.UTF8);
      sFile.LoadFromFile(GetRealFilePath(sDestinationPathWeb + PathDelim + 'Unit1'+'.pas'));
      sFileContent:= sFile.DataString;

      //----- Template HTML Files
      sFileContent := StringReplace(sFileContent, '{TemplateMasterHTMLFile}', WizardForm.Edit_Template_Maste_Page.Text, [rfIgnoreCase]);
      sFileContent := StringReplace(sFileContent, '{TemplateHTMLFile}', WizardForm.Edit_Template_Page.Text, [rfIgnoreCase]);
      sFileContent := StringReplace(sFileContent, '{ProjectName}', sProjectName, [rfIgnoreCase, rfReplaceAll]);

      //MainMenu
      if WizardForm.RadioButton_Menu_SideBar.Checked and (WizardForm.ComboBox_Template.Text = 'None') then
       sFileContent := StringReplace(sFileContent, '{MENU}', 'SideMenu(MainMenu1);', [rfIgnoreCase, rfReplaceAll])
      else
       sFileContent := StringReplace(sFileContent, '{MENU}', 'VCLObj(MainMenu1);', [rfIgnoreCase, rfReplaceAll]);

      sFile.Clear;
      sFile.WriteString(sFileContent);
      sFile.SaveToFile(GetRealFilePath(sDestinationPathWeb + PathDelim + 'Unit1'+'.pas'));
      sFile.Free;
     {$ENDREGION}



     with WizardForm.TemplatesList.Items[WizardForm.ComboBox_Template.ItemIndex] do
     begin
      if TemplateFilePath <> '' then
      begin
       if Zipped then
       begin
        {$IFDEF FPC}ExtractZipFile{$ELSE}TZipFile.ExtractZipFile{$ENDIF}(GetRealFilePath(sPathWizard + PathDelim + TemplateFilePath), sPathwwwroot);
       end;
      end;

     end;

{$IFDEF FPC}
    PathPROJ:= sPathWEBDPROJFile;
{$ELSE}
    services := (BorlandIDEServices as IOTAModuleServices);
    services.OpenModule(PChar(sProjectNameLogical));
{$ENDIF}


    //Project.geterverStarter.pas';
{$IFDEF FPC}
    MessageDlg('The Lazarus Web project was created Successfully!', mtinformation, [mbok], 0);
{$ELSE}
    MessageDlg('The Delphi Web project was created Successfully!', mtinformation, [mbok], 0);
{$ENDIF}
   end;
  finally
   if WizardForm.EnableCreateProject then
   begin
    FreeAndNil(sLanguagesUnitsDPR);
    FreeAndNil(sLanguagesJSON);
    FreeAndNil(sLanguagesUSES);
    FreeAndNil(sLanguagesCREATE);
    FreeAndNil(sLanguagesDESTROY);
    FreeAndNil(sLanguagesSET);
    FreeAndNil(sUNITs);
    //WizardForm.Free;
   end;
  end;
end;

end.
