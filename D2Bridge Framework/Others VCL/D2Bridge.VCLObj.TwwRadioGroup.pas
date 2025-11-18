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
  Thanks for contribution to this Unit to:
    Alisson Suart
    Email: contato@deuxsoftware.com.br
 +--------------------------------------------------------------------------+
}

{$I D2Bridge.inc}

unit D2Bridge.VCLObj.TwwRadioGroup;

interface

{$IFDEF INFOPOWER_AVAILABLE}
uses
  Classes, RTTI, vcl.wwradiogroup,
  StdCtrls, Controls, Forms, Graphics, ExtCtrls,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;

type
 TVCLObjTwwRadioGroup = class(TD2BridgeItemVCLObjCore)
  private
  public
   function VCLClass: TClass; override;
   function CSSClass: String; override;
   Procedure VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle); override;
   procedure ProcessPropertyClass(NewObj: TObject); override;
   procedure ProcessEventClass; override;
   function FrameworkItemClass: ID2BridgeFrameworkItem; override;
 end;

implementation

Uses
 D2Bridge.Item.VCLObj.Style, D2Bridge.Util,
 D2Bridge.Forms.Helper,
 Prism.Forms, Prism.Session.Thread.Proc;

{ TVCLObjTwwRadioGroup }

function TVCLObjTwwRadioGroup.CSSClass: String;
begin
 result := 'd2bridgeradiogroup';
end;

function TVCLObjTwwRadioGroup.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.RadioGroup;
end;

procedure TVCLObjTwwRadioGroup.ProcessEventClass;
begin
 if Assigned(TwwRadioGroup(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:=
    procedure(EventParams: TStrings)
    begin
     TwwRadioGroup(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwRadioGroup(FD2BridgeItemVCLObj.Item).OnEnter) then
 FrameworkItemClass.OnEnter:=
    procedure(EventParams: TStrings)
    begin
     TwwRadioGroup(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwRadioGroup(FD2BridgeItemVCLObj.Item).OnExit) then
 FrameworkItemClass.OnExit:=
    procedure(EventParams: TStrings)
    begin
     TwwRadioGroup(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
    end;
end;

procedure TVCLObjTwwRadioGroup.ProcessPropertyClass(NewObj: TObject);
begin
 inherited;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.RadioGroup.ProcGetItems :=
    function: TStrings
    begin
     Result := TwwRadioGroup(FD2BridgeItemVCLObj.Item).Items;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.RadioGroup.GetEnabled :=
    function: Variant
    begin
     Result := GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.RadioGroup.SetEnabled :=
    procedure(AValue: Variant)
    begin
     TwwRadioGroup(FD2BridgeItemVCLObj.Item).Enabled := AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.RadioGroup.GetVisible :=
    function: Variant
    begin
       Result := GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.RadioGroup.SetVisible :=
    procedure(AValue: Variant)
    begin
     TwwRadioGroup(FD2BridgeItemVCLObj.Item).Visible := AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.RadioGroup.ProcGetItemIndex :=
    function: Variant
    begin
     Result:= TwwRadioGroup(FD2BridgeItemVCLObj.Item).ItemIndex;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.RadioGroup.ProcSetItemIndex :=
    procedure(AValue: Variant)
    begin
     TwwRadioGroup(FD2BridgeItemVCLObj.Item).ItemIndex := AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.RadioGroup.ProcGetCaption :=
    function: Variant
    begin
      result:= TwwRadioGroup(FD2BridgeItemVCLObj.Item).Caption;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.RadioGroup.ProcSetCaption :=
    procedure(AValue: Variant)
    begin
     TwwRadioGroup(FD2BridgeItemVCLObj.Item).Caption:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.RadioGroup.ProcGetColumns :=
    function: Variant
    begin
     Result := TwwRadioGroup(FD2BridgeItemVCLObj.Item).Columns;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.RadioGroup.ProcSetColumns :=
    procedure(AValue: Variant)
    begin
      TwwRadioGroup(FD2BridgeItemVCLObj.Item).Columns:= AValue;
    end;
end;

function TVCLObjTwwRadioGroup.VCLClass: TClass;
begin
 Result := TwwRadioGroup;
end;

procedure TVCLObjTwwRadioGroup.VCLStyle(
  const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 inherited;

 if TwwRadioGroup(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize := TwwRadioGroup(FD2BridgeItemVCLObj.Item).Font.Size;

 if TwwRadioGroup(FD2BridgeItemVCLObj.Item).Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor := TwwRadioGroup(FD2BridgeItemVCLObj.Item).Font.Color;

 if not IsColor(TwwRadioGroup(FD2BridgeItemVCLObj.Item).Color, [clWindow, clDefault, clBtnFace]) then
  VCLObjStyle.Color := TwwRadioGroup(FD2BridgeItemVCLObj.Item).Color;

 VCLObjStyle.FontStyles := TwwRadioGroup(FD2BridgeItemVCLObj.Item).Font.Style;
end;

{$ELSE}
implementation
{$ENDIF}

end.
