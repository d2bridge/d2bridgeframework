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

unit Prism.DataWare.Mapped;

interface

uses
  Classes,
  Prism.Types;


type
 TPrismDataWareMapped = class(TPersistent)
  private
   FPrismFieldTypeAuto: TPrismFieldType;
   FPrismFieldTypeString: TPrismFieldType;
   FPrismFieldTypePassword: TPrismFieldType;
   FPrismFieldTypeInteger: TPrismFieldType;
   FPrismFieldTypeNumber: TPrismFieldType;
   FPrismFieldTypeDate: TPrismFieldType;
   FPrismFieldTypeDateTime: TPrismFieldType;
   FPrismFieldTypeTime: TPrismFieldType;
  public
   constructor Create;

   function MappedPrismField(ATPrismFieldType: TPrismFieldType): TPrismFieldType;
   procedure Assign(Source: TPersistent); override;

   property PrismFieldTypeAuto: TPrismFieldType read FPrismFieldTypeAuto write FPrismFieldTypeAuto;
   property PrismFieldTypeString: TPrismFieldType read FPrismFieldTypeString write FPrismFieldTypeString;
   property PrismFieldTypePassword: TPrismFieldType read FPrismFieldTypePassword write FPrismFieldTypePassword;
   property PrismFieldTypeInteger: TPrismFieldType read FPrismFieldTypeInteger write FPrismFieldTypeInteger;
   property PrismFieldTypeNumber: TPrismFieldType read FPrismFieldTypeNumber write FPrismFieldTypeNumber;
   property PrismFieldTypeDate: TPrismFieldType read FPrismFieldTypeDate write FPrismFieldTypeDate;
   property PrismFieldTypeDateTime: TPrismFieldType read FPrismFieldTypeDateTime write FPrismFieldTypeDateTime;
   property PrismFieldTypeTime: TPrismFieldType read FPrismFieldTypeTime write FPrismFieldTypeTime;
 end;

implementation

{ TPrismDataWareMapped }

procedure TPrismDataWareMapped.Assign(Source: TPersistent);
begin
 if Source is TPrismDataWareMapped then
 begin
  FPrismFieldTypeAuto:= TPrismDataWareMapped(Source).PrismFieldTypeAuto;
  FPrismFieldTypeString:= TPrismDataWareMapped(Source).PrismFieldTypeString;
  FPrismFieldTypePassword:= TPrismDataWareMapped(Source).PrismFieldTypePassword;
  FPrismFieldTypeInteger:= TPrismDataWareMapped(Source).PrismFieldTypeInteger;
  FPrismFieldTypeNumber:= TPrismDataWareMapped(Source).PrismFieldTypeNumber;
  FPrismFieldTypeDate:= TPrismDataWareMapped(Source).PrismFieldTypeDate;
  FPrismFieldTypeDateTime:= TPrismDataWareMapped(Source).PrismFieldTypeDateTime;
  FPrismFieldTypeTime:= TPrismDataWareMapped(Source).PrismFieldTypeTime;

  exit;
 end;
 inherited;
end;

constructor TPrismDataWareMapped.Create;
begin
 inherited;

 FPrismFieldTypeAuto:= TPrismFieldType.PrismFieldTypeAuto;
 FPrismFieldTypeString:= TPrismFieldType.PrismFieldTypeString;
 FPrismFieldTypePassword:= TPrismFieldType.PrismFieldTypePassword;
 FPrismFieldTypeInteger:= TPrismFieldType.PrismFieldTypeInteger;
 FPrismFieldTypeNumber:= TPrismFieldType.PrismFieldTypeNumber;
 FPrismFieldTypeDate:= TPrismFieldType.PrismFieldTypeDate;
 FPrismFieldTypeDateTime:= TPrismFieldType.PrismFieldTypeDateTime;
 FPrismFieldTypeTime:= TPrismFieldType.PrismFieldTypeTime;
end;

function TPrismDataWareMapped.MappedPrismField(ATPrismFieldType: TPrismFieldType): TPrismFieldType;
begin
 case ATPrismFieldType of
   TPrismFieldType.PrismFieldTypeAuto : Result:= FPrismFieldTypeAuto;
   TPrismFieldType.PrismFieldTypeString : Result:= FPrismFieldTypeString;
   TPrismFieldType.PrismFieldTypePassword : Result:= FPrismFieldTypePassword;
   TPrismFieldType.PrismFieldTypeInteger : Result:= FPrismFieldTypeInteger;
   TPrismFieldType.PrismFieldTypeNumber : Result:= FPrismFieldTypeNumber;
   TPrismFieldType.PrismFieldTypeDate : Result:= FPrismFieldTypeDate;
   TPrismFieldType.PrismFieldTypeDateTime : Result:= FPrismFieldTypeDateTime;
   TPrismFieldType.PrismFieldTypeTime : Result:= FPrismFieldTypeTime;
  else
   Result:= FPrismFieldTypeAuto;
 end;
end;

end.