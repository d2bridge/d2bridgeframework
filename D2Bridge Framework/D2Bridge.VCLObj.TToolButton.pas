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

unit D2Bridge.VCLObj.TToolButton;

interface

uses
  Classes,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTToolButton = class(TD2BridgeItemVCLObjCore)
  private
   procedure TToolButtonOnClick(EventParams: TStrings);
   function TToolButtonGetEnabled: Variant;
   procedure TToolButtonSetEnabled(AValue: Variant);
   function TToolButtonGetVisible: Variant;
   procedure TToolButtonSetVisible(AValue: Variant);
   function TToolButtonOnGetCaption: Variant;
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
  StdCtrls, Buttons, ComCtrls,
{$ENDIF}
  D2Bridge.Util,
  Prism.Util;

{ TVCLObjTToolButton }


function TVCLObjTToolButton.CSSClass: String;
begin
 Result:= 'btn';
end;

function TVCLObjTToolButton.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Button;
end;

procedure TVCLObjTToolButton.TToolButtonOnClick(EventParams: TStrings);
begin
  TToolButton(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
end;

function TVCLObjTToolButton.TToolButtonOnGetCaption: Variant;
begin
 Result:= TToolButton(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}Caption{$ELSE}Text{$ENDIF};
end;

procedure TVCLObjTToolButton.ProcessEventClass;
begin
 if Assigned(TToolButton(FD2BridgeItemVCLObj.Item).OnClick) then
   FrameworkItemClass.OnClick := TToolButtonOnClick;
end;

function TVCLObjTToolButton.TToolButtonGetEnabled: Variant;
begin
  Result := GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTToolButton.TToolButtonSetEnabled(AValue: Variant);
begin
  TToolButton(FD2BridgeItemVCLObj.Item).Enabled := AValue;
end;

function TVCLObjTToolButton.TToolButtonGetVisible: Variant;
begin
  Result := GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTToolButton.TToolButtonSetVisible(AValue: Variant);
begin
  TToolButton(FD2BridgeItemVCLObj.Item).Visible := AValue;
end;

procedure TVCLObjTToolButton.ProcessPropertyClass(NewObj: TObject);
begin
{$IFNDEF FMX}
 {$IFDEF DELPHIX_SYDNEY_UP} // Delphi 10.4 Sydney or Upper
     if (FD2BridgeItemVCLObj.Item is TToolButton) then
     begin
      if TToolButton(FD2BridgeItemVCLObj.Item).ImageName <> '' then
       FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Button.CSSButtonIcon:= TToolButton(FD2BridgeItemVCLObj.Item).ImageName;
     end;
 {$ENDIF}
{$ENDIF}

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Button.GetEnabled := TToolButtonGetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Button.SetEnabled := TToolButtonSetEnabled;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Button.GetVisible := TToolButtonGetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Button.SetVisible := TToolButtonSetVisible;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Button.OnGetCaption := TToolButtonOnGetCaption;
end;

function TVCLObjTToolButton.VCLClass: TClass;
begin
 Result:= TToolButton;
end;

procedure TVCLObjTToolButton.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin

end;

end.
