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

unit D2Bridge.Prism.DBMemo;

interface

{$IFNDEF FMX}
uses
  Classes, SysUtils,
  D2Bridge.Interfaces, D2Bridge.Prism, D2Bridge.FrameworkItem.DataWare, D2Bridge.Prism.Item;


type
 PrismDBMemo = class(TD2BridgePrismItem, ID2BridgeFrameworkItemDBMemo)
  private
   FD2BridgeDatawareDataSource: TD2BridgeDatawareDataSource;
  public
   constructor Create(AD2BridgePrismFramework: TD2BridgePrismFramework); override;
   destructor Destroy; override;

   procedure Clear; override;
   function FrameworkClass: TClass; override;
   procedure ProcessPropertyClass(VCLObj, NewObj: TObject); override;
   procedure ProcessEventClass(VCLObj, NewObj: TObject); override;
   procedure ProcessPropertyByName(VCLObj, NewObj: TObject; PropertyName: string; PropertyValue: Variant); override;

   function DataWare: ID2BridgeDatawareDataSource;

  end;



implementation

uses
  Prism.DBMemo;


{ PrismDBMemo }

procedure PrismDBMemo.Clear;
begin
 inherited;

 Dataware.Clear;
end;

constructor PrismDBMemo.Create(AD2BridgePrismFramework: TD2BridgePrismFramework);
begin
 inherited;

 FD2BridgeDatawareDataSource:= TD2BridgeDatawareDataSource.Create;
end;

function PrismDBMemo.DataWare: ID2BridgeDatawareDataSource;
begin
 Result:= FD2BridgeDatawareDataSource;
end;

destructor PrismDBMemo.Destroy;
begin
 FreeAndNil(FD2BridgeDatawareDataSource);

 inherited;
end;

function PrismDBMemo.FrameworkClass: TClass;
begin
 inherited;

 Result:= TPrismDBMemo;
end;


procedure PrismDBMemo.ProcessEventClass(VCLObj, NewObj: TObject);
begin
 inherited;

end;

procedure PrismDBMemo.ProcessPropertyByName(VCLObj, NewObj: TObject;
  PropertyName: string; PropertyValue: Variant);
begin
 inherited;

end;

procedure PrismDBMemo.ProcessPropertyClass(VCLObj, NewObj: TObject);
begin
 inherited;

 if Assigned(Dataware.DataSource) then
 TPrismDBMemo(NewObj).DataWare.DataSource:= Dataware.DataSource;

 if Dataware.DataField <> '' then
 TPrismDBMemo(NewObj).DataWare.FieldName:= Dataware.DataField;
end;
{$ELSE}
implementation
{$ENDIF}

end.