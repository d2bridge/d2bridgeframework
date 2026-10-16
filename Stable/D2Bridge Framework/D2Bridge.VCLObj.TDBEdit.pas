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

unit D2Bridge.VCLObj.TDBEdit;


interface

{$IF NOT DEFINED(FMX) AND DEFINED(D2BRIDGE)}
uses
  Classes,
  DBCtrls, Graphics,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;

type
 TVCLObjTDBEdit = class(TD2BridgeItemVCLObjCore)
  private
   procedure TDBEditOnClick(EventParams: TStrings);
   procedure TDBEditOnDblClick(EventParams: TStrings);
   procedure TDBEditOnEnter(EventParams: TStrings);
   procedure TDBEditOnExit(EventParams: TStrings);
   procedure TDBEditOnChange(EventParams: TStrings);
   procedure TDBEditOnKeyDown(EventParams: TStrings);
   procedure TDBEditOnKeyUp(EventParams: TStrings);
   procedure TDBEditOnKeyPress(EventParams: TStrings);

   function TDBEditGetEnabled: Variant;
   procedure TDBEditSetEnabled(AValue: Variant);
   function TDBEditGetVisible: Variant;
   procedure TDBEditSetVisible(AValue: Variant);
   function TDBEditGetReadOnly: Variant;
   procedure TDBEditSetReadOnly(AValue: Variant);
   function TDBEditGetPlaceholder: Variant;
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

{ TVCLObjTDBEdit }

function TVCLObjTDBEdit.CSSClass: String;
begin
 result:= 'form-control';
end;

function TVCLObjTDBEdit.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit;
end;

procedure TVCLObjTDBEdit.TDBEditOnClick(EventParams: TStrings);
begin
  TDBEdit(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBEdit.TDBEditOnDblClick(EventParams: TStrings);
begin
  TDBEdit(FD2BridgeItemVCLObj.Item).OnDblClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBEdit.TDBEditOnEnter(EventParams: TStrings);
begin
  TDBEdit(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBEdit.TDBEditOnExit(EventParams: TStrings);
begin
  TDBEdit(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBEdit.TDBEditOnChange(EventParams: TStrings);
begin
  TDBEdit(FD2BridgeItemVCLObj.Item).OnChange(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBEdit.TDBEditOnKeyDown(EventParams: TStrings);
var
  KeyPress: word;
begin
  KeyPress := ConvertHTMLKeyToVK(EventParams.Values['key']);
  TDBEdit(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
end;

procedure TVCLObjTDBEdit.TDBEditOnKeyUp(EventParams: TStrings);
var
  KeyPress: word;
begin
  KeyPress := ConvertHTMLKeyToVK(EventParams.Values['key']);
  TDBEdit(FD2BridgeItemVCLObj.Item).OnKeyUp(FD2BridgeItemVCLObj.Item, KeyPress, []);
end;

procedure TVCLObjTDBEdit.TDBEditOnKeyPress(EventParams: TStrings);
var
  KeyPress: Char;
begin
  KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.Values['key']));
  TDBEdit(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
end;

procedure TVCLObjTDBEdit.ProcessEventClass;
begin
  if Assigned(TDBEdit(FD2BridgeItemVCLObj.Item).OnClick) then
    FrameworkItemClass.OnClick := TDBEditOnClick;

  if Assigned(TDBEdit(FD2BridgeItemVCLObj.Item).OnDblClick) then
    FrameworkItemClass.OnDblClick := TDBEditOnDblClick;

  if Assigned(TDBEdit(FD2BridgeItemVCLObj.Item).OnEnter) then
    FrameworkItemClass.OnEnter := TDBEditOnEnter;

  if Assigned(TDBEdit(FD2BridgeItemVCLObj.Item).OnExit) then
    FrameworkItemClass.OnExit := TDBEditOnExit;

  if Assigned(TDBEdit(FD2BridgeItemVCLObj.Item).OnChange) then
    FrameworkItemClass.OnChange := TDBEditOnChange;

  if Assigned(TDBEdit(FD2BridgeItemVCLObj.Item).OnKeyDown) then
    FrameworkItemClass.OnKeyDown := TDBEditOnKeyDown;

  if Assigned(TDBEdit(FD2BridgeItemVCLObj.Item).OnKeyUp) then
    FrameworkItemClass.OnKeyUp := TDBEditOnKeyUp;

  if Assigned(TDBEdit(FD2BridgeItemVCLObj.Item).OnKeyPress) then
    FrameworkItemClass.OnKeyPress:= TDBEditOnKeyPress;
end;

function TVCLObjTDBEdit.TDBEditGetEnabled: Variant;
begin
  Result := GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBEdit.TDBEditSetEnabled(AValue: Variant);
begin
  TDBEdit(FD2BridgeItemVCLObj.Item).Enabled := AValue;
end;

function TVCLObjTDBEdit.TDBEditGetVisible: Variant;
begin
  Result := GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBEdit.TDBEditSetVisible(AValue: Variant);
begin
  TDBEdit(FD2BridgeItemVCLObj.Item).Visible := AValue;
end;

function TVCLObjTDBEdit.TDBEditGetReadOnly: Variant;
begin
  Result := TDBEdit(FD2BridgeItemVCLObj.Item).ReadOnly;
end;

procedure TVCLObjTDBEdit.TDBEditSetReadOnly(AValue: Variant);
begin
  TDBEdit(FD2BridgeItemVCLObj.Item).ReadOnly := AValue;
end;

function TVCLObjTDBEdit.TDBEditGetPlaceholder: Variant;
begin
  if TDBEdit(FD2BridgeItemVCLObj.Item).TextHint <> '' then
    Result := TDBEdit(FD2BridgeItemVCLObj.Item).TextHint
  else if TDBEdit(FD2BridgeItemVCLObj.Item).ShowHint then
    Result := TDBEdit(FD2BridgeItemVCLObj.Item).Hint
  else
    Result := '';
end;

procedure TVCLObjTDBEdit.ProcessPropertyClass(NewObj: TObject);
begin
 if Assigned(TDBEdit(FD2BridgeItemVCLObj.Item).DataSource) then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.Dataware.DataSource:= TDBEdit(FD2BridgeItemVCLObj.Item).DataSource;

 if TDBEdit(FD2BridgeItemVCLObj.Item).DataField <> '' then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.Dataware.DataField:= TDBEdit(FD2BridgeItemVCLObj.Item).DataField;

 if TDBEdit(FD2BridgeItemVCLObj.Item).PasswordChar <> #0 then
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.DataType:= PrismFieldTypePassword;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.CharCase:= TDBEdit(FD2BridgeItemVCLObj.Item).CharCase;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.GetEnabled := TDBEditGetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.SetEnabled := TDBEditSetEnabled;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.GetVisible := TDBEditGetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.SetVisible := TDBEditSetVisible;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.GetReadOnly := TDBEditGetReadOnly;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.SetReadOnly := TDBEditSetReadOnly;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.GetPlaceholder := TDBEditGetPlaceholder;
end;

function TVCLObjTDBEdit.VCLClass: TClass;
begin
 Result:= TDBEdit;
end;

procedure TVCLObjTDBEdit.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TDBEdit(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize := TDBEdit(FD2BridgeItemVCLObj.Item).Font.Size;

 if TDBEdit(FD2BridgeItemVCLObj.Item).Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor := TDBEdit(FD2BridgeItemVCLObj.Item).Font.Color;

 if not IsColor(TDBEdit(FD2BridgeItemVCLObj.Item).Color, [clWindow, clDefault]) then
  VCLObjStyle.Color := TDBEdit(FD2BridgeItemVCLObj.Item).Color;

 if TDBEdit(FD2BridgeItemVCLObj.Item).Alignment <> DefaultAlignment then
  VCLObjStyle.Alignment:= TDBEdit(FD2BridgeItemVCLObj.Item).Alignment;

 VCLObjStyle.FontStyles := TDBEdit(FD2BridgeItemVCLObj.Item).Font.Style;
end;

{$ELSE}
implementation
{$ENDIF}

end.