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

unit D2Bridge.Item.Nested;

interface

uses
  Classes, SysUtils, Generics.Collections,
  Prism.Interfaces,
  D2Bridge.Item, D2Bridge.BaseClass, D2Bridge.Item.VCLObj, D2Bridge.Interfaces;

type
  TD2BridgeItemNested = class(TD2BridgeItem, ID2BridgeItemNested)
   //events
   procedure BeginReader;
   procedure EndReader;
  private
   FD2BridgeItem: TD2BridgeItem;
   FNestedFormName: String;
  public
   constructor Create(AOwner: TD2BridgeClass); override;
   destructor Destroy; override;

   procedure PreProcess; override;
   procedure Render; override;
   procedure RenderHTML; override;

   function GetNestedFormName: String;
   procedure SetNestedFormName(AD2BridgeFormName: String);

   property BaseClass;
   property NestedFormName: string read GetNestedFormName write SetNestedFormName;
  end;

implementation

{ TD2BridgeItemNested }

constructor TD2BridgeItemNested.Create(AOwner: TD2BridgeClass);
begin
 FD2BridgeItem:= Inherited Create(AOwner);

 FD2BridgeItem.OnBeginReader:= BeginReader;
 FD2BridgeItem.OnEndReader:= EndReader;
end;

destructor TD2BridgeItemNested.Destroy;
begin

  inherited;
end;

function TD2BridgeItemNested.GetNestedFormName: String;
begin
 Result:= FNestedFormName;
end;

procedure TD2BridgeItemNested.BeginReader;
begin

end;

procedure TD2BridgeItemNested.EndReader;
begin

end;

procedure TD2BridgeItemNested.PreProcess;
begin

end;

procedure TD2BridgeItemNested.Render;
begin
 if NestedFormName <> '' then
  BaseClass.HTML.Render.Body.Add('$prismnested('+AnsiUpperCase(NestedFormName)+')');
end;

procedure TD2BridgeItemNested.RenderHTML;
begin

end;

procedure TD2BridgeItemNested.SetNestedFormName(AD2BridgeFormName: String);
begin
 FNestedFormName:= AD2BridgeFormName;
end;

end.
