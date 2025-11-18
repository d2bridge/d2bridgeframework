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

unit D2Bridge.Item;

interface

uses
  Classes, Generics.Collections,
  D2Bridge.BaseClass, Prism.Interfaces, D2Bridge.Interfaces;


type
  TD2BridgeItem = class;

  TReaderNotify = procedure of object;
  TReaderGetValueNotify =  procedure(const AD2BridgeItem: TD2BridgeItem; var Value: string) of object;

  TD2BridgeHTMLTag = class(TInterfacedPersistent, ID2BridgeHTMLTag)
  private
   FCSSClass: String;
   FHtmlExtas: String;
   FHtmlStyle: String;
  protected
   function GetCSSClass: string; virtual;
   procedure SetCSSClass(Value: string); virtual;
   function GetHTMLExtras: string; virtual;
   procedure SetHTMLExtras(Value: string); virtual;
   function GetHTMLStyle: string; virtual;
   procedure SetHTMLStyle(Value: string); virtual;
  published
   property CSSClasses: string read GetCSSClass write SetCSSClass;
   property HTMLExtras: string read GetHTMLExtras write SetHTMLExtras;
   property HTMLStyle: string read GetHTMLStyle write SetHTMLStyle;
  public
   constructor Create;
   destructor Destroy; override;
  end;


  TD2BridgeItem = class(TD2BridgeHTMLTag, ID2BridgeItem)
  private
   FBaseClass: TD2BridgeClass;
   FOnBeginReader: TReaderNotify;
   FOnEndReader: TReaderNotify;
   FItemID: String;
   FRenderized: Boolean;
   FOnGetCSSClass: TReaderGetValueNotify;
   FOwner: ID2BridgeItem;
   FHTMLItems: TStrings;
   function GetCSSClass: string; override;
{$IFDEF FPC}
  protected
{$ENDIF}
   function GetOwner: ID2BridgeItem;
   procedure SetOwner(Value: ID2BridgeItem);
  protected
   FPrismControl: IPrismControl;
   function GetItemID: String; virtual;
   procedure SetItemID(AItemID: String); virtual;
   Function GetItemPrefixID: String; virtual;
   function GetPrismControl: IPrismControl; virtual;
   procedure SetPrismControl(AValue: IPrismControl); virtual;
   procedure SetRenderized(Value: boolean); virtual;
   function GetRenderized: Boolean; virtual;
   procedure DoBeginReader; virtual;
   procedure DoEndReader; virtual;

  public
   constructor Create(AOwner: TD2BridgeClass); virtual;
   destructor Destroy; override;

   function HTMLItems: TStrings;

   procedure PreProcess; virtual; abstract;
   procedure Render; virtual; abstract;
   procedure RenderHTML; virtual; abstract;
  published
   property Renderized: boolean read GetRenderized Write SetRenderized;
   property BaseClass: TD2BridgeClass read FBaseClass; //: TD2BridgeClass read FBaseClass;
   property ItemID: string read GetItemID write SetItemID;
   property ItemPrefixID: string read GetItemPrefixID;
   property PrismControl: IPrismControl read GetPrismControl write SetPrismControl;
   property OnBeginReader: TReaderNotify read FOnBeginReader write FOnBeginReader;
   property OnEndReader: TReaderNotify read FOnEndReader write FOnEndReader;
   property OnGetCSSClass: TReaderGetValueNotify read FOnGetCSSClass write FOnGetCSSClass;
   property Owner: ID2BridgeItem read GetOwner write SetOwner;
  end;



implementation

uses
  Variants, Prism.Forms, Prism.Util, Prism.ControlGeneric, Prism.Forms.Controls,
  D2Bridge.Forms;

{ TD2BridgeItem }

destructor TD2BridgeItem.Destroy;
begin
 FHTMLItems.Free;

 if Assigned(FPrismControl) then
 begin
  if (FPrismControl as TPrismControl).D2BridgeItem = (self as ID2BridgeItem) then
   (FPrismControl as TPrismControl).D2BridgeItem:= nil;

  FPrismControl:= nil;
 end;

 if Assigned(FOwner) then
  FOwner:= nil;

 inherited;
end;

procedure TD2BridgeItem.DoBeginReader;
begin
 if Assigned(FPrismControl) then
 begin
  if FPrismControl.IsControl then
  begin
   //Visible
   if (not FPrismControl.Visible) then
    if Pos('display: none', FHTMLStyle) <= 0 then
     FHTMLStyle:= HTMLAddItemFromTag(FHTMLStyle, '', 'display: none;');

   //Enabled
   if not FPrismControl.Enabled then
    if Pos('disabled', FHtmlExtas) <= 0 then
     FHtmlExtas:= HTMLAddItemFromTag(FHtmlExtas, '', 'disabled');

   //ReadOnly
   if FPrismControl.ReadOnly then
    if Pos('readonly', FHtmlExtas) <= 0 then
     FHtmlExtas:= HTMLAddItemFromTag(FHtmlExtas, '', 'readonly');

   //Required
   if FPrismControl.Required then
    if Pos('required', FHtmlExtas) <= 0 then
     FHtmlExtas:= HTMLAddItemFromTag(FHtmlExtas, '', 'required');

   //Validation Group
   if not VarIsEmpty(FPrismControl.ValidationGroup) then
    if Pos('validationgroup', FHtmlExtas) <= 0 then
     FHtmlExtas:= HTMLAddItemFromTag(FHtmlExtas, '', 'validationgroup="'+VarToStr(FPrismControl.ValidationGroup)+'"');

   //PlaceHolder
   if FPrismControl.Placeholder <> '' then
    if Pos('placeholder', FHtmlExtas) <= 0 then
     FHtmlExtas:= HTMLAddItemFromTag(FHtmlExtas, '', 'placeholder="' + FPrismControl.Placeholder + '"');
  end;
 end;


 if Assigned(FOnBeginReader) then
  FOnBeginReader;
end;

constructor TD2BridgeItem.Create(AOwner: TD2BridgeClass);
begin
 inherited Create;

 //inherited Create;
 //Self.AOwner := AOwner;
 FRenderized:= false;
 FBaseClass:= AOwner;
 FHTMLItems:= TStringList.Create;
end;

procedure TD2BridgeItem.DoEndReader;
begin
 if Assigned(FOnEndReader) then
  FOnEndReader;
end;

function TD2BridgeItem.GetCSSClass: string;
begin
 result:= Inherited;

 if Assigned(FOnGetCSSClass) then
  FOnGetCSSClass(self, result);
end;

function TD2BridgeItem.GetItemID: String;
begin
 Result:= FItemID;
end;

function TD2BridgeItem.GetItemPrefixID: String;
begin
 if (BaseClass.Prefix <> '') and (BaseClass.EnableControlsPrefix) then
  Result:= BaseClass.Prefix+'_'+ItemID
 else
  Result:= ItemID;
end;

function TD2BridgeItem.GetOwner: ID2BridgeItem;
begin
 Result:= FOwner;
end;

function TD2BridgeItem.GetPrismControl: IPrismControl;
begin
 Result:= FPrismControl;
end;

function TD2BridgeItem.GetRenderized: Boolean;
begin
 Result:= FRenderized;
end;

function TD2BridgeItem.HTMLItems: TStrings;
begin
 Result:= FHTMLItems;
end;

procedure TD2BridgeItem.SetItemID(AItemID: String);
begin
 FItemID:= AItemID;
 if Assigned(FPrismControl) then
  FPrismControl.Name:= FItemID;
end;

procedure TD2BridgeItem.SetOwner(Value: ID2BridgeItem);
begin
 FOwner:= Value;
end;

procedure TD2BridgeItem.SetPrismControl(AValue: IPrismControl);
begin
 FPrismControl:= AValue;
end;

procedure TD2BridgeItem.SetRenderized(Value: boolean);
begin
 FRenderized:= Value;

 if Value then
 begin
  //Check PrismControl
  if not Assigned(FPrismControl) then
   FPrismControl:= TPrismControlGeneric.Create(FBaseClass.FrameworkForm as TPrismForm)
  else
  if not Assigned(FPrismControl.Form) then
  begin
   FPrismControl.Form:= (FBaseClass.FrameworkForm as TPrismForm);
   FPrismControl.Form.Controls.Add(FPrismControl);
   //(FBaseClass.FrameworkForm as TPrismForm).Controls.Add(FPrismControl);
  end;
 end;
end;

{ TD2BridgeHTMLTag }

constructor TD2BridgeHTMLTag.Create;
begin
 inherited;

 FCSSClass:= '';
 FHtmlExtas:= '';
 FHtmlStyle:= '';
end;

destructor TD2BridgeHTMLTag.Destroy;
begin

 inherited;
end;

function TD2BridgeHTMLTag.GetCSSClass: string;
begin
 result:= FCSSClass;
end;

function TD2BridgeHTMLTag.GetHTMLExtras: string;
begin
 result:= FHtmlExtas;
end;

function TD2BridgeHTMLTag.GetHTMLStyle: string;
begin
 result:= FHtmlStyle;
end;

procedure TD2BridgeHTMLTag.SetCSSClass(Value: string);
begin
 FCSSClass:= Value;
end;

procedure TD2BridgeHTMLTag.SetHTMLExtras(Value: string);
begin
 FHtmlExtas:= Value;
end;

procedure TD2BridgeHTMLTag.SetHTMLStyle(Value: string);
begin
 FHtmlStyle:= Value;
end;

end.

