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

unit D2Bridge.Item.HTML.Editor.MarkDown;

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
  TD2BridgeItemHTMLMarkDownEditor = class(TD2BridgeItemHTMLEditor, ID2BridgeItemHTMLMarkDownEditor)
   //events
   procedure BeginReader; override;
   procedure EndReader; override;
  private
   function GetShowButtonPreview: Boolean;
   function GetShowButtonQuote: Boolean;
   function GetShowButtonSplit: Boolean;
   function GetShowButtonUpload: Boolean;
   procedure SetShowButtonPreview(const Value: Boolean);
   procedure SetShowButtonQuote(const Value: Boolean);
   procedure SetShowButtonSplit(const Value: Boolean);
   procedure SetShowButtonUpload(const Value: Boolean);
  public
   constructor Create(AOwner: TD2BridgeClass); override;
   destructor Destroy; override;

   function PrismMarkDownEditor: IPrismMarkDownEditor;

   procedure PreProcess; override;
   procedure Render; override;
   procedure RenderHTML; override;

   property ShowButtonPreview: Boolean read GetShowButtonPreview write SetShowButtonPreview;
   property ShowButtonQuote: Boolean read GetShowButtonQuote write SetShowButtonQuote;
   property ShowButtonSplit: Boolean read GetShowButtonSplit write SetShowButtonSplit;
   property ShowButtonUpload: Boolean read GetShowButtonUpload write SetShowButtonUpload;
  end;

implementation

Uses
 Prism.Editor.MarkDown, Prism.Forms, Prism.Forms.Controls,
 D2Bridge.Util;

{ TD2BridgeItemHTMLMarkDownEditor }

procedure TD2BridgeItemHTMLMarkDownEditor.BeginReader;
begin
 inherited;
end;

constructor TD2BridgeItemHTMLMarkDownEditor.Create(AOwner: TD2BridgeClass);
begin
 Inherited Create(AOwner);

 FPrismControl := TPrismMarkDownEditor.Create(FD2BridgeItem.BaseClass.PrismSession);
 FPrismControl.Name:= ITemID;
 AOwner.PrismControlToRegister.Add(FPrismControl);
end;

destructor TD2BridgeItemHTMLMarkDownEditor.Destroy;
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

procedure TD2BridgeItemHTMLMarkDownEditor.EndReader;
begin

end;

function TD2BridgeItemHTMLMarkDownEditor.GetShowButtonPreview: Boolean;
begin
 result:= PrismMarkDownEditor.ShowButtonPreview;
end;

function TD2BridgeItemHTMLMarkDownEditor.GetShowButtonQuote: Boolean;
begin
 result:= PrismMarkDownEditor.ShowButtonQuote;
end;

function TD2BridgeItemHTMLMarkDownEditor.GetShowButtonSplit: Boolean;
begin
 result:= PrismMarkDownEditor.ShowButtonSplit;
end;

function TD2BridgeItemHTMLMarkDownEditor.GetShowButtonUpload: Boolean;
begin
 result:= PrismMarkDownEditor.ShowButtonUpload;
end;

procedure TD2BridgeItemHTMLMarkDownEditor.PreProcess;
begin
  inherited;

end;

function TD2BridgeItemHTMLMarkDownEditor.PrismMarkDownEditor: IPrismMarkDownEditor;
begin
 result:= GetPrismControl as IPrismMarkDownEditor;
end;

procedure TD2BridgeItemHTMLMarkDownEditor.Render;
begin
 BaseClass.HTML.Render.Body.Add('{%'+TrataHTMLTag(ItemPrefixID+' class="d2bridgemarkdowneditor '+Trim(CSSClasses)+'" style="'+GetHTMLStyle+'" '+ GetHTMLExtras) + '%}');
end;

procedure TD2BridgeItemHTMLMarkDownEditor.RenderHTML;
begin
  inherited;

end;

procedure TD2BridgeItemHTMLMarkDownEditor.SetShowButtonPreview(
  const Value: Boolean);
begin
 PrismMarkDownEditor.ShowButtonPreview:= Value;
end;

procedure TD2BridgeItemHTMLMarkDownEditor.SetShowButtonQuote(
  const Value: Boolean);
begin
 PrismMarkDownEditor.ShowButtonQuote:= Value;
end;

procedure TD2BridgeItemHTMLMarkDownEditor.SetShowButtonSplit(
  const Value: Boolean);
begin
 PrismMarkDownEditor.ShowButtonSplit:= Value;
end;

procedure TD2BridgeItemHTMLMarkDownEditor.SetShowButtonUpload(
  const Value: Boolean);
begin
 PrismMarkDownEditor.ShowButtonUpload:= Value;
end;

end.
