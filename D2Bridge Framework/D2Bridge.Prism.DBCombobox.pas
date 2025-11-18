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

unit D2Bridge.Prism.DBCombobox;

interface

{$IFNDEF FMX}
uses
  Classes, SysUtils,
  D2Bridge.Interfaces, D2Bridge.Prism, D2Bridge.FrameworkItem.DataWare, D2Bridge.Prism.Item;


type
 PrismDBCombobox = class(TD2BridgePrismItem, ID2BridgeFrameworkItemDBCombobox)
  private
   FProcGetItems: TOnGetStrings;
   FD2BridgeDatawareDataSource: TD2BridgeDatawareDataSource;
   procedure SetProcGetItems(AProc: TOnGetStrings);
   function GetProcGetItems: TOnGetStrings;
  public
   constructor Create(AD2BridgePrismFramework: TD2BridgePrismFramework); reintroduce;
   destructor Destroy; override;

   procedure Clear; override;
   function FrameworkClass: TClass; override;
   procedure ProcessPropertyClass(VCLObj, NewObj: TObject); override;
   procedure ProcessEventClass(VCLObj, NewObj: TObject); override;
   procedure ProcessPropertyByName(VCLObj, NewObj: TObject; PropertyName: string; PropertyValue: Variant); override;

   function DataWare: ID2BridgeDatawareDataSource;

   property ProcGetItems: TOnGetStrings read GetProcGetItems write SetProcGetItems;
  end;



implementation

uses
  Prism.DBCombobox;


{ PrismDBCombobox }

procedure PrismDBCombobox.Clear;
begin
 inherited;

 FProcGetItems:= nil;
 Dataware.Clear;
end;

constructor PrismDBCombobox.Create(AD2BridgePrismFramework: TD2BridgePrismFramework);
begin
 inherited Create(AD2BridgePrismFramework);

 FD2BridgeDatawareDataSource:= TD2BridgeDatawareDataSource.Create;
end;

function PrismDBCombobox.DataWare: ID2BridgeDatawareDataSource;
begin
 Result:= FD2BridgeDatawareDataSource;
end;

destructor PrismDBCombobox.Destroy;
begin
 FreeAndNil(FD2BridgeDatawareDataSource);

 inherited;
end;

function PrismDBCombobox.FrameworkClass: TClass;
begin
 inherited;

 Result:= TPrismDBCombobox;
end;

function PrismDBCombobox.GetProcGetItems: TOnGetStrings;
begin
 Result:= FProcGetItems;
end;

procedure PrismDBCombobox.ProcessEventClass(VCLObj, NewObj: TObject);
begin
 inherited;

end;

procedure PrismDBCombobox.ProcessPropertyByName(VCLObj, NewObj: TObject;
  PropertyName: string; PropertyValue: Variant);
begin
 inherited;

end;

procedure PrismDBCombobox.ProcessPropertyClass(VCLObj, NewObj: TObject);
begin
 inherited;

 if Assigned(Dataware.DataSource) then
  TPrismDBCombobox(NewObj).DataWare.DataSource:= Dataware.DataSource;

 if Dataware.DataField <> '' then
  TPrismDBCombobox(NewObj).DataWare.FieldName:= Dataware.DataField;

 if Assigned(FProcGetItems) then
  TPrismDBCombobox(NewObj).ProcGetItems:= FProcGetItems;

end;


procedure PrismDBCombobox.SetProcGetItems(AProc: TOnGetStrings);
begin
 FProcGetItems:= AProc;
end;
{$ELSE}
implementation
{$ENDIF}

end.
