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

{$I ..\D2Bridge.inc}

unit D2Bridge.VCLObj.TDBDateEdit;


interface

{$IFDEF RXLIB_AVAILABLE}
uses
  Classes,
  RXDBCtrl,
  Forms,  Graphics,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTDBDateEdit = class(TD2BridgeItemVCLObjCore)
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
  Prism.Util, D2Bridge.Util, D2Bridge.Item.VCLObj.Style;


{ TVCLObjTDBDateEdit }


function TVCLObjTDBDateEdit.CSSClass: String;
begin
 result:= 'form-control';
end;

function TVCLObjTDBDateEdit.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit;
end;

procedure TVCLObjTDBDateEdit.ProcessEventClass;
begin
 if Assigned(TDBDateEdit(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:=
    procedure(EventParams: TStrings)
    begin
     TDBDateEdit(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TDBDateEdit(FD2BridgeItemVCLObj.Item).OnEnter) then
 FrameworkItemClass.OnEnter:=
    procedure(EventParams: TStrings)
    begin
     TDBDateEdit(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TDBDateEdit(FD2BridgeItemVCLObj.Item).OnExit) then
 FrameworkItemClass.OnExit:=
    procedure(EventParams: TStrings)
    begin
     TDBDateEdit(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TDBDateEdit(FD2BridgeItemVCLObj.Item).OnChange) then
 FrameworkItemClass.OnChange:=
    procedure(EventParams: TStrings)
    begin
     TDBDateEdit(FD2BridgeItemVCLObj.Item).OnChange(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TDBDateEdit(FD2BridgeItemVCLObj.Item).OnKeyDown) then
 FrameworkItemClass.OnKeyDown:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TDBDateEdit(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TDBDateEdit(FD2BridgeItemVCLObj.Item).OnKeyUp) then
 FrameworkItemClass.OnKeyUp:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TDBDateEdit(FD2BridgeItemVCLObj.Item).OnKeyUp(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TDBDateEdit(FD2BridgeItemVCLObj.Item).OnKeyPress) then
 FrameworkItemClass.OnKeyPress:=
    procedure(EventParams: TStrings)
    var
      KeyPress: Char;
    begin
     KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
     TDBDateEdit(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
    end;
end;

procedure TVCLObjTDBDateEdit.ProcessPropertyClass(NewObj: TObject);
begin
 if Assigned(TDBDateEdit(FD2BridgeItemVCLObj.Item).DataSource) then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.Dataware.DataSource:= TDBDateEdit(FD2BridgeItemVCLObj.Item).DataSource;

 if TDBDateEdit(FD2BridgeItemVCLObj.Item).DataField <> '' then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.Dataware.DataField:= TDBDateEdit(FD2BridgeItemVCLObj.Item).DataField;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.GetEnabled:=
    function: Variant
    begin
     Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TDBDateEdit(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.GetVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.SetVisible:=
    procedure(AValue: Variant)
    begin
     TDBDateEdit(FD2BridgeItemVCLObj.Item).Visible:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.GetReadOnly:=
    function: Variant
    begin
     Result:= TDBDateEdit(FD2BridgeItemVCLObj.Item).ReadOnly;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.SetReadOnly:=
    procedure(AValue: Variant)
    begin
     TDBDateEdit(FD2BridgeItemVCLObj.Item).ReadOnly:= AValue;
    end;
end;

function TVCLObjTDBDateEdit.VCLClass: TClass;
begin
 Result:= TDBDateEdit;
end;

Procedure TVCLObjTDBDateEdit.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TDBDateEdit(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize := TDBDateEdit(FD2BridgeItemVCLObj.Item).Font.Size;

 if TDBDateEdit(FD2BridgeItemVCLObj.Item).Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor := TDBDateEdit(FD2BridgeItemVCLObj.Item).Font.Color;

 if TDBDateEdit(FD2BridgeItemVCLObj.Item).Color <> DefaultColor then
  VCLObjStyle.Color := TDBDateEdit(FD2BridgeItemVCLObj.Item).Color;

 VCLObjStyle.FontStyles := TDBDateEdit(FD2BridgeItemVCLObj.Item).Font.Style;

end;

{$ELSE}
implementation
{$ENDIF}

end.