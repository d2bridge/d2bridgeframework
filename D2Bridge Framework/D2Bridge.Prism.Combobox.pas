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
