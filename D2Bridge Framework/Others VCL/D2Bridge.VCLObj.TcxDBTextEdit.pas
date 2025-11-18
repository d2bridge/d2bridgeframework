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

unit D2Bridge.VCLObj.TcxDBTextEdit;


interface

{$IFDEF DEVEXPRESS_AVAILABLE}
uses
  Classes,
  DBCtrls, Graphics,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTcxDBTextEdit = class(TD2BridgeItemVCLObjCore)
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
  Prism.Util, D2Bridge.Util, Prism.Types, cxDBEdit, Forms, D2Bridge.Item.VCLObj.Style;


{ TVCLObjTcxDBTextEdit }


function TVCLObjTcxDBTextEdit.CSSClass: String;
begin
 result:= 'form-control';
end;

function TVCLObjTcxDBTextEdit.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit;
end;

procedure TVCLObjTcxDBTextEdit.ProcessEventClass;
begin
 if Assigned(TcxDBTextEdit(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:=
    procedure(EventParams: TStrings)
    begin
     TcxDBTextEdit(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TcxDBTextEdit(FD2BridgeItemVCLObj.Item).OnEnter) then
 FrameworkItemClass.OnEnter:=
    procedure(EventParams: TStrings)
    begin
     TcxDBTextEdit(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TcxDBTextEdit(FD2BridgeItemVCLObj.Item).OnExit) then
 FrameworkItemClass.OnExit:=
    procedure(EventParams: TStrings)
    begin
     TcxDBTextEdit(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TcxDBTextEdit(FD2BridgeItemVCLObj.Item).Properties.OnChange) then
 FrameworkItemClass.OnChange:=
    procedure(EventParams: TStrings)
    begin
     TcxDBTextEdit(FD2BridgeItemVCLObj.Item).Properties.OnChange(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TcxDBTextEdit(FD2BridgeItemVCLObj.Item).OnKeyDown) then
 FrameworkItemClass.OnKeyDown:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TcxDBTextEdit(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TcxDBTextEdit(FD2BridgeItemVCLObj.Item).OnKeyUp) then
 FrameworkItemClass.OnKeyUp:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TcxDBTextEdit(FD2BridgeItemVCLObj.Item).OnKeyUp(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TcxDBTextEdit(FD2BridgeItemVCLObj.Item).OnKeyPress) then
 FrameworkItemClass.OnKeyPress:=
    procedure(EventParams: TStrings)
    var
      KeyPress: Char;
    begin
     KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
     TcxDBTextEdit(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
    end;
end;

procedure TVCLObjTcxDBTextEdit.ProcessPropertyClass(NewObj: TObject);
begin
 if Assigned(TcxDBTextEdit(FD2BridgeItemVCLObj.Item).DataBinding.DataSource) then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.Dataware.DataSource:= TcxDBTextEdit(FD2BridgeItemVCLObj.Item).DataBinding.DataSource;

 if TcxDBTextEdit(FD2BridgeItemVCLObj.Item).DataBinding.DataField <> '' then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.Dataware.DataField:= TcxDBTextEdit(FD2BridgeItemVCLObj.Item).DataBinding.DataField;

 if TcxDBTextEdit(FD2BridgeItemVCLObj.Item).Properties.PasswordChar <> #0 then
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.DataType:= PrismFieldTypePassword;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.CharCase:= TcxDBTextEdit(FD2BridgeItemVCLObj.Item).Properties.CharCase;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.GetEnabled:=
    function: Variant
    begin
     Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TcxDBTextEdit(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.GetVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.SetVisible:=
    procedure(AValue: Variant)
    begin
     TcxDBTextEdit(FD2BridgeItemVCLObj.Item).Visible:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.GetReadOnly:=
    function: Variant
    begin
     Result:= TcxDBTextEdit(FD2BridgeItemVCLObj.Item).Properties.ReadOnly;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.SetReadOnly:=
    procedure(AValue: Variant)
    begin
     TcxDBTextEdit(FD2BridgeItemVCLObj.Item).Properties.ReadOnly:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.GetPlaceholder:=
    function: Variant
    begin
     if TcxDBTextEdit(FD2BridgeItemVCLObj.Item).ShowHint then
      Result:= TcxDBTextEdit(FD2BridgeItemVCLObj.Item).Hint
     else
      Result:= '';
    end;

end;

function TVCLObjTcxDBTextEdit.VCLClass: TClass;
begin
 Result:= TcxDBTextEdit;
end;

procedure TVCLObjTcxDBTextEdit.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TcxDBTextEdit(FD2BridgeItemVCLObj.Item).Style.Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize := TcxDBTextEdit(FD2BridgeItemVCLObj.Item).Style.Font.Size;

 if TcxDBTextEdit(FD2BridgeItemVCLObj.Item).Style.Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor := TcxDBTextEdit(FD2BridgeItemVCLObj.Item).Style.Font.Color;

 if TcxDBTextEdit(FD2BridgeItemVCLObj.Item).Style.Color <> DefaultColor then
  VCLObjStyle.Color := TcxDBTextEdit(FD2BridgeItemVCLObj.Item).Style.Color;

 if TcxDBTextEdit(FD2BridgeItemVCLObj.Item).Properties.Alignment.Horz <> DefaultAlignment then
  VCLObjStyle.Alignment:= TcxDBTextEdit(FD2BridgeItemVCLObj.Item).Properties.Alignment.Horz;

 VCLObjStyle.FontStyles := TcxDBTextEdit(FD2BridgeItemVCLObj.Item).Style.Font.Style;
end;

{$ELSE}
implementation
{$ENDIF}

end.