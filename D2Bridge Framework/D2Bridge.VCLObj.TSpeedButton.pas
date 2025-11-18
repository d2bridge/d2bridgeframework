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

unit D2Bridge.VCLObj.TSpeedButton;

interface

uses
  Classes,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTSpeedButton = class(TD2BridgeItemVCLObjCore)
  private
   procedure TSpeedButtonOnClick(EventParams: TStrings);
   procedure TSpeedButtonOnDblClick(EventParams: TStrings);
   function TSpeedButtonGetEnabled: Variant;
   procedure TSpeedButtonSetEnabled(AValue: Variant);
   function TSpeedButtonGetVisible: Variant;
   procedure TSpeedButtonSetVisible(AValue: Variant);
   function TSpeedButtonOnGetCaption: Variant;
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
{$IFDEF FMX}
  FMX.StdCtrls,
{$ELSE}
  StdCtrls, Buttons,
{$ENDIF}
  D2Bridge.Util,
  Prism.Util;

{ TVCLObjTSpeedButton }


function TVCLObjTSpeedButton.CSSClass: String;
begin
 Result:= 'btn';
end;

function TVCLObjTSpeedButton.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Button;
end;

procedure TVCLObjTSpeedButton.TSpeedButtonOnClick(EventParams: TStrings);
begin
  TSpeedButton(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTSpeedButton.TSpeedButtonOnDblClick(EventParams: TStrings);
begin
  TSpeedButton(FD2BridgeItemVCLObj.Item).OnDblClick(FD2BridgeItemVCLObj.Item);
end;

function TVCLObjTSpeedButton.TSpeedButtonOnGetCaption: Variant;
begin
 Result:= TSpeedButton(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}Caption{$ELSE}Text{$ENDIF};
end;

procedure TVCLObjTSpeedButton.ProcessEventClass;
begin
 if Assigned(TSpeedButton(FD2BridgeItemVCLObj.Item).OnClick) then
   FrameworkItemClass.OnClick := TSpeedButtonOnClick;

 if Assigned(TSpeedButton(FD2BridgeItemVCLObj.Item).OnDblClick) then
   FrameworkItemClass.OnDblClick := TSpeedButtonOnDblClick;
end;

function TVCLObjTSpeedButton.TSpeedButtonGetEnabled: Variant;
begin
  Result := GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTSpeedButton.TSpeedButtonSetEnabled(AValue: Variant);
begin
  TSpeedButton(FD2BridgeItemVCLObj.Item).Enabled := AValue;
end;

function TVCLObjTSpeedButton.TSpeedButtonGetVisible: Variant;
begin
  Result := GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTSpeedButton.TSpeedButtonSetVisible(AValue: Variant);
begin
  TSpeedButton(FD2BridgeItemVCLObj.Item).Visible := AValue;
end;

procedure TVCLObjTSpeedButton.ProcessPropertyClass(NewObj: TObject);
begin
{$IFNDEF FMX}
 {$IFDEF DELPHIX_SYDNEY_UP} // Delphi 10.4 Sydney or Upper
     if (FD2BridgeItemVCLObj.Item is TSpeedButton) then
     begin
      if TSpeedButton(FD2BridgeItemVCLObj.Item).ImageName <> '' then
       FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Button.CSSButtonIcon:= TSpeedButton(FD2BridgeItemVCLObj.Item).ImageName;
     end;
 {$ENDIF}
{$ENDIF}

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Button.GetEnabled := TSpeedButtonGetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Button.SetEnabled := TSpeedButtonSetEnabled;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Button.GetVisible := TSpeedButtonGetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Button.SetVisible := TSpeedButtonSetVisible;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Button.OnGetCaption := TSpeedButtonOnGetCaption;
end;

function TVCLObjTSpeedButton.VCLClass: TClass;
begin
 Result:= TSpeedButton;
end;

procedure TVCLObjTSpeedButton.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin

end;

end.