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

unit D2Bridge.Prism.DBText;

interface

{$IFNDEF FMX}
uses
  Classes, SysUtils,
  D2Bridge.Interfaces, D2Bridge.Prism, D2Bridge.FrameworkItem.DataWare, D2Bridge.Prism.Item,
  Prism.Types;


type
 PrismDBText = class(TD2BridgePrismItem, ID2BridgeFrameworkItemDBText)
  private
   FD2BridgeDatawareDataSource: TD2BridgeDatawareDataSource;
   FDataType: TPrismFieldType;
   procedure SetDataType(Value: TPrismFieldType);
   function GetDataType: TPrismFieldType;
  public
   constructor Create(AD2BridgePrismFramework: TD2BridgePrismFramework); reintroduce;
   destructor Destroy; override;

   procedure Clear; override;
   function FrameworkClass: TClass; override;
   procedure ProcessPropertyClass(VCLObj, NewObj: TObject); override;
   procedure ProcessEventClass(VCLObj, NewObj: TObject); override;
   procedure ProcessPropertyByName(VCLObj, NewObj: TObject; PropertyName: string; PropertyValue: Variant); override;

   function DataWare: ID2BridgeDatawareDataSource;
   property DataType: TPrismFieldType read GetDataType write SetDataType;
  end;



implementation

uses
  Prism.DBText;


{ PrismDBText }

procedure PrismDBText.Clear;
begin
 inherited;

 FDataType:= PrismFieldTypeAuto;
 Dataware.Clear;
end;

constructor PrismDBText.Create(AD2BridgePrismFramework: TD2BridgePrismFramework);
begin
 inherited Create(AD2BridgePrismFramework);

 FD2BridgeDatawareDataSource:= TD2BridgeDatawareDataSource.Create;
end;

function PrismDBText.DataWare: ID2BridgeDatawareDataSource;
begin
 Result:= FD2BridgeDatawareDataSource;
end;

destructor PrismDBText.Destroy;
begin
 FreeAndNil(FD2BridgeDatawareDataSource);

 inherited;
end;

function PrismDBText.FrameworkClass: TClass;
begin
 inherited;

 Result:= TPrismDBText;
end;

function PrismDBText.GetDataType: TPrismFieldType;
begin
 Result:= FDataType;
end;

procedure PrismDBText.ProcessEventClass(VCLObj, NewObj: TObject);
begin
 inherited;

end;

procedure PrismDBText.ProcessPropertyByName(VCLObj, NewObj: TObject;
  PropertyName: string; PropertyValue: Variant);
begin
 inherited;

end;

procedure PrismDBText.ProcessPropertyClass(VCLObj, NewObj: TObject);
begin
 inherited;

 TPrismDBText(NewObj).DataType:= DataType;

 if Assigned(Dataware.DataSource) then
 TPrismDBText(NewObj).DataWare.DataSource:= Dataware.DataSource;

 if Dataware.DataField <> '' then
 TPrismDBText(NewObj).DataWare.FieldName:= Dataware.DataField;

end;
procedure PrismDBText.SetDataType(Value: TPrismFieldType);
begin
 FDataType:= Value;
end;

{$ELSE}
implementation
{$ENDIF}

end.