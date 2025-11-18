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

unit D2Bridge.Item.HTML.Card.Image;

interface

uses
  Classes, SysUtils, Generics.Collections,
{$IFDEF FMX}
  FMX.Objects, FMX.Graphics,
{$ELSE}
  ExtCtrls, Graphics, DB,
{$ENDIF}
  Prism.Interfaces,
  D2Bridge.Item.HTML.Card, D2Bridge.Types, D2Bridge.Item, D2Bridge.ItemCommon, D2Bridge.BaseClass,
  D2Bridge.Image, D2Bridge.Item.VCLObj, D2Bridge.Interfaces;

type
  TD2BridgeItemCardImage = class(TD2BridgeHTMLTag, ID2BridgeItemHTMLCardImage)
  private
   FD2BridgeItemHTMLCard: TD2BridgeItemHTMLCard;
   FImage: TD2BridgeImage;
   FColSize: string;
   FImagePosition: TD2BridgeCardImagePosition;
{$IFNDEF FMX}
   FImageDB: ID2BridgeItemHTMLDBImage;
{$ENDIF}
   procedure SetColSize(AColSize: string);
   function GetColSize: string;
   procedure SetPosition(AImagePosition: TD2BridgeCardImagePosition);
   function GetPosition: TD2BridgeCardImagePosition;
  public
   constructor Create(AOwner: TD2BridgeItemHTMLCard); reintroduce;
   destructor Destroy; override;

   function Image: TD2BridgeImage;
   procedure ImageFromLocal(PathFromImage: string);
   procedure ImageFromURL(URLFromImage: string);
   procedure ImageFromTImage(ImageComponent: TImage);
{$IFNDEF FMX}
   function ImageDB: ID2BridgeItemHTMLDBImage;
{$ENDIF}
   function IsImageFromDB: boolean;

   property ColSize: string read GetColSize write SetColSize;
   property Position: TD2BridgeCardImagePosition read GetPosition write SetPosition;
  end;

implementation

uses
  D2Bridge.Item.HTML.DBImage;

{ TD2BridgeItemCardImage }

constructor TD2BridgeItemCardImage.Create(AOwner: TD2BridgeItemHTMLCard);
begin
 inherited Create;

 FD2BridgeItemHTMLCard:= AOwner;
 FImage:= TD2BridgeImage.Create;
 FImagePosition:= TD2BridgeCardImagePosition.D2BridgeCardImagePositionTop;

 {$IFNDEF FMX}
  FImageDB:= TD2BridgeItemHTMLDBImage.Create(FD2BridgeItemHTMLCard.BaseClass);
  FImageDB.ItemID:= FD2BridgeItemHTMLCard.BaseClass.CreateItemID('img')
 {$ENDIF}

// FD2BridgeItemVCLObj:= TD2BridgeItemVCLObj.Create(AOwner.BaseClass);
// FD2BridgeItemVCLObj.Item:= FImage;
end;

destructor TD2BridgeItemCardImage.Destroy;
{$IFnDEF FMX}
var
 vImageDB: TD2BridgeItemHTMLDBImage;
{$ENDIF}
begin
 FImage.Free;

 {$IFnDEF FMX}
  vImageDB:= FImageDB as TD2BridgeItemHTMLDBImage;
  FImageDB:= nil;
  vImageDB.Free;
 {$ENDIF}

 inherited;
end;

function TD2BridgeItemCardImage.GetColSize: string;
begin
 Result:= FColSize;
end;

function TD2BridgeItemCardImage.GetPosition: TD2BridgeCardImagePosition;
begin
 Result:= FImagePosition;
end;

function TD2BridgeItemCardImage.Image: TD2BridgeImage;
begin
 Result:= FImage;
end;

{$IFNDEF FMX}
function TD2BridgeItemCardImage.ImageDB: ID2BridgeItemHTMLDBImage;
begin
 Result:= FImageDB;
end;
{$ENDIF}

function TD2BridgeItemCardImage.IsImageFromDB: boolean;
begin
 result:= false;

 {$IFNDEF FMX}
  if Assigned(ImageDB.DataSource) then
   Result:= true;
 {$ENDIF}
end;

procedure TD2BridgeItemCardImage.ImageFromLocal(PathFromImage: string);
begin
 FImage.Local:= PathFromImage;
end;

procedure TD2BridgeItemCardImage.ImageFromTImage(ImageComponent: TImage);
begin
 FImage.Image:= ImageComponent;
end;

procedure TD2BridgeItemCardImage.ImageFromURL(URLFromImage: string);
begin
 FImage.URL:= URLFromImage;
end;

procedure TD2BridgeItemCardImage.SetColSize(AColSize: string);
begin
 FColSize:= Trim(AColSize);
end;

procedure TD2BridgeItemCardImage.SetPosition(
  AImagePosition: TD2BridgeCardImagePosition);
begin
 FImagePosition:= AImagePosition;

 if AImagePosition in [D2BridgeCardImagePositionLeft, D2BridgeCardImagePositionRight] then
 if FColSize = '' then
  ColSize:= 'col-md-4';
end;

end.

