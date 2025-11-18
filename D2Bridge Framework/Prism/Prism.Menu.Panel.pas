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

unit Prism.Menu.Panel;

interface

uses
  Classes, System.UITypes,
  Prism.Interfaces;


type
 TPrismMenuPanel = class(TInterfacedPersistent, IPrismMenuPanel)
  private
   FColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
   FPrismMenu: IPrismMenu;
   function GetColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
   procedure SetColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
  public
   constructor Create(APrismMenu: IPrismMenu); virtual;

   property Color: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF} read GetColor write SetColor;
 end;

Const
 DefaultColor: TColor = $0;

implementation

uses
  SysUtils, Prism.MainMenu;

{ TPrismMenuPanel }

constructor TPrismMenuPanel.Create(APrismMenu: IPrismMenu);
begin
 inherited Create;

 FPrismMenu:= APrismMenu;
 FColor:= DefaultColor;
end;

function TPrismMenuPanel.GetColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
begin
 Result:= FColor;

 if FColor = DefaultColor then
  Result:= FPrismMenu.Color;
end;

procedure TPrismMenuPanel.SetColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
begin
 FColor:= Value;
end;

end.