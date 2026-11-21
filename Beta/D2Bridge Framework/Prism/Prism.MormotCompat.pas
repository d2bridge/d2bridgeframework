{
 +--------------------------------------------------------------------------+
  D2Bridge Framework Content

  Author: Talis Jonatas Gomes
  Email: talisjonatas@me.com

  This source code is distributed under the terms of the
  GNU Lesser General Public License (LGPL) version 2.1.

  This library is free software; you can redistribute it and/or modify ...

  God bless you
 +--------------------------------------------------------------------------+

  Unit: Prism.MormotCompat.pas
  Purpose: Compatibility layer for migrating from Indy to mORMot2.
           Provides type aliases, helper functions, and shims.
}

{$I ..\D2Bridge.inc}

unit Prism.MormotCompat;

interface

uses
  Classes, SysUtils
  {$IFDEF USE_MORMOT2}
  , mormot.core.base
  , mormot.core.os
  , mormot.core.buffers
  , mormot.core.text
  , mormot.core.unicode
  , mormot.net.sock
  , mormot.net.http
  , mormot.net.server
  , mormot.net.ws.core
  , mormot.net.ws.server
  {$ELSE}
  , IdGlobal
  {$ENDIF}
  ;

{$IFDEF USE_MORMOT2}

{ ------------------------------------------------------------------ }
{ Type aliases                                                        }
{ ------------------------------------------------------------------ }

type
  // UTF-8 string: Indy's IndyTextEncoding_UTF8 maps to RawUTF8
  TMormotUTF8 = RawUTF8;

  // Raw bytes: Indy's TIdBytes maps to TBytes (TByteDynArray)
  TMormotBytes = TBytes;

  // HTTP Request abstraction (maps to THttpServerRequestAbstract)
  TMormotHttpRequest = THttpServerRequestAbstract;

  // HTTP Server reference
  TMormotHttpServer = THttpServer;

  // Connection identifier (maps to THttpServerConnectionID = Int64)
  TMormotConnectionID = THttpServerConnectionID;

{ ------------------------------------------------------------------ }
{ Socket I/O abstraction for WebSocket frames                         }
{ ------------------------------------------------------------------ }

type
  // Lightweight wrapper around a TCrtSocket for raw I/O.
  // Replaces TIdIOHandler for WebSocket frame reading/writing.
  TMormotSocketIO = class
  private
    FSock: TCrtSocket;
  public
    constructor CreateFromCrtSocket(aSock: TCrtSocket);
    function ReadBytes: TBytes;
    function ReadString: RawUTF8;
    procedure WriteBytes(const Data: TBytes);
    procedure WriteString(const Str: RawUTF8);
    function Connected: boolean;
    procedure Disconnect;
    property Sock: TCrtSocket read FSock;
  end;

{ ------------------------------------------------------------------ }
{ TLS configuration                                                   }
{ ------------------------------------------------------------------ }

type
  // TLS context replacing TIdServerIOHandlerSSLOpenSSL + TIdSSLOptions.
  TMormotTlsConfig = record
    Enabled: boolean;
    CertificateFile: RawUTF8;
    PrivateKeyFile: RawUTF8;
    PrivateKeyPassword: RawUTF8;
    CACertificatesFile: RawUTF8;
    // Indy-compatible aliases
    CertFile: RawUTF8;
    KeyFile: RawUTF8;
    IgnoreCertificateErrors  : boolean;
    RootCertFile: RawUTF8;
  end;

{ ------------------------------------------------------------------ }
{ URL parsing                                                         }
{ ------------------------------------------------------------------ }

  // Extracts query string from a URL and returns the path-only part.
  function ExtractQueryParams(const FullPath: RawUTF8; out AQueryParams: RawUTF8): RawUTF8;

  // URL-decodes a string. Replaces TIdURI.URLDecode.
  function UrlDecodeStr(const S: RawUTF8): RawUTF8;

{ ------------------------------------------------------------------ }
{ MIME type lookup                                                    }
{ ------------------------------------------------------------------ }

  function MormotMimeTypeFromExt(const AExtension: RawUTF8): RawUTF8;

{$ENDIF} // USE_MORMOT2

implementation

{$IFDEF USE_MORMOT2}

{ TMormotSocketIO }

constructor TMormotSocketIO.CreateFromCrtSocket(aSock: TCrtSocket);
begin
  inherited Create;
  FSock := aSock;
end;

function TMormotSocketIO.ReadBytes: TBytes;
var
  Len: integer;
  Buf: array[0..65535] of byte;
begin
  Result := nil;
  if (FSock = nil) or not FSock.SockConnected then
    Exit;
  Len := FSock.SockInRead(@Buf, SizeOf(Buf), {UseOnlySockIn=}true);
  if Len <= 0 then
    Exit;
  SetLength(Result, Len);
  Move(Buf, Result[0], Len);
end;

function TMormotSocketIO.ReadString: RawUTF8;
var
  Bytes: TBytes;
begin
  Bytes := ReadBytes;
  if Bytes <> nil then
    SetString(Result, PAnsiChar(Bytes), Length(Bytes))
  else
    Result := '';
end;

procedure TMormotSocketIO.WriteBytes(const Data: TBytes);
begin
  if (FSock = nil) or (Data = nil) then
    Exit;
  FSock.SndLow(pointer(Data), Length(Data));
end;

procedure TMormotSocketIO.WriteString(const Str: RawUTF8);
begin
  if (FSock = nil) or (Str = '') then
    Exit;
  FSock.SndLow(pointer(Str), Length(Str));
end;

function TMormotSocketIO.Connected: boolean;
begin
  Result := Assigned(FSock) and FSock.SockConnected;
end;

procedure TMormotSocketIO.Disconnect;
begin
  if Assigned(FSock) then
  begin
    FSock.Close;
    FSock := nil;
  end;
end;

{ URL parsing }

function ExtractQueryParams(const FullPath: RawUTF8; out AQueryParams: RawUTF8): RawUTF8;
var
  QPos: integer;
begin
  QPos := PosEx('?', FullPath);
  if QPos > 0 then
  begin
    Result := copy(FullPath, 1, QPos - 1);
    AQueryParams := copy(FullPath, QPos + 1, MaxInt);
  end
  else
  begin
    Result := FullPath;
    AQueryParams := '';
  end;
end;

function UrlDecodeStr(const S: RawUTF8): RawUTF8;
begin
  Result := UrlDecode(S);
end;

{ MIME types }

function MormotMimeTypeFromExt(const AExtension: RawUTF8): RawUTF8;
const
  MIME_MAP: array[0..24] of record Ext: RawUTF8; Mime: RawUTF8; end = (
    (Ext: 'css';   Mime: 'text/css'),
    (Ext: 'js';    Mime: 'text/javascript'),
    (Ext: 'png';   Mime: 'image/png'),
    (Ext: 'txt';   Mime: 'text/html'),
    (Ext: 'html';  Mime: 'text/html'),
    (Ext: 'htm';   Mime: 'text/html'),
    (Ext: 'jpg';   Mime: 'image/jpeg'),
    (Ext: 'jpeg';  Mime: 'image/jpeg'),
    (Ext: 'jpe';   Mime: 'image/jpeg'),
    (Ext: 'gif';   Mime: 'image/gif'),
    (Ext: 'woff';  Mime: 'application/font-woff'),
    (Ext: 'svgz';  Mime: 'image/svg+xml'),
    (Ext: 'svg';   Mime: 'image/svg+xml'),
    (Ext: 'woff2'; Mime: 'application/font-woff2'),
    (Ext: 'pdf';   Mime: 'application/pdf'),
    (Ext: 'bmp';   Mime: 'image/bmp'),
    (Ext: 'ico';   Mime: 'image/vnd.microsoft.icon'),
    (Ext: 'mp3';   Mime: 'audio/mpeg'),
    (Ext: 'wav';   Mime: 'audio/wav'),
    (Ext: 'mp4';   Mime: 'video/mp4'),
    (Ext: 'mjs';   Mime: 'application/javascript'),
    (Ext: 'zip';   Mime: 'application/zip'),
    (Ext: 'webp';  Mime: 'image/webp'),
    (Ext: 'json';  Mime: 'application/json'),
    (Ext: 'ttf';   Mime: 'font/ttf')
  );
var
  i: integer;
  LowExt: RawUTF8;
begin
  Result := 'application/octet-stream';
  if AExtension = '' then
    Exit;
  LowExt := LowerCase(AExtension);
  for i := 0 to High(MIME_MAP) do
    if MIME_MAP[i].Ext = LowExt then
    begin
      Result := MIME_MAP[i].Mime;
      Exit;
    end;
end;

{$ENDIF} // USE_MORMOT2

end.
