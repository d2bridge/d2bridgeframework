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

unit Prism.JSONHelper;


interface


uses
  Classes, SysUtils, D2Bridge.JSON,
{$IFNDEF FPC}
  {$IFDEF HAS_UNIT_SYSTEM_NETENCODING}
  System.NetEncoding,
  {$ELSE}
  EncdDecd,
  {$ENDIF}
{$ELSE}
  base64,
{$ENDIF}
{$IFDEF FMX}
  FMX.Grid,
{$ELSE}
  Grids,
{$ENDIF}
  DB;

type
  TDataSetHelper = class helper for TDataSet
  public
    function DataSetToJSON: TJSONArray; overload;
    function DataSetToJSON(AColumns: TJSONArray; MaxRecords: Integer; SkipeInvisibleFields: boolean; AFormatSettings: TFormatSettings; IncludeRecNOCol: boolean = false): TJSONArray; overload;
    procedure SaveToJSON(aFileName : string);
  end;

  TStringGridHelper = class helper for TStringGrid
  public
    function StringGridToJson: TJSONArray; overload;
    function StringGridToJson(AColumns: TJSONArray; MaxRecords: Integer; AFormatSettings: TFormatSettings; IncludeRecNOCol: boolean = false): TJSONArray; overload;
    procedure SaveToJSON(aFileName: string);
  end;

implementation

uses
  Prism.Util;

{ TDataSetHelper }

function TDataSetHelper.DataSetToJSON: TJSONArray;
var
  lCols:       Integer;
  lHexString:  string;
  lByteValue:  Byte;
  lStreamIn:   TStream;
  lStreamOut:  TStringStream;
  lJSONArray:  TJSONArray;
  lJSONObject: TJSONObject;
{$IFDEF FPC}
  Encoder:     TBase64EncodingStream;
{$ENDIF}
begin
  lJSONArray:= TJSONArray.Create;

  try
    Self.First;
    while not Self.Eof do
      begin
        lJSONObject:= TJSONObject.Create;
        lJSONArray.Add(lJSONObject);

        for lCols := 0 to Pred(FieldCount) do
          begin
            if Self.Fields[lCols].IsNull then
              lJSONObject.AddPair(Self.Fields[lCols].FieldName, TJSONNull.Create)
            else
              case Fields[lCols].DataType of
                ftBlob:
                  begin
                    lStreamIn := CreateBlobStream(Fields[lCols], bmRead);
                    lStreamOut := TStringStream.Create;
                    lStreamIn.Position:= 0;

{$IFNDEF FPC}
  {$IFDEF HAS_UNIT_SYSTEM_NETENCODING}
                    TNetEncoding.Base64.Encode(lStreamIn, lStreamOut);
  {$ELSE}
                    EncodeStream(lStreamIn, lStreamOut);
  {$ENDIF}
{$ELSE}
                    Encoder:= TBase64EncodingStream.Create(lStreamOut);
                    Encoder.CopyFrom(lStreamIn, lStreamIn.Size);
                    Encoder.Flush;
{$ENDIF}

                    lStreamOut.Position:= 0;

                    lJSONObject.AddPair(Self.Fields[lCols].FieldName, lStreamOut.DataString);
                    lStreamOut.Free;
                  end;
                ftBoolean:
                  begin
                    if Fields[lCols].AsBoolean then
                      lJSONObject.AddPair(Self.Fields[lCols].FieldName, GetTJSONTrue)
                    else
                      lJSONObject.AddPair(Self.Fields[lCols].FieldName, GetTJSONFalse);
                  end;
                // númericos
                ftFloat{$IFDEF SUPPORTS_FTEXTENDED}, ftExtended{$ENDIF}, ftFMTBcd, ftBCD:
                  lJSONObject.AddPair(Self.Fields[lCols].FieldName, TJSONFloatNumber.Create(Fields[lCols].AsFloat));
                ftCurrency:
                  lJSONObject.AddPair(Self.Fields[lCols].FieldName, TJSONFloatNumber.Create(Fields[lCols].AsCurrency));
                ftSmallint{$IFDEF SUPPORTS_FTEXTENDED}, ftShortint, ftSingle{$ENDIF}, ftWord, ftInteger, ftAutoInc,
                ftLargeint{$IFDEF SUPPORTS_FTEXTENDED}, ftLongWord{$ENDIF}:
                  lJSONObject.AddPair(Self.Fields[lCols].FieldName, TJSONInt64Number.Create(Int64(Fields[lCols].Value)));
                //string
                ftString, ftFmtMemo, ftMemo, ftWideString, ftWideMemo, ftUnknown :
                  lJSONObject.AddPair(Self.Fields[lCols].FieldName, Trim(Fields[lCols].Value));
                // DateTime
                ftDateTime:
                  begin
//                          var lFS : TFormatSettings;
//                          lFS := TFormatSettings.Create('pt-BR');
//                          lFS.ShortDateFormat := 'mm/dd/yyyy';
                    lJSONObject.AddPair(Self.Fields[lCols].FieldName, FormatDatetime('DD/MM/YYYY hh:nn:ss', Self.Fields[lCols].AsDateTime));
                  end;
                ftDate:
                  lJSONObject.AddPair(Self.Fields[lCols].FieldName, FormatDatetime('DD/MM/YYYY', Self.fields[lcols].AsDateTime));
                ftTime, ftTimeStamp:
                  lJSONObject.AddPair(Self.Fields[lCols].FieldName, FormatDatetime('hh:hh:ss', Self.Fields[lCols].AsDateTime));

                ftBytes:
                begin
                  LHexString:= EmptyStr;

                  for LByteValue in Self.Fields[lCols].AsBytes do
                    LHexString:= LHexString + IntToHex(LByteValue, 2);

                  lJSONObject.AddPair(Self.Fields[lCols].FieldName, LHexString);
                end;
              end;
          end;

        Self.Next;
      end;

    Result:= lJSONArray.NewClone as TJSONArray;
  finally
    lJSONArray.Free;
  end;
end;

function TDataSetHelper.DataSetToJSON(AColumns: TJSONArray; MaxRecords: Integer; SkipeInvisibleFields: boolean; AFormatSettings: TFormatSettings; IncludeRecNOCol: boolean): TJSONArray;
begin
 result:= D2Bridge.JSON.DataSetToJSON(Self, AColumns, MaxRecords, SkipeInvisibleFields, AFormatSettings, IncludeRecNOCol);
end;


procedure TDataSetHelper.SaveToJSON(aFileName: string);
var
  S: TStringList;
begin
  S:= TStringList.Create;
  S.Clear;
  S.Add(DataSetToJSON.ToJSON());
  S.SaveToFile(aFileName);

  S.Free;
end;

{ TStringGridHelper }

function TStringGridHelper.StringGridToJson: TJSONArray;
var
  lCols : integer;
  lJSONArray:  TJSONArray;
  lJSONObject: TJSONObject;
  nRowCount, nColCount, nRegistro: integer;
begin
  lJSONArray:= TJSONArray.Create;

  try
    nRowCount:= Self.RowCount;
    nColCount:= Self.{$IFNDEF FMX}ColCount{$ELSE}ColumnCount{$ENDIF};

    for nRegistro:= {$IFNDEF FMX}1{$ELSE}0{$ENDIF} to Pred(nRowCount) do
    begin
      lJSONObject:= TJSONObject.Create;
      lJSONArray.Add(lJSONObject);

      for lCols := 0 to Pred(nColCount) do
      begin
        lJSONObject.AddPair({$IFNDEF FMX}Self.Cells[lCols, 0]{$ELSE}Self.Columns[lCols].Header{$ENDIF}, Trim(Self.Cells[lCols, nRegistro]));
      end;
    end;

    Result:= lJSONArray.NewClone as TJSONArray;
  finally
    lJSONArray.Free;
  end;
end;

function TStringGridHelper.StringGridToJson(AColumns: TJSONArray; MaxRecords: Integer; AFormatSettings: TFormatSettings; IncludeRecNOCol: boolean): TJSONArray;
var
  lCols, lColsArray, I : integer;
  lColName: string;
  lJSONArray:  TJSONArray;
  lJSONObject: TJSONObject;
  FieldExist: Boolean;
  lCountRecordsExported: integer;
  nRowCount, nColCount, nRegistro: integer;
begin
  lCountRecordsExported:= 0;
  lJSONArray:= TJSONArray.Create;

  try
    try
      nRowCount:= Self.RowCount;
      nColCount:= Self.{$IFNDEF FMX}ColCount{$ELSE}ColumnCount{$ENDIF};

      if (MaxRecords > 0) and ((nRowCount {$IFNDEF FMX} - 1{$ENDIF}) > MaxRecords) then
        nRowCount:= MaxRecords {$IFNDEF FMX} + 1{$ENDIF};

      for nRegistro:= {$IFNDEF FMX}1{$ELSE}0{$ENDIF} to Pred(nRowCount) do
      begin
        if lCountRecordsExported > MaxRecords then
          Break;

        Inc(lCountRecordsExported);

        lJSONObject:= TJSONObject.Create;
        lJSONArray.Add(lJSONObject);

        for lColsArray:= 0 to Pred(AColumns.Count) do
        begin
          lColName:= AColumns.Items[lColsArray].Value;

          FieldExist:= false;
          for I := 0 to Pred(nColCount) do
          if SameText(lColName, {$IFNDEF FMX}Self.Cells[I, 0]{$ELSE}Self.Columns[I].Header{$ENDIF}) then
          begin
            FieldExist:= true;
            lCols:= I;
            break;
          end;

          if not FieldExist then
            lJSONObject.AddPair(lColName, TJSONNull.Create)
          else
            lJSONObject.AddPair(lColName, Trim(Self.Cells[lCols, nRegistro]));
        end;

        if IncludeRecNOCol then
        begin
         lJSONObject.AddPair('PrismRecNo', TJSONIntegerNumber.Create(nRegistro));
        end;
      end;
    except

    end;

    Result:= lJSONArray.NewClone as TJSONArray;
  finally
    lJSONArray.Free;
  end;
end;

procedure TStringGridHelper.SaveToJSON(aFileName: string);
var
  S: TStringList;
begin
  S:= TStringList.Create;
  S.Clear;
  S.Add(StringGridToJson.ToJSON());
  S.SaveToFile(aFileName);

  S.Free;
end;

end.