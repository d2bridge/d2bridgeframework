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

unit Prism.Badge;

interface

uses
  Classes, SysUtils, D2Bridge.JSON,
{$IFDEF FMX}

{$ELSE}
  StdCtrls, DBCtrls,
{$ENDIF}
  Prism.Forms.Controls, Prism.Interfaces, Prism.Types;


type
 TPrismBadge = class(TPrismControl, IPrismBadge)
  private
   FButtonHTMLElement: TComponent;
   FLabel: TComponent;
  strict protected
   function GetLabelHTMLElement: TComponent;
   procedure SetLabelHTMLElement(AComponent: TComponent);
   function GetButtonHTMLElement: TComponent;
   procedure SetButtonHTMLElement(const Value: TComponent);
  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessEvent(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   function IsBadge: Boolean; override;
  public
   constructor Create(AOwner: TObject); override;

   property ButtonHTMLElement: TComponent read GetButtonHTMLElement write SetButtonHTMLElement;
   property LabelHTMLElement: TComponent read GetLabelHTMLElement write SetLabelHTMLElement;

 end;


implementation

{ TPrismBadge }

constructor TPrismBadge.Create(AOwner: TObject);
begin
  inherited;

end;

function TPrismBadge.GetButtonHTMLElement: TComponent;
begin
 Result := FButtonHTMLElement;
end;

function TPrismBadge.GetEnableComponentState: Boolean;
begin

end;

function TPrismBadge.GetLabelHTMLElement: TComponent;
begin
 result:= FLabel;
end;

procedure TPrismBadge.Initialize;
begin
  inherited;

end;

function TPrismBadge.IsBadge: Boolean;
begin
 result:= true;
end;

procedure TPrismBadge.ProcessComponentState(
  const ComponentStateInfo: TJSONObject);
begin
  inherited;

end;

procedure TPrismBadge.ProcessEvent(Event: IPrismControlEvent;
  Parameters: TStrings);
begin
  inherited;

end;

procedure TPrismBadge.ProcessEventParameters(Event: IPrismControlEvent;
  Parameters: TStrings);
begin
  inherited;

end;

procedure TPrismBadge.ProcessHTML;
begin
  inherited;

end;

procedure TPrismBadge.SetButtonHTMLElement(const Value: TComponent);
begin
 FButtonHTMLElement := Value;
end;

procedure TPrismBadge.SetLabelHTMLElement(AComponent: TComponent);
begin
 FLabel:= AComponent;
end;

procedure TPrismBadge.UpdateServerControls(var ScriptJS: TStrings;
  AForceUpdate: Boolean);
begin
  inherited;

end;

end.