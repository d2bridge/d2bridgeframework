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
