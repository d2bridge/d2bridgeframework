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

unit D2Bridge.VCLObj.TJvDBCombobox;

interface

{$IFDEF JVCL_AVAILABLE}
uses
  Classes,
  DBCtrls, Forms, Graphics, JvDBCombobox,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTJvDBCombobox = class(TD2BridgeItemVCLObjCore)
  public
   function VCLClass: TClass; override;
   function CSSClass: String; override;
   Procedure VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle); override;
   procedure ProcessPropertyClass(NewObj: TObject); override;
   procedure ProcessEventClass; override;
   function PropertyCopyList: TStringList; override;
   function FrameworkItemClass: ID2BridgeFrameworkItem; override;
 end;

implementation

uses
  Prism.Util, D2Bridge.Util, D2Bridge.Forms, D2Bridge.Item.VCLObj.Style;

{ TVCLObjTJvDBCombobox }


function TVCLObjTJvDBCombobox.CSSClass: String;
begin
 result:= 'form-select';
end;

function TVCLObjTJvDBCombobox.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox;
end;

procedure TVCLObjTJvDBCombobox.ProcessEventClass;
begin
 if Assigned(TJvDBCombobox(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:=
    procedure(EventParams: TStrings)
    begin
     TJvDBCombobox(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TJvDBCombobox(FD2BridgeItemVCLObj.Item).OnDblClick) then
 FrameworkItemClass.OnDblClick:=
    procedure(EventParams: TStrings)
    begin
     TJvDBCombobox(FD2BridgeItemVCLObj.Item).OnDblClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TJvDBCombobox(FD2BridgeItemVCLObj.Item).OnEnter) then
 FrameworkItemClass.OnEnter:=
    procedure(EventParams: TStrings)
    begin
     TJvDBCombobox(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TJvDBCombobox(FD2BridgeItemVCLObj.Item).OnExit) then
 FrameworkItemClass.OnExit:=
    procedure(EventParams: TStrings)
    begin
     TJvDBCombobox(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TJvDBCombobox(FD2BridgeItemVCLObj.Item).OnChange) then
 FrameworkItemClass.OnChange:=
    procedure(EventParams: TStrings)
    begin
     TJvDBCombobox(FD2BridgeItemVCLObj.Item).OnChange(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TJvDBCombobox(FD2BridgeItemVCLObj.Item).OnKeyDown) then
 FrameworkItemClass.OnKeyDown:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TJvDBCombobox(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TJvDBCombobox(FD2BridgeItemVCLObj.Item).OnKeyUp) then
 FrameworkItemClass.OnKeyUp:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TJvDBCombobox(FD2BridgeItemVCLObj.Item).OnKeyUp(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TJvDBCombobox(FD2BridgeItemVCLObj.Item).OnKeyPress) then
 FrameworkItemClass.OnKeyPress:=
    procedure(EventParams: TStrings)
    var
      KeyPress: Char;
    begin
     KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
     TJvDBCombobox(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
    end;
end;

procedure TVCLObjTJvDBCombobox.ProcessPropertyClass(NewObj: TObject);
begin
 if Assigned(TJvDBCombobox(FD2BridgeItemVCLObj.Item).DataSource) then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.Dataware.DataSource:= TJvDBCombobox(FD2BridgeItemVCLObj.Item).DataSource;

 if TJvDBCombobox(FD2BridgeItemVCLObj.Item).DataField <> '' then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.Dataware.DataField:= TJvDBCombobox(FD2BridgeItemVCLObj.Item).DataField;

 //Need to fix error in Nested
 TJvDBCombobox(FD2BridgeItemVCLObj.Item).DataSource:= nil;
 TJvDBCombobox(FD2BridgeItemVCLObj.Item).DataField:= '';

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.ProcGetItems :=
    function: TStrings
    begin
     Result:= TJvDBCombobox(FD2BridgeItemVCLObj.Item).Items;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.GetEnabled:=
    function: Variant
    begin
     Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TJvDBCombobox(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.GetVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.SetVisible:=
    procedure(AValue: Variant)
    begin
     TJvDBCombobox(FD2BridgeItemVCLObj.Item).Visible:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.GetReadOnly:=
    function: Variant
    begin
     Result:= TJvDBCombobox(FD2BridgeItemVCLObj.Item).ReadOnly;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.SetReadOnly:=
    procedure(AValue: Variant)
    begin
     TJvDBCombobox(FD2BridgeItemVCLObj.Item).ReadOnly:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox.GetPlaceholder:=
    function: Variant
    begin
     if TJvDBCombobox(FD2BridgeItemVCLObj.Item).TextHint <> '' then
      Result:= TJvDBCombobox(FD2BridgeItemVCLObj.Item).TextHint
     else
     if TJvDBCombobox(FD2BridgeItemVCLObj.Item).ShowHint then
      Result:= TJvDBCombobox(FD2BridgeItemVCLObj.Item).Hint
     else
      Result:= '';
    end;


// FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.Items(NewObj).Assign(TJvDBCombobox(FD2BridgeItemVCLObj.Item).Items);
end;

function TVCLObjTJvDBCombobox.PropertyCopyList: TStringList;
begin
 Result:= inherited;

 if Result.IndexOf('Text') >= 0 then
   Result.Delete(Result.IndexOf('Text'));
end;

function TVCLObjTJvDBCombobox.VCLClass: TClass;
begin
 Result:= TJvDBCombobox;
end;

procedure TVCLObjTJvDBCombobox.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TJvDBCombobox(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize := TJvDBCombobox(FD2BridgeItemVCLObj.Item).Font.Size;

 if TJvDBCombobox(FD2BridgeItemVCLObj.Item).Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor := TJvDBCombobox(FD2BridgeItemVCLObj.Item).Font.Color;

 if TJvDBCombobox(FD2BridgeItemVCLObj.Item).Color <> clWindow then
  VCLObjStyle.Color := TJvDBCombobox(FD2BridgeItemVCLObj.Item).Color;

 VCLObjStyle.FontStyles := TJvDBCombobox(FD2BridgeItemVCLObj.Item).Font.Style;
end;

{$ELSE}
implementation
{$ENDIF}

end.