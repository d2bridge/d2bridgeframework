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

unit D2Bridge.API.Mail.Adresses;

interface

uses
  Classes, Generics.Collections, SysUtils,
  D2Bridge.Interfaces
  {$IFDEF FMX}

  {$ELSE}

  {$ENDIF}
  ;


type
 TD2BridgeAPIMailAddress = class(TInterfacedPersistent, ID2BridgeAPIMailAddress)
  private
    FMailAddress: string;
    FName: string;
    function GetMailAddress: string;
    function GetName: string;
    procedure SetMailAddress(const Value: string);
    procedure SetName(const Value: string);
  public
   function IsValidMailAddress: boolean;

   property Name: string read GetName write SetName;
   property MailAddress: string read GetMailAddress write SetMailAddress;
 end;


 TD2BridgeAPIMailAdresses = class(TInterfacedPersistent, ID2BridgeAPIMailAdresses)
  private
   FAdresses: TList<ID2BridgeAPIMailAddress>;
   function GetAdresses: TList<ID2BridgeAPIMailAddress>;
  public
   constructor Create;
   destructor Destroy; override;

   Procedure Clear;
   function Add: ID2BridgeAPIMailAddress; overload;
   procedure Add(Address: ID2BridgeAPIMailAddress); overload;

   property Items: TList<ID2BridgeAPIMailAddress> read GetAdresses;
 end;


implementation

uses
  D2Bridge.API.Mail;


{ TD2BridgeAPIMailAddress }

function TD2BridgeAPIMailAddress.GetMailAddress: string;
begin
 Result:= FMailAddress;
end;

function TD2BridgeAPIMailAddress.GetName: string;
begin
 Result:= FName;
end;

function TD2BridgeAPIMailAddress.IsValidMailAddress: boolean;
begin
 Result:= D2Bridge.API.Mail.TD2BridgeAPIMail.IsValidMailAddress(FMailAddress);
end;

procedure TD2BridgeAPIMailAddress.SetMailAddress(const Value: string);
begin
 FMailAddress:= Value;
end;

procedure TD2BridgeAPIMailAddress.SetName(const Value: string);
begin
 FName:= Value;
end;

{ TD2BridgeAPIMailAdresses }

function TD2BridgeAPIMailAdresses.Add: ID2BridgeAPIMailAddress;
begin
 Result:= TD2BridgeAPIMailAddress.Create;
 FAdresses.Add(Result);
end;

procedure TD2BridgeAPIMailAdresses.Add(Address: ID2BridgeAPIMailAddress);
begin
 FAdresses.Add(Address);
end;

procedure TD2BridgeAPIMailAdresses.Clear;
begin
 FAdresses.Clear;
end;

constructor TD2BridgeAPIMailAdresses.Create;
begin
 inherited;

 FAdresses:= TList<ID2BridgeAPIMailAddress>.Create;
end;

destructor TD2BridgeAPIMailAdresses.Destroy;
begin
 FreeAndNil(FAdresses);

 inherited;
end;

function TD2BridgeAPIMailAdresses.GetAdresses: TList<ID2BridgeAPIMailAddress>;
begin
 Result:= FAdresses;
end;

end.
