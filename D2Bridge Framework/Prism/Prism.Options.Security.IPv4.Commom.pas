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

unit Prism.Options.Security.IPv4.Commom;

interface

uses
  Classes, SysUtils, Generics.Collections,
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
{$IFDEF FMX}

{$ELSE}

{$ENDIF}
  Prism.Interfaces, Prism.Types;

type
 TPrismOptionSecurityIPv4 = class(TInterfacedPersistent, IPrismOptionSecurityIPv4)
  private

  protected
   FLock: TMultiReadExclusiveWriteSynchronizer;
   FItems: TList<string>;
  published

  public
   constructor Create; virtual;
   destructor Destroy; override;

   function IPToStr(IP: Cardinal): string;
   function StrToIP(const IPStr: string): Cardinal;
   function IsValidIP(const IPStr: string; const IsValidCDIR: boolean = true): Boolean;
   function IsValidCDIR(const CDIR: string): Boolean;
   function IPRangeFromCIDR(const CIDR: string): TStrings;

   procedure Clear;
   procedure Add(CIDR: string); overload;
   function Count: integer;
   function Delete(CIDR: string): Boolean;
   function Exist(CIDR: string): Boolean;
   function ExistIP(const IPStr: string): boolean;
   function Items: TList<string>;
   function AllIPS: TList<string>;
 end;

implementation

{ TPrismOptionSecurityIPv4 }

function TPrismOptionSecurityIPv4.IPRangeFromCIDR(const CIDR: string): TStrings;
var
  IP, StartIP, EndIP: Cardinal;
  MaskBits, IPCount, I: Integer;
  IPStr, Network, Mask: string;
begin
  Result := TStringList.Create;
  try
    // Dividir CIDR em IP e Máscara
    if Pos('/', CIDR) = 0 then
      Exit; // Formato CIDR inválido

    Network := CIDR.Substring(0, CIDR.IndexOf('/'));
    Mask := CIDR.Substring(CIDR.IndexOf('/') + 1);

    IP := StrToIP(Network);
    MaskBits := StrToInt(Mask);

    if (MaskBits < 0) or (MaskBits > 32) then
      Exit; // Máscara inválida

    // Calcular intervalo de IPs
    StartIP := IP and (not ((1 shl (32 - MaskBits)) - 1));
    EndIP := StartIP or ((1 shl (32 - MaskBits)) - 1);

    // Gerar a lista de IPs
    IPCount := EndIP - StartIP + 1;
    for I := 0 to IPCount - 1 do
    begin
      IPStr := IPToStr(StartIP + I);

      // Ignorar IPs com final .0 ou .255
      if (StartIP + I) and $FF = 0 then
        Continue; // Ignora IP com final .0
      if (StartIP + I) and $FF = 255 then
        Continue; // Ignora IP com final .255

      Result.Add(IPStr);
    end;
  except
  end;
end;


function TPrismOptionSecurityIPv4.IPToStr(IP: Cardinal): string;
begin
 Result := Format('%d.%d.%d.%d', [(IP shr 24) and $FF, (IP shr 16) and $FF, (IP shr 8) and $FF, IP and $FF]);
end;

function TPrismOptionSecurityIPv4.IsValidCDIR(const CDIR: string): Boolean;
begin
 result:= false;

 if Pos('/', CDIR) > 0 then
  Result:= IsValidIP(CDIR);
end;

function TPrismOptionSecurityIPv4.IsValidIP(const IPStr: string; const IsValidCDIR: boolean = true): Boolean;
var
  Parts: TArray<string>;
  I, Value, MaskBits: Integer;
begin
  Result := False;

  if (Pos('/', IPStr) > 0) then
  begin
    if not IsValidCDIR then
     Exit;

    Parts := IPStr.Split(['/']);
    if Length(Parts) <> 2 then
      Exit;

    if not IsValidIP(Parts[0], false) then
      Exit;

    if not TryStrToInt(Parts[1], MaskBits) then
      Exit;

    if (MaskBits < 0) or (MaskBits > 32) then
      Exit;

    Result := True;
  end else
  begin
   Parts := IPStr.Split(['.']);
   if Length(Parts) = 4 then
   begin
     for I := 0 to High(Parts) do
     begin
       if not TryStrToInt(Parts[I], Value) then
         Exit;
       if (Value < 0) or (Value > 255) then
         Exit;
     end;
     Result := True;
     Exit;
   end;
  end;

end;

function TPrismOptionSecurityIPv4.StrToIP(const IPStr: string): Cardinal;
var
  Parts: TArray<string>;
  I, Value: Integer;
begin
 result:= 0;

 Parts := IPStr.Split(['.']);
 if Length(Parts) <> 4 then
 begin
  //raise Exception.CreateFmt('Invalid IP format: %s', [IPStr]);
  exit;
 end;

 for I := 0 to High(Parts) do
 begin
  if not TryStrToInt(Parts[I], Value) then
  begin
   //raise Exception.CreateFmt('Invalid IP part: %s', [Parts[I]]);
   exit;
  end;
  if (Value < 0) or (Value > 255) then
  begin
   //raise Exception.CreateFmt('IP part out of range (0-255): %d', [Value]);
   exit;
  end;
  Result := (Result shl 8) or Value;
 end;
end;

procedure TPrismOptionSecurityIPv4.Add(CIDR: string);
begin
 if not IsValidCDIR(CIDR) then
  CIDR:= Trim(CIDR) + '/32';

 if not IsValidCDIR(CIDR) then
  Exit;

 FLock.BeginWrite;

 FItems.Add(CIDR);

 FLock.EndWrite;
end;

function TPrismOptionSecurityIPv4.AllIPS: TList<string>;
var
 I: integer;
 vIPs: TStrings;
begin
 FLock.BeginRead;

 Result:= TList<string>.Create;

 for I := 0 to Pred(FItems.Count) do
 begin
  if IsValidCDIR(FItems[I]) then
  begin
   vIPs:= IPRangeFromCIDR(FItems[I]);
   Result.AddRange(vIPs.ToStringArray);
   vIPs.Free;
  end;
 end;

 FLock.EndRead;
end;

procedure TPrismOptionSecurityIPv4.Clear;
begin
 FLock.BeginWrite;

 FItems.Clear;

 FLock.EndWrite;
end;

function TPrismOptionSecurityIPv4.Count: integer;
begin
 FLock.BeginRead;

 Result:= FItems.Count;

 FLock.EndRead;
end;

constructor TPrismOptionSecurityIPv4.Create;
begin
 inherited;

 FLock:= TMultiReadExclusiveWriteSynchronizer.Create;
 FItems:= TList<string>.Create;
end;

function TPrismOptionSecurityIPv4.Delete(CIDR: string): Boolean;
begin
 Result:= false;

 if not IsValidCDIR(CIDR) then
  CIDR:= Trim(CIDR) + '/32';

 if not IsValidCDIR(CIDR) then
  Exit;

 FLock.BeginWrite;

 if FItems.Contains(CIDR) then
 begin
  FItems.Remove(CIDR);
  Result:= true;
 end;

 FLock.EndWrite;
end;

destructor TPrismOptionSecurityIPv4.Destroy;
begin
 FLock.Free;
 FItems.Free;

 inherited;
end;

function TPrismOptionSecurityIPv4.Exist(CIDR: string): Boolean;
begin
 result:= false;

 if not IsValidCDIR(CIDR) then
  CIDR:= Trim(CIDR) + '/32';

 if not IsValidCDIR(CIDR) then
  Exit;

 FLock.BeginRead;

 Result:= FItems.Contains(CIDR);

 FLock.EndRead;
end;

function TPrismOptionSecurityIPv4.ExistIP(const IPStr: string): Boolean;
var
  TargetIP, StartIP, EndIP, NetworkIP: Cardinal;
  MaskBits: Integer;
  vCIDR, Network, Mask: string;
begin
  Result := False;

  // Converter o IP de entrada para formato binário
  TargetIP := StrToIP(IPStr);

  FLock.BeginRead;
  try
    for vCIDR in FItems do
    begin
      if Pos('/', vCIDR) = 0 then
        Continue;

      // Dividir CIDR em Rede e Máscara
      Network := vCIDR.Substring(0, vCIDR.IndexOf('/'));
      Mask := vCIDR.Substring(vCIDR.IndexOf('/') + 1);

      NetworkIP := StrToIP(Network);
      MaskBits := StrToInt(Mask);

      if (MaskBits < 0) or (MaskBits > 32) then
        Continue; // Máscara inválida

      // Calcular o intervalo CIDR
      StartIP := NetworkIP and (not ((1 shl (32 - MaskBits)) - 1));
      EndIP := StartIP or ((1 shl (32 - MaskBits)) - 1);

      // Verificar se o IP está no intervalo
      if (TargetIP >= StartIP) and (TargetIP <= EndIP) then
      begin
        Result := True;
        Break;
      end;
    end;
  finally
    FLock.EndRead;
  end;
end;


function TPrismOptionSecurityIPv4.Items: TList<string>;
begin
 FLock.BeginRead;

 Result:= TList<string>.Create;

 Result.AddRange(FItems);

 FLock.EndRead;
end;

end.