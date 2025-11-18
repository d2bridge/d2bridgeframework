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

unit D2Bridge.Prism.DBEdit;

interface

{$IFNDEF FMX}
uses
  Classes, SysUtils,
{$IFDEF HAS_UNIT_SYSTEM_UITYPES}
  System.UITypes,
{$ENDIF}
{$IFNDEF FPC}

{$ELSE}
  StdCtrls,
{$ENDIF}
  D2Bridge.Interfaces, D2Bridge.Prism, D2Bridge.FrameworkItem.DataWare, D2Bridge.Prism.Item,
  Prism.Types;


type
  PrismDBEdit = class(TD2BridgePrismItem, ID2BridgeFrameworkItemDBEdit)
  private
   FD2BridgeDatawareDataSource: TD2BridgeDatawareDataSource;
   FDataType: TPrismFieldType;
   FCharCase: TEditCharCase;
   function GetEditDataType: TPrismFieldType;
   procedure SetEditDataType(const Value: TPrismFieldType);
   function GetCharCase: TEditCharCase;
   procedure SetCharCase(ACharCase: TEditCharCase);
  public
   constructor Create(AD2BridgePrismFramework: TD2BridgePrismFramework); reintroduce;
   destructor Destroy; override;

   procedure Clear; override;
   function FrameworkClass: TClass; override;
   procedure ProcessPropertyClass(VCLObj, NewObj: TObject); override;
   procedure ProcessEventClass(VCLObj, NewObj: TObject); override;
   procedure ProcessPropertyByName(VCLObj, NewObj: TObject; PropertyName: string; PropertyValue: Variant); override;

   function DataWare: ID2BridgeDatawareDataSource;
   property CharCase: TEditCharCase read GetCharCase write SetCharCase;
   property DataType: TPrismFieldType read GetEditDataType write SetEditDataType;
  end;



implementation

uses
  Prism.DBEdit;


{ PrismDBEdit }

procedure PrismDBEdit.Clear;
begin
 inherited;

 FDataType:= PrismFieldTypeAuto;
 FCharCase:= TEditCharCase.ecNormal;
 Dataware.Clear;
end;

constructor PrismDBEdit.Create(AD2BridgePrismFramework: TD2BridgePrismFramework);
begin
 inherited Create(AD2BridgePrismFramework);

 FD2BridgeDatawareDataSource:= TD2BridgeDatawareDataSource.Create;
end;

function PrismDBEdit.DataWare: ID2BridgeDatawareDataSource;
begin
 Result:= FD2BridgeDatawareDataSource;
end;

destructor PrismDBEdit.Destroy;
begin
 FreeAndNil(FD2BridgeDatawareDataSource);

 inherited;
end;

function PrismDBEdit.FrameworkClass: TClass;
begin
 inherited;

 Result:= TPrismDBEdit;
end;

function PrismDBEdit.GetCharCase: TEditCharCase;
begin
 Result:= FCharCase;
end;

function PrismDBEdit.GetEditDataType: TPrismFieldType;
begin
 Result:= FDataType;
end;

procedure PrismDBEdit.ProcessEventClass(VCLObj, NewObj: TObject);
begin
 inherited;

end;

procedure PrismDBEdit.ProcessPropertyByName(VCLObj, NewObj: TObject;
  PropertyName: string; PropertyValue: Variant);
begin
 inherited;

end;

procedure PrismDBEdit.ProcessPropertyClass(VCLObj, NewObj: TObject);
begin
 inherited;

 if Assigned(Dataware.DataSource) then
  TPrismDBEdit(NewObj).DataWare.DataSource:= Dataware.DataSource;

 if Dataware.DataField <> '' then
  TPrismDBEdit(NewObj).DataWare.FieldName := Dataware.DataField;

 TPrismDBEdit(NewObj).CharCase:= CharCase;

 TPrismDBEdit(NewObj).DataType:= DataType;
end;


procedure PrismDBEdit.SetCharCase(ACharCase: TEditCharCase);
begin
 FCharCase:= ACharCase;
end;

procedure PrismDBEdit.SetEditDataType(const Value: TPrismFieldType);
begin
 FDataType:= Value;
end;
{$ELSE}
implementation
{$ENDIF}

end.
