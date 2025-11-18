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

unit Prism.Chart.Base.Title;

interface

Uses
 Classes, SysUtils, Variants,
 Prism.interfaces, Prism.Types;

type
 TPrismChartBaseLegend = class(TInterfacedPersistent, IPrismChartBaseTitle)
  private
   FAlignment: TPrismAlignment;
   FLink: string;
   FOnClick: TNotifyEvent;
   FShow: Boolean;
   FText: string;
   function GetAlignment: TPrismAlignment;
   function GetLink: string;
   function GetOnClick: TNotifyEvent;
   function GetShow: Boolean;
   function GetText: string;
   procedure SetAlignment(const Value: TPrismAlignment);
   procedure SetLink(const Value: string);
   procedure SetOnClick(const Value: TNotifyEvent);
   procedure SetShow(const Value: Boolean);
   procedure SetText(const Value: string);

  protected

  public
   property Link: string read GetLink write SetLink;
   property OnClick: TNotifyEvent read GetOnClick write SetOnClick;
   property Alignment: TPrismAlignment read GetAlignment write SetAlignment;
   property Show: Boolean read GetShow write SetShow default true;
   property Text: string read GetText write SetText;


 end;


implementation

function TPrismChartBaseLegend.GetAlignment: TPrismAlignment;
begin
 Result := FAlignment;
end;

function TPrismChartBaseLegend.GetLink: string;
begin
 Result := FLink;
end;

function TPrismChartBaseLegend.GetOnClick: TNotifyEvent;
begin
 Result := FOnClick;
end;

function TPrismChartBaseLegend.GetShow: Boolean;
begin
 Result := FShow;
end;

function TPrismChartBaseLegend.GetText: string;
begin
 Result := FText;
end;

procedure TPrismChartBaseLegend.SetAlignment(const Value: TPrismAlignment);
begin
 FAlignment := Value;
end;

procedure TPrismChartBaseLegend.SetLink(const Value: string);
begin
 FLink := Value;
end;

procedure TPrismChartBaseLegend.SetOnClick(const Value: TNotifyEvent);
begin
 FOnClick := Value;
end;

procedure TPrismChartBaseLegend.SetShow(const Value: Boolean);
begin
 FShow := Value;
end;

procedure TPrismChartBaseLegend.SetText(const Value: string);
begin
 FText := Value;
end;

end.