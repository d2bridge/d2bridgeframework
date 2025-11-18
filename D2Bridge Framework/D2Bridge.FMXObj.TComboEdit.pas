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

unit D2Bridge.FMXObj.TComboEdit;


interface

{$IFDEF FMX}
uses
  Classes, SysUtils,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TFMXObjTComboEdit = class(TD2BridgeItemVCLObjCore)
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
  FMX.ComboEdit,
  Prism.Util, D2Bridge.Forms, D2Bridge.Util, D2Bridge.Item.VCLObj.Style,
  Prism.Forms, D2Bridge.Forms.Helper;

{ TFMXObjTComboEdit }

function TFMXObjTComboEdit.CSSClass: String;
begin
 result:= 'form-select';
end;

function TFMXObjTComboEdit.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox;
end;

procedure TFMXObjTComboEdit.ProcessEventClass;
begin
 if Assigned(TComboEdit(FD2BridgeItemVCLObj.Item).OnChange) then
 FrameworkItemClass.OnSelect:=
    procedure(EventParams: TStrings)
    begin
     TComboEdit(FD2BridgeItemVCLObj.Item).OnChange(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TComboEdit(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:=
    procedure(EventParams: TStrings)
    begin
     TComboEdit(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TComboEdit(FD2BridgeItemVCLObj.Item).OnEnter) then
 FrameworkItemClass.OnEnter:=
    procedure(EventParams: TStrings)
    begin
     TComboEdit(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TComboEdit(FD2BridgeItemVCLObj.Item).OnExit) then
 FrameworkItemClass.OnExit:=
    procedure(EventParams: TStrings)
    begin
     TComboEdit(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TComboEdit(FD2BridgeItemVCLObj.Item).OnChange) then
 FrameworkItemClass.OnChange:=
    procedure(EventParams: TStrings)
    begin
     TComboEdit(FD2BridgeItemVCLObj.Item).OnChange(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TComboEdit(FD2BridgeItemVCLObj.Item).OnKeyDown) then
 FrameworkItemClass.OnKeyDown:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
      KeyChar:  Char;
    begin
     KeyPress:= ConvertHTMLKeyToVK(EventParams.values['key']);
     KeyChar:=  Char(KeyPress);
     TComboEdit(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, KeyChar, []);
    end;

 if Assigned(TComboEdit(FD2BridgeItemVCLObj.Item).OnKeyUp) then
 FrameworkItemClass.OnKeyUp:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
      KeyChar:  Char;
    begin
     KeyPress:= ConvertHTMLKeyToVK(EventParams.values['key']);
     KeyChar:=  Char(KeyPress);
     TComboEdit(FD2BridgeItemVCLObj.Item).OnKeyUp(FD2BridgeItemVCLObj.Item, KeyPress, KeyChar, []);
    end;
end;

procedure TFMXObjTComboEdit.ProcessPropertyClass(NewObj: TObject);
var
 vD2BridgeForm: TD2BridgeForm;
 vItems: TStrings;
 vItemIndex: Integer;
begin
 if NewObj is TPrismControl then
  if Assigned(TPrismControl(NewObj).Form) then
  begin
   vItems:= TComboEdit(FD2BridgeItemVCLObj.Item).Items;
   vItemIndex:= TComboEdit(FD2BridgeItemVCLObj.Item).ItemIndex;
   vD2BridgeForm:= TPrismForm(TPrismControl(NewObj).Form).D2BridgeForm;
   TComboEdit(FD2BridgeItemVCLObj.Item).Tag := NativeInt(vD2BridgeForm.D2BridgeFormComponentHelperItems.PropValues(NewObj));
   TD2BridgeFormComponentHelper(TComboEdit(FD2BridgeItemVCLObj.Item).Tag).Value['Lines']:= vItems;
   TD2BridgeFormComponentHelper(TComboEdit(FD2BridgeItemVCLObj.Item).Tag).Value['ItemIndex']:= vItemIndex;
  end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox.ProcGetItems :=
    function: TStrings
    begin
     Result:= TComboEdit(FD2BridgeItemVCLObj.Item).Items;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox.ProcGetSelectedItem :=
    function: Variant
    begin
     Result:= '';
     if (TComboEdit(FD2BridgeItemVCLObj.Item).ItemIndex >= 0) and (TComboEdit(FD2BridgeItemVCLObj.Item).Items.Count > 0) then
      Result:= TComboEdit(FD2BridgeItemVCLObj.Item).Items[TComboEdit(FD2BridgeItemVCLObj.Item).ItemIndex];
     //Result:= TComboEdit(FD2BridgeItemVCLObj.Item).Text;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox.ProcSetSelectedItem :=
    procedure(AValue: Variant)
    begin
     if TComboEdit(FD2BridgeItemVCLObj.Item).Items.IndexOf(AValue) < 0 then
      TComboEdit(FD2BridgeItemVCLObj.Item).Text := AValue
     else
      TComboEdit(FD2BridgeItemVCLObj.Item).ItemIndex := TComboEdit(FD2BridgeItemVCLObj.Item).Items.IndexOf(AValue);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox.GetEnabled:=
    function: Variant
    begin
     Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TComboEdit(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox.GetVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox.SetVisible:=
    procedure(AValue: Variant)
    begin
     TComboEdit(FD2BridgeItemVCLObj.Item).Visible:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox.GetPlaceholder:=
    function: Variant
    begin
     if TComboEdit(FD2BridgeItemVCLObj.Item).ShowHint then
      Result:= TComboEdit(FD2BridgeItemVCLObj.Item).Hint
     else
      Result:= '';
    end;
end;

function TFMXObjTComboEdit.VCLClass: TClass;
begin
 Result:= TComboEdit;
end;

procedure TFMXObjTComboEdit.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TComboEdit(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize:= TComboEdit(FD2BridgeItemVCLObj.Item).Font.Size;

 if TComboEdit(FD2BridgeItemVCLObj.Item).FontColor <> DefaultFontColor then
  VCLObjStyle.FontColor:= TComboEdit(FD2BridgeItemVCLObj.Item).FontColor;

 if TComboEdit(FD2BridgeItemVCLObj.Item).TextSettings.HorzAlign <> DefaultAlignment then
  VCLObjStyle.Alignment:= TComboEdit(FD2BridgeItemVCLObj.Item).TextSettings.HorzAlign;

 VCLObjStyle.FontStyles:= TComboEdit(FD2BridgeItemVCLObj.Item).Font.Style;
end;
{$ELSE}
implementation
{$ENDIF}

end.
