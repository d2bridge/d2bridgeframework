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

unit D2Bridge.Item.HTML.Card;

interface

uses
  Classes, SysUtils, Generics.Collections, System.UITypes,
{$IFDEF FMX}
  FMX.Objects,
{$ELSE}
  ExtCtrls, Graphics, DB,
{$ENDIF}
  Prism.Interfaces, Prism.Types,
  D2Bridge.ItemCommon, D2Bridge.Types, D2Bridge.Item, D2Bridge.BaseClass, D2Bridge.Item.VCLObj,
  D2Bridge.Interfaces;


type
  TD2BridgeItemHTMLCard = class(TD2BridgeItem, ID2BridgeItemHTMLCard)
  private
   FD2BridgeItem: TD2BridgeItem;
   FColSize: string;
   FTitle: string;
   FSubTitle: string;
   FText: string;
   FD2BridgeItems : TD2BridgeItems;
   FHeader: ID2BridgeItemHTMLCardHeader;
   FFooter: ID2BridgeItemHTMLCardFooter;
   FCardImage: ID2BridgeItemHTMLCardImage;
   FCSSClassesBody: string;
   FCSSImage: string;
{$IFNDEF FMX}
   FIsDataModel: Boolean;
{$ENDIF}
   FIsModel: Boolean;
   FRenderizable: Boolean;
   FDestroyPrismControl: boolean;
   FColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
   FTextColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
   FBorderColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
   FBorderWidth: integer;
   //events
   procedure BeginReader;
   procedure EndReader;
   //Prop
   function FixImageIcoColSize(AColSize: string): string;
   procedure SetCSSClassesBody(AValue: string);
   function GetCSSClassesBody: string;
   procedure SetColSize(AColSize: string);
   function GetColSize: string;
   function GetTitle: string;
   procedure SetTitle(ATitle: string);
   function GetTitleHeader: string;
   procedure SetTitleHeader(Value: string);
   function GetSubTitle: string;
   procedure SetSubTitle(ASubTitle: string);
   function GetText: string;
   procedure SetText(Value: string);
   function RemainderColSize: string;
   function GetExitProc: TProc;
   function GetOnExit: TNotifyEvent;
   procedure SetExitProc(const Value: TProc);
   procedure SetOnExit(const Value: TNotifyEvent);
   function GetCloseFormOnExit: Boolean;
   procedure SetCloseFormOnExit(const Value: Boolean);
   function GetRenderizable: Boolean;
   procedure SetRenderizable(const Value: Boolean);
   function GetColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
   procedure SetColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
   function GetTextColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
   procedure SetTextColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
   function GetBorderColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
   procedure SetBorderColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
   function GetBorderWidth: integer;
   procedure SetBorderWidth(const Value: integer);

   function ImageFromURL(AImagePosition: TD2BridgeCardImagePosition = D2BridgeCardImagePositionTop; URLFromImage: string = ''; AColSize: string = ''; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardImage; overload;
   function ImageFromLocal(AImagePosition: TD2BridgeCardImagePosition = D2BridgeCardImagePositionTop; LocalFromImage: string = ''; AColSize: string = ''; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardImage;
   function ImageFromTImage(AImagePosition: TD2BridgeCardImagePosition = D2BridgeCardImagePositionTop; Image: TImage = nil; AColSize: string = ''; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardImage;
{$IFNDEF FMX}
   function ImageFromDB(ADataSource: TDataSource; ADataFieldImagePath: string; AImagePosition: TD2BridgeCardImagePosition = D2BridgeCardImagePositionTop; ACSSClass: String = ''; AColSize: string = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardImage; overload;
{$ENDIF}
  public
   constructor Create(AOwner: TD2BridgeClass; APrismControl: IPrismControl = nil); overload;
   constructor Create(AOwner: TD2BridgeClass; AIsCardModel: Boolean; APrismControl: IPrismControl = nil); overload;
   destructor Destroy; override;

   procedure PreProcess; override;
   procedure Render; override;
   procedure RenderHTML; override;

   property BaseClass;

   function Header(AText: String = ''; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardHeader;
   Function Items: ID2BridgeAddItems;
   Function BodyItems: ID2BridgeAddItems;
   function Footer(AText: String = ''; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardFooter;

   function Image(AImagePosition: TD2BridgeCardImagePosition = D2BridgeCardImagePositionTop; Image: TImage = nil; AColSize: string = ''): ID2BridgeItemHTMLCardImage; overload;
   function ImageICOFromLocal(LocalFromImage: string = ''; AColSize: string = ''; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardImage;
   function ImageICOFromURL(URLFromImage: string = ''; AColSize: string = ''; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardImage;
   function ImageICOFromTImage(Image: TImage = nil; AColSize: string = ''; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardImage;
{$IFNDEF FMX}
   function ImageICOFromDB(ADataSource: TDataSource; ADataFieldImagePath: string; ACSSClass: String = ''; AColSize: string = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardImage;
{$ENDIF}
   function ImageTOPFromLocal(LocalFromImage: string = ''; AColSize: string = ''; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardImage;
   function ImageTOPFromURL(URLFromImage: string = ''; AColSize: string = ''; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardImage;
   function ImageTOPFromTImage(Image: TImage = nil; AColSize: string = ''; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardImage;
{$IFNDEF FMX}
   function ImageTOPFromDB(ADataSource: TDataSource; ADataFieldImagePath: string; ACSSClass: String = ''; AColSize: string = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardImage;
{$ENDIF}
   function ImageBOTTOMFromLocal(LocalFromImage: string = ''; AColSize: string = ''; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardImage;
   function ImageBOTTOMFromURL(URLFromImage: string = ''; AColSize: string = ''; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardImage;
   function ImageBOTTOMFromTImage(Image: TImage = nil; AColSize: string = ''; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardImage;
{$IFNDEF FMX}
   function ImageBOTTOMFromDB(ADataSource: TDataSource; ADataFieldImagePath: string; ACSSClass: String = ''; AColSize: string = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardImage;
{$ENDIF}
   function ImageLEFTFromLocal(LocalFromImage: string = ''; AColSize: string = ''; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardImage;
   function ImageLEFTFromURL(URLFromImage: string = ''; AColSize: string = ''; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardImage;
   function ImageLEFTFromTImage(Image: TImage = nil; AColSize: string = ''; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardImage;
{$IFNDEF FMX}
   function ImageLEFTFromDB(ADataSource: TDataSource; ADataFieldImagePath: string; ACSSClass: String = ''; AColSize: string = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardImage;
{$ENDIF}
   function ImageRIGHTFromLocal(LocalFromImage: string = ''; AColSize: string = ''; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardImage;
   function ImageRIGHTFromURL(URLFromImage: string = ''; AColSize: string = ''; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardImage;
   function ImageRIGHTFromTImage(Image: TImage = nil; AColSize: string = ''; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardImage;
{$IFNDEF FMX}
   function ImageRIGHTFromDB(ADataSource: TDataSource; ADataFieldImagePath: string; ACSSClass: String = ''; AColSize: string = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardImage;
{$ENDIF}
   function ImageFULLFromLocal(LocalFromImage: string = ''; AColSize: string = ''; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardImage;
   function ImageFULLFromURL(URLFromImage: string = ''; AColSize: string = ''; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardImage;
   function ImageFULLFromTImage(Image: TImage = nil; AColSize: string = ''; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardImage;
{$IFNDEF FMX}
   function ImageFULLFromDB(ADataSource: TDataSource; ADataFieldImagePath: string; ACSSClass: String = ''; AColSize: string = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardImage;
{$ENDIF}

   property Color: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF} read GetColor write SetColor;
   property TextColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF} read GetTextColor write SetTextColor;
   property BorderColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF} read GetBorderColor write SetBorderColor;
   property BorderWidth: integer read GetBorderWidth write SetBorderWidth;
   property CSSClassesBody: string read GetCSSClassesBody write SetCSSClassesBody;
   property ColSize: string read GetColSize write SetColSize;
   property Title: string read GetTitle write SetTitle;
   property TitleHeader: string read GetTitleHeader write SetTitleHeader;
   property SubTitle: string read GetSubTitle write SetSubTitle;
   property Text: string read GetSubTitle write SetSubTitle;
   property Renderizable: boolean read GetRenderizable write SetRenderizable;

   property OnExit: TNotifyEvent read GetOnExit write SetOnExit;
   property ExitProc: TProc read GetExitProc write SetExitProc;
   property CloseFormOnExit: Boolean read GetCloseFormOnExit write SetCloseFormOnExit;
  end;

implementation

uses
  D2Bridge.Item.HTML.Card.Header, D2Bridge.Item.HTML.Card.Footer, D2Bridge.Item.HTML.Card.Image,
  D2Bridge.Util,
  Prism.Forms.Controls,
  Prism.Util, Prism.ControlGeneric, Prism.Card, Prism.Card.DataModel, Prism.Card.Model,
  StrUtils, Math, Prism.Card.Grid.DataModel;



{ TD2BridgeItemHTMLCard }

function TD2BridgeItemHTMLCard.BodyItems: ID2BridgeAddItems;
begin
 result:= Items;
end;

constructor TD2BridgeItemHTMLCard.Create(AOwner: TD2BridgeClass; APrismControl: IPrismControl = nil);
begin
 Create(AOwner, false, APrismControl);
end;

constructor TD2BridgeItemHTMLCard.Create(AOwner: TD2BridgeClass; AIsCardModel: Boolean; APrismControl: IPrismControl = nil);
begin
 FD2BridgeItem:= Inherited Create(AOwner);

 FIsModel:= AIsCardModel;

 FColor:= {$IFNDEF FPC}TColors.SysNone{$ELSE}TColorRec.Black{$ENDIF};
 FTextColor:= {$IFNDEF FPC}TColors.SysNone{$ELSE}TColorRec.Black{$ENDIF};
 FBorderColor:= {$IFNDEF FPC}TColors.SysNone{$ELSE}TColorRec.Black{$ENDIF};
 FBorderWidth:= 1;

 FDestroyPrismControl:= false;

 FRenderizable:= true;

{$IFNDEF FMX}
 if Assigned(APrismControl) then
 begin
  if APrismControl is TPrismCardGridDataModel then
   FIsDataModel:= true;
 end;
{$ENDIF}

 FD2BridgeItems:= TD2BridgeItems.Create(AOwner);
 FHeader:= TD2BridgeItemCardHeader.Create(self);
 FFooter:= TD2BridgeItemCardFooter.Create(self);
 FCardImage:= TD2BridgeItemCardImage.Create(self);

 FD2BridgeItem.OnBeginReader:= BeginReader;
 FD2BridgeItem.OnEndReader:= EndReader;

{$IFNDEF FMX}
 if FIsDataModel then
 begin
  FPrismControl := TPrismCardDataModel.Create(APrismControl);
  AOwner.PrismControlToRegister.Add(FPrismControl);
 end else
{$ENDIF}
 if FIsModel then
 begin
  FPrismControl := TPrismCardModel.Create(APrismControl);
  AOwner.PrismControlToRegister.Add(FPrismControl);
 end else
 begin
  if Assigned(APrismControl) then
   FPrismControl:= APrismControl
  else
  begin
   FDestroyPrismControl:= true;
   FPrismControl := TPrismCard.Create(nil);
  end;
 end;

 FPrismControl.Name:= ITemID;
end;

destructor TD2BridgeItemHTMLCard.Destroy;
var
 vHeader: TD2BridgeItemCardHeader;
 vFooter: TD2BridgeItemCardFooter;
 vCardImage: TD2BridgeItemCardImage;
 vPrismControl: TPrismControl;
begin
 FreeAndNil(FD2BridgeItems);

 vHeader:= FHeader as TD2BridgeItemCardHeader;
 FHeader:= nil;
 vHeader.Free;

 vFooter:= FFooter as TD2BridgeItemCardFooter;
 FFooter:= nil;
 vFooter.Free;

 vCardImage:= FCardImage as TD2BridgeItemCardImage;
 FCardImage:= nil;
 vCardImage.Destroy;

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

function TD2BridgeItemHTMLCard.GetBorderColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
begin
 result:= FBorderColor;
end;

function TD2BridgeItemHTMLCard.GetBorderWidth: integer;
begin
 result:= FBorderWidth;
end;

function TD2BridgeItemHTMLCard.GetCloseFormOnExit: Boolean;
begin
 Result:= (FPrismControl as TPrismCard).CloseFormOnExit;
end;

function TD2BridgeItemHTMLCard.GetColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
begin
 result:= FColor;
end;

function TD2BridgeItemHTMLCard.GetColSize: string;
begin
 result:= FColSize;
end;
function TD2BridgeItemHTMLCard.GetCSSClassesBody: string;
begin
 result:= FCSSClassesBody;
end;

function TD2BridgeItemHTMLCard.GetExitProc: TProc;
begin
 Result:= (FPrismControl as TPrismCard).ExitProc;
end;

function TD2BridgeItemHTMLCard.GetOnExit: TNotifyEvent;
begin
 Result:= (FPrismControl as TPrismCard).OnExit;
end;

function TD2BridgeItemHTMLCard.GetRenderizable: Boolean;
begin
 result:= FRenderizable;
end;

function TD2BridgeItemHTMLCard.GetSubTitle: string;
begin
 Result:= FSubTitle;
end;

function TD2BridgeItemHTMLCard.GetText: string;
begin
 Result:= FText;
end;

function TD2BridgeItemHTMLCard.GetTextColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
begin
 Result:= FTextColor;
end;

function TD2BridgeItemHTMLCard.GetTitle: string;
begin
 Result:= FTitle;
end;

function TD2BridgeItemHTMLCard.GetTitleHeader: string;
begin
 result:= FHeader.Text;
end;

function TD2BridgeItemHTMLCard.Header(AText: String = ''; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardHeader;
begin
 FHeader.Text:= AText;
 FHeader.CSSClasses:= ACSSClass;
 FHeader.HTMLExtras:= HTMLExtras;
 FHeader.HTMLStyle:= HTMLStyle;

 result:= FHeader;
end;

function TD2BridgeItemHTMLCard.Image(AImagePosition: TD2BridgeCardImagePosition = D2BridgeCardImagePositionTop; Image: TImage = nil; AColSize: string = ''): ID2BridgeItemHTMLCardImage;
begin
 if Assigned(Image) then
  FCardImage.Image.Picture:= Image.{$IFDEF FMX}Bitmap{$ELSE}Picture{$ENDIF};

 if AColSize <> '' then
  FCardImage.ColSize:= AColSize;

 FCardImage.Position:= AImagePosition;

 result:= FCardImage;
end;

{$IFNDEF FMX}
function TD2BridgeItemHTMLCard.ImageBOTTOMFromDB(ADataSource: TDataSource;
  ADataFieldImagePath, ACSSClass, AColSize, HTMLExtras,
  HTMLStyle: String): ID2BridgeItemHTMLCardImage;
begin
 Result:= ImageFromDB(ADataSource, ADataFieldImagePath, D2BridgeCardImagePositionBOTTOM, ACSSClass, AColSize, HTMLExtras, HTMLStyle);
end;
{$ENDIF}

function TD2BridgeItemHTMLCard.ImageBOTTOMFromLocal(LocalFromImage, AColSize, ACSSClass, HTMLExtras, HTMLStyle: String): ID2BridgeItemHTMLCardImage;
begin
 Result:= ImageFromLocal(D2BridgeCardImagePositionBottom, LocalFromImage, AColSize, ACSSClass, HTMLExtras, HTMLStyle);
end;

function TD2BridgeItemHTMLCard.ImageBOTTOMFromTImage(Image: TImage; AColSize, ACSSClass, HTMLExtras, HTMLStyle: String): ID2BridgeItemHTMLCardImage;
begin
 Result:= ImageFromTImage(D2BridgeCardImagePositionBottom, Image, AColSize, ACSSClass, HTMLExtras, HTMLStyle);
end;

function TD2BridgeItemHTMLCard.ImageBOTTOMFromURL(URLFromImage, AColSize, ACSSClass, HTMLExtras, HTMLStyle: String): ID2BridgeItemHTMLCardImage;
begin
 Result:= ImageFromURL(D2BridgeCardImagePositionBottom, URLFromImage, AColSize, ACSSClass, HTMLExtras, HTMLStyle);
end;

function TD2BridgeItemHTMLCard.ImageFromURL(AImagePosition: TD2BridgeCardImagePosition; URLFromImage, AColSize, ACSSClass, HTMLExtras, HTMLStyle: string): ID2BridgeItemHTMLCardImage;
begin
 FCardImage.Image.URL:= URLFromImage;

 if AColSize <> '' then
  FCardImage.ColSize:= AColSize;

 FCardImage.Position:= AImagePosition;

 if ACSSClass <> '' then
  FCardImage.CSSClasses:= ACSSClass;
 if HTMLExtras <> '' then
  FCardImage.HTMLExtras:= HTMLExtras;
 if HTMLStyle <> '' then
  FCardImage.HTMLStyle:= HTMLStyle;

 result:= FCardImage;
end;

{$IFNDEF FMX}
function TD2BridgeItemHTMLCard.ImageFULLFromDB(ADataSource: TDataSource;
  ADataFieldImagePath, ACSSClass, AColSize, HTMLExtras,
  HTMLStyle: String): ID2BridgeItemHTMLCardImage;
begin
 Result:= ImageFromDB(ADataSource, ADataFieldImagePath, D2BridgeCardImagePositionFull, ACSSClass, AColSize, HTMLExtras, HTMLStyle);
end;

{$ENDIF}

{$IFNDEF FMX}
function TD2BridgeItemHTMLCard.ImageICOFromDB(ADataSource: TDataSource;
  ADataFieldImagePath, ACSSClass, AColSize, HTMLExtras,
  HTMLStyle: String): ID2BridgeItemHTMLCardImage;
begin
 Result:= ImageFromDB(ADataSource, ADataFieldImagePath, D2BridgeCardImagePositionIco, ACSSClass, AColSize, HTMLExtras, HTMLStyle);
end;
{$ENDIF}

function TD2BridgeItemHTMLCard.ImageFULLFromLocal(LocalFromImage, AColSize,
  ACSSClass, HTMLExtras, HTMLStyle: String): ID2BridgeItemHTMLCardImage;
begin
 Result:= ImageFromLocal(D2BridgeCardImagePositionFull, LocalFromImage, AColSize, ACSSClass, HTMLExtras, HTMLStyle);
end;

function TD2BridgeItemHTMLCard.ImageFULLFromTImage(Image: TImage; AColSize,
  ACSSClass, HTMLExtras, HTMLStyle: String): ID2BridgeItemHTMLCardImage;
begin
 Result:= ImageFromTImage(D2BridgeCardImagePositionFull, Image, AColSize, ACSSClass, HTMLExtras, HTMLStyle);
end;

function TD2BridgeItemHTMLCard.ImageFULLFromURL(URLFromImage, AColSize,
  ACSSClass, HTMLExtras, HTMLStyle: String): ID2BridgeItemHTMLCardImage;
begin
 Result:= ImageFromURL(D2BridgeCardImagePositionFull, URLFromImage, AColSize, ACSSClass, HTMLExtras, HTMLStyle);
end;

function TD2BridgeItemHTMLCard.ImageICOFromLocal(LocalFromImage, AColSize, ACSSClass, HTMLExtras, HTMLStyle: String): ID2BridgeItemHTMLCardImage;
begin
 Result:= ImageFromLocal(D2BridgeCardImagePositionIco, LocalFromImage, AColSize, ACSSClass, HTMLExtras, HTMLStyle);
end;

function TD2BridgeItemHTMLCard.ImageICOFromTImage(Image: TImage; AColSize, ACSSClass, HTMLExtras, HTMLStyle: String): ID2BridgeItemHTMLCardImage;
begin
 Result:= ImageFromTImage(D2BridgeCardImagePositionIco, Image, AColSize, ACSSClass, HTMLExtras, HTMLStyle);
end;

function TD2BridgeItemHTMLCard.ImageICOFromURL(URLFromImage, AColSize, ACSSClass, HTMLExtras, HTMLStyle: String): ID2BridgeItemHTMLCardImage;
begin
 Result:= ImageFromURL(D2BridgeCardImagePositionIco, URLFromImage, AColSize, ACSSClass, HTMLExtras, HTMLStyle);
end;

{$IFNDEF FMX}
function TD2BridgeItemHTMLCard.ImageLEFTFromDB(ADataSource: TDataSource;
  ADataFieldImagePath, ACSSClass, AColSize, HTMLExtras,
  HTMLStyle: String): ID2BridgeItemHTMLCardImage;
begin
 Result:= ImageFromDB(ADataSource, ADataFieldImagePath, D2BridgeCardImagePositionLEFT, ACSSClass, AColSize, HTMLExtras, HTMLStyle);
end;
{$ENDIF}

function TD2BridgeItemHTMLCard.ImageLEFTFromLocal(LocalFromImage, AColSize, ACSSClass, HTMLExtras, HTMLStyle: String): ID2BridgeItemHTMLCardImage;
begin
 Result:= ImageFromLocal(D2BridgeCardImagePositionLeft, LocalFromImage, AColSize, ACSSClass, HTMLExtras, HTMLStyle);
end;

function TD2BridgeItemHTMLCard.ImageLEFTFromTImage(Image: TImage; AColSize, ACSSClass, HTMLExtras, HTMLStyle: String): ID2BridgeItemHTMLCardImage;
begin
 Result:= ImageFromTImage(D2BridgeCardImagePositionLeft, Image, AColSize, ACSSClass, HTMLExtras, HTMLStyle);
end;

function TD2BridgeItemHTMLCard.ImageLEFTFromURL(URLFromImage, AColSize, ACSSClass, HTMLExtras, HTMLStyle: String): ID2BridgeItemHTMLCardImage;
begin
 Result:= ImageFromURL(D2BridgeCardImagePositionLeft, URLFromImage, AColSize, ACSSClass, HTMLExtras, HTMLStyle);
end;

{$IFNDEF FMX}
function TD2BridgeItemHTMLCard.ImageRIGHTFromDB(ADataSource: TDataSource;
  ADataFieldImagePath, ACSSClass, AColSize, HTMLExtras,
  HTMLStyle: String): ID2BridgeItemHTMLCardImage;
begin
 Result:= ImageFromDB(ADataSource, ADataFieldImagePath, D2BridgeCardImagePositionRIGHT, ACSSClass, AColSize, HTMLExtras, HTMLStyle);
end;
{$ENDIF}

function TD2BridgeItemHTMLCard.ImageRIGHTFromLocal(LocalFromImage, AColSize, ACSSClass, HTMLExtras, HTMLStyle: String): ID2BridgeItemHTMLCardImage;
begin
 Result:= ImageFromLocal(D2BridgeCardImagePositionRight, LocalFromImage, AColSize, ACSSClass, HTMLExtras, HTMLStyle);
end;

function TD2BridgeItemHTMLCard.ImageRIGHTFromTImage(Image: TImage; AColSize, ACSSClass, HTMLExtras, HTMLStyle: String): ID2BridgeItemHTMLCardImage;
begin
 Result:= ImageFromTImage(D2BridgeCardImagePositionRight, Image, AColSize, ACSSClass, HTMLExtras, HTMLStyle);
end;

function TD2BridgeItemHTMLCard.ImageRIGHTFromURL(URLFromImage, AColSize, ACSSClass, HTMLExtras, HTMLStyle: String): ID2BridgeItemHTMLCardImage;
begin
 Result:= ImageFromURL(D2BridgeCardImagePositionRight, URLFromImage, AColSize, ACSSClass, HTMLExtras, HTMLStyle);
end;

{$IFNDEF FMX}
function TD2BridgeItemHTMLCard.ImageTOPFromDB(ADataSource: TDataSource;
  ADataFieldImagePath, ACSSClass, AColSize, HTMLExtras,
  HTMLStyle: String): ID2BridgeItemHTMLCardImage;
begin
 Result:= ImageFromDB(ADataSource, ADataFieldImagePath, D2BridgeCardImagePositionTOP, ACSSClass, AColSize, HTMLExtras, HTMLStyle);
end;
{$ENDIF}

function TD2BridgeItemHTMLCard.ImageTOPFromLocal(LocalFromImage, AColSize, ACSSClass, HTMLExtras, HTMLStyle: String): ID2BridgeItemHTMLCardImage;
begin
 Result:= ImageFromLocal(D2BridgeCardImagePositionTOP, LocalFromImage, AColSize, ACSSClass, HTMLExtras, HTMLStyle);
end;

function TD2BridgeItemHTMLCard.ImageTOPFromTImage(Image: TImage; AColSize, ACSSClass, HTMLExtras, HTMLStyle: String): ID2BridgeItemHTMLCardImage;
begin
 Result:= ImageFromTImage(D2BridgeCardImagePositionTOP, Image, AColSize, ACSSClass, HTMLExtras, HTMLStyle);
end;

function TD2BridgeItemHTMLCard.ImageTOPFromURL(URLFromImage, AColSize, ACSSClass, HTMLExtras, HTMLStyle: String): ID2BridgeItemHTMLCardImage;
begin
 Result:= ImageFromURL(D2BridgeCardImagePositionTOP, URLFromImage, AColSize, ACSSClass, HTMLExtras, HTMLStyle);
end;

{$IFNDEF FMX}
function TD2BridgeItemHTMLCard.ImageFromDB(ADataSource: TDataSource;
  ADataFieldImagePath: string; AImagePosition: TD2BridgeCardImagePosition;
  ACSSClass, AColSize, HTMLExtras,
  HTMLStyle: String): ID2BridgeItemHTMLCardImage;
begin
 FCardImage.ImageDB.DataSource:= ADataSource;
 FCardImage.ImageDB.DataFieldImagePath:= ADataFieldImagePath;

 if AColSize <> '' then
  FCardImage.ColSize:= AColSize;

 FCardImage.Position:= AImagePosition;

 if ACSSClass <> '' then
  FCardImage.CSSClasses:= ACSSClass;
 if HTMLExtras <> '' then
  FCardImage.HTMLExtras:= HTMLExtras;
 if HTMLStyle <> '' then
  FCardImage.HTMLStyle:= HTMLStyle;

 result:= FCardImage;
end;
{$ENDIF}

function TD2BridgeItemHTMLCard.ImageFromLocal(AImagePosition: TD2BridgeCardImagePosition; LocalFromImage, AColSize, ACSSClass, HTMLExtras, HTMLStyle: string): ID2BridgeItemHTMLCardImage;
begin
 FCardImage.Image.Local:= LocalFromImage;

 if AColSize <> '' then
  FCardImage.ColSize:= AColSize;

 if ACSSClass <> '' then
  FCardImage.CSSClasses:= ACSSClass;
 if HTMLExtras <> '' then
  FCardImage.HTMLExtras:= HTMLExtras;
 if HTMLStyle <> '' then
  FCardImage.HTMLStyle:= HTMLStyle;

 FCardImage.Position:= AImagePosition;

 result:= FCardImage;
end;

function TD2BridgeItemHTMLCard.ImageFromTImage(AImagePosition: TD2BridgeCardImagePosition; Image: TImage; AColSize, ACSSClass, HTMLExtras, HTMLStyle: String): ID2BridgeItemHTMLCardImage;
begin
 if Assigned(Image) then
  FCardImage.Image.Picture:= Image.{$IFDEF FMX}Bitmap{$ELSE}Picture{$ENDIF};

 if AColSize <> '' then
  FCardImage.ColSize:= AColSize;

 if ACSSClass <> '' then
  FCardImage.CSSClasses:= ACSSClass;
 if HTMLExtras <> '' then
  FCardImage.HTMLExtras:= HTMLExtras;
 if HTMLStyle <> '' then
  FCardImage.HTMLStyle:= HTMLStyle;

 FCardImage.Position:= AImagePosition;

 result:= FCardImage;
end;

function TD2BridgeItemHTMLCard.Items: ID2BridgeAddItems;
begin
 Result:= FD2BridgeItems;
end;

procedure TD2BridgeItemHTMLCard.BeginReader;
var
 vMargem: string;
 vHtmlStyle: string;
 vHtmlExtras: string;
begin
 with BaseClass.HTML.Render.Body do
 begin
  if TRIM(FColSize) <> '' then
   Add('<div class="' + FColSize +'">');

  vMargem:= '';

  if (Pos('d2bridgecardgriditem', CSSClasses) <= 0) and (Pos('kanbancard', CSSClasses) <= 0) then
   vMargem:= 'mb-3';

  vHtmlStyle:= HTMLStyle;
  if FColor <> {$IFNDEF FPC}TColors.SysNone{$ELSE}TColorRec.Black{$ENDIF} then
   vHtmlStyle:= vHtmlStyle + ' background-color:' + ColorToHex(FColor) + ';';
  if FTextColor <> {$IFNDEF FPC}TColors.SysNone{$ELSE}TColorRec.Black{$ENDIF} then
   vHtmlStyle:= vHtmlStyle + ' color:' + ColorToHex(FTextColor) + ';';
  if (FBorderColor <> {$IFNDEF FPC}TColors.SysNone{$ELSE}TColorRec.Black{$ENDIF}) and (FBorderWidth > 0) then
   vHtmlStyle:= vHtmlStyle + ' border:'+ IntToStr(FBorderWidth) +'px solid ' + ColorToHex(FBorderColor) + ';';

  vHtmlStyle:= Trim(vHtmlStyle);

  vHtmlExtras:= HTMLExtras;
  if FIsModel then
   vHtmlExtras:= Trim(vHTMLExtras + ' DataModelProperty');

  Add('<div id="'+IfThen(FIsModel, '{{CardModelAtt=id}}', AnsiUpperCase(ItemPrefixID))+'" class="d2bridgecard card '+ vMargem +' ' + CSSClasses + ifThen(not Renderizable, ' cardnotrenderizable') + '" style="'+ vHtmlStyle +'" '+ vHtmlExtras +'>');
 end;
end;

procedure TD2BridgeItemHTMLCard.EndReader;
begin
 with BaseClass.HTML.Render.Body do
 begin
  //Image in Bottom
  if ((not FCardImage.Image.IsEmpty) or (FCardImage.IsImageFromDB)) then
   if FCardImage.Position = D2BridgeCardImagePositionBottom then
   begin
    if not FCardImage.IsImageFromDB then
    begin
     with BaseClass.HTML.Render.Body do
      Add('      <img class="'+ FCSSImage +'" src="'+ FCardImage.Image.ImageToSrc +'" style="'+HTMLStyle+'" '+HTMLExtras+'/>');
    end else
    begin
{$IFNDEF FMX}
     BaseClass.RenderD2Bridge(FCardImage.ImageDB);
{$ENDIF}
    end;
   end;

  if (FFooter.Text <> '') or (FFooter.Items.Items.Count > 0) then
  with BaseClass.HTML.Render.Body do
  begin
   Add('  <div class="d2bridgecard-footer card-footer '+ FFooter.CSSClasses +'" style="'+FFooter.HTMLStyle+'" '+FFooter.HTMLExtras+'>');
   if FFooter.Text <> '' then
   Add(FFooter.Text);
   if FFooter.Items.Items.Count > 0 then
    BaseClass.RenderD2Bridge(FFooter.Items.Items);
   Add('  </div>');
  end;
  Add('</div>');

  if TRIM(FColSize) <> '' then
   Add('</div>');
 end;
end;

function TD2BridgeItemHTMLCard.FixImageIcoColSize(AColSize: string): string;
begin
 Result:= AColSize;

 if (Pos('col-xl-', AColSize) > 0) and
    (Pos('col-md-', AColSize) > 0) and
    ((Pos('col-1', AColSize) > 0) or (Pos('col-2', AColSize) > 0) or (Pos('col-3', AColSize) > 0) or
     (Pos('col-4', AColSize) > 0) or (Pos('col-5', AColSize) > 0) or (Pos('col-6', AColSize) > 0) or
     (Pos('col-7', AColSize) > 0) or (Pos('col-8', AColSize) > 0) or (Pos('col-9', AColSize) > 0) or
     (Pos('col-10', AColSize) > 0) or (Pos('col-11', AColSize) > 0) or (Pos('col-12', AColSize) > 0)) then
 begin
  Result:= Copy(Result, Pos('col-xl-', AColSize));
  Result:= Copy(Result, 1, Pos(' ', AColSize)-1);
  Result:= ReplaceStr(Result, 'col-xl-', 'col-');
 end;
end;

function TD2BridgeItemHTMLCard.Footer(AText: String = ''; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLCardFooter;
begin
 FFooter.Text:= AText;
 FFooter.CSSClasses:= ACSSClass;
 FFooter.HTMLExtras:= HTMLExtras;
 FFooter.HTMLStyle:= HTMLStyle;

 Result:= FFooter;
end;

procedure TD2BridgeItemHTMLCard.PreProcess;
begin

end;

function TD2BridgeItemHTMLCard.RemainderColSize: string;
var
  vPrefix: string;
  vColSize: integer;
begin
 result:= '';

 if FCardImage.ColSize <> '' then
  if Pos('col-xl-', FCardImage.ColSize) = 1 then
   vPrefix:= 'col-xl-'
  else
  if Pos('col-lg-', FCardImage.ColSize) = 1 then
   vPrefix:= 'col-lg-'
  else
  if Pos('col-md-', FCardImage.ColSize) = 1 then
   vPrefix:= 'col-md-'
  else
  if Pos('col-sm-', FCardImage.ColSize) = 1 then
   vPrefix:= 'col-sm-'
  else
  if Pos('col-', FCardImage.ColSize) = 1 then
   vPrefix:= 'col-';

 if vPrefix <> '' then
 begin
  if TryStrToInt(Copy(FCardImage.ColSize, Length(vPrefix) + 1), vColSize) then
  result:= vPrefix + IntToStr(12 - vColSize);
 end else
  result:= 'col-md-8';
end;

procedure TD2BridgeItemHTMLCard.Render;
var
 vShowButtonClose: Boolean;
begin
 vShowButtonClose:= Assigned(ExitProc) or Assigned(OnExit) or CloseFormOnExit;

 //FHeader
 if (FHeader.Text <> '') or (FHeader.Items.Items.Count > 0) or vShowButtonClose then
 with BaseClass.HTML.Render.Body do
 begin
  //FHeader + Button Close
  Add('  <div class="d2bridgecard-header card-header ' + IfThen(vShowButtonClose, 'modal-header') + ' ' + FHeader.CSSClasses + '" style="'+FHeader.HTMLStyle+'" '+FHeader.HTMLExtras+'>');
  if FHeader.Text <> '' then
   Add('<h5 class="d2bridgecard-header-title card-title">' + IfThen(FIsModel, '{{CardModelAtt=TitleHeader}}', FHeader.Text) + '</h5>');
  if vShowButtonClose then
   Add('<button class="d2bridgecard-header-buttonclose btn-close" onclick="' +  fPrismControl.Events.Item(EventOnExit).EventJS(FD2BridgeItem.BaseClass.PrismSession, FD2BridgeItem.BaseClass.FormUUID, ExecEventProc) + '" style="width: 2em;"></button>');
  if FHeader.Items.Items.Count > 0 then
   BaseClass.RenderD2Bridge(FHeader.Items.Items);
  Add('  </div>');
 end;

 //Image
 if ((not FCardImage.Image.IsEmpty) or (FCardImage.IsImageFromDB)) then
 begin
//  if not Assigned(FD2BridgeItemImage) then
//  begin
//   FD2BridgeItemImage:= TD2BridgeItemVCLObj.Create(BaseClass);
//   FD2BridgeItemImage.Item:= FCardImage.Image;
//  end;
//  FD2BridgeItemImage.HTMLExtras:= FCardImage.HTMLExtras;

  if FCardImage.Position = D2BridgeCardImagePositionTop then
   FCSSImage:= 'd2bridgecard-img card-img-top ' + FCardImage.CSSClasses
  else
  if FCardImage.Position = D2BridgeCardImagePositionBottom then
   FCSSImage:= 'd2bridgecard-img card-img-bottom ' + FCardImage.CSSClasses
  else
  if FCardImage.Position = D2BridgeCardImagePositionLeft then
   FCSSImage:= 'd2bridgecard-img img-fluid rounded-start ' + FCardImage.CSSClasses
  else
  if FCardImage.Position = D2BridgeCardImagePositionRight then
   FCSSImage:= 'd2bridgecard-img img-fluid rounded-end ' + FCardImage.CSSClasses
  else
  if FCardImage.Position = D2BridgeCardImagePositionIco then
   FCSSImage:= 'd2bridgecard-img card-img-ico ' + FCardImage.CSSClasses
  else
  if FCardImage.Position = D2BridgeCardImagePositionFull then
   FCSSImage:= 'd2bridgecard-img card-img-full ' + FCardImage.CSSClasses;

{$IFNDEF FMX}
  if FCardImage.IsImageFromDB then
  begin
   FCardImage.ImageDB.CSSClasses:= FCSSImage;
   FCardImage.ImageDB.HTMLStyle:= FCardImage.HTMLStyle;
   FCardImage.ImageDB.HTMLExtras:= FCardImage.HTMLExtras;
  end;
{$ENDIF}


  //Image in Top, Left or Right
  if (FCardImage.Position in [D2BridgeCardImagePositionLeft, D2BridgeCardImagePositionRight]) then
   with BaseClass.HTML.Render.Body do
   begin
    Add('   <div class="row g-0">');
   end;

   if FCardImage.Position = D2BridgeCardImagePositionLeft then
   begin
    with BaseClass.HTML.Render.Body do
    begin
     Add('   <div class="' + FCardImage.ColSize + '">');
     if not FCardImage.IsImageFromDB then
     begin
      Add('      <img class="'+ FCSSImage +'" src="' + FCardImage.Image.ImageToSrc +'" style="'+FCardImage.HTMLStyle+'" '+FCardImage.HTMLExtras+'/>');
     end else
     begin
{$IFNDEF FMX}
      BaseClass.RenderD2Bridge(FCardImage.ImageDB);
{$ENDIF}
     end;
     Add('   </div>');
    end;
   end else
    if (FCardImage.Position in [D2BridgeCardImagePositionTop]) then
    begin
     if not FCardImage.IsImageFromDB then
     begin
      with BaseClass.HTML.Render.Body do
       Add('      <img class="'+ FCSSImage +'" src="' + FCardImage.Image.ImageToSrc + '" style="'+FCardImage.HTMLStyle+'" '+FCardImage.HTMLExtras+'/>')
     end else
     begin
{$IFNDEF FMX}
      BaseClass.RenderD2Bridge(FCardImage.ImageDB);
{$ENDIF}
     end;
    end else
     if (FCardImage.Position in [D2BridgeCardImagePositionIco]) then
     with BaseClass.HTML.Render.Body do
     begin
      if FCardImage.ColSize <> '' then
      begin
       Add('      <div class="row justify-content-center" style="padding-top: 3em;">');
       Add('      <div class="' + FixImageIcoColSize(FCardImage.ColSize) + '">');
      end;

      if not FCardImage.IsImageFromDB then
      begin
       Add('      <img class="'+ FCSSImage + IfThen(FCardImage.ColSize <> '', ' d2bridgecard-img-col') + '" src="' + FCardImage.Image.ImageToSrc + '" style="'+FCardImage.HTMLStyle+'" '+FCardImage.HTMLExtras+'/>');
      end else
      begin
{$IFNDEF FMX}
       FCardImage.ImageDB.CSSClasses:= FCardImage.ImageDB.CSSClasses + IfThen(FCardImage.ColSize <> '', ' d2bridgecard-img-col');
       BaseClass.RenderD2Bridge(FCardImage.ImageDB);
{$ENDIF}
      end;

      if FCardImage.ColSize <> '' then
      begin
       Add('      </div>');
       Add('      </div>');
      end;
     end else
      if (FCardImage.Position in [D2BridgeCardImagePositionFull]) then
      begin
       if not FCardImage.IsImageFromDB then
       begin
        with BaseClass.HTML.Render.Body do
         Add('      <img class="'+ FCSSImage +'" src="' + FCardImage.Image.ImageToSrc + '" style="'+FCardImage.HTMLStyle+'" '+FCardImage.HTMLExtras+'/>')
       end else
       begin
  {$IFNDEF FMX}
        BaseClass.RenderD2Bridge(FCardImage.ImageDB);
  {$ENDIF}
       end;
      end;
 end;



 //Body
 with BaseClass.HTML.Render.Body do
 begin
  if ((not FCardImage.Image.IsEmpty) or (FCardImage.IsImageFromDB)) and
     (FCardImage.Position in [D2BridgeCardImagePositionLeft, D2BridgeCardImagePositionRight]) then
  Add('  <div class="' + RemainderColSize + '">');

  if not ((FCardImage.Position in [D2BridgeCardImagePositionFull]) and (Items.Items.Count <= 0)) then
  begin
   Add('  <div class="d2bridgecard-body card-body '+ CSSClassesBody +'">');
   if FTitle <> '' then
    Add('    <h5 class="d2bridgecard-body-title card-title">'+ IfThen(FIsModel, '{{CardModelAtt=Title}}', FTitle) +'</h5>');
   if FSubTitle <> '' then
    Add('    <h6 class="card-subtitle mb-2 text-muted">' + IfThen(FIsModel, '{{CardModelAtt=SubTitle}}', FSubTitle) + '</h6>');
   if FText <> '' then
    Add('    <p class="card-text">' + IfThen(FIsModel, '{{CardModelAtt=Text}}', FText) + '</p>');
   if Items.Items.Count > 0 then
   begin
    BaseClass.RenderD2Bridge(Items.Items);
   end;
   Add('  </div>');
  end;

  if ((not FCardImage.Image.IsEmpty) or (FCardImage.IsImageFromDB)) and
     (FCardImage.Position in [D2BridgeCardImagePositionLeft, D2BridgeCardImagePositionRight]) then
  Add('  </div>');

  if FCardImage.Position = D2BridgeCardImagePositionRight then
  begin
   with BaseClass.HTML.Render.Body do
   begin
    Add('   <div class="' + FCardImage.ColSize + '">');

    if not FCardImage.IsImageFromDB then
    begin
     Add('      <img class="'+ FCSSImage +'" src="' + FCardImage.Image.ImageToSrc + '" style="'+HTMLStyle+'" '+HTMLExtras+'/>');
    end else
    begin
{$IFNDEF FMX}
     BaseClass.RenderD2Bridge(FCardImage.ImageDB);
{$ENDIF}
    end;

    Add('   </div>');
   end;
  end;

 end;


 FPrismControl.AsCard.TitleHeader:= TitleHeader;
 FPrismControl.AsCard.Title:= Title;
 FPrismControl.AsCard.SubTitle:= SubTitle;
 FPrismControl.AsCard.Text:= Text;
end;

procedure TD2BridgeItemHTMLCard.RenderHTML;
begin

end;

procedure TD2BridgeItemHTMLCard.SetBorderColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
begin
 FBorderColor:= Value;
end;

procedure TD2BridgeItemHTMLCard.SetBorderWidth(const Value: integer);
begin
 FBorderWidth:= Value;
end;

procedure TD2BridgeItemHTMLCard.SetCloseFormOnExit(const Value: Boolean);
begin
 (FPrismControl as TPrismCard).CloseFormOnExit:= Value;
end;

procedure TD2BridgeItemHTMLCard.SetColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
begin
 FColor:= Value;
end;

procedure TD2BridgeItemHTMLCard.SetColSize(AColSize: string);
begin
 FColSize:= AColSize;
end;

procedure TD2BridgeItemHTMLCard.SetCSSClassesBody(AValue: string);
begin
 FCSSClassesBody:= AValue;
end;

procedure TD2BridgeItemHTMLCard.SetExitProc(const Value: TProc);
begin
 (FPrismControl as TPrismCard).ExitProc:= Value;
end;

procedure TD2BridgeItemHTMLCard.SetOnExit(const Value: TNotifyEvent);
begin
 (FPrismControl as TPrismCard).OnExit:= Value;
end;

procedure TD2BridgeItemHTMLCard.SetRenderizable(const Value: Boolean);
begin
 FRenderizable:= Value;
end;

procedure TD2BridgeItemHTMLCard.SetSubTitle(ASubTitle: string);
begin
 FSubTitle:= ASubTitle;
end;

procedure TD2BridgeItemHTMLCard.SetText(Value: string);
begin
 FText:= Value;
end;

procedure TD2BridgeItemHTMLCard.SetTextColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
begin
 FTextColor:= Value;
end;

procedure TD2BridgeItemHTMLCard.SetTitle(ATitle: string);
begin
 FTitle:= ATitle;
end;

procedure TD2BridgeItemHTMLCard.SetTitleHeader(Value: string);
begin
 FHeader.Text := Value;
end;

end.
