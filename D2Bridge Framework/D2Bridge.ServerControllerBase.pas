{
 +--------------------------------------------------------------------------+
  D2Bridge Framework Content

  Author: Talis Jonatas Gomes
  Email: talisjonatas@me.com

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

{$I D2Bridge.inc}

{$IFNDEF FPC}
{$R 'D2Bridge.Lang.res' 'D2Bridge.Lang.rc'}
{$ENDIF}

unit D2Bridge.ServerControllerBase;

interface

uses
  Classes, SysUtils, DB,
{$IFNDEF FPC}
  MidasLib, DBClient, ADODB,
  {$IFDEF FMX}
  FMX.Forms, FMX.StdCtrls,
  {$ELSE}
  Forms, StdCtrls,
  {$ENDIF}
{$ELSE}
  Forms, BufDataset, LResources, StdCtrls,
{$ENDIF}
{$IFDEF MSWINDOWS}
  ActiveX, Windows,
{$ENDIF}
  SyncObjs,
  {$IFNDEF D2BRIDGE}
  D2Bridge.Instance,
  {$ENDIF}
  Prism, Prism.Interfaces, Prism.Session, Prism.Types, D2Bridge.Interfaces,
  D2Bridge.Manager, D2Bridge.Types, D2Bridge.Prism.Form, D2Bridge.Lang.Interfaces;


type
 TOnSessionChange = procedure(AChangeType: TSessionConnectionStatus; APrismSession: IPrismSession) of object;

 TD2BridgeServerControllerBase = class(TDataModule, ID2BridgeServerControllerBase)
   CDSLog: {$IFNDEF FPC}TClientDataSet{$ELSE}TBufDataset{$ENDIF};
   CDSLogAutoCod: TAutoIncField;
   CDSLogIdentify: TStringField;
   CDSLogUser: TStringField;
   CDSLogIP: TStringField;
   CDSLogUserAgent: TStringField;
   CDSLogStatus: TStringField;
   CDSLogDateConnection: TDateTimeField;
   CDSLogDateUpdate: TDateTimeField;
   CDSLogExpire: TStringField;
   CDSLogUUID: TStringField;
   CDSLogFormName: TStringField;
   DataSourceLog: TDataSource;
  private
   FD2BridgeManager: TD2BridgeManager;
   FOnSessionChange: TOnSessionChange;
   FCriticalSessionCDSLog: TCriticalSection;
   FStartTimeTickCount: Integer;
   FStartTime: TDateTime;
   FServerName: String;
   FServerDescription: String;
   FAPPName: string;
   FAPPDescription: string;
   FServerAppAuthor: string;
   FServerAppDescription: string;
   FServerAppTitle: string;
   FStopping: Boolean;
   function GetPrism: TPrism;
   function GetD2BridgeManager: TD2BridgeManager;
   function GetPort: Integer;
   procedure SetPort(const Value: Integer);
   function GetPrimaryFormClass: TD2BridgeFormClass;
   procedure SetPrimaryFormClass(const Value: TD2BridgeFormClass);
   function GetTemplateClassForm: TD2BridgePrismFormClass;
   function GetTemplateMasterHTMLFile: string;
   function GetTemplatePageHTMLFile: string;
   procedure SetTemplateClassForm(const Value: TD2BridgePrismFormClass);
   procedure SetTemplateMasterHTMLFile(const Value: string);
   procedure SetTemplatePageHTMLFile(const Value: string);
   function GetServerName: String;
   procedure SetServerName(const Value: String);
   procedure SetServerDescription(const Value: String);
   function GetServerDescription: String;
   function GetLanguages: TD2BridgeLangs;
   procedure SetLanguages(const Value: TD2BridgeLangs);
   procedure SetLanguage(const Value: TD2BridgeLang);
   function GetAPPName: string;
   procedure SetAPPName(const Value: string);
   function GetAPPDescription: string;
   function GetServerAppAuthor: string;
   function GetServerAppDescription: string;
   function GetServerAppTitle: string;
   procedure SetAPPDescription(const Value: string);
   procedure SetServerAppAuthor(const Value: string);
   procedure SetServerAppDescription(const Value: string);
   procedure SetServerAppTitle(const Value: string);
  public
   FDefaultFontSize: {$IFnDEF FMX}integer{$ELSE}single{$ENDIF};

   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;

   function Started: boolean;
   procedure StartServer;
   procedure StopServer;
   procedure DoSessionChange(AChangeType: TSessionConnectionStatus; APrismSession: IPrismSession); virtual;
   function CloseSession(ASessionUUID: String): Boolean;
   procedure CloseAllSessions;
   function SendMessageToSession(ASessionUUID: String; AMessage: String): Boolean;
   procedure SendMessageToAllSession(AMessage: String);
   function ServerInfoConsoleHeader: TStrings; virtual;
   function ServerInfoConsole: TStrings; virtual;

   function ServerUUID: string;

   property Languages: TD2BridgeLangs read GetLanguages write SetLanguages;
   property Language: TD2BridgeLang write SetLanguage;
   property D2BridgeManager: TD2BridgeManager read GetD2BridgeManager;
   property Prism: TPrism read GetPrism;
   property PrimaryFormClass: TD2BridgeFormClass read GetPrimaryFormClass write SetPrimaryFormClass;
   property TemplateMasterHTMLFile: string read GetTemplateMasterHTMLFile write SetTemplateMasterHTMLFile;
   property TemplatePageHTMLFile: string read GetTemplatePageHTMLFile write SetTemplatePageHTMLFile;
   property TemplateClassForm : TD2BridgePrismFormClass read GetTemplateClassForm write SetTemplateClassForm;
   property Port: Integer read GetPort write SetPort;
   property ServerName: String read GetServerName write SetServerName;
   property ServerDescription: String read GetServerDescription write SetServerDescription;
   property OnSessionChange: TOnSessionChange read FOnSessionChange write FOnSessionChange;
   property APPName: string read GetAPPName write SetAPPName;
   property APPDescription: string read GetAPPDescription write SetAPPDescription;
   property ServerAppTitle: string read GetServerAppTitle write SetServerAppTitle;
   property ServerAppDescription: string read GetServerAppDescription write SetServerAppDescription;
   property ServerAppAuthor: string read GetServerAppAuthor write SetServerAppAuthor;
 end;


var
 D2BridgeServerControllerBase: TD2BridgeServerControllerBase;

implementation

{$IFNDEF FPC}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses
  D2Bridge.Prism, D2Bridge.Util, Prism.Util, Prism.Session.Helper;


function IsEscapePressed: Boolean;
var
  InputHandle: THandle;
  InputRecord: TInputRecord;
  NumRead: DWORD;
begin
  Result := False;

  {$IFDEF FPC}
  Exit(false);
  {$ENDIF}


  InputHandle := GetStdHandle(STD_INPUT_HANDLE);
  if InputHandle = INVALID_HANDLE_VALUE then Exit;

  while True do
  begin
    if not PeekConsoleInput(InputHandle, InputRecord, 1, NumRead) then Exit;
    if NumRead = 0 then Exit;

    if (InputRecord.EventType = KEY_EVENT) and
       (InputRecord.Event.KeyEvent.bKeyDown) and
       (InputRecord.Event.KeyEvent.wVirtualKeyCode = VK_ESCAPE) then
    begin
      // Limpa o buffer do evento para evitar repetições
      ReadConsoleInput(InputHandle, InputRecord, 1, NumRead);
      Exit(True);
    end
    else
    begin
      // Remove o evento se não for ESC para evitar acúmulo no buffer
      ReadConsoleInput(InputHandle, InputRecord, 1, NumRead);
    end;
  end;
end;


{ TD2BridgeServerControllerBase }

procedure TD2BridgeServerControllerBase.CloseAllSessions;
begin
 GetPrism.Sessions.CloseAll;
end;

function TD2BridgeServerControllerBase.CloseSession(ASessionUUID: String): Boolean;
var
 vPrismSession: TPrismSession;
begin
 Result:= false;

 if ASessionUUID <> '' then
 begin
  vPrismSession:= Prism.Sessions.Item[ASessionUUID] as TPrismSession;

  try
   if (vPrismSession <> nil) and (not vPrismSession.Closing) and (not vPrismSession.Destroying) then
   begin
    vPrismSession.Close;
    Result:= true;
   end;
  except
  end;
 end;
end;

constructor TD2BridgeServerControllerBase.Create;
var
 vLabel: TLabel;
begin
 inherited;

 D2BridgeServerControllerBase:= self;

{$IFDEF D2BRIDGE}
 CDSLog.CreateDataset;

 FStartTime:= now;

 FCriticalSessionCDSLog:= TCriticalSection.Create;

 FServerName:= 'D2Bridge Server';
 FServerDescription:= 'Primary D2Bridge Server';

 if FD2BridgeManager = nil then
  FD2BridgeManager:= TD2BridgeManager.Create(self);
 FD2BridgeManager.FrameworkExportTypeClass:= TD2BridgePrismFramework;
 FD2BridgeManager.Prism:= TPrism.Create(self);
 FD2BridgeManager.ServerController:= self;
 (FD2BridgeManager.Prism as TPrism).ServerController:= self;
 FAPPName:= 'D2Bridge';
 FAPPDescription:= 'My Web D2Bridge APP';
 FStopping:= false;


 FServerAppTitle:= {$IFNDEF FPC}'Delphi Web'{$ELSE}'Lazarus Web'{$ENDIF};
 FServerAppDescription:= 'D2Bridge Framework '+ D2BridgeManager.Version;
 FServerAppAuthor:= 'by Talis Jonatas Gomes';

 {$IFNDEF FPC}
 vLabel:= TLabel.Create(nil);
 FDefaultFontSize:= vLabel.Font.Size;
 vLabel.Free;
 {$ELSE}
 FDefaultFontSize:= Screen.SystemFont.Size;
 {$ENDIF}
{$ENDIF}
end;

destructor TD2BridgeServerControllerBase.Destroy;
var
 vPrism: TPrism;
 vPrismIntf: IPrismBaseClass;
begin
 {$IFNDEF D2BRIDGE}
 D2BridgeInstance.PrismSession.Data.Free;
 D2BridgeInstance.PrismSession.Data:= nil;
 {$ENDIF}

 {$IFDEF D2BRIDGE}
 if Assigned(FD2BridgeManager) then
  if FD2BridgeManager.Prism.Started then
   FD2BridgeManager.Prism.StopServer;
 if (Not IsDebuggerPresent) {$IFnDEF FPC}or (not ReportMemoryLeaksOnShutdown){$ENDIF} then
 begin
  {$IFDEF MSWINDOWS}
  ExitProcess(0);
  {$ELSE}
  Halt(0);
  {$ENDIF}
 end;

 vPrismIntf:= FD2BridgeManager.Prism;

 FreeAndNil(FD2BridgeManager);
 FreeAndNil(FCriticalSessionCDSLog);

 if Assigned(vPrismIntf) then
 begin
  vPrism:= (vPrismIntf as TPrism);
  vPrismIntf:= nil;
  vPrism.Free;
 end;
 {$ENDIF}

 inherited;
end;


procedure TD2BridgeServerControllerBase.DoSessionChange(AChangeType: TSessionConnectionStatus; APrismSession: IPrismSession);
var
 vRow: Integer;
begin
 {$REGION 'Deactive/Restore Session'}
  try
   if Assigned(APrismSession) and (APrismSession.UUID <> '') then
   begin
    try
     if not (AChangeType in [scsNewSession, scsCloseSession, scsDestroySession]) then
      (APrismSession as TPrismSession).SetConnectionStatus(AChangeType);
    except
    end;

    try
     if AChangeType = scsStabilizedConnectioSession then
      if not (APrismSession as TPrismSession).StabilizedConn then
       (APrismSession as TPrismSession).SetStabilizedConn(True);
    except
    end;

    case AChangeType of
  //   sctNewSession : TPrismSession(APrismSession).DoDeActive;
  //   sctCloseSession : TPrismSession(APrismSession).DoDeActive;
  //   sctActiveSession : TPrismSession(APrismSession).DoRestore;
  //   sctClosingSession : TPrismSession(APrismSession).DoDeActive;
     scsExpireSession : (APrismSession as TPrismSession).DoDeActive;
     scsStabilizedConnectioSession : (APrismSession as TPrismSession).DoRestore;
     scsLostConnectioSession : (APrismSession as TPrismSession).DoDeActive;
     scsReconnectedSession : (APrismSession as TPrismSession).DoRestore;
  //   sctDestroySession : TPrismSession(APrismSession).DoDeActive;
    end;
   end;
  except
  end;
 {$ENDREGION}

 {$REGION 'Manage Data in CDSLog'}
 if Prism.Options.DataSetLog then
 begin
  FCriticalSessionCDSLog.Enter;
  try
   if Assigned(APrismSession) and (APrismSession.UUID <> '') then
   begin
    vRow:= CDSLog.RecNo;
    CDSLog.DisableControls;

    if CDSLog.IsEmpty or (not CDSLog.Locate('UUID', APrismSession.UUID, [])) then
    begin
     if CDSLog.FieldByName('AutoCod').AsInteger > 0 then
      CDSLog.Insert;

     CDSLog.Edit;
     CDSLog.FieldByName('DateConnection').AsDateTime:= now;
     CDSLog.FieldByName('IP').AsString:= APrismSession.InfoConnection.IP;
     CDSLog.FieldByName('UserAgent').AsString:= APrismSession.InfoConnection.UserAgent;
     CDSLog.FieldByName('UUID').AsString:= APrismSession.UUID;
    end;

    if AChangeType = scsDestroySession then
    begin
     CDSLog.Delete;
    end else
    begin
     CDSLog.Edit;
     CDSLog.FieldByName('DateUpdate').AsDateTime:= now;
     CDSLog.FieldByName('User').AsString:= APrismSession.InfoConnection.User;
     CDSLog.FieldByName('Identify').AsString:= APrismSession.InfoConnection.Identity;

     if not APrismSession.Closing then
     begin
      CDSLog.FieldByName('FormName').AsString:= APrismSession.InfoConnection.FormName;
      case AChangeType of
       TSessionConnectionStatus.scsNewSession : CDSLog.FieldByName('Status').AsString:= 'New';
       TSessionConnectionStatus.scsCloseSession : CDSLog.FieldByName('Status').AsString:= 'Close';
       TSessionConnectionStatus.scsActiveSession : CDSLog.FieldByName('Status').AsString:= 'Active';
       TSessionConnectionStatus.scsClosingSession : CDSLog.FieldByName('Status').AsString:= 'Closing';
       TSessionConnectionStatus.scsExpireSession : CDSLog.FieldByName('Status').AsString:= 'Time out';
       TSessionConnectionStatus.scsStabilizedConnectioSession : CDSLog.FieldByName('Status').AsString:= 'Stabilized';
       TSessionConnectionStatus.scsLostConnectioSession : CDSLog.FieldByName('Status').AsString:= 'Lost';
       TSessionConnectionStatus.scsReconnectedSession : CDSLog.FieldByName('Status').AsString:= 'Reconnected';
      end;
     end else
      CDSLog.FieldByName('Status').AsString:= 'Closing';

     CDSLog.Post;

     if vRow > 0 then
     CDSLog.RecNo:= vRow;
    end;
   end;
  finally
   CDSLog.EnableControls;
   FCriticalSessionCDSLog.Leave;
  end;
 end;
 {$ENDREGION}


 if Assigned(FOnSessionChange) then
  FOnSessionChange(AChangeType, APrismSession);
end;

function TD2BridgeServerControllerBase.GetAPPDescription: string;
begin
 Result:= FAPPDescription;
end;

function TD2BridgeServerControllerBase.GetAPPName: string;
begin
 result:= FAPPName;
end;

function TD2BridgeServerControllerBase.GetD2BridgeManager: TD2BridgeManager;
begin
 Result:= FD2BridgeManager;
end;

function TD2BridgeServerControllerBase.GetLanguages: TD2BridgeLangs;
begin
 Result:= D2BridgeManager.Languages;
end;

function TD2BridgeServerControllerBase.GetPort: Integer;
begin
 Result:= Prism.ServerPort;
end;

function TD2BridgeServerControllerBase.GetPrimaryFormClass: TD2BridgeFormClass;
begin
 Result:= D2BridgeManager.PrimaryFormClass;
end;

function TD2BridgeServerControllerBase.GetPrism: TPrism;
begin
 Result:= D2BridgeManager.Prism as TPrism;
end;

function TD2BridgeServerControllerBase.GetServerAppAuthor: string;
begin
 Result := FServerAppAuthor;
end;

function TD2BridgeServerControllerBase.GetServerAppDescription: string;
begin
 Result := FServerAppDescription;
end;

function TD2BridgeServerControllerBase.GetServerAppTitle: string;
begin
 Result := FServerAppTitle;
end;

function TD2BridgeServerControllerBase.GetServerDescription: String;
begin
 Result:= FServerDescription;
end;

function TD2BridgeServerControllerBase.GetServerName: String;
begin
 Result:= FServerName;
end;

function TD2BridgeServerControllerBase.GetTemplateClassForm: TD2BridgePrismFormClass;
begin
 Result:= TD2BridgePrismFormClass(D2BridgeManager.TemplateClassForm);
end;

function TD2BridgeServerControllerBase.GetTemplateMasterHTMLFile: string;
begin
 Result:= D2BridgeManager.TemplateMasterHTMLFile;
end;

function TD2BridgeServerControllerBase.GetTemplatePageHTMLFile: string;
begin
 Result:= D2BridgeManager.TemplatePageHTMLFile;
end;

procedure TD2BridgeServerControllerBase.SendMessageToAllSession(AMessage: String);
var
 VPrismSession: IPrismSession;
begin
 for vPrismSession in GetPrism.Sessions.Items do
 begin
  try
   vPrismSession.ExecJS
    (
      'Swal.fire(' + sLineBreak +
      '  ''Mensagem'',' + sLineBreak +
      '  '''+ AMessage +''',' + sLineBreak +
      '  ''question''' + sLineBreak +
      ')'
    );
  except
  end;
 end;
end;

function TD2BridgeServerControllerBase.SendMessageToSession(ASessionUUID,
  AMessage: String): Boolean;
var
 vPrismSession: TPrismSession;
begin
 Result:= false;

 if ASessionUUID <> '' then
 begin
  vPrismSession:= Prism.Sessions.Item[ASessionUUID] as TPrismSession;
  if vPrismSession <> nil then
  begin
   vPrismSession.ExecJS
   (
     'Swal.fire(' + sLineBreak +
     '  ''Mensagem'',' + sLineBreak +
     '  '''+ AMessage +''',' + sLineBreak +
     '  ''question''' + sLineBreak +
     ')'
   );
   Result:= true;
  end;
 end;

end;

function TD2BridgeServerControllerBase.ServerInfoConsole: TStrings;
begin
 Result:= ServerInfoConsoleHeader;

 if not FStopping then
 begin
  Result.Add('Server Information:');
  Result.Add('Server Name: ' + ServerName);
  Result.Add('Server Started On: ' + GetElapsedTime(FStartTimeTickCount));
  Result.Add('Port: '+ IntToStr(Port));
  Result.Add('Active Sessions: ' + IntToStr(Prism.Sessions.Count));
  Result.Add('');
  Result.Add('D2Bridge Server Running....');
 end;
end;

function TD2BridgeServerControllerBase.ServerInfoConsoleHeader: TStrings;
begin
 Result:= TStringList.Create;

 if FStopping then
 begin
  Result.Add('Stopping D2Bridge Framework Server');
 end else
 begin
  Result.Add(FServerAppTitle);
  Result.Add(FServerAppDescription);
  Result.Add(FServerAppAuthor);
  Result.Add('');
 end;
end;

function TD2BridgeServerControllerBase.ServerUUID: string;
begin
 result:= Prism.ServerUUID;
end;

procedure TD2BridgeServerControllerBase.SetAPPDescription(const Value: string);
begin
 FAPPDescription:= Value;
end;

procedure TD2BridgeServerControllerBase.SetAPPName(const Value: string);
begin
 FAPPName:= Value;
end;

procedure TD2BridgeServerControllerBase.SetLanguage(const Value: TD2BridgeLang);
begin
 Languages:= [Value];
end;

procedure TD2BridgeServerControllerBase.SetLanguages(const Value: TD2BridgeLangs);
begin
 D2BridgeManager.Languages:= Value;
end;

procedure TD2BridgeServerControllerBase.SetPort(const Value: Integer);
begin
 Prism.ServerPort:= Value;
end;

procedure TD2BridgeServerControllerBase.SetPrimaryFormClass(
  const Value: TD2BridgeFormClass);
begin
 D2BridgeManager.PrimaryFormClass:= Value;
end;

procedure TD2BridgeServerControllerBase.SetServerAppAuthor(const Value: string);
begin
 FServerAppAuthor := Value;
end;

procedure TD2BridgeServerControllerBase.SetServerAppDescription(const Value:
    string);
begin
 FServerAppDescription := Value;
end;

procedure TD2BridgeServerControllerBase.SetServerAppTitle(const Value: string);
begin
 FServerAppTitle := Value;
end;

procedure TD2BridgeServerControllerBase.SetServerDescription(
  const Value: String);
begin
 FServerDescription:= Value;
end;

procedure TD2BridgeServerControllerBase.SetServerName(const Value: String);
begin
 FServerName:= Value;
end;

procedure TD2BridgeServerControllerBase.SetTemplateClassForm(
  const Value: TD2BridgePrismFormClass);
begin
 D2BridgeManager.TemplateClassForm:= Value;
end;

procedure TD2BridgeServerControllerBase.SetTemplateMasterHTMLFile(
  const Value: string);
begin
 D2BridgeManager.TemplateMasterHTMLFile:= Value;
end;

procedure TD2BridgeServerControllerBase.SetTemplatePageHTMLFile(
  const Value: string);
begin
 D2BridgeManager.TemplatePageHTMLFile := Value;
end;

function TD2BridgeServerControllerBase.Started: boolean;
var
 vTime: int64;
begin
 Result:= Prism.Started;

 //Heart Beat of Main Thread
 if Result then
 begin
  vTime:= GetTickCount;

  repeat
   try
    {$IFDEF MSWINDOWS}
     {$IFnDEF FPC}
      Application.ProcessMessages;
     {$ENDIF}
    {$ENDIF}

    try
     CheckSynchronize;
    except
    end;

    {$IFDEF MSWINDOWS}
     {$IFnDEF FPC}
      Application.ProcessMessages;
     {$ENDIF}
    {$ENDIF}

    if FStopping then
    begin
     if (GetPrism.Sessions.Count <= 0) then
     begin
      StopServer;
      //Writeln('Stopping D2Bridge Server');

      Result:= false;

      Free;
      Break;
     end;
    end else
    if IsEscapePressed then
    begin
     if IsDebuggerPresent then
     begin
      {$IFnDEF FPC}
      ReportMemoryLeaksOnShutdown:= true;
      {$ENDIF}
      IsConsole:= false;

      FStopping:= true;

      CloseAllSessions;
     end;
    end;
   except
   end;

   if FStopping then
    Sleep(1000)
   else
    Sleep(1);
  until Result and ((GetTickCount - vTime) >= 900);
 end;
end;

procedure TD2BridgeServerControllerBase.StartServer;
begin
{$IFDEF MSWINDOWS}
 if Prism.Options.CoInitialize then
   CoInitializeEx(0, COINIT_MULTITHREADED);
{$ENDIF}

 //Security
 Prism.Options.Security.LoadDefaultSecurity;

 FStartTimeTickCount:= TThread.GetTickCount;
 Prism.StartServer;

 if not IsDebuggerPresent then
  Prism.Sessions.FreeMem;
end;

procedure TD2BridgeServerControllerBase.StopServer;
begin
 FStopping:= true;

 Prism.StopServer;

{$IFDEF MSWINDOWS}
 if Prism.Options.CoInitialize then
  CoUninitialize;
{$ENDIF}
end;

{$IFDEF FPC}
initialization
{$I D2Bridge.Lang.lrs}
{$ENDIF}

end.
