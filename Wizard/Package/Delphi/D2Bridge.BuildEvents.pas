unit D2Bridge.BuildEvents;

interface

uses
  Windows, ShellAPI, SysUtils, Classes, Forms, Dialogs, ToolsAPI, XMLDoc, XMLIntf;


type
  TD2BridgeBuildNotifier = class(TNotifierObject,
                                  IOTAIDENotifier,
                                  IOTAIDENotifier50,
                                  IOTAIDENotifier80)
  private
    //FIndex: Integer;
  public
    // IOTAIDENotifier
    procedure FileNotification(NotifyCode: TOTAFileNotification; const FileName: string; var Cancel: Boolean);
    procedure BeforeCompile(const Project: IOTAProject; var Cancel: Boolean); overload;
    procedure AfterCompile(Succeeded: Boolean); overload;

    // IOTAIDENotifier50
    procedure BeforeCompile(const Project: IOTAProject; IsCodeInsight: Boolean; var Cancel: Boolean); overload;
    procedure AfterCompile(Succeeded: Boolean; IsCodeInsight: Boolean); overload;

    // IOTAIDENotifier80
    procedure AfterCompile(const Project: IOTAProject; Succeeded: Boolean; IsCodeInsight: Boolean); overload;
  end;


procedure RegisterGlobalBuildNotifier;
procedure UnregisterGlobalBuildNotifier;


var
 D2BridgeWizardNotifierIndex: integer = -1;
 D2BridgeBuildNotifier: TD2BridgeBuildNotifier;


implementation


uses
  D2Bridge.Wizard.Util, System.UITypes;



procedure RegisterGlobalBuildNotifier;
var
  IDE: IOTAServices;
begin
  IDE := BorlandIDEServices as IOTAServices;
  if Assigned(IDE) then
  begin
    D2BridgeBuildNotifier := TD2BridgeBuildNotifier.Create;
    D2BridgeWizardNotifierIndex:= IDE.AddNotifier(D2BridgeBuildNotifier);
    //Notifier.SetIndex(D2BridgeWizardNotifierIndex);
  end;
end;


procedure UnregisterGlobalBuildNotifier;
var
  IDE: IOTAServices;
begin
 if Assigned(D2BridgeBuildNotifier) and (D2BridgeWizardNotifierIndex <> -1) then
  begin
    IDE := BorlandIDEServices as IOTAServices;
    if Assigned(IDE) then
    begin
     IDE.RemoveNotifier(D2BridgeWizardNotifierIndex);
     D2BridgeWizardNotifierIndex := -1;
    end;
  end;
end;

{ TD2BridgeBuildNotifier }

//procedure TD2BridgeBuildNotifier.SetIndex(AIndex: Integer);
//begin
//  FIndex := AIndex;
//end;
//
//function TD2BridgeBuildNotifier.GetIndex: Integer;
//begin
//  Result := FIndex;
//end;

function ProjectIsD2Bridge(AProject: IOTAProject): Boolean;
var
  i: Integer;
  Module: IOTAModuleInfo;
begin
  Result := False;
  for i := 0 to AProject.GetModuleCount - 1 do
  begin
    Module := AProject.GetModule(i);
    if SameText(ExtractFileName(Module.FileName), 'D2Bridge.ServerControllerBase.pas') then
      Exit(True);
  end;
  // fallback: checar diretivas no .dproj
//  Result := ProjectHasDefine(AProject, 'D2Bridge');
end;


function GetProjectSourceEditor(AProject: IOTAProject): IOTASourceEditor;
var
  i: Integer;
  Editor: IOTAEditor;
begin
  Result := nil;
  for i := 0 to AProject.GetModuleCount - 1 do
  begin
    Editor := (BorlandIDEServices as IOTAModuleServices)
                .FindModule(AProject.FileName)
                .GetModuleFileEditor(i);
    if Supports(Editor, IOTASourceEditor, Result) then
      Exit;
  end;
end;



function ExtractFileNameOnly(const FileName: string): string;
begin
  Result := ChangeFileExt(ExtractFileName(FileName), '');
end;



procedure FixDprD2docker(AProject: IOTAProject);
var
 sFileContent: string;
 sFile: TStringStream;
 sOldProgramLine, sNewProgramLine: string;
 ProjectFile, ProjectName: string;
begin
 ProjectFile := AProject.FileName;

 if not FileExists(ProjectFile) then
  Exit;

 ProjectFile := ChangeFileExt(AProject.FileName, '.dpr');

 if not FileExists(ProjectFile) then
  Exit;

 sFile:= TStringStream.Create('', TEncoding.UTF8);
 try
  sFile.LoadFromFile(GetRealFilePath(ProjectFile));
  sFileContent:= sFile.DataString;

  ProjectName := ChangeFileExt(ExtractFileName(ProjectFile), '');

  sOldProgramLine:= Format('program %s;', [ProjectName]);

  if Pos(UpperCase(sOldProgramLine), UpperCase(sFileContent)) > 0 then
  begin
   sNewProgramLine := Format(
     '{$IFDEF D2DOCKER}library{$ELSE}program{$ENDIF} %s;',
     [ProjectName]);

   sFileContent:= StringReplace(sFileContent, sOldProgramLine, sNewProgramLine, [rfReplaceAll, rfIgnoreCase]);
   sFileContent:= StringReplace(sFileContent, 'D2BridgeServerController.Prism.INIConfig.', 'D2BridgeServerController.APPConfig.', [rfReplaceAll, rfIgnoreCase]);

   sFile.Clear;
   sFile.WriteString(sFileContent);
   sFile.SaveToFile(ProjectFile);
  end;

 finally
  sFile.Free;
 end;
end;


procedure FixServerConsoleD2docker(AProject: IOTAProject);
var
 vServerConsoleFile: string;
 sFileContent: string;
 sFile: TStringStream;
 vNewCode: string;
begin
 vServerConsoleFile:=
  IncludeTrailingPathDelimiter(ExtractFilePath(AProject.FileName)) + 'Unit_D2Bridge_Server_Console.pas';

 if not FileExists(vServerConsoleFile) then
  exit;


 sFile:= TStringStream.Create('', TEncoding.UTF8);
 try
  sFile.LoadFromFile(GetRealFilePath(vServerConsoleFile));
  sFileContent:= sFile.DataString;

  if Pos(UpperCase('D2BridgeServerController.IsD2DockerContext'), UpperCase(sFileContent)) = 0 then
  begin
   vNewCode:=
    sLineBreak +
    ' if D2BridgeServerController.IsD2DockerContext then' + sLineBreak +
    '  Exit;' + sLineBreak +
    sLineBreak +
    ' D2BridgeServerController.StartServer;' + sLineBreak;

   sFileContent:= StringReplace(sFileContent, 'D2BridgeServerController.StartServer;', vNewCode, [rfReplaceAll, rfIgnoreCase]);
  end;

  if Pos(UpperCase('WaitingForReturn:= false;'), UpperCase(sFileContent)) > 0 then
  begin
    vNewCode:=
     sLineBreak +
     ' if D2BridgeServerController.IsD2DockerContext then' + sLineBreak +
     '  Exit;' + sLineBreak +
     sLineBreak +
     ' WaitingForReturn:= false;' + sLineBreak;

    sFileContent:= StringReplace(sFileContent, 'WaitingForReturn:= false;', vNewCode, [rfReplaceAll, rfIgnoreCase]);
  end;

  if Pos(UpperCase('//Security'), UpperCase(sFileContent)) > 0 then
  begin
    vNewCode:=
     sLineBreak +
     ' //D2BridgeServerController.APPSignature:= ''...'';' +
     sLineBreak +
     sLineBreak +
     sLineBreak +
     ' //Security';

    sFileContent:= StringReplace(sFileContent, '//Security', vNewCode, [rfReplaceAll, rfIgnoreCase]);
  end;


  sFile.Clear;
  sFile.WriteString(sFileContent);
  sFile.SaveToFile(vServerConsoleFile);
 finally
  sFile.Free;
 end;
end;


procedure FixAddD2dockerDeployConfig(AProject: IOTAProject);
var
  Xml: IXMLDocument;
  Root, Item, ItemD2DockerDeploy, ItemCfg, ItemBuildCfg: IXMLNode;
  ProjFile, ConfigName, cfgStr: string;
  Exists: Boolean;
  i: Integer;
  cfgNum: integer;
  cfgAvailable: boolean;
begin
  ProjFile := AProject.FileName;
  if not FileExists(ProjFile) then Exit;

  Xml := LoadXMLDocument(ProjFile);
  Root := Xml.DocumentElement;

  ConfigName := 'D2Docker Deploy';
  Exists := False;

  // --- verificar se já existe a configuração ---
  for i := 0 to Root.ChildNodes.Count - 1 do
  begin
    Item := Root.ChildNodes[i];
    if (Item.NodeName = 'PropertyGroup') and
       (Item.HasAttribute('Condition')) and
       (Pos(ConfigName, Item.GetAttribute('Condition')) > 0) then
    begin
      Exists := True;
      Break;
    end;
  end;

  if (not Exists) and
     (MessageDlg('Update this D2Bridge project to the latest version?', TMsgDlgType.mtInformation, [mbYes,mbNo], 0) = mryes) then
  begin
   cfgnum := 1;
   cfgAvailable:= false;
   while not cfgAvailable do
   begin
    cfgStr:= 'Cfg_' + IntToStr(cfgNum);
    Inc(cfgNum);
    cfgAvailable:= true;
    for i := 0 to Root.ChildNodes.Count - 1 do
    begin
      Item := Root.ChildNodes[i];
      if (Item.NodeName = 'PropertyGroup') and
         (Item.HasAttribute('Condition')) and
         (Pos(cfgStr, Item.GetAttribute('Condition')) > 0) then
      begin
        cfgAvailable := false;
        Break;
      end;
    end;
   end;

   // cria novo PropertyGroup baseado em Release
   ItemD2DockerDeploy := Root.AddChild('PropertyGroup');
   ItemD2DockerDeploy.Attributes['Condition'] :=
       '''$(Config)''==''D2Docker Deploy'' or ''$(' + cfgStr + ')''!=''''';

   ItemD2DockerDeploy.AddChild(cfgStr).Text:= 'true';
   ItemD2DockerDeploy.AddChild('CfgParent').Text:= 'Base';
   ItemD2DockerDeploy.AddChild('Base').Text:= 'true';



   ItemBuildCfg := Root.ChildNodes.FindNode('ItemGroup').AddChild('BuildConfiguration');
   ItemBuildCfg.Attributes['Include'] := 'D2Docker Deploy';

   ItemBuildCfg.AddChild('key').Text:= cfgStr;
   ItemBuildCfg.AddChild('CfgParent').Text:= 'Base';



   ItemCfg := Root.AddChild('PropertyGroup');
   ItemCfg.Attributes['Condition'] :=
     '''$(' + cfgStr + ')''!=''''';

   ItemCfg.AddChild('DCC_Define').Text :=
     'RELEASE;D2Docker;D2Bridge;$(DCC_Define)';

   ItemCfg.AddChild('DCC_ExeOutput').Text:= '.\Web';
   ItemCfg.AddChild('DCC_BplOutput').Text:= '.\Web';
   ItemCfg.AddChild('AppType').Text:= 'Library';
   ItemCfg.AddChild('OutputExt').Text:= 'd2d';
   ItemCfg.AddChild('DCC_LargeAddressAware').Text:= 'true';

   // salvar alterações
   Xml.SaveToFile(ProjFile);


   FixDprD2docker(AProject);

   FixServerConsoleD2docker(AProject);

   AProject.Refresh(true);
  end;

end;


procedure TD2BridgeBuildNotifier.FileNotification(NotifyCode: TOTAFileNotification; const FileName: string; var Cancel: Boolean);
var
  Project: IOTAProject;
begin
  if NotifyCode = ofnFileOpened then
  begin
   //Just DPROJ
   if SameText(ExtractFileExt(FileName),'.dproj') then
   begin
    Project := GetActiveProject;
    if Assigned(Project) and ProjectIsD2Bridge(Project) then
    begin
     //MessageBox(0, PChar('Treste'), pchar('asdf'), 0);
     FixAddD2dockerDeployConfig(Project);
    end;
   end;
  end;
end;

procedure TD2BridgeBuildNotifier.BeforeCompile(const Project: IOTAProject; var Cancel: Boolean);
begin
 inherited;
  // Compatibilidade
end;

procedure TD2BridgeBuildNotifier.BeforeCompile(const Project: IOTAProject; IsCodeInsight: Boolean; var Cancel: Boolean);
var
  ProjectName: string;
begin
 inherited;

 if not Assigned(Project) then Exit;
end;

procedure TD2BridgeBuildNotifier.AfterCompile(Succeeded: Boolean);
begin
 inherited;
  // Compatibilidade
end;

procedure TD2BridgeBuildNotifier.AfterCompile(Succeeded: Boolean; IsCodeInsight: Boolean);
begin
  // Compatibilidade
 inherited;
end;

procedure TD2BridgeBuildNotifier.AfterCompile(const Project: IOTAProject; Succeeded: Boolean; IsCodeInsight: Boolean);
var
  ConfigName, PlatformName, vProjectFile, vParameters,
  DeployFileWin32, DeployFileWin64: string;
begin
 inherited;

  if not Succeeded then Exit;
  if not Assigned(Project) then Exit;

  try
    if SameText(ExtractFileExt(Project.FileName), '.bpl') then Exit;

    ConfigName := Project.CurrentConfiguration;
    PlatformName := Project.CurrentPlatform;

    if Pos('D2DOCKER', UpperCase(ConfigName)) > 0 then
    begin
      if not IsValidD2BridgeFrameworkPath then
      begin
       MessageDlg('D2Bridge Framework Path not found, go on File -> New -> D2Bridge Framework, and create project and check D2Bridge path', mterror, [mbcancel], 0);
       Exit;
      end;

      vProjectFile := Project.ProjectOptions.TargetName;
      if vProjectFile = '' then Exit;
      if not FileExists(vProjectFile) then Exit;

      vParameters := '-app="' + vProjectFile + '"';

      DeployFileWin32 := IncludeTrailingPathDelimiter(D2BridgeFrameworkRootPath) +
                         'Wizard' + PathDelim +
                         'D2Docker' + PathDelim +
                         'Deploy' + PathDelim +
                         'D2DockerDeployWin32.exe';

      DeployFileWin64 := IncludeTrailingPathDelimiter(D2BridgeFrameworkRootPath) +
                         'Wizard' + PathDelim +
                         'D2Docker' + PathDelim +
                         'Deploy' + PathDelim +
                         'D2DockerDeployWin64.exe';

      if (Pos('WIN32', UpperCase(PlatformName)) > 0) and FileExists(DeployFileWin32) then
        ShellExecute(0, 'open', PChar(DeployFileWin32), PChar(vParameters), nil, SW_SHOWNORMAL)
      else if (Pos('WIN64', UpperCase(PlatformName)) > 0) and FileExists(DeployFileWin64) then
        ShellExecute(0, 'open', PChar(DeployFileWin64), PChar(vParameters), nil, SW_SHOWNORMAL);
    end;
  except
    // Silenciar falhas
  end;
end;

end.


