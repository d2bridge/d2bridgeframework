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
    Daniel Hondo Tedesque
    Email: daniel@uniontech.eti.br
 +--------------------------------------------------------------------------+
}

{$I ..\D2Bridge.inc}

unit D2Bridge.VCLObj.TJvDBDateEdit;


interface

{$IFDEF JVCL_AVAILABLE}
uses
  Classes,
  Forms, Graphics, JvExMask, JvToolEdit, JvBaseEdits, JvDBControls,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTJvDBDateEdit = class(TD2BridgeItemVCLObjCore)
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
  Prism.Types, Prism.Util, D2Bridge.Util, D2Bridge.Item.VCLObj.Style;


{ TVCLObjTJvDBDateEdit }


function TVCLObjTJvDBDateEdit.CSSClass: String;
begin
 result:= 'form-control';
end;

function TVCLObjTJvDBDateEdit.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit;
end;

procedure TVCLObjTJvDBDateEdit.ProcessEventClass;
begin
 if Assigned(TJvDBDateEdit(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:=
    procedure(EventParams: TStrings)
    begin
     TJvDBDateEdit(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TJvDBDateEdit(FD2BridgeItemVCLObj.Item).OnEnter) then
 FrameworkItemClass.OnEnter:=
    procedure(EventParams: TStrings)
    begin
     TJvDBDateEdit(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TJvDBDateEdit(FD2BridgeItemVCLObj.Item).OnExit) then
 FrameworkItemClass.OnExit:=
    procedure(EventParams: TStrings)
    begin
     TJvDBDateEdit(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TJvDBDateEdit(FD2BridgeItemVCLObj.Item).OnChange) then
 FrameworkItemClass.OnChange:=
    procedure(EventParams: TStrings)
    begin
     TJvDBDateEdit(FD2BridgeItemVCLObj.Item).OnChange(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TJvDBDateEdit(FD2BridgeItemVCLObj.Item).OnKeyDown) then
 FrameworkItemClass.OnKeyDown:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TJvDBDateEdit(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TJvDBDateEdit(FD2BridgeItemVCLObj.Item).OnKeyUp) then
 FrameworkItemClass.OnKeyUp:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TJvDBDateEdit(FD2BridgeItemVCLObj.Item).OnKeyUp(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TJvDBDateEdit(FD2BridgeItemVCLObj.Item).OnKeyPress) then
 FrameworkItemClass.OnKeyPress:=
    procedure(EventParams: TStrings)
    var
      KeyPress: Char;
    begin
     KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
     TJvDBDateEdit(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
    end;
end;

procedure TVCLObjTJvDBDateEdit.ProcessPropertyClass(NewObj: TObject);
begin
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.DataType:= PrismFieldTypeDate;

 if Assigned(TJvDBDateEdit(FD2BridgeItemVCLObj.Item).DataSource) then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.Dataware.DataSource:= TJvDBDateEdit(FD2BridgeItemVCLObj.Item).DataSource;

 if TJvDBDateEdit(FD2BridgeItemVCLObj.Item).DataField <> '' then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.Dataware.DataField:= TJvDBDateEdit(FD2BridgeItemVCLObj.Item).DataField;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.GetEnabled:=
    function: Variant
    begin
     Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TJvDBDateEdit(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.GetVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.SetVisible:=
    procedure(AValue: Variant)
    begin
     TJvDBDateEdit(FD2BridgeItemVCLObj.Item).Visible:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.GetReadOnly:=
    function: Variant
    begin
     Result:= TJvDBDateEdit(FD2BridgeItemVCLObj.Item).ReadOnly;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.SetReadOnly:=
    procedure(AValue: Variant)
    begin
     TJvDBDateEdit(FD2BridgeItemVCLObj.Item).ReadOnly:= AValue;
    end;
end;

function TVCLObjTJvDBDateEdit.VCLClass: TClass;
begin
 Result:= TJvDBDateEdit;
end;

Procedure TVCLObjTJvDBDateEdit.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TJvDBDateEdit(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize := TJvDBDateEdit(FD2BridgeItemVCLObj.Item).Font.Size;

 if TJvDBDateEdit(FD2BridgeItemVCLObj.Item).Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor := TJvDBDateEdit(FD2BridgeItemVCLObj.Item).Font.Color;

 if TJvDBDateEdit(FD2BridgeItemVCLObj.Item).Color <> clWindow then
  VCLObjStyle.Color := TJvDBDateEdit(FD2BridgeItemVCLObj.Item).Color;

 VCLObjStyle.FontStyles := TJvDBDateEdit(FD2BridgeItemVCLObj.Item).Font.Style;

end;

{$ELSE}
implementation
{$ENDIF}

end.