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

unit D2Bridge.Item.HTML.Badge;

interface

uses
  Classes, SysUtils, Generics.Collections,
{$IFDEF FMX}

{$ELSE}
  StdCtrls, DBCtrls,
{$ENDIF}
{$IFDEF DEVEXPRESS_AVAILABLE}
  cxLabel, cxDBLabel,
{$ENDIF}
  Prism.Interfaces, D2Bridge.ItemCommon,
  D2Bridge.Item, D2Bridge.BaseClass, D2Bridge.Item.VCLObj, D2Bridge.Interfaces;


type
  TD2BridgeItemHTMLBadge = class(TD2BridgeItem, ID2BridgeItemHTMLBadge)
   //events
   procedure BeginReader;
   procedure EndReader;
  private
   //FD2BridgeItems : TD2BridgeItems;
  protected
   FD2BridgeItem: TD2BridgeItem;
  public
   constructor Create(AOwner: TD2BridgeClass); override;
   destructor Destroy; override;

   //Function Items: ID2BridgeAddItems;
   function PrismBadge: IPrismBadge;

//   Procedure AddLabelVCLObj(VCLItem: TObject; CSS: String = ''; HTMLExtras: String = ''; HTMLStyle: String = '');
//   Procedure AddPillLabelVCLObj(VCLItem: TObject; CSS: String = ''; HTMLExtras: String = ''; HTMLStyle: String = '');
//   Procedure AddButtonVCLObj(VCLItem: TObject; CSS: String = ''; HTMLExtras: String = ''; HTMLStyle: String = '');
//   Procedure AddTopLabelVCLObj(VCLItem: TObject; CSS: String = ''; HTMLExtras: String = ''; HTMLStyle: String = '');

   procedure PreProcess; override;
   procedure Render; override;
   procedure RenderHTML; override;

   property BaseClass;
  end;

implementation

uses
  Prism.Forms.Controls, Prism.Badge, D2Bridge.Util, Prism.Forms,
  D2Bridge.Item.VCLObj.Style, D2Bridge.HTML.CSS;


{ TD2BridgeItemHTMLBadge }

procedure TD2BridgeItemHTMLBadge.BeginReader;
begin
 (BaseClass.Form as TPrismForm).AddControl(FPrismControl);
end;

constructor TD2BridgeItemHTMLBadge.Create(AOwner: TD2BridgeClass);
begin
 FD2BridgeItem:= Inherited Create(AOwner);

 //FD2BridgeItems:= TD2BridgeItems.Create(AOwner);

// FPrismControl := TPrismBadge.Create(nil);
// FPrismControl.Name:= ITemID;

 FD2BridgeItem.OnBeginReader:= BeginReader;
 FD2BridgeItem.OnEndReader:= EndReader;
end;

destructor TD2BridgeItemHTMLBadge.Destroy;
begin
 //FreeAndNil(FD2BridgeItems);

 inherited;
end;

procedure TD2BridgeItemHTMLBadge.EndReader;
begin

end;

procedure TD2BridgeItemHTMLBadge.PreProcess;
begin
  inherited;

end;

function TD2BridgeItemHTMLBadge.PrismBadge: IPrismBadge;
begin
 result:= GetPrismControl as IPrismBadge;
end;

procedure TD2BridgeItemHTMLBadge.Render;
begin
  inherited;

end;

procedure TD2BridgeItemHTMLBadge.RenderHTML;
begin
  inherited;

end;

end.