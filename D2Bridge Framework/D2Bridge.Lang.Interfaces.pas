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

unit D2Bridge.Lang.Interfaces;

interface

uses
  SysUtils, Classes,
  D2Bridge.JSON, D2Bridge.Types;

type
 ID2BridgeTerm = interface;

 ID2BridgeLangBaseClass = interface
  ['{82D4CA56-F3ED-4DC1-8467-44D9D5F8FAB8}']
   procedure PopuleFieldTerms;
   procedure LoadJSONfromResource;
   procedure ProcessJSONLang;
   function FormatSettings: TFormatSettings;
   function IsRTL: Boolean;

   function HTMLLangGeneric: string;

   function D2BridgeTerm: ID2BridgeTerm;
   function Translate(AContext: string; ATerm: string): string; overload;
   function Translate(ATerm: string): string; overload;
 end;


 ID2BridgeLang = interface(ID2BridgeLangBaseClass)
  ['{8142910F-0448-4CD7-B9EA-21C6A0A91DCB}']
   function D2BridgeLang: TD2BridgeLang;
   function HTMLLang: string;
   function LangName: string;

   Procedure DoConfigFormatSettings;
   procedure DoTranslate(const AContext: string; const ATerm: string; var ATranslated: string); overload;
   procedure DoTranslate(const ATerm: string; var ATranslated: string); overload;
 end;


 ID2BridgeTerm = interface
  ['{1F46AF57-98B9-4C89-BBF0-730C8620CF45}']
   function Language: ID2BridgeLang;
 end;


 ID2BridgeTermItem = interface
  ['{49FB6EFF-5C95-4CBC-9CC4-1F051F22709D}']
   function D2BridgeTerm: ID2BridgeTerm;
   function Language: ID2BridgeLang;
   function Context: string;
 end;


 ID2BridgeLangCoreBaseClass = interface
  ['{92E19852-3149-4521-A6FA-7B95520DF7D2}']
   function GetPortuguese: ID2BridgeLang;
   procedure SetPortuguese(Avalue: ID2BridgeLang);
   function GetEnglish: ID2BridgeLang;
   procedure SetEnglish(AValue: ID2BridgeLang);
   function GetSpanish: ID2BridgeLang;
   procedure SetSpanish(AValue: ID2BridgeLang);
   function GetArabic: ID2BridgeLang;
   procedure SetArabic(AValue: ID2BridgeLang);
   function GetItalian: ID2BridgeLang;
   function GetFrench: ID2BridgeLang;
   function GetGerman: ID2BridgeLang;
   function GetJapanese: ID2BridgeLang;
   function GetRussian: ID2BridgeLang;
   function GetChinese: ID2BridgeLang;
   function GetKorean: ID2BridgeLang;
   function GetTurkish: ID2BridgeLang;
   procedure SetKorean(const Value: ID2BridgeLang);
   procedure SetTurkish(const Value: ID2BridgeLang);
   procedure SetItalian(AValue: ID2BridgeLang);
   procedure SetFrench(AValue: ID2BridgeLang);
   procedure SetGerman(AValue: ID2BridgeLang);
   procedure SetJapanese(AValue: ID2BridgeLang);
   procedure SetRussian(AValue: ID2BridgeLang);
   procedure SetChinese(AValue: ID2BridgeLang);
   function GetCzech: ID2BridgeLang;
   procedure SetCzech(Avalue: ID2BridgeLang);
   function GetRomanian: ID2BridgeLang;
   procedure SetRomanian(Avalue: ID2BridgeLang);
   function GetPersian: ID2BridgeLang;
   procedure SetPersian(const Value: ID2BridgeLang);
   function GetThai: ID2BridgeLang;
   procedure SetThai(Avalue: ID2BridgeLang);
   function GetUkrainian: ID2BridgeLang;
   procedure SetUkrainian(const Value: ID2BridgeLang);

   function GetLanguages: TD2BridgeLangs;
   procedure SetLanguages(SetOfLanguages: TD2BridgeLangs);
   function GetPathExportJSON: string;
   procedure SetPathExportJSON(Value: string);
   function GetPathJSON: string;
   procedure SetPathJSON(Value: string);
   function GetResourcePrefix: string;
   procedure SetResourcePrefix(Value: string);
   function GetExportJSON: boolean;
   procedure SetExportJSON(Value: boolean);
   function GetEmbedJSON: boolean;
   procedure SetEmbedJSON(Value: boolean);

   function LangByTD2BridgeLang(ALang: TD2BridgeLang): ID2BridgeTerm;
   function LangByHTMLLang(ALang: string): ID2BridgeTerm;
   function LangByBrowser(ALangCommaText: string): ID2BridgeTerm; overload;

   function JSONDefaultLang: TJSONObject;
   procedure CreateJSONDefaultLang;
   procedure IncludeLogMissing(AContext: string; ATerm: string; AInformation: string = '');

   property Portuguese: ID2BridgeLang read GetPortuguese write SetPortuguese;
   property English: ID2BridgeLang read GetEnglish write SetEnglish;
   property Spanish: ID2BridgeLang read GetSpanish write SetSpanish;
   property Arabic: ID2BridgeLang read GetArabic write SetArabic;
   property Italian: ID2BridgeLang read GetItalian write SetItalian;
   property French: ID2BridgeLang read GetFrench write SetFrench;
   property German: ID2BridgeLang read GetGerman write SetGerman;
   property Japanese: ID2BridgeLang read GetJapanese write SetJapanese;
   property Russian: ID2BridgeLang read GetRussian write SetRussian;
   property Chinese: ID2BridgeLang read GetChinese write SetChinese;
   property Czech: ID2BridgeLang read GetCzech write SetCzech;
   property Turkish: ID2BridgeLang read GetTurkish write SetTurkish;
   property Korean: ID2BridgeLang read GetKorean write SetKorean;
   property Romanian: ID2BridgeLang read GetRomanian write SetRomanian;
   property Persian: ID2BridgeLang read GetPersian write SetPersian;
   property Thai: ID2BridgeLang read GetThai write SetThai;
   property Ukrainian: ID2BridgeLang read GetUkrainian write SetUkrainian;

   property PathExportJSON: string read GetPathExportJSON write SetPathExportJSON;
   property PathJSON: string read GetPathJSON write SetPathJSON;
   property ResourcePrefix: string read GetResourcePrefix write SetResourcePrefix;
   property ExportJSON: boolean read GetExportJSON write SetExportJSON;
   property EmbedJSON: boolean read GetEmbedJSON write SetEmbedJSON;

   property Languages: TD2BridgeLangs read GetLanguages write SetLanguages;
 end;


 ID2BridgeLangCore = interface(ID2BridgeLangCoreBaseClass)
  ['{82D4CA56-F3ED-4DC1-8467-44D9D5F8FAB8}']
 end;


implementation

end.
