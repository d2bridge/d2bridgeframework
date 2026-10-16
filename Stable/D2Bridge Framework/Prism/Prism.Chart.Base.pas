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

unit Prism.Chart.Base;

interface

uses
 Classes, SysUtils, Types, StrUtils, D2Bridge.JSON,
 StdCtrls, DBCtrls,
 Prism.Forms.Controls, Prism.Interfaces, Prism.Types, Prism.DataLink.Field;


type
  TPrismChartBase = class(TPrismControl, IPrismChartBase)
  private
   FLegend: IPrismChartBaseLegend;
  protected
   procedure Initialize; override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
  public
   constructor Create(AOwner: TObject); override;
   destructor Destroy; override;

   function Legend: IPrismChartBaseLegend;
  end;


implementation

Uses
 Prism.Chart.Base.Legend;

{ TPrismChartBase }

constructor TPrismChartBase.Create(AOwner: TObject);
begin
 inherited;

 FLegend:= TPrismChartBaseLegend.Create;
end;

destructor TPrismChartBase.Destroy;
var
 vLegend: TPrismChartBaseLegend;
begin
 vLegend:= FLegend as TPrismChartBaseLegend;
 FLegend:= nil;
 vLegend.Free;

  inherited;
end;

function TPrismChartBase.GetEnableComponentState: Boolean;
begin
 Result:= true;
end;

procedure TPrismChartBase.Initialize;
begin
  inherited;

end;

function TPrismChartBase.Legend: IPrismChartBaseLegend;
begin

end;

procedure TPrismChartBase.ProcessComponentState(
  const ComponentStateInfo: TJSONObject);
begin
  inherited;

end;

procedure TPrismChartBase.ProcessEventParameters(Event: IPrismControlEvent;
  Parameters: TStrings);
begin
  inherited;

end;

end.