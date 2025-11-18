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

unit Prism.Chart.Base.Legend.Data;

interface

Uses
 Classes, SysUtils, Variants,
 Generics.Collections,
 Prism.interfaces, Prism.Types;


type
 TPrismChartBaseLegendData = class(TInterfacedPersistent, IPrismChartBaseLegendData)
  private
   FItems: TList<string>;
  protected

  public
   constructor Create;
   destructor Destroy; override;

   procedure Add(AText: string);

   function TextItems: TList<string>;
 end;


implementation

{ TPrismChartBaseLegendData }

procedure TPrismChartBaseLegendData.Add(AText: string);
begin
 if FItems.Contains(AText) then
  FItems.Add(AText);
end;

constructor TPrismChartBaseLegendData.Create;
begin
 FItems:= TList<string>.Create;
end;

destructor TPrismChartBaseLegendData.Destroy;
begin
 FItems.Free;

 inherited;
end;

function TPrismChartBaseLegendData.TextItems: TList<string>;
begin
 result:= FItems;
end;

end.