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

unit D2Bridge.JSON.Util;

interface

uses
  Classes,
{$IFNDEF FPC}
  Rest.Utils,
  {$IFDEF HAS_UNIT_SYSTEM_NETENCODING}
  System.NetEncoding,
  {$ELSE}
  EncdDecd,
  {$ENDIF}
{$ELSE}
 base64,
{$ENDIF}
 SysUtils;


function Base64FromFile(const AFileName: string): string;
procedure Base64ToFile(const Base64, OutputFile: string);


implementation

function Base64FromFile(const AFileName: string): string;
var
  Input: TFileStream;
  Output: TStringStream;
{$IFDEF FPC}
  Encoder: TBase64EncodingStream;
{$ENDIF}
begin
  Result := '';
  if not FileExists(AFileName) then
    Exit;

  Input := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  Output := TStringStream.Create('');
  try
    {$IFDEF FPC}
    Encoder := TBase64EncodingStream.Create(Output);
    try
      Encoder.CopyFrom(Input, Input.Size);
      Encoder.Flush;
    finally
      Encoder.Free;
    end;
    {$ELSE}
    {$IFDEF HAS_UNIT_SYSTEM_NETENCODING}
    TNetEncoding.Base64.Encode(Input, Output);
    {$ELSE}
    EncodeStream(Input, Output);
    {$ENDIF}
    {$ENDIF}
    Result := Output.DataString;
  finally
    Input.Free;
    Output.Free;
  end;
end;



procedure Base64ToFile(const Base64, OutputFile: string);
var
  Output: TFileStream;
  Input: TStringStream;
{$IFDEF FPC}
  Decoder: TBase64DecodingStream;
{$ENDIF}
begin
  Input := TStringStream.Create(Base64);
  try
    if FileExists(OutputFile) then
     DeleteFile(OutputFile);

    Output := TFileStream.Create(OutputFile, fmCreate);
    try
      {$IFDEF FPC}
      Decoder := TBase64DecodingStream.Create(Input);
      try
        Output.CopyFrom(Decoder, Decoder.Size);
        Output.Position := 0;
      finally
        Decoder.Free;
      end;
      {$ELSE}
      Output.WriteBuffer(
        TNetEncoding.Base64.DecodeStringToBytes(Base64)[0],
        Length(TNetEncoding.Base64.DecodeStringToBytes(Base64))
      );
      {$ENDIF}
    finally
      Output.Free;
    end;
  finally
    Input.Free;
  end;
end;


end.