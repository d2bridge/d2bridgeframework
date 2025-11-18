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

unit D2Bridge.Prism.DBCheckBox;

interface

{$IFNDEF FMX}
uses
  Classes, SysUtils,
  D2Bridge.Interfaces, D2Bridge.Prism, D2Bridge.Prism.Item, D2Bridge.FrameworkItem.DataWare,
  Prism.Types;


type
 PrismDBCheckBox = class(TD2BridgePrismItem, ID2BridgeFrameworkItemDBCheckBox)
  private
   FProcGetText: TOnGetValue;
   FSwitchMode: boolean;
   FD2BridgeDatawareDataSource: TD2BridgeDatawareDataSource;
   FValueChecked: String;
   FValueUnChecked: String;
   procedure SetOnGetText(AProc: TOnGetValue);
   function GetOnGetText: TOnGetValue;
   function GetValueChecked: String;
   procedure SetValueChecked(AValue: String);
   function GetValueUnChecked: String;
   procedure SetValueUnChecked(AValue: String);
   function GetSwitchMode: Boolean;
   procedure SetSwitchMode(const Value: Boolean);
  public
   constructor Create(AD2BridgePrismFramework: TD2BridgePrismFramework); override;
   destructor Destroy; override;

   procedure Clear; override;
   function FrameworkClass: TClass; override;
   procedure ProcessPropertyClass(VCLObj, NewObj: TObject); override;
   procedure ProcessEventClass(VCLObj, NewObj: TObject); override;
   procedure ProcessPropertyByName(VCLObj, NewObj: TObject; PropertyName: string; PropertyValue: Variant); override;

   function Dataware : ID2BridgeDatawareDataSource;

   property OnGetText: TOnGetValue read GetOnGetText write SetOnGetText;
   property ValueChecked: String read GetValueChecked write SetValueChecked;
   property ValueUnChecked: String read GetValueUnChecked write SetValueUnChecked;
   property SwitchMode: Boolean read GetSwitchMode write SetSwitchMode;
  end;



implementation

uses
  Prism.DBCheckBox, Prism.Forms.Controls;


{ PrismDBCheckBox }


procedure PrismDBCheckBox.Clear;
begin
 inherited;

 FSwitchMode:= True;
 Dataware.Clear;
 FProcGetText:= nil;
 ValueChecked:= '';
 ValueUnChecked:= '';
end;

constructor PrismDBCheckBox.Create(
  AD2BridgePrismFramework: TD2BridgePrismFramework);
begin
 inherited;

 FSwitchMode:= true;

 FD2BridgeDatawareDataSource:= TD2BridgeDatawareDataSource.Create;
end;

function PrismDBCheckBox.Dataware: ID2BridgeDatawareDataSource;
begin
 Result:= FD2BridgeDatawareDataSource;
end;

destructor PrismDBCheckBox.Destroy;
begin
 FreeAndNil(FD2BridgeDatawareDataSource);

 inherited;
end;

function PrismDBCheckBox.FrameworkClass: TClass;
begin
 inherited;

 Result:= TPrismDBCheckBox;
end;

function PrismDBCheckBox.GetOnGetText: TOnGetValue;
begin
 Result:= FProcGetText;
end;

function PrismDBCheckBox.GetSwitchMode: Boolean;
begin
 result:= FSwitchMode;
end;

function PrismDBCheckBox.GetValueChecked: String;
begin
 Result:= FValueChecked;
end;

function PrismDBCheckBox.GetValueUnChecked: String;
begin
 Result:= FValueUnChecked;
end;

procedure PrismDBCheckBox.ProcessEventClass(VCLObj, NewObj: TObject);
begin
 inherited;

end;

procedure PrismDBCheckBox.ProcessPropertyByName(VCLObj, NewObj: TObject;
  PropertyName: string; PropertyValue: Variant);
begin
 inherited;

end;

procedure PrismDBCheckBox.ProcessPropertyClass(VCLObj, NewObj: TObject);
begin
 inherited;

 if Assigned(Dataware.DataSource) then
 TPrismDBCheckBox(NewObj).DataSource:= Dataware.DataSource;

 if Dataware.DataField <> '' then
 TPrismDBCheckBox(NewObj).DataField:= Dataware.DataField;

 TPrismDBCheckBox(NewObj).SwitchMode:= SwitchMode;

 TPrismDBCheckBox(NewObj).ValueChecked:= ValueChecked;
 TPrismDBCheckBox(NewObj).ValueUnChecked:= ValueUnChecked;

 if Assigned(FProcGetText) then
 TPrismDBCheckBox(NewObj).ProcGetText:= FProcGetText;

 TPrismControl(NewObj).Events.Add(TPrismEventType.EventOnCheckChange, OnCheckChange, true);
end;

procedure PrismDBCheckBox.SetOnGetText(AProc: TOnGetValue);
begin
 FProcGetText:= AProc;
end;

procedure PrismDBCheckBox.SetSwitchMode(const Value: Boolean);
begin
 FSwitchMode:= Value;
end;

procedure PrismDBCheckBox.SetValueChecked(AValue: String);
begin
 FValueChecked:= AValue;
end;

procedure PrismDBCheckBox.SetValueUnChecked(AValue: String);
begin
 FValueUnChecked:= AValue;
end;
{$ELSE}
implementation
{$ENDIF}

end.