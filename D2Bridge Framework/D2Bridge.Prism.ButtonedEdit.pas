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

unit D2Bridge.Prism.ButtonedEdit;

interface

{$IFNDEF FMX}
uses
  Classes,
  D2Bridge.Interfaces, D2Bridge.Prism, D2Bridge.Prism.Item, D2Bridge.Prism.Edit,
  Prism.Types;



type
 PrismButtonedEdit = class(PrismEdit, ID2BridgeFrameworkItemButtonedEdit)
  private
   FButtonLeftVisible: Boolean;
   FButtonRightVisible: Boolean;
   FButtonLeftEnabled: Boolean;
   FButtonRightEnabled: Boolean;
   FButtonLeftCSS: string;
   FButtonRightCSS: string;
   FButtonLeftText: string;
   FButtonRightText: string;
   FOnLeftButtonClick: TOnEventProc;
   FOnRightButtonClick: TOnEventProc;
   FGetProcGetLeftButtonEnabled: TOnGetValue;
   FGetProcGetLeftButtonVisible: TOnGetValue;
   FGetProcGetRightButtonEnabled: TOnGetValue;
   FGetProcGetRightButtonVisible: TOnGetValue;
   procedure SetButtonLeftVisible(Value: Boolean);
   function GetButtonLeftVisible: boolean;
   procedure SetButtonLeftEnabled(Value: Boolean);
   function GetButtonLeftEnabled: boolean;
   procedure SetButtonLeftCSS(Value: String);
   function GetButtonLeftCSS: string;
   procedure SetButtonLeftText(Value: String);
   function GetButtonLeftText: string;
   procedure SetButtonRightVisible(Value: Boolean);
   function GetButtonRightVisible: boolean;
   procedure SetButtonRightEnabled(Value: Boolean);
   function GetButtonRightEnabled: boolean;
   procedure SetButtonRightCSS(Value: String);
   function GetButtonRightCSS: string;
   procedure SetButtonRightText(Value: String);
   function GetButtonRightText: string;
  public
   constructor Create(AD2BridgePrismFramework: TD2BridgePrismFramework); override;

   procedure Clear; override;
   function FrameworkClass: TClass; override;
   procedure ProcessPropertyClass(VCLObj, NewObj: TObject); override;
   procedure ProcessEventClass(VCLObj, NewObj: TObject); override;
   procedure ProcessPropertyByName(VCLObj, NewObj: TObject; PropertyName: string; PropertyValue: Variant); override;

   property OnLeftButtonClick: TOnEventProc read FOnLeftButtonClick write FOnLeftButtonClick;
   property OnRightButtonClick: TOnEventProc read FOnRightButtonClick write FOnRightButtonClick;

   property GetLeftButtonEnabled: TOnGetValue read FGetProcGetLeftButtonEnabled write FGetProcGetLeftButtonEnabled;
   property GetLeftButtonVisible: TOnGetValue read FGetProcGetLeftButtonVisible write FGetProcGetLeftButtonVisible;
   property GetRightButtonEnabled: TOnGetValue read FGetProcGetRightButtonEnabled write FGetProcGetRightButtonEnabled;
   property GetRightButtonVisible: TOnGetValue read FGetProcGetRightButtonVisible write FGetProcGetRightButtonVisible;

   property ButtonLeftVisible: boolean read GetButtonLeftVisible write SetButtonLeftVisible;
   property ButtonLeftEnabled: boolean read GetButtonLeftEnabled write SetButtonLeftEnabled;
   property ButtonLeftCSS: string read GetButtonLeftCSS write SetButtonLeftCSS;
   property ButtonLeftText: string read GetButtonLeftText write SetButtonLeftText;
   property ButtonRightVisible: boolean read GetButtonRightVisible write SetButtonRightVisible;
   property ButtonRightEnabled: boolean read GetButtonRightEnabled write SetButtonRightEnabled;
   property ButtonRightCSS: string read GetButtonRightCSS write SetButtonRightCSS;
   property ButtonRightText: string read GetButtonRightText write SetButtonRightText;
  end;



implementation

uses
  Prism.ButtonedEdit, Prism.Forms.Controls;


{ PrismButtonedEdit }


procedure PrismButtonedEdit.Clear;
begin
 inherited;

 FButtonLeftVisible:= false;
 FButtonRightVisible:= false;
 FButtonLeftEnabled:= false;
 FButtonRightEnabled:= false;
 FButtonLeftCSS:= '';
 FButtonRightCSS:= '';
 FButtonLeftText:= '';
 FButtonRightText:= '';
 FOnLeftButtonClick:= nil;
 FOnRightButtonClick:= nil;
 FGetProcGetLeftButtonEnabled:= nil;
 FGetProcGetLeftButtonVisible:= nil;
 FGetProcGetRightButtonEnabled:= nil;
 FGetProcGetRightButtonVisible:= nil;
end;

constructor PrismButtonedEdit.Create(AD2BridgePrismFramework: TD2BridgePrismFramework);
begin
 inherited;

end;

function PrismButtonedEdit.FrameworkClass: TClass;
begin
 inherited;

 Result:= TPrismButtonedEdit;
end;

function PrismButtonedEdit.GetButtonLeftCSS: string;
begin
 Result:= FButtonLeftCSS;
end;

function PrismButtonedEdit.GetButtonLeftEnabled: boolean;
begin
 result:= FButtonLeftEnabled;
end;

function PrismButtonedEdit.GetButtonLeftText: string;
begin
 Result:= FButtonLeftText;
end;

function PrismButtonedEdit.GetButtonLeftVisible: boolean;
begin
 Result:= FButtonLeftVisible;
end;

function PrismButtonedEdit.GetButtonRightCSS: string;
begin
 Result:= FButtonRightCSS;
end;

function PrismButtonedEdit.GetButtonRightEnabled: boolean;
begin
 Result:= FButtonRightEnabled;
end;

function PrismButtonedEdit.GetButtonRightText: string;
begin
 Result:= FButtonRightText;
end;

function PrismButtonedEdit.GetButtonRightVisible: boolean;
begin
 Result:= FButtonRightVisible;
end;

procedure PrismButtonedEdit.ProcessEventClass(VCLObj, NewObj: TObject);
begin
 inherited;

 if Assigned(FOnLeftButtonClick) then
  TPrismControl(NewObj).Events.Add(TPrismEventType.EventOnLeftClick, FOnLeftButtonClick);

 if Assigned(FOnRightButtonClick) then
  TPrismControl(NewObj).Events.Add(TPrismEventType.EventOnRightClick, FOnRightButtonClick);
end;

procedure PrismButtonedEdit.ProcessPropertyByName(VCLObj, NewObj: TObject; PropertyName: string; PropertyValue: Variant);
begin
 inherited;

end;

procedure PrismButtonedEdit.ProcessPropertyClass(VCLObj, NewObj: TObject);
begin
 inherited;

 TPrismButtonedEdit(NewObj).ProcGetLeftButtonEnabled:= FGetProcGetLeftButtonEnabled;
 TPrismButtonedEdit(NewObj).ProcGetRightButtonEnabled:= FGetProcGetRightButtonEnabled;
 TPrismButtonedEdit(NewObj).ProcGetLeftButtonVisible:= FGetProcGetLeftButtonVisible;
 TPrismButtonedEdit(NewObj).ProcGetRightButtonVisible:= FGetProcGetRightButtonVisible;

 TPrismButtonedEdit(NewObj).ButtonLeftText:= ButtonLeftText;
 TPrismButtonedEdit(NewObj).ButtonRightText:= ButtonRightText;
end;

procedure PrismButtonedEdit.SetButtonLeftCSS(Value: String);
begin
 FButtonLeftCSS := value;
end;

procedure PrismButtonedEdit.SetButtonLeftEnabled(Value: Boolean);
begin
 FButtonLeftEnabled:= Value;
end;

procedure PrismButtonedEdit.SetButtonLeftText(Value: String);
begin
 FButtonLeftText := value;
end;

procedure PrismButtonedEdit.SetButtonLeftVisible(Value: Boolean);
begin
 FButtonLeftVisible:= value;
end;

procedure PrismButtonedEdit.SetButtonRightCSS(Value: String);
begin
 FButtonRightCSS := Value;
end;

procedure PrismButtonedEdit.SetButtonRightEnabled(Value: Boolean);
begin
 FButtonRightEnabled:= Value;
end;

procedure PrismButtonedEdit.SetButtonRightText(Value: String);
begin
 FButtonRightText := Value;
end;

procedure PrismButtonedEdit.SetButtonRightVisible(Value: Boolean);
begin
 FButtonRightVisible := Value;
end;

{$ELSE}
implementation
{$ENDIF}

end.
