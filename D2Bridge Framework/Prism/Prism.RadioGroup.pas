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

unit Prism.RadioGroup;

interface

{$IFNDEF FMX}
uses
 Classes, D2Bridge.JSON, SysUtils, StrUtils,
 Prism.Forms.Controls, Prism.Interfaces, Prism.Types,
 D2Bridge.Forms;

type
 TPrismRadioGroup = class(TPrismControl, IPrismRadioGroup)
  private
   FStoredColumns: integer;
   FStoredCaption: string;
   FStoredItemIndex: Integer;
   FStoredItems: TStrings;
   FProcGetItems: TOnGetStrings;
   FProcGetItemIndex: TOnGetValue;
   FProcSetItemIndex: TOnSetValue;
   FProcGetCaption: TOnGetValue;
   FProcSetCaption: TOnSetValue;
   FProcGetColumns: TOnGetValue;
   FProcSetColumns: TOnSetValue;
   function GetCaption: string;
   procedure SetCaption(const Value: string);
   function GetItems: TStrings;
   function GetItemIndex: Integer;
   procedure SetItemIndex(const Value: Integer);
   function GetColumns: Integer;
   procedure SetColumns(const Value: Integer);
   function GroupNamed: string;
   function LegendNamed: string;
   function RenderRadioGroupItems: string;
  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   function IsRadioGroup: Boolean; override;
  public
   constructor Create(AOwner: TObject); override;
   destructor Destroy; override;

   property Caption: string read GetCaption write SetCaption;
   property Items: TStrings read GetItems;
   property ItemIndex: integer read GetItemIndex write SetItemIndex;
   property Columns: integer read GetColumns write SetColumns;

   property ProcGetItems: TOnGetStrings read FProcGetItems write FProcGetItems;
   property ProcGetItemIndex: TOnGetValue read FProcGetItemIndex write FProcGetItemIndex;
   property ProcSetItemIndex: TOnSetValue read FProcSetItemIndex write FProcSetItemIndex;
   property ProcGetCaption: TOnGetValue read FProcGetCaption write FProcGetCaption;
   property ProcSetCaption: TOnSetValue read FProcSetCaption write FProcSetCaption;
   property ProcGetColumns: TOnGetValue read FProcGetColumns write FProcGetColumns;
   property ProcSetColumns: TOnSetValue read FProcSetColumns write FProcSetColumns;
 end;

implementation

uses
 Prism.Util;

{ TPrismRadioGroup }

constructor TPrismRadioGroup.Create(AOwner: TObject);
begin
 inherited;

 FStoredItems:= TStringList.Create;
end;

destructor TPrismRadioGroup.Destroy;
begin
 FStoredItems.Free;

 inherited;
end;

function TPrismRadioGroup.GetCaption: string;
begin
 if Assigned(ProcGetCaption) then
  Result:= ProcGetCaption
 else
  Result:= FStoredCaption;

end;

function TPrismRadioGroup.GetColumns: Integer;
begin
 if Assigned(ProcGetColumns) then
  Result:= ProcGetColumns
 else
  Result:= FStoredColumns;
end;

function TPrismRadioGroup.GetEnableComponentState: Boolean;
begin

end;

function TPrismRadioGroup.GetItems: TStrings;
begin
 if Assigned(ProcGetItems) then
 begin
  Result:= ProcGetItems;
 end else
 Result:= FStoredItems;
end;

function TPrismRadioGroup.GroupNamed: string;
begin
 result:= AnsiUpperCase(NamePrefix + 'Group');
end;

function TPrismRadioGroup.GetItemIndex: Integer;
begin
 if Assigned(ProcGetItemIndex) then
  Result:= ProcGetItemIndex
 else
  Result:= FStoredItemIndex;
end;

procedure TPrismRadioGroup.Initialize;
begin
 inherited;

 FStoredCaption:= Caption;
 FStoredItemIndex:= ItemIndex;
 FStoredItems.CommaText:= Items.CommaText;
 FStoredColumns:= Columns;
end;

function TPrismRadioGroup.IsRadioGroup: Boolean;
begin
 result:= true;
end;

function TPrismRadioGroup.LegendNamed: string;
begin
 result:= AnsiUpperCase(NamePrefix + 'Caption');
end;

procedure TPrismRadioGroup.ProcessComponentState(const ComponentStateInfo: TJSONObject);
var
 vItemIndex: Integer;
begin
 inherited;

 try
  if (ComponentStateInfo.GetValue('itemindex') <> nil) then
  begin
   if TryStrToInt(ComponentStateInfo.GetValue('itemindex').Value, vItemIndex) then
   begin
    if (vItemIndex >= 0) and (vItemIndex < Items.Count) then
     ItemIndex:= vItemIndex
    else
     ItemIndex:= -1
   end;
  end;
 except
 end;
end;

procedure TPrismRadioGroup.ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings);
begin
  inherited;

end;

procedure TPrismRadioGroup.ProcessHTML;
begin
 inherited;

 HTMLControl := '<fieldset ';
 HTMLControl := HTMLControl + ' ' + HTMLCore + ' ';
 HTMLControl := HTMLControl + '>';

 HTMLControl := HTMLControl + RenderRadioGroupItems;

 HTMLControl := HTMLControl + '</fieldset>';
end;

function TPrismRadioGroup.RenderRadioGroupItems: string;
var
 I: Integer;
 vColumns: integer;
 vQtyBlockRow, vItemBlockRow: integer;
 vItems: TStrings;
begin
 Result:= '';
 vItems:= TStringList.Create;

 try
  vQtyBlockRow:= 0;

  Result := Result + '<legend class="d2bridgeradiogroupcaption" id="' + LegendNamed + '">' + FStoredCaption + '</legend>';

  vItems.Text:= FStoredItems.Text;
  vColumns:= FStoredColumns;
  if vColumns < 1 then
   vColumns:= 1;
  vQtyBlockRow:= vItems.Count div vColumns;
  if (vQtyBlockRow * vColumns) < vItems.Count then
   Inc(vQtyBlockRow);

  vItemBlockRow:= vQtyBlockRow + 1;

  Result := Result + '<div class="row">';

  //Itens
  for I := 0 to Pred(vItems.Count) do
  begin
   if vItemBlockRow > vQtyBlockRow  then
   begin
    vItemBlockRow:= 1;
    Result := Result + '<div class="col">';
   end;

   Result := Result + '<div class="form-check">';
   Result := Result + '  <input class="form-check-input" type="radio" name="' + GroupNamed + '" id="' + GroupNamed + IntToStr(I) + '" value="' + IntToStr(I) + '"' +
                         ifThen(I = FStoredItemIndex, 'checked') + ' nofocused>';
   Result := Result + '  <label class="form-check-label" for="' + GroupNamed + IntToStr(I) + '">' + vItems[I] + '</label>';
   Result := Result + '</div>';

   inc(vItemBlockRow);

   if vItemBlockRow > vQtyBlockRow  then
    Result := Result + '</div>';
  end;

  Result := Result + '</div>';
 except
 end;

 vItems.Free;
end;

procedure TPrismRadioGroup.SetCaption(const Value: string);
begin
 if Assigned(ProcSetCaption) then
  if FStoredCaption <> Value then
   ProcSetCaption(Value);

 FStoredCaption:= Value;
end;

procedure TPrismRadioGroup.SetColumns(const Value: Integer);
begin
 if Assigned(ProcSetColumns) then
  if FStoredColumns <> Value then
   ProcSetColumns(Value);

 FStoredColumns:= Value;
end;

procedure TPrismRadioGroup.SetItemIndex(const Value: Integer);
begin
 if Assigned(ProcSetItemIndex) then
  if FStoredItemIndex <> Value then
   ProcSetItemIndex(Value);

 FStoredItemIndex:= Value;
end;

procedure TPrismRadioGroup.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
var
 NewCaption: string;
 NewItems: TStrings;
 NewItemIndex, NewColumns: integer;
begin
 inherited;

 NewCaption:= Caption;
 if NewCaption <> FStoredCaption then
 begin
  FStoredCaption:= NewCaption;

  ScriptJS.Add('document.querySelector("[id='+LegendNamed+' i]").textContent = "'+  FStoredCaption +'";');
 end;

 NewItemIndex:= ItemIndex;
 if NewItemIndex <> FStoredItemIndex then
 begin
  FStoredItemIndex:= NewItemIndex;

  if FStoredItemIndex < 0 then
  begin
   ScriptJS.Add('const selected = document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").querySelector("input[type=''radio'']:checked");');
   ScriptJS.Add('if (selected) {');
   ScriptJS.Add('  selected.checked = false;');
   ScriptJS.Add('}');
  end else
  begin
   ScriptJS.Add('document.querySelector("[id='+GroupNamed + IntToStr(FStoredItemIndex)+' i]").checked = true;');
  end;
 end;

 NewItems:= Items;
 NewColumns:= Columns;
 if (NewItems.CommaText <> FStoredItems.CommaText) or (NewColumns <> FStoredColumns) then
 begin
  FStoredItems.CommaText:= NewItems.CommaText;
  FStoredColumns:= NewColumns;

  ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").innerHTML = '+ FormatValueHTML(RenderRadioGroupItems) +';');
 end;
end;

{$ELSE}
implementation
{$ENDIF}

end.