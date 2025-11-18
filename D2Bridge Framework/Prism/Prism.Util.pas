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

{$I ..\D2Bridge.inc}

unit Prism.Util;

interface

uses
  Classes, SysUtils, D2Bridge.JSON, StrUtils, Variants, DateUtils,
{$IFDEF HAS_UNIT_SYSTEM_UITYPES}
  System.UITypes,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  DB,
  Prism.Types;


Function GenerateRandomJustString(Size: integer): string;
Function GenerateRandomString(Size: integer): string;
Function GenerateRandomNumber(Size: integer): string;

function FormatValueHTML(AResponse: string): string;

function FormatTextHTML(AText: string): string;

//HTML
function HTMLAddItemFromTag(AHTML, ATag, ItemADD: String): String;
function HTMLRemoveItemFromTag(AHTML, ATag, ItemREMOVE: String): String;
function HTMLAddItemFromClass(AHTML, ItemADD: String): String;
function HTMLRemoveItemFromClass(AHTML, ItemREMOVE: String): String;
function HTMLAddItemFromStyle(AHTML, ItemADD, ItemAValue: String): String;
function HTMLRemoveItemFromStyle(AHTML, ItemREMOVE: String; ItemREMOVEValue: string = ''): String;
function ExistForClass(ACSSClass, ASearch: String): boolean;

function ConvertHTMLKeyToVK(KeyName: string): Word;

function SubtractPaths(const Path, SubPath: string): string;

function IsJSONValid(const AMessage: string): Boolean;

function PrismFieldType(AFieldType: TFieldType): TPrismFieldType;
function InputHTMLTypeByPrismFieldType(APrismFieldType: TPrismFieldType): string;

Function ExtractDecimal(AValue: String): string;
function FixFloat(AValue: String): String; overload;
function FixFloat(AValue: String; AFormatSettings: TFormatSettings): String; overload;
function PrepareFloat(AValue: String; AFormatSettings: TFormatSettings): String;
function FixDateTimeByFormat(AValue: String; AOldDateTime: TDateTime; ANewDateTimeFormat: string; ADefaultDateTimeFormat: string): string; overload;

function FloatToHTMLElement(AValue: double): String;
function FloatFromHTMLElement(AValue: string): double;
function DateToHTMLElement(AValue: TDate): String;
function DateFromHTMLElement(AValue: string): TDate;
function TimeToHTMLElement(AValue: TTime): String;
function TimeFromHTMLElement(AValue: string): TTime;
function DateTimeToHTMLElement(AValue: TDateTime): String;
function DateTimeFromHTMLElement(AValue: string): TDateTime;
function DataFieldValueToHTMLElement(AValue: String; APrismFieldType: TPrismFieldType): String;
function DataFieldValueFromHTMLElement(AValue: String; APrismFieldType: TPrismFieldType): Variant;

function FormatOfFloat(AFormatSettings: TFormatSettings): string; overload;
function FormatOfFloat(AFormatSettings: TFormatSettings; ADecimalPlaces: integer): string; overload;
function FormatOfCurrency(AFormatSettings: TFormatSettings; FUseCurSymbol: boolean = false): string;

implementation

uses
  Prism.BaseClass;

{$IFNDEF MSWINDOWS}
const
  VK_BACK = vkBack; {8}
  VK_TAB = vkTab; {9}
  VK_RETURN = vkReturn; {13}
  VK_SHIFT = vkShift; { $10, 16}
  VK_CONTROL = vkControl; {17}
  VK_PAUSE = vkPause; {19}

  VK_CAPITAL = vkCapital; {20}
  VK_SPACE = vkSpace; { $20}
  VK_ESCAPE = vkEscape; {27}

  VK_PRIOR = vkPrior; {33}
  VK_NEXT = vkNext; {34}
  VK_END = vkEnd; {35}
  VK_HOME = vkHome; {35}

  VK_LEFT = vkLeft; {37}
  VK_UP = vkUp; {38}
  VK_RIGHT = vkRight; {39}
  VK_DOWN = vkDown; {40}

  VK_SNAPSHOT = vkSnapShot; {44}
  VK_INSERT = vkInsert; {45}
  VK_DELETE = vkDelete; {46}

  VK_F1 = vkF1; {112}
  VK_F2 = vkF2; {113}
  VK_F3 = vkF3; {114}
  VK_F4 = vkF4; {115}
  VK_F5 = vkF5; {116}
  VK_F6 = vkF6; {117}
  VK_F7 = vkF7; {118}
  VK_F8 = vkF8; {119}
  VK_F9 = vkF9; {120}
  VK_F10 = vkF10; {121}
  VK_F11 = vkF11; {122}
  VK_F12 = vkF12; {123}

  VK_NUMLOCK = vkNumLock; {144}
  VK_SCROLL = vkScroll; {145}
{$IFEND}


Function GenerateRandomJustString(Size: integer): string;
var i: integer;
 r:string;
const
 Str = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
begin
 r:= '';

 for i := 1 to Size do
  r := r + Str[random(length(Str))+ 1];

 Result := r;
end;


Function GenerateRandomString(Size: integer): string;
var i: integer;
 r:string;
const
 Str = '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
begin
 r:= '';

 for i := 1 to Size do
  r := r + Str[random(length(Str))+ 1];

 Result := r;
end;


Function GenerateRandomNumber(Size: integer): string;
var i: integer;
 r:string;
const
 Str = '1234567890';
begin
 r:= '';

 for i := 1 to Size do
  r := r + Str[random(length(Str))+ 1];

 Result := r;
end;


function FormatValueHTML(AResponse: string): string;
var
 vJSONString: TJSONString;
begin
 vJSONString:= TJSONString.Create(AResponse);
 result:= vJSONString.ToJSON;
 vJSONString.Free;
end;


function FormatTextHTML(AText: string): string;
var
 vText: string;
begin
// vText:= FormatValueHTML(AText);
 //result:= Copy(vText, 2, Length(vText)-2);
 result:= AText;
 result:= StringReplace(result, '&', '&amp;', [rfReplaceAll]);
 result:= StringReplace(result, '<', '&lt;', [rfReplaceAll]);
 result:= StringReplace(result, '>', '&gt;', [rfReplaceAll]);
 result:= StringReplace(result, '"', '&quot;', [rfReplaceAll]);
 result:= StringReplace(result, '''', '&#39;', [rfReplaceAll]);
end;


function HTMLAddItemFromTag(AHTML, ATag, ItemADD: String): String;
var
 PosInit, PosEnd: Integer;
 ClassText, ProxCaractBefore: string;
begin
  ProxCaractBefore:= Copy(AHTML, Pos(ATag, AHTML) + length(ATag), 1);

  // Verificar se já existe a classe no atributo class
  if (Pos(ATag+'="', AHTML) = 1) or (Pos(' '+ATag+'="', AHTML) >= 1) then
  begin
    PosInit:= Pos(ATag+'="', AHTML) + Length(ATag+'="');
    PosEnd:= Pos('"', Copy(AHTML, PosInit, Length(AHTML)));
    if PosEnd <= PosInit then
    PosEnd:= Length(AHTML);
    ClassText:= Copy(AHTML, PosInit, PosEnd-1);

    ClassText:= Trim(ClassText);

    //Exists
    if (Pos(ItemADD, ClassText) = 1) or (Pos(' '+ItemADD+' ', ClassText) >= 1) or ((Pos(ItemADD, ClassText)-1) + length(ItemADD) = length(ClassText)) then
    begin
     result:= AHTML;
     exit;
    end;

    Result := Copy(AHTML, 1, Pos(ATag+'="', AHTML) + Length(ATag+'="') - 1) + ItemADD + ' ' +
              Copy(AHTML, Pos(ATag+'="', AHTML) + Length(ATag+'="'), Length(AHTML));
  end
  else
  if (Pos(ATag+' ', AHTML) = 1) or (Pos(' '+ATag+' ', AHTML) >= 1) or (ProxCaractBefore = '/') or (ProxCaractBefore = '=') or (ProxCaractBefore = '>') or (ProxCaractBefore = '%') or (ProxCaractBefore = '}') then
  begin
    // Não há classes definidas, adiciona class=""
    Result := Copy(AHTML, 1, Pos(ATag, AHTML) + Length(ATag)-1) + '="' + ItemADD + '" ' +
              Copy(AHTML, Pos(ATag, AHTML) + Length(ATag), Length(AHTML));
  end
  else
  begin
    // Não há atributo class, adiciona class=""
    if ATag <> '' then
     Result := AHTML.Insert(0, ATag+'="' + ItemADD + '" ')
    else
     Result := AHTML.Insert(0, ItemADD + ' ')
  end;
end;


function HTMLRemoveItemFromTag(AHTML, ATag, ItemREMOVE: String): String;
var
 PosInit, PosEnd: Integer;
 ClassText, NewClassText: string;
begin
  // Verificar se já existe a classe no atributo class
  if (Pos(ATag+'="', AHTML) = 1) or (Pos(' '+ATag+'="', AHTML) >= 1) then
  begin
    PosInit:= Pos(ATag+'="', AHTML) + Length(ATag+'="');
    PosEnd:= Pos('"', Copy(AHTML, PosInit, Length(AHTML)));
    if PosEnd <= PosInit then
    PosEnd:= Length(AHTML);
    ClassText:= Copy(AHTML, PosInit, PosEnd-1);

    //Exists
    if (Pos(ItemREMOVE, ClassText) = 1) or (Pos(' '+ItemREMOVE+' ', ClassText) >= 1) or ((Pos(ItemREMOVE, ClassText)-1) + length(ItemREMOVE) = length(ClassText)) then
    begin
     if ((Pos(ItemREMOVE, ClassText)-1) + length(ItemREMOVE) = length(ClassText)) then
     NewClassText:= Copy(ClassText, 1, length(ClassText) - length(ItemREMOVE))
     else
     if (Pos(' '+ItemREMOVE+' ', ClassText) >= 1) then
     NewClassText:= StringReplace(AHTML, ' '+ItemREMOVE+' ', ' ', [rfIgnoreCase])
     else
     NewClassText:= Copy(ClassText, length(ItemREMOVE)+1, length(ClassText));

     NewClassText:= Trim(NewClassText);

     result:= StringReplace(AHTML, ATag+'="'+ClassText+'"', ATag+'="'+NewClassText+'"', [rfIgnoreCase]);
    end else
    Result:= AHTML;
  end else
  begin
    // Não há atributo class
    Result := AHTML;
  end;
end;


function HTMLAddItemFromClass(AHTML, ItemADD: String): String;
begin
 Result:= HTMLAddItemFromTag(AHTML, 'class', ItemADD);
end;


function HTMLRemoveItemFromClass(AHTML, ItemREMOVE: String): String;
begin
 Result:= HTMLRemoveItemFromTag(AHTML, 'class', ItemREMOVE);
end;

function HTMLAddItemFromStyle(AHTML, ItemADD, ItemAValue: String): String;
var
 ATag: string;
 PosInit, PosEnd: integer;
 ItemPosInit, ItemPosEnd: integer;
 StyleText: string;
 ItemStyleText: string;
 vExistPos: boolean;
begin
 ATag:= 'style';
 ItemStyleText:= '';
 ItemPosInit:= -1;

 if (Pos(' '+AnsiUpperCase(ATag)+'="', AnsiUpperCase(AHTML)) >= 1) then
 begin
  PosInit:= Pos(AnsiUpperCase(ATag)+'="', AnsiUpperCase(AHTML)) + Length(ATag+'="');
  PosEnd:= Pos('"', AnsiUpperCase(Copy(AHTML, PosInit)));
  StyleText:= Copy(AHTML, PosInit, PosEnd-1);

  StyleText:= Trim(StyleText);

  repeat
   StyleText:= StringReplace(StyleText, '; ', ';', [rfReplaceAll]);
   vExistPos:= Pos('; ', StyleText) > 0;
  until not vExistPos;
  repeat
   StyleText:= StringReplace(StyleText, ' ;', ';', [rfReplaceAll]);
   vExistPos:= Pos(' ;', StyleText) > 0;
  until not vExistPos;
  repeat
   StyleText:= StringReplace(StyleText, ': ', ':', [rfReplaceAll]);
   vExistPos:= Pos(': ', StyleText) > 0;
  until not vExistPos;
  repeat
   StyleText:= StringReplace(StyleText, ' :', ':', [rfReplaceAll]);
   vExistPos:= Pos(' :', StyleText) > 0;
  until not vExistPos;

  if Copy(StyleText, Length(StyleText)) <> ';' then
   StyleText:= StyleText + ';';

  if (Pos(AnsiUpperCase(ItemADD)+':', AnsiUpperCase(StyleText)) = 1) then
   ItemPosInit:= Pos(AnsiUpperCase(ItemADD)+':', AnsiUpperCase(StyleText)) + Length(ItemADD+':')
  else
   if (Pos(';'+AnsiUpperCase(ItemADD)+':', AnsiUpperCase(StyleText)) >= 1) then
    ItemPosInit:= Pos(';'+AnsiUpperCase(ItemADD)+':', AnsiUpperCase(StyleText));

  if ItemPosInit >= 0 then
  begin
   ItemPosEnd:= Pos(';', AnsiUpperCase(Copy(StyleText, ItemPosInit + 1)));
   if ItemPosEnd <= 0 then
    ItemPosEnd:= Pos(';', AnsiUpperCase(Copy(StyleText, ItemPosInit)));
   ItemStyleText:= Copy(StyleText, ItemPosInit + 1, ItemPosEnd);

   StyleText:= StringReplace(StyleText, ItemStyleText, '', [rfReplaceAll, rfIgnoreCase]);
  end;

  ItemStyleText:= ItemADD + ':' + ItemAValue + ';';

  StyleText:= StyleText + ItemStyleText;

  AHTML:= Copy(AHTML, 1, PosInit-1) + StyleText + Copy(AHTML, PosInit + PosEnd -1);
 end;

 Result:= AHTML;
end;


function HTMLRemoveItemFromStyle(AHTML, ItemREMOVE: String; ItemREMOVEValue: string = ''): String;
var
 ATag: string;
 PosInit, PosEnd: integer;
 ItemPosInit, ItemPosEnd: integer;
 StyleText: string;
 ItemStyleText, ItemStyleValue: string;
 vExistPos: boolean;
begin
 ATag:= 'style';
 ItemStyleText:= '';
 ItemPosInit:= -1;

 if (Pos(' '+AnsiUpperCase(ATag)+'="', AnsiUpperCase(AHTML)) >= 1) then
 begin
  PosInit:= Pos(AnsiUpperCase(ATag)+'="', AnsiUpperCase(AHTML)) + Length(ATag+'="');
  PosEnd:= Pos('"', AnsiUpperCase(Copy(AHTML, PosInit)));
  StyleText:= Copy(AHTML, PosInit, PosEnd-1);

  StyleText:= Trim(StyleText);

  repeat
   StyleText:= StringReplace(StyleText, '; ', ';', [rfReplaceAll]);
   vExistPos:= Pos('; ', StyleText) > 0;
  until not vExistPos;
  repeat
   StyleText:= StringReplace(StyleText, ' ;', ';', [rfReplaceAll]);
   vExistPos:= Pos(' ;', StyleText) > 0;
  until not vExistPos;
  repeat
   StyleText:= StringReplace(StyleText, ': ', ':', [rfReplaceAll]);
   vExistPos:= Pos(': ', StyleText) > 0;
  until not vExistPos;
  repeat
   StyleText:= StringReplace(StyleText, ' :', ':', [rfReplaceAll]);
   vExistPos:= Pos(' :', StyleText) > 0;
  until not vExistPos;

  if Copy(StyleText, Length(StyleText)) <> ';' then
   StyleText:= StyleText + ';';

  if (Pos(AnsiUpperCase(ItemREMOVE)+':', AnsiUpperCase(StyleText)) = 1) then
   ItemPosInit:= Pos(AnsiUpperCase(ItemREMOVE)+':', AnsiUpperCase(StyleText))
  else
   if (Pos(';'+AnsiUpperCase(ItemREMOVE)+':', AnsiUpperCase(StyleText)) >= 1) then
    ItemPosInit:= Pos(';'+AnsiUpperCase(ItemREMOVE)+':', AnsiUpperCase(StyleText));

  if ItemPosInit >= 0 then
  begin
   ItemPosEnd:= Pos(';', AnsiUpperCase(Copy(StyleText, ItemPosInit + 1)));
   if ItemPosEnd <= 0 then
    ItemPosEnd:= Pos(';', AnsiUpperCase(Copy(StyleText, ItemPosInit)));
   ItemStyleText:= Copy(StyleText, ItemPosInit, ItemPosEnd);

   if ItemREMOVEValue <> '' then
   begin
    ItemStyleValue:= '';

    if Pos(':', ItemStyleText) > 0 then
     ItemStyleValue:= Copy(ItemStyleText, Pos(':', ItemStyleText)+1);

    if SameText(Trim(ItemREMOVEValue), Trim(ItemStyleValue)) then
     StyleText:= StringReplace(StyleText, ItemStyleText, '', [rfReplaceAll, rfIgnoreCase]);
   end else
   begin
    StyleText:= StringReplace(StyleText, ItemStyleText, '', [rfReplaceAll, rfIgnoreCase]);
   end;

   if Pos(';', StyleText) = 1 then
    StyleText:= Copy(StyleText, 2);
  end;

  AHTML:= Copy(AHTML, 1, PosInit-1) + StyleText + Copy(AHTML, PosInit + PosEnd -1);
 end;

 Result:= AHTML;
end;

function ExistForClass(ACSSClass, ASearch: String): boolean;
begin
 result:= false;

 if (Pos(ASearch, ACSSClass) = 1) or (Pos(' '+ASearch+'', ACSSClass) > 1) then
  result:= true;
end;

function ConvertHTMLKeyToVK(KeyName: string): Word;
begin
  KeyName := LowerCase(KeyName); // Converter para minúsculas para mapeamento insensível a maiúsculas e minúsculas

  if KeyName = 'arrowleft' then
    Result := VK_LEFT
  else if KeyName = 'arrowup' then
    Result := VK_UP
  else if KeyName = 'arrowright' then
    Result := VK_RIGHT
  else if KeyName = 'arrowdown' then
    Result := VK_DOWN
  else if KeyName = 'backspace' then
    Result := VK_BACK
  else if KeyName = 'tab' then
    Result := VK_TAB
  else if KeyName = 'enter' then
    Result := VK_RETURN
  else if KeyName = 'escape' then
    Result := VK_ESCAPE
  else if KeyName = 'space' then
    Result := VK_SPACE
  else if KeyName = 'control' then
    Result := VK_CONTROL
  else if KeyName = 'shift' then
    Result := VK_SHIFT
  else if KeyName = ' ' then
    Result := VK_SPACE
  else if KeyName = 'delete' then
    Result := VK_DELETE
  else if KeyName = 'insert' then
    Result := VK_INSERT
  else if KeyName = 'home' then
    Result := VK_HOME
  else if KeyName = 'end' then
    Result := VK_END
  else if KeyName = 'pageup' then
    Result := VK_PRIOR
  else if KeyName = 'pagedown' then
    Result := VK_NEXT
  else if KeyName = 'pause' then
    Result := VK_PAUSE
  else if KeyName = 'printscreen' then
    Result := VK_SNAPSHOT
  else if KeyName = 'scrolllock' then
    Result := VK_SCROLL
  else if KeyName = 'capslock' then
    Result := VK_CAPITAL
  else if KeyName = 'numlock' then
    Result := VK_NUMLOCK
  else if KeyName = 'f1' then
    Result := VK_F1
  else if KeyName = 'f2' then
    Result := VK_F2
  else if KeyName = 'f3' then
    Result := VK_F3
  else if KeyName = 'f4' then
    Result := VK_F4
  else if KeyName = 'f5' then
    Result := VK_F5
  else if KeyName = 'f6' then
    Result := VK_F6
  else if KeyName = 'f7' then
    Result := VK_F7
  else if KeyName = 'f8' then
    Result := VK_F8
  else if KeyName = 'f9' then
    Result := VK_F9
  else if KeyName = 'f10' then
    Result := VK_F10
  else if KeyName = 'f11' then
    Result := VK_F11
  else if KeyName = 'f12' then
    Result := VK_F12
  else if KeyName = 'a' then
    Result := Ord(WideChar('A'))
  else if KeyName = 'b' then
    Result := Ord(WideChar('B'))
  else if KeyName = 'c' then
    Result := Ord(WideChar('C'))
  else if KeyName = 'd' then
    Result := Ord(WideChar('D'))
  else if KeyName = 'e' then
    Result := Ord(WideChar('E'))
  else if KeyName = 'f' then
    Result := Ord(WideChar('F'))
  else if KeyName = 'g' then
    Result := Ord(WideChar('G'))
  else if KeyName = 'h' then
    Result := Ord(WideChar('H'))
  else if KeyName = 'i' then
    Result := Ord(WideChar('I'))
  else if KeyName = 'j' then
    Result := Ord(WideChar('J'))
  else if KeyName = 'k' then
    Result := Ord(WideChar('K'))
  else if KeyName = 'l' then
    Result := Ord(WideChar('L'))
  else if KeyName = 'm' then
    Result := Ord(WideChar('M'))
  else if KeyName = 'n' then
    Result := Ord(WideChar('N'))
  else if KeyName = 'o' then
    Result := Ord(WideChar('O'))
  else if KeyName = 'p' then
    Result := Ord(WideChar('P'))
  else if KeyName = 'q' then
    Result := Ord(WideChar('Q'))
  else if KeyName = 'r' then
    Result := Ord(WideChar('R'))
  else if KeyName = 's' then
    Result := Ord(WideChar('S'))
  else if KeyName = 't' then
    Result := Ord(WideChar('T'))
  else if KeyName = 'u' then
    Result := Ord(WideChar('U'))
  else if KeyName = 'v' then
    Result := Ord(WideChar('V'))
  else if KeyName = 'w' then
    Result := Ord(WideChar('W'))
  else if KeyName = 'x' then
    Result := Ord(WideChar('X'))
  else if KeyName = 'y' then
    Result := Ord(WideChar('Y'))
  else if KeyName = 'z' then
    Result := Ord(WideChar('Z'))
  else if KeyName = '0' then
    Result := Ord(WideChar('0'))
  else if KeyName = '1' then
    Result := Ord(WideChar('1'))
  else if KeyName = '2' then
    Result := Ord(WideChar('2'))
  else if KeyName = '3' then
    Result := Ord(WideChar('3'))
  else if KeyName = '4' then
    Result := Ord(WideChar('4'))
  else if KeyName = '5' then
    Result := Ord(WideChar('5'))
  else if KeyName = '6' then
    Result := Ord(WideChar('6'))
  else if KeyName = '7' then
    Result := Ord(WideChar('7'))
  else if KeyName = '8' then
    Result := Ord(WideChar('8'))
  else if KeyName = '9' then
    Result := Ord(WideChar('9'))
  else if KeyName = '!' then
    Result := Ord(WideChar('!'))
  else if KeyName = '@' then
    Result := Ord(WideChar('@'))
  else if KeyName = '#' then
    Result := Ord(WideChar('#'))
  else if KeyName = '$' then
    Result := Ord(WideChar('$'))
  else if KeyName = '%' then
    Result := Ord(WideChar('%'))
  else if KeyName = '^' then
    Result := Ord(WideChar('^'))
  else if KeyName = '&' then
    Result := Ord(WideChar('&'))
  else if KeyName = '*' then
    Result := Ord(WideChar('*'))
  else if KeyName = '(' then
    Result := Ord(WideChar('('))
  else if KeyName = ')' then
    Result := Ord(WideChar(')'))
  else if KeyName = '-' then
    Result := Ord(WideChar('-'))
  else if KeyName = '_' then
    Result := Ord(WideChar('_'))
  else if KeyName = '=' then
    Result := Ord(WideChar('='))
  else if KeyName = '+' then
    Result := Ord(WideChar('+'))
  else if KeyName = '[' then
    Result := Ord(WideChar('['))
  else if KeyName = ']' then
    Result := Ord(WideChar(']'))
  else if KeyName = '{' then
    Result := Ord(WideChar('{'))
  else if KeyName = '}' then
    Result := Ord(WideChar('}'))
  else if KeyName = '/' then
    Result := Ord(WideChar('/'))
  else if KeyName = '?' then
    Result := Ord(WideChar('?'))
  else if KeyName = ';' then
    Result := Ord(WideChar(';'))
  else if KeyName = ':' then
    Result := Ord(WideChar(':'))
  else if KeyName = '~' then
    Result := Ord(WideChar('~'))
  else if KeyName = '^' then
    Result := Ord(WideChar('^'))
  else if KeyName = '´' then
    Result := Ord(WideChar('´'))
  else if KeyName = '`' then
    Result := Ord(WideChar('`'))
  else if KeyName = '"' then
    Result := Ord(WideChar('"'))
  else if KeyName = '''' then
    Result := Ord(WideChar(''''))
  else
    Result := 0; // Valor padrão para tecla não mapeada
end;

function IsJSONValid(const AMessage: string): Boolean;
var
  JSONValue: TJSONValue;
begin
  Result := False;

  if AMessage.Trim = '' then
    Exit;

  try
    JSONValue := TJSONObject.ParseJSONValue(AMessage);

    if Assigned(JSONValue) then
    begin
      Result := True;
      JSONValue.Free;
    end;
  except
    on E: Exception do
      if E.ClassName = 'EJSONParseException' then
        Result := False
      else
        Result := False
  end;
end;


function SubtractPaths(const Path, SubPath: string): string;
begin
  // Use a função SameText para comparar as partes iniciais de Path e SubPath independentemente de serem maiúsculas ou minúsculas
  if SameText(Path, Copy(SubPath, 1, Length(Path))) then
    Result := Copy(SubPath, Length(Path) + 1, MaxInt)
  else
    Result := SubPath;
end;


function PrismFieldType(AFieldType: TFieldType): TPrismFieldType;
begin
 Result:= TPrismFieldType.PrismFieldTypeString;

 if AFieldType in [ftFloat, ftCurrency, ftBCD, ftFMTBcd{$IFDEF SUPPORTS_FTEXTENDED}, ftExtended{$ENDIF}] then
  Result:= PrismFieldTypeNumber
 else
 if AFieldType in [ftSmallint, ftInteger, ftWord, ftAutoInc, ftLargeint{$IFDEF SUPPORTS_FTEXTENDED}, ftLongWord, ftShortint, ftSingle{$ENDIF}] then
  Result:= PrismFieldTypeInteger
 else
 if AFieldType in [ftDate] then
  Result:= PrismFieldTypeDate
 else
 if AFieldType in [ftDateTime, ftTimeStamp] then
  Result:= PrismFieldTypeDateTime
 else
 if AFieldType in [ftTime{$IFNDEF FPC}, ftTimeStampOffset{$ENDIF}] then
  Result:= PrismFieldTypeTime
end;

function InputHTMLTypeByPrismFieldType(APrismFieldType: TPrismFieldType): string;
begin
 Result:= '';

 if APrismFieldType = PrismFieldTypeNumber then
 begin
  Result:= 'type="number"';
 end else
 if APrismFieldType = PrismFieldTypeInteger then
 begin
  Result:= 'type="number"';
 end else
 if APrismFieldType = PrismFieldTypeDate then
 begin
  Result:= 'type="date"';
 end else
 if APrismFieldType = PrismFieldTypeDateTime then
 begin
  Result:= 'type="datetime-local"';
 end else
 if APrismFieldType = PrismFieldTypeTime then
 begin
  Result:= 'type="time"';
 end else
 if APrismFieldType = PrismFieldTypePassword then
 begin
  Result:= 'type="password"';
 end else
  Result:= 'type="text"';

end;


Function ExtractDecimal(AValue: String): string;
const
  Str : string = '1234567890,.';
var
  i,x: integer;
  NotExists: boolean;
begin
 Result:= '';

 for i := 0 to Length(AValue)-1 do
 begin
  NotExists:= false;

  for x := 0 to Length(Str)-1 do
  if (AValue.Chars[i] = Str.Chars[x]) and (AValue.Chars[i] <> ' ') then
  begin
   NotExists:= true;
   break;
  end;

  if NotExists = true then
  begin
   result:= result + AValue.Chars[i];
  end;
 end;
end;


function FixFloat(AValue: String; AFormatSettings: TFormatSettings): String; overload;
begin
 result:= StringReplace(PrepareFloat(AValue, AFormatSettings), AFormatSettings.ThousandSeparator, '', [rfReplaceAll]);
end;

function FixFloat(AValue: String): String;
var
 vQtyDecimalSeparator, vQtyThousandSeparator: Integer;
 I: Integer;
 vDecimalSeparator, vThousandSeparator: string;
begin
 AValue:= ExtractDecimal(AValue);

 vQtyDecimalSeparator:= 0;
 vQtyThousandSeparator:= 0;

 vDecimalSeparator:= '.';
 vThousandSeparator:= ',';

 for I := 0 to Pred(Length(AValue)) do
 begin
  if AValue[I] = vDecimalSeparator then
   inc(vQtyDecimalSeparator)
  else
  if AValue[I] = vThousandSeparator then
   inc(vQtyThousandSeparator);
 end;

 if vQtyDecimalSeparator > 1 then
 begin
  AValue:= StringReplace(AValue, vDecimalSeparator, '', [rfReplaceAll]);
  AValue:= StringReplace(AValue, vThousandSeparator, vDecimalSeparator, [rfReplaceAll]);
 end else
 if (vQtyDecimalSeparator = 0) and (vQtyThousandSeparator = 1) then
 begin
  AValue:= StringReplace(AValue, vThousandSeparator, vDecimalSeparator, [rfReplaceAll]);
 end else
 if (vQtyDecimalSeparator = 0) and (vQtyThousandSeparator > 1) then
 begin
  AValue:= StringReplace(AValue, vThousandSeparator, '', [rfReplaceAll]);
 end;
 if Pos(vThousandSeparator, AValue) > Pos(vDecimalSeparator, AValue) then
 begin
  AValue:= StringReplace(AValue, vDecimalSeparator, '', [rfReplaceAll]);
  AValue:= StringReplace(AValue, vThousandSeparator, vDecimalSeparator, [rfReplaceAll]);
 end;

 Result:= AValue;
end;


function PrepareFloat(AValue: String; AFormatSettings: TFormatSettings): String;
var
 vQtyDecimalSeparator, vQtyThousandSeparator: Integer;
 I: Integer;
begin
 AValue:= ExtractDecimal(AValue);

 vQtyDecimalSeparator:= 0;
 vQtyThousandSeparator:= 0;

 if AFormatSettings.DecimalSeparator = '' then
 AFormatSettings.DecimalSeparator:= '.';
 if AFormatSettings.ThousandSeparator = '' then
 AFormatSettings.ThousandSeparator:= ',';

 for I := 1 to Length(AValue) do
 begin
  if AValue[I] = AFormatSettings.DecimalSeparator then
   inc(vQtyDecimalSeparator)
  else
  if AValue[I] = AFormatSettings.ThousandSeparator then
   inc(vQtyThousandSeparator);
 end;

 if vQtyDecimalSeparator > 1 then
 begin
  AValue:= StringReplace(AValue, AFormatSettings.DecimalSeparator, '', [rfReplaceAll]);
  AValue:= StringReplace(AValue, AFormatSettings.ThousandSeparator, AFormatSettings.DecimalSeparator, [rfReplaceAll]);
 end else
 if (vQtyDecimalSeparator = 0) and (vQtyThousandSeparator = 1) then
 begin
  AValue:= StringReplace(AValue, AFormatSettings.ThousandSeparator, AFormatSettings.DecimalSeparator, [rfReplaceAll]);
 end else
 if (vQtyDecimalSeparator = 0) and (vQtyThousandSeparator > 1) then
 begin
  AValue:= StringReplace(AValue, AFormatSettings.ThousandSeparator, '', [rfReplaceAll]);
 end;

 Result:= AValue;
end;


function FixDateTimeByFormat(AValue: String; AOldDateTime: TDateTime; ANewDateTimeFormat: string; ADefaultDateTimeFormat: string): String;
const
 vSeparators = '-/:.';
var
 vDefaultDateValue, vFormatedDateValue: string;
 vFieldFormat: string;
 vNewFormatDistiller: TStrings;
 vNewDateDistiller: TStrings;
 vDay, vMonth, vYear, vHour, vMinute, vSec, vMSec: Word;
 vDateParteInt: integer;
 vBlock: string;
 I: integer;
begin
 AValue:= Trim(AValue);

 Result:= AValue;

 vNewFormatDistiller:= TStringList.Create;
 vNewDateDistiller:= TStringList.Create;
 vBlock:= '';

 try
  try
   //Distiller new DateTime Format
   for I := 1 to Length(ANewDateTimeFormat) do
   begin
    if (Pos(ANewDateTimeFormat[I], vSeparators) > 0) or (ANewDateTimeFormat[I] = ' ') then
    begin
     if vBlock <> '' then
      vNewFormatDistiller.Add(vBlock);
     vBlock:= '';
    end else
    begin
     vBlock:= vBlock + ANewDateTimeFormat[I];
    end;
   end;
   if vBlock <> '' then
    vNewFormatDistiller.Add(vBlock);
   vBlock:= '';


   //Distiller AValue (new DataTime)
   for I := 1 to Length(AValue) do
   begin
    if (Pos(AValue[I], vSeparators) > 0) or (AValue[I] = ' ') then
    begin
     if vBlock <> '' then
      vNewDateDistiller.Add(vBlock);
     vBlock:= '';
    end else
    begin
     vBlock:= vBlock + AValue[I];
    end;
   end;
   if vBlock <> '' then
    vNewDateDistiller.Add(vBlock);
   vBlock:= '';


   //Decode Old DataTime
   DecodeDateTime(AOldDateTime, vYear, vMonth, vDay, vHour, vMinute, vSec, vMSec);


   //Set Decoded DateTime Values
   for I := 0 to Pred(vNewFormatDistiller.Count) do
   begin
    if vNewDateDistiller.Count >= I then
    begin
     if Pos('y', vNewFormatDistiller[i]) > 0 then
      if TryStrToInt(vNewDateDistiller[I], vDateParteInt) then
      begin
       if (vYear > 99) and (vDateParteInt <= 99) then //Fix 1900s 2000s
        vYear:= vDateParteInt + ((vYear div 100) * 100)
       else
        vYear:= vDateParteInt;
      end;

     if Pos('m', LowerCase(vNewFormatDistiller[i])) > 0 then
      if TryStrToInt(vNewDateDistiller[I], vDateParteInt) then
       vMonth:= vDateParteInt;

     if Pos('d', LowerCase(vNewFormatDistiller[i])) > 0 then
      if TryStrToInt(vNewDateDistiller[I], vDateParteInt) then
       vDay:= vDateParteInt;

     if Pos('h', LowerCase(vNewFormatDistiller[i])) > 0 then
      if TryStrToInt(vNewDateDistiller[I], vDateParteInt) then
       vHour:= vDateParteInt;

     if Pos('n', LowerCase(vNewFormatDistiller[i])) > 0 then
      if TryStrToInt(vNewDateDistiller[I], vDateParteInt) then
       vMinute:= vDateParteInt;

     if Pos('s', LowerCase(vNewFormatDistiller[i])) > 0 then
      if TryStrToInt(vNewDateDistiller[I], vDateParteInt) then
       vSec:= vDateParteInt;

     if Pos('z', LowerCase(vNewFormatDistiller[i])) > 0 then
      if TryStrToInt(vNewDateDistiller[I], vDateParteInt) then
       vMSec:= vDateParteInt;
    end;
   end;

   Result:= FormatDateTime(ADefaultDateTimeFormat, EncodeDateTime(vYear, vMonth, vDay, vHour, vMinute, vSec, vMSec));
  except
  end;
 finally
  vNewFormatDistiller.Free;
  vNewDateDistiller.Free;
 end;
end;

function FloatToHTMLElement(AValue: double): String;
begin
 result:= FloatToStr(AValue, PrismBaseClass.Options.HTMLFormatSettings);
end;

function FloatFromHTMLElement(AValue: string): double;
begin
 Result:= StrToFloat(AValue, PrismBaseClass.Options.HTMLFormatSettings);
end;


function DateToHTMLElement(AValue: TDate): String;
begin
 result:= FormatDateTime(PrismBaseClass.Options.HTMLFormatSettings.ShortDateFormat, AValue);
end;

function DateFromHTMLElement(AValue: string): TDate;
begin
 result:= StrToDate(AValue, PrismBaseClass.Options.HTMLFormatSettings);
end;

function TimeToHTMLElement(AValue: TTime): String;
begin
 result:= FormatDateTime(PrismBaseClass.Options.HTMLFormatSettings.ShortTimeFormat, AValue);
end;

function TimeFromHTMLElement(AValue: string): TTime;
begin
 result:= StrToTime(AValue, PrismBaseClass.Options.HTMLFormatSettings);
end;

function DateTimeToHTMLElement(AValue: TDateTime): String;
begin
 result:= FormatDateTime(PrismBaseClass.Options.HTMLFormatSettings.ShortDateFormat, AValue);
end;

function DateTimeFromHTMLElement(AValue: string): TDateTime;
begin
 result:= StrToDateTime(AValue, PrismBaseClass.Options.HTMLFormatSettings);
end;

function DataFieldValueToHTMLElement(AValue: String; APrismFieldType: TPrismFieldType): String;
begin
 result:= '';

 if APrismFieldType in [PrismFieldTypeDate] then
 begin
   Result:= DateToHTMLElement(StrToDate(AValue, FormatSettings));
 end else
 if APrismFieldType in [PrismFieldTypeDateTime] then
 begin
  //Result:= DateTimeToHTMLElement(AValue)
 end else
 if APrismFieldType in [PrismFieldTypeTime] then
 begin
  //Result:= TimeToHTMLElement(AValue)
 end else
 if APrismFieldType in [PrismFieldTypeNumber] then
 begin
  //Result:= FloatToHTMLElement(AValue)
 end else
  Result:= AValue
end;

function DataFieldValueFromHTMLElement(AValue: String; APrismFieldType: TPrismFieldType): Variant;
begin
 if APrismFieldType in [PrismFieldTypeDate] then
 begin
  if (AValue = '') or (AValue = '0') then
   Result:= Date
  else
   Result:= DateFromHTMLElement(AValue);
 end else
 if APrismFieldType in [PrismFieldTypeDateTime] then
 begin
  if (AValue = '') or (AValue = '0') then
   Result:= Date
  else
   Result:= DateTimeFromHTMLElement(AValue)
 end else
 if APrismFieldType in [PrismFieldTypeTime] then
 begin
  if (AValue = '') or (AValue = '00:00') or (AValue = '00:00:00') or (AValue = '0') then
   Result:= Time
  else
   Result:= TimeFromHTMLElement(AValue)
 end else
 if APrismFieldType in [PrismFieldTypeNumber] then
 begin
  if (AValue = '') or (AValue = '0') then
   Result:= 0
  else
    Result:= FloatFromHTMLElement(AValue)
 end else
  Result:= AValue
end;




function FormatOfFloat(AFormatSettings: TFormatSettings): string; overload;
begin
 result:= FormatOfFloat(AFormatSettings, 4);
end;

function FormatOfFloat(AFormatSettings: TFormatSettings; ADecimalPlaces: integer): string; overload;
var
 vDecimalPlaces: string;
 I: integer;
begin
 vDecimalPlaces:= '';

 if ADecimalPlaces > 0 then
 for I := 0 to Pred(ADecimalPlaces) do
  vDecimalPlaces:= vDecimalPlaces + '0';

// if AFormatSettings.ThousandSeparator <> '' then
// begin
//  Result:= '#'+AFormatSettings.ThousandSeparator+'##0'+ IfThen(ADecimalPlaces > 0, AFormatSettings.DecimalSeparator+vDecimalPlaces)
// end else
//  Result:= '0'+IfThen(ADecimalPlaces > 0, AFormatSettings.DecimalSeparator+vDecimalPlaces);

 if AFormatSettings.ThousandSeparator <> '' then
 begin
  Result:= '#'+','+'##0'+ IfThen(ADecimalPlaces > 0, '.'+vDecimalPlaces)
 end else
  Result:= '0'+IfThen(ADecimalPlaces > 0, '.'+vDecimalPlaces);

end;

function FormatOfCurrency(AFormatSettings: TFormatSettings; FUseCurSymbol: boolean = false): string;
var
 vDecimalPlaces: string;
 I: integer;
begin
 vDecimalPlaces:= '';

 for I := 0 to Pred(AFormatSettings.CurrencyDecimals) do
  vDecimalPlaces:= vDecimalPlaces + '0';

// if AFormatSettings.ThousandSeparator <> '' then
// begin
//  Result:= '#'+AFormatSettings.ThousandSeparator+'##0'+ IfThen(ADecimalPlaces > 0, AFormatSettings.DecimalSeparator+vDecimalPlaces)
// end else
//  Result:= '0'+IfThen(ADecimalPlaces > 0, AFormatSettings.DecimalSeparator+vDecimalPlaces);

 if AFormatSettings.ThousandSeparator <> '' then
 begin
  Result:= IfThen(FUseCurSymbol, AFormatSettings.CurrencyString + ' ') + '#'+','+'##0'+ IfThen(AFormatSettings.CurrencyDecimals > 0, '.'+vDecimalPlaces)
 end else
  Result:= IfThen(FUseCurSymbol, AFormatSettings.CurrencyString + ' ') + '0'+IfThen(AFormatSettings.CurrencyDecimals > 0, '.'+vDecimalPlaces);

end;

end.
