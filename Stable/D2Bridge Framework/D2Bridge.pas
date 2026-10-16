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

