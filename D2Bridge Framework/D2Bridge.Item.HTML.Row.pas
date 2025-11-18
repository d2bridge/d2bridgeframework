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

unit D2Bridge.Item.HTML.Row;

interface

uses
  Classes, Generics.Collections, StrUtils,
  Prism.Interfaces,
  D2Bridge.ItemCommon, D2Bridge.Item, D2Bridge.BaseClass, D2Bridge.Interfaces, D2Bridge.Item.VCLObj,
  D2Bridge.Item.HTML.FormGroup;

type
  TD2BridgeItemHTMLRow = class(TD2BridgeItem, ID2BridgeItemHTMLRow)
   //events
   procedure BeginReader;
   procedure EndReader;

  private
   //FD2BridgeItem: TD2BridgeItem;
   FD2BridgeItems : TD2BridgeItems;
   FInLine: Boolean;
   FTagRow: String;
   FCloseElement: boolean;
   FIsRow: boolean;
   FIsCol: boolean;
   FIsDiv: boolean;
   //Funções
   function GetItems: TList<ID2BridgeItem>;
   function GetInLine: Boolean;
   procedure SetInLine(Value: Boolean);
   procedure SetHTMLTagRow(ATagRow: String);
   function GetHTMLTagRow: String;
   function GetCloseElement: boolean;
   procedure SetCloseElement(const Value: boolean);
   function GetIsCol: Boolean;
   function GetIsDiv: Boolean;
   function GetIsRow: Boolean;
   procedure SetIsCol(const Value: Boolean);
   procedure SetIsDiv(const Value: Boolean);
   procedure SetIsRow(const Value: Boolean);
  public
   constructor Create(AOwner: TD2BridgeClass); override;
   destructor Destroy; override;
   //Functions
   procedure PreProcess; override;
   procedure Render; override;
   procedure RenderHTML; override;

   Function Items: ID2BridgeAddItems;
   function Add: IItemAdd;

   property BaseClass;
   property HTMLInLine: Boolean read GetInLine write SetInLine default false;
   property HTMLTagRow: String read GetHTMLTagRow write SetHTMLTagRow;
   property CloseElement: boolean read GetCloseElement write SetCloseElement;
   property IsRow: Boolean read GetIsRow write SetIsRow;
   property IsDiv: Boolean read GetIsDiv write SetIsDiv;
   property IsCol: Boolean read GetIsCol write SetIsCol;
  end;

const
 TAG_Default = 'row';
 TAG_INLINE = 'row form-inline mb-2 align-items-end';



implementation

uses
  SysUtils,
  D2Bridge.Render, D2Bridge.Item.HTML.PanelGroup, D2Bridge.Util,
  Prism.Forms.Controls, Prism.ControlGeneric,
  D2Bridge.HTML.CSS,
  Prism.Util;

{ TD2BridgeItemHTMLRow }



constructor TD2BridgeItemHTMLRow.Create(AOwner: TD2BridgeClass);
begin
 Inherited;

 HTMLTagRow:= 'div';

 CSSClasses:= 'row';

 FIsRow:= true;
 FIsCol:= false;
 FIsDiv:= false;

 FCloseElement:= true;

 FInLine:= false;

 FD2BridgeItems:= TD2BridgeItems.Create(AOwner);
 //Items:= TD2BridgeItems.Create(BaseClass);

 OnBeginReader:= BeginReader;
 OnEndReader:= EndReader;

 FPrismControl:= TPrismControlGeneric.Create(nil);
end;


destructor TD2BridgeItemHTMLRow.Destroy;
var
 vPrismControl: TPrismControl;
begin
 FreeAndNil(FD2BridgeItems);
 // FreeAndNil(Items);

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

function TD2BridgeItemHTMLRow.GetCloseElement: boolean;
begin
 result:= FCloseElement;
end;

function TD2BridgeItemHTMLRow.GetHTMLTagRow: String;
begin
 Result:= FTagRow;
end;

function TD2BridgeItemHTMLRow.GetInLine: Boolean;
begin
 result:= FInLine;
end;

function TD2BridgeItemHTMLRow.GetIsCol: Boolean;
begin
 result:= FIsCol;
end;

function TD2BridgeItemHTMLRow.GetIsDiv: Boolean;
begin
 result:= FIsDiv;
end;

function TD2BridgeItemHTMLRow.GetIsRow: Boolean;
begin
 result:= FIsRow;
end;

function TD2BridgeItemHTMLRow.GetItems: TList<ID2BridgeItem>;
begin
 Result:= FD2BridgeItems.Items;
end;

function TD2BridgeItemHTMLRow.Items: ID2BridgeAddItems;
begin
 Result:= FD2BridgeItems;
end;

function TD2BridgeItemHTMLRow.Add: IItemAdd;
begin
 result:= Items.Add;
end;

procedure TD2BridgeItemHTMLRow.BeginReader;
var
 HTMLText: String;
 vCSSClass: string;
 I: integer;
 vJustRow: boolean;
 vRow: ID2BridgeItemHTMLRow;
begin
 if HTMLTagRow = '' then
  HTMLTagRow := 'div';

 vCSSClass:= CSSClasses;

 if (HTMLTagRow = 'row') or (Pos(D2Bridge.HTML.CSS.Col.colinline, vCSSClass) > 0) then
  if (not ExistForClass(vCSSClass, 'm-')) and
     (not ExistForClass(vCSSClass, 'my-') and
     (not ExistForClass(vCSSClass, 'mb-')) and
     (not ExistForClass(vCSSClass, 'mt-'))) then
  vCSSClass:= Trim(vCSSClass + ' mt-2 mb-2');

 if (Pos(D2Bridge.HTML.CSS.Col.nocolinline, vCSSClass) > 0) then
 begin
  vCSSClass:= StringReplace(vCSSClass, D2Bridge.HTML.CSS.Col.colinline, '', [rfReplaceAll]);
 end else
  if FD2BridgeItems.Count > 1 then
  begin
   vJustRow:= true;

   for I := 0 to Pred(FD2BridgeItems.Count) do
   begin
    if not Supports(FD2BridgeItems.Items.Items[I], ID2BridgeItemHTMLRow, vRow) then
    begin
     vJustRow:= false;
     break;
    end else
    begin
     if not vRow.IsRow then
     begin
      vRow:= nil;
      vJustRow:= false;
      break;
     end else
      vRow:= nil;
    end;

   end;

   if vJustRow then
    vCSSClass:= StringReplace(vCSSClass, D2Bridge.HTML.CSS.Col.colinline, '', [rfReplaceAll]);
  end else
   vCSSClass:= StringReplace(vCSSClass, D2Bridge.HTML.CSS.Col.colinline, '', [rfReplaceAll]);

 if HTMLInLine then
 HTMLText:= '<'+HTMLTagRow+' '+TrataHTMLTag('class="'+Trim(TAG_INLINE + IfThen(Pos('d2bridgediv', vCSSClass) <= 0, ' d2bridgerow ') + vCSSClass)+'" style="'+HTMLStyle+'" '+HTMLExtras)+' id="'+AnsiUpperCase(ItemPrefixID)+'">'
 else
 HTMLText:= '<'+HTMLTagRow+' '+TrataHTMLTag('class="'+Trim(vCSSClass)+ IfThen(Pos('d2bridgediv', vCSSClass) <= 0, ' d2bridgerow') + '" style="'+HTMLStyle+'" '+HTMLExtras)+' id="'+AnsiUpperCase(ItemPrefixID)+'">';

 BaseClass.HTML.Render.Body.Add(HTMLText);
end;

procedure TD2BridgeItemHTMLRow.EndReader;
var
 HTMLText: String;
begin
 if FCloseElement then
 begin
  HTMLText:= '</'+HTMLTagRow+'>';

  BaseClass.HTML.Render.Body.Add(HTMLText);
 end;
end;

procedure TD2BridgeItemHTMLRow.PreProcess;
begin

end;

procedure TD2BridgeItemHTMLRow.Render;
begin
 if Items.Items.Count > 0 then
 begin
  BaseClass.RenderD2Bridge(Items.Items);
 end;
end;

procedure TD2BridgeItemHTMLRow.RenderHTML;
begin

end;

procedure TD2BridgeItemHTMLRow.SetCloseElement(const Value: boolean);
begin
 FCloseElement:= Value;
end;

procedure TD2BridgeItemHTMLRow.SetHTMLTagRow(ATagRow: String);
begin
 FTagRow:= ATagRow;
end;

procedure TD2BridgeItemHTMLRow.SetInLine(Value: Boolean);
begin
 FInLine:= Value;
end;

procedure TD2BridgeItemHTMLRow.SetIsCol(const Value: Boolean);
begin
 FIsRow:= false;
 FIsCol:= false;
 FIsDiv:= false;

 FIsCol:= Value;
end;

procedure TD2BridgeItemHTMLRow.SetIsDiv(const Value: Boolean);
begin
 FIsRow:= false;
 FIsCol:= false;
 FIsDiv:= false;

 FIsDiv:= Value;
end;

procedure TD2BridgeItemHTMLRow.SetIsRow(const Value: Boolean);
begin
 FIsRow:= false;
 FIsCol:= false;
 FIsDiv:= false;

 FIsRow:= Value;
end;

//function TD2BridgeItemHTMLRow.NewFormGroup: TD2BridgeItemHTMLFormGroup;
//begin
// Result:= TD2BridgeItemHTMLFormGroup.Create(BaseClass);
// FD2BridgeItems.Add(Result);
//end;
//
//function TD2BridgeItemHTMLRow.NewPanelGorup: ID2BridgeItemPanelGroup;
//begin
// Result:= TD2BridgeItemHTMLPanelGroup.Create(BaseClass);
// FD2BridgeItems.Add(Result as TD2BridgeItem);
//end;
//
//function TD2BridgeItemHTMLRow.NewRow: TD2BridgeItemHTMLRow;
//begin
// Result:= TD2BridgeItemHTMLRow.Create(BaseClass);
// FD2BridgeItems.Add(Result);
//end;
//
//function TD2BridgeItemHTMLRow.NewVCLObj: TD2BridgeItemVCLObj;
//begin
// Result := TD2BridgeItemVCLObj.Create(BaseClass);
// FD2BridgeItems.Add(Result);
//end;
//
//function TD2BridgeItemHTMLRow.NewVCLObj(VCLItem: TObject; CSS: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): TD2BridgeItemVCLObj;
//begin
// Result := NewVCLObj;
// Result.Item:= TComponent(VCLItem);
// Result.CSS:= CSS;
// Result.HTMLExtras:= HTMLExtras;
// Result.HTMLStyle:= HTMLStyle;
//
// //FD2BridgeItems.Add(Result);
//end;

end.

