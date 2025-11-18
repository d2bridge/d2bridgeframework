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
    Alisson Suart
    Email: contato@deuxsoftware.com.br
 +--------------------------------------------------------------------------+
}


{$I ..\D2Bridge.inc}

unit D2Bridge.VCLObj.TwwDBGrid;

interface

{$IFDEF INFOPOWER_AVAILABLE}

uses
  Classes, Graphics,
  DBGrids, Grids, vcl.wwdbigrd, vcl.wwdbgrid,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;

type
  TVCLObjTwwDBGrid = class(TD2BridgeItemVCLObjCore)
  private
    function DBGridColumnByPrismColumnIndex(aCol: integer): TwwColumn;
    procedure TwwDBGridOnSelect(EventParams: TStrings);
    procedure TwwDBGridOnCheck(EventParams: TStrings);
//    procedure TwwDBGridOnClick(EventParams: TStrings);
    procedure TwwDBGridOnUnCheck(EventParams: TStrings);
    procedure TwwDBGridOnDblClick(EventParams: TStrings);
    procedure TwwDBGridOnSelectAll(EventParams: TStrings);
    procedure TwwDBGridOnUnSelectAll(EventParams: TStrings);
    function TwwDBGridGetEnabled: Variant;
    procedure TwwDBGridSetEnabled(AValue: Variant);
    function TwwDBGridGetVisible: Variant;
    procedure TwwDBGridSetVisible(AValue: Variant);
    function TwwDBGridGetEditable: Variant;
  public
   function VCLClass: TClass; override;
   function CSSClass: String; override;
   Procedure VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle); override;
   procedure ProcessPropertyClass(NewObj: TObject); override;
   procedure ProcessEventClass; override;
   function FrameworkItemClass: ID2BridgeFrameworkItem; override;
   function GetFieldName(APos: integer): String;
   function GetTextFieldName(APos: Integer): String;
   function GetWidthFieldGrid(APos: Integer): Integer;
 end;

implementation

uses
  SysUtils, DB,
  D2Bridge.Types, D2Bridge.Util,
  Prism.Grid, Prism.Util, Prism.Types, D2Bridge.Item.VCLObj.Style;

{ TVCLObjTwwDBGrid }


function TVCLObjTwwDBGrid.CSSClass: String;
begin
 result:= 'table table-hover table-sm table-bordered ui-jqgrid-htable d2bridgedbgrid cursor-pointer';
end;

function TVCLObjTwwDBGrid.DBGridColumnByPrismColumnIndex(aCol: integer): TwwColumn;
var
 I, X: Integer;
 vPrismColumns: ID2BridgeFrameworkItemGridColumns;
begin
 vPrismColumns:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.Columns;

 if vPrismColumns.Items.Count >= aCol then
  for I := 0 to Pred(vPrismColumns.Items.Count) do
   if vPrismColumns.Items[I].DataField <> '' then
    for X := 0 to Pred(TwwDBGrid(FD2BridgeItemVCLObj.Item).Selected.Count) do
    begin
     if SameText(vPrismColumns.Items[I].DataField, GetFieldName(X) ) then
     begin
      result:= TwwDBGrid(FD2BridgeItemVCLObj.Item).ColumnByName(GetFieldName(X));
      break;
     end;
    end;
end;

function TVCLObjTwwDBGrid.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid;
end;

function TVCLObjTwwDBGrid.GetFieldName(APos: integer): String;
var i : integer;
    vSelectedField: String;
begin
   {Os campos da grid estão concatenados como = FieldName Width Title}
   vSelectedField := TwwDBGrid(FD2BridgeItemVCLObj.Item).Selected.KeyNames[APos];
   vSelectedField := Copy(vSelectedField,1,Pos(#9,vSelectedField)-1);
   Result         := vSelectedField;
end;

function TVCLObjTwwDBGrid.GetTextFieldName(APos: Integer): String;
var i : integer;
    vTextField: String;
begin
   {Os campos da grid estão concatenados como = FieldName Width Title}
   vTextField := TwwDBGrid(FD2BridgeItemVCLObj.Item).Selected.KeyNames[APos];
   delete(vTextField,1,Pos(#9,vTextField)); // delete fieldname
   delete(vTextField,1,Pos(#9,vTextField)); // delete width
   vTextField := Copy(vTextField,1,Pos(#9,vTextField)-1);
   Result         := vTextField;
end;

function TVCLObjTwwDBGrid.GetWidthFieldGrid(APos: Integer): Integer;
var i : integer;
    vWidthField: String;
begin
   {Os campos da grid estão concatenados como = FieldName Width Title}
   vWidthField := TwwDBGrid(FD2BridgeItemVCLObj.Item).Selected.KeyNames[APos];
   delete(vWidthField,1,Pos(#9,vWidthField)); // delete fieldname
   vWidthField := Copy(vWidthField,1,Pos(#9,vWidthField)-1);
   Result         := StrToIntDef(vWidthField,20);
end;

procedure TVCLObjTwwDBGrid.ProcessEventClass;
begin
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.OnSelect := TwwDBGridOnSelect;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.OnCheck := TwwDBGridOnCheck;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.OnUnCheck := TwwDBGridOnUnCheck;

// FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.OnClick := TwwDBGridOnClick;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.OnDblClick := TwwDBGridOnDblClick;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.OnSelectAll := TwwDBGridOnSelectAll;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.OnUnSelectAll := TwwDBGridOnUnSelectAll;

end;

procedure TVCLObjTwwDBGrid.ProcessPropertyClass(NewObj: TObject);
var
  I, J, K: Integer;
begin
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.Dataware.DataSource:= TwwDBGrid(FD2BridgeItemVCLObj.Item).DataSource;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.GetEnabled:= TwwDBGridGetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.SetEnabled:= TwwDBGridSetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.GetVisible:= TwwDBGridGetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.SetVisible:= TwwDBGridSetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.GetEditable:= TwwDBGridGetEditable;

 //Enable MultiSelect
 if (dgMultiSelect in TwwDBGrid(FD2BridgeItemVCLObj.Item).Options) then
  (FrameworkItemClass as ID2BridgeFrameworkItemDBGrid).MultiSelect:= true
 else
  (FrameworkItemClass as ID2BridgeFrameworkItemDBGrid).MultiSelect:= false;

 with FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.Columns do
 begin
  items.Clear;

  for I := 0 to TwwDBGrid(FD2BridgeItemVCLObj.Item).Selected.Count -1 do
  with Add do
  begin
   DataField:= GetFieldName(I);
   if DataField <> '' then
      if Assigned(TwwDBGrid(FD2BridgeItemVCLObj.Item).DataSource.DataSet.FieldList.Fields[I]) then
         DataFieldType:= PrismFieldType(TwwDBGrid(FD2BridgeItemVCLObj.Item).DataSource.DataSet.FieldList.Fields[I].DataType)
      else
         DataFieldType:= PrismFieldTypeAuto;
   Title:= GetTextFieldName(I);
   Visible:= TwwDBGrid(FD2BridgeItemVCLObj.Item).DataSource.DataSet.FieldList.Fields[I].Visible;
   Width:= WidthPPI(GetWidthFieldGrid(I));
   if not TwwDBGrid(FD2BridgeItemVCLObj.Item).DataSource.DataSet.FieldList.Fields[I].ReadOnly then
      Editable:= true;

   Alignment:= D2BridgeAlignColumnsLeft;

   //Load combobox Itens
//   for J := 0 to Pred(TwwDBGrid(FD2BridgeItemVCLObj.Item).Columns[I]. PickList.Count) do
//   begin
//    if J = 0 then
//     SelectItems.AddPair('0', '--Selecione--');
//
//    SelectItems.AddPair(IntToStr(J+1), TDBGrid(FD2BridgeItemVCLObj.Item).Columns[I].PickList[J]);
//   end;
  end;
 end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.TitleFontSize   := TwwDBGrid(FD2BridgeItemVCLObj.Item).TitleFont.Size;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.TitleFontColor  := TwwDBGrid(FD2BridgeItemVCLObj.Item).TitleFont.Color;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.TitleFontStyles := TwwDBGrid(FD2BridgeItemVCLObj.Item).TitleFont.Style;
end;

function TVCLObjTwwDBGrid.TwwDBGridGetEditable: Variant;
begin
 Result:= (dgEditing in TwwDBGrid(FD2BridgeItemVCLObj.Item).Options);
end;

function TVCLObjTwwDBGrid.TwwDBGridGetEnabled: Variant;
begin
 Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
end;

function TVCLObjTwwDBGrid.TwwDBGridGetVisible: Variant;
begin
 Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTwwDBGrid.TwwDBGridOnCheck(EventParams: TStrings);
begin
   if not TwwDBGrid(FD2BridgeItemVCLObj.Item).SelectedList.CurrentRowSelected then
   begin
    TwwDBGrid(FD2BridgeItemVCLObj.Item).SelectedList.CurrentRowSelected:= true;

    if Assigned(TwwDBGrid(FD2BridgeItemVCLObj.Item).OnCellChanged) then
     TwwDBGrid(FD2BridgeItemVCLObj.Item).OnCellChanged(nil)
    else
     if Assigned(TwwDBGrid(FD2BridgeItemVCLObj.Item).OnColEnter) then
      TwwDBGrid(FD2BridgeItemVCLObj.Item).OnColEnter(TwwDBGrid(FD2BridgeItemVCLObj.Item))
     else
      if Assigned(TwwDBGrid(FD2BridgeItemVCLObj.Item).OnEnter) then
       TwwDBGrid(FD2BridgeItemVCLObj.Item).OnColEnter(TwwDBGrid(FD2BridgeItemVCLObj.Item));

    if not TwwDBGrid(FD2BridgeItemVCLObj.Item).SelectedList.CurrentRowSelected then
     (FD2BridgeItemVCLObj.PrismControl as TPrismGrid).SelectedRowsID.Remove(TwwDBGrid(FD2BridgeItemVCLObj.Item).DataSource.DataSet.RecNo);
   end;
end;

procedure TVCLObjTwwDBGrid.TwwDBGridOnDblClick(EventParams: TStrings);
begin
 if Assigned(TwwDBGrid(FD2BridgeItemVCLObj.Item).OnDblClick) then
    TwwDBGrid(FD2BridgeItemVCLObj.Item).OnDblClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTwwDBGrid.TwwDBGridOnSelect(EventParams: TStrings);
begin
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBGrid.OnClick :=
  procedure(EventParams: TStrings)
  var
   Col: Integer;
  begin
   if TryStrToInt(EventParams.Values['col'], col) then
   begin
    if Assigned(TwwDBGrid(FD2BridgeItemVCLObj.Item).OnCellChanged) then
     TwwDBGrid(FD2BridgeItemVCLObj.Item).OnCellChanged(DBGridColumnByPrismColumnIndex(col));
    if Assigned(TwwDBGrid(FD2BridgeItemVCLObj.Item).OnColEnter) then
     TwwDBGrid(FD2BridgeItemVCLObj.Item).OnColEnter(DBGridColumnByPrismColumnIndex(col));
   end;
  end;

end;

procedure TVCLObjTwwDBGrid.TwwDBGridOnSelectAll(EventParams: TStrings);
begin
  TwwDBGrid(FD2BridgeItemVCLObj.Item).DataSource.DataSet.DisableControls;

  try
   try
    TwwDBGrid(FD2BridgeItemVCLObj.Item).DataSource.DataSet.First;
    repeat
     if not TwwDBGrid(FD2BridgeItemVCLObj.Item).SelectedList.CurrentRowSelected then
     begin
      TwwDBGrid(FD2BridgeItemVCLObj.Item).SelectedList.CurrentRowSelected:= true;

      if Assigned(TwwDBGrid(FD2BridgeItemVCLObj.Item).OnCellChanged) then
       TwwDBGrid(FD2BridgeItemVCLObj.Item).OnCellChanged(nil)
      else
       if Assigned(TwwDBGrid(FD2BridgeItemVCLObj.Item).OnColEnter) then
        TwwDBGrid(FD2BridgeItemVCLObj.Item).OnColEnter(TwwDBGrid(FD2BridgeItemVCLObj.Item))
       else
        if Assigned(TwwDBGrid(FD2BridgeItemVCLObj.Item).OnEnter) then
         TwwDBGrid(FD2BridgeItemVCLObj.Item).OnColEnter(TwwDBGrid(FD2BridgeItemVCLObj.Item));
     end;

     if TwwDBGrid(FD2BridgeItemVCLObj.Item).SelectedList.CurrentRowSelected then
      (FD2BridgeItemVCLObj.PrismControl as TPrismGrid).SelectedRowsID.Add(TwwDBGrid(FD2BridgeItemVCLObj.Item).DataSource.DataSet.RecNo);

     TwwDBGrid(FD2BridgeItemVCLObj.Item).DataSource.DataSet.Next;
    until TwwDBGrid(FD2BridgeItemVCLObj.Item).DataSource.DataSet.Eof;
   except
   end;
  finally
   TwwDBGrid(FD2BridgeItemVCLObj.Item).DataSource.DataSet.EnableControls;
  end;
end;

procedure TVCLObjTwwDBGrid.TwwDBGridOnUnCheck(EventParams: TStrings);
begin
   if TwwDBGrid(FD2BridgeItemVCLObj.Item).SelectedList.CurrentRowSelected then
   begin
    TwwDBGrid(FD2BridgeItemVCLObj.Item).SelectedList.CurrentRowSelected:= false;

    if Assigned(TwwDBGrid(FD2BridgeItemVCLObj.Item).OnCellChanged) then
     TwwDBGrid(FD2BridgeItemVCLObj.Item).OnCellChanged(nil)
    else
     if Assigned(TwwDBGrid(FD2BridgeItemVCLObj.Item).OnColEnter) then
      TwwDBGrid(FD2BridgeItemVCLObj.Item).OnColEnter(TwwDBGrid(FD2BridgeItemVCLObj.Item))
     else
      if Assigned(TwwDBGrid(FD2BridgeItemVCLObj.Item).OnEnter) then
       TwwDBGrid(FD2BridgeItemVCLObj.Item).OnColEnter(TwwDBGrid(FD2BridgeItemVCLObj.Item));

    if TwwDBGrid(FD2BridgeItemVCLObj.Item).SelectedList.CurrentRowSelected then
     (FD2BridgeItemVCLObj.PrismControl as TPrismGrid).SelectedRowsID.Add(TwwDBGrid(FD2BridgeItemVCLObj.Item).DataSource.DataSet.RecNo);
   end;
end;

procedure TVCLObjTwwDBGrid.TwwDBGridOnUnSelectAll(EventParams: TStrings);
begin
 TwwDBGrid(FD2BridgeItemVCLObj.Item).SelectedList.Clear;
end;

procedure TVCLObjTwwDBGrid.TwwDBGridSetEnabled(AValue: Variant);
begin
 TwwDBGrid(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
end;

procedure TVCLObjTwwDBGrid.TwwDBGridSetVisible(AValue: Variant);
begin
 TwwDBGrid(FD2BridgeItemVCLObj.Item).Visible:= AValue;
end;

function TVCLObjTwwDBGrid.VCLClass: TClass;
begin
 Result:= TwwDBGrid;
end;

procedure TVCLObjTwwDBGrid.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TwwDBGrid(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize := TwwDBGrid(FD2BridgeItemVCLObj.Item).Font.Size;

 if TwwDBGrid(FD2BridgeItemVCLObj.Item).Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor := TwwDBGrid(FD2BridgeItemVCLObj.Item).Font.Color;

 if not IsColor(TDBGrid(FD2BridgeItemVCLObj.Item).Color, [clWindow, clDefault]) then
  VCLObjStyle.Color := TwwDBGrid(FD2BridgeItemVCLObj.Item).Color;

 VCLObjStyle.FontStyles := TwwDBGrid(FD2BridgeItemVCLObj.Item).Font.Style;
end;
{$ELSE}
implementation
{$ENDIF}

end.
