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

unit D2Bridge.Lang.Persian;

interface

uses
  Classes,
  D2Bridge.Lang.Interfaces, D2Bridge.Types, D2Bridge.Lang.Term, D2Bridge.Lang.BaseClass, D2Bridge.Lang.Term.BaseClass;

type
 TD2BridgeLangPersian = class(TD2BridgeLangBaseClass, ID2BridgeLang)
  private

  public
   constructor Create(AD2BridgeLangCoreBaseClass: ID2BridgeLangCoreBaseClass; D2BridgeTermClass: TD2BridgeTermClass);

   function D2BridgeLang: TD2BridgeLang;

   function HTMLLang: string;
   function LangName: string;

   function IsRTL: Boolean; override;

   Procedure DoConfigFormatSettings; virtual;
   procedure DoTranslate(const AContext: string; const ATerm: string; var ATranslated: string); overload; virtual;
   procedure DoTranslate(const ATerm: string; var ATranslated: string); overload; virtual;
 end;


implementation


{ TD2BridgeLangPersian }

constructor TD2BridgeLangPersian.Create(AD2BridgeLangCoreBaseClass: ID2BridgeLangCoreBaseClass; D2BridgeTermClass: TD2BridgeTermClass);
begin
 Inherited Create(AD2BridgeLangCoreBaseClass, D2BridgeTermClass, self);
end;

function TD2BridgeLangPersian.D2BridgeLang: TD2BridgeLang;
begin
 Result:= TD2BridgeLang.Persian;
end;

procedure TD2BridgeLangPersian.DoConfigFormatSettings;
begin

end;

procedure TD2BridgeLangPersian.DoTranslate(const ATerm: string; var ATranslated: string);
begin

end;

procedure TD2BridgeLangPersian.DoTranslate(const AContext: string; const ATerm: string; var ATranslated: string);
begin

end;

function TD2BridgeLangPersian.HTMLLang: string;
begin
 result:= 'fa-IR';
end;

function TD2BridgeLangPersian.IsRTL: Boolean;
begin
 result:= true;
end;

function TD2BridgeLangPersian.LangName: string;
begin
 result:= 'Persian';
end;


end.