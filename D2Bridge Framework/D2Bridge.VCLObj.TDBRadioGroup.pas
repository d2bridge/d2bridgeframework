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

unit D2Bridge.VCLObj.TDBRadioGroup;

interface

{$IF NOT DEFINED(FMX) AND DEFINED(D2BRIDGE)}
uses
  Classes, RTTI, DB,
{$IFDEF FMX}

{$ELSE}
  StdCtrls, Controls, Forms, Graphics, DBCtrls,
{$ENDIF}
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;

type
 TVCLObjTDBRadioGroup = class(TD2BridgeItemVCLObjCore)
  private
   procedure TDBRadioGroupOnClick(EventParams: TStrings);
   procedure TDBRadioGroupOnEnter(EventParams: TStrings);
   procedure TDBRadioGroupOnExit(EventParams: TStrings);
   procedure TDBRadioGroupOnChange(EventParams: TStrings);

   function TDBRadioGroupProcGetItems: TStrings;
   function TDBRadioGroupOnGetEnabled: Variant;
   procedure TDBRadioGroupOnSetEnabled(AValue: Variant);
   function TDBRadioGroupOnGetVisible: Variant;
   procedure TDBRadioGroupOnSetVisible(AValue: Variant);
   function TDBRadioGroupOnGetCaption: Variant;
   procedure TDBRadioGroupOnSetCaption(AValue: Variant);
   function TDBRadioGroupOnGetColumns: Variant;
   procedure TDBRadioGroupOnSetColumns(AValue: Variant);
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

{ TVCLObjTDBRadioGroup }

function TVCLObjTDBRadioGroup.CSSClass: String;
begin
 result := 'd2bridgeradiogroup';

 if {$IFDEF DELPHIX_ALEXANDRIA_UP}TDBRadioGroup(FD2BridgeItemVCLObj.Item).ShowFrame{$ELSE}True{$ENDIF} then
  result := result + ' border';
end;

function TVCLObjTDBRadioGroup.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBRadioGroup;
end;

procedure TVCLObjTDBRadioGroup.ProcessEventClass;
begin
 if Assigned(TDBRadioGroup(FD2BridgeItemVCLObj.Item).OnClick) then
   FrameworkItemClass.OnClick := TDBRadioGroupOnClick;

 if Assigned(TDBRadioGroup(FD2BridgeItemVCLObj.Item).OnEnter) then
   FrameworkItemClass.OnEnter := TDBRadioGroupOnEnter;

 if Assigned(TDBRadioGroup(FD2BridgeItemVCLObj.Item).OnExit) then
   FrameworkItemClass.OnExit := TDBRadioGroupOnExit;

 if Assigned(TDBRadioGroup(FD2BridgeItemVCLObj.Item).OnChange) then
  FrameworkItemClass.OnChange := TDBRadioGroupOnChange;
end;

procedure TVCLObjTDBRadioGroup.ProcessPropertyClass(NewObj: TObject);
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
   if not TagIsD2BridgeFormComponentHelper(TDBRadioGroup(FD2BridgeItemVCLObj.Item).Tag, 'Items') then
   begin
    vD2BridgeForm:= (TPrismControl(NewObj).Form as TPrismForm).D2BridgeForm;

    TComponent(FD2BridgeItemVCLObj.Item).Tag := NativeInt(vD2BridgeForm.D2BridgeFormComponentHelperItems.PropValues(FD2BridgeItemVCLObj.Item));

    TPrismSessionThreadProc.Create(nil, TDBRadioGroup(FD2BridgeItemVCLObj.Item).InstanceHelper, true, true).Exec;
   end;
  end;
{$ENDIF}

 if Assigned(TDBRadioGroup(FD2BridgeItemVCLObj.Item).DataSource) then
   FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBRadioGroup.Dataware.DataSource := TDBRadioGroup(FD2BridgeItemVCLObj.Item).DataSource;

 if TDBRadioGroup(FD2BridgeItemVCLObj.Item).DataField <> '' then
   FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBRadioGroup.Dataware.DataField := TDBRadioGroup(FD2BridgeItemVCLObj.Item).DataField;

 //Need to fix error in Nested
 TDBRadioGroup(FD2BridgeItemVCLObj.Item).DataSource := nil;
 TDBRadioGroup(FD2BridgeItemVCLObj.Item).DataField := '';

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBRadioGroup.ProcGetItems := TDBRadioGroupProcGetItems;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBRadioGroup.GetEnabled := TDBRadioGroupOnGetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBRadioGroup.SetEnabled := TDBRadioGroupOnSetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBRadioGroup.GetVisible := TDBRadioGroupOnGetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBRadioGroup.SetVisible := TDBRadioGroupOnSetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBRadioGroup.ProcGetCaption := TDBRadioGroupOnGetCaption;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBRadioGroup.ProcSetCaption := TDBRadioGroupOnSetCaption;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBRadioGroup.ProcGetColumns := TDBRadioGroupOnGetColumns;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBRadioGroup.ProcSetColumns := TDBRadioGroupOnSetColumns;
end;

procedure TVCLObjTDBRadioGroup.TDBRadioGroupOnChange(EventParams: TStrings);
begin
 TDBRadioGroup(FD2BridgeItemVCLObj.Item).OnChange(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBRadioGroup.TDBRadioGroupOnClick(EventParams: TStrings);
begin
 TDBRadioGroup(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBRadioGroup.TDBRadioGroupOnEnter(EventParams: TStrings);
begin
  TDBRadioGroup(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBRadioGroup.TDBRadioGroupOnExit(EventParams: TStrings);
begin
 TDBRadioGroup(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
end;

function TVCLObjTDBRadioGroup.TDBRadioGroupOnGetCaption: Variant;
begin
 result:= TDBRadioGroup(FD2BridgeItemVCLObj.Item).Caption;
end;

function TVCLObjTDBRadioGroup.TDBRadioGroupOnGetColumns: Variant;
begin
 Result := TDBRadioGroup(FD2BridgeItemVCLObj.Item).Columns;
end;

function TVCLObjTDBRadioGroup.TDBRadioGroupOnGetEnabled: Variant;
begin
  Result := GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
end;

function TVCLObjTDBRadioGroup.TDBRadioGroupOnGetVisible: Variant;
begin
 Result := GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBRadioGroup.TDBRadioGroupOnSetCaption(AValue: Variant);
begin
 TDBRadioGroup(FD2BridgeItemVCLObj.Item).Caption:= AValue;
end;

procedure TVCLObjTDBRadioGroup.TDBRadioGroupOnSetColumns(AValue: Variant);
begin
 TDBRadioGroup(FD2BridgeItemVCLObj.Item).Columns:= AValue;
end;

procedure TVCLObjTDBRadioGroup.TDBRadioGroupOnSetEnabled(AValue: Variant);
begin
 TDBRadioGroup(FD2BridgeItemVCLObj.Item).Enabled := AValue;
end;

procedure TVCLObjTDBRadioGroup.TDBRadioGroupOnSetVisible(AValue: Variant);
begin
 TDBRadioGroup(FD2BridgeItemVCLObj.Item).Visible := AValue;
end;

function TVCLObjTDBRadioGroup.TDBRadioGroupProcGetItems: TStrings;
begin
 Result := TDBRadioGroup(FD2BridgeItemVCLObj.Item).Items;
end;

function TVCLObjTDBRadioGroup.VCLClass: TClass;
begin
 Result := TDBRadioGroup;
end;

procedure TVCLObjTDBRadioGroup.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 inherited;

 if TDBRadioGroup(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize := TDBRadioGroup(FD2BridgeItemVCLObj.Item).Font.Size;

 if TDBRadioGroup(FD2BridgeItemVCLObj.Item).Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor := TDBRadioGroup(FD2BridgeItemVCLObj.Item).Font.Color;

 if not IsColor(TDBRadioGroup(FD2BridgeItemVCLObj.Item).Color, [clWindow, clDefault, clBtnFace]) then
  VCLObjStyle.Color := TDBRadioGroup(FD2BridgeItemVCLObj.Item).Color;

 VCLObjStyle.FontStyles := TDBRadioGroup(FD2BridgeItemVCLObj.Item).Font.Style;
end;

{$ELSE}
implementation
{$ENDIF}

end.