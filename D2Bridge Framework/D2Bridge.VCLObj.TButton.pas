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

unit D2Bridge.VCLObj.TButton;

interface

uses
  Classes,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTButton = class(TD2BridgeItemVCLObjCore)
  private
   procedure TButtonOnEnter(EventParams: TStrings);
   procedure TButtonOnExit(EventParams: TStrings);
   procedure TButtonOnKeyDown(EventParams: TStrings);
{$IFNDEF FMX}
   procedure TButtonOnKeyPress(EventParams: TStrings);
{$ENDIF}
   procedure TButtonOnClick(EventParams: TStrings);
   function TButtonGetEnabled: Variant;
   procedure TButtonSetEnabled(AValue: Variant);
   function TButtonGetVisible: Variant;
   procedure TButtonSetVisible(AValue: Variant);
   function TButtonOnGetCaption: Variant;
  public
   function VCLClass: TClass; override;
   function CSSClass: String; override;
   Procedure VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle); override;
   procedure ProcessPropertyClass(NewObj: TObject); override;
   procedure ProcessEventClass; override;
   function FrameworkItemClass: ID2BridgeFrameworkItem; override;
 end;

implementation

uses
{$IFDEF FMX}
  FMX.StdCtrls,
{$ELSE}
  StdCtrls, Buttons,
  {$IFDEF DEVEXPRESS_AVAILABLE}cxButtons,{$ENDIF}
{$ENDIF}
  D2Bridge.Util,
  Prism.Util, D2Bridge.Forms, Prism.Forms
{$IFDEF HAS_UNIT_SYSTEM_UITYPES}
  , System.UITypes
{$ENDIF}
;

{ TVCLObjTButton }

function TVCLObjTButton.CSSClass: String;
begin
 Result:= 'btn';
end;

function TVCLObjTButton.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Button;
end;

procedure TVCLObjTButton.TButtonOnEnter(EventParams: TStrings);
begin
 TButton(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTButton.TButtonOnExit(EventParams: TStrings);
begin
 TButton(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
end;

function TVCLObjTButton.TButtonOnGetCaption: Variant;
begin
 Result:= TButton(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}Caption{$ELSE}Text{$ENDIF};
end;

procedure TVCLObjTButton.TButtonOnKeyDown(EventParams: TStrings);
var
 KeyPress: word;
 KeyChar:  Char;
begin
 KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
{$IFNDEF FMX}
 TButton(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
{$ELSE}
 KeyChar:= Char(KeyPress);
 TButton(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, KeyChar, []);
{$ENDIF}
end;

{$IFNDEF FMX}
procedure TVCLObjTButton.TButtonOnKeyPress(EventParams: TStrings);
var
 KeyPress: Char;
begin
 KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
 TButton(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
end;
{$ENDIF}

procedure TVCLObjTButton.ProcessEventClass;
begin
 if Assigned(TButton(FD2BridgeItemVCLObj.Item).OnEnter) then
 FrameworkItemClass.OnEnter:= TButtonOnEnter;

 if Assigned(TButton(FD2BridgeItemVCLObj.Item).OnExit) then
 FrameworkItemClass.OnExit:= TButtonOnExit;

 if Assigned(TButton(FD2BridgeItemVCLObj.Item).OnKeyDown) then
 FrameworkItemClass.OnKeyDown:= TButtonOnKeyDown;

{$IFNDEF FMX}
 if Assigned(TButton(FD2BridgeItemVCLObj.Item).OnKeyPress) then
 FrameworkItemClass.OnKeyPress:= TButtonOnKeyPress;
{$ENDIF}
end;

procedure TVCLObjTButton.TButtonOnClick(EventParams: TStrings);
var
 vD2BridgeForm: TD2BridgeForm;
 FModalResult: Integer;
begin
 {$IFNDEF FMX}
  if FD2BridgeItemVCLObj.PrismControl <> nil then
   if Assigned(FD2BridgeItemVCLObj.PrismControl.Form) then
   begin
    vD2BridgeForm:= (FD2BridgeItemVCLObj.PrismControl.Form as TPrismForm).D2BridgeForm;
    if Assigned(vD2BridgeForm) then
    begin
     FModalResult:= -1;

     if (FD2BridgeItemVCLObj.Item is TButton) then
      FModalResult:= TButton(FD2BridgeItemVCLObj.Item).ModalResult;
     {$IFNDEF FMX}
      if (FD2BridgeItemVCLObj.Item is TBitBtn) then
       FModalResult:= TBitBtn(FD2BridgeItemVCLObj.Item).ModalResult;
      {$IFDEF DEVEXPRESS_AVAILABLE}
       if (FD2BridgeItemVCLObj.Item is TBitBtn) then
        FModalResult:= TcxButton(FD2BridgeItemVCLObj.Item).ModalResult;
      {$ENDIF}
     {$ENDIF}
     if vD2BridgeForm.ShowingModal and (FModalResult > 0) then
     begin
       vD2BridgeForm.ModalResult:= FModalResult;
     end;
    end;
   end;
 {$ENDIF}


 if Assigned(TButton(FD2BridgeItemVCLObj.Item).OnClick) then
  TButton(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
end;

function TVCLObjTButton.TButtonGetEnabled: Variant;
begin
 Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTButton.TButtonSetEnabled(AValue: Variant);
begin
 TButton(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
end;

function TVCLObjTButton.TButtonGetVisible: Variant;
begin
 Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTButton.TButtonSetVisible(AValue: Variant);
begin
 TButton(FD2BridgeItemVCLObj.Item).Visible:= AValue;
end;

procedure TVCLObjTButton.ProcessPropertyClass(NewObj: TObject);
begin
 if Assigned(TButton(FD2BridgeItemVCLObj.Item).OnClick) or
    (FD2BridgeItemVCLObj.Item is TButton) {$IFNDEF FMX} or (FD2BridgeItemVCLObj.Item is TBitBtn) {$IFDEF DEVEXPRESS_AVAILABLE}or (FD2BridgeItemVCLObj.Item is TcxButton){$ENDIF}{$ENDIF} then
 FrameworkItemClass.OnClick:= TButtonOnClick;

{$IFNDEF FMX}
 {$IFDEF DELPHIX_SYDNEY_UP} // Delphi 10.4 Sydney or Upper
  if (FD2BridgeItemVCLObj.Item is TButton) then
  begin
   if TButton(FD2BridgeItemVCLObj.Item).ImageName <> '' then
    FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Button.CSSButtonIcon := TButton(FD2BridgeItemVCLObj.Item).ImageName;
  end else
   if (FD2BridgeItemVCLObj.Item is TBitBtn) then
   begin
    if TBitBtn(FD2BridgeItemVCLObj.Item).ImageName <> '' then
     FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Button.CSSButtonIcon := TBitBtn(FD2BridgeItemVCLObj.Item).ImageName;
   end;
 {$ENDIF}
{$ENDIF}

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Button.GetEnabled:= TButtonGetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Button.SetEnabled:= TButtonSetEnabled;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Button.GetVisible:= TButtonGetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Button.SetVisible:= TButtonSetVisible;
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Button.OnGetCaption:= TButtonOnGetCaption;
end;

function TVCLObjTButton.VCLClass: TClass;
begin
 Result:= TButton;
end;


procedure TVCLObjTButton.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin

end;

end.