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

unit D2Bridge.VCLObj.TcxDBComboBox;

interface

{$IFDEF DEVEXPRESS_AVAILABLE}
uses
  Classes,
  DBCtrls, Graphics,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTcxDBComboBox = class(TD2BridgeItemVCLObjCore)
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
  Prism.Util, D2Bridge.Util, D2Bridge.Forms, cxDBEdit, Forms, D2Bridge.Item.VCLObj.Style;

{ TVCLObjTcxDBComboBox }


function TVCLObjTcxDBComboBox.CSSClass: String;
begin
 result:= 'form-select';
end;

function TVCLObjTcxDBComboBox.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox;
end;

procedure TVCLObjTcxDBComboBox.ProcessEventClass;
begin
 if Assigned(TcxDBComboBox(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:=
    procedure(EventParams: TStrings)
    begin
     TcxDBComboBox(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TcxDBComboBox(FD2BridgeItemVCLObj.Item).OnEnter) then
 FrameworkItemClass.OnEnter:=
    procedure(EventParams: TStrings)
    begin
     TcxDBComboBox(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TcxDBComboBox(FD2BridgeItemVCLObj.Item).OnExit) then
 FrameworkItemClass.OnExit:=
    procedure(EventParams: TStrings)
    begin
     TcxDBComboBox(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TcxDBComboBox(FD2BridgeItemVCLObj.Item).Properties.OnChange) then
 FrameworkItemClass.OnChange:=
    procedure(EventParams: TStrings)
    begin
     TcxDBComboBox(FD2BridgeItemVCLObj.Item).Properties.OnChange(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TcxDBComboBox(FD2BridgeItemVCLObj.Item).OnKeyDown) then
 FrameworkItemClass.OnKeyDown:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TcxDBComboBox(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TcxDBComboBox(FD2BridgeItemVCLObj.Item).OnKeyUp) then
 FrameworkItemClass.OnKeyUp:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TcxDBComboBox(FD2BridgeItemVCLObj.Item).OnKeyUp(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TcxDBComboBox(FD2BridgeItemVCLObj.Item).OnKeyPress) then
 FrameworkItemClass.OnKeyPress:=
    procedure(EventParams: TStrings)
    var
      KeyPress: Char;
    begin
     KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
     TcxDBComboBox(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
    end;
end;

procedure TVCLObjTcxDBComboBox.ProcessPropertyClass(NewObj: TObject);
begin
 if Assigned(TcxDBComboBox(FD2BridgeItemVCLObj.Item).DataBinding.DataSource) then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.Dataware.DataSource:= TcxDBComboBox(FD2BridgeItemVCLObj.Item).DataBinding.DataSource;

 if TcxDBComboBox(FD2BridgeItemVCLObj.Item).DataBinding.DataField <> '' then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.Dataware.DataField:= TcxDBComboBox(FD2BridgeItemVCLObj.Item).DataBinding.DataField;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.ProcGetItems :=
    function: TStrings
    begin
     Result:= TcxDBComboBox(FD2BridgeItemVCLObj.Item).Properties.Items;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.GetEnabled:=
    function: Variant
    begin
     Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TcxDBComboBox(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.GetVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.SetVisible:=
    procedure(AValue: Variant)
    begin
     TcxDBComboBox(FD2BridgeItemVCLObj.Item).Visible:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.GetReadOnly:=
    function: Variant
    begin
     Result:= TcxDBComboBox(FD2BridgeItemVCLObj.Item).Properties.ReadOnly;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.SetReadOnly:=
    procedure(AValue: Variant)
    begin
     TcxDBComboBox(FD2BridgeItemVCLObj.Item).Properties.ReadOnly:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox.GetPlaceholder:=
    function: Variant
    begin
     if TcxDBComboBox(FD2BridgeItemVCLObj.Item).ShowHint then
      Result:= TcxDBComboBox(FD2BridgeItemVCLObj.Item).Hint
     else
      Result:= '';
    end;


// FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.Items(NewObj).Assign(TcxDBComboBox(FD2BridgeItemVCLObj.Item).Items);
end;

function TVCLObjTcxDBComboBox.PropertyCopyList: TStringList;
begin
 Result:= inherited;

 if Result.IndexOf('Text') >= 0 then
   Result.Delete(Result.IndexOf('Text'));
end;

function TVCLObjTcxDBComboBox.VCLClass: TClass;
begin
 Result:= TcxDBComboBox;
end;

procedure TVCLObjTcxDBComboBox.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TcxDBComboBox(FD2BridgeItemVCLObj.Item).Style.Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize := TcxDBComboBox(FD2BridgeItemVCLObj.Item).Style.Font.Size;

 if TcxDBComboBox(FD2BridgeItemVCLObj.Item).Style.Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor := TcxDBComboBox(FD2BridgeItemVCLObj.Item).Style.Font.Color;

 if TcxDBComboBox(FD2BridgeItemVCLObj.Item).Style.Color <> DefaultColor then
  VCLObjStyle.Color := TcxDBComboBox(FD2BridgeItemVCLObj.Item).Style.Color;

 if TcxDBComboBox(FD2BridgeItemVCLObj.Item).Properties.Alignment.Horz <> DefaultAlignment then
  VCLObjStyle.Alignment:= TcxDBComboBox(FD2BridgeItemVCLObj.Item).Properties.Alignment.Horz;

 VCLObjStyle.FontStyles := TcxDBComboBox(FD2BridgeItemVCLObj.Item).Style.Font.Style;
end;

{$ELSE}
implementation
{$ENDIF}

end.