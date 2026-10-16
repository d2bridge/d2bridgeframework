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

unit Prism.DBMemo;

interface

{$IFNDEF FMX}
uses
  Classes, D2Bridge.JSON, SysUtils, DB,
  DBCtrls,
  Prism.Interfaces, Prism.Forms.Controls, Prism.Types, Prism.DataLink.Field;

type
 TPrismDBMemo = class(TPrismControl, IPrismDBMemo)
  private
   FDataLinkField: TPrismDataLinkField;
   FRefreshData: Boolean;
   FStoredText: String;
   FRows: Integer;
   procedure UpdateData; override;
  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   function IsDBMemo: Boolean; override;
   function GetReadOnly: Boolean; override;
   procedure SetRows(ARows: Integer);
   function GetRows: Integer;
  public
   constructor Create(AOwner: TObject); override;
   destructor Destroy; override;

   function DataWare: TPrismDataLinkField;
 end;


implementation

uses
  Prism.Util;

{ TPrismDBMemo }

constructor TPrismDBMemo.Create(AOwner: TObject);
begin
 inherited;

 FRefreshData:= false;
 FDataLinkField:= TPrismDataLinkField.Create(Self);
 FDataLinkField.UseHTMLFormatSettings:= false;
 FRows  := 3;
end;

function TPrismDBMemo.DataWare: TPrismDataLinkField;
begin
 result:= FDataLinkField;
end;

destructor TPrismDBMemo.Destroy;
begin
 FreeAndNil(FDataLinkField);

 inherited;
end;

function TPrismDBMemo.GetEnableComponentState: Boolean;
begin
 Result:= true;
end;

function TPrismDBMemo.GetReadOnly: Boolean;
begin
 result:= Inherited;

 if not result then
  result:= FDataLinkField.ReadOnly;
end;

function TPrismDBMemo.GetRows: Integer;
begin
  Result := FRows;
end;

procedure TPrismDBMemo.Initialize;
begin
 inherited;

 FStoredText:= DataWare.FieldText;
end;

function TPrismDBMemo.IsDBMemo: Boolean;
begin
 Result:= true;
end;

procedure TPrismDBMemo.ProcessComponentState(const ComponentStateInfo: TJSONObject);
var
 vText: string;
begin
 inherited;

 if (ComponentStateInfo.GetValue('text') <> nil) then
 begin
  vText:= ComponentStateInfo.GetValue('text').Value;

  if vText <> FStoredText then
  begin
   DataWare.FieldValue:= vText;

   FStoredText:= DataWare.FieldText;
  end;
 end;
end;

procedure TPrismDBMemo.ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings);
begin
 inherited;

end;

procedure TPrismDBMemo.ProcessHTML;
begin
 inherited;

 HTMLControl := '<textarea ';
 HTMLControl := HTMLControl + ' ' + HTMLCore;
 HTMLControl := HTMLControl + Format(' rows="%d"', [FRows]);
 HTMLControl := HTMLControl + '>';
 HTMLControl := HTMLControl + DataWare.FieldText;
 HTMLControl := HTMLControl + '</textarea>';
end;

procedure TPrismDBMemo.SetRows(ARows: Integer);
begin
 FRows := ARows;
end;

procedure TPrismDBMemo.UpdateData;
begin
 if (Form.FormPageState = PageStateLoaded) and (not Form.ComponentsUpdating) then
 FRefreshData:= true;
end;

procedure TPrismDBMemo.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
var
 NewText: string;
begin
 inherited;

 NewText:= DataWare.FieldText(AForceUpdate);
 if (FStoredText <> NewText) or (AForceUpdate) then
 begin
  FStoredText := NewText;
  ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").value = '+ FormatValueHTML(FStoredText) +';');
 end;

end;

{$ELSE}
implementation
{$ENDIF}

end.