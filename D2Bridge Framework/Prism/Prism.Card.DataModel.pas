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

unit Prism.Card.DataModel;

interface

{$IFNDEF FMX}

uses
  Classes, SysUtils, D2Bridge.JSON, StrUtils,
{$IFDEF FMX}

{$ELSE}

{$ENDIF}
  Prism.Forms.Controls, Prism.Interfaces, Prism.Types, Prism.Card;

type
 TPrismCardDataModel = class(TPrismCard, IPrismCardDataModel)
  private
   FCardGrid: IPrismCardGridDataModel;
   FIsCardGridContainer: boolean;
  public
   constructor Create(PrismControlContainer: IPrismControl); reintroduce;

   function IsCardDataModel: boolean; override;

   function CardGrid: IPrismCardGridDataModel;
   function IsCardGridContainer: Boolean;
 end;

implementation

uses
  Prism.Forms, Prism.Card.Grid.DataModel;

{ TPrismCard }

function TPrismCardDataModel.CardGrid: IPrismCardGridDataModel;
begin
 result:= FCardGrid;
end;

constructor TPrismCardDataModel.Create(PrismControlContainer: IPrismControl);
begin
 FIsCardGridContainer:= false;

 if PrismControlContainer is TPrismCardGridDataModel then
 begin
  FCardGrid:= PrismControlContainer as TPrismCardGridDataModel;
  FIsCardGridContainer:= true;
 end;

 inherited Create(PrismControlContainer.Form as TPrismForm);
end;

function TPrismCardDataModel.IsCardGridContainer: Boolean;
begin
 result:= FIsCardGridContainer;
end;

function TPrismCardDataModel.IsCardDataModel: boolean;
begin
 result:= true;
end;

{$ELSE}
implementation
{$ENDIF}


end.