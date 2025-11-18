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

unit Prism.DBGrid;

interface

{$IFNDEF FMX}
uses
  Classes, SysUtils, D2Bridge.JSON, Generics.Collections, DB, Rtti,
  Prism.Forms.Controls, Prism.Interfaces, Prism.Types, Prism.Grid.Columns, Prism.Grid.Columns.Buttons,
  Prism.Grid, Prism.DataLink.Core;


type
 TPrismGridColumn = Prism.Grid.Columns.TPrismGridColumn;
 TPrismGridColumns = Prism.Grid.Columns.TPrismGridColumns;
 TPrismGridColumnButton = Prism.Grid.Columns.Buttons.TPrismGridColumnButton;
 TPrismGridColumnButtons = Prism.Grid.Columns.Buttons.TPrismGridColumnButtons;


type
 TPrismDBGrid = class(TPrismGrid, IPrismDBGrid)
  strict private
   type
    TUpdateRowData = record
     Update: boolean;
     RecNo: Integer;
     JSONData: string;
    end;
   procedure Exec_Check(varParameter: TValue);
   procedure Exec_UnCheck(varParameter: TValue);
  private
   FSelectEvent: boolean;
   FProcGetSelectedRow: TOnGetValue;
   FProcSetSelectedRow: TOnSetValue;
   FProcGetEditable: TOnGetValue;
   FStoredRecNo: Integer;
   FStoredEditable: Boolean;
   FOnLoadJSON: TPrismGetStrEvent;
   FSelectedRowsID: TList<Integer>;
   FRefreshData: Boolean;
   FRefreshDataOnLoad: Boolean;
   FRefreshRow: TUpdateRowData;
   FRecNo: Integer;
   FJSONData: string;
   FPrismDataLink: TPrismDataLinkCore;
   const
    FSelectAll: integer = -9999;
   procedure SetDataSource(const Value: TDataSource);
   function GetDataSource: TDataSource;
   function GetSelectedRowsID: TList<Integer>; override;
   procedure SetSelectedRowsID(Value: TList<Integer>); override;
   function GetEditable: Boolean; override;
   procedure UpdateData; override;
   procedure UpdateRow(aRecNo: Integer; aJSONData: string = '');
   procedure ReloadGrid;
   function ColModelToList: TDictionary<string,string>;
   function ColumnsToColModel: string;
   procedure OnCellButtonClick(EventParams: TStrings);
   function SelectedRowsIDStr: string;
   //Dataware Event
   procedure DataWareEvent(const ADataWareEvent: TPrismDataLinkEvent);
  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
  public
   constructor Create(AOwner: TObject); override;
   destructor Destroy; override;

   function RecNo: integer; overload; override;
   function RecNo(AValue: Integer): boolean; overload; override;

   function IsDBGrid: Boolean; override;

   procedure SetDataToJSON; override;
   function GetDataToJSON: String; override;
   procedure CellPostbyJSON(AJSON: string; out ARowID: string; out AErrorMessage: string); override;

   property DataSource: TDataSource read GetDataSource write SetDataSource;
   property ProcSetSelectedRow: TOnSetValue read FProcSetSelectedRow write FProcSetSelectedRow;
   property ProcGetSelectedRow: TOnGetValue read FProcGetSelectedRow write FProcGetSelectedRow;
   property ProcGetEditable: TOnGetValue read FProcGetEditable write FProcGetEditable;
 end;



implementation

uses
  Prism.Events, Prism.JSONHelper, Prism.Util;

{ TPrismDBGrid }

procedure TPrismDBGrid.CellPostbyJSON(AJSON: string; out ARowID: string; out AErrorMessage: string);
var
 vJSONCellValues: TJSONObject;
 I, J: Integer;
 vRecNO: integer;
 vAlter: Boolean;
 vOperation: String;
 vFieldName, vFieldValue: String;
 vSelectFieldValue: integer;
 vFieldType: TPrismFieldType;
 vRollbackField: TDictionary<string,Variant>;
 vErrorRollback: Boolean;
 vColumn: TPrismGridColumn;
 vDateTime: TDateTime;
 vFixedDateTimeStr: string;
begin
 vJSONCellValues:= TJSONObject.ParseJSONValue(AJSON) as TJSONObject;
 vRollbackField:= TDictionary<string,Variant>.Create;
 vErrorRollback:= false;
 vColumn:= nil;

 vOperation:= vJSONCellValues.GetValue('oper','');

 vAlter:= false;

 if SameText(vOperation, 'edit') then
 begin
  //Processa o RecNO
  if TryStrToInt(vJSONCellValues.GetValue('rowindex',''), vRecNO) then
  begin
   ARowID:= vJSONCellValues.GetValue('id','');
   RecNo(vRecNO);
  end else
  Exit;


  if vRecNO >= 0 then
  for I := 0 to Pred(vJSONCellValues.Count)-3 do //Exclude oper and id
  begin
//   if FPrismDataLink.DataSet.RecNo <> vRecNO then
//    SetRecNo(vRecNO);

   try
    vFieldName:= vJSONCellValues.GetJsonStringValue(I);

    {$REGION 'Find Column'}
     for J := 0 to Pred(Columns.Items.Count) do
     begin
      if SameText(Columns.Items[J].DataField, vFieldName) then
      begin
       vColumn:= Columns.Items[J] as TPrismGridColumn;
       Break;
      end;
     end;
    {$ENDREGION}

    vFieldValue:= vJSONCellValues.GetJsonValue(I).Value;
    vFieldType:= PrismFieldTypeAuto;
    if vColumn.DataFieldModel in [PrismFieldModelCombobox, PrismFieldModelLookup] then
    begin
     TryStrToInt(vFieldValue, vSelectFieldValue);

     //Trata "none"
     if (vSelectFieldValue > 0) then
     begin
      if vColumn.DataFieldModel in [PrismFieldModelCombobox] then
       vFieldValue:= vColumn.SelectItems.GetValue(vFieldValue).Value
      else
      if vColumn.DataFieldModel in [PrismFieldModelLookup] then
      begin
       FPrismDataLink.DataSet.FieldByName(vFieldName).LookupDataSet.RecNo:= vSelectFieldValue;
       //vFieldValue:= FPrismDataLink.DataSet.FieldByName(vFieldName).LookupDataSet.FieldByName(FPrismDataLink.DataSet.FieldByName(vFieldName).LookupKeyFields).AsString;
       vFieldValue:= FPrismDataLink.DataSet.FieldByName(vFieldName).LookupDataSet.FieldByName(FPrismDataLink.DataSet.FieldByName(vFieldName).LookupResultField).AsString;
      end;
     end else
     begin
      if (not DataSource.DataSet.FieldByName(vFieldName).IsNull) and
         (DataSource.DataSet.FieldByName(vFieldName).Value <> '') and
         (DataSource.DataSet.FieldByName(vFieldName).Value <> '0') then
      begin
       vErrorRollback:= true;
       AErrorMessage:= Format(Lang.Grid.MsgErrorCellNoneValue, [vColumn.Title]);
       Break;
      end;

      Continue;
     end;
    end;

    if Assigned(DataSource.DataSet.FieldByName(vFieldName)) then
     vFieldType:= PrismFieldType(DataSource.DataSet.FieldByName(vFieldName).DataType);
    if (vFieldType in [PrismFieldTypeNumber,PrismFieldTypeInteger,PrismFieldTypeDate,PrismFieldTypeDateTime]) and (vFieldValue = '') then
     vFieldValue:= '0';

    if (vFieldType in [PrismFieldTypeNumber]) and (vFieldValue <> '') and (vFieldValue <> '0') then
     vFieldValue:= FloatToStr(StrToFloat(FixFloat(vFieldValue, Session.FormatSettings), Session.FormatSettings), PrismOptions.DataBaseFormatSettings)
    else
     if (vFieldType in [PrismFieldTypeDate]) and (vFieldValue <> '') and (vFieldValue <> '0') then
     begin
      if TryStrToDate(vFieldValue, vDateTime, Session.FormatSettings) then
       vFieldValue:= DateToStr(vDateTime, PrismOptions.DataBaseFormatSettings)
      else
      if (DataSource.DataSet.FieldByName(vFieldName) is TDateField) and ((DataSource.DataSet.FieldByName(vFieldName) as TDateTimeField).DisplayFormat <> '') then
      begin
       vFixedDateTimeStr:= FixDateTimeByFormat(vFieldValue, DataSource.DataSet.FieldByName(vFieldName).AsDateTime, (DataSource.DataSet.FieldByName(vFieldName) as TDateTimeField).DisplayFormat, Session.FormatSettings.ShortDateFormat);
       if TryStrToDate(vFixedDateTimeStr, vDateTime, Session.FormatSettings) then
        vFieldValue:= DateToStr(vDateTime, PrismOptions.DataBaseFormatSettings);
      end;
     end else
      if (vFieldType in [PrismFieldTypeDate,PrismFieldTypeDateTime]) and (vFieldValue <> '') and (vFieldValue <> '0') then
      begin
       if (DataSource.DataSet.FieldByName(vFieldName) is TDateTimeField) and ((DataSource.DataSet.FieldByName(vFieldName) as TDateTimeField).DisplayFormat <> '') then
       begin
        vFixedDateTimeStr:= FixDateTimeByFormat(vFieldValue, DataSource.DataSet.FieldByName(vFieldName).AsDateTime, (DataSource.DataSet.FieldByName(vFieldName) as TDateTimeField).DisplayFormat, Session.FormatSettings.ShortDateFormat + ' ' + Session.FormatSettings.ShortTimeFormat);
        if TryStrToDateTime(vFixedDateTimeStr, vDateTime, Session.FormatSettings) then
         vFieldValue:= DateTimeToStr(StrToDateTime(vFieldValue, Session.FormatSettings), PrismOptions.DataBaseFormatSettings);
       end else
        vFieldValue:= DateTimeToStr(StrToDateTime(vFieldValue, Session.FormatSettings), PrismOptions.DataBaseFormatSettings);
      end;

    if Assigned(vColumn) then
    if ((DataSource.DataSet.FieldByName(vFieldName).IsNull) and (vFieldValue <> '')) or
       ((not DataSource.DataSet.FieldByName(vFieldName).IsNull) and
           (((vFieldType in [PrismFieldTypeAuto, PrismFieldTypeString]) and (DataSource.DataSet.FieldByName(vFieldName).AsString <> vFieldValue)) or
            ((vFieldType in [PrismFieldTypeInteger]) and (DataSource.DataSet.FieldByName(vFieldName).AsInteger <> StrToInt(vFieldValue))) or
            ((vFieldType in [PrismFieldTypeDate,PrismFieldTypeDateTime]) and (DataSource.DataSet.FieldByName(vFieldName).AsDateTime <> StrToDateTime(vFieldValue, PrismOptions.DataBaseFormatSettings))) or
            ((vFieldType in [PrismFieldTypeNumber]) and (DataSource.DataSet.FieldByName(vFieldName).AsFloat <> StrToFloat(vFieldValue, PrismOptions.DataBaseFormatSettings))))) then
    begin
     vAlter:= true;

     if not (vColumn.DataFieldModel in [PrismFieldModelLookup]) then
     vRollbackField.Add(vFieldName, DataSource.DataSet.FieldByName(vFieldName).Value);

     if not (DataSource.State in [dsEdit]) then
      DataSource.DataSet.Edit;

//      if PrismFieldType(DataSource.DataSet.FieldByName(vFieldName).DataType) = PrismFieldTypeNumber then
     if (vColumn.DataFieldModel in [PrismFieldModelLookup]) then
     begin
      DataSource.DataSet.FieldByName(FPrismDataLink.DataSet.FieldByName(vFieldName).KeyFields).Value:=
        FPrismDataLink.DataSet.FieldByName(vFieldName).LookupDataSet.FieldByName(FPrismDataLink.DataSet.FieldByName(vFieldName).LookupKeyFields).AsString;
     end;

     if ((vFieldType in [PrismFieldTypeNumber,PrismFieldTypeInteger,PrismFieldTypeDate,PrismFieldTypeDateTime]) and (vFieldValue = '0')) or
        ((vFieldType in [PrismFieldTypeString,PrismFieldTypeAuto]) and (vFieldValue = '')) then
      DataSource.DataSet.FieldByName(vFieldName).Clear
     else
     begin
      if (vFieldType in [PrismFieldTypeNumber]) and (vFieldValue <> '') and (vFieldValue <> '0') then
       DataSource.DataSet.FieldByName(vFieldName).AsFloat := StrToFloat(vFieldValue, PrismOptions.DataBaseFormatSettings)
      else
       if (vFieldType in [PrismFieldTypeDate]) and (vFieldValue <> '') and (vFieldValue <> '0') then
        DataSource.DataSet.FieldByName(vFieldName).AsDateTime:= StrToDate(vFieldValue, PrismOptions.DataBaseFormatSettings)
       else
       if (vFieldType in [PrismFieldTypeDateTime]) and (vFieldValue <> '') and (vFieldValue <> '0') then
        DataSource.DataSet.FieldByName(vFieldName).AsDateTime:= StrToDateTime(vFieldValue, PrismOptions.DataBaseFormatSettings)
       else
        DataSource.DataSet.FieldByName(vFieldName).Value:= vFieldValue;
     end;
    end;

   except
    vErrorRollback:= true;
    AErrorMessage:= Format(Lang.Grid.MsgErrorCellValue, [vFieldValue, vColumn.Title]);
    Break;
   end;
  end;

  if (vAlter) and (vErrorRollback) then
  begin
   DataSource.DataSet.Edit;

   for I := 0 to Pred(vRollbackField.Count) do
   begin
    if not (DataSource.State in [dsEdit]) then
     DataSource.DataSet.Edit;

    DataSource.DataSet.FieldByName(vRollbackField.Keys.ToArray[I]).Value:= vRollbackField.Items[vRollbackField.Keys.ToArray[I]];
   end;
  end else
  if (vAlter) and (not vErrorRollback) then
  begin
   DataSource.DataSet.Edit;
   DataSource.DataSet.Post;

   //ReloadGrid;
  end;
 end;

 if Assigned(vJSONCellValues) then
  vJSONCellValues.Free;

 vRollbackField.Free;
end;

function TPrismDBGrid.ColModelToList: TDictionary<string,string>;
const
 vWidthIconSelect: integer = 8;
 vWidthEditCell: integer = 3;
var
// JSONArrayColModelOptions: TJSONArray;
 JSONItemColumn: TJSONObject;
 JSONItemColumnOptions: TJSONObject;
 vItemColumnClasses: TStrings;
 ResultColJSON: String;
 I, J: Integer;
 vFatorWidth: Double;
 LookupRecNo: integer;
 vColumnIndex: Integer;
 vFormatterFunc: TStrings;
 vColAlign: string;
begin
 vFatorWidth:= 1.6;
 Result:= TDictionary<string,string>.Create;

 vColumnIndex:= 0;

 repeat
  for I := 0 to Columns.Items.Count-1 do
  begin
   if Columns.Items[I].ColumnIndex = vColumnIndex then
   begin
    if Columns.Items[I].Visible then
    begin
     JSONItemColumn:= TJSONObject.Create;
     vItemColumnClasses:= TStringList.Create;
     JSONItemColumnOptions:= TJSONObject.Create;
     //JSONArrayColModelOptions:= TJSONArray.Create;

     //if Columns.Items[I].DataFieldModel <> PrismFieldModelButton then
//     if (Columns.Items[I].DataField <> '') then
//     begin
//      JSONItemColumn.AddPair('name', Columns.Items[I].DataField);
//     end else
//     begin
//      JSONItemColumn.AddPair('name', 'ColumnNoNamed'+IntToStr(I));
//     end;

     //Align
     vColAlign:= 'left';
     if Columns.Items[I].Alignment in [PrismAlignLeft, PrismAlignNone, PrismAlignJustified] then
      vColAlign:= 'left'
     else
     if Columns.Items[I].Alignment in [PrismAlignRight] then
      vColAlign:= 'right'
     else
     if Columns.Items[I].Alignment in [PrismAlignCenter] then
      vColAlign:= 'center';

     vItemColumnClasses.Add('d2bridgedbgridcell');

     JSONItemColumn.AddPair('name', Columns.Items[I].ColName);
     JSONItemColumn.AddPair('index', TJSONIntegerNumber.Create(Columns.Items[I].ColumnIndex));
     JSONItemColumn.AddPair('label', '<div class="d2bridgedbgridtitle" style="text-align: ' + vColAlign + ';">'+Columns.Items[I].Title+'</div>');
     JSONItemColumn.AddPair('width', TJSONIntegerNumber.Create(Round(Columns.Items[I].Width * vFatorWidth)));
     JSONItemColumn.AddPair('align', vColAlign);

     if Columns.Items[I].DataFieldModel = PrismFieldModelNone then
      Columns.Items[I].DataFieldModel:= PrismFieldModelField;

     if (Columns.Items[I].Editable) and (FStoredEditable) then
     begin
      JSONItemColumn.AddPair('editable', GetTJSONTrue);

      vItemColumnClasses.Add('celleditable');

      JSONItemColumn.AddPair('width', TJSONIntegerNumber.Create(Round((Columns.Items[I].Width + vWidthEditCell) * vFatorWidth)));

      //Lookup Combobox
      if Columns.Items[I].DataField <> '' then
      if Assigned(FPrismDataLink.DataSource) then
      if Assigned(FPrismDataLink.DataSet.FindField(Columns.Items[I].DataField)) then
      begin
       if (FPrismDataLink.DataSet.FindField(Columns.Items[I].DataField).FieldKind = fkLookup) and
          Assigned(FPrismDataLink.DataSet.FindField(Columns.Items[I].DataField).LookupDataSet) and
          (FPrismDataLink.DataSet.FindField(Columns.Items[I].DataField).LookupDataSet.Active) and
          (FPrismDataLink.DataSet.FindField(Columns.Items[I].DataField).KeyFields <> '') and
          (FPrismDataLink.DataSet.FindField(Columns.Items[I].DataField).LookupKeyFields <> '') and
          (FPrismDataLink.DataSet.FindField(Columns.Items[I].DataField).LookupResultField <> '') then
       begin
        Columns.Items[I].DataFieldModel:= PrismFieldModelLookup;

        //Adjust Select ICON
        JSONItemColumn.AddPair('width', TJSONIntegerNumber.Create(Round((Columns.Items[I].Width+vWidthIconSelect) * vFatorWidth)));

        if Assigned(Columns.Items[I].SelectItems) then
         Columns.Items[I].SelectItems.Free;

        Columns.Items[I].SelectItems:= TJSONObject.Create;

        Columns.Items[I].SelectItems.AddPair('0', '--' + Lang.Combobox.Select + '--');

        LookupRecNo:= FPrismDataLink.DataSet.FindField(Columns.Items[I].DataField).LookupDataSet.RecNo;
        FPrismDataLink.DataSet.FindField(Columns.Items[I].DataField).LookupDataSet.DisableControls;
        FPrismDataLink.DataSet.FindField(Columns.Items[I].DataField).LookupDataSet.First;

        repeat
         Columns.Items[I].SelectItems.AddPair(
           IntToStr(FPrismDataLink.DataSet.FindField(Columns.Items[I].DataField).LookupDataSet.RecNo),
           FPrismDataLink.DataSet.FindField(Columns.Items[I].DataField).LookupDataSet.FieldByName(FPrismDataLink.DataSet.FindField(Columns.Items[I].DataField).LookupResultField).AsString
         );

         FPrismDataLink.DataSet.FindField(Columns.Items[I].DataField).LookupDataSet.Next;
        until FPrismDataLink.DataSet.FindField(Columns.Items[I].DataField).LookupDataSet.Eof;

        FPrismDataLink.DataSet.FindField(Columns.Items[I].DataField).LookupDataSet.RecNo:= LookupRecNo;
        FPrismDataLink.DataSet.FindField(Columns.Items[I].DataField).LookupDataSet.EnableControls;

       end;
      end;


      if Columns.Items[I].SelectItems.Count > 0 then
      begin
       if Columns.Items[I].DataFieldModel <> PrismFieldModelLookup then
        Columns.Items[I].DataFieldModel:= PrismFieldModelCombobox;

       JSONItemColumn.AddPair('edittype', 'select');
       JSONItemColumnOptions.AddPair('value', Columns.Items[I].SelectItems.NewClone);
       JSONItemColumnOptions.AddPair('style', 'width: 100%;box-sizing: border-box;');

       //Adjust Select ICON
       JSONItemColumn.AddPair('width', TJSONIntegerNumber.Create(Round((Columns.Items[I].Width+vWidthIconSelect) * vFatorWidth)));
      end else
       JSONItemColumn.AddPair('edittype', 'text');

      //Get DataType
      if Columns.Items[I].DataField <> '' then
      if Columns.Items[I].DataFieldType = PrismFieldTypeAuto then
      if Assigned(FPrismDataLink.DataSource) then
      begin
       if Assigned(FPrismDataLink.DataSet.FindField(Columns.Items[I].DataField)) then
       Columns.Items[I].DataFieldType := PrismFieldType(FPrismDataLink.DataSet.FindField(Columns.Items[I].DataField).DataType);
      end;
     end else
     begin
      JSONItemColumn.AddPair('editable', GetTJSONFalse);
     end;

     if Columns.Items[I].CSS <> '' then
     vItemColumnClasses.Add(Columns.Items[I].CSS);

     if Columns.Items[I].DataFieldModel in [PrismFieldModelButton, PrismFieldModelHTML]  then
     begin
      vFormatterFunc:= TStringList.Create;
      vFormatterFunc.LineBreak:= '';

      with vFormatterFunc do
      begin
       Add('[NoQuotationMarks]function (cellvalue, options, rowObject) { ');

       if Columns.Items[I].DataField <> '' then
        Add(' var value = rowObject.'+ Columns.Items[I].DataField +'; ')
       else
        Add(' var value = null; ');

       Add(' var recNo = rowObject.PrismRecNo; ');
       Add(' var data = rowObject; ');

       if Columns.Items[I].DataFieldModel = PrismFieldModelButton then
        Add(' return `'+Columns.Items[I].Buttons.MakeHTML+'`')
       else
        Add(' return `'+Columns.Items[I].HTML+'`');

       Add('}[NoQuotationMarks]');
      end;

      JSONItemColumn.AddPair('formatter', vFormatterFunc.Text);

      //JSONItemColumn.AddPair('fixed', GetTJSONTrue);

      if Columns.Items[I].DataFieldModel = PrismFieldModelButton then
       vItemColumnClasses.Add('gridcolbuttons')
      else
       vItemColumnClasses.Add('gridcolhtml');

      vFormatterFunc.Free;
     end;

     if JSONItemColumnOptions.Count > 0 then
      JSONItemColumn.AddPair('editoptions', JSONItemColumnOptions.NewClone);

     JSONItemColumn.AddPair('classes', StringReplace(vItemColumnClasses.CommaText, ',', ' ', [rfReplaceAll]));

     ResultColJSON:= JSONItemColumn.ToJSON;
     ResultColJSON:= StringReplace(ResultColJSON, '"[NoQuotationMarks]', '', [rfReplaceAll]);
     ResultColJSON:= StringReplace(ResultColJSON, '[NoQuotationMarks]"', '', [rfReplaceAll]);
  //   ResultColJSON:= StringReplace(ResultColJSON, '''''', '\''', [rfReplaceAll]);

     Result.Add(Columns.Items[I].ColName, Form.ProcessAllTagHTML(ResultColJSON));

     JSONItemColumn.Free;
     vItemColumnClasses.Free;
     JSONItemColumnOptions.Free;
     ResultColJSON:= '';
   //  JSONArrayColModelOptions.Free;
    end;
   end;
  end;

  Inc(vColumnIndex);

 until vColumnIndex >= Columns.Items.Count;

end;

function TPrismDBGrid.ColumnsToColModel: string;
var
 I: Integer;
 vColModelToList: TDictionary<string,string>;
 vColumnIndex: Integer;
begin
 Result:= '';

 vColumnIndex:= 0;

 vColModelToList:= ColModelToList;

 repeat
  for I := 0 to Pred(Columns.Items.Count) do
  begin
   if vColumnIndex = Columns.Items[I].ColumnIndex then
   begin
    if Columns.Items[I].Visible then
    begin
     if Result <> '' then
      Result:= Result + ',' + sLineBreak;

      Result:= Result + vColModelToList.Items[Columns.Items[I].ColName]
    end;
   end;
  end;

  inc(vColumnIndex);

 until vColumnIndex >= Columns.Items.Count;

 vColModelToList.Free;
end;

constructor TPrismDBGrid.Create(AOwner: TObject);
var
 EventJSON, EventCellPost, EventCellButtonClick: TPrismControlEvent;
begin
 inherited;

 FRefreshData:= false;
 FRefreshDataOnLoad:= false;

 FPrismDataLink:= TPrismDataLinkCore.Create;
 FPrismDataLink.OnDataWareEvent:= DataWareEvent;

 FOnLoadJSON:= GetDataToJSON;

 FSelectedRowsID:= TList<Integer>.Create;
 FSelectEvent:= false;

// EventJSON:= TPrismControlEvent.Create(self, EventOnLoadJSON);
// EventJSON.AutoPublishedEvent:= false;
// EventJSON.SetOnEvent(FOnLoadJSON);
// Events.Add(EventJSON);

 EventCellPost := TPrismControlEvent.Create(self, EventOnCellPost);
 EventCellPost.AutoPublishedEvent:= false;
 EventCellPost.SetOnEvent(FOnLoadJSON);
 Events.Add(EventCellPost);

 EventCellButtonClick := TPrismControlEvent.Create(self, EventOnCellButtonClick);
 EventCellButtonClick.AutoPublishedEvent:= false;
 EventCellButtonClick.SetOnEvent(OnCellButtonClick);
 Events.Add(EventCellButtonClick);

 FRefreshRow.Update := false;
end;

procedure TPrismDBGrid.DataWareEvent(const ADataWareEvent: TPrismDataLinkEvent);
var
 vJSONData: string;
 vJSONArrayColumns, vJSONDataArray: TJSONArray;
begin
 if Form.FormPageState in [PageStateLoaded, PageStateLoading] then
 begin
  //Active/Deactive
  if ADataWareEvent in [TPrismDataLinkEvent.Activate, TPrismDataLinkEvent.Deactivate, TPrismDataLinkEvent.NewRow, TPrismDataLinkEvent.Deleted] then
  begin
   FSelectedRowsID.Clear;
   UpdateData;
  end;

  //Update
  if ADataWareEvent in [TPrismDataLinkEvent.Updated] then
  begin
   vJSONArrayColumns:= Columns.ColumnsNameToJSON;
   vJSONDataArray:= FPrismDataLink.DataSet.DataSetToJSON(vJSONArrayColumns, 1, false, Session.FormatSettings, true);
   vJSONData:= vJSONDataArray.Items[0].ToJSON;
   UpdateRow(FPrismDataLink.DataSet.RecNo, vJSONData);
   vJSONArrayColumns.Free;
   vJSONDataArray.Free;
  end;
 end else
  if ADataWareEvent in [TPrismDataLinkEvent.Activate, TPrismDataLinkEvent.Deactivate, TPrismDataLinkEvent.NewRow, TPrismDataLinkEvent.Deleted, TPrismDataLinkEvent.Updated] then
   FRefreshDataOnLoad:= true;
end;

destructor TPrismDBGrid.Destroy;
begin
 if Assigned(FPrismDataLink.DataSource) then
 begin
  //FPrismDataLink.DataSource.RemoveFreeNotification(Self);
  FPrismDataLink.DataSource := nil; // Desassocia o evento
 end;

 FreeAndNil(FPrismDataLink);

 FSelectedRowsID.Free;

 inherited;
end;

procedure TPrismDBGrid.Exec_Check(varParameter: TValue);
var
 vParameters: TStrings;
begin
 vParameters:= TStrings(varParameter.AsObject);
 Events.Item(EventOnCheck).CallEvent(vParameters);
end;

procedure TPrismDBGrid.Exec_UnCheck(varParameter: TValue);
var
 vParameters: TStrings;
begin
 vParameters:= TStrings(varParameter.AsObject);
 Events.Item(EventOnUnCheck).CallEvent(vParameters);
end;

function TPrismDBGrid.GetDataSource: TDataSource;
begin
 result:= FPrismDataLink.DataSource;
end;

function TPrismDBGrid.GetDataToJSON: String;
begin
 if FJSONData = '' then
  Result:= '[]'
 else
  Result:= FJSONData;
end;

function TPrismDBGrid.GetEditable: Boolean;
var
 vResultCanEditing: boolean;
begin
 if Assigned(ProcGetEditable) then
  Result:= ProcGetEditable
 else
  Result:= FStoredEditable;

 if Result and Assigned(FPrismDataLink.DataSource) then
 begin
  vResultCanEditing:= false;

  if Assigned(FPrismDataLink.DataSet) then
   if FPrismDataLink.Active then
    if (FPrismDataLink.Editing) or (FPrismDataLink.DataSource.AutoEdit) then
     vResultCanEditing:= true;

  Result:= vResultCanEditing;
 end;
end;

function TPrismDBGrid.GetEnableComponentState: Boolean;
begin
 Result:= false;
end;

function TPrismDBGrid.GetSelectedRowsID: TList<Integer>;
begin
 Result:= FSelectedRowsID;
end;

procedure TPrismDBGrid.Initialize;
begin
 inherited;

 FStoredRecNo:= RecNo;
 FStoredEditable:= GetEditable;
end;

function TPrismDBGrid.IsDBGrid: Boolean;
begin
 result:= true;
end;

procedure TPrismDBGrid.OnCellButtonClick(EventParams: TStrings);
var
 vColIndex: Integer;
 vRowID: integer;
 vElementID: string;
 I, J, K: integer;
 vCellButton: TPrismGridColumnButton;
begin
 if TryStrToInt(EventParams.Values['ColIndex'], vColIndex) then
 begin
  if TryStrToInt(EventParams.Values['rowid'], vRowID) then
  begin
   RecNo(vRowID);

   vCellButton:= nil;
   vElementID:= EventParams.Values['CellButtonElementID'];

   for I := 0 to Pred(Columns.Items.Count) do
   begin
    if Columns.Items[I].ColumnIndex = vColIndex then
    begin
     for J := 0 to Pred(Columns.Items[I].Buttons.Items.Count) do
     begin
      if Columns.Items[I].Buttons.Items.Items[J].ElementID = vElementID then
      begin
       vCellButton:= Columns.Items[I].Buttons.Items.Items[J] as TPrismGridColumnButton;
       Form.DoCellButtonClick(self, vCellButton, vColIndex, vRowID);
       break;
      end else
      for k := 0 to Pred(Columns.Items[I].Buttons.Items.Items[J].Buttons.Count) do
      begin
       if Columns.Items[I].Buttons.Items.Items[J].Buttons[K].ElementID = vElementID then
       begin
        vCellButton:= Columns.Items[I].Buttons.Items.Items[J].Buttons[K] as TPrismGridColumnButton;
        Form.DoCellButtonClick(self, vCellButton, vColIndex, vRowID);
        break;
        break;
       end;
      end;
     end;
     break;
    end;
   end;
  end;
 end;

end;

procedure TPrismDBGrid.ProcessComponentState(
  const ComponentStateInfo: TJSONObject);
begin
  inherited;

end;

procedure TPrismDBGrid.ProcessEventParameters(Event: IPrismControlEvent;
  Parameters: TStrings);
var
 FRowIDStr, vSelectType: String;
 I,X, FRowID, _row: integer;
 FRowsID: TStringList;
 vRowIDExist: boolean;
begin
 inherited;

 FRowIDStr:= Parameters.Values['rowid'];
 vSelectType:= Parameters.Values['selecttype'];

 if Assigned(FPrismDataLink.DataSource) then
 if Assigned(FPrismDataLink.DataSet) then
 if FPrismDataLink.DataSet.Active then
 begin
  if (vSelectType <> 'selectall') and (vSelectType <> 'unselectall') then
  if TryStrToInt(FRowIDStr, FRowID) then
  begin
   if (Event.EventType in [EventOnSelect]) then
   begin
    FRowsID:= TStringList.Create;
    FSelectEvent:= true;

    try
     try
      FRowsID.CommaText:= Parameters.Values['rowsids'];
//      if FRowsID.CommaText = '' then
//       FRowsID.CommaText:= FRowIDStr;

      if FRowsID.Count > 0 then
      begin
       {$REGION 'Remove UnChecks'}
        for X:= Pred(FSelectedRowsID.Count) downto 0 do
        begin
         vRowIDExist:= false;
         _row:= FSelectedRowsID[X];

         for I := 0 to Pred(FRowsID.Count) do
         if FRowsID[I] = IntToStr(_row) then
         begin
          vRowIDExist:= true;
          break;
         end;

         if not vRowIDExist then
         begin
          FSelectedRowsID.Delete(X);

          if RecNo(_row) then
           Session.ExecThread(true,
            Exec_UnCheck,
            TValue.From<TStrings>(Parameters)
           );


          //Verify if not Deleted
          if FSelectedRowsID.Contains(_row) then
          Session.ExecJS
           (
             '$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).jqGrid("setSelection", ' + IntToStr(_row) + '); '+
             'SelectedRowIDs'+AnsiUpperCase(NamePrefix)+'.push(parseInt(' + IntToStr(_row) + '));'
           );
         end;
        end;
       {$ENDREGION}


       {$REGION 'Check'}
        for I := 0 to Pred(FRowsID.Count) do
        begin
         vRowIDExist:= false;
         _row:= StrToInt(FRowsID[I]);

         for X := 0 to Pred(FSelectedRowsID.Count) do
         if IntToStr(FSelectedRowsID[X]) = FRowsID[I] then
         begin
          vRowIDExist:= true;
          break;
         end;

         if not vRowIDExist then
         begin
          FSelectedRowsID.Add(_row);

          if RecNo(_row) then
           Session.ExecThread(true,
            Exec_Check,
            TValue.From<TStrings>(Parameters)
           );

          //Verify if Deleted
          if not FSelectedRowsID.Contains(_row) then
          Session.ExecJS
           (
             '$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).jqGrid("setSelection", ' + IntToStr(_row) + '); '+
             'if (SelectedRowIDs'+AnsiUpperCase(NamePrefix)+'.indexOf(parseInt(' + IntToStr(_row) + ')) !== -1) '+
             'SelectedRowIDs'+AnsiUpperCase(NamePrefix)+'.splice(SelectedRowIDs'+AnsiUpperCase(NamePrefix)+'.indexOf(parseInt(' + IntToStr(_row) + ')), 1); '
           );

         end;
        end;
       {$ENDREGION}
      end else
      begin
       {$REGION 'Remove UnChecks'}
        for X:= Pred(FSelectedRowsID.Count) downto 0 do
        begin
         _row:= FSelectedRowsID[X];

         FSelectedRowsID.Delete(X);

         if RecNo(_row) then
          Session.ExecThread(true,
           Exec_UnCheck,
           TValue.From<TStrings>(Parameters)
          );

         //Verify if not Deleted
         if FSelectedRowsID.Contains(_row) then
         Session.ExecJS
          (
            '$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).jqGrid("setSelection", ' + IntToStr(_row) + '); '+
            'SelectedRowIDs'+AnsiUpperCase(NamePrefix)+'.push(parseInt(' + IntToStr(_row) + '));'
          );
        end;
       {$ENDREGION}
      end;
     except

     end;
    finally
     FRowsID.Free;
    end;
   end;

   if Event.EventType in [EventOnSelect] then
   begin
    RecNo(FRowID);

    if vSelectType = 'select' then
     if Assigned(Events.Item(EventOnClick)) then
      Events.Item(EventOnClick).CallEvent(Parameters);
   end;
  end;


  if Event.EventType = EventOnSelect then
  begin
   if vSelectType = 'selectall' then
   begin
    FSelectedRowsID.Clear;

    if Assigned(Events.Item(EventOnSelectAll)) then
    begin
     Events.Item(EventOnSelectAll).CallEvent(Parameters);

     Session.ExecJS
      (
        'SelectedRowIDs'+AnsiUpperCase(NamePrefix)+' = ' + SelectedRowsIDStr + '; '+
        'let allRowIDs = $("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).jqGrid("getDataIDs"); '+
        'allRowIDs.forEach(function(rowId) { '+
        '    let shouldBeSelected = SelectedRowIDs'+AnsiUpperCase(NamePrefix)+'.includes(parseInt(rowId)); '+
        '    if (!shouldBeSelected) { '+
        '        $("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).jqGrid("setSelection", rowId, false); '+
        '    } '+
        '}); '
      );
    end;
   end else
    if vSelectType = 'unselectall' then
    begin
     FSelectedRowsID.Clear;

     if Assigned(Events.Item(EventOnUnSelectAll)) then
      Events.Item(EventOnUnSelectAll).CallEvent(Parameters);
    end;

  end;


 end;


 FSelectEvent:= false;
end;

procedure TPrismDBGrid.ProcessHTML;
var
 I: Integer;
 HTMLText: TStringList;
begin
 inherited;

 SetDataToJSON;

 HTMLText:= TStringList.Create;

 HTMLText.Add('<div class="col">');
 HTMLText.Add('<table '+HTMLCore+'>'+'</table>');
 if ShowPager then
 begin
  HTMLText.Add('<div id="PAGER'+ AnsiUpperCase(NamePrefix) +'"></div>');
 end;
 HTMLText.Add('</div>');


 HTMLText.Add('<script type="text/javascript">');

 with HTMLText do
 begin
  Add('var SelectedRowIDs'+AnsiUpperCase(NamePrefix)+' = ' + SelectedRowsIDStr + ';');
  Add('var SelectedCol'+AnsiUpperCase(NamePrefix)+' = -1;');
  Add('var nextEditRowID'+AnsiUpperCase(NamePrefix)+' = null;');
  Add('var nextEditCol'+AnsiUpperCase(NamePrefix)+' = null;');
  Add('var lastEditRowID'+AnsiUpperCase(NamePrefix)+' = null;');
  Add('var lastCellContent'+AnsiUpperCase(NamePrefix)+' = null;');
  Add('var ColEditable'+AnsiUpperCase(NamePrefix)+' = false;');
  Add('var refreshcellbuttonclick'+AnsiUpperCase(NamePrefix)+' = false;');
  //Add('var JSONData'+AnsiUpperCase(NamePrefix)+' = {};');
  //Add('var JSONData'+AnsiUpperCase(NamePrefix)+' = ' + GetDataToJSON + ';');
 end;

 with HTMLText do
 begin
//  Add('async function GetJSONData'+AnsiUpperCase(NamePrefix)+'() {');
//  Add('  var ResponseJSON = await PrismServer().GetFromEvent("'+Session.UUID+'", "'+ Session.Token +'", "'+ Form.FormUUID +'", "' + AnsiUpperCase(NamePrefix) + '", "'+ FOnLoadJSONEventID + '", "", "true");');
//  Add('  return JSON.parse(ResponseJSON);');
//  Add('}');
  //Add('JSONData'+AnsiUpperCase(NamePrefix)+' = await PrismServer().GetFromEvent("'+Session.UUID+'", "'+ Session.Token +'", "'+ Form.FormUUID +'", "' + AnsiUpperCase(NamePrefix) + '", "'+ FOnLoadJSONEventID + '", "", "true");');
 end;

 HTMLText.Add('$(function () {');
 HTMLText.Add('"use strict";');
 HTMLText.Add('let DBGrid = $("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'"});');
 HTMLText.Add('DBGrid.jqGrid(');
 HTMLText.Add('{');
 //LANGUAGE
 HTMLText.Add('recordtext: "' + Lang.Grid.FooterRecordText + '",');
 HTMLText.Add('emptyrecords: "' + Lang.Grid.EmptyRecords + '",');
 HTMLText.Add('loadtext: "' + Lang.Grid.LoadingData + '",');
 HTMLText.Add('pgtext : "' + Lang.Grid.FooterRecordPageText + '",');
 //CONFIG
 //HTMLText.Add('url: window.location.href + ''rest/json/jqgrid/get?controlid='+AnsiUpperCase(NamePrefix)+'&eventid='+Events.Item(EventOnLoadJSON).EventID+'&token='+Session.Token+'&prismsession='+Session.UUID+'&FormUUID='+Form.FormUUID+''',');
 HTMLText.Add('datatype : "local",');
 //HTMLText.Add('datatype : "json",');
 HTMLText.Add('data : ' + FJSONData + ',');
 HTMLText.Add('loadonce: true,');
 if FStoredEditable then
 begin
  HTMLText.Add('editable: true,');
  HTMLText.Add('celledit: true,');
 end else
 begin
  HTMLText.Add('editable: false,');
  HTMLText.Add('celledit: false,');
 end;
 HTMLText.Add('cellsubmit: "remote",');
 HTMLText.Add('editurl: ''rest/json/jqgrid/post?controlid='+AnsiUpperCase(NamePrefix)+'&eventid='+Events.Item(EventOnCellPost).EventID+'&token='+Session.Token+'&prismsession='+Session.UUID+'&FormUUID='+Form.FormUUID+''',');

 //HTMLText.Add('cellurl: window.location.href + ''rest/json/jqgrid/changed/cell/value?controlid='+AnsiUpperCase(NamePrefix)+'&eventid='+Events.Item(EventOnLoadJSON).EventID+'&token='+Session.Token+'&prismsession='+Session.UUID+'&FormUUID='+Form.FormUUID+''',');

 HTMLText.Add('serializeRowData: function (postdata) {');
 HTMLText.Add('      let currentPage = DBGrid.jqGrid("getGridParam", "page");');
 HTMLText.Add('      let recordsPerPage = DBGrid.jqGrid("getGridParam", "rowNum");');
 HTMLText.Add('      let rowindexpage = DBGrid.jqGrid("getInd", postdata.id);');
 HTMLText.Add('      let rowindex = (currentPage - 1) * recordsPerPage + rowindexpage;');
 HTMLText.Add('      postdata.rowindex = rowindex;');
 HTMLText.Add('      return JSON.stringify(postdata);');
 HTMLText.Add(' },');

 HTMLText.Add('rowattr: function (rowData, currentObj, rowId) {');
 HTMLText.Add('    return { "class": "d2bridgedbgridrow" };');
 HTMLText.Add('},');

// HTMLText.Add('inlineEditing: { keys: false },');
 HTMLText.Add('forceClientSorting: true,');
 //localReader
 HTMLText.Add('localReader: {');
 HTMLText.Add('   id: "PrismRecNo",');
 HTMLText.Add('   repeatitems: true');
 HTMLText.Add('},');
 //jsonReader
 HTMLText.Add('jsonReader: {');
 HTMLText.Add('   id: "PrismRecNo",');
 HTMLText.Add('   repeatitems: false');
 HTMLText.Add('},');
 //Colunas
 HTMLText.Add('colModel : '+ sLineBreak + '['+ColumnsToColModel+']' +',');
 //HTMLText.Add('data: JSONData'+AnsiUpperCase(NamePrefix)+',');
 //Pager
 if ShowPager then
  HTMLText.Add('pager: "#PAGER'+AnsiUpperCase(NamePrefix)+'",');
 HTMLText.Add('gridview: true,');
 HTMLText.Add('hoverrows: false,');
 HTMLText.Add('scrollrows: true,');
 HTMLText.Add('rowNum: '+ IntToStr(RecordsPerPage) +',');
 HTMLText.Add('viewrecords: true,');
 HTMLText.Add('shrinkToFit: false,');
 //HTMLText.Add('forceFit: true,');
 //HTMLText.Add('width: 800,');
 if MultiSelect then
 begin
  HTMLText.Add('multiselect: true,');
  HTMLText.Add('multiselectWidth: '+ IntToStr(MultiSelectWidth) +',');
 end else
 begin
  HTMLText.Add('multiselect: false,');
  //HTMLText.Add('multiselectPosition: "none",');
 end;
 HTMLText.Add('ignorecase: true,');
 HTMLText.Add('scroll: false,');
 HTMLText.Add('sortable: true,');
 HTMLText.Add('altRows: false,');
 HTMLText.Add('hidegrid: true,');
 HTMLText.Add('multiboxonly: true,');
 HTMLText.Add('toppager: false,');
 HTMLText.Add('pginput: true,');
 HTMLText.Add('guiStyle: "bootstrap4",');
 HTMLText.Add('iconSet: "fontAwesome",');
 HTMLText.Add('reloadAfterSubmit: true,');
// HTMLText.Add('jqModal: false,');
// HTMLText.Add('modal: false,');



 //Event onCellSelect
 with HTMLText do
 begin
  Add('onCellSelect: function(rowid, iCol, cellcontent, e)');
  Add('{');
  Add(' var cellcontentElement = document.createRange().createContextualFragment(cellcontent).querySelector("div");');
  Add(' var isCellControl = (cellcontentElement !== null) && cellcontentElement.classList.contains("d2bridgecellcontrols");');
  Add(' var ismultiselect = $(this).jqGrid("getGridParam", "multiselect");');
  Add(' var rowindex = rowid;');
  Add(' var isRowSelected = $(this).jqGrid("getGridParam", "selrow") === rowid;');
  Add(' var colModelRow = $(this).jqGrid("getGridParam", "colModel");');
  Add(' var waitsave = false;');
  Add(' ColEditable'+AnsiUpperCase(NamePrefix)+' = colModelRow[iCol].editable;');
  Add(' lastCellContent'+AnsiUpperCase(NamePrefix)+' = e;');
  Add(' if (!isRowSelected || iCol !== SelectedCol'+AnsiUpperCase(NamePrefix)+' || ismultiselect)');
  Add(' {');
  Add('   SelectedCol'+AnsiUpperCase(NamePrefix)+' = iCol;');
  Add('   if (iCol != 0 || !ismultiselect) {');
  Add('     if(lastEditRowID'+AnsiUpperCase(NamePrefix)+' !== null) {');
  Add('       if(rowid !== lastEditRowID'+AnsiUpperCase(NamePrefix)+'){');
  Add('          nextEditRowID'+AnsiUpperCase(NamePrefix)+' = rowid;');
  Add('          nextEditCol'+AnsiUpperCase(NamePrefix)+' = iCol;');
  Add('            $(this).jqGrid(''saveRow'',lastEditRowID'+AnsiUpperCase(NamePrefix)+');');
  Add('          $(this).jqGrid("setSelection", lastEditRowID'+AnsiUpperCase(NamePrefix)+', false);');
  Add('            waitsave = true;');
  Add('        }');
  Add('     }');
  Add('     if (!waitsave && ColEditable'+AnsiUpperCase(NamePrefix)+') {');
  Add('        $(this).jqGrid("setSelection", rowid, false);');
  Add('         DBGrid.jqGrid(''editRow'', rowid, iCol);');
  Add('        lastEditRowID'+AnsiUpperCase(NamePrefix)+' = rowid;');
  Add('        setTimeout(function() {');
  Add('             lastCellContent'+AnsiUpperCase(NamePrefix)+'.target.lastChild.focus();');
  Add('        }, 0);');
  Add('     }');
  Add('   }');
  Add('   if (!waitsave) {');
  Add('      var rowsids = [];');
  Add('      var typeValue = null;');
  Add('      var $tempElement = $(''<div>'').html(cellcontent);');
  Add('      if ($tempElement.find(''input'').length > 0) {');
  Add('         if (e.target.className  === "cbox")');
  Add('         var typeValue = $tempElement.find(''input'').attr(''type'');');
  Add('      }');
  Add('      rowsids = SelectedRowIDs'+AnsiUpperCase(NamePrefix)+';');
  Add('      $(this).jqGrid("getGridParam", "selarrrow").forEach(function(_rowId) {');
  Add('         if (!rowsids.includes(parseInt(_rowId))) {');
  Add('            rowsids.push(parseInt(_rowId));');
  Add('         }');
  Add('      });');
  //Add('   rowsids =  Array.from(new Set(SelectedRowIDs'+AnsiUpperCase(NamePrefix)+'.concat(jqGridSelectedRows($(this).jqGrid("getGridParam", "selarrrow")))));');
  Add('      if (!rowsids.includes(parseInt(rowid)) || iCol != 0) {');
  Add('        if (typeValue === "checkbox" && iCol === 0) {');
  Add('           if (!rowsids.includes(parseInt(rowid))) {');
  Add('              rowsids.push(parseInt(rowindex));');
  Add('           }');
  Add('        }');
  Add('        else {');
  Add('           rowsids = [parseInt(rowid)];');
  Add('        }');
  Add('        if (typeValue === "checkbox") {');
  Add('           var params = "rowid="+rowindex+"&col="+iCol+"&rowsids="+rowsids+"&selecttype=check";');
  Add('           SelectedRowIDs'+AnsiUpperCase(NamePrefix)+' = rowsids;');
//  if Assigned(Events.Item(EventOnCheck)) then
  if Assigned(Events.Item(EventOnSelect)) then
  Add(Events.Item(EventOnSelect).EventJS(ExecEventProc, 'params', true));
  Add('        } else {');
  Add('           var params = "rowid="+rowindex+"&col="+iCol+"&rowsids="+rowsids+"&selecttype=select";');
  Add('           SelectedRowIDs'+AnsiUpperCase(NamePrefix)+' = rowsids;');
  Add('           if (!isCellControl) {');
  if Assigned(Events.Item(EventOnSelect)) then
  Add(Events.Item(EventOnSelect).EventJS(ExecEventProc, 'params', true));
  Add('           }');
  Add('        }');
  Add('      } else {');
  Add('           if (typeValue === "checkbox" && iCol === 0) {');
  Add('              if (rowsids.includes(parseInt(rowid)))');
  Add('                 rowsids.splice(rowsids.indexOf(parseInt(rowid)), 1);');
  Add('              SelectedRowIDs'+AnsiUpperCase(NamePrefix)+' = rowsids;');
  Add('           } else {');
  Add('              rowsids = [parseInt(rowid)];');
  Add('              SelectedRowIDs'+AnsiUpperCase(NamePrefix)+' = [];');
  Add('           }');
  Add('           var params = "rowid="+rowindex+"&col="+iCol+"&rowsids="+rowsids+"&selecttype=uncheck";');
//  if Assigned(Events.Item(EventOnUncheck)) then
  if Assigned(Events.Item(EventOnSelect)) then
  Add(Events.Item(EventOnSelect).EventJS(ExecEventProc, 'params', true));
  Add('      }');
  Add('   }');
  Add(' }');
  if not MultiSelect then
  begin
   Add('  if (!waitsave) {');
   Add('     setTimeout(function() {');
   Add('     DBGrid.jqGrid("setSelection", rowid, false);');
   Add('        if (ColEditable'+AnsiUpperCase(NamePrefix)+') { ');
   Add('           lastEditRowID'+AnsiUpperCase(NamePrefix)+' = rowid;');
   Add('        }');
   Add('     }, 0);');
   Add('  }');
  end;
  Add('  return true;');
  Add('},');
 end;


 //Event onPaging
 with HTMLText do
 begin
  Add('onPaging: function(pagingInfo) {');
  Add('   if (pagingInfo.direction === "user") {');
  Add('   }');
  Add('   if (pagingInfo.direction === "first") {');
  Add('   }');
  Add('   if (pagingInfo.direction === "next") {');
  Add('   }');
  Add('   if (pagingInfo.direction === "last") {');
  Add('   }');
  Add('   if (pagingInfo.direction === "prev") {');
  Add('   }');
  Add('},');
 end;


 //Event loadComplete
 with HTMLText do
 begin
  Add('loadComplete: function(data) {');
  Add('   DBGrid.jqGrid("resetSelection");');
  Add('   for (var i = 0; i < SelectedRowIDs'+AnsiUpperCase(NamePrefix)+'.length; i++) {');
  Add('      DBGrid.jqGrid("setSelection", SelectedRowIDs'+AnsiUpperCase(NamePrefix)+'[i], false);');
  Add('   }');
  Add('   let isMultiSelect = DBGrid.jqGrid("getGridParam", "multiselect");');
  Add('   let isEditable = DBGrid.jqGrid("getGridParam", "editable");');
  Add('   if (isMultiSelect && isEditable) {');
  Add('      $("#gbox_' +AnsiUpperCase(NamePrefix) + ' th:nth-child(1)").hide();');
  Add('      $("#gbox_' +AnsiUpperCase(NamePrefix) + ' td:nth-child(1)").hide();');
  Add('   }');
  Add('   $("#gbox_' +AnsiUpperCase(NamePrefix)+'").find(".ui-jqgrid-labels").attr("id", "'+AnsiUpperCase(NamePrefix)+'titles");');
  Add('   $("#'+AnsiUpperCase(NamePrefix)+'titles").addClass("d2bridgedbgridrowtitles");');
//  Add('   $("#gbox_' +AnsiUpperCase(NamePrefix)+'").find(".ui-jqgrid-labels > th").addClass("d2bridgedbgridtitle");');
  Add('   $("#PAGER'+ AnsiUpperCase(NamePrefix) +' .ui-pg-input").closest("td").addClass("d-none d-sm-block");');
  Add('   $("#PAGER'+ AnsiUpperCase(NamePrefix) +'").addClass("d2bridgedbgridpager");');
  //Disabled
  if not Enabled then
  begin
   Add('   $("#gbox_' +AnsiUpperCase(NamePrefix)+'").attr("disabled","disabled");');
  end;
  //Invisible
  if not Visible then
  begin
   Add('   $("#gbox_' +AnsiUpperCase(NamePrefix)+'").addClass("invisible");');
  end;
  Add('');
  Add('');
  Add('');
  Add('},');
 end;



 //Event ondblClickRow
 with HTMLText do
 begin
  Add('ondblClickRow: function(rowid, iRow, iCol, e)');
  Add('{');
  Add('   var rowsids = []');
  Add('   rowsids = jqGridSelectedRows($(this).jqGrid("getGridParam", "selarrrow"));');
  Add('   if (!rowsids.includes(rowid.replace("jqg", "")) || iCol != 0) {');
  Add('     rowsids.push(rowid.replace("jqg", ""));');
  Add('     var params = "rowid="+rowid.replace("jqg", "")+"&col="+iCol+"&rowsids="+rowsids;');
  if Assigned(Events.Item(EventOnDblClick)) then
  begin
   Add(Events.Item(EventOnDblClick).EventJS(ExecEventProc, 'params', true));
   Events.Item(EventOnDblClick).AutoPublishedEvent:= false;
  end;
  Add('   }');
  Add('   return true;');
  Add('},');
 end;



 //Event onSelectAll
 with HTMLText do
 begin
  Add('onSelectAll: function(aRowids, status)');
  Add('{');
  Add(' if (SelectedRowIDs'+AnsiUpperCase(NamePrefix)+'.length > 1) {');
  Add('    var params = "selecttype=unselectall";');
  Add('    SelectedRowIDs'+AnsiUpperCase(NamePrefix)+' = [];');
  Add('    DBGrid.jqGrid("resetSelection");');
  if Assigned(Events.Item(EventOnselect)) then
  Add(Events.Item(EventOnselect).EventJS(ExecEventProc, 'params', true));
  Add(' } else {');
  Add('    if (status === true) {');
  Add('       var params = "selecttype=selectall";');
  Add('       SelectedRowIDs'+AnsiUpperCase(NamePrefix)+' = [];');
  if Assigned(Events.Item(EventOnSelect)) then
  Add(Events.Item(EventOnSelect).EventJS(ExecEventProc, 'params', true));
  Add('    } else {');
  Add('       var params = "selecttype=unselectall";');
  Add('       SelectedRowIDs'+AnsiUpperCase(NamePrefix)+' = [];');
  if Assigned(Events.Item(EventOnselect)) then
  Add(Events.Item(EventOnselect).EventJS(ExecEventProc, 'params', true));
  Add('    }');
  Add(' }');
  Add('},');
 end;



 //Event LoadError
 with HTMLText do
 begin
  Add('loadError: function (xhr, status, error) {');
  Add('    console.error("Error in Grid", status, error);');
  Add('},');
 end;


// //Event afterSubmitCell
// with HTMLText do
// begin
//  Add('afterSubmitCell: function (serverresponse, rowid, cellname, value, iRow, iCol) {');
//  Add('    var response = $.parseJSON(serverresponse.responseText);');
//  Add('    if (response && response.error) {');
//  Add('        return [false, ""];');
//  Add('    }');
//  Add('    return [true, ""];');
//  Add('},');
// end;


 //Event onSelectRow
// with HTMLText do
// begin
//  Add('onSelectRow: function(id){');
//  Add('  if(id && id !== lastEditRowID'+AnsiUpperCase(NamePrefix)+'){');
////  Add('    if(lastEditRowID'+AnsiUpperCase(NamePrefix)+' !== null) {');
////  Add('        $(this).jqGrid(''saveRow'',lastEditRowID'+AnsiUpperCase(NamePrefix)+');');
////  Add('    }');
//  Add('    if (ColEditable'+AnsiUpperCase(NamePrefix)+') { ');
//  Add('        $(this).jqGrid(''editRow'',id);');
//  Add('      lastEditRowID'+AnsiUpperCase(NamePrefix)+' = id;');
//   Add('     setTimeout(function() {');
//  Add('           lastCellContent'+AnsiUpperCase(NamePrefix)+'.target.lastChild.focus();');
//   Add('     }, 0);');
//  Add('    }');
//  Add('  }');
//  Add('},');
// end;


 //Event formatoptions
 with HTMLText do
 begin
  Add('ajaxRowOptions: {');
  Add('  contentType: "application/json; charset=utf-8",');
  Add('  success: function (data, textStatus) {');
  Add('    if(textStatus=="success")');
  Add('    {');
  Add('      DBGrid.restoreRow(lastEditRowID'+AnsiUpperCase(NamePrefix)+');');
  Add('      var params = "rowid="+nextEditRowID'+AnsiUpperCase(NamePrefix)+'+"&col="+nextEditCol'+AnsiUpperCase(NamePrefix)+'+"&rowsids="+nextEditRowID'+AnsiUpperCase(NamePrefix)+'+"&selecttype=select";');
  Add('      if (nextEditRowID'+AnsiUpperCase(NamePrefix)+' !== null) {');
  Add('         SelectedRowIDs'+AnsiUpperCase(NamePrefix)+' = [nextEditRowID'+AnsiUpperCase(NamePrefix)+'];');
  Add('      } else {');
  Add(         'SelectedRowIDs'+AnsiUpperCase(NamePrefix)+' = [];');
  Add('      }');
  if Assigned(Events.Item(EventOnSelect)) then
  Add(Events.Item(EventOnSelect).EventJS(ExecEventProc, 'params', true));
  Add('      if (ColEditable'+AnsiUpperCase(NamePrefix)+' && nextEditRowID'+AnsiUpperCase(NamePrefix)+' !== null) { ');
//  Add('         DBGrid.jqGrid("setSelection", nextEditRowID'+AnsiUpperCase(NamePrefix)+', false);');
  Add('          DBGrid.jqGrid(''editRow'', nextEditRowID'+AnsiUpperCase(NamePrefix)+', nextEditCol'+AnsiUpperCase(NamePrefix)+');');
  Add('          lastEditRowID'+AnsiUpperCase(NamePrefix)+' = nextEditRowID'+AnsiUpperCase(NamePrefix)+';');
  Add('          nextEditRowID'+AnsiUpperCase(NamePrefix)+' = null;');
  Add('         setTimeout(function() {');
  Add('              lastCellContent'+AnsiUpperCase(NamePrefix)+'.target.lastChild.focus();');
  Add('         }, 0);');
  Add('      }');
  Add('      else {');
  Add('          lastEditRowID'+AnsiUpperCase(NamePrefix)+' = null;');
  Add('          nextEditRowID'+AnsiUpperCase(NamePrefix)+' = null;');
  Add('      }');
  Add('    }');
  Add('    else');
  Add('    {');
  Add('');
  Add('    }');
  Add('  },');

  Add('  error: function(rowId, response) {');
  Add('    var jsonData = JSON.parse(rowId.responseText);');
  Add('    if (jsonData) {');
  Add('      var status = jsonData.status;');
  Add('      var errorMessage = jsonData.errormessage;');
  Add('      var errorrowId = jsonData.rowid;');
  Add('    }');
  Add('         DBGrid.jqGrid("resetSelection");');
  Add('         SelectedRowIDs'+AnsiUpperCase(NamePrefix)+' = [lastEditRowID'+AnsiUpperCase(NamePrefix)+'];');
  Add('         nextEditRowID'+AnsiUpperCase(NamePrefix)+' = null;');
  Add('         DBGrid.jqGrid("setSelection", lastEditRowID'+AnsiUpperCase(NamePrefix)+', false);');
//  Add('    var editedRowId = jQuery("#' + AnsiUpperCase(NamePrefix) + '").getGridParam("selrow");');
//  Add('    jQuery("#' + AnsiUpperCase(NamePrefix) + '").restoreRow(editedRowId);');
//  Add('    lastEditRowID'+AnsiUpperCase(NamePrefix)+' = errorrowId;');
//  Add('    jQuery("#' + AnsiUpperCase(NamePrefix) + '").setSelection(errorrowId);');

  Add('    if (status == "error") {');
  Add('      $(this).jqGrid("restoreRow", lastEditRowID'+AnsiUpperCase(NamePrefix)+');');
  Add('      Swal.fire({');
  Add('        icon: "error",');
  Add('        title: "Oops...",');
  Add('        text: errorMessage');
  Add('      }).then(function () {');

  Add('      });');
  Add('    }');

  Add('  }');

  Add('},');
 end;


 //Event beforeSaveCell
 with HTMLText do
 begin
  Add('beforeSaveCell: function (rowid, cellname, value, iRow, iCol) {');
  Add('    return true;');
  Add('},');
 end;


 //End JQGrid
 HTMLText.Add('});');

 //End Function
 HTMLText.Add('});');

 with HTMLText do
 begin
  Add('function '+AnsiUpperCase(NamePrefix)+'_onlinkClick(type, id) {');
  Add('}');
 end;

 //Cell ButtonClick Method
 with HTMLText do
 begin
  Add('function '+AnsiUpperCase(NamePrefix)+'_CellButtonClick(ColIndex,CellButtonElement) {');
  Add('   const dropdownname = CellButtonElement.id + "dropdown";');
  Add('   const dropdown = CellButtonElement.parentElement.querySelector(`#${dropdownname}`);');
  Add('   if (dropdown) {');
  Add('       const gbox_' +AnsiUpperCase(NamePrefix)+' = document.getElementById("gbox_' +AnsiUpperCase(NamePrefix)+'");');
  Add('       if (gbox_' +AnsiUpperCase(NamePrefix)+') {');
  Add('         refreshcellbuttonclick'+AnsiUpperCase(NamePrefix)+' = true;');
  Add('         gbox_' +AnsiUpperCase(NamePrefix)+'.appendChild(dropdown);');
  Add('           setTimeout(() => {');
  Add('              CellButtonElement.click();');
  Add('              CellButtonElement.click();');
  Add('           refreshcellbuttonclick'+AnsiUpperCase(NamePrefix)+' = false;');
  Add('           }, 1);');
  Add('       }');
  Add('   }');
  Add('   if (!refreshcellbuttonclick'+AnsiUpperCase(NamePrefix)+') {');
  Add('      var rowid = CellButtonElement.getAttribute("recno");');
  Add('      var params = "rowid="+rowid+"&ColIndex="+ColIndex+"&CellButtonElementID="+CellButtonElement.id;');
  if Assigned(Events.Item(EventOnCellButtonClick)) then
  Add('      '+Events.Item(EventOnCellButtonClick).EventJS(ExecEventProc, 'params', true));
  Add('   }');
  Add('}');
 end;


 //Navigator Bar Buttons Events
 with HTMLText do
 begin
  Add('$(document).ready(function() {');

  //Button First
  Add('    $("#first_PAGER'+AnsiUpperCase(NamePrefix)+'").click(function () {');
  Add('        if ($("#'+AnsiUpperCase(NamePrefix)+'").getGridParam("savedRow") !== null && lastEditRowID'+AnsiUpperCase(NamePrefix)+' !== null) {');
  Add('            $("#'+AnsiUpperCase(NamePrefix)+'").restoreRow($("#'+AnsiUpperCase(NamePrefix)+'").getGridParam("selrow"));');
  Add('               firstEditRowID'+AnsiUpperCase(NamePrefix)+' = null;');
  Add('               firstEditCol'+AnsiUpperCase(NamePrefix)+' = null;');
  Add('               lastEditRowID'+AnsiUpperCase(NamePrefix)+' = null;');
  Add('               SelectedCol'+AnsiUpperCase(NamePrefix)+' = null;');
  Add('               setTimeout(function() {');
  Add('                    $("#first_PAGER'+AnsiUpperCase(NamePrefix)+'").click();');
  Add('               }, 1);');
  Add('        }');
  Add('    });');


  //Button Prev
  Add('    $("#prev_PAGER'+AnsiUpperCase(NamePrefix)+'").click(function () {');
  Add('        if ($("#'+AnsiUpperCase(NamePrefix)+'").getGridParam("savedRow") !== null && lastEditRowID'+AnsiUpperCase(NamePrefix)+' !== null) {');
  Add('            $("#'+AnsiUpperCase(NamePrefix)+'").restoreRow($("#'+AnsiUpperCase(NamePrefix)+'").getGridParam("selrow"));');
  Add('               prevEditRowID'+AnsiUpperCase(NamePrefix)+' = null;');
  Add('               prevEditCol'+AnsiUpperCase(NamePrefix)+' = null;');
  Add('               lastEditRowID'+AnsiUpperCase(NamePrefix)+' = null;');
  Add('               SelectedCol'+AnsiUpperCase(NamePrefix)+' = null;');
  Add('               setTimeout(function() {');
  Add('                    $("#prev_PAGER'+AnsiUpperCase(NamePrefix)+'").click();');
  Add('               }, 1);');
  Add('        }');
  Add('    });');


  //Button Next
  Add('    $("#next_PAGER'+AnsiUpperCase(NamePrefix)+'").click(function () {');
  Add('        if ($("#'+AnsiUpperCase(NamePrefix)+'").getGridParam("savedRow") !== null && lastEditRowID'+AnsiUpperCase(NamePrefix)+' !== null) {');
  Add('            $("#'+AnsiUpperCase(NamePrefix)+'").restoreRow($("#'+AnsiUpperCase(NamePrefix)+'").getGridParam("selrow"));');
  Add('               nextEditRowID'+AnsiUpperCase(NamePrefix)+' = null;');
  Add('               nextEditCol'+AnsiUpperCase(NamePrefix)+' = null;');
  Add('               lastEditRowID'+AnsiUpperCase(NamePrefix)+' = null;');
  Add('               SelectedCol'+AnsiUpperCase(NamePrefix)+' = null;');
  Add('               setTimeout(function() {');
  Add('                    $("#next_PAGER'+AnsiUpperCase(NamePrefix)+'").click();');
  Add('               }, 1);');
  Add('        }');
  Add('    });');


  //Button Last
  Add('    $("#last_PAGER'+AnsiUpperCase(NamePrefix)+'").click(function () {');
  Add('        if ($("#'+AnsiUpperCase(NamePrefix)+'").getGridParam("savedRow") !== null && lastEditRowID'+AnsiUpperCase(NamePrefix)+' !== null) {');
  Add('            $("#'+AnsiUpperCase(NamePrefix)+'").restoreRow($("#'+AnsiUpperCase(NamePrefix)+'").getGridParam("selrow"));');
  Add('               lastEditRowID'+AnsiUpperCase(NamePrefix)+' = null;');
  Add('               lastEditCol'+AnsiUpperCase(NamePrefix)+' = null;');
  Add('               lastEditRowID'+AnsiUpperCase(NamePrefix)+' = null;');
  Add('               SelectedCol'+AnsiUpperCase(NamePrefix)+' = null;');
  Add('               setTimeout(function() {');
  Add('                    $("#last_PAGER'+AnsiUpperCase(NamePrefix)+'").click();');
  Add('               }, 1);');
  Add('        }');
  Add('    });');


  Add('});');
 end;



 HTMLText.Add('</script>');

 //Form.HeadHTMLPrism:= HEADHTML;

 HTMLControl:= HTMLText.Text;

 HTMLText.Free;
end;


function TPrismDBGrid.RecNo: integer;
begin
 Result:= -1;

 if Assigned(FPrismDataLink.DataSource) then
 if Assigned(FPrismDataLink.DataSet) then
 if FPrismDataLink.DataSet.Active then
 begin
  Result:= FPrismDataLink.DataSet.RecNo;
 end;
end;

function TPrismDBGrid.RecNo(AValue: Integer): boolean;
begin
 Result:= false;

 if AValue = 0 then
   Exit;

 if Assigned(FPrismDataLink.DataSource) then
 if Assigned(FPrismDataLink.DataSet) then
 if FPrismDataLink.DataSet.Active then
 begin
  try
   if FPrismDataLink.DataSet.RecNo <> AValue then
   FPrismDataLink.DataSet.RecNo:= AValue;

   Result:= true;
  except
   Result:= false;
  end;
 end;

 FStoredRecNo:= AValue;
end;

procedure TPrismDBGrid.ReloadGrid;
begin
 Session.ExecJS('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).trigger("reloadGrid", { fromServer: true, page: 1 } );');
end;

function TPrismDBGrid.SelectedRowsIDStr: string;
var
 I: integer;
begin
 Result:= '';

 for I := 0 to Pred(SelectedRowsID.Count) do
  if result <> '' then
   result:= result + ',' + IntToStr(SelectedRowsID[I])
  else
   result:= IntToStr(SelectedRowsID[I]);

  result:= '['+ result + ']';
end;

procedure TPrismDBGrid.SetDataSource(const Value: TDataSource);
begin
 if FPrismDataLink.DataSource <> Value then
 begin
  if Assigned(FPrismDataLink.DataSource) then
  begin
   //FPrismDataLink.DataSource.RemoveFreeNotification(Self);
  end;

  FPrismDataLink.DataSource := Value;

//  if Assigned(FPrismDataLink.DataSource) then
//    FPrismDataLink.DataSource.FreeNotification(Self);
 end;
end;

procedure TPrismDBGrid.SetDataToJSON;
var
 vJSONData: String;
 vJSONArrayColumns, vJSONDataArray: TJSONArray;
 Pos: Integer;
 vControlsEnabled: boolean;
 vBookmark: TBookmark;
 vHasBookmark: Boolean;
begin
 vJSONData:= '[]';

 if Assigned(FPrismDataLink.DataSource) then
 if Assigned(FPrismDataLink.DataSet) then
 if FPrismDataLink.DataSet.Active then
 if FPrismDataLink.DataSet.RecordCount > 0 then
 begin
  vHasBookmark := False;

  try
   vBookmark := FPrismDataLink.DataSet.GetBookmark;
   vHasBookmark := True;
  except
  end;

  if not vHasBookmark then
   Pos:= FPrismDataLink.DataSet.RecNo;
  FPrismDataLink.DataSet.DisableControls;
  FPrismDataLink.DataSet.First;

  try
   try
    vJSONArrayColumns:= Columns.ColumnsNameToJSON;
    vJSONDataArray:= FPrismDataLink.DataSet.DataSetToJSON(vJSONArrayColumns, MaxRecords, false, Session.FormatSettings, true);
    vJSONData:= vJSONDataArray.ToJSON;
    vJSONArrayColumns.Free;
    vJSONDataArray.Free;
   except
   end;
  finally
   try
    if Assigned(FPrismDataLink.DataSource) then
    if Assigned(FPrismDataLink.DataSet) then
    if FPrismDataLink.DataSet.Active then
    begin
     if vHasBookmark then
     begin
      if FPrismDataLink.DataSet.BookmarkValid(vBookmark) then
       FPrismDataLink.DataSet.GotoBookmark(vBookmark);
      FPrismDataLink.DataSet.FreeBookmark(vBookmark);
     end else
      FPrismDataLink.DataSet.RecNo:= Pos;
    end;

    try
     vControlsEnabled:= false;

     repeat
      if Assigned(FPrismDataLink.DataSource) then
      if Assigned(FPrismDataLink.DataSet) then
      if FPrismDataLink.DataSet.Active then
      begin
       try
        FPrismDataLink.DataSet.EnableControls;
        vControlsEnabled:= true;
       except
        vControlsEnabled:= false;
       end;
      end else
      sleep(100);
     until vControlsEnabled;
    except

    end;
   except

   end;
  end;
 end;

 FJSONData:= vJSONData;
 vJSONData:= '';
end;

procedure TPrismDBGrid.SetSelectedRowsID(Value: TList<Integer>);
var
 vValue: integer;
begin
 FSelectedRowsID.Clear;

 for vValue in Value do
  FSelectedRowsID.Add(vValue);
end;

procedure TPrismDBGrid.UpdateData;
begin
 if Form.FormPageState <> PageStateUnloaded then
  SetDataToJSON;

 if Form.FormPageState = PageStateLoaded then
  FRefreshData:= true;
end;

procedure TPrismDBGrid.UpdateRow(aRecNo: Integer; aJSONData: string);
begin
 if Form.FormPageState = PageStateLoaded then
 begin
  if aRecNo = -1 then
  begin
   FRefreshRow:= Default(TUpdateRowData);
  end else
  if not FRefreshRow.Update then
  begin
   FRefreshRow.Update:= true;
   FRefreshRow.RecNo:= aRecNo;
   FRefreshRow.JSONData:= aJSONData;
  end else
   UpdateData;
 end;
end;

procedure TPrismDBGrid.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
var
 NewRecNo: Integer;
 NewEditable, NewSelectedRow: Boolean;
 NewEnabled, NewVisible: boolean;
 vColumnsDict: TDictionary<string,string>;
 I: Integer;
begin
 if (Form.FormPageState = PageStateLoaded) and FRefreshDataOnLoad then
 begin
  FRefreshDataOnLoad:= false;
  UpdateData;
 end;


 NewEnabled:= Enabled;
 if (NewEnabled <> FStoredEnabled) then
 begin
  if NewEnabled then
  begin
   ScriptJS.Add('$("#gbox_' +AnsiUpperCase(NamePrefix)+'").removeAttr("disabled");');
  end else
  begin
   ScriptJS.Add('$("#gbox_' +AnsiUpperCase(NamePrefix)+'").attr("disabled","disabled");');
  end;
 end;


 NewVisible:= Visible;
 if (NewVisible <> FStoredVisible) then
 begin
  if NewVisible then
  begin
   ScriptJS.Add('$("#gbox_' +AnsiUpperCase(NamePrefix)+'").removeClass("invisible");');
  end else
  begin
   ScriptJS.Add('$("#gbox_' +AnsiUpperCase(NamePrefix)+'").addClass("invisible");');
  end;
 end;



 NewEditable:= Editable;
 if (NewEditable <> FStoredEditable) then
 begin
  FStoredEditable:= NewEditable;

  if MultiSelect then
  begin
   ScriptJS.Add('$("#gbox_' +AnsiUpperCase(NamePrefix) + ' th:nth-child(1)").show();');
   ScriptJS.Add('$("#gbox_' +AnsiUpperCase(NamePrefix) + ' td:nth-child(1)").show();');
  end;

  ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).restoreRow($("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).getGridParam("selrow"));');

  ScriptJS.Add('SelectedCol'+AnsiUpperCase(NamePrefix)+' = -1;');
  ScriptJS.Add('lastEditRowID'+AnsiUpperCase(NamePrefix)+' = null;');

  vColumnsDict:= ColModelToList;
  for I := 0 to Pred(vColumnsDict.Count) do
   ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).jqGrid("setColProp", "'+ vColumnsDict.Keys.ToArray[I]+'", ' + vColumnsDict.Values.ToArray[I] + ');');
  vColumnsDict.Free;

  ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).jqGrid("setGridParam", '+
    '"{ editable: '+ BoolToStr(FStoredEditable, True).ToLower +
     ', celledit: ' + BoolToStr(FStoredEditable, True).ToLower + '}");');

  ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";})');
  ScriptJS.Add('.jqGrid("clearGridData")');
  ScriptJS.Add('.jqGrid("setGridParam", { data: ' + FJSONData + ' })');
  ScriptJS.Add('.trigger("reloadGrid", { page: 1 });');

  //ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).trigger("reloadGrid", { fromServer: false, page: 1 } );');
 end;



 if Assigned(FPrismDataLink.DataSource) then
 if Assigned(FPrismDataLink.DataSet) then
 if FPrismDataLink.DataSet.Active then
 begin
  if (Form.FormPageState = PageStateLoaded) or (AForceUpdate) or
     ((Form.FormPageState = PageStateLoaded) and (FRefreshData)) then
  begin
   if (FRefreshData) or (AForceUpdate) then
   begin
//    //ScriptJS.Add('GetJSONData'+AnsiUpperCase(NamePrefix)+'().then((result) => { setTimeout(() => {JSONData'+AnsiUpperCase(NamePrefix)+' = result}, 0);});');
//    ScriptJS.Add('$("#'+ AnsiUpperCase(NamePrefix) +'").jqGrid("clearGridData");');
//    if not MultiSelect then
//    ScriptJS.Add('$("#'+ AnsiUpperCase(NamePrefix) +'").jqGrid("setGridParam", { multiselect: true });')
//    else
//    ScriptJS.Add('$("#'+ AnsiUpperCase(NamePrefix) +'").jqGrid("setGridParam", { multiselect: false });');
//    ScriptJS.Add('$("#'+ AnsiUpperCase(NamePrefix) +'").jqGrid("setGridParam", { rowNum: '+ IntToStr(FRecordsPerPage) + '});');
//    //ScriptJS.Add('$("#'+ AnsiUpperCase(NamePrefix) +'").jqGrid("setGridParam", { data: GetJSONData'+AnsiUpperCase(NamePrefix)+'() });');

    ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).restoreRow($("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).getGridParam("selrow"));');

    ScriptJS.Add('SelectedCol'+AnsiUpperCase(NamePrefix)+' = -1;');
    ScriptJS.Add('SelectedRowIDs'+AnsiUpperCase(NamePrefix)+' = [];');

    vColumnsDict:= ColModelToList;
    for I := 0 to Pred(vColumnsDict.Count) do
     ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).jqGrid("setColProp", "'+ vColumnsDict.Keys.ToArray[I]+'", ' + vColumnsDict.Values.ToArray[I] + ');');
    vColumnsDict.Free;

    //ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).trigger("reloadGrid", { fromServer: true, page: 1 } );');
    ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";})');
    ScriptJS.Add('.jqGrid("clearGridData")');
    ScriptJS.Add('.jqGrid("setGridParam", { data: ' + FJSONData + ' })');
    ScriptJS.Add('.trigger("reloadGrid", { page: 1 });');
   end else
   if (FRefreshRow.Update) then
   begin
    ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).jqGrid("setRowData", "' + IntToStr(FRefreshRow.RecNo) + '", ' + FRefreshRow.JSONData + ');');
   end;
  end;


  FRefreshData:= false;
  FRefreshRow.Update := false;
 end else
 begin
  if (Form.FormPageState = PageStateLoaded) or (AForceUpdate) then
  begin
   if (FRefreshData) or (AForceUpdate) then
   begin
    //ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).trigger("reloadGrid", { page: 1 } );');
    ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";})');
    ScriptJS.Add('.jqGrid("clearGridData")');
    ScriptJS.Add('.jqGrid("setGridParam", { data: ' + FJSONData + ' })');
    ScriptJS.Add('.trigger("reloadGrid", { page: 1 });');
   end;

   FRefreshData:= false;
   FRefreshRow.Update := false;
  end;
 end;


 inherited;
end;

{$ELSE}
implementation
{$ENDIF}

end.