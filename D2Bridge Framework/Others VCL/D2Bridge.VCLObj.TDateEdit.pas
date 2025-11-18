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

unit D2Bridge.VCLObj.TDateEdit;


interface

{$IFDEF RXLIB_AVAILABLE}
uses
  Classes, SysUtils, Forms, Graphics,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTDateEdit = class(TD2BridgeItemVCLObjCore)
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
  Vcl.StdCtrls, Vcl.ComCtrls, Prism.Util, Prism.Types, D2Bridge.Util, D2Bridge.Item.VCLObj.Style, RxToolEdit;

{ TVCLObjTDateEdit }


function TVCLObjTDateEdit.CSSClass: String;
begin
 result:= 'form-control';
end;

function TVCLObjTDateEdit.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit;
end;

procedure TVCLObjTDateEdit.ProcessEventClass;
begin
 if Assigned(TDateEdit(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:=
    procedure(EventParams: TStrings)
    begin
     TDateEdit(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TDateEdit(FD2BridgeItemVCLObj.Item).OnEnter) then
 FrameworkItemClass.OnEnter:=
    procedure(EventParams: TStrings)
    begin
     TDateEdit(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TDateEdit(FD2BridgeItemVCLObj.Item).OnExit) then
 FrameworkItemClass.OnExit:=
    procedure(EventParams: TStrings)
    begin
     TDateEdit(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TDateEdit(FD2BridgeItemVCLObj.Item).OnChange) then
 FrameworkItemClass.OnChange:=
    procedure(EventParams: TStrings)
    begin
     TDateEdit(FD2BridgeItemVCLObj.Item).OnChange(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TDateEdit(FD2BridgeItemVCLObj.Item).OnKeyDown) then
 FrameworkItemClass.OnKeyDown:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TDateEdit(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TDateEdit(FD2BridgeItemVCLObj.Item).OnKeyPress) then
 FrameworkItemClass.OnKeyPress:=
    procedure(EventParams: TStrings)
    var
      KeyPress: Char;
    begin
     KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
     TDateEdit(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
    end;

end;

procedure TVCLObjTDateEdit.ProcessPropertyClass(NewObj: TObject);
begin
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.DataType:= PrismFieldTypeDate;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.GetEnabled:=
    function: Variant
    begin
     Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TDateEdit(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.GetVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.SetVisible:=
    procedure(AValue: Variant)
    begin
     TDateEdit(FD2BridgeItemVCLObj.Item).Visible:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.GetReadOnly:=
    function: Variant
    begin
     Result:= not TDateEdit(FD2BridgeItemVCLObj.Item).Enabled;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.SetReadOnly:=
    procedure(AValue: Variant)
    begin
     TDateEdit(FD2BridgeItemVCLObj.Item).Enabled:= not AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.OnGetText:=
    function: Variant
    begin
     Result:= DateToStr(TDateEdit(FD2BridgeItemVCLObj.Item).Date);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.OnSetText:=
    procedure(AValue: Variant)
    begin
     TDateEdit(FD2BridgeItemVCLObj.Item).Date:= StrToDate(AValue);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.GetPlaceholder:=
    function: Variant
    begin
     if TDateEdit(FD2BridgeItemVCLObj.Item).ShowHint then
      Result:= TDateEdit(FD2BridgeItemVCLObj.Item).Hint
     else
      Result:= '';
    end;
end;

function TVCLObjTDateEdit.VCLClass: TClass;
begin
 Result:= TDateEdit;
end;

procedure TVCLObjTDateEdit.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TDateEdit(FD2BridgeItemVCLObj.Item).Font.Size <> Application.DefaultFont.Size then
  VCLObjStyle.FontSize := TDateEdit(FD2BridgeItemVCLObj.Item).Font.Size;

 if (TDateEdit(FD2BridgeItemVCLObj.Item).Font.Color <> clWindowText) then
  VCLObjStyle.FontColor := TDateEdit(FD2BridgeItemVCLObj.Item).Font.Color;

 if TDateEdit(FD2BridgeItemVCLObj.Item).Color <> DefaultColor then
  VCLObjStyle.Color := TDateEdit(FD2BridgeItemVCLObj.Item).Color;

 if TDateEdit(FD2BridgeItemVCLObj.Item).Alignment <> taLeftJustify then
  VCLObjStyle.Alignment:= TDateEdit(FD2BridgeItemVCLObj.Item).Alignment;

 VCLObjStyle.FontStyles := TDateEdit(FD2BridgeItemVCLObj.Item).Font.Style;
end;


{$ELSE}
implementation
{$ENDIF}

end.