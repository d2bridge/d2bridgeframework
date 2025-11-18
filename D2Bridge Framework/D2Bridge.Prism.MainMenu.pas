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
