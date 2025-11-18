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

unit D2Bridge.VCLObj.TJvDBUltimGrid;

interface

{$IFDEF JVCL_AVAILABLE}

uses
  Classes,
  dbgrids, JvDBGrid, JvDBUltimGrid,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
  TVCLObjTJvDBUltimGrid = class(TD2BridgeItemVCLObjCore)
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

{ TVCLObjTJvDBUltimGrid }


function TVCLObjTJvDBUltimGrid.CSSClass: String;
begin
 result:= 'table table-hover table-sm table-bordered ui-jqgrid-htable d2bridgedbgrid cursor-pointer';
end;

function TVCLObjTJvDBUltimGrid.DBGridColumnByPrismColumnIndex(aCol: integer): TColumn;
var
 I, X: Integer;
 vPrismColumns: ID2BridgeFrameworkItemGridColumns;
begin
 vPrismColumns:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.Columns;

 if vPrismColumns.Items.Count >= aCol then
  for I := 0 to Pred(vPrismColumns.Items.Count) do
   if vPrismColumns.Items[I].DataField <> '' then
    for X := 0 to Pred(TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).Columns.Count) do
     if SameText(vPrismColumns.Items[I].DataField, TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).Columns[X].FieldName) then
     begin
      result:= TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).Columns[X];
      break;
     end;
end;

function TVCLObjTJvDBUltimGrid.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid;
end;

procedure TVCLObjTJvDBUltimGrid.ProcessEventClass;
begin
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.OnSelect :=
   procedure(EventParams: TStrings)
   begin

   end;


 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.OnCheck :=
  procedure(EventParams: TStrings)
  begin
   if not TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).SelectedRows.CurrentRowSelected then
   begin
    TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).SelectedRows.CurrentRowSelected:= true;

    if Assigned(TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).OnCellClick) then
     TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).OnCellClick(nil)
    else
     if Assigned(TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).OnColEnter) then
      TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).OnColEnter(TJvDBUltimGrid(FD2BridgeItemVCLObj.Item))
     else
      if Assigned(TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).OnEnter) then
       TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).OnColEnter(TJvDBUltimGrid(FD2BridgeItemVCLObj.Item));

    if not TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).SelectedRows.CurrentRowSelected then
     (FD2BridgeItemVCLObj.PrismControl as TPrismGrid).SelectedRowsID.Remove(TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).DataSource.DataSet.RecNo);
   end;
  end;


 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.OnUnCheck :=
  procedure(EventParams: TStrings)
  begin
   if TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).SelectedRows.CurrentRowSelected then
   begin
    TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).SelectedRows.CurrentRowSelected:= false;

    if Assigned(TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).OnCellClick) then
     TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).OnCellClick(nil)
    else
     if Assigned(TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).OnColEnter) then
      TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).OnColEnter(TJvDBUltimGrid(FD2BridgeItemVCLObj.Item))
     else
      if Assigned(TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).OnEnter) then
       TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).OnColEnter(TJvDBUltimGrid(FD2BridgeItemVCLObj.Item));

    if TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).SelectedRows.CurrentRowSelected then
     (FD2BridgeItemVCLObj.PrismControl as TPrismGrid).SelectedRowsID.Add(TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).DataSource.DataSet.RecNo);
   end;
  end;


// FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.OnClick :=
//  procedure(EventParams: TStrings)
//  var
//   Col: Integer;
//  begin
//   if TryStrToInt(EventParams.Values['col'], col) then
//   begin
//    if Assigned(TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).OnCellClick) then
//     TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).OnCellClick(DBGridColumnByPrismColumnIndex(col));
//    if Assigned(TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).OnColEnter) then
//     TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).OnColEnter(DBGridColumnByPrismColumnIndex(col));
//   end;
//  end;


 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.OnDblClick :=
  procedure(EventParams: TStrings)
  begin
   if Assigned(TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).OnDblClick) then
      TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).OnDblClick(FD2BridgeItemVCLObj.Item);
  end;


 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.OnSelectAll :=
   procedure(EventParams: TStrings)
   begin
    TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).DataSource.DataSet.DisableControls;

    try
     try
      TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).DataSource.DataSet.First;
      repeat
       if not TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).SelectedRows.CurrentRowSelected then
       begin
        TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).SelectedRows.CurrentRowSelected:= true;

        if Assigned(TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).OnCellClick) then
         TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).OnCellClick(nil)
        else
         if Assigned(TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).OnColEnter) then
          TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).OnColEnter(TJvDBUltimGrid(FD2BridgeItemVCLObj.Item))
         else
          if Assigned(TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).OnEnter) then
           TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).OnColEnter(TJvDBUltimGrid(FD2BridgeItemVCLObj.Item));
       end;

       if TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).SelectedRows.CurrentRowSelected then
        (FD2BridgeItemVCLObj.PrismControl as TPrismGrid).SelectedRowsID.Add(TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).DataSource.DataSet.RecNo);

       TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).DataSource.DataSet.Next;
      until TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).DataSource.DataSet.Eof;
     except

     end;
    finally
     TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).DataSource.DataSet.EnableControls;
    end;
   end;


 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.OnUnSelectAll :=
   procedure(EventParams: TStrings)
   begin
    TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).SelectedRows.Clear;
   end;
end;

procedure TVCLObjTJvDBUltimGrid.ProcessPropertyClass(NewObj: TObject);
var
  I, J, K: Integer;
begin
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.Dataware.DataSource:= TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).DataSource;


 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.GetEnabled:=
    function: Variant
    begin
     Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.GetVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.SetVisible:=
    procedure(AValue: Variant)
    begin
     TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).Visible:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.GetEditable:=
    function: Variant
    begin
     Result:= (dgEditing in TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).Options);
    end;

 //Enable MultiSelect
 if (dgMultiSelect in TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).Options) then
  (FrameworkItemClass as ID2BridgeFrameworkItemDBGrid).MultiSelect:= true
 else
  (FrameworkItemClass as ID2BridgeFrameworkItemDBGrid).MultiSelect:= false;


 with FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.Columns do
 begin
  items.Clear;

  for I := 0 to TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).Columns.Count -1 do
  with Add do
  begin
   DataField:= TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).Columns[I].FieldName;
   if DataField <> '' then
   if Assigned(TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).Columns[I].Field) then
   DataFieldType:= PrismFieldType(TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).Columns[I].Field.DataType)
   else
   DataFieldType:= PrismFieldTypeAuto;
   Title:= TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).Columns[I].Title.Caption;
   Visible:= TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).Columns[I].Visible;
   Width:= WidthPPI(TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).Columns[I].Width);
   if (not TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).Columns[I].ReadOnly) then
   Editable:= true;
   case TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).Columns[I].Alignment of
    taLeftJustify : Alignment:= D2BridgeAlignColumnsLeft;
    taRightJustify : Alignment:= D2BridgeAlignColumnsRight;
    taCenter : Alignment:= D2BridgeAlignColumnsCenter;
   end;
   //Load combobox Itens
   for J := 0 to Pred(TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).Columns[I].PickList.Count) do
   begin
    if J = 0 then
     SelectItems.AddPair('0', '--Selecione--');

    SelectItems.AddPair(IntToStr(J+1), TJvDBUltimGrid(FD2BridgeItemVCLObj.Item).Columns[I].PickList[J]);
   end;
  end;
 end;
end;

function TVCLObjTJvDBUltimGrid.VCLClass: TClass;
begin
 Result:= TJvDBUltimGrid;
end;
procedure TVCLObjTJvDBUltimGrid.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin

end;

{$ELSE}
implementation
{$ENDIF}

end.

