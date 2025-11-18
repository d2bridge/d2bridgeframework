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
  Thank for contribution to this Unit to:
    Natanael Ribeiro
    natan_ribeiro_ferreira@hotmail.com
 +--------------------------------------------------------------------------+
}

{$I ..\D2Bridge.inc}

unit D2Bridge.VCLObj.TcxComboBox;


interface

{$IFDEF DEVEXPRESS_AVAILABLE}
uses
  Classes, SysUtils,
  DBCtrls, Forms,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTcxComboBox = class(TD2BridgeItemVCLObjCore)
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
  StdCtrls,
  Prism.Util, D2Bridge.Forms, D2Bridge.Util, cxDropDownEdit, Graphics, D2Bridge.Item.VCLObj.Style;

{ TVCLObjTcxComboBox }


function TVCLObjTcxComboBox.CSSClass: String;
begin
 result:= 'form-select';
end;

function TVCLObjTcxComboBox.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox;
end;

procedure TVCLObjTcxComboBox.ProcessEventClass;
begin
 if Assigned(TcxComboBox(FD2BridgeItemVCLObj.Item).Properties.OnChange) then
 FrameworkItemClass.OnSelect:=
    procedure(EventParams: TStrings)
    begin
     TcxComboBox(FD2BridgeItemVCLObj.Item).Properties.OnChange(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TcxComboBox(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:=
    procedure(EventParams: TStrings)
    begin
     TcxComboBox(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TcxComboBox(FD2BridgeItemVCLObj.Item).OnEnter) then
 FrameworkItemClass.OnEnter:=
    procedure(EventParams: TStrings)
    begin
     TcxComboBox(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TcxComboBox(FD2BridgeItemVCLObj.Item).OnExit) then
 FrameworkItemClass.OnExit:=
    procedure(EventParams: TStrings)
    begin
     TcxComboBox(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TcxComboBox(FD2BridgeItemVCLObj.Item).Properties.OnChange) then
 FrameworkItemClass.OnChange:=
    procedure(EventParams: TStrings)
    begin
     TcxComboBox(FD2BridgeItemVCLObj.Item).Properties.OnChange(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TcxComboBox(FD2BridgeItemVCLObj.Item).OnKeyDown) then
 FrameworkItemClass.OnKeyDown:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TcxComboBox(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TcxComboBox(FD2BridgeItemVCLObj.Item).OnKeyUp) then
 FrameworkItemClass.OnKeyUp:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TcxComboBox(FD2BridgeItemVCLObj.Item).OnKeyUp(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TcxComboBox(FD2BridgeItemVCLObj.Item).OnKeyPress) then
 FrameworkItemClass.OnKeyPress:=
    procedure(EventParams: TStrings)
    var
      KeyPress: Char;
    begin
     KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
     TcxComboBox(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
    end;
end;

procedure TVCLObjTcxComboBox.ProcessPropertyClass(NewObj: TObject);
begin
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox.ProcGetItems :=
    function: TStrings
    begin
     Result:= TcxComboBox(FD2BridgeItemVCLObj.Item).Properties.Items;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox.ProcGetSelectedItem :=
    function: Variant
    begin
     Result:= '';
     if TcxComboBox(FD2BridgeItemVCLObj.Item).ItemIndex >= 0 then
      Result:= TcxComboBox(FD2BridgeItemVCLObj.Item).Properties.Items[TcxComboBox(FD2BridgeItemVCLObj.Item).ItemIndex];
     //Result:= TcxComboBox(FD2BridgeItemVCLObj.Item).Text;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox.ProcSetSelectedItem :=
    procedure(AValue: Variant)
    begin
     if TcxComboBox(FD2BridgeItemVCLObj.Item).Properties.Items.IndexOf(AValue) < 0 then
      TcxComboBox(FD2BridgeItemVCLObj.Item).Text := AValue
     else
      TcxComboBox(FD2BridgeItemVCLObj.Item).ItemIndex := TcxComboBox(FD2BridgeItemVCLObj.Item).Properties.Items.IndexOf(AValue);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox.GetEnabled:=
    function: Variant
    begin
     Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TcxComboBox(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox.GetVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox.SetVisible:=
    procedure(AValue: Variant)
    begin
     TcxComboBox(FD2BridgeItemVCLObj.Item).Visible:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox.GetPlaceholder:=
    function: Variant
    begin
     if TcxComboBox(FD2BridgeItemVCLObj.Item).TextHint <> '' then
      Result:= TcxComboBox(FD2BridgeItemVCLObj.Item).TextHint
     else
     if TcxComboBox(FD2BridgeItemVCLObj.Item).ShowHint then
      Result:= TcxComboBox(FD2BridgeItemVCLObj.Item).Hint
     else
      Result:= '';
    end;

end;

function TVCLObjTcxComboBox.VCLClass: TClass;
begin
 Result:= TcxComboBox;
end;

Procedure TVCLObjTcxComboBox.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TcxComboBox(FD2BridgeItemVCLObj.Item).Style.Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize := TcxComboBox(FD2BridgeItemVCLObj.Item).Style.Font.Size;

 if TcxComboBox(FD2BridgeItemVCLObj.Item).Style.Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor := TcxComboBox(FD2BridgeItemVCLObj.Item).Style.Font.Color;

 if TcxComboBox(FD2BridgeItemVCLObj.Item).Style.Color <> DefaultColor then
  VCLObjStyle.Color := TcxComboBox(FD2BridgeItemVCLObj.Item).Style.Color;

// if TcxComboBox(FD2BridgeItemVCLObj.Item).Style.Alignment <> DefaultAlignment then
//  VCLObjStyle.Alignment:= TcxComboBox(FD2BridgeItemVCLObj.Item).Alignment;

 VCLObjStyle.FontStyles := TcxComboBox(FD2BridgeItemVCLObj.Item).Style.Font.Style;
end;

{$ELSE}
implementation
{$ENDIF}

end.
