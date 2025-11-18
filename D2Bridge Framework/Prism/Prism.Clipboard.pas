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

unit Prism.Clipboard;

interface

uses
  Classes, SysUtils,
  Prism.Interfaces;

type
 TPrismClipboard = class(TInterfacedPersistent, IPrismClipboard)
  private
   FText: string;
   FPrismSession: IPrismSession;
   function GetAsText: string;
   procedure SetAsText(const Value: string);
  public
   constructor Create(APrismSession: IPrismSession);

   property AsText: string read GetAsText write SetAsText;
 end;

implementation

uses
  Prism.Util;

{ TPrismClipboard }

constructor TPrismClipboard.Create(APrismSession: IPrismSession);
begin
 FPrismSession:= APrismSession;

 inherited Create;
end;

function TPrismClipboard.GetAsText: string;
begin
 Result:= FText;
end;

procedure TPrismClipboard.SetAsText(const Value: string);
begin
 FText:= Value;

 FPrismSession.ExecJS(
  ' navigator.clipboard.writeText(`' + FText + '`) '
 )
end;

end.
