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

unit D2Bridge.FrameworkItem.GridColumns;

interface


uses
  Classes, Generics.Collections, D2Bridge.JSON,
  D2Bridge.Interfaces, D2Bridge.Types,
  Prism.Types;

type
 TD2BridgeFrameworkItemGridColumns = class(TInterfacedPersistent, ID2BridgeFrameworkItemGridColumns)
 private
  FColumns: TList<ID2BridgeFrameworkItemGridColumn>;
  function GetColumns: TList<ID2BridgeFrameworkItemGridColumn>;
 public
  constructor Create;
  destructor Destroy; override;

  procedure Clear;
  function Add: ID2BridgeFrameworkItemGridColumn; overload;
  procedure Add(AColumn: ID2BridgeFrameworkItemGridColumn); overload;

  property Items: TList<ID2BridgeFrameworkItemGridColumn> read GetColumns;
 end;


type
 TD2BridgeFrameworkItemGridColumn = class(TInterfacedPersistent, ID2BridgeFrameworkItemGridColumn)
  private
   FDataField: String;
   FTitle: String;
   FVisible: Boolean;
   FWidth: Integer;
   FEditable: Boolean;
   FAlignment: TD2BridgeColumnsAlignment;
   FDataFieldType: TPrismFieldType;
   FSelectItems: TJSONObject;
   function GetDataField: string;
   Procedure SetDataField(AFieldName: String);
   function GetTitle: string;
   Procedure SetTitle(ATitle: String);
   function GetVisible: Boolean;
   Procedure SetVisible(AVisible: Boolean);
   function GetWidth: Integer;
   Procedure SetWidth(AWidth: Integer);
   function GetAlignment: TD2BridgeColumnsAlignment;
   Procedure SetAlignment(AAlignment: TD2BridgeColumnsAlignment);
   function GetEditable: Boolean;
   Procedure SetEditable(AValue: Boolean);
   function GetDataFieldType: TPrismFieldType;
   procedure SetDataFieldType(const Value: TPrismFieldType);
  public
   constructor Create;
   destructor Destroy; override;

   function SelectItems: TJSONObject;
   property DataFieldType: TPrismFieldType read GetDataFieldType write SetDataFieldType;
   property Editable: Boolean read GetEditable write SetEditable;
   property DataField: String read GetDataField write SetDataField;
   property Title: String read GetTitle write SetTitle;
   property Visible: Boolean read GetVisible write SetVisible;
   property Width: Integer read GetWidth write SetWidth;
   property Alignment: TD2BridgeColumnsAlignment read GetAlignment write SetAlignment;
 end;

implementation

uses
  SysUtils;

{ TD2BridgeFrameworkItemGridColumns }

procedure TD2BridgeFrameworkItemGridColumns.Add(AColumn: ID2BridgeFrameworkItemGridColumn);
begin
 Items.Add(AColumn);
end;

function TD2BridgeFrameworkItemGridColumns.Add: ID2BridgeFrameworkItemGridColumn;
begin
 Result:= TD2BridgeFrameworkItemGridColumn.create;

 Items.Add(Result);
end;

procedure TD2BridgeFrameworkItemGridColumns.Clear;
var
 vColumnIntf: ID2BridgeFrameworkItemGridColumn;
 vColumn: TD2BridgeFrameworkItemGridColumn;
begin
 while FColumns.Count > 0 do
 begin
  vColumnIntf:= FColumns.Last;
  FColumns.Delete(Pred(FColumns.Count));

  vColumn:= vColumnIntf as TD2BridgeFrameworkItemGridColumn;
  vColumnIntf:= nil;
  vColumn.Free;
 end;
end;

constructor TD2BridgeFrameworkItemGridColumns.Create;
begin
 FColumns:= TList<ID2BridgeFrameworkItemGridColumn>.create;
end;


destructor TD2BridgeFrameworkItemGridColumns.Destroy;
begin
 Clear;
 FreeAndNil(FColumns);

 inherited;
end;

function TD2BridgeFrameworkItemGridColumns.GetColumns: TList<ID2BridgeFrameworkItemGridColumn>;
begin
 Result:= FColumns;
end;

{ TD2BridgeFrameworkItemGridColumn }

constructor TD2BridgeFrameworkItemGridColumn.Create;
begin
 FVisible:= true;
 FAlignment:= D2BridgeAlignColumnsLeft;
 FEditable:= false;
 FDataFieldType:= PrismFieldTypeString;
 FSelectItems:= TJSONObject.Create;
end;

destructor TD2BridgeFrameworkItemGridColumn.Destroy;
begin
 if Assigned(FSelectItems) then
 FSelectItems.Free;

 inherited;
end;

function TD2BridgeFrameworkItemGridColumn.GetAlignment: TD2BridgeColumnsAlignment;
begin
 result:= FAlignment;
end;

function TD2BridgeFrameworkItemGridColumn.GetDataField: string;
begin
 Result:= FDataField;
end;

function TD2BridgeFrameworkItemGridColumn.GetDataFieldType: TPrismFieldType;
begin
 Result:= FDataFieldType;
end;

function TD2BridgeFrameworkItemGridColumn.GetEditable: Boolean;
begin
 Result:= FEditable;
end;

function TD2BridgeFrameworkItemGridColumn.GetTitle: string;
begin
 Result:= FTitle;
end;

function TD2BridgeFrameworkItemGridColumn.GetVisible: Boolean;
begin
 Result:= FVisible;
end;

function TD2BridgeFrameworkItemGridColumn.GetWidth: Integer;
begin
 Result:= FWidth;
end;

function TD2BridgeFrameworkItemGridColumn.SelectItems: TJSONObject;
begin
 Result:= FSelectItems;
end;

procedure TD2BridgeFrameworkItemGridColumn.SetAlignment(AAlignment: TD2BridgeColumnsAlignment);
begin
 FAlignment:= AAlignment;
end;

procedure TD2BridgeFrameworkItemGridColumn.SetDataField(AFieldName: String);
begin
 FDataField:= AFieldName;
end;

procedure TD2BridgeFrameworkItemGridColumn.SetDataFieldType(const Value: TPrismFieldType);
begin
 FDataFieldType:= Value;
end;

procedure TD2BridgeFrameworkItemGridColumn.SetEditable(AValue: Boolean);
begin
 FEditable:= AValue;
end;

procedure TD2BridgeFrameworkItemGridColumn.SetTitle(ATitle: String);
begin
 FTitle:= ATitle;
end;

procedure TD2BridgeFrameworkItemGridColumn.SetVisible(AVisible: Boolean);
begin
 FVisible:= AVisible;
end;

procedure TD2BridgeFrameworkItemGridColumn.SetWidth(AWidth: Integer);
begin
 FWidth:= AWidth;
end;

end.
