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

unit Prism.Text;

interface

uses
  Classes, SysUtils, D2Bridge.JSON,
  Prism.Forms.Controls, Prism.Interfaces, Prism.Types;


type
 TPrismLabel = class(TPrismControl, IPrismLabel)
  private
   FStoredText: String;
   FProcGetText: TOnGetValue;
   FDataType: TPrismFieldType;
   FIsHTMLContent: boolean;
   function GetText: String;
   function GetIsHTMLContent: Boolean;
   procedure SetIsHTMLContent(const Value: Boolean);
  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   function IsLabel: Boolean; override;
   procedure SetDataType(Value: TPrismFieldType);
   function GetDataType: TPrismFieldType;
  public
   constructor Create(AOwner: TObject); override;

   property Text: String read GetText;
   property ProcGetText: TOnGetValue read FProcGetText write FProcGetText;
   property DataType: TPrismFieldType read GetDataType write SetDataType;
   property IsHTMLContent: Boolean read GetIsHTMLContent write SetIsHTMLContent;
 end;



implementation

uses
  Prism.Util;

{ TPrismLabel }

constructor TPrismLabel.Create(AOwner: TObject);
begin
 inherited;

 FDataType:= PrismFieldTypeAuto;
 FIsHTMLContent:= false;
end;

function TPrismLabel.GetDataType: TPrismFieldType;
begin
 result:= FDataType;
end;

function TPrismLabel.GetEnableComponentState: Boolean;
begin
 Result:= true;
end;

function TPrismLabel.GetIsHTMLContent: Boolean;
begin
 result:= FIsHTMLContent;
end;

function TPrismLabel.GetText: String;
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
     if (DataType in [PrismFieldTypeDate]) and (TryStrToDate(Result, vDateTime, Session.FormatSettings)) then
     begin
      Result:= DateToStr(vDateTime, Session.FormatSettings);
     end else
     if (DataType in [PrismFieldTypeDateTime]) and (TryStrToDateTime(Result, vDateTime, Session.FormatSettings)) then
     begin
      Result:= DateTimeToStr(vDateTime, Session.FormatSettings);
     end;
    end;
   end else
   if DataType in [PrismFieldTypeTime] then
   begin
    if (Result <> '') and (Result <> '0') then
    begin
     if (TryStrToTime(Result, vDateTime, Session.FormatSettings)) then
     begin
      Result:= TimeToStr(vDateTime, Session.FormatSettings);
     end;
    end;
   end else
   if DataType in [PrismFieldTypeNumber] then
   begin
    if (Result <> '') and (Result <> '0') then
    begin
     if (TryStrToFloat(Result, vFloatValue, Session.FormatSettings)) then
     begin
      Result:= FloatToStr(vFloatValue, Session.FormatSettings);
     end;
    end;
   end;
  except
  end;
 end else
  Result:= FStoredText;

end;

procedure TPrismLabel.Initialize;
begin
 inherited;

 FStoredText:= Text;
end;

function TPrismLabel.IsLabel: Boolean;
begin
 Result:= true;
end;

procedure TPrismLabel.ProcessComponentState(const ComponentStateInfo: TJSONObject);
begin
 inherited;

end;

procedure TPrismLabel.ProcessEventParameters(Event: IPrismControlEvent;
  Parameters: TStrings);
begin
  inherited;

end;

procedure TPrismLabel.ProcessHTML;
begin
 inherited;

 HTMLControl := '<span';
 HTMLControl := HTMLControl + ' ' + HTMLCore;
 HTMLControl := HTMLControl + '>';
 if FIsHTMLContent then
  HTMLControl := HTMLControl + FStoredText
 else
  HTMLControl := HTMLControl + FormatTextHTML(FStoredText);
 HTMLControl := HTMLControl + '</span>';
end;

procedure TPrismLabel.SetDataType(Value: TPrismFieldType);
begin
 FDataType:= Value;
end;

procedure TPrismLabel.SetIsHTMLContent(const Value: Boolean);
begin
 FIsHTMLContent:= Value;
end;

procedure TPrismLabel.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
var
 NewText: string;
begin
 inherited;

 NewText:= Text;
 if (AForceUpdate) or (FStoredText <> NewText) then
 begin
  FStoredText := NewText;
  if FIsHTMLContent then
   ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").innerHTML = `'+  FStoredText +'`;')
  else
   ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").textContent = '+  FormatValueHTML(FStoredText) +';');
 end;

end;

end.