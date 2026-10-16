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