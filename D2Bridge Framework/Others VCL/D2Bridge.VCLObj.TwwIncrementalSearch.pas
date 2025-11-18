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

unit D2Bridge.VCLObj.TwwIncrementalSearch;


interface

{$IFDEF INFOPOWER_AVAILABLE}
uses
  Classes, Graphics,
  StdCtrls, Controls, Forms,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTwwIncrementalSearch = class(TD2BridgeItemVCLObjCore)
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
  SysUtils, vcl.wwkeycb, D2Bridge.Util, Prism.Util, D2Bridge.Item.VCLObj.Style,
  Prism.Types;


{ TVCLObjTwwIncrementalSearch }


function TVCLObjTwwIncrementalSearch.CSSClass: String;
begin
 result:= 'form-control';
end;

function TVCLObjTwwIncrementalSearch.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit;
end;

procedure TVCLObjTwwIncrementalSearch.ProcessEventClass;
begin
 if Assigned(TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:=
    procedure(EventParams: TStrings)
    begin
     TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).OnEnter) then
 FrameworkItemClass.OnEnter:=
    procedure(EventParams: TStrings)
    begin
     TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).OnExit) then
 FrameworkItemClass.OnExit:=
    procedure(EventParams: TStrings)
    begin
     TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).OnChange) then
 FrameworkItemClass.OnChange:=
    procedure(EventParams: TStrings)
    begin
     TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).OnChange(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).OnKeyDown) then
 FrameworkItemClass.OnKeyDown:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).OnKeyUp) then
 FrameworkItemClass.OnKeyUp:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).OnKeyUp(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).OnKeyPress) then
 FrameworkItemClass.OnKeyPress:=
    procedure(EventParams: TStrings)
    var
      KeyPress: Char;
    begin
     KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
     TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
    end;

end;

procedure TVCLObjTwwIncrementalSearch.ProcessPropertyClass(NewObj: TObject);
begin
 if TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).PasswordChar <> #0 then
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.DataType:= PrismFieldTypePassword;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.CharCase:= TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).CharCase;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.GetEnabled:=
    function: Variant
    begin
     Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.GetVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.SetVisible:=
    procedure(AValue: Variant)
    begin
     TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).Visible:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.GetReadOnly:=
    function: Variant
    begin
     Result:= TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).ReadOnly;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.SetReadOnly:=
    procedure(AValue: Variant)
    begin
     TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).ReadOnly:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.GetPlaceholder:=
    function: Variant
    begin
     if TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).TextHint <> '' then
      Result:= TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).TextHint
     else
     if TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).ShowHint then
      Result:= TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).Hint
     else
      Result:= '';
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.OnGetText:=
    function: Variant
    begin
     Result:= TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).Text;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Edit.OnSetText:=
    procedure(AValue: Variant)
    begin
     TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).Text:= AValue;
    end;
end;

function TVCLObjTwwIncrementalSearch.VCLClass: TClass;
begin
 Result:= TwwIncrementalSearch;
end;

Procedure TVCLObjTwwIncrementalSearch.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize := TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).Font.Size;

 if TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor := TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).Font.Color;

 if TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).Color <> clWindow then
  VCLObjStyle.Color := TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).Color;

 VCLObjStyle.FontStyles := TwwIncrementalSearch(FD2BridgeItemVCLObj.Item).Font.Style;
end;

{$ELSE}
implementation
{$ENDIF}

end.