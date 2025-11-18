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

{$IFNDEF FPC}
{$R 'prism.res' 'prism.rc'}
{$ENDIF}

unit Prism.SessionBase;

interface

uses
  SysUtils, Classes,
{$IFNDEF FPC}

{$ELSE}
  LResources,
{$ENDIF}
  D2Bridge.BaseClass,
  Prism.Session;

type
 TPrismSession = Prism.Session.TPrismSession;

type
  TPrismSessionBase = class(TDataModule)
  private
   FPrismSession: TPrismSession;
   function GetPrismSession: TPrismSession;
  protected
   procedure DoDestroy; override;

  public
   constructor Create(APrismSession: TPrismSession); reintroduce; virtual;
   destructor Destroy; override;

  published
   function D2Bridge: TD2BridgeClass;
   property Session: TPrismSession read GetPrismSession;
  end;


implementation

{$IFNDEF FPC}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

{ TPrismSessionBase }


function TPrismSessionBase.D2Bridge: TD2BridgeClass;
begin
 if Assigned(FPrismSession.D2BridgeBaseClassActive) then
  result:= TD2BridgeClass(FPrismSession.D2BridgeBaseClassActive);
end;

destructor TPrismSessionBase.Destroy;
begin

 inherited;
end;

procedure TPrismSessionBase.DoDestroy;
begin
// inherited;
 if Assigned(OnDestroy) then
 try
  OnDestroy(Self);
 except
 end;
end;

function TPrismSessionBase.GetPrismSession: TPrismSession;
begin
 Result:= FPrismSession;
end;

constructor TPrismSessionBase.Create(APrismSession: TPrismSession);
begin
 FPrismSession:= APrismSession;

 inherited Create(APrismSession);
end;

{$IFDEF FPC}
initialization
{$I prism.lrs}
{$ENDIF}

end.