unit D2Bridge.BuildEvents;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, LazIDEIntf, ProjectIntf, FileUtil, System.UITypes, RegExpr,
  Laz2_DOM, Laz2_XMLRead, Laz2_XMLWrite,
  {$IFDEF MSWINDOWS}
    windows,
  {$ELSE}

  {$ENDIF}
  Dialogs;

procedure RegisterD2BridgeBuildEvents;
procedure UnregisterD2BridgeBuildEvents;

procedure Register;

implementation

uses
  Forms,
  D2Bridge.Wizard.Util;


type

  { TD2BridgeEventsHandler }

  TD2BridgeEventsHandler = class
  private

  public
   procedure OnBuildFinished(Sender: TObject; BuildSuccessful: Boolean);
   function OnProjectOpened(Sender: TObject; AProject: TLazProject): TModalResult;
  end;

var
  D2BridgeEventsHandler: TD2BridgeEventsHandler = nil;


function ProjectIsD2Bridge(AProject: TLazProject): Boolean;
var
 i: integer;
begin
 result:= false;

 for i:= 0 to Pred(AProject.FileCount) do
 begin
  if SameText(ExtractFileName(AProject.Files[I].FileName), 'D2Bridge.ServerControllerBase.pas') then
  begin
   result:= true;
   break;
  end;
 end;
end;


procedure FixDprD2docker(AProject: TLazProject);
var
  sFileContent: string;
  sFile: TStringStream;
  ProjectFile: string;
  Regex: TRegExpr;
  ProgramName: string;
  ReplaceLine: string;
begin
  ProjectFile := AProject.MainFile.Filename;

  if not FileExists(ProjectFile) then
    Exit;

  ProjectFile := ChangeFileExt(ProjectFile, '.lpr');

  if not FileExists(ProjectFile) then
    Exit;

  sFile := TStringStream.Create('', TEncoding.UTF8);
  try
    sFile.LoadFromFile(GetRealFilePath(ProjectFile));
    sFileContent := sFile.DataString;

    Regex := TRegExpr.Create;
    try
      Regex.ModifierI := True; // case-insensitive
      Regex.Expression := '^\s*program\s+([a-zA-Z0-9_]+)\s*;';
      if Regex.Exec(sFileContent) then
      begin
        ProgramName := Regex.Match[1];
        ReplaceLine := Format(
          '{$IFDEF D2DOCKER}library{$ELSE}program{$ENDIF} %s;',
          [ProgramName]
        );

        sFileContent := Regex.Replace(sFileContent, ReplaceLine, False);

        // também faz o ajuste do controller
        sFileContent := StringReplace(
          sFileContent,
          'D2BridgeServerController.Prism.INIConfig.',
          'D2BridgeServerController.APPConfig.',
          [rfReplaceAll, rfIgnoreCase]
        );
      end;

      //if POS(UpperCase('D2Bridge.API.D2Docker.Comm'), UpperCase(sFileContent)) <= 0 then
      // sFileContent:= StringReplace(sFileContent, 'D2Bridge.Instance,', 'D2Bridge.Instance, D2Bridge.API.D2Docker.Comm,', [rfReplaceAll, rfIgnoreCase]);

      sFile.Clear;
      sFile.WriteString(sFileContent);
      sFile.SaveToFile(ProjectFile);
    finally
      Regex.Free;
    end;
  finally
    sFile.Free;
  end;
end;


procedure FixServerConsoleD2docker(AProject: TLazProject);
var
 I: integer;
 vServerConsoleFile: string;
 sFileContent: string;
 sFile: TStringStream;
 vNewCode: string;
begin
 vServerConsoleFile:=
  IncludeTrailingPathDelimiter(ExtractFilePath(AProject.MainFile.FileName)) + 'Unit_D2Bridge_Server_Console.pas';

 if not FileExists(vServerConsoleFile) then
  exit;


 sFile:= TStringStream.Create('', TEncoding.UTF8);
 try
  sFile.LoadFromFile(GetRealFilePath(vServerConsoleFile));
  sFileContent:= sFile.DataString;

  if Pos(UpperCase('D2BridgeServerController.IsD2DockerContext'), UpperCase(sFileContent)) <= 0 then
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


procedure FixAddD2dockerDeployConfig(AProject: TLazProject);
var
 i: integer;
 Doc:  TXMLDocument;
 Root, Item, vProjectOptions, vBuildModes: TDOMNode;
 vRelease, vD2dockerDeploy: TDOMNode;
 vDockerCompilerOptions, vDockerTarget, vD2dockerOther,
 vD2DockerLinking, vD2dockerLinkingOptions: TDOMNode;
 vDockerFilename, VDockerCustomOptions, DDockerExecutableType: TDOMElement;
 vProjectFileName: string;
 Exists: Boolean;
begin
 vProjectFileName:= ChangeFileExt(AProject.MainFile.Filename, '.lpi');

 if not FileExists(vProjectFileName) then Exit;

 vProjectOptions:= nil;
 vBuildModes:= nil;
 vRelease:= nil;
 vD2dockerDeploy:= nil;

 Exists := False;

 ReadXMLFile(Doc, vProjectFileName);
 Root := Doc.DocumentElement;

 try
  for i := 0 to Root.ChildNodes.Count - 1 do
  begin
   Item := Root.ChildNodes.Item[i];
   if SameText(Item.NodeName, 'ProjectOptions') then
   begin
    vProjectOptions:= Item;
    break;
   end;
  end;


  if not Assigned(vProjectOptions) then
   exit;

  for i := 0 to vProjectOptions.ChildNodes.Count - 1 do
  begin
   Item := vProjectOptions.ChildNodes.Item[i];
   if SameText(Item.NodeName, 'BuildModes') then
   begin
    vBuildModes:= Item;
    break;
   end;
  end;


  if not Assigned(vBuildModes) then
   exit;


  for i := 0 to vBuildModes.ChildNodes.Count - 1 do
  begin
    Item := vBuildModes.ChildNodes.Item[i];
    if SameText(Item.NodeName, 'Item') and
       (Item.Attributes <> nil) and
       (Pos('D2Docker Deploy', Item.Attributes.GetNamedItem('Name').NodeValue) > 0) then
    begin
      Exists := True;
      vRelease:= Item;
      Break;
    end;
  end;

  if Exists then
   exit;


  for i := 0 to vBuildModes.ChildNodes.Count - 1 do
  begin
    Item := vBuildModes.ChildNodes.Item[i];
    if SameText(Item.NodeName, 'Item') and
       (Item.Attributes <> nil) and
       (Pos('D2Bridge Web Release', Item.Attributes.GetNamedItem('Name').NodeValue) > 0) then
    begin
      Exists := True;
      vRelease:= Item;
      Break;
    end;
  end;

  if not Exists then
   exit;


  if TDOMElement(vRelease).GetElementsByTagName('CompilerOptions') = nil then
   exit;

  if TDOMElement(TDOMElement(vRelease).GetElementsByTagName('CompilerOptions').Item[0]).GetElementsByTagName('Target') = nil then
   exit;

  if TDOMElement(TDOMElement(vRelease).GetElementsByTagName('CompilerOptions').Item[0]).GetElementsByTagName('Other') = nil then
   exit;

  if TDOMElement(TDOMElement(vRelease).GetElementsByTagName('CompilerOptions').Item[0]).GetElementsByTagName('Linking') = nil then
   exit;


  if (MessageDlg('Update this D2Bridge project to the latest version?', mtInformation, [mbYes, mbNo], 0) <> mrYes) then
   exit;


  vD2dockerDeploy:= Doc.CreateElement('Item');
  TDOMElement(vD2dockerDeploy).SetAttribute('Name', 'D2Docker Deploy');
  vD2dockerDeploy.AppendChild(vRelease.FirstChild.CloneNode(true));


  vDockerCompilerOptions:= TDOMElement(vD2dockerDeploy).GetElementsByTagName('CompilerOptions').Item[0];
  vDockerTarget:= TDOMElement(vDockerCompilerOptions).GetElementsByTagName('Target').Item[0];
  vDockerFilename:= TDOMElement(TDOMElement(vDockerTarget).GetElementsByTagName('Filename').Item[0]);
  vD2dockerOther:= TDOMElement(vDockerCompilerOptions).GetElementsByTagName('Other').Item[0];
  VDockerCustomOptions:= TDOMElement(TDOMElement(vD2dockerOther).GetElementsByTagName('CustomOptions').Item[0]);
  vD2DockerLinking:= TDOMElement(vDockerCompilerOptions).GetElementsByTagName('Linking').Item[0];
  vD2dockerLinkingOptions:= TDOMElement(vD2DockerLinking).GetElementsByTagName('Options').Item[0];

  vDockerFilename.SetAttribute('Value', ChangeFileExt(vDockerFilename.GetAttribute('Value'), '.d2d'));
  vDockerFilename.SetAttribute('ApplyConventions', 'False');

  VDockerCustomOptions.SetAttribute('Value', '-dD2Bridge -dD2Docker');

  if (TDOMElement(vD2dockerLinkingOptions).GetElementsByTagName('ExecutableType') <> nil) and
     (TDOMElement(vD2dockerLinkingOptions).GetElementsByTagName('ExecutableType').Count > 0) then
  begin
   DDockerExecutableType:= TDOMElement(TDOMElement(vD2dockerLinkingOptions).GetElementsByTagName('ExecutableType').Item[0]);
  end else
  begin
   DDockerExecutableType:= Doc.CreateElement('ExecutableType');
   vD2dockerLinkingOptions.AppendChild(DDockerExecutableType);
  end;
  DDockerExecutableType.SetAttribute('Value', 'Library');


  vBuildModes.AppendChild(vD2dockerDeploy);

  // salvar alterações
  WriteXMLFile(Doc, vProjectFileName);


  //Fix DPR
  FixDprD2docker(AProject);

  //Fix Server Console
  FixServerConsoleD2docker(AProject);


  //Refresh Project ....
  AProject.Modified := false;
  LazarusIDE.DoOpenProjectFile(AProject.MainFile.Filename, []);
 finally
  Doc.Free;
 end;
end;




procedure TD2BridgeEventsHandler.OnBuildFinished(Sender: TObject; BuildSuccessful: Boolean);
var
  Project: TLazProject;
  vProjectFile: string;
  vParameters: string;
  vDeployFileWin32, vDeployFileWin64: string;
  vPlatformName: string;
  vProjectDir, vAbsoluteFile: string;
begin
  if not BuildSuccessful then Exit;

  Project := LazarusIDE.ActiveProject;
  if Assigned(Project) then
  begin
    if Pos(UpperCase('D2Docker Deploy'), Project.ActiveBuildModeID) >= 0 then
    begin
      if not IsValidD2BridgeFrameworkPath then Exit;

      //Showmessage(Project.LazCompilerOptions.TargetFilename);
      //Showmessage(Project.LazCompilerOptions.GetEffectiveTargetCPU);
      //Showmessage(Project.LazCompilerOptions.GetEffectiveTargetOS);

      vProjectFile := Project.LazCompilerOptions.TargetFilename;
      vProjectDir := ExtractFilePath(Project.ProjectInfoFile);
      vAbsoluteFile := ExpandFileName(
                          IncludeTrailingPathDelimiter(ExtractFilePath(Project.ProjectInfoFile)) +
                          Project.LazCompilerOptions.TargetFilename
                       );

      if vAbsoluteFile = '' then Exit;
      if not FileExists(vAbsoluteFile) then Exit;

      vPlatformName:= Project.LazCompilerOptions.GetEffectiveTargetOS;

      vParameters := '-app="' + vAbsoluteFile + '"';

      vDeployFileWin32 := IncludeTrailingPathDelimiter(D2BridgeFrameworkRootPath) +
                         'Wizard' + PathDelim +
                         'D2Docker' + PathDelim + 'Deploy' + PathDelim + 'D2DockerDeployWin32.exe';

      vDeployFileWin64 := IncludeTrailingPathDelimiter(D2BridgeFrameworkRootPath) +
                         'Wizard' + PathDelim +
                         'D2Docker' + PathDelim + 'Deploy' + PathDelim + 'D2DockerDeployWin64.exe';

      if (Pos(UpperCase('WIN32'), UpperCase(vPlatformName)) > 0) and FileExists(vDeployFileWin32) then
{$IFDEF MSWINDOWS}
        ShellExecute(0, 'open', PChar(vDeployFileWin32), PChar(vParameters), nil, SW_SHOWNORMAL)
{$ELSE}

{$ENDIF}
      else if (Pos(UpperCase('WIN64'), UpperCase(vPlatformName)) > 0) and FileExists(vDeployFileWin64) then
{$IFDEF MSWINDOWS}
        ShellExecute(0, 'open', PChar(vDeployFileWin64), PChar(vParameters), nil, SW_SHOWNORMAL);
{$ELSE}

{$ENDIF}

      //Output File Name
    end;
  end;
end;

function TD2BridgeEventsHandler.OnProjectOpened(Sender: TObject; AProject: TLazProject): TModalResult;
begin
 if Assigned(AProject) and ProjectIsD2Bridge(AProject) then
 begin
  FixAddD2dockerDeployConfig(AProject);
 end;

 result:= mrOK;
end;

procedure RegisterD2BridgeBuildEvents;
begin
  if not Assigned(D2BridgeEventsHandler) then
  begin
    D2BridgeEventsHandler := TD2BridgeEventsHandler.Create;
    LazarusIDE.AddHandlerOnProjectBuildingFinished(D2BridgeEventsHandler.OnBuildFinished);
    LazarusIDE.AddHandlerOnProjectOpened(D2BridgeEventsHandler.OnProjectOpened);
  end;
end;

procedure UnregisterD2BridgeBuildEvents;
begin
  if Assigned(D2BridgeEventsHandler) then
  begin
    LazarusIDE.RemoveHandlerOnProjectBuildingFinished(D2BridgeEventsHandler.OnBuildFinished);
    LazarusIDE.RemoveHandlerOnProjectOpened(D2BridgeEventsHandler.OnProjectOpened);
    FreeAndNil(D2BridgeEventsHandler);
  end;
end;

procedure Register;
begin
 RegisterD2BridgeBuildEvents;
end;


end.

