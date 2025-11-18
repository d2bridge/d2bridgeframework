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

unit Prism.HTMLElement;

interface

uses
  Classes, SysUtils, D2Bridge.JSON,
{$IFDEF FMX}
  FMX.StdCtrls, FMX.Edit, FMX.Memo,
{$ELSE}
  StdCtrls, DBCtrls,
{$ENDIF}
{$IFDEF DEVEXPRESS_AVAILABLE}
 cxTextEdit, cxMemo, cxLabel, cxDBEdit, cxDBLabel,
{$ENDIF}
 Prism.Forms.Controls, Prism.Interfaces, Prism.Types;


type
 TPrismHTMLElement = class(TPrismControl, IPrismHTMLElement)
  private
   FStoredHTML: String;
   FHTML: String;
   FLabel: TComponent;
   function GetHTML: String;
   procedure SetHTML(AHTML: string);
   function GetLabelHTMLElement: TComponent;
   procedure SetLabelHTMLElement(ALabel: TComponent);
  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   function IsHTMLElement: Boolean; override;
  public
   constructor Create(AOwner: TObject); override;

   property HTML: String read GetHTML write SetHTML;
   property LabelHTMLElement: TComponent read GetLabelHTMLElement write SetLabelHTMLElement;
 end;



implementation

uses
  Prism.Util, D2Bridge.Util;


{ TPrismHTMLElement }

constructor TPrismHTMLElement.Create(AOwner: TObject);
begin
 inherited;

 FHTML:= '';
 FStoredHTML:= '';
end;

function TPrismHTMLElement.GetEnableComponentState: Boolean;
begin
 Result:= true;
end;

function TPrismHTMLElement.GetHTML: String;
begin
 result:= '';

 if Assigned(LabelHTMLElement) then
 begin
  if (LabelHTMLElement is TLabel) //Label's
{$IFDEF DEVEXPRESS_AVAILABLE}
   or (LabelHTMLElement is TcxLabel)
   or (LabelHTMLElement is TcxDBLabel)
{$ENDIF}
{$IFNDEF FMX} or (LabelHTMLElement is TDBText){$ENDIF} then
   Result:= TLabel(LabelHTMLElement).{$IFNDEF FMX}Caption{$ELSE}Text{$ENDIF}
  else
  if (LabelHTMLElement is TEdit) //Edit's
{$IFDEF DEVEXPRESS_AVAILABLE}
   or (LabelHTMLElement is TcxTextEdit)
   or (LabelHTMLElement is TcxDBTextEdit)
{$ENDIF}
{$IFNDEF FMX} or (LabelHTMLElement is TDBEdit){$ENDIF} then
   Result:= TEdit(LabelHTMLElement).Text
  else
  if (LabelHTMLElement is TMemo) //Memo's
{$IFDEF DEVEXPRESS_AVAILABLE}
   or (LabelHTMLElement is TcxMemo)
   or (LabelHTMLElement is TcxDBMemo)
{$ENDIF}
{$IFNDEF FMX} or (LabelHTMLElement is TDBMemo){$ENDIF} then
   Result:= TrimRight(TMemo(LabelHTMLElement).Text)
 end else
  Result:= FHTML;
end;

function TPrismHTMLElement.GetLabelHTMLElement: TComponent;
begin
 Result:= FLabel;
end;

procedure TPrismHTMLElement.Initialize;
begin
 inherited;

 FStoredHTML := HTML;
end;

function TPrismHTMLElement.IsHTMLElement: Boolean;
begin
 Result:= true;
end;

procedure TPrismHTMLElement.ProcessComponentState(const ComponentStateInfo: TJSONObject);
begin
 inherited;

end;

procedure TPrismHTMLElement.ProcessEventParameters(Event: IPrismControlEvent;
  Parameters: TStrings);
begin
  inherited;

end;

procedure TPrismHTMLElement.ProcessHTML;
begin
 inherited;

 HTMLControl := '<div class="d2bridgehtmlelement" id="' + AnsiUpperCase(NamePrefix) + '">' + Form.ProcessAllTagHTML(HTML) + '</div>';
end;

procedure TPrismHTMLElement.SetHTML(AHTML: string);
begin
  FHTML:= AHTML;
end;

procedure TPrismHTMLElement.SetLabelHTMLElement(ALabel: TComponent);
begin
 FLabel:= ALabel;
end;

procedure TPrismHTMLElement.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
var
 NewHTML: string;
begin
 inherited;

 NewHTML:= HTML;
 if (AForceUpdate) or (FStoredHTML <> NewHTML) then
 begin
  FStoredHTML := NewHTML;

  ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").innerHTML = `' + Form.ProcessAllTagHTML(FStoredHTML) + '`;');
 end;

end;

end.