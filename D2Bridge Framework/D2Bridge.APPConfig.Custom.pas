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

unit D2Bridge.APPConfig.Custom;

interface

uses
 Classes, SysUtils, IniFiles, Generics.Collections,
 D2Bridge.Interfaces;


type
 TD2BridgeAPPConfigCustom = class(TInterfacedPersistent, ID2BridgeAPPConfigCustom)
  private
   FAPPConfig: ID2BridgeAPPConfig;
   FItems: TList<ID2BridgeAPPConfigCustomItem>;
   FLock: TMultiReadExclusiveWriteSynchronizer;
   function GetItem(AKey: string): ID2BridgeAPPConfigCustomItem;
   function GetItemByKey(AKey: string): ID2BridgeAPPConfigCustomItem;
  public
   constructor Create(APPConfig: ID2BridgeAPPConfig);
   destructor Destroy; override;

   function Add: ID2BridgeAPPConfigCustomItem; overload;

   procedure Add(AItem: ID2BridgeAPPConfigCustomItem); overload;

   function Count: integer;

   procedure Delete(AItem: ID2BridgeAPPConfigCustomItem); overload;
   procedure Delete(AKey: string); overload;

   procedure Clear;

   property Item[AKey: string]: ID2BridgeAPPConfigCustomItem read GetItem;
 end;

implementation

Uses
 D2Bridge.APPConfig.Custom.Item;


{ TD2BridgeAPPConfigCustom }

function TD2BridgeAPPConfigCustom.Add: ID2BridgeAPPConfigCustomItem;
begin
 result:= TD2BridgeAPPConfigCustomItem.Create(FAPPConfig);

 Add(result);
end;

procedure TD2BridgeAPPConfigCustom.Add(AItem: ID2BridgeAPPConfigCustomItem);
begin
 FLock.BeginWrite;

 try
  FItems.Add(AItem);
 finally
  FLock.EndWrite;
 end;
end;

procedure TD2BridgeAPPConfigCustom.Clear;
var
 I: integer;
 vItemIntf: ID2BridgeAPPConfigCustomItem;
 vItem: TD2BridgeAPPConfigCustomItem;
begin
 FLock.BeginWrite;

 try
  while FItems.Count > 0 do
  begin
   I:= FItems.Count;
   vItemIntf:= FItems[I];
   vItem:= vItemIntf as TD2BridgeAPPConfigCustomItem;
   FItems.Delete(I);
   vItemIntf:= nil;
   vItem.Free;
  end;
 finally
  FLock.EndWrite;
 end;

end;

function TD2BridgeAPPConfigCustom.Count: integer;
begin
 FLock.BeginRead;

 try
  result:= FItems.Count;
 finally
  FLock.EndRead;
 end;
end;

constructor TD2BridgeAPPConfigCustom.Create(APPConfig: ID2BridgeAPPConfig);
begin
 inherited Create;

 FAPPConfig:= APPConfig;
 FItems:= TList<ID2BridgeAPPConfigCustomItem>.Create;
 FLock:= TMultiReadExclusiveWriteSynchronizer.Create;
end;

procedure TD2BridgeAPPConfigCustom.Delete(AItem: ID2BridgeAPPConfigCustomItem);
var
 I: integer;
 vItemIntf: ID2BridgeAPPConfigCustomItem;
 vItem: TD2BridgeAPPConfigCustomItem;
begin
 FLock.BeginWrite;

 try
  for I:= 0 to Pred(FItems.Count) do
   if FItems[I] = AItem then
   begin
    vItemIntf:= FItems[I];
    vItem:= vItemIntf as TD2BridgeAPPConfigCustomItem;
    FItems.Delete(I);
    vItemIntf:= nil;
    vItem.Free;
   end;
 finally
  FLock.EndWrite;
 end;
end;

procedure TD2BridgeAPPConfigCustom.Delete(AKey: string);
var
 vItem: ID2BridgeAPPConfigCustomItem;
begin
 vItem:= nil;

 vItem:= GetItem(AKey);

 if vItem <> nil then
  Delete(vItem);
end;

destructor TD2BridgeAPPConfigCustom.Destroy;
begin
 Clear;

 FItems.Free;

 FLock.Free;

 inherited;
end;

function TD2BridgeAPPConfigCustom.GetItem(AKey: string): ID2BridgeAPPConfigCustomItem;
var
 vItem: ID2BridgeAPPConfigCustomItem;
begin
 vItem:= GetItemByKey(AKey);

 if vItem = nil then
 begin
  result:= Add;
  result.Key:= AKey;
 end else
  result:= vItem;
end;


function TD2BridgeAPPConfigCustom.GetItemByKey(AKey: string): ID2BridgeAPPConfigCustomItem;
var
 vItem: ID2BridgeAPPConfigCustomItem;
begin
 FLock.BeginRead;

 result:= nil;

 try
  for vItem in FItems do
  begin
   if SameText(vItem.Key, AKey) then
   begin
    result:= vItem;
    break;
   end;
  end;

 finally
  FLock.EndRead;
 end;

end;

end.
