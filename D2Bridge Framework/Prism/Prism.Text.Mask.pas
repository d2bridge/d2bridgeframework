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
