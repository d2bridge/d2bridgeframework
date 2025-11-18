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

unit Prism.DBRadioGroup;

interface

uses
 Classes, D2Bridge.JSON, SysUtils, StrUtils,
 Prism.Forms.Controls, Prism.Interfaces, Prism.Types, Prism.DataLink.Field,
 D2Bridge.Forms;

type
 TPrismDBRadioGroup = class(TPrismControl, IPrismDBRadioGroup)
  private
   FStoredSelectedItem: string;
   FStoredColumns: integer;
   FStoredCaption: string;
   FStoredItems: TStrings;
   FDataLinkField: TPrismDataLinkField;
   FProcGetItems: TOnGetStrings;
   FProcGetCaption: TOnGetValue;
   FProcSetCaption: TOnSetValue;
   FProcGetColumns: TOnGetValue;
   FProcSetColumns: TOnSetValue;
   function GetCaption: string;
   procedure SetCaption(const Value: string);
   function GetItems: TStrings;
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
   function GetReadOnly: Boolean; override;
   function IsDBRadioGroup: Boolean; override;
  public
   constructor Create(AOwner: TObject); override;
   destructor Destroy; override;

   function DataWare: TPrismDataLinkField;

   property Caption: string read GetCaption write SetCaption;
   property Items: TStrings read GetItems;
   property Columns: integer read GetColumns write SetColumns;

   property ProcGetItems: TOnGetStrings read FProcGetItems write FProcGetItems;
   property ProcGetCaption: TOnGetValue read FProcGetCaption write FProcGetCaption;
   property ProcSetCaption: TOnSetValue read FProcSetCaption write FProcSetCaption;
   property ProcGetColumns: TOnGetValue read FProcGetColumns write FProcGetColumns;
   property ProcSetColumns: TOnSetValue read FProcSetColumns write FProcSetColumns;
 end;

implementation

Uses
 Prism.Util;

{ TPrismDBRadioGroup }

constructor TPrismDBRadioGroup.Create(AOwner: TObject);
begin
 inherited;

 FStoredItems:= TStringList.Create;

 FDataLinkField:= TPrismDataLinkField.Create(Self);
 FDataLinkField.UseHTMLFormatSettings:= false;
end;

function TPrismDBRadioGroup.DataWare: TPrismDataLinkField;
begin
 result:= FDataLinkField;
end;

destructor TPrismDBRadioGroup.Destroy;
begin
 FDataLinkField.Free;
 FStoredItems.Free;

 inherited;
end;

function TPrismDBRadioGroup.GetCaption: string;
begin
 if Assigned(ProcGetCaption) then
  Result:= ProcGetCaption
 else
  Result:= FStoredCaption;
end;

function TPrismDBRadioGroup.GetColumns: Integer;
begin
 if Assigned(ProcGetColumns) then
  Result:= ProcGetColumns
 else
  Result:= FStoredColumns;
end;

function TPrismDBRadioGroup.GetEnableComponentState: Boolean;
begin
 Result:= true;
end;

function TPrismDBRadioGroup.GetItems: TStrings;
begin
 if Assigned(ProcGetItems) then
 begin
  Result:= ProcGetItems;
 end else
  Result:= FStoredItems;
end;

function TPrismDBRadioGroup.GetReadOnly: Boolean;
begin
 result:= Inherited;

 if not result then
  result:= FDataLinkField.ReadOnly;
end;

function TPrismDBRadioGroup.GroupNamed: string;
begin
 result:= AnsiUpperCase(NamePrefix + 'Group');
end;

procedure TPrismDBRadioGroup.Initialize;
begin
 inherited;

 FStoredSelectedItem:= DataWare.FieldText;
 FStoredCaption:= Caption;
 FStoredItems.CommaText:= Items.CommaText;
 FStoredColumns:= Columns;
end;

function TPrismDBRadioGroup.IsDBRadioGroup: Boolean;
begin
 result:= true;
end;

function TPrismDBRadioGroup.LegendNamed: string;
begin
 result:= AnsiUpperCase(NamePrefix + 'Caption');
end;

procedure TPrismDBRadioGroup.ProcessComponentState(const ComponentStateInfo: TJSONObject);
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
    begin
     DataWare.FieldValue:= Items[vItemIndex];
     FStoredSelectedItem:= Items[vItemIndex];
    end else
    begin
     DataWare.Field.Clear;
     FStoredSelectedItem:= '';
    end;
   end;
  end;
 except
 end;
end;

procedure TPrismDBRadioGroup.ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings);
begin
  inherited;

end;

procedure TPrismDBRadioGroup.ProcessHTML;
begin
 inherited;

 HTMLControl := '<fieldset ';
 HTMLControl := HTMLControl + ' ' + HTMLCore + ' ';
 HTMLControl := HTMLControl + '>';

 HTMLControl := HTMLControl + RenderRadioGroupItems;

 HTMLControl := HTMLControl + '</fieldset>';
end;

function TPrismDBRadioGroup.RenderRadioGroupItems: string;
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
                         ifThen(SameText(vItems[I], FStoredSelectedItem), 'checked') + ' nofocused>';
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

procedure TPrismDBRadioGroup.SetCaption(const Value: string);
begin
 if Assigned(ProcSetCaption) then
  if FStoredCaption <> Value then
   ProcSetCaption(Value);

 FStoredCaption:= Value;
end;

procedure TPrismDBRadioGroup.SetColumns(const Value: Integer);
begin
 if Assigned(ProcSetColumns) then
  if FStoredColumns <> Value then
   ProcSetColumns(Value);

 FStoredColumns:= Value;
end;

procedure TPrismDBRadioGroup.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
var
 NewSelectedItem, NewCaption: string;
 NewItems: TStrings;
 vItemIndex, NewColumns: integer;
begin
 NewCaption:= Caption;
 if NewCaption <> FStoredCaption then
 begin
  FStoredCaption:= NewCaption;

  ScriptJS.Add('document.querySelector("[id='+LegendNamed+' i]").textContent = "'+  FStoredCaption +'";');
 end;

 NewSelectedItem := FDataLinkField.FieldText(AForceUpdate);
 if (NewSelectedItem <> FStoredSelectedItem) or (AForceUpdate) then
 begin
  FStoredSelectedItem:= NewSelectedItem;

  vItemIndex:= FStoredItems.IndexOf(FStoredSelectedItem);

  if vItemIndex < 0 then
  begin
   ScriptJS.Add('const selected = document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").querySelector("input[type=''radio'']:checked");');
   ScriptJS.Add('if (selected) {');
   ScriptJS.Add('  selected.checked = false;');
   ScriptJS.Add('}');
  end else
  begin
   ScriptJS.Add('document.querySelector("[id='+GroupNamed + IntToStr(vItemIndex)+' i]").checked = true;');
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

 inherited;
end;

end.
