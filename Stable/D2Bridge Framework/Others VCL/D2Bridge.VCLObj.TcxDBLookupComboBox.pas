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

unit D2Bridge.VCLObj.TcxDBLookupComboBox;

interface

{$IFDEF DEVEXPRESS_AVAILABLE}
uses
  Classes, Graphics,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTcxDBLookupComboBox = class(TD2BridgeItemVCLObjCore)
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
  SysUtils, DBCtrls, Prism.Util, D2Bridge.Util, cxDBLookupComboBox,
  Forms, D2Bridge.Item.VCLObj.Style;

{ TVCLObjTcxDBLookupComboBox }


function TVCLObjTcxDBLookupComboBox.CSSClass: String;
begin
 result:= 'form-select';
end;

function TVCLObjTcxDBLookupComboBox.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox;
end;

procedure TVCLObjTcxDBLookupComboBox.ProcessEventClass;
begin
 if Assigned(TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:=
    procedure(EventParams: TStrings)
    begin
     TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).OnEnter) then
 FrameworkItemClass.OnEnter:=
    procedure(EventParams: TStrings)
    begin
     TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).OnExit) then
 FrameworkItemClass.OnExit:=
    procedure(EventParams: TStrings)
    begin
     TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).OnKeyDown) then
 FrameworkItemClass.OnKeyDown:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).OnKeyPress) then
 FrameworkItemClass.OnKeyPress:=
    procedure(EventParams: TStrings)
    var
      KeyPress: Char;
    begin
     KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
     TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
    end;
end;

procedure TVCLObjTcxDBLookupComboBox.ProcessPropertyClass(NewObj: TObject);
begin
 if Assigned(TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).DataBinding.DataSource) then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.DataSource.DataSource:= TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).DataBinding.DataSource;

 if (TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).DataBinding.DataField <> '') then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.DataSource.DataField:= TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).DataBinding.DataField;

 if Assigned(TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).Properties.ListSource) then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.ListSource.ListSource:= TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).Properties.ListSource;

 if (TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).Properties.ListFieldNames <> '') then
 if AnsiPos(';', TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).Properties.ListFieldNames) > 0 then
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.ListSource.ListField:= Copy(TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).Properties.ListFieldNames, 0, AnsiPos(';', TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).Properties.ListFieldNames) -1)
 else
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.ListSource.ListField:= TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).Properties.ListFieldNames;

 if (TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).Properties.KeyFieldNames <> '') then
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.ListSource.KeyField:= TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).Properties.KeyFieldNames;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.OnSetText:=
    procedure(AValue: Variant)
    begin
     if AValue <> '' then
     TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).EditValue:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.GetEnabled:=
    function: Variant
    begin
     Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.GetVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.SetVisible:=
    procedure(AValue: Variant)
    begin
     TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).Visible:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.GetReadOnly:=
    function: Variant
    begin
     Result:= TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).Properties.ReadOnly;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.SetReadOnly:=
    procedure(AValue: Variant)
    begin
     TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).Properties.ReadOnly:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.GetPlaceholder:=
    function: Variant
    begin
     if TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).ShowHint then
      Result:= TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).Hint
     else
      Result:= '';
    end;

end;

function TVCLObjTcxDBLookupComboBox.PropertyCopyList: TStringList;
begin
 Result:= inherited;

 if Result.IndexOf('Text') >= 0 then
   Result.Delete(Result.IndexOf('Text'));
end;

function TVCLObjTcxDBLookupComboBox.VCLClass: TClass;
begin
 Result:= TcxDBLookupComboBox;
end;

procedure TVCLObjTcxDBLookupComboBox.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).Style.Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize := TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).Style.Font.Size;

 if TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).Style.Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor := TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).Style.Font.Color;

 if TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).Style.Color <> DefaultColor then
  VCLObjStyle.Color := TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).Style.Color;

 if TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).Properties.Alignment.Horz <> DefaultAlignment then
  VCLObjStyle.Alignment:= TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).Properties.Alignment.Horz;

 VCLObjStyle.FontStyles := TcxDBLookupComboBox(FD2BridgeItemVCLObj.Item).Style.Font.Style;
end;

{$ELSE}
implementation
{$ENDIF}

end.