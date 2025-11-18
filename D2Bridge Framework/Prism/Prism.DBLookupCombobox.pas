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

unit Prism.DBLookupCombobox;

interface

{$IFNDEF FMX}
uses
  Classes, D2Bridge.JSON, SysUtils, DB, RTTI,
  DBCtrls, Generics.Collections,
  Prism.Interfaces, Prism.Forms.Controls, Prism.Types,
  Prism.DataLink.Field, Prism.DataLink.Field.Lookup;

type
 TPrismDBLookupCombobox = class(TPrismControl, IPrismDBLookupCombobox)
  strict private
   procedure Exec_SetSelectedItem;
  private
   FProcSetText: TOnSetValue;
   FProcGetText: TOnGetValue;
   FRefreshData: Boolean;
   FRefreshListData: Boolean;
   FPrismDataLink: TPrismDataLinkField;
   FPrismDataLinkLookup: TPrismDataLinkFieldLookup;
   FStoredSelectedItem: String;
   FMaxRecords: Integer;
   FRefreshDataOnLoad: boolean;
   procedure UpdateData; override;
   procedure UpdateListData;
   procedure SetDataSource(const Value: TDataSource);
   function GetDataSource: TDataSource;
   procedure SetDataField(AValue: String);
   function GetDataField: String;
   procedure SetListDataSource(const Value: TDataSource);
   function GetListDataSource: TDataSource;
   function GetListDataField: string;
   Procedure SetListDataField(AFieldName: string);
   function GetKeyDataField: string;
   Procedure SetKeyDataField(AFieldName: string);
   function GetMaxRecords: integer;
   Procedure SetMaxRecords(AMaxRecords: Integer);
   procedure SetSelectedItem(AText: String);
   function GetSelectedItem: String;
   function RenderDBLookupComboboxItems: string;
   procedure DataWareLookupEvent(const ADataWareEvent: TPrismDataLinkEvent);
  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   function GetReadOnly: Boolean; override;
   function IsDBLookupCombobox: Boolean; override;
  public
   constructor Create(AOwner: TObject); override;
   destructor Destroy; override;

   property DataSource: TDataSource read GetDataSource write SetDataSource;
   property DataField: String read GetDataField write SetDataField;
   property ListDataSource: TDataSource read GetListDataSource write SetListDataSource;
   property ListDataField: String read GetListDataField write SetListDataField;
   property KeyDataField: String read GetKeyDataField write SetKeyDataField;
   property SelectedItem: String read GetSelectedItem write SetSelectedItem;
   property ProcSetText: TOnSetValue read FProcSetText write FProcSetText;
   property ProcGetText: TOnGetValue read FProcGetText write FProcGetText;
   property MaxRecords: Integer read GetMaxRecords write SetMaxRecords;
 end;


implementation

uses
  Prism.Util, Prism.Events,
  Variants, StrUtils;

constructor TPrismDBLookupCombobox.Create(AOwner: TObject);
var
 vSelectEvent: IPrismControlEvent;
begin
 inherited;

 FRefreshDataOnLoad:= false;
 FRefreshData:= false;
 FRefreshListData:= True;
 FPrismDataLink:= TPrismDataLinkField.Create(self);
 FPrismDataLinkLookup:= TPrismDataLinkFieldLookup.Create(self);
 FPrismDataLinkLookup.OnDataWareEvent:= DataWareLookupEvent;

 FMaxRecords:= 1000;

 if not Assigned(Events.Item(EventOnChange)) then
 begin
  vSelectEvent := TPrismControlEvent.Create(self, EventOnChange);
  vSelectEvent.AutoPublishedEvent:= true;

  Events.Add(vSelectEvent);
 end;
end;

procedure TPrismDBLookupCombobox.DataWareLookupEvent(const ADataWareEvent: TPrismDataLinkEvent);
begin
 if Form.FormPageState in [PageStateLoaded, PageStateLoading] then
 begin
  if ADataWareEvent in [TPrismDataLinkEvent.Activate, TPrismDataLinkEvent.Deactivate, TPrismDataLinkEvent.Deleted, TPrismDataLinkEvent.NewRow, TPrismDataLinkEvent.Updated] then
  begin
   UpdateListData;
  end;
 end else
  if ADataWareEvent in [TPrismDataLinkEvent.Activate, TPrismDataLinkEvent.Deactivate, TPrismDataLinkEvent.NewRow, TPrismDataLinkEvent.Deleted, TPrismDataLinkEvent.Updated] then
   FRefreshDataOnLoad:= true;
end;

destructor TPrismDBLookupCombobox.Destroy;
begin
 FreeAndNil(FPrismDataLink);
 FreeAndNil(FPrismDataLinkLookup);

 inherited;
end;

procedure TPrismDBLookupCombobox.Exec_SetSelectedItem;
begin
 Events.Item(EventOnSelect).CallEvent(nil);
end;

function TPrismDBLookupCombobox.GetDataField: String;
begin
 Result:= FPrismDataLink.FieldName;
end;

function TPrismDBLookupCombobox.GetDataSource: TDataSource;
begin
 Result:= FPrismDataLink.DataSource;
end;

function TPrismDBLookupCombobox.GetEnableComponentState: Boolean;
begin
 Result:= true;
end;

function TPrismDBLookupCombobox.GetKeyDataField: string;
begin
 Result:= FPrismDataLinkLookup.KeyFieldName;
end;

function TPrismDBLookupCombobox.GetListDataField: string;
begin
 Result:= FPrismDataLinkLookup.FieldName;
end;

function TPrismDBLookupCombobox.GetListDataSource: TDataSource;
begin
 Result:= FPrismDataLinkLookup.DataSource;
end;


function TPrismDBLookupCombobox.GetMaxRecords: integer;
begin
 Result:= FMaxRecords;
end;

function TPrismDBLookupCombobox.GetReadOnly: Boolean;
var
 vResultCanEditing: boolean;
begin
 result:= Inherited;

 if Assigned(FPrismDataLink.DataSource) and Assigned(FPrismDataLink.DataSet) and Assigned(FPrismDataLink.Field) then
 begin
  if not result then
   result:= FPrismDataLink.ReadOnly;
 end else
 begin
  if not (Assigned(FPrismDataLinkLookup.DataSource) and
          Assigned(FPrismDataLinkLookup.DataSet) and
          Assigned(FPrismDataLinkLookup.Field) and
          Assigned(FPrismDataLinkLookup.KeyField) and
          FPrismDataLinkLookup.DataSet.Active) then
   result:= true;
 end;
end;

function TPrismDBLookupCombobox.GetSelectedItem: String;
var
 vResult: Variant;
begin
 if Assigned(FPrismDataLink.DataSource) and Assigned(FPrismDataLink.DataSet) and Assigned(FPrismDataLink.Field) then
 begin
  if (FPrismDataLink.DataSet.Active) then
   Result:= FPrismDataLink.Field.AsString
  else
   Result:= ''
 end else
 if Assigned(FProcGetText) then
 begin
  vResult:= FProcGetText;
  if not VarIsNull(vResult) then
  Result:= vResult
 end
 else
 if not Assigned(FPrismDataLink.DataSource) and Assigned(FPrismDataLinkLookup.DataSource) and Assigned(FPrismDataLinkLookup.DataSource.DataSet) and (FPrismDataLinkLookup.DataSet.Active) then
  Result:= FStoredSelectedItem
 else
  Result:= '';
end;

procedure TPrismDBLookupCombobox.Initialize;
begin
 inherited;

 FStoredSelectedItem:= GetSelectedItem;
end;

function TPrismDBLookupCombobox.IsDBLookupCombobox: Boolean;
begin
 result:= true;
end;

procedure TPrismDBLookupCombobox.ProcessComponentState(
  const ComponentStateInfo: TJSONObject);
var
 SelectValue: String;
begin
 inherited;

 if (ComponentStateInfo.GetValue('selectedvalue') <> nil) then
 begin
  SelectValue:= ComponentStateInfo.GetValue('selectedvalue').Value;

  SelectedItem:= SelectValue;
 end;
end;

procedure TPrismDBLookupCombobox.ProcessEventParameters(Event: IPrismControlEvent;
  Parameters: TStrings);
begin
  inherited;

end;

procedure TPrismDBLookupCombobox.ProcessHTML;
begin
 inherited;

 try
  HTMLControl := '<select ';
  HTMLControl := HTMLControl + ' ' + HTMLCore + ' aria-label="' + ifThen(Placeholder = '', Form.Session.LangNav.Combobox.Select, Placeholder) + '" ';
  HTMLControl := HTMLControl + '>';

  HTMLControl := HTMLControl + RenderDBLookupComboboxItems;

  HTMLControl := HTMLControl + '</select>';
 except
  on E: Exception do
  begin
   try
    Session.DoException(self as TObject, E, 'TPrismDBLookupCombobox.ProcessHTML');
   except
   end;
   Exit;
  end;
 end;

end;

function TPrismDBLookupCombobox.RenderDBLookupComboboxItems: string;
var
 I, Pos, vQtdRec: Integer;
 vExistItem: Boolean;
 vKeyFieldValue, vFieldValue: string;
begin
 result:= '';

 try
  if SelectedItem = '' then
   result := result + '<option hidden disabled selected value>' + ifThen(Placeholder = '', Form.Session.LangNav.Combobox.Select, Placeholder) + '</option>';

  //Itens
  //if Assigned(FDataLink.DataSource) and Assigned(FDataLink.DataSet) and (FDataLink.DataSet.Active) then
  if Assigned(FPrismDataLinkLookup.DataSource) and
     Assigned(FPrismDataLinkLookup.DataSet) and
     (FPrismDataLinkLookup.DataSet.Active) and
     Assigned(FPrismDataLinkLookup.Field) and
     (FRefreshListData) and
     (FPrismDataLinkLookup.KeyFieldName <> '') and
     (not FPrismDataLinkLookup.DataSet.IsEmpty) then
  begin
   try
    FRefreshListData:= false;
    Pos:= FPrismDataLinkLookup.DataSet.RecNo;
    FPrismDataLinkLookup.DataSet.DisableControls;

    vQtdRec:= 0;
    vExistItem:= false;
    FPrismDataLinkLookup.DataSet.First;
    repeat
    begin
     vFieldValue:= FPrismDataLinkLookup.FieldText(true);
     vKeyFieldValue:= FPrismDataLinkLookup.KeyFieldText(true);

     if SameText(vKeyFieldValue, FStoredSelectedItem) then
     begin
      result := result + '<option selected value="'+ vKeyFieldValue + '">' + vFieldValue + '</option>';
      vExistItem:= true;
     end else
      result := result + '<option value="'+ vKeyFieldValue + '">' + vFieldValue + '</option>';

     FPrismDataLinkLookup.DataSet.next;

     Inc(vQtdRec);
    end until (vQtdRec >= FMaxRecords) or FPrismDataLinkLookup.DataSet.Eof;
   except
    on E: Exception do
    begin
     try
      Session.DoException(self as TObject, E, 'TPrismDBLookupCombobox.ProcessHTML');
     except
     end;
     Exit;
    end;
   end;

   FPrismDataLinkLookup.DataSet.RecNo:= Pos;
   FPrismDataLinkLookup.DataSet.EnableControls;
  end;


  if not (Assigned(FPrismDataLink.DataSource) and Assigned(FPrismDataLink.DataSet) and (FPrismDataLink.DataSet.Active)) then
  begin
   if (not vExistItem) then
    result := result + '<option hidden disabled selected value>' + Form.Session.LangNav.Combobox.Select + '</option>';
  end else
  if (Assigned(FPrismDataLink.DataSource) and Assigned(FPrismDataLink.DataSet) and (FPrismDataLink.DataSet.Active)) and
     (not vExistItem) then
  begin
   if (SelectedItem <> '') then
    result := result + '<option selected value="'+ SelectedItem + '">' + Form.Session.LangNav.Combobox.Select + '</option>'
   else
    result := result + '<option hidden disabled selected value>' + Form.Session.LangNav.Combobox.Select + '</option>';
  end;
 except
 end;

end;

procedure TPrismDBLookupCombobox.SetDataField(AValue: String);
begin
 FPrismDataLink.FieldName:= AValue;
end;

procedure TPrismDBLookupCombobox.SetDataSource(const Value: TDataSource);
begin
 if FPrismDataLink.DataSource <> Value then
 begin
//  if Assigned(FDataLink.DataSource) then
//   FDataLink.DataSource.RemoveFreeNotification(Self);

  try
   if Assigned(Value) then
    FPrismDataLink.DataSource := Value
   else
    FPrismDataLink.DataSource:= nil;
  except

  end;


//  if Assigned(FDataLink.DataSource) then
//    FDataLink.DataSource.FreeNotification(Self);
 end;

end;

procedure TPrismDBLookupCombobox.SetKeyDataField(AFieldName: string);
begin
 FPrismDataLinkLookup.KeyFieldName:= AFieldName;
end;

procedure TPrismDBLookupCombobox.SetListDataField(AFieldName: string);
begin
 FPrismDataLinkLookup.FieldName:= AFieldName;
end;

procedure TPrismDBLookupCombobox.SetListDataSource(const Value: TDataSource);
begin
 if FPrismDataLinkLookup.DataSource <> Value then
 begin
//  if Assigned(FListDataLink.DataSource) then
//   FListDataLink.DataSource.RemoveFreeNotification(Self);

  try
   if Assigned(Value) then
    FPrismDataLinkLookup.DataSource := Value
   else
    FPrismDataLinkLookup.DataSource:= nil;
  except

  end;

//  if Assigned(FListDataLink.DataSource) then
//    FListDataLink.DataSource.FreeNotification(Self);
 end;

end;


procedure TPrismDBLookupCombobox.SetMaxRecords(AMaxRecords: Integer);
begin
 FMaxRecords:= AMaxRecords;
end;

procedure TPrismDBLookupCombobox.SetSelectedItem(AText: String);
begin
 if Assigned(FPrismDataLink.DataSource) and
    Assigned(FPrismDataLink.DataSet) and
    (FPrismDataLink.DataSet.Active) and
    Assigned(FPrismDataLinkLookup.Field) then
 begin
  if Assigned(FPrismDataLinkLookup.DataSource) and
      Assigned(FPrismDataLinkLookup.DataSet) and
      (FPrismDataLinkLookup.DataSet.Active) and
      Assigned(FPrismDataLinkLookup.Field) then
  begin
   if (Form.ComponentsUpdating) and (not FPrismDataLink.Editing) and (AText <> FStoredSelectedItem) then
    FPrismDataLink.DataSet.Edit;

   if (FPrismDataLink.DataSet.State in [dsEdit,dsInsert]) then
   begin
    //FPrismDataLinkLookup.KeyFieldValue:= AText;

    FPrismDataLink.Field.AsString:= AText;
   end;
  end;
 end else
  if Assigned(FProcSetText) then
   FProcSetText(AText);


 if Assigned(FPrismDataLinkLookup.DataSource) and
    Assigned(FPrismDataLinkLookup.DataSet) and
    (FPrismDataLinkLookup.DataSet.Active) and
    Assigned(FPrismDataLinkLookup.Field) then
 begin
  if FStoredSelectedItem <> AText then
   if Assigned(Events.Item(EventOnSelect)) then
   begin
    Session.ExecThread(false, Exec_SetSelectedItem);
   end;

  FStoredSelectedItem:= AText;
 end;
end;

procedure TPrismDBLookupCombobox.UpdateData;
begin
 if (Form.FormPageState = PageStateLoaded) and (not Form.ComponentsUpdating) then
 FRefreshData:= true
end;


procedure TPrismDBLookupCombobox.UpdateListData;
begin
 FRefreshListData:= true;
end;

procedure TPrismDBLookupCombobox.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
var
 NewSelectedItem: string;
begin
 if (Form.FormPageState = PageStateLoaded) and FRefreshDataOnLoad then
 begin
  FRefreshDataOnLoad:= false;
  UpdateListData;
 end;


 if (FRefreshData) or (FRefreshListData) or (AForceUpdate) then
 begin
  try
   try
    if AForceUpdate then
     FRefreshListData:= true;

//    RefreshHTMLControl;
//    ProcessHTML;
//
//    ScriptJS.Add('let oldElement = document.querySelector("[id=' + AnsiUpperCase(NamePrefix) + ' i]");');
//    ScriptJS.Add('let events = $._data(oldElement[0], "events");');
//    ScriptJS.Add('oldElement.outerHTML = '+ FormatValueHTML(HTMLControl) +';');
//    ScriptJS.Add('let newElement = document.querySelector("[id=' + AnsiUpperCase(NamePrefix) + ' i]");');
//    ScriptJS.Add('for (let type in events) {');
//    ScriptJS.Add('    events[type].forEach(event => {');
//    ScriptJS.Add('        newElement.addEventListener(event.type, event.listener);');
//    ScriptJS.Add('    });');
//    ScriptJS.Add('}');

    //ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").outerHTML = '+ FormatValueHTML(HTMLControl) +';');

    ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").innerHTML = '+ FormatValueHTML(RenderDBLookupComboboxItems) +';');
   except
   end;
  finally
   FRefreshData:= false;
   FRefreshListData:= false;
  end;
 end;


 NewSelectedItem:= SelectedItem;
 if (FStoredSelectedItem <> NewSelectedItem) then
 begin
  FStoredSelectedItem := NewSelectedItem;

  if NewSelectedItem <> '' then
   ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").value = '+ FormatValueHTML(NewSelectedItem) +';')
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
