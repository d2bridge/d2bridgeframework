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

unit D2Bridge.FrameworkItem.DataWare;

interface

uses
  Classes, Generics.Collections, DB,
{$IFDEF FMX}
  FMX.Grid,
{$ELSE}
  Grids,
{$ENDIF}
  D2Bridge.Interfaces, D2Bridge.Types;


type
 TD2BridgeDatawareOnlyDataSource = class(TInterfacedPersistent, ID2BridgeDatawareOnlyDataSource)
  private
   FDataSource: TDataSource;
   procedure Clear;
   function GetDataSource: TDataSource;
   procedure SetDataSource(ADataSource: TDataSource);
  public

 end;


 TD2BridgeDatawareDataSource = class(TInterfacedPersistent, ID2BridgeDatawareDataSource)
 private
  FDataSource: TDataSource;
  FDataField: String;
  procedure Clear;
  function GetDataSource: TDataSource;
  procedure SetDataSource(ADataSource: TDataSource);
  function GetDataField: string;
  Procedure SetDataField(AFieldName: string);
 public

 end;

 TD2BridgeDatawareListSource = class(TInterfacedPersistent, ID2BridgeDatawareListSource)
  private
   FListField: String;
   FKeyField: String;
   FListSource: TDataSource;
   procedure Clear;
   function GetListField: string;
   Procedure SetListField(AFieldName: string);
   function GetKeyField: string;
   Procedure SetKeyField(AFieldName: string);
   function GetListSource: TDataSource;
   procedure SetListSource(ADataSource: TDataSource);
  public

 end;

 TD2BridgeDatawareStringGrid = class(TInterfacedPersistent, ID2BridgeDatawareStringGrid)
  private
   FStringGrid: TStringGrid;
   procedure Clear;
   function GetStringGrid: TStringGrid;
   procedure SetStringGrid(AStringGrid: TStringGrid);
  public

 end;


 TD2BridgeDataware = class(TInterfacedPersistent, ID2BridgeDataware)
   function DataSource: ID2BridgeDatawareDataSource;
   function ListSource: ID2BridgeDatawareListSource;
  private
   FDataSource: TD2BridgeDatawareDataSource;
   FListSource: TD2BridgeDatawareListSource;
  public
   constructor Create;
   destructor Destroy; override;

   procedure Clear;
 end;


implementation

uses
  SysUtils;

{ TD2BridgeDatawareDataSource }

procedure TD2BridgeDatawareDataSource.Clear;
begin
 FDataSource:= nil;
 FDataField:= '';
end;

function TD2BridgeDatawareDataSource.GetDataField: string;
begin
 Result:= FDataField;
end;

function TD2BridgeDatawareDataSource.GetDataSource: TDataSource;
begin
 Result:= FDataSource;
end;

procedure TD2BridgeDatawareDataSource.SetDataField(AFieldName: string);
begin
 FDataField:= AFieldName;
end;

procedure TD2BridgeDatawareDataSource.SetDataSource(ADataSource: TDataSource);
begin
 FDataSource:= ADataSource;
end;

{ TD2BridgeDatawareListSource }

procedure TD2BridgeDatawareListSource.Clear;
begin
 FListField:= '';
 FKeyField:= '';
 FListSource:= nil;
end;

function TD2BridgeDatawareListSource.GetKeyField: string;
begin
 Result:= FKeyField;
end;

function TD2BridgeDatawareListSource.GetListField: string;
begin
 Result:= FListField;
end;

function TD2BridgeDatawareListSource.GetListSource: TDataSource;
begin
 Result:= FListSource;
end;

procedure TD2BridgeDatawareListSource.SetKeyField(AFieldName: string);
begin
 FKeyField:= AFieldName;
end;

procedure TD2BridgeDatawareListSource.SetListField(AFieldName: string);
begin
 FListField:= AFieldName;
end;

procedure TD2BridgeDatawareListSource.SetListSource(ADataSource: TDataSource);
begin
 FListSource:= ADataSource;
end;

{ TD2BridgeDataware }

procedure TD2BridgeDataware.Clear;
begin
 DataSource.Clear;
 ListSource.Clear;
end;

constructor TD2BridgeDataware.Create;
begin
 FDataSource:= TD2BridgeDatawareDataSource.Create;
 FListSource:= TD2BridgeDatawareListSource.Create;
end;

function TD2BridgeDataware.DataSource: ID2BridgeDatawareDataSource;
begin
 Result:= FDataSource;
end;

destructor TD2BridgeDataware.Destroy;
begin
 FreeAndNil(FDataSource);
 FreeAndNil(FListSource);

  inherited;
end;

function TD2BridgeDataware.ListSource: ID2BridgeDatawareListSource;
begin
 Result:= FListSource;
end;

{ TD2BridgeDatawareOnlyDataSource }

procedure TD2BridgeDatawareOnlyDataSource.Clear;
begin
 FDataSource:= nil;
end;

function TD2BridgeDatawareOnlyDataSource.GetDataSource: TDataSource;
begin
 Result:= FDataSource;
end;

procedure TD2BridgeDatawareOnlyDataSource.SetDataSource(
  ADataSource: TDataSource);
begin
 FDataSource:= ADataSource;
end;

{ TD2BridgeDatawareStringGrid }

procedure TD2BridgeDatawareStringGrid.Clear;
begin
  FStringGrid:= nil;
end;

function TD2BridgeDatawareStringGrid.GetStringGrid: TStringGrid;
begin
  Result:= FStringGrid;
end;

procedure TD2BridgeDatawareStringGrid.SetStringGrid(AStringGrid: TStringGrid);
begin
  FStringGrid:= AStringGrid;
end;

end.
