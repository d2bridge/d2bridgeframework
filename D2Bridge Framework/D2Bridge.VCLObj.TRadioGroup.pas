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

unit D2Bridge.VCLObj.TRadioGroup;

interface

{$IF NOT DEFINED(FMX) AND DEFINED(D2BRIDGE)}
uses
  Classes, RTTI,
{$IFDEF FMX}
  FMX.StdCtrls, FMX.Controls, FMX.ExtCtrls,
{$ELSE}
  StdCtrls, Controls, Forms, Graphics, ExtCtrls,
{$ENDIF}
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;

type
 TVCLObjTRadioGroup = class(TD2BridgeItemVCLObjCore)
  private
   procedure TRadioGroupOnClick(EventParams: TStrings);
   procedure TRadioGroupOnEnter(EventParams: TStrings);
   procedure TRadioGroupOnExit(EventParams: TStrings);

   function TRadioGroupProcGetItems: TStrings;
   function TRadioGroupOnGetItemIndex: Variant;
   procedure TRadioGroupOnSetItemIndex(AValue: Variant);
   function TRadioGroupOnGetEnabled: Variant;
   procedure TRadioGroupOnSetEnabled(AValue: Variant);
   function TRadioGroupOnGetVisible: Variant;
   procedure TRadioGroupOnSetVisible(AValue: Variant);
   function TRadioGroupOnGetCaption: Variant;
   procedure TRadioGroupOnSetCaption(AValue: Variant);
   function TRadioGroupOnGetColumns: Variant;
   procedure TRadioGroupOnSetColumns(AValue: Variant);
  public
   function VCLClass: TClass; override;
   function CSSClass: String; override;
   Procedure VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle); override;
   procedure ProcessPropertyClass(NewObj: TObject); override;
   procedure ProcessEventClass; override;
   function FrameworkItemClass: ID2BridgeFrameworkItem; override;
 end;

implementation

Uses
 D2Bridge.Item.VCLObj.Style, D2Bridge.Util, D2Bridge.Forms,
 D2Bridge.Forms.Helper,
 Prism.Forms, Prism.Session.Thread.Proc;

{ TVCLObjTRadioGroup }

function TVCLObjTRadioGroup.CSSClass: String;
begin
 result := 'd2bridgeradiogroup';

 if {$IFDEF DELPHIX_ALEXANDRIA_UP}TRadioGroup(FD2BridgeItemVCLObj.Item).ShowFrame{$ELSE}True{$ENDIF} then
  result := result + ' border';
end;

function TVCLObjTRadioGroup.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.RadioGroup;
end;

procedure TVCLObjTRadioGroup.ProcessEventClass;
begin
 if Assigned(TRadioGroup(FD2BridgeItemVCLObj.Item).OnClick) then
   FrameworkItemClass.OnClick := TRadioGroupOnClick;

 if Assigned(TRadioGroup(FD2BridgeItemVCLObj.Item).OnEnter) then
   FrameworkItemClass.OnEnter := TRadioGroupOnEnter;

 if Assigned(TRadioGroup(FD2BridgeItemVCLObj.Item).OnExit) then
   FrameworkItemClass.OnExit := TRadioGroupOnExit;
end;

procedure TVCLObjTRadioGroup.ProcessPropertyClass(NewObj: TObject);
{$IFnDEF FPC}
var
 vD2BridgeForm: TD2BridgeForm;
 vProc: TPrismSessionThreadProc;
{$ENDIF}
begin
 inherited;

{$IFnDEF FPC}
 if NewObj is TPrismControl then
  if Assigned(TPrismControl(NewObj).Form) then
  begin
   if not TagIsD2BridgeFormComponentHelper(TRadioGroup(FD2BridgeItemVCLObj.Item).Tag, 'Items') then
   begin
    vD2BridgeForm:= (TPrismControl(NewObj).Form as TPrismForm).D2BridgeForm;

    TComponent(FD2BridgeItemVCLObj.Item).Tag := NativeInt(vD2BridgeForm.D2BridgeFormComponentHelperItems.PropValues(FD2BridgeItemVCLObj.Item));

    TPrismSessionThreadProc.Create(nil, TRadioGroup(FD2BridgeItemVCLObj.Item).InstanceHelper, true, true).Exec;
   end;
  end;
{$ENDIF}

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.RadioGroup.ProcGetItems := TRadioGroupProcGetItems;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.RadioGroup.GetEnabled := TRadioGroupOnGetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.RadioGroup.SetEnabled := TRadioGroupOnSetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.RadioGroup.GetVisible := TRadioGroupOnGetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.RadioGroup.SetVisible := TRadioGroupOnSetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.RadioGroup.ProcGetItemIndex := TRadioGroupOnGetItemIndex;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.RadioGroup.ProcSetItemIndex := TRadioGroupOnSetItemIndex;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.RadioGroup.ProcGetCaption := TRadioGroupOnGetCaption;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.RadioGroup.ProcSetCaption := TRadioGroupOnSetCaption;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.RadioGroup.ProcGetColumns := TRadioGroupOnGetColumns;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.RadioGroup.ProcSetColumns := TRadioGroupOnSetColumns;
end;

procedure TVCLObjTRadioGroup.TRadioGroupOnClick(EventParams: TStrings);
begin
 TRadioGroup(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTRadioGroup.TRadioGroupOnEnter(EventParams: TStrings);
begin
  TRadioGroup(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTRadioGroup.TRadioGroupOnExit(EventParams: TStrings);
begin
 TRadioGroup(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
end;

function TVCLObjTRadioGroup.TRadioGroupOnGetCaption: Variant;
begin
 result:= TRadioGroup(FD2BridgeItemVCLObj.Item).Caption;
end;

function TVCLObjTRadioGroup.TRadioGroupOnGetColumns: Variant;
begin
 Result := TRadioGroup(FD2BridgeItemVCLObj.Item).Columns;
end;

function TVCLObjTRadioGroup.TRadioGroupOnGetEnabled: Variant;
begin
  Result := GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
end;

function TVCLObjTRadioGroup.TRadioGroupOnGetItemIndex: Variant;
begin
 Result := TRadioGroup(FD2BridgeItemVCLObj.Item).ItemIndex;
end;

function TVCLObjTRadioGroup.TRadioGroupOnGetVisible: Variant;
begin
 Result := GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTRadioGroup.TRadioGroupOnSetCaption(AValue: Variant);
begin
 TRadioGroup(FD2BridgeItemVCLObj.Item).Caption:= AValue;
end;

procedure TVCLObjTRadioGroup.TRadioGroupOnSetColumns(AValue: Variant);
begin
 TRadioGroup(FD2BridgeItemVCLObj.Item).Columns:= AValue;
end;

procedure TVCLObjTRadioGroup.TRadioGroupOnSetEnabled(AValue: Variant);
begin
 TRadioGroup(FD2BridgeItemVCLObj.Item).Enabled := AValue;
end;

procedure TVCLObjTRadioGroup.TRadioGroupOnSetItemIndex(AValue: Variant);
begin
 TRadioGroup(FD2BridgeItemVCLObj.Item).ItemIndex := AValue;
end;

procedure TVCLObjTRadioGroup.TRadioGroupOnSetVisible(AValue: Variant);
begin
 TRadioGroup(FD2BridgeItemVCLObj.Item).Visible := AValue;
end;

function TVCLObjTRadioGroup.TRadioGroupProcGetItems: TStrings;
begin
 Result := TRadioGroup(FD2BridgeItemVCLObj.Item).Items;
end;

function TVCLObjTRadioGroup.VCLClass: TClass;
begin
 Result := TRadioGroup;
end;

procedure TVCLObjTRadioGroup.VCLStyle(
  const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 inherited;

 if TRadioGroup(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize := TRadioGroup(FD2BridgeItemVCLObj.Item).Font.Size;

 if TRadioGroup(FD2BridgeItemVCLObj.Item).Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor := TRadioGroup(FD2BridgeItemVCLObj.Item).Font.Color;

 if not IsColor(TRadioGroup(FD2BridgeItemVCLObj.Item).Color, [clWindow, clDefault, clBtnFace]) then
  VCLObjStyle.Color := TRadioGroup(FD2BridgeItemVCLObj.Item).Color;

 VCLObjStyle.FontStyles := TRadioGroup(FD2BridgeItemVCLObj.Item).Font.Style;
end;

{$ELSE}
implementation
{$ENDIF}

end.
