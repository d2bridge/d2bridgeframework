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

unit Prism.ControlGeneric;

interface

uses
  Classes, SysUtils, D2Bridge.JSON,
{$IFDEF FMX}

{$ELSE}

{$ENDIF}
  Prism.Forms.Controls, Prism.Interfaces, Prism.Types;


type
 TPrismControlGeneric = class(TPrismControl, IPrismControlGeneric)
  private

  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   function IsControlGeneric: Boolean; override;
  public
   constructor Create(AOwner: TObject); override;
 end;



implementation

uses
  Prism.Util;


constructor TPrismControlGeneric.Create(AOwner: TObject);
begin
 inherited;
end;

function TPrismControlGeneric.GetEnableComponentState: Boolean;
begin
 Result:= true;
end;

procedure TPrismControlGeneric.Initialize;
begin
 inherited;
end;

function TPrismControlGeneric.IsControlGeneric: Boolean;
begin
 result:= true;
end;

procedure TPrismControlGeneric.ProcessComponentState(const ComponentStateInfo: TJSONObject);
begin
 inherited;

end;

procedure TPrismControlGeneric.ProcessEventParameters(Event: IPrismControlEvent;
  Parameters: TStrings);
begin
  inherited;

end;

procedure TPrismControlGeneric.ProcessHTML;
begin
 inherited;

end;

procedure TPrismControlGeneric.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
begin
 inherited;

end;

end.