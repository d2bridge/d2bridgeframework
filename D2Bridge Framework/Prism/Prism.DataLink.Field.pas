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

{$I ..\D2Bridge.inc}

unit Prism.DataLink.Field;

interface

{$IFNDEF FMX}
uses
  Classes, SysUtils, DBCtrls, DB, Variants, FMTBcd,
  Prism.Types, Prism.DataWare.Mapped, Prism.DataLink.Core;

type
 TPrismDataLinkField = class(TPrismDataLinkCore)
  private
   FPrismControl: TObject;
   FDataType: TPrismFieldType;
   FFormatSettings: TFormatSettings;
   FUseHTMLFormatSettings: Boolean;
   FPrismDataWareMapped: TPrismDataWareMapped;
   FField: TField;
   FFieldName: string;
   FControl: TComponent;
   FFixFieldType: boolean;
   FValueSetWithError: boolean;
   FLastFieldValue: string;
   procedure SetEditDataType(AEditType: TPrismFieldType);
   function GetEditDataType: TPrismFieldType;
   procedure FixPrismFieldType;
   procedure SetFieldValue(AValue: Variant);
   function GetFieldValue(AIgnoreDisableControl: Boolean): Variant; overload;
   function GetFieldValue: Variant; overload;
   procedure SetValueHTMLElement(AValue: string);
   function GetValueHTMLElement: string;
   procedure SetUseHTMLFormatSettings(Value: Boolean);
   procedure SetDataWareMapped(const Value: TPrismDataWareMapped);
   function GetDataWareMapped: TPrismDataWareMapped;
   procedure SetFieldName(const Value: string);
   function GetCanModify: Boolean;
   function GetFixFieldType: boolean;
   procedure SetFixFieldType(const Value: boolean);
  protected
   procedure UpdateField; virtual;
   procedure DataEvent(Event: TDataEvent; Info: {$IFNDEF FPC}NativeInt{$ELSE}Ptrint{$ENDIF}); override;
   procedure DoDataWareEvent(const ADataWareEvent: TPrismDataLinkEvent); override;
   procedure RefreshValue; virtual;
  public
   constructor Create(APrismControlOwner: TObject);
   destructor Destroy; override;

   function FieldText(AIgnoreDisableControl: Boolean = false): string;

   property CanModify: Boolean read GetCanModify;
   function ReadOnly: boolean;

   property UseHTMLFormatSettings: Boolean read FUseHTMLFormatSettings write SetUseHTMLFormatSettings;
   property ValueHTMLElement : string read GetValueHTMLElement write SetValueHTMLElement;
   property FieldValue: Variant read GetFieldValue write SetFieldValue;
   property DataType: TPrismFieldType read GetEditDataType write SetEditDataType;
   property DataWareMapped: TPrismDataWareMapped read GetDataWareMapped write SetDataWareMapped;

   property ValueSetWithError: Boolean read FValueSetWithError;

   property FixFieldType: boolean read GetFixFieldType write SetFixFieldType;

   property Field: TField read FField;
   property FieldName: string read FFieldName write SetFieldName;
   property Control: TComponent read FControl write FControl;
 end;

implementation

uses
  Prism.Forms.Controls, DateUtils, Prism.BaseClass, Prism.Util,
  Prism.Forms;

{ TPrismDataLinkField }

constructor TPrismDataLinkField.Create(APrismControlOwner: TObject);
begin
 inherited Create;

 FFixFieldType:= true;
 VisualControl:= false;

 FValueSetWithError:= false;

 FPrismControl:= APrismControlOwner;

 FDataType:= PrismFieldTypeAuto;

 FPrismDataWareMapped:= TPrismDataWareMapped.Create;
 FPrismDataWareMapped.Assign(PrismBaseClass.Options.DataWareMapped);

 FFormatSettings:= TPrismControl(APrismControlOwner).Session.FormatSettings;

 FLastFieldValue:= '';
end;

procedure TPrismDataLinkField.DataEvent(Event: TDataEvent; Info: {$IFNDEF FPC}NativeInt{$ELSE}Ptrint{$ENDIF});
var
 vDataField: string;
begin
 inherited;

 try
  if Assigned(DataSet) then
   if Assigned(TPrismControl(FPrismControl).Form) then
    if (TPrismControl(FPrismControl).Form.ComponentsUpdating) then
    begin
     if Event in [deFocusControl] then
     begin
      TPrismControl(FPrismControl).SetFocus;
      if Assigned(TPrismControl(FPrismControl).VCLComponent) then
       Control:= TPrismControl(FPrismControl).VCLComponent;
      Exit;
     end;
    end;

 except
 end;
end;

destructor TPrismDataLinkField.Destroy;
begin
 FreeAndNil(FPrismDataWareMapped);

 inherited;
end;

procedure TPrismDataLinkField.DoDataWareEvent(const ADataWareEvent: TPrismDataLinkEvent);
begin
 inherited;

 try
  if Assigned(DataSet) then
  begin
   if Assigned(TPrismControl(FPrismControl).Form) then
   if (TPrismControl(FPrismControl).Form.ComponentsUpdating) then
   begin
    TPrismControl(FPrismControl).UpdateData;
   end;

   if ADataWareEvent in [TPrismDataLinkEvent.Activate] then
   begin
    UpdateField;
    RefreshValue;
   end;
  end;
 except
  on E: Exception do
  begin
   try
    if Assigned(FPrismControl) then
     TPrismControl(FPrismControl).Session.DoException(TPrismControl(FPrismControl).VCLComponent, E, 'DataWareEvent')
    else
     PrismBaseClass.DoException(nil, E, nil, 'DataWareEvent');
   except
   end;
  end;
 end;
end;

function TPrismDataLinkField.FieldText(AIgnoreDisableControl: Boolean): string;
begin
 try
  result:= VarToStrDef(GetFieldValue(AIgnoreDisableControl), '');
 except
 end;
end;

procedure TPrismDataLinkField.FixPrismFieldType;
begin
 try
  if Assigned(DataSource) and Assigned(DataSet) then
  begin
   if Assigned(Field) then
   begin
    if FDataType = PrismFieldTypeAuto then
    begin
     if Field.DataType in [ftFloat, ftCurrency, ftBCD, ftFMTBcd{$IFDEF SUPPORTS_FTEXTENDED}, ftExtended{$ENDIF}] then
     begin
      FDataType:= FPrismDataWareMapped.MappedPrismField(PrismFieldTypeNumber);
     end else
     if Field.DataType in [ftSmallint, ftInteger, ftWord, ftAutoInc, ftLargeint{$IFDEF SUPPORTS_FTEXTENDED}, ftLongWord, ftShortint, ftSingle{$ENDIF}] then
     begin
      FDataType:= FPrismDataWareMapped.MappedPrismField(PrismFieldTypeInteger);

      //TextMask:= TPrismTextMask.Integer;
     end else
     if Field.DataType in [ftDate] then
     begin
      FDataType:= FPrismDataWareMapped.MappedPrismField(PrismFieldTypeDate);
     end else
     if Field.DataType in [ftDateTime] then
     begin
      FDataType:= FPrismDataWareMapped.MappedPrismField(PrismFieldTypeDateTime);
     end else
     if Field.DataType in [ftTimeStamp, ftTime{$IFNDEF FPC}, ftTimeStampOffset{$ENDIF}] then
     begin
      if Field.DataType = ftTimeStamp then
      begin
       if Trunc(Field.AsDateTime) = 0 then
        FDataType := FPrismDataWareMapped.MappedPrismField(PrismFieldTypeTime) // só tem hora
       else
        if Frac(Field.AsDateTime) = 0 then
         FDataType := FPrismDataWareMapped.MappedPrismField(PrismFieldTypeDate) // só tem data
        else
         FDataType := FPrismDataWareMapped.MappedPrismField(PrismFieldTypeDateTime); // tem data e hora
      end else
       FDataType:= FPrismDataWareMapped.MappedPrismField(PrismFieldTypeTime);
     end;
    end;
   end;
  end;
 except
 end;
end;

function TPrismDataLinkField.GetCanModify: Boolean;
begin
 try
  if (Field <> nil) then
   Result := not Field.ReadOnly and (Field <> nil) and Field.CanModify
  else
   Result := false;
 except
 end;
end;

function TPrismDataLinkField.GetDataWareMapped: TPrismDataWareMapped;
begin
 Result:= FPrismDataWareMapped;
end;

function TPrismDataLinkField.GetEditDataType: TPrismFieldType;
begin
 Result:= FDataType;
end;

function TPrismDataLinkField.GetFieldValue: Variant;
begin
 result:= GetFieldValue(false);
end;

function TPrismDataLinkField.GetFieldValue(AIgnoreDisableControl: Boolean): Variant;
begin
 try
  if FixFieldType then
   FixPrismFieldType;

  Result:= '';

  if AIgnoreDisableControl or
     (Assigned(DataSet) and (not DataSet.ControlsDisabled)) then
  begin
   if Assigned(Field) and Assigned(DataSet) and DataSet.Active and (not Field.IsNull) then
    Result:= Field.Value;
  end else
   Result:= FLastFieldValue;

  FLastFieldValue:= Result;
 except
 end;
end;

function TPrismDataLinkField.GetFixFieldType: boolean;
begin
 Result := FFixFieldType;
end;

function TPrismDataLinkField.GetValueHTMLElement: string;
var
 vDateTime: TDateTime;
begin
 try
  if FixFieldType then
   FixPrismFieldType;

  if Assigned(Field) and Assigned(DataSet) and DataSet.Active and (not Field.IsNull) then
  begin
   if (FDataType in [PrismFieldTypeDate]) or (FixFieldType and (Field.DataType in [ftDate])) then
   begin
    if (not FUseHTMLFormatSettings) and (Field is TDateTimeField) and ((Field as TDateTimeField).DisplayFormat <> '') then
    begin
     Result:= FormatDateTime((Field as TDateTimeField).DisplayFormat, Field.AsDateTime, FFormatSettings);

 //    if (Result <> '') and (not TryStrToDate(Result, vDateTime, FFormatSettings)) and (FUseHTMLFormatSettings) then
 //     FDataType:= PrismFieldTypeAuto;
    end else
    begin
     if (Field.AsString = '') or (Field.AsString = '0') or ((Field.DataType in [ftDate]) and (Field.AsDateTime = 0)) then
      Result:= ''
     else
     begin
      if (not (Field.DataType in [ftDate])) and (Field.DataType in [ftWideString]) then
       Result:= Field.AsString
      else
       Result:= DateToStr(Field.AsDateTime, FFormatSettings);
     end;
    end;
   end else
   if (FDataType in [PrismFieldTypeDateTime]) or (FixFieldType and (Field.DataType in [ftDateTime])) then
   begin
    if (not FUseHTMLFormatSettings) and (Field is TDateTimeField) and ((Field as TDateTimeField).DisplayFormat <> '') then
    begin
     Result:= FormatDateTime((Field as TDateTimeField).DisplayFormat, Field.AsDateTime, FFormatSettings);
 //    if (Result <> '') and (not TryStrToDateTime(Result, vDateTime, FFormatSettings)) and (FUseHTMLFormatSettings) then
 //     FDataType:= PrismFieldTypeAuto;
    end else
    begin
     if (Field.AsString = '') or (Field.AsString = '0') or (Field.AsDateTime = 0) then
      Result:= ''
     else
      if (not (Field.DataType in [ftDateTime])) and (Field.DataType in [ftWideString]) then
       Result:= Field.AsString
      else
       Result:= FormatDateTime(FFormatSettings.ShortDateFormat+ ' ' + FFormatSettings.ShortTimeFormat, Field.AsDateTime, FFormatSettings);
    end;

    if FUseHTMLFormatSettings then
     Result:= StringReplace(Result, ' ', 'T', []);
   end else
   if (FDataType in [PrismFieldTypeTime]) or (FixFieldType and (Field.DataType in [ftTime, ftTimeStamp])) then
   begin
    if (Field.AsString = '') or (Field.AsString = '00:00') or (Field.AsString = '00:00:00') or (Field.AsString = '0') then
     Result:= ''
    else
    begin
     if (not (Field.DataType in [ftTime, ftTimeStamp])) and (Field.DataType in [ftWideString]) then
     begin
      if TryStrToTime(Field.AsString, vDateTime, FFormatSettings) then
       Result:= FormatDateTime(FFormatSettings.ShortTimeFormat, vDateTime)
      else
       Result:= Field.AsString
     end else
      Result:= FormatDateTime(FFormatSettings.ShortTimeFormat, Field.AsDateTime);
    end;
   end else
   if (FDataType in [PrismFieldTypeNumber]) or (FixFieldType and (Field.DataType in [ftFloat{$IFDEF SUPPORTS_FTEXTENDED}, ftExtended{$ENDIF}, ftFMTBcd, ftBCD, ftCurrency])) then
   begin
    if (Field.DataType in [ftCurrency]) and
       ((not (Field is TNumericField)) or ((Field is TNumericField) and ((Field as TNumericField).DisplayFormat = ''))) then
    begin
     Result:= FormatCurr(FormatOfCurrency(FFormatSettings), Field.AsCurrency, FFormatSettings);
    end else
    if (Field is TNumericField) and ((Field as TNumericField).DisplayFormat <> '') then
    begin
     if (Field.AsString = '') or (Field.AsString = '0') then
      Result:= FormatFloat((Field as TNumericField).DisplayFormat, 0, FFormatSettings)
     else
      Result:= FormatFloat((Field as TNumericField).DisplayFormat, field.AsFloat, FFormatSettings);
    end else
    begin
     if (Field.AsString = '') or (Field.AsString = '0') then
      Result:= '0'
     else
       Result:= FloatToStr(Field.AsFloat, FFormatSettings);
    end;
   end else
    Result:= Field.AsString;
  end else
   Result:= '';
 except
 end;
end;

function TPrismDataLinkField.ReadOnly: boolean;
begin
 if Assigned(FPrismControl) and (TPrismControl(FPrismControl).Initilized) then
 begin
  Result:= true;

  try
   if Active then
    if CanModify then
     if (Editing) or (DataSource.AutoEdit) then
      result:= false;
  except
  end;
 end else
  Result:= False;
end;

procedure TPrismDataLinkField.RefreshValue;
begin
 FieldText;
end;

procedure TPrismDataLinkField.SetDataWareMapped(const Value: TPrismDataWareMapped);
begin
 FPrismDataWareMapped:= Value;
end;

procedure TPrismDataLinkField.SetEditDataType(AEditType: TPrismFieldType);
begin
 FDataType:= AEditType;
end;

procedure TPrismDataLinkField.SetFieldName(const Value: string);
begin
 try
  FFieldName := Value;

  UpdateField;
 except
  on E: Exception do
  begin
   try
    if Assigned(DataSet) then
     E.Message:= Trim(E.Message + ' Dataset: ' + DataSet.Name);
   except
   end;

   try
    if Assigned(FPrismControl) then
     TPrismControl(FPrismControl).Session.DoException(TPrismControl(FPrismControl).VCLComponent, E, 'SetValue')
    else
     PrismBaseClass.DoException(nil, E, nil, 'SetFieldName');
   except
   end;
  end;
 end;
end;

procedure TPrismDataLinkField.SetFieldValue(AValue: Variant);
begin
 try
  FValueSetWithError:= false;

  if Assigned(Field) and Assigned(DataSet) and DataSet.Active then
  begin
   if (not Editing) then
    if not Edit then
     exit;

   Field.Value := AValue;
  end;
 except
  on E: Exception do
  begin
   FValueSetWithError:= true;

   try
    if Assigned(DataSet) then
     E.Message:= Trim(E.Message + ' Dataset: ' + DataSet.Name);
   except
   end;

   try
    if Assigned(FPrismControl) then
     TPrismControl(FPrismControl).Session.DoException(TPrismControl(FPrismControl).VCLComponent, E, 'SetValue')
    else
     PrismBaseClass.DoException(nil, E, nil, 'SetValue');
   except
   end;
  end;
 end;
end;

procedure TPrismDataLinkField.SetFixFieldType(const Value: boolean);
begin
 FFixFieldType := Value;
end;

procedure TPrismDataLinkField.SetUseHTMLFormatSettings(Value: Boolean);
begin
 if Value then
  FFormatSettings:= PrismBaseClass.Options.HTMLFormatSettings
 else
  FFormatSettings:= TPrismControl(FPrismControl).Session.FormatSettings;

 FUseHTMLFormatSettings:= Value;
end;

procedure TPrismDataLinkField.SetValueHTMLElement(AValue: string);
var
 vDateTime: TDateTime;
 vFloat: Double;
 vCurrency: Currency;
begin
 try
  FValueSetWithError:= false;

  if Assigned(Field) and Assigned(DataSet) and DataSet.Active then
  begin
   if (not Editing) then
    if not Edit then
     exit;

   if (FDataType in [PrismFieldTypeDate]) or (FixFieldType and (Field.DataType in [ftDate])) then
   begin
    if (AValue = '') or (AValue = '0') then
     Field.Clear
    else
    begin
     if (not (Field.DataType in [ftDate])) and (Field.DataType in [ftWideString]) then
      Field.AsString:= AValue
     else
     if TryStrToDate(AValue, vDateTime, FFormatSettings) then
      Field.AsDateTime:= TDate(vDateTime)
     else
     begin
      if (Field is TDateTimeField) and ((Field as TDateTimeField).DisplayFormat <> '') then
       AValue:= FixDateTimeByFormat(AValue, Field.AsDateTime, (Field as TDateTimeField).DisplayFormat, FFormatSettings.ShortDateFormat);
      if TryStrToDate(AValue, vDateTime, FFormatSettings) then
       Field.AsDateTime:= TDate(vDateTime)
     end;
    end;
   end else
   if (FDataType in [PrismFieldTypeDateTime]) or (FixFieldType and (Field.DataType in [ftDateTime])) then
   begin
    if (AValue = '') or (AValue = '0') then
     Field.Clear
    else
    begin
     if (not (Field.DataType in [ftDateTime])) and (Field.DataType in [ftWideString]) then
      Field.AsString:= AValue
     else
     if TryStrToDateTime(AValue, vDateTime, FFormatSettings) then
      Field.AsDateTime:= TDate(vDateTime)
     else
     begin
      if (Field is TDateTimeField) and ((Field as TDateTimeField).DisplayFormat <> '') then
       AValue:= FixDateTimeByFormat(AValue, Field.AsDateTime, (Field as TDateTimeField).DisplayFormat, FFormatSettings.ShortDateFormat+' '+FFormatSettings.ShortTimeFormat);
      if TryStrToDateTime(AValue, vDateTime, FFormatSettings) then
       Field.AsDateTime:= TDate(vDateTime)
     end;
    end;
   end else
   if (FDataType in [PrismFieldTypeTime]) or (FixFieldType and (Field.DataType in [ftTime, ftTimeStamp])) then
   begin
    if (AValue = '') or (AValue = '00:00') or (AValue = '00:00:00') or (AValue = '0') then
     Field.AsString:= '00:00:00'
    else
    begin
     if TryStrToTime(AValue, vDateTime, FFormatSettings) then
      Field.AsDateTime:= TDate(vDateTime)
    end;
   end else
   if (FDataType in [PrismFieldTypeNumber]) or (FixFieldType and (Field.DataType in [ftFloat{$IFDEF SUPPORTS_FTEXTENDED}, ftExtended{$ENDIF}, ftFMTBcd, ftBCD, ftCurrency])) then
   begin
    AValue:= FixFloat(AValue, FFormatSettings);
    if (AValue = '') then
     Field.Clear
    else
    begin
     if Field.DataType in [ftCurrency] then
     begin
       if TryStrToCurr(AValue, vCurrency, FFormatSettings) then
         Field.AsCurrency := vCurrency;
     end else
      if Field.DataType in [ftBCD, ftFMTBcd] then
      begin
        if TryStrToCurr(AValue, vCurrency, FFormatSettings) then
          Field.AsBCD := DoubleToBcd(vCurrency); // ou Field.Value := CurrToBCD(...)
      end else
      begin
        if TryStrToFloat(AValue, vFloat, FFormatSettings) then
          Field.AsFloat := vFloat;
      end;
    end;
   end else
    Field.AsString:= AValue;
  end;
 except
  on E: Exception do
  begin
   FValueSetWithError:= true;

   try
    if Assigned(DataSet) then
     E.Message:= Trim(E.Message + ' Dataset: ' + DataSet.Name);
   except
   end;

   try
    if Assigned(FPrismControl) then
     TPrismControl(FPrismControl).Session.DoException(TPrismControl(FPrismControl).VCLComponent, E, 'SetValue')
    else
     PrismBaseClass.DoException(nil, E, nil, 'SetValue');
   except
   end;
  end;
 end;
end;


procedure TPrismDataLinkField.UpdateField;
begin
 try
  if Active and (FFieldName <> '') then
  begin
   FField := DataSet.FindField(FFieldName);
  end;
 except
 end;
end;

{$ELSE}
implementation
{$ENDIF}

end.
