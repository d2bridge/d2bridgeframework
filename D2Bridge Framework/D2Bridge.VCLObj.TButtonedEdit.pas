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

unit D2Bridge.VCLObj.TButtonedEdit;

interface

{$IF NOT DEFINED(FMX) AND NOT DEFINED(FPC)}
uses
  Classes,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass,
  ExtCtrls, Controls, Graphics, Forms;

type
 TVCLObjTButtonedEdit = class(TD2BridgeItemVCLObjCore)
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
 Prism.Util, Prism.Types, D2Bridge.Util, D2Bridge.Item.VCLObj.Style, D2Bridge.Prism.ButtonedEdit;

{ VCLObjTButtonedEdit }


function TVCLObjTButtonedEdit.CSSClass: String;
begin
 result:= 'form-control';
end;

function TVCLObjTButtonedEdit.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit;
end;

procedure TVCLObjTButtonedEdit.ProcessEventClass;
begin
 if Assigned(TButtonedEdit(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:=
    procedure(EventParams: TStrings)
    begin
     TButtonedEdit(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TButtonedEdit(FD2BridgeItemVCLObj.Item).OnDblClick) then
  FrameworkItemClass.OnDblClick:=
    procedure(EventParams: TStrings)
    begin
     TButtonedEdit(FD2BridgeItemVCLObj.Item).OnDblClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TButtonedEdit(FD2BridgeItemVCLObj.Item).OnLeftButtonClick) then
  PrismButtonedEdit(FrameworkItemClass).OnLeftButtonClick:=
    procedure(EventParams: TStrings)
    begin
     TButtonedEdit(FD2BridgeItemVCLObj.Item).OnLeftButtonClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TButtonedEdit(FD2BridgeItemVCLObj.Item).OnRightButtonClick) then
  PrismButtonedEdit(FrameworkItemClass).OnRightButtonClick:=
    procedure(EventParams: TStrings)
    begin
     TButtonedEdit(FD2BridgeItemVCLObj.Item).OnRightButtonClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TButtonedEdit(FD2BridgeItemVCLObj.Item).OnEnter) then
 FrameworkItemClass.OnEnter:=
    procedure(EventParams: TStrings)
    begin
     TButtonedEdit(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TButtonedEdit(FD2BridgeItemVCLObj.Item).OnExit) then
 FrameworkItemClass.OnExit:=
    procedure(EventParams: TStrings)
    begin
     TButtonedEdit(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TButtonedEdit(FD2BridgeItemVCLObj.Item).OnChange) then
 FrameworkItemClass.OnChange:=
    procedure(EventParams: TStrings)
    begin
     TButtonedEdit(FD2BridgeItemVCLObj.Item).OnChange(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TButtonedEdit(FD2BridgeItemVCLObj.Item).OnKeyDown) then
 FrameworkItemClass.OnKeyDown:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
      KeyChar:  Char;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TButtonedEdit(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TButtonedEdit(FD2BridgeItemVCLObj.Item).OnKeyUp) then
 FrameworkItemClass.OnKeyUp:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
      KeyChar:  Char;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TButtonedEdit(FD2BridgeItemVCLObj.Item).OnKeyUp(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TButtonedEdit(FD2BridgeItemVCLObj.Item).OnKeyPress) then
 FrameworkItemClass.OnKeyPress:=
    procedure(EventParams: TStrings)
    var
      KeyPress: Char;
    begin
     KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
     TButtonedEdit(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
    end;
end;

procedure TVCLObjTButtonedEdit.ProcessPropertyClass(NewObj: TObject);
begin
 if TButtonedEdit(FD2BridgeItemVCLObj.Item).PasswordChar <> #0 then
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.DataType:= PrismFieldTypePassword
 else
 begin
  if TButtonedEdit(FD2BridgeItemVCLObj.Item).NumbersOnly then
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.DataType:= PrismFieldTypeNumber;
 end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.CharCase:= TButtonedEdit(FD2BridgeItemVCLObj.Item).CharCase;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.GetEnabled:=
    function: Variant
    begin
     Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TButtonedEdit(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 PrismButtonedEdit(FrameworkItemClass).GetLeftButtonEnabled:=
    function: Variant
    begin
     Result:= TButtonedEdit(FD2BridgeItemVCLObj.Item).LeftButton.Enabled;
    end;

 PrismButtonedEdit(FrameworkItemClass).GetLeftButtonVisible:=
    function: Variant
    begin
     Result:= TButtonedEdit(FD2BridgeItemVCLObj.Item).LeftButton.Visible;
    end;

 PrismButtonedEdit(FrameworkItemClass).GetRightButtonEnabled:=
    function: Variant
    begin
     Result:= TButtonedEdit(FD2BridgeItemVCLObj.Item).RightButton.Enabled;
    end;

 PrismButtonedEdit(FrameworkItemClass).GetRightButtonVisible:=
    function: Variant
    begin
     Result:= TButtonedEdit(FD2BridgeItemVCLObj.Item).RightButton.Visible;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TButtonedEdit(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.GetVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.SetVisible:=
    procedure(AValue: Variant)
    begin
     TButtonedEdit(FD2BridgeItemVCLObj.Item).Visible:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.GetReadOnly:=
    function: Variant
    begin
     Result:= TButtonedEdit(FD2BridgeItemVCLObj.Item).ReadOnly;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.SetReadOnly:=
    procedure(AValue: Variant)
    begin
     TButtonedEdit(FD2BridgeItemVCLObj.Item).ReadOnly:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.GetPlaceholder:=
    function: Variant
    begin
     if TButtonedEdit(FD2BridgeItemVCLObj.Item).TextHint <> '' then
      Result:= TButtonedEdit(FD2BridgeItemVCLObj.Item).TextHint
     else

     if TButtonedEdit(FD2BridgeItemVCLObj.Item).ShowHint then
      Result:= TButtonedEdit(FD2BridgeItemVCLObj.Item).Hint
     else
      Result:= '';
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.OnGetText:=
    function: Variant
    begin
     Result:= TButtonedEdit(FD2BridgeItemVCLObj.Item).Text;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.OnSetText:=
    procedure(AValue: Variant)
    begin
     TButtonedEdit(FD2BridgeItemVCLObj.Item).Text:= AValue;
    end;

 {$IF DEFINED(DELPHIX_SYDNEY_UP)} // Delphi 10.4 Sydney or Upper
 if (FD2BridgeItemVCLObj.Item is TButtonedEdit) then
 begin
    if (FD2BridgeItemVCLObj.Item as TButtonedEdit).LeftButton.ImageName <> '' then
    begin
     FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.ButtonLeftText:=
       '<i class="'+(FD2BridgeItemVCLObj.Item as TButtonedEdit).LeftButton.ImageName+'"></i> '
       + FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.ButtonLeftText;
    end;

    if (FD2BridgeItemVCLObj.Item as TButtonedEdit).RightButton.ImageName <> '' then
    begin
     FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.ButtonRightText:=
       '<i class="'+(FD2BridgeItemVCLObj.Item as TButtonedEdit).RightButton.ImageName+'"></i> '
       + FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.ButtonRightText;
    end;
 end;
 {$ENDIF}
end;

function TVCLObjTButtonedEdit.VCLClass: TClass;
begin
 Result:= TButtonedEdit;
end;

procedure TVCLObjTButtonedEdit.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TButtonedEdit(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize:= TButtonedEdit(FD2BridgeItemVCLObj.Item).Font.Size;

 if TButtonedEdit(FD2BridgeItemVCLObj.Item).Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor:= TButtonedEdit(FD2BridgeItemVCLObj.Item).Font.Color;

 if not IsColor(TButtonedEdit(FD2BridgeItemVCLObj.Item).Color, [clWindow, clDefault]) then
  VCLObjStyle.Color:= TButtonedEdit(FD2BridgeItemVCLObj.Item).Color;

 if TButtonedEdit(FD2BridgeItemVCLObj.Item).Alignment <> DefaultAlignment then
  VCLObjStyle.Alignment:= TButtonedEdit(FD2BridgeItemVCLObj.Item).Alignment;

 VCLObjStyle.FontStyles:= TButtonedEdit(FD2BridgeItemVCLObj.Item).Font.Style;
end;

{$ELSE}
implementation
{$ENDIF}

end.