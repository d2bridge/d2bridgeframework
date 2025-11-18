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

unit D2Bridge.VCLObj.TDBCheckBox;

interface

{$IFNDEF FMX}
uses
  Classes,
  DBCtrls, Forms, Graphics,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;

type
 TVCLObjTDBCheckBox = class(TD2BridgeItemVCLObjCore)
  private
   procedure TDBCheckBoxOnClick(EventParams: TStrings);
   procedure TDBCheckBoxOnEnter(EventParams: TStrings);
   procedure TDBCheckBoxOnExit(EventParams: TStrings);
   procedure TDBCheckBoxOnKeyDown(EventParams: TStrings);
   procedure TDBCheckBoxOnKeyPress(EventParams: TStrings);

   function TDBCheckBoxGetEnabled: Variant;
   procedure TDBCheckBoxSetEnabled(AValue: Variant);
   function TDBCheckBoxGetVisible: Variant;
   procedure TDBCheckBoxSetVisible(AValue: Variant);
   function TDBCheckBoxGetReadOnly: Variant;
   procedure TDBCheckBoxSetReadOnly(AValue: Variant);
   function TDBCheckBoxGetText: Variant;

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
  StdCtrls, Controls,
  Prism.Util, D2Bridge.Util, D2Bridge.Item.VCLObj.Style;

{ TVCLObjTDBCheckBox }

function TVCLObjTDBCheckBox.CSSClass: String;
begin
 result := 'form-check-input';
end;

function TVCLObjTDBCheckBox.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result := FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCheckBox;
end;

procedure TVCLObjTDBCheckBox.TDBCheckBoxOnClick(EventParams: TStrings);
begin
  TDBCheckBox(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBCheckBox.TDBCheckBoxOnEnter(EventParams: TStrings);
begin
  TDBCheckBox(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBCheckBox.TDBCheckBoxOnExit(EventParams: TStrings);
begin
  TDBCheckBox(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBCheckBox.TDBCheckBoxOnKeyDown(EventParams: TStrings);
var
  KeyPress: word;
begin
  KeyPress := ConvertHTMLKeyToVK(EventParams.Values['key']);
  TDBCheckBox(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
end;

procedure TVCLObjTDBCheckBox.TDBCheckBoxOnKeyPress(EventParams: TStrings);
var
  KeyPress: Char;
begin
  KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.Values['key']));
  TDBCheckBox(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
end;

procedure TVCLObjTDBCheckBox.ProcessEventClass;
begin
 if Assigned(TDBCheckBox(FD2BridgeItemVCLObj.Item).OnClick) then
   FrameworkItemClass.OnClick := TDBCheckBoxOnClick;

 if Assigned(TDBCheckBox(FD2BridgeItemVCLObj.Item).OnEnter) then
   FrameworkItemClass.OnEnter := TDBCheckBoxOnEnter;

 if Assigned(TDBCheckBox(FD2BridgeItemVCLObj.Item).OnExit) then
   FrameworkItemClass.OnExit := TDBCheckBoxOnExit;

 if Assigned(TDBCheckBox(FD2BridgeItemVCLObj.Item).OnKeyDown) then
   FrameworkItemClass.OnKeyDown := TDBCheckBoxOnKeyDown;

 if Assigned(TDBCheckBox(FD2BridgeItemVCLObj.Item).OnKeyPress) then
   FrameworkItemClass.OnKeyPress := TDBCheckBoxOnKeyPress;
end;

procedure TVCLObjTDBCheckBox.ProcessPropertyClass(NewObj: TObject);
begin
 if Assigned(TDBCheckBox(FD2BridgeItemVCLObj.Item).DataSource) then
   FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCheckBox.Dataware.DataSource := TDBCheckBox(FD2BridgeItemVCLObj.Item).DataSource;

 if TDBCheckBox(FD2BridgeItemVCLObj.Item).DataField <> '' then
   FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCheckBox.Dataware.DataField := TDBCheckBox(FD2BridgeItemVCLObj.Item).DataField;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCheckBox.ValueChecked := TDBCheckBox(FD2BridgeItemVCLObj.Item).ValueChecked;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCheckBox.ValueUnchecked := TDBCheckBox(FD2BridgeItemVCLObj.Item).ValueUnchecked;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCheckBox.OnGetText := TDBCheckBoxGetText;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCheckBox.GetEnabled := TDBCheckBoxGetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCheckBox.SetEnabled := TDBCheckBoxSetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCheckBox.GetVisible := TDBCheckBoxGetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCheckBox.SetVisible := TDBCheckBoxSetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCheckBox.GetReadOnly := TDBCheckBoxGetReadOnly;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCheckBox.SetReadOnly := TDBCheckBoxSetReadOnly;
end;

function TVCLObjTDBCheckBox.TDBCheckBoxGetEnabled: Variant;
begin
  Result := GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBCheckBox.TDBCheckBoxSetEnabled(AValue: Variant);
begin
  TDBCheckBox(FD2BridgeItemVCLObj.Item).Enabled := AValue;
end;

function TVCLObjTDBCheckBox.TDBCheckBoxGetVisible: Variant;
begin
  Result := GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBCheckBox.TDBCheckBoxSetVisible(AValue: Variant);
begin
  TDBCheckBox(FD2BridgeItemVCLObj.Item).Visible := AValue;
end;

function TVCLObjTDBCheckBox.TDBCheckBoxGetReadOnly: Variant;
begin
  Result := TDBCheckBox(FD2BridgeItemVCLObj.Item).ReadOnly;
end;

procedure TVCLObjTDBCheckBox.TDBCheckBoxSetReadOnly(AValue: Variant);
begin
  TDBCheckBox(FD2BridgeItemVCLObj.Item).ReadOnly := AValue;
end;

function TVCLObjTDBCheckBox.TDBCheckBoxGetText: Variant;
begin
  Result := TDBCheckBox(FD2BridgeItemVCLObj.Item).Caption;
end;

function TVCLObjTDBCheckBox.VCLClass: TClass;
begin
 Result := TDBCheckBox;
end;

procedure TVCLObjTDBCheckBox.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TDBCheckBox(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize := TDBCheckBox(FD2BridgeItemVCLObj.Item).Font.Size;

 if TDBCheckBox(FD2BridgeItemVCLObj.Item).Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor := TDBCheckBox(FD2BridgeItemVCLObj.Item).Font.Color;

 if not IsColor(TDBCheckBox(FD2BridgeItemVCLObj.Item).Color, [clBtnFace, clDefault]) then
  VCLObjStyle.Color := TDBCheckBox(FD2BridgeItemVCLObj.Item).Color;

 if TDBCheckBox(FD2BridgeItemVCLObj.Item).Alignment <> DefaultAlignment then
  VCLObjStyle.Alignment := TDBCheckBox(FD2BridgeItemVCLObj.Item).Alignment;

 VCLObjStyle.FontStyles := TDBCheckBox(FD2BridgeItemVCLObj.Item).Font.Style;
end;

{$ELSE}
implementation
{$ENDIF}

end.

