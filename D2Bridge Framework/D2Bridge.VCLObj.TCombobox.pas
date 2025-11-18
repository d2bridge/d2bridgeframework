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

unit D2Bridge.VCLObj.TCombobox;


interface

{$IF DEFINED(D2BRIDGE)}
uses
  Classes, SysUtils, RTTI,
{$IFDEF FMX}
  FMX.ListBox,
{$ELSE}
  StdCtrls, Forms, Graphics,
{$ENDIF}
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass, D2Bridge.Forms;


type
 TVCLObjTCombobox = class(TD2BridgeItemVCLObjCore)
  strict private

  private
   procedure TComboboxOnSelect(EventParams: TStrings);
   procedure TComboboxOnClick(EventParams: TStrings);
   procedure TComboboxOnDblClick(EventParams: TStrings);
   procedure TComboboxOnEnter(EventParams: TStrings);
   procedure TComboboxOnExit(EventParams: TStrings);
   procedure TComboboxOnChange(EventParams: TStrings);
   procedure TComboboxOnKeyDown(EventParams: TStrings);
   procedure TComboboxOnKeyUp(EventParams: TStrings);
{$IFNDEF FMX}
   procedure TComboboxOnKeyPress(EventParams: TStrings);
{$ENDIF}

   procedure TComboboxOnDestroy;
   function TComboboxProcGetItems: TStrings;
   function TComboboxProcGetSelectedItem: Variant;
   procedure TComboboxProcSetSelectedItem(AValue: Variant);
   function TComboboxGetEnabled: Variant;
   procedure TComboboxSetEnabled(AValue: Variant);
   function TComboboxGetVisible: Variant;
   procedure TComboboxSetVisible(AValue: Variant);
   function TComboboxGetPlaceholder: Variant;
  public
   function VCLClass: TClass; override;
   function CSSClass: String; override;
   Procedure VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle); override;
   procedure ProcessPropertyClass(NewObj: TObject); override;
   procedure ProcessEventClass; override;
   function FrameworkItemClass: ID2BridgeFrameworkItem; override;
 end;


implementation

uses
 Prism.Util, D2Bridge.Util, D2Bridge.Item.VCLObj.Style,
 Prism.Forms, D2Bridge.Forms.Helper, Prism.Session.Thread.Proc;

{ TVCLObjTCombobox }


function TVCLObjTCombobox.CSSClass: String;
begin
 result:= 'form-select';
end;

function TVCLObjTCombobox.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox;
end;

procedure TVCLObjTCombobox.TComboboxOnSelect(EventParams: TStrings);
begin
  TCombobox(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}OnSelect{$ELSE}OnChange{$ENDIF}(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTCombobox.TComboboxOnClick(EventParams: TStrings);
begin
  TCombobox(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTCombobox.TComboboxOnDblClick(EventParams: TStrings);
begin
  TCombobox(FD2BridgeItemVCLObj.Item).OnDblClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTCombobox.TComboboxOnEnter(EventParams: TStrings);
begin
  TCombobox(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTCombobox.TComboboxOnExit(EventParams: TStrings);
begin
  TCombobox(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTCombobox.TComboboxOnChange(EventParams: TStrings);
begin
  TCombobox(FD2BridgeItemVCLObj.Item).OnChange(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTCombobox.TComboboxOnKeyDown(EventParams: TStrings);
var
  KeyPress: word;
  KeyChar: Char;
begin
  KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
{$IFNDEF FMX}
  TCombobox(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
{$ELSE}
  KeyChar := Char(KeyPress);
  TCombobox(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, KeyChar, []);
{$ENDIF}
end;

procedure TVCLObjTCombobox.TComboboxOnKeyUp(EventParams: TStrings);
var
  KeyPress: word;
  KeyChar: Char;
begin
  KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
{$IFNDEF FMX}
  TCombobox(FD2BridgeItemVCLObj.Item).OnKeyUp(FD2BridgeItemVCLObj.Item, KeyPress, []);
{$ELSE}
  KeyChar := Char(KeyPress);
  TCombobox(FD2BridgeItemVCLObj.Item).OnKeyUp(FD2BridgeItemVCLObj.Item, KeyPress, KeyChar, []);
{$ENDIF}
end;

{$IFNDEF FMX}
procedure TVCLObjTCombobox.TComboboxOnKeyPress(EventParams: TStrings);
var
  KeyPress: Char;
begin
  KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
  TCombobox(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
end;
{$ENDIF}

procedure TVCLObjTCombobox.ProcessEventClass;
begin
 if Assigned(TCombobox(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}OnSelect{$ELSE}OnChange{$ENDIF}) then
   FrameworkItemClass.OnSelect := TComboboxOnSelect;

 if Assigned(TCombobox(FD2BridgeItemVCLObj.Item).OnClick) then
   FrameworkItemClass.OnClick := TComboboxOnClick;

 if Assigned(TCombobox(FD2BridgeItemVCLObj.Item).OnDblClick) then
   FrameworkItemClass.OnDblClick := TComboboxOnDblClick;

 if Assigned(TCombobox(FD2BridgeItemVCLObj.Item).OnEnter) then
   FrameworkItemClass.OnEnter := TComboboxOnEnter;

 if Assigned(TCombobox(FD2BridgeItemVCLObj.Item).OnExit) then
   FrameworkItemClass.OnExit := TComboboxOnExit;

 if Assigned(TCombobox(FD2BridgeItemVCLObj.Item).OnChange) then
   FrameworkItemClass.OnChange := TComboboxOnChange;

 if Assigned(TCombobox(FD2BridgeItemVCLObj.Item).OnKeyDown) then
   FrameworkItemClass.OnKeyDown := TComboboxOnKeyDown;

 if Assigned(TCombobox(FD2BridgeItemVCLObj.Item).OnKeyUp) then
   FrameworkItemClass.OnKeyUp := TComboboxOnKeyUp;

{$IFNDEF FMX}
 if Assigned(TCombobox(FD2BridgeItemVCLObj.Item).OnKeyPress) then
   FrameworkItemClass.OnKeyPress := TComboboxOnKeyPress;
{$ENDIF}
end;

function TVCLObjTCombobox.TComboboxProcGetItems: TStrings;
begin
  Result := TCombobox(FD2BridgeItemVCLObj.Item).Items;
end;

function TVCLObjTCombobox.TComboboxProcGetSelectedItem: Variant;
begin
 Result:= '';
 if (TCombobox(FD2BridgeItemVCLObj.Item).ItemIndex >= 0) and (TCombobox(FD2BridgeItemVCLObj.Item).Items.Count > 0) then
  Result:= TCombobox(FD2BridgeItemVCLObj.Item).Items[TCombobox(FD2BridgeItemVCLObj.Item).ItemIndex];
 //Result:= TCombobox(FD2BridgeItemVCLObj.Item).Text;
end;

procedure TVCLObjTCombobox.TComboboxProcSetSelectedItem(AValue: Variant);
begin
{$IFNDEF FMX}
  if TCombobox(FD2BridgeItemVCLObj.Item).Items.IndexOf(AValue) < 0 then
    TCombobox(FD2BridgeItemVCLObj.Item).Text := String(AValue)
  else
{$ENDIF}
    TCombobox(FD2BridgeItemVCLObj.Item).ItemIndex := TCombobox(FD2BridgeItemVCLObj.Item).Items.IndexOf(AValue);
end;

function TVCLObjTCombobox.TComboboxGetEnabled: Variant;
begin
  Result := GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTCombobox.TComboboxSetEnabled(AValue: Variant);
begin
  TCombobox(FD2BridgeItemVCLObj.Item).Enabled := AValue;
end;

function TVCLObjTCombobox.TComboboxGetVisible: Variant;
begin
  Result := GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTCombobox.TComboboxSetVisible(AValue: Variant);
begin
  TCombobox(FD2BridgeItemVCLObj.Item).Visible := AValue;
end;

function TVCLObjTCombobox.TComboboxGetPlaceholder: Variant;
begin
{$IFNDEF FMX}
  if TCombobox(FD2BridgeItemVCLObj.Item).TextHint <> '' then
    Result := TCombobox(FD2BridgeItemVCLObj.Item).TextHint
  else
{$ENDIF}
  if TCombobox(FD2BridgeItemVCLObj.Item).ShowHint then
    Result := TCombobox(FD2BridgeItemVCLObj.Item).Hint
  else
    Result := '';
end;

procedure TVCLObjTCombobox.TComboboxOnDestroy;
var
 vvItems: TStrings;
begin
 vvItems:= TD2BridgeFormComponentHelper(TCombobox(FD2BridgeItemVCLObj.Item).Tag).Value['Items'].AsObject as TStrings;
 FreeAndNil(vvItems);
 TD2BridgeFormComponentHelper(TCombobox(FD2BridgeItemVCLObj.Item).Tag).Value['Items']:= TValue.Empty;
end;

procedure TVCLObjTCombobox.ProcessPropertyClass(NewObj: TObject);
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
   if not TagIsD2BridgeFormComponentHelper(TCombobox(FD2BridgeItemVCLObj.Item).Tag, 'Items') then
   begin
    vD2BridgeForm:= (TPrismControl(NewObj).Form as TPrismForm).D2BridgeForm;

    TComponent(FD2BridgeItemVCLObj.Item).Tag := NativeInt(vD2BridgeForm.D2BridgeFormComponentHelperItems.PropValues(FD2BridgeItemVCLObj.Item));

    TPrismSessionThreadProc.Create(nil, TCombobox(FD2BridgeItemVCLObj.Item).InstanceHelper, true, true).Exec;

    TD2BridgeFormComponentHelper(TCombobox(FD2BridgeItemVCLObj.Item).Tag).OnDestroy:= TComboboxOnDestroy;
   end;
  end;
{$ENDIF}

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox.ProcGetItems := TComboboxProcGetItems;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox.ProcGetSelectedItem := TComboboxProcGetSelectedItem;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox.ProcSetSelectedItem := TComboboxProcSetSelectedItem;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox.GetEnabled := TComboboxGetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox.SetEnabled := TComboboxSetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox.GetVisible := TComboboxGetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox.SetVisible := TComboboxSetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox.GetPlaceholder := TComboboxGetPlaceholder;
end;

function TVCLObjTCombobox.VCLClass: TClass;
begin
 Result:= TComboBox;
end;

procedure TVCLObjTCombobox.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
{$IFNDEF FMX}
 if TCombobox(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize:= TCombobox(FD2BridgeItemVCLObj.Item).Font.Size;

 if TCombobox(FD2BridgeItemVCLObj.Item).Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor:= TCombobox(FD2BridgeItemVCLObj.Item).Font.Color;

 if not IsColor(TCombobox(FD2BridgeItemVCLObj.Item).Color, [clWindow, clDefault]) then
  VCLObjStyle.Color:= TCombobox(FD2BridgeItemVCLObj.Item).Color;

 VCLObjStyle.FontStyles:= TCombobox(FD2BridgeItemVCLObj.Item).Font.Style;
{$ENDIF}
end;

{$ELSE}
implementation
{$ENDIF}

end.