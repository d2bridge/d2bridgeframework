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
    Daniel Alisson Suart
    Email: contato@deuxsoftware.com.br
 +--------------------------------------------------------------------------+
}

{$I ..\D2Bridge.inc}

unit D2Bridge.VCLObj.TwwDBRichEdit;

interface

{$IFDEF INFOPOWER_AVAILABLE}
uses
  Classes,
  DBCtrls, Graphics,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTwwDBRichEdit = class(TD2BridgeItemVCLObjCore)
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
  Prism.Util, D2Bridge.Util, vcl.wwriched, ComCtrls, Forms, D2Bridge.Item.VCLObj.Style;

{ TVCLObjTwwDBRichEdit }


function TVCLObjTwwDBRichEdit.CSSClass: String;
begin
 result:= 'form-control';
end;

function TVCLObjTwwDBRichEdit.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBMemo;
end;

procedure TVCLObjTwwDBRichEdit.ProcessEventClass;
begin
 if Assigned(TwwDBRichEdit(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:=
    procedure(EventParams: TStrings)
    begin
     TwwDBRichEdit(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwDBRichEdit(FD2BridgeItemVCLObj.Item).OnEnter) then
 FrameworkItemClass.OnEnter:=
    procedure(EventParams: TStrings)
    begin
     TwwDBRichEdit(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwDBRichEdit(FD2BridgeItemVCLObj.Item).OnExit) then
 FrameworkItemClass.OnExit:=
    procedure(EventParams: TStrings)
    begin
     TwwDBRichEdit(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwDBRichEdit(FD2BridgeItemVCLObj.Item).OnChange) then
 FrameworkItemClass.OnChange:=
    procedure(EventParams: TStrings)
    begin
     TwwDBRichEdit(FD2BridgeItemVCLObj.Item).OnChange(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwDBRichEdit(FD2BridgeItemVCLObj.Item).OnKeyUp) then
 FrameworkItemClass.OnKeyUp:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TwwDBRichEdit(FD2BridgeItemVCLObj.Item).OnKeyUp(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TwwDBRichEdit(FD2BridgeItemVCLObj.Item).OnKeyDown) then
 FrameworkItemClass.OnKeyDown:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TwwDBRichEdit(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TwwDBRichEdit(FD2BridgeItemVCLObj.Item).OnKeyPress) then
 FrameworkItemClass.OnKeyPress:=
    procedure(EventParams: TStrings)
    var
      KeyPress: Char;
    begin
     KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
     TwwDBRichEdit(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
    end;
end;

procedure TVCLObjTwwDBRichEdit.ProcessPropertyClass(NewObj: TObject);
begin
 if Assigned(TwwDBRichEdit(FD2BridgeItemVCLObj.Item).DataSource) then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBMemo.Dataware.DataSource:= TwwDBRichEdit(FD2BridgeItemVCLObj.Item).DataSource;

 if TwwDBRichEdit(FD2BridgeItemVCLObj.Item).DataField <> '' then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBMemo.Dataware.DataField:= TwwDBRichEdit(FD2BridgeItemVCLObj.Item).DataField;


 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBMemo.GetEnabled:=
    function: Variant
    begin
     Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBMemo.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TwwDBRichEdit(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBMemo.GetVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBMemo.SetVisible:=
    procedure(AValue: Variant)
    begin
     TwwDBRichEdit(FD2BridgeItemVCLObj.Item).Visible:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBMemo.GetReadOnly:=
    function: Variant
    begin
     Result:= TwwDBRichEdit(FD2BridgeItemVCLObj.Item).ReadOnly;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBMemo.SetReadOnly:=
    procedure(AValue: Variant)
    begin
     TwwDBRichEdit(FD2BridgeItemVCLObj.Item).ReadOnly:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBMemo.GetPlaceholder:=
    function: Variant
    begin
     if TwwDBRichEdit(FD2BridgeItemVCLObj.Item).ShowHint then
      Result:= TwwDBRichEdit(FD2BridgeItemVCLObj.Item).Hint
     else
      Result:= '';
    end;

// FrameworkItemClass.ProcessPropertyByName(FD2BridgeItemVCLObj.Item, NewObj, 'ReadOnly', TwwDBRichEdit(FD2BridgeItemVCLObj.Item).ReadOnly);
end;

function TVCLObjTwwDBRichEdit.VCLClass: TClass;
begin
 Result:= TwwDBRichEdit;
end;

procedure TVCLObjTwwDBRichEdit.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TwwDBRichEdit(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize := TwwDBRichEdit(FD2BridgeItemVCLObj.Item).Font.Size;

 if TwwDBRichEdit(FD2BridgeItemVCLObj.Item).Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor := TwwDBRichEdit(FD2BridgeItemVCLObj.Item).Font.Color;

 if TwwDBRichEdit(FD2BridgeItemVCLObj.Item).Color <> clWindow then
  VCLObjStyle.Color := TwwDBRichEdit(FD2BridgeItemVCLObj.Item).Color;

 if TwwDBRichEdit(FD2BridgeItemVCLObj.Item).Alignment <> DefaultAlignment then
  VCLObjStyle.Alignment:= TwwDBRichEdit(FD2BridgeItemVCLObj.Item).Alignment;

 VCLObjStyle.FontStyles := TwwDBRichEdit(FD2BridgeItemVCLObj.Item).Font.Style;
end;

{$ELSE}
implementation
{$ENDIF}

end.