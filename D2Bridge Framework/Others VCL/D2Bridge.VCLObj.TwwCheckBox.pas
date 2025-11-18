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

unit D2Bridge.VCLObj.TwwCheckBox;


interface

{$IFDEF INFOPOWER_AVAILABLE}
uses
  Classes,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTwwCheckBox = class(TD2BridgeItemVCLObjCore)
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
  StdCtrls, Controls, Prism.Util, D2Bridge.Util, vcl.wwcheckbox, Forms,
  Graphics, D2Bridge.Item.VCLObj.Style;

{ TVCLObjTwwCheckBox }


function TVCLObjTwwCheckBox.CSSClass: String;
begin
 result:= 'form-check-input';
end;

function TVCLObjTwwCheckBox.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox;
end;

procedure TVCLObjTwwCheckBox.ProcessEventClass;
begin
 if Assigned(TwwCheckBox(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:=
    procedure(EventParams: TStrings)
    begin
     TwwCheckBox(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwCheckBox(FD2BridgeItemVCLObj.Item).OnEnter) then
 FrameworkItemClass.OnEnter:=
    procedure(EventParams: TStrings)
    begin
     TwwCheckBox(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwCheckBox(FD2BridgeItemVCLObj.Item).OnExit) then
 FrameworkItemClass.OnExit:=
    procedure(EventParams: TStrings)
    begin
     TwwCheckBox(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwCheckBox(FD2BridgeItemVCLObj.Item).OnKeyDown) then
 FrameworkItemClass.OnKeyDown:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TwwCheckBox(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TwwCheckBox(FD2BridgeItemVCLObj.Item).OnKeyPress) then
 FrameworkItemClass.OnKeyPress:=
    procedure(EventParams: TStrings)
    var
      KeyPress: Char;
    begin
     KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
     TwwCheckBox(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
    end;

end;

procedure TVCLObjTwwCheckBox.ProcessPropertyClass(NewObj: TObject);
begin
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox.OnGetText:=
    function: Variant
    begin
     Result:= TwwCheckBox(FD2BridgeItemVCLObj.Item).Caption;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox.OnGetChecked:=
    function: Variant
    begin
     Result:= TwwCheckBox(FD2BridgeItemVCLObj.Item).Checked;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox.OnSetChecked:=
    procedure(AValue: Variant)
    begin
     TwwCheckBox(FD2BridgeItemVCLObj.Item).Checked:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox.GetEnabled:=
    function: Variant
    begin
     Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TwwCheckBox(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox.GetVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox.SetVisible:=
    procedure(AValue: Variant)
    begin
     TwwCheckBox(FD2BridgeItemVCLObj.Item).Visible:= AValue;
    end;
end;

function TVCLObjTwwCheckBox.VCLClass: TClass;
begin
 Result:= TwwCheckBox;
end;

Procedure TVCLObjTwwCheckBox.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TwwCheckBox(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize := TwwCheckBox(FD2BridgeItemVCLObj.Item).Font.Size;

 if TwwCheckBox(FD2BridgeItemVCLObj.Item).Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor := TwwCheckBox(FD2BridgeItemVCLObj.Item).Font.Color;

 if TwwCheckBox(FD2BridgeItemVCLObj.Item).Color <> clBtnFace then
  VCLObjStyle.Color := TwwCheckBox(FD2BridgeItemVCLObj.Item).Color;

 if TwwCheckBox(FD2BridgeItemVCLObj.Item).Alignment <> DefaultAlignment then
  VCLObjStyle.Alignment:= TwwCheckBox(FD2BridgeItemVCLObj.Item).Alignment;

 VCLObjStyle.FontStyles := TwwCheckBox(FD2BridgeItemVCLObj.Item).Font.Style;
end;

{$ELSE}
implementation
{$ENDIF}

end.