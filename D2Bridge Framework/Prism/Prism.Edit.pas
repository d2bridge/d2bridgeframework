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

unit Prism.Edit;

interface

uses
  Classes, SysUtils, Variants, D2Bridge.JSON,
{$IFDEF HAS_UNIT_SYSTEM_UITYPES}
  System.UITypes,
{$ENDIF}
{$IFDEF FPC}
  StdCtrls,
{$ENDIF}
  Prism.Forms.Controls, Prism.Interfaces, Prism.Types;


type
 TPrismFieldType = Prism.Types.TPrismFieldType;


type
 TPrismEdit = class(TPrismControl, IPrismEdit)
  private
   FStoredText: String;
   FStoredTextMask: String;
   FStoredDataType: TPrismFieldType;
   FProcSetText: TOnSetValue;
   FProcGetText: TOnGetValue;
   FDataType: TPrismFieldType;
   FCharCase: TEditCharCase;
   FTextMask: string;
   FMaxLength: integer;
{$IFDEF FPC}
  protected
{$ENDIF}
   procedure SetText(AText: String);
   function GetText: String;
   procedure SetEditDataType(AEditType: TPrismFieldType);
   function GetEditDataType: TPrismFieldType;
   function GetCharCase: TEditCharCase;
   procedure SetCharCase(ACharCase: TEditCharCase);
   procedure SetTextMask(AValue: string);
   function GetTextMask: string;
   function GetMaxLength: integer;
   procedure SetMaxLength(const Value: integer);
  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   function IsEdit: Boolean; override;
   function ValidationGroupPassed: Boolean; override;
  public
   constructor Create(AOwner: TObject); override;

   property MaxLength: integer read GetMaxLength write SetMaxLength;
   property Text: String read GetText write SetText;
   property TextMask: string read GetTextMask write SetTextMask;
   property CharCase: TEditCharCase read GetCharCase write SetCharCase;
   property DataType: TPrismFieldType read GetEditDataType write SetEditDataType;
   property ProcSetText: TOnSetValue read FProcSetText write FProcSetText;
   property ProcGetText: TOnGetValue read FProcGetText write FProcGetText;
 end;



implementation

uses
  Prism.Util, Prism.Text.Mask;

{ TPrismEdit }

constructor TPrismEdit.Create(AOwner: TObject);
begin
 inherited;

 FMaxLength:= 0;
 FDataType:= PrismFieldTypeAuto;
end;

function TPrismEdit.GetCharCase: TEditCharCase;
begin
 Result:= FCharCase;
end;

function TPrismEdit.GetEditDataType: TPrismFieldType;
begin
 Result:= FDataType;
end;

function TPrismEdit.GetEnableComponentState: Boolean;
begin
 Result:= true;
end;

function TPrismEdit.GetMaxLength: integer;
begin
 Result:= FMaxLength;
end;

function TPrismEdit.GetText: String;
var
 vDateTime: TDateTime;
 vFloatValue: Double;
begin
 if Assigned(ProcGetText) then
 begin
  Result:= ProcGetText;

  try
   if DataType in [PrismFieldTypeDate, PrismFieldTypeDateTime] then
   begin
    if (Result <> '') and (Result <> '0') then
    begin
     if (DataType in [PrismFieldTypeDate]) and (TryStrToDate(Result, vDateTime)) then
     begin
      Result:= DateToStr(vDateTime, PrismOptions.HTMLFormatSettings);
     end else
     if (DataType in [PrismFieldTypeDateTime]) and (TryStrToDateTime(Result, vDateTime)) then
     begin
      Result:= DateTimeToStr(vDateTime, PrismOptions.HTMLFormatSettings);
     end;
    end;
   end else
   if DataType in [PrismFieldTypeTime] then
   begin
    if (Result <> '') and (Result <> '0') then
    begin
     if (TryStrToTime(Result, vDateTime)) then
     begin
      Result:= TimeToStr(vDateTime, PrismOptions.HTMLFormatSettings);
     end;
    end;
   end else
   if DataType in [PrismFieldTypeNumber] then
   begin
    if (Result <> '') and (Result <> '0') then
    begin
     if (TryStrToFloat(Result, vFloatValue)) then
     begin
      Result:= FloatToStr(vFloatValue, PrismOptions.HTMLFormatSettings);
     end;
    end;
   end;
  except
  end;
 end else
 Result:= FStoredText;
end;

function TPrismEdit.GetTextMask: string;
begin
 Result:= FTextMask;
end;

procedure TPrismEdit.Initialize;
begin
 inherited;

 FStoredText:= Text;
 FStoredTextMask:= TextMask;
 FStoredDataType:= DataType;
end;

function TPrismEdit.IsEdit: Boolean;
begin
 Result:= true;
end;

procedure TPrismEdit.ProcessComponentState(
  const ComponentStateInfo: TJSONObject);
begin
 inherited;

 if (ComponentStateInfo.GetValue('text') <> nil) then
 Text:= ComponentStateInfo.GetValue('text').Value;
end;

procedure TPrismEdit.ProcessEventParameters(Event: IPrismControlEvent;
  Parameters: TStrings);
begin
  inherited;

end;

procedure TPrismEdit.ProcessHTML;
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

 if (MaxLength > 0) then
 begin
  if DataType in [PrismFieldTypeInteger, PrismFieldTypeNumber] then
  begin
   HTMLControl := HTMLControl + ' ' + 'oninput="if(this.value.length > ' + IntToStr(MaxLength) + ') this.value = this.value.slice(0, ' + IntToStr(MaxLength) + ');"';
  end else
   HTMLControl := HTMLControl + ' ' + 'maxlength="' + IntToStr(MaxLength) + '"';
 end;

 if TextMask <> '' then
  HTMLControl := HTMLControl + ' ' + 'data-inputmask="' + TextMask + '"';

 HTMLControl := HTMLControl + ' ' + InputHTMLTypeByPrismFieldType(FDataType) + ' ';

 HTMLControl := HTMLControl + ' value = "' + FormatTextHTML(Text) + '"';
 HTMLControl := HTMLControl + '/>';
end;


procedure TPrismEdit.SetCharCase(ACharCase: TEditCharCase);
begin
 FCharCase:= ACharCase;
end;

procedure TPrismEdit.SetEditDataType(AEditType: TPrismFieldType);
begin
 if AEditType = PrismFieldTypeInteger then
 begin
  TextMask:= TPrismTextMask.Integer;
 end else
 FDataType:= AEditType;
end;

procedure TPrismEdit.SetMaxLength(const Value: integer);
begin
 FMaxLength:= Value;
end;

procedure TPrismEdit.SetText(AText: String);
var
 vDateTime: TDateTime;
 vFloatValue: Double;
begin
 if Assigned(ProcSetText) then
  if FStoredText <> AText then
  begin
   try
    if DataType in [PrismFieldTypeDate, PrismFieldTypeDateTime] then
    begin
     if (AText <> '') and (AText <> '0') then
     begin
      if (DataType in [PrismFieldTypeDate]) and (TryStrToDate(AText, vDateTime, PrismOptions.HTMLFormatSettings)) then
      begin
       AText:= DateToStr(vDateTime);
      end else
      if (DataType in [PrismFieldTypeDateTime]) and (TryStrToDateTime(AText, vDateTime, PrismOptions.HTMLFormatSettings)) then
      begin
       AText:= DateTimeToStr(vDateTime);
      end;
     end;
    end else
    if DataType in [PrismFieldTypeTime] then
    begin
     if (AText <> '') and (AText <> '0') then
     begin
      if (TryStrToTime(AText, vDateTime, PrismOptions.HTMLFormatSettings)) then
      begin
       AText:= TimeToStr(vDateTime);
      end;
     end;
    end else
    if DataType in [PrismFieldTypeNumber] then
    begin
     if (AText <> '') and (AText <> '0') then
     begin
      if (TryStrToFloat(AText, vFloatValue, PrismOptions.HTMLFormatSettings)) then
      begin
       AText:= FloatToStr(vFloatValue);
      end;
     end;
    end;
   except
   end;

   ProcSetText(AText);
  end;

 FStoredText:= AText;
end;

procedure TPrismEdit.SetTextMask(AValue: string);
begin
 FTextMask:= TPrismTextMask.ProcessTextMask(AValue);
end;

procedure TPrismEdit.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
var
 NewText, NewTextMask: string;
 NewDataType: TPrismFieldType;
begin
 inherited;

 NewText:= Text;
 if (AForceUpdate) or (FStoredText <> NewText) then
 begin
  FStoredText:= NewText;
  ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").value = '+ FormatValueHTML(FStoredText) +';');
 end;

 NewDataType:= DataType;
 if (AForceUpdate) or (FStoredDataType <> NewDataType) then
 begin
  FStoredDataType:= NewDataType;
  ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").' + InputHTMLTypeByPrismFieldType(FStoredDataType) +';');
 end;

 NewTextMask:= TextMask;
 if (AForceUpdate) or (FStoredTextMask <> NewTextMask) then
 begin
  FStoredTextMask:= NewTextMask;
  ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).inputmask("remove");');
  if FStoredTextMask <> '' then
  ScriptJS.Add('$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix)+'";}).inputmask({' + FStoredTextMask + '});');
 end;
end;

function TPrismEdit.ValidationGroupPassed: Boolean;
begin
 if Required and (Text = '') and Visible and (not ReadOnly) then
  Result:= false
 else
  Result:= true;
end;

end.