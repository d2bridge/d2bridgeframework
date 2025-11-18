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
