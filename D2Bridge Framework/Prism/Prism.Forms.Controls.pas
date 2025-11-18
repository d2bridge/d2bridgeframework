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

{$I ..\D2Bridge.inc}

unit Prism.Forms.Controls;

interface

uses
  Classes, SysUtils, Variants, D2Bridge.JSON,
{$IFDEF HAS_UNIT_SYSTEM_UITYPES}
  System.UITypes,
{$ENDIF}
{$IFDEF FMX}
  FMX.Graphics,
{$ELSE}
  Graphics,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  Prism.Interfaces, Prism.Types,
  D2Bridge.Prism, D2Bridge.Lang.Interfaces, D2Bridge.Lang.Term, D2Bridge.Interfaces;


type
 TPrismControl = class(TInterfacedPersistent, IPrismControl)
  private
   FName: string;
   FHTMLControl: String;
   FHTMLCore: String;
   FUnformatedHTMLControl: String;
   FIPrismControlEvents: IPrismControlEvents;
   FVCLComponent: TComponent;
   FIsHidden: Boolean;
   FForm: IPrismForm;
   FStoredPlaceholder: String;
   FProcGetEnabled: TOnGetValue;
   FProcSetEnabled: TOnSetValue;
   FProcGetVisible: TOnGetValue;
   FProcSetVisible: TOnSetValue;
   FProcGetReadOnly: TOnGetValue;
   FProcSetReadOnly: TOnSetValue;
   FProcGetPlaceholder: TOnGetValue;
   FRefreshControl: Boolean;
   FTemplateControl: Boolean;
   FRequired: Boolean;
   FValidationGroup: Variant;
   FInitilized: Boolean;
   FIgnoreValueInInitialized: boolean;
   FD2BridgeItem: ID2BridgeItem;
   FPrismSession: IPrismSession;
   FUpdatable: Boolean;
{$IFDEF FPC}
  protected
{$ENDIF}
   procedure SetName(AName: String); reintroduce;
   function GetName: String; reintroduce;
   function GetNamePrefix: String;
   function GetPlaceholder: String;
   function GetIsHidden: Boolean;
   procedure SetIsHidden(AIsHidden: Boolean);
   function GetValidationGroup: Variant;
   Procedure SetValidationGroup(AValidationGroup: Variant);
   procedure SetForm(APrismForm: IPrismForm);
   function GetForm: IPrismForm;
   procedure SetHTMLControl(AHTMLControl: String);
   function GetHTMLControl: String;
   function GetUnformatedHTMLControl: String;
   function GetHTMLCore: string;
   procedure SetHTMLCore(AHTMLTag: String);
   function GetEvents: IPrismControlEvents;
   function GetTemplateControl: Boolean;
   procedure SetTemplateControl(AValue: Boolean);
   function GetD2BridgeItem: ID2BridgeItem;
   procedure SetD2BridgeItem(Value: ID2BridgeItem);
   function GetUpdatable: Boolean;
   procedure SetUpdatable(const Value: Boolean);
  protected
   FStoredEnabled: Boolean;
   FNewEnabled: Boolean;
   FStoredVisible: Boolean;
   FNewVisible: Boolean;
   FStoredReadOnly: Boolean;
   FFStoredVCLStyle: ID2BridgeItemVCLObjStyle;
   FNewReadOnly: Boolean;
   function RefreshControl: Boolean;
   procedure SetVCLComponent(AComponent: TComponent); virtual;
   function GetVCLComponent: TComponent; virtual;
   procedure SetVisible(AVisible: Boolean); virtual;
   function GetVisible: Boolean; virtual;
   procedure SetEnabled(AEnabled: Boolean); virtual;
   function GetEnabled: Boolean; virtual;
   procedure SetReadOnly(AReadOnly: Boolean); virtual;
   function GetReadOnly: Boolean; virtual;
   function GetRequired: Boolean; virtual;
   procedure SetRequired(ARequired: Boolean); virtual;
   procedure ProcessEvent(Event: IPrismControlEvent; Parameters: TStrings); virtual;
   function ValidationGroupPassed: boolean; virtual;
   procedure FormatHTMLControl(AHTMLText: String); virtual;
   procedure RefreshHTMLControl;
  public
   constructor Create(AOwner: TObject); virtual;
   destructor Destroy; override;

   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); virtual;
   procedure UpdateData; virtual;
   procedure Refresh;
   function PrismOptions: IPrismOptions;
   procedure SetFocus;

   //**AS** PrismControls
   function AsButton: IPrismButton;
   function AsCheckBox: IPrismCheckBox;
   function AsCombobox: IPrismCombobox;
   function AsStringGrid: IPrismStringGrid;
   function AsMainMenu: IPrismMainMenu;
   function AsSideMenu: IPrismSideMenu;
   function AsKanban: IPrismKanban;

{$IFNDEF FMX}
   function AsDBGrid: IPrismDBGrid;
   function AsDBCheckBox: IPrismDBCheckBox;
   function AsDBCombobox: IPrismDBCombobox;
   function AsDBLookupCombobox: IPrismDBLookupCombobox;
   function AsDBEdit: IPrismDBEdit;
   function AsDBMemo: IPrismDBMemo;
   function AsDBText: IPrismDBText;
   function AsButtonedEdit: IPrismButtonedEdit;
   function AsCardDataModel: IPrismCardDataModel;
   function AsRadioGroup: IPrismRadioGroup;
   function AsDBRadioGroup: IPrismDBRadioGroup;
{$ENDIF}

   function AsLabel: IPrismLabel;
   function AsEdit: IPrismEdit;
   function AsImage: IPrismImage;
   function AsHTMLElement: IPrismHTMLElement;
   function AsLink: IPrismLink;
   function AsQRCode: IPrismQRCode;
   function AsCarousel: IPrismCarousel;
   function AsMemo: IPrismMemo;
   function AsTabs: IPrismTabs;
   function AsControl: IPrismControl;
   function AsControlGeneric: IPrismControlGeneric;
   function AsCard: IPrismCard;
   function AsCardGridDataModel: IPrismCardGridDataModel;
   function AsCardModel: IPrismCardModel;
   function AsMarkDownEditor: IPrismMarkDownEditor;
   function AsWYSIWYGEditor: IPrismWYSIWYGEditor;
   function AsCamera: IPrismCamera;
   function AsQRCodeReader: IPrismQRCodeReader;

   //**IS** PrismControls
   function IsButton: Boolean; virtual;
   function IsCheckBox: Boolean; virtual;
   function IsCombobox: Boolean; virtual;
   function IsStringGrid: Boolean; virtual;

{$IFNDEF FMX}
   function IsDBGrid: Boolean; virtual;
   function IsDBCheckBox: Boolean; virtual;
   function IsDBCombobox: Boolean; virtual;
   function IsDBLookupCombobox: Boolean; virtual;
   function IsDBEdit: Boolean; virtual;
   function IsDBMemo: Boolean; virtual;
   function IsDBText: Boolean; virtual;
   function IsButtonedEdit: Boolean; virtual;
   function IsRadioGroup: Boolean; virtual;
   function IsDBRadioGroup: Boolean; virtual;
{$ENDIF}

   function IsEdit: Boolean; virtual;
   function IsLabel: Boolean; virtual;
   function IsImage: Boolean; virtual;
   function IsMemo: Boolean; virtual;
   function IsHTMLElement: Boolean; virtual;
   function IsLink: Boolean; virtual;
   function IsQRCode: Boolean; virtual;
   function IsCarousel: boolean; virtual;
   function IsTabs: boolean; virtual;
   function IsControl: Boolean; virtual;
   function IsControlGeneric: boolean; virtual;
   function IsCard: Boolean; virtual;
   function IsMainMenu: Boolean; virtual;
   function IsSideMenu: Boolean; virtual;
   function IsCardGridDataModel: boolean; virtual;
   function IsCardDataModel: boolean; virtual;
   function IsCardModel: boolean; virtual;
   function IsKanban: boolean; virtual;
   function IsMarkDownEditor: boolean; virtual;
   function IsWYSIWYGEditor: boolean; virtual;
   function IsCamera: boolean; virtual;
   function IsQRCodeReader: boolean; virtual;


   function NeedCheckValidation: Boolean; virtual;
   //function IsValidable: Boolean; virtual;

   function Lang: TD2BridgeTerm;
   function Session: IPrismSession;

   //Form Laod Events
   procedure DoFormLoadComplete; virtual;
   procedure DoFormResize; virtual;
   procedure DoFormOrientationChange; virtual;
   procedure DoFormUnLoad; virtual;

   //Abstract
   procedure Initialize; virtual;
   function Initilized: boolean; virtual;
   function AlwaysInitialize: boolean; virtual;
   procedure ProcessHTML; virtual; abstract;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); virtual; abstract;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); virtual; abstract;
   function GetEnableComponentState: Boolean; virtual; abstract;

   //Events
   property ProcGetEnabled: TOnGetValue read FProcGetEnabled write FProcGetEnabled;
   property ProcSetEnabled: TOnSetValue read FProcSetEnabled write FProcSetEnabled;
   property ProcGetVisible: TOnGetValue read FProcGetVisible write FProcGetVisible;
   property ProcSetVisible: TOnSetValue read FProcSetVisible write FProcSetVisible;
   property ProcGetReadOnly: TOnGetValue read FProcGetReadOnly write FProcGetReadOnly;
   property ProcSetReadOnly: TOnSetValue read FProcSetReadOnly write FProcSetReadOnly;
   property ProcGetPlaceholder: TOnGetValue read FProcGetPlaceholder write FProcGetPlaceholder;

   //Property
   property Name: String read GetName write SetName;
   property NamePrefix: String read GetNamePrefix;
   property HTMLControl: String read GetHTMLControl write SetHTMLControl;
   property HTMLCore: String read GetHTMLCore write SetHTMLCore;
   property VCLComponent: TComponent read GetVCLComponent write SetVCLComponent;
   property TemplateControl: Boolean read GetTemplateControl write SetTemplateControl;
   property Events: IPrismControlEvents read GetEvents;
   property UnformatedHTMLControl: String read GetUnformatedHTMLControl;
   property Visible: Boolean read GetVisible write SetVisible;
   property Enabled: Boolean read GetEnabled write SetEnabled;
   property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
   property Placeholder: String read GetPlaceholder;
   property Required: Boolean read GetRequired write SetRequired;
   property ValidationGroup: Variant read GetValidationGroup write SetValidationGroup;
   property Hidden: Boolean read GetIsHidden write SetIsHidden;
   property Updatable: Boolean read GetUpdatable write SetUpdatable;
   property Form: IPrismForm read GetForm write SetForm;
   property D2BridgeItem: ID2BridgeItem read GetD2BridgeItem write SetD2BridgeItem;
 end;

 TPrismControlClass = class of TPrismControl;

implementation

uses
  D2Bridge.Item.VCLObj.Style, D2Bridge.Util, D2Bridge.HTML.CSS,
  Prism.Events, Prism.Util, Prism.Forms,
  Prism.Button, Prism.CheckBox, Prism.Combobox, Prism.Edit, Prism.Image, Prism.HTMLElement, Prism.Memo,
  Prism.StringGrid,
{$IFNDEF FMX}
  Prism.DBGrid, Prism.DBCheckBox, Prism.DBCombobox, Prism.DBEdit, Prism.DBMemo, Prism.DBText,
{$ENDIF}
  Prism.ControlGeneric, Prism.Link, Prism.Carousel, Prism.Session;


{ TPrismControl }

function TPrismControl.AlwaysInitialize: boolean;
begin
 result:= false;
end;

function TPrismControl.AsButton: IPrismButton;
begin
 result:= self as TPrismButton;
end;

function TPrismControl.AsCamera: IPrismCamera;
begin
 result:= self as IPrismCamera;
end;

function TPrismControl.AsCard: IPrismCard;
begin
 result := self as IPrismCard;
end;

{$IFNDEF FMX}
function TPrismControl.AsCardDataModel: IPrismCardDataModel;
begin
 result:= self as IPrismCardDataModel;
end;
{$ENDIF}

function TPrismControl.AsCardGridDataModel: IPrismCardGridDataModel;
begin
 result:= self as IPrismCardGridDataModel;
end;

function TPrismControl.AsCardModel: IPrismCardModel;
begin
 result:= self as IPrismCardModel;
end;

function TPrismControl.AsCarousel: IPrismCarousel;
begin
 result:= self as TPrismCarousel;
end;

function TPrismControl.AsCheckBox: IPrismCheckBox;
begin
 result:= self as TPrismCheckBox;
end;

function TPrismControl.AsCombobox: IPrismCombobox;
begin
 result:= self as TPrismCombobox;
end;

function TPrismControl.AsControl: IPrismControl;
begin
 result:= Self;
end;

function TPrismControl.AsControlGeneric: IPrismControlGeneric;
begin
 result:= self as IPrismControlGeneric;
end;

function TPrismControl.AsSideMenu: IPrismSideMenu;
begin
 result:= self as IPrismSideMenu;
end;

function TPrismControl.AsStringGrid: IPrismStringGrid;
begin
 result:= self as TPrismStringGrid;
end;

{$IFNDEF FMX}
function TPrismControl.AsDBCheckBox: IPrismDBCheckBox;
begin
 result:= self as TPrismDBCheckBox;
end;

function TPrismControl.AsDBCombobox: IPrismDBCombobox;
begin
 result:= self as TPrismDBCombobox;
end;

function TPrismControl.AsDBEdit: IPrismDBEdit;
begin
 result:= self as TPrismDBEdit;
end;

function TPrismControl.AsDBMemo: IPrismDBMemo;
begin
 result:= self as TPrismDBMemo;
end;

function TPrismControl.AsDBRadioGroup: IPrismDBRadioGroup;
begin
 result:= self as IPrismDBRadioGroup;
end;

function TPrismControl.AsDBText: IPrismDBText;
begin
 result:= self as TPrismDBText;
end;

function TPrismControl.AsDBGrid: IPrismDBGrid;
begin
 result:= self as TPrismDBGrid;
end;

function TPrismControl.AsDBLookupCombobox: IPrismDBLookupCombobox;
begin
 result:= self as IPrismDBLookupCombobox;
end;

function TPrismControl.AsButtonedEdit: IPrismButtonedEdit;
begin
 result:= self as IPrismButtonedEdit;
end;
{$ENDIF}

function TPrismControl.AsEdit: IPrismEdit;
begin
 result:= self as TPrismEdit;
end;

function TPrismControl.AsHTMLElement: IPrismHTMLElement;
begin
 result:= self as TPrismHTMLElement;
end;

function TPrismControl.AsImage: IPrismImage;
begin
 result:= self as TPrismImage;
end;

function TPrismControl.AsKanban: IPrismKanban;
begin
 result:= Self as IPrismKanban;
end;

function TPrismControl.AsLabel: IPrismLabel;
begin
 result:= self as IPrismLabel;
end;

function TPrismControl.AsLink: IPrismLink;
begin
 result:= self as TPrismLink;
end;

function TPrismControl.AsMainMenu: IPrismMainMenu;
begin
 result:= self as IPrismMainMenu;
end;

function TPrismControl.AsMarkDownEditor: IPrismMarkDownEditor;
begin
 result:= self as IPrismMarkDownEditor;
end;

function TPrismControl.AsMemo: IPrismMemo;
begin
 result:= self as TPrismMemo;
end;

function TPrismControl.AsQRCode: IPrismQRCode;
begin
 result:= self as IPrismQRCode;
end;

function TPrismControl.AsQRCodeReader: IPrismQRCodeReader;
begin
 result:= self as IPrismQRCodeReader;
end;

{$IFnDEF FMX}
function TPrismControl.AsRadioGroup: IPrismRadioGroup;
begin
 result:= self as IPrismRadioGroup;
end;
{$ENDIF}

function TPrismControl.AsTabs: IPrismTabs;
begin
 result:= self as IPrismTabs;
end;

function TPrismControl.AsWYSIWYGEditor: IPrismWYSIWYGEditor;
begin
 result:= self as IPrismWYSIWYGEditor;
end;

constructor TPrismControl.Create(AOwner: TObject);
var
 vPrismForm: IPrismForm;
begin
  inherited Create;

  System.Initialize(FFStoredVCLStyle);
  FHTMLControl:= '';
  FHTMLCore:= '';
  FUnformatedHTMLControl:= '';
  FStoredEnabled:= true;
  FStoredVisible:= true;
  FStoredReadOnly:= false;
  FRefreshControl:= false;
  FInitilized:= false;
  FTemplateControl:= false;
  FUpdatable:= true;

  FNewEnabled:= FStoredEnabled;
  FNewVisible:= FStoredVisible;
  FNewReadOnly:= FStoredReadOnly;

  FIgnoreValueInInitialized:= false;

  FIPrismControlEvents:= TPrismControlEvents.Create(self);

  if AOwner is TPrismSession then
   FPrismSession:= AOwner as TPrismSession;

  if AOwner <> nil then
   if Supports(AOwner, IPrismForm, vPrismForm) then
   begin
    vPrismForm.AddControl(self);
    if not Assigned(FPrismSession) then
     FPrismSession:= vPrismForm.Session;
   end;
end;

destructor TPrismControl.Destroy;
var
 vD2BridgeItemVCLObjStyle: TD2BridgeItemVCLObjStyle;
 vPrismControlEvents: TPrismControlEvents;
begin
 try
  if Assigned(FFStoredVCLStyle) then
  begin
   vD2BridgeItemVCLObjStyle:= FFStoredVCLStyle as TD2BridgeItemVCLObjStyle;
   FFStoredVCLStyle:= nil;
   vD2BridgeItemVCLObjStyle.Free;
  end;
 except
 end;

 try
  vPrismControlEvents:= FIPrismControlEvents as TPrismControlEvents;
  FIPrismControlEvents:= nil;
  vPrismControlEvents.Free;
 except
 end;

 try
  if Assigned(Self) then
  begin
   if Assigned(Form) and
      (not Form.Destroying) and
      Assigned(Form.Controls) then
    Form.Controls.Remove(self);
  end;
 except
 end;

 if Assigned(FForm) then
  FForm:= nil;

 if Assigned(FPrismSession) then
  FPrismSession:= nil;

 inherited;
end;

procedure TPrismControl.DoFormLoadComplete;
begin

end;

procedure TPrismControl.DoFormOrientationChange;
begin

end;

procedure TPrismControl.DoFormResize;
begin

end;

procedure TPrismControl.DoFormUnLoad;
begin

end;

procedure TPrismControl.FormatHTMLControl(AHTMLText: String);
var
 PosInit, PosEnd: Integer;
 NameControlPosInit, NameControlPosEnd: Integer;
 vEnabled, vReadOnly, vVisible: boolean;
begin
 PosInit:= AnsiPos('{%'+ NamePrefix+' ', AHTMLText);
 if PosInit = 0 then
  PosInit:= AnsiPos('{%'+ NamePrefix+'%}', AHTMLText);
 PosEnd:= AnsiPos('%}', AHTMLText);

 NameControlPosInit:= PosInit+3;
 NameControlPosEnd:= NameControlPosInit + Length(NamePrefix);

 if (PosInit >= 1) and (PosEnd >= 1) then
 begin
  FUnformatedHTMLControl:= Copy(AHTMLText, PosInit, PosEnd+1);

  if (AnsiPos(' ID="'+AnsiUpperCase(NamePrefix)+'"', AnsiUpperCase(FUnformatedHTMLControl)) <= 0) then
  HTMLCore:= Copy(AHTMLText, NameControlPosEnd, PosEnd - NameControlPosEnd) + ' id="'+AnsiUpperCase(NamePrefix)+'" '
  else
  HTMLCore:= Copy(AHTMLText, NameControlPosEnd, PosEnd - NameControlPosEnd);

  //not Enabled
  vEnabled := Enabled;
  vReadOnly:= ReadOnly;
  vVisible:= Visible;

  //not Enabled or ReadOnly
  if (not vEnabled) or vReadOnly then
  begin
   HTMLCore:= HTMLAddItemFromClass(HTMLCore, 'disabled');
   HTMLCore:= HTMLAddItemFromTag(HTMLCore, 'disabled', '');

   FStoredEnabled:= vEnabled;
   FStoredReadOnly:= vReadOnly;

   FIgnoreValueInInitialized:= true;
  end;

  //not Visible
  if not vVisible then
  begin
   HTMLCore:= HTMLAddItemFromClass(HTMLCore, 'invisible');

   FStoredVisible:= vVisible;

   FIgnoreValueInInitialized:= true;
  end;

//  //ReadOnly
//  if ReadOnly then
//  HTMLCore:= HTMLCore + 'disabled ';

  //Required
  if Required then
  HTMLCore:= HTMLCore + 'required ';

  //Validation Group
  if not VarIsEmpty(ValidationGroup) then
   HTMLCore:= HTMLCore + 'validationgroup="'+VarToStr(ValidationGroup)+'" ';

  //PlaceHolder
  if Placeholder <> '' then
   HTMLCore:= HTMLCore + 'placeholder="' + Placeholder + '" ';

  //Self.Initialize;

  //Call Event
  //TPrismForm(Form).D2BridgeForm.DoRenderPrismControl(self, FHTMLControl);

  //Self.ProcessHTML;
 end;
end;

function TPrismControl.GetD2BridgeItem: ID2BridgeItem;
begin
 Result:= FD2BridgeItem;
end;

function TPrismControl.GetEnabled: Boolean;
begin
 if Assigned(ProcGetEnabled) then
 Result:= ProcGetEnabled
 else
 Result:= FNewEnabled;
end;

function TPrismControl.GetEvents: IPrismControlEvents;
begin
 Result:= FIPrismControlEvents;
end;

function TPrismControl.GetForm: IPrismForm;
begin
 result:= FForm;
end;

function TPrismControl.GetPlaceholder: String;
begin
 if Assigned(ProcGetPlaceholder) then
  Result:= ProcGetPlaceholder
 else
  Result:= FStoredPlaceholder;
end;

function TPrismControl.GetHTMLControl: String;
begin
 Result:= FHTMLControl;
end;

function TPrismControl.GetHTMLCore: string;
begin
 Result:= FHTMLCore;
end;

function TPrismControl.GetIsHidden: Boolean;
begin
 Result:= FIsHidden;
end;

function TPrismControl.GetName: String;
begin
 Result:= FName;
end;

function TPrismControl.GetNamePrefix: String;
begin
 if (Form.ControlsPrefix <> '') and (FName <> '') then
  Result:= Form.ControlsPrefix+'_'+FName
 else
  Result:= FName;
end;

function TPrismControl.GetReadOnly: Boolean;
begin
 if Assigned(ProcGetReadOnly) then
  Result:= ProcGetReadOnly
 else
  Result:= FNewReadOnly;
end;

function TPrismControl.GetRequired: Boolean;
begin
 Result:= FRequired;
end;

function TPrismControl.GetTemplateControl: Boolean;
begin
 Result:= FTemplateControl;
end;

function TPrismControl.GetUnformatedHTMLControl: String;
begin
 Result:= FUnformatedHTMLControl;
end;


function TPrismControl.GetUpdatable: Boolean;
begin
 result:= FUpdatable;
end;

function TPrismControl.GetValidationGroup: Variant;
begin
 Result:= FValidationGroup;
end;

function TPrismControl.GetVCLComponent: TComponent;
begin
 Result:= FVCLComponent;
end;

function TPrismControl.GetVisible: Boolean;
begin
 if Assigned(ProcGetVisible) then
 Result:= ProcGetVisible
 else
 Result:= FNewVisible;
end;

procedure TPrismControl.Initialize;
begin
 if not FIgnoreValueInInitialized then
 begin
  FStoredEnabled:= Enabled;
  FStoredReadOnly:= ReadOnly;
  FStoredVisible:= Visible;

  //VCL Style
  if Assigned(D2BridgeItem) and Supports(D2BridgeItem, ID2BridgeItemVCLObj) then
  begin
   if Assigned((D2BridgeItem as ID2BridgeItemVCLObj).VCLObjStyle) then
   begin
    if not Assigned(FFStoredVCLStyle) then
     FFStoredVCLStyle:= TD2BridgeItemVCLObjStyle.Create;

    (FFStoredVCLStyle as TD2BridgeItemVCLObjStyle).Assign((D2BridgeItem as ID2BridgeItemVCLObj).VCLObjStyle as TPersistent);
   end;
  end;
 end;

 FStoredPlaceholder:= Placeholder;

 //Call Event
 try
  if not FInitilized or AlwaysInitialize then
   (Form as TPrismForm).DoInitPrismControl(self);
 except on E: Exception do
{$IFDEF MSWINDOWS}
   if IsDebuggerPresent then
     raise Exception.Create(E.Message);
{$ENDIF}
 end;

 //FIgnoreValueInInitialized:= false;
 FInitilized:= true;
end;

function TPrismControl.Initilized: boolean;
begin
 result:= FInitilized;
end;

function TPrismControl.IsButton: Boolean;
begin
 result:= false;
end;

function TPrismControl.IsCard: Boolean;
begin
 result:= false;
end;

function TPrismControl.IsCardDataModel: boolean;
begin
 result:= false;
end;

function TPrismControl.IsCardGridDataModel: boolean;
begin
 result:= false;
end;

function TPrismControl.IsCardModel: boolean;
begin
 result:= false;
end;

function TPrismControl.IsCarousel: boolean;
begin
 result:= false;
end;

function TPrismControl.IsCheckBox: Boolean;
begin
 Result:= false;
end;

function TPrismControl.IsCombobox: Boolean;
begin
 Result:= false;
end;

function TPrismControl.IsControl: Boolean;
begin
 Result:= false;
end;

function TPrismControl.IsControlGeneric: boolean;
begin
 result:= false;
end;

function TPrismControl.IsSideMenu: Boolean;
begin
 result:= false;
end;

function TPrismControl.IsStringGrid: Boolean;
begin
 Result:= false;
end;

{$IFNDEF FMX}
function TPrismControl.IsDBCheckBox: Boolean;
begin
 Result:= false;
end;

function TPrismControl.IsDBCombobox: Boolean;
begin
 Result:= false;
end;

function TPrismControl.IsDBEdit: Boolean;
begin
 Result:= false;
end;

function TPrismControl.IsDBMemo: Boolean;
begin
 Result:= false;
end;

function TPrismControl.IsDBRadioGroup: Boolean;
begin
  result:= false;
end;

function TPrismControl.IsDBText: Boolean;
begin
 Result:= false;
end;

function TPrismControl.IsDBGrid: Boolean;
begin
 Result:= false;
end;

function TPrismControl.IsDBLookupCombobox: Boolean;
begin
 result:= false;
end;

function TPrismControl.IsButtonedEdit: Boolean;
begin
 Result:= false;
end;
{$ENDIF}

function TPrismControl.IsEdit: Boolean;
begin
 Result:= false;
end;

function TPrismControl.IsHTMLElement: Boolean;
begin
 result:= false;
end;

function TPrismControl.IsImage: Boolean;
begin
 Result:= false;
end;

function TPrismControl.IsCamera: boolean;
begin
 result:= false;
end;

function TPrismControl.IsQRCodeReader: boolean;
begin
 result:= false;
end;

function TPrismControl.IsKanban: boolean;
begin
 result:= false;
end;

function TPrismControl.IsLabel: Boolean;
begin
 Result:= false;
end;

function TPrismControl.IsLink: Boolean;
begin
 result:= false;
end;

function TPrismControl.IsMainMenu: Boolean;
begin
 Result:= false;
end;

function TPrismControl.IsMarkDownEditor: boolean;
begin
 result:= false;
end;

function TPrismControl.IsMemo: Boolean;
begin
 Result:= false;
end;

function TPrismControl.IsQRCode: Boolean;
begin
 result:= false;
end;

{$IFnDEF FMX}
function TPrismControl.IsRadioGroup: Boolean;
begin
 result:= false;
end;
{$ENDIF}

function TPrismControl.IsTabs: boolean;
begin
 result:= false;
end;

function TPrismControl.IsWYSIWYGEditor: boolean;
begin
 result:= false;
end;

function TPrismControl.Lang: TD2BridgeTerm;
begin
 Result:= FForm.Session.LangNav;
end;

function TPrismControl.NeedCheckValidation: Boolean;
begin
 Result:= False;
end;

function TPrismControl.PrismOptions: IPrismOptions;
begin
 Result:= Form.PrismOptions;
end;

procedure TPrismControl.ProcessEvent(Event: IPrismControlEvent;
  Parameters: TStrings);
begin

end;

procedure TPrismControl.Refresh;
begin
// inherited;

 FRefreshControl:= true;
end;

function TPrismControl.RefreshControl: Boolean;
begin
 Result:= FRefreshControl;
end;

procedure TPrismControl.RefreshHTMLControl;
begin
 FormatHTMLControl(UnformatedHTMLControl);
end;

function TPrismControl.Session: IPrismSession;
begin
 //result:= FForm.Session;
 result:= FPrismSession;
end;

procedure TPrismControl.SetD2BridgeItem(Value: ID2BridgeItem);
begin
 FD2BridgeItem:= Value;
end;

procedure TPrismControl.SetEnabled(AEnabled: Boolean);
begin
 if Assigned(ProcSetEnabled) then
 if FStoredEnabled <> AEnabled then
 begin
  ProcSetEnabled(AEnabled);
  FStoredEnabled:= AEnabled;
 end;

 FNewEnabled:= AEnabled;

 if FNewEnabled then
  FHTMLCore:= HTMLRemoveItemFromClass(FHTMLCore, 'disabled')
 else
  FHTMLCore:= HTMLAddItemFromClass(FHTMLCore, 'disabled');
end;

procedure TPrismControl.SetFocus;
begin
 if Visible and Enabled then
 begin
  if (not Assigned(Form.FocusedControl)) or
     (Form.FocusedControl <> (self as IPrismControl)) then
   Form.FocusedControl:= self;

  Form.Session.ExecJS
  (
    'setTimeout(function() {' +
    '   if (document.querySelector("[id='+UpperCase(self.NamePrefix)+' i]") !== null) { ' +
    '     var element = document.querySelector("[id='+UpperCase(self.NamePrefix)+' i]"); ' +
    '     if (element !== document.activeElement && element.tabIndex >= 0 && element.offsetParent !== null) { ' +
    '       element.focus({ preventScroll: true }); ' +
    '     } ' +
    '   }' +
    '}, 400);',
    true
  );
 end;
end;

procedure TPrismControl.SetForm(APrismForm: IPrismForm);
begin
 FForm:= APrismForm;
 FPrismSession:= APrismForm.Session;
end;

procedure TPrismControl.SetHTMLControl(AHTMLControl: String);
begin
 FHTMLControl:= AHTMLControl;
end;

procedure TPrismControl.SetHTMLCore(AHTMLTag: String);
begin
 FHTMLCore:= AHTMLTag;
end;

procedure TPrismControl.SetIsHidden(AIsHidden: Boolean);
begin
 FIsHidden:= AIsHidden;
end;

procedure TPrismControl.SetName(AName: String);
begin
 FName:= AName;
end;


procedure TPrismControl.SetReadOnly(AReadOnly: Boolean);
begin
 if Assigned(ProcSetReadOnly) then
 if FStoredReadOnly <> AReadOnly then
 begin
  ProcSetReadOnly(AReadOnly);
  FStoredReadOnly:= AReadOnly;
 end;

 FNewReadOnly:= AReadOnly;
end;

procedure TPrismControl.SetRequired(ARequired: Boolean);
begin
 FRequired:= ARequired;
end;

procedure TPrismControl.SetTemplateControl(AValue: Boolean);
begin
 FTemplateControl := AValue;
end;

procedure TPrismControl.SetUpdatable(const Value: Boolean);
begin
 FUpdatable:= Value;
end;

procedure TPrismControl.SetValidationGroup(AValidationGroup: Variant);
begin
 FValidationGroup:= AValidationGroup;
end;

procedure TPrismControl.SetVCLComponent(AComponent: TComponent);
begin
 FVCLComponent:= AComponent;
// FVCLComponent.FreeNotification(self);
end;

procedure TPrismControl.SetVisible(AVisible: Boolean);
begin
 if Assigned(ProcSetVisible) then
 if FStoredVisible <> AVisible then
 begin
  ProcSetVisible(AVisible);
  FStoredVisible:= AVisible;
 end;

 FNewVisible:= AVisible;

 if FNewVisible then
  FHTMLCore:= HTMLRemoveItemFromClass(FHTMLCore, 'invisible')
 else
  FHTMLCore:= HTMLAddItemFromClass(FHTMLCore, 'invisible');
end;

procedure TPrismControl.UpdateData;
begin

end;

procedure TPrismControl.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
var
 NewEnabled, NewVisible, NewReadOnly: Boolean;
 NewPlaceHolder: string;
 NewVCLStyle: ID2BridgeItemVCLObjStyle;
 vVCLStyleChanged: boolean;
begin
 {$REGION 'Enabled'}
  NewEnabled:= Enabled;
  if FStoredEnabled <> NewEnabled then
  begin
   //Enabled := NewEnabled;
   FStoredEnabled:= NewEnabled;

   if NewEnabled then
   begin
    ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").disabled = false;');
    ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).removeClass("disabled");');

    FHTMLCore:= HTMLRemoveItemFromClass(FHTMLCore, 'disabled');
   end else
   begin
    ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").disabled = true;');
    ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).addClass("disabled");');

    FHTMLCore:= HTMLAddItemFromClass(FHTMLCore, 'disabled');
   end;
  end;
 {$ENDREGION}

 {$REGION 'Visible'}
  NewVisible:= Visible;
  if FStoredVisible <> NewVisible then
  begin
   //Visible := NewVisible;
   FStoredVisible:= NewVisible;

   if NewVisible then
   begin
    //ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").classList.remove("invisible");');
    ScriptJS.Add('let _displayincontrol'+AnsiUpperCase(NamePrefix)+' = ($("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).css("display") === "none");');
    ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).show();');
    ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).removeClass("invisible");');
    ScriptJS.Add('if (_displayincontrol'+AnsiUpperCase(NamePrefix)+' === true) {');
    ScriptJS.Add('  $("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).css("display", "");');
    ScriptJS.Add('}');

    FHTMLCore:= HTMLRemoveItemFromClass(FHTMLCore, 'invisible');
   end else
   begin
    //ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").classList.add("invisible");');
    ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).hide();');
    ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).addClass("invisible");');
    FHTMLCore:= HTMLAddItemFromClass(FHTMLCore, 'invisible');
   end;
  end;

  if NewVisible then
   FHTMLCore:= HTMLRemoveItemFromStyle(FHTMLCore, 'display', 'none');
 {$ENDREGION}


 {$REGION 'ReadOnly'}
  NewReadOnly:= ReadOnly;
  if FStoredReadOnly <> NewReadOnly then
  begin
   //ReadOnly := NewReadOnly;
   FStoredReadOnly:= NewReadOnly;

   if NewReadOnly then
   begin
    ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).addClass("readonly");');

    FHTMLCore:= HTMLAddItemFromClass(FHTMLCore, 'readonly');
   end else
   begin
    ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).removeClass("readonly");');

    FHTMLCore:= HTMLRemoveItemFromClass(FHTMLCore, 'readonly');
   end;

   if NewReadOnly then
    ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").disabled = true;')
   else
   if NewEnabled then
   begin
    ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").disabled = false;');
    ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).removeClass("disabled");');

    FHTMLCore:= HTMLRemoveItemFromClass(FHTMLCore, 'disabled');
   end;
  end;
 {$ENDREGION}


 {$REGION 'PlaceHolder'}
  NewPlaceHolder:= PlaceHolder;
  if FStoredPlaceHolder <> NewPlaceHolder then
  begin
   FStoredPlaceHolder:= NewPlaceHolder;

   ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").setAttribute("placeholder", "' + FStoredPlaceHolder + '");');
  end;
 {$ENDREGION}


 {$REGION 'VCL Styles'}
  if Assigned(FFStoredVCLStyle) then
  begin
   vVCLStyleChanged:= false;

   (D2BridgeItem as ID2BridgeItemVCLObj).RefreshVCLObjStyle;
   NewVCLStyle:= (D2BridgeItem as ID2BridgeItemVCLObj).VCLObjStyle;

   if NewVCLStyle.FontSize <> FFStoredVCLStyle.FontSize then
   begin
    vVCLStyleChanged := true;
    ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").style.font-size = "' + StringReplace(FloatToStr(NewVCLStyle.FontSize / DefaultFontSize), ',', '.', []) +'rem;');
   end;

   if NewVCLStyle.FontStyles <> FFStoredVCLStyle.FontStyles then
   begin
    vVCLStyleChanged := true;
    ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").classList.remove("' + TCSSClassText.Style.bold + '", "' + TCSSClassText.Style.italic + '", "' + TCSSClassText.Style.Underline + '", "' + TCSSClassText.Style.StrikeOut + '");');

    if TFontStyle.fsBold in NewVCLStyle.FontStyles then
     ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").classList.add("' + TCSSClassText.Style.bold + '"');

    if TFontStyle.fsItalic in NewVCLStyle.FontStyles then
     ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").classList.add("' + TCSSClassText.Style.italic + '"');

    if TFontStyle.fsUnderline in NewVCLStyle.FontStyles then
     ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").classList.add("' + TCSSClassText.Style.Underline + '"');

    if TFontStyle.fsStrikeOut in NewVCLStyle.FontStyles then
     ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").classList.add("' + TCSSClassText.Style.StrikeOut + '"');
   end;

   if NewVCLStyle.Alignment <> FFStoredVCLStyle.Alignment then
   begin
    vVCLStyleChanged := true;
    ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").classList.remove("' + TCSSClassText.Align.left + '", "' + TCSSClassText.Align.right + '", "' + TCSSClassText.Align.center + '");');

    if NewVCLStyle.Alignment = AlignmentLeft then
     ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").classList.add("' + TCSSClassText.Align.left + '"');

    if NewVCLStyle.Alignment = AlignmentRight then
     ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").classList.add("' + TCSSClassText.Align.left + '"');

    if NewVCLStyle.Alignment = AlignmentCenter then
     ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").classList.add("' + TCSSClassText.Align.left + '"');
   end;

   if NewVCLStyle.Color <> FFStoredVCLStyle.Color then
   begin
    vVCLStyleChanged := true;
    if NewVCLStyle.Color <> D2Bridge.Item.VCLObj.Style.ColorNone then
     ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").style.backgroundColor = "' + D2Bridge.Util.ColorToHex(NewVCLStyle.Color) + '";')
    else
     ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").style.backgroundColor = "";')
   end;

   if NewVCLStyle.FontColor <> FFStoredVCLStyle.FontColor then
   begin
    vVCLStyleChanged := true;
    if NewVCLStyle.FontColor <> D2Bridge.Item.VCLObj.Style.ColorNone then
     ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").style.color = "' + D2Bridge.Util.ColorToHex(NewVCLStyle.FontColor) + '";')
    else
     ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").style.color = "";');
   end;

   if vVCLStyleChanged then
    (FFStoredVCLStyle as TD2BridgeItemVCLObjStyle).Assign(NewVCLStyle as TPersistent);
  end;
 {$ENDREGION}


 if FRefreshControl then
  (Form as TPrismForm).D2BridgeForm.DoRenderPrismControl(self, FHTMLControl);

 FRefreshControl:= false;
end;

function TPrismControl.ValidationGroupPassed: boolean;
begin
 result:= true;
end;

end.
