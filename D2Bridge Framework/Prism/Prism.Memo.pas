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
