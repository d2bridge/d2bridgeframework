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
    Natanael Ribeiro
    natan_ribeiro_ferreira@hotmail.com
 +--------------------------------------------------------------------------+
}

{$I ..\D2Bridge.inc}

unit D2Bridge.VCLObj.TcxLabel;


interface

{$IFDEF DEVEXPRESS_AVAILABLE}
uses
  Classes, Graphics,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTcxLabel = class(TD2BridgeItemVCLObjCore)
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
  StdCtrls, Controls, Prism.Util, D2Bridge.Util, cxLabel, Forms, D2Bridge.Item.VCLObj.Style,
  D2Bridge.VCLObj.ApplyStyle;

{ TVCLObjTcxLabel }


function TVCLObjTcxLabel.CSSClass: String;
begin
 result:= 'form-control-plaintext';
end;

function TVCLObjTcxLabel.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Text;
end;

procedure TVCLObjTcxLabel.ProcessEventClass;
begin
 if Assigned(TcxLabel(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:=
    procedure(EventParams: TStrings)
    begin
     TcxLabel(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
    end;
end;

procedure TVCLObjTcxLabel.ProcessPropertyClass(NewObj: TObject);
begin
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Text.GetEnabled:=
    function: Variant
    begin
     Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Text.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TcxLabel(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Text.GetVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Text.SetVisible:=
    procedure(AValue: Variant)
    begin
     TcxLabel(FD2BridgeItemVCLObj.Item).Visible:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Text.OnGetText:=
    function: Variant
    begin
     Result:= TcxLabel(FD2BridgeItemVCLObj.Item).Caption;
    end;
end;

function TVCLObjTcxLabel.VCLClass: TClass;
begin
 Result:= TcxLabel;
end;

procedure TVCLObjTcxLabel.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 TVCLObjTcxLabelApplyStyle(TcxLabel(FD2BridgeItemVCLObj.Item), VCLObjStyle);
end;


{$ELSE}
implementation
{$ENDIF}

end.