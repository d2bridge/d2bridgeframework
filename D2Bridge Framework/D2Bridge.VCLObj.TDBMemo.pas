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

unit D2Bridge.VCLObj.TDBMemo;

interface

{$IFNDEF FMX}
uses
  Classes,
  DBCtrls, Forms, Graphics,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;

type
  TVCLObjTDBMemo = class(TD2BridgeItemVCLObjCore)
  private
    procedure TDBMemoOnClick(EventParams: TStrings);
    procedure TDBMemoOnDblClick(EventParams: TStrings);
    procedure TDBMemoOnEnter(EventParams: TStrings);
    procedure TDBMemoOnExit(EventParams: TStrings);
    procedure TDBMemoOnChange(EventParams: TStrings);
    procedure TDBMemoOnKeyUp(EventParams: TStrings);
    procedure TDBMemoOnKeyDown(EventParams: TStrings);
    procedure TDBMemoOnKeyPress(EventParams: TStrings);
    function TDBMemoGetEnabled: Variant;
    procedure TDBMemoSetEnabled(AValue: Variant);
    function TDBMemoGetVisible: Variant;
    procedure TDBMemoSetVisible(AValue: Variant);
    function TDBMemoGetReadOnly: Variant;
    procedure TDBMemoSetReadOnly(AValue: Variant);
    function TDBMemoGetPlaceholder: Variant;
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

{ TVCLObjTDBMemo }

function TVCLObjTDBMemo.CSSClass: String;
begin
  Result := 'form-control';
end;

function TVCLObjTDBMemo.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
  Result := FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBMemo;
end;

procedure TVCLObjTDBMemo.TDBMemoOnClick(EventParams: TStrings);
begin
  TDBMemo(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBMemo.TDBMemoOnDblClick(EventParams: TStrings);
begin
  TDBMemo(FD2BridgeItemVCLObj.Item).OnDblClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBMemo.TDBMemoOnEnter(EventParams: TStrings);
begin
  TDBMemo(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBMemo.TDBMemoOnExit(EventParams: TStrings);
begin
  TDBMemo(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBMemo.TDBMemoOnChange(EventParams: TStrings);
begin
  TDBMemo(FD2BridgeItemVCLObj.Item).OnChange(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBMemo.TDBMemoOnKeyUp(EventParams: TStrings);
var
  KeyPress: word;
begin
  KeyPress := ConvertHTMLKeyToVK(EventParams.Values['key']);
  TDBMemo(FD2BridgeItemVCLObj.Item).OnKeyUp(FD2BridgeItemVCLObj.Item, KeyPress, []);
end;

procedure TVCLObjTDBMemo.TDBMemoOnKeyDown(EventParams: TStrings);
var
  KeyPress: word;
begin
  KeyPress := ConvertHTMLKeyToVK(EventParams.Values['key']);
  TDBMemo(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
end;

procedure TVCLObjTDBMemo.TDBMemoOnKeyPress(EventParams: TStrings);
var
  KeyPress: Char;
begin
  KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.Values['key']));
  TDBMemo(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
end;

procedure TVCLObjTDBMemo.ProcessEventClass;
begin
  if Assigned(TDBMemo(FD2BridgeItemVCLObj.Item).OnClick) then
    FrameworkItemClass.OnClick := TDBMemoOnClick;

  if Assigned(TDBMemo(FD2BridgeItemVCLObj.Item).OnDblClick) then
    FrameworkItemClass.OnDblClick := TDBMemoOnDblClick;

  if Assigned(TDBMemo(FD2BridgeItemVCLObj.Item).OnEnter) then
    FrameworkItemClass.OnEnter := TDBMemoOnEnter;

  if Assigned(TDBMemo(FD2BridgeItemVCLObj.Item).OnExit) then
    FrameworkItemClass.OnExit := TDBMemoOnExit;

  if Assigned(TDBMemo(FD2BridgeItemVCLObj.Item).OnChange) then
    FrameworkItemClass.OnChange := TDBMemoOnChange;

  if Assigned(TDBMemo(FD2BridgeItemVCLObj.Item).OnKeyUp) then
    FrameworkItemClass.OnKeyUp := TDBMemoOnKeyUp;

  if Assigned(TDBMemo(FD2BridgeItemVCLObj.Item).OnKeyDown) then
    FrameworkItemClass.OnKeyDown := TDBMemoOnKeyDown;

  if Assigned(TDBMemo(FD2BridgeItemVCLObj.Item).OnKeyPress) then
    FrameworkItemClass.OnKeyPress := TDBMemoOnKeyPress;
end;

function TVCLObjTDBMemo.TDBMemoGetEnabled: Variant;
begin
  Result := GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBMemo.TDBMemoSetEnabled(AValue: Variant);
begin
  TDBMemo(FD2BridgeItemVCLObj.Item).Enabled := AValue;
end;

function TVCLObjTDBMemo.TDBMemoGetVisible: Variant;
begin
  Result := GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBMemo.TDBMemoSetVisible(AValue: Variant);
begin
  TDBMemo(FD2BridgeItemVCLObj.Item).Visible := AValue;
end;

function TVCLObjTDBMemo.TDBMemoGetReadOnly: Variant;
begin
  Result := TDBMemo(FD2BridgeItemVCLObj.Item).ReadOnly;
end;

procedure TVCLObjTDBMemo.TDBMemoSetReadOnly(AValue: Variant);
begin
  TDBMemo(FD2BridgeItemVCLObj.Item).ReadOnly := AValue;
end;

function TVCLObjTDBMemo.TDBMemoGetPlaceholder: Variant;
begin
  if TDBMemo(FD2BridgeItemVCLObj.Item).TextHint <> '' then
    Result := TDBMemo(FD2BridgeItemVCLObj.Item).TextHint
  else if TDBMemo(FD2BridgeItemVCLObj.Item).ShowHint then
    Result := TDBMemo(FD2BridgeItemVCLObj.Item).Hint
  else
    Result := '';
end;

procedure TVCLObjTDBMemo.ProcessPropertyClass(NewObj: TObject);
begin
  if Assigned(TDBMemo(FD2BridgeItemVCLObj.Item).DataSource) then
    FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBMemo.Dataware.DataSource := TDBMemo(FD2BridgeItemVCLObj.Item).DataSource;

  if TDBMemo(FD2BridgeItemVCLObj.Item).DataField <> '' then
    FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBMemo.Dataware.DataField := TDBMemo(FD2BridgeItemVCLObj.Item).DataField;

  //Need to fix error in Nested
  TDBMemo(FD2BridgeItemVCLObj.Item).DataSource := nil;
  TDBMemo(FD2BridgeItemVCLObj.Item).DataField := '';

  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBMemo.GetEnabled := TDBMemoGetEnabled;
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBMemo.SetEnabled := TDBMemoSetEnabled;
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBMemo.GetVisible := TDBMemoGetVisible;
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBMemo.SetVisible := TDBMemoSetVisible;
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBMemo.GetReadOnly := TDBMemoGetReadOnly;
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBMemo.SetReadOnly := TDBMemoSetReadOnly;
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBMemo.GetPlaceholder := TDBMemoGetPlaceholder;
end;

function TVCLObjTDBMemo.VCLClass: TClass;
begin
  Result := TDBMemo;
end;

procedure TVCLObjTDBMemo.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
  if TDBMemo(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
    VCLObjStyle.FontSize := TDBMemo(FD2BridgeItemVCLObj.Item).Font.Size;

  if TDBMemo(FD2BridgeItemVCLObj.Item).Font.Color <> DefaultFontColor then
    VCLObjStyle.FontColor := TDBMemo(FD2BridgeItemVCLObj.Item).Font.Color;

 if not IsColor(TDBMemo(FD2BridgeItemVCLObj.Item).Color, [clWindow, clDefault]) then
  VCLObjStyle.Color := TDBMemo(FD2BridgeItemVCLObj.Item).Color;

  if TDBMemo(FD2BridgeItemVCLObj.Item).Alignment <> DefaultAlignment then
    VCLObjStyle.Alignment := TDBMemo(FD2BridgeItemVCLObj.Item).Alignment;

  VCLObjStyle.FontStyles := TDBMemo(FD2BridgeItemVCLObj.Item).Font.Style;
end;

{$ELSE}
implementation
{$ENDIF}

end.

