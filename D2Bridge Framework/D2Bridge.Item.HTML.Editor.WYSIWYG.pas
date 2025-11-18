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

unit D2Bridge.Item.HTML.Editor.WYSIWYG;

interface

uses
  Classes, SysUtils, Generics.Collections,
  Prism.Interfaces,
  D2Bridge.Item, D2Bridge.BaseClass, D2Bridge.Item.VCLObj, D2Bridge.Interfaces,
  D2Bridge.Item.HTML.Editor
  {$IFDEF FMX}

  {$ELSE}

  {$ENDIF}
  ;

type
  TD2BridgeItemHTMLWYSIWYGEditor = class(TD2BridgeItemHTMLEditor, ID2BridgeItemHTMLWYSIWYGEditor)
   //events
   procedure BeginReader; override;
   procedure EndReader; override;
  private
   function GetAirMode: Boolean;
   function GetShowButtonColor: Boolean;
   function GetShowButtonFontName: Boolean;
   function GetShowButtonFontSize: Boolean;
   function GetShowButtonHTMLPreview: Boolean;
   function GetShowButtonUnderline: Boolean;
   function GetShowButtonVideo: Boolean;
   procedure SetAirMode(const Value: Boolean);
   procedure SetShowButtonColor(const Value: Boolean);
   procedure SetShowButtonFontName(const Value: Boolean);
   procedure SetShowButtonFontSize(const Value: Boolean);
   procedure SetShowButtonHTMLPreview(const Value: Boolean);
   procedure SetShowButtonUnderline(const Value: Boolean);
   procedure SetShowButtonVideo(const Value: Boolean);
  public
   constructor Create(AOwner: TD2BridgeClass); override;
   destructor Destroy; override;

   function PrismWYSIWYGEditor: IPrismWYSIWYGEditor;

   procedure PreProcess; override;
   procedure Render; override;
   procedure RenderHTML; override;

   property AirMode: Boolean read GetAirMode write SetAirMode;
   property ShowButtonColor: Boolean read GetShowButtonColor write SetShowButtonColor;
   property ShowButtonFontName: Boolean read GetShowButtonFontName write SetShowButtonFontName;
   property ShowButtonFontSize: Boolean read GetShowButtonFontSize write SetShowButtonFontSize;
   property ShowButtonHTMLPreview: Boolean read GetShowButtonHTMLPreview write SetShowButtonHTMLPreview;
   property ShowButtonUnderline: Boolean read GetShowButtonUnderline write SetShowButtonUnderline;
   property ShowButtonVideo: Boolean read GetShowButtonVideo write SetShowButtonVideo;
  end;


implementation

Uses
 Prism.Editor.WYSIWYG, Prism.Forms.Controls,
 D2Bridge.Util;

{ TD2BridgeItemHTMLWYSIWYGEditor }

procedure TD2BridgeItemHTMLWYSIWYGEditor.BeginReader;
begin
 inherited;
end;

constructor TD2BridgeItemHTMLWYSIWYGEditor.Create(AOwner: TD2BridgeClass);
begin
 Inherited Create(AOwner);

 FPrismControl := TPrismWYSIWYGEditor.Create(FD2BridgeItem.BaseClass.PrismSession);
 FPrismControl.Name:= ITemID;
 AOwner.PrismControlToRegister.Add(FPrismControl);
end;

destructor TD2BridgeItemHTMLWYSIWYGEditor.Destroy;
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

procedure TD2BridgeItemHTMLWYSIWYGEditor.EndReader;
begin
 inherited;
end;

function TD2BridgeItemHTMLWYSIWYGEditor.GetAirMode: Boolean;
begin
 result:= PrismWYSIWYGEditor.AirMode;
end;

function TD2BridgeItemHTMLWYSIWYGEditor.GetShowButtonColor: Boolean;
begin
 result:= PrismWYSIWYGEditor.ShowButtonColor;
end;

function TD2BridgeItemHTMLWYSIWYGEditor.GetShowButtonFontName: Boolean;
begin
 result:= PrismWYSIWYGEditor.ShowButtonFontName;
end;

function TD2BridgeItemHTMLWYSIWYGEditor.GetShowButtonFontSize: Boolean;
begin
 result:= PrismWYSIWYGEditor.ShowButtonFontSize;
end;

function TD2BridgeItemHTMLWYSIWYGEditor.GetShowButtonHTMLPreview: Boolean;
begin
 result:= PrismWYSIWYGEditor.ShowButtonHTMLPreview;
end;

function TD2BridgeItemHTMLWYSIWYGEditor.GetShowButtonUnderline: Boolean;
begin
 result:= PrismWYSIWYGEditor.ShowButtonUnderline;
end;

function TD2BridgeItemHTMLWYSIWYGEditor.GetShowButtonVideo: Boolean;
begin
 result:= PrismWYSIWYGEditor.ShowButtonVideo;
end;

procedure TD2BridgeItemHTMLWYSIWYGEditor.PreProcess;
begin
  inherited;

end;

function TD2BridgeItemHTMLWYSIWYGEditor.PrismWYSIWYGEditor: IPrismWYSIWYGEditor;
begin
 result:= GetPrismControl as IPrismWYSIWYGEditor;
end;

procedure TD2BridgeItemHTMLWYSIWYGEditor.Render;
begin
 BaseClass.HTML.Render.Body.Add('{%'+TrataHTMLTag(ItemPrefixID+' class="d2bridgewysiwygeditor '+Trim(CSSClasses)+'" style="'+GetHTMLStyle+'" '+ GetHTMLExtras) + '%}');
end;

procedure TD2BridgeItemHTMLWYSIWYGEditor.RenderHTML;
begin
  inherited;

end;


procedure TD2BridgeItemHTMLWYSIWYGEditor.SetAirMode(const Value: Boolean);
begin
 PrismWYSIWYGEditor.AirMode:= true;
end;

procedure TD2BridgeItemHTMLWYSIWYGEditor.SetShowButtonColor(const Value: Boolean);
begin
 PrismWYSIWYGEditor.ShowButtonColor:= Value;
end;

procedure TD2BridgeItemHTMLWYSIWYGEditor.SetShowButtonFontName(const Value: Boolean);
begin
 PrismWYSIWYGEditor.ShowButtonFontName:= Value;
end;

procedure TD2BridgeItemHTMLWYSIWYGEditor.SetShowButtonFontSize(const Value: Boolean);
begin
 PrismWYSIWYGEditor.ShowButtonFontSize:= Value;
end;

procedure TD2BridgeItemHTMLWYSIWYGEditor.SetShowButtonHTMLPreview(const Value: Boolean);
begin
 PrismWYSIWYGEditor.ShowButtonHTMLPreview:= Value;
end;

procedure TD2BridgeItemHTMLWYSIWYGEditor.SetShowButtonUnderline(const Value: Boolean);
begin
 PrismWYSIWYGEditor.ShowButtonUnderline:= Value;
end;

procedure TD2BridgeItemHTMLWYSIWYGEditor.SetShowButtonVideo(const Value: Boolean);
begin
 PrismWYSIWYGEditor.ShowButtonVideo:= Value;
end;

end.
