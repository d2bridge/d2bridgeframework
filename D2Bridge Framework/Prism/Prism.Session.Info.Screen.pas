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

{$I ..\D2Bridge.inc}

unit Prism.Session.Info.Screen;

interface

uses
  Classes, SysUtils, D2Bridge.JSON,
  Prism.Types, Prism.Interfaces;

type
 TPrismSessionInfoScreen = class(TInterfacedPersistent, IPrismSessionInfoScreen)
  private
   FHeight: Integer;
   FOrientation: TPrismScreenOrientation;
   FWidth: Integer;
   function GetHeight: Integer;
   function GetOrientation: TPrismScreenOrientation;
   function GetWidth: Integer;
   procedure SetHeight(const Value: Integer);
   procedure SetOrientation(const Value: TPrismScreenOrientation);
   procedure SetWidth(const Value: Integer);

  public
   constructor Create;

   procedure ProcessScreenInfo(AScreenInfo: string);

   property Height: Integer read GetHeight write SetHeight;
   property Orientation: TPrismScreenOrientation read GetOrientation write SetOrientation;
   property Width: Integer read GetWidth write SetWidth;

 end;

implementation

constructor TPrismSessionInfoScreen.Create;
begin
 inherited;

 FOrientation:= PrismScreenUnknown;
end;

function TPrismSessionInfoScreen.GetHeight: Integer;
begin
 Result := FHeight;
end;

function TPrismSessionInfoScreen.GetOrientation: TPrismScreenOrientation;
begin
 Result := FOrientation;
end;

function TPrismSessionInfoScreen.GetWidth: Integer;
begin
 Result := FWidth;
end;

procedure TPrismSessionInfoScreen.ProcessScreenInfo(AScreenInfo: string);
var
 vJSONViewportinfo: TJSONObject;
begin
 if AScreenInfo <> '' then
 begin
  try
   vJSONViewportinfo:= TJSONObject.ParseJSONValue(AScreenInfo) as TJSONObject;

   Width:= vJSONViewportinfo.GetValue('width', 0);
   Height:= vJSONViewportinfo.GetValue('height', 0);

   if vJSONViewportinfo.GetValue('orientation', 'unknown') = 'portrait' then
    Orientation:= PrismScreenPortrait
   else
    if vJSONViewportinfo.GetValue('orientation', 'unknown') = 'landscape' then
     Orientation:= PrismScreenLandscape
    else
      Orientation:= PrismScreenUnknown;

   vJSONViewportinfo.Free;
  except
  end;
 end;
end;

procedure TPrismSessionInfoScreen.SetHeight(const Value: Integer);
begin
 FHeight := Value;
end;

procedure TPrismSessionInfoScreen.SetOrientation(const Value:
    TPrismScreenOrientation);
begin
 FOrientation := Value;
end;

procedure TPrismSessionInfoScreen.SetWidth(const Value: Integer);
begin
 FWidth := Value;
end;

end.
