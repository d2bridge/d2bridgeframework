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
  Thank for contribution to this Unit to:
    Edvanio Jancy
    edvanio@ideiasistemas.com.br
 +--------------------------------------------------------------------------+
}

{$I D2Bridge.inc}

unit D2Bridge.VCLObj.TImage;

interface

uses
  Classes,
{$IFDEF FMX}
  FMX.Objects,
{$ELSE}
  ExtCtrls, Graphics,
{$ENDIF}
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTImage = class(TD2BridgeItemVCLObjCore)
  private
   procedure TImageOnClick(EventParams: TStrings);
   procedure TImageOnDblClick(EventParams: TStrings);
   function TImageGetVisible: Variant;
   procedure TImageSetVisible(AValue: Variant);
  public
   function VCLClass: TClass; override;
   function CSSClass: String; override;
   Procedure VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle); override;
   procedure ProcessPropertyClass(NewObj: TObject); override;
   procedure ProcessEventClass; override;
   function FrameworkItemClass: ID2BridgeFrameworkItem; override;
 end;

implementation

uses
  Prism.Util, D2Bridge.Util;


{ TVCLObjTImage }


function TVCLObjTImage.CSSClass: String;
begin
  result := 'rounded float-left img-fluid';
end;

function TVCLObjTImage.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
  Result := FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Image;
end;

procedure TVCLObjTImage.TImageOnClick(EventParams: TStrings);
begin
  TImage(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTImage.TImageOnDblClick(EventParams: TStrings);
begin
  TImage(FD2BridgeItemVCLObj.Item).OnDblClick(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTImage.ProcessEventClass;
begin
 if Assigned(TImage(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:= TImageOnClick;

 if Assigned(TImage(FD2BridgeItemVCLObj.Item).OnDblClick) then
 FrameworkItemClass.OnDblClick:= TImageOnDblClick;
end;

function TVCLObjTImage.TImageGetVisible: Variant;
begin
  Result := GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
end;

procedure TVCLObjTImage.TImageSetVisible(AValue: Variant);
begin
  TImage(FD2BridgeItemVCLObj.Item).Visible := AValue;
end;

procedure TVCLObjTImage.ProcessPropertyClass(NewObj: TObject);
begin
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Image.Picture := TImage(FD2BridgeItemVCLObj.Item).{$IFNDEF FMX}Picture{$ELSE}Bitmap{$ENDIF};

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Image.GetVisible:= TImageGetVisible;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Image.SetVisible:= TImageSetVisible;
end;

function TVCLObjTImage.VCLClass: TClass;
begin
  Result:= TImage;
end;

procedure TVCLObjTImage.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin

end;

end.