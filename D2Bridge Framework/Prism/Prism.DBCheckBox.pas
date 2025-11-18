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

unit Prism.DBCheckBox;

interface

{$IFNDEF FMX}
uses
  Classes, SysUtils, D2Bridge.JSON, DB, StrUtils,
  DBCtrls, Rtti,
  Prism.Forms.Controls, Prism.DataLink.Field, Prism.Interfaces, Prism.Types;



type
 TPrismDBCheckBox = class(TPrismControl, IPrismDBCheckBox)
  strict private
   procedure Exec_SetChecked(varChecked: TValue);
  private
   FDataLinkField: TPrismDataLinkField;
   FRefreshData: Boolean;
   FStoredChecked: Boolean;
   FStoredText: String;
   FProcGetText: TOnGetValue;
   FSwitchMode: boolean;
   FValueChecked: String;
   FValueUnChecked: String;
   function GetText: String;
   procedure SetDataSource(const Value: TDataSource);
   function GetDataSource: TDataSource;
   procedure SetDataField(AValue: String);
   function GetDataField: String;
   function GetValueChecked: String;
   procedure SetValueChecked(AValue: String);
   function GetValueUnChecked: String;
   procedure SetValueUnChecked(AValue: String);
   function GetChecked: Boolean;
   procedure SetChecked(AValue: Boolean);
   function GetSwitchMode: Boolean;
   procedure SetSwitchMode(const Value: Boolean);
   procedure UpdateData; override;
  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   function IsDBCheckBox: Boolean; override;
   function NeedCheckValidation: Boolean; override;
   function GetReadOnly: Boolean; override;
  public
   constructor Create(AOwner: TObject); override;
   destructor Destroy; override;

   property Text: String read GetText;
   property DataSource: TDataSource read GetDataSource write SetDataSource;
   property DataField: String read GetDataField write SetDataField;
   property ValueChecked: String read GetValueChecked write SetValueChecked;
   property ValueUnChecked: String read GetValueUnChecked write SetValueUnChecked;
   property Checked: Boolean read GetChecked write SetChecked;
   property SwitchMode: Boolean read GetSwitchMode write SetSwitchMode;
   property ProcGetText: TOnGetValue read FProcGetText write FProcGetText;
 end;



implementation

uses
  Prism.Util;

{ TPrismDBCheckBox }

constructor TPrismDBCheckBox.Create(AOwner: TObject);
begin
 inherited;

 FRefreshData:= false;
 FDataLinkField:= TPrismDataLinkField.Create(Self);
 FSwitchMode:= true;
end;

destructor TPrismDBCheckBox.Destroy;
begin
 FreeAndNil(FDataLinkField);

 inherited;
end;

procedure TPrismDBCheckBox.Exec_SetChecked(varChecked: TValue);
begin
 Checked:= varChecked.AsBoolean;
end;

function TPrismDBCheckBox.GetChecked: Boolean;
begin
 if Assigned(FDataLinkField.Field) then
 begin
  if Assigned(FDataLinkField.DataSource) and Assigned(FDataLinkField.DataSet) and (FDataLinkField.DataSet.Active) then
   Result:= SameText(FDataLinkField.FieldText, ValueChecked)
  else
   Result:= false;
 end else
 Result:= false;
end;

function TPrismDBCheckBox.GetDataField: String;
begin
 Result:= FDataLinkField.FieldName;
end;

function TPrismDBCheckBox.GetDataSource: TDataSource;
begin
 Result:= FDataLinkField.DataSource;
end;

function TPrismDBCheckBox.GetEnableComponentState: Boolean;
begin
 Result:= true;
end;

function TPrismDBCheckBox.GetReadOnly: Boolean;
var
 vResultCanEditing: boolean;
begin
 result:= Inherited;

 if not result then
  result:= FDataLinkField.ReadOnly;
end;

function TPrismDBCheckBox.GetSwitchMode: Boolean;
begin
 result:= FSwitchMode;
end;

function TPrismDBCheckBox.GetText: String;
begin
 result:= '';

 if Assigned(ProcGetText) then
  Result:= ProcGetText;
end;

function TPrismDBCheckBox.GetValueChecked: String;
begin
 Result:= FValueChecked;
end;

function TPrismDBCheckBox.GetValueUnChecked: String;
begin
 Result:= FValueUnChecked;
end;

procedure TPrismDBCheckBox.Initialize;
begin
 inherited;

 FStoredText:= Text;
 FStoredChecked:= Checked;
end;

function TPrismDBCheckBox.IsDBCheckBox: Boolean;
begin
 Result:= true;
end;

function TPrismDBCheckBox.NeedCheckValidation: Boolean;
begin
 result:= true;
end;

procedure TPrismDBCheckBox.ProcessComponentState(
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
   Form.Session.ExecThread(false,
    Exec_SetChecked,
    TValue.From<Boolean>(NewChecked)
   );
  end;
 end;

end;

procedure TPrismDBCheckBox.ProcessEventParameters(Event: IPrismControlEvent;
  Parameters: TStrings);
begin
  inherited;

end;

procedure TPrismDBCheckBox.ProcessHTML;
var
 vChecked: string;
begin
 inherited;

 if Checked then
 vChecked:= 'checked'
 else
 vChecked:= '';

 HTMLControl := '<div class="form-check' + IfThen(FSwitchMode, ' form-switch')+'">' + sLineBreak;
 HTMLControl := HTMLControl + '<input ' + HTMLCore +' type="checkbox" role="switch" '+ vChecked +'>' + sLineBreak;
 HTMLControl := HTMLControl + '<label class="form-check-label" for="' + AnsiUpperCase(NamePrefix) + '">' + Text + '</label>' + sLineBreak;
 HTMLControl := HTMLControl + '</div>';
end;


procedure TPrismDBCheckBox.SetChecked(AValue: Boolean);
begin
 if Assigned(FDataLinkField.Field) then
 begin
  if Assigned(FDataLinkField.DataSource) and Assigned(FDataLinkField.DataSet) and (FDataLinkField.DataSet.Active) then
  begin
   //if (Form.ComponentsUpdating) and (not FDataLinkField.Editing) and (AValue <> FStoredChecked) then
   if (not FDataLinkField.Editing) and (AValue <> FStoredChecked) then
    FDataLinkField.DataSet.Edit;

   if (FDataLinkField.Editing) then
   begin
    if AValue then
    FDataLinkField.Field.AsString:= ValueChecked
    else
    FDataLinkField.Field.AsString:= ValueUnChecked;
   end;
  end;

  FStoredChecked:= AValue;
 end;
end;

procedure TPrismDBCheckBox.SetDataField(AValue: String);
begin
 FDataLinkField.FieldName:= AValue;
end;

procedure TPrismDBCheckBox.SetDataSource(const Value: TDataSource);
begin
 if FDataLinkField.DataSource <> Value then
 begin
//  if Assigned(FDataLinkField.DataSource) then
//   FDataLinkField.DataSource.RemoveFreeNotification(Self);

  FDataLinkField.DataSource := Value;

//  if Assigned(FDataLink.DataSource) then
//    FDataLink.DataSource.FreeNotification(Self);
 end;

end;

procedure TPrismDBCheckBox.SetSwitchMode(const Value: Boolean);
begin
 FSwitchMode:= Value;
end;

procedure TPrismDBCheckBox.SetValueChecked(AValue: String);
begin
 FValueChecked:= AValue;
end;

procedure TPrismDBCheckBox.SetValueUnChecked(AValue: String);
begin
 FValueUnChecked:= AValue;
end;

procedure TPrismDBCheckBox.UpdateData;
begin
 if (Form.FormPageState = PageStateLoaded) and (not Form.ComponentsUpdating) then
 FRefreshData:= true;

end;

procedure TPrismDBCheckBox.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
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


{$ELSE}
implementation
{$ENDIF}

end.