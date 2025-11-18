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

unit D2Bridge.Item.HTML.Tabs;

interface

uses
  Classes, SysUtils, Generics.Collections, StrUtils, System.UITypes,
  Prism.Interfaces,
  D2Bridge.Item, D2Bridge.BaseClass, D2Bridge.Item.VCLObj, D2Bridge.Interfaces, D2Bridge.ItemCommon;

type
  TD2BridgeItemHTMLTabs = class(TD2BridgeItem, ID2BridgeItemHTMLTabs)
   //events
   procedure BeginReader;
   procedure EndReader;
  strict private
   type
    TD2BridgeItemHTMLTabItem = class(TD2BridgeHTMLTag, ID2BridgeItemHTMLTabItem)
    private
     FD2BridgeItemHTMLTabs: TD2BridgeItemHTMLTabs;
     FD2BridgeItems : TD2BridgeItems;
     FTitle: String;
     function GetTitle: string;
     procedure SetTitle(ATitle: string);
    public
     constructor Create(D2BridgeItemHTMLTabs: TD2BridgeItemHTMLTabs); reintroduce;
     destructor Destroy; override;

     Function Items: ID2BridgeAddItems;
     property Title: string read GetTitle write SetTitle;
   end;
  private
   FD2BridgeItem: TD2BridgeItem;
   FTabs: TList<ID2BridgeItemHTMLTabItem>;
   FColSize: String;
   FTabColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
   FTabTextColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
   function GetTabs: TList<ID2BridgeItemHTMLTabItem>;
   procedure SetColSize(AColSize: string);
   function GetColSize: string;
   function GetShowTabs: Boolean;
   procedure SetShowTabs(const Value: Boolean);
   function GetTabColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
   function GetTabTextColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
   procedure SetTabColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
   procedure SetTabTextColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
  public
   constructor Create(AOwner: TD2BridgeClass); override;
   destructor Destroy; override;

   procedure PreProcess; override;
   procedure Render; override;
   procedure RenderHTML; override;

   function AddTab: ID2BridgeItemHTMLTabItem; overload;
   function AddTab(ATitle: String; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLTabItem; overload;
   procedure AddTab(Item: ID2BridgeItemHTMLTabItem); overload;

   property Tabs: TList<ID2BridgeItemHTMLTabItem> read GetTabs;
   property ColSize: string read GetColSize write SetColSize;
   property ShowTabs: Boolean read GetShowTabs write SetShowTabs;

   property TabColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF} read GetTabColor write SetTabColor;
   property TabTextColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF} read GetTabTextColor write SetTabTextColor;

   property BaseClass;
  end;

implementation

uses
  Prism.Forms.Controls,
  Prism.ControlGeneric, Prism.Tabs, Prism.Types, D2Bridge.Util;

{ TD2BridgeItemHTMLTabs }

constructor TD2BridgeItemHTMLTabs.Create(AOwner: TD2BridgeClass);
begin
 FD2BridgeItem:= Inherited Create(AOwner);

 FTabs:= TList<ID2BridgeItemHTMLTabItem>.Create;

 FColSize:= 'col';

 FD2BridgeItem.OnBeginReader:= BeginReader;
 FD2BridgeItem.OnEndReader:= EndReader;

 FPrismControl := TPrismTabs.Create(nil);
 FPrismControl.Name:= ITemID;

 FTabTextColor:= {$IFNDEF FPC}TColors.SysNone{$ELSE}TColorRec.Black{$ENDIF};
 FTabColor:= {$IFNDEF FPC}TColors.SysNone{$ELSE}TColorRec.Black{$ENDIF};
end;

destructor TD2BridgeItemHTMLTabs.Destroy;
var
 FTabItemIntf: ID2BridgeItemHTMLTabItem;
 vTabItem: TD2BridgeItemHTMLTabItem;
 vPrismControl: TPrismControl;
begin
// if Assigned(FPrismControl) then
// begin
//  (FPrismControl as TPrismTabs).Destroy;
// end;

 while FTabs.Count > 0 do
 begin
  FTabItemIntf:= FTabs.Last;
  FTabs.Delete(Pred(FTabs.Count));

  vTabItem:= FTabItemIntf as TD2BridgeItemHTMLTabItem;
  FTabItemIntf:= nil;
  vTabItem.Free;
 end;
 FreeAndNil(FTabs);


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

function TD2BridgeItemHTMLTabs.GetColSize: string;
begin
 Result:= FColSize;
end;

function TD2BridgeItemHTMLTabs.GetShowTabs: Boolean;
begin
 result:= FPrismControl.AsTabs.ShowTabs;
end;

function TD2BridgeItemHTMLTabs.AddTab: ID2BridgeItemHTMLTabItem;
begin
 Result:= TD2BridgeItemHTMLTabItem.Create(self);
 FTabs.Add(Result);
end;

function TD2BridgeItemHTMLTabs.AddTab(ATitle: String; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLTabItem;
begin
 Result:= AddTab;
 Result.Title:= ATitle;
 Result.CSSClasses:= ACSSClass;
 Result.HTMLExtras:= HTMLExtras;
 Result.HTMLStyle:= HTMLStyle;
end;

procedure TD2BridgeItemHTMLTabs.AddTab(Item: ID2BridgeItemHTMLTabItem);
begin
 FTabs.Add(Item);
end;

function TD2BridgeItemHTMLTabs.GetTabColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
begin
 result:= FTabColor;
end;

function TD2BridgeItemHTMLTabs.GetTabs: TList<ID2BridgeItemHTMLTabItem>;
begin
 Result:= FTabs;
end;

function TD2BridgeItemHTMLTabs.GetTabTextColor: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
begin
 result:= FTabTextColor;
end;

procedure TD2BridgeItemHTMLTabs.BeginReader;
var
 vCSSClasses: string;
 vHTMLStyle: string;
begin
 vCSSClasses:= CSSClasses;
 vHTMLStyle:= HTMLStyle;

 if FTabColor = {$IFNDEF FPC}TColors.SysNone{$ELSE}TColorRec.Black{$ENDIF} then
 begin
  if (Pos(BaseClass.CSSClass.TabsColor.primary, vCSSClasses) <= 0) and
     (Pos(BaseClass.CSSClass.TabsColor.secondary, vCSSClasses) <= 0) and
     (Pos(BaseClass.CSSClass.TabsColor.success, vCSSClasses) <= 0) and
     (Pos(BaseClass.CSSClass.TabsColor.danger, vCSSClasses) <= 0) then
  begin
   vCSSClasses:= Trim(vCSSClasses + ' ' + BaseClass.CSSClass.TabsColor.primary);
  end;
 end else
 begin
  vHTMLStyle:= Trim(vHTMLStyle + ' ' + 'background: ' + ColorToHex(FTabColor) + ';');
 end;

 with BaseClass.HTML.Render.Body do
 begin
  Add('<div id="'+AnsiUpperCase(ItemPrefixID)+'" class="d2bridgetab '+ColSize+'">');
  Add('<div class="card card-nav-tabs '+ ifThen(ShowTabs, 'd2bridgetabs', 'd2bridgetabs-invisible') +' mb-1" id="'+AnsiUpperCase(ItemPrefixID)+'tabs">');
  Add('<div class="card-header d2bridgetabstitles '+vCSSClasses+'" style="'+vHTMLStyle+'" '+HTMLExtras+' id="'+AnsiUpperCase(ItemPrefixID)+'titlearea">');
  Add('<div class="nav-tabs-navigation">');
  Add('<div class="nav-tabs-wrapper">');
 end;
end;

procedure TD2BridgeItemHTMLTabs.EndReader;
begin
end;

procedure TD2BridgeItemHTMLTabs.PreProcess;
begin

end;

procedure TD2BridgeItemHTMLTabs.Render;
var
  I: Integer;
begin
 if Tabs.Count > 0 then
 begin
  {$REGION 'Abas'}
   BaseClass.HTML.Render.Body.Add('<ul class="nav nav-tabs border-bottom-0 ' + CSSClasses + '" style="'+ HtmlStyle +'" '+ HtmlExtras +' data-tabs="tabs" role="tablist">');
   for I := 0 to Tabs.Count -1 do
   begin
    with BaseClass.HTML.Render.Body do
    begin
     Add('<li class="nav-item">');
     if I = 0 then
     Add('<a class="nav-link d2bridgetabsbuttom active" href="#TABS_'+ UpperCase(ItemPrefixID) +'_ITEM'+IntToStr(I)+'" id="TABS_'+ UpperCase(ItemPrefixID) +'_BUTTON'+IntToStr(I)+'" data-bs-toggle="tab" data-bs-target="#TABS_'+UpperCase(ItemPrefixID)+'_ITEM'+IntToStr(I)+'" role="tab" aria-controls="profile-tab-pane" onclick="' +  FPrismControl.Events.Item(EventOnChange).EventJS(FD2BridgeItem.BaseClass.PrismSession, FD2BridgeItem.BaseClass.FormUUID, ExecEventProc, QuotedStr('tabindex='+IntToStr(I))) + '" style="' + IfThen(FTabTextColor <> {$IFNDEF FPC}TColors.SysNone{$ELSE}TColorRec.Black{$ENDIF}, 'Color: '+ColorToHex(FTabTextColor) +'!important;') + '">'+Tabs[I].Title+'</a>')
     else
     Add('<a class="nav-link d2bridgetabsbuttom" href="#TABS_'+UpperCase(ItemPrefixID)+'_ITEM'+IntToStr(I)+'" id="TABS_'+ UpperCase(ItemPrefixID) +'_BUTTON'+IntToStr(I)+'" data-bs-toggle="tab" data-bs-target="#TABS_'+UpperCase(ItemPrefixID)+'_ITEM'+IntToStr(I)+'" role="tab" aria-controls="profile-tab-pane" onclick="' +  FPrismControl.Events.Item(EventOnChange).EventJS(FD2BridgeItem.BaseClass.PrismSession, FD2BridgeItem.BaseClass.FormUUID, ExecEventProc, QuotedStr('tabindex='+IntToStr(I))) + '" style="' + IfThen(FTabTextColor <> {$IFNDEF FPC}TColors.SysNone{$ELSE}TColorRec.Black{$ENDIF}, 'Color: '+ColorToHex(FTabTextColor) +'!important;') + '">'+Tabs[I].Title+'</a>');
     Add('</li>');
    end;
   end;
   BaseClass.HTML.Render.Body.Add('</ul>');

   //Fecha
   with BaseClass.HTML.Render.Body do
   begin
    //Fecha <div class="nav-tabs-wrapper">
    Add('</div>');
    //Fecha <div class="nav-tabs-navigation">
    Add('</div>');
    //Fecha <div class="card-header card-header-primary">
    Add('</div>');
   end;
  {$ENDREGION}


  {$REGION 'Card Body'}
   //Inicio
   with BaseClass.HTML.Render.Body do
   begin
    Add('<div class="card-body d2bridgetabsbody">');
    Add('<div class="tab-content">');
   end;

   for I := 0 to Tabs.Count -1 do
   begin
    if I = 0 then
     BaseClass.HTML.Render.Body.Add('<div class="tab-pane fade show active" id="TABS_'+UpperCase(ItemPrefixID)+'_ITEM'+IntToStr(I)+'" role="tabpanel">')
    else
    BaseClass.HTML.Render.Body.Add('<div class="tab-pane fade" id="TABS_'+UpperCase(ItemPrefixID)+'_ITEM'+IntToStr(I)+'" role="tabpanel">');

    BaseClass.RenderD2Bridge(Tabs[I].Items.Items);

    BaseClass.HTML.Render.Body.Add('</div>');
   end;

   //Fim
   with BaseClass.HTML.Render.Body do
   begin
    Add('</div>');
    Add('</div>');
   end;
  {$ENDREGION}


  with BaseClass.HTML.Render.Body do
  begin
   //Fecha <div class="card card-nav-tabs">
   Add('</div>');
   //Fecha <div class="col">
   Add('</div>');
  end;

 end;
end;

procedure TD2BridgeItemHTMLTabs.RenderHTML;
begin

end;

procedure TD2BridgeItemHTMLTabs.SetColSize(AColSize: string);
begin
 FColSize:= AColSize;
end;

procedure TD2BridgeItemHTMLTabs.SetShowTabs(const Value: Boolean);
begin
 FPrismControl.AsTabs.ShowTabs:= Value;
end;

procedure TD2BridgeItemHTMLTabs.SetTabColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
begin
 FTabColor:= Value;
end;

procedure TD2BridgeItemHTMLTabs.SetTabTextColor(const Value: {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF});
begin
 FTabTextColor:= Value;
end;

{ TD2BridgeItemHTMLTabs.TD2BridgeItemHTMLTabItem }

constructor TD2BridgeItemHTMLTabs.TD2BridgeItemHTMLTabItem.Create(D2BridgeItemHTMLTabs: TD2BridgeItemHTMLTabs);
begin
 FD2BridgeItemHTMLTabs:= D2BridgeItemHTMLTabs;

 FD2BridgeItems:= TD2BridgeItems.Create(D2BridgeItemHTMLTabs.BaseClass);
end;

destructor TD2BridgeItemHTMLTabs.TD2BridgeItemHTMLTabItem.Destroy;
begin
 FreeAndNil(FD2BridgeItems);

 inherited;
end;

function TD2BridgeItemHTMLTabs.TD2BridgeItemHTMLTabItem.GetTitle: string;
begin
 Result:= FTitle;
end;

function TD2BridgeItemHTMLTabs.TD2BridgeItemHTMLTabItem.Items: ID2BridgeAddItems;
begin
 Result:= FD2BridgeItems;
end;

procedure TD2BridgeItemHTMLTabs.TD2BridgeItemHTMLTabItem.SetTitle(
  ATitle: string);
begin
 FTitle:= ATitle;
end;

end.
