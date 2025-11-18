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
  Thank for contribution to this Unit to:
    Edvanio Jancy
    edvanio@ideiasistemas.com.br
 +--------------------------------------------------------------------------+
}

{$I D2Bridge.inc}

unit D2Bridge.Prism.Memo;

interface

uses
  Classes,
{$IFDEF FMX}
{$ELSE}
  StdCtrls, Controls, Graphics,
{$ENDIF}
  D2Bridge.Interfaces, D2Bridge.Prism, D2Bridge.Prism.Item;



type
 PrismMemo = class(TD2BridgePrismItem, ID2BridgeFrameworkItemMemo)
  private
   FLines: TStrings;
   FRows: Integer;
  public
   constructor Create(AD2BridgePrismFramework: TD2BridgePrismFramework); override;

   procedure Clear; override;
   function FrameworkClass: TClass; override;
   procedure ProcessPropertyClass(VCLObj, NewObj: TObject); override;
   procedure ProcessEventClass(VCLObj, NewObj: TObject); override;
   procedure ProcessPropertyByName(VCLObj, NewObj: TObject; PropertyName: string; PropertyValue: Variant); override;

   procedure SetLines(ALines: TStrings);
   function GetLines: TStrings;

   procedure SetRows(ARows: Integer);
   function GetRows: Integer;

   property Lines: TStrings read FLines write FLines;
   property Rows: Integer read GetRows write SetRows;
  end;

implementation

uses
  SysUtils, Prism.Memo;

{ PrismMemo }

procedure PrismMemo.Clear;
begin
  inherited;
  FLines := nil;
  FRows  := 3;
end;

constructor PrismMemo.Create(AD2BridgePrismFramework: TD2BridgePrismFramework);
begin
 inherited;
end;

function PrismMemo.FrameworkClass: TClass;
begin
  Result := TPrismMemo;
end;

function PrismMemo.GetLines: TStrings;
begin
  Result := FLines;
end;

function PrismMemo.GetRows: Integer;
begin
  Result := FRows;
end;

procedure PrismMemo.ProcessEventClass(VCLObj, NewObj: TObject);
begin
  inherited;

end;

procedure PrismMemo.ProcessPropertyByName(VCLObj, NewObj: TObject;
  PropertyName: string; PropertyValue: Variant);
begin
  inherited;
end;

procedure PrismMemo.ProcessPropertyClass(VCLObj, NewObj: TObject);
begin
  inherited;
  TPrismMemo(NewObj).Lines := Lines;
end;

procedure PrismMemo.SetLines(ALines: TStrings);
begin
  FLines := ALines;
end;

procedure PrismMemo.SetRows(ARows: Integer);
begin
   FRows := ARows;
end;

end.