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

unit D2Bridge.Util;

interface

uses
  Rtti, Classes,
  SysUtils,
{$IFDEF MSWINDOWS}
  {$IFNDEF FPC}
  Windows,
  {$ELSE}
  Windows,
  {$ENDIF}
{$ENDIF}
  Generics.Collections, DB,
  TypInfo,
{$IFDEF HAS_UNIT_SYSTEM_UITYPES}
  System.UITypes,
{$ENDIF}
{$IFDEF HAS_UNIT_SYSTEM_THREADING}
  System.Threading,
{$ENDIF}
{$IFNDEF FPC}
  Rest.Utils,
  {$IFDEF HAS_UNIT_SYSTEM_NETENCODING}
  System.NetEncoding,
  {$ELSE}
  EncdDecd,
  {$ENDIF}
{$ELSE}
  base64, LCLIntf, URIParser,
{$ENDIF}
{$IFDEF FMX}
  FMX.Controls, FMX.Forms, FMX.TabControl, FMX.Platform, FMX.Graphics,
{$ELSE}
  Controls, Forms, ComCtrls, Graphics,
{$ENDIF}
{$IFDEF DEVEXPRESS_AVAILABLE}
  cxPC,
{$ENDIF}
  Variants, Math;


{$IFDEF FPC}
// FPC: declare as APIs que podem não existir nos headers
function ProcessIdToSessionId(dwProcessId: DWORD; var pSessionId: DWORD): BOOL; stdcall;
  external 'kernel32' name 'ProcessIdToSessionId';
function OpenInputDesktop(dwFlags: DWORD; fInherit: BOOL; dwDesiredAccess: DWORD): THandle; stdcall;
  external 'user32' name 'OpenInputDesktop';
function CloseDesktop(hDesktop: THandle): BOOL; stdcall;
  external 'user32' name 'CloseDesktop';
{$ENDIF}


{$IFDEF FPC}
procedure WriteAllText(const Path, Contents: string; const Encoding: TEncoding; const WriteBOM: Boolean);
{$ENDIF}
function TrataHTMLTag(HTML: String): String;
//function IsMethodImplemented(Instance: TObject; MethodName: String): Boolean;


Function GenerateRandomString(ASize: integer): string;
Function GenerateRandomNumber(ASize: integer): string;


Function GetVisibleRecursive(AControl: TObject): Boolean;
Function GetEnabledRecursive(AControl: TObject): Boolean;


function LangsByBrowser(ALangCommaText: string): TStrings; overload;
function FirstLangByBrowser(ALangCommaText: string): String; overload;

function GetTickCount: Int64;

function GetElapsedTime(const StartTime: Cardinal): string;

function WidthPPI(AWidth: Integer): Integer; overload;
function WidthPPI(AWidth: Single): Integer; overload;

function Base64FromFile(AFile: string): string;
function Base64ImageFromFile(AFile: string): string;

function RelativeFileFromRoot(AFilePath: string): string;

function URLEncode(AURI: string): string;
function URLDecode(AURI: string): string;

function HexToTColor(Hex: string): {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
function ColorToHex(Color: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF}): string;
function LightenColor(Color: {$IFDEF FMX}TAlphaColor{$ELSE}TColor{$ENDIF}; Percent: Byte): {$IFDEF FMX}TAlphaColor{$ELSE}TColor{$ENDIF};
function IsColor(AColor: {$IFDEF FMX}TAlphaColor{$ELSE}TColor{$ENDIF}; const ASet: array of {$IFDEF FMX}TAlphaColor{$ELSE}TColor{$ENDIF}): Boolean;

function ExtractHexValue(AHexValue: LongInt): integer;

procedure CSSButtonFontToIelement(var AOriginalCSSClasses, ANewCSSClasses, AFontClass, AIelement: string);

function VarToObject(Value: variant): TObject;
function ObjectToVar(Value: TObject): Variant;

function CopyException(const E: Exception): Exception;

//String Function
{$IFnDEF FPC}
{$IF CompilerVersion < 32.0}
function TrimRight(AText: string): string; //Fix Memo Line Break problem
{$ENDIF}
{$ENDIF}

//Registro das Classes do D2Bridge
function GetRegisteredClass: TList<TClass>;
procedure RegisterClassD2Bridge(AClass: TPersistentClass);
procedure UnRegisterAllClassD2Bridge;

//Fix Clear in TList
procedure ClearInterfaceList(var AList: TList<IInterface>);
procedure FreeInterfaceList(var AList: TList<IInterface>);

{$IFDEF MSWINDOWS}
function IsRunningAsService: Boolean;
{$ENDIF}

implementation

uses
  D2Bridge.Forms, Prism.BaseClass;

var
  ClassesRegistradas: TList<TClass> = nil;

{$IFDEF FPC}
procedure WriteAllText(const Path, Contents: string; const Encoding: TEncoding; const WriteBOM: Boolean);
var
  LFileStream: TFileStream;
  Buff: TBytes;
begin
  LFileStream := nil;
  try
    LFileStream:= TFileStream.Create(Path, fmCreate);
    if WriteBOM then
    begin
      Buff := Encoding.GetPreamble;
      LFileStream.WriteBuffer(Buff, Length(Buff));
    end;
    Buff := Encoding.GetBytes(Contents);
    LFileStream.WriteBuffer(Buff, Length(Buff));
  finally
    LFileStream.Free;
  end;
end;
{$ENDIF}

function TrataHTMLTag(HTML: String): String;
begin
 Result:= Trim(HTML);
 Result:= StringReplace(Result, '=""', '', [rfReplaceAll, rfIgnoreCase]);
end;


Function GenerateRandomString(ASize: integer): string;
var i: integer;
 r:string;
const
 Str = '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
begin
 r:= '';

 for i := 1 to ASize do
  r := r + Str[random(length(Str))+ 1];

 Result := r;
end;


Function GenerateRandomNumber(ASize: integer): string;
var i: integer;
 r:string;
const
 Str = '1234567890';
begin
 r:= '';

 for i := 1 to ASize do
  r := r + Str[random(length(Str))+ 1];

 Result := r;
end;


Function GetVisibleRecursive(AControl: TObject): Boolean;
begin
 TControl(AControl).Repaint;
 Result := TControl(AControl).Visible;
 while (TControl(AControl).Parent <> nil)
   and (not (TControl(AControl).Parent is TForm))
   and (not (TControl(AControl).Parent is TD2BridgeForm))
   and (not (TControl(AControl).Parent is TCustomForm))
   and Result do
 begin
  AControl := TControl(AControl).Parent;
  if AControl is {$IFDEF FMX}TTabItem{$ELSE}TTabSheet{$ENDIF} then
   Result := {$IFDEF FMX}TTabItem{$ELSE}TTabSheet{$ENDIF}(AControl).{$IFDEF FMX}Visible{$ELSE}TabVisible{$ENDIF}
{$IFDEF DEVEXPRESS_AVAILABLE}
  else
   if AControl is TcxTabSheet then
    Result := TcxTabSheet(AControl).TabVisible
{$ENDIF}
{$IFDEF FMX}
  else if AControl.ClassType.ClassName = 'TTabItemContent' then
    //Ignora no FMX
{$ENDIF}
  else
   Result := TControl(AControl).Visible;
 end;
end;


Function GetEnabledRecursive(AControl: TObject): Boolean;
begin
 Result := TControl(AControl).Enabled;
 while (TControl(AControl).Parent <> nil)
   and (not (TControl(AControl).Parent is TForm))
   and (not (TControl(AControl).Parent is TD2BridgeForm))
   and Result do
 begin
  AControl := TControl(AControl).Parent;
  if AControl is {$IFDEF FMX}TTabItem{$ELSE}TTabSheet{$ENDIF} then
   Result := {$IFDEF FMX}TTabItem{$ELSE}TTabSheet{$ENDIF}(AControl).Enabled
{$IFDEF DEVEXPRESS_AVAILABLE}
  else
   if AControl is TcxTabSheet then
    Result := TcxTabSheet(AControl).Enabled
{$ENDIF}
{$IFDEF FMX}
  else if AControl.ClassType.ClassName = 'TTabItemContent' then
    //Ignora no FMX
{$ENDIF}
  else
   Result := TControl(AControl).Enabled;
 end;
end;


function LangsByBrowser(ALangCommaText: string): TStrings; overload;
var
 I: integer;
begin
 Result:= TStringList.Create;

 Result.CommaText:= ALangCommaText;

 for I := Pred(Result.Count) downto 0 do
 begin
  if Pos('q=', Result.Strings[I]) > 0 then
  begin
   Result.Strings[I]:= Copy(Result.Strings[I], 0, Pos(';',Result.Strings[I])-1);
  end;
 end;

 if Result.Text = '' then
  Result.Text:= 'en-US';
end;


function FirstLangByBrowser(ALangCommaText: string): String; overload;
var
 vLangs: TStrings;
begin
 result:= '';

 vLangs:= LangsByBrowser(ALangCommaText);
 if vLangs.Count > 0 then
  result:= vLangs.Strings[0]
 else
  result:= 'en-US';

 vLangs.Free;
end;

function GetTickCount: Int64;
begin
 result:=
     {$IFDEF FPC}
      TThread.GetTickCount64
    {$ELSE}
      {$IF CompilerVersion >= 35}
        TThread.GetTickCount64
      {$ELSE}
        TThread.GetTickCount
      {$ENDIF}
    {$ENDIF};
end;

function GetElapsedTime(const StartTime: Cardinal): string;
 var
  ElapsedTime: Cardinal;
  Seconds, Minutes, Hours, Days: Integer;
begin
  ElapsedTime := GetTickCount - StartTime;

  Seconds := ElapsedTime div 1000;
  Minutes := Seconds div 60;
  Hours := Minutes div 60;
  Days := Hours div 24;

  if Days > 0 then
    Result := Format('%dd %dh %dm %ds', [Days, Hours mod 24, Minutes mod 60, Seconds mod 60])
  else if Hours > 0 then
    Result := Format('%dh %dm %ds', [Hours, Minutes mod 60, Seconds mod 60])
  else if Minutes > 0 then
    Result := Format('%dm %ds', [Minutes, Seconds mod 60])
  else
    Result := Format('%ds', [Seconds]);
end;

{$IFDEF FMX}
function get_screenscale: Single;
var
  ScreenService: IFMXScreenService;
begin
  Result:= 1;

  if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, IInterface(ScreenService)) then
    Result:= ScreenService.GetScreenScale;
end;
{$ENDIF}

{$IFNDEF MSWINDOWS}
function MathRound(AValue: Extended): Int64; inline;
begin
  if AValue >= 0 then
    Result := Trunc(AValue + 0.5)
  else
    Result := Trunc(AValue - 0.5);
end;

function MulDiv(nNumber, nNumerator, nDenominator: Integer): Integer;
begin
  if nDenominator = 0 then
    Result := -1
  else
    Result := MathRound(Int64(nNumber) * Int64(nNumerator) / nDenominator);
end;
{$ENDIF}

function WidthPPI(AWidth: Integer): Integer;
var
  aDefault:              Integer;
  aDefaultPixelsPerInch: Integer;
  aPixelsPerInch:        Integer;
begin
{$IFDEF FMX}
  aDefault:=              1;
  aDefaultPixelsPerInch:= Trunc(get_screenscale);
  aPixelsPerInch:=        Trunc(get_screenscale);
{$ELSE}
  aDefault:=              96;
  {$IFDEF DELPHIX_SYDNEY_UP} // Delphi 10.4 Sydney or Upper
  aDefaultPixelsPerInch:= Screen.DefaultPixelsPerInch;
  {$ENDIF}
  aPixelsPerInch:=        Screen.PixelsPerInch;
{$ENDIF}

 {$IFDEF DELPHIX_SYDNEY_UP} // Delphi 10.4 Sydney or Upper
  Result:= MulDiv(AWidth, aDefaultPixelsPerInch, aPixelsPerInch);
 {$ELSE}
  Result:= MulDiv(AWidth, aDefault, aPixelsPerInch);
 {$ENDIF}
end;

function WidthPPI(AWidth: Single): Integer;
var
 nWidth: Integer;
begin
 nWidth:= Trunc(AWidth);

 Result:= WidthPPI(nWidth);
end;

function Base64FromFile(AFile: string): string;
var
  Output, Input: TStringStream;
{$IFDEF FPC}
  Encoder:       TBase64EncodingStream;
{$ENDIF}
begin
  try
    if FileExists(AFile) then
    begin
       try
        Input := TStringStream.Create;
        Output := TStringStream.Create;

        Input.LoadFromFile(AFile);

        Input.Position := 0;

{$IFNDEF FPC}
  {$IFDEF HAS_UNIT_SYSTEM_NETENCODING}
        TNetEncoding.Base64.Encode(Input, Output);
  {$ELSE}
        EncodeStream(Input, Output);
  {$ENDIF}
{$ELSE}
        Encoder:= TBase64EncodingStream.Create(Output);
        Encoder.CopyFrom(Input, Input.Size);
        Encoder.Flush;
{$ENDIF}

        Output.Position := 0;

        Result := Output.DataString;
       finally
        Input.Free;
        Output.Free;
{$IFDEF FPC}
        Encoder.Free;
{$ENDIF}
       end;
    end;
  except
  end;
end;


function Base64ImageFromFile(AFile: string): string;
begin
 result:= 'data:image/jpeg;base64, ' + Base64FromFile(AFile);
end;


function RelativeFileFromRoot(AFilePath: string): string;
var
 vRootPath: string;
begin
 Result := AFilePath;

 vRootPath:= IncludeTrailingPathDelimiter(PrismBaseClass.Options.RootDirectory);

 if Pos(LowerCase(vRootPath), LowerCase(AFilePath)) = 1 then
   Result := Copy(AFilePath, Length(vRootPath) + 1, Length(AFilePath));
end;


function URLEncode(AURI: string): string;
begin
{$IFnDEF FPC}
 result:= URIEncode(AURI);
{$ELSE}
 Result:= FilenameToURI(AURI);
{$ENDIF}
end;

function URLDecode(AURI: string): string;
begin
{$IFnDEF FPC}
 result:= TNetEncoding.URL.Decode(AURI);
{$ELSE}
 URIToFilename(AURI, Result);
{$ENDIF}
end;

function HexToTColor(Hex: string): {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
var
  nColor:  TColor;
  R, G, B: Byte;
begin
  if SameText(Hex, 'black') then
    nColor := TColorRec.Black
  else if SameText(Hex, 'white') then
    nColor := TColorRec.White
  // Adiciona suporte para todas as cores nomeadas disponíveis no CSS
  else if SameText(Hex, 'aqua') then
    nColor := $00FFFF
  else if SameText(Hex, 'aliceblue') then
    nColor := $F0F8FF
  else if SameText(Hex, 'antiquewhite') then
    nColor := $FAEBD7
  else if SameText(Hex, 'azure') then
    nColor := $F0FFFF
  else if SameText(Hex, 'beige') then
    nColor := $F5F5DC
  else if SameText(Hex, 'bisque') then
    nColor := $FFE4C4
  else if SameText(Hex, 'blanchedalmond') then
    nColor := $FFEBCD
  else if SameText(Hex, 'blueviolet') then
    nColor := $8A2BE2
  else if SameText(Hex, 'burlywood') then
    nColor := $DEB887
  else if SameText(Hex, 'cadetblue') then
    nColor := $5F9EA0
  else if SameText(Hex, 'chartreuse') then
    nColor := $7FFF00
  else if SameText(Hex, 'chocolate') then
    nColor := $D2691E
  else if SameText(Hex, 'coral') then
    nColor := $FF7F50
  else if SameText(Hex, 'cornflowerblue') then
    nColor := $6495ED
  else if SameText(Hex, 'cornsilk') then
    nColor := $FFF8DC
  else if SameText(Hex, 'crimson') then
    nColor := $DC143C
  else if SameText(Hex, 'cyan') then
    nColor := $00FFFF
  else if SameText(Hex, 'darkblue') then
    nColor := $00008B
  else if SameText(Hex, 'darkcyan') then
    nColor := $008B8B
  else if SameText(Hex, 'darkgoldenrod') then
    nColor := $B8860B
  else if SameText(Hex, 'darkgray') then
    nColor := $A9A9A9
  else if SameText(Hex, 'darkgreen') then
    nColor := $006400
  else if SameText(Hex, 'darkkhaki') then
    nColor := $BDB76B
  else if SameText(Hex, 'darkmagenta') then
    nColor := $8B008B
  else if SameText(Hex, 'darkolivegreen') then
    nColor := $556B2F
  else if SameText(Hex, 'darkorange') then
    nColor := $FF8C00
  else if SameText(Hex, 'darkorchid') then
    nColor := $9932CC
  else if SameText(Hex, 'darkred') then
    nColor := $8B0000
  else if SameText(Hex, 'darksalmon') then
    nColor := $E9967A
  else if SameText(Hex, 'darkseagreen') then
    nColor := $8FBC8F
  else if SameText(Hex, 'darkslateblue') then
    nColor := $483D8B
  else if SameText(Hex, 'darkslategray') then
    nColor := $2F4F4F
  else if SameText(Hex, 'darkturquoise') then
    nColor := $00CED1
  else if SameText(Hex, 'darkviolet') then
    nColor := $9400D3
  else if SameText(Hex, 'deeppink') then
    nColor := $FF1493
  else if SameText(Hex, 'deepskyblue') then
    nColor := $00BFFF
  else if SameText(Hex, 'dimgray') then
    nColor := $696969
  else if SameText(Hex, 'dodgerblue') then
    nColor := $1E90FF
  else if SameText(Hex, 'firebrick') then
    nColor := $B22222
  else if SameText(Hex, 'floralwhite') then
    nColor := $FFFAF0
  else if SameText(Hex, 'forestgreen') then
    nColor := $228B22
  else if SameText(Hex, 'gainsboro') then
    nColor := $DCDCDC
  else if SameText(Hex, 'ghostwhite') then
    nColor := $F8F8FF
  else if SameText(Hex, 'gold') then
    nColor := $FFD700
  else if SameText(Hex, 'goldenrod') then
    nColor := $DAA520
  else if SameText(Hex, 'gray') then
    nColor := $808080
  else if SameText(Hex, 'greenyellow') then
    nColor := $ADFF2F
  else if SameText(Hex, 'honeydew') then
    nColor := $F0FFF0
  else if SameText(Hex, 'hotpink') then
    nColor := $FF69B4
  else if SameText(Hex, 'indianred') then
    nColor := $CD5C5C
  else if SameText(Hex, 'indigo') then
    nColor := $4B0082
  else if SameText(Hex, 'ivory') then
    nColor := $FFFFF0
  else if SameText(Hex, 'khaki') then
    nColor := $F0E68C
  else if SameText(Hex, 'lavender') then
    nColor := $E6E6FA
  else if SameText(Hex, 'lavenderblush') then
    nColor := $FFF0F5
  else if SameText(Hex, 'lawngreen') then
    nColor := $7CFC00
  else if SameText(Hex, 'lemonchiffon') then
    nColor := $FFFACD
  else if SameText(Hex, 'lightblue') then
    nColor := $ADD8E6
  else if SameText(Hex, 'lightcoral') then
    nColor := $F08080
  else if SameText(Hex, 'lightcyan') then
    nColor := $E0FFFF
  else if SameText(Hex, 'lightgoldenrodyellow') then
    nColor := $FAFAD2
  else if SameText(Hex, 'lightgray') then
    nColor := $D3D3D3
  else if SameText(Hex, 'lightgreen') then
    nColor := $90EE90
  else if SameText(Hex, 'lightpink') then
    nColor := $FFB6C1
  else if SameText(Hex, 'lightsalmon') then
    nColor := $FFA07A
  else if SameText(Hex, 'lightseagreen') then
    nColor := $20B2AA
  else if SameText(Hex, 'lightskyblue') then
    nColor := $87CEFA
  else if SameText(Hex, 'lightslategray') then
    nColor := $778899
  else if SameText(Hex, 'lightsteelblue') then
    nColor := $B0C4DE
  else if SameText(Hex, 'lightyellow') then
    nColor := $FFFFE0
  else if SameText(Hex, 'limegreen') then
    nColor := $32CD32
  else if SameText(Hex, 'linen') then
    nColor := $FAF0E6
  else if SameText(Hex, 'magenta') then
    nColor := $FF00FF
  else if SameText(Hex, 'maroon') then
    nColor := $800000
  else if SameText(Hex, 'mediumaquamarine') then
    nColor := $66CDAA
  else if SameText(Hex, 'mediumblue') then
    nColor := $0000CD
  else if SameText(Hex, 'mediumorchid') then
    nColor := $BA55D3
  else if SameText(Hex, 'mediumpurple') then
    nColor := $9370DB
  else if SameText(Hex, 'mediumseagreen') then
    nColor := $3CB371
  else if SameText(Hex, 'mediumslateblue') then
    nColor := $7B68EE
  else if SameText(Hex, 'mediumspringgreen') then
    nColor := $00FA9A
  else if SameText(Hex, 'mediumturquoise') then
    nColor := $48D1CC
  else if SameText(Hex, 'mediumvioletred') then
    nColor := $C71585
  else if SameText(Hex, 'midnightblue') then
    nColor := $191970
  else if SameText(Hex, 'mintcream') then
    nColor := $F5FFFA
  else if SameText(Hex, 'mistyrose') then
    nColor := $FFE4E1
  else if SameText(Hex, 'moccasin') then
    nColor := $FFE4B5
  else if SameText(Hex, 'navajowhite') then
    nColor := $FFDEAD
  else if SameText(Hex, 'oldlace') then
    nColor := $FDF5E6
  else if SameText(Hex, 'olivedrab') then
    nColor := $6B8E23
  else if SameText(Hex, 'orangered') then
    nColor := $FF4500
  else if SameText(Hex, 'orchid') then
    nColor := $DA70D6
  else if SameText(Hex, 'palegoldenrod') then
    nColor := $EEE8AA
  else if SameText(Hex, 'palegreen') then
    nColor := $98FB98
  else if SameText(Hex, 'paleturquoise') then
    nColor := $AFEEEE
  else if SameText(Hex, 'palevioletred') then
    nColor := $DB7093
  else if SameText(Hex, 'papayawhip') then
    nColor := $FFEFD5
  else if SameText(Hex, 'peachpuff') then
    nColor := $FFDAB9
  else if SameText(Hex, 'peru') then
    nColor := $CD853F
  else if SameText(Hex, 'pink') then
    nColor := $FFC0CB
  else if SameText(Hex, 'plum') then
    nColor := $DDA0DD
  else if SameText(Hex, 'powderblue') then
    nColor := $B0E0E6
  else if SameText(Hex, 'purple') then
    nColor := $800080
  else if SameText(Hex, 'rebeccapurple') then
    nColor := $663399
  else if SameText(Hex, 'rosybrown') then
    nColor := $BC8F8F
  else if SameText(Hex, 'royalblue') then
    nColor := $4169E1
  else if SameText(Hex, 'saddlebrown') then
    nColor := $8B4513
  else if SameText(Hex, 'salmon') then
    nColor := $FA8072
  else if SameText(Hex, 'sandybrown') then
    nColor := $F4A460
  else if SameText(Hex, 'seagreen') then
    nColor := $2E8B57
  else if SameText(Hex, 'seashell') then
    nColor := $FFF5EE
  else if SameText(Hex, 'sienna') then
    nColor := $A0522D
  else if SameText(Hex, 'silver') then
    nColor := $C0C0C0
  else if SameText(Hex, 'skyblue') then
    nColor := $87CEEB
  else if SameText(Hex, 'slateblue') then
    nColor := $6A5ACD
  else if SameText(Hex, 'slategray') then
    nColor := $708090
  else if SameText(Hex, 'snow') then
    nColor := $FFFAFA
  else if SameText(Hex, 'springgreen') then
    nColor := $00FF7F
  else if SameText(Hex, 'steelblue') then
    nColor := $4682B4
  else if SameText(Hex, 'tan') then
    nColor := $D2B48C
  else if SameText(Hex, 'teal') then
    nColor := $008080
  else if SameText(Hex, 'thistle') then
    nColor := $D8BFD8
  else if SameText(Hex, 'tomato') then
    nColor := $FF6347
  else if SameText(Hex, 'turquoise') then
    nColor := $40E0D0
  else if SameText(Hex, 'violet') then
    nColor := $EE82EE
  else if SameText(Hex, 'wheat') then
    nColor := $F5DEB3
  else if SameText(Hex, 'whitesmoke') then
    nColor := $F5F5F5
  else if SameText(Hex, 'yellowgreen') then
    nColor := $9ACD32
  else
  begin
   // Remova o "#" do início do código Hex, se presente
   if Hex[1] = '#' then
    Delete(Hex, 1, 1);

   // Converta os valores Hex para RGB
   R := StrToInt('$' + Copy(Hex, 1, 2));
   G := StrToInt('$' + Copy(Hex, 3, 2));
   B := StrToInt('$' + Copy(Hex, 5, 2));

   // Retorne a cor em formato TColor
   nColor := RGB(R, G, B);
  end;

{$IFNDEF FMX}
  Result:= nColor;
{$ELSE}
  Result:= TAlphaColorRec.Alpha or TAlphaColor(nColor);
{$ENDIF}
end;

function ColorToHex(Color: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF}): string;
var
 vRGBColor: Longint;
begin
 try
{$IFNDEF FMX}
  vRGBColor:= ColorToRGB(Color);
{$ELSE}
  vRGBColor:= TAlphaColorRec.ColorToRGB(Color);
{$ENDIF}

  Result := '#' +
    { red value }
    IntToHex( GetRValue( vRGBColor ), 2 ) +
    { green value }
    IntToHex( GetGValue( vRGBColor ), 2 ) +
    { blue value }
    IntToHex( GetBValue( vRGBColor ), 2 );
 except
  Result := '#FFFFFF';
 end;
end;

function LightenColor(Color: {$IFDEF FMX}TAlphaColor{$ELSE}TColor{$ENDIF}; Percent: Byte): {$IFDEF FMX}TAlphaColor{$ELSE}TColor{$ENDIF};
var
  R, G, B: Byte;
  vRGBColor: Longint;
begin
  {$IFDEF FMX}
  vRGBColor := TAlphaColorRec.ColorToRGB(Color);
  {$ELSE}
  vRGBColor := ColorToRGB(Color);
  {$ENDIF}

  R := GetRValue(vRGBColor);
  G := GetGValue(vRGBColor);
  B := GetBValue(vRGBColor);

  R := Min(255, R + (R * Percent div 100));
  G := Min(255, G + (G * Percent div 100));
  B := Min(255, B + (B * Percent div 100));

  Result := RGB(R, G, B);
end;

function IsColor(AColor: {$IFDEF FMX}TAlphaColor{$ELSE}TColor{$ENDIF}; const ASet: array of {$IFDEF FMX}TAlphaColor{$ELSE}TColor{$ENDIF}): Boolean;
var
 C: TColor;
begin
 Result := False;
 for C in ASet do
 begin
  if AColor = C then
   Exit(True);
 end;
end;

function ExtractHexValue(AHexValue: LongInt): integer;
var
  HexStr: string;
begin
  HexStr := IntToHex(AHexValue, 8);

  HexStr := StringReplace(HexStr, '$', '', [rfReplaceAll]);

  Result := StrToInt(HexStr);
end;


procedure CSSButtonFontToIelement(var AOriginalCSSClasses, ANewCSSClasses, AFontClass, AIelement: string);
var
 OverrideIndex, OpenBracketIndex, CloseBracketIndex, HifenIndex, SpaceIndex: Integer;
 OverrideText, HTMLComponentOverride, OverridePosition, CSSClean: string;
begin
  AFontClass:= '';
  AIelement:= '';
  HTMLComponentOverride:= '';
  ANewCSSClasses:= AOriginalCSSClasses;

  OverrideIndex := AnsiPos('[override', AOriginalCSSClasses);
  if OverrideIndex > 0 then
  begin
    // Encontrar a posição do colchete de abertura "[" a partir da posição do trecho "[override..."
    OpenBracketIndex := AnsiPos('[', Copy(AOriginalCSSClasses, OverrideIndex, Length(AOriginalCSSClasses) - OverrideIndex + 1)) + OverrideIndex - 1;
    if OpenBracketIndex > 0 then
    begin
      // Encontrar a posição do colchete de fechamento "]" a partir da posição do colchete de abertura
      CloseBracketIndex := AnsiPos(']', Copy(AOriginalCSSClasses, OpenBracketIndex, Length(AOriginalCSSClasses) - OpenBracketIndex + 1)) + OpenBracketIndex - 1;
      if CloseBracketIndex > 0 then
      begin
        // Extrair o trecho entre os colchetes
        OverrideText := Copy(AOriginalCSSClasses, OpenBracketIndex + 1, CloseBracketIndex - OpenBracketIndex - 1);

        // Verificar se o trecho contém a palavra "override"
        HifenIndex := AnsiPos('-', OverrideText);
        if HifenIndex > 0 then
        begin
          // Encontrar a posição do próximo espaço em branco ou hífen após o hífen encontrado
          SpaceIndex := 0;
          for SpaceIndex := HifenIndex + 1 to Length(OverrideText) do
          begin
            if (OverrideText[SpaceIndex] = ' ') or (OverrideText[SpaceIndex] = '-') then
              Break;
          end;

          // Extrair a classe entre o hífen e o espaço em branco ou próximo hífen
          HTMLComponentOverride := Copy(OverrideText, HifenIndex + 1, SpaceIndex - HifenIndex - 1);

          if pos('-r-', Trim(Copy(OverrideText, SpaceIndex))) = 1 then
          begin
           OverridePosition:= 'right';
           OverrideText:= StringReplace(OverrideText, '-r-', '-', []);
          end else
          if pos('-t-', Trim(Copy(OverrideText, SpaceIndex))) = 1 then
          begin
           OverridePosition:= 'top';
           OverrideText:= StringReplace(OverrideText, '-t-', '-', []);
          end else
          if pos('-b-', Trim(Copy(OverrideText, SpaceIndex))) = 1 then
          begin
           OverridePosition:= 'bottom';
           OverrideText:= StringReplace(OverrideText, '-b-', '-', []);
          end else
           OverridePosition:= 'left';

          // Extrair o que vem após o item 2 até o final da string, removendo espaços em branco extras e hífen inicial
          AFontClass := Trim(Copy(OverrideText, SpaceIndex + 1));
        end;

        // Remover o trecho entre "[" e "]" e obter o restante da string
        CSSClean := Trim(StringReplace(AOriginalCSSClasses, '[' + OverrideText + ']', '', []));

        if CompareText(HTMLComponentOverride,'button') = 0 then
        begin
         AIelement:= '<i class="'+AFontClass+'"></i>';
        end;


        ANewCSSClasses:=
         Copy(AOriginalCSSClasses, 1, OpenBracketIndex-1) +
         Copy(AOriginalCSSClasses, CloseBracketIndex+1);
      end;
    end;
  end else
   AFontClass:= AOriginalCSSClasses;
end;




function VarToObject(Value: variant): TObject;
begin
  Result := TObject(TVarData(Value).VPointer)
end;

function ObjectToVar(Value: TObject): Variant;
begin
  TVarData(Result).VPointer := Value;
  TVarData(Result).VType := varString;
end;

{$IFnDEF FPC}
{$IF CompilerVersion < 32.0}
function TrimRight(AText: string): string;
var
  I: Integer;
begin
  I := AText.Length - 1;
  if (I >= 0) and (AText[I] > ' ') then Result := AText
  else begin
    while (I >= 0) and (AText.Chars[I] <= ' ') do Dec(I);
    Result := AText.SubString(0, I + 1);
  end;
end;
{$ENDIF}
{$ENDIF}

//Registro das Classes do D2Bridge
function GetRegisteredClass: TList<TClass>;
begin
  Result:= ClassesRegistradas;
end;

procedure RegisterClassD2Bridge(AClass: TPersistentClass);
begin
  if ClassesRegistradas = nil then
    ClassesRegistradas:= TList<TClass>.Create;

  ClassesRegistradas.Add(AClass);
  Classes.RegisterClass(AClass);
end;

procedure UnRegisterAllClassD2Bridge;
var
  ttClass: TClass;
begin
  if ClassesRegistradas = nil then
    Exit;

  for ttClass in ClassesRegistradas do
    Classes.UnRegisterClass(TPersistentClass(ttClass));

  FreeAndNil(ClassesRegistradas);
end;


procedure ClearInterfaceList(var AList: TList<IInterface>);
var i: Integer;
begin
  for i := AList.Count - 1 downto 0 do
    AList[i] := nil;
  AList.Clear;
end;

procedure FreeInterfaceList(var AList: TList<IInterface>);
begin
 ClearInterfaceList(AList);
 AList.Free;
end;


function CopyException(const E: Exception): Exception;
begin
  if E is EOSError then
    Result := EOSError.CreateFmt('%s (Code: %d)', [E.Message, EOSError(E).ErrorCode])
  else if E is EInOutError then
    Result := EInOutError.CreateFmt('%s (ErrorCode: %d)', [E.Message, EInOutError(E).ErrorCode])
  else if E is EAbort then
    Result := EAbort.Create(E.Message)
  else if E is EDatabaseError then
    Result := EDatabaseError.Create(E.Message)
  else if E is EInvalidOperation then
    Result := EInvalidOperation.Create(E.Message)
  else if E is EConvertError then
    Result := EConvertError.Create(E.Message)
  else if E is EAbort then
    Result := EAbort.Create(E.Message)
  else
    Result := Exception.Create(E.Message);
end;


{$IFDEF MSWINDOWS}
function IsRunningAsService: Boolean;
var
  SessionId: DWORD;
  hDesk: THandle;
begin
  Result := False;

  // 1) Estamos na sessão 0?
  if not ProcessIdToSessionId(GetCurrentProcessId, SessionId) then
    Exit(False);
  if SessionId <> 0 then
    Exit(False);

  // 2) Temos desktop de entrada (interativo)? Se sim, não é serviço.
  SetLastError(0);
  hDesk := OpenInputDesktop(0, False, DESKTOP_SWITCHDESKTOP);
  if hDesk <> 0 then
  begin
    CloseDesktop(hDesk);
    Exit(False);
  end;

  // Sessão 0 + sem desktop interativo => serviço
  Result := True;
end;
{$ELSE}
function IsRunningAsService: Boolean;
begin
  // Não-Windows: ajuste a sua própria heurística (systemd, etc.)
  Result := False;
end;
{$ENDIF}


end.