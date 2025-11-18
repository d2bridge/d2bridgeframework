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
    Alisson Suart
    Email: contato@deuxsoftware.com.br
 +--------------------------------------------------------------------------+
}

{$I ..\D2Bridge.inc}

unit D2Bridge.VCLObj.TwwDBDateTimePicker;


interface

{$IFDEF INFOPOWER_AVAILABLE}

uses
  Classes, SysUtils,
  StdCtrls, ComCtrls, Forms, Graphics,
  vcl.wwdbdatetimepicker,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTwwDBDateTimePicker = class(TD2BridgeItemVCLObjCore)
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
 Prism.Util, Prism.Types, D2Bridge.Util, D2Bridge.Item.VCLObj.Style;

{ TVCLObjTwwDBDateTimePicker }


function TVCLObjTwwDBDateTimePicker.CSSClass: String;
begin
 result:= 'form-control';
end;

function TVCLObjTwwDBDateTimePicker.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit;
end;

procedure TVCLObjTwwDBDateTimePicker.ProcessEventClass;
begin
 if Assigned(TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:=
    procedure(EventParams: TStrings)
    begin
     TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).OnEnter) then
 FrameworkItemClass.OnEnter:=
    procedure(EventParams: TStrings)
    begin
     TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).OnExit) then
 FrameworkItemClass.OnExit:=
    procedure(EventParams: TStrings)
    begin
     TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).OnChange) then
 FrameworkItemClass.OnChange:=
    procedure(EventParams: TStrings)
    begin
     TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).OnChange(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).OnKeyDown) then
 FrameworkItemClass.OnKeyDown:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).OnKeyPress) then
 FrameworkItemClass.OnKeyPress:=
    procedure(EventParams: TStrings)
    var
      KeyPress: Char;
    begin
     KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
     TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
    end;

end;

procedure TVCLObjTwwDBDateTimePicker.ProcessPropertyClass(NewObj: TObject);
begin
 if Assigned(TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).DataSource) then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.Dataware.DataSource:= TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).DataSource;

 if TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).DataField <> '' then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.Dataware.DataField:= TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).DataField;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.DataType:= PrismFieldTypeDate;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.GetEnabled:=
    function: Variant
    begin
     Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.GetVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.SetVisible:=
    procedure(AValue: Variant)
    begin
     TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).Visible:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.GetReadOnly:=
    function: Variant
    begin
     Result:= not TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).Enabled;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.SetReadOnly:=
    procedure(AValue: Variant)
    begin
     TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).Enabled:= not AValue;
    end;

// If transformed to the Edit Class, these properties must be returned
// FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.OnGetText:=
//    function: Variant
//    begin
//     Result:= DateToStr(TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).Date);
//    end;
//
// FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.OnSetText:=
//    procedure(AValue: Variant)
//    begin
//     TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).Date:= StrToDate(AValue);
//    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBEdit.GetPlaceholder:=
    function: Variant
    begin
     if TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).ShowHint then
      Result:= TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).Hint
     else
      Result:= '';
    end;
end;

function TVCLObjTwwDBDateTimePicker.VCLClass: TClass;
begin
 Result:= TwwDBDateTimePicker;
end;

procedure TVCLObjTwwDBDateTimePicker.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize := TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).Font.Size;

 if TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor := TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).Font.Color;

 if TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).Color <> clWindow then
  VCLObjStyle.Color := TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).Color;

 VCLObjStyle.FontStyles := TwwDBDateTimePicker(FD2BridgeItemVCLObj.Item).Font.Style;
end;
{$ELSE}
implementation
{$ENDIF}

end.