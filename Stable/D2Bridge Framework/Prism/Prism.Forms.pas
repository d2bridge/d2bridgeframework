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

{$I ..\D2Bridge.inc}

unit Prism.Forms;

interface

uses
  Classes, SysUtils, Generics.Collections, Rtti, SyncObjs,
{$IFDEF HAS_UNIT_REGULAREXPRESSIONSAPI}
  System.RegularExpressions,
{$ELSE}
  RegExpr,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
{$IFDEF FMX}
  FMX.ExtCtrls, FMX.Forms,
{$ELSE}
  ExtCtrls, Forms,
{$ENDIF}
  Prism.Interfaces, Prism.Events, Prism.Session, Prism.Form.Timer, Prism.Types,
  Prism.CallBack,
  D2bridge.JSON, D2Bridge.Forms;


type
 TSimpleCallBack = record
  Referente: string;
  Name: string;
  Parameters: string;
 end;

type
 TPrismForm = class(TInterfacedPersistent, IPrismForm)
  strict private
   procedure Exec_DoCellButtonClick(varPrismStringGrid, varPrismCellButton, varColIndex, varRow: TValue);
   procedure Exec_ShowPopup(varPopupName: TValue);
{$IFNDEF FMX}
   procedure Exec_DoDBCellButtonClick(varDBGrid, varPrismCellButton, varColIndex, varRow: TValue);
{$ENDIF}
  private
   FName: string;
   FOnProcessHTML: TProcessHTMLNotify;
   FOnPageLoaded: TNotifyEvent;
   FOnTagHTML: TOnTagHTML;
   FTemplateMasterHTMLFile: string;
   FTemplatePageHTMLFile: string;
   FControls: TList<IPrismControl>;
   FTimerObserver: TPrismFormTimer;
   FFormUUID: String;
   FPrismSession: TPrismSession;
   FFormHTMLText: string;
   FFormCacheHTMLText: string;
   FHeadHTMLPrism: String;
   FFormPageState: TPrismPageState;
   FFormComponentsUpdating: Boolean;
   FServerControlsUpdating: Boolean;
   FForceUpdateControls: Boolean;
   FFocusedControl: IPrismControl;
   FControlsPrefix: String;
   FOnShowPopup: TOnPopup;
   FOnClosePopup: TOnPopup;
   FOnUpload: TOnUpload;
   FCallBacks: IPrismFormCallBacks;
   FSimpleCallBacks: TList<TSimpleCallBack>;
   FD2BridgeForm: TD2BridgeForm;
   FDestroying: Boolean;
   FLock: TMultiReadExclusiveWriteSynchronizer;
   procedure SetName(AName: String); reintroduce;
   function GetName: String; reintroduce;
   function GetControls: TList<IPrismControl>;
{$IFNDEF FPC}
   function GetFormUUID: string;
{$ENDIF}
   procedure SetSession(ASession: IPrismSession);
   function GetSession: IPrismSession;
   procedure SetTemplateMasterHTMLFile(AFileMasterTemplate: string);
   procedure SetTemplatePageHTMLFile(AFilePageTemplate: string);
   function GetTemplateMasterHTMLFile: string;
   function GetTemplatePageHTMLFile: string;
   Function GetFormHTMLText: string;
   procedure SetFormHTMLText(AHTMLText: string);
   Function GetFormCacheHTMLText: string;
   procedure SetFormCacheHTMLText(AHTMLText: string);
   Function GetHeadHTMLPrism: string;
   procedure SetHeadHTMLPrism(AHTMLText: string);
   function GetFormPageState: TPrismPageState;
   procedure SetFormPageState(Value: TPrismPageState);
   function GetComponentsUpdating: Boolean;
   function GetFocusedControl: IPrismControl;
   procedure SetFocusedControl(APrismControl: IPrismControl);
   function GetControlsPrefix: String;
   function GetEnableControlsPrefix: Boolean;
   function GetLanguage: String;
   function ProcessAllTagHTML(HTMLText: String): string;
   procedure ProcessTagHTML(var HTMLText: String);
   procedure ProcessCallBackTagHTML(var HTMLText: String);
   procedure SetOnShowPopup(AOnPopupEvent: TOnPopup);
   function GetOnShowPopup: TOnPopup;
   procedure SetOnClosePopup(AOnPopupEvent: TOnPopup);
   function GetOnClosePopup: TOnPopup;
   function GetOnUpload: TOnUpload;
   procedure SetOnUpload(const Value: TOnUpload);
   function GetServerControlsUpdating: boolean;
  protected
{$IFDEF FPC}
   function GetFormUUID: string;
{$ENDIF}
   procedure OnTimerObserver;
   procedure DoTagHTML(const TagString: string; var ReplaceTag: string); virtual;
   procedure DoTagTranslate(const Language: TD2BridgeLang; const AContext: string; const ATerm: string; var ATranslated: string); virtual;
   procedure DoCallBack(const CallBackName: String; EventParams: TStrings); virtual;
   procedure DoBeginUpdateD2BridgeControls; virtual;
   procedure DoEndUpdateD2BridgeControls; virtual;
   procedure TagHTML(const TagString: string; var ReplaceTag: string); virtual;
   procedure CallBack(const CallBackName: String; EventParams: TStrings); virtual;
  public
   constructor Create(AOwner: TObject);
   destructor Destroy; override;

   procedure Clear;
   Procedure AddControl(APrismControl: IPrismControl);
   procedure ProcessControlsToHTML(var HTMLText: String);
   procedure ProcessNested(var HTMLText: String);
   procedure ProcessPopup(var HTMLText: String);
   procedure ProcessTags(var HTMLText: String);
   procedure ProcessTagTranslate(var HTMLText: String);
   procedure Show; virtual;
   procedure Close;
   procedure OnAfterPageLoad(EventParams: TStrings); virtual;
   procedure OnPageResize(EventParams: TStrings); virtual;
   procedure OnOrientationChange(EventParams: TStrings); virtual;
   procedure OnBeforePageLoad;
   procedure onFormUnload;
   procedure onComponentsUpdating;
   procedure onComponentsUpdated;
   procedure DoUpload(AFiles: TStrings; Sender: TObject); virtual;
   procedure DoCellButtonClick(APrismStringGrid: IPrismStringGrid; APrismCellButton: IPrismGridColumnButton; AColIndex: Integer; ARow: Integer); overload; virtual;
{$IFNDEF FMX}
   procedure DoCellButtonClick(APrismDBGrid: IPrismDBGrid; APrismCellButton: IPrismGridColumnButton; AColIndex: Integer; ARow: Integer); overload; virtual;
   procedure DoCardGridClick(PrismControlClick: TPrismControl; ARow: Integer; APrismCardGrid: IPrismCardGridDataModel); virtual;
{$ENDIF}
   procedure DoKanbanClick(AKanbanCard: IPrismCardModel; PrismControlClick: TPrismControl); virtual;
   procedure DoBeginTranslate; virtual;
   procedure DoBeginTagHTML; virtual;
   procedure DoEndTagHTML; virtual;
   procedure DoEventD2Bridge(const PrismControl: TPrismControl; const EventType: TPrismEventType; EventParams: TStrings); virtual;
   procedure DoInitPrismControl(const PrismControl: TPrismControl); virtual;
   procedure DoExportD2Bridge; overload; virtual;
   procedure DoExportD2Bridge(D2Bridge: TObject); overload; virtual;
   procedure DoBeginRender; virtual;
   procedure DoEndRender; virtual;
   procedure Initialize;
   function D2BridgeForm: TD2BridgeForm;

   function Destroying: Boolean;

   procedure UpdateServerControls;
   procedure UpdateControls;

   procedure ShowPopup(AName: String);
   procedure ClosePopup(AName: String);
   function PrismOptions: IPrismOptions;

   function CallBacks: IPrismFormCallBacks;

   property Name: String read GetName write SetName;
   property Controls: TList<IPrismControl> read GetControls;
   property TemplateMasterHTMLFile: string read GetTemplateMasterHTMLFile write SetTemplateMasterHTMLFile;
   property TemplatePageHTMLFile: string read GetTemplatePageHTMLFile write SetTemplatePageHTMLFile;
   property FormHTMLText: string read GetFormHTMLText write SetFormHTMLText;
   property FormCacheHTMLText: string read GetFormCacheHTMLText write SetFormCacheHTMLText;
   property HeadHTMLPrism: string read GetHeadHTMLPrism write SetHeadHTMLPrism;
   property FormPageState: TPrismPageState read GetFormPageState write SetFormPageState;
   property Session: TPrismSession read FPrismSession write FPrismSession;
   property ServerControlsUpdating: boolean read GetServerControlsUpdating;
   property ComponentsUpdating: Boolean read GetComponentsUpdating;
   property FormUUID: string read GetFormUUID;
   property FocusedControl: IPrismControl read GetFocusedControl write SetFocusedControl;
   property Language: String read GetLanguage;
   property ControlsPrefix: String read GetControlsPrefix;
   property EnableControlsPrefix: Boolean read GetEnableControlsPrefix;
   property FormTimer: TPrismFormTimer read FTimerObserver write FTimerObserver;
  published
   property OnProcessHTML: TProcessHTMLNotify read FOnProcessHTML write FOnProcessHTML;
   property OnTagHTML: TOnTagHTML read FOnTagHTML write FOnTagHTML;
   property OnPageLoaded: TNotifyEvent read FOnPageLoaded write FOnPageLoaded;
   property OnShowPopup: TOnPopup read GetOnShowPopup write SetOnShowPopup;
   property OnClosePopup: TOnPopup read GetOnClosePopup write SetOnClosePopup;
   property OnUpload: TOnUpload read GetOnUpload write SetOnUpload;
 end;

implementation

uses
  Prism.Forms.Controls, Prism.Util, Prism.BaseClass, Prism.Session.Helper,
  D2Bridge.Manager, D2Bridge.BaseClass;


{ PrismForm }

procedure TPrismForm.AddControl(APrismControl: IPrismControl);
begin
 APrismControl.Form:= self;

 if not Controls.Contains(APrismControl) then
  Controls.Add(APrismControl);
end;

procedure TPrismForm.CallBack(const CallBackName: String; EventParams: TStrings);
begin

end;

function TPrismForm.CallBacks: IPrismFormCallBacks;
begin
 Result:= FCallBacks;
end;

procedure TPrismForm.Clear;
var
 vPrismControlIntf: IPrismControl;
 vPrismControl: TPrismControl;
begin
 try
  while FControls.Count > 0 do
  begin
   vPrismControlIntf:= FControls.Last;
   FControls.Delete(Pred(FControls.Count));

   try
    vPrismControl:= vPrismControlIntf as TPrismControl;

    if (not Assigned(vPrismControlIntf.Form)) or
       (Assigned(vPrismControlIntf.Form) and ((vPrismControlIntf.Form as TPrismForm) <> self)) then
    begin
     vPrismControlIntf:= nil;
     Continue; //Nested
    end;
   except
   end;

   try
    vPrismControlIntf:= nil;
    vPrismControl.Free;
   except
   end;
  end;
 except
 end;

 FormCacheHTMLText:= '';
end;

procedure TPrismForm.Close;
begin
 FFormPageState:= PageStateUnloaded;
end;

procedure TPrismForm.ClosePopup(AName: String);
begin
// Session.ExecThread(true,
//  procedure
//  begin
   D2BridgeForm.ClosePopup(AName);
//  end
// );
end;

constructor TPrismForm.Create(AOwner: TObject);
begin
 inherited Create;

 if AOwner is TD2BridgeForm then
 begin
  FD2BridgeForm:= TD2BridgeForm(AOwner);
  FFormUUID:= FD2BridgeForm.D2Bridge.FormUUID;
  FControlsPrefix:= FD2BridgeForm.D2Bridge.ControlsPrefix;
 end else
 begin
  FFormUUID:= GenerateRandomString(14);
  FControlsPrefix:= GenerateRandomJustString(7);
 end;

 FTimerObserver:= TPrismFormTimer.Create(self, 1, OnTimerObserver);

 FCallBacks:= TPrismFormCallBacks.Create(FormUUID, Self, Session);

 FFormHTMLText:= '';
 FFormCacheHTMLText:= '';

 FDestroying:= false;

 FFormPageState:= PageStateUnloaded;
 FServerControlsUpdating:= false;
 FFormComponentsUpdating:= false;
 FForceUpdateControls:= false;

 System.Initialize(FFocusedControl);

 FControls:= TList<IPrismControl>.Create;
 FSimpleCallBacks:= TList<TSimpleCallBack>.Create;
end;

function TPrismForm.D2BridgeForm: TD2BridgeForm;
begin
 if Assigned(FD2BridgeForm) then
  Result:= FD2BridgeForm
 else
  Result:= TD2BridgeForm(TD2BridgeClass(Session.D2BridgeBaseClassActive).FormAOwner);
end;

destructor TPrismForm.Destroy;
var
 I: Integer;
 //vPrismControlIntf: IPrismControl;
 //vPrismControl: TPrismControl;
 vCallBacks: TPrismFormCallBacks;
begin
 FDestroying:= true;

 FSimpleCallBacks.Clear;

 FFormComponentsUpdating:= true;

 if Assigned(FFocusedControl) then
  FFocusedControl:= nil;

 try
  if Assigned(FTimerObserver) then
  begin
   FTimerObserver.PrismForm:= nil;

   FTimerObserver.Terminate;
  end;
  //Este Sleep é necessário por que o Timer acima
  //vai tentar chamar o OnTimer e o PrismForm não existe
  //mais
  //sleep(1000);
  //FTimerObserver:= nil;
 except
 end;

// try
//  while FControls.Count > 0 do
//  begin
//   vPrismControlIntf:= FControls.Last;
//   FControls.Delete(Pred(FControls.Count));
//
//   try
//    vPrismControl:= vPrismControlIntf as TPrismControl;
//
//    if (not Assigned(vPrismControlIntf.Form)) or
//       (Assigned(vPrismControlIntf.Form) and ((vPrismControlIntf.Form as TPrismForm) <> self)) then
//    begin
//     vPrismControlIntf:= nil;
//     Continue; //Nested
//    end;
//   except
//   end;
//
//   try
//    vPrismControlIntf:= nil;
//    vPrismControl.Free;
//   except
//   end;
//  end;
//
//  FControls.Free;
// except
// end;

 Clear;

 //DestroyComponents;

 vCallBacks:= FCallBacks as TPrismFormCallBacks;
 FCallBacks:= nil;
 vCallBacks.Free;

 Session.CallBacks.UnRegisterAll(self);

 FreeAndNil(FSimpleCallBacks);

 FControls.Free;

 inherited;
end;

function TPrismForm.Destroying: Boolean;
begin
 Result:= FDestroying;
end;

procedure TPrismForm.DoBeginRender;
begin

end;

procedure TPrismForm.DoBeginTagHTML;
begin
 D2BridgeForm.DoBeginTagHTML;
end;

procedure TPrismForm.DoBeginTranslate;
begin
 D2BridgeForm.DoBeginTranslate;
end;

procedure TPrismForm.DoBeginUpdateD2BridgeControls;
begin
 D2BridgeForm.DoBeginUpdateD2BridgeControls;
end;

procedure TPrismForm.DoCallBack(const CallBackName: String; EventParams: TStrings);
begin
 CallBack(CallBackName, EventParams);

 D2BridgeForm.DoCallBack(CallBackName, EventParams);
end;

procedure TPrismForm.DoCellButtonClick(APrismStringGrid: IPrismStringGrid; APrismCellButton: IPrismGridColumnButton; AColIndex: Integer; ARow: Integer);
begin
  Session.ExecThread(true,
   Exec_DoCellButtonClick,
   TValue.From<TPrismStringGrid>(APrismStringGrid as TPrismStringGrid),
   TValue.From<TPrismGridColumnButton>(APrismCellButton as TPrismGridColumnButton),
   TValue.From<Integer>(AColIndex),
   TValue.From<Integer>(ARow)
  );
end;

{$IFNDEF FMX}
procedure TPrismForm.DoCellButtonClick(APrismDBGrid: IPrismDBGrid; APrismCellButton: IPrismGridColumnButton; AColIndex: Integer; ARow: Integer);
begin
  Session.ExecThread(true,
   Exec_DoDBCellButtonClick,
   TValue.From<TPrismDBGrid>(APrismDBGrid as TPrismDBGrid),
   TValue.From<TPrismGridColumnButton>(APrismCellButton as TPrismGridColumnButton),
   TValue.From<Integer>(AColIndex),
   TValue.From<Integer>(ARow)
  );
end;
{$ENDIF}

procedure TPrismForm.DoEndRender;
begin

end;

procedure TPrismForm.DoEndTagHTML;
begin
 D2BridgeForm.DoEndTagHTML;
end;

procedure TPrismForm.DoEndUpdateD2BridgeControls;
begin
 Sleep(1);
 D2BridgeForm.DoEndUpdateD2BridgeControls;
end;

procedure TPrismForm.DoEventD2Bridge(const PrismControl: TPrismControl; const EventType: TPrismEventType; EventParams: TStrings);
begin
 D2BridgeForm.DoEventD2Bridge(PrismControl, EventType, EventParams);
end;

procedure TPrismForm.DoExportD2Bridge;
begin
end;

procedure TPrismForm.DoExportD2Bridge(D2Bridge: TObject);
begin
end;

{$IFNDEF FMX}
procedure TPrismForm.DoCardGridClick(PrismControlClick: TPrismControl; ARow: Integer; APrismCardGrid: IPrismCardGridDataModel);
begin
 D2BridgeForm.DoCardGridClick(PrismControlClick, ARow, APrismCardGrid as TPrismCardGridDataModel);
end;
{$ENDIF}

procedure TPrismForm.DoInitPrismControl(const PrismControl: TPrismControl);
begin
 if D2BridgeForm <> nil then
  D2BridgeForm.DoInitPrismControl(PrismControl);
end;

procedure TPrismForm.DoKanbanClick(AKanbanCard: IPrismCardModel; PrismControlClick: TPrismControl);
begin
 D2BridgeForm.DoKanbanClick(AKanbanCard, PrismControlClick);
end;

procedure TPrismForm.DoTagHTML(const TagString: string; var ReplaceTag: string);
begin
 if Assigned(FOnTagHTML) then
  FOnTagHTML(TagString, ReplaceTag);

 TagHTML(TagString, ReplaceTag);

 if ((TagString = ReplaceTag) or
    (((AnsiPos(ReplaceTag, '{{') = 0) and (Copy(ReplaceTag, length(ReplaceTag)-1) = '}}')) and
     (TagString = Copy(ReplaceTag, 3, length(ReplaceTag)-4)))) then
 begin
//     Session.ExecThread(true,
//      procedure
//      begin
  try
   D2BridgeForm.DoTagHTML(TagString, ReplaceTag);
  except
  end;
//      end
//     );
 end;

end;

procedure TPrismForm.DoTagTranslate(const Language: TD2BridgeLang; const AContext: string; const ATerm: string; var ATranslated: string);
begin
 D2BridgeForm.DoTagTranslate(Language, AContext, ATerm, ATranslated);
end;

procedure TPrismForm.DoUpload(AFiles: TStrings; Sender: TObject);
begin
 if Assigned(FOnUpload) then
  FOnUpload(AFiles, Sender);

// Session.ExecThread(true,
//  procedure
//  begin
   D2BridgeForm.DoUpload(AFiles, Sender);
//  end
// );

end;

procedure TPrismForm.Exec_DoCellButtonClick(varPrismStringGrid, varPrismCellButton, varColIndex, varRow: TValue);
var
 APrismStringGrid: TPrismStringGrid;
 APrismCellButton: TPrismGridColumnButton;
 AColIndex:        Integer;
 ARow:             Integer;
begin
 try
  APrismStringGrid:= TPrismStringGrid(varPrismStringGrid.AsObject);
  APrismCellButton:= TPrismGridColumnButton(varPrismCellButton.AsObject);
  AColIndex:=        varColIndex.AsInteger;
  ARow:=             varColIndex.AsInteger;

  D2BridgeForm.DoCellButtonClick(APrismStringGrid, APrismCellButton, AColIndex, ARow);
 except
 end;
end;


{$IFNDEF FMX}
procedure TPrismForm.Exec_DoDBCellButtonClick(varDBGrid, varPrismCellButton, varColIndex, varRow: TValue);
var
 APrismDBGrid:     TPrismDBGrid;
 APrismCellButton: TPrismGridColumnButton;
 AColIndex:        Integer;
 ARow:             Integer;
begin
 try
  APrismDBGrid:=     TPrismDBGrid(varDBGrid.AsObject);
  APrismCellButton:= TPrismGridColumnButton(varPrismCellButton.AsObject);
  AColIndex:=        varColIndex.AsInteger;
  ARow:=             varRow.AsInteger;

  D2BridgeForm.DoCellButtonClick(APrismDBGrid, APrismCellButton, AColIndex, ARow);
 except
 end;
end;
{$ENDIF}

procedure TPrismForm.Exec_ShowPopup(varPopupName: TValue);
var
 AName: String;
begin
 try
  AName:= varPopupName.AsString;
  ShowPopup(AName);
 except
 end;
end;

function TPrismForm.GetComponentsUpdating: Boolean;
begin
// if D2BridgeForm.isNestedContext then
// begin
//  Result:= TPrismForm(D2BridgeForm.D2Bridge.D2BridgeOwner.FrameworkForm).ComponentsUpdating;
// end else
  Result:= FFormComponentsUpdating;
end;

function TPrismForm.GetControls: TList<IPrismControl>;
begin
 Result:= FControls;
end;

function TPrismForm.GetControlsPrefix: String;
begin
 if EnableControlsPrefix then
 Result:= FControlsPrefix
 else
 Result:= '';
end;

function TPrismForm.GetEnableControlsPrefix: Boolean;
begin
 Result:= FD2BridgeForm.D2Bridge.EnableControlsPrefix;
end;

function TPrismForm.GetFocusedControl: IPrismControl;
begin
 Result:= FFocusedControl;
end;

function TPrismForm.GetFormCacheHTMLText: string;
begin
 Result:= FFormCacheHTMLText;
end;

function TPrismForm.GetFormHTMLText: string;
begin
 Result:= FFormHTMLText;
end;

function TPrismForm.GetFormPageState: TPrismPageState;
begin
 Result:= FFormPageState;
end;

function TPrismForm.GetFormUUID: string;
begin
 Result:= FFormUUID;
end;

function TPrismForm.GetHeadHTMLPrism: string;
begin
 Result:= FHeadHTMLPrism;
end;

function TPrismForm.GetLanguage: String;
begin
 Result:= D2BridgeManager.Prism.Options.Language;
end;

function TPrismForm.GetName: String;
begin
 Result:= FName;

 if Result = '' then
 begin
  if D2BridgeForm <> nil then
   Result:= D2BridgeForm.Name;
 end;
end;


function TPrismForm.GetOnClosePopup: TOnPopup;
begin
 Result:= FOnClosePopup;
end;

function TPrismForm.GetOnShowPopup: TOnPopup;
begin
 Result:= FOnShowPopup;
end;

function TPrismForm.GetOnUpload: TOnUpload;
begin
 result:= FOnUpload;
end;

function TPrismForm.GetServerControlsUpdating: boolean;
begin
 result:= FServerControlsUpdating;
end;

function TPrismForm.GetSession: IPrismSession;
begin
 Result:= FPrismSession;
end;

function TPrismForm.GetTemplateMasterHTMLFile: string;
begin
 Result:= FTemplateMasterHTMLFile;
end;

function TPrismForm.GetTemplatePageHTMLFile: string;
begin
 Result:= FTemplatePageHTMLFile;
end;

procedure TPrismForm.Initialize;
var I: Integer;
    vHTMLControl: String;
begin
 for I := 0 to Controls.Count-1 do
 begin
  try
   Controls[I].Initialize;

   Controls[I].ProcessHTML;

   //Call Event
   vHTMLControl:= Controls[I].HTMLControl;
   (Controls[I].Form as TPrismForm).D2BridgeForm.DoRenderPrismControl(Controls[I] as TPrismControl, vHTMLControl);
   Controls[I].HTMLControl:= vHTMLControl;
  except
  end;
 end;
end;

procedure TPrismForm.OnAfterPageLoad(EventParams: TStrings);
var
 I: Integer;
begin
 FTimerObserver.Resume;
 FFormPageState:= PageStateLoaded;

 Session.DoFormPageLoad(self, EventParams);

 if Assigned(FOnPageLoaded) then
  FOnPageLoaded(Self);

// Session.ExecThread(true,
//  procedure
//  begin
   D2BridgeForm.DoPageLoaded;
//  end
// );


 for I := 0 to Pred(Controls.Count) do
 begin
  try
   Controls[I].DoFormLoadComplete;
  except
  end;
 end;

end;

procedure TPrismForm.OnBeforePageLoad;
begin
 FTimerObserver.Pause;
 FFormPageState:= PageStateLoading;
end;

procedure TPrismForm.onComponentsUpdated;
begin
 FFormComponentsUpdating:= false;
end;

procedure TPrismForm.onComponentsUpdating;
begin
 FFormComponentsUpdating:= true;
end;

procedure TPrismForm.onFormUnload;
var
 I: Integer;
begin
 FTimerObserver.Pause;
 FFormPageState:= PageStateUnloaded;

 for I := 0 to Controls.Count-1 do
 begin
  try
   Controls[I].DoFormUnLoad;
  except
  end;
 end;
end;

procedure TPrismForm.OnOrientationChange(EventParams: TStrings);
var
 I: integer;
 vJSONScreenInfo: TJSONObject;
begin
 if Assigned(EventParams) then
 begin
  try
   vJSONScreenInfo:= TJSONObject.ParseJSONValue(EventParams.Text) as TJSONObject;

   if SameText(vJSONScreenInfo.GetValue('orientation', 'landscape'), 'landscape') then
   Session.InfoConnection.Screen.Orientation:= PrismScreenLandscape;

   Session.DoFormOrientationChange(self, EventParams);

   D2BridgeForm.DoOrientationChange;

   for I := 0 to Pred(Controls.Count) do
   begin
    try
     Controls[I].DoFormOrientationChange;
    except
    end;
   end;

   vJSONScreenInfo.Free;
  except
  end;
 end;
end;

procedure TPrismForm.OnPageResize(EventParams: TStrings);
var
 I: integer;
 vJSONScreenInfo: TJSONObject;
 vWidth, vHeight: integer;
begin
 if Assigned(EventParams) then
 begin
  try
   vJSONScreenInfo:= TJSONObject.ParseJSONValue(EventParams.Text) as TJSONObject;

   Session.InfoConnection.Screen.Width:= vJSONScreenInfo.GetValue('width', 0);
   Session.InfoConnection.Screen.Height:= vJSONScreenInfo.GetValue('height', 0);

   Session.DoFormPageResize(self, EventParams);

   D2BridgeForm.DoPageResize;

   for I := 0 to Pred(Controls.Count) do
   begin
    try
     Controls[I].DoFormResize;
    except
    end;
   end;

   vJSONScreenInfo.Free;
  except
  end;
 end;
end;

procedure TPrismForm.OnTimerObserver;
begin
 try
  FTimerObserver.Pause;

  if (Destroying) then
   exit;

  if (Session.Closing) or (Session.Destroying) then
   exit;

  if (not FFormComponentsUpdating) and (Session.Active) then
  begin
   UpdateServerControls;
  end;

  if (FFormPageState = PageStateLoaded) and
     (not Session.Closing) and (not Session.Destroying) and
     (not Destroying) then
   FTimerObserver.Resume;
 except
 end;
end;

function TPrismForm.PrismOptions: IPrismOptions;
begin
 Result:= PrismBaseClass.Options;
end;

function TPrismForm.ProcessAllTagHTML(HTMLText: String): string;
var
 vHTMLText: string;
begin
 vHTMLText:= HTMLText;

 ProcessTagHTML(vHTMLText);
 ProcessTagTranslate(vHTMLText);
 ProcessCallBackTagHTML(vHTMLText);

 Result:= vHTMLText;
end;

procedure TPrismForm.ProcessCallBackTagHTML(var HTMLText: String);
var
 I: Integer;
 vCallBacks: TList<IPrismCallBack>;
begin
 vCallBacks:= Session.CallBacks.GetCallBacks(self);

 try
  for I := 0 to Pred(vCallBacks.Count) do
  begin
   HTMLText:= StringReplace(HTMLText, '{{'+vCallBacks[I].Name+'}}', Session.CallBacks.CallBackJS(vCallBacks[I].Name, true, FormUUID, '', true), [rfReplaceAll, rfIgnoreCase]);
  end;
 finally
  vCallBacks.Free;
 end;

 for I := 0 to Pred(FSimpleCallBacks.Count) do
 begin
  HTMLText:= StringReplace(HTMLText, '{{'+FSimpleCallBacks.Items[I].Referente+'}}', Session.CallBacks.CallBackJS(FSimpleCallBacks.Items[I].Name, true, FormUUID, QuotedStr(FSimpleCallBacks.Items[I].Parameters), true), [rfReplaceAll, rfIgnoreCase]);
 end;
end;

procedure TPrismForm.ProcessControlsToHTML(var HTMLText: String);
var
 I, PosInit, PosEnd: Integer;
 vTemplateElement, vHTMLEment, vPrismHTMLControl: string;
 vIsTemplateHTMLElement: Boolean;
begin
 for I:= 0 to Controls.Count-1 do
 begin
//  var vUnformatedHTMLControl := Controls[I].UnformatedHTMLControl;
//  var vHTMLControl:= Controls[I].HTMLControl;

  if (Controls[I].HTMLControl <> '') and (Controls[I].UnformatedHTMLControl <> '') then
  begin
   vTemplateElement:= '';

   if ((TemplateMasterHTMLFile = '') and (TemplatePageHTMLFile = '')) or
      (AnsiPos(Controls[I].UnformatedHTMLControl, HTMLText) > 0) then //No template defined or no TAG in template
    HTMLText:= StringReplace(HTMLText, Controls[I].UnformatedHTMLControl, Controls[I].HTMLControl, [rfReplaceAll, rfIgnoreCase])
   else
   begin
    //Adjuste HTML control to Template
    if (AnsiPos('{%'+AnsiUpperCase(Controls[I].NamePrefix)+'%}', AnsiUpperCase(HTMLText)) > 0) then
    begin
     vTemplateElement:= '{%'+Controls[I].NamePrefix+'%}';

     //vHTMLEment:= ' id="'+AnsiUpperCase(Controls[I].NamePrefix)+'" ';
     vHTMLEment:= Controls[I].HTMLCore;

     vIsTemplateHTMLElement:= false;
    end else
    if AnsiPos('{%'+AnsiUpperCase(Controls[I].NamePrefix)+' ', AnsiUpperCase(HTMLText)) > 0 then
    begin
     PosInit := Pos('{%'+AnsiUpperCase(Controls[I].NamePrefix)+' ', AnsiUpperCase(HTMLText));
     PosEnd := Pos('%}', Copy(AnsiUpperCase(HTMLText), PosInit-1, MaxInt));

     vTemplateElement:= Copy(HTMLText, PosInit, PosEnd);

     vHTMLEment:=
       Copy(vTemplateElement,
            Length('{%'+Controls[I].NamePrefix+' '),
            PosEnd-Length('{%'+Controls[I].NamePrefix+' ')-1) +
            ' id="'+AnsiUpperCase(Controls[I].NamePrefix)+'"';

     if not Controls[I].Visible then
      if POS('invisible', vHTMLEment) <= 0 then
       vHTMLEment:= StringReplace(vHTMLEment, 'class="', 'class="invisible ', [rfIgnoreCase]);

     if not Controls[I].Enabled then
      if POS('disabled', vHTMLEment) <= 0 then
       vHTMLEment:= StringReplace(vHTMLEment, 'class="', 'class="disabled ', [rfIgnoreCase]);

     vIsTemplateHTMLElement:= true;
    end;

    if vTemplateElement <> '' then
    begin
     vPrismHTMLControl:=
        StringReplace
        (
          Controls[I].HTMLControl,
          Controls[I].HTMLCore,
          vHTMLEment,
          [rfIgnoreCase]
        );

     HTMLText:= StringReplace(HTMLText, vTemplateElement, vPrismHTMLControl, [rfIgnoreCase]);

     if vIsTemplateHTMLElement then
      Controls[I].HTMLCore:= vHTMLEment;

     Controls[I].TemplateControl:= true;
     D2BridgeForm.D2Bridge.HTML.Render.RemoveHTMLControlToBody(Controls[I].Name);
    end;
   end;

   //HTMLText:= StringReplace(HTMLText, 'id="'+AnsiUpperCase(Controls[I].Name)+'"', 'id="'+AnsiUpperCase(Controls[I].NamePrefix)+'"', [rfIgnoreCase, rfReplaceAll]);
  end;
 end;
end;


procedure TPrismForm.ProcessNested(var HTMLText: String);
var
 I, J: Integer;
 BaseClass, vNestedBaseClass: TD2BridgeClass;
begin
 //BaseClass:= TD2BridgeClass(Session.D2BridgeBaseClassActive);
 BaseClass:= FD2BridgeForm.D2Bridge;

 for I := 0 to BaseClass.NestedCount-1 do
 begin
  vNestedBaseClass:= BaseClass.Nested(I);

  HTMLText:= StringReplace(HTMLText, '$prismnested('+AnsiUpperCase(TD2BridgeForm(vNestedBaseClass.FormAOwner).NestedName)+')', vNestedBaseClass.HTML.Render.Body.Text, [rfIgnoreCase, rfReplaceAll]);

  for J := 0 to Pred(vNestedBaseClass.NestedCount) do
  begin
   (vNestedBaseClass.FrameworkForm as TPrismForm).ProcessNested(HTMLText);
  end;
 end;

end;

procedure TPrismForm.ProcessPopup(var HTMLText: String);
var
 I: Integer;
 BaseClass: TD2BridgeClass;
begin
 //BaseClass:= TD2BridgeClass(Session.D2BridgeBaseClassActive);
 BaseClass:= FD2BridgeForm.D2Bridge;

 for I := 0 to BaseClass.PopupCount-1 do
 begin
  HTMLText:= StringReplace(HTMLText, '$prismpopup('+AnsiUpperCase(BaseClass.Popup(I).ItemID)+')', TD2BridgeClass(BaseClass).HTML.Render.GetHTMLControls(BaseClass.Popup(I).ItemID).HTMLText, [rfIgnoreCase, rfReplaceAll]);
 end;

end;

procedure TPrismForm.ProcessTagHTML(var HTMLText: String);
var
{$IFDEF HAS_UNIT_REGULAREXPRESSIONSAPI}
  Regex: TRegEx;
  Match: TMatch;
{$ELSE}
  Regex: TRegExpr;
{$ENDIF}
  StartPos: Integer;
  TagString, TagStringJust, ReplaceTag: string;
  vNewCallBackName, vNewCallBackParameters: String;
  vIsSimpleCallBack, vIsStaticCallBack: Boolean;
  I: Integer;
  vSimpleCallBack: TSimpleCallBack;
begin
  // Crie uma expressão regular para encontrar todas as ocorrências de {{Texto}}
{$IFDEF HAS_UNIT_REGULAREXPRESSIONSAPI}
  Regex := TRegEx.Create('{{(?!_).*?}}', [roIgnoreCase, roMultiLine]);
{$ELSE}
  Regex := TRegExpr.Create('\{\{.*?\}\}');
{$ENDIF}

  // Inicialize as variáveis
  StartPos := 1;

  // Comece a percorrer o HTMLText
  while StartPos <= Length(HTMLText) do
  begin
   try
{$IFDEF HAS_UNIT_REGULAREXPRESSIONSAPI}
    // Encontre a próxima correspondência
    Match := Regex.Match(HTMLText, StartPos);

    // Se não houver correspondência, saia do loop
    if not Match.Success then
      Break;
{$ELSE}
    // Encontre a próxima correspondência, Se não houver correspondência, saia do loop
    if not Regex.Exec(HTMLText.Substring(StartPos)) then
      Break;

   {$IFDEF FPC}
    if Regex.Match[0].StartsWith('{{_') and Regex.Match[0].EndsWith('_}}') then
    begin
     StartPos := Regex.MatchPos[0] + Regex.MatchLen[0] + StartPos;
     continue;
    end;
   {$ENDIF}
{$ENDIF}



    //Not is Simple CallBack
    vIsSimpleCallBack:= false;
    vIsStaticCallBack:= false;

    // Obtenha a correspondência e o texto entre {{ e }}
    TagString := {$IFDEF HAS_UNIT_REGULAREXPRESSIONSAPI}Match.Value{$ELSE}Regex.Match[0]{$ENDIF};
    TagStringJust:= Copy(TagString, 3, length(TagString)-4);
    ReplaceTag := {$IFDEF HAS_UNIT_REGULAREXPRESSIONSAPI}Match.Value{$ELSE}Regex.Match[0]{$ENDIF};//Match.Groups[1].Value;



    //Static CallBacks
    if (SameText(TagString, 'CallBackClose')) or (SameText(TagString, 'CallBackCloseSession')) or (SameText(TagString, 'CallBackHome')) then
     vIsStaticCallBack:= true;



    //Insert Simple CallBack
    if not vIsStaticCallBack then
    if AnsiPos(AnsiUpperCase('CallBack='),AnsiUpperCase(TagStringJust)) = 1 then
    begin
     vNewCallBackParameters:= '';

     if AnsiPos('(',TagStringJust) > 0 then
      vNewCallBackName:= Trim(Copy(TagStringJust, Length('CallBack=') + 1, AnsiPos('(',TagStringJust) - Length('CallBack=') - 1))
     else
      vNewCallBackName:= Trim(Copy(TagStringJust, Length('CallBack=')+1));


     if (AnsiPos('(',TagStringJust) > 0) and (AnsiPos(')',TagStringJust) > 0) then
     begin
      for I := Length(TagStringJust) downto 9 do
       if TagStringJust[I] = ')' then
       begin
        vNewCallBackParameters:= copy(TagStringJust, AnsiPos('(',TagStringJust) + 1, I - AnsiPos('(',TagStringJust) - 1);
        break;
       end;
     end;

     CallBacks.Register(vNewCallBackName);
     vIsSimpleCallBack:= true;

     vSimpleCallBack.Referente:= TagStringJust;
     vSimpleCallBack.Name:= vNewCallBackName;
     vSimpleCallBack.Parameters:= vNewCallBackParameters;
     FSimpleCallBacks.Add(vSimpleCallBack);
    end;


    // Chame o evento OnHTMLTag
    if not vIsStaticCallBack then
    if not vIsSimpleCallBack then
    begin
     try
      DoTagHTML(TagStringJust, ReplaceTag);
     except
     end;
    end;


    if not vIsStaticCallBack then
    if not vIsSimpleCallBack then
    if (SameText(TagString, '{{Title}}')) and
       (TagString = ReplaceTag) then
     ReplaceTag := TD2BridgeForm(TD2BridgeClass(Session.D2BridgeBaseClassActive).FormAOwner).Title;


    if not vIsStaticCallBack then
    if not vIsSimpleCallBack then
    if (SameText(TagString, '{{SubTitle}}')) and
       (TagString = ReplaceTag) then
     ReplaceTag := TD2BridgeForm(TD2BridgeClass(Session.D2BridgeBaseClassActive).FormAOwner).SubTitle;


    if not vIsStaticCallBack then
    if not vIsSimpleCallBack then
    if (SameText(TagString, '{{Lang}}')) and
       (TagString = ReplaceTag) then
     ReplaceTag := Language;


{$IFDEF HAS_UNIT_REGULAREXPRESSIONSAPI}
    // Substitua a correspondência pelo resultado do evento
    HTMLText := HTMLText.Remove(Match.Index-1, Match.Length).Insert(Match.Index-1, ReplaceTag);

    // Atualize a posição de início
    StartPos := Match.Index -1 + Length(ReplaceTag);
{$ELSE}
    // Substitua a correspondência pelo resultado do evento
    HTMLText := HTMLText.Remove(Regex.MatchPos[0]{$IFDEF FPC} + StartPos - 1{$ENDIF}, Regex.MatchLen[0]).Insert(Regex.MatchPos[0]{$IFDEF FPC} + StartPos - 1{$ENDIF}, ReplaceTag);

    // Atualize a posição de início
    StartPos := Regex.MatchPos[0] + Length(ReplaceTag){$IFDEF FPC} + StartPos{$ENDIF};
{$ENDIF}
   except
    Inc(StartPos);
   end;
  end;
end;

procedure TPrismForm.ProcessTags(var HTMLText: String);
var
 I: Integer;
 BaseClass: TD2BridgeClass;
begin
 BaseClass:= TD2BridgeClass(Session.D2BridgeBaseClassActive);

 for I := 0 to Pred(BaseClass.HTML.Render.CountHTMLControls) do
 begin
  HTMLText:= StringReplace(HTMLText, '$prismtag('+BaseClass.HTML.Render.GetHTMLControlsName(I)+')', BaseClass.HTML.Render.GetHTMLControls(I).HTMLText, [rfIgnoreCase, rfReplaceAll]);
 end;

end;

procedure TPrismForm.ProcessTagTranslate(var HTMLText: String);
var
{$IFDEF HAS_UNIT_REGULAREXPRESSIONSAPI}
  Regex: TRegEx;
  Match: TMatch;
{$ELSE}
  Regex: TRegExpr;
{$ENDIF}
  StartPos, EndPos: Integer;
  AContext, TagString, TagStringJust, ATerm, ATranslated: string;
begin
 // Crie uma expressão regular para encontrar todas as ocorrências de {{_Texto_}}
{$IFDEF HAS_UNIT_REGULAREXPRESSIONSAPI}
  Regex := TRegEx.Create('{{_.*?(\.\w+)?_}}', [roIgnoreCase, roMultiLine]);
{$ELSE}
  Regex := TRegExpr.Create('\{\{_.*?(\.\w+)?_\}\}');
{$ENDIF}

 // Inicialize as variáveis
 StartPos := 1;
 EndPos := Length(HTMLText);

 // Comece a percorrer o HTMLText
 while StartPos <= EndPos do
 begin
{$IFDEF HAS_UNIT_REGULAREXPRESSIONSAPI}
  // Encontre a próxima correspondência
  Match := Regex.Match(HTMLText, StartPos);
  ATranslated:= '';

  // Se não houver correspondência, saia do loop
  if not Match.Success then
   Break;
{$ELSE}
  // Encontre a próxima correspondência, Se não houver correspondência, saia do loop
  ATranslated:= '';

  if not Regex.Exec(HTMLText.Substring(StartPos)) then
   Break;
{$ENDIF}

  // Obtenha a correspondência e o texto entre {{ e }}
  TagString := {$IFDEF HAS_UNIT_REGULAREXPRESSIONSAPI}Match.Value{$ELSE}Regex.Match[0]{$ENDIF};
  TagStringJust:= Copy(TagString, 4, length(TagString)-6);

  //Pega o Term
  if AnsiPos(',',TagStringJust) > 0 then
  begin
   AContext:= Copy(TagStringJust, 1, AnsiPos(',',TagStringJust)-1);
   ATerm:= Copy(TagStringJust, AnsiPos(',',TagStringJust) +1);
  end else
  begin
   AContext:= '';
   ATerm:= TagStringJust;
  end;

  DoTagTranslate(Session.Language, AContext, ATerm, ATranslated);

{$IFDEF HAS_UNIT_REGULAREXPRESSIONSAPI}
  if ATranslated <> '' then
   HTMLText := HTMLText.Remove(Match.Index-1, Match.Length).Insert(Match.Index-1, ATranslated)
  else
   ATranslated := Match.Value;

  // Atualize a posição de início
  StartPos := Match.Index -1 + Length(ATranslated);
{$ELSE}
  if ATranslated <> '' then
   HTMLText := HTMLText.Remove(Regex.MatchPos[0]{$IFDEF FPC} + StartPos -1{$ENDIF}, Regex.MatchLen[0]).Insert(Regex.MatchPos[0]{$IFDEF FPC} + StartPos -1{$ENDIF}, ATranslated)
  else
   ATranslated := Regex.Match[0];

  // Atualize a posição de início
  StartPos := Regex.MatchPos[0] + Length(ATranslated){$IFDEF FPC} + StartPos{$ENDIF};
{$ENDIF}
 end;
end;

procedure TPrismForm.SetFocusedControl(APrismControl: IPrismControl);
begin
 if Assigned(FocusedControl) then
 if Assigned(FocusedControl.Events.Item(EventOnExit)) then
 begin
  FocusedControl.Events.Item(EventOnExit).CallEvent(nil);
 end;

 if Assigned(APrismControl) then
 begin
  if Assigned(APrismControl.Events.Item(EventOnEnter)) then
  APrismControl.Events.Item(EventOnEnter).CallEvent(nil);

  FFocusedControl:= APrismControl;
 end;
end;

procedure TPrismForm.SetFormCacheHTMLText(AHTMLText: string);
begin
 FFormCacheHTMLText:= AHTMLText;
end;

procedure TPrismForm.SetFormHTMLText(AHTMLText: string);
begin
 FFormHTMLText:= AHTMLText;
end;

procedure TPrismForm.SetFormPageState(Value: TPrismPageState);
begin
 FFormPageState:= Value;
end;

procedure TPrismForm.SetHeadHTMLPrism(AHTMLText: string);
begin
 FHeadHTMLPrism:= AHTMLText;
end;

procedure TPrismForm.SetName(AName: String);
begin
 FName:= AName;
end;


procedure TPrismForm.SetOnClosePopup(AOnPopupEvent: TOnPopup);
begin
 FOnClosePopup:= AOnPopupEvent;
end;

procedure TPrismForm.SetOnShowPopup(AOnPopupEvent: TOnPopup);
begin
 FOnShowPopup:= AOnPopupEvent;
end;

procedure TPrismForm.SetOnUpload(const Value: TOnUpload);
begin
 FOnUpload:= Value;
end;

procedure TPrismForm.SetSession(ASession: IPrismSession);
begin
 FPrismSession:= (ASession as TPrismSession)
end;

procedure TPrismForm.SetTemplateMasterHTMLFile(AFileMasterTemplate: string);
begin
 FTemplateMasterHTMLFile:= AFileMasterTemplate;
end;

procedure TPrismForm.SetTemplatePageHTMLFile(AFilePageTemplate: string);
begin
 FTemplatePageHTMLFile:= AFilePageTemplate;
end;

procedure TPrismForm.Show;
begin
 Session.DoHeartBeat;

 TPrismBaseClass(PrismBaseClass).PrismServerHTMLHeaders.ReloadPage(Session);

 D2BridgeForm.DoShow;

 if D2BridgeForm.ShowingModal then
 begin
  Session.Lock(FormUUID+'_showmodal');
  if (Destroying) or
     (Session.Destroying or Session.Closing) or
     ((D2BridgeForm = nil) or (csDestroying in D2BridgeForm.ComponentState)) then
  Abort;
 end;
end;



procedure TPrismForm.ShowPopup(AName: String);
begin
  Session.ExecThread(true,
   Exec_ShowPopup,
   TValue.From<String>(AName)
  );
end;

procedure TPrismForm.TagHTML(const TagString: string; var ReplaceTag: string);
begin

end;

procedure TPrismForm.UpdateControls;
begin
 FForceUpdateControls:= true;
end;

procedure TPrismForm.UpdateServerControls;
var
 I: Integer;
 _ProcessControlScriptJS: String;
 ItemScriptJS, ScriptJS: TStrings;
 vForceUpdateAllControls: Boolean;
 vTextHTML: string;
begin
 if (Session.Active) then
 begin
  try
   FServerControlsUpdating:= true;
   try
    vForceUpdateAllControls:= FForceUpdateControls;
    FForceUpdateControls:= false;

    DoBeginUpdateD2BridgeControls;

    ScriptJS:= TStringList.Create;
    ScriptJS.LineBreak:= ' ';

    for I := 0 to Controls.Count-1 do
    begin
     if FFormComponentsUpdating or
        (Session.Destroying) or
        (Destroying) or
        (Session.Closing) then
      break;

     try
      if (Assigned(Controls[I].Form) and ((Controls[I].Form as TPrismForm) <> self)) or (not Controls[I].Updatable) then
      begin
       Continue; //Nested
      end;

      ItemScriptJS:= TStringList.Create;
      ItemScriptJS.LineBreak:= ' ';

      try
       if Controls[I].RefreshControl then
        Controls[I].UpdateServerControls(ItemScriptJS, Controls[I].RefreshControl)
       else
        Controls[I].UpdateServerControls(ItemScriptJS, vForceUpdateAllControls);

       if ItemScriptJS.Count > 0 then
       begin
        ScriptJS.Add('if (document.querySelector("[id='+UpperCase(Controls[I].NamePrefix)+' i]") !== null) {');
        ScriptJS.Add('try {');
        ScriptJS.Add(ItemScriptJS.Text);
        ScriptJS.Add('} catch (error) {');
        ScriptJS.Add('}');
        ScriptJS.Add('}');
       end;
      except
      end;

      ItemScriptJS.Free;
     except
      on E: Exception do
       Session.DoException(self as TObject, E, 'PrismFormUpdateControls');
     end;
    end;

    if ScriptJS.Text <> '' then
    if not FFormComponentsUpdating then
    begin
     //Update Translation TAG
     ScriptJS.Text:=
      'requestAnimationFrame(() => { ' +
      ScriptJS.Text +
      '});';
     vTextHTML:= ScriptJS.Text;
     ProcessTagHTML(vTextHTML);
     ProcessTagTranslate(vTextHTML);
     Session.ExecJS(vTextHTML);
    end;
   except
   end;
  finally
   FServerControlsUpdating:= false;
   if Assigned(ScriptJS) then
    ScriptJS.Free;

   if (not Session.Destroying) and
      (not Destroying) and
      (not (Session.Closing)) then
    DoEndUpdateD2BridgeControls;
  end;
 end;
end;

end.