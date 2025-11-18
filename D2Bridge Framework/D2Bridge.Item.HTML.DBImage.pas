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
   procedure SetImageFolder(AValue: String);
   function GetImageFolder: String;
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
   property ImageFolder: String read GetImageFolder write SetImageFolder;
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

function TD2BridgeItemHTMLDBImage.GetImageFolder: String;
begin
 result:= PrismControl.ImageFolder;
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

procedure TD2BridgeItemHTMLDBImage.SetImageFolder(AValue: String);
begin
 PrismControl.ImageFolder:= AValue;
end;

{$ELSE}
implementation
{$ENDIF}

end.