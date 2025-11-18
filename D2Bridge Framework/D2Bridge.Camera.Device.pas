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
}

{$I D2Bridge.inc}

unit D2Bridge.Camera.Device;

interface

Uses
 Classes, SysUtils, Generics.Collections,
{$IFnDEF FPC}
 {$IFnDEF FMX}
 ExtCtrls,
 {$ELSE}
 FMX.ExtCtrls,
 {$ENDIF}
{$ELSE}
 ExtCtrls,
{$ENDIF}
 D2Bridge.Interfaces,
 Prism.Types;

type

 { TD2BridgeCameraDevice }

 TD2BridgeCameraDevice = class(TInterfacedPersistent, ID2BridgeCameraDevice)
  private
   Fid: string;
   FIndex: Integer;
   FName: string;
   function Getid: string;
   function GetIndex: Integer;
   function GetName: string;
   procedure Setid(const Value: string);
   procedure SetIndex(const Value: Integer);
   procedure SetName(const Value: string);
  public
   constructor Create;
   destructor Destroy; override;

   property id: string read Getid write Setid;
   property Index: Integer read GetIndex write SetIndex;
   property Name: string read GetName write SetName;

   function this: ID2BridgeCameraDevice;
 end;

implementation

{ TD2BridgeCameraDevice }

function TD2BridgeCameraDevice .Getid: string;
begin
 result:= FID;
end;

function TD2BridgeCameraDevice .GetIndex: Integer;
begin
 result:= FIndex;
end;

function TD2BridgeCameraDevice .GetName: string;
begin
 result:= FName;
end;

procedure TD2BridgeCameraDevice .Setid(const Value: string);
begin
 FID:= Value;
end;

procedure TD2BridgeCameraDevice .SetIndex(const Value: Integer);
begin
 FIndex:= Value;
end;

procedure TD2BridgeCameraDevice .SetName(const Value: string);
begin
 FName:= Value;
end;

constructor TD2BridgeCameraDevice.Create;
begin
 inherited;
end;

destructor TD2BridgeCameraDevice.Destroy;
begin
 inherited;
end;

function TD2BridgeCameraDevice.this: ID2BridgeCameraDevice;
begin
 result:= self;
end;

end.
