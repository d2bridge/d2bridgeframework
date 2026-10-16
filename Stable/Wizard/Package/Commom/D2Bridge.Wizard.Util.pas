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

unit D2Bridge.Wizard.Util;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, Generics.Collections, IniFiles, StdCtrls, Forms, Dialogs,
  StrUtils,
{$IFDEF FPC}
  Zipper, ProjectIntf, LazIDEIntf, FileUtil, RegExpr, LazFileUtils, LCLintf,
  Graphics,
{$ELSE}
  System.UITypes, Winapi.Windows, Winapi.ShellAPI,
  System.IOUtils, Graphics,
  {$IFDEF DESIGNMODE}ToolsAPI,{$ENDIF}
{$ENDIF}
  D2Bridge.Wizard.Types;

function GetUsesServerControllerName: string;
function ExistFileInCurrentProject(AFileName: String): Boolean;
function FindSplashScreenAsImage(IntoBMP : TBitmap) : Boolean;
function GetSplashScreenBaseColor : TColor;
function CreateBlankSplashBitmap(const W, H : Integer) : TBitmap;
function CreateSplashBitmap(const Logo : TIcon) : TBitmap;
function IsVCLProject: Boolean;
function IsFMXProject: Boolean;
function D2BridgeFrameworkPath: string;
function D2BridgeFrameworkRootPath: string;
function IsValidD2BridgeFrameworkPath: boolean;
function GetDocumentPath: string;
function CopyDir(const Source, Target: string): Boolean;
function ExtractNumbers(AText: string): string;
function D2BridgeWizardVersionFullToString: string;
function D2BridgeWizardToString: string;
function AvailableLanguages(const Folder: string): TStringList;
procedure OpenURLExt(AURL: string);
function GetRealFilePath(const FilePath: string): string;
{$IFDEF FPC}
procedure CopyFolderFiles(const SourcePattern, TargetDir: string);
procedure ExtractZipFile(const SourceZip, DestinationPath: string);
function FormsInfoFromProject: TList<TFormInfo>;
{$IFDEF DESIGNMODE}
function GetOPMPath: string;
{$ENDIF}
{$ELSE}
function CopyFolderFiles(sourceFolder, targetFolder: string):LongInt;
{$IFDEF DESIGNMODE}
function GetCurrentProject: IOTAProject;
function GetCurrentProjectGroup: IOTAProjectGroup;
{$ENDIF}
{$ENDIF}

const
  D2BridgeWizardVersion = 2.52;

implementation

{$IFNDEF FPC}
{$IFDEF DESIGNMODE}
function GetCurrentProject: IOTAProject;
var
  ProjectGroup: IOTAProjectGroup;
begin
  Result := nil;
  ProjectGroup := GetCurrentProjectGroup;

  if Assigned(ProjectGroup) then
    if ProjectGroup.ProjectCount > 0 then
      Result := ProjectGroup.ActiveProject;
end;

function GetCurrentProjectGroup: IOTAProjectGroup;
var
  IModuleServices: IOTAModuleServices;
  IModule: IOTAModule;
  IProjectGroup: IOTAProjectGroup;
  i: Integer;
begin
  Result := nil;
  IModuleServices := BorlandIDEServices as IOTAModuleServices;
  for i := 0 to IModuleServices.ModuleCount - 1 do
  begin
    IModule := IModuleServices.Modules[i];
    if IModule.QueryInterface(IOTAProjectGroup, IProjectGroup) = S_OK then
    begin
      Result := IProjectGroup;
      Break;
    end;
  end;
end;
{$ENDIF}
{$ENDIF}

{$IFDEF FPC}
procedure ExtractZipFile(const SourceZip, DestinationPath: string);
var
  UnZipper: TUnZipper;
begin
  UnZipper := TUnZipper.Create;
  try
    UnZipper.FileName := SourceZip;
    UnZipper.OutputPath := DestinationPath;
    UnZipper.Examine;  // Examina os conteúdos do arquivo ZIP
    UnZipper.UnZipAllFiles;  // Extrai todos os arquivos
  finally
    UnZipper.Free;
  end;
end;

function FormsInfoFromProject: TList<TFormInfo>;
var
  i: Integer;
  Project: TLazProject;
  ProjectFile: TLazProjectFile;
  FormClassName, FormName, LFMFileContent: string;
  Regex: TRegExpr;
  vFormRec: TFormInfo;
begin
  // Limpa o ComboBox e o dicionário para evitar duplicações
  result:= nil;

  if (not Assigned(LazarusIDE)) or (not Assigned(LazarusIDE.ActiveProject)) then
   exit;

  Project:= LazarusIDE.ActiveProject;

  if Assigned(Project) then
  begin
   result:= TList<TFormInfo>.Create;

    for i := 0 to Project.FileCount - 1 do
    begin
      ProjectFile := Project.Files[i];

      // Verifica se há um arquivo .lfm correspondente à unit
      if FileExists(ChangeFileExt(ProjectFile.Filename, '.lfm')) and ProjectFile.IsPartOfProject then
      begin
        // Lê o conteúdo completo do arquivo .lfm como uma string
        LFMFileContent := ReadFileToString(ChangeFileExt(ProjectFile.Filename, '.lfm'));

        // Configura expressão regular para identificar "object <FormName>: <FormClass>"
        Regex := TRegExpr.Create;
        try
          // Expressão regular para capturar o nome e a classe do form
          Regex.Expression := '^(object|inherited)\s+(\w+)\s*:\s*(\w+)';

          if Regex.Exec(LFMFileContent) then
          begin
            FormName := Regex.Match[2];      // Nome do form
            FormClassName := Regex.Match[3]; // Classe do form

            if (FormName <> '') and (FormClassName <> '') then
            if (not SameText(FormClassName, 'TD2BridgeServerControllerBase')) and
               (not SameText(FormClassName, 'TPrismSessionBase')) and
               (not SameText(FormName, ExtractFileNameOnly(Project.MainFile.Filename) + 'WebAppGlobal')) and
               (not SameText(FormName, ExtractFileNameOnly(Project.MainFile.Filename) + 'Session')) then
            begin
             // Cria o registro do formulário
             vFormRec.Name := FormName;
             vFormRec.ClassName := FormClassName;
             vFormRec.UnitName:= ProjectFile.Unit_Name;
             vFormRec.UnitFileName:= ProjectFile.Filename;
             vFormRec.IsCrud := False; // ou ajuste conforme sua lógica

             // Adiciona o form ao dicionário e ao ComboBox
             Result.Add(vFormRec);
            end;
          end;

        finally
          Regex.Free;
        end;
      end;
    end;
  end;
end;

{$IFDEF DESIGNMODE}
function GetOPMPath: string;
begin
 result:= LazarusIDE.GetPrimaryConfigPath + PathDelim + 'onlinepackagemanager' + PathDelim + 'packages' + PathDelim + 'd2bridgeframework' + PathDelim + 'source' + PathDelim + 'D2Bridge Framework';

 if not DirectoryExistsUTF8(result) then
  result:= '';
end;
{$ENDIF}

{$ENDIF}

{$IFDEF FPC}
function GetUsesServerControllerName: string;
begin
 result:= ChangeFileExt(ExtractFileName(LazarusIDE.ActiveProject.ProjectInfoFile)+'WebApp', '') + 'WebApp';
end;
{$ELSE}
function GetUsesServerControllerName: string;
{$IFnDEF DESIGNMODE}
begin
{$ELSE}
var
 ModServices: IOTAModuleServices;
 Module: IOTAModule;
 ProjectIOTA: IOTAProject;
 vIOTAModuleInfo: IOTAModuleInfo;
 i: Integer;
 vExistServerController: Boolean;
begin
 Result:= 'ServerController';
 vExistServerController:= false;

 ProjectIOTA:= GetCurrentProject;

 for I := 0 to Pred(ProjectIOTA.GetModuleCount) do
 begin
  vIOTAModuleInfo:= ProjectIOTA.GetModule(I);

  if (vIOTAModuleInfo.FileName <> '') then
  begin
   if AnsiPos(UpperCase('ServerController.pas'), UpperCase(vIOTAModuleInfo.FileName)) > 0 then
   begin
    vExistServerController:= true;
    Break;
   end;
  end;
 end;

 if not vExistServerController then
  Result:= ChangeFileExt(ExtractFileName(GetCurrentProject.FileName)+'WebApp', '') + 'WebApp';
{$ENDIF}
end;
{$ENDIF}

{$IFnDEF FPC}
function ExistFileInCurrentProject(AFileName: String): Boolean;
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
 Result:= false;

 ProjectIOTA:= GetCurrentProject;

 for I := 0 to Pred(ProjectIOTA.GetModuleCount) do
 begin
  vIOTAModuleInfo:= ProjectIOTA.GetModule(I);

  if (vIOTAModuleInfo.FileName <> '') then
  begin
   if AnsiPos(UpperCase(AFileName), UpperCase(vIOTAModuleInfo.FileName)) > 0 then
   begin
    Result:= true;
    Break;
   end;
  end;
 end;
{$ENDIF}
end;
{$ELSE}
function ExistFileInCurrentProject(AFileName: String): Boolean;
begin
  Result := false;  // Sem equivalência no Lazarus para este método
end;
{$ENDIF}

function FindSplashScreenAsImage(IntoBMP: TBitmap): Boolean;
var
  I: Integer;
begin
  Result := false;
  for I := 0 to Pred(Screen.FormCount) do
    if Screen.Forms[i].Caption = 'SplashScreen' then
    begin
      IntoBMP.Width := Screen.Forms[i].ClientWidth;
      IntoBMP.Height := Screen.Forms[i].ClientHeight;
      Screen.Forms[i].PaintTo(IntoBMP.Canvas.Handle, 0, 0);
      Exit(true);
    end;
end;

function GetSplashScreenBaseColor: TColor;
var
  SplashBMP: TBitmap;
begin
  Result := clBlack; // Default
  SplashBMP := TBitmap.Create;
  try
    if FindSplashScreenAsImage(SplashBMP) then
      Result := SplashBMP.Canvas.Pixels[4, SplashBMP.Height - (SplashBMP.Height div 4)];
  finally
    SplashBMP.Free;
  end;
end;

function CreateBlankSplashBitmap(const W, H: Integer): TBitmap;
var
  SplashColor: TColor;
begin
  Result := TBitmap.Create;
  Result.PixelFormat := pf24bit;
  Result.Width := W;
  Result.Height := H;

  SplashColor := GetSplashScreenBaseColor;
  Result.Canvas.Brush.Color := SplashColor;
  Result.Canvas.FillRect(Rect(0, 0, Result.Width, Result.Height));
end;

function CreateSplashBitmap(const Logo: TIcon): TBitmap;
var
  SplashSize: Integer;
begin
  SplashSize := 24;
  Result := CreateBlankSplashBitmap(SplashSize, SplashSize);
  Result.Canvas.Draw((SplashSize div 2) - (Logo.Width div 2), (SplashSize div 2) - (Logo.Height div 2), Logo);
end;

{$IFnDEF FPC}
function IsVCLProject: Boolean;
{$IFDEF DESIGNMODE}
var
  i: Integer;
  ModuleInfo: IOTAModuleInfo;
  Project: IOTAProject;
begin
  Project:= GetCurrentProject;
  Result:= false;

  if Assigned(Project) then
  begin
   Result:= SameText(GetCurrentProject.FrameworkType, 'VCL');
  end;
{$ELSE}
begin
{$ENDIF}
end;
{$ELSE}
function IsVCLProject: Boolean;
begin
  Result := false;  // Não aplicável ao Lazarus
end;
{$ENDIF}

{$IFnDEF FPC}
function IsFMXProject: Boolean;
{$IFDEF DESIGNMODE}
var
  i: Integer;
  ModuleInfo: IOTAModuleInfo;
  Project: IOTAProject;
begin
  Project:= GetCurrentProject;
  Result := False;

  if Assigned(Project) then
  begin
   Result:= SameText(GetCurrentProject.FrameworkType, 'FMX');
  end;
{$ELSE}
begin
{$ENDIF}
end;
{$ELSE}
function IsFMXProject: Boolean;
begin
  Result := false;  // Não aplicável ao Lazarus
end;
{$ENDIF}

function D2BridgeFrameworkPath: string;
var
  ArqIni: TIniFile;
begin
  Result := '';

  ArqIni   := TIniFile.Create(ExtractFilePath(GetModuleName(HInstance))+'Config.ini');
  try
    Result := ArqIni.ReadString('Config', 'Path D2Bridge Framework', '');

    {$IFDEF FPC}
     {$IFDEF DESIGNMODE}
     if Result = '' then
      if GetOPMPath <> '' then
       Result:= GetOPMPath;
     {$ENDIF}
    {$ENDIF}

    if Result <> '' then
      Result := IncludeTrailingPathDelimiter(Result);
  finally
    ArqIni.Free;
  end;
end;

function D2BridgeFrameworkRootPath: string;
var
 vFile, vPath, vD2BridgePath: string;
begin
 result:= '';

 if IsValidD2BridgeFrameworkPath then
 begin
  vD2BridgePath:= D2BridgeFrameworkPath;

  {$IFDEF FPC}
    vFile := ConcatPaths([vD2BridgePath, 'D2Bridge.BaseClass.pas']);
    vPath := ConcatPaths([vD2BridgePath, 'D2Bridge Framework']);
  {$ELSE}
    vFile := TPath.Combine(vD2BridgePath, 'D2Bridge.BaseClass.pas');
    vPath := TPath.Combine(vD2BridgePath, 'D2Bridge Framework');
  {$ENDIF}

  if FileExists(vFile) then
  begin
   Result := IncludeTrailingPathDelimiter(ExtractFileDir(ExcludeTrailingBackslash(vD2BridgePath)));
  end else
  begin
   Result:= vD2BridgePath;
  end;
 end;
end;

function IsValidD2BridgeFrameworkPath: Boolean;
var
  vFile, vPath, vD2BridgePath: string;
begin
  Result := false;
  vD2BridgePath := D2BridgeFrameworkPath;

  if vD2BridgePath <> '' then
  begin
    {$IFDEF FPC}
      vFile := ConcatPaths([vD2BridgePath, 'D2Bridge.BaseClass.pas']);
      vPath := ConcatPaths([vD2BridgePath, 'D2Bridge Framework']);
    {$ELSE}
      vFile := TPath.Combine(vD2BridgePath, 'D2Bridge.BaseClass.pas');
      vPath := TPath.Combine(vD2BridgePath, 'D2Bridge Framework');
    {$ENDIF}
    if FileExists(vFile) or DirectoryExists(vPath) then
      Result := true;
  end;
end;

function GetDocumentPath: string;
begin
{$IFDEF FPC}
  {$IFDEF MSWINDOWS}
    // No Windows, a pasta "Documentos" normalmente fica em "C:\Users\<User>\Documents"
    Result := GetUserDir + 'Documents';
  {$ELSE}
    {$IFDEF LINUX}
      // No Linux, a pasta "Documentos" pode ser "Home/Documents"
      Result := GetUserDir + 'Documents';
    {$ELSE}
      {$IFDEF DARWIN}
        // No macOS, a pasta "Documentos" fica em "Users/<User>/Documents"
        Result := GetUserDir + 'Documents';
      {$ELSE}
        // Caso outra plataforma não identificada, retorna o diretório do usuário
        Result := GetUserDir;
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ELSE}
  Result:= TPath.GetSharedDocumentsPath;
{$ENDIF}
end;

{$IFDEF FPC}
function CopyDir(const Source, Target: string): Boolean;
begin
  // Copia o conteúdo do diretório Source para o Target
  Result := CopyDirTree(Source, Target, [cffOverwriteFile]);
end;
{$ELSE}
function CopyDir(const Source, Target: string): Boolean;
var
  SHFileOpStruct: TSHFileOpStruct;
begin
  ZeroMemory(@SHFileOpStruct, SizeOf(SHFileOpStruct));
  with SHFileOpStruct do
  begin
    wFunc  := FO_COPY;
    fFlags := FOF_FILESONLY;
    pFrom  := PChar(Source + #0);
    pTo    := PChar(Target)
  end;
  Result := (0 = ShFileOperation(SHFileOpStruct));
end;
{$ENDIF}

function D2BridgeWizardVersionFullToString: string;
var
  J: integer;
  vD2BridgeVersion: string;
  vD2BridgeManagerPath: string;
  vFileStrings: TStrings;
  vPosInit, vPosEnd: integer;
begin
 vD2BridgeVersion:= '';

 if IsValidD2BridgeFrameworkPath then
 begin
  vD2BridgeManagerPath:= IncludeTrailingPathDelimiter(D2BridgeFrameworkPath) + 'D2Bridge.Manager.pas';

  if FileExists(vD2BridgeManagerPath) then
  begin
   vFileStrings:= TStringList.Create;
   vFileStrings.LoadFromFile(GetRealFilePath(vD2BridgeManagerPath));

   for J:= 0 to pred(vFileStrings.Count) do
   begin
    if POS('Version of D2Bridge Framework', vFileStrings.Strings[J]) > 0 then
    begin
     vPosInit:= POS('''', vFileStrings.Strings[J]) + 1;
     vPosEnd:= POS('''', Copy(vFileStrings.Strings[J], vPosInit)) - 1;
     vD2BridgeVersion:= Copy(vFileStrings.Strings[J], vPosInit, vPosEnd);
     break;
    end;
   end;
  end;
 end;

 result:= StringReplace(D2BridgeWizardToString, ',', '.', [rfIgnoreCase, rfReplaceAll]);

 if vD2BridgeVersion <> '' then
  result:= 'D2Bridge Framework ' + vD2BridgeVersion + ' / Wizard ' + result;

 result:= result + ' ' + {$IFDEF FPC}'(Lazarus)'{$ELSE}'(Delphi)'{$ENDIF};
end;

function D2BridgeWizardToString: string;
var
 vVersionMajor, vVersionMinor: string;
 vFormatSettings: TFormatSettings;
 vParts: TArray<string>;
begin
 Result:= '';

 vFormatSettings.DecimalSeparator:= '.';
 vParts := FloatToStr(D2BridgeWizardVersion, vFormatSettings).Split(['.']);
 if Length(vParts) > 0 then
  vVersionMajor := vParts[0];
 if Length(vParts) > 1 then
 begin
  if StrToInt(vParts[1]) < 10 then
   vParts[1]:= vParts[1]  + '0';

  vVersionMinor := vParts[1];
 end;

 result:= vVersionMajor + '.' + vVersionMinor;
end;

function AvailableLanguages(const Folder: string): TStringList;
const
  IgnoredPrefixes: array[0..5] of string = (
    'Core.', 'APP.', 'BaseClass.', 'Interfaces.', 'Term.', 'Util.'
  );
var
  SearchRec: TSearchRec;
  FileName, LangName: string;
  i: Integer;
  Ignore: Boolean;
begin
  Result := TStringList.Create;
  Result.Sorted := True;
  Result.Duplicates := dupIgnore;

  if FindFirst(IncludeTrailingPathDelimiter(Folder) + 'D2Bridge.Lang.*.pas', faAnyFile, SearchRec) = 0 then
  begin
    repeat
      FileName := SearchRec.Name;

      // Remove prefix "D2Bridge.Lang." e extensão ".pas"
      LangName := FileName;
      Delete(LangName, 1, Length('D2Bridge.Lang.'));
      LangName := Copy(LangName, 1, Length(LangName) - Length('.pas'));

      // Verificar se está na lista de ignorados
      Ignore := False;
      for i := Low(IgnoredPrefixes) to High(IgnoredPrefixes) do
      begin
        if StartsText(IgnoredPrefixes[i], LangName + '.') or (LangName = StringReplace(IgnoredPrefixes[i], '.', '', [rfReplaceAll])) then
        begin
          Ignore := True;
          Break;
        end;
      end;

      if not Ignore then
        Result.Add(LangName);
    until FindNext(SearchRec) <> 0;
    SysUtils.FindClose(SearchRec);
  end;
end;


procedure OpenURLExt(AURL: string);
begin
 {$IFDEF FPC}
 LCLintf.OpenURL(AURL);
 {$ELSE}
 ShellExecute(0, 'open', PChar(AURL), nil, nil, SW_SHOWNORMAL);
 {$ENDIF}
end;

function GetRealFilePath(const FilePath: string): string;
var
  Dir, FileName, FoundFile: string;
  SearchRec: TSearchRec;
begin
 Result := FilePath;

 {$IFDEF WINDOWS}

 {$ELSE}
 Dir := ExtractFileDir(FilePath);
 FileName := ExtractFileName(FilePath);

 // Se o diretório não existir, retorna vazio
 if not DirectoryExists(Dir) then
   Exit;

 // Busca pelo arquivo no diretório
 if FindFirst(Dir + PathDelim + '*', faAnyFile, SearchRec) = 0 then
 begin
   repeat
     // Compara ignorando case, mas retorna o nome correto
     if SameText(SearchRec.Name, FileName) then
     begin
       FoundFile := Dir + PathDelim + SearchRec.Name;
       Break;
     end;
   until FindNext(SearchRec) <> 0;

   SysUtils.FindClose(SearchRec);
 end;

 // Se encontrou, retorna o caminho real
 if FoundFile <> '' then
   Result := FoundFile;
 {$ENDIF}
end;

{$IFDEF FPC}
procedure CopyFolderFiles(const SourcePattern, TargetDir: string);
var
  FilesList: TStringList;
  SourceDir, FileMask: string;
  SourceFile, TargetFile: string;
  i: Integer;
begin
  FilesList := TStringList.Create;
  try
    // Separar o diretório e a máscara do padrão de origem
    SourceDir := ExtractFileDir(SourcePattern);
    FileMask := ExtractFileName(SourcePattern);

    // Encontrar todos os arquivos que correspondem à máscara no diretório de origem
    FindAllFiles(FilesList, SourceDir, FileMask, False);

    // Garante que o diretório de destino existe
    if not DirectoryExists(TargetDir) then
      CreateDir(TargetDir);

    // Copia cada arquivo encontrado para o diretório de destino
    for i := 0 to FilesList.Count - 1 do
    begin
      SourceFile := FilesList[i];
      TargetFile := TargetDir + DirectorySeparator + ExtractFileName(SourceFile);
      CopyFile(SourceFile, TargetFile, [cffOverwriteFile]); // Sobrescreve se o arquivo já existir
    end;
  finally
    FilesList.Free;
  end;
end;
{$ELSE}
function CopyFolderFiles(sourceFolder, targetFolder: string):LongInt;
var
 F : TShFileOpStruct;
 sOrigen, sDestino : String;
begin
 Result := 0;
 sOrigen := sourceFolder + #0;
 sDestino := targetFolder + #0;

 with F do
 begin
  Wnd   := Application.Handle;
  wFunc := FO_COPY;
  pFrom := @sOrigen[1];
  pTo   := @sDestino[1];
  fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMATION
 end;

 Result := ShFileOperation(F);
end;
{$ENDIF}

function ExtractNumbers(AText: string): string;
var
  i: Integer;
begin
  Result := ''; // Inicializa o resultado como vazio
  for i := 1 to Length(AText) do
  begin
    // Verifica se o caractere atual é um número
    if AText[i] in ['0'..'9'] then
      Result := Result + AText[i]; // Adiciona o número ao resultado
  end;
end;


end.

