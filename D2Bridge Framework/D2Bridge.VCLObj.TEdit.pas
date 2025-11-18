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

unit D2Bridge.VCLObj.TEdit;


interface


uses
  Classes,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass,
  {$IFDEF FMX}
    FMX.Edit
  {$ELSE}
    StdCtrls, Controls, Graphics, Forms
  {$ENDIF}
  ;


type
 TVCLObjTEdit = class(TD2BridgeItemVCLObjCore)
  private
   procedure TEditOnClick(EventParams: TStrings);
   procedure TEditOnDblClick(EventParams: TStrings);
   procedure TEditOnEnter(EventParams: TStrings);
   procedure TEditOnExit(EventParams: TStrings);
   procedure TEditOnChange(EventParams: TStrings);
   procedure TEditOnKeyDown(EventParams: TStrings);
   procedure TEditOnKeyUp(EventParams: TStrings);
   {$IFNDEF FMX}
   procedure TEditOnKeyPress(EventParams: TStrings);
   {$ENDIF}

   function TEditGetEnabled: Variant;
   procedure TEditSetEnabled(AValue: Variant);
   function TEditGetVisible: Variant;
   procedure TEditSetVisible(AValue: Variant);
   function TEditGetReadOnly: Variant;
   procedure TEditSetReadOnly(AValue: Variant);
   function TEditGetPlaceholder: Variant;
   function TEditOnGetText: Variant;
   procedure TEditOnSetText(AValue: Variant);
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

{ VCLObjTEdit }


function TVCLObjTEdit.CSSClass: String;
begin
 result:= 'form-control';
end;

function TVCLObjTEdit.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit;
end;

procedure TVCLObjTEdit.TEditOnClick(EventParams: TStrings);
begin
  TEdit(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTEdit.TEditOnDblClick(EventParams: TStrings);
begin
  TEdit(FD2BridgeItemVCLObj.Item).OnDblClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTEdit.TEditOnEnter(EventParams: TStrings);
begin
  TEdit(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTEdit.TEditOnExit(EventParams: TStrings);
begin
  TEdit(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTEdit.TEditOnChange(EventParams: TStrings);
begin
  TEdit(FD2BridgeItemVCLObj.Item).OnChange(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTEdit.TEditOnKeyDown(EventParams: TStrings);
var
  KeyPress: Word;
  KeyChar: Char;
begin
  KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
  {$IFNDEF FMX}
  TEdit(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
  {$ELSE}
  KeyChar := Char(KeyPress);
  TEdit(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, KeyChar, []);
  {$ENDIF}
end;

procedure TVCLObjTEdit.TEditOnKeyUp(EventParams: TStrings);
var
  KeyPress: Word;
  KeyChar: Char;
begin
  KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
  {$IFNDEF FMX}
  TEdit(FD2BridgeItemVCLObj.Item).OnKeyUp(FD2BridgeItemVCLObj.Item, KeyPress, []);
  {$ELSE}
  KeyChar := Char(KeyPress);
  TEdit(FD2BridgeItemVCLObj.Item).OnKeyUp(FD2BridgeItemVCLObj.Item, KeyPress, KeyChar, []);
  {$ENDIF}
end;

{$IFNDEF FMX}
procedure TVCLObjTEdit.TEditOnKeyPress(EventParams: TStrings);
var
  KeyPress: Char;
begin
  KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
  TEdit(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
end;
{$ENDIF}

procedure TVCLObjTEdit.ProcessEventClass;
begin
  if Assigned(TEdit(FD2BridgeItemVCLObj.Item).OnClick) then
    FrameworkItemClass.OnClick := TEditOnClick;

  if Assigned(TEdit(FD2BridgeItemVCLObj.Item).OnDblClick) then
    FrameworkItemClass.OnDblClick := TEditOnDblClick;

  if Assigned(TEdit(FD2BridgeItemVCLObj.Item).OnEnter) then
    FrameworkItemClass.OnEnter := TEditOnEnter;

  if Assigned(TEdit(FD2BridgeItemVCLObj.Item).OnExit) then
    FrameworkItemClass.OnExit := TEditOnExit;

  if Assigned(TEdit(FD2BridgeItemVCLObj.Item).OnChange) then
    FrameworkItemClass.OnChange := TEditOnChange;

  if Assigned(TEdit(FD2BridgeItemVCLObj.Item).OnKeyDown) then
    FrameworkItemClass.OnKeyDown := TEditOnKeyDown;

  if Assigned(TEdit(FD2BridgeItemVCLObj.Item).OnKeyUp) then
    FrameworkItemClass.OnKeyUp := TEditOnKeyUp;

  {$IFNDEF FMX}
  if Assigned(TEdit(FD2BridgeItemVCLObj.Item).OnKeyPress) then
    FrameworkItemClass.OnKeyPress := TEditOnKeyPress;
  {$ENDIF}
end;

function TVCLObjTEdit.TEditGetEnabled: Variant;
begin
  Result := GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTEdit.TEditSetEnabled(AValue: Variant);
begin
  TEdit(FD2BridgeItemVCLObj.Item).Enabled := AValue;
end;

function TVCLObjTEdit.TEditGetVisible: Variant;
begin
  Result := GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTEdit.TEditSetVisible(AValue: Variant);
begin
  TEdit(FD2BridgeItemVCLObj.Item).Visible := AValue;
end;

function TVCLObjTEdit.TEditGetReadOnly: Variant;
begin
  Result := TEdit(FD2BridgeItemVCLObj.Item).ReadOnly;
end;

procedure TVCLObjTEdit.TEditSetReadOnly(AValue: Variant);
begin
  TEdit(FD2BridgeItemVCLObj.Item).ReadOnly := AValue;
end;

function TVCLObjTEdit.TEditGetPlaceholder: Variant;
begin
  {$IFNDEF FMX}
  if TEdit(FD2BridgeItemVCLObj.Item).TextHint <> '' then
    Result := TEdit(FD2BridgeItemVCLObj.Item).TextHint
  else
  {$ENDIF}
  if TEdit(FD2BridgeItemVCLObj.Item).ShowHint then
    Result := TEdit(FD2BridgeItemVCLObj.Item).Hint
  else
    Result := '';
end;

function TVCLObjTEdit.TEditOnGetText: Variant;
begin
  Result := TEdit(FD2BridgeItemVCLObj.Item).Text;
end;

procedure TVCLObjTEdit.TEditOnSetText(AValue: Variant);
begin
  TEdit(FD2BridgeItemVCLObj.Item).Text := AValue;
end;

procedure TVCLObjTEdit.ProcessPropertyClass(NewObj: TObject);
begin
 if TEdit(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}PasswordChar <> #0{$ELSE}Password{$ENDIF} then
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.DataType:= PrismFieldTypePassword
 else
 begin
  {$IFNDEF FMX}
   if TEdit(FD2BridgeItemVCLObj.Item).NumbersOnly then
    FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.DataType:= PrismFieldTypeNumber;
  {$ENDIF}
 end;

{$IF (NOT DEFINED(FMX)) OR (DEFINED(FMX) AND DEFINED(DELPHIX_SYDNEY_UP))}
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.CharCase:= TEdit(FD2BridgeItemVCLObj.Item).CharCase;
{$ENDIF}

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.MaxLength:= TEdit(FD2BridgeItemVCLObj.Item).MaxLength;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.GetEnabled := TEditGetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.SetEnabled := TEditSetEnabled;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.GetVisible := TEditGetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.SetVisible := TEditSetVisible;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.GetReadOnly := TEditGetReadOnly;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.SetReadOnly := TEditSetReadOnly;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.GetPlaceholder := TEditGetPlaceholder;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.OnGetText := TEditOnGetText;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.OnSetText := TEditOnSetText;
end;

function TVCLObjTEdit.VCLClass: TClass;
begin
 Result:= TEdit;
end;

procedure TVCLObjTEdit.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TEdit(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize:= TEdit(FD2BridgeItemVCLObj.Item).Font.Size;

 if TEdit(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}Font.Color{$ELSE}FontColor{$ENDIF} <> DefaultFontColor then
  VCLObjStyle.FontColor:= TEdit(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}Font.Color{$ELSE}FontColor{$ENDIF};

{$IFNDEF FMX}
 if not IsColor(TEdit(FD2BridgeItemVCLObj.Item).Color, [clWindow, clDefault]) then
  VCLObjStyle.Color:= TEdit(FD2BridgeItemVCLObj.Item).Color;
{$ENDIF}

 if TEdit(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}Alignment{$ELSE}TextSettings.HorzAlign{$ENDIF} <> DefaultAlignment then
  VCLObjStyle.Alignment:= TEdit(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}Alignment{$ELSE}TextSettings.HorzAlign{$ENDIF};

 VCLObjStyle.FontStyles:= TEdit(FD2BridgeItemVCLObj.Item).Font.Style;
end;

end.
