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

unit D2Bridge.Forms;

interface

uses
  Classes, SysUtils, TypInfo, RTTI, SyncObjs, Variants, DateUtils, Generics.Collections,
  {$IFNDEF FMX}
  DBCtrls, Dialogs, ExtCtrls, StdCtrls, Clipbrd, Controls, Forms, Graphics, ComCtrls,
  {$ELSE}
  FMX.Dialogs, FMX.ExtCtrls, FMX.StdCtrls, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Memo, FMX.ListBox, FMX.ComboEdit, FMX.Edit, FMX.Types, FMX.Objects,
  {$ENDIF}
  {$IFDEF HAS_UNIT_SYSTEM_THREADING}
  System.Threading,
  {$ENDIF}
  {$IFDEF HAS_UNIT_SYSTEM_UITYPES}
  System.UITypes,
  {$ENDIF}
  DB,
  {$IFNDEF FPC}

  {$ELSE}

  {$ENDIF}
  {$IFDEF MSWINDOWS}
  Windows, Messages,
  {$ENDIF}
  D2Bridge, D2Bridge.Instance, D2Bridge.Interfaces, D2Bridge.HTML.CSS, D2Bridge.ItemCommon,
  D2Bridge.Prism.Button, D2Bridge.Types, D2Bridge.Forms.Helper, D2Bridge.Camera.Image, D2Bridge.QRCodeReader.Image,
  Prism.Interfaces, Prism.Session, Prism.Types, Prism.Forms.Controls,
  Prism.StringGrid, Prism.Card.Grid.DataModel, Prism.Card.Model,
  {$IFNDEF FMX}
  Prism.DBGrid,
  {$ENDIF}
  Prism.CSS.Bootstrap.Button, Prism.Clipboard, Prism.Text.Mask;

type
 TPrismControl = Prism.Forms.Controls.TPrismControl;
 TPrismStringGrid = Prism.StringGrid.TPrismStringGrid;
 {$IFNDEF FMX}
 TPrismDBGrid = Prism.DBGrid.TPrismDBGrid;
 TPrismDBGridColumnButton = Prism.DBGrid.TPrismGridColumnButton;
 {$ENDIF}
 TPrismGridColumnButton = Prism.StringGrid.TPrismGridColumnButton;
 TD2BridgeInstance = D2Bridge.Instance.TD2BridgeInstance;
 TPrismFieldType = Prism.Types.TPrismFieldType;
 TPrismFieldModel = Prism.Types.TPrismFieldModel;
 TButtonModel = Prism.CSS.Bootstrap.Button.TButtonModelClass;
 TD2BridgeLang = D2Bridge.Types.TD2BridgeLang;
 TPrismTextMask = Prism.Text.Mask.TPrismTextMask;
 TD2BridgeCardImagePosition = D2Bridge.Types.TD2BridgeCardImagePosition;
 TToastPosition = D2Bridge.Types.TToastPosition;
 TPrismEventType = Prism.Types.TPrismEventType;
 {$IFNDEF FMX}
 TPrismCardGridDataModel = Prism.Card.Grid.DataModel.TPrismCardGridDataModel;
 {$ENDIF}
 TPrismAlignment = Prism.Types.TPrismAlignment;
 IPrismCardModel = Prism.Interfaces.IPrismCardModel;
 IPrismKanban = Prism.Interfaces.IPrismKanban;
 IPrismKanbanColumn = Prism.Interfaces.IPrismKanbanColumn;


{$REGION 'Helpers'}
{$IFDEF D2BRIDGE}
{$IFNDEF FMX}
 type
  TApplicationHelper = class helper for TApplication
   public
    function MessageBox(const Text, Caption: PChar; Flags: Longint): Integer;
  end;
{$ENDIF}

 {$IFNDEF FMX}
 type
  TTabSheetHelper = class helper for TTabSheet
   private
    procedure SetTabVisible(Value: Boolean);
    function GetTableVisible: Boolean;
   public
    property TabVisible: Boolean read GetTableVisible write SetTabVisible default True;
  end;
 {$ENDIF}

{$IFnDEF FPC}
 type
  THelperMemo = class helper for TMemo
   private
    function GetHelperLines: TStrings;
    procedure SetHelperLines(const Value: TStrings);
    function GetHelperText: String;
    procedure SetHelperText(const Value: String);
    procedure CheckInstanceHelper;
   public
    procedure InstanceHelper;
    procedure Clear;
    property Lines: TStrings read GetHelperLines write SetHelperLines;
    property Text: String read GetHelperText write SetHelperText;
  end;
{$ENDIF}

// type
//  TInterceptedCombobox = class(TComponent)
//   public
//    Items: TStrings;
//    ItemIndex: Integer;
//    Text: String;
//    constructor Create(AOwner: TComponent); override;
//    destructor Destroy; override;
//  end;

{$IFnDEF FPC}
 type
   THelperCombobox = class helper for {$IF DEFINED(FMX) OR DEFINED(FPC)}TCustomComboBox{$ELSE}TCustomCombo{$IFEND}
  private
   //function InterceptedCombobox: TInterceptedCombobox;
   function GetHelperItems: TStrings;
   procedure SetHelperItems(AItems: TStrings);
   function GetItemIndex: integer;
   Procedure SetItemIndex(Val: Integer);
   function GetText: String;
   procedure SetText(AText: String);
   procedure CheckInstanceHelper;
  public
   procedure Clear;
   procedure InstanceHelper;
  published
   property Items: TStrings read GetHelperItems write SetHelperItems;
   property ItemIndex: Integer read GetItemIndex write SetItemIndex;
   property Text: string read GetText write SetText;
  end;
{$ENDIF}

{$IFnDEF FMX}
{$IFnDEF FPC}
 type
   THelperRadioGroup = class helper for TCustomRadioGroup
  private
   //function InterceptedCombobox: TInterceptedCombobox;
   function GetHelperItems: TStrings;
   procedure SetHelperItems(AItems: TStrings);
   function GetItemIndex: integer;
   Procedure SetItemIndex(Val: Integer);
   function GetText: String;
   procedure SetText(AText: String);
   procedure CheckInstanceHelper;
    function GetCaption: string;
    procedure SetCaption(const Value: string);
  public
   procedure Clear;
   procedure InstanceHelper;
  published
   property Items: TStrings read GetHelperItems write SetHelperItems;
   property ItemIndex: Integer read GetItemIndex write SetItemIndex;
   property Text: string read GetText write SetText;
   property Caption: string read GetCaption write SetCaption;
  end;
{$ENDIF}
{$ENDIF}


 {$IFDEF VCL}
 type
  TWinControlHelper = class(Controls.TWinControl)
   private

   public
    Procedure ClearHandle;
  end;
 {$ENDIF}

{$IFDEF FMX}
 type
   THelperComboEdit = class helper for TCustomComboEdit
  private
   //function InterceptedCombobox: TInterceptedCombobox;
   function GetHelperItems: TStrings;
   procedure SetHelperItems(AItems: TStrings);
   function GetItemIndex: Integer;
   Procedure SetItemIndex(AItemIndexValue: Integer);
   function GetText: String;
   procedure SetText(AText: String);
  public
   procedure Clear;
   //Procedure CreateInterceptedCombobox;
  published
   property Items: TStrings read GetHelperItems write SetHelperItems;
   property ItemIndex: Integer read GetItemIndex write SetItemIndex;
   property Text: string read GetText write SetText;
  end;
{$ENDIF}

 type
  TD2BridgeHelperCustomEdit = class helper for TCustomEdit
   private

   public
    procedure Clear;
 end;

// type
//  TD2BridgeHelperField = class helper for TField
//   public
//    procedure FocusControl;
//  end;


 type
  TD2BridgeHelperWinControl = class helper for {$IFNDEF FMX}TWinControl{$ELSE}TControl{$ENDIF}
   private

   public
    //procedure SelectAll;
    procedure SetFocus;
   protected

   published

  end;


 type
  TD2BridgeThreadTimer = class(TThread)
  private
    fsOnTimer: TNotifyEvent;
    fsEnabled: Boolean;
    fsInterval: Integer;
    fsEvent: TSimpleEvent;
    procedure SetEnabled(const AValue: Boolean);
    procedure SetInterval(const AValue: Integer);
  protected
    procedure DoCallEvent;
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;

    property OnTimer: TNotifyEvent read fsOnTimer write fsOnTimer;
    property Interval: Integer read fsInterval write SetInterval;
    property Enabled: Boolean read fsEnabled write SetEnabled;
  end;

  TTimer = class({$IFNDEF FMX}ExtCtrls.TTimer{$ELSE}FMX.Types.TTimer{$ENDIF})
  strict private
   procedure Exec_Timer;
  private
{$IFDEF FPC}
    FD2BridgeThreadTimer: TD2BridgeThreadTimer;
{$ENDIF}
    FPrismSession: TPrismSession;
    FD2BridgeForm: TObject;
    FThreadID: Integer;
    function GetFormOfComponent(AComponent: TComponent): TForm;
{$IFDEF FPC}
  protected
    procedure SetEnabled(Value: Boolean); override;
    procedure SetInterval(Value: Cardinal); override;
    procedure Loaded; override;
    procedure TimerD2BridgeThread(Sender: TObject);
{$ENDIF}
   public
    constructor Create(AOwner: TComponent); override;
    procedure {$IF DEFINED(FMX) OR DEFINED(FPC)}DoOnTimer{$ELSE}Timer{$IFEND}; override;
  end;
{$ENDIF}

  TImageHelper = class helper for TImage
   private

   public
    procedure NewCameraInstance;
    procedure NewQRCodeReaderInstance;
    function Camera: TD2BridgeCameraImage;
    function QRCodeReader: TD2BridgeQRCodeReaderImage;
  end;

// type
//  TD2BridgeHelperEdit = class helper for TCustomEdit
//   private
//
//   public
//    //procedure SelectAll;
//    procedure SetFocus;
//   protected
//
//   published
//
//  end;
{$ENDREGION}

type
  TD2BridgeFormClass = class of TD2BridgeForm;

  TD2BridgeForm = class(TForm)
  strict private
{$IFDEF D2BRIDGE}
   function CallBackClose(EventParams: TStrings): string;
   function CallBackCloseSession(EventParams: TStrings): string;
   function CallBackHome(EventParams: TStrings): string;
   procedure Exec_DestroyInstance(varObject: TValue);
   procedure Exec_DoCloseShowmodal;
   procedure Exec_Render;
   procedure Exec_Activate;
   procedure Exec_CreateInstanceFormClass(varD2BridgeFormClass: TValue);
   class procedure Exec_CreateInstance(varPrismSession: TValue);
   procedure Exec_Create(varD2BridgeFormOwner: TValue);
   procedure Exec_CreateFromOwner(varOwner, varPrismSession: TValue);
   procedure Exec_ShowPopupModal(varPopupName: TValue);
   procedure Exec_PopupClosed(varPopupName, varPopup: TValue);
   procedure Exec_DoDestroy;
   procedure Exec_OnDestroy;
{$ENDIF}
   constructor CreateInstance(AOwner: TPrismSession); overload;
  private
{$IFDEF D2BRIDGE}
   FModalResult: integer;
   FActive: boolean;
   FDestroying: Boolean;
{$ENDIF}
   FD2Bridge: TD2Bridge;
   FMessageResponse: Integer;
   FTemplateClassForm: TClass;
   FTitle: String;
   FSubTitle: String;
   FShowing: Boolean;
   FPopupsShowing: TList<string>;
   FOnShowPopup: TOnPopup;
   FOnClosePopup: TonPopup;
   FOnPageLoaded: TNotifyEvent;
   FOnTagHTML: TOnTagHTML;
   FOnUpload: TOnUpload;
   FUsedD2BridgeInstance: Boolean;
   FShowingModal: Boolean;
   FDestroyForm: boolean;
   FPriorD2Bridge: TD2BridgeForm;
   FShowCount: integer;
   FNestedName: string;
   FPopupName: string;
{$IFDEF D2BRIDGE}
   FD2BridgeFormComponentHelperItems: TD2BridgeFormComponentHelperItems;
{$ENDIF}
   function GetLanguage: TD2BridgeLang;
{$IFDEF D2BRIDGE}
   procedure CreateD2BridgeForm;
   procedure RegisterStaticCallBacks;
   procedure UnRegisterStaticCallBacks;
   function GetModalResult: integer;
   procedure SetModalResult(const Value: integer);
  {$IFNDEF FMX}
   procedure DestroyHandle(AControl: TWincontrol);
  {$ENDIF}
{$ENDIF}
   procedure InternalCreate(AOwner: TD2BridgeForm);
   function GetNestedName: string;
   function GetPopupName: string;
   procedure DoClose(var Action: TCloseAction); override;
   function GetSubTitle: String; virtual;
   function GetTitle: String; virtual;
   procedure SetSubTitle(const Value: String); virtual;
   procedure SetTitle(const Value: String); virtual;
   type
    RBUttonTypes = record
     Value: Integer;
     Caption: String;
     Color: String;
    end;
   type
    RAlertTypes = record
     Tipo: string;
     Caption: String;
    end;
  protected
   Procedure ExportD2Bridge; overload; virtual;
   Procedure ExportD2Bridge(D2Bridge: TD2Bridge); overload; virtual;
   procedure InitControlsD2Bridge(const PrismControl: TPrismControl); virtual;
   procedure BeginRenderD2Bridge(const PrismControl: TPrismControl); virtual;
   procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); virtual;
   procedure TagHTML(const TagString: string; var ReplaceTag: string); virtual;
   procedure CallBack(const CallBackName: String; EventParams: TStrings); virtual;
   procedure EventD2Bridge(const PrismControl: TPrismControl; const EventType: TPrismEventType; EventParams: TStrings); virtual;
   procedure CellButtonClick(APrismStringGrid: TPrismStringGrid; APrismCellButton: TPrismGridColumnButton; AColIndex: Integer; ARow: Integer); overload; virtual;
{$IFNDEF FMX}
   procedure CellButtonClick(APrismDBGrid: TPrismDBGrid; APrismCellButton: TPrismDBGridColumnButton; AColIndex: Integer; ARow: Integer); overload; virtual;
   procedure CardGridClick(PrismControlClick: TPrismControl; ARow: Integer; APrismCardGrid: TPrismCardGridDataModel); virtual;
{$ENDIF}
   procedure KanbanClick(const AKanbanCard: IPrismCardModel; const PrismControlClick: TPrismControl); virtual;
   procedure PageLoaded; virtual;
   procedure PageResize; virtual;
   procedure OrientationChange; virtual;
   procedure BeginTranslate(const Language: TD2BridgeLang); virtual;
   procedure BeginUpdateD2BridgeControls; virtual;
   procedure UpdateD2BridgeControls(const PrismControl: TPrismControl); virtual;
   procedure EndUpdateD2BridgeControls; virtual;
   procedure BeginTagHTML; virtual;
   procedure EndTagHTML; virtual;
   procedure TagTranslate(const Language: TD2BridgeLang; const AContext, ATerm: string; var ATranslated: string); virtual;
   Procedure SetupD2Bridge; virtual;
   procedure BeginRender; virtual;
   procedure EndRender; virtual;
   procedure ShowPopup(const AName: string; var CanShow: Boolean); overload; virtual;
   procedure ClosePopup(const AName: string; var CanClose: Boolean); overload; virtual;
   procedure PopupClosed(const AName: string); overload; virtual;
   procedure PopupClosed(const AName: string; const ACloseParam: variant); overload; virtual;
   procedure PopupOpened(AName: string); virtual;
   procedure KanbanMoveCard(const AKanbanCard: IPrismCardModel; const IsColumnMoved, IsPositionMoved: boolean); virtual;
  {$IFDEF VCL}
   procedure DoCreate; override;
  {$ENDIF}
   procedure DoHide; override;
  {$IFDEF VCL}
   procedure DoDestroy; override;
  {$ENDIF}
  {$IFDEF VCL}
   procedure Activate; override; //Somente Vcl e somente com inherited;
  {$ENDIF}
{$IFDEF D2BRIDGE}
   procedure DoCloseShowmodal;
   procedure BeforeDestruction; override;
{$ENDIF}
  public
   Function D2BridgeFormComponentHelperItems: TD2BridgeFormComponentHelperItems;
   constructor Create(AOwner: TComponent); overload; override;
   constructor Create(AOwner: TD2BridgeForm); reintroduce; overload;
   constructor Create(AOwner: TPrismSession); reintroduce; overload;
   constructor Create(AOwner: TD2BridgeInstance); reintroduce; overload;
{$IFDEF D2BRIDGE}
   constructor Create(AOwner: TComponent; Session: TPrismSession); reintroduce; overload;
   function Clipboard: TPrismClipboard;
{$ENDIF}
   //constructor CreateInstance; overload;
   function GetTemplateClassForm: TClass;
   procedure Clear;
   procedure Render;
   procedure ShowPopup(AName: String); overload;
   procedure ClosePopup(AName: String); overload;
   procedure ShowPopupModal(AName: String);
   procedure DoShow; override;
   //DO
   procedure DoPopupOpened(AName: string);
   procedure DoPopupClosed(AName: string);
   procedure DoUpload(AFiles: TStrings; Sender: TObject);
   procedure DoBeginRender;
   procedure DoEndRender;
   procedure DoBeginTagHTML;
   procedure DoEndTagHTML;
   procedure DoPageLoaded;
   procedure DoRenderPrismControl(const APrismControl: TPrismControl; var HTMLControl: string);
   procedure DoInitPrismControl(const APrismControl: TPrismControl);
   procedure DoBeginRenderPrismControl(const APrismControl: TPrismControl);
   procedure DoBeginTranslate;
   procedure DoTagHTML(const TagString: string; var ReplaceTag: string);
   procedure DoCallBack(const CallBackName: String; EventParams: TStrings);
   procedure DoBeginUpdateD2BridgeControls;
   procedure DoUpdateD2BridgeControls(const APrismControl: TPrismControl);
   procedure DoEndUpdateD2BridgeControls;
   procedure DoTagTranslate(const Language: TD2BridgeLang; const AContext, ATerm: string; var ATranslated: string);
   procedure DoEventD2Bridge(const PrismControl: TPrismControl; const EventType: TPrismEventType; EventParams: TStrings);
   procedure DoCellButtonClick(APrismStringGrid: IPrismStringGrid; APrismCellButton: IPrismGridColumnButton; AColIndex: Integer; ARow: Integer); overload;
   procedure DoOrientationChange; virtual;
   procedure DoPageResize; virtual;
  {$IFNDEF FMX}
   procedure DoCardGridClick(PrismControlClick: TPrismControl; ARow: Integer; APrismCardGrid: TPrismCardGridDataModel);
  {$ENDIF}
   procedure DoKanbanMoveCard(const AKanbanCard: IPrismCardModel; const IsColumnMoved, IsPositionMoved: boolean);
   procedure DoKanbanClick(const AKanbanCard: IPrismCardModel; const PrismControlClick: TPrismControl);
  {$IFNDEF FMX}
   procedure DoCellButtonClick(APrismDBGrid: IPrismDBGrid; APrismCellButton: IPrismGridColumnButton; AColIndex: Integer; ARow: Integer); overload;
  {$ENDIF}
   procedure Upload(AFiles: TStrings; Sender: TObject); virtual;
   procedure ExportD2BridgeAllControls;
  public
   procedure ShowMessage(const Msg: string; useToast: boolean; TimerInterval: integer = 4000; DlgType: TMsgDlgType = TMsgDlgType.mtInformation; ToastPosition: TToastPosition = ToastTopRight); overload;
   procedure ShowMessage(const Msg: string; useToast: boolean; ASyncMode : Boolean; TimerInterval: integer = 4000; DlgType: TMsgDlgType = TMsgDlgType.mtInformation; ToastPosition: TToastPosition = ToastTopRight); overload;
   procedure ShowMessage(const Msg: string); overload;
   function MessageDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint; ACallBackName: string): Integer; overload;
   function MessageDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer; overload;
   function PrismSession: TPrismSession; deprecated 'Use just Session';
   function Session: TPrismSession;
   function CallBacks: IPrismFormCallBacks;

   Procedure ExportWithD2Bridge(const AD2Bridge: TD2Bridge);
{$IFDEF D2BRIDGE}
   Function Showing: Boolean;
   function D2BridgeItems: TD2BridgeItems;
{$ENDIF}
   function RootDirectory: string;
   destructor Destroy; override;
   procedure Release;

   class function IsD2BridgeContext: Boolean;

   function isNestedContext: boolean;

   function CSSClass: TCSSClass;

   function ShowCount: integer;

   class Function GetInstance: TD2BridgeForm; overload;
   //procedure CreateInstance(D2BridgeForm: TD2BridgeFormClass);
   procedure CreateInstance(FormClass: TFormClass); overload;
   procedure CreateInstance(DataModuleClass: TDataModuleClass); overload;
   procedure CreateInstance(D2BridgeFormClass: TD2BridgeFormClass); overload;
   class Procedure CreateInstance; overload;
//    class Procedure CreateInstance(AOwner: TD2BridgeForm); overload;
//    class Procedure CreateInstance(ASession: TPrismSession); overload;
//    class Procedure CreateInstance(D2BridgeInstance: TD2BridgeInstance); overload;
   Procedure DestroyInstance; overload;
   procedure DestroyInstance(AObject: TObject); overload;

{$IFDEF D2BRIDGE}
   procedure Show;
   function ShowModal: integer;
  {$IFNDEF FMX}
   procedure Close; overload;
  {$ELSE}
   function Close: TCloseAction; overload;
  {$ENDIF}
{$ENDIF}
   procedure Close(ACloseParam: variant); overload;

    //class Function Owner: TComponent;


    //class Procedure CreateInstance(AForm: TForm); overload;

  published
   property Language: TD2BridgeLang read GetLanguage;
   property D2Bridge : TD2Bridge read FD2Bridge;
   property TemplateClassForm : TClass read GetTemplateClassForm write FTemplateClassForm;
   property Title: String read GetTitle write SetTitle;
   property SubTitle: String read GetSubTitle write SetSubTitle;
   property PopupsShowing: TList<String> read FPopupsShowing write FPopupsShowing;
   property OnShowPopup: TOnPopup read FOnShowPopup write FOnShowPopup;
   property OnClosePopup: TOnPopup read FOnClosePopup write FOnClosePopup;
   property OnPageLoaded: TNotifyEvent read FOnPageLoaded write FOnPageLoaded;
   property OnTagHTML: TOnTagHTML read FOnTagHTML write FOnTagHTML;
   property OnUpload: TOnUpload read FOnUpload write FOnUpload;
   property ShowingModal: Boolean read FShowingModal;
   property PriorD2Bridge: TD2BridgeForm read FPriorD2Bridge write FPriorD2Bridge;
   property UsedD2BridgeInstance: boolean read FUsedD2BridgeInstance write FUsedD2BridgeInstance;
   property NestedName: string read GetNestedName write FNestedName;
   property PopupName: string read GetPopupName write FPopupName;
{$IFDEF D2BRIDGE}
   property ModalResult: integer read GetModalResult write SetModalResult;
   property Active: boolean read FActive default false;
{$ENDIF}
end;


{$IFDEF D2BRIDGE}
const
 TimeExpireResp = 30;
{$ENDIF}


implementation

uses
  D2Bridge.Item.VCLObj, D2Bridge.Messages, Prism.CallBack, Prism.Util, Prism.Forms, D2Bridge.VCLObj.Override,
  D2Bridge.Util, D2Bridge.BaseClass, D2Bridge.Manager, D2Bridge.Prism.Form, D2Bridge.Item.HTML.Popup,
  Prism.Session.Thread.Proc {$IFDEF D2BRIDGE}, Prism.BaseClass{$ENDIF};

{$IFDEF D2BRIDGE}
type
  TExecThread = class
  strict private
    fD2BridgeForm: TD2BridgeForm;
    fLockName: String;
    fFuncMessageDlgResponse: TCallBackEvent;
    fFuncShowMessage: TCallBackEvent;
    function _FuncShowMessage(EventParams: TStrings): string;
    function _FuncMessageDlgResponse(EventParams: TStrings): string;
  public
    constructor Create(aD2BridgeForm: TD2BridgeForm; aLockName: String); overload;
    destructor Destroy; override;
  published
    property FuncMessageDlgResponse: TCallBackEvent read fFuncMessageDlgResponse;
    property FuncShowMessage: TCallBackEvent read fFuncShowMessage;
  end;

{ TExecThread }

constructor TExecThread.Create(aD2BridgeForm: TD2BridgeForm; aLockName: String);
begin
  fD2BridgeForm:= aD2BridgeForm;
  fLockName:= aLockName;

  Self.fFuncMessageDlgResponse:= Self._FuncMessageDlgResponse;
  Self.fFuncShowMessage:= Self._FuncShowMessage;
end;

destructor TExecThread.Destroy;
begin
  inherited;
end;

function TExecThread._FuncMessageDlgResponse(EventParams: TStrings): string;
begin
  result:= '';

  if Assigned(EventParams) then
   if EventParams.Count > 0 then
     Result:= EventParams.Strings[0];

  Self.fD2BridgeForm.D2Bridge.PrismSession.UnLock(Self.fLockName);

  //Self Destruct After Execute
  Self.Free;
end;

function TExecThread._FuncShowMessage(EventParams: TStrings): string;
begin
  result:= '';

  if Assigned(EventParams) then
   if EventParams.Count > 0 then
    Result:= EventParams.Strings[0];

  Self.fD2BridgeForm.D2Bridge.PrismSession.UnLock(Self.fLockName);

  //Self Destruct After Execute
  Self.Free;
end;
{$ENDIF}

{ TD2BridgeForm }

constructor TD2BridgeForm.Create(AOwner: TComponent);
begin
 try
  {$IFDEF D2BRIDGE}
  inherited CreateNew(AOwner);
  InitInheritedComponent(self, TForm);
  {$ELSE}
  Inherited Create(AOwner);
  {$ENDIF}
 except
  {$IFDEF D2BRIDGE}
   on E: Exception do
   PrismSession.DoException(self as TObject, E, 'OnCreate');
  {$ENDIF}
 end;

 {$IFDEF D2BRIDGE}
  CreateD2BridgeForm;
 {$ENDIF}
end;

destructor TD2BridgeForm.Destroy;
var
 vComponentCount: integer;
 vComponent: TComponent;
begin
 {$IFDEF D2BRIDGE}
  // Cancela eventos pendentes para evitar acessos inválidos
  //Perform(WM_CLOSE, 0, 0);
  //Application.ProcessMessages;

 try
  Exec_DoDestroy;
 except
 end;

 try
  inherited;
 except
 end;

 {$ELSE}
  inherited;

  if FUsedD2BridgeInstance then
   D2BridgeInstance.RemoveInstance(self);
 {$ENDIF}
end;

{$IFDEF D2BRIDGE}
{$IFNDEF FMX}
procedure TD2BridgeForm.DestroyHandle(AControl: TWincontrol);
var
 I: integer;
begin
 for i := AControl.ComponentCount - 1 downto 0 do
  if (AControl.Components[I] is TWinControl) then
   TWinControlHelper(AControl.Components[I]).ClearHandle;

 try
  //if TWinControl(AControl).Handle <> 0 then
  TWinControlHelper(AControl).ClearHandle;

  if AControl is TTabSheet then
   TTabSheet(AControl).Destroy;
 except
 end;
end;
{$ENDIF}
{$ENDIF}

procedure TD2BridgeForm.DestroyInstance;
begin
{$IFDEF D2BRIDGE}
 D2BridgeInstance.DestroyInstance(self);
{$ELSE}
 Self.Destroy;
{$ENDIF}
end;

procedure TD2BridgeForm.DestroyInstance(AObject: TObject);
var
 vProc: TPrismSessionThreadProc;
begin
{$IFDEF D2BRIDGE}
 vProc:= TPrismSessionThreadProc.Create(PrismSession,
   Exec_DestroyInstance,
   TValue.From<TObject>(self),
   true,
   true
 );
 vProc.Exec;
{$ELSE}
 AObject.Destroy;
{$ENDIF}
end;


procedure TD2BridgeForm.DoBeginRender;
begin
 (D2Bridge.FrameworkForm as TPrismForm).DoBeginRender;
 BeginRender;
end;

procedure TD2BridgeForm.DoBeginRenderPrismControl(const APrismControl: TPrismControl);
begin
 BeginRenderD2Bridge(APrismControl);
end;

procedure TD2BridgeForm.DoBeginTagHTML;
begin
 BeginTagHTML;
end;

procedure TD2BridgeForm.DoBeginTranslate;
begin
 if FShowCount <= 1 then
  BeginTranslate(D2Bridge.Language);
end;

procedure TD2BridgeForm.DoBeginUpdateD2BridgeControls;
begin
 BeginUpdateD2BridgeControls;
end;

procedure TD2BridgeForm.DoCallBack(const CallBackName: String; EventParams: TStrings);
begin
 CallBack(CallBackName, EventParams);
end;

procedure TD2BridgeForm.DoCellButtonClick(APrismStringGrid: IPrismStringGrid; APrismCellButton: IPrismGridColumnButton; AColIndex, ARow: Integer);
begin
 if Assigned(APrismCellButton.ClickProc) then
  APrismCellButton.ClickProc();

 if Assigned(APrismCellButton.OnClick) then
  APrismCellButton.OnClick(self);

 CellButtonClick
  (APrismStringGrid as TPrismStringGrid,
   APrismCellButton as TPrismGridColumnButton,
   AColIndex,
   ARow);
end;

{$IFNDEF FMX}
procedure TD2BridgeForm.DoCardGridClick(PrismControlClick: TPrismControl; ARow: Integer; APrismCardGrid: TPrismCardGridDataModel);
begin
 CardGridClick(PrismControlClick, ARow, APrismCardGrid);
end;

procedure TD2BridgeForm.DoCellButtonClick(APrismDBGrid: IPrismDBGrid; APrismCellButton: IPrismGridColumnButton; AColIndex, ARow: Integer);
begin
 if Assigned(APrismCellButton.ClickProc) then
  APrismCellButton.ClickProc();

 if Assigned(APrismCellButton.OnClick) then
  APrismCellButton.OnClick(self);

 CellButtonClick
  ((APrismDBGrid as TPrismDBGrid),
   (APrismCellButton as TPrismGridColumnButton),
   AColIndex,
   ARow);
end;
{$ENDIF}

procedure TD2BridgeForm.DoClose(var Action: TCloseAction);
begin
 {$IFDEF D2BRIDGE}
 if csDestroying in ComponentState then
  Exit;

// if Assigned(OnClose) then
//  OnClose(Self, Action);

 //Close;

 if Assigned(OnClose) then
  OnClose(Self, Action);

 if FShowingModal then
 begin
  FDestroyForm:= Action = TCloseAction.caFree;
  Action:= TCloseAction.caNone;
 end;

 if Action <> TCloseAction.caFree then
  if Assigned(OnDeactivate) then
   OnDeactivate(Self);

 if FShowing then
 begin
  if isNestedContext then
   (FD2Bridge.BaseClass.FrameworkForm as TPrismForm).onFormUnload
  else
   FD2Bridge.BaseClass.FrameworkForm.Hide;

  FShowing:= false;

  FShowingModal:= false;

//  TThread.Synchronize(TThread.CurrentThread,
//   procedure
//   begin
//    Visible := false;
//   end
//  );
 end;

 while (FPopupsShowing.Count > 0) do
  ClosePopup(FPopupsShowing[0]);

 {$ELSE}
  inherited;
 {$ENDIF}
end;

{$IFDEF D2BRIDGE}
procedure TD2BridgeForm.DoCloseShowmodal;
var
 FIsLocked: Boolean;
 FLockName: string;
begin
 if not D2Bridge.PrismSession.Closing then
 begin
  FLockName:= D2Bridge.FrameworkForm.FormUUID+'_showmodal';
  if D2Bridge.PrismSession.LockExists(FLockName) then
  begin
   D2Bridge.PrismSession.UnLock(FLockName);

   if FDestroyForm then
   begin
    FD2Bridge.PrismSession.ExecThread(false,
     Exec_DoCloseShowmodal
    );
   end;
  end;
 end;

 FShowingModal:= false;
end;

procedure TD2BridgeForm.BeforeDestruction;
begin
 if not FDestroying then
 begin
  FDestroying:= true;

  if MainThreadID <> GetCurrentThreadId then
  begin
   DestroyInstance;
   abort;
  end else
  begin
   inherited;
  end;
 end else
  inherited;
end;
{$ENDIF}

{$IFDEF VCL}
procedure TD2BridgeForm.DoDestroy;
begin
 {$IFDEF D2BRIDGE}

 {$ELSE}
  inherited;
 {$ENDIF}
end;
{$ENDIF}

{$IFDEF VCL}
procedure TD2BridgeForm.DoCreate;
begin
 {$IFDEF D2BRIDGE}
  FDestroying:= false;
 {$ELSE}
  inherited;
 {$ENDIF}
end;
{$ENDIF}

procedure TD2BridgeForm.DoEndRender;
begin
 (D2Bridge.FrameworkForm as TPrismForm).DoEndRender;
 EndRender;
end;

procedure TD2BridgeForm.DoEndTagHTML;
begin
 EndTagHTML;
end;

procedure TD2BridgeForm.DoEndUpdateD2BridgeControls;
begin
 EndUpdateD2BridgeControls;
end;

procedure TD2BridgeForm.DoEventD2Bridge(const PrismControl: TPrismControl; const EventType: TPrismEventType; EventParams: TStrings);
begin
 EventD2Bridge(PrismControl, EventType, EventParams);
end;

procedure TD2BridgeForm.DoHide;
begin
 {$IFDEF D2BRIDGE}
 if FShowing then
 begin
  FD2Bridge.BaseClass.FrameworkForm.Hide;

  FShowing:= false;

  inherited;
 end;
 {$ELSE}
 inherited;
 {$ENDIF}
end;

procedure TD2BridgeForm.DoInitPrismControl(const APrismControl: TPrismControl);
begin
 InitControlsD2Bridge(APrismControl);
end;

procedure TD2BridgeForm.DoKanbanClick(const AKanbanCard: IPrismCardModel; const PrismControlClick: TPrismControl);
begin
 KanbanClick(AKanbanCard, PrismControlClick);
end;

procedure TD2BridgeForm.DoKanbanMoveCard(const AKanbanCard: IPrismCardModel; const IsColumnMoved, IsPositionMoved: boolean);
begin
 KanbanMoveCard(AKanbanCard, IsColumnMoved, IsPositionMoved);
end;

procedure TD2BridgeForm.DoOrientationChange;
begin
 if Assigned(OnResize) then
  OnResize(self);

 OrientationChange;
end;

procedure TD2BridgeForm.DoPageLoaded;
begin
// if D2BridgeManager.PrimaryFormClass = self.ClassType then
// begin
//  FShowing:= true;
//
//  Inc(FShowCount);
//
////  if Assigned(OnShow) then
////   OnShow(self);
//
//  Activate;
// end else
// begin
{$IFDEF FMX}
  if TFmxFormState.Showing in Self.FormState then
{$ELSE}
  if Showing then
{$ENDIF}
  begin
//   if Assigned(OnShow) then
//    OnShow(self);

   Activate;
  end;
 //end;

{$IFDEF FMX}
  if TFmxFormState.Showing in Self.FormState then
{$ELSE}
  if Showing then
{$ENDIF}
 if Assigned(FOnPageLoaded) then
  FOnPageLoaded(self)
 else
  PageLoaded;

{$IFDEF D2BRIDGE}
 if Assigned(PriorD2Bridge) and (PriorD2Bridge <> Self) and (not PriorD2Bridge.ShowingModal) then
 begin
  PriorD2Bridge.DoCloseShowmodal;
 end;
{$ENDIF}
end;

procedure TD2BridgeForm.DoPageResize;
begin
 if Assigned(OnResize) then
  OnResize(self);

 PageResize;
end;

procedure TD2BridgeForm.DoPopupClosed(AName: string);
var
 I: Integer;
 vCanClosePopup: Boolean;
 vPopup: TD2BridgeItemHTMLPopup;
 vNestedFormName: String;
 vD2BridgeFormNested: TD2BridgeForm;
begin
{$IFDEF D2BRIDGE}
//  if not Assigned(FOnClosePopup) then
//  begin
//   vCanClosePopup:= true;
//   ClosePopup(AName, vCanClosePopup);
//   //Add this code bellow because this function not is been implemented yet
//   vCanClosePopup:= true;
//   //if not vCanClosePopup then
//   // exit;
//  end;


  vPopup:= nil;
  for I := 0 to D2Bridge.Items.Items.Count-1 do
  if Supports(D2Bridge.Items.Items[I], ID2BridgeItemHTMLPopup) then
  if AnsiUpperCase((D2Bridge.Items.Items[I] as TD2BridgeItemHTMLPopup).ItemID) = AnsiUpperCase(AName) then
  begin
   vPopup:= (D2Bridge.Items.Items[I] as TD2BridgeItemHTMLPopup);
   Break;
  end;

  if Assigned(vPopup) and (vPopup <> nil) then
  begin
   vNestedFormName:= '';

   //Check Nested
   {$REGION 'Check Nested'}
    for I := 0 to vPopup.Items.Items.Count-1 do
    if Supports(vPopup.Items.Items[I], ID2BridgeItemNested) then
    vNestedFormName:= (vPopup.Items.Items[I] as ID2BridgeItemNested).NestedFormName;

    if vNestedFormName <> '' then
    begin
     for I := 0 to D2Bridge.NestedCount-1 do
     if AnsiUpperCase(TD2BridgeForm(D2Bridge.Nested(I).FormAOwner).NestedName) = AnsiUpperCase(vNestedFormName) then
     begin
      vD2BridgeFormNested:= TD2BridgeForm(D2Bridge.Nested(I).FormAOwner);

      vD2BridgeFormNested.PopupName:= '';

      if vD2BridgeFormNested.Showing then
       vD2BridgeFormNested.Close;
     end;
    end;
   {$ENDREGION}

   //D2Bridge.PrismSession.ExecJS('decd2bridgepopup(document.querySelector(''[id='+vPopup.ItemPrefixID+' i]''));', true);
  end;


  if FPopupsShowing.Contains(AName) then
   FPopupsShowing.Remove(AName);

  if Assigned(FOnClosePopup) then
   FOnClosePopup(AName)
  else
  begin
   PrismSession.ExecThread(false,
    Exec_PopupClosed,
    TValue.From<string>(AName),
    TValue.From<TD2BridgeItemHTMLPopup>(vPopup)
   );
  end;

  D2Bridge.PrismSession.UnLock(UpperCase(AName));
{$ENDIF}
end;

procedure TD2BridgeForm.DoPopupOpened(AName: string);
var
 I: Integer;
 vPopup: TD2BridgeItemHTMLPopup;
 vNestedFormName: String;
 vD2BridgeFormNested: TD2BridgeForm;
 vCanShowPopup: boolean;
begin
 vPopup:= nil;
 for I := 0 to D2Bridge.Items.Items.Count-1 do
 if Supports(D2Bridge.Items.Items[I], ID2BridgeItemHTMLPopup) then
 if AnsiUpperCase((D2Bridge.Items.Items[I] as TD2BridgeItemHTMLPopup).ItemID) = AnsiUpperCase(AName) then
 begin
  vPopup:= (D2Bridge.Items.Items[I] as TD2BridgeItemHTMLPopup);
  Break;
 end;

 if Assigned(vPopup) and (vPopup <> nil) then
 begin
  if not Assigned(FOnShowPopup) then
  begin
   vCanShowPopup:= true;
   ShowPopup(AName, vCanShowPopup);
   if not vCanShowPopup then
    exit;
  end;

  vNestedFormName:= '';
  if not FPopupsShowing.Contains(AName) then
  FPopupsShowing.Add(AName);

  //Check Nested
  {$REGION 'Check Nested'}
  for I := 0 to vPopup.Items.Items.Count-1 do
  if Supports(vPopup.Items.Items[I], ID2BridgeItemNested) then
  vNestedFormName:= (vPopup.Items.Items[I] as ID2BridgeItemNested).NestedFormName;

  if vNestedFormName <> '' then
  begin
   for I := 0 to D2Bridge.NestedCount-1 do
   if AnsiUpperCase(TD2BridgeForm(D2Bridge.Nested(I).FormAOwner).NestedName) = AnsiUpperCase(vNestedFormName) then
   begin
    vD2BridgeFormNested:= TD2BridgeForm(D2Bridge.Nested(I).FormAOwner);

    try
     if Assigned(vD2BridgeFormNested.OnActivate) then
      vD2BridgeFormNested.OnActivate(vD2BridgeFormNested);
    except
    on E: Exception do
     try
      PrismSession.DoException(self as TObject, E, 'FormOnActivate');
     except
     end;
    end;
   end;
  end;
  {$ENDREGION}
 end;

 try
  if Assigned(FOnShowPopup) then
   FOnShowPopup(AName)
  else
   PopupOpened(AName);
 except
 on E: Exception do
  try
   PrismSession.DoException(self as TObject, E, 'PopupOpened');
  except
  end;
 end;
end;

procedure TD2BridgeForm.DoRenderPrismControl(const APrismControl: TPrismControl; var HTMLControl: string);
begin
 Self.RenderD2Bridge(APrismControl, HTMLControl);
end;

procedure TD2BridgeForm.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin

end;


class function TD2BridgeForm.IsD2BridgeContext: Boolean;
begin
 {$IFDEF D2BRIDGE}
 Result := True;
 {$ELSE}
 Result := False;
 {$ENDIF}
end;

function TD2BridgeForm.isNestedContext: boolean;
begin
 result:= false;

 if IsD2BridgeContext then
  result:= D2Bridge.isNestedContext;
end;

procedure TD2BridgeForm.KanbanClick(const AKanbanCard: IPrismCardModel; const PrismControlClick: TPrismControl);
begin

end;

procedure TD2BridgeForm.KanbanMoveCard(const AKanbanCard: IPrismCardModel; const IsColumnMoved, IsPositionMoved: boolean);
begin
end;

// ****Precisa implementar também CreateMessageDialog*****
function TD2BridgeForm.MessageDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint; ACallBackName: string): Integer;
{$IFDEF D2BRIDGE}
var
 ButtonArray : Array of RBUttonTypes;
 vPrimCallBackName: String;
 vResponseMessageDlg: Integer;
 _Button: TMsgDlgBtn;
 _MessageString: String;
 _TipoAlerta: RAlertTypes;
 _LockName: string;
 ProcExecThread: TExecThread;
 vPrismCallBack: IPrismCallBack;
 vMSGTranslated: string;
{$ENDIF}
begin
 {$IFDEF D2BRIDGE}

 _TipoAlerta:= Default(RAlertTypes);

 vMSGTranslated:= Msg;
 (D2Bridge.FrameworkForm as TPrismForm).ProcessTagTranslate(vMSGTranslated);

 if D2Bridge.PrismSession.ActiveForm.FormPageState <> PageStateLoaded then
 begin
  raise Exception.Create('In D2Bridge Context not is possible block the session before show page.');
  Abort;
 end;

 if ACallBackName <> '' then
  vPrimCallBackName:= ACallBackName
 else
  vPrimCallBackName:= 'MessageDlg'+GenerateRandomString(30);

 if ACallBackName <> '' then
  _LockName := ACallBackName
 else
  _LockName := vPrimCallBackName;

 ProcExecThread:= TExecThread.Create(Self, _LockName);

 vPrismCallBack:= D2Bridge.PrismSession.ActiveForm.CallBacks.Register(vPrimCallBackName, ProcExecThread.FuncMessageDlgResponse);

 FMessageResponse:= -1;
 SetLength(ButtonArray,0);


 // Iterar pelos elementos do conjunto
 {$REGION 'Carrega os Botões'}
  //Colors https://www.colorhexmap.com/
  for _Button := Low(TMsgDlgBtn) to High(TMsgDlgBtn) do
  begin
    // Verificar se o botão está presente no conjunto
    if _Button in Buttons then
    begin
      SetLength(ButtonArray,Length(ButtonArray)+1);

      // Fazer algo com o botão
      case _Button of
        TMsgDlgBtn.mbYes:
         with ButtonArray[Length(ButtonArray)-1] do
         begin
          Value:= mrYes;
          Caption := PrismSession.LangNav.MessageButton.ButtonYes;
          Color:= '#5dc640';
         end;
        TMsgDlgBtn.mbNo:
         with ButtonArray[Length(ButtonArray)-1] do
         begin
          Value:= mrNo;
          Caption := PrismSession.LangNav.MessageButton.ButtonNo;
          Color := '#dc9b71';
         end;
        TMsgDlgBtn.mbOK:
         with ButtonArray[Length(ButtonArray)-1] do
         begin
          Value:= mrOK;
          Caption := PrismSession.LangNav.MessageButton.ButtonOk;
          Color := '#e82a58';
         end;
        TMsgDlgBtn.mbCancel:
         with ButtonArray[Length(ButtonArray)-1] do
         begin
          Value:= mrCancel;
          Caption := PrismSession.LangNav.MessageButton.ButtonCancel;
          Color := '#aa5454';
         end;
        TMsgDlgBtn.mbAbort:
         with ButtonArray[Length(ButtonArray)-1] do
         begin
          Value:= mrAbort;
          Caption := PrismSession.LangNav.MessageButton.ButtonAbort;
          Color := '#d02819';
         end;
        TMsgDlgBtn.mbRetry:
         with ButtonArray[Length(ButtonArray)-1] do
         begin
          Value:= mrRetry;
          Caption := PrismSession.LangNav.MessageButton.ButtonRetry;
          Color := '#376bf3';
         end;
        TMsgDlgBtn.mbIgnore:
         with ButtonArray[Length(ButtonArray)-1] do
         begin
          Value:= mrIgnore;
          Caption := PrismSession.LangNav.MessageButton.ButtonIgnore;
          Color:= '#e8c88b';
         end;
        TMsgDlgBtn.mbAll:
         with ButtonArray[Length(ButtonArray)-1] do
         begin
          Value:= mrAll;
          Caption := PrismSession.LangNav.MessageButton.ButtonAll;
          Color:= '#0d24c6';
         end;
        TMsgDlgBtn.mbNoToAll:
         with ButtonArray[Length(ButtonArray)-1] do
         begin
          Value:= mrNoToAll;
          Caption := PrismSession.LangNav.MessageButton.ButtonNoToAll;
          Color:= '#d50446';
         end;
        TMsgDlgBtn.mbYesToAll:
         with ButtonArray[Length(ButtonArray)-1] do
         begin
          Value:= mrYesToAll;
          Caption := PrismSession.LangNav.MessageButton.ButtonYesToAll;
          Color:= '#199306';
         end;
        TMsgDlgBtn.mbHelp:
         with ButtonArray[Length(ButtonArray)-1] do
         begin
{$IFNDEF FPC}
          Value:= mrHelp;
{$ELSE}
          // Help does not return from modal;
{$ENDIF}
          Caption := PrismSession.LangNav.MessageButton.ButtonmrHelp;
          Color:= '#0f8cf7';
         end;
        TMsgDlgBtn.mbClose:
         with ButtonArray[Length(ButtonArray)-1] do
         begin
          Value:= mrClose;
          Caption := PrismSession.LangNav.MessageButton.ButtonmrClose;
          Color:= '#68718d';
         end;
      end;
    end;
  end;
 {$ENDREGION}


 //Carrega o Tipo de Alerta
 {$REGION 'Tipo de Alerta'}
  case DlgType of
   TMsgDlgType.mtWarning:
   begin
    _TipoAlerta.Tipo:= 'warning';
    _TipoAlerta.Caption:= PrismSession.LangNav.MessageType.TypeWarning;
   end;
   TMsgDlgType.mtError:
   begin
    _TipoAlerta.Tipo:= 'error';
    _TipoAlerta.Caption:= PrismSession.LangNav.MessageType.TypeError;
   end;
   TMsgDlgType.mtInformation:
   begin
    if (Length(ButtonArray) = 1) and (ButtonArray[0].Caption = 'Ok') then
    begin
     _TipoAlerta.Tipo:= 'success';
     _TipoAlerta.Caption:= PrismSession.LangNav.MessageType.TypeSuccess;
    end else
    begin
     _TipoAlerta.Tipo:= 'info';
     _TipoAlerta.Caption:= PrismSession.LangNav.MessageType.TypeInformation;
    end;
   end;
   TMsgDlgType.mtConfirmation:
   begin
    _TipoAlerta.Tipo:= 'question';
    _TipoAlerta.Caption:= PrismSession.LangNav.MessageType.TypeQuestion;
   end;
   TMsgDlgType.mtCustom:
   begin
    _TipoAlerta.Tipo:= 'information';
    _TipoAlerta.Caption:= PrismSession.LangNav.MessageType.TypeInformation;
   end;
  end;
 {$ENDREGION}



 //Monta a Mensagem
 _MessageString:=
    'let _IsLockShowing = IsThreadClientLocked();                         '+
    'UnLockThreadClient();                                                '+
    'setTimeout(function() {                                                  '+
    '   document.activeElement.blur();                                        '+
    '   document.body.focus();                                                '+
    '}, 1);                                                                   '+
    'var modalElement = document.querySelector(''.modal'');                   '+
    'if (modalElement) {                                                      '+
    ' var currentModalZIndex = window.getComputedStyle(modalElement).zIndex;  '+
    ' modalElement.style.zIndex = 999;                                        '+
    '}                                                                        '+
    'swal.fire({                                                          ';

 _MessageString := _MessageString +
    '   title:         "' + _TipoAlerta.Caption + '",                     '+
    '   html:         ' + FormatValueHTML(vMSGTranslated) + ',            '+
    '   text:         ' + FormatValueHTML(vMSGTranslated) + ',            '+
    '   icon:         "' + _TipoAlerta.Tipo +'",                          '+
    '   showCancelButton:                                                 ';
    if (Length(ButtonArray) <= 1) then
     _MessageString:= _MessageString +
    '     false,                       '
    else
    _MessageString:= _MessageString +
    '     true,                        ';
 _MessageString:= _MessageString +
    '   confirmButtonColor:   "'+ ButtonArray[0].Color +'",                ';
    if (Length(ButtonArray) >= 2) then
    _MessageString:= _MessageString +
    '   cancelButtonColor:   "'+ ButtonArray[1].Color +'",                 ';
    if (Length(ButtonArray) >= 3) then
    _MessageString:= _MessageString +
    '   denyButtonColor:   "'+ ButtonArray[2].Color +'",                   ';
 _MessageString:= _MessageString +
    '   confirmButtonText:   "' + ButtonArray[0].Caption + '",             ';
    if (Length(ButtonArray) >= 2) then
    _MessageString:= _MessageString +
    '   cancelButtonText:   "' +  ButtonArray[1].Caption + '",             ';
    if (Length(ButtonArray) >= 3) then
    _MessageString:= _MessageString +
    '   denyButtonText:     "' +  ButtonArray[2].Caption + '",             ';
 _MessageString:= _MessageString +
    ' closeOnConfirm: false,                                               '+
    ' closeOnCancel: false,                                                '+
    ' allowOutsideClick: false,                                             '+
    ' customClass: { popup: "d2bridgealert' + vPrimCallBackName + '" }                  '+
    ' }).then((result) => {                                                '+
    '  if (_IsLockShowing === true) {                                      '+
    '    LockThreadClient();                                               '+
    '  }                                                                   '+
    '  if (modalElement) {                                                 '+
    '    modalElement.style.zIndex = currentModalZIndex;                   '+
    '  }                                                                   '+
    '   if (result.isConfirmed) {                                          '+
    '      '+ D2Bridge.PrismSession.CallBacks.CallBackDirectJS(vPrimCallBackName, D2Bridge.PrismSession.ActiveForm.FormUUID, IntToStr(ButtonArray[0].Value))+'   '+
    '   }                                                                  ';
    if (Length(ButtonArray) >= 2) then
    begin
     _MessageString:= _MessageString +
     '   else if (result.isDismissed) {                                     '+
    '      '+ D2Bridge.PrismSession.CallBacks.CallBackDirectJS(vPrimCallBackName, D2Bridge.PrismSession.ActiveForm.FormUUID, IntToStr(ButtonArray[1].Value))+'   '+
     '   }                                                                  ';
    end;
    if (Length(ButtonArray) >= 3) then
    begin
     _MessageString:= _MessageString +
     '   else if (result.isDenied) {                                     '+
    '      '+ D2Bridge.PrismSession.CallBacks.CallBackDirectJS(vPrimCallBackName, D2Bridge.PrismSession.ActiveForm.FormUUID, IntToStr(ButtonArray[2].Value))+'   '+
     '   }                                                                  ';
    end;
    _MessageString:= _MessageString +
     '}); ';



  D2Bridge.PrismSession.ExecJS(_MessageString, true);

  D2Bridge.PrismSession.Lock(_LockName);
  if (not Assigned(self)) or (not Assigned(D2Bridge)) or (D2Bridge.PrismSession.Destroying) or D2Bridge.PrismSession.Closing then
  Abort;


// repeat
//  Application.HandleMessage;
// until not vWaitMessage;

 if ACallBackName <> '' then
  PrismSession.ExecJS(
   '{                                                                                   '+
   ' const popup = document.querySelector(".d2bridgealert' + vPrimCallBackName + '");   '+
   '  if (popup) {                                                                      '+
   '    Swal.close();                                                                   '+
   '  }                                                                                 '+
   '}                                                                                   '
  );


 if TryStrToInt(vPrismCallBack.Response, vResponseMessageDlg) then
 begin
  result:= vResponseMessageDlg;
 end else
 result:= -1;

 if Assigned(vPrismCallBack) then
 begin
  vPrismCallBack:= nil; { #todo -c'Fix Lazarus RefCount' :  }
  D2Bridge.PrismSession.ActiveForm.CallBacks.Unregister(vPrimCallBackName);
 end;


 //Somente aborta se tiver mais de uma confirmação
// if Length(ButtonArray) > 1 then
// Abort;

 {$ELSE}
   {$IFDEF FMX}
 result:= FMX.Dialogs.MessageDlg(msg, DlgType, Buttons, HelpCtx);
   {$ELSE}
 result:= Dialogs.MessageDlg(msg, DlgType, Buttons, HelpCtx);
   {$ENDIF}
 {$ENDIF}
end;


function TD2BridgeForm.MessageDlg(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer;
begin
 {$IFDEF D2BRIDGE}
 result:= MessageDlg(Msg, DlgType, Buttons, HelpCtx, '');
 {$ELSE}
   {$IFDEF FMX}
 result:= FMX.Dialogs.MessageDlg(msg, DlgType, Buttons, HelpCtx);
   {$ELSE}
 result:= Dialogs.MessageDlg(msg, DlgType, Buttons, HelpCtx);
   {$ENDIF}
 {$ENDIF}
end;

procedure TD2BridgeForm.OrientationChange;
begin

end;

procedure TD2BridgeForm.Release;
begin
 Destroy;
end;

procedure TD2BridgeForm.Render;
begin
{$IFDEF D2BRIDGE}


 PrismSession.ExecThread(true,
  Exec_Render
 );

// PrismSession.ExecThread(true,
//  procedure
//  begin
//   EndRender;
//  end);
{$ENDIF}
end;

procedure TD2BridgeForm.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string);
begin
end;

function TD2BridgeForm.RootDirectory: string;
begin
 result:= D2Bridge.RootDirectory;
end;

{$IFDEF D2BRIDGE}
procedure TD2BridgeForm.SetModalResult(const Value: integer);
begin
 FModalResult:= Value;

 if (FModalResult > 0) and (FShowingModal) then
  Close;
end;
{$ENDIF}

procedure TD2BridgeForm.InternalCreate(AOwner: TD2BridgeForm);
begin
  try
   inherited CreateNew(TComponent(AOwner));
   InitInheritedComponent(self, TForm);
  except on E: Exception do
    PrismSession.DoException(Self as TObject, E, 'OnCreate');
  end;
end;

procedure TD2BridgeForm.SetSubTitle(const Value: String);
begin
 FSubTitle:= value;
end;

procedure TD2BridgeForm.SetTitle(const Value: String);
begin
 FTitle:= Value;
end;

procedure TD2BridgeForm.SetupD2Bridge;
begin
end;

procedure TD2BridgeForm.ShowPopup(AName: String);
var
 I: Integer;
 vPopup: TD2BridgeItemHTMLPopup;
 vNestedFormName: String;
 vD2BridgeFormNested: TD2BridgeForm;
 vCanShowPopup: boolean;
begin
  vPopup:= nil;
  for I := 0 to D2Bridge.Items.Items.Count-1 do
  if Supports(D2Bridge.Items.Items[I], ID2BridgeItemHTMLPopup) then
  if AnsiUpperCase((D2Bridge.Items.Items[I] as TD2BridgeItemHTMLPopup).ItemID) = AnsiUpperCase(AName) then
  begin
   vPopup:= (D2Bridge.Items.Items[I] as TD2BridgeItemHTMLPopup);
   Break;
  end;

  if Assigned(vPopup) and (vPopup <> nil) then
  begin
   if not Assigned(FOnShowPopup) then
   begin
    vCanShowPopup:= true;
    ShowPopup(AName, vCanShowPopup);
    if not vCanShowPopup then
     exit;
   end;

   vNestedFormName:= '';
   if not FPopupsShowing.Contains(AName) then
   FPopupsShowing.Add(AName);

   //Check Nested
   {$REGION 'Check Nested'}
    for I := 0 to vPopup.Items.Items.Count-1 do
    if Supports(vPopup.Items.Items[I], ID2BridgeItemNested) then
    vNestedFormName:= (vPopup.Items.Items[I] as ID2BridgeItemNested).NestedFormName;

    if vNestedFormName <> '' then
    begin
     for I := 0 to D2Bridge.NestedCount-1 do
     if AnsiUpperCase(TD2BridgeForm(D2Bridge.Nested(I).FormAOwner).NestedName) = AnsiUpperCase(vNestedFormName) then
     begin
      vD2BridgeFormNested:= TD2BridgeForm(D2Bridge.Nested(I).FormAOwner);

      //Unload Prism Form Owner from Nested
      //(vD2BridgeFormNested.D2Bridge.FrameworkForm as TPrismForm).onFormUnload;

      //if Assigned(vD2BridgeFormNested.OnShow) then
      // vD2BridgeFormNested.OnShow(vD2BridgeFormNested);
      (vD2BridgeFormNested.D2Bridge.FrameworkForm as TPrismForm).FormPageState:= PageStateLoading;

      vD2BridgeFormNested.PopupName:= AName;
      vD2BridgeFormNested.DoShow;

//      try
//       if Assigned(vD2BridgeFormNested.OnActivate) then
//        vD2BridgeFormNested.OnActivate(vD2BridgeFormNested);
//      except
//      on E: Exception do
//       try
//        PrismSession.DoException(self as TObject, E, 'FormOnActivate');
//       except
//       end;
//      end;

      if not TD2BridgeForm(D2Bridge.Nested(I).FormAOwner).PopupsShowing.Contains(AName) then
      TD2BridgeForm(D2Bridge.Nested(I).FormAOwner).PopupsShowing.Add(AName);

      //TD2BridgePrismForm(D2Bridge.Nested(I).FrameworkForm).UpdateControls;

      (vD2BridgeFormNested.D2Bridge.FrameworkForm as TPrismForm).UpdateServerControls;
     end;
    end;
   {$ENDREGION}

   PrismSession.ExecJS
    (
     'incd2bridgepopup(new bootstrap.Modal(document.querySelector(''[id='+ AnsiUpperCase(AName) +' i]''))); ',
     true
    );
  end;
end;


procedure TD2BridgeForm.ShowPopupModal(AName: String);
begin
{$IFDEF D2BRIDGE}
 PrismSession.ExecThread(true,
  Exec_ShowPopupModal,
  TValue.From<string>(AName)
 );
{$ENDIF}
end;

procedure TD2BridgeForm.TagHTML(const TagString: string;
  var ReplaceTag: string);
begin

end;


procedure TD2BridgeForm.TagTranslate(const Language: TD2BridgeLang;
  const AContext, ATerm: string; var ATranslated: string);
begin

end;

{$IFDEF D2BRIDGE}
procedure TD2BridgeForm.UnRegisterStaticCallBacks;
begin
 CallBacks.UnRegister('CallBackClose');
 CallBacks.UnRegister('CallBackCloseSession');
 CallBacks.UnRegister('CallBackHome');
end;
{$ENDIF}

procedure TD2BridgeForm.UpdateD2BridgeControls(const PrismControl: TPrismControl);
begin
end;

procedure TD2BridgeForm.Upload(AFiles: TStrings; Sender: TObject);
begin

end;

procedure TD2BridgeForm.EndRender;
begin

end;

procedure TD2BridgeForm.EndTagHTML;
begin

end;

procedure TD2BridgeForm.EndUpdateD2BridgeControls;
begin

end;

procedure TD2BridgeForm.EventD2Bridge(const PrismControl: TPrismControl;
  const EventType: TPrismEventType; EventParams: TStrings);
begin

end;

procedure TD2BridgeForm.ExportD2Bridge;
begin
end;

{$IFDEF D2BRIDGE}
procedure TD2BridgeForm.Exec_Activate;
begin
 try
  if Assigned(OnActivate) then
   OnActivate(self);

  FActive:= true;
 except on E: Exception do
  try
    PrismSession.DoException(Self as TObject, E, 'FormOnActivate');
  except
  end;
 end;
end;

procedure TD2BridgeForm.Exec_DestroyInstance(varObject: TValue);
var
 vObject: TObject;
begin
 try
  vObject:= varObject.AsObject;

  vObject.Free;
 except
 end;
end;

procedure TD2BridgeForm.Exec_DoCloseShowmodal;
begin
 try
  //Wait 100 mille seconds to continue Distroy the form
  //This time is necessary because em "release mode"
  //the form is destructed but modal result is processed yet
  Sleep(100);

  Destroy;
 except on E: Exception do
  try
    PrismSession.DoException(Self as TObject, E, 'DestroyFormModal');
  except
  end;
 end;
end;


procedure TD2BridgeForm.Exec_DoDestroy;
var
 vComponentCount: integer;
 vComponent: TComponent;
begin
 try
  if Assigned(OnDestroy) then
  begin
   TPrismSessionThreadProc.Create(nil,
    Exec_OnDestroy,
    true
   ).Exec;
  end;
 except
 end;

 try
  FreeAndNil(FPopupsShowing);
 except
 end;

 try
  if FUsedD2BridgeInstance and Assigned(FD2Bridge) and (not (csDestroying in TPrismSession(FD2Bridge.PrismSession).ComponentState)) and Assigned(FD2Bridge.PrismSession) and Assigned(FD2Bridge.PrismSession.D2BridgeInstance) then
   TD2BridgeInstance(FD2Bridge.PrismSession.D2BridgeInstance).RemoveInstance(self);
 except
 end;

  //SetLength(FArrayCombobox, 0);

 try
  FreeAndNil(FD2BridgeFormComponentHelperItems);
 except
 end;

 try
  if not D2Bridge.PrismSession.Destroying then
  if D2Bridge.PrismSession.LockExists(D2Bridge.FrameworkForm.FormUUID+'_showmodal') then
  begin
   D2Bridge.PrismSession.D2BridgeBaseClassActive:= PrismSession.D2BridgeBaseClassActive;
   DoCloseShowmodal;
  end;
 except
 end;

 //try
 // if TPrismForm(FD2Bridge.FrameworkForm).D2BridgeForm = self then
 // begin
   //RemoveComponent(TPrismForm(FD2Bridge.FrameworkForm));
   //(FD2Bridge.FrameworkForm as TD2BridgePrismForm).Free;
 // end;
 //except
 //end;


 {$IFDEF VCL}
  //WindowHandle:= 0;
 {$ENDIF}

 try
  vComponentCount:= ComponentCount;
  while (ComponentCount > 0) and (vComponentCount > 0) do
  begin
   try
    vComponent:= Components[ComponentCount-1];
    RemoveComponent(vComponent);

    try
     vComponent.Free;
    except
    end;
   except
   end;

   Dec(vComponentCount);
  end;
 except
 end;


 try
  if Assigned(FD2Bridge) then
   FD2Bridge.Free;
 except
 end;
end;

procedure TD2BridgeForm.Exec_OnDestroy;
begin
 OnDestroy(self);
end;

procedure TD2BridgeForm.Exec_PopupClosed(varPopupName, varPopup: TValue);
var
 vPopupName: string;
 vPopup: TD2BridgeItemHTMLPopup;
begin
 try
  vPopupName:= varPopupName.AsString;
  vPopup:= varPopup.AsObject as TD2BridgeItemHTMLPopup;

  PopupClosed(vPopupName, (vPopup as TD2BridgeItemHTMLPopup).CloseParam);
  PopupClosed(vPopupName);

  (vPopup as TD2BridgeItemHTMLPopup).CloseParam:= Unassigned;
 except
 end;
end;

procedure TD2BridgeForm.Exec_Render;
begin
 try
  if not isNestedContext then
   if Assigned(OnShow) then
    OnShow(Self);
 except on E: Exception do
  try
   PrismSession.DoException(Self as TObject, E, 'FormOnShow');
  except
  end;
 end;

 try
  DoBeginRender;
 except on E: Exception do
  try
   PrismSession.DoException(Self as TObject, E, 'OnBeginRender');
  except
  end;
 end;

 D2Bridge.RenderD2Bridge(D2Bridge.Items.Items);

 try
  DoEndRender;
 except on E: Exception do
  try
   PrismSession.DoException(Self as TObject, E, 'OnEndRender');
  except
  end;
 end;
end;

procedure TD2BridgeForm.Exec_ShowPopupModal(varPopupName: TValue);
var
 vPopupName: string;
begin
 try
  vPopupName:= varPopupName.AsString;

  ShowPopup(vPopupName);

  if FPopupsShowing.Contains(vPopupName) then
   D2Bridge.PrismSession.Lock(UpperCase(vPopupName));

  if (not Assigned(self)) or (not Assigned(D2Bridge)) or (D2Bridge.PrismSession.Destroying) or D2Bridge.PrismSession.Closing then
   Abort;
 except
 end;
end;

{$ENDIF}

procedure TD2BridgeForm.ExportD2Bridge(D2Bridge: TD2Bridge);
begin

end;

procedure TD2BridgeForm.ExportD2BridgeAllControls;
var
 I, J: Integer;
begin
 for I := 0 to Pred(Self.{$IFDEF FMX}ChildrenCount{$ELSE}ControlCount{$ENDIF}) do
 begin
  if not D2Bridge.ObjectExported(Self.{$IFDEF FMX}Children{$ELSE}Controls{$ENDIF}[I]) then
  begin
   if D2Bridge.D2BridgeManager.SupportsVCLClass(Self.{$IFDEF FMX}Children{$ELSE}Controls{$ENDIF}[I].ClassType, false) then
    D2Bridge.Items.Add.VCLObj(Self.{$IFDEF FMX}Children{$ELSE}Controls{$ENDIF}[I]);
  end;
 end;
end;

procedure TD2BridgeForm.Close(ACloseParam: variant);
var
 vPopup: TD2BridgeItemHTMLPopup;
 I, J: integer;
 vBreak: boolean;
begin
 try
  if ACloseParam <> varNull then
   if FPopupsShowing.Count > 0 then
   begin
    for I := 0 to Pred(FPopupsShowing.Count) do
    begin
     if isNestedContext then
      vPopup:= D2Bridge.D2BridgeOwner.Popup(FPopupsShowing[I]) as TD2BridgeItemHTMLPopup
     else
      vPopup:= D2Bridge.Popup(FPopupsShowing[I]) as TD2BridgeItemHTMLPopup;

     if Assigned(vPopup) then
      for J := 0 to vPopup.Items.Items.Count-1 do
      if Supports(vPopup.Items.Items[I], ID2BridgeItemNested) then
       if (vPopup.Items.Items[I] as ID2BridgeItemNested).NestedFormName = NestedName then
       begin
        vBreak:= true;
        vPopup.CloseParam:= ACloseParam;
        Break;
       end;

     if vBreak then
      Break;
    end;

   end;
 except
 end;

 Close;
end;

procedure TD2BridgeForm.ClosePopup(AName: String);
var
 vCanClosePopup: Boolean;
begin
  if not Assigned(FOnClosePopup) then
  begin
   vCanClosePopup:= true;
   ClosePopup(AName, vCanClosePopup);
   if not vCanClosePopup then
    exit;
  end;

  if FPopupsShowing.Contains(AName) then
  FPopupsShowing.Remove(AName);

  D2Bridge.PrismSession.ExecJS('document.querySelector(''[id=BUTTONCLOSE_'+ AnsiUpperCase(AName) +' i]'').click();', true);
end;

procedure TD2BridgeForm.PageLoaded;
begin

end;

procedure TD2BridgeForm.PageResize;
begin

end;

procedure TD2BridgeForm.PopupClosed(const AName: string);
begin
end;

procedure TD2BridgeForm.PopupClosed(const AName: string; const ACloseParam: variant);
begin

end;

procedure TD2BridgeForm.PopupOpened(AName: string);
begin
end;


function TD2BridgeForm.PrismSession: TPrismSession;
begin
 {$IFDEF D2BRIDGE}
 Result:= D2Bridge.PrismSession;
 {$ELSE}
 result:= D2BridgeInstance.PrismSession as TPrismSession;
 {$ENDIF}
end;

function TD2BridgeForm.Session: TPrismSession;
begin
 {$IFDEF D2BRIDGE}
 Result:= D2Bridge.Session;
 {$ELSE}
 result:= D2BridgeInstance.Session as TPrismSession;
 {$ENDIF}
end;

procedure TD2BridgeForm.ShowMessage(const Msg: string);
begin
 {$IFDEF D2BRIDGE}
 MessageDlg(Msg, TMsgDlgType.mtInformation, [TMsgDlgBtn.mbok], 0);
 {$ELSE}
   {$IFDEF FMX}
 FMX.Dialogs.ShowMessage(Msg);
   {$ELSE}
 Dialogs.ShowMessage(Msg);
   {$ENDIF}
 {$ENDIF}
end;

procedure TD2BridgeForm.ShowMessage(const Msg: string; useToast: boolean; TimerInterval: integer = 4000; DlgType: TMsgDlgType = TMsgDlgType.mtInformation; ToastPosition: TToastPosition = ToastTopRight);
begin
 ShowMessage(Msg, useToast, false, TimerInterval, DlgType, ToastPosition);
end;

procedure TD2BridgeForm.ShowMessage(const Msg: string; useToast,
  ASyncMode: Boolean; TimerInterval: integer; DlgType: TMsgDlgType;
  ToastPosition: TToastPosition);
 {$IFDEF D2BRIDGE}
var
 vAlertType, vToastPosition, _MessageString: string;
 vPrimCallBackName, vPrismCallBackJS: String;
 ProcExecThread: TExecThread;
 vPrismCallBack: IPrismCallBack;
 vMSGTranslated: string;
 {$ENDIF}
begin
 {$IFDEF D2BRIDGE}
 vAlertType:= '';
 vPrimCallBackName:= '';
 vPrismCallBackJS:= '';
 vToastPosition:= '';
 vPrimCallBackName:= 'MessageDlg'+GenerateRandomString(30);

 if not useToast then
 begin
  MessageDlg(Msg, DlgType, [TMsgDlgBtn.mbok], 0);
 end else
 begin
  if not ASyncMode then
  begin
   ProcExecThread:= TExecThread.Create(Self, vPrimCallBackName);

   vPrismCallBack:= D2Bridge.PrismSession.ActiveForm.CallBacks.Register(vPrimCallBackName, ProcExecThread.FuncShowMessage);

   vPrismCallBackJS:= D2Bridge.PrismSession.ActiveForm.CallBacks.CallBackJS(vPrimCallBackName);
  end;


 vMSGTranslated:= Msg;
 (D2Bridge.FrameworkForm as TPrismForm).ProcessTagTranslate(vMSGTranslated);


  {$REGION 'Tipo de Alerta'}
   case DlgType of
    TMsgDlgType.mtWarning:
     vAlertType:= 'warning';
    TMsgDlgType.mtError:
     vAlertType:= 'error';
    TMsgDlgType.mtInformation:
     vAlertType:= 'success';
    TMsgDlgType.mtConfirmation:
     vAlertType:= 'question';
    TMsgDlgType.mtCustom:
     vAlertType:= 'information';
   end;
  {$ENDREGION}


  {$REGION 'Tipo de Alerta'}
   case ToastPosition of
    ToastTop:
     vToastPosition:= 'top';
    ToastTopLeft:
     vToastPosition:= 'top-start';
    ToastTopRight:
     vToastPosition:= 'top-end';
    ToastCenter:
     vToastPosition:= 'center';
    ToastCenterLeft:
     vToastPosition:= 'center-start';
    ToastCenterRight:
     vToastPosition:= 'center-end';
    ToastBottom:
     vToastPosition:= 'bottom';
    ToastBottomLeft:
     vToastPosition:= 'bottom-start';
    ToastBottomRight:
     vToastPosition:= 'bottom-end';
   end;
  {$ENDREGION}


  _MessageString:=
    'let _IsLockShowing = IsThreadClientLocked();                             '+
    'UnLockThreadClient();                                                    '+
    'setTimeout(function() {                                                  '+
    '   document.activeElement.blur();                                        '+
    '   document.body.focus();                                                '+
    '}, 1);                                                                   ';
    if not useToast then
    begin
     _MessageString:= _MessageString +
       'var modalElement = document.querySelector(''.modal'');                   '+
       'if (modalElement) {                                                      '+
       ' var currentModalZIndex = window.getComputedStyle(modalElement).zIndex;  '+
       ' modalElement.style.zIndex = 999;                                        '+
       '}                                                                        ';
    end;
    _MessageString:= _MessageString +
      'Swal.fire({                                                              '+
      '  icon: "' + vAlertType + '",                                            ';

  if not useToast then
  _MessageString:= _MessageString +
    '  html:  ' + FormatValueHTML(vMSGTranslated) + ',                       ';

  _MessageString:= _MessageString +
    '  title: ' + FormatValueHTML(vMSGTranslated) + ',                         '+
    '  toast: true,                                                           '+
    '  position: "' + vToastPosition + '",                                    ';
    if TimerInterval > 0 then
     _MessageString:= _MessageString +'  timer: ' + IntToStr(TimerInterval) + ',  ';
  _MessageString:= _MessageString +
    '  showConfirmButton: false,                                              '+
    '  timerProgressBar: true,                                                '+
    '  didOpen: (toast) => {                                                  '+
    '    toast.onmouseenter = Swal.stopTimer;                                 '+
    '    toast.onmouseleave = Swal.resumeTimer;                               '+
    '    toast.classList.add("sweetAlert2CloseButton");                       '+
    '  }                                                                      '+
    '}).then((result) => {                                                    ';
    if not useToast then
    begin
     _MessageString:= _MessageString +
       '  if (modalElement) {                                                    '+
       '    modalElement.style.zIndex = currentModalZIndex;                      '+
       ' }                                                                       '+
       '  if (_IsLockShowing === true) {                                         '+
       '    LockThreadClient();                                                  '+
       '  }                                                                      ';
    end;
    _MessageString:= _MessageString +
      '   '+ vPrismCallBackJS +'  '+
     '}); ';


  PrismSession.ExecJS(_MessageString, true);


  if not ASyncMode then
  begin
   D2Bridge.PrismSession.Lock(vPrimCallBackName);
   if (not Assigned(self)) or (not Assigned(D2Bridge)) or (D2Bridge.PrismSession.Destroying) or D2Bridge.PrismSession.Closing then
    Abort;
  end;


  if Assigned(vPrismCallBack) then
  begin
   vPrismCallBack:= nil; { #todo -c'Fix Lazarus RefCount' :  }
   D2Bridge.PrismSession.ActiveForm.CallBacks.Unregister(vPrimCallBackName);
  end;
 end;
 {$ELSE}
   {$IFDEF FMX}
 FMX.Dialogs.ShowMessage(Msg);
   {$ELSE}
 Dialogs.ShowMessage(Msg);
   {$ENDIF}
 {$ENDIF}
end;

function TD2BridgeForm.ShowCount: integer;
begin
 Result:= FShowCount;
end;

procedure TD2BridgeForm.ShowPopup(const AName: string; var CanShow: Boolean);
begin
 CanShow:= true;
end;

procedure TD2BridgeForm.ClosePopup(const AName: string; var CanClose: Boolean);
begin
 CanClose:= true;
end;

{$IFDEF D2BRIDGE}
procedure TD2BridgeForm.Show;
var
 vOtherFormInFront: Boolean;
 vActualForm: TD2BridgeForm;
begin
 vOtherFormInFront:= false;
 vActualForm:= nil;

 if Assigned(FD2Bridge.BaseClass.PrismSession.D2BridgeBaseClassActive) then
 begin
  vOtherFormInFront:= FD2Bridge.BaseClass.PrismSession.D2BridgeBaseClassActive <> FD2Bridge.BaseClass;
  vActualForm:= TD2BridgeForm(TD2Bridge(PrismSession.D2BridgeBaseClassActive).FormAOwner);
 end;

 if vOtherFormInFront then
  FD2Bridge.BaseClass.PrismSession.D2BridgeBaseClassActive:= FD2Bridge.BaseClass
 else
  if Assigned(FD2Bridge.BaseClass.PrismSession.D2BridgeBaseClassActive) then
   ((FD2Bridge.BaseClass.PrismSession.D2BridgeBaseClassActive as TD2Bridge).FrameworkForm as TPrismForm).onFormUnload;

 if not FShowing then
 begin
//  if Assigned(OnShow) then
//   OnShow(self);

  // Visible := True;
  //TThread.Synchronize(nil,
  //FD2Bridge.PrismSession.ExecThreadSynchronize(
//   procedure
//   begin
//    AlphaBlend:= true;
//    AlphaBlendValue:= 0;
//    Visible := True;
//    Inherited;
//   end
//  );
 end;

// FShowing:= true;

 if vOtherFormInFront then
  if Assigned(vActualForm) then
   if Assigned(vActualForm.OnDeactivate) then
    vActualForm.OnDeactivate(self);

 FD2Bridge.BaseClass.FrameworkForm.Show;


 if FShowing then
 begin
  //Visible:= false;
 end;
end;

function TD2BridgeForm.Showing: Boolean;
var
 vD2BridgeOwner: TD2BridgeClass;
begin
 Result:= false;

 if Assigned(D2Bridge) then
 begin
  if isNestedContext and Assigned(D2Bridge.D2BridgeOwner) then
  begin
   vD2BridgeOwner := D2Bridge.D2BridgeOwner;
   if Assigned(vD2BridgeOwner.D2BridgeOwner) then
   repeat
    vD2BridgeOwner := vD2BridgeOwner.D2BridgeOwner;
   until not Assigned(vD2BridgeOwner.D2BridgeOwner);

   result:= vD2BridgeOwner.BaseClass.FrameworkExportType.FormShowing and FShowing;
  end else
  if Assigned(D2Bridge.BaseClass.FrameworkExportType) then
  begin
   Result:= D2Bridge.BaseClass.FrameworkExportType.FormShowing;

   if (not Result) and (PrismSession.D2BridgeForms.Count > 1) then
   begin
    Result:= PrismSession.D2BridgeForms[PrismSession.D2BridgeForms.Count-2] = D2Bridge;
   end;


  end;
 end;
end;

function TD2BridgeForm.ShowModal: integer;
begin
 FShowingModal:= true;

 FModalResult:= 0;
 Result:= FModalResult;

 Show;

 Result:= FModalResult;
end;
{$ENDIF}

procedure TD2BridgeForm.ExportWithD2Bridge(const AD2Bridge: TD2Bridge);
var
 InstaceD2Bridge: TD2Bridge;
begin
 InstaceD2Bridge:= FD2Bridge;

 FD2Bridge:= AD2Bridge;

 Self.SetupD2Bridge;

 Self.ExportD2Bridge;

 FD2Bridge:= InstaceD2Bridge;
end;

function TD2BridgeForm.D2BridgeFormComponentHelperItems: TD2BridgeFormComponentHelperItems;
begin
{$IFDEF D2BRIDGE}
 Result:= FD2BridgeFormComponentHelperItems;
{$ENDIF}
end;

{$IFDEF D2BRIDGE}
function TD2BridgeForm.D2BridgeItems: TD2BridgeItems;
begin
 Result:= D2Bridge.Items as TD2BridgeItems;
end;
{$ENDIF}

procedure TD2BridgeForm.DoShow;
begin
 Inc(FShowCount);

 {$IFDEF D2BRIDGE}

 if not FShowing then
 if isNestedContext then
 begin
  try
   if Assigned(OnShow) then
    OnShow(Self);
  except
  on E: Exception do
   try
    PrismSession.DoException(self as TObject, E, 'FormOnShow');
   except
   end;
  end;

  (D2Bridge.FrameworkForm as TPrismForm).OnAfterPageLoad(nil);
  (D2Bridge.FrameworkForm as TPrismForm).UpdateControls;
 end;


 FShowing:= true;

 {$ELSE}
 BeginTagHTML;
 EndTagHTML;

 inherited;
 {$ENDIF}
end;


procedure TD2BridgeForm.DoTagHTML(const TagString: string;
  var ReplaceTag: string);
begin
 if Assigned(FOnTagHTML) then
  FOnTagHTML(TagString, ReplaceTag);

 TagHTML(TagString, ReplaceTag);
end;

procedure TD2BridgeForm.DoTagTranslate(const Language: TD2BridgeLang; const AContext, ATerm: string; var ATranslated: string);
begin
 if D2Bridge.LangAPPIsPresent then
  ATranslated:= D2Bridge.LangAPP.Language.Translate(AContext, ATerm);

 if ATranslated = '' then
  TagTranslate(Language, AContext, ATerm, ATranslated);
end;

procedure TD2BridgeForm.DoUpdateD2BridgeControls(
  const APrismControl: TPrismControl);
begin
 UpdateD2BridgeControls(APrismControl);
end;

procedure TD2BridgeForm.DoUpload(AFiles: TStrings; Sender: TObject);
begin
 if Assigned(FOnUpload) then
  FOnUpload(AFiles, Sender)
 else
  Upload(AFiles, Sender);
end;

{$IFDEF VCL}
procedure TD2BridgeForm.Activate;
begin
{$IFDEF D2BRIDGE}
 PrismSession.ExecThread(false,
   Exec_Activate
 );
  //inherited;
{$ELSE}
inherited;
{$ENDIF}
end;
{$ENDIF}


procedure TD2BridgeForm.BeginRenderD2Bridge(const PrismControl: TPrismControl);
begin

end;

procedure TD2BridgeForm.BeginRender;
begin

end;

procedure TD2BridgeForm.BeginTagHTML;
begin

end;

procedure TD2BridgeForm.BeginTranslate(const Language: TD2BridgeLang);
begin

end;

procedure TD2BridgeForm.BeginUpdateD2BridgeControls;
begin

end;

procedure TD2BridgeForm.CallBack(const CallBackName: String; EventParams: TStrings);
begin

end;

{$IFDEF D2BRIDGE}
function TD2BridgeForm.CallBackClose(EventParams: TStrings): string;
begin
 result:= '';

 Close;
end;

function TD2BridgeForm.CallBackCloseSession(EventParams: TStrings): string;
begin
 result:= '';

 PrismSession.Close;
end;

function TD2BridgeForm.CallBackHome(EventParams: TStrings): string;
begin
 result:= '';

 (PrismSession.PrimaryForm as TD2BridgeForm).Show;
end;
{$ENDIF}

function TD2BridgeForm.CallBacks: IPrismFormCallBacks;
begin
 //Result:= TD2BridgePrismForm(D2Bridge.FrameworkForm).CallBacks;
 Result:= FD2Bridge.CallBacks;
end;

procedure TD2BridgeForm.CellButtonClick(APrismStringGrid: TPrismStringGrid; APrismCellButton: TPrismGridColumnButton; AColIndex: Integer; ARow: Integer);
begin

end;

{$IFNDEF FMX}
procedure TD2BridgeForm.CardGridClick(PrismControlClick: TPrismControl; ARow: Integer; APrismCardGrid: TPrismCardGridDataModel);
begin

end;

procedure TD2BridgeForm.CellButtonClick(APrismDBGrid: TPrismDBGrid; APrismCellButton: TPrismDBGridColumnButton; AColIndex: Integer; ARow: Integer);
begin

end;
{$ENDIF}

procedure TD2BridgeForm.Clear;
begin
 FD2Bridge.HTML.Render.Clear;
end;

{$IFDEF D2BRIDGE}
function TD2BridgeForm.Clipboard: TPrismClipboard;
begin
 result:= D2Bridge.PrismSession.Clipboard as TPrismClipboard;
end;
{$ENDIF}

{$IFDEF D2BRIDGE}
{$IFNDEF FMX}
procedure TD2BridgeForm.Close;
var
  CloseAction: TCloseAction;
begin
  if fsModal in FFormState then
    ModalResult := mrCancel
  else
    if CloseQuery then
    begin
      if FormStyle = fsMDIChild then
        if biMinimize in BorderIcons then
          CloseAction := caMinimize else
          CloseAction := caNone
      else
        CloseAction := caHide;
      DoClose(CloseAction);
    end;

 //inherited;
// if Assigned(OnDeactivate) then
//  OnDeactivate(Self);

// DoHide;
end;

{$ELSE}
function TD2BridgeForm.Close: TCloseAction;
begin
 if Assigned(OnDeactivate) then
  OnDeactivate(Self);
 {$IFDEF VER11}
  //inherited;
 {$ELSE}
  //inherited Close;
 {$ENDIF}
end;
{$ENDIF}
{$ENDIF}

{$IFDEF D2BRIDGE}
constructor TD2BridgeForm.Create(AOwner: TComponent; Session: TPrismSession);
begin
 {$IFDEF D2BRIDGE}
  FD2Bridge:= TD2Bridge.Create(Self);
  FD2Bridge.PrismSession:= Session;
  FD2Bridge.PrismSession.D2BridgeBaseClassActive:= FD2Bridge.BaseClass;
 {$ENDIF}

 try
  {$IFDEF D2BRIDGE}
  Session.ExecThread(True,
   Exec_CreateFromOwner,
   TValue.From<TComponent>(AOwner),
   TValue.From<TPrismSession>(Session),
   PrismBaseClass.Options.UseMainThread
  );
//  FD2Bridge.PrismSession.ExecThreadSynchronize(True,
//   procedure
//   begin
//    inherited CreateNew(AOwner);
//    InitInheritedComponent(self, TForm);
//   end
//  );
//  Exec_CreateFromOwner(AOwner);
  {$ELSE}
  Inherited Create(AOwner);
  {$ENDIF}
 except
  {$IFDEF D2BRIDGE}
   on E: Exception do
   PrismSession.DoException(self as TObject, E, 'OnCreate');
  {$ENDIF}
 end;

 {$IFDEF D2BRIDGE}
  Session.ExecThread(True,
   CreateD2BridgeForm
  );
 {$ENDIF}
end;

procedure TD2BridgeForm.CreateD2BridgeForm;
var
 I: Integer;
 vVisible: boolean;
begin
 FD2BridgeFormComponentHelperItems:= TD2BridgeFormComponentHelperItems.Create(self);
 FShowing:= false;
 FShowingModal:= false;
 FDestroyForm:= false;
 FActive:= true;

 FUsedD2BridgeInstance:= false;

 FPopupsShowing:= TList<string>.Create;

 System.Initialize(FTemplateClassForm);

 if not Assigned(FD2Bridge) then
 FD2Bridge:= TD2Bridge.Create(Self);

// for I := 0 to ComponentCount-1 do
// if Components[I] is TComboBox then
//  TCombobox(Components[I]).CreateInterceptedCombobox;

 {$IFNDEF FMX}
 for I := 0 to ComponentCount-1 do
 if Components[I] is TTabSheet then
 begin
  vVisible:= TTabSheet(Components[I]).TabVisible;
  Components[I].Tag:= NativeInt(FD2BridgeFormComponentHelperItems.PropValues(Components[I]));
  TD2BridgeFormComponentHelper(Components[I].Tag).Value['TabVisible']:= vVisible;
 end;
 {$ENDIF}

 //Chama o OnCreate
 try
  if Assigned(OnCreate) then
   OnCreate(Self);
 except
  on E: Exception do
  PrismSession.DoException(self as TObject, E, 'OnCreate');
 end;

 //Aqui é o Setup
 try
  SetupD2Bridge;
 except
  on E: Exception do
   PrismSession.DoException(self as TObject, E, 'SetupD2Bridge');
 end;

 //Exporta os Controles
 try
  self.ExportD2Bridge;
 except
  on E: Exception do
   PrismSession.DoException(self as TObject, E, 'ExportD2Bridge');
 end;


 //Configura o Form que vai receber os controles
 try
  if GetTemplateClassForm <> nil then
  begin
   FD2Bridge.BaseClass.FrameworkExportType.AddFormByClass(GetTemplateClassForm, self);
  end else
  if FTemplateClassForm <> nil then
  begin
   FD2Bridge.BaseClass.FrameworkExportType.AddFormByClass(FTemplateClassForm, self);
  end else
  if not Assigned(FD2Bridge.BaseClass.Form) then
  begin
   FD2Bridge.BaseClass.FrameworkExportType.CreateForm(self);
  end;
 except
  on E: Exception do
  PrismSession.DoException(self as TObject, E, 'CreateFrameworkForm');
 end;

 try
  (FD2Bridge.FrameworkForm as TPrismForm).DoExportD2Bridge;
  (FD2Bridge.FrameworkForm as TPrismForm).DoExportD2Bridge(FD2Bridge);
 except
  on E: Exception do
   PrismSession.DoException(self as TObject, E, 'ExportD2Bridge');
 end;

 //Register PrismControls created without prism form
 try
  if D2Bridge.PrismControlToRegister.Count > 0 then
   for I := 0 to Pred(D2Bridge.PrismControlToRegister.Count) do
    (D2Bridge.FrameworkForm as TPrismForm).AddControl(D2Bridge.PrismControlToRegister[I]);
except
 end;

// //Renderiza o Form
// FD2Bridge.RenderD2Bridge(FD2Bridge.Items.Items);

 //Check Temp CallBacks to Register
 if Supports(FD2Bridge.TempCallBacks, IPrismFormCallBacks) and
    (FD2Bridge.TempCallBacks <> nil) and
    (FD2Bridge.TempCallBacks.TempCallBacks <> nil) and
    (FD2Bridge.TempCallBacks.TempCallBacks.Count > 0) then
 begin
  FD2Bridge.TempCallBacks.ConsolideTempCallBacks(FD2Bridge.FrameworkForm as IPrismForm);
 end;

 RegisterStaticCallBacks;
end;

procedure TD2BridgeForm.RegisterStaticCallBacks;
begin
 CallBacks.Register('CallBackClose', CallBackClose);
 CallBacks.Register('CallBackCloseSession', CallBackCloseSession);
 CallBacks.Register('CallBackHome', CallBackHome);
end;
{$ENDIF}

//procedure TD2BridgeForm.CreateInstance(D2BridgeForm: TD2BridgeFormClass);
//begin
// TD2BridgeInstance(D2Bridge.PrismSession.D2BridgeInstance).AddInstace(D2BridgeForm.Create(D2Bridge.PrismSession));
//end;

procedure TD2BridgeForm.CreateInstance(FormClass: TFormClass);
begin
{$IFDEF D2BRIDGE}
 TD2BridgeInstance(FD2Bridge.PrismSession.D2BridgeInstance).AddInstace(FormClass.Create(FD2Bridge.PrismSession))
{$ELSE}
 D2BridgeInstance.CreateInstance(FormClass);
{$ENDIF}
end;

procedure TD2BridgeForm.CreateInstance(D2BridgeFormClass: TD2BridgeFormClass);
begin
{$IFDEF D2BRIDGE}
 PrismSession.ExecThread(true,
  Exec_CreateInstanceFormClass,
  TValue.From<TD2BridgeFormClass>(D2BridgeFormClass),
  PrismBaseClass.Options.UseMainThread
 );
{$ELSE}
 D2BridgeInstance.CreateInstance(D2BridgeFormClass);
{$ENDIF}
end;

class procedure TD2BridgeForm.CreateInstance;
var
 vD2BridgeInstance: TD2BridgeInstance;
begin
{$IFDEF D2BRIDGE}
 vD2BridgeInstance:= D2BridgeInstance;

 if Assigned(vD2BridgeInstance) then
 begin
  D2BridgeInstance.PrismSession.ExecThread(true,
   Exec_CreateInstance,
   TValue.From<TPrismSession>(vD2BridgeInstance.PrismSession as TPrismSession),
   PrismBaseClass.Options.UseMainThread
  );
 end else
  Abort;
{$ELSE}
 vD2BridgeInstance := D2BridgeInstance;
 vD2BridgeInstance.CreateInstance(self);
{$ENDIF}
end;

constructor TD2BridgeForm.CreateInstance(AOwner: TPrismSession);
begin
 {$IFDEF D2BRIDGE}
  FD2Bridge:= TD2Bridge.Create(Self);
  FD2Bridge.PrismSession:= AOwner;
 {$ENDIF}

 try
  {$IFDEF D2BRIDGE}
  inherited CreateNew(AOwner);
  (AOwner.D2BridgeInstance as TD2BridgeInstance).AddInstace(self);
  InitInheritedComponent(self, TForm);
  {$ELSE}
  Inherited Create(AOwner);
  {$ENDIF}
 except
  {$IFDEF D2BRIDGE}
   on E: Exception do
   PrismSession.DoException(self as TObject, E, 'OnCreate');
  {$ENDIF}
 end;

 {$IFDEF D2BRIDGE}
  AOwner.ExecThread(true,
   CreateD2BridgeForm
  );
 {$ENDIF}
end;

{$IFDEF D2BRIDGE}
procedure TD2BridgeForm.Exec_Create(varD2BridgeFormOwner: TValue);
var
 vD2BridgeForm: TD2BridgeForm;
begin
 try
  vD2BridgeForm:= varD2BridgeFormOwner.AsObject as TD2BridgeForm;

  InternalCreate(vD2BridgeForm);
 except
  Abort;
 end;
end;

procedure TD2BridgeForm.Exec_CreateFromOwner(varOwner, varPrismSession: TValue);
var
 vOwner: TComponent;
 vPrismSession: TPrismSession;
begin
 try
  vOwner:= varOwner.AsObject as TComponent;
  vPrismSession:= varPrismSession.AsObject as TPrismSession;

  inherited CreateNew(TPrismSession(vOwner));

  (vPrismSession.D2BridgeInstance as TD2BridgeInstance).AddInstace(self);

  InitInheritedComponent(self, TForm);
 except
 end;
end;

class procedure TD2BridgeForm.Exec_CreateInstance(varPrismSession: TValue);
var
 vPrismSession: TPrismSession;
begin
 try
  vPrismSession:= varPrismSession.AsObject as TPrismSession;
  //(vPrismSession.D2BridgeInstance as TD2BridgeInstance).AddInstace(self.Create(vPrismSession));
  CreateInstance(vPrismSession);
 except
 end;
end;

procedure TD2BridgeForm.Exec_CreateInstanceFormClass(varD2BridgeFormClass: TValue);
var
 vD2BridgeFormClass: TD2BridgeFormClass;
begin
 try
  vD2BridgeFormClass:= TD2BridgeFormClass(varD2BridgeFormClass.AsClass);

  TD2BridgeInstance(FD2Bridge.PrismSession.D2BridgeInstance).AddInstace(vD2BridgeFormClass.Create(FD2Bridge.PrismSession));
 except
  abort;
 end;
end;
{$ENDIF}

function TD2BridgeForm.CSSClass: TCSSClass;
begin
 result:= D2Bridge.CSSClass;
end;

//class procedure TD2BridgeForm.CreateInstance(D2BridgeInstance: TD2BridgeInstance);
//begin
// D2BridgeInstance.CreateInstance(Self);
//end;

//constructor TD2BridgeForm.CreateInstance;
//begin
//  FD2Bridge:= TD2Bridge.Create(Self);
//  FD2Bridge.PrismSession:= AOwner.D2Bridge.PrismSession;
//
// Inherited Create(TComponent(AOwner));
//
//  CreateD2BridgeForm;
//
//
//
//   vForm:= Create(TD2BridgeInstance(TPrismContext.GetCurrent.GetSession.D2BridgeInstance).Owner, TPrismSession(TPrismContext.GetCurrent.GetSession));
//   vForm.FUsedD2BridgeInstance:= True;
//   TD2BridgeInstance(TPrismContext.GetCurrent.GetSession.D2BridgeInstance).AddInstace(vForm);
//end;

constructor TD2BridgeForm.Create(AOwner: TD2BridgeInstance);
begin
 {$IFDEF D2BRIDGE}
  FD2Bridge:= TD2Bridge.Create(Self);
  FD2Bridge.PrismSession:= AOwner.PrismSession as TPrismSession;
 {$ENDIF}

  try
   {$IFDEF D2BRIDGE}
   inherited CreateNew(AOwner.Owner);
   InitInheritedComponent(self, TForm);
   {$ELSE}
   inherited Create(AOwner.Owner);
   {$ENDIF}
  except
  {$IFDEF D2BRIDGE}
   on E: Exception do
   PrismSession.DoException(self as TObject, E, 'OnCreate');
  {$ENDIF}
  end;

 {$IFDEF D2BRIDGE}
  AOwner.PrismSession.ExecThread(true,
   CreateD2BridgeForm
  );
 {$ENDIF}
end;

procedure TD2BridgeForm.CreateInstance(DataModuleClass: TDataModuleClass);
begin
 TD2BridgeInstance(FD2Bridge.PrismSession.D2BridgeInstance).CreateInstance(DataModuleClass);
end;

constructor TD2BridgeForm.Create(AOwner: TPrismSession);
begin
 {$IFDEF D2BRIDGE}
  FD2Bridge:= TD2Bridge.Create(Self);
  FD2Bridge.PrismSession:= AOwner;
 {$ENDIF}

 try
  {$IFDEF D2BRIDGE}
  inherited CreateNew(AOwner);
  InitInheritedComponent(self, TForm);
  {$ELSE}
  Inherited Create(AOwner);
  {$ENDIF}
 except
  {$IFDEF D2BRIDGE}
   on E: Exception do
   PrismSession.DoException(self as TObject, E, 'OnCreate');
  {$ENDIF}
 end;

 {$IFDEF D2BRIDGE}
 AOwner.ExecThread(true,
  CreateD2BridgeForm
 );
 {$ENDIF}
end;

constructor TD2BridgeForm.Create(AOwner: TD2BridgeForm);
begin
 {$IFDEF D2BRIDGE}
  FD2Bridge:= TD2Bridge.Create(Self);
  FD2Bridge.PrismSession:= AOwner.D2Bridge.PrismSession;
 {$ENDIF}

 {$IFDEF D2BRIDGE}
 //The use of ExecThread is because TCombobox freeze
 //all instance *BUG VCL*
  FD2Bridge.PrismSession.ExecThread(True,
   Exec_Create,
   TValue.From<TD2BridgeForm>(AOwner),
   PrismBaseClass.Options.UseMainThread
  );
  //inherited CreateNew(TComponent(AOwner));
  //InitInheritedComponent(self, TForm);
 {$ELSE}
  Inherited Create(TComponent(AOwner));
 {$ENDIF}

 {$IFDEF D2BRIDGE}
 FD2Bridge.PrismSession.ExecThread(true,
  CreateD2BridgeForm
 );
 {$ENDIF}
end;

//class procedure TD2BridgeForm.CreateInstance(AOwner: TD2BridgeForm);
//begin
// //TD2BridgeInstance(AOwner.D2Bridge.PrismSession.D2BridgeInstance).CreateInstance(self);
// TD2BridgeInstance(AOwner.D2Bridge.PrismSession.D2BridgeInstance).AddInstace(Create(AOwner));
//end;

//class Procedure TD2BridgeForm.CreateInstance(AForm: TForm);
//begin
// D2BridgeInstance.CreateInstance(Self);
//end;

class function TD2BridgeForm.GetInstance: TD2BridgeForm;
begin
 result:= TD2BridgeForm(D2BridgeInstance.GetInstance(self));

// if TPrismContext.GetCurrent <> nil then
// begin
//  Result:= TD2BridgeForm(TD2BridgeInstance(TPrismContext.GetCurrent.GetSession.D2BridgeInstance).GetInstance(self));
// end else
// begin
//  Result:= nil;
//  raise Exception.Create('Contexto não encontrado - ERROR 1966-1');
// end;
end;

function TD2BridgeForm.GetLanguage: TD2BridgeLang;
begin
 Result:= D2Bridge.PrismSession.Language;
end;

{$IFDEF D2BRIDGE}
function TD2BridgeForm.GetModalResult: integer;
begin
 Result:= FModalResult;
end;
{$ENDIF}

function TD2BridgeForm.GetNestedName: string;
begin
 if FNestedName <> '' then
  Result:= FNestedName
 else
  Result:= Name;
end;

function TD2BridgeForm.GetPopupName: string;
begin
 Result := FPopupName;
end;

function TD2BridgeForm.GetSubTitle: String;
begin
 result:= FSubTitle;
end;

function TD2BridgeForm.GetTemplateClassForm: TClass;
begin
 result:= FTemplateClassForm;
end;

function TD2BridgeForm.GetTitle: String;
begin
 result:= FTitle;
end;

{ TD2BridgeForm.TD2CustomCombobox }

{$IFDEF D2BRIDGE}
{$IFnDEF FPC}
function THelperCombobox.GetItemIndex: Integer;
begin
 CheckInstanceHelper;

 if TagIsD2BridgeFormComponentHelper(Tag) then
 begin
  Result:= TD2BridgeFormComponentHelper(Tag).Value['ItemIndex'].AsInteger;
 end else
  Result:= inherited {$IFNDEF FMX}GetItemIndex{$ELSE}ItemIndex{$ENDIF};
end;

procedure THelperCombobox.SetItemIndex(Val: Integer);
begin
 CheckInstanceHelper;

 if TagIsD2BridgeFormComponentHelper(Tag) then
 begin
  TD2BridgeFormComponentHelper(Tag).Value['ItemIndex']:= Val;
 end else
  inherited {$IFNDEF FMX}SetItemIndex(Val){$ELSE}ItemIndex:= Val{$ENDIF};
end;

function THelperCombobox.GetText: String;
begin
// if self.ClassType = TCombobox then
//  result:= inherited Text
// else
// begin
//  if ItemIndex < 0 then
//  ItemIndex:= 0;
//  Result:= Items[ItemIndex];
// end;

Result:= '';

if ItemIndex >= 0 then
 Result:= Items[ItemIndex];
end;

procedure THelperCombobox.InstanceHelper;
var
 vItems: TStrings;
 vD2BridgeForm: TD2BridgeForm;
begin
  if Owner is TD2BridgeForm then
  begin
   vD2BridgeForm:= TD2BridgeForm(Owner);

   Tag := NativeInt(vD2BridgeForm.D2BridgeFormComponentHelperItems.PropValues(Self));

   if not TagIsD2BridgeFormComponentHelper(tag, 'Items') then
   begin
    vItems:= TStringList.Create;

    TD2BridgeFormComponentHelper(Tag).Value['Items']:= vItems;

    vItems.Text:= inherited Items.Text;
   end;

   if not TagIsD2BridgeFormComponentHelper(tag, 'ItemIndex') then
   begin
    TD2BridgeFormComponentHelper(Tag).Value['ItemIndex']:= inherited {$IFNDEF FMX}GetItemIndex{$ELSE}ItemIndex{$ENDIF};
   end;
 end;
end;

procedure THelperCombobox.SetText(AText: String);
begin
 CheckInstanceHelper;

 if (Items.IndexOf(AText) < 0) then
 begin
  if AText <> '' then
  begin
   Items.Add(AText);
   ItemIndex:= Items.IndexOf(AText)
  end else
   ItemIndex:= -1;
 end else
  ItemIndex:= Items.IndexOf(AText)
end;

procedure THelperCombobox.CheckInstanceHelper;
begin
 if not TagIsD2BridgeFormComponentHelper(Tag) then
  TPrismSessionThreadProc.Create(nil, InstanceHelper, true, true).Exec;
end;

procedure THelperCombobox.Clear;
begin
 CheckInstanceHelper;

 if TagIsD2BridgeFormComponentHelper(Tag) then
 begin
  (TD2BridgeFormComponentHelper(Tag).Value['Items'].AsObject as TStrings).Clear;
  ItemIndex:= -1;
 end else
  inherited Clear;
end;

//function THelperCombobox.InterceptedCombobox: TInterceptedCombobox;
//var
// I: Integer;
// vExist: Boolean;
//begin
// vExist:= false;
//
// for I := 0 to Length(TD2BridgeForm(Owner).FArrayCombobox)-1 do
// begin
//  if TD2BridgeForm(Owner).FArrayCombobox[I].Name = Name then
//  begin
//   vExist:= true;
//   Result:= TD2BridgeForm(Owner).FArrayCombobox[I];
//   Break;
//  end;
// end;
//
// if not vExist then
// begin
//  CreateInterceptedCombobox;
//  Result:= InterceptedCombobox;
// end;
//end;

procedure THelperCombobox.SetHelperItems(AItems: TStrings);
begin
 CheckInstanceHelper;

 if TagIsD2BridgeFormComponentHelper(Tag) then
 begin
  TD2BridgeFormComponentHelper(Tag).Value['Items']:= AItems;
 end else
  inherited Items:= AItems;
end;

function THelperCombobox.GetHelperItems: TStrings;
begin
 CheckInstanceHelper;

 if TagIsD2BridgeFormComponentHelper(Tag) then
 begin
  Result:= TD2BridgeFormComponentHelper(Tag).Value['Items'].AsObject as TStrings;
 end else
  Result:= inherited Items;
end;
{$ENDIF}

{$IFDEF FMX}
function THelperComboEdit.GetItemIndex: Integer;
begin
 if TagIsD2BridgeFormComponentHelper(Tag) then
 begin
  Result:= TD2BridgeFormComponentHelper(Tag).Value['ItemIndex'].AsInteger;
 end else
  Result:= inherited ItemIndex;
end;

procedure THelperComboEdit.SetItemIndex(AItemIndexValue: Integer);
begin
 if TagIsD2BridgeFormComponentHelper(Tag) then
 begin
  TD2BridgeFormComponentHelper(Tag).Value['ItemIndex']:= AItemIndexValue;
 end else
  inherited ItemIndex := AItemIndexValue;
end;

function THelperComboEdit.GetText: String;
begin
// if self.ClassType = TCombobox then
//  result:= inherited Text
// else
// begin
//  if ItemIndex < 0 then
//  ItemIndex:= 0;
//  Result:= Items[ItemIndex];
// end;
 if ItemIndex >= 0 then
  Result:= Items[ItemIndex];
end;

procedure THelperComboEdit.SetText(AText: String);
begin
 if Items.IndexOf(AText) < 0 then
 begin
  Items.Add(AText);
  ItemIndex:= Items.IndexOf(AText)
 end else
  ItemIndex:= Items.IndexOf(AText)
end;

procedure THelperComboEdit.Clear;
begin
 if TagIsD2BridgeFormComponentHelper(Tag) then
 begin
  (TD2BridgeFormComponentHelper(Tag).Value['Items'].AsObject as TStrings).Clear;
  ItemIndex:= -1;
 end else
  inherited Clear;
end;

//procedure THelperComboEdit.CreateInterceptedCombobox;
//begin
// SetLength(TD2BridgeForm(Owner).FArrayCombobox, Length(TD2BridgeForm(Owner).FArrayCombobox) + 1);
//
// TD2BridgeForm(Owner).FArrayCombobox[Length(TD2BridgeForm(Owner).FArrayCombobox)-1]:= TInterceptedCombobox.Create(self);
// TD2BridgeForm(Owner).FArrayCombobox[Length(TD2BridgeForm(Owner).FArrayCombobox)-1].Name:= Name;
//
//// TThread.Synchronize(TThread.CurrentThread,
////  procedure
////  begin
//   TD2BridgeForm(Owner).FArrayCombobox[Length(TD2BridgeForm(Owner).FArrayCombobox)-1].Items.CommaText:= inherited Items.CommaText;
////  end
//// );
//
// TD2BridgeForm(Owner).FArrayCombobox[Length(TD2BridgeForm(Owner).FArrayCombobox)-1].ItemIndex:= inherited ItemIndex;
// TD2BridgeForm(Owner).FArrayCombobox[Length(TD2BridgeForm(Owner).FArrayCombobox)-1].Text:= inherited Text;
//end;
//
//function THelperComboEdit.InterceptedCombobox: TInterceptedCombobox;
//var
// I: Integer;
// vExist: Boolean;
//begin
// vExist:= false;
//
// for I := 0 to Length(TD2BridgeForm(Owner).FArrayCombobox)-1 do
// begin
//  if TD2BridgeForm(Owner).FArrayCombobox[I].Name = Name then
//  begin
//   vExist:= true;
//   Result:= TD2BridgeForm(Owner).FArrayCombobox[I];
//   Break;
//  end;
// end;
//
// if not vExist then
// begin
//  CreateInterceptedCombobox;
//  Result:= InterceptedCombobox;
// end;
//end;

procedure THelperComboEdit.SetHelperItems(AItems: TStrings);
begin
 if TagIsD2BridgeFormComponentHelper(Tag) then
 begin
  TD2BridgeFormComponentHelper(Tag).Value['Items']:= AItems;
 end else
  inherited Items:= AItems;
end;

function THelperComboEdit.GetHelperItems: TStrings;
begin
 if TagIsD2BridgeFormComponentHelper(Tag) then
 begin
  Result:= TD2BridgeFormComponentHelper(Tag).Value['Items'].AsObject as TStrings;
 end else
  Result:= inherited Items;
end;
{$ENDIF}


//{ TD2BridgeHelperEdit }
//
//procedure TD2BridgeHelperEdit.SelectAll;
//begin
//
//end;



{ TD2BridgeForm.TD2BridgeInstanceHelper }

//procedure TD2BridgeForm.TD2BridgeInstanceHelper.SetD2Bridge(
//  AD2Bridge: TD2Bridge);
//begin
// FD2Bridge:= AD2Bridge;
//end;



{ TD2BridgeHelperWinControl }

procedure TD2BridgeHelperWinControl.SetFocus;
var
 vPrismControl: TPrismControl;
begin
 vPrismControl:= (PrismSession.D2BridgeBaseClassActive as TD2BridgeClass).PrismControlFromVCLObj(self) as TPrismControl;
 if Assigned(vPrismControl) then
  vPrismControl.SetFocus;
end;



{ TInterceptedCombobox }

//constructor TInterceptedCombobox.Create(AOwner: TComponent);
//begin
// inherited;
//
// Items:= TStringList.Create;
//end;
//
//destructor TInterceptedCombobox.Destroy;
//begin
// FreeAndNil(Items);
//
// inherited;
//end;

{ TD2BridgeHelperCustomEdit }

procedure TD2BridgeHelperCustomEdit.Clear;
begin
 Self.Text:= '';
end;

{ TApplicationHelper }
{$IFNDEF FMX}
function TApplicationHelper.MessageBox(const Text, Caption: PChar; Flags: Longint): Integer;
begin
 Result:= D2BridgeInstance.PrismSession.MessageBox(Text, Caption, Flags);
end;
{$ENDIF}

{ TD2BridgeHelperField }

//procedure TD2BridgeHelperField.FocusControl;
//begin
// inherited;
//
//end;



{ TTabSheetHelper }
{$IFNDEF FMX}
 function TTabSheetHelper.GetTableVisible: Boolean;
 var
   RttiContext: TRttiContext;
   RttiType: TRttiType;
   RttiProperty: TRttiProperty;
 begin
  Result:= False;

  if (not (csDestroying in Self.ComponentState)) and
     (Tag <> 0) and
     (TObject(Tag) is TD2BridgeFormComponentHelper) then
   result:= TD2BridgeFormComponentHelper(Tag).Value['TabVisible'].AsBoolean
  else
  begin
   RttiContext := TRttiContext.Create;
   try
     RttiType := RttiContext.GetType(self.ClassType);

     RttiProperty := RttiType.GetProperty('TabVisible');

     if Assigned(RttiProperty) and (RttiProperty.Visibility = mvPublished) then
     begin
       result := RttiProperty.GetValue(self).AsBoolean;
     end;
   finally
     RttiContext.Free;
   end;
  end;
 end;

 procedure TTabSheetHelper.SetTabVisible(Value: Boolean);
 begin
  if (not (csDestroying in Self.ComponentState)) and
     (Tag <> 0) and
     (TObject(Tag) is TD2BridgeFormComponentHelper) then
  begin
   if TD2BridgeFormComponentHelper(Tag).Value['TabVisible'].AsBoolean <> Value then
   begin
    if Value then
    begin
     try
      if Assigned(OnShow) then
       OnShow(self);
     except
     on E: Exception do
      try
       PrismSession.DoException(self as TObject, E, 'TabOnShow');
      except
      end;
     end;
    end else
    try
     if Assigned(OnHide) then
      OnHide(self);
    except
    on E: Exception do
     try
      PrismSession.DoException(self as TObject, E, 'TabOnHide');
     except
     end;
    end;

    TD2BridgeFormComponentHelper(Tag).Value['TabVisible']:= Value;
   end;
  end else
   inherited TabVisible := Value;
 end;
 {$ENDIF}

{ THelperMemo }

{$IFnDEF FPC}
procedure THelperMemo.CheckInstanceHelper;
begin
 if not TagIsD2BridgeFormComponentHelper(Tag) then
  TPrismSessionThreadProc.Create(nil, InstanceHelper, true, true).Exec;
end;

procedure THelperMemo.Clear;
begin
 Lines.Clear;
end;

function THelperMemo.GetHelperLines: TStrings;
begin
 CheckInstanceHelper;

 if TagIsD2BridgeFormComponentHelper(Tag) then
 begin
  Result:= TD2BridgeFormComponentHelper(Tag).Value['Lines'].AsObject as TStrings;
 end else
 begin
  Result:= inherited Lines;
 end;
end;

function THelperMemo.GetHelperText: String;
begin
 CheckInstanceHelper;

 if TagIsD2BridgeFormComponentHelper(Tag) then
 begin
  Result:= (TD2BridgeFormComponentHelper(Tag).Value['Lines'].AsObject as TStrings).Text;
 end else
 begin
  result:= inherited Text;
 end;
end;


procedure THelperMemo.InstanceHelper;
var
 vItems: TStrings;
 vD2BridgeForm: TD2BridgeForm;
begin
  if Owner is TD2BridgeForm then
  begin
   vD2BridgeForm:= TD2BridgeForm(Owner);

   Tag := NativeInt(vD2BridgeForm.D2BridgeFormComponentHelperItems.PropValues(Self));

   if not TagIsD2BridgeFormComponentHelper(tag, 'Lines') then
   begin
    vItems:= TStringList.Create;

    TD2BridgeFormComponentHelper(Tag).Value['Lines']:= vItems;

    vItems.Text:= inherited Lines.Text;
   end;
 end;
end;

procedure THelperMemo.SetHelperLines(const Value: TStrings);
begin
 CheckInstanceHelper;

 if TagIsD2BridgeFormComponentHelper(Tag) then
 begin
  TD2BridgeFormComponentHelper(Tag).Value['Lines']:= Value;
 end else
  inherited Lines:= Value;
end;

procedure THelperMemo.SetHelperText(const Value: String);
begin
 CheckInstanceHelper;

 if TagIsD2BridgeFormComponentHelper(Tag) then
 begin
  (TD2BridgeFormComponentHelper(Tag).Value['Lines'].AsObject as TStrings).Text:= Value;
 end else
  inherited Text:= Value;
end;
{$ENDIF}

{$IFDEF VCL}
{ TWinControlHelper }

procedure TWinControlHelper.ClearHandle;
begin
  if Self <> nil then
    WindowHandle:= 0;
end;
{$ENDIF}

{------------------------------ TD2BridgeThreadTimer ------------------------------}

constructor TD2BridgeThreadTimer.Create;
begin
  fsInterval:= 100;
  fsEnabled:= False;
  fsOnTimer:= nil;
  fsEvent:= TSimpleEvent.Create;

  inherited Create(False);
end;

destructor TD2BridgeThreadTimer.Destroy;
begin
  fsEnabled:= False;
  Terminate;
  fsEvent.SetEvent;  // libera Event.WaitFor()
  if not Terminated then
    WaitFor;

  fsEvent.Free;

  inherited;
end;

procedure TD2BridgeThreadTimer.Execute;
begin
  while not Terminated do
  begin
    fsEvent.ResetEvent;

    if fsEnabled then
    begin
      fsEvent.WaitFor(fsInterval);

      if fsEnabled and Assigned(fsOntimer) then
      begin
        //{$IFNDEF NOGUI}
        //Synchronize( DoCallEvent )
        //{$ELSE}
        DoCallEvent;
        //{$ENDIF};
      end;
    end
    else
      fsEvent.WaitFor(Cardinal(-1));
  end;
end;

procedure TD2BridgeThreadTimer.DoCallEvent;
begin
  fsOnTimer(self);
end;

procedure TD2BridgeThreadTimer.SetEnabled(const AValue: Boolean);
begin
  if fsEnabled = AValue then
    exit;

  fsEnabled:= AValue;
  fsEvent.SetEvent;
end;

procedure TD2BridgeThreadTimer.SetInterval(const AValue: Integer);
begin
  fsInterval:= AValue;
  if AValue = 0 then
     Enabled:= False;
end;

{ TTimer }

constructor TTimer.Create(AOwner: TComponent);
begin
{$IFDEF FPC}
 FD2BridgeThreadTimer:= TD2BridgeThreadTimer.Create;
 FD2BridgeThreadTimer.OnTimer:= Self.TimerD2BridgeThread;
 FD2BridgeThreadTimer.Interval:= Self.Interval;
 FD2BridgeThreadTimer.Enabled:= False;
{$ENDIF}

 if AOwner is TD2BridgeForm then
 begin
  FD2BridgeForm:= AOwner;
 end else
 begin
  FD2BridgeForm:= GetFormOfComponent(AOwner);

  if Not Assigned(FD2BridgeForm) then
  begin
{$IFDEF MSWINDOWS}
   if IsDebuggerPresent then
    raise Exception.Create('Owner of this Timer ' + self.Name + ' is not D2BridgeForm - ERROR 0098-1');
{$ENDIF}
  end;
 end;

 if Assigned(FD2BridgeForm) then
  FPrismSession:= (FD2BridgeForm as TD2BridgeForm).PrismSession;

 FThreadID:= -1;

 inherited;
end;

{$IFDEF FPC}
procedure TTimer.SetEnabled(Value: Boolean);
begin
  inherited;

  FD2BridgeThreadTimer.Enabled:= Value;
end;

procedure TTimer.SetInterval(Value: Cardinal);
begin
  inherited;

  FD2BridgeThreadTimer.Interval:= Value;
end;

procedure TTimer.Loaded;
begin
  inherited;

  FD2BridgeThreadTimer.Enabled:= Self.Enabled;
end;

procedure TTimer.TimerD2BridgeThread(Sender: TObject);
var
  FThread: TThread;
begin
  if not Assigned(FD2BridgeForm) then
    Exit;

  //inherited;
  if TD2BridgeForm(FD2BridgeForm).Showing then
  begin
    FThread:= TThread.CreateAnonymousThread(Exec_Timer);

    FThread.FreeOnTerminate:= false;
    FThread.Start;
    FThread.WaitFor;

    FreeAndNil(FThread);
  end;
end;
{$ENDIF}

procedure TTimer.Exec_Timer;
begin
 if FThreadID = -1 then
 begin
  FPrismSession.ThreadAddCurrent;
 end else
 begin
  if FThreadID <> TThread.CurrentThread.ThreadID then
   FPrismSession.ThreadRemoveFromID(FThreadID);

  FPrismSession.ThreadAddCurrent;
 end;

 try
  OnTimer(self);
  //FOnTimer(self);
 except
  on E: Exception do
   FPrismSession.DoException(TTimer(Owner), E, 'OnTimer');
 end;
end;

function TTimer.GetFormOfComponent(AComponent: TComponent): TForm;
begin
  Result := nil;
  while Assigned(AComponent) do
  begin
    if AComponent is TD2BridgeForm then
    begin
      Result := TForm(AComponent);
      Exit; // Encontrou o formulário, sai da função
    end;
    AComponent := AComponent.Owner; // Vai subindo na cadeia de owners
  end;
end;

procedure TTimer.{$IF DEFINED(FMX) OR DEFINED(FPC)}DoOnTimer{$ELSE}Timer{$IFEND};
var
  FThread: TThread;
begin
  if not Assigned(FD2BridgeForm) then
    Exit;

  //inherited;
  if TD2BridgeForm(FD2BridgeForm).Showing then
  begin
    FThread:= TThread.CreateAnonymousThread(Exec_Timer);

    FThread.FreeOnTerminate:= false;
    FThread.Start;
    FThread.WaitFor;

    FreeAndNil(FThread);
  end;
end;
{$ENDIF}

{ TImageHelper }

function TImageHelper.Camera: TD2BridgeCameraImage;
begin
 if not TagIsD2BridgeFormComponentHelper(Tag) then
  NewCameraInstance;

 Result:= TD2BridgeCameraImage(TD2BridgeFormComponentHelper(Tag).Value['Camera'].AsObject);
end;


procedure TImageHelper.NewCameraInstance;
begin
 if not TagIsD2BridgeFormComponentHelper(Tag,'Camera') then
 begin
  if not TagIsD2BridgeFormComponentHelper(Tag) then
   Tag:= NativeInt(TD2BridgeFormComponentHelper.Create(nil, self));

  TD2BridgeFormComponentHelper(Tag).Value['Camera']:=
   TValue.From<TD2BridgeCameraImage>(TD2BridgeCameraImage.Create(D2BridgeInstance.PrismSession, nil));
 end;
end;


procedure TImageHelper.NewQRCodeReaderInstance;
begin
 if not TagIsD2BridgeFormComponentHelper(Tag,'QRCode') then
 begin
  if not TagIsD2BridgeFormComponentHelper(Tag) then
   Tag:= NativeInt(TD2BridgeFormComponentHelper.Create(nil, self));

  TD2BridgeFormComponentHelper(Tag).Value['QRCode']:=
   TValue.From<TD2BridgeQRCodeReaderImage>(TD2BridgeQRCodeReaderImage.Create(D2BridgeInstance.PrismSession, nil));
 end;
end;


function TImageHelper.QRCodeReader: TD2BridgeQRCodeReaderImage;
begin
 if not TagIsD2BridgeFormComponentHelper(Tag) then
  NewQRCodeReaderInstance;

 Result:= TD2BridgeQRCodeReaderImage(TD2BridgeFormComponentHelper(Tag).Value['QRCode'].AsObject);
end;

{ THelperRadioGroup }

{$IFDEF D2BRIDGE}
{$IFnDEF FMX}
{$IFnDEF FPC}
procedure THelperRadioGroup.CheckInstanceHelper;
begin
 if not TagIsD2BridgeFormComponentHelper(Tag) then
  TPrismSessionThreadProc.Create(nil, InstanceHelper, true, true).Exec;
end;

procedure THelperRadioGroup.Clear;
begin
 CheckInstanceHelper;

 if TagIsD2BridgeFormComponentHelper(Tag) then
 begin
  (TD2BridgeFormComponentHelper(Tag).Value['Items'].AsObject as TStrings).Clear;
  ItemIndex:= -1;
 end else
  inherited Items.Clear;
end;

function THelperRadioGroup.GetCaption: string;
begin
 CheckInstanceHelper;

 if TagIsD2BridgeFormComponentHelper(Tag) then
 begin
  Result:= TD2BridgeFormComponentHelper(Tag).Value['Caption'].AsString;
 end else
  Result:= inherited Caption;
end;

function THelperRadioGroup.GetHelperItems: TStrings;
begin
 CheckInstanceHelper;

 if TagIsD2BridgeFormComponentHelper(Tag) then
 begin
  Result:= TD2BridgeFormComponentHelper(Tag).Value['Items'].AsObject as TStrings;
 end else
  Result:= inherited Items;
end;

function THelperRadioGroup.GetItemIndex: integer;
begin
 CheckInstanceHelper;

 if TagIsD2BridgeFormComponentHelper(Tag) then
 begin
  Result:= TD2BridgeFormComponentHelper(Tag).Value['ItemIndex'].AsInteger;
 end else
  Result:= inherited ItemIndex;
end;

function THelperRadioGroup.GetText: String;
begin
 Result:= '';

 if ItemIndex >= 0 then
  Result:= Items[ItemIndex];
end;

procedure THelperRadioGroup.InstanceHelper;
var
 vItems: TStrings;
 vD2BridgeForm: TD2BridgeForm;
 vProc: TPrismSessionThreadProc;
begin
 if Owner is TD2BridgeForm then
 begin
  vD2BridgeForm:= TD2BridgeForm(Owner);

  Tag := NativeInt(vD2BridgeForm.D2BridgeFormComponentHelperItems.PropValues(Self));

  if not TagIsD2BridgeFormComponentHelper(tag, 'Items') then
  begin
   vItems:= TStringList.Create;

   TD2BridgeFormComponentHelper(Tag).Value['Items']:= vItems;

   vItems.Text:= inherited Items.Text;
  end;

  if not TagIsD2BridgeFormComponentHelper(tag, 'ItemIndex') then
  begin
   TD2BridgeFormComponentHelper(Tag).Value['ItemIndex']:= (inherited {$IFnDEF FPC}ItemIndex{$ELSE}GetItemIndex{$ENDIF});
  end;
 end;
end;

procedure THelperRadioGroup.SetCaption(const Value: string);
begin
 CheckInstanceHelper;

 if TagIsD2BridgeFormComponentHelper(Tag) then
 begin
  TD2BridgeFormComponentHelper(Tag).Value['Caption']:= Value;
 end else
  inherited Caption := Value;
end;

procedure THelperRadioGroup.SetHelperItems(AItems: TStrings);
begin
 CheckInstanceHelper;

 if TagIsD2BridgeFormComponentHelper(Tag) then
 begin
  TD2BridgeFormComponentHelper(Tag).Value['Items']:= AItems;
 end else
  inherited Items:= AItems;
end;

procedure THelperRadioGroup.SetItemIndex(Val: Integer);
begin
 CheckInstanceHelper;

 if TagIsD2BridgeFormComponentHelper(Tag) then
 begin
  TD2BridgeFormComponentHelper(Tag).Value['ItemIndex']:= Val;
 end else
  inherited ItemIndex := Val;
end;

procedure THelperRadioGroup.SetText(AText: String);
begin
 CheckInstanceHelper;

 if (Items.IndexOf(AText) < 0) then
 begin
  if AText <> '' then
  begin
   Items.Add(AText);
   ItemIndex:= Items.IndexOf(AText)
  end else
   ItemIndex:= -1;
 end else
  ItemIndex:= Items.IndexOf(AText)
end;
{$ENDIF}
{$ENDIF}
{$ENDIF}

end.
