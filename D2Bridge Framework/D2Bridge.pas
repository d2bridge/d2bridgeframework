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

unit D2Bridge;

interface

uses
  Classes,
{$IFDEF FMX}
{$ELSE}
  Controls,
{$ENDIF}
  D2Bridge.BaseClass, D2Bridge.Types;


type
 TD2Bridge = class(TD2BridgeClass)
  private

  public
   //BaseClass: TD2BridgeClass;

   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;

   function ObjectExported(AControl: TComponent): Boolean;

   //BaseClass
   property BaseClass;
   property Form;
   property FrameworkForm;
   property Owner;
   property Options;
   property HTML;
   property Token;
 end;

implementation

uses
  SysUtils;

{ TD2Bridge }


constructor TD2Bridge.Create(AOwner: TComponent);
begin
 Inherited;

 //Items:= TD2BridgeItems.Create(self);
end;

destructor TD2Bridge.Destroy;
begin
 //FreeAndNil(Items);

 Inherited;
end;

function TD2Bridge.ObjectExported(AControl: TComponent): Boolean;
var
 I: Integer;
begin
 result:= false;

 for I := 0 to Pred(ExportedControls.Count) do
 begin
  if ExportedControls.Items[ExportedControls.Keys.ToArray[I]].ItemID = AControl.Name  then
  begin
   Result:= true;
   Break;
  end;
 end;

end;

end.

