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

unit D2Bridge.VCLObj.TcxCheckBox;


interface

{$IFDEF DEVEXPRESS_AVAILABLE}
uses
  Classes,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTcxCheckBox = class(TD2BridgeItemVCLObjCore)
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
  StdCtrls, Controls, Prism.Util, D2Bridge.Util, cxCheckBox, Forms,
  Graphics, D2Bridge.Item.VCLObj.Style;

{ TVCLObjTcxCheckBox }


function TVCLObjTcxCheckBox.CSSClass: String;
begin
 result:= 'form-check-input';
end;

function TVCLObjTcxCheckBox.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox;
end;

procedure TVCLObjTcxCheckBox.ProcessEventClass;
begin
 if Assigned(TcxCheckBox(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:=
    procedure(EventParams: TStrings)
    begin
     //TcxCheckBox(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TcxCheckBox(FD2BridgeItemVCLObj.Item).OnEnter) then
 FrameworkItemClass.OnEnter:=
    procedure(EventParams: TStrings)
    begin
     TcxCheckBox(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TcxCheckBox(FD2BridgeItemVCLObj.Item).OnExit) then
 FrameworkItemClass.OnExit:=
    procedure(EventParams: TStrings)
    begin
     TcxCheckBox(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TcxCheckBox(FD2BridgeItemVCLObj.Item).OnKeyDown) then
 FrameworkItemClass.OnKeyDown:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TcxCheckBox(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TcxCheckBox(FD2BridgeItemVCLObj.Item).OnKeyPress) then
 FrameworkItemClass.OnKeyPress:=
    procedure(EventParams: TStrings)
    var
      KeyPress: Char;
    begin
     KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
     TcxCheckBox(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
    end;

end;

procedure TVCLObjTcxCheckBox.ProcessPropertyClass(NewObj: TObject);
begin
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox.OnGetText:=
    function: Variant
    begin
     Result:= TcxCheckBox(FD2BridgeItemVCLObj.Item).Caption;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox.OnGetChecked:=
    function: Variant
    begin
     Result:= TcxCheckBox(FD2BridgeItemVCLObj.Item).Checked;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox.OnSetChecked:=
    procedure(AValue: Variant)
    begin
     TcxCheckBox(FD2BridgeItemVCLObj.Item).Checked:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox.GetEnabled:=
    function: Variant
    begin
     Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TcxCheckBox(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox.GetVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.CheckBox.SetVisible:=
    procedure(AValue: Variant)
    begin
     TcxCheckBox(FD2BridgeItemVCLObj.Item).Visible:= AValue;
    end;
end;

function TVCLObjTcxCheckBox.VCLClass: TClass;
begin
 Result:= TcxCheckBox;
end;

Procedure TVCLObjTcxCheckBox.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TcxCheckBox(FD2BridgeItemVCLObj.Item).Style.Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize := TcxCheckBox(FD2BridgeItemVCLObj.Item).Style.Font.Size;

 if TcxCheckBox(FD2BridgeItemVCLObj.Item).Style.Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor := TcxCheckBox(FD2BridgeItemVCLObj.Item).Style.Font.Color;

 if TcxCheckBox(FD2BridgeItemVCLObj.Item).Style.Color <> clBtnFace then
  VCLObjStyle.Color := TcxCheckBox(FD2BridgeItemVCLObj.Item).Style.Color;

// if TcxCheckBox(FD2BridgeItemVCLObj.Item).Alignment <> DefaultAlignment then
//  VCLObjStyle.Alignment:= TcxCheckBox(FD2BridgeItemVCLObj.Item).Alignment;

 VCLObjStyle.FontStyles := TcxCheckBox(FD2BridgeItemVCLObj.Item).Style.Font.Style;
end;

{$ELSE}
implementation
{$ENDIF}

end.