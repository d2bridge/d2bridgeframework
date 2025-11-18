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

unit D2Bridge.VCLObj.TRadioButton;


interface


uses
  Classes,
{$IFDEF FMX}
  FMX.StdCtrls,
{$ELSE}
  StdCtrls, Controls, Forms, Graphics,
{$ENDIF}
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTRadioButton = class(TD2BridgeItemVCLObjCore)
  private
   procedure TRadioButtonOnClick(EventParams: TStrings);
   {$IFNDEF FPC}
   procedure TRadioButtonOnDblClick(EventParams: TStrings);
   {$ENDIF}
   procedure TRadioButtonOnEnter(EventParams: TStrings);
   procedure TRadioButtonOnExit(EventParams: TStrings);
   procedure TRadioButtonOnKeyDown(EventParams: TStrings);
   {$IFNDEF FMX}
   procedure TRadioButtonOnKeyPress(EventParams: TStrings);
   {$ENDIF}

   function TRadioButtonOnGetText: Variant;
   function TRadioButtonOnGetChecked: Variant;
   procedure TRadioButtonOnSetChecked(AValue: Variant);
   function TRadioButtonOnGetEnabled: Variant;
   procedure TRadioButtonOnSetEnabled(AValue: Variant);
   function TRadioButtonOnGetVisible: Variant;
   procedure TRadioButtonOnSetVisible(AValue: Variant);
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

{ VCLObjTRadioButton }


function TVCLObjTRadioButton.CSSClass: String;
begin
 result:= 'form-check-input';
end;

function TVCLObjTRadioButton.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox;
end;

procedure TVCLObjTRadioButton.TRadioButtonOnClick(EventParams: TStrings);
begin
  TRadioButton(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
end;

{$IFNDEF FPC}
procedure TVCLObjTRadioButton.TRadioButtonOnDblClick(EventParams: TStrings);
begin
  TRadioButton(FD2BridgeItemVCLObj.Item).OnDblClick(FD2BridgeItemVCLObj.Item);
end;
{$ENDIF}

procedure TVCLObjTRadioButton.TRadioButtonOnEnter(EventParams: TStrings);
begin
  TRadioButton(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTRadioButton.TRadioButtonOnExit(EventParams: TStrings);
begin
  TRadioButton(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTRadioButton.TRadioButtonOnKeyDown(EventParams: TStrings);
var
  KeyPress: word;
  KeyChar: Char;
begin
  KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
{$IFNDEF FMX}
  TRadioButton(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
{$ELSE}
  KeyChar := Char(KeyPress);
  TRadioButton(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, KeyChar, []);
{$ENDIF}
end;

{$IFNDEF FMX}
procedure TVCLObjTRadioButton.TRadioButtonOnKeyPress(EventParams: TStrings);
var
  KeyPress: Char;
begin
  KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
  TRadioButton(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
end;
{$ENDIF}

procedure TVCLObjTRadioButton.ProcessEventClass;
begin
 if Assigned(TRadioButton(FD2BridgeItemVCLObj.Item).OnClick) then
   FrameworkItemClass.OnClick := TRadioButtonOnClick;

 {$IFNDEF FPC}
 if Assigned(TRadioButton(FD2BridgeItemVCLObj.Item).OnDblClick) then
   FrameworkItemClass.OnDblClick := TRadioButtonOnDblClick;
 {$ENDIF}

 if Assigned(TRadioButton(FD2BridgeItemVCLObj.Item).OnEnter) then
   FrameworkItemClass.OnEnter := TRadioButtonOnEnter;

 if Assigned(TRadioButton(FD2BridgeItemVCLObj.Item).OnExit) then
   FrameworkItemClass.OnExit := TRadioButtonOnExit;

 if Assigned(TRadioButton(FD2BridgeItemVCLObj.Item).OnKeyDown) then
   FrameworkItemClass.OnKeyDown := TRadioButtonOnKeyDown;

 {$IFNDEF FMX}
 if Assigned(TRadioButton(FD2BridgeItemVCLObj.Item).OnKeyPress) then
   FrameworkItemClass.OnKeyPress := TRadioButtonOnKeyPress;
 {$ENDIF}
end;

function TVCLObjTRadioButton.TRadioButtonOnGetText: Variant;
begin
  Result := TRadioButton(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}Caption{$ELSE}Text{$ENDIF};
end;

function TVCLObjTRadioButton.TRadioButtonOnGetChecked: Variant;
begin
  Result := TRadioButton(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}Checked{$ELSE}IsChecked{$ENDIF};
end;

procedure TVCLObjTRadioButton.TRadioButtonOnSetChecked(AValue: Variant);
begin
  if AValue = false then
  begin
    if not TRadioButton(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}Checked{$ELSE}IsChecked{$ENDIF} then
      TRadioButton(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}Checked{$ELSE}IsChecked{$ENDIF} := true;
  end
  else
    TRadioButton(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}Checked{$ELSE}IsChecked{$ENDIF} := AValue;
end;

function TVCLObjTRadioButton.TRadioButtonOnGetEnabled: Variant;
begin
  Result := GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTRadioButton.TRadioButtonOnSetEnabled(AValue: Variant);
begin
  TRadioButton(FD2BridgeItemVCLObj.Item).Enabled := AValue;
end;

function TVCLObjTRadioButton.TRadioButtonOnGetVisible: Variant;
begin
  Result := GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTRadioButton.TRadioButtonOnSetVisible(AValue: Variant);
begin
  TRadioButton(FD2BridgeItemVCLObj.Item).Visible := AValue;
end;

procedure TVCLObjTRadioButton.ProcessPropertyClass(NewObj: TObject);
begin
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox.OnGetText := TRadioButtonOnGetText;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox.OnGetChecked := TRadioButtonOnGetChecked;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox.OnSetChecked := TRadioButtonOnSetChecked;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox.GetEnabled := TRadioButtonOnGetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox.SetEnabled := TRadioButtonOnSetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox.GetVisible := TRadioButtonOnGetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox.SetVisible := TRadioButtonOnSetVisible;
end;

function TVCLObjTRadioButton.VCLClass: TClass;
begin
 Result:= TRadioButton;
end;

procedure TVCLObjTRadioButton.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 //Font in Switch is not appropriate
 //if TRadioButton(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
 // VCLObjStyle.FontSize := TRadioButton(FD2BridgeItemVCLObj.Item).Font.Size;

 if TRadioButton(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}Font.Color{$ELSE}FontColor{$ENDIF} <> DefaultFontColor then
  VCLObjStyle.FontColor := TRadioButton(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}Font.Color{$ELSE}FontColor{$ENDIF};

{$IFNDEF FMX}
 if not IsColor(TRadioButton(FD2BridgeItemVCLObj.Item).Color, [clBtnFace, clDefault]) then
  VCLObjStyle.Color := TRadioButton(FD2BridgeItemVCLObj.Item).Color;
{$ENDIF}

 if TRadioButton(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}Alignment{$ELSE}TextSettings.HorzAlign{$ENDIF} <> DefaultAlignment then
  VCLObjStyle.Alignment:= TRadioButton(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}Alignment{$ELSE}TextSettings.HorzAlign{$ENDIF};

 VCLObjStyle.FontStyles := TRadioButton(FD2BridgeItemVCLObj.Item).Font.Style;

end;

end.
