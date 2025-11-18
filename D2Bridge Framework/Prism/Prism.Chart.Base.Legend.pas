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

unit Prism.Chart.Base.Legend;

interface

Uses
 Classes, SysUtils, Variants,
 Prism.interfaces, Prism.Types;

type
 TPrismChartBaseLegend = class(TInterfacedPersistent, IPrismChartBaseLegend)
  private
   FAlign: TPrismAlignment;
   FBottom: variant;
   FIcon: TPrismChatLegendIcon;
   FLeft: variant;
   FRight: Variant;
   FTop: Variant;
   FVisible: boolean;
   FData: IPrismChartBaseLegendData;
   function GetRight: Variant;
   procedure SetBottom(const Value: variant);
   function GetBottom: variant;
   procedure SetRight(const Value: Variant);
   function GetAlign: TPrismAlignment;
   function GetIcon: TPrismChatLegendIcon;
   function GetLeft: variant;
   procedure SetAlign(const Value: TPrismAlignment);
   function GetTop: variant;
   function GetVisible: boolean;
   procedure SetIcon(const Value: TPrismChatLegendIcon);
   procedure SetLeft(const Value: variant);
   procedure SetTop(const Value: variant);
   procedure SetVisible(const Value: boolean);
  strict protected
  public
   constructor Create;
   destructor Destroy; override;

   function Data: IPrismChartBaseLegendData;

   property Visible: boolean read GetVisible write SetVisible;
   property Align: TPrismAlignment read GetAlign write SetAlign;
   property Bottom: variant read GetBottom write SetBottom;
   property Icon: TPrismChatLegendIcon read GetIcon write SetIcon default ChartLegendIconCircle;
   property Left: variant read GetLeft write SetLeft;
   property Right: Variant read GetRight write SetRight;
   property Top: variant read GetTop write SetTop;

 end;

implementation


Uses
 Prism.Chart.Base.Legend.Data;


{ TPrismChartBaseLegend }

constructor TPrismChartBaseLegend.Create;
begin
 inherited;

 FAlign:= PrismAlignNone;
 FBottom:= -1;
 FLeft:= -1;
 FRight:= -1;
 FTop:= -1;
 FVisible:= false;

 FData:= TPrismChartBaseLegendData.Create;
end;

function TPrismChartBaseLegend.Data: IPrismChartBaseLegendData;
begin

end;

destructor TPrismChartBaseLegend.Destroy;
var
 vData: TPrismChartBaseLegendData;
begin
 vData:= FData as TPrismChartBaseLegendData;
 FData:= nil;
 vData.Free;

  inherited;
end;

function TPrismChartBaseLegend.GetAlign: TPrismAlignment;
begin
 result:= FAlign;
end;

function TPrismChartBaseLegend.GetBottom: variant;
begin
 result:= FBottom;
end;

function TPrismChartBaseLegend.GetIcon: TPrismChatLegendIcon;
begin
 Result := FIcon;
end;

function TPrismChartBaseLegend.GetLeft: variant;
begin
 Result := FLeft;
end;

function TPrismChartBaseLegend.GetRight: Variant;
begin
 Result := FRight;
end;

function TPrismChartBaseLegend.GetTop: variant;
begin
 Result:= FTop;
end;

function TPrismChartBaseLegend.GetVisible: boolean;
begin
 result:= FVisible;
end;

procedure TPrismChartBaseLegend.SetAlign(const Value: TPrismAlignment);
begin
 FAlign:= Value;
end;

procedure TPrismChartBaseLegend.SetBottom(const Value: variant);
begin
 FBottom := Value;
end;

procedure TPrismChartBaseLegend.SetIcon(const Value: TPrismChatLegendIcon);
begin
 FIcon := Value;
end;

procedure TPrismChartBaseLegend.SetLeft(const Value: variant);
begin
 FLeft := Value;
end;

procedure TPrismChartBaseLegend.SetRight(const Value: Variant);
begin
 FRight := Value;
end;

procedure TPrismChartBaseLegend.SetTop(const Value: variant);
begin
 FTop:= Value;
end;

procedure TPrismChartBaseLegend.SetVisible(const Value: boolean);
begin
 FVisible:= Value;
end;

end.