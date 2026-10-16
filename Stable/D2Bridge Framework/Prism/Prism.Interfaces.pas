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

unit Prism.Interfaces;

interface

uses
  Classes, Generics.Collections,
  D2Bridge.JSON, SysUtils, IniFiles,
{$IFDEF HAS_UNIT_SYSTEM_UITYPES}
  System.UITypes,
{$ENDIF}
  DB, Rtti,
{$IFNDEF FPC}

{$ELSE}
  StdCtrls,
{$ENDIF}
{$IFDEF FMX}
  FMX.Forms, FMX.Graphics, FMX.Grid,
{$ELSE}
  Forms, Graphics, Grids, Prism.DataLink.Field,
{$ENDIF}
  Prism.Types, Prism.DataWare.Mapped,
  D2Bridge.Types, D2Bridge.Lang.Interfaces, D2Bridge.Lang.Term, D2Bridge.Lang.APP.Term,
  D2Bridge.Image.Interfaces, D2Bridge.Rest.Interfaces;


type
  IPrismBaseClass = interface;
  IPrismSessions = interface;
  IPrismSession = interface;
  IPrismSessionInfo = interface;
  IPrismCookie = interface;
  IPrismCookies = interface;
  IPrismForm = interface;
  IPrismControl = interface;
  IPrismButton = interface;
  IPrismCheckBox = interface;
  IPrismCombobox = interface;
  IPrismGrid = interface;
  IPrismStringGrid = interface;
  IPrismCardGridDataModel = interface;
  IPrismCardModel = interface;
  IPrismKanban = interface;
  IPrismKanbanColumn = interface;
  IPrismOptionSecurity = interface;
  IPrismOptionSecurityUserAgent = interface;
  IPrismOptionSecurityIP = interface;
  IPrismOptionSecurityIPConnections = interface;
  IPrismOptionSecurityIPv4Blacklist = interface;
  IPrismOptionSecurityIPv4Whitelist = interface;

{$IFNDEF FMX}
  IPrismCardDataModel = interface;
  IPrismDBGrid = interface;
  IPrismDBCheckBox = interface;
  IPrismDBCombobox = interface;
  IPrismDBLookupCombobox = interface;
  IPrismDBEdit = interface;
  IPrismDBMemo = interface;
  IPrismDBText = interface;
  IPrismButtonedEdit = interface;
  IPrismRadioGroup = interface;
  IPrismDBRadioGroup = interface;
{$ENDIF}

  IPrismLabel = interface;
  IPrismEdit = interface;
  IPrismImage = interface;
  IPrismMemo = interface;
  IPrismHTMLElement = interface;
  IPrismLink = interface;
  IPrismQRCode = interface;
  IPrismCarousel = interface;
  IPrismTabs = interface;
  IPrismCarouselItem = interface;
  IPrismOptions = interface;
  IPrismClipboard = interface;
  IPrismCard = interface;
  IPrismControlGeneric = interface;
  IPrismMenu = interface;
  IPrismMainMenu = interface;
  IPrismSideMenu = interface;
  IPrismMenuItems = interface;
  IPrismMenuItem = interface;
  IPrismMenuItemGroup = interface;
  IPrismMarkDownEditor = interface;
  IPrismWYSIWYGEditor = interface;
  IPrismCamera = interface;
  IPrismQRCodeReader = interface;
  IPrismChartBase = interface;
  IPrismChartBaseLegend = interface;
  IPrismChartBar = interface;
  IPrismBadge = interface;


 IPrismCallBack = interface
  ['{439F7C10-F19C-43DF-ACE2-3B3215BAD47A}']
   procedure SetName(AName: String);
   function GetName: String;
   function GetCallBackID: String;
   function GetCallBackEvent: TCallBackEvent;
   procedure SetCallBackEvent(AValue: TCallBackEvent);
   function GetResponse: string;
   function GetPrismForm: IPrismForm;
   procedure SetPrismForm(APrismForm: IPrismForm);

   function Execute(EventParams: TStrings): string;
   function DefaultParameters: string;

   property Name: String read GetName write SetName;
   property ID: String read GetCallBackID;
   property Response: String read GetResponse;
   property CallBackEvent: TCallBackEvent read GetCallBackEvent write SetCallBackEvent;
   property PrismForm: IPrismForm read GetPrismForm write SetPrismForm;
 end;


 IPrismCallBacks = interface
  ['{35311C16-3B1E-49E9-BA23-AB5B2997B0E8}']
   Function GetCallBacks: TDictionary<string, IPrismCallBack>; overload;
   function GetCallBacks(APrismForm: IPrismForm): TList<IPrismCallBack>; overload;

   procedure Add(APrismCallBack: IPrismCallBack);
   function Register(AName: String; APrismForm: IPrismForm; ACallBackEventProc: TCallBackEvent): IPrismCallBack; overload;
   function Register(AName: String; APrismForm: IPrismForm): IPrismCallBack; overload;
   function Register(AName: String; Parameters: String; APrismForm: IPrismForm): IPrismCallBack; overload;
   function Register(ACallback: IPrismCallBack; APrismForm: IPrismForm): IPrismCallBack; overload;
   procedure UnRegisterAll(APrismForm: IPrismForm);
   procedure Unregister(AName: String);
   function GetCallBack(AName: String; APrismForm: IPrismForm): IPrismCallBack; overload;
   function GetCallBack(AName, FormUUID: String): IPrismCallBack; overload;
   function Execute(AName, FormUUID: String; EventParams: TStrings): string;
   function CallBackJS(ACallBackName: String; AReturnFalse: Boolean; AFormUUID: String = ''; Parameters: String = ''; LockClient: Boolean = false): string; overload;
   function CallBackJS(ACallBackName: String; AFormUUID: String = ''; Parameters: String = ''; LockClient: Boolean = false): string; overload;
   function CallBackDirectJS(ACallBackName, AFormUUID: String; Parameters: String = ''; LockCLient: Boolean = false): string; overload;
   function CallBackDirectJS(ACallBack: IPrismCallBack; AFormUUID: String; Parameters: String = ''; LockCLient: Boolean = false): string; overload;

   property Items: TDictionary<string, IPrismCallBack> read GetCallBacks;
 end;


 IPrismFormCallBacks = interface
  ['{15CFC9EA-F6CE-472D-A4C1-E70A2145D555}']
   function Register(AName: String; ACallBackEventProc: TCallBackEvent): IPrismCallBack; overload;
   function Register(AName: String; Parameters: String = ''): IPrismCallBack; overload;
   procedure Unregister(AName: String);
   function GetCallBack(AName: String): IPrismCallBack;
   function CallBackJS(ACallBackName: String; Parameters: String = ''; LockClient: Boolean = false): string;
   function TempCallBacks: TDictionary<string, IPrismCallBack>;
   procedure ConsolideTempCallBacks(APrismFormToConsolide: IPrismForm);
 end;


 IPrismControlEvent = interface
  ['{19D24223-9B39-41C8-9B70-928FBD54132C}']
  //procedure SetEventType(AEventType: TPrismEventType);
  function GetEventType: TPrismEventType;
  function GetEventID: String;

  procedure SetOnEvent(AOnEvent: TNotifyEvent); overload;
  procedure SetOnEvent(AOnEvent: TPrismGetStrEvent); overload;
  procedure SetOnEvent(AOnEventProc: TOnEventProc); overload;
  function GetPrismControl: IPrismControl;

  function EventTypeName: string;

  procedure CallEvent(Parameters: TStrings);

  function EventJS(EventProc: TEventProcType = ExecEventProc; Parameters: String = ''; LockCLient: Boolean = false): string; overload;
  function EventJS(ASession: IPrismSession; FormUUID: string; EventProc: TEventProcType = ExecEventProc; Parameters: String = ''; LockCLient: Boolean = false): string; overload;

  procedure SetAutoPublishedEvent(AAutoPublished: Boolean);
  function GetAutoPublishedEvent: Boolean;

  //function GetOnEvent: TObject;

  //property OnEvent: TObject Read GetOnEvent;
  //property OnEvent: TNotifyEvent write SetOnEvent;
  property AutoPublishedEvent: Boolean read GetAutoPublishedEvent write SetAutoPublishedEvent;
  property EventType: TPrismEventType read GetEventType;
  property EventID: string read GetEventID;
  property PrismControl: IPrismControl read GetPrismControl;
 end;

 IPrismControlEvents = interface
  ['{3AAE6326-CD78-4275-A065-A3AA82B60A85}']
  procedure Add(AEvent: IPrismControlEvent); overload;
  procedure Add(AEventType: TPrismEventType; AEvent: TNotifyEvent); overload;
  procedure Add(AEventType: TPrismEventType; AOnEventProc: TOnEventProc); overload;
  procedure Add(AEventType: TPrismEventType; AOnEventProc: TOnEventProc; AAutoPublishedEvent: Boolean); overload;
  procedure Delete(AIndex: Integer);
  function Count: integer;
  function Item(AIndex: Integer): IPrismControlEvent; overload;
  function Item(AEventType: TPrismEventType): IPrismControlEvent; overload;
 end;

 IPrismControl = interface
   ['{4030F766-D9EC-4105-9A1E-EC6B412E456B}']
   //Private
   procedure SetName(AName: String);
   function GetName: String;
   function GetNamePrefix: String;
   procedure SetEnabled(AEnabled: Boolean);
   function GetEnabled: Boolean;
   procedure SetVisible(AVisible: Boolean);
   function GetVisible: Boolean;
   procedure SetReadOnly(AReadOnly: Boolean);
   function GetReadOnly: Boolean;
   function GetIsHidden: Boolean;
   procedure SetIsHidden(AIsHidden: Boolean);
   function GetUpdatable: Boolean;
   procedure SetUpdatable(const Value: Boolean);
   function GetPlaceholder: String;
   function GetRequired: Boolean;
   procedure SetRequired(ARequired: Boolean);
   function GetValidationGroup: Variant;
   Procedure SetValidationGroup(AValidationGroup: Variant);
   procedure SetVCLComponent(AComponent: TComponent);
   function GetVCLComponent: TComponent;
   procedure SetForm(APrismForm: IPrismForm);
   function GetForm: IPrismForm;
   procedure FormatHTMLControl(AHTMLText: String);
   procedure SetHTMLControl(AHTMLControl: String);
   function GetHTMLControl: String;
   function GetUnformatedHTMLControl: String;
   function GetHTMLCore: string;
   procedure SetHTMLCore(AHTMLTag: String);
   function GetEvents: IPrismControlEvents;
   function RefreshControl: Boolean;
   function GetTemplateControl: Boolean;
   procedure SetTemplateControl(AValue: Boolean);
//   function GetD2BridgeItem: ID2BridgeItem;
//   procedure SetD2BridgeItem(Value: ID2BridgeItem);
   procedure SetFocus;
   procedure UpdateData;
   procedure RefreshHTMLControl;

   //**AS** PrismControls
   function AsButton: IPrismButton;
   function AsCheckBox: IPrismCheckBox;
   function AsCombobox: IPrismCombobox;
   function AsStringGrid: IPrismStringGrid;

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
   function AsMemo: IPrismMemo;
   function AsHTMLElement: IPrismHTMLElement;
   function AsLink: IPrismLink;
   function AsQRCode: IPrismQRCode;
   function AsCarousel: IPrismCarousel;
   function AsTabs: IPrismTabs;
   function AsControl: IPrismControl;
   function AsControlGeneric: IPrismControlGeneric;
   function AsCard: IPrismCard;
   function AsMainMenu: IPrismMainMenu;
   function AsSideMenu: IPrismSideMenu;
   function AsCardGridDataModel: IPrismCardGridDataModel;
   function AsCardModel: IPrismCardModel;
   function AsKanban: IPrismKanban;
   function AsMarkDownEditor: IPrismMarkDownEditor;
   function AsWYSIWYGEditor: IPrismWYSIWYGEditor;
   function AsCamera: IPrismCamera;
   function AsQRCodeReader: IPrismQRCodeReader;
   function AsBadge: IPrismBadge;
   function AsChart: IPrismChartBase;

   //**IS** PrismControls
   function IsButton: Boolean;
   function IsCheckBox: Boolean;
   function IsCombobox: Boolean;
   function IsStringGrid: Boolean;
   function IsMainMenu: Boolean;
   function IsSideMenu: Boolean;
   function IsKanban: Boolean;

{$IFNDEF FMX}
   function IsDBGrid: Boolean;
   function IsDBCheckBox: Boolean;
   function IsDBCombobox: Boolean;
   function IsDBLookupCombobox: Boolean;
   function IsDBEdit: Boolean;
   function IsDBMemo: Boolean;
   function IsDBText: Boolean;
   function IsButtonedEdit: Boolean;
   function IsCardDataModel: Boolean;
   function isRadioGroup: Boolean;
   function isDBRadioGroup: Boolean;
{$ENDIF}

   function IsEdit: Boolean;
   function IsLabel: Boolean;
   function IsHTMLElement: Boolean;
   function IsImage: Boolean;
   function IsMemo: Boolean;
   function IsControl: Boolean;
   function IsControlGeneric: Boolean;
   function IsLink: Boolean;
   function IsQRCode: Boolean;
   function IsCarousel: boolean;
   function IsTabs: boolean;
   function IsCard: boolean;
   function IsCardGridDataModel: boolean;
   function IsCardModel: boolean;
   function IsMarkDownEditor: boolean;
   function IsWYSIWYGEditor: boolean;
   function IsCamera: Boolean;
   function IsQRCodeReader: Boolean;
   function IsBadge: boolean;
   function IsChart: boolean;

   function NeedCheckValidation: Boolean;
   function Lang: TD2BridgeTerm;
   function Session: IPrismSession;

   //Strong
   procedure Initialize;
   function Initilized: boolean;
   function AlwaysInitialize: Boolean;
   procedure ProcessHTML;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings);
   procedure ProcessEvent(Event: IPrismControlEvent; Parameters: TStrings);
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject);
   function GetEnableComponentState: Boolean;

   //Virtual
   function ValidationGroupPassed: Boolean;

   //Public
   procedure Refresh;
   function PrismOptions: IPrismOptions;

   //Form Laod Events
   procedure DoFormLoadComplete;
   procedure DoFormResize;
   procedure DoFormOrientationChange;
   procedure DoFormUnLoad;

   //Property
   property Name: String read GetName write SetName;
   property NamePrefix: String read GetNamePrefix;
   property Enabled: Boolean read GetEnabled write SetEnabled;
   property Visible: Boolean read GetVisible write SetVisible;
   property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
   property Updatable: Boolean read GetUpdatable write SetUpdatable;
   property Placeholder: String read GetPlaceholder;
   property Hidden: Boolean read GetIsHidden write SetIsHidden;
   property Required: Boolean read GetRequired write SetRequired;
   property ValidationGroup: Variant read GetValidationGroup write SetValidationGroup;
   property HTMLCore: String read GetHTMLCore write SetHTMLCore;
   property HTMLControl: String read GetHTMLControl write SetHTMLControl;
   property Events: IPrismControlEvents read GetEvents;
   property VCLComponent: TComponent read GetVCLComponent write SetVCLComponent;
   property TemplateControl: Boolean read GetTemplateControl write SetTemplateControl;
   property UnformatedHTMLControl: String read GetUnformatedHTMLControl;
   property Form: IPrismForm read GetForm write SetForm;
   property EnableComponentState: Boolean read GetEnableComponentState;
   //property D2BridgeItem: ID2BridgeItem read GetD2BridgeItem write SetD2BridgeItem;
 end;


 IPrismButton = interface(IPrismControl)
  ['{D6315C01-D074-4F89-A6D5-39994EFFFF12}']
   function GetCaption: String;
   procedure SetPopupHTML(Value: String);
   function GetPopupHTML: String;
   function GetCSSButtonIcon: string;
   procedure SetCSSButtonIcon(const Value: string);
   function GetCSSButtonIconPosition: TPrismPosition;
   procedure SetCSSButtonIconPosition(const Value: TPrismPosition);

   property Caption: String read GetCaption;
   property CSSButtonIcon: string read GetCSSButtonIcon write SetCSSButtonIcon;
   property CSSButtonIconPosition: TPrismPosition read GetCSSButtonIconPosition write SetCSSButtonIconPosition;
   property PopupHTML: String read GetPopupHTML write SetPopupHTML;
 end;


 IPrismEdit = interface(IPrismControl)
  ['{E35744F9-6B81-4FED-A3C1-32F4DD31D038}']
   procedure SetText(AText: String);
   function GetText: String;
   procedure SetEditDataType(AEditType: TPrismFieldType);
   function GetEditDataType: TPrismFieldType;
   function GetCharCase: TEditCharCase;
   procedure SetCharCase(ACharCase: TEditCharCase);
   procedure SetTextMask(AValue: string);
   function GetTextMask: string;
   function GetMaxLength: integer;
   procedure SetMaxLength(const Value: integer);

   property Text: String read GetText write SetText;
   property MaxLength: integer read GetMaxLength write SetMaxLength;
   property CharCase: TEditCharCase read GetCharCase write SetCharCase;
   property DataType: TPrismFieldType read GetEditDataType write SetEditDataType;
   property TextMask: string read GetTextMask write SetTextMask;
 end;


 IPrismLabel = interface(IPrismControl)
  ['{3809BA9C-0E8E-4456-9314-106790DD8C0E}']
   function GetText: String;
   procedure SetDataType(Value: TPrismFieldType);
   function GetDataType: TPrismFieldType;
   function GetIsHTMLContent: Boolean;
   procedure SetIsHTMLContent(const Value: Boolean);

   property Text: String read GetText;
   property DataType: TPrismFieldType read GetDataType write SetDataType;
   property IsHTMLContent: Boolean read GetIsHTMLContent write SetIsHTMLContent;
 end;


 IPrismHTMLElement = interface(IPrismControl)
  ['{5EBC9C03-9932-4F38-9F2A-8A16D052D018}']
   function GetHTML: String;
   procedure SetHTML(AHTML: string);
   function GetLabelHTMLElement: TComponent;
   procedure SetLabelHTMLElement(AComponent: TComponent);

   property HTML: String read GetHTML write SetHTML;
   property LabelHTMLElement: TComponent read GetLabelHTMLElement write SetLabelHTMLElement;
 end;


 IPrismLink = interface(IPrismControl)
  ['{AE21796F-1E5F-414A-89E5-730CBBA64F16}']
   function GetText: String;
   procedure SetText(Value: string);
   function GetOnClickCallBack: String;
   procedure SetOnClickCallBack(Value: string);
   function Gethref: String;
   procedure Sethref(Value: string);
   function GetHint: String;
   procedure SetHint(Value: string);
   function GetOnClick: TNotifyEvent;
   procedure SetOnclick(Value: TNotifyEvent);
   function GetLabelHTMLElement: TComponent;
   procedure SetLabelHTMLElement(AComponent: TComponent);

   property Text: String read GetText write SetText;
   property OnClickCallBack: String read GetOnClickCallBack write SetOnClickCallBack;
   property OnClick: TNotifyEvent read GetOnClick write SetOnclick;
   property href: String read Gethref write Sethref;
   property Hint: String read GetHint write SetHint;
   property LabelHTMLElement: TComponent read GetLabelHTMLElement write SetLabelHTMLElement;
 end;


 IPrismCarousel = interface(IPrismControl)
  ['{AE21796F-1E5F-414A-89E5-730CBBA64F16}']
{$IFNDEF FMX}
   procedure SetDataSource(const Value: TDataSource);
   function GetDataSource: TDataSource;
   procedure SetDataFieldImagePath(AValue: String);
   function GetDataFieldImagePath: String;
{$ENDIF}
   function GetAutoSlide: boolean;
   procedure SetAutoSlide(Value: boolean);
   function GetInterval: integer;
   procedure SetInterval(Value: integer);
   function GetShowButtons: boolean;
   procedure SetShowButtons(Value: boolean);
   function GetShowIndicator: boolean;
   procedure SetShowIndicator(Value: boolean);
   procedure UpdateData;

   function ImageFiles: TList<string>;

   property AutoSlide: boolean read GetAutoSlide write SetAutoSlide;
   property ShowButtons: boolean read GetShowButtons write SetShowButtons;
   property ShowIndicator: boolean read GetShowIndicator write SetShowIndicator;
   property Interval: integer read GetInterval write SetInterval;
{$IFNDEF FMX}
   property DataSource: TDataSource read GetDataSource write SetDataSource;
   property DataFieldImagePath: String read GetDataFieldImagePath write SetDataFieldImagePath;
{$ENDIF}
 end;



 IPrismCarouselItem = interface(IPrismControl)
  ['{7E07EEA6-F939-4BD3-99F9-D17F0B396CB6}']
   function GetText: string;
   procedure SetText(Value: string);


 end;



 IPrismQRCode = interface(IPrismControl)
  ['{EA1D6F78-104F-49D6-BDC8-F37967FC30C8}']
{$IFNDEF FMX}
   procedure SetDataSource(const Value: TDataSource);
   function GetDataSource: TDataSource;
   procedure SetDataField(Value: String);
   function GetDataField: String;
{$ENDIF}
   function GetText: string;
   procedure SetText(const Value: string);
   function GetSize: integer;
   procedure SetSize(const Value: integer);
   function GetColorCode: string;
   procedure SetColorCode(const Value: string);
   function GetColorBackground: string;
   procedure SetColorBackground(const Value: string);

   function Base64FromBitmap(ABitmap: TBitmap): string;
   function Base64FromQRCode: string;

{$IFNDEF FMX}
   property DataSource: TDataSource read GetDataSource write SetDataSource;
   property DataField: String read GetDataField write SetDataField;
{$ENDIF}
   property Text: string read GetText write SetText;
   property Size: integer read GetSize write SetSize;
   property ColorCode: string read GetColorCode write SetColorCode;
   property ColorBackground: string read GetColorBackground write SetColorBackground;
 end;



 IPrismEditor = interface(IPrismControl)
  ['{4936D82A-6B88-45CE-AE26-E32B1102E715}']
   function GetShowButtonBold: boolean;
   function GetShowButtonCode: Boolean;
   function GetShowButtonFullScrean: Boolean;
   function GetShowButtonHeading: boolean;
   function GetShowButtonHelp: Boolean;
   function GetShowButtonItalic: boolean;
   function GetShowButtonLink: Boolean;
   function GetShowButtonList: Boolean;
   function GetShowButtonNumList: Boolean;
   function GetShowButtonRule: Boolean;
   function GetShowButtonStrikethrough: boolean;
   function GetShowButtonTable: Boolean;
   function GetShowButtonImage: Boolean;
   function GetShowToolbar: Boolean;
   procedure SetShowButtonBold(const Value: boolean);
   procedure SetShowButtonCode(const Value: Boolean);
   procedure SetShowButtonFullScrean(const Value: Boolean);
   procedure SetShowButtonHeading(const Value: boolean);
   procedure SetShowButtonHelp(const Value: Boolean);
   procedure SetShowButtonImage(const Value: Boolean);
   procedure SetShowButtonItalic(const Value: boolean);
   procedure SetShowButtonLink(const Value: Boolean);
   procedure SetShowButtonList(const Value: Boolean);
   procedure SetShowButtonNumList(const Value: Boolean);
   procedure SetShowButtonRule(const Value: Boolean);
   procedure SetShowButtonStrikethrough(const Value: boolean);
   procedure SetShowButtonTable(const Value: Boolean);
   procedure SetShowToolbar(const Value: Boolean);

   function GetText: string;
   procedure SetText(const Value: string);
   function GetTextVCLComponent: TComponent;
   procedure SetTextVCLComponent(AComponent: TComponent);
   function GetHeight: Integer;
   procedure SetHeight(const Value: Integer);

{$IFnDEF FMX}
   function DataWare: TPrismDataLinkField;
{$ENDIF}

   property ShowToolbar: Boolean read GetShowToolbar write SetShowToolbar;
   property ShowButtonBold: boolean read GetShowButtonBold write SetShowButtonBold;
   property ShowButtonCode: Boolean read GetShowButtonCode write SetShowButtonCode;
   property ShowButtonFullScrean: Boolean read GetShowButtonFullScrean write SetShowButtonFullScrean;
   property ShowButtonHeading: boolean read GetShowButtonHeading write SetShowButtonHeading;
   property ShowButtonHelp: Boolean read GetShowButtonHelp write SetShowButtonHelp;
   property ShowButtonImage: Boolean read GetShowButtonImage write SetShowButtonImage;
   property ShowButtonItalic: boolean read GetShowButtonItalic write SetShowButtonItalic;
   property ShowButtonLink: Boolean read GetShowButtonLink write SetShowButtonLink;
   property ShowButtonList: Boolean read GetShowButtonList write SetShowButtonList;
   property ShowButtonNumList: Boolean read GetShowButtonNumList write SetShowButtonNumList;
   property ShowButtonRule: Boolean read GetShowButtonRule write SetShowButtonRule;
   property ShowButtonStrikethrough: boolean read GetShowButtonStrikethrough write SetShowButtonStrikethrough;
   property ShowButtonTable: Boolean read GetShowButtonTable write SetShowButtonTable;

   property Text: string read GetText write SetText;
   property Height: Integer read GetHeight write SetHeight;
   property TextVCLComponent: TComponent read GetTextVCLComponent write SetTextVCLComponent;
 end;


 IPrismMarkDownEditor = interface(IPrismEditor)
  ['{F9316447-24AB-4A3A-A62D-74CFEE28B550}']
   function GetShowButtonPreview: Boolean;
   function GetShowButtonQuote: Boolean;
   function GetShowButtonSplit: Boolean;
   function GetShowButtonUpload: Boolean;
   procedure SetShowButtonPreview(const Value: Boolean);
   procedure SetShowButtonQuote(const Value: Boolean);
   procedure SetShowButtonSplit(const Value: Boolean);
   procedure SetShowButtonUpload(const Value: Boolean);

   property ShowButtonPreview: Boolean read GetShowButtonPreview write SetShowButtonPreview;
   property ShowButtonQuote: Boolean read GetShowButtonQuote write SetShowButtonQuote;
   property ShowButtonSplit: Boolean read GetShowButtonSplit write SetShowButtonSplit;
   property ShowButtonUpload: Boolean read GetShowButtonUpload write SetShowButtonUpload;
 end;



 IPrismWYSIWYGEditor = interface(IPrismEditor)
  ['{D36E1663-7C9A-4E80-AB2A-E2D5B3FA4199}']
   function GetAirMode: Boolean;
   function GetShowButtonColor: Boolean;
   function GetShowButtonFontName: Boolean;
   function GetShowButtonFontSize: Boolean;
   function GetShowButtonHTMLPreview: Boolean;
   function GetShowButtonUnderline: Boolean;
   function GetShowButtonVideo: Boolean;

   procedure SetAirMode(const Value: Boolean);
   procedure SetShowButtonColor(const Value: Boolean);
   procedure SetShowButtonFontName(const Value: Boolean);
   procedure SetShowButtonFontSize(const Value: Boolean);
   procedure SetShowButtonHTMLPreview(const Value: Boolean);
   procedure SetShowButtonUnderline(const Value: Boolean);
   procedure SetShowButtonVideo(const Value: Boolean);

   property AirMode: Boolean read GetAirMode write SetAirMode;
   property ShowButtonColor: Boolean read GetShowButtonColor write SetShowButtonColor;
   property ShowButtonFontName: Boolean read GetShowButtonFontName write SetShowButtonFontName;
   property ShowButtonFontSize: Boolean read GetShowButtonFontSize write SetShowButtonFontSize;
   property ShowButtonHTMLPreview: Boolean read GetShowButtonHTMLPreview write SetShowButtonHTMLPreview;
   property ShowButtonUnderline: Boolean read GetShowButtonUnderline write SetShowButtonUnderline;
   property ShowButtonVideo: Boolean read GetShowButtonVideo write SetShowButtonVideo;
 end;



 IPrismCamera = interface(IPrismControl)
  ['{FFA08844-641A-4D58-8FB4-735E3B4B14BA}']
 end;


 IPrismQRCodeReader = interface(IPrismControl)
  ['{82262334-CE87-444C-80C1-F7336875DAB8}']
   function GetTextVCLComponent: TComponent;
   procedure SetTextVCLComponent(AComponent: TComponent);
   function GetPressReturnKey: Boolean;
   procedure SetPressReturnKey(const Value: Boolean);
   function GetBorderShaders: Boolean;
   procedure SetBorderShaders(const Value: Boolean);
   procedure SetContinuousScan(const Value: Boolean);
   function GetContinuousScan: Boolean;
   function GetOnRead: TNotifyEventStr;
   procedure SetOnRead(const Value: TNotifyEventStr);
   function GetEnableAZTEC: boolean;
   function GetEnableCODABAR: boolean;
   function GetEnableCODE128: boolean;
   function GetEnableCODE39: boolean;
   function GetEnableCODE93: boolean;
   function GetEnableDATAMATRIX: boolean;
   function GetEnableEAN13: boolean;
   function GetEnableEAN8: boolean;
   function GetEnableITF: boolean;
   function GetEnableMAXICODE: boolean;
   function GetEnablePDF417: boolean;
   function GetEnableQRCODE: boolean;
   function GetEnableRSS14: boolean;
   function GetEnableRSSEXPANDED: boolean;
   function GetEnableUPCA: boolean;
   function GetEnableUPCE: boolean;
   function GetEnableUPCEANEXTENSION: boolean;
   procedure SetEnableAZTEC(const Value: boolean);
   procedure SetEnableCODABAR(const Value: boolean);
   procedure SetEnableCODE128(const Value: boolean);
   procedure SetEnableCODE39(const Value: boolean);
   procedure SetEnableCODE93(const Value: boolean);
   procedure SetEnableDATAMATRIX(const Value: boolean);
   procedure SetEnableEAN13(const Value: boolean);
   procedure SetEnableEAN8(const Value: boolean);
   procedure SetEnableITF(const Value: boolean);
   procedure SetEnableMAXICODE(const Value: boolean);
   procedure SetEnablePDF417(const Value: boolean);
   procedure SetEnableQRCODE(const Value: boolean);
   procedure SetEnableRSS14(const Value: boolean);
   procedure SetEnableRSSEXPANDED(const Value: boolean);
   procedure SetEnableUPCA(const Value: boolean);
   procedure SetEnableUPCE(const Value: boolean);
   procedure SetEnableUPCEANEXTENSION(const Value: boolean);

   procedure EnableAllCodesFormat;
   procedure DisableAllCodesFormat;

   property EnableQRCODE: boolean read GetEnableQRCODE write SetEnableQRCODE;
   property EnableAZTEC: boolean read GetEnableAZTEC write SetEnableAZTEC;
   property EnableCODABAR: boolean read GetEnableCODABAR write SetEnableCODABAR;
   property EnableCODE39: boolean read GetEnableCODE39 write SetEnableCODE39;
   property EnableCODE93: boolean read GetEnableCODE93 write SetEnableCODE93;
   property EnableCODE128: boolean read GetEnableCODE128 write SetEnableCODE128;
   property EnableDATAMATRIX: boolean read GetEnableDATAMATRIX write SetEnableDATAMATRIX;
   property EnableMAXICODE: boolean read GetEnableMAXICODE write SetEnableMAXICODE;
   property EnableITF: boolean read GetEnableITF write SetEnableITF;
   property EnableEAN13: boolean read GetEnableEAN13 write SetEnableEAN13;
   property EnableEAN8: boolean read GetEnableEAN8 write SetEnableEAN8;
   property EnablePDF417: boolean read GetEnablePDF417 write SetEnablePDF417;
   property EnableRSS14: boolean read GetEnableRSS14 write SetEnableRSS14;
   property EnableRSSEXPANDED: boolean read GetEnableRSSEXPANDED write SetEnableRSSEXPANDED;
   property EnableUPCA: boolean read GetEnableUPCA write SetEnableUPCA;
   property EnableUPCE: boolean read GetEnableUPCE write SetEnableUPCE;
   property EnableUPCEANEXTENSION: boolean read GetEnableUPCEANEXTENSION write SetEnableUPCEANEXTENSION;

   property TextVCLComponent: TComponent read GetTextVCLComponent write SetTextVCLComponent;
   property BorderShaders: Boolean read GetBorderShaders write SetBorderShaders;
   property PressReturnKey: Boolean read GetPressReturnKey write SetPressReturnKey;
   property ContinuousScan: Boolean read GetContinuousScan write SetContinuousScan;
   property OnRead: TNotifyEventStr read GetOnRead write SetOnRead;
 end;


 IPrismMenuItem = interface
  ['{47D0E60C-3397-4768-AAA9-E534807C2841}']
   function GetName: String;
   procedure SetName(const Value: String);
   function GetCaption: String;
   procedure SetCaption(const Value: String);
   function GetCSSClass: string;
   procedure SetCSSClass(Value: string);
   function GetHTMLExtras: string;
   procedure SetHTMLExtras(Value: string);
   function GetHTMLStyle: string;
   procedure SetHTMLStyle(Value: string);
   function GetIcon: String;
   procedure SetIcon(const Value: String);
   procedure SetEnabled(AEnabled: Boolean);
   function GetEnabled: Boolean;
   procedure SetVisible(AVisible: Boolean);
   function GetVisible: Boolean;
   function GetMenuItemGroup: IPrismMenuItemGroup;
   procedure SetMenuItemGroup(const Value: IPrismMenuItemGroup);
   function GetGroupIndex: Integer;
   procedure SetGroupIndex(const Value: Integer);
   procedure SetVCLComponent(Value: TComponent);
   function GetVCLComponent: TComponent;
   function GetOwner: TObject;

   function IsLink: Boolean;
   function IsGroup: Boolean;
   function IsSubMenu: Boolean;

   function Level: Integer;

   property Name: String read GetName write SetName;
   property Caption: String read GetCaption write SetCaption;
   property Icon: String read GetIcon write SetIcon;
   property CSSClasses: string read GetCSSClass write SetCSSClass;
   property HTMLExtras: string read GetHTMLExtras write SetHTMLExtras;
   property HTMLStyle: string read GetHTMLStyle write SetHTMLStyle;
   property Enabled: Boolean read GetEnabled write SetEnabled;
   property Visible: Boolean read GetVisible write SetVisible;
   property MenuItemGroup: IPrismMenuItemGroup read GetMenuItemGroup write SetMenuItemGroup;
   property GroupIndex: Integer read GetGroupIndex write SetGroupIndex;
   property VCLComponent: TComponent read GetVCLComponent write SetVCLComponent;
   property Owner: TObject read GetOwner;
 end;


 IPrismMenuItemGroup = interface(IPrismMenuItem)
  ['{A4B42D5D-4960-4817-8DA6-9B6A570D3837}']
   function GetGroupIndex: Integer;
   procedure SetGroupIndex(const Value: Integer);

   property GroupIndex: Integer read GetGroupIndex write SetGroupIndex;
 end;



 IPrismMenuItemSubMenu = interface(IPrismMenuItem)
  ['{143E0C19-40B8-4EDD-AC3F-3F47A82B4C84}']
  function MenuItems: IPrismMenuItems;
 end;


 IPrismMenuItemLink = interface(IPrismMenuItem)
  ['{F6A6C981-95E2-41C0-B198-597707313622}']
 end;


 IPrismMenuItems = interface
  ['{A5BC99BA-B499-4D82-A78A-4476F2C2464F}']
  Procedure Clear;
  function GetOwner: TObject;
  function GetMenuItems: TList<IPrismMenuItem>;
  procedure Add(AMenuItem: IPrismMenuItem); overload;
  function AddLink: IPrismMenuItemLink;
  function AddSubMenu: IPrismMenuItemSubMenu;
  function FromName(AName: string): IPrismMenuItem;
  function FromVCLComponent(AMenuItemComponent: TObject): IPrismMenuItem;

  function PrismMenu: IPrismMenu;

  function Level: Integer;

  property Items: TList<IPrismMenuItem> read GetMenuItems;
  property Owner: TObject read GetOwner;
 end;


 IPrismMenu = interface(IPrismControl)
  ['{976736E5-A587-476E-8A83-53D8583E32F3}']
  function GetTitle: string;
  procedure SetTitle(Value: String);
  function GetMenuGroup(Index: Integer): IPrismMenuItemGroup;
  function GetColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
  function GetDark: boolean;
  function GetTitleColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
  procedure SetColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
  procedure SetDark(const Value: boolean);
  procedure SetTitleColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
  function GetMenuTextColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
  procedure SetMenuTextColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});

  function MenuItems: IPrismMenuItems;
  function MenuItemFromVCLComponent(AMenuItemComponent: TObject): IPrismMenuItem; overload;
  function MenuItemFromName(AName: String): IPrismMenuItem; overload;
  function MenuItemFromCaption(AText: String): IPrismMenuItem;
  function MenuGroups: TList<IPrismMenuItemGroup>;
  function Image: ID2BridgeImage;

  property Title: String read GetTitle write SetTitle;
  property MenuGroup[Index: Integer]: IPrismMenuItemGroup read GetMenuGroup;

  property Dark: boolean read GetDark write SetDark;
  property Color: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF} read GetColor write SetColor;
  property TitleColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF} read GetTitleColor write SetTitleColor;
  property MenuTextColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF} read GetMenuTextColor write SetMenuTextColor;
 end;


 IPrismMenuPanel = interface
  ['{C690ABB0-F239-490E-92E9-BC5DB9209C69}']
  function GetColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
  procedure SetColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});

  property Color: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF} read GetColor write SetColor;
 end;


 IPrismMainMenu = interface(IPrismMenu)
  ['{98F72AE1-231B-4712-B148-16EED972C8F9}']
//  function GetRightItemsHTML: String;
//  procedure SetRightItemsHTML(const Value: String);
//  function GetAccessoryItemsHTML: String;
//  procedure SetAccessoryItemsHTML(const Value: String);
//  function GetPanelTopItemsHTML: String;
//  procedure SetPanelTopItemsHTML(const Value: String);
  function GetMenuAlign: TPrismAlignment;
  procedure SetMenuAlign(const Value: TPrismAlignment);
  function GetTransparent: Boolean;
  procedure SetTransparent(const Value: Boolean);

  function PanelTop: IPrismMenuPanel;
  function PanelBottom: IPrismMenuPanel;

  //property RightItemsHTML: String read GetRightItemsHTML write SetRightItemsHTML;
  //property AccessoryItemsHTML: String read GetAccessoryItemsHTML write SetAccessoryItemsHTML;
  //property PanelTopItemsHTML: String read GetPanelTopItemsHTML write SetPanelTopItemsHTML;
  property MenuAlign: TPrismAlignment read GetMenuAlign write SetMenuAlign;
  property Transparent: Boolean read GetTransparent write SetTransparent;
 end;


 IPrismSideMenu = interface(IPrismMenu)
  ['{8A5195AF-5352-4A0F-9738-82FEEBF3E2AF}']

 end;


 IPrismControlGeneric = interface(IPrismControl)
  ['{4E5F5DBE-5A06-42EB-9D89-26DD8822595C}']

 end;


 IPrismCard = interface(IPrismControl)
  ['{B423D3CE-0DC0-430E-A553-90A4741B0494}']
   function GetExitProc: TProc;
   function GetOnExit: TNotifyEvent;
   procedure SetExitProc(const Value: TProc);
   procedure SetOnExit(const Value: TNotifyEvent);
   function GetCloseFormOnExit: Boolean;
   procedure SetCloseFormOnExit(const Value: Boolean);
   function GetTitle: string;
   procedure SetTitle(ATitle: string);
   function GetTitleHeader: string;
   procedure SetTitleHeader(Value: string);
   function GetSubTitle: string;
   procedure SetSubTitle(ASubTitle: string);
   function GetText: string;
   procedure SetText(Value: string);

   property OnExit: TNotifyEvent read GetOnExit write SetOnExit;
   property ExitProc: TProc read GetExitProc write SetExitProc;
   property CloseFormOnExit: Boolean read GetCloseFormOnExit write SetCloseFormOnExit;
   property Title: string read GetTitle write SetTitle;
   property TitleHeader: string read GetTitleHeader write SetTitleHeader;
   property SubTitle: string read GetSubTitle write SetSubTitle;
   property Text: string read GetText write SetText;
 end;


{$IFNDEF FMX}
 IPrismCardDataModel = interface(IPrismCard)
  ['{CBBFE1E3-5730-423A-97BB-EE7621B8D095}']
  function CardGrid: IPrismCardGridDataModel;
  function IsCardGridContainer: Boolean;
 end;
{$ENDIF}


 IPrismCardModel = interface(IPrismCard)
  ['{CE49B426-B7D5-4A3C-A030-1A8FDFE76817}']
  function GetCoreHTML: string;
  procedure SetCoreHTML(const Value: string);
  function GetKanbanColumn: IPrismKanbanColumn;
  function GetIdentify: string;
  procedure SetIdentify(const Value: string);
  function GetRow: integer;

  function PrismControlIDS: TList<string>;

  function IsKanbanContainer: Boolean;

  property KanbanColumn: IPrismKanbanColumn read GetKanbanColumn;
  property CoreHTML: string read GetCoreHTML write SetCoreHTML;
  property Identify: string read GetIdentify write SetIdentify;
  property Row: integer read GetRow;
 end;


 IPrismCardGridDataModel = interface(IPrismControl)
  ['{AE21796F-1E5F-414A-89E5-730CBBA64F16}']
{$IFNDEF FMX}
   procedure SetDataSource(const Value: TDataSource);
   function GetDataSource: TDataSource;
{$ENDIF}
   function GetColSize: string;
   procedure SetColSize(const Value: string);
   function GetMaxRecords: integer;
   Procedure SetMaxRecords(AMaxRecords: Integer);
   function GetCardClick: boolean;
   procedure SetCardClick(const Value: boolean);

   procedure UpdateData;

   function PrismControlIDS: TList<string>;

   function Row: integer;

   property CardClick: boolean read GetCardClick write SetCardClick;
   property ColSize: string read GetColSize write SetColSize;
{$IFNDEF FMX}
   property DataSource: TDataSource read GetDataSource write SetDataSource;
   property MaxRecords: Integer read GetMaxRecords write SetMaxRecords;
{$ENDIF}
 end;


 IPrismKanban = interface(IPrismControl)
  ['{8F27A09C-5E76-440E-893A-CD52D8BE7B2F}']
   function GetColumn(const ItemIndex: integer): IPrismKanbanColumn;
   function GetCardModel: IPrismCardModel;
   procedure SetCardModel(const Value: IPrismCardModel);
   function GetTopColorAuto: boolean;
   procedure SetTopColorAuto(const Value: boolean);
   function GetAddClickProc: TProc;
   function GetOnAddClick: TNotifyEvent;
   procedure SetAddClickProc(const Value: TProc);
   procedure SetOnAddClick(const Value: TNotifyEvent);
   function GetColumnFromName(const AName: string): IPrismKanbanColumn;
   function GetColumnFromIdentify(const AIdentify: string): IPrismKanbanColumn;

   function Columns: TList<IPrismKanbanColumn>;
   function AddColumn: IPrismKanbanColumn;

   property CardModel: IPrismCardModel read GetCardModel write SetCardModel;
   property Column[const ItemIndex: integer]: IPrismKanbanColumn read GetColumn;
   property ColumnFromIdentify[const AIdentify: string]: IPrismKanbanColumn read GetColumnFromIdentify;
   property ColumnFromName[const AName: string]: IPrismKanbanColumn read GetColumnFromName;
   property TopColorAuto: boolean read GetTopColorAuto write SetTopColorAuto;
   property OnAddClick: TNotifyEvent read GetOnAddClick write SetOnAddClick;
   property AddClickProc: TProc read GetAddClickProc write SetAddClickProc;
 end;


 IPrismKanbanColumn = interface
  ['{AB074359-20A9-402D-906C-0CB0C3E999D1}']
   procedure SetName(AName: String);
   function GetName: String;
   function GetColumnIndex: integer;
   procedure SetColumnIndex(const Value: integer);
   function GetIdentify: string;
   procedure SetIdentify(const Value: string);
   function GetTitle: string;
   procedure SetTitle(const Value: string);
   function GetTopColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
   procedure SetTopColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});

   function Kanban: IPrismKanban;

   procedure AddCadsToInitialize(AQty: integer);
   function AddCard: IPrismCardModel;

   function Count: integer;

   property Name: String read GetName write SetName;
   property ColumnIndex: integer read GetColumnIndex write SetColumnIndex;
   property Identify: string read GetIdentify write SetIdentify;
   property Title: string read GetTitle write SetTitle;
   property TopColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF} read GetTopColor write SetTopColor;
 end;


 IPrismTabs = interface(IPrismControl)
  ['{C0D89AF4-142C-4EEC-8DCD-2AD6422DFC01}']
   function GetActiveTabIndex: integer;
   procedure SetActiveTabIndex(Value: integer);
   function GetShowTabs: Boolean;
   procedure SetShowTabs(const Value: Boolean);
//   function GetTabVisible(Index: Integer): boolean;
   procedure SetTabVisible(Index: Integer; Value: Boolean);
   procedure SetTabVisibleFromCaption(ACaption: string; const Value: Boolean);
//   function GetTabEnabled(Index: Integer): boolean;
//   procedure SetTabEnabled(Index: Integer; Value: Boolean);
//   function GetTabActive(Index: Integer): boolean;
//   procedure SetTabActive(Index: Integer; Value: Boolean);

   property ActiveTabIndex: integer read GetActiveTabIndex write SetActiveTabIndex;
   property TabVisible[Index: Integer]: Boolean write SetTabVisible;
   property ShowTabs: Boolean read GetShowTabs write SetShowTabs;
   property TabVisibleFromCaption[ACaption: string]: Boolean write SetTabVisibleFromCaption;
//   property TabEnabled[Index: Integer]: Boolean read GetTabEnabled write SetTabEnabled;
//   property TabActive[Index: Integer]: Boolean read GetTabActive write SetTabActive;
 end;


 IPrismCombobox = interface(IPrismControl)
  ['{8834442C-84E1-4989-A2BE-A7FE2588383A}']
   procedure SetSelectedItem(AText: String);
   function GetSelectedItem: String;
   function GetItems: TStrings;

   property Items: TStrings read GetItems;
   property SelectedItem: String read GetSelectedItem write SetSelectedItem;
 end;


 IPrismImage = interface(IPrismControl)
  ['{DD6C1006-2226-4529-AEB6-66E66B73DE32}']
   procedure SetPicture(APicture: {$IFNDEF FMX}TPicture{$ELSE}TBitmap{$ENDIF});
   function GetPicture: {$IFNDEF FMX}TPicture{$ELSE}TBitmap{$ENDIF};
   procedure SetURLImage(AURL: string);
   function GetURLImage: string;

   property Picture: {$IFNDEF FMX}TPicture{$ELSE}TBitmap{$ENDIF} read GetPicture write setPicture;
   property URLImage: String read GetURLImage write SetURLImage;
 end;


 IPrismMemo = interface(IPrismControl)
  ['{ED51EE1F-481D-451E-9CC5-713A40BB98DE}']
   procedure SetLines(ALines: TStrings);
   function GetLines: TStrings;

   procedure SetRows(ARows: Integer);
   function GetRows: Integer;

   property Lines: TStrings read GetLines write SetLines;
   property Rows: Integer read GetRows write SetRows;
 end;


 IPrismRadioGroup = interface(IPrismControl)
  ['{C6024A0E-1061-4435-ADEF-C7265DF48778}']
   function GetItems: TStrings;
   function GetCaption: string;
   procedure SetCaption(const Value: string);
   function GetItemIndex: Integer;
   procedure SetItemIndex(const Value: Integer);

   property Items: TStrings read GetItems;
   property Caption: string read GetCaption write SetCaption;
   property ItemIndex: Integer read GetItemIndex write SetItemIndex;
 end;


{$IFNDEF FMX}
 IPrismDBRadioGroup = interface(IPrismControl)
  ['{110F1FF3-5D7C-4D9C-A4B8-02BF88B319A2}']
   function GetCaption: string;
   procedure SetCaption(const Value: string);
   function GetItems: TStrings;
   function GetColumns: Integer;
   procedure SetColumns(const Value: Integer);

   function DataWare: TPrismDataLinkField;

   property Caption: string read GetCaption write SetCaption;
   property Items: TStrings read GetItems;
   property Columns: integer read GetColumns write SetColumns;
 end;
{$ENDIF}


{$IFNDEF FMX}
 IPrismButtonedEdit = interface(IPrismEdit)
  ['{7113EEEB-3D7F-4DDF-AC85-8210985D5FB3}']
   function GetButtonLeftVisible: boolean;
   function GetButtonLeftEnabled: boolean;
   procedure SetButtonLeftCSS(Value: String);
   function GetButtonLeftCSS: string;
   procedure SetButtonLeftText(Value: String);
   function GetButtonLeftText: string;

   function GetButtonRightVisible: boolean;
   function GetButtonRightEnabled: boolean;
   procedure SetButtonRightCSS(Value: String);
   function GetButtonRightCSS: string;
   procedure SetButtonRightText(Value: String);
   function GetButtonRightText: string;

   property ButtonLeftVisible: boolean read GetButtonLeftVisible;
   property ButtonLeftEnabled: boolean read GetButtonLeftEnabled;
   property ButtonLeftCSS: string read GetButtonLeftCSS write SetButtonLeftCSS;
   property ButtonLeftText: string read GetButtonLeftText write SetButtonLeftText;
   property ButtonRightVisible: boolean read GetButtonRightVisible;
   property ButtonRightEnabled: boolean read GetButtonRightEnabled;
   property ButtonRightCSS: string read GetButtonRightCSS write SetButtonRightCSS;
   property ButtonRightText: string read GetButtonRightText write SetButtonRightText;
 end;
{$ENDIF}


{$IFNDEF FMX}
 IPrismDBText = interface(IPrismControl)
  ['{13E08927-E48C-46FE-8F42-CA3EBA86E895}']
   procedure SetDataType(Value: TPrismFieldType);
   function GetDataType: TPrismFieldType;
   function GetIsHTMLContent: Boolean;
   procedure SetIsHTMLContent(const Value: Boolean);

   function DataWare: TPrismDataLinkField;

   property DataType: TPrismFieldType read GetDataType write SetDataType;
   property IsHTMLContent: Boolean read GetIsHTMLContent write SetIsHTMLContent;
 end;


 IPrismDBEdit = interface(IPrismControl)
  ['{0DBB4BF4-F29F-4C94-904C-5D8C4D00510B}']
   function GetCharCase: TEditCharCase;
   procedure SetCharCase(ACharCase: TEditCharCase);
   procedure SetTextMask(AValue: string);
   function GetTextMask: string;
   procedure SetEditDataType(AEditType: TPrismFieldType);
   function GetEditDataType: TPrismFieldType;

   function DataWare: TPrismDataLinkField;

   property CharCase: TEditCharCase read GetCharCase write SetCharCase;
   property TextMask: string read GetTextMask write SetTextMask;
   property DataType: TPrismFieldType read GetEditDataType write SetEditDataType;
 end;


 IPrismDBImage = interface(IPrismControl)
  ['{25E1C8A9-B79E-4E16-A03D-E4596D143EBA}']
   procedure SetImageFolder(AValue: String);
   function GetImageFolder: String;

   function DataWare: TPrismDataLinkField;

   property ImageFolder: String read GetImageFolder write SetImageFolder;
 end;
{$ENDIF}

 IPrismCheckBox = interface(IPrismControl)
  ['{02FA592A-8A62-4802-BECD-AFCAF5D7CFB4}']
   function GetText: String;
   procedure SetChecked(AValue: Boolean);
   function GetChecked: Boolean;
   function GetSwitchMode: Boolean;
   procedure SetSwitchMode(const Value: Boolean);

   property Text: String read GetText;
   property Checked: Boolean read GetChecked write SetChecked;
   property SwitchMode: Boolean read GetSwitchMode write SetSwitchMode;
 end;

{$IFNDEF FMX}
 IPrismDBCheckBox = interface(IPrismControl)
  ['{689DF9AA-50D9-43D1-ACC3-55E4C625B3F0}']
   function GetText: String;
   procedure SetDataSource(const Value: TDataSource);
   function GetDataSource: TDataSource;
   procedure SetDataField(AValue: String);
   function GetDataField: String;
   function GetValueChecked: String;
   procedure SetValueChecked(AValue: String);
   function GetValueUnChecked: String;
   procedure SetValueUnChecked(AValue: String);
   function GetChecked: Boolean;
   procedure SetChecked(AValue: Boolean);
   function GetSwitchMode: Boolean;
   procedure SetSwitchMode(const Value: Boolean);

   property Text: String read GetText;
   property DataSource: TDataSource read GetDataSource write SetDataSource;
   property DataField: String read GetDataField write SetDataField;
   property ValueChecked: String read GetValueChecked write SetValueChecked;
   property ValueUnChecked: String read GetValueUnChecked write SetValueUnChecked;
   property Checked: Boolean read GetChecked write SetChecked;
   property SwitchMode: Boolean read GetSwitchMode write SetSwitchMode;
 end;


 IPrismDBCombobox = interface(IPrismControl)
  ['{591AF4BB-6588-4428-8B2B-5183E4C5F64B}']
   function GetItems: TStrings;

   function DataWare: TPrismDataLinkField;

   property Items: TStrings read GetItems;
 end;


 IPrismDBLookupCombobox = interface(IPrismControl)
  ['{591AF4BB-6588-4428-8B2B-5183E4C5F64B}']
   procedure SetDataSource(const Value: TDataSource);
   function GetDataSource: TDataSource;
   procedure SetDataField(AValue: String);
   function GetDataField: String;
   procedure SetListDataSource(const Value: TDataSource);
   function GetListDataSource: TDataSource;
   function GetListDataField: string;
   Procedure SetListDataField(AFieldName: string);
   function GetKeyDataField: string;
   Procedure SetKeyDataField(AFieldName: string);
   function GetMaxRecords: integer;
   Procedure SetMaxRecords(AMaxRecords: Integer);
   procedure SetSelectedItem(AText: String);
   function GetSelectedItem: String;

   property DataSource: TDataSource read GetDataSource write SetDataSource;
   property DataField: String read GetDataField write SetDataField;
   property ListDataSource: TDataSource read GetListDataSource write SetListDataSource;
   property ListDataField: String read GetListDataField write SetListDataField;
   property KeyDataField: String read GetKeyDataField write SetKeyDataField;
   property MaxRecords: Integer read GetMaxRecords write SetMaxRecords;
   property SelectedItem: String read GetSelectedItem write SetSelectedItem;
 end;


 IPrismDBMemo = interface(IPrismControl)
  ['{C046E938-7485-4EE5-8ABF-2B82FC0870B6}']
   procedure SetRows(ARows: Integer);
   function GetRows: Integer;

   function DataWare: TPrismDataLinkField;

   property Rows: Integer read GetRows write SetRows;
 end;
{$ENDIF}


 IButtonModel = interface
  ['{81377E95-A6E4-4357-9DD0-B3C5BFB599D5}']
   Function GetCSSButtonType: string;
   Procedure SetCSSButtonType(AValue: string);
   function GetCSSButtonHeigth: string;
   function GetCSSButtonIcon: string;
   function GetCSSButtonWidth: string;
   procedure SetCSSButtonHeigth(const Value: string);
   procedure SetCSSButtonIcon(const Value: string);
   procedure SetCSSButtonWidth(const Value: string);
   Function GetCaption: string;
   Procedure SetCaption(AValue: string);
   Function GetIdentity: string;
   Procedure SetIdentity(AValue: string);
   Function GetHint: string;
   Procedure SetHint(AValue: string);

   property Caption: string read GetCaption write SetCaption;
   property Hint: string read GetHint write SetHint;
   property Identity: string read GetIdentity write SetIdentity;
   property CSSButtonType: String read GetCSSButtonType write SetCSSButtonType;
   property CSSButtonIcon: string read GetCSSButtonIcon write SetCSSButtonIcon;
   property CSSButtonWidth: string read GetCSSButtonWidth write SetCSSButtonWidth;
   property CSSButtonHeigth: string read GetCSSButtonHeigth write SetCSSButtonHeigth;
 end;

 IPrismGridColumnButton = interface
  ['{E771DE49-FCAF-4BE5-B002-A519D85944DE}']
   function GetCaption: string;
   procedure SetCaption(const Value: string);
   function GetEnabled: boolean;
   procedure SetEnabled(const Value: boolean);
   function GetVisible: boolean;
   procedure SetVisible(const Value: boolean);
   function GetCSS: string;
   procedure SetCSS(const Value: string);
   function GetButtonType: string;
   procedure SetButtonType(const Value: string);
   function GetButtonHeigth: string;
   function GetButtonIcon: string;
   function GetButtonWidth: string;
   procedure SetButtonHeigth(const Value: string);
   procedure SetButtonIcon(const Value: string);
   procedure SetButtonWidth(const Value: string);
   function GetOnClick: TNotifyEvent;
   procedure SetOnClick(const Value: TNotifyEvent);
   function GetProc: TProc;
   procedure SetProc(const Value: TProc);
   function GetIdentify: string;
   procedure SetIdentify(const Value: string);
   function GetButtonModel: IButtonModel;
   procedure SetButtonModel(const Value: IButtonModel);
   function Buttons: TList<IPrismGridColumnButton>;

   Procedure Clear;
   function Add: IPrismGridColumnButton; overload;
   procedure Add(AButton: IPrismGridColumnButton); overload;

//   function MakeHTML: string;
   function ElementID: string;

   property ButtonModel: IButtonModel read GetButtonModel write SetButtonModel;
   property Enabled: boolean read GetEnabled write SetEnabled;
   property Visible: boolean read GetVisible write SetVisible;
   property Caption: string read GetCaption write SetCaption;
   property Identify: string read GetIdentify write SetIdentify;
   property CSS: string read GetCSS write SetCSS;
   property CSSButtonType: string read GetButtonType write SetButtonType;
   property CSSButtonIcon: string read GetButtonIcon write SetButtonIcon;
   property CSSButtonWidth: string read GetButtonWidth write SetButtonWidth;
   property CSSButtonHeigth: string read GetButtonHeigth write SetButtonHeigth;
   property ClickProc: TProc read GetProc write SetProc;

   property OnClick: TNotifyEvent read GetOnClick write SetOnClick;
 end;


 IPrismGridColumnButtons = interface
  ['{DAFFE9B3-E12B-4402-98E3-86B947D08731}']
  Procedure Clear;
  function GetButtons: TList<IPrismGridColumnButton>;
  function Add: IPrismGridColumnButton; overload;
  procedure Add(AButton: IPrismGridColumnButton); overload;

  function MakeHTML: string;

  property Items: TList<IPrismGridColumnButton> read GetButtons;
 end;

 IPrismGridColumn = interface
  ['{E0473982-BE9A-44A2-98F9-A058EC1FF2BD}']
  function GetDataField: string;
  Procedure SetDataField(AFieldName: String);
  function GetTitle: string;
  Procedure SetTitle(ATitle: String);
  function GetVisible: Boolean;
  Procedure SetVisible(AVisible: Boolean);
  function GetEditable: Boolean;
  procedure SetEditable(const Value: Boolean);
  function GetWidth: Integer;
  Procedure SetWidth(AWidth: Integer);
  function GetAlignment: TPrismAlignment;
  Procedure SetAlignment(AAlignment: TPrismAlignment);
  function GetDataFieldType: TPrismFieldType;
  procedure SetDataFieldType(const Value: TPrismFieldType);
  function GetDataFieldModel: TPrismFieldModel;
  procedure SetDataFieldModel(const Value: TPrismFieldModel);
  function GetSelectItems: TJSONObject;
  procedure SetSelectItems(AItems: TJSONObject);
  function GetColumnIndex: Integer;
  procedure SetColumnIndex(Value: Integer);
  function GetCSS: String;
  procedure SetCSS(const Value: String);
  function GetHTML: String;
  procedure SetHTML(const Value: String);

  function Buttons: IPrismGridColumnButtons;
  function ButtonFromButtonModel(AButtonModel: IButtonModel): IPrismGridColumnButton;
  function ButtonFromIdentify(AIdentify: String): IPrismGridColumnButton;
  function ColName: string;
  function PrismGrid: IPrismGrid;

  property DataFieldType: TPrismFieldType read GetDataFieldType write SetDataFieldType;
  property DataFieldModel: TPrismFieldModel read GetDataFieldModel write SetDataFieldModel;
  property Editable: Boolean read GetEditable write SetEditable;
  property DataField: String read GetDataField write SetDataField;
  property Title: String read GetTitle write SetTitle;
  property Visible: Boolean read GetVisible write SetVisible;
  property Width: Integer read GetWidth write SetWidth;
  property ColumnIndex: Integer read GetColumnIndex write SetColumnIndex;
  property CSS: String read GetCSS write SetCSS;
  property HTML: String read GetHTML write SetHTML;
  property Alignment: TPrismAlignment read GetAlignment write SetAlignment;
  property SelectItems: TJSONObject read GetSelectItems write SetSelectItems;
 end;


 IPrismGridColumns = interface
  ['{E0473982-BE9A-44A2-98F9-A058EC1FF2BD}']
  Procedure Clear;
  function GetColumns: TList<IPrismGridColumn>;
  function Add: IPrismGridColumn; overload;
  function GetColumnsNameToJSON: TJSONArray;
  procedure Add(AColumn: IPrismGridColumn); overload;
  function ColumnByDataField(ADataField: string): IPrismGridColumn;
  function ColumnByIndex(AColumnIndex: Integer): IPrismGridColumn;
  function ColumnByTitle(ATitle: string): IPrismGridColumn;

  function PrismGrid: IPrismGrid;

  property Items: TList<IPrismGridColumn> read GetColumns;
  property ColumnsNameToJSON: TJSONArray read GetColumnsNameToJSON;
 end;


 IPrismGrid = interface(IPrismControl)
   ['{ECDB5B14-CBA6-494A-95D0-31FEC1F90470}']
   function GetMaxRecords: integer;
   Procedure SetMaxRecords(AMaxRecords: Integer);
   function GetRecordsPerPage: integer;
   Procedure SetRecordsPerPage(ARecordsPerPage: Integer);
   function GetMultiSelect: Boolean;
   Procedure SetMultiSelect(AMultiSelect: Boolean);
   function GetShowPager: Boolean;
   Procedure SetShowPager(Value: Boolean);
   function GetMultiSelectWidth: integer;
   Procedure SetMultiSelectWidth(Value: integer);
   function RecNo: integer; overload;
   function RecNo(AValue: Integer): boolean; overload;

   procedure SetDataToJSON;
   function GetDataToJSON: String;
   function GetSelectedRowsID: TList<Integer>;
   procedure SetSelectedRowsID(Value: TList<Integer>);
   function GetEditable: Boolean;
   procedure CellPostbyJSON(AJSON: string; out ARowID: string; out AErrorMessage: string);

   function Columns: IPrismGridColumns;

   property MaxRecords: Integer read GetMaxRecords write SetMaxRecords;
   property RecordsPerPage: Integer read GetRecordsPerPage write SetRecordsPerPage;
   property MultiSelect: Boolean read GetMultiSelect write SetMultiSelect;
   property MultiSelectWidth: integer read GetMultiSelectWidth write SetMultiSelectWidth;
   property SelectedRowsID: TList<Integer> read GetSelectedRowsID write SetSelectedRowsID;
   property ShowPager: Boolean read GetShowPager write SetShowPager;
   property Editable: Boolean read GetEditable;
   property DataToJSON: String read GetDataToJSON;
 end;


 IPrismStringGrid = interface(IPrismGrid)
   ['{25AB08DE-33E9-4865-8DBC-F47952219734}']
   procedure SetStringGrid(const Value: TStringGrid);
   function GetStringGrid: TStringGrid;

   property StringGrid: TStringGrid read GetStringGrid write SetStringGrid;
 end;


{$IFNDEF FMX}
 IPrismDBGrid = interface(IPrismGrid)
  ['{ABA80247-E392-4437-A6B2-1B5EAE789032}']
   procedure SetDataSource(const Value: TDataSource);
   function GetDataSource: TDataSource;

   property DataSource: TDataSource read GetDataSource write SetDataSource;
 end;
{$ENDIF}


 IPrismBadge = interface(IPrismControl)
  ['{9C121661-C16E-417B-8567-8B66F3F02F22}']
   function GetLabelHTMLElement: TComponent;
   procedure SetLabelHTMLElement(AComponent: TComponent);
   function GetButtonHTMLElement: TComponent;
   procedure SetButtonHTMLElement(const Value: TComponent);

   property LabelHTMLElement: TComponent read GetLabelHTMLElement write SetLabelHTMLElement;
   property ButtonHTMLElement: TComponent read GetButtonHTMLElement write SetButtonHTMLElement;
 end;


 IPrismChartBase = interface(IPrismControl)
  ['{FFE1F726-AC20-48D2-8D47-0F77ABD4FB1B}']
   function Legend: IPrismChartBaseLegend;
 end;


 IPrismChartBaseLegend = interface
  ['{3D0F32C6-ECBF-4BD2-B5C8-88F6E15F5974}']
   function GetRight: Variant;
   procedure SetBottom(const Value: variant);
   function GetBottom: variant;
   procedure SetRight(const Value: Variant);
   function GetAlign: TPrismAlignment;
   function GetLeft: variant;
   procedure SetAlign(const Value: TPrismAlignment);
   function GetTop: variant;
   function GetVisible: boolean;
   procedure SetLeft(const Value: variant);
   procedure SetTop(const Value: variant);
   procedure SetVisible(const Value: boolean);

   property Visible: boolean read GetVisible write SetVisible;
   property Align: TPrismAlignment read GetAlign write SetAlign;
   property Bottom: variant read GetBottom write SetBottom;
   property Left: variant read GetLeft write SetLeft;
   property Right: Variant read GetRight write SetRight;
   property Top: variant read GetTop write SetTop;
 end;


 IPrismChartBaseLegendData = interface
  ['{9FEA525B-F65E-4F0C-B091-8BB9BBC94FA6}']
 end;


 IPrismChartBaseTitle = interface
  ['{F1321966-2236-4C37-998D-974E4AF10B77}']
 end;


 IPrismChartBar = interface(IPrismChartBase)
  ['{C5EF6269-B880-49E3-859F-B7E5AD975AF3}']
 end;


 IPrismChartBaseTooltip = interface
  ['{B2C3CCAC-DD39-4F1A-B4B8-E5267A4A94BE}']
 end;

 IPrismForm = interface
  ['{C3797A0A-AAC1-4571-8A40-7CBB6AFBB38B}']
   //Private
   procedure Clear;
   procedure SetName(AName: String);
   function GetName: String;
   function GetLanguage: String;
   function GetControls: TList<IPrismControl>;

   //Public
   function GetFormUUID: string;
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
   function GetServerControlsUpdating: boolean;
   function GetFocusedControl: IPrismControl;
   procedure SetFocusedControl(APrismControl: IPrismControl);
   function GetControlsPrefix: String;
   function GetEnableControlsPrefix: Boolean;
   //procedure SetEnableControlsPrefix(AEnable: Boolean);
   function ProcessAllTagHTML(HTMLText: String): string;
   procedure ProcessTagHTML(var HTMLText: String);
   procedure DoTagHTML(const TagString: string; var ReplaceTag: string);
   procedure DoTagTranslate(const Language: TD2BridgeLang; const AContext: string; const ATerm: string; var ATranslated: string);
   procedure DoBeginUpdateD2BridgeControls;
   procedure DoEndUpdateD2BridgeControls;
   procedure TagHTML(const TagString: string; var ReplaceTag: string);
   procedure ProcessCallBackTagHTML(var HTMLText: String);
   procedure SetOnShowPopup(AOnPopupEvent: TOnPopup);
   function GetOnShowPopup: TOnPopup;
   procedure SetOnClosePopup(AOnPopupEvent: TOnPopup);
   function GetOnClosePopup: TOnPopup;
   procedure ShowPopup(AName: String);
   procedure ClosePopup(AName: String);
   function GetOnUpload: TOnUpload;
   procedure SetOnUpload(const Value: TOnUpload);
   function PrismOptions: IPrismOptions;

   function CallBacks: IPrismFormCallBacks;

   Procedure AddControl(APrismControl: IPrismControl);
   procedure ProcessControlsToHTML(var HTMLText: String);
   procedure ProcessNested(var HTMLText: String);
   procedure ProcessPopup(var HTMLText: String);
   procedure ProcessTags(var HTMLText: String);
   procedure ProcessTagTranslate(var HTMLText: String);
   procedure Show;
   procedure Close;
   procedure OnAfterPageLoad(EventParams: TStrings);
   procedure OnBeforePageLoad;
   procedure onFormUnload;
   procedure onComponentsUpdating;
   procedure onComponentsUpdated;
   procedure DoUpload(AFiles: TStrings; Sender: TObject);
   procedure DoCellButtonClick(APrismGrid: IPrismStringGrid; APrismCellButton: IPrismGridColumnButton; AColIndex: Integer; ARow: Integer); overload;
{$IFNDEF FMX}
   procedure DoCellButtonClick(APrismDBGrid: IPrismDBGrid; APrismCellButton: IPrismGridColumnButton; AColIndex: Integer; ARow: Integer); overload;
{$ENDIF}
   procedure DoCallBack(const CallBackName: String; EventParams: TStrings);
   procedure CallBack(const CallBackName: String; EventParams: TStrings);
   procedure DoBeginTranslate;
   procedure DoBeginTagHTML;
   procedure DoEndTagHTML;
   procedure UpdateControls;
   procedure UpdateServerControls;
   procedure Initialize;

   function Destroying: Boolean;

   //Property
   property Name: String read GetName write SetName;
   property Controls: TList<IPrismControl> read GetControls;
   property TemplateMasterHTMLFile: string read GetTemplateMasterHTMLFile write SetTemplateMasterHTMLFile;
   property TemplatePageHTMLFile: string read GetTemplatePageHTMLFile write SetTemplatePageHTMLFile;
   property FormHTMLText: string read GetFormHTMLText write SetFormHTMLText;
   property HeadHTMLPrism: string read GetHeadHTMLPrism write SetHeadHTMLPrism;
   property FormCacheHTMLText: string read GetFormCacheHTMLText write SetFormCacheHTMLText;
   property Session: IPrismSession read GetSession write SetSession;
   property FormPageState: TPrismPageState read GetFormPageState write SetFormPageState;
   property ComponentsUpdating: Boolean read GetComponentsUpdating;
   property ServerControlsUpdating: boolean read GetServerControlsUpdating;
   property FormUUID: string read GetFormUUID;
   property FocusedControl: IPrismControl read GetFocusedControl write SetFocusedControl;
   property Language: String read GetLanguage;
   property ControlsPrefix: String read GetControlsPrefix;
   property EnableControlsPrefix: Boolean read GetEnableControlsPrefix;
   property OnShowPopup: TOnPopup read GetOnShowPopup write SetOnShowPopup;
   property OnClosePopup: TOnPopup read GetOnClosePopup write SetOnClosePopup;
   property OnUpload: TOnUpload read GetOnUpload write SetOnUpload;
 end;


 IPrismURLQueryParam = interface
  ['{058390D1-52DF-4375-8A6D-FC2E058622DE}']
  function GetKey: string;
  function GetValue: string;
  procedure SetKey(AValue: String);
  procedure SetValue(AValue: String);

  property Key: string read GetKey write SetKey;
  property Value: string read GetValue write SetValue;
 end;


 IPrismURLQueryParams = interface
  ['{9243E343-A5BF-477E-B117-1E22457E8042}']
  function Items: TList<IPrismURLQueryParam>;
  function Add: IPrismURLQueryParam;
  function Count: Integer;
  function Exist(AKeyName: string): Boolean;
  function ValueFromKey(AKeyName: string): string;
  procedure Clear;
  procedure Update(AQueryParams: TStrings);
 end;


 IPrismURI = interface
  ['{0C8AD761-EB72-4BB4-BED3-F7904A97E965}']
  function GetRaw: string;
  function GetURL: string;
  function GetHost: string;
  function GetServerPort: integer;
  function GetProtocol: string;
  procedure SetRaw(AValue: string);
  procedure SetURL(AValue: string);
  procedure SetHost(AValue: string);
  procedure SetServerPort(AValue: integer);
  procedure SetProtocol(AValue: string);

  function QueryParams: IPrismURLQueryParams;
  procedure ClearQueryParams;

  property Raw: string read GetRaw write SetRaw;
  property URL: string read GetURL write SetURL;
  property Host: string read GetHost write SetHost;
  property ServerPort: integer read GetServerPort write SetServerPort;
  property Protocol: string read GetProtocol write SetProtocol;
 end;


 IPrismSession = interface
   ['{ED051AC9-2EB8-4789-AE78-A5BE858AE6E5}']
   //Private
   function GetD2BridgeManager: TObject;
   function GetD2BridgeBaseClass: TObject;
   procedure SetD2BridgeBaseClass(AD2BridgeBaseClass: TObject);
   Function GetD2BridgeInstance: TObject;
   Function GetActiveForm: IPrismForm;
   function GetD2BridgeForms: TList<TObject>;
   function GetCallBacks: IPrismCallBacks;
   function GetPushID: string;
   function GetAuthID: string;
   procedure SetData(AValue: TObject);
   function GetData: TObject;
   function GetFileDownloads: TDictionary<string, string>;
   function GetLanguageNav: TD2BridgeLang;
   procedure SetLanguageNav(const Value: TD2BridgeLang);
   function GetFormatSettings: TFormatSettings;
   procedure SetFormatSettings(const Value: TFormatSettings);

   //Public
   function GetUUID: string;
   function GetCallBackID: string;
   function GetToken: string;
   function CreateDate: TDateTime;
   function PathSession: String;
   procedure ExecJS(ScriptJS: String; SafeMode: Boolean = false);
   function ExecJSResponse(ScriptJS: String; ATimeout: integer = 60; SafeMode: Boolean = false): string;
   procedure Redirect(AURL: string; ANewPage:Boolean = false);
   procedure SendFile(FullFilePath: String; OpenOnFinishDownload: Boolean = false; WebFileName: String = '');
   Function ActiveFormByFormUUID(AFormUUID: String): IPrismForm;
   function PrimaryForm: TForm;

   procedure ExecThread(AProc: TProc; ASynchronize: Boolean = False); overload;
   procedure ExecThread(AWait: Boolean; AProc: TProc; ASynchronize: Boolean = False); overload;
   procedure ExecThread(AWait: Boolean; AProc: TProc1; var1: TValue; ASynchronize: Boolean = False); overload;
   procedure ExecThread(AWait: Boolean; AProc: TProc2; var1, var2: TValue; ASynchronize: Boolean = False); overload;
   procedure ExecThread(AWait: Boolean; AProc: TProc3; var1, var2, var3: TValue; ASynchronize: Boolean = False); overload;
   procedure ExecThread(AWait: Boolean; AProc: TProc4; var1, var2, var3, var4: TValue; ASynchronize: Boolean = False); overload;

   procedure ExecThreadSynchronize(AProc: TProc); overload;
   procedure ExecThreadSynchronize(AWait: Boolean; AProc: TProc); overload;
   procedure ExecThreadSynchronize(AWait: Boolean; AProc: TProc1; var1: TValue); overload;
   procedure ExecThreadSynchronize(AWait: Boolean; AProc: TProc2; var1, var2: TValue); overload;
   procedure ExecThreadSynchronize(AWait: Boolean; AProc: TProc3; var1, var2, var3: TValue); overload;
   procedure ExecThreadSynchronize(AWait: Boolean; AProc: TProc4; var1, var2, var3, var4: TValue); overload;

   procedure RegisterEventOnPageLoad(AOnPageLoad: TOnEventProc);
   procedure UnRegisterEventOnPageLoad(AOnPageLoad: TOnEventProc);
   procedure RegisterEventOnPageResize(AOnPageResize: TOnEventProc);
   procedure UnRegisterEventOnPageResize(AOnPageResize: TOnEventProc);
   procedure RegisterEventOnOrientationChange(AOnOrientationChange: TOnEventProc);
   procedure UnRegisterEventOnOrientationChange(AOnOrientationChange: TOnEventProc);
   procedure RegisterEventOnCameraInitialize(AOnCameraInitialize: TOnEventProc);
   procedure UnRegisterEventOnCameraInitialize(AOnCameraInitialize: TOnEventProc);

   procedure ThreadAddCurrent;
   procedure ThreadAddFromID(const AThreadID: integer);
   procedure ThreadRemoveCurrent;
   procedure ThreadRemoveFromID(const AThreadID: integer);
   function ThreadIDValid(const AThreadID: integer): boolean; overload;

   function Lang: TD2BridgeTerm;
   function LangNav: TD2BridgeTerm;
   function LangAPPIsPresent: Boolean;
   function LangAPP: TD2BridgeAPPTerm;
   function Language: TD2BridgeLang;
   function LangName: string;
   function LangCode: string;

   function URI: IPrismURI;
   function Clipboard: IPrismClipboard;
   function Cookies: IPrismCookies;

   function Destroying: Boolean;

   procedure UnLock(AWaitName: String);
   procedure UnLockAll;
   procedure Lock(const AWaitName: String; const ATimeOut: Integer = 0);
   function LockExists(AWaitName: String): boolean;

   procedure ShowMessageError(const Msg: string; ASyncMode : Boolean = true; useToast: boolean = false; TimerInterval: integer = 4000; ToastPosition: TToastPosition = ToastTopRight); overload;
   procedure ShowMessage(const Msg: string; useToast: boolean; TimerInterval: integer = 4000; DlgType: TMsgDlgType = TMsgDlgType.mtInformation; ToastPosition: TToastPosition = ToastTopRight); overload;
   procedure ShowMessage(const Msg: string; useToast: boolean; ASyncMode : Boolean; TimerInterval: integer = 4000; DlgType: TMsgDlgType = TMsgDlgType.mtInformation; ToastPosition: TToastPosition = ToastTopRight); overload;
   procedure ShowMessage(const Msg: string); overload;
   function MessageDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer; overload;
   function MessageDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint; ACallBackName: string): Integer; overload;
{$IFNDEF FMX}
   function MessageBox(const Text, Caption: PChar; Flags: Longint): Integer;
{$ENDIF}

   procedure Close(ACreateNewSession: Boolean = false);
   function Closing: boolean;
   function Recovering: boolean;

   function Active: boolean;
   function Disconnected: Boolean;
   function DisconnectedInSeconds: integer;
   function ConnectionStatus: TSessionConnectionStatus;
   function Reloading: boolean;
   function LastHeartBeat: TDateTime;
   function LastHeartBeatInSeconds: integer;
   function LastActivity: TDateTime;
   function LastActivityInSeconds: integer;
   function Idle: Boolean;
   function IdleInSeconds: integer;
   function StabilizedConn: boolean;

   function InfoConnection: IPrismSessionInfo;

   procedure DoException(Sender: TObject; E: Exception; EventName: string);

   function Sessions: IPrismSessions;

   property UUID: string read GetUUID;
   property CallBackID: string read GetCallBackID;
   property PushID: string read GetPushID;
   property AuthID: string read GetAuthID;
   property Token: string read GetToken;
   property ActiveForm: IPrismForm read GetActiveForm;
   property D2BridgeForms: TList<TObject> read GetD2BridgeForms;
   property D2BridgeManager: TObject read GetD2BridgeManager;
   property D2BridgeInstance: TObject read GetD2BridgeInstance;
   property D2BridgeBaseClassActive: TObject read GetD2BridgeBaseClass write SetD2BridgeBaseClass;
   property LanguageNav: TD2BridgeLang read GetLanguageNav write SetLanguageNav;
   property CallBacks: IPrismCallBacks read GetCallBacks;
   property Data: TObject read GetData write SetData;
   property FileDownloads: TDictionary<string, string> read GetFileDownloads;
   property FormatSettings: TFormatSettings read GetFormatSettings write SetFormatSettings;
 end;


 IPrismSessions = interface
  ['{317E2450-149F-4370-B0D0-6D966BC160D5}']
   function GetSessionsFromIdentity(const Identity: string): TList<IPrismSession>;
   function GetSessionsFromIdentityAndUser(const Identity, User: string): TList<IPrismSession>;
   procedure Add(APrismSession: IPrismSession); overload;
   function Delete(AUUID: string): Boolean; overload;
   function Delete(ASession: IPrismSession): Boolean; overload;
   function Exist(AUUID: string): Boolean; overload;
   function Exist(AUUID, AToken: string): Boolean; overload;
   function GetSession(const AUUID: String): IPrismSession;
   function Count: integer;
   procedure CloseAll;
   function FromThreadID(const AThreadID: Integer; AAlertErrorThreadID: Boolean = false): IPrismSession;
   function FromPushID(const APushID: string): IPrismSession;
   function FromAuthID(const AAuthID: string): IPrismSession;
   function Items: TList<IPrismSession>;
   function GetMainThreadPrismSession: IPrismSession;
   procedure SetMainThreadPrismSession(APrismSession: IPrismSession);

   procedure AddThreadhID(AID: integer; APrismSession: IPrismSession);
   procedure RemoveThreadID(AID: integer); overload;
   procedure RemoveThreadID(AID: integer; APrismSession: IPrismSession); overload;
   procedure RemoveThreadIDsFromSession(APrismSession: IPrismSession);
   function ThreadhIDs: TList<integer>;

   procedure FreeMem;

   property Item[const AUUID: string]: IPrismSession read GetSession;
   property SessionsFromIdentity[const Identity: string]: TList<IPrismSession> read GetSessionsFromIdentity;
   property SessionsFromIdentityAndUser[const Identity, User: string]: TList<IPrismSession> read GetSessionsFromIdentityAndUser;
   property MainThreadPrismSession: IPrismSession read GetMainThreadPrismSession write SetMainThreadPrismSession;
 end;


 IPrismSessionInfoScreen = interface
  ['{1B263DF9-DCD8-41C8-8DDA-11786B9B842F}']
   function GetHeight: Integer;
   function GetOrientation: TPrismScreenOrientation;
   function GetWidth: Integer;
   procedure SetHeight(const Value: Integer);
   procedure SetOrientation(const Value: TPrismScreenOrientation);
   procedure SetWidth(const Value: Integer);

   procedure ProcessScreenInfo(AScreenInfo: string);

   property Height: Integer read GetHeight write SetHeight;
   property Orientation: TPrismScreenOrientation read GetOrientation write SetOrientation;
   property Width: Integer read GetWidth write SetWidth;
 end;



 IPrismSessionInfo = interface
  ['{EDE322C3-84C8-47BE-9391-F32844330607}']
  function GetIP: string;
  procedure SetIP(AValue: string);
  function GetUser: string;
  procedure SetUser(AValue: string);
  function GetIdentity: string;
  procedure SetIdentity(AValue: string);
  function GetUserAgent: string;
  procedure SetUserAgent(AValue: string);

  function FormName: string;

  function Screen: IPrismSessionInfoScreen;

  property IP: string read GetIP write SetIP;
  property User: string read GetUser write SetUser;
  property Identity: string read GetIdentity write SetIdentity;
  property UserAgent: string read GetUserAgent write SetUserAgent;
 end;



 IPrismCookie = interface
   ['{9C68B434-5D88-4239-AE04-E4F567B3A596}']
   function GetName: string;
   procedure SetValue(Value: string);
   function GetValue: string;
   function Expire: TDateTime;
   function Path: string;

   procedure Delete;

   property Name: string read GetName;
   property Value: string read GetValue write SetValue;
 end;



 IPrismCookies = interface
   ['{2A01EE42-733F-49E9-B4BE-B3900B6DC2F7}']
   function GetItems: TList<IPrismCookie>;

   function RawCookies: string;

   Procedure Refresh;
   Procedure Clear;

   procedure Add(APrismCookie: IPrismCookie); overload;
   procedure Add(AName, AValue: string; ADay: integer = 0; AMinute: integer = 0; APath: string = '/'); overload;
   procedure Add(AName, AValue: string; AExpire: TDateTime; APath: String); overload;

   function Delete(AName: string): Boolean;

   function Exist(AName: string): Boolean;

   function GetCookie(const AName: String): IPrismCookie;
   function GetCookieValue(const AName: String): String;
   procedure SetCookieValue(const AName: String; Value: string);

   property Item[const AName: string]: IPrismCookie read GetCookie;
   property Value[const AName: string]: string read GetCookieValue write SetCookieValue; default;

   property Items: TList<IPrismCookie> read GetItems;
 end;


 IPrismOptions = interface
  ['{16BF76DA-F5EC-4227-9EEE-32CE6D838469}']
   function GetLanguage: string;
   procedure SetLanguage(AValue: string);
   function GetLoading: Boolean;
   procedure SetLoading(AValue: Boolean);
   function GetPathCSS: string;
   procedure SetPathCSS(const Value: string);
   function GetPathTemp: string;
   function GetPathTempSessions: string;
   procedure SetPathTemp(const Value: string);
   procedure SetPathTempSessions(const Value: string);
   function GetRootDirectory: string;
   procedure SetRootDirectory(const Value: string);
   function GetPathJS: string;
   procedure SetPathJS(const Value: string);
   function GetPathFont: string;
   procedure SetPathFont(const Value: string);
   function GetIncludeJQGrid: Boolean;
   function GetIncludeJQuery: Boolean;
   function GetIncludeSweetAlert2: Boolean;
   procedure SetIncludeJQGrid(const Value: Boolean);
   procedure SetIncludeJQuery(const Value: Boolean);
   procedure SetIncludeSweetAlert2(const Value: Boolean);
   function GetIncludeStyle: Boolean;
   procedure SetIncludeStyle(const Value: Boolean);
   function GetIncludeBootStrap: Boolean;
   procedure SetIncludeBootStrap(const Value: Boolean);
   function GetIncludeInputMask: Boolean;
   procedure SetIncludeInputMask(const Value: Boolean);
   function GetForceCloseExpired: Boolean;
   procedure SetForceCloseExpired(AValue: Boolean);
   function GetDataSetLog: Boolean;
   procedure SetDataSetLog(const Value: Boolean);
   function GetUseSSL: Boolean;
   procedure SetUseSSL(const Value: Boolean);
   function GetUseINIConfig: Boolean;
   procedure SetUseINIConfig(const Value: Boolean);
   function GetDataBaseFormatSettings: TFormatSettings;
   procedure SetDataBaseFormatSettings(Value: TFormatSettings);
   function GetHTMLFormatSettings: TFormatSettings;
   procedure SetHTMLFormatSettings(Value: TFormatSettings);
   function GetValidateAllControls: Boolean;
   procedure SetValidateAllControls(const Value: Boolean);
   procedure SetLogException(const Value: Boolean);
   function GetLogException: boolean;
   function GetLogSecurity: Boolean;
   procedure SetLogSecurity(const Value: Boolean);
   function GetLogAccess: Boolean;
   procedure SetLogAccess(const Value: Boolean);
   function GetLogFileMode: TPrismLogFileMode;
   procedure SetLogFileMode(const Value: TPrismLogFileMode);
   procedure SetPathLogException(const Value: string);
   function GetPathLogException: string;
   procedure SetSessionTimeOut(const Value: Integer);
   function GetSessionTimeOut: integer;
   procedure SetSessionIdleTimeOut(const Value: Integer);
   function GetSessionIdleTimeOut: integer;
   function LogFile: string;
   procedure SetCoInitialize(const Value: Boolean);
   function GetCoInitialize: Boolean;
   procedure SetVCLStyles(const Value: Boolean);
   function GetVCLStyles: Boolean;
   procedure SetDataWareMapped(const Value: TPrismDataWareMapped);
   function GetDataWareMapped: TPrismDataWareMapped;
   function GetHeartBeatTime: integer;
   procedure SetHeartBeatTime(const Value: integer);
   function GetShowError500Page: boolean;
   procedure SetShowError500Page(const Value: boolean);
   procedure SetUseMainThread(const Value: Boolean);
   function GetUseMainThread: Boolean;

   function Security: IPrismOptionSecurity;

   property Language: string read GetLanguage write SetLanguage;
   property Loading: boolean read GetLoading write SetLoading;
   property PathCSS: string read GetPathCSS write SetPathCSS;
   property PathJS: string read GetPathJS write SetPathJS;
   property PathFont: string read GetPathFont write SetPathFont;
   property PathTemp: string read GetPathTemp write SetPathTemp;
   property PathTempSessions: string read GetPathTempSessions write SetPathTempSessions;
   property RootDirectory: string read GetRootDirectory write SetRootDirectory;
   property IncludeSweetAlert2: Boolean read GetIncludeSweetAlert2 write SetIncludeSweetAlert2;
   property IncludeJQuery: Boolean read GetIncludeJQuery write SetIncludeJQuery;
   property IncludeJQGrid: Boolean read GetIncludeJQGrid write SetIncludeJQGrid;
   property IncludeStyle: Boolean read GetIncludeStyle write SetIncludeStyle;
   property IncludeBootStrap: Boolean read GetIncludeBootStrap write SetIncludeBootStrap;
   property IncludeInputMask: Boolean read GetIncludeInputMask write SetIncludeInputMask;
   property ValidateAllControls: Boolean read GetValidateAllControls write SetValidateAllControls;
   property ForceCloseExpired: Boolean read GetForceCloseExpired write SetForceCloseExpired;
   property DataSetLog: Boolean read GetDataSetLog write SetDataSetLog;
   property UseINIConfig: Boolean read GetUseINIConfig write SetUseINIConfig;
   property SSL: Boolean read GetUseSSL write SetUseSSL;
   property LogException: Boolean read GetLogException write SetLogException;
   property LogSecurity: Boolean read GetLogSecurity write SetLogSecurity;
   property LogAccess: Boolean read GetLogAccess write SetLogAccess;
   property LogFileMode: TPrismLogFileMode read GetLogFileMode write SetLogFileMode;
   property PathLogException: string read GetPathLogException write SetPathLogException;
   property CoInitialize: boolean read GetCoInitialize write SetCoInitialize;
   property VCLStyles: boolean read GetVCLStyles write SetVCLStyles;
   property DataBaseFormatSettings: TFormatSettings read GetDataBaseFormatSettings Write SetDataBaseFormatSettings;
   property HTMLFormatSettings: TFormatSettings read GetHTMLFormatSettings write SetHTMLFormatSettings;
   property DataWareMapped: TPrismDataWareMapped read GetDataWareMapped write SetDataWareMapped;
   property SessionTimeOut: integer read GetSessionTimeOut write SetSessionTimeOut;
   property SessionIdleTimeOut: integer read GetSessionIdleTimeOut write SetSessionIdleTimeOut;
   property HeartBeatTime: integer read GetHeartBeatTime write SetHeartBeatTime;
   property ShowError500Page: boolean read GetShowError500Page write SetShowError500Page;
   property UseMainThread: Boolean read GetUseMainThread write SetUseMainThread;
 end;


 IPrismOptionSecurity = interface
  ['{647D682F-06F6-4EF4-B942-97643439B770}']
   function IP: IPrismOptionSecurityIP;
   function UserAgent: IPrismOptionSecurityUserAgent;
   function Rest: ID2BridgeRestSecurity;

   procedure LoadDefaultSecurity;

   function GetEnabled: Boolean;
   procedure SetEnabled(const Value: Boolean);

   property Enabled: Boolean read GetEnabled write SetEnabled;
 end;


 IPrismOptionSecurityIP = interface
  ['{82B06F59-3BA2-4D70-8701-E3ECBB99E2CD}']
   function IPv4BlackList: IPrismOptionSecurityIPv4Blacklist;
   function IPv4WhiteList: IPrismOptionSecurityIPv4Whitelist;
   function IPConnections: IPrismOptionSecurityIPConnections;
 end;


 IPrismOptionSecurityBlacklistDelist = interface
  ['{8F96AC17-28A6-47B8-883E-2E735859978D}']

 end;


 IPrismOptionSecurityIPv4 = interface
  ['{4713D221-F084-41B4-AA85-C4D52E6030DF}']
   function IPToStr(IP: Cardinal): string;
   function StrToIP(const IPStr: string): Cardinal;
   function IsValidIP(const IPStr: string; const IsValidCDIR: boolean = true): Boolean;
   function IsValidCDIR(const CDIR: string): Boolean;
   function IPRangeFromCIDR(const CIDR: string): TStrings;

   procedure Clear;
   procedure Add(CIDR: string); overload;
   function Count: integer;
   function Delete(CIDR: string): Boolean;
   function Exist(CIDR: string): Boolean;
   function ExistIP(const IPStr: string): boolean;
   function Items: TList<string>;
   function AllIPS: TList<string>;
 end;


 IPrismOptionSecurityIPv4Blacklist = interface(IPrismOptionSecurityIPv4)
  ['{4E83B54C-2AF6-4360-8C09-0B6C8D27218F}']
   function GetEnableSelfDelist: Boolean;
   procedure SetEnableSelfDelist(const Value: Boolean);
   function GetEnableSpamhausList: Boolean;
   procedure SetEnableSpamhausList(const Value: Boolean);

   function CreateTokenDelist(AIP: string): string;
   function IsValidTokenDelist(AIP: string; AJSON: TJSONObject; ARemoveToken: boolean = false): boolean; overload;
   function IsValidTokenDelist(AIP: string; AToken: string; ARemoveToken: boolean = false): boolean; overload;
   function RemoveTokenDelist(AIP: string): boolean;

   procedure ClearOldTokenDelist;

   property EnableSelfDelist: Boolean read GetEnableSelfDelist write SetEnableSelfDelist;
   property EnableSpamhausList: Boolean read GetEnableSpamhausList write SetEnableSpamhausList;
 end;


 IPrismOptionSecurityIPv4Whitelist = interface(IPrismOptionSecurityIPv4)
  ['{F63CB0D9-88A5-4115-B7A5-ADD2474A9C72}']
 end;


 IPrismOptionSecurityUserAgent = interface
  ['{E6288B39-F2B2-49B4-9B5B-FD5D31635BA3}']
   function GetEnableCrawlerUserAgents: Boolean;
   procedure SetEnableCrawlerUserAgents(const Value: Boolean);

   procedure Clear;
   procedure Add(AUserAgent: string);
   function Count: integer;
   function Delete(AUserAgent: string): Boolean;
   function Exist(AUserAgent: string): Boolean;
   function UserAgentBlocked(AHeaderUserAgent: string): Boolean;
   function Items: TList<string>;

   property EnableCrawlerUserAgents: Boolean read GetEnableCrawlerUserAgents write SetEnableCrawlerUserAgents;
 end;



 IPrismOptionSecurityIPConnections = interface
  ['{744789CF-A9E9-49E4-8928-A9919BF1F707}']
   function GetLimitNewConnPerIPMin: Integer;
   procedure SetLimitNewConnPerIPMin(const Value: Integer);
   function GetLimitActiveSessionsPerIP: Integer;
   procedure SetLimitActiveSessionsPerIP(const Value: Integer);

   procedure AddSession(APrismSession: IPrismSession);
   procedure RemoveSession(APrismSession: IPrismSession);

   procedure Clear;
   function IsIPAllowed(AIP: string): boolean; overload;
   function IsIPAllowed(AIP: string; out ABlockIPLimitConn: boolean; out ABlockIPLimitSession: Boolean): boolean; overload;
   function IPCount(AIP: string): integer;
   function Delete(AIP: string): Boolean;

   property LimitNewConnPerIPMin: Integer read GetLimitNewConnPerIPMin write SetLimitNewConnPerIPMin; //per Minute
   property LimitActiveSessionsPerIP: Integer read GetLimitActiveSessionsPerIP write SetLimitActiveSessionsPerIP; //per Minute
 end;


 IPrismServerHTML = interface
  ['{202EABE7-9C8C-4862-B4A9-243EA18825D6}']
 end;


 IPrismServerTCP = interface
  ['{07698B99-06F0-4133-8A59-15B45E7613D3}']
 end;


 IPrismBaseClass = interface
   ['{263F99F2-01A4-4DA6-97F0-5E4425D99A87}']
   function GetServerPort: Integer;
   procedure SetServerPort(APort: Integer);

   function GetOptions: IPrismOptions;

   procedure InstancePrimaryForm(APrismSession: IPrismSession);

   function Started: boolean;
   procedure StartServer;
   procedure StopServer;

   function ServerUUID: string;

   function Sessions: IPrismSessions;

   function Rest: ID2BridgeRest;

   function IsD2DockerContext: boolean;
   function IsD2BridgeContext: boolean;

   property ServerPort: integer read GetServerPort write SetServerPort;
   //property Sessions: TDictionary<string, IPrismSession> read GetSessions;
   property Options: IPrismOptions read GetOptions;
 end;

 IPrismContext = interface
  ['{63ADFCF5-B2D5-4895-A574-917E47BBD996}']
   function GetSession: IPrismSession;

   property Session: IPrismSession read GetSession;
 end;

 IPrismClipboard = interface
  ['{4DA130C6-AEFF-4930-A4E6-CC9470F3D47F}']
   function GetAsText: string;
   procedure SetAsText(const Value: string);

   property AsText: string read GetAsText write SetAsText;
 end;


implementation


end.