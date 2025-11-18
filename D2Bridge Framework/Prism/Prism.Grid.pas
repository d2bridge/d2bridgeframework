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

{$I ..\D2Bridge.inc}

unit Prism.Grid;

interface

uses
  Classes, SysUtils, D2Bridge.JSON, Generics.Collections, DB,
  Prism.Forms.Controls, Prism.Interfaces, Prism.Grid.Columns;


type
 TPrismGrid = class(TPrismControl, IPrismGrid)
  private
   FPrismGridColumns: TPrismGridColumns;
   FMultiSelect: Boolean;
   FMultiSelectWidth: integer;
   FMaxRecords: Integer;
   FRecordsPerPage: Integer;
   FShowPager: boolean;
{$IFDEF FPC}
  protected
{$ENDIF}
   function GetMaxRecords: integer;
   Procedure SetMaxRecords(AMaxRecords: Integer);
   function GetRecordsPerPage: integer;
   Procedure SetRecordsPerPage(ARecordsPerPage: Integer);
   function GetMultiSelect: Boolean;
   Procedure SetMultiSelect(AMultiSelect: Boolean);
   function GetShowPager: Boolean;
   Procedure SetShowPager(Value: Boolean);
   function GetMultiSelectWidth: integer;
   Procedure SetMultiSelectWidth(Value: integer);

  protected
   //Abstract
   procedure SetDataToJSON; virtual; abstract;
   function GetDataToJSON: String; virtual; abstract;
   function GetSelectedRowsID: TList<Integer>; virtual; abstract;
   procedure SetSelectedRowsID(Value: TList<Integer>); virtual; abstract;
   procedure CellPostbyJSON(AJSON: string; out ARowID: string; out AErrorMessage: string); virtual; abstract;
   function GetEditable: Boolean; virtual; abstract;
   function RecNo: integer; overload; virtual; abstract;
   function RecNo(AValue: Integer): boolean; overload; virtual; abstract;
  public
   constructor Create(AOwner: TObject); override;
   destructor Destroy; override;

   function Columns: IPrismGridColumns;

   property MaxRecords: Integer read GetMaxRecords write SetMaxRecords;
   property RecordsPerPage: Integer read GetRecordsPerPage write SetRecordsPerPage;
   property MultiSelect: Boolean read GetMultiSelect write SetMultiSelect;
   property MultiSelectWidth: integer read GetMultiSelectWidth write SetMultiSelectWidth;
   property SelectedRowsID: TList<Integer> read GetSelectedRowsID write SetSelectedRowsID;
   property ShowPager: Boolean read GetShowPager write SetShowPager;
   property Editable: Boolean read GetEditable;
   property DataToJSON: String read GetDataToJSON;
 end;


implementation

{ TPrismGrid }

function TPrismGrid.Columns: IPrismGridColumns;
begin
 Result:= FPrismGridColumns;
end;

constructor TPrismGrid.Create(AOwner: TObject);
begin
 inherited;

 FPrismGridColumns:= TPrismGridColumns.Create(Self);

 FMultiSelectWidth:= 30;
 FShowPager:= true;
 FRecordsPerPage:= 100;
 FMaxRecords:= 5000;
 FMultiSelect:= false;
end;

destructor TPrismGrid.Destroy;
begin
 FreeAndNil(FPrismGridColumns);

 inherited;
end;

function TPrismGrid.GetMaxRecords: integer;
begin
 result:= FMaxRecords;
end;

function TPrismGrid.GetMultiSelect: Boolean;
begin
 result:= FMultiSelect;
end;

function TPrismGrid.GetMultiSelectWidth: integer;
begin
 result:= FMultiSelectWidth;
end;

function TPrismGrid.GetRecordsPerPage: integer;
begin
 Result:= FRecordsPerPage;
end;

function TPrismGrid.GetShowPager: Boolean;
begin
 Result:= FShowPager;
end;

procedure TPrismGrid.SetMaxRecords(AMaxRecords: Integer);
begin
 FMaxRecords:= AMaxRecords;
end;

procedure TPrismGrid.SetMultiSelect(AMultiSelect: Boolean);
begin
 FMultiSelect:= AMultiSelect;
end;

procedure TPrismGrid.SetMultiSelectWidth(Value: integer);
begin
 FMultiSelectWidth:= Value;
end;

procedure TPrismGrid.SetRecordsPerPage(ARecordsPerPage: Integer);
begin
 FRecordsPerPage:= ARecordsPerPage;
end;

procedure TPrismGrid.SetShowPager(Value: Boolean);
begin
 FShowPager:= Value;
end;

end.
