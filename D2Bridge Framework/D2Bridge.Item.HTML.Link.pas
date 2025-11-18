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

unit D2Bridge.Item.HTML.Link;

interface

uses
  Classes, SysUtils, Generics.Collections,
{$IFDEF FMX}
  FMX.StdCtrls, FMX.Edit, FMX.Memo, FMX.Types,
{$ELSE}
  StdCtrls, DBCtrls,
{$ENDIF}
{$IFDEF DEVEXPRESS_AVAILABLE}
  cxTextEdit, cxMemo, cxLabel, cxDBEdit, cxDBLabel,
{$ENDIF}
  Prism.Interfaces, D2Bridge.ItemCommon,
  D2Bridge.Item, D2Bridge.BaseClass, D2Bridge.Item.VCLObj, D2Bridge.Interfaces;

type
  TD2BridgeItemHTMLLink = class(TD2BridgeItem, ID2BridgeItemHTMLLink)
   //events
   procedure BeginReader;
   procedure EndReader;
  private
   FD2BridgeItem: TD2BridgeItem;
   FD2BridgeItems : TD2BridgeItems;
  public
   constructor Create(AOwner: TD2BridgeClass); override;
   destructor Destroy; override;

   Function Items: ID2BridgeAddItems;
   function PrismLink: IPrismLink;

   procedure PreProcess; override;
   procedure Render; override;
   procedure RenderHTML; override;

   property BaseClass;
  end;

implementation

uses
  Prism.Forms.Controls, Prism.Link, D2Bridge.Util, Prism.Forms,
  D2Bridge.Item.VCLObj.Style, D2Bridge.HTML.CSS;

{ TD2BridgeItemHTMLLink }

constructor TD2BridgeItemHTMLLink.Create(AOwner: TD2BridgeClass);
begin
 FD2BridgeItem:= Inherited Create(AOwner);

 FD2BridgeItems:= TD2BridgeItems.Create(AOwner);

 FPrismControl := TPrismLink.Create(nil);
 FPrismControl.Name:= ITemID;

 FD2BridgeItem.OnBeginReader:= BeginReader;
 FD2BridgeItem.OnEndReader:= EndReader;
end;

destructor TD2BridgeItemHTMLLink.Destroy;
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

 FreeAndNil(FD2BridgeItems);

 inherited;
end;


procedure TD2BridgeItemHTMLLink.BeginReader;
begin
 (BaseClass.Form as TPrismForm).AddControl(FPrismControl);
end;

procedure TD2BridgeItemHTMLLink.EndReader;
begin

end;

function TD2BridgeItemHTMLLink.Items: ID2BridgeAddItems;
begin
 result:= FD2BridgeItems;
end;

procedure TD2BridgeItemHTMLLink.PreProcess;
begin

end;

function TD2BridgeItemHTMLLink.PrismLink: IPrismLink;
begin
 result:= GetPrismControl as IPrismLink;
end;

procedure TD2BridgeItemHTMLLink.Render;
var
 HTMLText: String;
 vClickCallBack: string;
 vText: string;
 vhref: string;
 vHint: string;
 vAlignment: {$IFNDEF FMX}TAlignment{$ELSE}TTextAlign{$ENDIF};
begin
 vText:= PrismLink.Text;
 vhref:= PrismLink.href;
 vHint:= PrismLink.Hint;
 vClickCallBack:= PrismLink.OnClickCallBack;
 vAlignment:= D2Bridge.Item.VCLObj.Style.taNone;

 {$REGION 'Alignment'}
 if Assigned(PrismLink.LabelHTMLElement) then
  if BaseClass.VCLStyles then
  begin
   if (PrismLink.LabelHTMLElement is TLabel) //Label's
 {$IFDEF DEVEXPRESS_AVAILABLE}
    or (PrismLink.LabelHTMLElement is TcxLabel)
    or (PrismLink.LabelHTMLElement is TcxDBLabel)
 {$ENDIF}
 {$IFNDEF FMX} or (PrismLink.LabelHTMLElement is TDBText){$ENDIF} then
    vAlignment:= TLabel(PrismLink.LabelHTMLElement).{$IFNDEF FMX}Alignment{$ELSE}TextSettings.HorzAlign{$ENDIF}
   else
   if (PrismLink.LabelHTMLElement is TEdit) //Edit's
 {$IFDEF DEVEXPRESS_AVAILABLE}
    or (PrismLink.LabelHTMLElement is TcxTextEdit)
    or (PrismLink.LabelHTMLElement is TcxDBTextEdit)
 {$ENDIF}
 {$IFNDEF FMX} or (PrismLink.LabelHTMLElement is TDBEdit){$ENDIF} then
    vAlignment:= TEdit(PrismLink.LabelHTMLElement).{$IFNDEF FMX}Alignment{$ELSE}TextSettings.HorzAlign{$ENDIF}
   else
   if (PrismLink.LabelHTMLElement is TMemo) //Memo's
 {$IFDEF DEVEXPRESS_AVAILABLE}
    or (PrismLink.LabelHTMLElement is TcxMemo)
    or (PrismLink.LabelHTMLElement is TcxDBMemo)
 {$ENDIF}
 {$IFNDEF FMX} or (PrismLink.LabelHTMLElement is TDBMemo){$ENDIF} then
    vAlignment:= TMemo(PrismLink.LabelHTMLElement).{$IFNDEF FMX}Alignment{$ELSE}TextSettings.HorzAlign{$ENDIF};


   if vAlignment <> D2Bridge.Item.VCLObj.Style.taNone then
   begin
    if vAlignment = AlignmentLeft then
     CSSClasses:= CSSClasses + ' ' + TCSSClassText.Align.left;

    if vAlignment = AlignmentRight then
     CSSClasses:= CSSClasses + ' ' + TCSSClassText.Align.right;

    if vAlignment = AlignmentCenter then
     CSSClasses:= CSSClasses + ' ' + TCSSClassText.Align.center;
   end;
  end;
 {$ENDREGION}


 if vClickCallBack <> '' then
 begin
  if Pos('{{', vClickCallBack) <= 0 then
  begin
   if Pos('CallBack=', vClickCallBack) <= 0 then
    vClickCallBack:= 'CallBack=' + vClickCallBack;

   vClickCallBack:= '{{' + vClickCallBack + '}}';
  end;
 end else
 if (vhref = '') or
    (vhref = '#') then
  vClickCallBack:= TRIM('return false;');

 if vClickCallBack <> '' then
 begin
  HTMLText:=
    '<a '+
    TrataHTMLTag('class="d2bridgelink '+Trim(CSSClasses)+'" style="'+HTMLStyle+'" '+HTMLExtras)+
    ' id="'+AnsiUpperCase(ItemPrefixID)+'"'+
    ' href="'+ vhref + '"'+
    ' title="'+ vHint + '"'+
    ' onclick="' + PrismLink.Form.ProcessAllTagHTML(vClickCallBack) + '"' +
    '>';
 end else
 begin
  HTMLText:=
      '<a '+
      TrataHTMLTag('class="d2bridgelink '+Trim(CSSClasses)+'" style="'+HTMLStyle+'" '+HTMLExtras)+
      ' id="'+AnsiUpperCase(ItemPrefixID)+'"'+
      ' href="'+ vhref + '"'+
      ' title="'+ vHint + '"'+
      '>';
 end;

 if (vText = '') and (Items.Items.Count > 0) then
 begin
  HTMLText:= HTMLText +
   '<span id="'+AnsiUpperCase(ItemPrefixID)+'text" class="link-primary d2bridgelinktext">'+vText+'</span>';
 end else
  HTMLText:= HTMLText +
   '<span id="'+AnsiUpperCase(ItemPrefixID)+'text" class="link-primary form-control-plaintext d2bridgelinktext">'+vText+'</span>';

 BaseClass.HTML.Render.Body.Add(HTMLText);

 if Items.Items.Count > 0 then
 begin
  BaseClass.RenderD2Bridge(Items.Items);
 end;

 BaseClass.HTML.Render.Body.Add('</a>');


 (PrismLink as TPrismLink).FStoredText:= vText;
 (PrismLink as TPrismLink).FStoredhref:= vhref;
 (PrismLink as TPrismLink).FStoredHint:= vHint;
 (PrismLink as TPrismLink).FStoredOnClickCallBack:= vClickCallBack;

// HTMLControl := '<a class="d2bridgelink" id="' + AnsiUpperCase(NamePrefix) + '" href="'+ Fhref +'" title="'+ FHint +'" onclick="' + Form.ProcessAllTagHTML(FOnClickCallBack) + '">' + Form.ProcessAllTagHTML(FText) + '</a>';
end;

procedure TD2BridgeItemHTMLLink.RenderHTML;
begin

end;


end.