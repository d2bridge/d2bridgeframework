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

unit D2Bridge.Prism.Combobox;

interface

uses
  Classes, SysUtils,
  D2Bridge.Interfaces, D2Bridge.Prism, D2Bridge.Prism.Item;


type
 PrismCombobox = class(TD2BridgePrismItem, ID2BridgeFrameworkItemCombobox)
  private
   FProcGetItems: TOnGetStrings;
   FProcSetSelectedItem: TOnSetValue;
   FProcGetSelectedItem: TOnGetValue;
   procedure SetProcGetItems(AProc: TOnGetStrings);
   function GetProcGetItems: TOnGetStrings;
   procedure SetProcGetSelectedItem(AProc: TOnGetValue);
   function GetProcGetSelectedItem: TOnGetValue;
   procedure SetProcSetSelectedItem(AProc: TOnSetValue);
   function GetProcSetSelectedItem: TOnSetValue;
  public

   procedure Clear; override;
   function FrameworkClass: TClass; override;
   procedure ProcessPropertyClass(VCLObj, NewObj: TObject); override;
   procedure ProcessEventClass(VCLObj, NewObj: TObject); override;
   procedure ProcessPropertyByName(VCLObj, NewObj: TObject; PropertyName: string; PropertyValue: Variant); override;

   property ProcGetSelectedItem: TOnGetValue read GetProcGetSelectedItem write SetProcGetSelectedItem;
   property ProcSetSelectedItem: TOnSetValue read GetProcSetSelectedItem write SetProcSetSelectedItem;
   property ProcGetItems: TOnGetStrings read GetProcGetItems write SetProcGetItems;
  end;



implementation

uses
  Prism.Combobox;


{ PrismCombobox }

procedure PrismCombobox.Clear;
begin
 inherited;

 FProcGetItems:= nil;
 FProcGetSelectedItem:= nil;
 FProcSetSelectedItem:= nil;
end;

function PrismCombobox.FrameworkClass: TClass;
begin
 inherited;

 Result:= TPrismCombobox;
end;

function PrismCombobox.GetProcGetItems: TOnGetStrings;
begin
 Result:= FProcGetItems;
end;

function PrismCombobox.GetProcGetSelectedItem: TOnGetValue;
begin
 result:= FProcGetSelectedItem;
end;

function PrismCombobox.GetProcSetSelectedItem: TOnSetValue;
begin
 result:= FProcSetSelectedItem;
end;

procedure PrismCombobox.ProcessEventClass(VCLObj, NewObj: TObject);
begin
 inherited;

end;

procedure PrismCombobox.ProcessPropertyByName(VCLObj, NewObj: TObject;
  PropertyName: string; PropertyValue: Variant);
begin
 inherited;

end;

procedure PrismCombobox.ProcessPropertyClass(VCLObj, NewObj: TObject);
begin
 inherited;

 if Assigned(FProcGetItems) then
 TPrismCombobox(NewObj).ProcGetItems:= FProcGetItems;

 if Assigned(FProcGetSelectedItem) then
 TPrismCombobox(NewObj).ProcGetSelectedItem:= FProcGetSelectedItem;

 if Assigned(FProcSetSelectedItem) then
 TPrismCombobox(NewObj).ProcSetSelectedItem:= FProcSetSelectedItem;
end;


procedure PrismCombobox.SetProcGetItems(AProc: TOnGetStrings);
begin
 FProcGetItems:= AProc;
end;

procedure PrismCombobox.SetProcGetSelectedItem(AProc: TOnGetValue);
begin
 FProcGetSelectedItem:= AProc;
end;

procedure PrismCombobox.SetProcSetSelectedItem(AProc: TOnSetValue);
begin
 FProcSetSelectedItem:= AProc;
end;

end.