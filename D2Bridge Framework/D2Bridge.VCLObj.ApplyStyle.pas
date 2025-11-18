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

unit D2Bridge.VCLObj.ApplyStyle;

interface

Uses
 Classes, SysUtils,
{$IFDEF FMX}
  FMX.Controls, FMX.Forms, FMX.TabControl, FMX.Platform, FMX.Graphics, FMX.StdCtrls,
{$ELSE}
  Controls, Forms, ComCtrls, Graphics, StdCtrls,
{$ENDIF}
{$IFDEF DEVEXPRESS_AVAILABLE}
  cxLabel,
{$ENDIF}
 D2Bridge.Item.VCLObj.Style, D2Bridge.Interfaces;

//TLabel
procedure TVCLObjTLabelApplyStyle(const ALabel: TLabel; const VCLObjStyle: ID2BridgeItemVCLObjStyle);
{$IFDEF DEVEXPRESS_AVAILABLE}
//TcxLabel
procedure TVCLObjTcxLabelApplyStyle(const AcxLabel: TcxLabel; const VCLObjStyle: ID2BridgeItemVCLObjStyle);
{$ENDIF}

implementation


Uses
 D2Bridge.Util;


procedure TVCLObjTLabelApplyStyle(const ALabel: TLabel; const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if ALabel.Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize:= ALabel.Font.Size;

 if ALabel.{$IFNDEF FMX}Font.Color{$ELSE}FontColor{$ENDIF} <> DefaultFontColor then
  VCLObjStyle.FontColor:= ALabel.{$IFNDEF FMX}Font.Color{$ELSE}FontColor{$ENDIF};

{$IFNDEF FMX}
 if (not ALabel.Transparent) and
    (not IsColor(ALabel.Color, [clBtnFace, clDefault])) then
  VCLObjStyle.Color:= ALabel.Color;
{$ENDIF}

 if ALabel.{$IFNDEF FMX}Alignment{$ELSE}TextSettings.HorzAlign{$ENDIF} <> DefaultAlignment then
  VCLObjStyle.Alignment:= ALabel.{$IFNDEF FMX}Alignment{$ELSE}TextSettings.HorzAlign{$ENDIF};

 VCLObjStyle.FontStyles:= ALabel.Font.Style;
end;

{$IFDEF DEVEXPRESS_AVAILABLE}
procedure TVCLObjTcxLabelApplyStyle(const AcxLabel: TcxLabel; const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if AcxLabel.Style.Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize := AcxLabel.Style.Font.Size;

 if AcxLabel.Style.Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor := AcxLabel.Style.Font.Color;

 if (not AcxLabel.Transparent) and (AcxLabel.Style.Color <> clBtnFace) then
  VCLObjStyle.Color := AcxLabel.Style.Color;

 if AcxLabel.Properties.Alignment.Horz <> DefaultAlignment then
  VCLObjStyle.Alignment:= AcxLabel.Properties.Alignment.Horz;

 VCLObjStyle.FontStyles := AcxLabel.Style.Font.Style;
end;
{$ENDIF}


end.
