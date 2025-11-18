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

unit D2Bridge.Lang.Util;

interface

uses
  Classes, SysUtils, TypInfo,
  D2Bridge.Types;

type
  TLanguageCodeInfo = record
    Code: string;
    LCID: Integer;
    Name: string;
  end;

 function LanguageName(D2BridgeLang: TD2BridgeLang): string;
 function LanguageCode(D2BridgeLang: TD2BridgeLang): string;
 function D2BridgeLangbyLanguageName(ALanguage: string): TD2BridgeLang;
 function AllLanguages: TD2BridgeLangs;

const
 LANGUAGESCodeInfo: array [0..91] of TLanguageCodeInfo = (
    (Code: 'af-za'; LCID: 1078; Name: 'Afrikaans (South Africa)'),
    (Code: 'ar-sa'; LCID: 1025; Name: 'Arabic (Saudi Arabia)'),
    (Code: 'ar-iq'; LCID: 2049; Name: 'Arabic (Iraq)'),
    (Code: 'ar-eg'; LCID: 3073; Name: 'Arabic (Egypt)'),
    (Code: 'ar-ly'; LCID: 4097; Name: 'Arabic (Libya)'),
    (Code: 'ar-dz'; LCID: 5121; Name: 'Arabic (Algeria)'),
    (Code: 'ar-ma'; LCID: 6145; Name: 'Arabic (Morocco)'),
    (Code: 'ar-tn'; LCID: 7169; Name: 'Arabic (Tunisia)'),
    (Code: 'ar-om'; LCID: 8193; Name: 'Arabic (Oman)'),
    (Code: 'ar-ye'; LCID: 9217; Name: 'Arabic (Yemen)'),
    (Code: 'ar-sy'; LCID: 10241; Name: 'Arabic (Syria)'),
    (Code: 'ar-jo'; LCID: 11265; Name: 'Arabic (Jordan)'),
    (Code: 'ar-lb'; LCID: 12289; Name: 'Arabic (Lebanon)'),
    (Code: 'ar-kw'; LCID: 13313; Name: 'Arabic (Kuwait)'),
    (Code: 'ar-ae'; LCID: 14337; Name: 'Arabic (U.A.E.)'),
    (Code: 'ar-bh'; LCID: 15361; Name: 'Arabic (Bahrain)'),
    (Code: 'ar-qa'; LCID: 16385; Name: 'Arabic (Qatar)'),
    (Code: 'be-by'; LCID: 1059; Name: 'Belarusian (Belarus)'),
    (Code: 'bg-bg'; LCID: 1026; Name: 'Bulgarian (Bulgaria)'),
    (Code: 'ca-es'; LCID: 1027; Name: 'Catalan (Spain)'),
    (Code: 'cs-cz'; LCID: 1029; Name: 'Czech (Czech Republic)'),
    (Code: 'da-dk'; LCID: 1030; Name: 'Danish (Denmark)'),
    (Code: 'de-de'; LCID: 1031; Name: 'German (Germany)'),
    (Code: 'de-ch'; LCID: 2055; Name: 'German (Switzerland)'),
    (Code: 'de-at'; LCID: 3079; Name: 'German (Austria)'),
    (Code: 'de-lu'; LCID: 4103; Name: 'German (Luxembourg)'),
    (Code: 'de-li'; LCID: 5127; Name: 'German (Liechtenstein)'),
    (Code: 'el-gr'; LCID: 1032; Name: 'Greek (Greece)'),
    (Code: 'en-us'; LCID: 1033; Name: 'English (United States)'),
    (Code: 'en-gb'; LCID: 2057; Name: 'English (United Kingdom)'),
    (Code: 'en-au'; LCID: 3081; Name: 'English (Australia)'),
    (Code: 'en-ca'; LCID: 4105; Name: 'English (Canada)'),
    (Code: 'en-nz'; LCID: 5129; Name: 'English (New Zealand)'),
    (Code: 'en-ie'; LCID: 6153; Name: 'English (Ireland)'),
    (Code: 'en-za'; LCID: 7177; Name: 'English (South Africa)'),
    (Code: 'en-jm'; LCID: 8201; Name: 'English (Jamaica)'),
    (Code: 'en-bz'; LCID: 10249; Name: 'English (Belize)'),
    (Code: 'en-tt'; LCID: 11273; Name: 'English (Trinidad)'),
    (Code: 'es-es'; LCID: 1034; Name: 'Spanish (Spain - Traditional)'),
    (Code: 'es-mx'; LCID: 2058; Name: 'Spanish (Mexico)'),
    (Code: 'es-gt'; LCID: 4106; Name: 'Spanish (Guatemala)'),
    (Code: 'es-cr'; LCID: 5130; Name: 'Spanish (Costa Rica)'),
    (Code: 'es-pa'; LCID: 6154; Name: 'Spanish (Panama)'),
    (Code: 'es-do'; LCID: 7178; Name: 'Spanish (Dominican Republic)'),
    (Code: 'es-ve'; LCID: 8202; Name: 'Spanish (Venezuela)'),
    (Code: 'es-co'; LCID: 9226; Name: 'Spanish (Colombia)'),
    (Code: 'es-pe'; LCID: 10250; Name: 'Spanish (Peru)'),
    (Code: 'es-ar'; LCID: 11274; Name: 'Spanish (Argentina)'),
    (Code: 'es-ec'; LCID: 12298; Name: 'Spanish (Ecuador)'),
    (Code: 'es-cl'; LCID: 13322; Name: 'Spanish (Chile)'),
    (Code: 'es-uy'; LCID: 14346; Name: 'Spanish (Uruguay)'),
    (Code: 'es-py'; LCID: 15370; Name: 'Spanish (Paraguay)'),
    (Code: 'es-bo'; LCID: 16394; Name: 'Spanish (Bolivia)'),
    (Code: 'es-sv'; LCID: 17418; Name: 'Spanish (El Salvador)'),
    (Code: 'es-hn'; LCID: 18442; Name: 'Spanish (Honduras)'),
    (Code: 'es-ni'; LCID: 19466; Name: 'Spanish (Nicaragua)'),
    (Code: 'es-pr'; LCID: 20490; Name: 'Spanish (Puerto Rico)'),
    (Code: 'et-ee'; LCID: 1061; Name: 'Estonian (Estonia)'),
    (Code: 'fi-fi'; LCID: 1035; Name: 'Finnish (Finland)'),
    (Code: 'fr-fr'; LCID: 1036; Name: 'French (France)'),
    (Code: 'fr-be'; LCID: 2060; Name: 'French (Belgium)'),
    (Code: 'fr-ca'; LCID: 3084; Name: 'French (Canada)'),
    (Code: 'fr-ch'; LCID: 4108; Name: 'French (Switzerland)'),
    (Code: 'fr-lu'; LCID: 5132; Name: 'French (Luxembourg)'),
    (Code: 'he-il'; LCID: 1037; Name: 'Hebrew (Israel)'),
    (Code: 'hu-hu'; LCID: 1038; Name: 'Hungarian (Hungary)'),
    (Code: 'is-is'; LCID: 1039; Name: 'Icelandic (Iceland)'),
    (Code: 'it-it'; LCID: 1040; Name: 'Italian (Italy)'),
    (Code: 'it-ch'; LCID: 2064; Name: 'Italian (Switzerland)'),
    (Code: 'ja-jp'; LCID: 1041; Name: 'Japanese (Japan)'),
    (Code: 'ko-kr'; LCID: 1042; Name: 'Korean (Korea)'),
    (Code: 'lt-lt'; LCID: 1063; Name: 'Lithuanian (Lithuania)'),
    (Code: 'lv-lv'; LCID: 1062; Name: 'Latvian (Latvia)'),
    (Code: 'nb-no'; LCID: 1044; Name: 'Norwegian (Bokmål - Norway)'),
    (Code: 'nl-nl'; LCID: 1043; Name: 'Dutch (Netherlands)'),
    (Code: 'nl-be'; LCID: 2067; Name: 'Dutch (Belgium)'),
    (Code: 'pl-pl'; LCID: 1045; Name: 'Polish (Poland)'),
    (Code: 'pt-br'; LCID: 1046; Name: 'Portuguese (Brazil)'),
    (Code: 'pt-pt'; LCID: 2070; Name: 'Portuguese (Portugal)'),
    (Code: 'ro-ro'; LCID: 1048; Name: 'Romanian (Romania)'),
    (Code: 'ru-ru'; LCID: 1049; Name: 'Russian (Russia)'),
    (Code: 'sk-sk'; LCID: 1051; Name: 'Slovak (Slovakia)'),
    (Code: 'sl-si'; LCID: 1060; Name: 'Slovenian (Slovenia)'),
    (Code: 'sr-sp'; LCID: 3098; Name: 'Serbian (Serbia - Latin)'),
    (Code: 'sv-se'; LCID: 1053; Name: 'Swedish (Sweden)'),
    (Code: 'th-th'; LCID: 1054; Name: 'Thai (Thailand)'),
    (Code: 'tr-tr'; LCID: 1055; Name: 'Turkish (Turkey)'),
    (Code: 'uk-ua'; LCID: 1058; Name: 'Ukrainian (Ukraine)'),
    (Code: 'zh-cn'; LCID: 2052; Name: 'Chinese (Simplified - China)'),
    (Code: 'zh-tw'; LCID: 1028; Name: 'Chinese (Traditional - Taiwan)'),
    (Code: 'zh-hk'; LCID: 3076; Name: 'Chinese (Hong Kong SAR)'),
    (Code: 'zh-sg'; LCID: 4100; Name: 'Chinese (Singapore)')
  );

implementation


function LanguageName(D2BridgeLang: TD2BridgeLang): string;
begin
  Result := GetEnumName(TypeInfo(TD2BridgeLang), Ord(D2BridgeLang));
end;


function LanguageCode(D2BridgeLang: TD2BridgeLang): string;
begin
 case D2BridgeLang of
    English: Result := 'en-US';
    Portuguese: Result := 'pt-BR';
    Spanish: Result := 'es-ES';
    Arabic: Result := 'ar-SA';
    Italian: Result := 'it-IT';
    French: Result := 'fr-FR';
    German: Result := 'de-DE';
    Japanese: Result := 'ja-JP';
    Russian: Result := 'ru-RU';
    Chinese: Result := 'zh-CN';
    Czech: Result := 'cs-CZ';
    Turkish: Result := 'tr-TR';
    Korean: Result := 'ko-KR';
    Romanian: Result := 'ro-RO';
    Persian: Result := 'fa-IR';
    Thai: Result := 'th-TH';
    Ukrainian: Result := 'uk-UA';
    Polish: Result := 'pl-PL';
  else
    Result := '';
  end;
end;


function D2BridgeLangbyLanguageName(ALanguage: string): TD2BridgeLang;
var
  LangEnum: TD2BridgeLang;
begin
  ALanguage := LowerCase(ALanguage);

  for LangEnum := Low(TD2BridgeLang) to High(TD2BridgeLang) do
  begin
    if LowerCase(LanguageName(LangEnum)) = ALanguage then
    begin
      Result := LangEnum;
      Exit;
    end;
  end;

  Result := English; // Default to English if no match is found
end;


function AllLanguages: TD2BridgeLangs;
var
  Lang: TD2BridgeLang;
begin
  Result := [];
  for Lang := Low(TD2BridgeLang) to High(TD2BridgeLang) do
  begin
    Include(Result, Lang);
  end;
end;


end.