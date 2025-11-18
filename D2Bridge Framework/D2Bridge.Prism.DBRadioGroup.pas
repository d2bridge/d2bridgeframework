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

unit D2Bridge.Prism.DBRadioGroup;

interface

uses
  Classes, SysUtils,
  D2Bridge.Interfaces, D2Bridge.Prism, D2Bridge.Prism.Item, D2Bridge.FrameworkItem.DataWare;

type
 PrismDBRadioGroup = class(TD2BridgePrismItem, ID2BridgeFrameworkItemDBRadioGroup)
  private
   FProcGetItems: TOnGetStrings;
   FProcSetCaption: TOnSetValue;
   FProcGetCaption: TOnGetValue;
   FProcSetColumns: TOnSetValue;
   FProcGetColumns: TOnGetValue;
   FD2BridgeDatawareDataSource: TD2BridgeDatawareDataSource;
   procedure SetProcGetItems(AProc: TOnGetStrings);
   function GetProcGetItems: TOnGetStrings;
   function GetProcGetCaption: TOnGetValue;
   function GetProcSetCaption: TOnSetValue;
   procedure SetProcGetCaption(const Value: TOnGetValue);
   procedure SetProcSetCaption(const Value: TOnSetValue);
   function GetProcGetColumns: TOnGetValue;
   function GetProcSetColumns: TOnSetValue;
   procedure SetProcGetColumns(const Value: TOnGetValue);
   procedure SetProcSetColumns(const Value: TOnSetValue);
  public
   constructor Create(AD2BridgePrismFramework: TD2BridgePrismFramework); override;
   destructor Destroy; override;

   procedure Clear; override;
   function FrameworkClass: TClass; override;
   procedure ProcessPropertyClass(VCLObj, NewObj: TObject); override;
   procedure ProcessEventClass(VCLObj, NewObj: TObject); override;
   procedure ProcessPropertyByName(VCLObj, NewObj: TObject; PropertyName: string; PropertyValue: Variant); override;

   function Dataware : ID2BridgeDatawareDataSource;

   property ProcGetItems: TOnGetStrings read GetProcGetItems write SetProcGetItems;
   property ProcGetCaption: TOnGetValue read GetProcGetCaption write SetProcGetCaption;
   property ProcSetCaption: TOnSetValue read GetProcSetCaption write SetProcSetCaption;
   property ProcGetColumns: TOnGetValue read GetProcGetColumns write SetProcGetColumns;
   property ProcSetColumns: TOnSetValue read GetProcSetColumns write SetProcSetColumns;
  end;

implementation

{ PrismDBRadioGroup }

Uses
 Prism.DBRadioGroup;


procedure PrismDBRadioGroup.Clear;
begin
 inherited;

 FProcGetItems:= nil;
 FProcGetCaption:= nil;
 FProcSetCaption:= nil;
 FProcGetColumns:= nil;
 FProcSetColumns:= nil;
 Dataware.Clear;
end;

constructor PrismDBRadioGroup.Create(AD2BridgePrismFramework: TD2BridgePrismFramework);
begin
 inherited;

 FD2BridgeDatawareDataSource:= TD2BridgeDatawareDataSource.Create;
end;

function PrismDBRadioGroup.Dataware: ID2BridgeDatawareDataSource;
begin
 result:= FD2BridgeDatawareDataSource;
end;

destructor PrismDBRadioGroup.Destroy;
begin
 FreeAndNil(FD2BridgeDatawareDataSource);

 inherited;
end;

function PrismDBRadioGroup.FrameworkClass: TClass;
begin
 Result:= TPrismDBRadioGroup;
end;

function PrismDBRadioGroup.GetProcGetCaption: TOnGetValue;
begin
 result:= FProcGetCaption;
end;

function PrismDBRadioGroup.GetProcGetColumns: TOnGetValue;
begin
 result:= FProcGetColumns;
end;

function PrismDBRadioGroup.GetProcGetItems: TOnGetStrings;
begin
 result:= FProcGetItems;
end;

function PrismDBRadioGroup.GetProcSetCaption: TOnSetValue;
begin
 result:= FProcSetCaption;
end;

function PrismDBRadioGroup.GetProcSetColumns: TOnSetValue;
begin
 result:= FProcSetColumns;
end;

procedure PrismDBRadioGroup.ProcessEventClass(VCLObj, NewObj: TObject);
begin
  inherited;

end;

procedure PrismDBRadioGroup.ProcessPropertyByName(VCLObj, NewObj: TObject;
  PropertyName: string; PropertyValue: Variant);
begin
  inherited;

end;

procedure PrismDBRadioGroup.ProcessPropertyClass(VCLObj, NewObj: TObject);
begin
 inherited;

 if Assigned(Dataware.DataSource) then
 TPrismDBRadioGroup(NewObj).DataWare.DataSource:= Dataware.DataSource;

 if Dataware.DataField <> '' then
 TPrismDBRadioGroup(NewObj).DataWare.FieldName:= Dataware.DataField;

 if Assigned(FProcGetItems) then
 TPrismDBRadioGroup(NewObj).ProcGetItems:= FProcGetItems;

 if Assigned(FProcGetCaption) then
 TPrismDBRadioGroup(NewObj).ProcGetCaption:= FProcGetCaption;

 if Assigned(FProcSetCaption) then
 TPrismDBRadioGroup(NewObj).ProcSetCaption:= FProcSetCaption;

 if Assigned(FProcGetColumns) then
 TPrismDBRadioGroup(NewObj).ProcGetColumns:= FProcGetColumns;

 if Assigned(FProcSetColumns) then
 TPrismDBRadioGroup(NewObj).ProcSetColumns:= FProcSetColumns;
end;

procedure PrismDBRadioGroup.SetProcGetCaption(const Value: TOnGetValue);
begin
 FProcGetCaption:= Value;
end;

procedure PrismDBRadioGroup.SetProcGetColumns(const Value: TOnGetValue);
begin
 FProcGetColumns:= Value;
end;

procedure PrismDBRadioGroup.SetProcGetItems(AProc: TOnGetStrings);
begin
 FProcGetItems:= AProc;
end;

procedure PrismDBRadioGroup.SetProcSetCaption(const Value: TOnSetValue);
begin
 FProcSetCaption:= Value;
end;

procedure PrismDBRadioGroup.SetProcSetColumns(const Value: TOnSetValue);
begin
 FProcSetColumns:= Value;
end;

end.