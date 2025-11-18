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

{$I D2Bridge.inc}

unit D2Bridge.Prism.MainMenu;

interface

uses
  Classes,
  D2Bridge.Interfaces, D2Bridge.Prism, D2Bridge.Prism.Item,
  Prism.Types, D2Bridge.ItemCommon;



type
 PrismMainMenu = class(TD2BridgePrismItem, ID2BridgeFrameworkItemMainMenu)
  private

  public
   constructor Create(AD2BridgePrismFramework: TD2BridgePrismFramework); override;
   destructor Destroy; override;

   procedure Clear; override;
   function FrameworkClass: TClass; override;
   procedure ProcessPropertyClass(VCLObj, NewObj: TObject); override;
   procedure ProcessEventClass(VCLObj, NewObj: TObject); override;
   procedure ProcessPropertyByName(VCLObj, NewObj: TObject; PropertyName: string; PropertyValue: Variant); override;
  end;



implementation

uses
  Prism.MainMenu, SysUtils;


{ PrismMainMenu }


procedure PrismMainMenu.Clear;
begin
 inherited;

end;

constructor PrismMainMenu.Create(AD2BridgePrismFramework: TD2BridgePrismFramework);
begin
 inherited;
end;

destructor PrismMainMenu.Destroy;
begin
 inherited;
end;

function PrismMainMenu.FrameworkClass: TClass;
begin
 inherited;

 Result:= TPrismMainMenu;
end;

procedure PrismMainMenu.ProcessEventClass(VCLObj, NewObj: TObject);
begin
 inherited;

end;

procedure PrismMainMenu.ProcessPropertyByName(VCLObj, NewObj: TObject; PropertyName: string; PropertyValue: Variant);
begin
 inherited;

end;

procedure PrismMainMenu.ProcessPropertyClass(VCLObj, NewObj: TObject);
begin
 inherited;

end;


end.