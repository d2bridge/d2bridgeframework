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

unit Prism.StringGrid;

interface

uses
  Classes, SysUtils, D2Bridge.JSON, Generics.Collections,
{$IFDEF FMX}
  FMX.Grid,
{$ELSE}
  Grids,
{$ENDIF}
  Prism.Forms.Controls, Prism.Interfaces, Prism.Types, Prism.Grid.Columns, Prism.Grid.Columns.Buttons,
  Prism.Grid;


type
 TPrismGridColumn = Prism.Grid.Columns.TPrismGridColumn;
 TPrismGridColumns = Prism.Grid.Columns.TPrismGridColumns;
 TPrismGridColumnButton = Prism.Grid.Columns.Buttons.TPrismGridColumnButton;
 TPrismGridColumnButtons = Prism.Grid.Columns.Buttons.TPrismGridColumnButtons;


type
 TPrismStringGrid = class(TPrismGrid, IPrismStringGrid)
  strict private
   type
    TUpdateRowData = record
     Update: boolean;
     RecNo: Integer;
     JSONData: string;
    end;
  private
   FProcGetSelectedRow: TOnGetValue;
   FProcSetSelectedRow: TOnSetValue;
   FProcGetEditable: TOnGetValue;
   FStoredRecNo: Integer;
   FStoredEditable: Boolean;
   FOnLoadJSON: TPrismGetStrEvent;
   FSelectedRowsID: TList<Integer>;
   FRefreshData: Boolean;
   FRefreshRow: TUpdateRowData;
   FJSONData: string;
   FDataLink:  TStringGrid;
   FDataLinkRow: Integer;
   const
    FSelectAll: integer = -9999;
   function GetColumnIndex(aFieldName: String): Integer;
   function GetFieldByName(aFieldName: String): String;
   procedure SetFieldByName(aFieldName: String; aValue: String);
   procedure SetStringGrid(const Value: TStringGrid);
   function GetStringGrid: TStringGrid;
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

   function IsStringGrid: Boolean; override;

   procedure SetDataToJSON; override;
   function GetDataToJSON: String; override;
   procedure CellPostbyJSON(AJSON: string; out ARowID: string; out AErrorMessage: string); override;

   property StringGrid: TStringGrid read GetStringGrid write SetStringGrid;
   property ProcSetSelectedRow: TOnSetValue read FProcSetSelectedRow write FProcSetSelectedRow;
   property ProcGetSelectedRow: TOnGetValue read FProcGetSelectedRow write FProcGetSelectedRow;
   property ProcGetEditable: TOnGetValue read FProcGetEditable write FProcGetEditable;
 end;



implementation

uses
  Prism.Events, Prism.JSONHelper, Prism.Util;

{ TPrismStringGrid }

procedure TPrismStringGrid.CellPostbyJSON(AJSON: string; out ARowID: string; out AErrorMessage: string);
var
 vJSONCellValues: TJSONObject;
 I, J: Integer;
 vRecNO: integer;
 vAlter: Boolean;
 vOperation: String;
 vFieldName, vFieldValue: String;
 vSelectFieldValue: integer;
 vFieldType: TPrismFieldType;
 vColumn: TPrismGridColumn;
begin
 vJSONCellValues:= TJSONObject.ParseJSONValue(AJSON) as TJSONObject;
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
//   if FDataLink.DataSet.RecNo <> vRecNO then
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

//    //Lookup Combobox Desativado para StringGrid - Alterar
//    if vColumn.DataFieldModel in [PrismFieldModelCombobox, PrismFieldModelLookup] then
//    begin
//     TryStrToInt(vFieldValue, vSelectFieldValue);
//
//     //Trata "none"
//     if (vSelectFieldValue > 0) then
//     begin
//      if vColumn.DataFieldModel in [PrismFieldModelCombobox] then
//       vFieldValue:= vColumn.SelectItems.GetValue(vFieldValue).Value
//      else
//      if vColumn.DataFieldModel in [PrismFieldModelLookup] then
//      begin
//       FDataLink.DataSet.FieldByName(vFieldName).LookupDataSet.RecNo:= vSelectFieldValue;
//       //vFieldValue:= FDataLink.DataSet.FieldByName(vFieldName).LookupDataSet.FieldByName(FDataLink.DataSet.FieldByName(vFieldName).LookupKeyFields).AsString;
//       vFieldValue:= FDataLink.DataSet.FieldByName(vFieldName).LookupDataSet.FieldByName(FDataLink.DataSet.FieldByName(vFieldName).LookupResultField).AsString;
//      end;
//     end else
//     begin
//      if (not DataSource.DataSet.FieldByName(vFieldName).IsNull) and
//         (DataSource.DataSet.FieldByName(vFieldName).Value <> '') and
//         (DataSource.DataSet.FieldByName(vFieldName).Value <> '0') then
//      begin
//       vErrorRollback:= true;
//       AErrorMessage:= Format(Lang.Grid.MsgErrorCellNoneValue, [vColumn.Title]);
//       Break;
//      end;
//
//      Continue;
//     end;
//    end;

    vFieldType:= PrismFieldTypeString;

    if (vFieldType in [PrismFieldTypeNumber,PrismFieldTypeInteger,PrismFieldTypeDate,PrismFieldTypeDateTime]) and (vFieldValue = '') then
     vFieldValue:= '0';

    if (vFieldType in [PrismFieldTypeNumber]) and (vFieldValue <> '') and (vFieldValue <> '0') then
     vFieldValue:= FloatToStr(StrToFloat(PrepareFloat(vFieldValue, Session.FormatSettings), Session.FormatSettings), PrismOptions.DataBaseFormatSettings)
    else
     if (vFieldType in [PrismFieldTypeDate]) and (vFieldValue <> '') and (vFieldValue <> '0') then
      vFieldValue:= DateToStr(StrToDate(vFieldValue, Session.FormatSettings), PrismOptions.DataBaseFormatSettings)
     else
      if (vFieldType in [PrismFieldTypeDate,PrismFieldTypeDateTime]) and (vFieldValue <> '') and (vFieldValue <> '0') then
       vFieldValue:= DateTimeToStr(StrToDateTime(vFieldValue, Session.FormatSettings), PrismOptions.DataBaseFormatSettings);

    if Assigned(vColumn) then
    if (vFieldValue <> '') or
       ((vFieldType in [PrismFieldTypeAuto, PrismFieldTypeString]) and (GetFieldByName(vFieldName) <> vFieldValue)) then
    begin
     vAlter:= true;

//     //Lookup Combobox Desativado para StringGrid - Alterar
//      if PrismFieldType(DataSource.DataSet.FieldByName(vFieldName).DataType) = PrismFieldTypeNumber then
//     if (vColumn.DataFieldModel in [PrismFieldModelLookup]) then
//     begin
//      DataSource.DataSet.FieldByName(FDataLink.DataSet.FieldByName(vFieldName).KeyFields).Value:=
//        FDataLink.DataSet.FieldByName(vFieldName).LookupDataSet.FieldByName(FDataLink.DataSet.FieldByName(vFieldName).LookupKeyFields).AsString;
//     end;

     if ((vFieldType in [PrismFieldTypeNumber,PrismFieldTypeInteger,PrismFieldTypeDate,PrismFieldTypeDateTime]) and (vFieldValue = '0')) or
        ((vFieldType in [PrismFieldTypeString,PrismFieldTypeAuto]) and (vFieldValue = '')) then
      SetFieldByName(vFieldName, '')
     else
      SetFieldByName(vFieldName, vFieldValue);
    end;
   except
    AErrorMessage:= Format(Lang.Grid.MsgErrorCellValue, [vFieldValue, vColumn.Title]);
    Break;
   end;
  end;

  if vAlter then
    ReloadGrid;
 end;

 if Assigned(vJSONCellValues) then
  vJSONCellValues.Free;
end;

function TPrismStringGrid.ColModelToList: TDictionary<string,string>;
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

     vItemColumnClasses.Add('d2bridgedbgridcell');

     JSONItemColumn.AddPair('name', Columns.Items[I].ColName);
     JSONItemColumn.AddPair('index', TJSONIntegerNumber.Create(Columns.Items[I].ColumnIndex));
     JSONItemColumn.AddPair('label', '<div class="d2bridgedbgridtitle" style="text-align: ' + vColAlign + ';">'+Columns.Items[I].Title+'</div>');
     JSONItemColumn.AddPair('width', TJSONIntegerNumber.Create(Round(Columns.Items[I].Width * vFatorWidth)));
     JSONItemColumn.AddPair('align', vColAlign);

     //Align
     if Columns.Items[I].Alignment in [PrismAlignLeft, PrismAlignNone, PrismAlignJustified] then
      JSONItemColumn.AddPair('align', 'left')
     else
     if Columns.Items[I].Alignment in [PrismAlignRight] then
      JSONItemColumn.AddPair('align', 'right')
     else
     if Columns.Items[I].Alignment in [PrismAlignCenter] then
      JSONItemColumn.AddPair('align', 'center');

     if Columns.Items[I].DataFieldModel = PrismFieldModelNone then
      Columns.Items[I].DataFieldModel:= PrismFieldModelField;

     if (Columns.Items[I].Editable) and (FStoredEditable) then
     begin
      JSONItemColumn.AddPair('editable', GetTJSONTrue);

      vItemColumnClasses.Add('celleditable');

      JSONItemColumn.AddPair('width', TJSONIntegerNumber.Create(Round((Columns.Items[I].Width + vWidthEditCell) * vFatorWidth)));

//      //Lookup Combobox Desativado para StringGrid - Alterar
//      if Columns.Items[I].DataField <> '' then
//      if Assigned(FDataLink) then
//      if Assigned(FDataLink.DataSet.FindField(Columns.Items[I].DataField)) then
//      begin
//       if (FDataLink.DataSet.FindField(Columns.Items[I].DataField).FieldKind = fkLookup) and
//          Assigned(FDataLink.DataSet.FindField(Columns.Items[I].DataField).LookupDataSet) and
//          (FDataLink.DataSet.FindField(Columns.Items[I].DataField).LookupDataSet.Active) and
//          (FDataLink.DataSet.FindField(Columns.Items[I].DataField).KeyFields <> '') and
//          (FDataLink.DataSet.FindField(Columns.Items[I].DataField).LookupKeyFields <> '') and
//          (FDataLink.DataSet.FindField(Columns.Items[I].DataField).LookupResultField <> '') then
//       begin
//        Columns.Items[I].DataFieldModel:= PrismFieldModelLookup;
//
//        //Adjust Select ICON
//        JSONItemColumn.AddPair('width', TJSONIntegerNumber.Create(Round((Columns.Items[I].Width+vWidthIconSelect) * vFatorWidth)));
//
//        if Assigned(Columns.Items[I].SelectItems) then
//         Columns.Items[I].SelectItems.Free;
//
//        Columns.Items[I].SelectItems:= TJSONObject.Create;
//
//        Columns.Items[I].SelectItems.AddPair('0', '--' + Lang.Combobox.Select + '--');
//
//        LookupRecNo:= FDataLink.DataSet.FindField(Columns.Items[I].DataField).LookupDataSet.RecNo;
//        FDataLink.DataSet.FindField(Columns.Items[I].DataField).LookupDataSet.DisableControls;
//        FDataLink.DataSet.FindField(Columns.Items[I].DataField).LookupDataSet.First;
//
//        repeat
//         Columns.Items[I].SelectItems.AddPair(
//           IntToStr(FDataLink.DataSet.FindField(Columns.Items[I].DataField).LookupDataSet.RecNo),
//           FDataLink.DataSet.FindField(Columns.Items[I].DataField).LookupDataSet.FieldByName(FDataLink.DataSet.FindField(Columns.Items[I].DataField).LookupResultField).AsString
//         );
//
//         FDataLink.DataSet.FindField(Columns.Items[I].DataField).LookupDataSet.Next;
//        until FDataLink.DataSet.FindField(Columns.Items[I].DataField).LookupDataSet.Eof;
//
//        FDataLink.DataSet.FindField(Columns.Items[I].DataField).LookupDataSet.RecNo:= LookupRecNo;
//        FDataLink.DataSet.FindField(Columns.Items[I].DataField).LookupDataSet.EnableControls;
//
//       end;
//      end;


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

//      //Get DataType Desativado para StringGrid - Alterar
//      if Columns.Items[I].DataField <> '' then
//      if Columns.Items[I].DataFieldType = PrismFieldTypeAuto then
//      if Assigned(FDataLink) then
//      begin
//       if Assigned(FDataLink.DataSet.FindField(Columns.Items[I].DataField)) then
//       Columns.Items[I].DataFieldType := PrismFieldType(FDataLink.DataSet.FindField(Columns.Items[I].DataField).DataType);
//      end;
     end else
      JSONItemColumn.AddPair('editable', GetTJSONFalse);

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

     Result.Add(Columns.Items[I].ColName, ResultColJSON);

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

function TPrismStringGrid.ColumnsToColModel: string;
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

constructor TPrismStringGrid.Create(AOwner: TObject);
var
 EventJSON, EventCellPost, EventCellButtonClick: TPrismControlEvent;
begin
 inherited;

 FRefreshData:= false;

 FOnLoadJSON:= GetDataToJSON;

 FSelectedRowsID:= TList<Integer>.Create;

 FDataLinkRow:= 0;

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

destructor TPrismStringGrid.Destroy;
begin
 FreeAndNil(FDataLink);

 FSelectedRowsID.Free;

 inherited;
end;

function TPrismStringGrid.GetStringGrid: TStringGrid;
begin
 result:= FDataLink;
end;

function TPrismStringGrid.GetColumnIndex(aFieldName: String): Integer;
var
  I: integer;
begin
  Result:= -1;

  if Assigned(FDataLink) then
    for I:= 0 to Pred(FDataLink.{$IFNDEF FMX}ColCount{$ELSE}ColumnCount{$ENDIF}) do
      if FDataLink.{$IFNDEF FMX}Cells[I, 0]{$ELSE}Columns[I].Header{$ENDIF} = aFieldName then
        Result:= I;
end;

function TPrismStringGrid.GetDataToJSON: String;
begin
 if FJSONData = '' then
  Result:= '[]'
 else
  Result:= FJSONData;
end;

function TPrismStringGrid.GetEditable: Boolean;
begin
 if Assigned(ProcGetEditable) then
  Result:= ProcGetEditable
 else
  Result:= FStoredEditable;
end;

function TPrismStringGrid.GetEnableComponentState: Boolean;
begin
 Result:= false;
end;

function TPrismStringGrid.GetFieldByName(aFieldName: String): String;
begin
  Result:= '';

  if Assigned(FDataLink) then
    Result:= FDataLink.Cells[GetColumnIndex(aFieldName), FDataLinkRow];
end;

function TPrismStringGrid.GetSelectedRowsID: TList<Integer>;
begin
 Result:= FSelectedRowsID;
end;

procedure TPrismStringGrid.Initialize;
begin
 inherited;

 FStoredRecNo:= RecNo;
 FStoredEditable:= GetEditable;
end;

function TPrismStringGrid.IsStringGrid: Boolean;
begin
 result:= true;
end;

procedure TPrismStringGrid.OnCellButtonClick(EventParams: TStrings);
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

procedure TPrismStringGrid.ProcessComponentState(
  const ComponentStateInfo: TJSONObject);
begin
  inherited;

end;

procedure TPrismStringGrid.ProcessEventParameters(Event: IPrismControlEvent;
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

 if (vSelectType <> 'selectall') and (vSelectType <> 'unselectall') then
 if TryStrToInt(FRowIDStr, FRowID) then
 begin
  if (Event.EventType in [EventOnSelect]) then
  begin
   FRowsID:= TStringList.Create;

   try
    try
     FRowsID.CommaText:= Parameters.Values['rowsids'];
     if FRowsID.CommaText = '' then
      FRowsID.CommaText:= FRowIDStr;

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
          Events.Item(EventOnUnCheck).CallEvent(Parameters);


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
          Events.Item(EventOnCheck).CallEvent(Parameters);

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

procedure TPrismStringGrid.ProcessHTML;
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
  Add('           var params = "rowid="+rowindex+"&col="+iCol+"&rowsids="+rowsids+"&selecttype=unckeck";');
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


function TPrismStringGrid.RecNo: integer;
begin
 Result:= -1;

 if Assigned(FDataLink) then
  Result:= FDataLinkRow;
end;

function TPrismStringGrid.RecNo(AValue: Integer): boolean;
begin
 Result:= false;

 if Assigned(FDataLink) then
 begin
  try
   if FDataLinkRow <> AValue then
   FDataLinkRow:= AValue;

   Result:= true;
  except
   Result:= false;
  end;
 end;

 FStoredRecNo:= AValue;
end;

procedure TPrismStringGrid.ReloadGrid;
begin
 Session.ExecJS('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).trigger("reloadGrid", { fromServer: true, page: 1 } );');
end;

function TPrismStringGrid.SelectedRowsIDStr: string;
var
 I: integer;
begin
 result:= '';

 for I := 0 to Pred(SelectedRowsID.Count) do
  if result <> '' then
   result:= result + ',' + IntToStr(SelectedRowsID[I])
  else
   result:= IntToStr(SelectedRowsID[I]);

  result:= '['+ result + ']';
end;

procedure TPrismStringGrid.SetStringGrid(const Value: TStringGrid);
begin
 if FDataLink <> Value then
  FDataLink := Value;
end;

procedure TPrismStringGrid.SetDataToJSON;
var
 vJSONData: String;
 vJSONArrayColumns, vJSONDataArray: TJSONArray;
 Pos: Integer;
 vControlsEnabled: boolean;
begin
 vJSONData:= '[]';

 try
   if Assigned(FDataLink) then
   begin
    vJSONArrayColumns:= Columns.ColumnsNameToJSON;
    vJSONDataArray:= FDataLink.StringGridToJson(vJSONArrayColumns, MaxRecords, Session.FormatSettings, true);
    vJSONData:= vJSONDataArray.ToJSON;
    vJSONArrayColumns.Free;
    vJSONDataArray.Free;
   end;
 except

 end;

 FJSONData:= vJSONData;
 vJSONData:= '';
end;

procedure TPrismStringGrid.SetFieldByName(aFieldName, aValue: String);
begin
  if Assigned(FDataLink) then
    FDataLink.Cells[GetColumnIndex(aFieldName), FDataLinkRow]:= aValue;
end;

procedure TPrismStringGrid.SetSelectedRowsID(Value: TList<Integer>);
var
 vValue: integer;
begin
 FSelectedRowsID.Clear;

 for vValue in Value do
  FSelectedRowsID.Add(vValue);
 end;

procedure TPrismStringGrid.UpdateData;
begin
 if Form.FormPageState <> PageStateUnloaded then
  SetDataToJSON;

 if Form.FormPageState = PageStateLoaded then
  FRefreshData:= true;
end;

procedure TPrismStringGrid.UpdateRow(aRecNo: Integer; aJSONData: string);
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

procedure TPrismStringGrid.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
var
 NewRecNo: Integer;
 NewEditable, NewSelectedRow: Boolean;
 NewEnabled, NewVisible: boolean;
 vColumnsDict: TDictionary<string,string>;
 I: Integer;
begin
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

 if Assigned(FDataLink) then
 begin
  if (Form.FormPageState = PageStateLoaded) or (AForceUpdate) then
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

end.
