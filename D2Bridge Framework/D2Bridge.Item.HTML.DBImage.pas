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

unit D2Bridge.Item.HTML.DBImage;

interface

{$IFNDEF FMX}

uses
  Classes, Generics.Collections,
  D2Bridge.Interfaces, D2Bridge.Image, D2Bridge.Item, D2Bridge.BaseClass,
  DB, Prism.DBImage;

type
  TD2BridgeItemHTMLDBImage = class(TD2BridgeItem, ID2BridgeItemHTMLDBImage)
   //events
   procedure BeginReader;
   procedure EndReader;
  private
   procedure SetDataSource(const Value: TDataSource);
   function GetDataSource: TDataSource;
   procedure SetDataFieldImagePath(AValue: String);
   function GetDataFieldImagePath: String;
  public
   constructor Create(AOwner: TD2BridgeClass); override;
   destructor Destroy; override;

   //Functions
   procedure PreProcess; override;
   procedure Render; override;
   procedure RenderHTML; override;

   function PrismControl: TPrismDBImage; reintroduce;

   property BaseClass;
   property DataSource: TDataSource read GetDataSource write SetDataSource;
   property DataFieldImagePath: String read GetDataFieldImagePath write SetDataFieldImagePath;
  end;


implementation

uses
  Prism.Forms.Controls,
  D2Bridge.Util;

{ TD2BridgeItemHTMLDBImage }

constructor TD2BridgeItemHTMLDBImage.Create(AOwner: TD2BridgeClass);
begin
 Inherited;

 OnBeginReader:= BeginReader;
 OnEndReader:= EndReader;

 FPrismControl := TPrismDBImage.Create(BaseClass.PrismSession);
 AOwner.PrismControlToRegister.Add(FPrismControl);
end;


destructor TD2BridgeItemHTMLDBImage.Destroy;
var
 vPrismControl: TPrismControl;
begin
 try
  if Assigned(FPrismControl) then
   if not Assigned(FPrismControl.Form) then
   begin
    vPrismControl:= (FPrismControl as TPrismControl);
    FPrismControl:= nil;
    vPrismControl.Free;
   end;
 except
 end;

 inherited;
end;

procedure TD2BridgeItemHTMLDBImage.BeginReader;
begin
end;

procedure TD2BridgeItemHTMLDBImage.EndReader;
begin
end;


function TD2BridgeItemHTMLDBImage.GetDataFieldImagePath: String;
begin
 Result:= PrismControl.DataWare.FieldName;
end;

function TD2BridgeItemHTMLDBImage.GetDataSource: TDataSource;
begin
 Result:= PrismControl.DataWare.DataSource;
end;

procedure TD2BridgeItemHTMLDBImage.PreProcess;
begin

end;

function TD2BridgeItemHTMLDBImage.PrismControl: TPrismDBImage;
begin
 Result:= FPrismControl as TPrismDBImage;
end;

procedure TD2BridgeItemHTMLDBImage.Render;
var
 vCSSClass: string;
begin
 vCSSClass:= CSSClasses;

 if vCSSClass = '' then
  vCSSClass:= 'rounded img-fluid';

 BaseClass.HTML.Render.Body.Add('{%'+TrataHTMLTag(ItemPrefixID+' class="'+ vCSSClass +'" style="'+GetHTMLStyle+'" '+GetHTMLExtras) + '%}');
end;

procedure TD2BridgeItemHTMLDBImage.RenderHTML;
begin

end;

procedure TD2BridgeItemHTMLDBImage.SetDataFieldImagePath(AValue: String);
begin
 PrismControl.DataWare.FieldName:= AValue;
end;

procedure TD2BridgeItemHTMLDBImage.SetDataSource(const Value: TDataSource);
begin
 PrismControl.DataWare.DataSource:= Value;
end;

{$ELSE}
implementation
{$ENDIF}

end.

