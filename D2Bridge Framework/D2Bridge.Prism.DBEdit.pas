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