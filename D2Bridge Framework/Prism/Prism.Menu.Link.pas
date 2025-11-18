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

unit Prism.Menu.Link;

interface

uses
  Classes,
  Prism.Interfaces, Prism.Menu.Item;

type
 TPrismMenuItemLink = class(TPrismMenuItem, IPrismMenuItemLink)
  private
  public
   constructor Create(AOwner: TObject; APrismMenu: IPrismMenu); override;

   function IsLink: Boolean; Override;
 end;


implementation

uses
  Prism.Events, Prism.Types, Prism.Menu;

{ TPrismMenuItemLink }

constructor TPrismMenuItemLink.Create(AOwner: TObject; APrismMenu: IPrismMenu);
begin
 inherited;

end;

function TPrismMenuItemLink.IsLink: Boolean;
begin
 Result:= true;
end;

end.
