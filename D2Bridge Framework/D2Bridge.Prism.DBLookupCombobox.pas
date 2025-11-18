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

{$I D2Bridge.inc}

unit D2Bridge.Prism.DBLookupCombobox;

interface

{$IFNDEF FMX}
uses
  Classes, SysUtils,
  D2Bridge.Interfaces, D2Bridge.Prism, D2Bridge.FrameworkItem.DataWare, D2Bridge.Prism.Item;


type
 PrismDBLookupCombobox = class(TD2BridgePrismItem, ID2BridgeFrameworkItemDBLookupCombobox)
  private
   FProcSetText: TOnSetValue;
   FProcGetText: TOnGetValue;
   FD2BridgeDataware: TD2BridgeDataware;
   procedure SetOnGetText(AProc: TOnGetValue);
   function GetOnGetText: TOnGetValue;
   procedure SetOnSetText(AProc: TOnSetValue);
   function GetOnSetText: TOnSetValue;
  public
   constructor Create(AD2BridgePrismFramework: TD2BridgePrismFramework); reintroduce;
   destructor Destroy; override;

   procedure Clear; override;
   function FrameworkClass: TClass; override;
   procedure ProcessPropertyClass(VCLObj, NewObj: TObject); override;
   procedure ProcessEventClass(VCLObj, NewObj: TObject); override;
   procedure ProcessPropertyByName(VCLObj, NewObj: TObject; PropertyName: string; PropertyValue: Variant); override;

   function Dataware : ID2BridgeDataware;
   property OnGetText: TOnGetValue read GetOnGetText write SetOnGetText;
   property OnSetText: TOnSetValue read GetOnSetText write SetOnSetText;
  end;



implementation

uses
  Prism.DBLookupCombobox;


{ PrismDBLookupCombobox }

procedure PrismDBLookupCombobox.Clear;
begin
 inherited;

 Dataware.Clear;
end;

constructor PrismDBLookupCombobox.Create(AD2BridgePrismFramework: TD2BridgePrismFramework);
begin
 inherited Create(AD2BridgePrismFramework);

 FD2BridgeDataware:= TD2BridgeDataware.Create;
end;

function PrismDBLookupCombobox.DataWare: ID2BridgeDataware;
begin
 Result:= FD2BridgeDataware;
end;

destructor PrismDBLookupCombobox.Destroy;
begin
 FreeAndNil(FD2BridgeDataware);

 inherited;
end;

function PrismDBLookupCombobox.FrameworkClass: TClass;
begin
 inherited;

 Result:= TPrismDBLookupCombobox;
end;


function PrismDBLookupCombobox.GetOnGetText: TOnGetValue;
begin
 Result:= FProcGetText;
end;

function PrismDBLookupCombobox.GetOnSetText: TOnSetValue;
begin
 Result:= FProcSetText;
end;

procedure PrismDBLookupCombobox.ProcessEventClass(VCLObj, NewObj: TObject);
begin
 inherited;

end;

procedure PrismDBLookupCombobox.ProcessPropertyByName(VCLObj, NewObj: TObject;
  PropertyName: string; PropertyValue: Variant);
begin
 inherited;

end;

procedure PrismDBLookupCombobox.ProcessPropertyClass(VCLObj, NewObj: TObject);
begin
 inherited;

 if Assigned(Dataware.DataSource) then
 TPrismDBLookupCombobox(NewObj).DataSource:= Dataware.DataSource.DataSource;

 if Dataware.DataSource.DataField <> '' then
 TPrismDBLookupCombobox(NewObj).DataField:= Dataware.DataSource.DataField;

 if Assigned(Dataware.ListSource) then
 TPrismDBLookupCombobox(NewObj).ListDataSource:= Dataware.ListSource.ListSource;

 if Dataware.ListSource.ListField <> '' then
 TPrismDBLookupCombobox(NewObj).ListDataField:= Dataware.ListSource.ListField;

 if Dataware.ListSource.KeyField <> '' then
 TPrismDBLookupCombobox(NewObj).KeyDataField:= Dataware.ListSource.KeyField;

 if Assigned(FProcGetText) then
 TPrismDBLookupCombobox(NewObj).ProcGetText:= FProcGetText;

 if Assigned(FProcSetText) then
 TPrismDBLookupCombobox(NewObj).ProcSetText:= FProcSetText;
end;



procedure PrismDBLookupCombobox.SetOnGetText(AProc: TOnGetValue);
begin
 FProcGetText:= AProc;
end;

procedure PrismDBLookupCombobox.SetOnSetText(AProc: TOnSetValue);
begin
 FProcSetText:= AProc;
end;
{$ELSE}
implementation
{$ENDIF}

end.