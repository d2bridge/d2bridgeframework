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

unit D2Bridge.VCLObj.TLabel;


interface


uses
  Classes,
{$IFDEF HAS_UNIT_SYSTEM_UITYPES}
  System.UITypes,
{$ENDIF}
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTLabel = class(TD2BridgeItemVCLObjCore)
  private
    procedure TLabelOnClick(EventParams: TStrings);
    procedure TLabelOnDblClick(EventParams: TStrings);
    function TLabelGetEnabled: Variant;
    procedure TLabelSetEnabled(AValue: Variant);
    function TLabelGetVisible: Variant;
    procedure TLabelSetVisible(AValue: Variant);
    function TLabelOnGetText: Variant;
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
  SysUtils,
{$IFDEF FMX}
  FMX.StdCtrls, FMX.Forms, FMX.Graphics, FMX.Types,
{$ELSE}
  StdCtrls, Controls, Forms, Graphics,
{$ENDIF}
  D2Bridge.VCLObj.ApplyStyle,
  Prism.Util, D2Bridge.Util, D2Bridge.HTML.CSS, D2Bridge.Item.VCLObj.Style;

{ VCLObjTLabel }


function TVCLObjTLabel.CSSClass: String;
begin
 result:= 'form-control-plaintext';

 if TLabel(FD2BridgeItemVCLObj.Item).WordWrap then
  result:= result + ' text-break';
end;

function TVCLObjTLabel.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Text;
end;

procedure TVCLObjTLabel.TLabelOnClick(EventParams: TStrings);
begin
  TLabel(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTLabel.TLabelOnDblClick(EventParams: TStrings);
begin
  TLabel(FD2BridgeItemVCLObj.Item).OnDblClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTLabel.ProcessEventClass;
begin
 if Assigned(TLabel(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:= TLabelOnClick;

 if Assigned(TLabel(FD2BridgeItemVCLObj.Item).OnDblClick) then
 FrameworkItemClass.OnDblClick:= TLabelOnDblClick;
end;

function TVCLObjTLabel.TLabelGetEnabled: Variant;
begin
  Result := GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTLabel.TLabelSetEnabled(AValue: Variant);
begin
  TLabel(FD2BridgeItemVCLObj.Item).Enabled := AValue;
end;

function TVCLObjTLabel.TLabelGetVisible: Variant;
begin
  Result := GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTLabel.TLabelSetVisible(AValue: Variant);
begin
  TLabel(FD2BridgeItemVCLObj.Item).Visible := AValue;
end;

function TVCLObjTLabel.TLabelOnGetText: Variant;
begin
  Result := TLabel(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}Caption{$ELSE}Text{$ENDIF};
end;

procedure TVCLObjTLabel.ProcessPropertyClass(NewObj: TObject);
begin
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Text.GetEnabled:= TLabelGetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Text.SetEnabled:= TLabelSetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Text.GetVisible:= TLabelGetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Text.SetVisible:= TLabelSetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Text.OnGetText:= TLabelOnGetText;
end;

function TVCLObjTLabel.VCLClass: TClass;
begin
 Result:= TLabel;
end;

procedure TVCLObjTLabel.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 TVCLObjTLabelApplyStyle(TLabel(FD2BridgeItemVCLObj.Item), VCLObjStyle);
end;

end.