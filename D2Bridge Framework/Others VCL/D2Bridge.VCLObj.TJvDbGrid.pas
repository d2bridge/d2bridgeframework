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
  Thanks for contribution to this Unit to:
    Daniel Hondo Tedesque
    Email: daniel@uniontech.eti.br
 +--------------------------------------------------------------------------+
}

{$I ..\D2Bridge.inc}

unit D2Bridge.VCLObj.TJvDbGrid;

interface

{$IFDEF JVCL_AVAILABLE}

uses
  Classes,
  dbgrids, JvExDBGrids, JvDBGrid,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;

type
  TVCLObjTJvDbGrid = class(TD2BridgeItemVCLObjCore)
   private
     function DBGridColumnByPrismColumnIndex(aCol: integer): TColumn;
   public
     function VCLClass: TClass; override;
     function CSSClass: String; override;
     Procedure VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle); override;
     procedure ProcessPropertyClass(NewObj: TObject); override;
     procedure ProcessEventClass; override;
     function FrameworkItemClass: ID2BridgeFrameworkItem; override;
   end;

implementation

uses
  SysUtils, DB,
  D2Bridge.Types, D2Bridge.Util,
  Prism.Grid, Prism.Util, Prism.Types;

{ TVCLObjTJvDbGrid }


function TVCLObjTJvDbGrid.CSSClass: String;
begin
 result:= 'table table-hover table-sm table-bordered ui-jqgrid-htable d2bridgedbgrid cursor-pointer';
end;

function TVCLObjTJvDbGrid.DBGridColumnByPrismColumnIndex(aCol: integer): TColumn;
var
 I, X: Integer;
 vPrismColumns: ID2BridgeFrameworkItemGridColumns;
begin
 vPrismColumns:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.Columns;

 if vPrismColumns.Items.Count >= aCol then
  for I := 0 to Pred(vPrismColumns.Items.Count) do
   if vPrismColumns.Items[I].DataField <> '' then
    for X := 0 to Pred(TJvDbGrid(FD2BridgeItemVCLObj.Item).Columns.Count) do
     if SameText(vPrismColumns.Items[I].DataField, TJvDbGrid(FD2BridgeItemVCLObj.Item).Columns[X].FieldName) then
     begin
      result:= TJvDbGrid(FD2BridgeItemVCLObj.Item).Columns[X];
      break;
     end;
end;

function TVCLObjTJvDbGrid.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid;
end;

procedure TVCLObjTJvDbGrid.ProcessEventClass;
begin
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.OnSelect :=
   procedure(EventParams: TStrings)
   begin

   end;


 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.OnCheck :=
  procedure(EventParams: TStrings)
  begin
   if not TJvDbGrid(FD2BridgeItemVCLObj.Item).SelectedRows.CurrentRowSelected then
   begin
    TJvDbGrid(FD2BridgeItemVCLObj.Item).SelectedRows.CurrentRowSelected:= true;

    if Assigned(TJvDbGrid(FD2BridgeItemVCLObj.Item).OnCellClick) then
     TJvDbGrid(FD2BridgeItemVCLObj.Item).OnCellClick(nil)
    else
     if Assigned(TJvDbGrid(FD2BridgeItemVCLObj.Item).OnColEnter) then
      TJvDbGrid(FD2BridgeItemVCLObj.Item).OnColEnter(TJvDbGrid(FD2BridgeItemVCLObj.Item))
     else
      if Assigned(TJvDbGrid(FD2BridgeItemVCLObj.Item).OnEnter) then
       TJvDbGrid(FD2BridgeItemVCLObj.Item).OnColEnter(TJvDbGrid(FD2BridgeItemVCLObj.Item));

    if not TJvDbGrid(FD2BridgeItemVCLObj.Item).SelectedRows.CurrentRowSelected then
     (FD2BridgeItemVCLObj.PrismControl as TPrismGrid).SelectedRowsID.Remove(TJvDbGrid(FD2BridgeItemVCLObj.Item).DataSource.DataSet.RecNo);
   end;
  end;


 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.OnUnCheck :=
  procedure(EventParams: TStrings)
  begin
   if TJvDbGrid(FD2BridgeItemVCLObj.Item).SelectedRows.CurrentRowSelected then
   begin
    TJvDbGrid(FD2BridgeItemVCLObj.Item).SelectedRows.CurrentRowSelected:= false;

    if Assigned(TJvDbGrid(FD2BridgeItemVCLObj.Item).OnCellClick) then
     TJvDbGrid(FD2BridgeItemVCLObj.Item).OnCellClick(nil)
    else
     if Assigned(TJvDbGrid(FD2BridgeItemVCLObj.Item).OnColEnter) then
      TJvDbGrid(FD2BridgeItemVCLObj.Item).OnColEnter(TJvDbGrid(FD2BridgeItemVCLObj.Item))
     else
      if Assigned(TJvDbGrid(FD2BridgeItemVCLObj.Item).OnEnter) then
       TJvDbGrid(FD2BridgeItemVCLObj.Item).OnColEnter(TJvDbGrid(FD2BridgeItemVCLObj.Item));

    if TJvDbGrid(FD2BridgeItemVCLObj.Item).SelectedRows.CurrentRowSelected then
     (FD2BridgeItemVCLObj.PrismControl as TPrismGrid).SelectedRowsID.Add(TJvDbGrid(FD2BridgeItemVCLObj.Item).DataSource.DataSet.RecNo);
   end;
  end;


// FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.OnClick :=
//  procedure(EventParams: TStrings)
//  var
//   Col: Integer;
//  begin
//   if TryStrToInt(EventParams.Values['col'], col) then
//   begin
//    if Assigned(TJvDbGrid(FD2BridgeItemVCLObj.Item).OnCellClick) then
//     TJvDbGrid(FD2BridgeItemVCLObj.Item).OnCellClick(DBGridColumnByPrismColumnIndex(col));
//    if Assigned(TJvDbGrid(FD2BridgeItemVCLObj.Item).OnColEnter) then
//     TJvDbGrid(FD2BridgeItemVCLObj.Item).OnColEnter(DBGridColumnByPrismColumnIndex(col));
//   end;
//  end;


 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.OnDblClick :=
  procedure(EventParams: TStrings)
  begin
   if Assigned(TJvDbGrid(FD2BridgeItemVCLObj.Item).OnDblClick) then
      TJvDbGrid(FD2BridgeItemVCLObj.Item).OnDblClick(FD2BridgeItemVCLObj.Item);
  end;


 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.OnSelectAll :=
   procedure(EventParams: TStrings)
   begin
    TJvDbGrid(FD2BridgeItemVCLObj.Item).DataSource.DataSet.DisableControls;

    try
     try
      TJvDbGrid(FD2BridgeItemVCLObj.Item).DataSource.DataSet.First;
      repeat
       if not TJvDbGrid(FD2BridgeItemVCLObj.Item).SelectedRows.CurrentRowSelected then
       begin
        TJvDbGrid(FD2BridgeItemVCLObj.Item).SelectedRows.CurrentRowSelected:= true;

        if Assigned(TJvDbGrid(FD2BridgeItemVCLObj.Item).OnCellClick) then
         TJvDbGrid(FD2BridgeItemVCLObj.Item).OnCellClick(nil)
        else
         if Assigned(TJvDbGrid(FD2BridgeItemVCLObj.Item).OnColEnter) then
          TJvDbGrid(FD2BridgeItemVCLObj.Item).OnColEnter(TJvDbGrid(FD2BridgeItemVCLObj.Item))
         else
          if Assigned(TJvDbGrid(FD2BridgeItemVCLObj.Item).OnEnter) then
           TJvDbGrid(FD2BridgeItemVCLObj.Item).OnColEnter(TJvDbGrid(FD2BridgeItemVCLObj.Item));
       end;

       if TJvDbGrid(FD2BridgeItemVCLObj.Item).SelectedRows.CurrentRowSelected then
        (FD2BridgeItemVCLObj.PrismControl as TPrismGrid).SelectedRowsID.Add(TJvDbGrid(FD2BridgeItemVCLObj.Item).DataSource.DataSet.RecNo);

       TJvDbGrid(FD2BridgeItemVCLObj.Item).DataSource.DataSet.Next;
      until TJvDbGrid(FD2BridgeItemVCLObj.Item).DataSource.DataSet.Eof;
     except

     end;
    finally
     TJvDbGrid(FD2BridgeItemVCLObj.Item).DataSource.DataSet.EnableControls;
    end;
   end;


 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.OnUnSelectAll :=
   procedure(EventParams: TStrings)
   begin
    TJvDbGrid(FD2BridgeItemVCLObj.Item).SelectedRows.Clear;
   end;
end;

procedure TVCLObjTJvDbGrid.ProcessPropertyClass(NewObj: TObject);
var
  I, J, K: Integer;
begin
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.Dataware.DataSource:= TJvDbGrid(FD2BridgeItemVCLObj.Item).DataSource;


 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.GetEnabled:=
    function: Variant
    begin
     Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TJvDbGrid(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.GetVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.SetVisible:=
    procedure(AValue: Variant)
    begin
     TJvDbGrid(FD2BridgeItemVCLObj.Item).Visible:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.GetEditable:=
    function: Variant
    begin
     Result:= (dgEditing in TJvDbGrid(FD2BridgeItemVCLObj.Item).Options);
    end;

 //Enable MultiSelect
 if (dgMultiSelect in TJvDbGrid(FD2BridgeItemVCLObj.Item).Options) then
  (FrameworkItemClass as ID2BridgeFrameworkItemDBGrid).MultiSelect:= true
 else
  (FrameworkItemClass as ID2BridgeFrameworkItemDBGrid).MultiSelect:= false;


 with FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.Columns do
 begin
  items.Clear;

  for I := 0 to TJvDbGrid(FD2BridgeItemVCLObj.Item).Columns.Count -1 do
  with Add do
  begin
   DataField:= TJvDbGrid(FD2BridgeItemVCLObj.Item).Columns[I].FieldName;
   if DataField <> '' then
   if Assigned(TJvDbGrid(FD2BridgeItemVCLObj.Item).Columns[I].Field) then
   DataFieldType:= PrismFieldType(TJvDbGrid(FD2BridgeItemVCLObj.Item).Columns[I].Field.DataType)
   else
   DataFieldType:= PrismFieldTypeAuto;
   Title:= TJvDbGrid(FD2BridgeItemVCLObj.Item).Columns[I].Title.Caption;
   Visible:= TJvDbGrid(FD2BridgeItemVCLObj.Item).Columns[I].Visible;
   Width:= WidthPPI(TJvDbGrid(FD2BridgeItemVCLObj.Item).Columns[I].Width);
   if (not TJvDbGrid(FD2BridgeItemVCLObj.Item).Columns[I].ReadOnly) then
   Editable:= true;
   case TJvDbGrid(FD2BridgeItemVCLObj.Item).Columns[I].Alignment of
    taLeftJustify : Alignment:= D2BridgeAlignColumnsLeft;
    taRightJustify : Alignment:= D2BridgeAlignColumnsRight;
    taCenter : Alignment:= D2BridgeAlignColumnsCenter;
   end;
   //Load combobox Itens
   for J := 0 to Pred(TJvDbGrid(FD2BridgeItemVCLObj.Item).Columns[I].PickList.Count) do
   begin
    if J = 0 then
     SelectItems.AddPair('0', '--Selecione--');

    SelectItems.AddPair(IntToStr(J+1), TJvDbGrid(FD2BridgeItemVCLObj.Item).Columns[I].PickList[J]);
   end;
  end;
 end;
end;

function TVCLObjTJvDbGrid.VCLClass: TClass;
begin
 Result:= TJvDbGrid;
end;
procedure TVCLObjTJvDbGrid.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin

end;

{$ELSE}
implementation
{$ENDIF}

end.

