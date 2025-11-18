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

unit D2Bridge.Instance.Wrapper;

interface

uses
  Classes, SysUtils, Generics.Collections, RTTI,
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
{$IFDEF FMX}
  FMX.Forms,
{$ELSE}
  Forms,
{$ENDIF}
  D2Bridge, D2Bridge.Interfaces, D2Bridge.Types,
  Prism.Session, Prism.Interfaces;


type
 TD2BridgeInstanceWrapper = class(TComponent)
  private
   FID2BridgeInstance: ID2BridgeInstance;
   FComponent: TComponent;
  protected
    procedure BeforeDestruction; override;
  public
   constructor Create(AOwner: TComponent; AID2BridgeInstance: ID2BridgeInstance); reintroduce;
   destructor Destroy; override;
 end;

implementation

Uses
 D2Bridge.Instance;

{ TD2BridgeInstanceWrapper }

procedure TD2BridgeInstanceWrapper.BeforeDestruction;
begin
  inherited;

end;

constructor TD2BridgeInstanceWrapper.Create(AOwner: TComponent; AID2BridgeInstance: ID2BridgeInstance);
begin
 inherited Create(AOwner);
 FID2BridgeInstance:= AID2BridgeInstance;
 FComponent:= AOwner;
end;

destructor TD2BridgeInstanceWrapper.Destroy;
begin
 if FComponent is TDataModule then
  (FID2BridgeInstance as TD2BridgeInstance).RemoveInstance(TDataModule(FComponent))
 else
  if FComponent is TForm then
   (FID2BridgeInstance as TD2BridgeInstance).RemoveInstance(TForm(FComponent));

 FID2BridgeInstance:= nil;

 inherited;
end;

end.
