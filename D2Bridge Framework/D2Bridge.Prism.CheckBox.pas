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

{$I D2Bridge.inc}

unit D2Bridge.Prism.CheckBox;

interface

uses
  Classes,
  D2Bridge.Interfaces, D2Bridge.Prism, D2Bridge.Prism.Item,
  Prism.Types;


type
 PrismCheckBox = class(TD2BridgePrismItem, ID2BridgeFrameworkItemCheckBox)
  private
   FProcGetText: TOnGetValue;
   FProcGetChecked: TOnGetValue;
   FProcSetChecked: TOnSetValue;
   FSwitchMode: boolean;
   procedure SetOnGetText(AProc: TOnGetValue);
   function GetOnGetText: TOnGetValue;
   procedure SetOnGetChecked(AOnGetValue: TOnGetValue);
   function GetOnGetChecked: TOnGetValue;
   procedure SetOnSetChecked(AOnSetValue: TOnSetValue);
   function GetOnSetChecked: TOnSetValue;
   function GetSwitchMode: Boolean;
   procedure SetSwitchMode(const Value: Boolean);
  public
   constructor Create(AD2BridgePrismFramework: TD2BridgePrismFramework); override;

   procedure Clear; override;
   function FrameworkClass: TClass; override;
   procedure ProcessPropertyClass(VCLObj, NewObj: TObject); override;
   procedure ProcessEventClass(VCLObj, NewObj: TObject); override;
   procedure ProcessPropertyByName(VCLObj, NewObj: TObject; PropertyName: string; PropertyValue: Variant); override;

   property OnGetText: TOnGetValue read GetOnGetText write SetOnGetText;
   property OnGetChecked: TOnGetValue read GetOnGetChecked write SetOnGetChecked;
   property OnSetChecked: TOnSetValue read GetOnSetChecked write SetOnSetChecked;
   property SwitchMode: Boolean read GetSwitchMode write SetSwitchMode;
  end;



implementation

uses
  Prism.CheckBox, Prism.Forms.Controls;


{ PrismCheckBox }


procedure PrismCheckBox.Clear;
begin
 inherited;

 FSwitchMode:= true;
 FProcGetText:= nil;
 FProcGetChecked:= nil;
 FProcSetChecked:= nil;
end;

constructor PrismCheckBox.Create(
  AD2BridgePrismFramework: TD2BridgePrismFramework);
begin
 inherited;

 FSwitchMode:= true;
end;

function PrismCheckBox.FrameworkClass: TClass;
begin
 inherited;

 Result:= TPrismCheckBox;
end;

function PrismCheckBox.GetOnGetChecked: TOnGetValue;
begin
 Result:= FProcGetChecked;
end;

function PrismCheckBox.GetOnGetText: TOnGetValue;
begin
 Result:= FProcGetText;
end;

function PrismCheckBox.GetOnSetChecked: TOnSetValue;
begin
 Result:= FProcSetChecked;
end;


function PrismCheckBox.GetSwitchMode: Boolean;
begin
 result:= FSwitchMode;
end;

procedure PrismCheckBox.ProcessEventClass(VCLObj, NewObj: TObject);
begin
 inherited;

end;

procedure PrismCheckBox.ProcessPropertyByName(VCLObj, NewObj: TObject;
  PropertyName: string; PropertyValue: Variant);
begin
 inherited;

end;

procedure PrismCheckBox.ProcessPropertyClass(VCLObj, NewObj: TObject);
begin
 inherited;

 TPrismCheckBox(NewObj).SwitchMode:= SwitchMode;

 if Assigned(FProcGetText) then
 TPrismCheckBox(NewObj).ProcGetText:= FProcGetText;

 if Assigned(FProcGetChecked) then
 begin
  TPrismCheckBox(NewObj).ProcGetChecked:= FProcGetChecked;
 end;

 if Assigned(FProcSetChecked) then
 begin
  TPrismCheckBox(NewObj).ProcSetChecked:= FProcSetChecked;
 end;

 TPrismControl(NewObj).Events.Add(TPrismEventType.EventOnCheckChange, OnCheckChange, true);
end;


procedure PrismCheckBox.SetOnGetChecked(AOnGetValue: TOnGetValue);
begin
 FProcGetChecked:= AOnGetValue;
end;

procedure PrismCheckBox.SetOnGetText(AProc: TOnGetValue);
begin
 FProcGetText:= AProc;
end;

procedure PrismCheckBox.SetOnSetChecked(AOnSetValue: TOnSetValue);
begin
 FProcSetChecked:= AOnSetValue;
end;


procedure PrismCheckBox.SetSwitchMode(const Value: Boolean);
begin
 FSwitchMode:= Value;
end;

end.
