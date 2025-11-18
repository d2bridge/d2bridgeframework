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

unit D2Bridge.Item.HTML.FormGroup;

interface

uses
  Classes, SysUtils, Generics.Collections,
{$IFDEF FMX}
  FMX.Menus, FMX.Controls, FMX.StdCtrls,
{$ELSE}
  Menus, Controls, StdCtrls,
{$ENDIF}
  Prism.Interfaces,
  D2Bridge.Item, D2Bridge.BaseClass, D2Bridge.Interfaces, D2Bridge.ItemCommon;

type

  { TD2BridgeItemHTMLFormGroup }

  TD2BridgeItemHTMLFormGroup = class(TD2BridgeItem, ID2BridgeItemHTMLFormGroup)
    //events
    procedure BeginReader;
    procedure EndReader;
   private
    FD2BridgeItem: TD2BridgeItem;
    FD2BridgeItems : TD2BridgeItems;
    FLabelItems: TD2BridgeItems;
    FCSS_DIV: String;
    FCSS_ObjVCL: String;
    FColSize1: string;
    FColSize2: string;
    FItem: ID2BridgeItemVCLObj;
    FItemLabel: ID2BridgeItemVCLObj;
    FLink: ID2BridgeItemHTMLLink;
    FLabel: TComponent;
    FTextLabel: String;
    FInLine: Boolean;
    FRequired: Boolean;
    function GetLabelComponent: TComponent;
    procedure SetLabelComponent(ALabel: TComponent);
    function GetTextLabel: string;
    procedure SetTextLabel(ATextLabel: string);
    procedure SetColSize1(AColSize: string);
    function GetColSize1: string;
    procedure SetColSize2(AColSize: string);
    function GetColSize2: string;
    procedure SetInLine(Value: Boolean);
    function GetInLine: Boolean;
   public
    constructor Create(AOwner: TD2BridgeClass); override;
    destructor Destroy; override;

    Procedure AddVCLObj(VCLItem: TObject; CSS: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''); overload;
    procedure AddVCLObj(VCLItem: TObject; AValidationGroup: Variant; ARequired: Boolean = false; CSS: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''); overload;
    Procedure AddVCLObj(VCLItem: TObject; APopupMenu: TPopupMenu; CSS: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''); overload;
    Procedure AddVCLObjWithLabel(VCLItem: TObject; ATextLabel: string; CSS: String = ''; HTMLExtras: String = ''; HTMLStyle: String = '');
    procedure AddVCLObjLink(VCLItem: TComponent; Href: string = '#'; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = '');
    Procedure AddLabelVCLObj(VCLItem: TObject; CSS: String = ''; HTMLExtras: String = ''; HTMLStyle: String = '');

{$IFDEF FPC}
    Procedure AddLCLObj(VCLItem: TObject; CSS: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''); overload;
    procedure AddLCLObjLink(VCLItem: TComponent; Href: string = '#'; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = '');
    procedure AddLCLObj(VCLItem: TObject; AValidationGroup: Variant; ARequired: Boolean; CSS: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''); overload;
    Procedure AddLCLObj(VCLItem: TObject; APopupMenu: TPopupMenu; CSS: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''); overload;
    Procedure AddLCLObjWithLabel(VCLItem: TObject; ATextLabel: string; CSS: String = ''; HTMLExtras: String = ''; HTMLStyle: String = '');
    Procedure AddLabelLCLObj(VCLItem: TObject; CSS: String = ''; HTMLExtras: String = ''; HTMLStyle: String = '');
{$ENDIF}

    function Items: ID2BridgeAddItems;

    procedure PreProcess; override;
    procedure Render; override;
    procedure RenderHTML; override;

    property BaseClass;
    property HTMLInLine: Boolean read FInLine write FInLine default false;
    property TextLabel: string read GetTextLabel write SetTextLabel;
    property ColSize1: string read GetColSize1 write SetColSize1;
    property ColSize2: string read GetColSize2 write SetColSize2;

    property LabelComponent: TComponent read GetLabelComponent write SetLabelComponent;
  end;

Const
 TAG_FormGroup = 'div';
 TAG_Div = 'div';
 Class_FormGroup_Default = 'form-group %s'; //form-group + CSS
 Class_FormGroup_Inline = 'form-group flex-nowrap %s'; //form-group flex-nowrap + CSS
 Class_DIV_Default = '%s %s %s align-self-end'; //col-xl-4 col-md-6 + CSS
 Class_DIV_Inline = '%s %s mb-2 %s'; //col-xl-4 col-md-6 mb-2 + CSS
 Style_Label_InLine = 'padding-right: 5px;'; //padding-right: 5px;
 Class_Input_Inline = '%s col'; //form-control col

implementation

uses
  Prism.Forms.Controls,
  D2Bridge.Render, D2Bridge.Util, D2Bridge.VCLObj.Override, D2Bridge.Item.VCLObj, Prism.ControlGeneric,
  D2Bridge.Item.HTML.Link, D2Bridge.Item.VCLObj.Style, D2Bridge.VCLObj.ApplyStyle;


{ TD2BridgeItemHTMLFormGroup }


constructor TD2BridgeItemHTMLFormGroup.Create(AOwner: TD2BridgeClass);
begin
 FD2BridgeItem:= Inherited Create(AOwner);
 FInLine:= false;
 FColSize1:= 'col-xl-auto';
 //FColSize2:= 'col-md-6';

 FD2BridgeItem.OnBeginReader:= BeginReader;
 FD2BridgeItem.OnEndReader:= EndReader;

 FPrismControl:= TPrismControlGeneric.Create(nil);

 FD2BridgeItems:= TD2BridgeItems.Create(AOwner);

 FLabelItems:= TD2BridgeItems.Create(AOwner);
end;


destructor TD2BridgeItemHTMLFormGroup.Destroy;
var
 vItemLabel: TD2BridgeItemVCLObj;
 vItem: TD2BridgeItemVCLObj;
 vLink: TD2BridgeItemHTMLLink;
 vPrismControl: TPrismControl;
begin
// if Assigned(FPrismControl) then
// begin
//  (FPrismControl as TPrismControlGeneric).Destroy;
// end;

 if Assigned(FItemLabel) then
 begin
  vItemLabel:= FItemLabel as TD2BridgeItemVCLObj;
  FItemLabel:= nil;
  vItemLabel.Free;
 end;

 if Assigned(FItem) then
 begin
  vItem:= FItem as TD2BridgeItemVCLObj;
  FItem:= nil;
  vItem.Free;
 end;

 if Assigned(FLink) then
 begin
  vLink:= FLink as TD2BridgeItemHTMLLink;
  FLink:= nil;
  vLink.Free;
 end;

 FreeAndNil(FD2BridgeItems);
 FreeAndNil(FLabelItems);

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


function TD2BridgeItemHTMLFormGroup.GetColSize1: string;
begin
 result:= FColSize1;
end;

function TD2BridgeItemHTMLFormGroup.GetColSize2: string;
begin
 result:= FColSize2;
end;

function TD2BridgeItemHTMLFormGroup.GetLabelComponent: TComponent;
begin
 result:= FLabel;
end;

function TD2BridgeItemHTMLFormGroup.GetInLine: Boolean;
begin
 Result:= FInLine;
end;

function TD2BridgeItemHTMLFormGroup.GetTextLabel: string;
begin
 result:= FTextLabel;

 if Result <> '' then
  if FRequired then
   result:= result + ' *';
end;


function TD2BridgeItemHTMLFormGroup.Items: ID2BridgeAddItems;
begin
 Result:= FD2BridgeItems;
end;

procedure TD2BridgeItemHTMLFormGroup.AddLabelVCLObj(VCLItem: TObject;
  CSS: String; HTMLExtras: String; HTMLStyle: String);
begin
 if not BaseClass.D2BridgeManager.SupportsVCLClass(VCLItem.ClassType) then
  Exit;

 FItemLabel := TD2BridgeItemVCLObj.Create(BaseClass);
 FItemLabel.Item:= TComponent(VCLItem);
 FItemLabel.CSSClasses:= CSS;
 FItemLabel.HTMLExtras:= HTMLExtras;
 if Assigned(FItem) and Assigned(FItem.Item) then
 FItemLabel.HTMLExtras:= FItemLabel.HTMLExtras+ ' for="'+ AnsiUpperCase(FItem.Item.Name) +'"';
 FItemLabel.HTMLStyle:= HTMLStyle;
 if FInLine then
 FItem.HTMLStyle:= FItem.HTMLStyle+ ' ' + Style_Label_InLine;
end;

{$IFDEF FPC}
procedure TD2BridgeItemHTMLFormGroup.AddLCLObj(VCLItem: TObject; CSS: String;
  HTMLExtras: String; HTMLStyle: String);
begin
 AddVCLObj(VCLItem, CSS, HTMLExtras, HTMLStyle);
end;

procedure TD2BridgeItemHTMLFormGroup.AddLCLObjLink(VCLItem: TComponent; Href: string; ACSSClass: String; AHTMLExtras: String; AHTMLStyle: String);
begin
  AddVCLObjLink(VCLItem, Href, ACSSClass, AHTMLExtras, AHTMLStyle);
end;

procedure TD2BridgeItemHTMLFormGroup.AddLCLObj(VCLItem: TObject;
  AValidationGroup: Variant; ARequired: Boolean; CSS: String;
  HTMLExtras: String; HTMLStyle: String);
begin
 AddVCLObj(VCLItem, AValidationGroup, ARequired, CSS, HTMLExtras, HTMLStyle);
end;

procedure TD2BridgeItemHTMLFormGroup.AddLCLObj(VCLItem: TObject;
  APopupMenu: TPopupMenu; CSS: String; HTMLExtras: String; HTMLStyle: String);
begin
 AddVCLObj(VCLItem, APopupMenu, CSS, HTMLExtras, HTMLStyle);
end;

procedure TD2BridgeItemHTMLFormGroup.AddLCLObjWithLabel(VCLItem: TObject;
  ATextLabel: string; CSS: String; HTMLExtras: String; HTMLStyle: String);
begin
  AddVCLObjWithLabel(VCLItem, ATextLabel, CSS, HTMLExtras, HTMLStyle);
end;

procedure TD2BridgeItemHTMLFormGroup.AddLabelLCLObj(VCLItem: TObject;
  CSS: String; HTMLExtras: String; HTMLStyle: String);
begin
 AddLabelLCLObj(VCLItem, CSS, HTMLExtras, HTMLStyle);
end;
{$ENDIF}

procedure TD2BridgeItemHTMLFormGroup.AddVCLObj(VCLItem: TObject; CSS: String;
  HTMLExtras: String; HTMLStyle: String);
begin
 if not BaseClass.D2BridgeManager.SupportsVCLClass(VCLItem.ClassType) then
  Exit;

 AddVCLObj(VCLItem, nil, CSS, HTMLExtras, HTMLStyle);
end;

procedure TD2BridgeItemHTMLFormGroup.AddVCLObj(VCLItem: TObject;
  APopupMenu: TPopupMenu; CSS, HTMLExtras, HTMLStyle: String);
begin
 if not BaseClass.D2BridgeManager.SupportsVCLClass(VCLItem.ClassType) then
  Exit;

 FItem := TD2BridgeItemVCLObj.Create(BaseClass);
 FItem.Item:= TComponent(VCLItem);

 if CSS <> '' then
  CSS:= ' ' + CSS;
 CSS:= 'd2bridgeformgroupcontrol' + CSS;

 if FInLine then
 FItem.CSSClasses:= Format(Class_Input_Inline, [CSS])
 else
 FItem.CSSClasses:= CSS;

// if HTMLExtras <> '' then
//  HTMLExtras:= HTMLExtras + ' ';
// HTMLExtras:= HTMLExtras + 'formgroupfor="'+ AnsiUpperCase(ItemPrefixID) +'"';

 FItem.HTMLExtras:= HTMLExtras;
 FItem.HTMLStyle:= HTMLStyle;
 if Assigned(APopupMenu) then
 FItem.PopupMenu:= APopupMenu;
 if Assigned(FItemLabel) and Assigned(FItemLabel.Item) and (FItemLabel.Item <> nil) and (AnsiPos('for=',FItemLabel.HTMLExtras) < 0) then
 FItemLabel.HTMLExtras:= FItemLabel.HTMLExtras+ ' for="'+ AnsiUpperCase(FItem.Item.Name) +'"';
 if not FInLine then
 if (ColSize2 = '') and (Pos('col-md', ColSize1) <= 0) then
 begin
  if (SameText(OverrideVCL(VCLItem.ClassType).ClassName, 'TEdit'))
   or (SameText(OverrideVCL(VCLItem.ClassType).ClassName, 'TcxTextEdit'))
   or (SameText(OverrideVCL(VCLItem.ClassType).ClassName, 'TcxDBTextEdit'))
   or (SameText(OverrideVCL(VCLItem.ClassType).ClassName, 'TDBEdit')) then
  if AnsiPos('col-', FItem.CSSClasses) < 0 then
  ColSize2:= 'col-md-6 col-12'
  else
  if (SameText(OverrideVCL(VCLItem.ClassType).ClassName, 'TCombobox'))
   or (SameText(OverrideVCL(VCLItem.ClassType).ClassName, 'TComboEdit'))
   or (SameText(OverrideVCL(VCLItem.ClassType).ClassName, 'TcxComboBox'))
   or (SameText(OverrideVCL(VCLItem.ClassType).ClassName, 'TDBCombobox'))
   or (SameText(OverrideVCL(VCLItem.ClassType).ClassName, 'TcxDBComboBox'))
   or (SameText(OverrideVCL(VCLItem.ClassType).ClassName, 'TcxDBLookupComboBox'))
   or (SameText(OverrideVCL(VCLItem.ClassType).ClassName, 'TDBLookupCombobox')) then
  if AnsiPos('col-', FItem.CSSClasses) < 0 then
  ColSize2:= 'col-md-6 col-12'
  else
  if (SameText(OverrideVCL(VCLItem.ClassType).ClassName, 'TDateEdit')) then
  if AnsiPos('col-', FItem.CSSClasses) < 0 then
  ColSize2:= 'col-md-4 col-6'
 end;
end;

procedure TD2BridgeItemHTMLFormGroup.AddVCLObjLink(VCLItem: TComponent; Href: string; ACSSClass: String; AHTMLExtras: String; AHTMLStyle: String);
begin
 if not BaseClass.D2BridgeManager.SupportsVCLClass(VCLItem.ClassType) then
  Exit;

 if Href = '' then
  Href:= '#';

 FLink:= TD2BridgeItemHTMLLink.Create(BaseClass);
 FLink.PrismLink.LabelHTMLElement:= VCLItem;
 FLink.ItemID:= VCLItem.Name;
 FLink.PrismLink.href:= HRef;
 FLink.CSSClasses:= ACSSClass;
 FLink.HTMLExtras:= AHTMLExtras;
 FLink.HTMLStyle:= AHTMLStyle;

 AddVCLObj(VCLItem, ACSSClass, AHTMLExtras, AHTMLStyle);
end;

procedure TD2BridgeItemHTMLFormGroup.AddVCLObj(VCLItem: TObject;
  AValidationGroup: Variant; ARequired: Boolean; CSS, HTMLExtras,
  HTMLStyle: String);
begin
 if not BaseClass.D2BridgeManager.SupportsVCLClass(VCLItem.ClassType) then
  Exit;

 AddVCLObj(VCLItem, nil, CSS, HTMLExtras, HTMLStyle);
 FItem.Required:= ARequired;
 FItem.ValidationGroup:= AValidationGroup;

 FRequired:= ARequired;
end;

procedure TD2BridgeItemHTMLFormGroup.AddVCLObjWithLabel(VCLItem: TObject; ATextLabel: string; CSS: String; HTMLExtras: String; HTMLStyle: String);
begin
 if not BaseClass.D2BridgeManager.SupportsVCLClass(VCLItem.ClassType) then
  Exit;

 AddVCLObj(VCLItem, CSS, HTMLExtras, HTMLStyle);
 TextLabel:= ATextLabel;
end;

procedure TD2BridgeItemHTMLFormGroup.BeginReader;
var
 HTMLText: String;
begin

 //Check Start inVisible
// if (Assigned(FItem)) and (Assigned(FItem.Item)) then
// begin
//  if (FItem.Item is TControl) and
//     (not GetVisibleRecursive(TControl(FItem.Item))) then
//  begin
//   if Pos('display', HTMLStyle) <= 0 then
//   begin
//    if HTMLStyle <> '' then
//     HTMLStyle:= HTMLStyle + ' ';
//
//    HTMLStyle:= HTMLStyle + 'display: none;';
//   end;
//  end;
// end else
//  if ((Assigned(FD2BridgeItems)) and (FD2BridgeItems.Count > 0)) then
//  begin
//   if (FD2BridgeItems.Item(0) is TD2BridgeItemVCLObj) and
//      Assigned(TD2BridgeItemVCLObj(FD2BridgeItems.Item(0)).Item) and
//      ((TD2BridgeItemVCLObj(FD2BridgeItems.Item(0)).Item is TControl) and
//        (not GetVisibleRecursive(TControl(TD2BridgeItemVCLObj(FD2BridgeItems.Item(0)).Item)))) then
//   begin
//    if Pos('display', HTMLStyle) <= 0 then
//    begin
//     if HTMLStyle <> '' then
//      HTMLStyle:= HTMLStyle + ' ';
//
//     HTMLStyle:= HTMLStyle + 'display: none;';
//    end;
//   end;
//  end;


 if HTMLInLine then
 begin
  if ColSize1 = '' then
  ColSize1:= BaseClass.CSSClass.Col.colauto;

  HTMLText:= '<'+TrataHTMLTag(TAG_Div+' class="d2bridgeformgroup '+Trim(Format(Class_DIV_Inline, [ColSize1, ColSize2, CSSClasses]))+'" style="'+HTMLStyle+'" '+HTMLExtras)+' id="'+AnsiUpperCase(ItemPrefixID)+'">';
  BaseClass.HTML.Render.Body.Add(HTMLText);
  HTMLText:= '<'+TrataHTMLTag(TAG_FormGroup+' class="'+Trim(Format(Class_FormGroup_Inline, [CSSClasses]))+'" style="'+HTMLStyle+'" '+HTMLExtras)+'>';
  BaseClass.HTML.Render.Body.Add(HTMLText);
 end else
 begin
  HTMLText:= '<'+TrataHTMLTag(TAG_Div+' class="d2bridgeformgroup mt-1 '+Trim(Format(Class_DIV_Default, [ColSize1, ColSize2, CSSClasses]))+'" style="'+HTMLStyle+'" '+HTMLExtras)+' id="'+AnsiUpperCase(ItemPrefixID)+'">';
  BaseClass.HTML.Render.Body.Add(HTMLText);
  HTMLText:= '<'+TrataHTMLTag(TAG_FormGroup+' class="'+Trim(Format(Class_FormGroup_Default, [CSSClasses]))+'" style="'+HTMLStyle+'" '+HTMLExtras)+'>';
  BaseClass.HTML.Render.Body.Add(HTMLText);
 end;
end;

procedure TD2BridgeItemHTMLFormGroup.EndReader;
begin
 BaseClass.HTML.Render.Body.Add('</div>');
 BaseClass.HTML.Render.Body.Add('</div>');
end;

procedure TD2BridgeItemHTMLFormGroup.PreProcess;
begin

end;

procedure TD2BridgeItemHTMLFormGroup.Render;
var
 vD2BridgeItems : TList<ID2BridgeItem>;
 I: Integer;
 vHTMLExtras, vCSSClasses: string;
begin
 if FD2BridgeItems.Count > 0 then
 begin
  BaseClass.HTML.Render.Body.Add('<div class="d2bridgeformgroupitems input-group">');

  for I := 0 to Pred(Items.Items.Count) do
  begin
   vHTMLExtras:= Items.Items[I].HTMLExtras;

   if Pos('formgroupfor=', vHTMLExtras) <= 0 then
   begin
     if vHTMLExtras <> '' then
      vHTMLExtras := vHTMLExtras + ' ';


     vHTMLExtras := vHTMLExtras + 'formgroupfor="'+ AnsiUpperCase(ItemPrefixID) +'"';

     Items.Items[I].HTMLExtras:= vHTMLExtras;
   end;



   vCSSClasses:= Items.Items[I].CSSClasses;

   if Pos('d2bridgeformgroupcontrol', vCSSClasses) <= 0 then
   begin
     if vCSSClasses <> '' then
      vCSSClasses := vCSSClasses + ' ';

     vCSSClasses := vCSSClasses + 'd2bridgeformgroupcontrol';

     Items.Items[I].CSSClasses := vCSSClasses;
   end;
  end;

  BaseClass.RenderD2Bridge(Items.Items);

  BaseClass.HTML.Render.Body.Add('</div>');
 end else
 begin
  vD2BridgeItems:= TList<ID2BridgeItem>.Create;

  if (Assigned(FLink)) then
   vD2BridgeItems.Add(FLink)
  else
   if Assigned(FItem) then
    vD2BridgeItems.Add(FItem);

  if (vD2BridgeItems.Count > 0) then
  begin
   vHTMLExtras:= vD2BridgeItems.Items[0].HTMLExtras;

   if (Pos('formgroupfor=', vHTMLExtras) <= 0) then
   begin
    if vHTMLExtras <> '' then
     vHTMLExtras := vHTMLExtras + ' ';

    vHTMLExtras := vHTMLExtras + 'formgroupfor="'+ AnsiUpperCase(ItemPrefixID) +'"';

    vD2BridgeItems.Items[0].HTMLExtras:= vHTMLExtras;
   end;
  end;

  if Assigned(FItemLabel) and (Assigned(FItemLabel.Item)) then
  vD2BridgeItems.Add(FItemLabel);

  if vD2BridgeItems.Count > 0 then
  begin
   BaseClass.RenderD2Bridge(vD2BridgeItems);
  end;

  FreeAndNil(vD2BridgeItems);
 end;
end;

procedure TD2BridgeItemHTMLFormGroup.RenderHTML;
var
 HTMLText, NomeFor: String;
 vLabelCore: string;
 vVCLObjStyle: TD2BridgeItemVCLObjStyle;
 vCSSClasses, vHTMLStyle: string;
begin
 vCSSClasses:= 'd2bridgeformgrouplabel';
 vHTMLStyle:= '';
 vLabelCore:= '';
 System.Initialize(vVCLObjStyle);

 if ((not Assigned(FItemLabel)) or (not Assigned(FItemLabel.Item))) and
    ((TextLabel <> '') or Assigned(FLabel)) then
 begin
  NomeFor:= '';
  if ((Assigned(FItem)) and (Assigned(FItem.Item))) then
   NomeFor:= 'for="'+ AnsiUpperCase(FItem.ItemPrefixID)+'"'
  else
   if ((Assigned(FD2BridgeItems)) and (FD2BridgeItems.Count > 0)) then
    NomeFor:= 'for="'+ AnsiUpperCase(FD2BridgeItems.Item(0).ItemPrefixID)+'"';

  if HTMLInLine then
   vHTMLStyle:= Style_Label_InLine;

  if Assigned(FLabel) then
  begin
   FLabelItems.Item(0).CSSClasses:= Trim(' ' + FLabelItems.Item(0).CSSClasses + ' ' + vCSSClasses);
   FLabelItems.Item(0).HTMLStyle:= Trim(' ' + FLabelItems.Item(0).HTMLStyle + ' ' + vHTMLStyle);
   FLabelItems.Item(0).HTMLExtras:= Trim(' ' + FLabelItems.Item(0).HTMLExtras + ' ' + NomeFor);

   if FRequired then
    FLabelItems.Item(0).HTMLExtras:= Trim(' ' + FLabelItems.Item(0).HTMLExtras + ' ' + 'required');

   BaseClass.RenderD2Bridge(FLabelItems.Item(0));
  end else
   BaseClass.HTML.Render.Body.Add('<label class="'+ vCSSClasses +'" '+NomeFor+' style="'+vHTMLStyle+'">'+TextLabel+'</label>');
 end;
end;

procedure TD2BridgeItemHTMLFormGroup.SetColSize1(AColSize: string);
begin
 FColSize1:= AColSize;
end;

procedure TD2BridgeItemHTMLFormGroup.SetColSize2(AColSize: string);
begin
 FColSize2:= AColSize;
end;

procedure TD2BridgeItemHTMLFormGroup.SetLabelComponent(ALabel: TComponent);
begin
 FLabel:= ALabel;

 if FLabelItems.Count <= 0 then
  FLabelItems.Add.VCLObj(FLabel);
end;

procedure TD2BridgeItemHTMLFormGroup.SetInLine(Value: Boolean);
begin
 FInLine:= Value;
end;

procedure TD2BridgeItemHTMLFormGroup.SetTextLabel(ATextLabel: string);
begin
 FTextLabel:= ATextLabel;
end;

end.