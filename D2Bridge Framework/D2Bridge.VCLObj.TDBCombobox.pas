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

unit D2Bridge.VCLObj.TDBCombobox;

interface

{$IF NOT DEFINED(FMX) AND DEFINED(D2BRIDGE)}
uses
  Classes, SysUtils,
  DBCtrls, Forms, Graphics, RTTI,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;

type
 TVCLObjTDBCombobox = class(TD2BridgeItemVCLObjCore)
  private
   procedure TDBComboboxOnClick(EventParams: TStrings);
   procedure TDBComboboxOnDblClick(EventParams: TStrings);
   procedure TDBComboboxOnEnter(EventParams: TStrings);
   procedure TDBComboboxOnExit(EventParams: TStrings);
   procedure TDBComboboxOnChange(EventParams: TStrings);
   procedure TDBComboboxOnKeyDown(EventParams: TStrings);
   procedure TDBComboboxOnKeyUp(EventParams: TStrings);
   procedure TDBComboboxOnKeyPress(EventParams: TStrings);

   procedure TDBComboboxOnDestroy;
   function TDBComboboxGetEnabled: Variant;
   procedure TDBComboboxSetEnabled(AValue: Variant);
   function TDBComboboxGetVisible: Variant;
   procedure TDBComboboxSetVisible(AValue: Variant);
   function TDBComboboxGetReadOnly: Variant;
   procedure TDBComboboxSetReadOnly(AValue: Variant);
   function TDBComboboxGetPlaceholder: Variant;
   function TDBComboboxProcGetItems: TStrings;

  public
   function VCLClass: TClass; override;
   function CSSClass: String; override;
   Procedure VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle); override;
   procedure ProcessPropertyClass(NewObj: TObject); override;
   procedure ProcessEventClass; override;
   function PropertyCopyList: TStringList; override;
   function FrameworkItemClass: ID2BridgeFrameworkItem; override;
 end;

implementation

uses
  Prism.Util, D2Bridge.Util, D2Bridge.Forms, D2Bridge.Item.VCLObj.Style,
  Prism.Forms, D2Bridge.Forms.Helper, Prism.Session.Thread.Proc;

{ TVCLObjTDBCombobox }

function TVCLObjTDBCombobox.CSSClass: String;
begin
 result := 'form-select';
end;

function TVCLObjTDBCombobox.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result := FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox;
end;

procedure TVCLObjTDBCombobox.TDBComboboxOnClick(EventParams: TStrings);
begin
  TDBCombobox(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBCombobox.TDBComboboxOnDblClick(EventParams: TStrings);
begin
  TDBCombobox(FD2BridgeItemVCLObj.Item).OnDblClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBCombobox.TDBComboboxOnEnter(EventParams: TStrings);
begin
  TDBCombobox(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBCombobox.TDBComboboxOnExit(EventParams: TStrings);
begin
  TDBCombobox(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBCombobox.TDBComboboxOnChange(EventParams: TStrings);
begin
  TDBCombobox(FD2BridgeItemVCLObj.Item).OnChange(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBCombobox.TDBComboboxOnKeyDown(EventParams: TStrings);
var
  KeyPress: word;
begin
  KeyPress := ConvertHTMLKeyToVK(EventParams.Values['key']);
  TDBCombobox(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
end;

procedure TVCLObjTDBCombobox.TDBComboboxOnKeyUp(EventParams: TStrings);
var
  KeyPress: word;
begin
  KeyPress := ConvertHTMLKeyToVK(EventParams.Values['key']);
  TDBCombobox(FD2BridgeItemVCLObj.Item).OnKeyUp(FD2BridgeItemVCLObj.Item, KeyPress, []);
end;

procedure TVCLObjTDBCombobox.TDBComboboxOnKeyPress(EventParams: TStrings);
var
  KeyPress: Char;
begin
  KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.Values['key']));
  TDBCombobox(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
end;

procedure TVCLObjTDBCombobox.ProcessEventClass;
begin
 if Assigned(TDBCombobox(FD2BridgeItemVCLObj.Item).OnClick) then
   FrameworkItemClass.OnClick := TDBComboboxOnClick;

 if Assigned(TDBCombobox(FD2BridgeItemVCLObj.Item).OnDblClick) then
   FrameworkItemClass.OnDblClick := TDBComboboxOnDblClick;

 if Assigned(TDBCombobox(FD2BridgeItemVCLObj.Item).OnEnter) then
   FrameworkItemClass.OnEnter := TDBComboboxOnEnter;

 if Assigned(TDBCombobox(FD2BridgeItemVCLObj.Item).OnExit) then
   FrameworkItemClass.OnExit := TDBComboboxOnExit;

 if Assigned(TDBCombobox(FD2BridgeItemVCLObj.Item).OnChange) then
   FrameworkItemClass.OnChange := TDBComboboxOnChange;

 if Assigned(TDBCombobox(FD2BridgeItemVCLObj.Item).OnKeyDown) then
   FrameworkItemClass.OnKeyDown := TDBComboboxOnKeyDown;

 if Assigned(TDBCombobox(FD2BridgeItemVCLObj.Item).OnKeyUp) then
   FrameworkItemClass.OnKeyUp := TDBComboboxOnKeyUp;

 if Assigned(TDBCombobox(FD2BridgeItemVCLObj.Item).OnKeyPress) then
   FrameworkItemClass.OnKeyPress := TDBComboboxOnKeyPress;
end;

procedure TVCLObjTDBCombobox.TDBComboboxOnDestroy;
var
 vvItems: TStrings;
begin
 vvItems:= TD2BridgeFormComponentHelper(TDBCombobox(FD2BridgeItemVCLObj.Item).Tag).Value['Items'].AsObject as TStrings;
 FreeAndNil(vvItems);
 TD2BridgeFormComponentHelper(TDBCombobox(FD2BridgeItemVCLObj.Item).Tag).Value['Items']:= TValue.Empty;
end;

procedure TVCLObjTDBCombobox.ProcessPropertyClass(NewObj: TObject);
{$IFnDEF FPC}
var
 vD2BridgeForm: TD2BridgeForm;
 vProc: TPrismSessionThreadProc;
{$ENDIF}
begin
{$IFnDEF FPC}
 if NewObj is TPrismControl then
  if Assigned(TPrismControl(NewObj).Form) then
  begin
   vD2BridgeForm:= ((NewObj as TPrismControl).Form as TPrismForm).D2BridgeForm;

   TComponent(FD2BridgeItemVCLObj.Item).Tag := NativeInt(vD2BridgeForm.D2BridgeFormComponentHelperItems.PropValues(FD2BridgeItemVCLObj.Item));

   TPrismSessionThreadProc.Create(nil, TDBCombobox(FD2BridgeItemVCLObj.Item).InstanceHelper, true, true).Exec;

   TD2BridgeFormComponentHelper(TDBCombobox(FD2BridgeItemVCLObj.Item).Tag).OnDestroy:= TDBComboboxOnDestroy;
  end;
{$ENDIF}

 if Assigned(TDBCombobox(FD2BridgeItemVCLObj.Item).DataSource) then
   FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.Dataware.DataSource := TDBCombobox(FD2BridgeItemVCLObj.Item).DataSource;

 if TDBCombobox(FD2BridgeItemVCLObj.Item).DataField <> '' then
   FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.Dataware.DataField := TDBCombobox(FD2BridgeItemVCLObj.Item).DataField;

 //Need to fix error in Nested
 TDBCombobox(FD2BridgeItemVCLObj.Item).DataSource := nil;
 TDBCombobox(FD2BridgeItemVCLObj.Item).DataField := '';

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.ProcGetItems := TDBComboboxProcGetItems;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.GetEnabled := TDBComboboxGetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.SetEnabled := TDBComboboxSetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.GetVisible := TDBComboboxGetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.SetVisible := TDBComboboxSetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.GetReadOnly := TDBComboboxGetReadOnly;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.SetReadOnly := TDBComboboxSetReadOnly;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox.GetPlaceholder := TDBComboboxGetPlaceholder;
end;

function TVCLObjTDBCombobox.TDBComboboxProcGetItems: TStrings;
begin
  Result := TDBCombobox(FD2BridgeItemVCLObj.Item).Items;
end;

function TVCLObjTDBCombobox.TDBComboboxGetEnabled: Variant;
begin
  Result := GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBCombobox.TDBComboboxSetEnabled(AValue: Variant);
begin
  TDBCombobox(FD2BridgeItemVCLObj.Item).Enabled := AValue;
end;

function TVCLObjTDBCombobox.TDBComboboxGetVisible: Variant;
begin
  Result := GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBCombobox.TDBComboboxSetVisible(AValue: Variant);
begin
  TDBCombobox(FD2BridgeItemVCLObj.Item).Visible := AValue;
end;

function TVCLObjTDBCombobox.TDBComboboxGetReadOnly: Variant;
begin
  Result := TDBCombobox(FD2BridgeItemVCLObj.Item).ReadOnly;
end;

procedure TVCLObjTDBCombobox.TDBComboboxSetReadOnly(AValue: Variant);
begin
  TDBCombobox(FD2BridgeItemVCLObj.Item).ReadOnly := AValue;
end;

function TVCLObjTDBCombobox.TDBComboboxGetPlaceholder: Variant;
begin
  if TDBCombobox(FD2BridgeItemVCLObj.Item).TextHint <> '' then
    Result := TDBCombobox(FD2BridgeItemVCLObj.Item).TextHint
  else if TDBCombobox(FD2BridgeItemVCLObj.Item).ShowHint then
    Result := TDBCombobox(FD2BridgeItemVCLObj.Item).Hint
  else
    Result := '';
end;

function TVCLObjTDBCombobox.PropertyCopyList: TStringList;
begin
 Result := inherited;

 if Result.IndexOf('Text') >= 0 then
   Result.Delete(Result.IndexOf('Text'));
end;

function TVCLObjTDBCombobox.VCLClass: TClass;
begin
 Result := TDBCombobox;
end;

procedure TVCLObjTDBCombobox.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TDBCombobox(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize := TDBCombobox(FD2BridgeItemVCLObj.Item).Font.Size;

 if TDBCombobox(FD2BridgeItemVCLObj.Item).Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor := TDBCombobox(FD2BridgeItemVCLObj.Item).Font.Color;

 if not IsColor(TDBCombobox(FD2BridgeItemVCLObj.Item).Color, [clWindow, clDefault]) then
  VCLObjStyle.Color := TDBCombobox(FD2BridgeItemVCLObj.Item).Color;

 VCLObjStyle.FontStyles := TDBCombobox(FD2BridgeItemVCLObj.Item).Font.Style;
end;

{$ELSE}
implementation
{$ENDIF}

end.

