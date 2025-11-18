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

unit D2Bridge.VCLObj.TEditButton;

interface

{$IFDEF FPC}
uses
  Classes,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass,
  ExtCtrls, Controls, Graphics, Forms, EditBtn;

type
 TVCLObjTEditButton = class(TD2BridgeItemVCLObjCore)
  private
   procedure TEditButtonOnClick(EventParams: TStrings);
   procedure TEditButtonOnDblClick(EventParams: TStrings);
   procedure TEditButtonOnRightButtonClick(EventParams: TStrings);
   procedure TEditButtonOnEnter(EventParams: TStrings);
   procedure TEditButtonOnExit(EventParams: TStrings);
   procedure TEditButtonOnChange(EventParams: TStrings);
   procedure TEditButtonOnKeyDown(EventParams: TStrings);
   procedure TEditButtonOnKeyUp(EventParams: TStrings);
   procedure TEditButtonOnKeyPress(EventParams: TStrings);
   function TEditButtonGetEnabled: Variant;
   procedure TEditButtonSetEnabled(AValue: Variant);
   function TEditButtonGetLeftButtonEnabled: Variant;
   function TEditButtonGetLeftButtonVisible: Variant;
   function TEditButtonGetRightButtonEnabled: Variant;
   function TEditButtonGetRightButtonVisible: Variant;
   function TEditButtonGetVisible: Variant;
   procedure TEditButtonSetVisible(AValue: Variant);
   function TEditButtonGetReadOnly: Variant;
   procedure TEditButtonSetReadOnly(AValue: Variant);
   function TEditButtonGetPlaceholder: Variant;
   function TEditButtonOnGetText: Variant;
   procedure TEditButtonOnSetText(AValue: Variant);
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
 Prism.Util, Prism.Types, D2Bridge.Util, D2Bridge.Item.VCLObj.Style, D2Bridge.Prism.ButtonedEdit;

{ VCLObjTEditButton }


function TVCLObjTEditButton.CSSClass: String;
begin
 result:= 'form-control';
end;

function TVCLObjTEditButton.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit;
end;

procedure TVCLObjTEditButton.TEditButtonOnClick(EventParams: TStrings);
begin
 TEditButton(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTEditButton.TEditButtonOnDblClick(EventParams: TStrings);
begin
 TEditButton(FD2BridgeItemVCLObj.Item).OnDblClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTEditButton.TEditButtonOnRightButtonClick(EventParams: TStrings);
begin
 TEditButton(FD2BridgeItemVCLObj.Item).OnButtonClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTEditButton.TEditButtonOnEnter(EventParams: TStrings);
begin
 TEditButton(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTEditButton.TEditButtonOnExit(EventParams: TStrings);
begin
 TEditButton(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTEditButton.TEditButtonOnChange(EventParams: TStrings);
begin
 TEditButton(FD2BridgeItemVCLObj.Item).OnChange(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTEditButton.TEditButtonOnKeyDown(EventParams: TStrings);
var
  KeyPress: word;
  KeyChar:  Char;
begin
 KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
 TEditButton(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
end;

procedure TVCLObjTEditButton.TEditButtonOnKeyUp(EventParams: TStrings);
var
  KeyPress: word;
  KeyChar:  Char;
begin
 KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
 TEditButton(FD2BridgeItemVCLObj.Item).OnKeyUp(FD2BridgeItemVCLObj.Item, KeyPress, []);
end;

procedure TVCLObjTEditButton.TEditButtonOnKeyPress(EventParams: TStrings);
var
  KeyPress: Char;
begin
 KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
 TEditButton(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
end;

procedure TVCLObjTEditButton.ProcessEventClass;
begin
 if Assigned(TEditButton(FD2BridgeItemVCLObj.Item).OnClick) then
  FrameworkItemClass.OnClick:= TEditButtonOnClick;

 if Assigned(TEditButton(FD2BridgeItemVCLObj.Item).OnDblClick) then
  FrameworkItemClass.OnDblClick:= TEditButtonOnDblClick;

 if Assigned(TEditButton(FD2BridgeItemVCLObj.Item).OnButtonClick) then
  (FrameworkItemClass as PrismButtonedEdit).OnRightButtonClick:= TEditButtonOnRightButtonClick;

 if Assigned(TEditButton(FD2BridgeItemVCLObj.Item).OnEnter) then
 FrameworkItemClass.OnEnter:= TEditButtonOnEnter;

 if Assigned(TEditButton(FD2BridgeItemVCLObj.Item).OnExit) then
 FrameworkItemClass.OnExit:= TEditButtonOnExit;

 if Assigned(TEditButton(FD2BridgeItemVCLObj.Item).OnChange) then
 FrameworkItemClass.OnChange:= TEditButtonOnChange;

 if Assigned(TEditButton(FD2BridgeItemVCLObj.Item).OnKeyDown) then
 FrameworkItemClass.OnKeyDown:= TEditButtonOnKeyDown;

 if Assigned(TEditButton(FD2BridgeItemVCLObj.Item).OnKeyUp) then
 FrameworkItemClass.OnKeyUp:= TEditButtonOnKeyUp;

 if Assigned(TEditButton(FD2BridgeItemVCLObj.Item).OnKeyPress) then
 FrameworkItemClass.OnKeyPress:= TEditButtonOnKeyPress;
end;

function TVCLObjTEditButton.TEditButtonGetEnabled: Variant;
begin
 Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTEditButton.TEditButtonSetEnabled(AValue: Variant);
begin
 TEditButton(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
end;

function TVCLObjTEditButton.TEditButtonGetLeftButtonEnabled: Variant;
begin
 Result:= False;
end;

function TVCLObjTEditButton.TEditButtonGetLeftButtonVisible: Variant;
begin
 Result:= False;
end;

function TVCLObjTEditButton.TEditButtonGetRightButtonEnabled: Variant;
begin
 Result:= TEditButton(FD2BridgeItemVCLObj.Item).Enabled;
end;

function TVCLObjTEditButton.TEditButtonGetRightButtonVisible: Variant;
begin
 Result:= TEditButton(FD2BridgeItemVCLObj.Item).Visible;
end;

function TVCLObjTEditButton.TEditButtonGetVisible: Variant;
begin
 Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTEditButton.TEditButtonSetVisible(AValue: Variant);
begin
 TEditButton(FD2BridgeItemVCLObj.Item).Visible:= AValue;
end;

function TVCLObjTEditButton.TEditButtonGetReadOnly: Variant;
begin
 Result:= TEditButton(FD2BridgeItemVCLObj.Item).ReadOnly;
end;

procedure TVCLObjTEditButton.TEditButtonSetReadOnly(AValue: Variant);
begin
 TEditButton(FD2BridgeItemVCLObj.Item).ReadOnly:= AValue;
end;

function TVCLObjTEditButton.TEditButtonGetPlaceholder: Variant;
begin
 if TEditButton(FD2BridgeItemVCLObj.Item).TextHint <> '' then
  Result:= TEditButton(FD2BridgeItemVCLObj.Item).TextHint
 else

 if TEditButton(FD2BridgeItemVCLObj.Item).ShowHint then
  Result:= TEditButton(FD2BridgeItemVCLObj.Item).Hint
 else
  Result:= '';
end;

function TVCLObjTEditButton.TEditButtonOnGetText: Variant;
begin
 Result:= TEditButton(FD2BridgeItemVCLObj.Item).Text;
end;

procedure TVCLObjTEditButton.TEditButtonOnSetText(AValue: Variant);
begin
 TEditButton(FD2BridgeItemVCLObj.Item).Text:= AValue;
end;

procedure TVCLObjTEditButton.ProcessPropertyClass(NewObj: TObject);
begin
 if TEditButton(FD2BridgeItemVCLObj.Item).PasswordChar <> #0 then
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.DataType:= PrismFieldTypePassword;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.CharCase:= TEditButton(FD2BridgeItemVCLObj.Item).CharCase;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.GetEnabled:=     TEditButtonGetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.SetEnabled:=     TEditButtonSetEnabled;
 (FrameworkItemClass as PrismButtonedEdit).GetLeftButtonEnabled:=                TEditButtonGetLeftButtonEnabled;
 (FrameworkItemClass as PrismButtonedEdit).GetLeftButtonVisible:=                TEditButtonGetLeftButtonVisible;
 (FrameworkItemClass as PrismButtonedEdit).GetRightButtonEnabled:=               TEditButtonGetRightButtonEnabled;
 (FrameworkItemClass as PrismButtonedEdit).GetRightButtonVisible:=               TEditButtonGetRightButtonVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.GetVisible:=     TEditButtonGetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.SetVisible:=     TEditButtonSetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.GetReadOnly:=    TEditButtonGetReadOnly;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.SetReadOnly:=    TEditButtonSetReadOnly;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.GetPlaceholder:= TEditButtonGetPlaceholder;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.OnGetText:=      TEditButtonOnGetText;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.OnSetText:=      TEditButtonOnSetText;
end;

function TVCLObjTEditButton.VCLClass: TClass;
begin
 Result:= TEditButton;
end;

procedure TVCLObjTEditButton.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TEditButton(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize:= TEditButton(FD2BridgeItemVCLObj.Item).Font.Size;

 if TEditButton(FD2BridgeItemVCLObj.Item).Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor:= TEditButton(FD2BridgeItemVCLObj.Item).Font.Color;

 if TEditButton(FD2BridgeItemVCLObj.Item).Color <> DefaultColor then
  VCLObjStyle.Color:= TEditButton(FD2BridgeItemVCLObj.Item).Color;

 if TEditButton(FD2BridgeItemVCLObj.Item).Alignment <> DefaultAlignment then
  VCLObjStyle.Alignment:= TEditButton(FD2BridgeItemVCLObj.Item).Alignment;

 VCLObjStyle.FontStyles:= TEditButton(FD2BridgeItemVCLObj.Item).Font.Style;
end;

{$ELSE}
implementation
{$ENDIF}

end.