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

//{$I D2Bridge.inc}

unit Prism.Security.JWT.Laz;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

{$IFDEF FPC}


type
  TSHA256Context = record
    state: array[0..7] of DWord;
    count: QWord;
    buffer: array[0..63] of Byte;
  end;

procedure SHA256Init(var Context: TSHA256Context);
procedure SHA256Update(var Context: TSHA256Context; const Data; Len: LongWord);
procedure SHA256Final(var Context: TSHA256Context; var Digest: array of Byte);


implementation

const
  K256: array[0..63] of DWord = (
    $428a2f98, $71374491, $b5c0fbcf, $e9b5dba5, $3956c25b, $59f111f1, $923f82a4, $ab1c5ed5,
    $d807aa98, $12835b01, $243185be, $550c7dc3, $72be5d74, $80deb1fe, $9bdc06a7, $c19bf174,
    $e49b69c1, $efbe4786, $0fc19dc6, $240ca1cc, $2de92c6f, $4a7484aa, $5cb0a9dc, $76f988da,
    $983e5152, $a831c66d, $b00327c8, $bf597fc7, $c6e00bf3, $d5a79147, $06ca6351, $14292967,
    $27b70a85, $2e1b2138, $4d2c6dfc, $53380d13, $650a7354, $766a0abb, $81c2c92e, $92722c85,
    $a2bfe8a1, $a81a664b, $c24b8b70, $c76c51a3, $d192e819, $d6990624, $f40e3585, $106aa070,
    $19a4c116, $1e376c08, $2748774c, $34b0bcb5, $391c0cb3, $4ed8aa4a, $5b9cca4f, $682e6ff3,
    $748f82ee, $78a5636f, $84c87814, $8cc70208, $90befffa, $a4506ceb, $bef9a3f7, $c67178f2
  );

function ROTR(x, n: DWord): DWord; inline;
begin
  Result := (x shr n) or (x shl (32 - n));
end;

function Ch(x, y, z: DWord): DWord; inline;
begin
  Result := (x and y) xor ((not x) and z);
end;

function Maj(x, y, z: DWord): DWord; inline;
begin
  Result := (x and y) xor (x and z) xor (y and z);
end;

function Sigma0(x: DWord): DWord; inline;
begin
  Result := ROTR(x, 2) xor ROTR(x, 13) xor ROTR(x, 22);
end;

function Sigma1(x: DWord): DWord; inline;
begin
  Result := ROTR(x, 6) xor ROTR(x, 11) xor ROTR(x, 25);
end;

function Gamma0(x: DWord): DWord; inline;
begin
  Result := ROTR(x, 7) xor ROTR(x, 18) xor (x shr 3);
end;

function Gamma1(x: DWord): DWord; inline;
begin
  Result := ROTR(x, 17) xor ROTR(x, 19) xor (x shr 10);
end;

procedure SHA256Transform(var state: array of DWord; const block: array of Byte);
var
  w: array[0..63] of DWord;
  a, b, c, d, e, f, g, h, t1, t2: DWord;
  i: Integer;
begin
{$R-}
 try
  for i := 0 to 15 do
    w[i] := (block[i * 4] shl 24) or (block[i * 4 + 1] shl 16) or (block[i * 4 + 2] shl 8) or block[i * 4 + 3];
  for i := 16 to 63 do
    w[i] := Gamma1(w[i - 2]) + w[i - 7] + Gamma0(w[i - 15]) + w[i - 16];

  a := state[0]; b := state[1]; c := state[2]; d := state[3];
  e := state[4]; f := state[5]; g := state[6]; h := state[7];

  for i := 0 to 63 do
  begin
    t1 := h + Sigma1(e) + Ch(e, f, g) + K256[i] + w[i];
    t2 := Sigma0(a) + Maj(a, b, c);
    h := g; g := f; f := e;
    e := d + t1; d := c;
    c := b; b := a; a := t1 + t2;
  end;

  state[0] += a; state[1] += b; state[2] += c; state[3] += d;
  state[4] += e; state[5] += f; state[6] += g; state[7] += h;
 except
 end;
{$R+}
end;

procedure SHA256Init(var Context: TSHA256Context);
begin
  Context.state[0] := $6a09e667;
  Context.state[1] := $bb67ae85;
  Context.state[2] := $3c6ef372;
  Context.state[3] := $a54ff53a;
  Context.state[4] := $510e527f;
  Context.state[5] := $9b05688c;
  Context.state[6] := $1f83d9ab;
  Context.state[7] := $5be0cd19;
  Context.count := 0;
  FillChar(Context.buffer, SizeOf(Context.buffer), 0);
end;

procedure SHA256Update(var Context: TSHA256Context; const Data; Len: LongWord);
var
  i, idx, partLen: Integer;
  input: PByte;
begin
  input := @Data;
  idx := (Context.count shr 3) and 63;
  Context.count += QWord(Len) shl 3;
  partLen := 64 - idx;

  if Len >= partLen then
  begin
    Move(input^, Context.buffer[idx], partLen);
    SHA256Transform(Context.state, Context.buffer);
    i := partLen;
    while i + 63 < Len do
    begin
      SHA256Transform(Context.state, (input + i)^);
      Inc(i, 64);
    end;
    idx := 0;
  end
  else
    i := 0;

  Move((input + i)^, Context.buffer[idx], Len - i);
end;

procedure SHA256Final(var Context: TSHA256Context; var Digest: array of Byte);
var
  bits: array[0..7] of Byte;
  idx, padLen: Integer;
  pad: array[0..63] of Byte = (
    $80,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  );
  i: Integer;
begin
  for i := 0 to 7 do
    bits[7 - i] := (Context.count shr (i * 8)) and $FF;

  idx := (Context.count shr 3) and 63;
  if idx < 56 then padLen := 56 - idx else padLen := 120 - idx;
  SHA256Update(Context, pad, padLen);
  SHA256Update(Context, bits, 8);

  for i := 0 to 7 do
  begin
    Digest[i*4+0] := (Context.state[i] shr 24) and $FF;
    Digest[i*4+1] := (Context.state[i] shr 16) and $FF;
    Digest[i*4+2] := (Context.state[i] shr 8) and $FF;
    Digest[i*4+3] := Context.state[i] and $FF;
  end;
end;

{$ELSE}
implementation
{$ENDIF}

end.