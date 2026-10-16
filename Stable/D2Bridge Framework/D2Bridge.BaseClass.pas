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

unit D2Bridge.BaseClass;

interface

uses
  Classes, Generics.Collections, SysUtils,
{$IFDEF HAS_UNIT_SYSTEM_THREADING}
  System.Threading,
{$ENDIF}
{$IFDEF FMX}
  FMX.Forms,
{$ELSE}
  Forms,
{$ENDIF}
  D2Bridge.Interfaces, D2Bridge.Types, D2Bridge.HTML, D2Bridge.HTML.CSS, D2Bridge.Render.HTMLType, D2Bridge.Util,
  D2Bridge.Lang.Interfaces, D2Bridge.Lang.Core, D2Bridge.Lang.Term, D2Bridge.Lang.APP.Term, D2Bridge.Lang.APP.Core,
  D2Bridge.Render, D2Bridge.Rest.Interfaces,
  Prism.Session, Prism.Types,
  Prism.Interfaces, Prism.BaseClass.Sessions;

type

 { TD2BridgeClass }

 TD2BridgeClass = class
 strict private
  type
   D2BridgeOptions = class
   private
    FEnableHTMLRender: Boolean;
   public
    constructor Create;
    property EnableHTMLRender: Boolean read FEnableHTMLRender write FEnableHTMLRender;
   end;
 private
  FAOwner: TComponent;
  //FRender: TD2BridgeRender;
  FToken: String;
  FRenderHTMLType: ID2BridgeHTMLType;//TD2BridgeHTMLType;
  FFrameworkExportType: ID2BridgeFrameworkType;
  FEnableControlsPrefix: Boolean;
  FOptions: D2BridgeOptions;
  FHTML: TD2BridgeHTML;
  FEnableLoader: Boolean;
  FPrismSession: TPrismSession deprecated 'Use just Session';
  FControlIDs: TDictionary<string, integer>;
  FD2BridgeNested: TList<TD2BridgeClass>;
  FD2BridgePopups: TList<ID2BridgeItemHTMLPopup>;
  FD2BridgeOwner: TD2BridgeClass;
  FExportedControls: TDictionary<string,ID2BridgeItem>;
  FValidateAllControls: Boolean;
  FTempCallBacks: IPrismFormCallBacks;
  FVCLStyles: Boolean;
  FPrismControlToRegister: TList<IPrismControl>;
  FItems: ID2BridgeAddItems;
  function GetBaseClass: TD2BridgeClass;
  function GetFrameworkForm: ID2BridgeFrameworkForm;
  function GetFormObject: TObject;
  function GetVersion: string;
  function GetRootDirectory: string;
  function GetEnableControlsPrefix: Boolean;
  procedure SetEnableControlsPrefix(const Value: Boolean);
  function GetSession: TPrismSession;
  procedure SetSession(const Value: TPrismSession);
 public
  FormUUID: string;
  ControlsPrefix: string;
  FIsNested: boolean;
  Const
   PrefixAuxComponent = '_D2B';
  constructor Create(FormOwner: TComponent); virtual;
  destructor Destroy; override;

  function Items: ID2BridgeAddItems;

  function Lang: TD2BridgeTerm;
  function LangNav: TD2BridgeTerm;
  function LangAPPIsPresent: Boolean;
  function LangAPP: TD2BridgeAPPTerm;
  function Language: TD2BridgeLang;
  function LangName: string;
  function LangCode: string;

  function CreateItemID(AClassName: String): string;

  Procedure AddNested(AD2BridgeForm: TObject; ANestedName: string = '');
  function Nested(Index: Integer): TD2BridgeClass;
  function NestedCount: Integer;
  function isNestedContext: boolean;

  Procedure AddPopup(AD2BridgeItemHTMLPopup: ID2BridgeItemHTMLPopup);
  function Popup(Index: Integer): ID2BridgeItemHTMLPopup; overload;
  function Popup(AName: string): ID2BridgeItemHTMLPopup; overload;
  function Popups: TList<ID2BridgeItemHTMLPopup>;
  function PopupCount: Integer;

  function GetD2BridgeManager: ID2BridgeManager;
  procedure RenderD2Bridge(Itens: TList<ID2BridgeItem>); overload;
  procedure RenderD2Bridge(Itens: TList<ID2BridgeItem>; HTMLBody: TStrings); overload;
  procedure RenderD2Bridge(AD2BridgeItem: ID2BridgeItem); overload;
  procedure RenderD2Bridge(AD2BridgeItem: ID2BridgeItem; HTMLBody: TStrings); overload;

  function Prefix: String;

  function PrismControlFromVCLObj(VCLItem: TObject): IPrismControl;
  function PrismControlFromID(AItemID: String): IPrismControl;

  procedure Validation(VCLItem: TObject; AIsValid: Boolean; AMessage: String = '');
  procedure RemoveValidation(VCLItem: TObject);

  procedure UpdateD2BridgeControl(VCLItem: TObject);
  procedure UpdateD2BridgeAllControls;

  function Base64FromFile(AFile: string): string;
  function Base64ImageFromFile(AFile: string): string;

  function CallBackJS(ACallBackName: String; Parameters: String = ''; LockClient: Boolean = false): string; overload;
  Procedure RegisterCallBack(AName: String; ACallBackEventProc: TCallBackEvent);
  function CallBacks: IPrismFormCallBacks;
  function TempCallBacks: IPrismFormCallBacks;

  function PrismControlToRegister: TList<IPrismControl>;

  function Rest: ID2BridgeRest;

  function API: ID2BridgeAPI;
  function CSSClass: TCSSClass;
  function APPConfig: ID2BridgeAPPConfig;

  function IsD2BridgeContext: Boolean;

  function Sessions: TPrismSessions;
  function SessionsCount: integer;

  function RandomHash(ALength: Integer = 15): string;
 published
  //property Form : ID2BridgeFrameworkForm read GetForm;
  property PrismSession: TPrismSession read FPrismSession write FPrismSession;
  property Session: TPrismSession read GetSession write SetSession;
  property D2BridgeManager: ID2BridgeManager read GetD2BridgeManager;
  property FrameworkForm: ID2BridgeFrameworkForm read GetFrameworkForm;
  property Form: TObject read GetFormObject;
  property Owner : TComponent read FAOwner;
  property FormAOwner : TComponent read FAOwner;
  property ExportedControls: TDictionary<string,ID2BridgeItem> read FExportedControls write FExportedControls;
//  property HTMLText : TStringList read FHTMLText write FHTMLText;
  property RenderHTMLType : ID2BridgeHTMLType read FRenderHTMLType;
  property FrameworkExportType: ID2BridgeFrameworkType read FFrameworkExportType;
  property BaseClass: TD2BridgeClass read GetBaseClass;
  property Options: D2BridgeOptions read FOptions;
  property HTML: TD2BridgeHTML read FHTML;
  //property Render: TD2BridgeRender read Frender;
  property Token: String read FToken write FToken;
  property EnableLoader: Boolean read FEnableLoader write FEnableLoader;
  property ControlIDs: TDictionary<string, integer> read FControlIDs write FControlIDs;
  property EnableControlsPrefix: Boolean read GetEnableControlsPrefix write SetEnableControlsPrefix;
  property D2BridgeOwner: TD2BridgeClass read FD2BridgeOwner write FD2BridgeOwner;
  property RootDirectory: string read GetRootDirectory;
  property Version: string read GetVersion;
  property VCLStyles: boolean read FVCLStyles write FVCLStyles;
 end;

implementation


uses
  D2Bridge.Forms, D2Bridge.Manager, D2Bridge.Prism, D2Bridge.Prism.Form, D2Bridge.ItemCommon,
  Prism.CallBack, Prism.Util;


{ TD2BridgeClass }

procedure TD2BridgeClass.AddNested(AD2BridgeForm: TObject; ANestedName: string);
var
 AD2BridgeClassForm: TD2BridgeClass;
begin
{$IFDEF FMX}
  AD2BridgeClassForm:= TD2BridgeClass(TD2BridgeForm(AD2BridgeForm).D2Bridge);
{$ELSE}
  AD2BridgeClassForm:= TD2BridgeForm(AD2BridgeForm).D2Bridge;
{$ENDIF}

 if not FD2BridgeNested.Contains(AD2BridgeClassForm) then
 begin
  if ANestedName <> '' then
   TD2BridgeForm(AD2BridgeClassForm.FormAOwner).NestedName:= ANestedName
  else
   TD2BridgeForm(AD2BridgeClassForm.FormAOwner).NestedName:= TD2BridgeForm(AD2BridgeClassForm.FormAOwner).Name;

  AD2BridgeClassForm.D2BridgeOwner:= self;
  AD2BridgeClassForm.FIsNested:= true;

  AD2BridgeClassForm.EnableControlsPrefix:= true;
  TD2BridgeForm(AD2BridgeClassForm.FormAOwner).Clear;
  TD2BridgeForm(AD2BridgeClassForm.FormAOwner).Render;

  FD2BridgeNested.Add(AD2BridgeClassForm);

  if PrismSession.D2BridgeForms.Contains(AD2BridgeClassForm) then
  PrismSession.D2BridgeForms.Remove(AD2BridgeClassForm);
 end;
end;

procedure TD2BridgeClass.AddPopup(
  AD2BridgeItemHTMLPopup: ID2BridgeItemHTMLPopup);
begin
 FD2BridgePopups.Add(AD2BridgeItemHTMLPopup);
end;

function TD2BridgeClass.API: ID2BridgeAPI;
begin
 result:= D2BridgeManager.API;
end;

function TD2BridgeClass.APPConfig: ID2BridgeAPPConfig;
begin
 result:= D2BridgeManager.ServerController.APPConfig;
end;

function TD2BridgeClass.Base64FromFile(AFile: string): string;
begin
 result:= D2Bridge.Util.Base64FromFile(AFile);
end;

function TD2BridgeClass.Base64ImageFromFile(AFile: string): string;
begin
 result:= D2Bridge.Util.Base64ImageFromFile(AFile);
end;

function TD2BridgeClass.CallBackJS(ACallBackName: String; Parameters: String;
 LockClient: Boolean): string;
begin
 Result:= PrismSession.CallBacks.CallBackJS(ACallBackName, true, '', Parameters, LockClient);
end;

function TD2BridgeClass.CallBacks: IPrismFormCallBacks;
var
 vPrismForm: IPrismForm;
begin
 if Supports(GetFormObject, IPrismForm, vPrismForm) then
  result:= vPrismForm.CallBacks
 else
 begin
  if not Assigned(FTempCallBacks) then
   FTempCallBacks:= TPrismFormCallBacks.Create(FormUUID, nil, PrismSession);

  Result:= FTempCallBacks;
 end;
end;

constructor TD2BridgeClass.Create(FormOwner: TComponent);
begin
 FAOwner:= FormOwner;

 System.Initialize(FTempCallBacks);

 FItems:= TD2BridgeItems.Create(self);

 FIsNested:= false;

 FEnableControlsPrefix:= false;

 FormUUID:= GenerateRandomString(14);
 ControlsPrefix:= GenerateRandomJustString(7);

 //FD2BridgeItems:= TD2BridgeItems.Create(self);
 FRenderHTMLType:= TD2BridgeHTMLBootStrap.create;
 FOptions:= D2BridgeOptions.Create;
 FHTML:= TD2BridgeHTML.create(self);
 FHTML.Options.ValidateAllControls:= D2BridgeManager.Prism.Options.ValidateAllControls;
 FVCLStyles:= D2BridgeManager.Prism.Options.VCLStyles;

 //FRender:= TD2BridgeRender.Create(BaseClass);
 FToken:= GenerateRandomString(16);
 FEnableLoader:= true;

 FControlIDs:= TDictionary<string, integer>.Create;

 FD2BridgeNested:= TList<TD2BridgeClass>.Create;
 FD2BridgePopups:= TList<ID2BridgeItemHTMLPopup>.Create;
 FPrismControlToRegister:= TList<IPrismControl>.Create;

 FExportedControls:= TDictionary<string,ID2BridgeItem>.Create;

 if (D2BridgeManager as TD2BridgeManager).FrameworkExportTypeClass = TD2BridgePrismFramework then
  FFrameworkExportType:= TD2BridgePrismFramework.Create(self);

 FFrameworkExportType.TemplateMasterHTMLFile:= D2BridgeManager.TemplateMasterHTMLFile;
 FFrameworkExportType.TemplatePageHTMLFile:= D2BridgeManager.TemplatePageHTMLFile;
end;

function TD2BridgeClass.CreateItemID(AClassName: String): string;
var
 I: Integer;
begin
 if AClassName = '' then
 AClassName:= 'D2BridgeControl';

 if FControlIDs.TryGetValue(AClassName, I) then
  Inc(I)
 else
  I:= 1;

 FControlIDs.AddOrSetValue(AClassName, I);

 Result:= AClassName + IntToStr(I);
end;

function TD2BridgeClass.CSSClass: TCSSClass;
begin
 Result:= D2BridgeManager.CSSClass;
end;

destructor TD2BridgeClass.Destroy;
var
 vTempCallBacks: TPrismFormCallBacks;
 vRenderHTMLType: TD2BridgeHTMLBootStrap;
 vFrameworkExportType: TD2BridgePrismFramework;
 vItems: TD2BridgeItems;
 I: integer;
begin
 try
  if Assigned(FTempCallBacks) then
  begin
   vTempCallBacks:= FTempCallBacks as TPrismFormCallBacks;
   FTempCallBacks:= nil;
   vTempCallBacks.Free;
  end;
 except
 end;

 try
  if FRenderHTMLType is TD2BridgeHTMLBootStrap then
  begin
   vRenderHTMLType:= FRenderHTMLType as TD2BridgeHTMLBootStrap;
   FRenderHTMLType:= nil;
   vRenderHTMLType.Free;
  end;
 except
 end;

 try
  if Assigned(FOptions) then
   FOptions.Free;
 except
 end;

 //FPrismControlToRegister.Clear;
 try
  if Assigned(FPrismControlToRegister) then
   FreeInterfaceList(TList<IInterface>(FPrismControlToRegister));
 except
 end;

 try
  if Assigned(FD2BridgePopups) then
   FreeInterfaceList(TList<IInterface>(FD2BridgePopups));
 except
 end;

 try
  FreeAndNil(FHTML);
 except
 end;

 try
  FreeAndNil(FControlIDs);
 except
 end;

 try
  FreeAndNil(FD2BridgeNested);
 except
 end;

// for vID2BridgeItem in FExportedControls.Values do
//  if Supports(vID2BridgeItem, ID2BridgeItem, vD2BridgeItem) then
//   if vD2BridgeItem <> nil then
//    FreeAndNil(vD2BridgeItem);
 try
  for I := 0 to Pred(FExportedControls.Count) do
   FExportedControls.Items[FExportedControls.Keys.ToArray[I]]:= nil;
  FExportedControls.Clear;
  FreeAndNil(FExportedControls);
 except
 end;

 try
  vItems:= FItems as TD2BridgeItems;
  FItems:= nil;
  vItems.Free;
 except
 end;

 try
  if Assigned(FFrameworkExportType) then
  begin
   vFrameworkExportType:= FFrameworkExportType as TD2BridgePrismFramework;
   FFrameworkExportType:= nil;
   vFrameworkExportType.Free;
  end;
 except
 end;

 inherited;
end;

function TD2BridgeClass.GetBaseClass: TD2BridgeClass;
begin
 result:= self;
end;


function TD2BridgeClass.GetD2BridgeManager: ID2BridgeManager;
begin
 Result:= D2Bridge.Manager.D2BridgeManager;
end;

function TD2BridgeClass.GetEnableControlsPrefix: Boolean;
begin
 result:= FEnableControlsPrefix;
end;

function TD2BridgeClass.GetFormObject: TObject;
begin
 Result:= nil;

 if Assigned(FrameworkExportType) then
  if Assigned(FrameworkExportType.Form) then
   Result:= FrameworkExportType.Form;
end;

function TD2BridgeClass.GetFrameworkForm: ID2BridgeFrameworkForm;
begin
 Result:= FrameworkExportType.FrameworkForm;
end;

function TD2BridgeClass.GetRootDirectory: string;
begin
 Result:= D2BridgeManager.Prism.Options.RootDirectory;
end;

function TD2BridgeClass.GetSession: TPrismSession;
begin
 result:= FPrismSession;
end;

function TD2BridgeClass.GetVersion: string;
begin
 Result:= D2BridgeManager.Version;
end;

function TD2BridgeClass.IsD2BridgeContext: Boolean;
begin
 {$IFDEF D2BRIDGE}
 Result := True;
 {$ELSE}
 Result := False;
 {$ENDIF}
end;

function TD2BridgeClass.isNestedContext: boolean;
begin
  result:= FIsNested;
end;

function TD2BridgeClass.Items: ID2BridgeAddItems;
begin
 result:= FItems;
end;

function TD2BridgeClass.Lang: TD2BridgeTerm;
begin
 Result:= PrismSession.Lang;
end;

function TD2BridgeClass.LangAPP: TD2BridgeAPPTerm;
begin
 if LangAPPIsPresent then
   Result:= (D2BridgeLangAPPCore.LangByTD2BridgeLang(Language) as TD2BridgeAPPTerm);
end;

function TD2BridgeClass.LangAPPIsPresent: Boolean;
begin
 Result:= Assigned(D2BridgeLangAPPCore);
end;

function TD2BridgeClass.LangCode: string;
begin
 Result:= PrismSession.LangCode;
end;

function TD2BridgeClass.LangName: string;
begin
 Result:= PrismSession.LangName;
end;

function TD2BridgeClass.LangNav: TD2BridgeTerm;
begin
 Result:= PrismSession.LangNav;
end;

function TD2BridgeClass.Language: TD2BridgeLang;
begin
 Result:= PrismSession.Language;
end;

function TD2BridgeClass.Nested(Index: Integer): TD2BridgeClass;
begin
 Result:= FD2BridgeNested[Index];
end;

function TD2BridgeClass.NestedCount: Integer;
begin
 Result:= FD2BridgeNested.Count;
end;

function TD2BridgeClass.Popup(Index: Integer): ID2BridgeItemHTMLPopup;
begin
 Result:= FD2BridgePopups[Index];
end;

function TD2BridgeClass.Popup(AName: string): ID2BridgeItemHTMLPopup;
var
 vPopup: ID2BridgeItemHTMLPopup;
begin
 result:= nil;

 for vPopup in FD2BridgePopups do
  if SameText(vPopup.ItemID, AName)  then
  begin
   Result:= vPopup;
   break;
  end;
end;

function TD2BridgeClass.Popups: TList<ID2BridgeItemHTMLPopup>;
begin
 result:= FD2BridgePopups;
end;

function TD2BridgeClass.PopupCount: Integer;
begin
 Result:= FD2BridgePopups.Count;
end;

function TD2BridgeClass.Prefix: String;
begin
 Result:= ControlsPrefix; //TD2BridgePrismForm(FrameworkForm).ControlsPrefix;
end;

function TD2BridgeClass.PrismControlFromID(AItemID: String): IPrismControl;
var
 FPrismControl: IPrismControl;
 I: Integer;
begin
 Initialize(FPrismControl);
 Initialize(Result);

 try
  if Assigned(FrameworkForm) then
  begin
   for I := 0 to Pred((FrameworkForm as TD2BridgePrismForm).Controls.Count) do
   begin
    if Assigned((FrameworkForm as TD2BridgePrismForm).Controls[I].Form) then
     if (FrameworkForm as TD2BridgePrismForm).Controls[I].Form = (FrameworkForm as IPrismForm) then
      if SameText((FrameworkForm as TD2BridgePrismForm).Controls[I].Name, AItemID) then
      begin
       Result:= (FrameworkForm as TD2BridgePrismForm).Controls.Items[I];

       break;
      end;
   end;

   if not Assigned(result) then
   begin
    for I := 0 to Pred(FExportedControls.Keys.Count) do
    begin
     if SameText(FExportedControls.Keys.ToArray[I], AItemID) then
     begin
      result:= FExportedControls[FExportedControls.Keys.ToArray[I]].PrismControl;
      break;
     end;
    end;
   end;
  end;
 except
 end;
end;

function TD2BridgeClass.PrismControlFromVCLObj(VCLItem: TObject): IPrismControl;
var
 FPrismControl: IPrismControl;
 I: Integer;
begin
 System.Initialize(FPrismControl);
 System.Initialize(Result);

 if Assigned(FrameworkForm) then
 begin
  for I := 0 to Pred((FrameworkForm as TD2BridgePrismForm).Controls.Count) do
  begin
   if (Assigned((FrameworkForm as TD2BridgePrismForm).Controls[I].VCLComponent)) and
      ((FrameworkForm as TD2BridgePrismForm).Controls[I].VCLComponent = VCLItem) then
   begin
    Result:= (FrameworkForm as TD2BridgePrismForm).Controls.Items[I];

    break;
   end;
  end;
 end;
end;

function TD2BridgeClass.PrismControlToRegister: TList<IPrismControl>;
begin
 result:= FPrismControlToRegister;
end;

procedure TD2BridgeClass.UpdateD2BridgeAllControls;
begin
 PrismSession.ExecJS('UpdateD2BridgeControls(PrismComponents)');
end;

procedure TD2BridgeClass.UpdateD2BridgeControl(VCLItem: TObject);
var
 vPrismControl: IPrismControl;
begin
 vPrismControl := PrismControlFromVCLObj(VCLItem);

 if Assigned(vPrismControl) then
 begin
  vPrismControl.Refresh;

  if Assigned(vPrismControl) then
  begin
   PrismSession.ExecJS('UpdateD2BridgeControls([PrismComponents.find(obj => obj.id === "' + AnsiUpperCase(vPrismControl.NamePrefix) + '")])');
  end;
 end;
end;

function TD2BridgeClass.RandomHash(ALength: Integer): string;
begin
 result:= GenerateRandomString(ALength);
end;

procedure TD2BridgeClass.RegisterCallBack(AName: String;
  ACallBackEventProc: TCallBackEvent);
begin
 CallBacks.Register(AName, ACallBackEventProc);
end;

procedure TD2BridgeClass.RemoveValidation(VCLItem: TObject);
var
 vPrismControl: IPrismControl;
begin
 vPrismControl := PrismControlFromVCLObj(VCLItem);

 if Assigned(vPrismControl) then
 begin
  PrismSession.ExecJS('removeValidationFeedback("'+ AnsiUpperCase(vPrismControl.NamePrefix) +'")');
 end;
end;

procedure TD2BridgeClass.RenderD2Bridge(Itens: TList<ID2BridgeItem>; HTMLBody: TStrings);
var
 vBegin, vEnd, I: integer;
begin
 vBegin:= TD2BridgeClass(BaseClass).HTML.Render.Body.Count;

 RenderD2Bridge(Itens);

 vEnd:= TD2BridgeClass(BaseClass).HTML.Render.Body.Count;

 if vBegin < vEnd then
 begin
  for I := vBegin to Pred(vEnd) do
   HTMLBody.Add(TD2BridgeClass(BaseClass).HTML.Render.Body.Strings[I]);

  for I := Pred(vEnd) downto vBegin do
   TD2BridgeClass(BaseClass).HTML.Render.Body.Delete(I)
 end;
end;

procedure TD2BridgeClass.RenderD2Bridge(AD2BridgeItem: ID2BridgeItem);
var
 FRender: TD2BridgeRender;
 vItens: TList<ID2BridgeItem>;
begin
 FRender:= TD2BridgeRender.Create(Self);
 vItens:= TList<ID2BridgeItem>.Create;
 vItens.Add(AD2BridgeItem);
 FRender.RenderD2Bridge(vItens);
 FreeAndNil(FRender);
 FreeInterfaceList(TList<IInterface>(vItens));
end;

function TD2BridgeClass.Rest: ID2BridgeRest;
begin
 result:= D2BridgeManager.Prism.Rest;
end;

function TD2BridgeClass.Sessions: TPrismSessions;
begin
 result:= D2BridgeManager.Prism.Sessions as TPrismSessions;
end;

function TD2BridgeClass.SessionsCount: integer;
begin
 if IsD2BridgeContext then
 begin
  result:= Sessions.Count;
 end else
 begin
  result:= 1;
 end;
end;

procedure TD2BridgeClass.SetEnableControlsPrefix(const Value: Boolean);
begin
 FEnableControlsPrefix:= Value;
end;

procedure TD2BridgeClass.SetSession(const Value: TPrismSession);
begin
 FPrismSession:= Value;
end;

function TD2BridgeClass.TempCallBacks: IPrismFormCallBacks;
begin
 result:= FTempCallBacks;
end;

procedure TD2BridgeClass.RenderD2Bridge(Itens: TList<ID2BridgeItem>);
var
 FRender: TD2BridgeRender;
begin
 FRender:= TD2BridgeRender.Create(Self);
 FRender.RenderD2Bridge(Itens);
 FreeAndNil(FRender);
end;

procedure TD2BridgeClass.Validation(VCLItem: TObject; AIsValid: Boolean;
  AMessage: String);
var
 vPrismControl: IPrismControl;
begin
 vPrismControl := PrismControlFromVCLObj(VCLItem);

 if Assigned(vPrismControl) then
 begin
  PrismSession.ExecJS('insertValidationFeedback("'+ AnsiUpperCase(vPrismControl.NamePrefix) +'", ' + BoolToStr(AIsValid, True).ToLower + ', "' + AMessage + '")');
 end;
end;

procedure TD2BridgeClass.RenderD2Bridge(AD2BridgeItem: ID2BridgeItem; HTMLBody: TStrings);
var
 vBegin, vEnd, I: integer;
begin
 vBegin:= TD2BridgeClass(BaseClass).HTML.Render.Body.Count;

 RenderD2Bridge(AD2BridgeItem);

 vEnd:= TD2BridgeClass(BaseClass).HTML.Render.Body.Count;

 if vBegin < vEnd then
 begin
  for I := vBegin to Pred(vEnd) do
   HTMLBody.Add(TD2BridgeClass(BaseClass).HTML.Render.Body.Strings[I]);

  for I := Pred(vEnd) downto vBegin do
   TD2BridgeClass(BaseClass).HTML.Render.Body.Delete(I)
 end;

end;

{ TD2BridgeClass.D2BridgeOptions }

constructor TD2BridgeClass.D2BridgeOptions.Create;
begin
 FEnableHTMLRender:= true;
end;

end.