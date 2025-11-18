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

unit D2Bridge.VCLObj.TMaskEdit;


interface

{$IFNDEF FMX}
uses
  Classes,
  DBCtrls, Graphics,
{$IFNDEF FPC}
 {$IFDEF DELPHIX_SYDNEY_UP}
  Vcl.Mask,
 {$ELSE}
  Mask,
 {$ENDIF}
{$ELSE}
  MaskEdit,
{$ENDIF}
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;

type
 TVCLObjTMaskEdit = class(TD2BridgeItemVCLObjCore)
  private
    procedure TMaskEditOnClick(EventParams: TStrings);
    procedure TMaskEditOnDblClick(EventParams: TStrings);
    procedure TMaskEditOnEnter(EventParams: TStrings);
    procedure TMaskEditOnExit(EventParams: TStrings);
    procedure TMaskEditOnChange(EventParams: TStrings);
    procedure TMaskEditOnKeyDown(EventParams: TStrings);
    procedure TMaskEditOnKeyUp(EventParams: TStrings);
    procedure TMaskEditOnKeyPress(EventParams: TStrings);

    function TMaskEditGetEnabled: Variant;
    procedure TMaskEditSetEnabled(AValue: Variant);
    function TMaskEditGetVisible: Variant;
    procedure TMaskEditSetVisible(AValue: Variant);
    function TMaskEditGetReadOnly: Variant;
    procedure TMaskEditSetReadOnly(AValue: Variant);
    function TMaskEditGetPlaceholder: Variant;

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
  Prism.Util, D2Bridge.Util, Prism.Types, D2Bridge.Item.VCLObj.Style;

{ TVCLObjTMaskEdit }

function TVCLObjTMaskEdit.CSSClass: String;
begin
 result := 'form-control';
end;

function TVCLObjTMaskEdit.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result := FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit;
end;

procedure TVCLObjTMaskEdit.ProcessEventClass;
begin
 if Assigned(TMaskEdit(FD2BridgeItemVCLObj.Item).OnClick) then
   FrameworkItemClass.OnClick := TMaskEditOnClick;

 if Assigned(TMaskEdit(FD2BridgeItemVCLObj.Item).OnDblClick) then
   FrameworkItemClass.OnDblClick := TMaskEditOnDblClick;

 if Assigned(TMaskEdit(FD2BridgeItemVCLObj.Item).OnEnter) then
   FrameworkItemClass.OnEnter := TMaskEditOnEnter;

 if Assigned(TMaskEdit(FD2BridgeItemVCLObj.Item).OnExit) then
   FrameworkItemClass.OnExit := TMaskEditOnExit;

 if Assigned(TMaskEdit(FD2BridgeItemVCLObj.Item).OnChange) then
   FrameworkItemClass.OnChange := TMaskEditOnChange;

 if Assigned(TMaskEdit(FD2BridgeItemVCLObj.Item).OnKeyDown) then
   FrameworkItemClass.OnKeyDown := TMaskEditOnKeyDown;

 if Assigned(TMaskEdit(FD2BridgeItemVCLObj.Item).OnKeyUp) then
   FrameworkItemClass.OnKeyUp := TMaskEditOnKeyUp;

 if Assigned(TMaskEdit(FD2BridgeItemVCLObj.Item).OnKeyPress) then
   FrameworkItemClass.OnKeyPress := TMaskEditOnKeyPress;
end;

procedure TVCLObjTMaskEdit.TMaskEditOnClick(EventParams: TStrings);
begin
  TMaskEdit(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTMaskEdit.TMaskEditOnDblClick(EventParams: TStrings);
begin
  TMaskEdit(FD2BridgeItemVCLObj.Item).OnDblClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTMaskEdit.TMaskEditOnEnter(EventParams: TStrings);
begin
  TMaskEdit(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTMaskEdit.TMaskEditOnExit(EventParams: TStrings);
begin
  TMaskEdit(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTMaskEdit.TMaskEditOnChange(EventParams: TStrings);
begin
  TMaskEdit(FD2BridgeItemVCLObj.Item).OnChange(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTMaskEdit.TMaskEditOnKeyDown(EventParams: TStrings);
var
  KeyPress: Word;
begin
  KeyPress := ConvertHTMLKeyToVK(EventParams.Values['key']);
  TMaskEdit(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
end;

procedure TVCLObjTMaskEdit.TMaskEditOnKeyUp(EventParams: TStrings);
var
  KeyPress: Word;
begin
  KeyPress := ConvertHTMLKeyToVK(EventParams.Values['key']);
  TMaskEdit(FD2BridgeItemVCLObj.Item).OnKeyUp(FD2BridgeItemVCLObj.Item, KeyPress, []);
end;

procedure TVCLObjTMaskEdit.TMaskEditOnKeyPress(EventParams: TStrings);
var
  KeyPress: Char;
begin
  KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.Values['key']));
  TMaskEdit(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
end;

procedure TVCLObjTMaskEdit.ProcessPropertyClass(NewObj: TObject);
begin
 if TMaskEdit(FD2BridgeItemVCLObj.Item).PasswordChar <> #0 then
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.DataType := PrismFieldTypePassword;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.CharCase := TMaskEdit(FD2BridgeItemVCLObj.Item).CharCase;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.GetEnabled := TMaskEditGetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.SetEnabled := TMaskEditSetEnabled;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.GetVisible := TMaskEditGetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.SetVisible := TMaskEditSetVisible;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.GetReadOnly := TMaskEditGetReadOnly;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.SetReadOnly := TMaskEditSetReadOnly;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.GetPlaceholder := TMaskEditGetPlaceholder;
end;

function TVCLObjTMaskEdit.TMaskEditGetEnabled: Variant;
begin
  Result := GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTMaskEdit.TMaskEditSetEnabled(AValue: Variant);
begin
  TMaskEdit(FD2BridgeItemVCLObj.Item).Enabled := AValue;
end;

function TVCLObjTMaskEdit.TMaskEditGetVisible: Variant;
begin
  Result := GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTMaskEdit.TMaskEditSetVisible(AValue: Variant);
begin
  TMaskEdit(FD2BridgeItemVCLObj.Item).Visible := AValue;
end;

function TVCLObjTMaskEdit.TMaskEditGetReadOnly: Variant;
begin
  Result := TMaskEdit(FD2BridgeItemVCLObj.Item).ReadOnly;
end;

procedure TVCLObjTMaskEdit.TMaskEditSetReadOnly(AValue: Variant);
begin
  TMaskEdit(FD2BridgeItemVCLObj.Item).ReadOnly := AValue;
end;

function TVCLObjTMaskEdit.TMaskEditGetPlaceholder: Variant;
begin
  if TMaskEdit(FD2BridgeItemVCLObj.Item).TextHint <> '' then
    Result := TMaskEdit(FD2BridgeItemVCLObj.Item).TextHint
  else if TMaskEdit(FD2BridgeItemVCLObj.Item).ShowHint then
    Result := TMaskEdit(FD2BridgeItemVCLObj.Item).Hint
  else
    Result := '';
end;

function TVCLObjTMaskEdit.VCLClass: TClass;
begin
  Result := TMaskEdit;
end;

procedure TVCLObjTMaskEdit.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
  if TMaskEdit(FD2BridgeItemVCLObj.Item).Font.Size <> D2Bridge.Item.VCLObj.Style.DefaultFontSize then
    VCLObjStyle.FontSize := TMaskEdit(FD2BridgeItemVCLObj.Item).Font.Size;

  if TMaskEdit(FD2BridgeItemVCLObj.Item).Font.Color <> clWindowText then
    VCLObjStyle.FontColor := TMaskEdit(FD2BridgeItemVCLObj.Item).Font.Color;

 if not IsColor(TMaskEdit(FD2BridgeItemVCLObj.Item).Color, [clWindow, clDefault]) then
  VCLObjStyle.Color := TMaskEdit(FD2BridgeItemVCLObj.Item).Color;

  if TMaskEdit(FD2BridgeItemVCLObj.Item).Alignment <> taLeftJustify then
    VCLObjStyle.Alignment := TMaskEdit(FD2BridgeItemVCLObj.Item).Alignment;

  VCLObjStyle.FontStyles := TMaskEdit(FD2BridgeItemVCLObj.Item).Font.Style;
end;

{$ELSE}
implementation
{$ENDIF}

end.