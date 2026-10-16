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

{$I D2Bridge.inc}

unit D2Bridge.VCLObj.TDBText;


interface

{$IFNDEF FMX}
uses
  Classes,
  DBCtrls, Graphics,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTDBText = class(TD2BridgeItemVCLObjCore)
  private
   procedure TDBTextOnClick(EventParams: TStrings);
   procedure TDBTextOnDblClick(EventParams: TStrings);

   function TDBTextGetEnabled: Variant;
   procedure TDBTextSetEnabled(AValue: Variant);
   function TDBTextGetVisible: Variant;
   procedure TDBTextSetVisible(AValue: Variant);
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

{ TVCLObjTDBText }


function TVCLObjTDBText.CSSClass: String;
begin
 result:= 'form-control-plaintext';

 if TDBText(FD2BridgeItemVCLObj.Item).WordWrap then
  result:= result + ' text-break';
end;

function TVCLObjTDBText.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBText;
end;

procedure TVCLObjTDBText.TDBTextOnClick(EventParams: TStrings);
begin
 TDBText(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBText.TDBTextOnDblClick(EventParams: TStrings);
begin
 TDBText(FD2BridgeItemVCLObj.Item).OnDblClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBText.ProcessEventClass;
begin
 if Assigned(TDBText(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:= TDBTextOnClick;

 if Assigned(TDBText(FD2BridgeItemVCLObj.Item).OnDblClick) then
 FrameworkItemClass.OnDblClick:= TDBTextOnDblClick;
end;

function TVCLObjTDBText.TDBTextGetEnabled: Variant;
begin
  Result := GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBText.TDBTextSetEnabled(AValue: Variant);
begin
  TDBText(FD2BridgeItemVCLObj.Item).Enabled := AValue;
end;

function TVCLObjTDBText.TDBTextGetVisible: Variant;
begin
  Result := GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTDBText.TDBTextSetVisible(AValue: Variant);
begin
  TDBText(FD2BridgeItemVCLObj.Item).Visible := AValue;
end;

procedure TVCLObjTDBText.ProcessPropertyClass(NewObj: TObject);
begin
 if Assigned(TDBText(FD2BridgeItemVCLObj.Item).DataSource) then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBText.Dataware.DataSource:= TDBText(FD2BridgeItemVCLObj.Item).DataSource;

 if TDBText(FD2BridgeItemVCLObj.Item).DataField <> '' then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBText.Dataware.DataField:= TDBText(FD2BridgeItemVCLObj.Item).DataField;
 
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBText.GetEnabled:= TDBTextGetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBText.SetEnabled:= TDBTextSetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBText.GetVisible:= TDBTextGetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBText.SetVisible:= TDBTextSetVisible;
end;

function TVCLObjTDBText.VCLClass: TClass;
begin
 Result:= TDBText;
end;

procedure TVCLObjTDBText.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TDBText(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize := TDBText(FD2BridgeItemVCLObj.Item).Font.Size;

 if TDBText(FD2BridgeItemVCLObj.Item).Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor := TDBText(FD2BridgeItemVCLObj.Item).Font.Color;

 if (not TDBText(FD2BridgeItemVCLObj.Item).Transparent) and
    (not IsColor(TDBText(FD2BridgeItemVCLObj.Item).Color, [clBtnFace, clDefault])) then
  VCLObjStyle.Color := TDBText(FD2BridgeItemVCLObj.Item).Color;

 if TDBText(FD2BridgeItemVCLObj.Item).Alignment <> DefaultAlignment then
  VCLObjStyle.Alignment:= TDBText(FD2BridgeItemVCLObj.Item).Alignment;

 VCLObjStyle.FontStyles := TDBText(FD2BridgeItemVCLObj.Item).Font.Style;
end;

{$ELSE}
implementation
{$ENDIF}

end.