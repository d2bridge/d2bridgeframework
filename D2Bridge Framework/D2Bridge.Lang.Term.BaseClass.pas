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

unit D2Bridge.Lang.Term.BaseClass;

interface

uses
  Classes, SysUtils, Generics.Collections,
  D2Bridge.Lang.Interfaces;


type
 ID2BridgeLang = D2Bridge.Lang.Interfaces.ID2BridgeLang;


type
 TD2BridgeTermClass = class of TD2BridgeTermBaseClass;
 TD2BridgeTermItem = class;

 TD2BridgeTermBaseClass = class(TInterfacedPersistent, ID2BridgeTerm)
  private
   FItems: TList<TD2BridgeTermItem>;
   FD2BridgeLang: ID2BridgeLang;
  public
   constructor Create(AID2BridgeLang: ID2BridgeLang); virtual;
   destructor Destroy; override;

   function Context: string; virtual;

   function Language: ID2BridgeLang; virtual;
 end;



 TD2BridgeTermItem = class(TInterfacedPersistent, ID2BridgeTermItem)
  private
   FD2BridgeTerm: ID2BridgeTerm;
   FContext: String;
   FD2BridgeLang: ID2BridgeLang;
  public
   constructor Create(AD2BridgeTerm: ID2BridgeTerm; AContext: String); virtual;
  published
   function D2BridgeTerm: ID2BridgeTerm;
   function Language: ID2BridgeLang;
   function Context: string;
 end;



implementation


{ TD2BridgeTermBaseClass }

function TD2BridgeTermBaseClass.Context: string;
begin
 result:= '';
end;

constructor TD2BridgeTermBaseClass.Create(AID2BridgeLang: ID2BridgeLang);
begin
 FD2BridgeLang:= AID2BridgeLang;
 FItems:= TList<TD2BridgeTermItem>.Create;
end;

destructor TD2BridgeTermBaseClass.Destroy;
begin
  FItems.Free;

  inherited;
end;


function TD2BridgeTermBaseClass.Language: ID2BridgeLang;
begin
 Result:= FD2BridgeLang;
end;

{ TD2BridgeTermItem }

function TD2BridgeTermItem.Context: string;
begin
 Result:= FContext;
end;

constructor TD2BridgeTermItem.Create(AD2BridgeTerm: ID2BridgeTerm; AContext: String);
begin
 inherited Create;

 FContext:= AContext;
 FD2BridgeTerm:= AD2BridgeTerm;
 (FD2BridgeTerm as TD2BridgeTermBaseClass).FItems.Add(self);
 FD2BridgeLang:= FD2BridgeTerm.Language;
end;

function TD2BridgeTermItem.D2BridgeTerm: ID2BridgeTerm;
begin
 Result:= FD2BridgeTerm;
end;

function TD2BridgeTermItem.Language: ID2BridgeLang;
begin
 Result:= FD2BridgeLang;
end;

end.
