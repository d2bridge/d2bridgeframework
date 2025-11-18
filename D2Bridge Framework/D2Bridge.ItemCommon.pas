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

unit D2Bridge.ItemCommon;

interface

uses
  Classes, Generics.Collections,
  D2Bridge.Interfaces, D2Bridge.ItemCommon.Add, D2Bridge.BaseClass;

//type
//  TD2BridgeItems = class(TList<TD2BridgeItem>)
//   private
//    FBaseClass: TObject;
//    FAddItem: TItemsAdd;
//   public
//    constructor Create(BaseClass: TObject);
//    destructor Destroy; override;
//
//    property New: TItemsAdd read FAddItem;
//    property BaseClass: TObject read FBaseClass;
//  end;

type
  TD2BridgeItems = class(TInterfacedPersistent, ID2BridgeAddItems)
   private
    FBaseClass: TD2BridgeClass;
    FAddItem: TItemAdd;
    FItemList: TList<ID2BridgeItem>;
    function GetItems: TList<ID2BridgeItem>;
   public
    constructor Create(BaseClass: TD2BridgeClass);
    destructor Destroy; override;

    function Add: IItemAdd; overload;
    function Count: Integer;
    function Item(AIndex: Integer):ID2BridgeItem;

    procedure Remove(Item: ID2BridgeItem); overload;
    procedure RemoveFromVCL(AComponent: TComponent); overload;

    procedure Clear;

    procedure Add(Item: ID2BridgeItem); overload;
    property Items: TList<ID2BridgeItem> read GetItems;
    property BaseClass: TD2BridgeClass read FBaseClass;
  end;


implementation

uses
  SysUtils,
  D2Bridge.Item, D2Bridge.Item.VCLObj,
  Prism.Interfaces, Prism.Forms.Controls;


{ TD2BridgeItems }



function TD2BridgeItems.Add: IItemAdd;
begin
 result:= FAddItem;
end;

procedure TD2BridgeItems.Add(Item: ID2BridgeItem);
begin
 FItemList.Add(Item);
 FBaseClass.ExportedControls.Add(Item.ItemID, Item);
end;

procedure TD2BridgeItems.Clear;
var
 vCount: integer;
 vID2BridgeItemIntf: ID2BridgeItem;
begin
 vCount:= FItemList.Count;

 while (FItemList.Count > 0) and (vCount > 0) do
 begin
  try
   vID2BridgeItemIntf:= FItemList.Last;
   Remove(vID2BridgeItemIntf);
  except
  end;

  Dec(vCount);
 end;
end;

function TD2BridgeItems.Count: Integer;
begin
 Result:= FItemList.Count;
end;

constructor TD2BridgeItems.Create(BaseClass: TD2BridgeClass);
begin
 inherited Create;

 FBaseClass:= BaseClass;
 FAddItem:= TItemAdd.Create(self);
 FItemList:= TList<ID2BridgeItem>.Create;
end;

destructor TD2BridgeItems.Destroy;
var
  vID2BridgeItemIntf: ID2BridgeItem;
  vD2BridgeItem: TD2BridgeItem;
begin
 try
  while FItemList.Count > 0 do
  begin
   vID2BridgeItemIntf:= FItemList.Last;
   FItemList.Delete(Pred(FItemList.Count));

   try
    vD2BridgeItem:= vID2BridgeItemIntf as TD2BridgeItem;
    vID2BridgeItemIntf:= nil;

    vD2BridgeItem.Free;
   except
   end;
  end;

  FItemList.Free;
 except
 end;

 FreeAndNil(FAddItem);

 inherited;
end;

function TD2BridgeItems.GetItems: TList<ID2BridgeItem>;
begin
 Result:= FItemList;
end;

function TD2BridgeItems.Item(AIndex: Integer): ID2BridgeItem;
begin
 Result:= FItemList[AIndex];
end;

procedure TD2BridgeItems.Remove(Item: ID2BridgeItem);
var
 I: integer;
 vID2BridgeItemIntf: ID2BridgeItem;
 vD2BridgeItem: TD2BridgeItem;
 vPrismControlIntf: IPrismControl;
 vPrismControl: TPrismControl;
begin
 for I := 0 to Pred(FItemList.Count) do
 begin
  vID2BridgeItemIntf:= FItemList[I];

  if Item = vID2BridgeItemIntf then
  begin
   FBaseClass.ExportedControls.Remove(Item.ItemID);
   FItemList.Delete(I);

   try
    vD2BridgeItem:= vID2BridgeItemIntf as TD2BridgeItem;

    if Assigned(vD2BridgeItem.PrismControl) then
    begin
     try
      vPrismControlIntf:= vD2BridgeItem.PrismControl;
      vPrismControl:= vPrismControlIntf as TPrismControl;

      if Assigned(vD2BridgeItem.PrismControl.Form) then
       vD2BridgeItem.PrismControl.Form.Controls.Remove(vD2BridgeItem.PrismControl);

      vPrismControlIntf:= nil;
      vD2BridgeItem.PrismControl:= nil;

      vPrismControl.Free;
     except
     end;
    end;

    vID2BridgeItemIntf:= nil;

    vD2BridgeItem.Free;
   except
   end;

   Break;
  end;
 end;
end;

procedure TD2BridgeItems.RemoveFromVCL(AComponent: TComponent);
var
 I: integer;
 vRemove: boolean;
begin
 for I := 0 to Pred(FItemList.Count) do
 begin
  vRemove:= false;

  try
   if (FItemList[I] is TD2BridgeItemVCLObj) and ((FItemList[I] as TD2BridgeItemVCLObj).Item = AComponent) then
   begin
    vRemove:= true;
   end else
    if Supports(FItemList[I], ID2BridgeItemHTMLSideMenu) and ((FItemList[I] as ID2BridgeItemHTMLSideMenu).Options.VCLComponent = AComponent) then
    begin
     vRemove:= true;
    end else
     if Assigned(FItemList[I].PrismControl) and (FItemList[I].PrismControl.VCLComponent = AComponent) then
     begin
      vRemove:= true;
     end;


   if vRemove then
   begin
    Remove(FItemList[I]);

    Break;
   end;
  except
  end;
 end;

end;

end.
