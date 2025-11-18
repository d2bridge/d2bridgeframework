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

unit Prism.DBImage;

interface

{$IFNDEF FMX}
uses
  Classes, D2Bridge.JSON, SysUtils, DB,
{$IFDEF FPC}
  base64,
{$ENDIF}
  Prism.Interfaces, Prism.Forms.Controls, Prism.Types, Prism.DataLink.Field;

type
 TPrismDBImage = class(TPrismControl, IPrismDBImage)
  private
   FRefreshData: Boolean;
   FStoredText: string;
   FDataLinkField: TPrismDataLinkField;
   FImageFolder: string;
   procedure UpdateData; override;
   function ConvertLocalToBase64(AImageLocal: string): string;
   function ImageToSrc: string;
   procedure SetImageFolder(AValue: String);
   function GetImageFolder: String;
  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
  public
   constructor Create(AOwner: TObject); override;
   destructor Destroy; override;

   function DataWare: TPrismDataLinkField;

   property ImageFolder: String read GetImageFolder write SetImageFolder;
 end;


implementation

uses
  Prism.Util, System.NetEncoding;

{ TPrismDBImage }

function TPrismDBImage.ConvertLocalToBase64(AImageLocal: string): string;
var
  FileStream: TFileStream;
  Output: TStringStream;
{$IFDEF FPC}
  Encoder: TBase64EncodingStream;
{$ENDIF}
begin
 try
  Result := '';

  if FImageFolder <> '' then
   AImageLocal:= IncludeTrailingPathDelimiter(FImageFolder) + ExcludeTrailingBackslash(AImageLocal);

  if not FileExists(AImageLocal) then
    Exit;

  FileStream := TFileStream.Create(AImageLocal, fmOpenRead or fmShareDenyWrite);
  Output := TStringStream.Create;
  try
    FileStream.Position := 0;

{$IFNDEF FPC}
  {$IFDEF HAS_UNIT_SYSTEM_NETENCODING}
    TNetEncoding.Base64.Encode(FileStream, Output);
  {$ELSE}
    EncodeStream(FileStream, Output);
  {$ENDIF}
{$ELSE}
    Encoder:= TBase64EncodingStream.Create(Output);
    Encoder.CopyFrom(FileStream, FileStream.Size);
    Encoder.Flush;
{$ENDIF}

    Output.Position := 0;

    Result := 'data:image/jpeg;base64, '+Output.DataString;
  finally
    FileStream.Free;
    Output.Free;
{$IFDEF FPC}
    Encoder.Free;
{$ENDIF}
  end;
 except
 end;
end;

constructor TPrismDBImage.Create(AOwner: TObject);
begin
 inherited;

 FRefreshData:= false;
 FDataLinkField:= TPrismDataLinkField.Create(Self);

 FImageFolder:= '';
end;

function TPrismDBImage.DataWare: TPrismDataLinkField;
begin
 result:= FDataLinkField;
end;

destructor TPrismDBImage.Destroy;
begin
 FreeAndNil(FDataLinkField);

 inherited;
end;

function TPrismDBImage.GetEnableComponentState: Boolean;
begin
 Result:= true;
end;

function TPrismDBImage.GetImageFolder: String;
begin
 result:= FImageFolder;
end;

function TPrismDBImage.ImageToSrc: string;
var
 vImagePath: string;
begin
 result:= '';

 vImagePath:= FStoredText;

 if vImagePath <> '' then
 begin
  if (pos('http://', vImagePath) > 0) or (pos('https://', vImagePath) > 0) then
  begin
   result:= vImagePath;
  end else
   result:= ConvertLocalToBase64(vImagePath);
 end;
end;

procedure TPrismDBImage.Initialize;
begin
 inherited;

 FStoredText:= FDataLinkField.FieldText;
end;

procedure TPrismDBImage.ProcessComponentState(
  const ComponentStateInfo: TJSONObject);
begin
 inherited;

end;

procedure TPrismDBImage.ProcessEventParameters(Event: IPrismControlEvent;
  Parameters: TStrings);
begin
  inherited;

end;

procedure TPrismDBImage.ProcessHTML;
begin
 inherited;

// BaseClass.HTML.Render.Body.Add('<img class="'+ CSSClasses +'" src="'+ FImage.ImageToSrc +'" style="'+HTMLStyle+'" '+HTMLExtras+'/>');

// NewText:= FDataLinkField.FieldText;

 HTMLControl := '<img';
 HTMLControl := HTMLControl + ' ' + HTMLCore;
 HTMLControl := HTMLControl + ' ' + 'src="'+ ImageToSrc +'"';
 HTMLControl := HTMLControl + '/>';
end;


procedure TPrismDBImage.SetImageFolder(AValue: String);
begin
 FImageFolder:= AValue;
end;

procedure TPrismDBImage.UpdateData;
begin
 if (Form.FormPageState = PageStateLoaded) and (not Form.ComponentsUpdating) then
 FRefreshData:= true;
end;

procedure TPrismDBImage.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
var
 NewText: string;
begin
 inherited;

 NewText:= FDataLinkField.FieldText(AForceUpdate);
 if (FStoredText <> NewText) or (AForceUpdate) then
 begin
  FStoredText:= NewText;
  ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").src = `'+ ImageToSrc +'`;')
 end;
end;

{$ELSE}
implementation
{$ENDIF}

end.
