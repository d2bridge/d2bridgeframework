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
  Thank for contribution to this Unit to:
    Edvanio Jancy
    edvanio@ideiasistemas.com.br
 +--------------------------------------------------------------------------+
}

{$I ..\D2Bridge.inc}

unit Prism.Memo;

interface

uses
  Classes, D2Bridge.JSON,
  SysUtils,
{$IFDEF FMX}
  FMX.Graphics,
{$ELSE}
  Graphics,
{$ENDIF}
  Prism, Prism.Interfaces, Prism.Events, Prism.Forms.Controls, Prism.Types;

type
 TPrismMemo = class(TPrismControl, IPrismMemo)
  private
   FLines: TStrings;
   FRows: Integer;
   FStoredText: String;
   FStoredRows: Integer;
  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   function IsMemo: Boolean; override;
   function NeedCheckValidation: Boolean; override;
   procedure SetLines(ALines: TStrings);
   function GetLines: TStrings;
   procedure SetRows(ARows: Integer);
   function GetRows: Integer;
  public
   constructor Create(AOwner: TObject); override;

  published
   property Lines: TStrings read GetLines write SetLines;
   property Rows: Integer read GetRows write SetRows;
 end;

implementation

uses
  Prism.Util;

{ TPrismMemo }

constructor TPrismMemo.Create(AOwner: TObject);
begin
  inherited;
  FLines := nil;
  FRows  := 3;
end;

function TPrismMemo.GetEnableComponentState: Boolean;
begin

end;

function TPrismMemo.GetLines: TStrings;
begin
  Result := FLines;
end;

function TPrismMemo.GetRows: Integer;
begin
  Result := FRows;
end;

procedure TPrismMemo.Initialize;
begin
 inherited;
 FStoredText := FLines.Text;
 FStoredRows := FRows;
end;

function TPrismMemo.IsMemo: Boolean;
begin
  Result := True;
end;

function TPrismMemo.NeedCheckValidation: Boolean;
begin
   Result := true;
end;

procedure TPrismMemo.ProcessComponentState(
  const ComponentStateInfo: TJSONObject);
begin
 inherited;

 if (ComponentStateInfo.GetValue('text') <> nil) then
 begin
  FLines.Text := ComponentStateInfo.GetValue('text').Value;
  FStoredText:= FLines.Text;
 end;
end;

procedure TPrismMemo.ProcessEventParameters(Event: IPrismControlEvent;
  Parameters: TStrings);
begin
  inherited;

end;

procedure TPrismMemo.ProcessHTML;
begin
  inherited;
    HTMLControl := '<div>';
    HTMLControl := HTMLControl + Format('<textarea rows="%d" '+HTMLCore+'>'+FLines.Text+'</textarea>', [FRows]);
    HTMLControl := HTMLControl + '</div>';
end;

procedure TPrismMemo.SetLines(ALines: TStrings);
begin
 FLines := ALines;
end;

procedure TPrismMemo.SetRows(ARows: Integer);
begin
  FRows := ARows;
end;

procedure TPrismMemo.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
var
NewText: String;
begin
 inherited;

 NewText := FLines.Text;
 if AForceUpdate  or (FStoredText <> NewText) then
 begin
  FStoredText := NewText;
  ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").value= `' + FStoredText + '`;');
 end;
end;

end.