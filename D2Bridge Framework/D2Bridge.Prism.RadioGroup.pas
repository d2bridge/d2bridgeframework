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

unit D2Bridge.Prism.RadioGroup;

interface

{$IFnDEF FMX}
uses
  Classes, SysUtils,
  D2Bridge.Interfaces, D2Bridge.Prism, D2Bridge.Prism.Item;

type
 PrismRadioGroup = class(TD2BridgePrismItem, ID2BridgeFrameworkItemRadioGroup)
  private
   FProcGetItems: TOnGetStrings;
   FProcSetItemIndex: TOnSetValue;
   FProcGetItemIndex: TOnGetValue;
   FProcSetCaption: TOnSetValue;
   FProcGetCaption: TOnGetValue;
   FProcSetColumns: TOnSetValue;
   FProcGetColumns: TOnGetValue;
   procedure SetProcGetItems(AProc: TOnGetStrings);
   function GetProcGetItems: TOnGetStrings;
   function GetProcGetItemIndex: TOnGetValue;
   function GetProcSetItemIndex: TOnSetValue;
   procedure SetProcGetItemIndex(const Value: TOnGetValue);
   procedure SetProcSetItemIndex(const Value: TOnSetValue);
   function GetProcGetCaption: TOnGetValue;
   function GetProcSetCaption: TOnSetValue;
   procedure SetProcGetCaption(const Value: TOnGetValue);
   procedure SetProcSetCaption(const Value: TOnSetValue);
   function GetProcGetColumns: TOnGetValue;
   function GetProcSetColumns: TOnSetValue;
   procedure SetProcGetColumns(const Value: TOnGetValue);
   procedure SetProcSetColumns(const Value: TOnSetValue);
  public

   procedure Clear; override;
   function FrameworkClass: TClass; override;
   procedure ProcessPropertyClass(VCLObj, NewObj: TObject); override;
   procedure ProcessEventClass(VCLObj, NewObj: TObject); override;
   procedure ProcessPropertyByName(VCLObj, NewObj: TObject; PropertyName: string; PropertyValue: Variant); override;

   property ProcGetItems: TOnGetStrings read GetProcGetItems write SetProcGetItems;
   property ProcGetItemIndex: TOnGetValue read GetProcGetItemIndex write SetProcGetItemIndex;
   property ProcSetItemIndex: TOnSetValue read GetProcSetItemIndex write SetProcSetItemIndex;
   property ProcGetCaption: TOnGetValue read GetProcGetCaption write SetProcGetCaption;
   property ProcSetCaption: TOnSetValue read GetProcSetCaption write SetProcSetCaption;
   property ProcGetColumns: TOnGetValue read GetProcGetColumns write SetProcGetColumns;
   property ProcSetColumns: TOnSetValue read GetProcSetColumns write SetProcSetColumns;
  end;

implementation

Uses
 Prism.RadioGroup;


{ PrismRadioGroup }

procedure PrismRadioGroup.Clear;
begin
 inherited;

 FProcGetItems:= nil;
 FProcGetItemIndex:= nil;
 FProcSetItemIndex:= nil;
 FProcGetCaption:= nil;
 FProcSetCaption:= nil;
 FProcGetColumns:= nil;
 FProcSetColumns:= nil;
end;

function PrismRadioGroup.FrameworkClass: TClass;
begin
 Result:= TPrismRadioGroup;
end;

function PrismRadioGroup.GetProcGetCaption: TOnGetValue;
begin
 result:= FProcGetCaption;
end;

function PrismRadioGroup.GetProcGetColumns: TOnGetValue;
begin
 result:= FProcGetColumns;
end;

function PrismRadioGroup.GetProcGetItemIndex: TOnGetValue;
begin
 result:= FProcGetItemIndex;
end;

function PrismRadioGroup.GetProcGetItems: TOnGetStrings;
begin
 result:= FProcGetItems;
end;

function PrismRadioGroup.GetProcSetCaption: TOnSetValue;
begin
 result:= FProcSetCaption;
end;

function PrismRadioGroup.GetProcSetColumns: TOnSetValue;
begin
 result:= FProcSetColumns;
end;

function PrismRadioGroup.GetProcSetItemIndex: TOnSetValue;
begin
 result:= FProcSetItemIndex;
end;

procedure PrismRadioGroup.ProcessEventClass(VCLObj, NewObj: TObject);
begin
  inherited;

end;

procedure PrismRadioGroup.ProcessPropertyByName(VCLObj, NewObj: TObject;
  PropertyName: string; PropertyValue: Variant);
begin
 inherited;
end;

procedure PrismRadioGroup.ProcessPropertyClass(VCLObj, NewObj: TObject);
begin
 inherited;

 if Assigned(FProcGetItems) then
 TPrismRadioGroup(NewObj).ProcGetItems:= FProcGetItems;

 if Assigned(FProcGetItemIndex) then
 TPrismRadioGroup(NewObj).ProcGetItemIndex:= FProcGetItemIndex;

 if Assigned(FProcSetItemIndex) then
 TPrismRadioGroup(NewObj).ProcSetItemIndex:= FProcSetItemIndex;

 if Assigned(FProcGetCaption) then
 TPrismRadioGroup(NewObj).ProcGetCaption:= FProcGetCaption;

 if Assigned(FProcSetCaption) then
 TPrismRadioGroup(NewObj).ProcSetCaption:= FProcSetCaption;

 if Assigned(FProcGetColumns) then
 TPrismRadioGroup(NewObj).ProcGetColumns:= FProcGetColumns;

 if Assigned(FProcSetColumns) then
 TPrismRadioGroup(NewObj).ProcSetColumns:= FProcSetColumns;
end;

procedure PrismRadioGroup.SetProcGetCaption(const Value: TOnGetValue);
begin
 FProcGetCaption:= Value;
end;

procedure PrismRadioGroup.SetProcGetColumns(const Value: TOnGetValue);
begin
 FProcGetColumns:= Value;
end;

procedure PrismRadioGroup.SetProcGetItemIndex(const Value: TOnGetValue);
begin
 FProcGetItemIndex:= Value;
end;

procedure PrismRadioGroup.SetProcGetItems(AProc: TOnGetStrings);
begin
 FProcGetItems:= AProc;
end;

procedure PrismRadioGroup.SetProcSetCaption(const Value: TOnSetValue);
begin
 FProcSetCaption:= Value;
end;

procedure PrismRadioGroup.SetProcSetColumns(const Value: TOnSetValue);
begin
 FProcSetColumns:= Value;
end;

procedure PrismRadioGroup.SetProcSetItemIndex(const Value: TOnSetValue);
begin
 FProcSetItemIndex:= Value;
end;

{$ELSE}
implementation
{$ENDIF}

end.