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

 //if ALabel.{$IFNDEF FMX}Font.Color{$ELSE}FontColor{$ENDIF} <> DefaultFontColor then
 if ALabel.{$IFNDEF FMX}Font.Color{$ELSE}FontColor{$ENDIF} <> ColorNone then
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