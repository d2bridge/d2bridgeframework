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

{$I ..\D2Bridge.inc}

unit Prism.Text.Mask;

interface

uses
  Classes, SysUtils,
  Prism.Interfaces, Prism.Types;

type
 TPrismTextMask = class
  private

  public
   //Brazilian
   class function BrazilCPF: string;
   class function BrazilCNPJ: string;
   class function BrazilCep: string;
   class function BrazilPhone: string;
   //United States
   class function USSocialSecurity: string;
   //Generic
   class function Phone: string;
   class function PhoneWithDDI: string;
   class function Integer: string;
   class function URL: string;
   class function IP: string;
   class function Email: string;
   class function MAC: string;
   class function Decimal(decimaldigits: integer = 2; decimalseparador: string = ','; thousandseparator: string = '.'): string;
   class function Currency(CurrSimbol: string; decimaldigits: integer = 2; decimalseparador: string = ','; thousandseparator: string = '.'): string;
   //Functions
   class function ProcessTextMask(aMask: string): string;
 end;


implementation



{ TPrismTextMask }

class function TPrismTextMask.BrazilCep: string;
begin
 result:= '''mask'' : ''99999-999''';
end;

class function TPrismTextMask.BrazilCNPJ: string;
begin
 result:= '''mask'' : ''99.999.999/9999.99'', ''autoUnmask'' : true';
end;

class function TPrismTextMask.BrazilCPF: string;
begin
 result:= '''mask'': ''999.999.999.99'', ''autoUnmask'' : true';
end;

class function TPrismTextMask.BrazilPhone: string;
begin
 Result:= '''mask'' : ''(99) 9999[9]-9999'', ''autoUnmask'' : true';
end;

class function TPrismTextMask.Currency(CurrSimbol: string;
  decimaldigits: integer; decimalseparador, thousandseparator: string): string;
begin
 result:= '''alias'' : ''decimal'', ''prefix'' : ''' + CurrSimbol + ' '', ''radixPoint'' : ''' + decimalseparador + ''', ''inputtype'' : ''text'', ''groupSeparator'' : ''' + thousandseparator + ''', ''digits'' : ''' + IntToStr(decimaldigits) + ''', ''autoUnmask'' : true, ''numericInput'' : true';
 //result:= '''decimal'', {''prefix'' : ''' + CurrSimbol + ' '', ''radixPoint'' : ''' + decimalseparador + ''', ''inputtype'' : ''text'', ''groupSeparator'' : ''' + decimalseparador + ''', ''digits'' : ''' + IntToStr(decimaldigits) + ''', ''autoUnmask'' : true}';
end;

class function TPrismTextMask.Decimal(decimaldigits: integer = 2; decimalseparador: string = ','; thousandseparator: string = '.'): string;
begin
 result:= '''alias'' : ''decimal'', ''radixPoint'' : ''' + decimalseparador + ''', ''inputtype'' : ''text'', ''groupSeparator'' : ''' + thousandseparator + ''', ''digits'' : ''' + IntToStr(decimaldigits) + ''', ''autoUnmask'' : true, ''numericInput'' : true';
 //result:= '''decimal'' : {''radixPoint'' : ''' + decimalseparador + ''', ''inputtype'' : ''text'', ''groupSeparator'' : ''' + decimalseparador + ''', ''digits'' : ''' + IntToStr(decimaldigits) + ''', ''autoUnmask'' : true}';
end;


class function TPrismTextMask.Email: string;
begin
 result:= '''alias'' : ''email''';
end;

class function TPrismTextMask.IP: string;
begin
 result:= '''alias'' : ''ip''';
end;

class function TPrismTextMask.MAC: string;
begin
 result:= '''alias'' : ''mac''';
end;

class function TPrismTextMask.Integer: string;
begin
 result:= '''alias'' : ''integer''';
end;

class function TPrismTextMask.Phone: string;
begin
 Result:= '''mask'' : ''(9[9][9]) 999[9][9]-9999[9]'', ''autoUnmask'' : true';
end;

class function TPrismTextMask.PhoneWithDDI: string;
begin
 result:= '''mask'' : ''+9[9][9] (9{*}) 999[9][9]-9999[9]'', ''autoUnmask'' : true';
end;

class function TPrismTextMask.ProcessTextMask(aMask: string): string;
begin
 //Future implementation to replace Masks from TMaskEdit, DataFields, etc

 Result:= aMask;
end;

class function TPrismTextMask.URL: string;
begin
 result:= '''alias'' : ''url''';
end;

class function TPrismTextMask.USSocialSecurity: string;
begin
 result:= '''alias'' : ''ssn''';
end;

end.