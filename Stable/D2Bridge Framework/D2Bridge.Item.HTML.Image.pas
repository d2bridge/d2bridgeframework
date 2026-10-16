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

unit D2Bridge.Item.HTML.Image;

interface

uses
  Classes, Generics.Collections,
{$IFDEF FMX}
  FMX.Objects, FMX.Graphics,
{$ELSE}
  ExtCtrls, Graphics,
{$ENDIF}
  D2Bridge.Interfaces, D2Bridge.Image, D2Bridge.Item, D2Bridge.BaseClass;

type
  TD2BridgeItemHTMLImage = class(TD2BridgeItem, ID2BridgeItemHTMLImage)
   //events
   procedure BeginReader;
   procedure EndReader;
  private
   FImage: TD2BridgeImage;
  public
   constructor Create(AOwner: TD2BridgeClass); override;
   destructor Destroy; override;
   //Functions
   procedure PreProcess; override;
   procedure Render; override;
   procedure RenderHTML; override;

   procedure ImageFromLocal(PathFromImage: string);
   procedure ImageFromURL(URLFromImage: string);
   procedure ImageFromTImage(ImageComponent: TImage);

   property BaseClass;
  end;


implementation

uses
  Prism.Forms.Controls,
  Prism.ControlGeneric;

{ TD2BridgeItemHTMLImage }

constructor TD2BridgeItemHTMLImage.Create(AOwner: TD2BridgeClass);
begin
 Inherited;

 FImage:= TD2BridgeImage.Create;

 OnBeginReader:= BeginReader;
 OnEndReader:= EndReader;

 FPrismControl:= TPrismControlGeneric.Create(nil);
end;


destructor TD2BridgeItemHTMLImage.Destroy;
var
 vPrismControl: TPrismControl;
begin
 FImage.Free;

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

procedure TD2BridgeItemHTMLImage.BeginReader;
begin
end;

procedure TD2BridgeItemHTMLImage.EndReader;
begin
end;

procedure TD2BridgeItemHTMLImage.ImageFromLocal(PathFromImage: string);
begin
 FImage.Local:= PathFromImage;
end;

procedure TD2BridgeItemHTMLImage.ImageFromTImage(ImageComponent: TImage);
begin
 FImage.Image:= ImageComponent;
end;

procedure TD2BridgeItemHTMLImage.ImageFromURL(URLFromImage: string);
begin
 FImage.URL:= URLFromImage;
end;

procedure TD2BridgeItemHTMLImage.PreProcess;
begin

end;

procedure TD2BridgeItemHTMLImage.Render;
begin
end;

procedure TD2BridgeItemHTMLImage.RenderHTML;
begin
 BaseClass.HTML.Render.Body.Add('<img class="'+ CSSClasses +'" src="'+ FImage.ImageToSrc +'" style="'+HTMLStyle+'" '+HTMLExtras+'/>');
end;

end.