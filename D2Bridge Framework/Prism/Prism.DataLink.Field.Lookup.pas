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

unit Prism.DataLink.Field.Lookup;

interface

{$IFNDEF FMX}
uses
 Classes, SysUtils, DBCtrls, DB, Variants,
 Prism.Types, Prism.DataLink.Field;

type
 TPrismDataLinkFieldLookup = class(TPrismDataLinkField)
  private
   FLastKeyFieldValue: string;
   FKeyField: TField;
   FKeyFieldName: string;
   procedure SetKeyFieldValue(const Value: Variant);
   procedure SetKeyFieldName(const Value: string);
   function GetKeyFieldValue: Variant; overload;
   function GetKeyFieldValue(AIgnoreDisableControl: Boolean): Variant; overload;
  protected
   procedure UpdateField; override;
   procedure RefreshValue; override;
  public
   constructor Create(APrismControlOwner: TObject);

   function KeyFieldText(AIgnoreDisableControl: Boolean = false): string;

   property KeyFieldValue: Variant read GetKeyFieldValue write SetKeyFieldValue;

   property KeyField: TField read FKeyField;
   property KeyFieldName: string read FKeyFieldName write SetKeyFieldName;
 end;

implementation

{$ELSE}
implementation
{$ENDIF}

{ TPrismDataLinkFieldLookup }

constructor TPrismDataLinkFieldLookup.Create(APrismControlOwner: TObject);
begin
 inherited;

 FLastKeyFieldValue:= '';
end;

function TPrismDataLinkFieldLookup.GetKeyFieldValue: Variant;
begin
 Result:= GetKeyFieldValue(false);
end;

function TPrismDataLinkFieldLookup.GetKeyFieldValue(AIgnoreDisableControl: Boolean): Variant;
begin
 try
  Result:= '';

  if AIgnoreDisableControl or (not DataSet.ControlsDisabled) then
  begin
   if Assigned(KeyField) and Assigned(DataSet) and DataSet.Active and (not KeyField.IsNull) then
    Result:= KeyField.Value;
  end else
   Result:= FLastKeyFieldValue;

  FLastKeyFieldValue:= Result;
 except
 end;
end;

function TPrismDataLinkFieldLookup.KeyFieldText(AIgnoreDisableControl: Boolean = false): string;
begin
 result:= VarToStrDef(GetKeyFieldValue(AIgnoreDisableControl), '');
end;

procedure TPrismDataLinkFieldLookup.RefreshValue;
begin
 inherited;

 KeyFieldText;
end;

procedure TPrismDataLinkFieldLookup.SetKeyFieldName(const Value: string);
begin
 FKeyFieldName := Value;

 UpdateField;
end;

procedure TPrismDataLinkFieldLookup.SetKeyFieldValue(const Value: Variant);
var
 vValueStr: string;
begin
 if Assigned(KeyField) and Assigned(DataSet) and DataSet.Active then
 begin
  vValueStr:= VarToStrDef(Value, '');

  if (vValueStr = '') or
     (not DataSet.Locate(FKeyFieldName, Value, [])) then
  begin
   if DataSet.State <> dsInsert then
    DataSet.Insert;
  end;
 end;
end;

procedure TPrismDataLinkFieldLookup.UpdateField;
begin
 inherited;

 try
  if Active and (FKeyFieldName <> '') then
  begin
   FKeyField := DataSet.FindField(FKeyFieldName);
  end;
 except
 end;
end;

end.
