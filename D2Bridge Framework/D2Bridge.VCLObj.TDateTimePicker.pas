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

unit D2Bridge.VCLObj.TDateTimePicker;


interface

{$IFNDEF FMX}
uses
  Classes, SysUtils, Variants,
  StdCtrls, ComCtrls,
{$IFDEF FPC}
  DateTimePicker,
{$ENDIF}
  Forms, Graphics,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTDateTimePicker = class(TD2BridgeItemVCLObjCore)
 private
   procedure TDateTimePickerOnClick(EventParams: TStrings);
   procedure TDateTimePickerOnEnter(EventParams: TStrings);
   procedure TDateTimePickerOnExit(EventParams: TStrings);
   procedure TDateTimePickerOnChange(EventParams: TStrings);
   procedure TDateTimePickerOnKeyDown(EventParams: TStrings);
   procedure TDateTimePickerOnKeyPress(EventParams: TStrings);
   function TDateTimePickerGetEnabled: Variant;
   procedure TDateTimePickerSetEnabled(AValue: Variant);
   function TDateTimePickerGetVisible: Variant;
   procedure TDateTimePickerSetVisible(AValue: Variant);
   function TDateTimePickerGetReadOnly: Variant;
   procedure TDateTimePickerSetReadOnly(AValue: Variant);
   function TDateTimePickerOnGetText: Variant;
   procedure TDateTimePickerOnSetText(AValue: Variant);
   function TDateTimePickerGetPlaceholder: Variant;
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
  Prism.Util, Prism.Types, D2Bridge.Util, D2Bridge.Item.VCLObj.Style;

{ VCLObjTDateTimePicker }


function TVCLObjTDateTimePicker.CSSClass: String;
begin
 result:= 'form-control';
end;

function TVCLObjTDateTimePicker.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit;
end;

procedure TVCLObjTDateTimePicker.TDateTimePickerOnClick(EventParams: TStrings);
begin
 TDateTimePicker(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDateTimePicker.TDateTimePickerOnEnter(EventParams: TStrings);
begin
 TDateTimePicker(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDateTimePicker.TDateTimePickerOnExit(EventParams: TStrings);
begin
  TDateTimePicker(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDateTimePicker.TDateTimePickerOnChange(EventParams: TStrings);
begin
 TDateTimePicker(FD2BridgeItemVCLObj.Item).OnChange(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDateTimePicker.TDateTimePickerOnKeyDown(EventParams: TStrings);
var
 KeyPress: word;
begin
 KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
 TDateTimePicker(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
end;

procedure TVCLObjTDateTimePicker.TDateTimePickerOnKeyPress(EventParams: TStrings);
var
 KeyPress: Char;
begin
 KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
 TDateTimePicker(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
end;

procedure TVCLObjTDateTimePicker.ProcessEventClass;
begin
 if Assigned(TDateTimePicker(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:= TDateTimePickerOnClick;

 if Assigned(TDateTimePicker(FD2BridgeItemVCLObj.Item).OnEnter) then
 FrameworkItemClass.OnEnter:= TDateTimePickerOnEnter;

 if Assigned(TDateTimePicker(FD2BridgeItemVCLObj.Item).OnExit) then
 FrameworkItemClass.OnExit:= TDateTimePickerOnExit;

 if Assigned(TDateTimePicker(FD2BridgeItemVCLObj.Item).OnChange) then
 FrameworkItemClass.OnChange:= TDateTimePickerOnChange;

 if Assigned(TDateTimePicker(FD2BridgeItemVCLObj.Item).OnKeyDown) then
 FrameworkItemClass.OnKeyDown:= TDateTimePickerOnKeyDown;

 if Assigned(TDateTimePicker(FD2BridgeItemVCLObj.Item).OnKeyPress) then
 FrameworkItemClass.OnKeyPress:= TDateTimePickerOnKeyPress;
end;

function TVCLObjTDateTimePicker.TDateTimePickerGetEnabled: Variant;
begin
 Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDateTimePicker.TDateTimePickerSetEnabled(AValue: Variant);
begin
 TDateTimePicker(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
end;

function TVCLObjTDateTimePicker.TDateTimePickerGetVisible: Variant;
begin
 Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDateTimePicker.TDateTimePickerSetVisible(AValue: Variant);
begin
 TDateTimePicker(FD2BridgeItemVCLObj.Item).Visible:= AValue;
end;

function TVCLObjTDateTimePicker.TDateTimePickerGetReadOnly: Variant;
begin
 Result:= not TDateTimePicker(FD2BridgeItemVCLObj.Item).Enabled;
end;

procedure TVCLObjTDateTimePicker.TDateTimePickerSetReadOnly(AValue: Variant);
begin
 TDateTimePicker(FD2BridgeItemVCLObj.Item).Enabled:= not AValue;
end;

function TVCLObjTDateTimePicker.TDateTimePickerOnGetText: Variant;
begin
  Result:= '';

{$IFDEF DELPHIX_ALEXANDRIA_UP} // Delphi 11 Alexandria or Upper
  if TDateTimePicker(FD2BridgeItemVCLObj.Item).Kind = dtkDateTime then
   Result:= DateTimeToStr(TDateTimePicker(FD2BridgeItemVCLObj.Item).DateTime)
  else
{$ENDIF}
   if TDateTimePicker(FD2BridgeItemVCLObj.Item).Kind = dtkDate then
    Result:= DateToStr(TDateTimePicker(FD2BridgeItemVCLObj.Item).Date)
   else
    if TDateTimePicker(FD2BridgeItemVCLObj.Item).Kind = dtkTime then
     Result:= TimeToStr(TDateTimePicker(FD2BridgeItemVCLObj.Item).Time);
end;

procedure TVCLObjTDateTimePicker.TDateTimePickerOnSetText(AValue: Variant);
begin
  if VarToStr(AValue) = '' then
   AValue:= DateTimeToStr(0);

{$IFDEF DELPHIX_ALEXANDRIA_UP} // Delphi 11 Alexandria or Upper
  if TDateTimePicker(FD2BridgeItemVCLObj.Item).Kind = dtkDateTime then
   TDateTimePicker(FD2BridgeItemVCLObj.Item).DateTime:= StrToDateTime(AValue)
  else
{$ENDIF}
   if TDateTimePicker(FD2BridgeItemVCLObj.Item).Kind = dtkDate then
    TDateTimePicker(FD2BridgeItemVCLObj.Item).Date:= StrToDate(AValue)
   else
    if TDateTimePicker(FD2BridgeItemVCLObj.Item).Kind = dtkTime then
     TDateTimePicker(FD2BridgeItemVCLObj.Item).Time:= StrToTime(AValue);
end;

function TVCLObjTDateTimePicker.TDateTimePickerGetPlaceholder: Variant;
begin
 if TDateTimePicker(FD2BridgeItemVCLObj.Item).ShowHint then
  Result:= TDateTimePicker(FD2BridgeItemVCLObj.Item).Hint
 else
  Result:= '';
end;

procedure TVCLObjTDateTimePicker.ProcessPropertyClass(NewObj: TObject);
begin
{$IFDEF DELPHIX_ALEXANDRIA_UP} // Delphi 11 Alexandria or Upper
 if TDateTimePicker(FD2BridgeItemVCLObj.Item).Kind = dtkDateTime then
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.DataType:= PrismFieldTypeDateTime
 else
{$ENDIF}
 if TDateTimePicker(FD2BridgeItemVCLObj.Item).Kind = dtkDate then
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.DataType:= PrismFieldTypeDate
 else
 if TDateTimePicker(FD2BridgeItemVCLObj.Item).Kind = dtkTime then
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.DataType:= PrismFieldTypeTime;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.GetEnabled:=     TDateTimePickerGetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.SetEnabled:=     TDateTimePickerSetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.GetVisible:=     TDateTimePickerGetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.SetVisible:=     TDateTimePickerSetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.GetReadOnly:=    TDateTimePickerGetReadOnly;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.SetReadOnly:=    TDateTimePickerSetReadOnly;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.OnGetText:=      TDateTimePickerOnGetText;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.OnSetText:=      TDateTimePickerOnSetText;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.GetPlaceholder:= TDateTimePickerGetPlaceholder;
end;

function TVCLObjTDateTimePicker.VCLClass: TClass;
begin
 Result:= TDateTimePicker;
end;

procedure TVCLObjTDateTimePicker.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TDateTimePicker(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize := TDateTimePicker(FD2BridgeItemVCLObj.Item).Font.Size;

 if TDateTimePicker(FD2BridgeItemVCLObj.Item).Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor := TDateTimePicker(FD2BridgeItemVCLObj.Item).Font.Color;

 if not IsColor(TDateTimePicker(FD2BridgeItemVCLObj.Item).Color, [clWindow, clDefault]) then
  VCLObjStyle.Color := TDateTimePicker(FD2BridgeItemVCLObj.Item).Color;

 VCLObjStyle.FontStyles := TDateTimePicker(FD2BridgeItemVCLObj.Item).Font.Style;
end;
{$ELSE}
implementation
{$ENDIF}

end.
