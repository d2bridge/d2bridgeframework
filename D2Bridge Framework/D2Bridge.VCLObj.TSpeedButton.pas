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
