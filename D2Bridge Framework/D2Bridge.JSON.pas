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

unit D2Bridge.JSON;

interface

uses
  Classes, SysUtils, Rtti, TypInfo, Variants
{$IFNDEF FPC}
  {$IFDEF HAS_UNIT_SYSTEM_JSON}
  , System.JSON, System.SysConst, System.DateUtils
  {$ELSE}
  , JsonDataObjects_D2Bridge
  {$ENDIF}
{$ELSE}
  , fpjson
{$ENDIF}
;

type
{$IFNDEF FPC}
  {$IFDEF HAS_UNIT_SYSTEM_JSON}
  TJSONValue = System.JSON.TJSONValue;
  TJSONObject = System.JSON.TJSONObject;
  TJSONArray = System.JSON.TJSONArray;
  TJSONNull = System.JSON.TJSONNull;
  TJSONFloatNumber = System.JSON.TJSONNumber;
  TJSONIntegerNumber = System.JSON.TJSONNumber;
  TJSONInt64Number = System.JSON.TJSONNumber;
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
  TJSONFloatNumber = fpjson.TJSONFloatNumber;
  TJSONIntegerNumber = fpjson.TJSONIntegerNumber;
  TJSONInt64Number = fpjson.TJSONInt64Number;
  TJSONTrue = fpjson.TJSONBoolean;
  TJSONFalse = fpjson.TJSONBoolean;
  TJSONString = fpjson.TJSONString;
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

  { TJSONObjectHelper }

  TJSONObjectHelper = class helper for TJSONObject
  public
{$IFNDEF HAS_UNIT_SYSTEM_JSON}
    function AddPair(const aStr: string; const aVal: TJSONValue): TJSONObject; overload;
    function AddPair(const aStr: string; const aVal: string): TJSONObject; overload;
{$ENDIF}
  public
{$IFDEF FPC}
    function GetValue(const APath: string; ADefaultValue: String): String; overload;
    function GetValue(const APath: string; ADefaultValue: Boolean): Boolean; overload;
{$ENDIF}
    function GetValue(const APath: string; ADefaultValue: Integer): Integer; overload;
    function GetValue(const APath: string): TJSONValue; overload;
    function GetJsonStringValue(aIndex: Integer): String;
    function GetJsonValue(aIndex: Integer): TJSONValue;
    procedure SetJsonValue(aIndex: Integer; aJSONValue: TJSONValue);
  end;

function GetTJSONTrue: TJSONTrue;
function GetTJSONFalse: TJSONFalse;

implementation

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

  Result:= TJSONObject(Find(aStr));
{$ENDIF}
end;

function TJSONObjectHelper.AddPair(const aStr: string; const aVal: string): TJSONObject;
var
  vJSONValue: TJSONValue;
begin
  vJSONValue:= {$IFNDEF FPC}O[aStr]{$ELSE}Find(aStr){$ENDIF};

{$IFNDEF FPC}
  S[aStr]:= aVal;
{$ELSE}
  if vJSONValue = nil then
    Add(aStr, aVal)
  else
    vJSONValue.Value:= aVal;

  Result:= TJSONObject(Find(aStr));
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
begin
 result:= nil;
 aCaseInsensitive:= true;

 if aCaseInsensitive then
 begin
  for I:= 0 to Pred(Count) do
  begin
    if SameText({$IFDEF HAS_UNIT_SYSTEM_JSON}Pairs[I].JsonString.Value{$ELSE}Names[I]{$ENDIF}, APath) then
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

end.
