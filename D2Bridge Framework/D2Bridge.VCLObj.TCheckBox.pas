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

unit D2Bridge.VCLObj.TCheckBox;


interface


uses
  Classes,
{$IFDEF FMX}
  FMX.StdCtrls, FMX.Controls,
{$ELSE}
  StdCtrls, Controls, Forms, Graphics,
{$ENDIF}
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTCheckBox = class(TD2BridgeItemVCLObjCore)
  private
    procedure TCheckBoxOnClick(EventParams: TStrings);
    procedure TCheckBoxOnEnter(EventParams: TStrings);
    procedure TCheckBoxOnExit(EventParams: TStrings);
    procedure TCheckBoxOnKeyDown(EventParams: TStrings);
{$IFNDEF FMX}
    procedure TCheckBoxOnKeyPress(EventParams: TStrings);
{$ENDIF}

    function TCheckBoxOnGetText: Variant;
    function TCheckBoxOnGetChecked: Variant;
    procedure TCheckBoxOnSetChecked(AValue: Variant);
    function TCheckBoxOnGetEnabled: Variant;
    procedure TCheckBoxOnSetEnabled(AValue: Variant);
    function TCheckBoxOnGetVisible: Variant;
    procedure TCheckBoxOnSetVisible(AValue: Variant);
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
  Prism.Util, D2Bridge.Util, D2Bridge.Item.VCLObj.Style;

{ VCLObjTCheckBox }


function TVCLObjTCheckBox.CSSClass: String;
begin
 result:= 'form-check-input';
end;

function TVCLObjTCheckBox.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox;
end;

procedure TVCLObjTCheckBox.TCheckBoxOnClick(EventParams: TStrings);
begin
  //TCheckBox(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTCheckBox.TCheckBoxOnEnter(EventParams: TStrings);
begin
  TCheckBox(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTCheckBox.TCheckBoxOnExit(EventParams: TStrings);
begin
  TCheckBox(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTCheckBox.TCheckBoxOnKeyDown(EventParams: TStrings);
var
  KeyPress: word;
  KeyChar: Char;
begin
  KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
{$IFNDEF FMX}
  TCheckBox(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
{$ELSE}
  KeyChar := Char(KeyPress);
  TCheckBox(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, KeyChar, []);
{$ENDIF}
end;

{$IFNDEF FMX}
procedure TVCLObjTCheckBox.TCheckBoxOnKeyPress(EventParams: TStrings);
var
  KeyPress: Char;
begin
  KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
  TCheckBox(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
end;
{$ENDIF}

procedure TVCLObjTCheckBox.ProcessEventClass;
begin
 if Assigned(TCheckBox(FD2BridgeItemVCLObj.Item).OnClick) then
   FrameworkItemClass.OnClick := TCheckBoxOnClick;

 if Assigned(TCheckBox(FD2BridgeItemVCLObj.Item).OnEnter) then
   FrameworkItemClass.OnEnter := TCheckBoxOnEnter;

 if Assigned(TCheckBox(FD2BridgeItemVCLObj.Item).OnExit) then
   FrameworkItemClass.OnExit := TCheckBoxOnExit;

 if Assigned(TCheckBox(FD2BridgeItemVCLObj.Item).OnKeyDown) then
   FrameworkItemClass.OnKeyDown := TCheckBoxOnKeyDown;

{$IFNDEF FMX}
 if Assigned(TCheckBox(FD2BridgeItemVCLObj.Item).OnKeyPress) then
   FrameworkItemClass.OnKeyPress := TCheckBoxOnKeyPress;
{$ENDIF}
end;

function TVCLObjTCheckBox.TCheckBoxOnGetText: Variant;
begin
  Result := TCheckBox(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}Caption{$ELSE}Text{$ENDIF};
end;

function TVCLObjTCheckBox.TCheckBoxOnGetChecked: Variant;
begin
  Result := TCheckBox(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}Checked{$ELSE}IsChecked{$ENDIF};
end;

procedure TVCLObjTCheckBox.TCheckBoxOnSetChecked(AValue: Variant);
begin
  TCheckBox(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}Checked{$ELSE}IsChecked{$ENDIF} := AValue;
end;

function TVCLObjTCheckBox.TCheckBoxOnGetEnabled: Variant;
begin
  Result := GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTCheckBox.TCheckBoxOnSetEnabled(AValue: Variant);
begin
  TCheckBox(FD2BridgeItemVCLObj.Item).Enabled := AValue;
end;

function TVCLObjTCheckBox.TCheckBoxOnGetVisible: Variant;
begin
  Result := GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTCheckBox.TCheckBoxOnSetVisible(AValue: Variant);
begin
  TCheckBox(FD2BridgeItemVCLObj.Item).Visible := AValue;
end;

procedure TVCLObjTCheckBox.ProcessPropertyClass(NewObj: TObject);
begin
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox.OnGetText := TCheckBoxOnGetText;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox.OnGetChecked := TCheckBoxOnGetChecked;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox.OnSetChecked := TCheckBoxOnSetChecked;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox.GetEnabled := TCheckBoxOnGetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox.SetEnabled := TCheckBoxOnSetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox.GetVisible := TCheckBoxOnGetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox.SetVisible := TCheckBoxOnSetVisible;
end;

function TVCLObjTCheckBox.VCLClass: TClass;
begin
 Result:= TCheckBox;
end;

procedure TVCLObjTCheckBox.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 //Font in Switch is not appropriate
 //if TCheckBox(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
 // VCLObjStyle.FontSize := TCheckBox(FD2BridgeItemVCLObj.Item).Font.Size;

 if TCheckBox(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}Font.Color{$ELSE}FontColor{$ENDIF} <> DefaultFontColor then
  VCLObjStyle.FontColor := TCheckBox(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}Font.Color{$ELSE}FontColor{$ENDIF};

{$IFNDEF FMX}
 if not IsColor(TCheckBox(FD2BridgeItemVCLObj.Item).Color, [clBtnFace, clDefault]) then
  VCLObjStyle.Color := TCheckBox(FD2BridgeItemVCLObj.Item).Color;
{$ENDIF}

 if TCheckBox(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}Alignment{$ELSE}TextSettings.HorzAlign{$ENDIF} <> DefaultAlignment then
  VCLObjStyle.Alignment:= TCheckBox(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}Alignment{$ELSE}TextSettings.HorzAlign{$ENDIF};

 VCLObjStyle.FontStyles := TCheckBox(FD2BridgeItemVCLObj.Item).Font.Style;
end;

end.