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
  Thank for contribution to this Unit to:
    Natanael Ribeiro
    natan_ribeiro_ferreira@hotmail.com
 +--------------------------------------------------------------------------+
}

{$I ..\D2Bridge.inc}

unit D2Bridge.VCLObj.TcxGridDBTableView;

interface

{$IFDEF DEVEXPRESS_AVAILABLE}
uses
  Classes,
  cxGridDBTableView,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTcxGridDBTableView = class(TD2BridgeItemVCLObjCore)
   private
     function DBGridColumnByPrismColumnIndex(aCol: integer): TcxGridDBColumn;
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
  D2Bridge.Types, D2Bridge.Util, cxGrid, cxDropDownEdit,
  Prism.Grid, Prism.Util, Prism.Types;

{ TVCLObjTcxGridDBTableView }


function TVCLObjTcxGridDBTableView.CSSClass: String;
begin
 result:= 'table table-hover table-sm table-bordered ui-jqgrid-htable cursor-pointer';
end;

function TVCLObjTcxGridDBTableView.DBGridColumnByPrismColumnIndex(aCol: integer): TcxGridDBColumn;
var
 I, X: Integer;
 vPrismColumns: ID2BridgeFrameworkItemGridColumns;
begin
 vPrismColumns:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.Columns;

 if vPrismColumns.Items.Count >= aCol then
  for I := 0 to Pred(vPrismColumns.Items.Count) do
   if vPrismColumns.Items[I].DataField <> '' then
    for X := 0 to Pred(TcxGridDBTableView(FD2BridgeItemVCLObj.Item).ColumnCount) do
     if SameText(vPrismColumns.Items[I].DataField, TcxGridDBTableView(FD2BridgeItemVCLObj.Item).Columns[X].DataBinding.FieldName) then
     begin
      result:= TcxGridDBTableView(FD2BridgeItemVCLObj.Item).Columns[X];
      break;
     end;
end;

function TVCLObjTcxGridDBTableView.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid;
end;

procedure TVCLObjTcxGridDBTableView.ProcessEventClass;
begin
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.OnSelect :=
   procedure(EventParams: TStrings)
   begin

   end;


 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.OnCheck :=
  procedure(EventParams: TStrings) //Incompleto
  begin
//   if not TcxGridDBTableView(FD2BridgeItemVCLObj.Item).SelectedRows.CurrentRowSelected then
//   begin
//    TcxGridDBTableView(FD2BridgeItemVCLObj.Item).SelectedRows.CurrentRowSelected:= true;
//
//    if Assigned(TcxGridDBTableView(FD2BridgeItemVCLObj.Item).OnCellClick) then
//     TcxGridDBTableView(FD2BridgeItemVCLObj.Item).OnCellClick(nil)
//    else
//     if Assigned(TcxGridDBTableView(FD2BridgeItemVCLObj.Item).OnColEnter) then
//      TcxGridDBTableView(FD2BridgeItemVCLObj.Item).OnColEnter(TcxGridDBTableView(FD2BridgeItemVCLObj.Item))
//     else
//      if Assigned(TcxGridDBTableView(FD2BridgeItemVCLObj.Item).OnEnter) then
//       TcxGridDBTableView(FD2BridgeItemVCLObj.Item).OnColEnter(TcxGridDBTableView(FD2BridgeItemVCLObj.Item));
//
//    if not TcxGridDBTableView(FD2BridgeItemVCLObj.Item).SelectedRows.CurrentRowSelected then
//     (FD2BridgeItemVCLObj.PrismControl as TPrismGrid).SelectedRowsID.Remove(TcxGridDBTableView(FD2BridgeItemVCLObj.Item).DataSource.DataSet.RecNo);
//   end;
  end;


 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.OnUnCheck :=
  procedure(EventParams: TStrings) //Incompleto
  begin
//   if TcxGridDBTableView(FD2BridgeItemVCLObj.Item).SelectedRows.CurrentRowSelected then
//   begin
//    TcxGridDBTableView(FD2BridgeItemVCLObj.Item).SelectedRows.CurrentRowSelected:= false;
//
//    if Assigned(TcxGridDBTableView(FD2BridgeItemVCLObj.Item).OnCellClick) then
//     TcxGridDBTableView(FD2BridgeItemVCLObj.Item).OnCellClick(nil)
//    else
//     if Assigned(TcxGridDBTableView(FD2BridgeItemVCLObj.Item).OnColEnter) then
//      TcxGridDBTableView(FD2BridgeItemVCLObj.Item).OnColEnter(TcxGridDBTableView(FD2BridgeItemVCLObj.Item))
//     else
//      if Assigned(TcxGridDBTableView(FD2BridgeItemVCLObj.Item).OnEnter) then
//       TcxGridDBTableView(FD2BridgeItemVCLObj.Item).OnColEnter(TcxGridDBTableView(FD2BridgeItemVCLObj.Item));
//
//    if TcxGridDBTableView(FD2BridgeItemVCLObj.Item).SelectedRows.CurrentRowSelected then
//     (FD2BridgeItemVCLObj.PrismControl as TPrismGrid).SelectedRowsID.Add(TcxGridDBTableView(FD2BridgeItemVCLObj.Item).DataSource.DataSet.RecNo);
//   end;
  end;


// FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.OnClick :=
//  procedure(EventParams: TStrings)
//  var
//   Col: Integer;
//  begin
//   if TryStrToInt(EventParams.Values['col'], col) then
//   begin
//    if Assigned(TcxGridDBTableView(FD2BridgeItemVCLObj.Item).OnCellClick) then
//     TcxGridDBTableView(FD2BridgeItemVCLObj.Item).OnCellClick(DBGridColumnByPrismColumnIndex(col));
//    if Assigned(TcxGridDBTableView(FD2BridgeItemVCLObj.Item).OnColEnter) then
//     TcxGridDBTableView(FD2BridgeItemVCLObj.Item).OnColEnter(DBGridColumnByPrismColumnIndex(col));
//   end;
//  end;


 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.OnDblClick :=
  procedure(EventParams: TStrings)
  begin
   if Assigned(TcxGridDBTableView(FD2BridgeItemVCLObj.Item).OnDblClick) then
      TcxGridDBTableView(FD2BridgeItemVCLObj.Item).OnDblClick(FD2BridgeItemVCLObj.Item);
  end;


 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.OnSelectAll :=
   procedure(EventParams: TStrings) //Incompleto
   begin
//    TcxGridDBTableView(FD2BridgeItemVCLObj.Item).DataController.DataSource.DataSet.DisableControls;
//
//    try
//     try
//      TcxGridDBTableView(FD2BridgeItemVCLObj.Item).DataController.DataSource.DataSet.First;
//      repeat
//       if not TcxGridDBTableView(FD2BridgeItemVCLObj.Item).SelectedRows.CurrentRowSelected then
//       begin
//        TcxGridDBTableView(FD2BridgeItemVCLObj.Item).SelectedRows.CurrentRowSelected:= true;
//
//        if Assigned(TcxGridDBTableView(FD2BridgeItemVCLObj.Item).OnCellClick) then
//         TcxGridDBTableView(FD2BridgeItemVCLObj.Item).OnCellClick(nil)
//        else
//         if Assigned(TcxGridDBTableView(FD2BridgeItemVCLObj.Item).OnColEnter) then
//          TcxGridDBTableView(FD2BridgeItemVCLObj.Item).OnColEnter(TcxGridDBTableView(FD2BridgeItemVCLObj.Item))
//         else
//          if Assigned(TcxGridDBTableView(FD2BridgeItemVCLObj.Item).OnEnter) then
//           TcxGridDBTableView(FD2BridgeItemVCLObj.Item).OnColEnter(TcxGridDBTableView(FD2BridgeItemVCLObj.Item));
//       end;
//
//       if TcxGridDBTableView(FD2BridgeItemVCLObj.Item).SelectedRows.CurrentRowSelected then
//        (FD2BridgeItemVCLObj.PrismControl as TPrismGrid).SelectedRowsID.Add(TcxGridDBTableView(FD2BridgeItemVCLObj.Item).DataSource.DataSet.RecNo);
//
//       TcxGridDBTableView(FD2BridgeItemVCLObj.Item).DataController.DataSource.DataSet.Next;
//      until TcxGridDBTableView(FD2BridgeItemVCLObj.Item).DataController.DataSource.DataSet.Eof;
//     except
//
//     end;
//    finally
//     TcxGridDBTableView(FD2BridgeItemVCLObj.Item).DataController.DataSource.DataSet.EnableControls;
//    end;
   end;


 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.OnUnSelectAll :=
   procedure(EventParams: TStrings) //Incompleto
   begin
//    TcxGridDBTableView(FD2BridgeItemVCLObj.Item).SelectedRows.Clear;
   end;
end;

procedure TVCLObjTcxGridDBTableView.ProcessPropertyClass(NewObj: TObject);
var
  I, J, K: Integer;
begin
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.Dataware.DataSource:= TcxGridDBTableView(FD2BridgeItemVCLObj.Item).DataController.DataSource;


 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.GetEnabled:=
    function: Variant
    begin
     Result:= GetEnabledRecursive(TcxGrid(TcxGridDBTableView(FD2BridgeItemVCLObj.Item).Level.GetParentComponent));
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TcxGrid(TcxGridDBTableView(FD2BridgeItemVCLObj.Item).Level.GetParentComponent).Enabled:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.GetVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(TcxGrid(TcxGridDBTableView(FD2BridgeItemVCLObj.Item).Level.GetParentComponent));
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.SetVisible:=
    procedure(AValue: Variant)
    begin
     TcxGrid(TcxGridDBTableView(FD2BridgeItemVCLObj.Item).Level.GetParentComponent).Visible:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.GetEditable:=
    function: Variant
    begin
     Result:= TcxGridDBTableView(FD2BridgeItemVCLObj.Item).OptionsData.Editing;
    end;

 //Enable MultiSelect
 if TcxGridDBTableView(FD2BridgeItemVCLObj.Item).OptionsSelection.MultiSelect then
  (FrameworkItemClass as ID2BridgeFrameworkItemDBGrid).MultiSelect:= true
 else
  (FrameworkItemClass as ID2BridgeFrameworkItemDBGrid).MultiSelect:= false;


 with FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.Columns do
 begin
  items.Clear;

  for I := 0 to TcxGridDBTableView(FD2BridgeItemVCLObj.Item).ColumnCount -1 do
  with Add do
  begin
   DataField:= TcxGridDBTableView(FD2BridgeItemVCLObj.Item).Columns[I].DataBinding.FieldName;
   if DataField <> '' then
   if Assigned(TcxGridDBTableView(FD2BridgeItemVCLObj.Item).Columns[I].DataBinding.Field) then
   DataFieldType:= PrismFieldType(TcxGridDBTableView(FD2BridgeItemVCLObj.Item).Columns[I].DataBinding.Field.DataType)
   else
   DataFieldType:= PrismFieldTypeAuto;
   Title:= TcxGridDBTableView(FD2BridgeItemVCLObj.Item).Columns[I].Caption;
   Visible:= TcxGridDBTableView(FD2BridgeItemVCLObj.Item).Columns[I].Visible;
   Width:= WidthPPI(TcxGridDBTableView(FD2BridgeItemVCLObj.Item).Columns[I].Width);
   if TcxGridDBTableView(FD2BridgeItemVCLObj.Item).Columns[I].Options.Editing then
   Editable:= true;
   if TcxGridDBTableView(FD2BridgeItemVCLObj.Item).Columns[I].Properties <> nil then
   begin
     case TcxGridDBTableView(FD2BridgeItemVCLObj.Item).Columns[I].Properties.Alignment.Horz of
      taLeftJustify : Alignment:= D2BridgeAlignColumnsLeft;
      taRightJustify : Alignment:= D2BridgeAlignColumnsRight;
      taCenter : Alignment:= D2BridgeAlignColumnsCenter;
     end;
   end else
     Alignment:= D2BridgeAlignColumnsLeft;
   //Load combobox Itens
   if TcxGridDBTableView(FD2BridgeItemVCLObj.Item).Columns[I].Properties is TcxComboBoxProperties then
     for J := 0 to Pred(TcxComboBoxProperties(TcxGridDBTableView(FD2BridgeItemVCLObj.Item).Columns[I].Properties).Items.Count) do
     begin
      if J = 0 then
       SelectItems.AddPair('0', '--Selecione--');

      SelectItems.AddPair(IntToStr(J+1), TcxComboBoxProperties(TcxGridDBTableView(FD2BridgeItemVCLObj.Item).Columns[I].Properties).Items[J]);
     end;
  end;
 end;
end;

function TVCLObjTcxGridDBTableView.VCLClass: TClass;
begin
 Result:= TcxGridDBTableView;
end;

procedure TVCLObjTcxGridDBTableView.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin

end;
{$ELSE}
implementation
{$ENDIF}

end.