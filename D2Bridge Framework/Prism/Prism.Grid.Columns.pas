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

{$I ..\D2Bridge.inc}

unit Prism.Grid.Columns;

interface


uses
  Classes, Generics.Collections, SysUtils, D2Bridge.JSON,
  Prism.Interfaces, Prism.Types;


type
 TPrismGridColumns = class;

 TPrismGridColumn = class(TInterfacedPersistent, IPrismGridColumn)
  strict private
   function LastColumnIndex: integer;
   procedure RefreshColName;
  private
   FPrismGridColumns: TPrismGridColumns;
   FDataField: String;
   FTitle: String;
   FVisible: Boolean;
   FWidth: Integer;
   FEditable: Boolean;
   FAlignment: TPrismAlignment;
   FDataFieldType: TPrismFieldType;
   FDataFieldModel: TPrismFieldModel;
   FSelectItems: TJSONObject;
   FColumnIndex: Integer;
   FCSS: String;
   FButtons: IPrismGridColumnButtons;
   FHTML: String;
   FColName: String;
   function GetDataField: string;
   Procedure SetDataField(AFieldName: String);
   function GetTitle: string;
   Procedure SetTitle(ATitle: String);
   function GetVisible: Boolean;
   Procedure SetVisible(AVisible: Boolean);
   function GetWidth: Integer;
   Procedure SetWidth(AWidth: Integer);
   function GetAlignment: TPrismAlignment;
   Procedure SetAlignment(AAlignment: TPrismAlignment);
   function GetEditable: Boolean;
   procedure SetEditable(const Value: Boolean);
   function GetDataFieldType: TPrismFieldType;
   procedure SetDataFieldType(const Value: TPrismFieldType);
   function GetSelectItems: TJSONObject;
   procedure SetSelectItems(AItems: TJSONObject);
   function GetDataFieldModel: TPrismFieldModel;
   procedure SetDataFieldModel(const Value: TPrismFieldModel);
   function GetColumnIndex: Integer;
   procedure SetColumnIndex(Value: Integer);
   function GetCSS: String;
   procedure SetCSS(const Value: String);
   function GetHTML: String;
   procedure SetHTML(const Value: String);
  public
   constructor Create(APrismGridColumns: TPrismGridColumns);
   destructor Destroy; override;

   function Buttons: IPrismGridColumnButtons;
   function ButtonFromButtonModel(AButtonModel: IButtonModel): IPrismGridColumnButton;
   function ButtonFromIdentify(AIdentify: String): IPrismGridColumnButton;
   function ColName: string;
   function PrismGrid: IPrismGrid;

   property DataFieldType: TPrismFieldType read GetDataFieldType write SetDataFieldType;
   property DataFieldModel: TPrismFieldModel read GetDataFieldModel write SetDataFieldModel;
   property DataField: String read GetDataField write SetDataField;
   property Title: String read GetTitle write SetTitle;
   property Visible: Boolean read GetVisible write SetVisible;
   property Width: Integer read GetWidth write SetWidth;
   property ColumnIndex: Integer read GetColumnIndex write SetColumnIndex;
   property CSS: String read GetCSS write SetCSS;
   property HTML: String read GetHTML write SetHTML;
   property Alignment: TPrismAlignment read GetAlignment write SetAlignment;
   property SelectItems: TJSONObject read GetSelectItems write SetSelectItems;
   property Editable: Boolean read GetEditable write SetEditable;
 end;


 TPrismGridColumns = class(TInterfacedPersistent, IPrismGridColumns)
  private
   FColumns: TList<IPrismGridColumn>;
   FPrismGrid: IPrismGrid;
   function GetColumnsNameToJSON: TJSONArray;
  public
   constructor Create(APrismGrid: IPrismGrid);
   destructor Destroy; override;

   function PrismGrid: IPrismGrid;

   Procedure Clear;
   function GetColumns: TList<IPrismGridColumn>;
   function Add: IPrismGridColumn; overload;
   procedure Add(AColumn: IPrismGridColumn); overload;
   function ColumnByDataField(ADataField: string): IPrismGridColumn;
   function ColumnByIndex(AColumnIndex: Integer): IPrismGridColumn;
   function ColumnByTitle(ATitle: string): IPrismGridColumn;

   property Items: TList<IPrismGridColumn> read GetColumns;
   property ColumnsNameToJSON: TJSONArray read GetColumnsNameToJSON;
 end;


implementation

uses
  Prism.Grid.Columns.Buttons;

{ TPrismGridColumn }

function TPrismGridColumn.ButtonFromButtonModel(AButtonModel: IButtonModel): IPrismGridColumnButton;
var
 vButton: IPrismGridColumnButton;
begin
 System.Initialize(result);

 for vButton in FButtons.Items do
  if vButton.ButtonModel.Identity = AButtonModel.Identity then
  begin
   Result:= vButton;
   break;
  end;
end;

function TPrismGridColumn.ButtonFromIdentify(AIdentify: String): IPrismGridColumnButton;
var
 vButton: IPrismGridColumnButton;
begin
 System.Initialize(result);

 if AIdentify <> '' then
 begin
  for vButton in FButtons.Items do
   if vButton.Identify = AIdentify then
   begin
    Result:= vButton;
    break;
   end;
 end;
end;

function TPrismGridColumn.Buttons: IPrismGridColumnButtons;
begin
 Result:= FButtons;
end;

function TPrismGridColumn.ColName: string;
begin
 Result:= FColName;
end;

constructor TPrismGridColumn.Create(APrismGridColumns: TPrismGridColumns);
begin
 inherited Create;

 FPrismGridColumns:= APrismGridColumns;

 //FSelectItems:= TDictionary<string,string>.Create;

 FDataFieldType:= PrismFieldTypeString;
 FDataFieldModel:= PrismFieldModelNone;

 FButtons:= TPrismGridColumnButtons.Create(self);

 FColumnIndex:= LastColumnIndex + 1;

 FVisible:= true;
 FTitle:= 'Column';
 FEditable:= false;

 RefreshColName;
end;

destructor TPrismGridColumn.Destroy;
var
 vButtons: TPrismGridColumnButtons;
begin
 //FSelectItems.Free;

 vButtons:= FButtons as TPrismGridColumnButtons;
 FButtons:= nil;
 vButtons.Free;

 inherited;
end;

function TPrismGridColumn.GetAlignment: TPrismAlignment;
begin
 Result:= FAlignment;
end;

function TPrismGridColumn.GetColumnIndex: Integer;
begin
 Result:= FColumnIndex;
end;

function TPrismGridColumn.GetCSS: String;
begin
 Result:= FCSS;
end;

function TPrismGridColumn.GetDataField: string;
begin
 Result:= FDataField;
end;

function TPrismGridColumn.GetDataFieldModel: TPrismFieldModel;
begin
 Result:= FDataFieldModel;
end;

function TPrismGridColumn.GetDataFieldType: TPrismFieldType;
begin
 Result:= FDataFieldType;
end;

function TPrismGridColumn.GetEditable: Boolean;
begin
 Result:= FEditable;
end;

function TPrismGridColumn.GetHTML: String;
begin
 Result:= FHTML;
end;

function TPrismGridColumn.GetSelectItems: TJSONObject;
begin
 Result:= FSelectItems;
end;

function TPrismGridColumn.GetTitle: string;
begin
 Result:= FTitle;
end;

function TPrismGridColumn.GetVisible: Boolean;
begin
 Result:= FVisible;
end;

function TPrismGridColumn.GetWidth: Integer;
begin
 Result:= FWidth;
end;

function TPrismGridColumn.LastColumnIndex: integer;
var
 I: integer;
 vLastColumnIndex: integer;
begin
 vLastColumnIndex:= -1;

 for I := 0 to Pred(FPrismGridColumns.FColumns.Count) do
 if FPrismGridColumns.FColumns[I].ColumnIndex > vLastColumnIndex then
  vLastColumnIndex:= FPrismGridColumns.FColumns[I].ColumnIndex;

 Result:= vLastColumnIndex;
end;

function TPrismGridColumn.PrismGrid: IPrismGrid;
begin
 result:= FPrismGridColumns.PrismGrid;
end;

procedure TPrismGridColumn.RefreshColName;
var
 vPseudoName: string;
 vIndex: integer;
 vColName: string;
 vExistDuplicateName: Boolean;
 I: integer;
begin
 vIndex:= 0;

 if FDataField <> '' then
  vPseudoName:= FDataField
 else
 if FDataFieldModel = PrismFieldModelHTML then
  vPseudoName:= 'ColHTML'
 else
 if FDataFieldModel = PrismFieldModelButton then
  vPseudoName:= 'ColButton'
 else
  vPseudoName:= 'ColNoName';

 vColName:= vPseudoName;


 repeat
  vExistDuplicateName:= false;

  for I := 0 to Pred(FPrismGridColumns.Items.Count) do
  begin
   if FPrismGridColumns.Items.Items[I].ColumnIndex <> ColumnIndex then
   begin
    vColName:= vPseudoName;

    if vIndex > 0 then
     vColName:= vPseudoName + IntToStr(vIndex);

    if SameText(FPrismGridColumns.Items.Items[I].ColName, vColName) then
    begin
     vExistDuplicateName:= true;
     inc(vIndex);
     break;
    end;

   end;
  end;
 until not vExistDuplicateName;

 FColName:= vColName;
end;

procedure TPrismGridColumn.SetAlignment(AAlignment: TPrismAlignment);
begin
 FAlignment:= AAlignment;
end;

procedure TPrismGridColumn.SetColumnIndex(Value: Integer);
var
 I: integer;
 vLastColumnIndex: Integer;
 vColIndex: integer;
 vThisColumnIndex: Integer;
 vArrayCols: Array of Integer;
begin
 vThisColumnIndex:= FColumnIndex;
 SetLength(vArrayCols, FPrismGridColumns.FColumns.Count);
 for I := 0 to Pred(FPrismGridColumns.FColumns.Count) do
  vArrayCols[I]:= FPrismGridColumns.FColumns[I].ColumnIndex;

 if Value > Pred(FPrismGridColumns.FColumns.Count) then
  Value:= Pred(FPrismGridColumns.FColumns.Count);

 if FColumnIndex > Value then
 begin
  vLastColumnIndex:= Value;
  vColIndex:= Value;

  repeat
   for I := 0 to Pred(FPrismGridColumns.FColumns.Count) do
   begin
    if vArrayCols[I] <> vThisColumnIndex then
    if vArrayCols[I] >= Value then
    begin
     if vLastColumnIndex = vArrayCols[I] then
     begin
      (FPrismGridColumns.FColumns[I] as TPrismGridColumn).FColumnIndex:= vLastColumnIndex + 1;
      vLastColumnIndex:= vLastColumnIndex + 1;
      break;
     end;
    end;
   end;

   vColIndex:= vColIndex + 1;
  until vColIndex > FPrismGridColumns.FColumns.Count;
 end;


 if FColumnIndex < Value then
 begin
  vLastColumnIndex:= Value;
  vColIndex:= Value;

  repeat
   for I := 0 to Pred(FPrismGridColumns.FColumns.Count) do
   begin
    if vArrayCols[I] <> vThisColumnIndex then
    if vArrayCols[I] <= Value then
    begin
     if vLastColumnIndex = vArrayCols[I] then
     begin
      (FPrismGridColumns.FColumns[I] as TPrismGridColumn).FColumnIndex:= vLastColumnIndex - 1;
      vLastColumnIndex:= vLastColumnIndex - 1;
      break;
     end;
    end;
   end;

   vColIndex:= vColIndex + 1;
  until vColIndex > FPrismGridColumns.FColumns.Count;
 end;

 FColumnIndex:= Value;

 SetLength(vArrayCols, 0);
end;

procedure TPrismGridColumn.SetCSS(const Value: String);
begin
 FCSS:= Value;
end;

procedure TPrismGridColumn.SetDataField(AFieldName: String);
begin
 FDataField:= AFieldName;

 RefreshColName;
end;

procedure TPrismGridColumn.SetDataFieldModel(const Value: TPrismFieldModel);
begin
 FDataFieldModel:= Value;

 RefreshColName;
end;

procedure TPrismGridColumn.SetDataFieldType(const Value: TPrismFieldType);
begin
 FDataFieldType:= Value;
end;

procedure TPrismGridColumn.SetEditable(const Value: Boolean);
begin
 FEditable:= Value;
end;

procedure TPrismGridColumn.SetHTML(const Value: String);
begin
 FHTML:= Value;
 DataFieldModel:= PrismFieldModelHTML;
end;

procedure TPrismGridColumn.SetSelectItems(AItems: TJSONObject);
begin
 FSelectItems:= AItems;
end;

procedure TPrismGridColumn.SetTitle(ATitle: String);
begin
 FTitle:= ATitle;
end;

procedure TPrismGridColumn.SetVisible(AVisible: Boolean);
begin
 FVisible:= AVisible;
end;

procedure TPrismGridColumn.SetWidth(AWidth: Integer);
begin
 FWidth:= AWidth;
end;

{ TPrismGridColumns }

function TPrismGridColumns.Add: IPrismGridColumn;
begin
 Result:= TPrismGridColumn.Create(Self);
 FColumns.Add(Result);
end;

procedure TPrismGridColumns.Add(AColumn: IPrismGridColumn);
begin
 FColumns.Add(AColumn);
end;

procedure TPrismGridColumns.Clear;
var
 vColumnIntf: IPrismGridColumn;
 vColumn: TPrismGridColumn;
begin
 while FColumns.Count > 0 do
 begin
  vColumnIntf:= FColumns.Last;
  FColumns.Delete(Pred(FColumns.Count));

  vColumn:= vColumnIntf as TPrismGridColumn;
  vColumnIntf:= nil;
  vColumn.Free;
 end;
end;

function TPrismGridColumns.ColumnByDataField(
  ADataField: string): IPrismGridColumn;
var
 I: integer;
begin
 System.Initialize(Result);

 for I := 0 to Items.Count-1 do
  if SameText(Items[I].DataField, ADataField) then
   if Items[I].DataField <> '' then
   begin
    Result:= Items[I];
    Break;
   end;
end;

function TPrismGridColumns.ColumnByIndex(AColumnIndex: Integer): IPrismGridColumn;
var
 I: integer;
begin
 System.Initialize(Result);

 for I := 0 to Items.Count-1 do
  if (Items[I].ColumnIndex = AColumnIndex) then
  begin
   Result:= Items[I];
   Break;
  end;
end;

function TPrismGridColumns.ColumnByTitle(ATitle: string): IPrismGridColumn;
var
 I: integer;
begin
 System.Initialize(Result);

 for I := 0 to Items.Count-1 do
  if SameText(Items[I].Title, ATitle) then
  begin
   Result:= Items[I];
   break;
  end;
end;

constructor TPrismGridColumns.Create(APrismGrid: IPrismGrid);
begin
 FColumns:= TList<IPrismGridColumn>.Create;
 FPrismGrid:= APrismGrid;
end;

destructor TPrismGridColumns.Destroy;
begin
 Clear;
 FreeAndNil(FColumns);

 inherited;
end;

function TPrismGridColumns.GetColumns: TList<IPrismGridColumn>;
begin
 Result:= FColumns;
end;

function TPrismGridColumns.GetColumnsNameToJSON: TJSONArray;
var
 I: Integer;
 vColumnIndex: Integer;
begin
 Result:= TJSONArray.Create;

 vColumnIndex:= 0;

 repeat
  for I := 0 to Items.Count-1 do
   if Items[I].ColumnIndex = vColumnIndex then
    if Items[I].DataField <> '' then
    begin
     Result.Add(Items[I].DataField);
     break;
    end;

  Inc(vColumnIndex);
 until vColumnIndex > Items.Count;
end;


function TPrismGridColumns.PrismGrid: IPrismGrid;
begin
 Result:= FPrismGrid;
end;

end.