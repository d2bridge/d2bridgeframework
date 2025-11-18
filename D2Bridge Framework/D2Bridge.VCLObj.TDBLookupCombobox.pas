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

unit D2Bridge.VCLObj.TDBLookupCombobox;

interface

{$IFNDEF FMX}
uses
  Classes, SysUtils, Forms, Graphics,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;

type
 TVCLObjTDBLookupCombobox = class(TD2BridgeItemVCLObjCore)
  private
    procedure TDBLookupComboboxOnClick(EventParams: TStrings);
    procedure TDBLookupComboboxOnEnter(EventParams: TStrings);
    procedure TDBLookupComboboxOnExit(EventParams: TStrings);
    procedure TDBLookupComboboxOnKeyDown(EventParams: TStrings);
    procedure TDBLookupComboboxOnKeyPress(EventParams: TStrings);
    procedure TDBLookupComboboxOnCloseUp(EventParams: TStrings);

    function TDBLookupComboboxGetEnabled: Variant;
    procedure TDBLookupComboboxSetEnabled(AValue: Variant);
    function TDBLookupComboboxGetVisible: Variant;
    procedure TDBLookupComboboxSetVisible(AValue: Variant);
    function TDBLookupComboboxGetReadOnly: Variant;
    procedure TDBLookupComboboxSetReadOnly(AValue: Variant);
    function TDBLookupComboboxOnGetText: Variant;
    procedure TDBLookupComboboxOnSetText(AValue: Variant);
    function TDBLookupComboboxGetPlaceholder: Variant;
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
  DBCtrls,
  Prism.Util, D2Bridge.Util, D2Bridge.Item.VCLObj.Style;

{ TVCLObjTDBLookupCombobox }

function TVCLObjTDBLookupCombobox.CSSClass: String;
begin
  Result := 'form-select';
end;

function TVCLObjTDBLookupCombobox.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
  Result := FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox;
end;

procedure TVCLObjTDBLookupCombobox.TDBLookupComboboxOnClick(EventParams: TStrings);
begin
  TDBLookupCombobox(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBLookupCombobox.TDBLookupComboboxOnEnter(EventParams: TStrings);
begin
  TDBLookupCombobox(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBLookupCombobox.TDBLookupComboboxOnExit(EventParams: TStrings);
begin
  TDBLookupCombobox(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBLookupCombobox.TDBLookupComboboxOnKeyDown(EventParams: TStrings);
var
  KeyPress: word;
begin
 KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
 TDBLookupCombobox(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
end;

procedure TVCLObjTDBLookupCombobox.TDBLookupComboboxOnKeyPress(EventParams: TStrings);
var
  KeyPress: Char;
begin
 KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
 TDBLookupCombobox(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
end;

procedure TVCLObjTDBLookupCombobox.TDBLookupComboboxOnCloseUp(EventParams: TStrings);
begin
  TDBLookupCombobox(FD2BridgeItemVCLObj.Item).OnCloseUp(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBLookupCombobox.ProcessEventClass;
begin
  if Assigned(TDBLookupCombobox(FD2BridgeItemVCLObj.Item).OnClick) then
    FrameworkItemClass.OnClick := TDBLookupComboboxOnClick;

  if Assigned(TDBLookupCombobox(FD2BridgeItemVCLObj.Item).OnEnter) then
    FrameworkItemClass.OnEnter := TDBLookupComboboxOnEnter;

  if Assigned(TDBLookupCombobox(FD2BridgeItemVCLObj.Item).OnExit) then
    FrameworkItemClass.OnExit := TDBLookupComboboxOnExit;

  if Assigned(TDBLookupCombobox(FD2BridgeItemVCLObj.Item).OnKeyDown) then
    FrameworkItemClass.OnKeyDown := TDBLookupComboboxOnKeyDown;

  if Assigned(TDBLookupCombobox(FD2BridgeItemVCLObj.Item).OnKeyPress) then
    FrameworkItemClass.OnKeyPress := TDBLookupComboboxOnKeyPress;

  if Assigned(TDBLookupCombobox(FD2BridgeItemVCLObj.Item).OnCloseUp) then
    FrameworkItemClass.OnSelect := TDBLookupComboboxOnCloseUp;
end;

function TVCLObjTDBLookupCombobox.TDBLookupComboboxGetEnabled: Variant;
begin
  Result := GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBLookupCombobox.TDBLookupComboboxSetEnabled(AValue: Variant);
begin
  TDBLookupCombobox(FD2BridgeItemVCLObj.Item).Enabled := AValue;
end;

function TVCLObjTDBLookupCombobox.TDBLookupComboboxGetVisible: Variant;
begin
  Result := GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBLookupCombobox.TDBLookupComboboxSetVisible(AValue: Variant);
begin
  TDBLookupCombobox(FD2BridgeItemVCLObj.Item).Visible := AValue;
end;

function TVCLObjTDBLookupCombobox.TDBLookupComboboxGetReadOnly: Variant;
begin
  Result := TDBLookupCombobox(FD2BridgeItemVCLObj.Item).ReadOnly;
end;

procedure TVCLObjTDBLookupCombobox.TDBLookupComboboxSetReadOnly(AValue: Variant);
begin
  TDBLookupCombobox(FD2BridgeItemVCLObj.Item).ReadOnly := AValue;
end;

function TVCLObjTDBLookupCombobox.TDBLookupComboboxGetPlaceholder: Variant;
begin
  if TDBLookupCombobox(FD2BridgeItemVCLObj.Item).ShowHint then
    Result := TDBLookupCombobox(FD2BridgeItemVCLObj.Item).Hint
  else
    Result := '';
end;

// Métodos OnGetText e OnSetText
function TVCLObjTDBLookupCombobox.TDBLookupComboboxOnGetText: Variant;
begin
  Result := TDBLookupCombobox(FD2BridgeItemVCLObj.Item).KeyValue;
end;

procedure TVCLObjTDBLookupCombobox.TDBLookupComboboxOnSetText(AValue: Variant);
begin
  if AValue <> '' then
    TDBLookupCombobox(FD2BridgeItemVCLObj.Item).KeyValue := AValue;
end;

procedure TVCLObjTDBLookupCombobox.ProcessPropertyClass(NewObj: TObject);
begin
  if Assigned(TDBLookupCombobox(FD2BridgeItemVCLObj.Item).DataSource) then
    FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.DataSource.DataSource := TDBLookupCombobox(FD2BridgeItemVCLObj.Item).DataSource;

  if TDBLookupCombobox(FD2BridgeItemVCLObj.Item).DataField <> '' then
    FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.DataSource.DataField := TDBLookupCombobox(FD2BridgeItemVCLObj.Item).DataField;

  if Assigned(TDBLookupCombobox(FD2BridgeItemVCLObj.Item).ListSource) then
    FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.ListSource.ListSource := TDBLookupCombobox(FD2BridgeItemVCLObj.Item).ListSource;

  if TDBLookupCombobox(FD2BridgeItemVCLObj.Item).ListField <> '' then
    if AnsiPos(';', TDBLookupCombobox(FD2BridgeItemVCLObj.Item).ListField) > 0 then
      FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.ListSource.ListField := Copy(TDBLookupCombobox(FD2BridgeItemVCLObj.Item).ListField, 0, AnsiPos(';', TDBLookupCombobox(FD2BridgeItemVCLObj.Item).ListField) - 1)
    else
      FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.ListSource.ListField := TDBLookupCombobox(FD2BridgeItemVCLObj.Item).ListField;

  if TDBLookupCombobox(FD2BridgeItemVCLObj.Item).KeyField <> '' then
    FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.ListSource.KeyField := TDBLookupCombobox(FD2BridgeItemVCLObj.Item).KeyField;

  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.OnGetText := TDBLookupComboboxOnGetText;
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.OnSetText := TDBLookupComboboxOnSetText;

  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.GetEnabled := TDBLookupComboboxGetEnabled;
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.SetEnabled := TDBLookupComboboxSetEnabled;
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.GetVisible := TDBLookupComboboxGetVisible;
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.SetVisible := TDBLookupComboboxSetVisible;
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.GetReadOnly := TDBLookupComboboxGetReadOnly;
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.SetReadOnly := TDBLookupComboboxSetReadOnly;
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.GetPlaceholder := TDBLookupComboboxGetPlaceholder;
end;

function TVCLObjTDBLookupCombobox.PropertyCopyList: TStringList;
begin
  Result := inherited;

  if Result.IndexOf('Text') >= 0 then
    Result.Delete(Result.IndexOf('Text'));
end;

function TVCLObjTDBLookupCombobox.VCLClass: TClass;
begin
  Result := TDBLookupComboBox;
end;

procedure TVCLObjTDBLookupCombobox.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
  if TDBLookupCombobox(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
    VCLObjStyle.FontSize := TDBLookupCombobox(FD2BridgeItemVCLObj.Item).Font.Size;

  if TDBLookupCombobox(FD2BridgeItemVCLObj.Item).Font.Color <> DefaultFontColor then
    VCLObjStyle.FontColor := TDBLookupCombobox(FD2BridgeItemVCLObj.Item).Font.Color;

 if not IsColor(TDBLookupCombobox(FD2BridgeItemVCLObj.Item).Color, [clWindow, clDefault]) then
  VCLObjStyle.Color := TDBLookupCombobox(FD2BridgeItemVCLObj.Item).Color;

  VCLObjStyle.FontStyles := TDBLookupCombobox(FD2BridgeItemVCLObj.Item).Font.Style;
end;

{$ELSE}
implementation
{$ENDIF}

end.

