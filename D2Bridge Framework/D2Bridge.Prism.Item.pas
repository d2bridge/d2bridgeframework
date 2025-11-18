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

unit D2Bridge.Prism.Item;

interface

uses
  Classes,
  D2Bridge.Interfaces, D2Bridge.Prism;


type
 TD2BridgePrismItem = class(TInterfacedPersistent, ID2BridgeFrameworkItem)
  private
   FD2BridgePrismFramework: TD2BridgePrismFramework;
   FOnClick: TOnEventProc;
   FOnDblClick: TOnEventProc;
   FOnEnter: TOnEventProc;
   FOnExit: TOnEventProc;
   FOnChange: TOnEventProc;
   FOnKeyDown: TOnEventProc;
   FOnKeyUp: TOnEventProc;
   FOnKeyPress: TOnEventProc;
   FOnSelectAll: TOnEventProc;
   FOnUnselectAll: TOnEventProc;
   FOnSelect: TOnEventProc;
   FOnCheckChange: TOnEventProc;
   FOnCheck: TOnEventProc;
   FOnUnCheck: TOnEventProc;
   FProcGetEnabled: TOnGetValue;
   FProcSetEnabled: TOnSetValue;
   FProcGetVisible: TOnGetValue;
   FProcSetVisible: TOnSetValue;
   FProcGetReadOnly: TOnGetValue;
   FProcSetReadOnly: TOnSetValue;
   FProcGetPlaceholder: TOnGetValue;
{$IFDEF FPC}
  protected
{$ENDIF}
   procedure SetProcGetEnabled(AProc: TOnGetValue);
   function GetProcGetEnabled: TOnGetValue;
   procedure SetProcSetEnabled(AProc: TOnSetValue);
   function GetProcSetEnabled: TOnSetValue;
   procedure SetProcGetVisible(AProc: TOnGetValue);
   function GetProcGetVisible: TOnGetValue;
   procedure SetProcSetVisible(AProc: TOnSetValue);
   function GetProcSetVisible: TOnSetValue;
   procedure SetProcGetReadOnly(AProc: TOnGetValue);
   function GetProcGetReadOnly: TOnGetValue;
   procedure SetProcSetReadOnly(AProc: TOnSetValue);
   function GetProcSetReadOnly: TOnSetValue;
   procedure SetProcGetPlaceholder(AProc: TOnGetValue);
   function GetProcGetPlaceholder: TOnGetValue;
   procedure SetOnClick(AProc: TOnEventProc);
   function GetOnClick: TOnEventProc;
   procedure SetOnDblClick(AProc: TOnEventProc);
   function GetOnDblClick: TOnEventProc;
   procedure SetOnEnter(AProc: TOnEventProc);
   function GetOnEnter: TOnEventProc;
   procedure SetOnExit(AProc: TOnEventProc);
   function GetOnExit: TOnEventProc;
   procedure SetOnChange(AProc: TOnEventProc);
   function GetOnChange: TOnEventProc;
   procedure SetOnKeyDown(AProc: TOnEventProc);
   function GetOnKeyDown: TOnEventProc;
   procedure SetOnKeyUp(AProc: TOnEventProc);
   function GetOnKeyUp: TOnEventProc;
   procedure SetOnKeyPress(AProc: TOnEventProc);
   function GetOnKeyPress: TOnEventProc;
   procedure SetOnSelectAll(AProc: TOnEventProc);
   function GetOnSelectAll: TOnEventProc;
   procedure SetOnUnSelectAll(AProc: TOnEventProc);
   function GetOnUnselectAll: TOnEventProc;
   procedure SetOnSelect(AProc: TOnEventProc);
   function GetOnSelect: TOnEventProc;
   procedure SetOnCheck(AProc: TOnEventProc);
   function GetOnCheck: TOnEventProc;
   procedure SetOnCheckChange(AProc: TOnEventProc);
   function GetOnCheckChange: TOnEventProc;
   procedure SetOnUnCheck(AProc: TOnEventProc);
   function GetOnUnCheck: TOnEventProc;
  public
   constructor Create(AD2BridgePrismFramework: TD2BridgePrismFramework); virtual;
   destructor Destroy; override;

   procedure Clear; virtual;
   function FrameworkClass: TClass; virtual; abstract;
   procedure ProcessPropertyClass(VCLObj, NewObj: TObject); virtual;
   procedure ProcessEventClass(VCLObj, NewObj: TObject); virtual;
   procedure ProcessPropertyByName(VCLObj, NewObj: TObject; PropertyName: string; PropertyValue: Variant); virtual;

   property OnClick: TOnEventProc read GetOnClick write SetOnClick;
   property OnDblClick: TOnEventProc read GetOnDblClick write SetOnDblClick;
   property OnEnter: TOnEventProc read GetOnEnter write SetOnEnter;
   property OnExit: TOnEventProc read GetOnExit write SetOnExit;
   property OnChange: TOnEventProc read GetOnChange write SetOnChange;
   property OnKeyDown: TOnEventProc read GetOnKeyDown write SetOnKeyDown;
   property OnKeyUp: TOnEventProc read GetOnKeyUp write SetOnKeyUp;
   property OnKeyPress: TOnEventProc read GetOnKeyPress write SetOnKeyPress;
   property OnSelectAll: TOnEventProc read GetOnSelectAll write SetOnSelectAll;
   property OnUnselectAll: TOnEventProc read GetOnUnSelectAll write SetOnUnSelectAll;
   property OnSelect: TOnEventProc read GetOnSelect write SetOnSelect;
   property OnCheckChange: TOnEventProc read GetOnCheckChange write SetOnCheckChange;
   property OnCheck: TOnEventProc read GetOnCheck write SetOnCheck;
   property OnUnCheck: TOnEventProc read GetOnUnCheck write SetOnUnCheck;

   property GetEnabled: TOnGetValue read GetProcGetEnabled write SetProcGetEnabled;
   property SetEnabled: TOnSetValue read GetProcSetEnabled write SetProcSetEnabled;
   property GetVisible: TOnGetValue read GetProcGetVisible write SetProcGetVisible;
   property SetVisible: TOnSetValue read GetProcSetVisible write SetProcSetVisible;
   property GetReadOnly: TOnGetValue read GetProcGetReadOnly write SetProcGetReadOnly;
   property SetReadOnly: TOnSetValue read GetProcSetReadOnly write SetProcSetReadOnly;
   property GetPlaceholder: TOnGetValue read GetProcGetPlaceholder write SetProcGetPlaceholder;
 end;


implementation

uses
  Prism.Forms.Controls;


{ TD2BridgePrismItem }

procedure TD2BridgePrismItem.Clear;
begin
 FOnClick:= nil;
 FOnDblClick:= nil;
 FOnEnter:= nil;
 FOnExit:= nil;
 FOnChange:= nil;
 FOnKeyDown:= nil;
 FOnKeyUp:= nil;
 FOnKeyPress:= nil;
 FOnSelectAll:= nil;
 FOnUnselectAll:= nil;
 FOnSelect:= nil;
 FOnCheck:= nil;
 FOnUnCheck:= nil;
 FProcGetEnabled:= nil;
 FProcSetEnabled:= nil;
 FProcGetVisible:= nil;
 FProcSetVisible:= nil;
 FProcGetReadOnly:= nil;
 FProcSetReadOnly:= nil;
 FProcGetPlaceholder:= nil;
end;

constructor TD2BridgePrismItem.Create(AD2BridgePrismFramework: TD2BridgePrismFramework);
begin
 FD2BridgePrismFramework:= AD2BridgePrismFramework;
end;

destructor TD2BridgePrismItem.Destroy;
begin
 FOnClick:= nil;
 FOnDblClick:= nil;
 FOnEnter:= nil;
 FOnExit:= nil;
 FOnChange:= nil;
 FOnKeyDown:= nil;
 FOnKeyUp:= nil;
 FOnKeyPress:= nil;
 FOnSelectAll:= nil;
 FOnUnselectAll:= nil;
 FOnSelect:= nil;
 FOnCheck:= nil;
 FOnUnCheck:= nil;
 FProcGetEnabled:= nil;
 FProcSetEnabled:= nil;
 FProcGetVisible:= nil;
 FProcSetVisible:= nil;
 FProcGetReadOnly:= nil;
 FProcSetReadOnly:= nil;
 FProcGetPlaceholder:= nil;

 inherited;
end;

procedure TD2BridgePrismItem.ProcessEventClass(VCLObj, NewObj: TObject);
begin
 if Assigned(OnClick) then
  TPrismControl(NewObj).Events.Add(TPrismEventType.EventOnClick, OnClick);

 if Assigned(OnDblClick) then
  TPrismControl(NewObj).Events.Add(TPrismEventType.EventOnDblClick, OnDblClick);

 if Assigned(OnEnter) then
  TPrismControl(NewObj).Events.Add(TPrismEventType.EventOnEnter, OnEnter);

 if Assigned(OnExit) then
  TPrismControl(NewObj).Events.Add(TPrismEventType.EventOnExit, OnExit);

 if Assigned(OnChange) then
  TPrismControl(NewObj).Events.Add(TPrismEventType.EventOnChange, OnChange);

 if Assigned(OnKeyDown) then
  TPrismControl(NewObj).Events.Add(TPrismEventType.EventOnKeyDown, OnKeyDown);

 if Assigned(OnKeyUp) then
  TPrismControl(NewObj).Events.Add(TPrismEventType.EventOnKeyUp, OnKeyUp);

 if Assigned(OnKeyPress) then
  TPrismControl(NewObj).Events.Add(TPrismEventType.EventOnKeyPress, OnKeyPress);

 if Assigned(OnSelectAll) then
  TPrismControl(NewObj).Events.Add(TPrismEventType.EventOnSelectAll, OnSelectAll);

 if Assigned(OnUnselectAll) then
  TPrismControl(NewObj).Events.Add(TPrismEventType.EventOnUnSelectAll, OnUnSelectAll);

 if Assigned(OnSelect) then
  TPrismControl(NewObj).Events.Add(TPrismEventType.EventOnSelect, OnSelect);

 if Assigned(OnCheck) then
  TPrismControl(NewObj).Events.Add(TPrismEventType.EventOnCheck, OnCheck);

 if Assigned(OnUnCheck) then
  TPrismControl(NewObj).Events.Add(TPrismEventType.EventOnUnCheck, OnUnCheck);
end;

procedure TD2BridgePrismItem.ProcessPropertyByName(VCLObj, NewObj: TObject;
  PropertyName: string; PropertyValue: Variant);
begin

end;

procedure TD2BridgePrismItem.ProcessPropertyClass(VCLObj, NewObj: TObject);
begin
 if Assigned(GetEnabled) then
 TPrismControl(NewObj).ProcGetEnabled:= GetEnabled;

 if Assigned(SetEnabled) then
 TPrismControl(NewObj).ProcSetEnabled:= SetEnabled;

 if Assigned(GetVisible) then
 TPrismControl(NewObj).ProcGetVisible:= GetVisible;

 if Assigned(SetVisible) then
 TPrismControl(NewObj).ProcSetVisible:= SetVisible;

 if Assigned(GetReadOnly) then
 TPrismControl(NewObj).ProcGetReadOnly:= GetReadOnly;

 if Assigned(SetReadOnly) then
 TPrismControl(NewObj).ProcSetReadOnly:= SetReadOnly;

 if Assigned(GetPlaceholder) then
 TPrismControl(NewObj).ProcGetPlaceHolder:= GetPlaceholder;
end;

function TD2BridgePrismItem.GetOnChange: TOnEventProc;
begin
 Result:= FOnChange;
end;

function TD2BridgePrismItem.GetOnCheck: TOnEventProc;
begin
 Result:= FOnCheck;
end;

function TD2BridgePrismItem.GetOnCheckChange: TOnEventProc;
begin
 Result:= FOnCheckChange;
end;

function TD2BridgePrismItem.GetOnClick: TOnEventProc;
begin
 Result:= FOnClick;
end;

function TD2BridgePrismItem.GetOnDblClick: TOnEventProc;
begin
 Result:= FOnDblClick;
end;

function TD2BridgePrismItem.GetOnEnter: TOnEventProc;
begin
 Result:= FOnEnter;
end;

function TD2BridgePrismItem.GetOnExit: TOnEventProc;
begin
 Result:= FOnExit;
end;

function TD2BridgePrismItem.GetOnKeyDown: TOnEventProc;
begin
 Result:= FOnKeyDown;
end;

function TD2BridgePrismItem.GetOnKeyPress: TOnEventProc;
begin
 Result:= FOnKeyPress;
end;

function TD2BridgePrismItem.GetOnKeyUp: TOnEventProc;
begin
 Result:= FOnKeyUp;
end;

function TD2BridgePrismItem.GetOnSelect: TOnEventProc;
begin
 Result:= FOnSelect;
end;

function TD2BridgePrismItem.GetOnSelectAll: TOnEventProc;
begin
 Result:= FOnSelectAll;
end;

function TD2BridgePrismItem.GetOnUnCheck: TOnEventProc;
begin
 Result:= FOnUnCheck;
end;

function TD2BridgePrismItem.GetOnUnselectAll: TOnEventProc;
begin
 Result:= FOnUnSelectAll;
end;

function TD2BridgePrismItem.GetProcGetEnabled: TOnGetValue;
begin
 Result:= FProcGetEnabled;
end;

function TD2BridgePrismItem.GetProcGetPlaceholder: TOnGetValue;
begin
 Result:= FProcGetPlaceholder;
end;

function TD2BridgePrismItem.GetProcGetReadOnly: TOnGetValue;
begin
 Result:= FProcGetReadOnly;
end;

function TD2BridgePrismItem.GetProcGetVisible: TOnGetValue;
begin
 Result:= FProcGetVisible;
end;

function TD2BridgePrismItem.GetProcSetEnabled: TOnSetValue;
begin
 Result:= FProcSetEnabled;
end;

function TD2BridgePrismItem.GetProcSetReadOnly: TOnSetValue;
begin
 Result:= FProcSetReadOnly;
end;

function TD2BridgePrismItem.GetProcSetVisible: TOnSetValue;
begin
 Result:= FProcSetVisible;
end;

procedure TD2BridgePrismItem.SetOnChange(AProc: TOnEventProc);
begin
 FOnChange:= AProc;
end;

procedure TD2BridgePrismItem.SetOnCheck(AProc: TOnEventProc);
begin
 FOnCheck:= AProc;
end;

procedure TD2BridgePrismItem.SetOnCheckChange(AProc: TOnEventProc);
begin
 FOnCheckChange:= AProc;
end;

procedure TD2BridgePrismItem.SetOnClick(AProc: TOnEventProc);
begin
 FOnClick:= AProc;
end;

procedure TD2BridgePrismItem.SetOnDblClick(AProc: TOnEventProc);
begin
 FOnDblClick:= AProc;
end;

procedure TD2BridgePrismItem.SetOnEnter(AProc: TOnEventProc);
begin
 FOnEnter:= AProc;
end;

procedure TD2BridgePrismItem.SetOnExit(AProc: TOnEventProc);
begin
 FOnExit:= AProc;
end;

procedure TD2BridgePrismItem.SetOnKeyDown(AProc: TOnEventProc);
begin
 FOnKeyDown:= AProc;
end;

procedure TD2BridgePrismItem.SetOnKeyPress(AProc: TOnEventProc);
begin
 FOnKeyPress:= AProc;
end;

procedure TD2BridgePrismItem.SetOnKeyUp(AProc: TOnEventProc);
begin
 FOnKeyUp:= AProc;
end;

procedure TD2BridgePrismItem.SetOnSelect(AProc: TOnEventProc);
begin
 FOnSelect:= AProc;
end;

procedure TD2BridgePrismItem.SetOnSelectAll(AProc: TOnEventProc);
begin
 FOnSelectAll:= AProc;
end;

procedure TD2BridgePrismItem.SetOnUnCheck(AProc: TOnEventProc);
begin
 FOnUnCheck:= AProc;
end;

procedure TD2BridgePrismItem.SetOnUnSelectAll(AProc: TOnEventProc);
begin
 FOnUnSelectAll:= AProc;
end;

procedure TD2BridgePrismItem.SetProcGetEnabled(AProc: TOnGetValue);
begin
 FProcGetEnabled:= AProc;
end;

procedure TD2BridgePrismItem.SetProcGetPlaceholder(AProc: TOnGetValue);
begin
 FProcGetPlaceholder:= AProc;
end;

procedure TD2BridgePrismItem.SetProcGetReadOnly(AProc: TOnGetValue);
begin
 FProcGetReadOnly:= AProc;
end;

procedure TD2BridgePrismItem.SetProcGetVisible(AProc: TOnGetValue);
begin
 FProcGetVisible:= AProc;
end;

procedure TD2BridgePrismItem.SetProcSetEnabled(AProc: TOnSetValue);
begin
 FProcSetEnabled:= AProc;
end;

procedure TD2BridgePrismItem.SetProcSetReadOnly(AProc: TOnSetValue);
begin
 FProcSetReadOnly:= AProc;
end;

procedure TD2BridgePrismItem.SetProcSetVisible(AProc: TOnSetValue);
begin
 FProcSetVisible:= AProc;
end;

end.