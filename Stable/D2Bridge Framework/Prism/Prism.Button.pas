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

unit Prism.Button;

interface

uses
  Classes, D2Bridge.JSON,
  Prism, Prism.Interfaces, Prism.Events, Prism.Forms.Controls, Prism.Types;


type
 TPrismButton = class(TPrismControl, IPrismButton)
  private
   FStoredCaption: String;
   FPopupHTML: string;
   FProcGetCaption: TOnGetValue;
   FCSSButtonIcon: string;
   FCSSButtonIconPosition: TPrismPosition;
   procedure SetPopupHTML(Value: String);
   function GetPopupHTML: String;
   function GetCSSButtonIcon: string;
   procedure SetCSSButtonIcon(const Value: string);
   function GetCSSButtonIconPosition: TPrismPosition;
   procedure SetCSSButtonIconPosition(const Value: TPrismPosition);
  protected
   function GetCaption: String;
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   function IsButton: Boolean; override;
   function NeedCheckValidation: Boolean; override;
  public
   constructor Create(AOwner: TObject); override;

  published
   property Caption: String read GetCaption;
   property CSSButtonIcon: string read GetCSSButtonIcon write SetCSSButtonIcon;
   property CSSButtonIconPosition: TPrismPosition read GetCSSButtonIconPosition write SetCSSButtonIconPosition;
   property ProcGetCaption: TOnGetValue read FProcGetCaption write FProcGetCaption;
   property PopupHTML: String read GetPopupHTML write SetPopupHTML;
 end;


implementation

uses
  Prism.Util, SysUtils;


{ TPrismButton }

constructor TPrismButton.Create(AOwner: TObject);
begin
 inherited;

 FCSSButtonIconPosition:= PrismPositionLeft;
 FPopupHTML:= '';
 FProcGetCaption:= nil;
 FCSSButtonIcon:= '';
 FStoredCaption:= '';
end;

function TPrismButton.GetCaption: String;
var
 vCSSButtonIcon: string;
begin
 if Assigned(ProcGetCaption) then
 begin
  Result:= ProcGetCaption;
 end else
  Result:= FStoredCaption;

 vCSSButtonIcon:= FCSSButtonIcon;

 if Result = '' then
 begin
  if vCSSButtonIcon <> '' then
  begin
   vCSSButtonIcon := StringReplace(vCSSButtonIcon, ' me-2', '', []);
   vCSSButtonIcon := StringReplace(vCSSButtonIcon, ' ms-2', '', []);
  end;
 end else
  Result := Result + ' ';

 if vCSSButtonIcon <> '' then
 begin
  vCSSButtonIcon:= '<i class="d2bridgebuttonicon ' + vCSSButtonIcon + '"> </i>';

  if FCSSButtonIconPosition = PrismPositionLeft then
   Result:= vCSSButtonIcon + ' ' + Result
  else
  if FCSSButtonIconPosition = PrismPositionRight then
   Result:= Result + ' ' + vCSSButtonIcon;
 end;
end;

function TPrismButton.GetCSSButtonIcon: string;
begin
 result:= FCSSButtonIcon;
end;

function TPrismButton.GetCSSButtonIconPosition: TPrismPosition;
begin
 result:= FCSSButtonIconPosition;
end;

function TPrismButton.GetEnableComponentState: Boolean;
begin
 Result:= false;
end;

function TPrismButton.GetPopupHTML: String;
begin
 result:= FPopupHTML;
end;

procedure TPrismButton.Initialize;
begin
 inherited;

 FStoredCaption:= Caption;
end;

function TPrismButton.IsButton: Boolean;
begin
 result:= true;
end;

function TPrismButton.NeedCheckValidation: Boolean;
begin
 Result:= true;
end;

procedure TPrismButton.ProcessComponentState(
  const ComponentStateInfo: TJSONObject);
begin
  inherited;

end;

procedure TPrismButton.ProcessEventParameters(Event: IPrismControlEvent;
  Parameters: TStrings);
begin
  inherited;

end;

procedure TPrismButton.ProcessHTML;
begin
 inherited;

 HTMLControl:= '';

 if FPopupHTML <> '' then
  HTMLControl:= '<div class="d2bridgedropdown dropdown" id="dropdown' + UpperCase(NamePrefix) + '" for="' + UpperCase(NamePrefix) + '">' + sLineBreak;

 HTMLControl:= HTMLControl + '<button '+ HTMLCore +'>' + StringReplace(FStoredCaption, '&', '', [rfReplaceAll]) + D2BridgeItem.HTMLItems.Text + '</button>';
 if FPopupHTML <> '' then
  HTMLControl:= HTMLControl + sLineBreak;

 if FPopupHTML <> '' then
 begin
  HTMLControl:= HTMLControl + FPopupHTML;
  HTMLControl:= HTMLControl + '</div>';
 end;
end;

procedure TPrismButton.SetCSSButtonIcon(const Value: string);
begin
 FCSSButtonIcon:= Value;

 if FCSSButtonIcon <> '' then
  if (Pos('me-', FCSSButtonIcon) <= 0) and (Pos('ms-', FCSSButtonIcon) <= 0) then
   FCSSButtonIcon:= FCSSButtonIcon + ' me-2';
end;

procedure TPrismButton.SetCSSButtonIconPosition(const Value: TPrismPosition);
begin
 FCSSButtonIconPosition:= Value;
end;

procedure TPrismButton.SetPopupHTML(Value: String);
begin
 FPopupHTML:= Value;
end;

procedure TPrismButton.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
var
 NewCaption: string;
begin
 inherited;

 NewCaption:= Caption;
 if (AForceUpdate) or (FStoredCaption <> NewCaption) then
 begin
  FStoredCaption := NewCaption;
  //ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").innerHTML = '+ FormatValueHTML(FStoredCaption) +';');

  ScriptJS.Add(
  '(() => {'+
  '  const el = document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]");'+
  '  if (!el) return;'+
  '  const badge = el.querySelector("span.d2bridgelabelbadge");'+
  '  if (badge) {'+
  '    const badgeHTML = badge.outerHTML;'+
  '    const wasBefore = (badge.previousSibling === null);'+
  '    el.innerHTML = '+FormatValueHTML(FStoredCaption)+';'+
  '    if (wasBefore) el.insertAdjacentHTML("afterbegin", badgeHTML);'+
  '    else el.insertAdjacentHTML("beforeend", badgeHTML);'+
  '  } else {'+
  '    el.innerHTML = '+FormatValueHTML(FStoredCaption)+';'+
  '  }'+
  '})();'
  );

 end;

end;

end.