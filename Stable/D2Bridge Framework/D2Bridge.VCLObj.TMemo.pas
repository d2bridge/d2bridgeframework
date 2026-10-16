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
  Thank for contribution to this Unit to:
    Edvanio Jancy
    edvanio@ideiasistemas.com.br
 +--------------------------------------------------------------------------+
}

{$I D2Bridge.inc}

unit D2Bridge.VCLObj.TMemo;

interface

{$IFDEF D2BRIDGE}
uses
  Classes, RTTI,
{$IFDEF FMX}
  FMX.Memo,
{$ELSE}
  ExtCtrls, StdCtrls, Graphics, Forms,
{$ENDIF}
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass,
  Prism.Forms;

type
 TVCLObjTMemo = class(TD2BridgeItemVCLObjCore)
  private
   procedure TMemoOnClick(EventParams: TStrings);
   procedure TMemoOnDblClick(EventParams: TStrings);
   procedure TMemoOnEnter(EventParams: TStrings);
   procedure TMemoOnExit(EventParams: TStrings);
   procedure TMemoOnChange(EventParams: TStrings);
   procedure TMemoOnKeyUp(EventParams: TStrings);
   procedure TMemoOnKeyDown(EventParams: TStrings);
{$IFNDEF FMX}
   procedure TMemoOnKeyPress(EventParams: TStrings);
{$ENDIF}
   procedure TMemoOnDestroy;
   function TMemoGetEnabled: Variant;
   procedure TMemoSetEnabled(AValue: Variant);
   function TMemoGetVisible: Variant;
   procedure TMemoSetVisible(AValue: Variant);
   function TMemoGetReadOnly: Variant;
   procedure TMemoSetReadOnly(AValue: Variant);
   function TMemoGetPlaceholder: Variant;
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
  Prism.Util, D2Bridge.Util, D2Bridge.Item.VCLObj.Style, Prism.Forms.Controls,
  D2Bridge.Forms, D2Bridge.Forms.Helper, Prism.Session.Thread.Proc;

{ TVCLObjTMemo }

function TVCLObjTMemo.CSSClass: String;
begin
  Result := 'form-control';
end;

function TVCLObjTMemo.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
  Result := FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Memo;
end;

procedure TVCLObjTMemo.TMemoOnClick(EventParams: TStrings);
begin
  TMemo(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTMemo.TMemoOnDblClick(EventParams: TStrings);
begin
  TMemo(FD2BridgeItemVCLObj.Item).OnDblClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTMemo.TMemoOnEnter(EventParams: TStrings);
begin
  TMemo(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTMemo.TMemoOnExit(EventParams: TStrings);
begin
  TMemo(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTMemo.TMemoOnChange(EventParams: TStrings);
begin
  TMemo(FD2BridgeItemVCLObj.Item).OnChange(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTMemo.TMemoOnKeyUp(EventParams: TStrings);
var
  KeyPress: word;
  KeyChar: Char;
begin
  KeyPress := ConvertHTMLKeyToVK(EventParams.Values['key']);
{$IFNDEF FMX}
  TMemo(FD2BridgeItemVCLObj.Item).OnKeyUp(FD2BridgeItemVCLObj.Item, KeyPress, []);
{$ELSE}
  KeyChar := Char(KeyPress);
  TMemo(FD2BridgeItemVCLObj.Item).OnKeyUp(FD2BridgeItemVCLObj.Item, KeyPress, KeyChar, []);
{$ENDIF}
end;

procedure TVCLObjTMemo.TMemoOnKeyDown(EventParams: TStrings);
var
  KeyPress: word;
  KeyChar: Char;
begin
  KeyPress := ConvertHTMLKeyToVK(EventParams.Values['key']);
{$IFNDEF FMX}
  TMemo(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
{$ELSE}
  KeyChar := Char(KeyPress);
  TMemo(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, KeyChar, []);
{$ENDIF}
end;

{$IFNDEF FMX}
procedure TVCLObjTMemo.TMemoOnKeyPress(EventParams: TStrings);
var
  KeyPress: Char;
begin
  KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.Values['key']));
  TMemo(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
end;
{$ENDIF}

procedure TVCLObjTMemo.ProcessEventClass;
begin
  if Assigned(TMemo(FD2BridgeItemVCLObj.Item).OnClick) then
    FrameworkItemClass.OnClick := TMemoOnClick;

  if Assigned(TMemo(FD2BridgeItemVCLObj.Item).OnDblClick) then
    FrameworkItemClass.OnDblClick := TMemoOnDblClick;

  if Assigned(TMemo(FD2BridgeItemVCLObj.Item).OnEnter) then
    FrameworkItemClass.OnEnter := TMemoOnEnter;

  if Assigned(TMemo(FD2BridgeItemVCLObj.Item).OnExit) then
    FrameworkItemClass.OnExit := TMemoOnExit;

  if Assigned(TMemo(FD2BridgeItemVCLObj.Item).OnChange) then
    FrameworkItemClass.OnChange := TMemoOnChange;

  if Assigned(TMemo(FD2BridgeItemVCLObj.Item).OnKeyUp) then
    FrameworkItemClass.OnKeyUp := TMemoOnKeyUp;

  if Assigned(TMemo(FD2BridgeItemVCLObj.Item).OnKeyDown) then
    FrameworkItemClass.OnKeyDown := TMemoOnKeyDown;

{$IFNDEF FMX}
  if Assigned(TMemo(FD2BridgeItemVCLObj.Item).OnKeyPress) then
    FrameworkItemClass.OnKeyPress := TMemoOnKeyPress;
{$ENDIF}
end;

procedure TVCLObjTMemo.TMemoOnDestroy;
var
 vvItems: TStrings;
begin
 vvItems:= TD2BridgeFormComponentHelper(TMemo(FD2BridgeItemVCLObj.Item).Tag).Value['Lines'].AsObject as TStrings;
 vvItems.Free;
 TD2BridgeFormComponentHelper(TMemo(FD2BridgeItemVCLObj.Item).Tag).Value['Lines']:= TValue.Empty;
end;

function TVCLObjTMemo.TMemoGetEnabled: Variant;
begin
  Result := GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTMemo.TMemoSetEnabled(AValue: Variant);
begin
  TMemo(FD2BridgeItemVCLObj.Item).Enabled := AValue;
end;

function TVCLObjTMemo.TMemoGetVisible: Variant;
begin
  Result := GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTMemo.TMemoSetVisible(AValue: Variant);
begin
  TMemo(FD2BridgeItemVCLObj.Item).Visible := AValue;
end;

function TVCLObjTMemo.TMemoGetReadOnly: Variant;
begin
  Result := TMemo(FD2BridgeItemVCLObj.Item).ReadOnly;
end;

procedure TVCLObjTMemo.TMemoSetReadOnly(AValue: Variant);
begin
  TMemo(FD2BridgeItemVCLObj.Item).ReadOnly := AValue;
end;

function TVCLObjTMemo.TMemoGetPlaceholder: Variant;
begin
{$IFNDEF FMX}
  if TMemo(FD2BridgeItemVCLObj.Item).TextHint <> '' then
    Result := TMemo(FD2BridgeItemVCLObj.Item).TextHint
  else
{$ENDIF}
  if TMemo(FD2BridgeItemVCLObj.Item).ShowHint then
    Result := TMemo(FD2BridgeItemVCLObj.Item).Hint
  else
    Result := '';
end;

procedure TVCLObjTMemo.ProcessPropertyClass(NewObj: TObject);
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
   vD2BridgeForm:= (TPrismControl(NewObj).Form as TPrismForm).D2BridgeForm;

   TComponent(FD2BridgeItemVCLObj.Item).Tag := NativeInt(vD2BridgeForm.D2BridgeFormComponentHelperItems.PropValues(FD2BridgeItemVCLObj.Item));

   TPrismSessionThreadProc.Create(nil, TMemo(FD2BridgeItemVCLObj.Item).InstanceHelper, true, true).Exec;

   FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Memo.Lines:= TMemo(FD2BridgeItemVCLObj.Item).Lines;

   TD2BridgeFormComponentHelper(TMemo(FD2BridgeItemVCLObj.Item).Tag).OnDestroy:= TMemoOnDestroy;
  end;
{$ELSE}
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Memo.Lines:= TMemo(FD2BridgeItemVCLObj.Item).Lines;
{$ENDIF}

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Memo.GetEnabled := TMemoGetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Memo.SetEnabled := TMemoSetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Memo.GetVisible := TMemoGetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Memo.SetVisible := TMemoSetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Memo.GetReadOnly := TMemoGetReadOnly;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Memo.SetReadOnly := TMemoSetReadOnly;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Memo.GetPlaceholder := TMemoGetPlaceholder;
end;

function TVCLObjTMemo.VCLClass: TClass;
begin
  Result := TMemo;
end;

procedure TVCLObjTMemo.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TMemo(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize:= TMemo(FD2BridgeItemVCLObj.Item).Font.Size;

 if TMemo(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}Font.Color{$ELSE}FontColor{$ENDIF} <> DefaultFontColor then
  VCLObjStyle.FontColor:= TMemo(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}Font.Color{$ELSE}FontColor{$ENDIF};

{$IFNDEF FMX}
 if not IsColor(TMemo(FD2BridgeItemVCLObj.Item).Color, [clWindow, clDefault]) then
  VCLObjStyle.Color:= TMemo(FD2BridgeItemVCLObj.Item).Color;
{$ENDIF}

 if TMemo(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}Alignment{$ELSE}TextSettings.HorzAlign{$ENDIF} <> DefaultAlignment then
  VCLObjStyle.Alignment:= TMemo(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}Alignment{$ELSE}TextSettings.HorzAlign{$ENDIF};

 VCLObjStyle.FontStyles:= TMemo(FD2BridgeItemVCLObj.Item).Font.Style;
end;

{$ELSE}
implementation
{$ENDIF}

end.