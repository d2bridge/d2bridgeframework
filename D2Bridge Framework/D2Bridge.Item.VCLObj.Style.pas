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

unit D2Bridge.Item.VCLObj.Style;

interface

uses
  Classes, SysUtils,
{$IFDEF HAS_UNIT_SYSTEM_UITYPES}
  System.UITypes,
{$ENDIF}
  D2Bridge.Interfaces
{$IFDEF FMX}
  , FMX.Graphics, FMX.Types
{$ELSE}
  , Forms, Graphics
{$ENDIF}
 ;


type
 TD2BridgeItemVCLObjStyle = class(TInterfacedPersistent, ID2BridgeItemVCLObjStyle)
 private
  FFontSize: {$IFNDEF FMX}Integer{$ELSE}Single{$ENDIF};
  FAlignment: {$IFNDEF FMX}TAlignment{$ELSE}TTextAlign{$ENDIF};
  FFontColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
  FColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
  FFontStyles: TFontStyles;
  function GetFontSize: {$IFNDEF FMX}Integer{$ELSE}Single{$ENDIF};
  procedure SetFontSize(Value: {$IFNDEF FMX}Integer{$ELSE}Single{$ENDIF});
  function GetFontColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
  procedure SetFontColor(Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
  function GetAlignment: {$IFNDEF FMX}TAlignment{$ELSE}TTextAlign{$ENDIF};
  procedure SetAlignment(Value: {$IFNDEF FMX}TAlignment{$ELSE}TTextAlign{$ENDIF});
  function GetFontStyles: TFontStyles;
  procedure SetFontStyles(Value: TFontStyles);
  function GetColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
  procedure SetColor(Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
 public
  constructor Create;

  procedure Assign(Source: TPersistent); override;

  procedure Default;

  procedure ProcessVCLStyles(out CSSClasses: string; out HTMLStyle: string);

  property FontSize: {$IFNDEF FMX}Integer{$ELSE}Single{$ENDIF} read GetFontSize write SetFontSize;
  property FontStyles: TFontStyles read GetFontStyles write SetFontStyles;
  property FontColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF} read GetFontColor write SetFontColor;
  property Color: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF} read GetColor write SetColor;
  property Alignment: {$IFNDEF FMX}TAlignment{$ELSE}TTextAlign{$ENDIF} read GetAlignment write SetAlignment;
 end;

const
 taNone = {$IFNDEF FPC}{$IFNDEF FMX}TAlignment{$ELSE}TTextAlign{$ENDIF}($FF){$ELSE}TAlignment.taLeftJustify{$ENDIF};

 DefaultFontColor = {$IFNDEF FMX}TColorRec.Black{$ELSE}TAlphaColors.Null{$ENDIF};
{$IFNDEF FMX}
 DefaultColor     = {$IFNDEF FPC}clWindow{$ELSE}clDefault{$ENDIF};
{$ENDIF}
 DefaultAlignment = {$IFNDEF FMX}taLeftJustify{$ELSE}TTextAlign.Leading{$ENDIF};
 ColorNone        = {$IFNDEF FPC}TColors.SysNone{$ELSE}clNone{$ENDIF};
 AlignmentLeft    = {$IFNDEF FMX}taLeftJustify{$ELSE}TTextAlign.Leading{$ENDIF};
 AlignmentCenter  = {$IFNDEF FMX}taCenter{$ELSE}TTextAlign.Center{$ENDIF};
 AlignmentRight   = {$IFNDEF FMX}taRightJustify{$ELSE}TTextAlign.Trailing{$ENDIF};


 function DefaultFontSize: {$IFNDEF FMX}Integer{$ELSE}Single{$ENDIF};


implementation

Uses
 D2Bridge.HTML.CSS, D2Bridge.Util, D2Bridge.Manager, D2Bridge.ServerControllerBase;

{ TD2BridgeItemVCLObjStyle }

function DefaultFontSize: {$IFNDEF FMX}Integer{$ELSE}Single{$ENDIF};
begin
 //result:= 0;//{$IFNDEF FMX}{$IFDEF DELPHIX_SYDNEY_UP}Screen.defa{$ELSE}8{$ENDIF}{$ELSE}12.0{$ENDIF};
 result:= (D2BridgeManager.ServerController as TD2BridgeServerControllerBase).FDefaultFontSize;
end;

procedure TD2BridgeItemVCLObjStyle.Assign(Source: TPersistent);
begin
 if Source is TD2BridgeItemVCLObjStyle then
 begin
  FFontSize:= TD2BridgeItemVCLObjStyle(Source).FontSize;
  FAlignment:= TD2BridgeItemVCLObjStyle(Source).Alignment;
  FFontColor:= TD2BridgeItemVCLObjStyle(Source).FontColor;
  FColor:= TD2BridgeItemVCLObjStyle(Source).Color;
  FFontStyles:= TD2BridgeItemVCLObjStyle(Source).FontStyles;

  exit;
 end;

 inherited;
end;

constructor TD2BridgeItemVCLObjStyle.Create;
begin
 Default;
end;

procedure TD2BridgeItemVCLObjStyle.Default;
begin
 FAlignment:= taNone;

 FFontSize:=  DefaultFontSize;
 FFontColor:= ColorNone;
 FColor:=     ColorNone;
end;

function TD2BridgeItemVCLObjStyle.GetAlignment: {$IFNDEF FMX}TAlignment{$ELSE}TTextAlign{$ENDIF};
begin
 Result:= FAlignment;
end;

function TD2BridgeItemVCLObjStyle.GetColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
begin
 result:= FColor;
end;

function TD2BridgeItemVCLObjStyle.GetFontColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
begin
 Result:= FFontColor;
end;

function TD2BridgeItemVCLObjStyle.GetFontSize: {$IFNDEF FMX}Integer{$ELSE}Single{$ENDIF};
begin
 Result:= FFontSize;
end;

function TD2BridgeItemVCLObjStyle.GetFontStyles: TFontStyles;
begin
 Result:= FFontStyles;
end;

procedure TD2BridgeItemVCLObjStyle.ProcessVCLStyles(out CSSClasses: string; out HTMLStyle: string);
var
 vFontSize: Double;
begin

 {$REGION 'Font Size'}
  if FontSize <> DefaultFontSize then
  begin
   if (Trim(CSSClasses) = '') or
      (Trim(CSSClasses) = 'd2bridgeformgroupcontrol') or
      ((not Pos('fs-', CSSClasses) = 1) and
       (not Pos(' fs-', CSSClasses) >= 1)) then
   begin
    vFontSize:= FontSize / DefaultFontSize; //11.5 is exactally size

    if HTMLStyle <> '' then
     HTMLStyle := HTMLStyle + ' ';
    HTMLStyle := HTMLStyle + 'font-size: '+ StringReplace(FloatToStr(vFontSize), ',', '.', []) +'rem;';
   end;
  end;
 {$ENDREGION}

 {$REGION 'Font Style'}
  if TFontStyle.fsBold in FontStyles then
   CSSClasses:= CSSClasses + ' ' + TCSSClassText.Style.bold;

  if TFontStyle.fsItalic in FontStyles then
   CSSClasses:= CSSClasses + ' ' + TCSSClassText.Style.italic;

  if TFontStyle.fsUnderline in FontStyles then
   CSSClasses:= CSSClasses + ' ' + TCSSClassText.Style.Underline;

  if TFontStyle.fsStrikeOut in FontStyles then
   CSSClasses:= CSSClasses + ' ' + TCSSClassText.Style.StrikeOut;
 {$ENDREGION}

 {$REGION 'Font Color'}
  if FontColor <> ColorNone then
  begin
   if HTMLStyle <> '' then
    HTMLStyle := HTMLStyle + ' ';
   HTMLStyle := HTMLStyle + 'color: '+ D2Bridge.Util.ColorToHex(FontColor) + ';';
  end;
 {$ENDREGION}

 {$REGION 'Alignment'}
  if Alignment <> taNone then
  begin
   if Alignment = AlignmentLeft then
    CSSClasses:= CSSClasses + ' ' + TCSSClassText.Align.left;

   if Alignment = AlignmentRight then
    CSSClasses:= CSSClasses + ' ' + TCSSClassText.Align.right;

   if Alignment = AlignmentCenter then
    CSSClasses:= CSSClasses + ' ' + TCSSClassText.Align.center;
  end;
 {$ENDREGION}

 {$REGION 'Color'}
  if Color <> ColorNone then
  begin
   if HTMLStyle <> '' then
    HTMLStyle := HTMLStyle + ' ';
   HTMLStyle := HTMLStyle + 'background-color: '+ D2Bridge.Util.ColorToHex(Color) + ';';
  end;
 {$ENDREGION}
end;

procedure TD2BridgeItemVCLObjStyle.SetAlignment(Value: {$IFNDEF FMX}TAlignment{$ELSE}TTextAlign{$ENDIF});
begin
 FAlignment:= Value;
end;

procedure TD2BridgeItemVCLObjStyle.SetColor(Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
begin
 FColor:= Value;
end;

procedure TD2BridgeItemVCLObjStyle.SetFontColor(Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
begin
 FFontColor:= value;
end;

procedure TD2BridgeItemVCLObjStyle.SetFontSize(Value: {$IFNDEF FMX}Integer{$ELSE}Single{$ENDIF});
begin
{$IFDEF FPC}
 if Value = 0 then
  Value:= DefaultFontSize;
{$ENDIF}

 FFontSize:= value;
end;

procedure TD2BridgeItemVCLObjStyle.SetFontStyles(Value: TFontStyles);
begin
 FFontStyles:= Value;
end;

end.
