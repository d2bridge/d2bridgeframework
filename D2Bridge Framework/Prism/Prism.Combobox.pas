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

unit Prism.Combobox;

interface

uses
  Classes, D2Bridge.JSON, SysUtils,
  Prism.Forms.Controls, Prism.Interfaces, Prism.Types;


type
 TPrismCombobox = class(TPrismControl, IPrismCombobox)
  private
   FStoredSelectedItem: String;
   FStoredItems: TStrings;
   FProcGetItems: TOnGetStrings;
   FProcSetSelectedItem: TOnSetValue;
   FProcGetSelectedItem: TOnGetValue;
   procedure SetSelectedItem(AText: String);
   function GetSelectedItem: String;
   function GetItems: TStrings;
   function RenderComboboxItems: string;
  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   function IsCombobox: Boolean; override;
  public
   constructor Create(AOwner: TObject); override;
   destructor Destroy; override;

   property Items: TStrings read GetItems;
   property SelectedItem: String read GetSelectedItem write SetSelectedItem;

   property ProcGetItems: TOnGetStrings read FProcGetItems write FProcGetItems;
   property ProcGetSelectedItem: TOnGetValue read FProcGetSelectedItem write FProcGetSelectedItem;
   property ProcSetSelectedItem: TOnSetValue read FProcSetSelectedItem write FProcSetSelectedItem;
 end;



implementation

uses
  Prism.Util, Prism.Events,
  StrUtils;

{ TPrismCombobox }

constructor TPrismCombobox.Create(AOwner: TObject);
var
 vSelectEvent: IPrismControlEvent;
begin
 inherited;
 FStoredItems:= TStringList.Create;

// if not Assigned(Events.Item(EventOnChange)) then
// begin
//  vSelectEvent := TPrismControlEvent.Create(self, EventOnChange);
//  vSelectEvent.AutoPublishedEvent:= true;
//
//  Events.Add(vSelectEvent);
// end;
end;

destructor TPrismCombobox.Destroy;
begin
 FreeAndNil(FStoredItems);

 inherited;
end;

function TPrismCombobox.GetEnableComponentState: Boolean;
begin
 Result:= true;
end;

function TPrismCombobox.GetItems: TStrings;
begin
 if Assigned(ProcGetItems) then
 begin
  Result:= ProcGetItems;
 end else
 Result:= FStoredItems;
end;

function TPrismCombobox.GetSelectedItem: String;
begin
 if Assigned(ProcGetSelectedItem) then
 Result:= ProcGetSelectedItem
 else
 Result:= FStoredSelectedItem;

end;

procedure TPrismCombobox.Initialize;
begin
 inherited;

 if Assigned(Events.Item(EventOnSelect)) then
 begin
  Events.Item(EventOnSelect).AutoPublishedEvent:= true;
 end;

 FStoredSelectedItem:= GetSelectedItem;
 FStoredItems.CommaText:= GetItems.CommaText;
end;

function TPrismCombobox.IsCombobox: Boolean;
begin
 result:= true;
end;

procedure TPrismCombobox.ProcessComponentState(const ComponentStateInfo: TJSONObject);
var
 Selectindex: Integer;
begin
 inherited;

 try
  if (ComponentStateInfo.GetValue('selecteditemindex') <> nil) then
  begin
   TryStrToInt(ComponentStateInfo.GetValue('selecteditemindex').Value, Selectindex);

   if (Selectindex >= 1) and (Selectindex <= Items.Count) then
    SelectedItem:= Items[Selectindex-1]
   else
    SelectedItem:= '';
  end;
 except
 end;
end;

procedure TPrismCombobox.ProcessEventParameters(Event: IPrismControlEvent;
  Parameters: TStrings);
begin
 inherited;

end;

procedure TPrismCombobox.ProcessHTML;
begin
 inherited;

 HTMLControl := '<select ';
 HTMLControl := HTMLControl + ' ' + HTMLCore + ' aria-label="' + ifThen(Placeholder = '', Form.Session.LangNav.Combobox.Select, Placeholder) + '" ';
 HTMLControl := HTMLControl + '>';

 HTMLControl := HTMLControl + RenderComboboxItems;

 HTMLControl := HTMLControl + '</select>';
end;


function TPrismCombobox.RenderComboboxItems: string;
var
 I: Integer;
begin
 Result:= '';

 if FStoredSelectedItem = '' then
 Result := Result + '<option hidden disabled selected value>' + ifThen(Placeholder = '', Form.Session.LangNav.Combobox.Select, Placeholder) + '</option>';

 //Itens
 for I := 0 to FStoredItems.Count-1 do
 if SameText(FStoredItems[I],FStoredSelectedItem) then
  Result := Result + '<option selected value="'+ IntToStr(I+1) + '">' + FStoredItems[I] + '</option>'
 else
  Result := Result + '<option value="'+ IntToStr(I+1) + '">' + FStoredItems[I] + '</option>';
end;

procedure TPrismCombobox.SetSelectedItem(AText: String);
begin
 if Assigned(ProcSetSelectedItem) then
 if FStoredSelectedItem <> AText then
 begin
  ProcSetSelectedItem(AText);
 end;

 FStoredSelectedItem:= AText;
end;


procedure TPrismCombobox.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
var
 NewSelectedItem: string;
 NewItems: TStrings;
begin
 inherited;

 NewItems:= Items;
 if (FStoredItems.CommaText <> NewItems.CommaText) or (AForceUpdate) then
 begin
  FStoredItems.CommaText := NewItems.CommaText;
  //ProcessHTML;

  ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").innerHTML = '+ FormatValueHTML(RenderComboboxItems) +';');

  //ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").outerHTML = '+ FormatValueHTML(HTMLControl) +';');
 end;


 NewSelectedItem:= SelectedItem;
 if (FStoredSelectedItem <> NewSelectedItem) or (AForceUpdate) then
 begin
  FStoredSelectedItem := NewSelectedItem;

  if NewSelectedItem <> '' then
   ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").value = '+ FormatValueHTML(IntToStr(Items.IndexOf(SelectedItem)+1)) +';')
  else
   ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").value = ""');
 end;

end;

end.