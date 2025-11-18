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
  Thanks for contribution to this Unit to:
    Alisson Suart
    Email: contato@deuxsoftware.com.br
 +--------------------------------------------------------------------------+
}

{$I ..\D2Bridge.inc}

unit D2Bridge.VCLObj.TwwDBSpinEdit;

interface

{$IFDEF INFOPOWER_AVAILABLE}
uses
  Classes,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass,
  D2Bridge.HTML.CSS, ExtCtrls, Controls, Graphics, Forms;

type
 TVCLObjTwwDBSpinEdit = class(TD2BridgeItemVCLObjCore)
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
 Prism.Util, Prism.Types, D2Bridge.Util, D2Bridge.Item.VCLObj.Style, D2Bridge.Prism.ButtonedEdit,
 vcl.wwdbspin;

{ TVCLObjTwwDBSpinEdit }


function TVCLObjTwwDBSpinEdit.CSSClass: String;
begin
 result:= 'form-control';
end;

function TVCLObjTwwDBSpinEdit.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit;
end;

procedure TVCLObjTwwDBSpinEdit.ProcessEventClass;
begin
 if Assigned(TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:=
    procedure(EventParams: TStrings)
    begin
     TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).OnDblClick) then
  FrameworkItemClass.OnDblClick:=
    procedure(EventParams: TStrings)
    begin
     TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).OnDblClick(FD2BridgeItemVCLObj.Item);
    end;

  PrismButtonedEdit(FrameworkItemClass).OnLeftButtonClick:=
    procedure(EventParams: TStrings)
    begin
      TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).Value :=  TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).Value - TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).Increment;
    end;

  PrismButtonedEdit(FrameworkItemClass).OnRightButtonClick:=
    procedure(EventParams: TStrings)
    begin
      TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).Value :=  TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).Value + TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).Increment;
    end;

 if Assigned(TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).OnEnter) then
 FrameworkItemClass.OnEnter:=
    procedure(EventParams: TStrings)
    begin
     TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).OnExit) then
 FrameworkItemClass.OnExit:=
    procedure(EventParams: TStrings)
    begin
     TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).OnChange) then
 FrameworkItemClass.OnChange:=
    procedure(EventParams: TStrings)
    begin
     TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).OnChange(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).OnKeyDown) then
 FrameworkItemClass.OnKeyDown:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
      KeyChar:  Char;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).OnKeyUp) then
 FrameworkItemClass.OnKeyUp:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
      KeyChar:  Char;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).OnKeyUp(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).OnKeyPress) then
 FrameworkItemClass.OnKeyPress:=
    procedure(EventParams: TStrings)
    var
      KeyPress: Char;
    begin
     KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
     TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
    end;
end;

procedure TVCLObjTwwDBSpinEdit.ProcessPropertyClass(NewObj: TObject);
begin

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.ButtonLeftCSS  := D2Bridge.HTML.CSS.Button.decrease;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.ButtonRightCSS := D2Bridge.HTML.CSS.Button.increase;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.CharCase:= TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).CharCase;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.GetEnabled:=
    function: Variant
    begin
     Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 PrismButtonedEdit(FrameworkItemClass).GetLeftButtonEnabled:=
    function: Variant
    begin
     Result:=  GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 PrismButtonedEdit(FrameworkItemClass).GetLeftButtonVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 PrismButtonedEdit(FrameworkItemClass).GetRightButtonEnabled:=
    function: Variant
    begin
     Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 PrismButtonedEdit(FrameworkItemClass).GetRightButtonVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.GetVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.SetVisible:=
    procedure(AValue: Variant)
    begin
     TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).Visible:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.GetReadOnly:=
    function: Variant
    begin
     Result:= TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).ReadOnly;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.SetReadOnly:=
    procedure(AValue: Variant)
    begin
     TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).ReadOnly:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.GetPlaceholder:=
    function: Variant
    begin
     if TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).TextHint <> '' then
      Result:= TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).TextHint
     else

     if TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).ShowHint then
      Result:= TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).Hint
     else
      Result:= '';
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.OnGetText:=
    function: Variant
    begin
     Result:= TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).Text;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.OnSetText:=
    procedure(AValue: Variant)
    begin
     TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).Text:= AValue;
    end;

end;

function TVCLObjTwwDBSpinEdit.VCLClass: TClass;
begin
 Result:= TwwDBSpinEdit;
end;

procedure TVCLObjTwwDBSpinEdit.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize:= TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).Font.Size;

 if TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor:= TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).Font.Color;

 if TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).Color <> clWindow then
  VCLObjStyle.Color:= TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).Color;

 if TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).Alignment <> DefaultAlignment then
  VCLObjStyle.Alignment:= TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).Alignment;

 VCLObjStyle.FontStyles:= TwwDBSpinEdit(FD2BridgeItemVCLObj.Item).Font.Style;
end;

{$ELSE}
implementation
{$ENDIF}

end.