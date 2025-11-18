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

unit Prism.DBEdit;

interface

{$IFNDEF FMX}
uses
  Classes, D2Bridge.JSON, SysUtils,
{$IFDEF HAS_UNIT_SYSTEM_UITYPES}
  System.UITypes,
{$ENDIF}
  DB,
{$IFNDEF FPC}

{$ELSE}
  StdCtrls,
{$ENDIF}
  Variants,
  DBCtrls,
  Prism.Interfaces, Prism.Forms.Controls, Prism.Types, Prism.DataLink.Field;

type
 TPrismDBEdit = class(TPrismControl, IPrismDBEdit)
  private
   FRefreshData: Boolean;
   FStoredFieldValue: Variant;
   FStoredTextHTMLElement: string;
   FStoredFieldValueMask: String;
   FStoredDataType: TPrismFieldType;
   FDataLinkField: TPrismDataLinkField;
   FCharCase: TEditCharCase;
   FTextMask: string;
   FStoredFieldAlignment: TAlignment;
   procedure UpdateData; override;
   function GetCharCase: TEditCharCase;
   procedure SetCharCase(ACharCase: TEditCharCase);
   procedure SetTextMask(AValue: string);
   function GetTextMask: string;
   procedure SetEditDataType(AEditType: TPrismFieldType);
   function GetEditDataType: TPrismFieldType;
  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   function IsDBEdit: Boolean; override;
   function GetReadOnly: Boolean; override;
  public
   constructor Create(AOwner: TObject); override;
   destructor Destroy; override;

   function DataWare: TPrismDataLinkField;

   property CharCase: TEditCharCase read GetCharCase write SetCharCase;
   property TextMask: string read GetTextMask write SetTextMask;
   property DataType: TPrismFieldType read GetEditDataType write SetEditDataType;
 end;


implementation

uses
  DateUtils,
  Prism.Util, Prism.Text.Mask, Prism.BaseClass;

{ TPrismDBEdit }

constructor TPrismDBEdit.Create(AOwner: TObject);
begin
 inherited;

 FRefreshData:= false;
 FDataLinkField:= TPrismDataLinkField.Create(Self);
 FDataLinkField.UseHTMLFormatSettings:= true;
 FStoredTextHTMLElement:= '';
 FStoredFieldAlignment:= taLeftJustify;
end;

function TPrismDBEdit.DataWare: TPrismDataLinkField;
begin
 result:= FDataLinkField;
end;

destructor TPrismDBEdit.Destroy;
begin
 FreeAndNil(FDataLinkField);
 inherited;
end;

function TPrismDBEdit.GetCharCase: TEditCharCase;
begin
 result:= FCharCase;
end;


function TPrismDBEdit.GetEditDataType: TPrismFieldType;
begin
 result:= FDataLinkField.DataType;
end;

function TPrismDBEdit.GetEnableComponentState: Boolean;
begin
 Result:= true;
end;

function TPrismDBEdit.GetReadOnly: Boolean;
begin
 result:= Inherited;

 if not result then
  result:= FDataLinkField.ReadOnly;
end;

function TPrismDBEdit.GetTextMask: string;
begin
 Result:= FTextMask;
end;

procedure TPrismDBEdit.Initialize;
begin
 inherited;

 FStoredFieldValue:= DataWare.FieldValue;
 FStoredDataType:= DataWare.DataType;
 FStoredFieldValueMask:= TextMask;

 //Text Align
 try
  if Assigned(DataWare.DataSource) then
  if Assigned(DataWare.DataSet) then
  if DataWare.Active and Assigned(DataWare.Field) then
  begin
   if DataWare.Field.Alignment = taRightJustify then
   begin
    FStoredFieldAlignment:= DataWare.Field.Alignment;
    HTMLCore:= HTMLAddItemFromClass(HTMLCore, 'text-end');
    HTMLCore:= HTMLRemoveItemFromClass(HTMLCore, 'text-start');
    HTMLCore:= HTMLRemoveItemFromClass(HTMLCore, 'text-center');
   end else
   if DataWare.Field.Alignment = taCenter then
   begin
    FStoredFieldAlignment:= DataWare.Field.Alignment;
    HTMLCore:= HTMLAddItemFromClass(HTMLCore, 'text-center');
    HTMLCore:= HTMLRemoveItemFromClass(HTMLCore, 'text-start');
    HTMLCore:= HTMLRemoveItemFromClass(HTMLCore, 'text-end');
   end;
  end;
 except
 end;
end;

function TPrismDBEdit.IsDBEdit: Boolean;
begin
 Result:= true;
end;

procedure TPrismDBEdit.ProcessComponentState(const ComponentStateInfo: TJSONObject);
var
 vText: string;
begin
 inherited;

 if (ComponentStateInfo.GetValue('text') <> nil) then
 begin
  vText:= ComponentStateInfo.GetValue('text').Value;

  if vText <> FStoredTextHTMLElement then
  begin
   DataWare.ValueHTMLElement:= vText;

   if not DataWare.ValueSetWithError then
   begin
    FStoredFieldValue:= DataWare.FieldValue;
    FStoredTextHTMLElement:= vText;
   end else
    FStoredFieldValue:= vText;
  end;
 end;
end;

procedure TPrismDBEdit.ProcessEventParameters(Event: IPrismControlEvent;
  Parameters: TStrings);
begin
  inherited;

end;

procedure TPrismDBEdit.ProcessHTML;
var
 vHTMLCore: string;
begin
 inherited;

 vHTMLCore:= HTMLCore;

 if CharCase = TEditCharCase.ecLowerCase then
  vHTMLCore:= HTMLAddItemFromClass(HTMLCore, 'text-lowercase')
 else
 if CharCase = TEditCharCase.ecUpperCase then
  vHTMLCore:= HTMLAddItemFromClass(HTMLCore, 'text-uppercase');


 HTMLControl := '<input';

 HTMLControl := HTMLControl + ' ' + vHTMLCore;

 HTMLControl := HTMLControl + ' lang="' + Form.Language+'" ';

 if TextMask <> '' then
 begin
  DataWare.FixFieldType:= false;
  DataType := PrismFieldTypeString;
  HTMLControl := HTMLControl + ' ' + 'data-inputmask="' + TextMask + '"';
 end else
  if DataType = PrismFieldTypeInteger then
  begin
   DataWare.FixFieldType:= false;
   TextMask:= TPrismTextMask.Integer;
  end;

 HTMLControl := HTMLControl + ' ' + InputHTMLTypeByPrismFieldType(DataType) + ' ';

 FStoredTextHTMLElement:= DataWare.ValueHTMLElement;
 HTMLControl := HTMLControl + ' value="' + FormatTextHTML(FStoredTextHTMLElement) + '"';
 HTMLControl := HTMLControl + '/>';
end;

procedure TPrismDBEdit.SetCharCase(ACharCase: TEditCharCase);
begin
 FCharCase:= ACharCase;
end;


procedure TPrismDBEdit.SetEditDataType(AEditType: TPrismFieldType);
begin
 FDataLinkField.DataType:= AEditType;
end;


procedure TPrismDBEdit.SetTextMask(AValue: string);
begin
 FTextMask:= TPrismTextMask.ProcessTextMask(AValue);

 FStoredFieldValueMask:= FTextMask;
end;


procedure TPrismDBEdit.UpdateData;
begin
 if (Form.FormPageState = PageStateLoaded) and (not Form.ComponentsUpdating) then
 FRefreshData:= true;
end;

procedure TPrismDBEdit.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
var
 NewFieldValue: variant;
 NewTextMask: string;
 NewDataType: TPrismFieldType;
 vNewFormatedValue: string;
begin
 inherited;

 NewDataType:= DataWare.DataType;
 if (AForceUpdate) or (FStoredDataType <> NewDataType) then
 begin
  FStoredDataType:= DataWare.DataType;
  ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").'+InputHTMLTypeByPrismFieldType(DataType)+';');
 end;

 NewFieldValue:= DataWare.FieldText(AForceUpdate);
 if (AForceUpdate) or (VarToStr(FStoredFieldValue) <> VarToStr(NewFieldValue)) then
 begin
  FStoredTextHTMLElement:= DataWare.ValueHTMLElement;
  FStoredFieldValue:= NewFieldValue;
  vNewFormatedValue:= FormatValueHTML(FStoredTextHTMLElement);
  ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").value = '+ vNewFormatedValue +';');
  ScriptJS.Add('if (document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").value !== ' + vNewFormatedValue + ') {');
  ScriptJS.Add('  document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").type = "text";');
  ScriptJS.Add('  document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").value = '+ vNewFormatedValue +';');
  ScriptJS.Add('}');
 end;

  //Align
  if Assigned(DataWare.Field) then
  if FStoredFieldAlignment <> DataWare.Field.Alignment then
  begin
   FStoredFieldAlignment := DataWare.Field.Alignment;

   if FStoredFieldAlignment = taRightJustify then
   begin
    ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).addClass("text-end");');
    ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).removeClass("text-start");');
    ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).removeClass("text-center");');
   end else
   if FStoredFieldAlignment = taCenter then
   begin
    ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).addClass("text-center");');
    ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).removeClass("text-start");');
    ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).removeClass("text-end");');
   end;
  end;

 NewTextMask:= TextMask;
 if (AForceUpdate) or (FStoredFieldValueMask <> NewTextMask) then
 begin
  FStoredFieldValueMask:= NewTextMask;

  ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).inputmask("remove");');
  if FStoredFieldValueMask <> '' then
  ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).inputmask({' + FStoredFieldValueMask + '});');
 end;

end;


{$ELSE}
implementation
{$ENDIF}

end.