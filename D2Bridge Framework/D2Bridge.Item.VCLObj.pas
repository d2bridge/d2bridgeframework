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

unit D2Bridge.Item.VCLObj;


interface

//{$M+}

uses
  Classes,
{$IFDEF HAS_UNIT_SYSTEM_UITYPES}
  System.UITypes,
{$ENDIF}
{$IFDEF FMX}
  FMX.Menus, FMX.StdCtrls, FMX.Graphics,
{$ELSE}
  Menus, StdCtrls, Forms, Graphics,
{$ENDIF}
  Prism.Interfaces, Prism.Types,
  D2Bridge.BaseClass, D2Bridge.Item, D2bridge.Interfaces;


type
 TD2BridgeItemVCLObj = class(TD2BridgeItem, ID2BridgeItemVCLObj)
  private
   FItem: TComponent;
   FPopupMenu: TPopupMenu;
   FIsHidden: Boolean;
   FBridgeVCLObj: ID2BridgeVCLObj;
   FRequired: Boolean;
   FValidationGroup: Variant;
   FButtonIcon: string;
   FButtonIconPosition: TPrismPosition;
   FPopupHTML: TStrings;
   FVCLObjStyle: ID2BridgeItemVCLObjStyle;
   function GetIsHidden: Boolean;
   procedure SetIsHidden(AIsHidden: Boolean);
   function BridgeVCLObjClass(VCLObjClass: TClass): ID2BridgeVCLObj;
   function GetHTMLStyle: string; override;
   function GetItem: TComponent;
   procedure SetItem(AItemVCLObj: TComponent);
   procedure RenderPopupMenu;
   function GetRequired: Boolean;
   procedure SetRequired(ARequired: Boolean);
   function GetValidationGroup: Variant;
   Procedure SetValidationGroup(AValidationGroup: Variant);
   procedure ProcessVCLStyles;
   function CallBackEventPopup(EventParams: TStrings): string;
   //RegisterVCLObjec Class
   class Procedure RegisterVCLObjClass;
  public
   constructor Create(AOwner: TD2BridgeClass); override;
   destructor Destroy; override;

   procedure PreProcess; override;
   procedure Render; override;
   procedure RenderHTML; override;

   procedure RefreshVCLObjStyle;
   function VCLObjStyle: ID2BridgeItemVCLObjStyle;

   function DefaultPropertyCopyList: TStringList;

   function GetPopupMenu: TPopupMenu;
   procedure SetPopupMenu(APopupMenu: TPopupMenu);

   property Required: Boolean read GetRequired write SetRequired;
   property ValidationGroup: Variant read GetValidationGroup write SetValidationGroup;
   property Item: TComponent read GetItem write SetItem;
   property Hidden: Boolean read GetIsHidden write SetIsHidden;
   property PopupMenu: TPopupMenu read GetPopupMenu write SetPopupMenu;
   property BridgeVCLObj: ID2BridgeVCLObj read FBridgeVCLObj;
   property BaseClass;
 end;


type
 ID2BridgeItemVCLObjCore = Interface
  ['{9DCD331A-5A09-48E9-B2DC-FB1D8F7F3B9C}']
  function GetD2BridgeItemVCLObj: TD2BridgeItemVCLObj;
  property D2BridgeItemVCLObj: TD2BridgeItemVCLObj read GetD2BridgeItemVCLObj;
 End;

 TD2BridgeItemVCLObjCoreClass = class of TD2BridgeItemVCLObjCore;

 TD2BridgeItemVCLObjCore = class(TInterfacedPersistent, ID2BridgeVCLObj, ID2BridgeItemVCLObjCore)
  protected
   FD2BridgeItemVCLObj: TD2BridgeItemVCLObj;

   function CSSClass: String; virtual;
   function VCLClass: TClass; virtual;
   procedure VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle); virtual;
   function FrameworkItemClass: ID2BridgeFrameworkItem; virtual;
   procedure ProcessPropertyClass(NewObj: TObject); virtual;
   procedure ProcessEventClass; virtual;
   function GetD2BridgeItemVCLObj: TD2BridgeItemVCLObj;
  public
   constructor Create(AOwner: TD2BridgeItemVCLObj); virtual;
   destructor Destroy; override;

   function PropertyCopyList: TStringList; virtual;
 end;

{$IFDEF FMX}
 TMenuItemEx = class helper for TMenuItem
 public
   procedure ClickEx;
 end;
{$ENDIF}


Const
 CSS_Default = 'form-control';

implementation

uses
  Rtti, TypInfo, SysUtils, StrUtils,
{$IFDEF FMX}
  FMX.Controls,
{$ELSE}
  Controls,
{$ENDIF}

{$IFDEF D2BRIDGE}
{$IFDEF RXLIB_AVAILABLE}
  D2Bridge.VCLObj.TRxDBCalcEdit, D2Bridge.VCLObj.TRxLookupEdit, D2Bridge.VCLObj.TDBDateEdit, D2Bridge.VCLObj.TCurrencyEdit,
  D2Bridge.VCLObj.TDateEdit,
{$ENDIF}

{$IFDEF SMCOMPONENTS_AVAILABLE}
  D2Bridge.VCLObj.TSMDBGrid,
{$ENDIF}

{$IFDEF DEVEXPRESS_AVAILABLE}
  D2Bridge.VCLObj.TcxTextEdit, D2Bridge.VCLObj.TcxComboBox, D2Bridge.VCLObj.TcxCheckBox,
  D2Bridge.VCLObj.TcxMemo, D2Bridge.VCLObj.TcxLabel, D2Bridge.VCLObj.TcxImage, D2Bridge.VCLObj.TcxDateEdit,
  D2Bridge.VCLObj.TcxDBCheckBox, D2Bridge.VCLObj.TcxDBComboBox, D2Bridge.VCLObj.TcxDBTextEdit,
  D2Bridge.VCLObj.TcxDBLookupComboBox, D2Bridge.VCLObj.TcxDBMemo, D2Bridge.VCLObj.TcxDBLabel,
  D2Bridge.VCLObj.TcxRadioButton, D2Bridge.VCLObj.TcxGridDBTableView, D2Bridge.VCLObj.TcxDBDateEdit,
  D2Bridge.VCLObj.TcxButtonEdit,
{$ENDIF}

{$IFDEF JVCL_AVAILABLE}
  D2Bridge.VCLObj.TJvDatePickerEdit, D2Bridge.VCLObj.TJvDbGrid, D2Bridge.VCLObj.TJvDBLookupCombo,
  D2Bridge.VCLObj.TJvDBUltimGrid, D2Bridge.VCLObj.TJvValidateEdit, D2Bridge.VCLObj.TJvDBDateEdit, D2Bridge.VCLObj.TJvCalcEdit,
  D2Bridge.VCLObj.TJvDBCombobox,
{$ENDIF}

{$IFDEF INFOPOWER_AVAILABLE}
  D2Bridge.VCLObj.TwwDBGrid, D2Bridge.VCLObj.TwwDBEdit, D2Bridge.VCLObj.TwwButton, D2Bridge.VCLObj.TwwDBComboBox,
  D2Bridge.VCLObj.TwwDBLookupCombo, D2Bridge.VCLObj.TwwDBComboDlg, D2Bridge.VCLObj.TwwDBLookupComboDlg,
  D2Bridge.VCLObj.TwwDBRichEdit, D2Bridge.VCLObj.TwwDBDateTimePicker, D2Bridge.VCLObj.TwwCheckBox,
  D2Bridge.VCLObj.TwwRadioButton, D2Bridge.VCLObj.TwwIncrementalSearch, D2Bridge.VCLObj.TwwDBSpinEdit,
{$ENDIF}

{$IFDEF FMX}
  D2Bridge.FMXObj.TComboEdit, D2Bridge.FMXObj.TDateEdit, D2Bridge.FMXObj.TMenuBar,
{$ENDIF}

{$IFNDEF FMX}
  D2Bridge.VCLObj.TDateTimePicker, D2Bridge.VCLObj.TDBGrid, D2Bridge.VCLObj.TDBText, D2Bridge.VCLObj.TDBMemo,
  D2Bridge.VCLObj.TDBLookupCombobox, D2Bridge.VCLObj.TDBEdit, D2Bridge.VCLObj.TDBCombobox,
  D2Bridge.VCLObj.TDBCheckBox, D2Bridge.VCLObj.TMaskEdit,
  D2Bridge.VCLObj.TMainMenu, D2Bridge.VCLObj.TToolButton,
  D2Bridge.VCLObj.TRadioGroup, D2Bridge.VCLObj.TDBRadioGroup,
  {$IFNDEF FPC}
  D2Bridge.VCLObj.TButtonedEdit,
  {$ENDIF}
{$ENDIF}

{$IFDEF FPC}
  D2Bridge.VCLObj.TEditButton,
{$ENDIF}

  D2Bridge.VCLObj.TLabel, D2Bridge.VCLObj.TEdit, D2Bridge.VCLObj.TButton, D2Bridge.VCLObj.TSpeedButton,
  D2Bridge.VCLObj.TImage, D2Bridge.VCLObj.TMemo, D2Bridge.VCLObj.TStringGrid,
  D2Bridge.VCLObj.TCombobox, D2Bridge.VCLObj.TCheckBox, D2Bridge.VCLObj.TRadioButton,
{$ENDIF}

  D2Bridge.Util, D2Bridge.VCLObj.Override, D2Bridge.HTML.CSS, D2Bridge.Prism, D2Bridge.Item.VCLObj.Style,
  Prism.Forms, Prism.Forms.Controls, Prism.Session, Prism.CallBack;


{ TD2BridgeItemVCLObjCore }

constructor TD2BridgeItemVCLObjCore.Create(AOwner: TD2BridgeItemVCLObj);
begin
 inherited Create;

 FD2BridgeItemVCLObj:= AOwner;
end;

function TD2BridgeItemVCLObjCore.CSSClass: String;
begin

end;

destructor TD2BridgeItemVCLObjCore.Destroy;
begin
  inherited;
end;

function TD2BridgeItemVCLObjCore.VCLClass: TClass;
begin

end;

procedure TD2BridgeItemVCLObjCore.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin

end;

function TD2BridgeItemVCLObjCore.FrameworkItemClass: ID2BridgeFrameworkItem;
begin

end;

procedure TD2BridgeItemVCLObjCore.ProcessPropertyClass(NewObj: TObject);
begin

end;

procedure TD2BridgeItemVCLObjCore.ProcessEventClass;
begin

end;

function TD2BridgeItemVCLObjCore.GetD2BridgeItemVCLObj: TD2BridgeItemVCLObj;
begin
  Result:= FD2BridgeItemVCLObj;
end;

function TD2BridgeItemVCLObjCore.PropertyCopyList: TStringList;
begin
 Result:= FD2BridgeItemVCLObj.DefaultPropertyCopyList;
end;

{ TD2BridgeItemVCLObj }


function TD2BridgeItemVCLObj.BridgeVCLObjClass(VCLObjClass: TClass): ID2BridgeVCLObj;
var
  BridgeInstance: ID2BridgeVCLObj;
  InterfaceTypeInfo: PTypeInfo;
  InterfaceGUID: TGUID;
  Instance: TObject;
  Classe: TClass;
begin
{$IFDEF D2BRIDGE}
  // Obtenha o TypeInfo da interface
  InterfaceTypeInfo := TypeInfo(ID2BridgeVCLObj);

  // Obtenha o GUID da interface
  InterfaceGUID := GetTypeData(InterfaceTypeInfo).Guid;

  try
   // Itere sobre todas as classes carregadas no tempo de execução
   for Classe in GetRegisteredClass do
   begin
     if Supports(Classe, InterfaceGUID) then
       if SameText(Classe.ClassName, 'TVCLObj'+OverrideVCL(VCLObjClass).ClassName) then
       begin
        Instance:= TD2BridgeItemVCLObjCoreClass(Classe).Create(Self);

        if Supports(Instance, InterfaceGUID, BridgeInstance) then
        begin
          // Chame o método VCLClass
          if OverrideVCL(VCLObjClass) = BridgeInstance.VCLClass then
          begin
           Result := BridgeInstance;//Instance.ClassType;

           Exit;
           Break;
          end;
        end else
         Instance.Free;
       end;
   end;
  finally

  end;
{$ENDIF}
end;


function TD2BridgeItemVCLObj.CallBackEventPopup(EventParams: TStrings): string;
var
 xI, xJ: Integer;
begin
{$IFDEF D2BRIDGE}
 result:= '';

 for xI := 0 to PopupMenu.{$IFNDEF FMX}Items.Count{$ELSE}ItemsCount{$ENDIF}-1 do
 begin
  if PopupMenu.Items[xI].Name = EventParams.Strings[0] then
  begin
   if (PopupMenu.Items[xI].Enabled) and (PopupMenu.Items[xI].Visible) then
    PopupMenu.Items[xI].{$IFNDEF FMX}Click{$ELSE}ClickEx{$ENDIF};

   Break;

   for xJ := 0 to PopupMenu.Items[xI].{$IFNDEF FMX}Count{$ELSE}ItemsCount{$ENDIF}-1 do
    if PopupMenu.Items[xI].Items[xJ].Name = EventParams.Strings[0] then
    begin
     if (PopupMenu.Items[xI].Items[xJ].Enabled) and (PopupMenu.Items[xI].Items[xJ].Visible) then
       PopupMenu.Items[xI].Items[xJ].{$IFNDEF FMX}Click{$ELSE}ClickEx{$ENDIF};

     Break;
    end;
  end;
 end;
{$ENDIF}
end;

constructor TD2BridgeItemVCLObj.Create(AOwner: TD2BridgeClass);
begin
 Inherited Create(AOwner);

 FButtonIconPosition:= PrismPositionLeft;
 FIsHidden:= false;
 FRequired:= false;
 FPopupHTML:= TStringList.Create;
 Initialize(FVCLObjStyle);
end;



function TD2BridgeItemVCLObj.DefaultPropertyCopyList: TStringList;
begin
 Result:= TStringList.Create;
 Result.Add('Left');
 Result.Add('Top');
 Result.Add('Width');
 Result.Add('Heigth');
 Result.Add('Parent');
 Result.Add('Caption');
 Result.Add('Color');
 Result.Add('Enabled');
 Result.Add('Visible');
end;


destructor TD2BridgeItemVCLObj.Destroy;
var
 vD2BridgeItemVCLObjCore: TD2BridgeItemVCLObjCore;
 vD2BridgeItem: TD2BridgeItem;
 vVCLObjStyle: TD2BridgeItemVCLObjStyle;
begin
 try
  if Assigned(FBridgeVCLObj) then
  begin
   if FBridgeVCLObj is TD2BridgeItemVCLObjCore then
   begin
    vD2BridgeItemVCLObjCore:= FBridgeVCLObj as TD2BridgeItemVCLObjCore;
    FBridgeVCLObj:= nil;
    vD2BridgeItemVCLObjCore.Free;
   end else
    if FBridgeVCLObj is TD2BridgeItem then
    begin
     vD2BridgeItem:= FBridgeVCLObj as TD2BridgeItem;
     FBridgeVCLObj:= nil;
     vD2BridgeItem.Free;
    end;
  end;
 except
 end;

 FreeAndNil(FPopupHTML);

 try
  if Assigned(FVCLObjStyle) then
  begin
   vVCLObjStyle:= FVCLObjStyle as TD2BridgeItemVCLObjStyle;
   FVCLObjStyle:= nil;
   vVCLObjStyle.Free;
  end;
 except
 end;

 inherited;
end;

function TD2BridgeItemVCLObj.GetHTMLStyle: string;
begin
 result:= Inherited;

 if SameText(OverrideVCL(Item.ClassType).ClassName, 'TLabel')
 {$IFDEF DEVEXPRESS_AVAILABLE}
   or SameText(OverrideVCL(Item.ClassType).ClassName, 'TcxLabel')
   or SameText(OverrideVCL(Item.ClassType).ClassName, 'TcxDBLabel')
 {$ENDIF}
   or SameText(OverrideVCL(Item.ClassType).ClassName, 'TDBText') then
 begin
  if Pos('white-space: pre-line;', result) <= 0 then
  begin
   if result <> '' then
    Result:= Result + ' ';
   Result:= Result + 'white-space: pre-line;';
  end;
 end;


end;

function TD2BridgeItemVCLObj.GetIsHidden: Boolean;
begin
 Result:= FIsHidden;
end;

function TD2BridgeItemVCLObj.GetItem: TComponent;
begin
 result:= FItem;
end;


function TD2BridgeItemVCLObj.GetPopupMenu: TPopupMenu;
begin
 Result:= FPopupMenu;
end;

function TD2BridgeItemVCLObj.GetRequired: Boolean;
begin
 Result:= FRequired;
end;

function TD2BridgeItemVCLObj.GetValidationGroup: Variant;
begin
 Result:= FValidationGroup;
end;

procedure TD2BridgeItemVCLObj.PreProcess;
begin
{$IFDEF D2BRIDGE}
// if (Assigned(Item)) and Supports(BridgeVCLObj.FrameworkItemClass, ID2BridgeFrameworkItemButton) then
// begin
//  TButton(Item).{$IFNDEF FMX}Caption{$ELSE}Text{$ENDIF}:= StringReplace(TButton(Item).{$IFNDEF FMX}Caption{$ELSE}Text{$ENDIF}, '&', '', [rfReplaceAll, rfIgnoreCase]);
// end;

 if (Assigned(Item)) and (FBridgeVCLObj is TVCLObjTButton) then
 begin
  try
   if not Assigned(FPopupMenu) then
   begin
{$IF NOT DEFINED(FMX) AND NOT DEFINED(FPC)}
    if Assigned(TButton(Item).DropDownMenu) then
     FPopupMenu:= TButton(Item).DropDownMenu
    else
{$IFEND}
    if Assigned(TButton(Item).PopupMenu) then
     FPopupMenu:= TButton(Item).PopupMenu{$IFDEF FMX}.PopupComponent as TPopupMenu{$ENDIF};
   end;
  except
  end;
 end;
{$ENDIF}
end;

procedure TD2BridgeItemVCLObj.ProcessVCLStyles;
var
 vFontSize: Double;
 vCSSClasses, vHTMLStyle: string;
begin
{$IFDEF D2BRIDGE}
 if BaseClass.VCLStyles then
 begin
  vCSSClasses:= '';
  vHTMLStyle:= '';

  FVCLObjStyle.ProcessVCLStyles(vCSSClasses, vHTMLStyle);

  CSSClasses:= Trim(' ' + CSSClasses + ' ' + vCSSClasses);
  HTMLStyle:= Trim(' ' + HTMLStyle + ' ' + vHTMLStyle);
 end;
{$ENDIF}
end;

procedure TD2BridgeItemVCLObj.RefreshVCLObjStyle;
begin
 if Assigned(FVCLObjStyle) then
 begin
  FVCLObjStyle.Default;
  FBridgeVCLObj.VCLStyle(FVCLObjStyle);
 end;
end;

class procedure TD2BridgeItemVCLObj.RegisterVCLObjClass;
begin
{$IFDEF D2BRIDGE}
 RegisterClassD2Bridge(TVCLObjTLabel);
 RegisterClassD2Bridge(TVCLObjTEdit);
 RegisterClassD2Bridge(TVCLObjTButton);
 RegisterClassD2Bridge(TVCLObjTSpeedButton);
 RegisterClassD2Bridge(TVCLObjTCombobox);
 RegisterClassD2Bridge(TVCLObjTCheckBox);
 RegisterClassD2Bridge(TVCLObjTRadioButton);
 RegisterClassD2Bridge(TVCLObjTImage);
 RegisterClassD2Bridge(TVCLObjTMemo);
 RegisterClassD2Bridge(TVCLObjTStringGrid);
{$IFNDEF FMX}
 RegisterClassD2Bridge(TVCLObjTDateTimePicker);
 RegisterClassD2Bridge(TVCLObjTDBGrid);
 RegisterClassD2Bridge(TVCLObjTDBText);
 RegisterClassD2Bridge(TVCLObjTDBMemo);
 RegisterClassD2Bridge(TVCLObjTDBLookupCombobox);
 RegisterClassD2Bridge(TVCLObjTDBEdit);
 RegisterClassD2Bridge(TVCLObjTDBCombobox);
 RegisterClassD2Bridge(TVCLObjTDBCheckBox);
 RegisterClassD2Bridge(TVCLObjTMaskEdit);
 RegisterClassD2Bridge(TVCLObjTRadioGroup);
 RegisterClassD2Bridge(TVCLObjTDBRadioGroup);
 {$IFNDEF FPC}
 RegisterClassD2Bridge(TVCLObjTButtonedEdit);
 {$ELSE}
 RegisterClassD2Bridge(TVCLObjTEditButton);
 {$ENDIF}
 RegisterClassD2Bridge(TVCLObjTMainMenu);
 RegisterClass(TVCLObjTToolButton);
{$ELSE}
 RegisterClassD2Bridge(TFMXObjTComboEdit);
 RegisterClassD2Bridge(TFMXObjTDateEdit);
 RegisterClassD2Bridge(TFMXObjTMenuBar);
{$ENDIF}
{$IFDEF RXLIB_AVAILABLE}
 RegisterClassD2Bridge(TVCLObjTDBDateEdit);
 RegisterClassD2Bridge(TVCLObjTRxDBCalcEdit);
 RegisterClassD2Bridge(TVCLObjTRxLookupEdit);
 RegisterClassD2Bridge(TVCLObjTCurrencyEdit);
 RegisterClassD2Bridge(TVCLObjTDateEdit);
{$ENDIF}
{$IFDEF SMCOMPONENTS_AVAILABLE}
 RegisterClassD2Bridge(TVCLObjTSMDBGrid);
{$ENDIF}
{$IFDEF DEVEXPRESS_AVAILABLE}
 RegisterClassD2Bridge(TVCLObjTcxTextEdit);
 RegisterClassD2Bridge(TVCLObjTcxComboBox);
 RegisterClassD2Bridge(TVCLObjTcxCheckBox);
 RegisterClassD2Bridge(TVCLObjTcxMemo);
 RegisterClassD2Bridge(TVCLObjTcxLabel);
 RegisterClassD2Bridge(TVCLObjTcxImage);
 RegisterClassD2Bridge(TVCLObjTcxDateEdit);
 RegisterClassD2Bridge(TVCLObjTcxRadioButton);
 RegisterClassD2Bridge(TVCLObjTcxDBCheckBox);
 RegisterClassD2Bridge(TVCLObjTcxDBComboBox);
 RegisterClassD2Bridge(TVCLObjTcxDBTextEdit);
 RegisterClassD2Bridge(TVCLObjTcxGridDBTableView);
 RegisterClassD2Bridge(TVCLObjTcxDBLookupComboBox);
 RegisterClassD2Bridge(TVCLObjTcxDBMemo);
 RegisterClassD2Bridge(TVCLObjTcxDBLabel);
 RegisterClassD2Bridge(TVCLObjTcxDBDateEdit);
 RegisterClassD2Bridge(TVCLObjTcxButtonEdit);
{$ENDIF}
{$IFDEF JVCL_AVAILABLE}
 RegisterClassD2Bridge(TVCLObjTJvValidateEdit);
 RegisterClassD2Bridge(TVCLObjTJvDBUltimGrid);
 RegisterClassD2Bridge(TVCLObjTJvDBLookupCombo);
 RegisterClassD2Bridge(TVCLObjTJvDbGrid);
 RegisterClassD2Bridge(TVCLObjTJvDatePickerEdit);
 RegisterClassD2Bridge(TVCLObjTJvDBDateEdit);
 RegisterClassD2Bridge(TVCLObjTJvCalcEdit);
 RegisterClassD2Bridge(TVCLObjTJvDBCombobox);
{$ENDIF}
{$IFDEF INFOPOWER_AVAILABLE}
 RegisterClassD2Bridge(TVCLObjTwwDBGrid);
 RegisterClassD2Bridge(TVCLObjTwwDBEdit);
 RegisterClassD2Bridge(TVCLObjTwwButton);
 RegisterClassD2Bridge(TVCLObjTwwDBComboBox);
 RegisterClassD2Bridge(TVCLObjTwwDBLookupCombo);
 RegisterClassD2Bridge(TVCLObjTwwDBComboDlg);
 RegisterClassD2Bridge(TVCLObjTwwDBLookupComboDlg);
 RegisterClassD2Bridge(TVCLObjTwwDBRichEdit);
 RegisterClassD2Bridge(TVCLObjTwwDBDateTimePicker);
 RegisterClassD2Bridge(TVCLObjTwwCheckBox);
 RegisterClassD2Bridge(TVCLObjTwwRadioButton);
 RegisterClassD2Bridge(TVCLObjTwwIncrementalSearch);
 RegisterClassD2Bridge(TVCLObjTwwDBSpinEdit);
{$ENDIF}
{$ENDIF}
end;

procedure TD2BridgeItemVCLObj.Render;
var
  VCLClass, NewClass: TClass;
  //RttiVCLClass, RttiNewClass: TRttiType;
  NewComponent: TPrismControl;
  //Context: TRttiContext;
  ComponentProperty, ComponentPropertyNew: TRttiProperty;
  NomePropriedades: TStringList;
  AuxCompView, AuxCompHide: TComponent;
begin
 inherited;
{$IFDEF D2BRIDGE}
 if (not Renderized) and Assigned(Item) then
 begin
  //  VCLObj.GetInterface(ID2BridgeVCLObj, FBridgeVCLObj);
  VCLClass:= FBridgeVCLObj.VCLClass;

  FBridgeVCLObj.FrameworkItemClass.Clear;
  NewClass:= FBridgeVCLObj.FrameworkItemClass.FrameworkClass;

  // Obtém os tipos Rtti dos componentes original
  //Context := TRttiContext.Create;
  //RttiVCLClass := Context.GetType(VCLClass);

  //Fix Name of Componente
  if Item.Name = '' then
   Item.Name := ItemID;

  NewComponent := TPrismControlClass(NewClass).Create(BaseClass.Form);
  TPrismControl(NewComponent).VCLComponent:= Item;
  TPrismControl(NewComponent).Hidden:= Hidden;
  TPrismControl(NewComponent).Required:= Required;
  TPrismControl(NewComponent).ValidationGroup:= ValidationGroup;
  FPrismControl:= NewComponent as IPrismControl;
  FPrismControl.Name:= Item.Name;
  (FPrismControl as TPrismControl).D2BridgeItem:= self;


  //Obtém os tipos Rtti dos componentes novo
  //RttiNewClass := Context.GetType(NewClass);

  //Load Properties to Copy
  //NomePropriedades:= FBridgeVCLObj.PropertyCopyList;

  //for ComponentProperty in RttiVCLClass.GetProperties do
  //begin
  // try
  //  if NomePropriedades.IndexOf(ComponentProperty.Name) >= 0  then
  //  if Assigned(RttiNewClass.GetProperty(ComponentProperty.Name)) then
  //  if (RttiNewClass.GetProperty(ComponentProperty.Name).IsWritable) then
  //  begin
  //   for ComponentPropertyNew in RttiNewClass.GetProperties do
  //   if not SameText(ComponentProperty.Name, 'Name')  then
  //   if (SameText(ComponentProperty.Name, ComponentPropertyNew.Name)) and (ComponentProperty.PropertyType = ComponentPropertyNew.PropertyType) then
  //   ComponentPropertyNew.SetValue(NewComponent, ComponentProperty.GetValue(Item));
  //  end;
  // Except
  //
  // end;
  //end;

  //Process Class
  FBridgeVCLObj.ProcessPropertyClass(NewComponent);
  FBridgeVCLObj.FrameworkItemClass.ProcessPropertyClass(Item, NewComponent);

  //Process Events
  FBridgeVCLObj.ProcessEventClass;
  FBridgeVCLObj.FrameworkItemClass.ProcessEventClass(Item, NewComponent);

  //Button Icon
  if (FButtonIcon <> '') then
   if FPrismControl.IsButton then
   begin
    PrismControl.AsButton.CSSButtonIcon:= FButtonIcon;
    PrismControl.AsButton.CSSButtonIconPosition:= FButtonIconPosition;
   end;

  //PopupMenu
  if (FPopupHTML.Text <> '') then
   if FPrismControl.IsButton then
    FPrismControl.AsButton.PopupHTML:= FPopupHTML.Text;

  // Remove o componente original e adiciona a nova instância no lugar
  //FreeAndNil(FBridgeVCLObj);

  //NomePropriedades.Free;

//  Renderized:= true;

  NewComponent:= nil;
 end else
 begin
  //Refresh Popup
  try
   if Assigned(PopupMenu) then
   begin
    RenderPopupMenu;

    //PopupMenu
    if (FPopupHTML.Text <> '') then
     if FPrismControl.IsButton then
      FPrismControl.AsButton.PopupHTML:= FPopupHTML.Text;
   end;
  except
  end;

  //Refresh MainMenu
  try
   if Assigned(Item) then
    if Item is {$IFNDEF FMX}TMainMenu{$ELSE}TMenuBar{$ENDIF} then
    begin
     if FBridgeVCLObj is {$IFNDEF FMX}TVCLObjTMainMenu{$ELSE}TFMXObjTMenuBar{$ENDIF} then
      (FBridgeVCLObj as {$IFNDEF FMX}TVCLObjTMainMenu{$ELSE}TFMXObjTMenuBar{$ENDIF}).BuildMenuItems(Item as {$IFNDEF FMX}TMainMenu{$ELSE}TMenuBar{$ENDIF}, FPrismControl as IPrismMainMenu);
    end;
  except
  end;
 end;
{$ENDIF}
end;


procedure TD2BridgeItemVCLObj.RenderHTML;
var
 CSSHTMLComponentByVCLClass: string;
 OverrideText, HTMLComponentOverride, OverrideAditional, CSSClean: string;
 TagClassDropDown, DropDownHTMLExtras: String;
 OpenBracketIndex, CloseBracketIndex, OverrideIndex, HifenIndex, SpaceIndex: Integer;
begin
 TagClassDropDown:= '';
 DropDownHTMLExtras:= '';

 if Assigned(Item) and BaseClass.VCLStyles then
 begin
  if not Assigned(FVCLObjStyle) then
   FVCLObjStyle:= TD2BridgeItemVCLObjStyle.Create;

  RefreshVCLObjStyle;

  ProcessVCLStyles;
 end;

 if FBridgeVCLObj = nil then
 raise Exception.Create('Class Type '+Item.ClassType.ClassName+' not supported to D2Bridge Framework yet' + sLineBreak + 'Error X001-3');

 CSSHTMLComponentByVCLClass:= FBridgeVCLObj.CSSClass;

 if Assigned(Item) and Supports(FBridgeVCLObj.FrameworkItemClass, ID2BridgeFrameworkItemButton) then
 if Assigned(PopupMenu) then
 begin
  //BaseClass.HTML.Render.Body.Add('<div class="dropdown">');
  TagClassDropDown:= ' dropdown-toggle';
  DropDownHTMLExtras:= ' data-bs-toggle="dropdown" aria-expanded="false"';
 end;



  // Encontrar a posição do trecho "[override..."
  OverrideIndex := AnsiPos('[override', CSSClasses);
  if OverrideIndex > 0 then
  begin
    // Encontrar a posição do colchete de abertura "[" a partir da posição do trecho "[override..."
    OpenBracketIndex := AnsiPos('[', Copy(CSSClasses, OverrideIndex, Length(CSSClasses) - OverrideIndex + 1)) + OverrideIndex - 1;
    if OpenBracketIndex > 0 then
    begin
      // Encontrar a posição do colchete de fechamento "]" a partir da posição do colchete de abertura
      CloseBracketIndex := AnsiPos(']', Copy(CSSClasses, OpenBracketIndex, Length(CSSClasses) - OpenBracketIndex + 1)) + OpenBracketIndex - 1;
      if CloseBracketIndex > 0 then
      begin
        // Extrair o trecho entre os colchetes
        OverrideText := Copy(CSSClasses, OpenBracketIndex + 1, CloseBracketIndex - OpenBracketIndex - 1);

        // Verificar se o trecho contém a palavra "override"
        HifenIndex := AnsiPos('-', OverrideText);
        if HifenIndex > 0 then
        begin
          // Encontrar a posição do próximo espaço em branco ou hífen após o hífen encontrado
          SpaceIndex := 0;
          for SpaceIndex := HifenIndex + 1 to Length(OverrideText) do
          begin
            if (OverrideText[SpaceIndex] = ' ') or (OverrideText[SpaceIndex] = '-') then
              Break;
          end;

          // Extrair a classe entre o hífen e o espaço em branco ou próximo hífen
          HTMLComponentOverride := Copy(OverrideText, HifenIndex + 1, SpaceIndex - HifenIndex - 1);

          if pos('-r-', Trim(Copy(OverrideText, SpaceIndex))) = 1 then
          begin
           FButtonIconPosition:= PrismPositionRight;
           OverrideText:= StringReplace(OverrideText, '-r-', '-', []);
           CSSClasses:= StringReplace(CSSClasses, '[override-button-r-', '[override-button-', []);
          end else
          if pos('-t-', Trim(Copy(OverrideText, SpaceIndex))) = 1 then
          begin
           FButtonIconPosition:= PrismPositionTop;
           OverrideText:= StringReplace(OverrideText, '-t-', '-', []);
           CSSClasses:= StringReplace(CSSClasses, '[override-button-t-', '[override-button-', []);
          end else
          if pos('-b-', Trim(Copy(OverrideText, SpaceIndex))) = 1 then
          begin
           FButtonIconPosition:= PrismPositionBottom;
           OverrideText:= StringReplace(OverrideText, '-b-', '-', []);
           CSSClasses:= StringReplace(CSSClasses, '[override-button-b-', '[override-button-', []);
          end else
           FButtonIconPosition:= PrismPositionLeft;

          // Extrair o que vem após o item 2 até o final da string, removendo espaços em branco extras e hífen inicial
          OverrideAditional := Trim(Copy(OverrideText, SpaceIndex + 1));
        end;

        // Remover o trecho entre "[" e "]" e obter o restante da string
        CSSClean := Trim(StringReplace(CSSClasses, '[' + OverrideText + ']', '', []));

        if CompareText(HTMLComponentOverride,'button') = 0 then
        begin
         FButtonIcon:= OverrideAditional;
         BaseClass.HTML.Render.Body.Add('{%'+TrataHTMLTag(ItemPrefixID+' class="'+Trim(CSSHTMLComponentByVCLClass+' '+CSSClean + TagClassDropDown)+'" style="'+GetHTMLStyle+'" '+ GetHTMLExtras + DropDownHTMLExtras ) +'%}');
         //BaseClass.HTML.Render.Body.Add('<button type="button" class="'+Trim(CSSHTMLComponentByVCLClass+' '+CSSClean + TagClassDropDown)+'" id="'+AnsiUpperCase(ItemPrefixID)+'" '+DropDownHTMLExtras+'><i class="'+OverrideAditional+'"></i>'+TButton(Item).{$IFNDEF FMX}Caption{$ELSE}Text{$ENDIF}+'</button>');
         //var HTMLOveride := '{%'+TrataHTMLTag(ItemPrefixID+' type="button" class="'+Trim(CSSHTMLComponentByVCLClass+' '+CSSClean + TagClassDropDown)+'" id="'+AnsiUpperCase(ItemPrefixID)+'" '+DropDownHTMLExtras+'><i class="'+OverrideAditional+'"></i') + '%}';

         if Assigned(PopupMenu) then
         RenderPopupMenu;
        end;

      end;
    end;
  end else
  begin
   if (Assigned(Item)) and Supports(FBridgeVCLObj.FrameworkItemClass, ID2BridgeFrameworkItemButton) then
   if (Pos('btn-', CSSClasses) <= 0) then
    begin
     if CSSClasses <> '' then
      CSSClasses := CSSClasses + ' ';
     CSSClasses := CSSClasses + BaseClass.CSSClass.Button.TypeButton.Default.primary;
    end;


   //Default TAG
   BaseClass.HTML.Render.Body.Add('{%'+TrataHTMLTag(ItemPrefixID+' class="'+Trim(CSSHTMLComponentByVCLClass+' '+CSSClasses+ TagClassDropDown)+'" style="'+GetHTMLStyle+'" '+ GetHTMLExtras + DropDownHTMLExtras ) +'%}');


   if (Assigned(Item)) and Supports(FBridgeVCLObj.FrameworkItemClass, ID2BridgeFrameworkItemButton) then
   if Assigned(PopupMenu) then
   RenderPopupMenu;

  end;


// if (Assigned(Item)) and Supports(BridgeVCLObj.FrameworkItemClass, ID2BridgeFrameworkItemButton) then
// if Assigned(PopupMenu) then
// BaseClass.HTML.Render.Body.Add('</div>');


 //BridgeVCLObj:= nil;
end;

procedure TD2BridgeItemVCLObj.RenderPopupMenu;
var
 I, J: Integer;
 Session: TPrismSession;
 vIcon: string;
begin
 if Assigned(PopupMenu) then
 begin
  Session:= BaseClass.PrismSession;

  if (not Renderized) and Assigned(Item) then
  begin
   BaseClass.CallBacks.Register('CallBackEventPopup'+PopupMenu.Name, CallBackEventPopup);
  end;

  FPopupHTML.Clear;
  FPopupHTML.Add('<ul class="dropdown-menu" aria-labelledby="dropdownMenu'+ItemPrefixID+'">');
  for I := 0 to PopupMenu.{$IFNDEF FMX}Items.Count{$ELSE}ItemsCount{$ENDIF}-1 do
  begin
   if (PopupMenu.Items[I].Visible)
   and (PopupMenu.Items[I].{$IFNDEF FMX}Caption{$ELSE}Text{$ENDIF} <> '-')
   and (PopupMenu.Items[I].{$IFNDEF FMX}Caption{$ELSE}Text{$ENDIF} <> '') then
   begin
    if PopupMenu.Items[I].{$IFNDEF FMX}Count{$ELSE}ItemsCount{$ENDIF} > 0 then
    begin
     for J := 0 to PopupMenu.Items[I].{$IFNDEF FMX}Count{$ELSE}ItemsCount{$ENDIF}-1 do
     if (PopupMenu.Items[I].Items[J].Visible)
     and (PopupMenu.Items[I].Items[J].{$IFNDEF FMX}Caption{$ELSE}Text{$ENDIF} <> '-')
     and (PopupMenu.Items[I].Items[J].{$IFNDEF FMX}Caption{$ELSE}Text{$ENDIF} <> '') then
     begin
      vIcon:= '';
{$IFNDEF FMX}
 {$IFDEF DELPHIX_SYDNEY_UP}
      vIcon:= '<i class="d2bridgebuttonicon ' + PopupMenu.Items[I].Items[J].ImageName + ' me-2"> </i> ';
 {$ENDIF}
{$ENDIF}
      FPopupHTML.Add('<li><a class="d2bridgedowndownitem dropdown-item cursor-pointer" onclick="'+Session.CallBacks.CallBackJS('CallBackEventPopup'+PopupMenu.Name, true, BaseClass.FrameworkForm.FormUUID, QuotedStr(PopupMenu.Items[I].Items[J].Name), true)+'">'+ PopupMenu.Items[I].{$IFNDEF FMX}Caption{$ELSE}Text{$ENDIF}+'->'+ vIcon + PopupMenu.Items[I].Items[J].{$IFNDEF FMX}Caption{$ELSE}Text{$ENDIF} +'</a></li>');
     end;
    end else
    begin
     vIcon:= '';
{$IFNDEF FMX}
 {$IFDEF DELPHIX_SYDNEY_UP}
     vIcon:= '<i class="d2bridgebuttonicon ' + PopupMenu.Items[I].ImageName + ' me-2"> </i> ';
 {$ENDIF}
{$ENDIF}
     FPopupHTML.Add('<li><a class="d2bridgedowndownitem dropdown-item cursor-pointer" onclick="'+Session.CallBacks.CallBackJS('CallBackEventPopup'+PopupMenu.Name, true, BaseClass.FrameworkForm.FormUUID, QuotedStr(PopupMenu.Items[I].Name), true)+'">'+ vIcon + PopupMenu.Items[I].{$IFNDEF FMX}Caption{$ELSE}Text{$ENDIF} +'</a></li>');
    end;
   end;
  end;
  FPopupHTML.Add('</ul>');
 end;
end;

procedure TD2BridgeItemVCLObj.SetIsHidden(AIsHidden: Boolean);
begin
 FIsHidden:= AIsHidden;
end;

procedure TD2BridgeItemVCLObj.SetItem(AItemVCLObj: TComponent);
begin
 FItem:= AItemVCLObj;

 FBridgeVCLObj:= BridgeVCLObjClass(FItem.ClassType);

// if Supports(FBridgeVCLObj.FrameworkItemClass, ID2BridgeFrameworkItemDBMemo) then
// FItemIDHTML := '_D2B'+FItem.Name
// else
 if FItem.Name <> '' then
  ItemID := FItem.Name
 else
 begin
  ItemID := BaseClass.CreateItemID('D2BridgeItemVCLObj');
 end;

end;

procedure TD2BridgeItemVCLObj.SetPopupMenu(APopupMenu: TPopupMenu);
begin
 FPopupMenu:= APopupMenu;
end;

procedure TD2BridgeItemVCLObj.SetRequired(ARequired: Boolean);
begin
 FRequired:= ARequired;
end;

procedure TD2BridgeItemVCLObj.SetValidationGroup(AValidationGroup: Variant);
begin
 FValidationGroup:= AValidationGroup;
end;

function TD2BridgeItemVCLObj.VCLObjStyle: ID2BridgeItemVCLObjStyle;
begin
 result:= FVCLObjStyle;
end;

{$IFDEF FMX}
{ TMenuItemEx }

procedure TMenuItemEx.ClickEx;
begin
  inherited Click;
end;
{$ENDIF}

initialization
 TD2BridgeItemVCLObj.RegisterVCLObjClass;

finalization
 UnRegisterAllClassD2Bridge;

end.


