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

{$I D2Bridge.inc}

unit D2Bridge.JSON;

interface

uses
  Classes, SysUtils, Rtti, TypInfo, Variants,
{$IFNDEF FPC}
  {$IFDEF HAS_UNIT_SYSTEM_JSON}
  System.JSON, System.SysConst, System.DateUtils,
  {$ELSE}
  JsonDataObjects_D2Bridge,
  {$ENDIF}
  {$IFDEF HAS_UNIT_SYSTEM_NETENCODING}
  System.NetEncoding,
  {$ELSE}
  EncdDecd,
  {$ENDIF}
{$ELSE}
  fpjson, base64,
{$ENDIF}
  DB;

type
{$IFNDEF FPC}
  {$IFDEF HAS_UNIT_SYSTEM_JSON}
  TJSONValue = System.JSON.TJSONValue;
  TJSONObject = System.JSON.TJSONObject;
  TJSONArray = System.JSON.TJSONArray;
  TJSONNull = System.JSON.TJSONNull;
  TJSONNumber = System.JSON.TJSONNumber;
  TJSONFloatNumber = System.JSON.TJSONNumber;
  TJSONIntegerNumber = System.JSON.TJSONNumber;
  TJSONInt64Number = System.JSON.TJSONNumber;
  TJSONBool = System.JSON.TJSONBool;
  {$IFDEF DELPHIX_SEATTLE_UP}
  TJSONTrue = System.JSON.TJSONBool;
  TJSONFalse = System.JSON.TJSONBool;
  {$ELSE}
  TJSONTrue = System.JSON.TJSONTrue;
  TJSONFalse = System.JSON.TJSONFalse;
  {$ENDIF}
  TJSONString = System.JSON.TJSONString;
  {$ELSE}
  TJSONValue = JsonDataObjects_D2Bridge.TJSONObject;
  TJSONObject = JsonDataObjects_D2Bridge.TJSONObject;
  TJSONArray = JsonDataObjects_D2Bridge.TJSONArray;
  TJSONNull = JsonDataObjects_D2Bridge.TJSONObject;
  TJSONFloatNumber = JsonDataObjects_D2Bridge.TJSONObject;
  TJSONIntegerNumber = JsonDataObjects_D2Bridge.TJSONObject;
  TJSONInt64Number = JsonDataObjects_D2Bridge.TJSONObject;
  TJSONTrue = JsonDataObjects_D2Bridge.TJSONObject;
  TJSONFalse = JsonDataObjects_D2Bridge.TJSONObject;
  TJSONString = JsonDataObjects_D2Bridge.TJSONObject;
  {$ENDIF}
{$ELSE}
  TJSONValue = fpjson.TJSONData;
  TJSONObject = fpjson.TJSONObject;
  TJSONArray = fpjson.TJSONArray;
  TJSONNull = fpjson.TJSONNull;
  TJSONNumber = fpjson.TJSONNumber;
  TJSONFloatNumber = fpjson.TJSONFloatNumber;
  TJSONIntegerNumber = fpjson.TJSONIntegerNumber;
  TJSONInt64Number = fpjson.TJSONInt64Number;
  TJSONTrue = fpjson.TJSONBoolean;
  TJSONFalse = fpjson.TJSONBoolean;
  TJSONString = fpjson.TJSONString;
  TJSONBool = fpjson.TJSONBoolean;
{$ENDIF}

  TJSONValueHelper = class helper for TJSONValue
  public
{$IFDEF FPC}
    class function ParseJSONValue(const aData: string): TJSONValue; overload; static;
{$ENDIF}
{$IF DEFINED(FPC) OR NOT DEFINED(DELPHIX_SEATTLE_UP)}
    function ToJSON: String;
{$IFEND}
    function NewClone: TJSONValue;
  end;


  { TJSONArrayHelper }

  TJSONArrayHelper = class helper for TJSONArray
   public
    procedure ToDataSet(ADataSet: TDataset); overload;
    procedure ToDataSet(ADataSet: TDataset; AFormatSettings: TFormatSettings); overload;
    procedure ToDataSet(ADataSet: TDataset; AExcludeFields: array of string); overload;
    procedure ToDataSet(ADataSet: TDataset; AFormatSettings: TFormatSettings; AExcludeFields: array of string); overload;
  end;



  { TJSONObjectHelper }

  TJSONObjectHelper = class helper for TJSONObject
  public
{$IFNDEF HAS_UNIT_SYSTEM_JSON}
    function AddPair(const aStr: string; const aVal: TJSONValue): TJSONObject; overload;
    function AddPair(const aStr: string; const aVal: Variant): TJSONObject; overload;
{$ENDIF}
{$IFDEF FPC}
    function GetValue(const APath: string; ADefaultValue: String): String; overload;
    function GetValue(const APath: string; ADefaultValue: Boolean): Boolean; overload;
{$ENDIF}
    function GetValue(const APath: string; ADefaultValue: Integer): Integer; overload;
    function GetValue(const APath: string): TJSONValue; overload;
    function GetJsonStringValue(aIndex: Integer): String;
    function GetJsonValue(aIndex: Integer): TJSONValue;
    procedure SetJsonValue(aIndex: Integer; aJSONValue: TJSONValue);
    function AddBase64File(const aStr: string; const aFileName: string): TJSONObject; overload;
    procedure GetBase64File(const aStr: string; const aSaveFileName: string);
    procedure ToDataSet(ADataSet: TDataset; ADataArrayName: string = ''); overload;
    procedure ToDataSet(ADataSet: TDataset; AFormatSettings: TFormatSettings; ADataArrayName: string = ''); overload;
    procedure ToDataSet(ADataSet: TDataset; AExcludeFields: array of string); overload;
    procedure ToDataSet(ADataSet: TDataset; AFormatSettings: TFormatSettings; AExcludeFields: array of string); overload;
    procedure ToDataSet(ADataSet: TDataset; ADataArrayName: string; AExcludeFields: array of string); overload;
    procedure ToDataSet(ADataSet: TDataset; AFormatSettings: TFormatSettings; ADataArrayName: string; AExcludeFields: array of string); overload;
  end;


 TDataSetToJSONHelper = class helper for TDataSet
  public
   function ToJSON: TJSONArray; overload;
   function ToJSON(AExcludeFields: array of string): TJSONArray; overload;
   function ToJSON(AShowMetaData: Boolean): TJSONObject; overload;
   function ToJSON(AExcludeFields: array of string; AShowMetaData: Boolean): TJSONObject; overload;
   function ToJSON(AMaxRecords: Integer; AOffSet: Integer = 0): TJSONArray; overload;
   function ToJSON(AExcludeFields: array of string; AMaxRecords: Integer; AOffSet: Integer = 0): TJSONArray; overload;
   function ToJSON(AMaxRecords: Integer; AOffSet: Integer; AShowMetaData: Boolean): TJSONObject; overload;
   function ToJSON(AExcludeFields: array of string; AMaxRecords: Integer; AOffSet: Integer; AShowMetaData: Boolean): TJSONObject; overload;
   procedure FromJSONArray(AJSONArrayData: TJSONArray); overload;
   procedure FromJSONArray(AJSONArrayData: TJSONArray; AFormatSettings: TFormatSettings); overload;
   procedure FromJSONArray(AJSONArrayData: TJSONArray; AExcludeFields: array of string); overload;
   procedure FromJSONArray(AJSONArrayData: TJSONArray; AFormatSettings: TFormatSettings; AExcludeFields: array of string); overload;
   procedure FromJSONObject(AJSONObject: TJSONObject; ADataArrayName: string = ''); overload;
   procedure FromJSONObject(AJSONObject: TJSONObject; AFormatSettings: TFormatSettings; ADataArrayName: string = ''); overload;
   procedure FromJSONObject(AJSONObject: TJSONObject; AExcludeFields: array of string); overload;
   procedure FromJSONObject(AJSONObject: TJSONObject; AFormatSettings: TFormatSettings; AExcludeFields: array of string); overload;
   procedure FromJSONObject(AJSONObject: TJSONObject; ADataArrayName: string; AExcludeFields: array of string); overload;
   procedure FromJSONObject(AJSONObject: TJSONObject; AFormatSettings: TFormatSettings; ADataArrayName: string; AExcludeFields: array of string); overload;
 end;


{$IFDEF FPC}
  { TJSONFloatNumberFixed }

  TJSONFloatNumberFixed = class(TJSONFloatNumber)
   public
    function GetAsString: TJSONStringType; override;
  end;
{$ENDIF}


function GetTJSONTrue: TJSONTrue;
function GetTJSONFalse: TJSONFalse;

function DataSetToJSON(ADataSet: TDataSet; AColumns: TJSONArray; MaxRecords: Integer; SkipeInvisibleFields: boolean; AFormatSettings: TFormatSettings; IncludeRecNOCol: boolean = false): TJSONArray; overload;


implementation

Uses
 D2Bridge.JSON.Util
{$IFDEF D2BRIDGE}
 , Prism.BaseClass
{$ELSE}

{$ENDIF}
;


function FindJSONValue(AObj: TJSONObject; const AName: string): {$IFnDEF FPC}TJSONValue{$ELSE}TJSONData{$ENDIF};
var
  I: Integer;
begin
  Result := nil;

  if AObj = nil then
    Exit;

  for I := 0 to AObj.Count - 1 do
    if SameText(AObj.{$IFnDEF FPC}Pairs[I].JsonString.Value{$ELSE}Names[I]{$ENDIF}, AName) then
      Exit(AObj.{$IFnDEF FPC}Pairs[I].JsonValue{$ELSE}Items[I]{$ENDIF});
end;



procedure JSONObjectToDataSetRow(ADataSet: TDataset; AJSON: TJSONObject; AFormatSettings: TFormatSettings; AExcludeFields: array of string);
var
 LValue: {$IFnDEF FPC}TJSONValue{$ELSE}TJSONData{$ENDIF};
 I, B, F: Integer;
 Field: TField;
 Bytes: TBytes;
 P: Integer;
 vFieldName, vExcFieldName: string;
 vContinue: boolean;
begin
 if not Assigned(ADataSet) then
   Exit;

 if not Assigned(AJSON) then
   Exit;

 // ISO / JSON settings
 //FS := DefaultFormatSettings;
 //FS.DecimalSeparator := '.';
 //FS.DateSeparator := '-';
 //FS.TimeSeparator := ':';
 //FS.ShortDateFormat := 'yyyy-mm-dd';
 //FS.LongTimeFormat := 'hh:nn:ss';

 try
  ADataSet.Edit;

  for F := 0 to ADataSet.FieldCount - 1 do
  begin
   Field := ADataSet.Fields[F];
   vFieldName:= Field.FieldName;


   vContinue:= false;
   if Length(AExcludeFields) > 0 then
    for vExcFieldName in AExcludeFields do
    begin
     if SameText(vExcFieldName, vFieldName) then
     begin
      vContinue:= true;
      break;
     end;
    end;
    if vContinue then
     Continue;


   // Proteções importantes
   if Field.ReadOnly or Field.Calculated or Field.Lookup then
     Continue;

   LValue := FindJSONValue(AJSON, vFieldName);
   if LValue = nil then
     Continue;

   {$IFDEF FPC}
   if LValue.JSONType = jtNull then
   {$ELSE}
   if LValue is TJSONNull then
   {$ENDIF}
   begin
     Field.Clear;
     Continue;
   end;


   case Field.DataType of

    // Inteiros
    ftSmallint, {$IFnDEF FPC}ftShortint,{$ENDIF} ftWord, ftInteger, ftAutoInc,
    ftLargeint {$IFnDEF FPC}, ftLongWord{$ENDIF}:
      Field.AsLargeInt := {$IFnDEF FPC}TJSONNumber(LValue).AsInt64{$ELSE}LValue.AsLargeInt{$ENDIF};

    // Float / Extended / BCD
    ftFloat, {$IFnDEF FPC}ftExtended, ftSingle,{$ENDIF} ftFMTBcd, ftBCD:
      Field.AsFloat := StrToFloat({$IFnDEF FPC}TJSONString(LValue).Value{$ELSE}LValue.AsString{$ENDIF}, AFormatSettings);

    ftCurrency:
      Field.AsCurrency := StrToFloat({$IFnDEF FPC}TJSONString(LValue).Value{$ELSE}LValue.AsString{$ENDIF}, AFormatSettings);

    // Boolean
    ftBoolean:
      Field.AsBoolean := SameText({$IFnDEF FPC}TJSONString(LValue).Value{$ELSE}LValue.AsString{$ENDIF}, 'true') or
                         ({$IFnDEF FPC}TJSONString(LValue).Value{$ELSE}LValue.AsString{$ENDIF} = '1');

    // Strings
    ftString, ftWideString, ftMemo, ftFmtMemo, ftWideMemo, ftUnknown:
      Field.AsString := {$IFnDEF FPC}TJSONString(LValue).Value{$ELSE}LValue.AsString{$ENDIF};

    // Datas
    ftDate:
      Field.AsDateTime := StrToDate({$IFnDEF FPC}TJSONString(LValue).Value{$ELSE}LValue.AsString{$ENDIF}, AFormatSettings);

    ftTime:
      Field.AsDateTime := StrToTime({$IFnDEF FPC}TJSONString(LValue).Value{$ELSE}LValue.AsString{$ENDIF}, AFormatSettings);

    ftDateTime, ftTimeStamp:
      Field.AsDateTime := StrToDateTime({$IFnDEF FPC}TJSONString(LValue).Value{$ELSE}LValue.AsString{$ENDIF}, AFormatSettings);

    // Bytes (hex)
    ftBytes:
    begin
      SetLength(Bytes, Length({$IFnDEF FPC}TJSONString(LValue).Value{$ELSE}LValue.AsString{$ENDIF}) div 2);
      P := 1;
      for B := 0 to High(Bytes) do
      begin
        Bytes[B] := StrToInt('$' + Copy({$IFnDEF FPC}TJSONString(LValue).Value{$ELSE}LValue.AsString{$ENDIF}, P, 2));
        Inc(P, 2);
      end;
      Field.AsBytes := Bytes;
    end;

    // Blob (Base64 – compatível com seu serializer)
    ftBlob:
      Field.AsString := {$IFnDEF FPC}TJSONString(LValue).Value{$ELSE}LValue.AsString{$ENDIF};

   else
    // fallback seguro
    Field.AsString := {$IFnDEF FPC}TJSONString(LValue).Value{$ELSE}LValue.AsString{$ENDIF};
   end;
  end;

  ADataSet.Post;
 finally
 end;
end;


{ TJSONValueHelper }

{$IFDEF FPC}
class function TJSONValueHelper.ParseJSONValue(const aData: string): TJSONValue;
begin
  Result:= GetJSON(aData);
end;
{$ENDIF}

{$IF DEFINED(FPC) OR NOT DEFINED(DELPHIX_SEATTLE_UP)}
function TJSONValueHelper.ToJSON: String;
begin
  {$IFNDEF FPC}
  Result:= ToString;
  {$ELSE}
  Result:= AsJSON;
  {$ENDIF}
end;
{$IFEND}

function TJSONValueHelper.NewClone: TJSONValue;
begin
{$IFNDEF FPC}
  {$IFDEF HAS_UNIT_SYSTEM_JSON}
  Result:= TJSONObject.ParseJSONValue(ToJSON);
  {$ELSE}
  Result:= TJSONObject.Parse(ToJSON) as TJSONValue;
  {$ENDIF}
{$ELSE}
  Result:= Clone;
{$ENDIF}
end;

{ TJSONObjectHelper }

{$IFNDEF HAS_UNIT_SYSTEM_JSON}
function TJSONObjectHelper.AddPair(const aStr: string; const aVal: TJSONValue): TJSONObject;
var
  vJSONValue: TJSONValue;
begin
  vJSONValue:= {$IFNDEF FPC}O[aStr]{$ELSE}Find(aStr){$ENDIF};

{$IFNDEF FPC}
  O[aStr]:= aVal;
{$ELSE}
  if vJSONValue = nil then
    Add(aStr, aVal)
  else
    vJSONValue.Value:= aVal.Value;
{$ENDIF}

 Result:= self;
end;

function TJSONObjectHelper.AddPair(const aStr: string; const aVal: Variant): TJSONObject; overload;
var
  vType: TVarType;
  vJSONValue: TJSONData;
  fs: TFormatSettings;
begin
  {$IFDEF FPC}
  vJSONValue := Find(aStr);
  vType := VarType(aVal);
  if (vType and varByRef) <> 0 then
    vType := vType and not varByRef;

  case vType of
    varEmpty, varNull, varUnknown:
      begin
        if vJSONValue = nil then
          Add(aStr, TJSONNull.Create)
        else
          vJSONValue.Free;
      end;

    varString, varOleStr, varUString:
      begin
        if vJSONValue = nil then
          Add(aStr, VarToStr(aVal))
        else
          vJSONValue.Value := VarToStr(aVal);
      end;

    varBoolean:
      begin
        if vJSONValue = nil then
          Add(aStr, Boolean(aVal))
        else
          vJSONValue.Value := Boolean(aVal);
      end;

    varByte, varSmallint, varInteger, varWord, varLongWord, varShortInt:
      begin
        if vJSONValue = nil then
          Add(aStr, Integer(aVal))
        else
          vJSONValue.Value := Integer(aVal);
      end;

    varInt64:
      begin
        if vJSONValue = nil then
          Add(aStr, Int64(aVal))
        else
          vJSONValue.Value := Int64(aVal);
      end;

    varCurrency, varSingle, varDouble:
      begin
        if vJSONValue = nil then
          Add(aStr, TJSONFloatNumberFixed.Create(aVal))
        else
        begin
          vJSONValue.Free;
          Add(aStr, TJSONFloatNumberFixed.Create(aVal));
        end;
      end;

    varDate:
      begin
        fs := DefaultFormatSettings;
        fs.ShortDateFormat := 'yyyy-mm-dd';
        fs.DateSeparator:= '-';
        fs.DecimalSeparator:= '.';
        fs.ThousandSeparator:= ',';
        fs.ShortTimeFormat:= 'hh:nn';
        fs.LongTimeFormat:= 'hh:nn:ss';

        if vJSONValue = nil then
          Add(aStr, DateTimeToStr(aVal, fs))
        else
          vJSONValue.Value := DateTimeToStr(aVal, fs);
      end;

    else
      begin
        if vJSONValue = nil then
          Add(aStr, VarToStr(aVal))
        else
          vJSONValue.Value := VarToStr(aVal);
      end;
  end;

  Result := self;
  {$ELSE}
  Result := AddPair(aStr, aVal);
  {$ENDIF}
end;
{$ENDIF}

{$IFDEF FPC}
function TJSONObjectHelper.GetValue(const APath: string; ADefaultValue: String): String;
var
 vJSONValue: TJSONValue;
begin
 vJSONValue:= Find(APath);

 if vJSONValue = nil then
  Result:= ADefaultValue
 else
  Result:= VarToStr(vJSONValue.Value);
end;

function TJSONObjectHelper.GetValue(const APath: string; ADefaultValue: Boolean): Boolean;
var
 vJSONValue: TJSONValue;
 vBoolValue: Boolean;
begin
 vJSONValue:= Find(APath);

 if vJSONValue = nil then
  Result:= ADefaultValue
 else
 begin
  if TryStrToBool(VarToStr(vJSONValue.Value), vBoolValue) then
   Result:= vBoolValue
  else
   Result:= false;
 end;
end;

{$ENDIF}

function TJSONObjectHelper.GetValue(const APath: string): TJSONValue;
var
 I: Integer;
 aCaseInsensitive: Boolean;
 cmp_string:string;
begin
 result:= nil;

 if not Assigned(self) then
  exit;

 aCaseInsensitive:= true;

 if aCaseInsensitive then
 begin
  try
   for I:= 0 to Pred(Count) do
   begin
     {$IFDEF HAS_UNIT_SYSTEM_JSON}
       cmp_string:=Pairs[I].JsonString.Value;
     {$ELSE}
       cmp_string:=Names[I];
     {$ENDIF}
     if SameText(cmp_string, APath) then
     begin
 {$IFNDEF FPC}
   {$IFDEF HAS_UNIT_SYSTEM_JSON}
       Result:= Pairs[I].JsonValue;
   {$ELSE}
       Result:= Items[I].ObjectValue;
   {$ENDIF}
 {$ELSE}
       Result:= Items[I];
 {$ENDIF}
       break;
     end;
   end;
  except
  end;
 end else
  result:= GetValue(APath);
end;

function TJSONObjectHelper.GetValue(const APath: string; ADefaultValue: Integer): Integer;
var
 vJSONValue: TJSONValue;
 vIntValue: Integer;
begin
 vJSONValue:= GetValue(APath);

 if vJSONValue = nil then
  Result:= ADefaultValue
 else
 begin
  if TryStrToInt(VarToStr(vJSONValue.Value), vIntValue) then
   Result:= vIntValue
  else
   Result:= 0;
 end;
end;

function TJSONObjectHelper.GetJsonStringValue(aIndex: Integer): String;
begin
  Result:= {$IFDEF HAS_UNIT_SYSTEM_JSON}Pairs[aIndex].JsonString.Value{$ELSE}Names[aIndex]{$ENDIF};
end;

function TJSONObjectHelper.GetJsonValue(aIndex: Integer): TJSONValue;
begin
{$IFNDEF FPC}
  {$IFDEF HAS_UNIT_SYSTEM_JSON}
  Result:= Pairs[aIndex].JsonValue;
  {$ELSE}
  Result:= Items[aIndex].ObjectValue;
  {$ENDIF}
{$ELSE}
  Result:= Items[aIndex];
{$ENDIF}
end;

procedure TJSONObjectHelper.SetJsonValue(aIndex: Integer; aJSONValue: TJSONValue);
begin
{$IFNDEF FPC}
  {$IFDEF HAS_UNIT_SYSTEM_JSON}
  Pairs[aIndex].JsonValue:= aJSONValue;
  {$ELSE}
  Items[aIndex].ObjectValue:= aJSONValue as TJsonObject;
  {$ENDIF}
{$ELSE}
  Items[aIndex]:= aJSONValue;
{$ENDIF}
end;


procedure TJSONObjectHelper.ToDataSet(ADataSet: TDataset;
  AFormatSettings: TFormatSettings; ADataArrayName: string;
  AExcludeFields: array of string);
var
 vJSONArray: TJSONArray;
begin
 if ADataArrayName = '' then
 begin
  JSONObjectToDataSetRow(ADataSet, Self, AFormatSettings, AExcludeFields);
 end else
 begin
  vJSONArray:= self.GetValue(ADataArrayName) as TJSONArray;

  if Assigned(vJSONArray) then
  begin
   vJSONArray.ToDataSet(ADataSet, AFormatSettings, AExcludeFields);
  end;
 end;
end;


procedure TJSONObjectHelper.ToDataSet(ADataSet: TDataset;
  AFormatSettings: TFormatSettings; AExcludeFields: array of string);
begin
 ToDataSet(ADataSet, AFormatSettings, '', AExcludeFields);
end;


procedure TJSONObjectHelper.ToDataSet(ADataSet: TDataset; AExcludeFields: array of string);
var
 vFormatSettings: TFormatSettings;
begin
{$IFDEF D2BRIDGE}
 vFormatSettings:= PrismBaseClass.Rest.Options.FormatSettings;
{$ELSE}
 vFormatSettings:= {$IFnDEF FPC}TFormatSettings.Create('en-US'){$ELSE}DefaultFormatSettings{$ENDIF};
{$ENDIF}

 ToDataSet(ADataSet, vFormatSettings, '', AExcludeFields);
end;


procedure TJSONObjectHelper.ToDataSet(ADataSet: TDataset; ADataArrayName: string; AExcludeFields: array of string);
var
 vJSONArray: TJSONArray;
var
 vFormatSettings: TFormatSettings;
begin
{$IFDEF D2BRIDGE}
 vFormatSettings:= PrismBaseClass.Rest.Options.FormatSettings;
{$ELSE}
 vFormatSettings:= {$IFnDEF FPC}TFormatSettings.Create('en-US'){$ELSE}DefaultFormatSettings{$ENDIF};
{$ENDIF}

 ToDataSet(ADataSet, vFormatSettings, ADataArrayName, AExcludeFields);
end;


procedure TJSONObjectHelper.ToDataSet(ADataSet: TDataset; ADataArrayName: string);
var
 vFormatSettings: TFormatSettings;
begin
{$IFDEF D2BRIDGE}
 vFormatSettings:= PrismBaseClass.Rest.Options.FormatSettings;
{$ELSE}
 vFormatSettings:= {$IFnDEF FPC}TFormatSettings.Create('en-US'){$ELSE}DefaultFormatSettings{$ENDIF};
{$ENDIF}

 ToDataSet(ADataSet, vFormatSettings, ADataArrayName, []);
end;


function TJSONObjectHelper.AddBase64File(const aStr, aFileName: string): TJSONObject;
begin
 result:= self;

 if FileExists(aFileName) then
 begin
  result:= AddPair(aStr, Base64FromFile(aFileName));
 end;
end;


procedure TJSONObjectHelper.GetBase64File(const aStr, aSaveFileName: string);
begin
 Base64ToFile(GetValue(aStr,''), aSaveFileName);
end;


function GetTJSONTrue: TJSONTrue;
begin
{$IFNDEF FPC}
  {$IFDEF HAS_UNIT_SYSTEM_JSON}
    {$IFDEF DELPHIX_SEATTLE_UP}
  Result:= TJSONBool.Create(True);
    {$ELSE}
  Result:= TJSONTrue.Create;
    {$ENDIF}
  {$ELSE}
  Result:= Items[aIndex].ObjectValue;
  {$ENDIF}
{$ELSE}
  Result:= TJSONBoolean.Create(True);
{$ENDIF}
end;

function GetTJSONFalse: TJSONFalse;
begin
{$IFNDEF FPC}
  {$IFDEF HAS_UNIT_SYSTEM_JSON}
    {$IFDEF DELPHIX_SEATTLE_UP}
  Result:= TJSONBool.Create(False);
    {$ELSE}
  Result:= TJSONFalse.Create;
    {$ENDIF}
  {$ELSE}
  Result:= Items[aIndex].ObjectValue;
  {$ENDIF}
{$ELSE}
  Result:= TJSONBoolean.Create(False);
{$ENDIF}
end;

function DataSetToJSON(ADataSet: TDataSet; AColumns: TJSONArray; MaxRecords: Integer; SkipeInvisibleFields: boolean; AFormatSettings: TFormatSettings; IncludeRecNOCol: boolean = false): TJSONArray;
var
  lCountRecordsExported: Integer;
  lCols, lColsArray, I:  Integer;
  lColName:              String;
  lHexString:            string;
  lByteValue:            Byte;
  FieldExist:            Boolean;
  SkipeField:            Boolean;
  lStreamIn:             TStream;
  lStreamOut:            TStringStream;
  lJSONArray:            TJSONArray;
  lJSONObject:           TJSONObject;
{$IFDEF FPC}
  Encoder:               TBase64EncodingStream;
{$ENDIF}
begin
  lCountRecordsExported:= 0;

  lJSONArray:= TJSONArray.Create;
  try
    //ADataSet.First;

    try
      while ((not ADataSet.Eof) or ((ADataSet.Eof) and (MaxRecords = 1))) and
            ((MaxRecords <= 0) or ((MaxRecords > 0) and (MaxRecords > lCountRecordsExported))) do
      begin
        Inc(lCountRecordsExported);

        lJSONObject:= TJSONObject.Create;
        lJSONArray.Add(lJSONObject);

          for lColsArray:= 0 to Pred(AColumns.Count) do
          begin
              lColName:= AColumns.Items[lColsArray].Value;

              FieldExist:= false;
              for I := 0 to Pred(ADataSet.FieldCount) do
              if SameText(lColName, ADataSet.Fields[I].FieldName) then
              begin
               FieldExist:= true;
               lCols:= I;

               SkipeField:= not ADataSet.Fields[I].Visible;

               break;
              end;

              if SkipeField and SkipeInvisibleFields then
               Continue;

              if not FieldExist then
                lJSONObject.AddPair(lColName, TJSONNull.Create)
              else
              begin
                //lJSONWriter.WritePropertyName(ADataSet.Fields[lCols].FieldName);
                if ADataSet.Fields[lCols].IsNull then
                  case ADataSet.Fields[lCols].DataType of
                    // nÃºmericos
                    ftFloat{$IFDEF SUPPORTS_FTEXTENDED}, ftCurrency, ftExtended{$ENDIF}, ftFMTBcd,
                    ftSmallint{$IFDEF SUPPORTS_FTEXTENDED}, ftShortint, ftSingle{$ENDIF}, ftWord, ftInteger, ftAutoInc,
                    ftLargeint{$IFDEF SUPPORTS_FTEXTENDED}, ftLongWord{$ENDIF}, ftBCD:
                    begin
                     lJSONObject.AddPair(lColName, TJSONFloatNumber.Create(0));
                    end;
                    //string
                    ftString, ftFmtMemo, ftMemo, ftWideString, ftWideMemo, ftUnknown :
                      lJSONObject.AddPair(lColName, '');
                    // DateTime
                    ftDateTime:
                      begin
//                       if (ADataSet.Fields[lCols] as TDateTimeField).DisplayFormat <> '' then
//                        lJSONObject.AddPair(lColName, FormatDatetime((ADataSet.Fields[lCols] as TDateTimeField).DisplayFormat, ADataSet.Fields[lCols].AsDateTime))
//                       else
                        lJSONObject.AddPair(lColName, '');
                      end;
                    //Date
                    ftDate:
                      begin
//                       if (ADataSet.Fields[lCols] as TDateField).DisplayFormat <> '' then
//                        lJSONObject.AddPair(lColName, FormatDatetime((ADataSet.Fields[lCols] as TDateTimeField).DisplayFormat, ADataSet.Fields[lCols].AsDateTime))
//                       else
                        lJSONObject.AddPair(lColName, '');
                      end;
                    //Time
                    ftTime:
                      begin
//                       if (ADataSet.Fields[lCols] as TTimeField).DisplayFormat <> '' then
//                        lJSONObject.AddPair(lColName, FormatDatetime((ADataSet.Fields[lCols] as TDateTimeField).DisplayFormat, ADataSet.Fields[lCols].AsDateTime))
//                       else
                        lJSONObject.AddPair(lColName, '');
                      end;
                    //TimeStamp
                    ftTimeStamp:
                      begin
{$IFNDEF FPC}
//                       if (ADataSet.Fields[lCols] as TSQLTimeStampField).DisplayFormat <> '' then
//                        lJSONObject.AddPair(lColName, FormatDatetime((ADataSet.Fields[lCols] as TSQLTimeStampField).DisplayFormat, ADataSet.Fields[lCols].AsDateTime))
//                       else
{$ENDIF}
                        lJSONObject.AddPair(lColName, '');
                      end;

                    else
                     lJSONObject.AddPair(lColName, TJSONNull.Create)
                  end
                else
                  case ADataSet.Fields[lCols].DataType of
                    ftBlob:
                      begin
                        lStreamIn := ADataSet.CreateBlobStream(ADataSet.Fields[lCols], bmRead);
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

                        lStreamOut.Position := 0;

                        lJSONObject.AddPair(ADataSet.Fields[lCols].FieldName, lStreamOut.DataString);
                        lStreamOut.Free;
                      end;
                    ftBoolean:
                      begin
                        if ADataSet.Fields[lCols].AsBoolean then
                          lJSONObject.AddPair(lColName, GetTJSONTrue)
                        else
                          lJSONObject.AddPair(lColName, GetTJSONFalse);
                      end;
                    // nÃºmericos
                    ftFloat{$IFDEF SUPPORTS_FTEXTENDED}, ftExtended{$ENDIF}, ftFMTBcd, ftBCD:
                    begin
                      if (ADataSet.Fields[lCols] as TNumericField).DisplayFormat <> '' then
                       lJSONObject.AddPair(lColName, FormatFloat((ADataSet.Fields[lCols] as TNumericField).DisplayFormat, ADataSet.fields[lcols].AsFloat, AFormatSettings))
                      else
                       lJSONObject.AddPair(lColName, {$IFnDEF FPC}TJSONFloatNumber{$ELSE}TJSONFloatNumberFixed{$ENDIF}.Create(ADataSet.Fields[lCols].AsFloat));
                    end;
                    ftCurrency:
                    begin
                      if (ADataSet.Fields[lCols] as TCurrencyField).DisplayFormat <> '' then
                       lJSONObject.AddPair(lColName, FormatFloat((ADataSet.Fields[lCols] as TCurrencyField).DisplayFormat, ADataSet.fields[lcols].AsCurrency, AFormatSettings))
                      else
                       lJSONObject.AddPair(lColName, {$IFnDEF FPC}TJSONFloatNumber{$ELSE}TJSONFloatNumberFixed{$ENDIF}.Create(ADataSet.Fields[lCols].AsCurrency));
                    end;
                    ftSmallint{$IFDEF SUPPORTS_FTEXTENDED}, ftShortint, ftSingle{$ENDIF}, ftWord, ftInteger, ftAutoInc,
                    ftLargeint{$IFDEF SUPPORTS_FTEXTENDED}, ftLongWord{$ENDIF}:
                      lJSONObject.AddPair(lColName, TJSONInt64Number.Create(Int64(ADataSet.Fields[lCols].Value)));
                    //string
                    ftString, ftFmtMemo, ftMemo, ftWideString, ftWideMemo, ftUnknown :
                      lJSONObject.AddPair(lColName, Trim(ADataSet.Fields[lCols].Value));
                    // DateTime
                    ftDateTime:
                      begin
                       if (ADataSet.Fields[lCols] as TDateTimeField).DisplayFormat <> '' then
                        lJSONObject.AddPair(lColName, FormatDatetime((ADataSet.Fields[lCols] as TDateTimeField).DisplayFormat, ADataSet.Fields[lCols].AsDateTime))
                       else
                        lJSONObject.AddPair(lColName, FormatDatetime(AFormatSettings.ShortDateFormat + ' ' + AFormatSettings.LongTimeFormat, ADataSet.Fields[lCols].AsDateTime));
                      end;
                    ftDate:
                      begin
                       if (ADataSet.Fields[lCols] as TDateField).DisplayFormat <> '' then
                        lJSONObject.AddPair(lColName, FormatDatetime((ADataSet.Fields[lCols] as TDateField).DisplayFormat, ADataSet.Fields[lCols].AsDateTime))
                       else
                        lJSONObject.AddPair(lColName, FormatDatetime(AFormatSettings.ShortDateFormat, ADataSet.fields[lcols].AsDateTime));
                      end;
                    ftTime:
                      begin
                       if (ADataSet.Fields[lCols] as TTimeField).DisplayFormat <> '' then
                        lJSONObject.AddPair(lColName, FormatDatetime((ADataSet.Fields[lCols] as TTimeField).DisplayFormat, ADataSet.Fields[lCols].AsDateTime))
                       else
                        lJSONObject.AddPair(lColName, FormatDatetime(AFormatSettings.LongTimeFormat, ADataSet.Fields[lCols].AsDateTime));
                      end;
                    ftTimeStamp:
                      begin
{$IFNDEF FPC}
                       if (ADataSet.Fields[lCols] as TSQLTimeStampField).DisplayFormat <> '' then
                        lJSONObject.AddPair(lColName, FormatDatetime((ADataSet.Fields[lCols] as TSQLTimeStampField).DisplayFormat, ADataSet.Fields[lCols].AsDateTime))
                       else
{$ENDIF}
                        lJSONObject.AddPair(lColName, FormatDatetime(AFormatSettings.ShortDateFormat + ' ' + AFormatSettings.LongTimeFormat, ADataSet.Fields[lCols].AsDateTime)); //'DD/MM/YYYY hh:nn:ss'
                      end;
                    ftBytes:
                    begin
                      LHexString:= EmptyStr;

                      for LByteValue in ADataSet.fields[lcols].AsBytes do
                        LHexString:= LHexString + IntToHex(LByteValue, 2);

                      lJSONObject.AddPair(lColName, LHexString);
                    end;
                  end;
              end;
          end;

        if IncludeRecNOCol then
        begin
         lJSONObject.AddPair('PrismRecNo', TJSONIntegerNumber.Create(ADataSet.RecNo));
        end;

        if (MaxRecords <= 0) or (MaxRecords > 1) then
         ADataSet.Next;
      end;
    except

    end;

    Result:= lJSONArray.NewClone as TJSONArray;
  finally
    lJSONArray.Free;
  end;
end;

{ TDataSetToJSONHelper }

function TDataSetToJSONHelper.ToJSON: TJSONArray;
begin
 result:= ToJSON({$IFDEF D2BRIDGE}PrismBaseClass.Rest.Options.MaxRecord{$ELSE}0{$ENDIF}, 0);
end;

function TDataSetToJSONHelper.ToJSON(AShowMetaData: Boolean): TJSONObject;
begin
 result:= ToJSON({$IFDEF D2BRIDGE}PrismBaseClass.Rest.Options.MaxRecord{$ELSE}0{$ENDIF}, 0, AShowMetaData);
end;

function TDataSetToJSONHelper.ToJSON(AMaxRecords, AOffSet: Integer): TJSONArray;
begin
 result:= ToJSON([], AMaxRecords, AOffSet);
end;

procedure TDataSetToJSONHelper.FromJSONArray(AJSONArrayData: TJSONArray);
begin
 AJSONArrayData.ToDataSet(self, []);
end;

procedure TDataSetToJSONHelper.FromJSONArray(AJSONArrayData: TJSONArray;
  AExcludeFields: array of string);
begin
 AJSONArrayData.ToDataSet(self, AExcludeFields);
end;

procedure TDataSetToJSONHelper.FromJSONObject(AJSONObject: TJSONObject;
  ADataArrayName: string);
begin
 AJSONObject.ToDataSet(Self, ADataArrayName);
end;

procedure TDataSetToJSONHelper.FromJSONArray(AJSONArrayData: TJSONArray;
  AFormatSettings: TFormatSettings);
begin
 AJSONArrayData.ToDataSet(self, AFormatSettings, []);
end;

procedure TDataSetToJSONHelper.FromJSONArray(AJSONArrayData: TJSONArray;
  AFormatSettings: TFormatSettings; AExcludeFields: array of string);
begin
 AJSONArrayData.ToDataSet(self, AFormatSettings, AExcludeFields);
end;

procedure TDataSetToJSONHelper.FromJSONObject(AJSONObject: TJSONObject; ADataArrayName: string; AExcludeFields: array of string);
begin
 AJSONObject.ToDataSet(Self, ADataArrayName, AExcludeFields);
end;

procedure TDataSetToJSONHelper.FromJSONObject(AJSONObject: TJSONObject;
  AFormatSettings: TFormatSettings; AExcludeFields: array of string);
begin
 FromJSONObject(AJSONObject, AFormatSettings, '', AExcludeFields);
end;

procedure TDataSetToJSONHelper.FromJSONObject(AJSONObject: TJSONObject;
  AFormatSettings: TFormatSettings; ADataArrayName: string);
begin
 AJSONObject.ToDataSet(Self, AFormatSettings, ADataArrayName);
end;

procedure TDataSetToJSONHelper.FromJSONObject(AJSONObject: TJSONObject;
  AExcludeFields: array of string);
begin
 FromJSONObject(AJSONObject, '', AExcludeFields);
end;

function TDataSetToJSONHelper.ToJSON(AMaxRecords, AOffSet: Integer; AShowMetaData: Boolean): TJSONObject;
begin
 result:= ToJSON([], AMaxRecords, AOffSet, AShowMetaData);
end;



{$IFDEF FPC}
{ TJSONFloatNumberFixed }

function TJSONFloatNumberFixed.GetAsString: TJSONStringType;
var
  F: TJSONFloat;
  fs: TFormatSettings;
begin
  fs := DefaultFormatSettings;
  fs.DecimalSeparator := '.';
  fs.ThousandSeparator:= #0;
  F := GetAsFloat;
  Result := FormatFloat('0.0#########', F, fs); // format with your preferences
end;
{$ENDIF}




{ TJSONArrayHelper }

procedure TJSONArrayHelper.ToDataSet(ADataSet: TDataset; AExcludeFields: array of string);
var
 vFormatSettings: TFormatSettings;
begin
{$IFDEF D2BRIDGE}
 vFormatSettings:= PrismBaseClass.Rest.Options.FormatSettings;
{$ELSE}
 vFormatSettings:= {$IFnDEF FPC}TFormatSettings.Create('en-US'){$ELSE}DefaultFormatSettings{$ENDIF};
{$ENDIF}

 ToDataSet(ADataSet, vFormatSettings, AExcludeFields);
end;


procedure TJSONArrayHelper.ToDataSet(ADataSet: TDataset);
begin
 ToDataSet(ADataSet, []);
end;


procedure TJSONObjectHelper.ToDataSet(ADataSet: TDataset;
  AFormatSettings: TFormatSettings; ADataArrayName: string);
begin
 ToDataSet(ADataSet, AFormatSettings, ADataArrayName, []);
end;


procedure TJSONArrayHelper.ToDataSet(ADataSet: TDataset;
  AFormatSettings: TFormatSettings; AExcludeFields: array of string);
var
 I: integer;
 vJSON: TJSONObject;
begin
 for I := 0 to Pred(Self.Count) do
 begin
  vJSON:= Self.Items[I] as TJSONObject;
  if Assigned(vJSON) then
  begin
   if I = 0 then
    ADataSet.Edit
   else
    ADataSet.Append;
   vJSON.ToDataSet(ADataSet, AFormatSettings, '', AExcludeFields);
  end;
 end;
end;


procedure TJSONArrayHelper.ToDataSet(ADataSet: TDataset;
  AFormatSettings: TFormatSettings);
begin
 ToDataSet(ADataSet, AFormatSettings, []);
end;


procedure TDataSetToJSONHelper.FromJSONObject(AJSONObject: TJSONObject;
  AFormatSettings: TFormatSettings; ADataArrayName: string;
  AExcludeFields: array of string);
begin
 AJSONObject.ToDataSet(Self, AFormatSettings, ADataArrayName, AExcludeFields);
end;

function TDataSetToJSONHelper.ToJSON(
  AExcludeFields: array of string): TJSONArray;
begin
 result:= ToJSON(AExcludeFields, {$IFDEF D2BRIDGE}PrismBaseClass.Rest.Options.MaxRecord{$ELSE}0{$ENDIF}, 0);
end;

function TDataSetToJSONHelper.ToJSON(AExcludeFields: array of string;
  AShowMetaData: Boolean): TJSONObject;
begin
 result:= ToJSON(AExcludeFields, {$IFDEF D2BRIDGE}PrismBaseClass.Rest.Options.MaxRecord{$ELSE}0{$ENDIF}, 0, AShowMetaData);
end;

function TDataSetToJSONHelper.ToJSON(AExcludeFields: array of string;
  AMaxRecords, AOffSet: Integer): TJSONArray;
var
 vJSONArrayColumns: TJSONArray;
 vJSONDataArray: TJSONArray;
 I, X: integer;
 vPos: integer;
 vFormatSettings: TFormatSettings;
 vAbortField: boolean;
begin
 result:= nil;

 if Assigned(Self) and
    Self.Active and
    (Self.RecordCount > 0) and
    (((AMaxRecords <= 0) or
       ((AMaxRecords > 0) and ((Self.RecordCount - AOffSet) >= 0)))) then
 begin
  {$IFDEF D2BRIDGE}
   vFormatSettings:= PrismBaseClass.Rest.Options.FormatSettings;
  {$ELSE}
   vFormatSettings:= {$IFnDEF FPC}TFormatSettings.Create('en-US'){$ELSE}DefaultFormatSettings{$ENDIF};
  {$ENDIF}


  vPos:= Self.RecNo;
  Self.DisableControls;

  if AOffSet > 0 then
   Self.RecNo := AOffSet
  else
   Self.First;

  try
   vJSONArrayColumns:= TJSONArray.Create;

   for I := 0 to Pred(Self.FieldCount) do
   begin
    vAbortField:= false;
    if Length(AExcludeFields) > 0 then
    begin
     for X := 0 to Pred(Length(AExcludeFields)) do
     begin
      if SameText(Self.Fields[I].FieldName, AExcludeFields[X]) then
      begin
       vAbortField:= true;
       break;
      end;
     end;
    end;

    if vAbortField then
     Continue;

    {$IFDEF D2BRIDGE}
     if PrismBaseClass.Rest.Options.FieldNameLowerCase then
      vJSONArrayColumns.Add(LowerCase(Self.Fields[I].FieldName))
     else
      vJSONArrayColumns.Add(Self.Fields[I].FieldName);
    {$ELSE}
      vJSONArrayColumns.Add(Self.Fields[I].FieldName);
    {$ENDIF}
   end;

   result:= DataSetToJSON(self, vJSONArrayColumns, AMaxRecords, true, vFormatSettings, false);

   vJSONArrayColumns.Free;
   //vJSONDataArray.Free;
  except
  end;

  Self.RecNo:= vPos;
  Self.EnableControls;
 end else
 begin
  vJSONDataArray:= TJSONArray.Create;
  result:= vJSONDataArray.NewClone as TJSONArray;
  vJSONDataArray.Free;
 end;
end;

function TDataSetToJSONHelper.ToJSON(AExcludeFields: array of string;
  AMaxRecords, AOffSet: Integer; AShowMetaData: Boolean): TJSONObject;
var
 vJSONMetaData: TJSONObject;
 Total, Count: Integer;
 HasMore: Boolean;
begin
 result:= TJSONObject.Create;

 try
  if AShowMetaData then
  begin
   Total := Self.RecordCount;

   // Calcular o nÃºmero real de registros retornados
   if (AOffset >= Total) then
    Count := 0
   else if (AMaxRecords = 0) or (AOffset + AMaxRecords > Total) then
    Count := Total - AOffset
   else
    Count := AMaxRecords;

   HasMore := (AOffset + Count) < Total;

   vJSONMetaData:= TJSONObject.Create;
   vJSONMetaData.AddPair('total', {$IFnDEF FPC}TJSONNumber.Create(total){$ELSE}total{$ENDIF});
   vJSONMetaData.AddPair('limit', {$IFnDEF FPC}TJSONNumber.Create(AMaxRecords){$ELSE}AMaxRecords{$ENDIF});
   vJSONMetaData.AddPair('offset', {$IFnDEF FPC}TJSONNumber.Create(AOffset){$ELSE}AOffset{$ENDIF});
   vJSONMetaData.AddPair('count', {$IFnDEF FPC}TJSONNumber.Create(Count){$ELSE}Count{$ENDIF});
   vJSONMetaData.AddPair('hasmore', {$IFnDEF FPC}TJSONBool.Create(HasMore){$ELSE}HasMore{$ENDIF});

   if Count = 0 then
    result.AddPair('message', 'No records found for the specified offset.')
   else
    result.AddPair('message', Format('%d records returned successfully.', [Count]));

   result.AddPair('pagination', vJSONMetaData);
   //vJSONMetaData.Free;
  end;
 except
 end;

 result.AddPair('data', ToJSON(AExcludeFields, AMaxRecords, AOffSet));

end;

end.
