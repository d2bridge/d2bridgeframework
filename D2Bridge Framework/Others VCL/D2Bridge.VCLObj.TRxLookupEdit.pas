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

unit D2Bridge.VCLObj.TRxLookupEdit;


interface

{$IFDEF RXLIB_AVAILABLE}
uses
  Classes,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTRxLookupEdit = class(TD2BridgeItemVCLObjCore)
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
  SysUtils, RxLookup, D2Bridge.Util, Prism.Util, D2Bridge.Item.VCLObj.Style;


{ TVCLObjTRxLookupEdit }


function TVCLObjTRxLookupEdit.CSSClass: String;
begin
 result:= 'form-select';
end;

function TVCLObjTRxLookupEdit.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox;
end;

procedure TVCLObjTRxLookupEdit.ProcessEventClass;
begin
 if Assigned(TRxLookupEdit(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:=
    procedure(EventParams: TStrings)
    begin
     TRxLookupEdit(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TRxLookupEdit(FD2BridgeItemVCLObj.Item).OnEnter) then
 FrameworkItemClass.OnEnter:=
    procedure(EventParams: TStrings)
    begin
     TRxLookupEdit(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TRxLookupEdit(FD2BridgeItemVCLObj.Item).OnExit) then
 FrameworkItemClass.OnExit:=
    procedure(EventParams: TStrings)
    begin
     TRxLookupEdit(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TRxLookupEdit(FD2BridgeItemVCLObj.Item).OnKeyDown) then
 FrameworkItemClass.OnKeyDown:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TRxLookupEdit(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TRxLookupEdit(FD2BridgeItemVCLObj.Item).OnKeyUp) then
 FrameworkItemClass.OnKeyUp:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TRxLookupEdit(FD2BridgeItemVCLObj.Item).OnKeyUp(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TRxLookupEdit(FD2BridgeItemVCLObj.Item).OnKeyPress) then
 FrameworkItemClass.OnKeyPress:=
    procedure(EventParams: TStrings)
    var
      KeyPress: Char;
    begin
     KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
     TRxLookupEdit(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
    end;
end;

procedure TVCLObjTRxLookupEdit.ProcessPropertyClass(NewObj: TObject);
begin
 if Assigned(TRXLookupEdit(FD2BridgeItemVCLObj.Item).LookupSource) then
 (FrameworkItemClass as ID2BridgeFrameworkItemDBLookupCombobox).Dataware.ListSource.ListSource:= TRXLookupEdit(FD2BridgeItemVCLObj.Item).LookupSource;

 if (TRXLookupEdit(FD2BridgeItemVCLObj.Item).LookupDisplay <> '') then
 if AnsiPos(';', TRXLookupEdit(FD2BridgeItemVCLObj.Item).LookupDisplay) > 0 then
  (FrameworkItemClass as ID2BridgeFrameworkItemDBLookupCombobox).Dataware.ListSource.ListField:= Copy(TRXLookupEdit(FD2BridgeItemVCLObj.Item).LookupDisplay, 0, AnsiPos(';', TRXLookupEdit(FD2BridgeItemVCLObj.Item).LookupDisplay) -1)
 else
  (FrameworkItemClass as ID2BridgeFrameworkItemDBLookupCombobox).Dataware.ListSource.ListField:= TRXLookupEdit(FD2BridgeItemVCLObj.Item).LookupDisplay;

 if (TRXLookupEdit(FD2BridgeItemVCLObj.Item).LookupField <> '') then
  (FrameworkItemClass as ID2BridgeFrameworkItemDBLookupCombobox).Dataware.ListSource.KeyField:= TRXLookupEdit(FD2BridgeItemVCLObj.Item).LookupField;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.OnGetText:=
    function: Variant
    begin
     Result:= TRxLookupEdit(FD2BridgeItemVCLObj.Item).LookupValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.OnSetText:=
    procedure(AValue: Variant)
    begin
     TRxLookupEdit(FD2BridgeItemVCLObj.Item).LookupValue:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.GetEnabled:=
    function: Variant
    begin
     Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TRxLookupEdit(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.GetVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.SetVisible:=
    procedure(AValue: Variant)
    begin
     TRxLookupEdit(FD2BridgeItemVCLObj.Item).Visible:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.GetReadOnly:=
    function: Variant
    begin
     Result:= TRxLookupEdit(FD2BridgeItemVCLObj.Item).ReadOnly;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.SetReadOnly:=
    procedure(AValue: Variant)
    begin
     TRxLookupEdit(FD2BridgeItemVCLObj.Item).ReadOnly:= AValue;
    end;
end;

function TVCLObjTRxLookupEdit.VCLClass: TClass;
begin
 Result:= TRxLookupEdit;
end;

Procedure TVCLObjTRxLookupEdit.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin

end;

{$ELSE}
implementation
{$ENDIF}

end.