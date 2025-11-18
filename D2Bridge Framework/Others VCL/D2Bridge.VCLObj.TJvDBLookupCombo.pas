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

unit D2Bridge.VCLObj.TJvDBLookupCombo;

interface

{$IFDEF JVCL_AVAILABLE}
uses
  Classes, SysUtils, Forms, Graphics, JvDBLookup,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTJvDBLookupCombo = class(TD2BridgeItemVCLObjCore)
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
  DBCtrls,
  Prism.Util, D2Bridge.Util, D2Bridge.Item.VCLObj.Style;

{ TVCLObjTJvDBLookupCombo }


function TVCLObjTJvDBLookupCombo.CSSClass: String;
begin
 result:= 'form-select';
end;

function TVCLObjTJvDBLookupCombo.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox;
end;

procedure TVCLObjTJvDBLookupCombo.ProcessEventClass;
begin
 if Assigned(TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:=
    procedure(EventParams: TStrings)
    begin
     TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).OnEnter) then
 FrameworkItemClass.OnEnter:=
    procedure(EventParams: TStrings)
    begin
     TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).OnExit) then
 FrameworkItemClass.OnExit:=
    procedure(EventParams: TStrings)
    begin
     TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).OnKeyDown) then
 FrameworkItemClass.OnKeyDown:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).OnKeyPress) then
 FrameworkItemClass.OnKeyPress:=
    procedure(EventParams: TStrings)
    var
      KeyPress: Char;
    begin
     KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
     TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
    end;
end;

procedure TVCLObjTJvDBLookupCombo.ProcessPropertyClass(NewObj: TObject);
begin
 if Assigned(TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).DataSource) then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.DataSource.DataSource:= TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).DataSource;

 if (TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).DataField <> '') then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.DataSource.DataField:= TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).DataField;

 if Assigned(TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).LookupSource) then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.ListSource.ListSource:= TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).LookupSource;

 if (TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).LookupDisplay <> '') then
 if AnsiPos(';', TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).LookupDisplay) > 0 then
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.ListSource.ListField:= Copy(TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).LookupDisplay, AnsiPos(';', TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).LookupDisplay) + 1, Length(TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).LookupDisplay) - AnsiPos(';', TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).LookupDisplay))
 else
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.ListSource.ListField:= TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).LookupDisplay;

 if (TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).LookupField <> '') then
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.ListSource.KeyField:= TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).LookupField;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.OnGetText:=
    function: Variant
    begin
     Result:= TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).KeyValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.OnSetText:=
    procedure(AValue: Variant)
    begin
     if AValue <> '' then
     TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).KeyValue:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.GetEnabled:=
    function: Variant
    begin
     Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.GetVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.SetVisible:=
    procedure(AValue: Variant)
    begin
     TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).Visible:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.GetReadOnly:=
    function: Variant
    begin
     Result:= TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).ReadOnly;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.SetReadOnly:=
    procedure(AValue: Variant)
    begin
     TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).ReadOnly:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.GetPlaceholder:=
    function: Variant
    begin
     if TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).ShowHint then
      Result:= TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).Hint
     else
      Result:= '';
    end;

end;

function TVCLObjTJvDBLookupCombo.PropertyCopyList: TStringList;
begin
 Result:= inherited;

 if Result.IndexOf('Text') >= 0 then
   Result.Delete(Result.IndexOf('Text'));
end;

function TVCLObjTJvDBLookupCombo.VCLClass: TClass;
begin
 Result:= TJvDBLookupCombo;
end;

procedure TVCLObjTJvDBLookupCombo.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).Font.Size <> Application.DefaultFont.Size then
  VCLObjStyle.FontSize := TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).Font.Size;

 if (TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).Font.Color <> clWindowText) then
  VCLObjStyle.FontColor := TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).Font.Color;

 if TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).Color <> DefaultColor then
  VCLObjStyle.Color := TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).Color;

 VCLObjStyle.FontStyles := TJvDBLookupCombo(FD2BridgeItemVCLObj.Item).Font.Style;
end;

{$ELSE}
implementation
{$ENDIF}

end.