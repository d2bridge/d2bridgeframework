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
