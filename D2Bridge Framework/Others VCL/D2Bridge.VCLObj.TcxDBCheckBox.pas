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

unit D2Bridge.VCLObj.TcxDBCheckBox;


interface

{$IFDEF DEVEXPRESS_AVAILABLE}
uses
  Classes,
  DBCtrls,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTcxDBCheckBox = class(TD2BridgeItemVCLObjCore)
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
  StdCtrls, Controls, Prism.Util, D2Bridge.Util, cxDBEdit,
  Graphics, Forms, D2Bridge.Item.VCLObj.Style;

{ TVCLObjTcxDBCheckBox }


function TVCLObjTcxDBCheckBox.CSSClass: String;
begin
 result:= 'form-check-input';
end;

function TVCLObjTcxDBCheckBox.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCheckBox;
end;

procedure TVCLObjTcxDBCheckBox.ProcessEventClass;
begin
 if Assigned(TcxDBCheckBox(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:=
    procedure(EventParams: TStrings)
    begin
     TcxDBCheckBox(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TcxDBCheckBox(FD2BridgeItemVCLObj.Item).OnEnter) then
 FrameworkItemClass.OnEnter:=
    procedure(EventParams: TStrings)
    begin
     TcxDBCheckBox(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TcxDBCheckBox(FD2BridgeItemVCLObj.Item).OnExit) then
 FrameworkItemClass.OnExit:=
    procedure(EventParams: TStrings)
    begin
     TcxDBCheckBox(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TcxDBCheckBox(FD2BridgeItemVCLObj.Item).OnKeyDown) then
 FrameworkItemClass.OnKeyDown:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TcxDBCheckBox(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TcxDBCheckBox(FD2BridgeItemVCLObj.Item).OnKeyPress) then
 FrameworkItemClass.OnKeyPress:=
    procedure(EventParams: TStrings)
    var
      KeyPress: Char;
    begin
     KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
     TcxDBCheckBox(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
    end;

end;

procedure TVCLObjTcxDBCheckBox.ProcessPropertyClass(NewObj: TObject);
begin
 if Assigned(TcxDBCheckBox(FD2BridgeItemVCLObj.Item).DataBinding.DataSource) then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCheckBox.Dataware.DataSource:= TcxDBCheckBox(FD2BridgeItemVCLObj.Item).DataBinding.DataSource;

 if TcxDBCheckBox(FD2BridgeItemVCLObj.Item).DataBinding.DataField <> '' then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCheckBox.Dataware.DataField:= TcxDBCheckBox(FD2BridgeItemVCLObj.Item).DataBinding.DataField;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCheckBox.ValueChecked:= TcxDBCheckBox(FD2BridgeItemVCLObj.Item).Properties.ValueChecked;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCheckBox.ValueUnchecked:= TcxDBCheckBox(FD2BridgeItemVCLObj.Item).Properties.ValueUnchecked;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCheckBox.OnGetText:=
    function: Variant
    begin
     Result:= TcxDBCheckBox(FD2BridgeItemVCLObj.Item).Caption;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCheckBox.GetEnabled:=
    function: Variant
    begin
     Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCheckBox.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TcxDBCheckBox(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCheckBox.GetVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCheckBox.SetVisible:=
    procedure(AValue: Variant)
    begin
     TcxDBCheckBox(FD2BridgeItemVCLObj.Item).Visible:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCheckBox.GetReadOnly:=
    function: Variant
    begin
     Result:= TcxDBCheckBox(FD2BridgeItemVCLObj.Item).Properties.ReadOnly;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCheckBox.SetReadOnly:=
    procedure(AValue: Variant)
    begin
     TcxDBCheckBox(FD2BridgeItemVCLObj.Item).Properties.ReadOnly:= AValue;
    end;
end;

function TVCLObjTcxDBCheckBox.VCLClass: TClass;
begin
 Result:= TcxDBCheckBox;
end;

procedure TVCLObjTcxDBCheckBox.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TcxDBCheckBox(FD2BridgeItemVCLObj.Item).Style.Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize := TcxDBCheckBox(FD2BridgeItemVCLObj.Item).Style.Font.Size;

 if TcxDBCheckBox(FD2BridgeItemVCLObj.Item).Style.Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor := TcxDBCheckBox(FD2BridgeItemVCLObj.Item).Style.Font.Color;

 if TcxDBCheckBox(FD2BridgeItemVCLObj.Item).Style.Color <> clbtnFace then
  VCLObjStyle.Color := TcxDBCheckBox(FD2BridgeItemVCLObj.Item).Style.Color;

// if TcxDBCheckBox(FD2BridgeItemVCLObj.Item).Properties.Alignment.Horz <> DefaultAlignment then
//  VCLObjStyle.Alignment:= TcxDBCheckBox(FD2BridgeItemVCLObj.Item).Properties.Alignment.Horz;

 VCLObjStyle.FontStyles := TcxDBCheckBox(FD2BridgeItemVCLObj.Item).Style.Font.Style;
end;

{$ELSE}
implementation
{$ENDIF}

end.