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


