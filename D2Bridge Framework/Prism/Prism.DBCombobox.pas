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

unit Prism.DBCombobox;

interface

{$IFNDEF FMX}
uses
  Classes, SysUtils, D2Bridge.JSON, DB,
  DBCtrls,
  Prism.Interfaces, Prism.Forms.Controls, Prism.Types, Prism.DataLink.Field;

type
 TPrismDBCombobox = class(TPrismControl, IPrismDBCombobox)
  private
   FProcGetItems: TOnGetStrings;
   FRefreshData: Boolean;
   FStoredSelectedItem: String;
   FStoredItems: TStrings;
   FDataLinkField: TPrismDataLinkField;
   procedure UpdateData; override;
   function GetItems: TStrings;
   function RenderDBComboboxItems: string;
  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   function IsDBCombobox: Boolean; override;
   function GetReadOnly: Boolean; override;
  public
   constructor Create(AOwner: TObject); override;
   destructor Destroy; override;

   function DataWare: TPrismDataLinkField;

   property Items: TStrings read GetItems;
   property ProcGetItems: TOnGetStrings read FProcGetItems write FProcGetItems;
 end;


implementation

uses
  Prism.Util, Prism.Events,
  StrUtils;

{ TPrismDBCombobox }

constructor TPrismDBCombobox.Create(AOwner: TObject);
var
 vSelectEvent: IPrismControlEvent;
begin
 inherited;

 FDataLinkField:= TPrismDataLinkField.Create(self);
 FRefreshData:= false;
 FStoredItems:= TStringList.Create;

 if not Assigned(Events.Item(EventOnChange)) then
 begin
  vSelectEvent := TPrismControlEvent.Create(self, EventOnChange);
  vSelectEvent.AutoPublishedEvent:= true;

  Events.Add(vSelectEvent);
 end;
end;

function TPrismDBCombobox.DataWare: TPrismDataLinkField;
begin
 Result:= FDataLinkField;
end;

destructor TPrismDBCombobox.Destroy;
begin
 FreeAndNil(FStoredItems);
 FreeAndNil(FDataLinkField);

 inherited;
end;

function TPrismDBCombobox.GetEnableComponentState: Boolean;
begin
 Result:= true;
end;

function TPrismDBCombobox.GetItems: TStrings;
begin
 if Assigned(ProcGetItems) then
 begin
  Result:= ProcGetItems;
 end else
 Result:= FStoredItems;
end;

function TPrismDBCombobox.GetReadOnly: Boolean;
begin
 result:= Inherited;

 if not result then
  result:= FDataLinkField.ReadOnly;
end;

procedure TPrismDBCombobox.Initialize;
begin
 inherited;

 FStoredSelectedItem:= DataWare.FieldText;
 FStoredItems.CommaText:= GetItems.CommaText;
end;

function TPrismDBCombobox.IsDBCombobox: Boolean;
begin
 Result:= true;
end;

procedure TPrismDBCombobox.ProcessComponentState(const ComponentStateInfo: TJSONObject);
var
 Selectindex: Integer;
begin
 inherited;

 if (ComponentStateInfo.GetValue('selecteditemindex') <> nil) then
 begin
  if TryStrToInt(ComponentStateInfo.GetValue('selecteditemindex').Value, Selectindex) then
  begin
   if (Selectindex >= 1) and (Selectindex <= Items.Count) then
    DataWare.FieldValue:= Items[Selectindex-1]
   else
   if (Selectindex <> 0) and (Items.Count <= 0) then
    DataWare.Field.Clear;
  end;
 end;
end;

procedure TPrismDBCombobox.ProcessEventParameters(Event: IPrismControlEvent;
  Parameters: TStrings);
begin
  inherited;

end;

procedure TPrismDBCombobox.ProcessHTML;
begin
 inherited;

 HTMLControl := '<select ';
 HTMLControl := HTMLControl + ' ' + HTMLCore + ' aria-label="' + ifThen(Placeholder = '', Form.Session.LangNav.Combobox.Select, Placeholder) + '" ';
 HTMLControl := HTMLControl + '>';

 HTMLControl := HTMLControl + RenderDBComboboxItems;

 HTMLControl := HTMLControl + '</select>';
end;


function TPrismDBCombobox.RenderDBComboboxItems: string;
var
 I: Integer;
 vSelectedValue: boolean;
begin
 result:= '';

 vSelectedValue:= false;

 if FStoredSelectedItem = '' then
 result := result + '<option hidden disabled selected value>' + ifThen(Placeholder = '', Form.Session.LangNav.Combobox.Select, Placeholder) + '</option>';

 //Itens
 for I := 0 to FStoredItems.Count-1 do
 if SameText(FStoredItems[I],FStoredSelectedItem) then
 begin
  result := result + '<option selected value="'+ IntToStr(I+1) + '">' + FStoredItems[I] + '</option>';
  vSelectedValue:= true;
 end else
  result := result + '<option value="'+ IntToStr(I+1) + '">' + FStoredItems[I] + '</option>';

 if (not vSelectedValue) and (FStoredSelectedItem <> '') then
  result := result + '<option selected value="0">' + FStoredSelectedItem + '</option>';
end;

procedure TPrismDBCombobox.UpdateData;
begin
 if (Form.FormPageState = PageStateLoaded) and (not Form.ComponentsUpdating) then
 FRefreshData:= true;
end;

procedure TPrismDBCombobox.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
var
 NewSelectedItem: string;
 NewItems: TStrings;
begin
 NewItems:= Items;
 if (FStoredItems.CommaText <> NewItems.CommaText) or (AForceUpdate) then
 begin
  FStoredItems.CommaText:= NewItems.CommaText;

  ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").innerHTML = '+ FormatValueHTML(RenderDBComboboxItems) +';');

  //ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").outerHTML = '+ FormatValueHTML(HTMLControl) +';');
 end;

 NewSelectedItem:= FDataLinkField.FieldText(AForceUpdate);
 if (FStoredSelectedItem <> NewSelectedItem) or (AForceUpdate) then
 begin
  FStoredSelectedItem := NewSelectedItem;

  if NewSelectedItem <> '' then
   ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").value = '+ FormatValueHTML(IntToStr(Items.IndexOf(FStoredSelectedItem)+1)) +';')
  else
   ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").value = "";')
 end;

 //Se faz necessário o inherited aqui embaixo para que o combobox receba atualização de visibilidade apos a tabela abrir
 inherited;
end;


{$ELSE}
implementation
{$ENDIF}

end.
