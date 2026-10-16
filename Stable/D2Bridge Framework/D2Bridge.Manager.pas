{
 +--------------------------------------------------------------------------+
  D2Bridge Framework Content

  Author: Talis Jonatas Gomes
  Email: talisjonatas@me.com

  This source code is distributed under the terms of the
  GNU Lesser General Public License (LGPL) version 2.1.

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Lesser General Public License as published by
  the Free Software Foundation; either version 2.1 of the License, or
  (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License
  along with this library; if not, see <https://www.gnu.org/licenses/>.

  If you use this software in a product, an acknowledgment in the product
  documentation would be appreciated but is not required.

  God bless you
 +--------------------------------------------------------------------------+
}

{$I D2Bridge.inc}

unit D2Bridge.Manager;

interface

uses
  Classes, SysUtils, Generics.Collections,
  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF}
  D2Bridge.Interfaces, Prism.Interfaces,
  D2Bridge.Lang.Interfaces, D2Bridge.Lang.Core, D2Bridge.Types,
  D2Bridge.HTML.CSS;

type
 TD2BridgeManager = class(TInterfacedPersistent, ID2BridgeManager)
  strict private
   type TD2BridgeManagerOptions = class(TInterfacedPersistent, ID2BridgeManagerOptions)
    private
    public
   end;
  private
   FAOwner: TComponent;
   FPrism: IPrismBaseClass;
   FFrameworkExportTypeClass: TD2BridgeFrameworkTypeClass;
   FD2BridgeFormClass: TD2BridgeFormClass;
   FTemplateMasterHTMLFile: string;
   FTemplatePageHTMLFile: string;
   FD2BridgeManagerOptions: TD2BridgeManagerOptions;
   FTemplateClassForm: TClass;
   FServerControllerBase: ID2BridgeServerControllerBase;
   FSupportedVCLClasses: TList<TClass>;
   FD2BridgeLangCore: TD2BridgeLangCore;
   FLanguages: TD2BridgeLangs;
   FD2BridgeAPI: ID2BridgeAPI;
   FCSSClass: TCSSClass;
   function GetD2BridgeFrameworkTypeClass: TD2BridgeFrameworkTypeClass;
   procedure SetD2BridgeFrameworkType(AD2BridgeFrameworkTypeClass: TD2BridgeFrameworkTypeClass);
   Function GetPrimaryFormClass: TD2BridgeFormClass;
   procedure SetPrimaryFormClass(AD2BridgeFormClass: TD2BridgeFormClass);
   procedure SetTemplateMasterHTMLFile(AFileMasterTemplate: string);
   procedure SetTemplatePageHTMLFile(AFilePageTemplate: string);
   function GetTemplateMasterHTMLFile: string;
   function GetTemplatePageHTMLFile: string;
   function GetTemplateClassForm: TClass;
   procedure SetTemplateClassForm(const Value: TClass);
   function GetPrism: IPrismBaseClass;
   procedure SetPrism(APrism: IPrismBaseClass);
   function GetOptions: ID2BridgeManagerOptions;
   function GetServerController: ID2BridgeServerControllerBase;
   Procedure SetGetServerController(AD2BridgeServerControllerBase: ID2BridgeServerControllerBase);
   function GetVersion: string;
   function GetLanguages: TD2BridgeLangs;
   procedure SetLanguages(const Value: TD2BridgeLangs);
  public
   constructor Create(AOwner: TComponent);
   destructor Destroy; override;

   function SupportedVCLClasses: TList<TClass>;
   function SupportsVCLClass(AClass: TClass; ARaiseError: boolean = true): Boolean;
  published

   function API: ID2BridgeAPI;
   function CSSClass: TCSSClass;

   class function Version: string;
   function D2BridgeVersion: string;

   property Languages: TD2BridgeLangs read GetLanguages write SetLanguages;
   property Owner:TComponent read FAOwner;
   property FrameworkExportTypeClass: TD2BridgeFrameworkTypeClass read FFrameworkExportTypeClass write FFrameworkExportTypeClass;
   property Prism: IPrismBaseClass read GetPrism write SetPrism;
   property PrimaryFormClass: TD2BridgeFormClass read GetPrimaryFormClass write SetPrimaryFormClass;
   property ServerController: ID2BridgeServerControllerBase read GetServerController write SetGetServerController;
   property TemplateMasterHTMLFile: string read GetTemplateMasterHTMLFile write SetTemplateMasterHTMLFile;
   property TemplatePageHTMLFile: string read GetTemplatePageHTMLFile write SetTemplatePageHTMLFile;
   property TemplateClassForm : TClass read GetTemplateClassForm write SetTemplateClassForm;
   property Options: ID2BridgeManagerOptions read GetOptions;
 end;

function D2BridgeManager: TD2BridgeManager;

implementation

uses
  Rtti, TypInfo,
  D2Bridge.Instance, D2Bridge.API, D2Bridge.VCLObj.Override, D2Bridge.Util,
  Prism.BaseClass, Prism.Session;

var
 FD2BridgeManager: TD2BridgeManager;


function D2BridgeManager: TD2BridgeManager;
begin
 Result := FD2BridgeManager;
end;


{ TD2BridgeManager }

function OverrideFindComponent(const Name: string): TComponent;
var
 vPrismSession: TPrismSession;
 FThreadID: Integer;
 vComponent: TComponent;
begin
 Result:= nil;

 FThreadID:= TThread.CurrentThread.ThreadID;

 if (FThreadID <> MainThreadID) then
 begin
  try
   vPrismSession:= (PrismBaseClass.Sessions.FromThreadID(FThreadID, false) as TPrismSession);

   //TD2BridgeInstance(vPrismSession.D2BridgeInstance).
   if Assigned(vPrismSession) then
   begin
    Result:= TComponent(TD2BridgeInstance(vPrismSession.D2BridgeInstance).GetInstanceByObjectName(Name));
   end;
   except
  end;
 end else
 begin
  vPrismSession := PrismBaseClass.Sessions.MainThreadPrismSession as TPrismSession;

  if vPrismSession <> nil then
  begin
   Result:= TComponent(TD2BridgeInstance(vPrismSession.D2BridgeInstance).GetInstanceByObjectName(Name));
  end;
 end;
end;

function TD2BridgeManager.API: ID2BridgeAPI;
begin
 Result:= FD2BridgeAPI;
end;

constructor TD2BridgeManager.Create(AOwner: TComponent);
begin
 FD2BridgeManager := self;
 FD2BridgeManagerOptions:= TD2BridgeManagerOptions.Create;
 FSupportedVCLClasses:= TList<TClass>.Create;

 Initialize(FD2BridgeFormClass);

 FD2BridgeAPI:= TD2BridgeAPI.Create;

 FD2BridgeLangCore:= TD2BridgeLangCore.Create;
 Languages:= [TD2BridgeLang.English];

 FCSSClass:= TCSSClass.Create;

 FAOwner:= AOwner;

 RegisterFindGlobalComponentProc(OverrideFindComponent);

 SupportedVCLClasses;
end;

function TD2BridgeManager.CSSClass: TCSSClass;
begin
 Result:= FCSSClass;
end;

function TD2BridgeManager.D2BridgeVersion: string;
begin
 result:= Version;
end;

destructor TD2BridgeManager.Destroy;
var
 vD2BridgeAPI: TD2BridgeAPI;
begin
 FreeAndNil(FD2BridgeManagerOptions);
 FreeAndNil(FSupportedVCLClasses);
 FreeAndNil(FD2BridgeLangCore);
 FreeAndNil(FCSSClass);

 vD2BridgeAPI:= FD2BridgeAPI as TD2BridgeAPI;
 FD2BridgeAPI:= nil;
 vD2BridgeAPI.Free;

 inherited;
end;

function TD2BridgeManager.GetD2BridgeFrameworkTypeClass: TD2BridgeFrameworkTypeClass;
begin
 Result:= FFrameworkExportTypeClass;
end;

function TD2BridgeManager.GetLanguages: TD2BridgeLangs;
begin
 Result:= FLanguages;
end;

function TD2BridgeManager.GetOptions: ID2BridgeManagerOptions;
begin
 Result:= FD2BridgeManagerOptions;
end;

function TD2BridgeManager.GetPrimaryFormClass: TD2BridgeFormClass;
begin
 result:= FD2BridgeFormClass;
end;

function TD2BridgeManager.GetPrism: IPrismBaseClass;
begin
 Result:= FPrism;
end;

function TD2BridgeManager.GetServerController: ID2BridgeServerControllerBase;
begin
 Result:= FServerControllerBase;
end;

function TD2BridgeManager.GetTemplateClassForm: TClass;
begin
 Result:= FTemplateClassForm;
end;

function TD2BridgeManager.GetTemplateMasterHTMLFile: string;
begin
 result:= FTemplateMasterHTMLFile;
end;

function TD2BridgeManager.GetTemplatePageHTMLFile: string;
begin
 result:= FTemplatePageHTMLFile;
end;

function TD2BridgeManager.GetVersion: string;
begin
 result:= Version;
end;

procedure TD2BridgeManager.SetD2BridgeFrameworkType(
  AD2BridgeFrameworkTypeClass: TD2BridgeFrameworkTypeClass);
begin
 FFrameworkExportTypeClass:= AD2BridgeFrameworkTypeClass;
end;

procedure TD2BridgeManager.SetGetServerController(
  AD2BridgeServerControllerBase: ID2BridgeServerControllerBase);
begin
 FServerControllerBase:= AD2BridgeServerControllerBase;
end;

procedure TD2BridgeManager.SetLanguages(const Value: TD2BridgeLangs);
begin
 FLanguages:= Value;
end;

procedure TD2BridgeManager.SetPrimaryFormClass(
  AD2BridgeFormClass: TD2BridgeFormClass);
begin
 FD2BridgeFormClass:= AD2BridgeFormClass;
end;

procedure TD2BridgeManager.SetPrism(APrism: IPrismBaseClass);
begin
 FPrism:= APrism;
end;

procedure TD2BridgeManager.SetTemplateClassForm(const Value: TClass);
begin
 FTemplateClassForm:= Value;
end;

procedure TD2BridgeManager.SetTemplateMasterHTMLFile(
  AFileMasterTemplate: string);
begin
 FTemplateMasterHTMLFile:= AFileMasterTemplate;
end;

procedure TD2BridgeManager.SetTemplatePageHTMLFile(AFilePageTemplate: string);
begin
 FTemplatePageHTMLFile:= AFilePageTemplate;
end;

function TD2BridgeManager.SupportedVCLClasses: TList<TClass>;
var
 BridgeInstance: ID2BridgeVCLObj;
 InterfaceTypeInfo: PTypeInfo;
 InterfaceGUID: TGUID;
 Instance: TObject;
 Classe: TClass;
begin
 if FSupportedVCLClasses.Count <= 0 then
 begin
  // Obtenha o TypeInfo da interface
  InterfaceTypeInfo := TypeInfo(ID2BridgeVCLObj);

  // Obtenha o GUID da interface
  InterfaceGUID := GetTypeData(InterfaceTypeInfo).Guid;

  try
   // Itere sobre todas as classes carregadas no tempo de execução
   for Classe in GetRegisteredClass do
   begin
     if Supports(Classe, InterfaceGUID) then
       begin
        Instance:= Classe.Create;

        if Supports(Instance, InterfaceGUID, BridgeInstance) then
          FSupportedVCLClasses.Add(BridgeInstance.VCLClass);

        BridgeInstance:= nil;
        Instance.Free;
       end;
   end;
  finally

  end;
 end;

 Result:= FSupportedVCLClasses;
end;

function TD2BridgeManager.SupportsVCLClass(AClass: TClass; ARaiseError: boolean): Boolean;
var
 vSupports: Boolean;
begin
 Result:= SupportedVCLClasses.Contains(OverrideVCL(AClass));

{$IFDEF MSWINDOWS}
 if (not Result) and ARaiseError and IsDebuggerPresent and (not IsD2DockerContext) then
  try
   raise Exception.Create(AClass.ClassName+' is not Renderizable with D2Bridge Framework yet');
  except
  end;
{$ENDIF}
end;

class function TD2BridgeManager.Version: string;
begin
 Result:= '2.5.78'; //Version of D2Bridge Framework
end;

end.
