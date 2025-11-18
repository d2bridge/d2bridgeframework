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

unit Prism.URI;

interface

uses
  Classes, Generics.Collections, SysUtils,
  Prism.Interfaces;


type
 TPrismURLQueryParams = class;

 TPrismURI = class(TInterfacedPersistent, IPrismURI)
  private
   FRaw: String;
   FURL: string;
   FHost: string;
   FServerPort: integer;
   FProtocol: string;
   FQueryParams: IPrismURLQueryParams;
   function GetRaw: string;
   function GetURL: string;
   function GetHost: string;
   function GetServerPort: integer;
   function GetProtocol: string;
   procedure SetRaw(AValue: string);
   procedure SetURL(AValue: string);
   procedure SetHost(AValue: string);
   procedure SetServerPort(AValue: integer);
   procedure SetProtocol(AValue: string);
  public
   constructor Create;
   destructor Destroy; override;

   function QueryParams: IPrismURLQueryParams;
   procedure ClearQueryParams;

   property Raw: string read GetRaw write SetRaw;
   property URL: string read GetURL write SetURL;
   property Host: string read GetHost write SetHost;
   property ServerPort: integer read GetServerPort write SetServerPort;
   property Protocol: string read GetProtocol write SetProtocol;
 end;



 TPrismURLQueryParam = class(TInterfacedPersistent, IPrismURLQueryParam)
  private
   FKey: String;
   FValue: String;
   function GetKey: string;
   function GetValue: string;
   procedure SetKey(AValue: String);
   procedure SetValue(AValue: String);
  public
   property Key: string read GetKey write SetKey;
   property Value: string read GetValue write SetValue;
 end;



 TPrismURLQueryParams = class(TInterfacedPersistent, IPrismURLQueryParams)
  private
   FItems: TList<IPrismURLQueryParam>;
  public
   constructor Create;
   destructor Destroy; override;

   function Add: IPrismURLQueryParam;
   function Count: Integer;
   procedure Clear;
   procedure Update(AQueryParams: TStrings);

   function Items: TList<IPrismURLQueryParam>;
   function Exist(AKeyName: string): Boolean;
   function ValueFromKey(AKeyName: string): string;
 end;



implementation


{ TPrismURI }

procedure TPrismURI.ClearQueryParams;
begin
 QueryParams.Clear;
end;

constructor TPrismURI.Create;
begin
 FQueryParams:= TPrismURLQueryParams.Create;
end;

destructor TPrismURI.Destroy;
var
 vQueryParams: TPrismURLQueryParams;
begin
 vQueryParams:= FQueryParams as TPrismURLQueryParams;
 FQueryParams:= nil;
 vQueryParams.Free;
 inherited;
end;

function TPrismURI.GetHost: string;
begin
 Result:= FHost;
end;

function TPrismURI.GetProtocol: string;
begin
 Result:= FProtocol;
end;

function TPrismURI.GetRaw: string;
begin
 Result:= FRaw;
end;

function TPrismURI.GetServerPort: integer;
begin
 Result:= FServerPort;
end;

function TPrismURI.GetURL: string;
begin
 Result:= FURL;
end;

function TPrismURI.QueryParams: IPrismURLQueryParams;
begin
 Result:= FQueryParams;
end;

procedure TPrismURI.SetHost(AValue: string);
begin
 FHost:= AValue;
end;

procedure TPrismURI.SetProtocol(AValue: string);
begin
 FProtocol:= AValue;
end;

procedure TPrismURI.SetRaw(AValue: string);
begin
 FRaw:= AValue;
end;

procedure TPrismURI.SetServerPort(AValue: integer);
begin
 FServerPort:= AValue;
end;

procedure TPrismURI.SetURL(AValue: string);
begin
 FURL:= AValue;
end;



{ TPrismURLQueryParams }

function TPrismURLQueryParams.Add: IPrismURLQueryParam;
begin
 Result:= TPrismURLQueryParam.Create;
 Items.Add(Result);
end;

procedure TPrismURLQueryParams.Clear;
var
 vURLQueryParamIntf: IPrismURLQueryParam;
 vURLQueryParam: TPrismURLQueryParam;
begin
 while FItems.Count > 0 do
 begin
  vURLQueryParamIntf:= FItems.Last;
  FItems.Delete(Pred(FItems.Count));

  try
   vURLQueryParam:= vURLQueryParamIntf as TPrismURLQueryParam;
   vURLQueryParamIntf:= nil;
   vURLQueryParam.Free;
  except
  end;
 end;

 FItems.Clear;
end;

function TPrismURLQueryParams.Count: Integer;
begin
 Result:= Items.Count;
end;

constructor TPrismURLQueryParams.Create;
begin
 FItems:= TList<IPrismURLQueryParam>.Create;
end;

destructor TPrismURLQueryParams.Destroy;
begin
 Clear;
 FreeAndNil(FItems);

 inherited;
end;

function TPrismURLQueryParams.Exist(AKeyName: string): Boolean;
var
 I: integer;
begin
 Result:= false;

 for I := 0 to Pred(Items.Count) do
 begin
  if SameText(Items.Items[I].Key, AKeyName) then
  begin
   Result:= true;
   break;
  end;
 end;

end;

function TPrismURLQueryParams.Items: TList<IPrismURLQueryParam>;
begin
 Result:= FItems;
end;

procedure TPrismURLQueryParams.Update(AQueryParams: TStrings);
var
 I: integer;
begin
 Clear;

 for I := 0 to Pred(AQueryParams.Count) do
 with Add do
 begin
  Key:= AQueryParams.Names[I];
  Value:= AQueryParams.ValueFromIndex[I];
 end;
end;

function TPrismURLQueryParams.ValueFromKey(AKeyName: string): string;
var
 I: integer;
begin
 result:= '';

 for I := 0 to Pred(Items.Count) do
 begin
  if SameText(Items.Items[I].Key, AKeyName) then
  begin
   Result:= Items.Items[I].Value;
   break;
  end;
 end;
end;


{ TPrismURLQueryParam }

function TPrismURLQueryParam.GetKey: string;
begin
 Result:= FKey;
end;

function TPrismURLQueryParam.GetValue: string;
begin
 Result:= FValue;
end;

procedure TPrismURLQueryParam.SetKey(AValue: String);
begin
 FKey:= AValue;
end;

procedure TPrismURLQueryParam.SetValue(AValue: String);
begin
 FValue:= AValue;
end;

end.
