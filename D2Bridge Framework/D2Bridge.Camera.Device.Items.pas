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

unit D2Bridge.Camera.Device.Items;

interface

Uses
 Classes, SysUtils, Generics.Collections,
{$IFnDEF FPC}

{$ELSE}

{$ENDIF}
 D2Bridge.Interfaces;

type
 TD2BridgeCameraDeviceItems = class(TInterfacedPersistent, ID2BridgeCameraDeviceItems)
  private
   FListDevices: TList<ID2BridgeCameraDevice>;
   function GetDevice(Index: integer): ID2BridgeCameraDevice;
  public
   constructor Create;
   destructor Destroy; override;

   function Add: ID2BridgeCameraDevice;

   function Count: Integer;
   function Items: TList<ID2BridgeCameraDevice>;

   function ItemFromID(AId: string): ID2BridgeCameraDevice;
   function ItemFromName(AName: string): ID2BridgeCameraDevice;
   function ItemFromIndex(AIndex: integer): ID2BridgeCameraDevice;

   procedure Clear;

   property Item[Index: integer]: ID2BridgeCameraDevice read GetDevice;
  end;

implementation

Uses
 D2Bridge.Camera.Device;

{ TD2BridgeCameraDeviceItems }

function TD2BridgeCameraDeviceItems.Add: ID2BridgeCameraDevice;
begin
 result:= TD2BridgeCameraDevice.Create;

 FListDevices.Add(result);
end;

procedure TD2BridgeCameraDeviceItems.Clear;
var
 vDevice: TD2BridgeCameraDevice;
 vIDevice: ID2BridgeCameraDevice;
begin
 while FListDevices.Count > 0 do
 begin
  vIDevice:= FListDevices.Last;
  FListDevices.Delete(Pred(FListDevices.Count));
  vDevice:= vIDevice as TD2BridgeCameraDevice;
  vIDevice:= nil;
  vDevice.Free;
 end;
end;

function TD2BridgeCameraDeviceItems.Count: Integer;
begin
 result:= FListDevices.Count;
end;

constructor TD2BridgeCameraDeviceItems.Create;
begin
 FListDevices:= TList<ID2BridgeCameraDevice>.Create;

 inherited;
end;

destructor TD2BridgeCameraDeviceItems.Destroy;
begin
 Clear;
 FListDevices.Destroy;

 inherited;
end;

function TD2BridgeCameraDeviceItems.GetDevice(Index: integer): ID2BridgeCameraDevice;
begin
 result:= nil;

 if Index <= FListDevices.Count then
  result:= FListDevices[Index];
end;

function TD2BridgeCameraDeviceItems.ItemFromID(
  AId: string): ID2BridgeCameraDevice;
var
 I: integer;
begin
 result:= nil;

 for I := 0 to Pred(FListDevices.Count) do
 begin
  if SameText(FListDevices[I].id, AId) then
  begin
   Result:= FListDevices[I];
   Break;
  end;
 end;
end;

function TD2BridgeCameraDeviceItems.ItemFromIndex(
  AIndex: integer): ID2BridgeCameraDevice;
var
 I: integer;
begin
 result:= nil;

 for I := 0 to Pred(FListDevices.Count) do
 begin
  if FListDevices[I].Index = AIndex then
  begin
   Result:= FListDevices[I];
   Break;
  end;
 end;

end;

function TD2BridgeCameraDeviceItems.ItemFromName(
  AName: string): ID2BridgeCameraDevice;
var
 I: integer;
begin
 result:= nil;

 for I := 0 to Pred(FListDevices.Count) do
 begin
  if SameText(FListDevices[I].Name, AName) then
  begin
   Result:= FListDevices[I];
   Break;
  end;
 end;

end;

function TD2BridgeCameraDeviceItems.Items: TList<ID2BridgeCameraDevice>;
begin
 result:= FListDevices;
end;


end.