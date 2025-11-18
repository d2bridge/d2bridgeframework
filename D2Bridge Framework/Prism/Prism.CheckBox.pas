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

unit Prism.CheckBox;

interface

uses
  Classes, SysUtils, D2Bridge.JSON, Rtti, StrUtils,
  Prism.Forms.Controls, Prism.Interfaces, Prism.Types;


type
 TPrismCheckBox = class(TPrismControl, IPrismCheckBox)
  strict private
   procedure Exec_SetChecked(varChecked: TValue);
  private
   FStoredChecked: Boolean;
   FStoredText: String;
   FProcGetText: TOnGetValue;
   FProcGetChecked: TOnGetValue;
   FProcSetChecked: TOnSetValue;
   FSwitchMode: Boolean;
   function GetText: String;
   procedure SetChecked(AValue: Boolean);
   function GetChecked: Boolean;
   function GetSwitchMode: Boolean;
   procedure SetSwitchMode(const Value: Boolean);
  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   function IsCheckBox: Boolean; override;
   function NeedCheckValidation: Boolean; override;
  public
   constructor Create(AOwner: TObject); override;

   property Text: String read GetText;
   property Checked: Boolean read GetChecked write SetChecked;
   property ProcGetText: TOnGetValue read FProcGetText write FProcGetText;
   property ProcGetChecked: TOnGetValue read FProcGetChecked write FProcGetChecked;
   property ProcSetChecked: TOnSetValue read FProcSetChecked write FProcSetChecked;
   property SwitchMode: Boolean read GetSwitchMode write SetSwitchMode;
 end;



implementation

uses
  Prism.Util;

{ TPrismCheckBox }

constructor TPrismCheckBox.Create(AOwner: TObject);
begin
 inherited;

 FSwitchMode:= true;
end;

procedure TPrismCheckBox.Exec_SetChecked(varChecked: TValue);
begin
 ProcSetChecked(varChecked.AsBoolean);
 FStoredChecked:= varChecked.AsBoolean;
end;

function TPrismCheckBox.GetChecked: Boolean;
begin
 if Assigned(ProcGetChecked) then
  Result:= ProcGetChecked;
end;

function TPrismCheckBox.GetEnableComponentState: Boolean;
begin
 Result:= true;
end;

function TPrismCheckBox.GetSwitchMode: Boolean;
begin
 Result := FSwitchMode;
end;

function TPrismCheckBox.GetText: String;
begin
 if Assigned(ProcGetText) then
  Result:= ProcGetText;
end;

procedure TPrismCheckBox.Initialize;
begin
 inherited;

 FStoredText:= Text;
 FStoredChecked:= Checked;
end;

function TPrismCheckBox.IsCheckBox: Boolean;
begin
 Result:= true;
end;

function TPrismCheckBox.NeedCheckValidation: Boolean;
begin
 Result:= true;
end;

procedure TPrismCheckBox.ProcessComponentState(
  const ComponentStateInfo: TJSONObject);
var
 NewChecked: Boolean;
begin
 inherited;

 if (ComponentStateInfo.GetValue('checked') <> nil) then
 begin
  NewChecked:= SameText(ComponentStateInfo.GetValue('checked').Value, 'true');
  if FStoredChecked <> NewChecked then
  begin
   Checked:= NewChecked;
  end;
 end;
end;

procedure TPrismCheckBox.ProcessEventParameters(Event: IPrismControlEvent;
  Parameters: TStrings);
begin
  inherited;

end;

procedure TPrismCheckBox.ProcessHTML;
var
 vChecked: string;
begin
 inherited;

 if Checked then
 vChecked:= 'checked'
 else
 vChecked:= '';

 HTMLControl := '<div class="d2bridgeswtich form-check' + IfThen(FSwitchMode, ' form-switch')+'">' + sLineBreak;
 HTMLControl := HTMLControl + '<input ' + HTMLCore +' type="checkbox" role="switch" '+ vChecked +'>' + sLineBreak;
 HTMLControl := HTMLControl + '<label class="form-check-label" for="' + AnsiUpperCase(NamePrefix) + '">' + Text + '</label>' + sLineBreak;
 HTMLControl := HTMLControl + '</div>';
end;


procedure TPrismCheckBox.SetChecked(AValue: Boolean);
begin
 if Assigned(ProcSetChecked) then
 begin
  if FStoredChecked <> AValue then
  begin
   Form.Session.ExecThread(false,
    Exec_SetChecked,
    TValue.From<Boolean>(AValue)
   );
  end;
 end else
  FStoredChecked:= AValue;
end;

procedure TPrismCheckBox.SetSwitchMode(const Value: Boolean);
begin
 FSwitchMode := Value;
end;

procedure TPrismCheckBox.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
var
 NewChecked: Boolean;
 NewText: String;
begin
 inherited;

 NewText:= Text;
 if (FStoredText <> Text) or (AForceUpdate) then
 begin
  FStoredText := NewText;
  ScriptJS.Add('document.querySelector("label[for='+AnsiUpperCase(NamePrefix)+']").textContent  = "'+ Text +'";');
 end;

 NewChecked:= Checked;
 if (FStoredChecked <> NewChecked) or (AForceUpdate) then
 begin
  FStoredChecked := NewChecked;
  ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").checked = '+ NewChecked.ToString(FStoredChecked, TUseBoolStrs.True).ToLower +';');
 end;

end;

end.