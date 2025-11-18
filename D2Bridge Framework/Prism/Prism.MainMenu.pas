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

{$I ..\D2Bridge.inc}

unit Prism.MainMenu;

interface

uses
  Classes, SysUtils,
  Prism.Interfaces, Prism.Menu, D2Bridge.JSON, Prism.Types, StrUtils;

type
 TPrismMainMenu = class(TPrismMenu, IPrismMainMenu)
  private
   FPanelTopItemsHTML: string;
   FPanelBottomItemsHTML: string;
   FRightItemsHTML: string;
   FAccessoryItemsHTML: string;
   FMenuAlign: TPrismAlignment;
   FTransparent: Boolean;
   FPanelTop: IPrismMenuPanel;
   FPanelBottom: IPrismMenuPanel;
   procedure RenderHTMLMenuItem(APrismMenuItems: IPrismMenuItems; APrismMenuItem: IPrismMenuItem; var AMenuHTML: TStrings);
   function GetPanelTopItemsHTML: String;
   procedure SetPanelTopItemsHTML(const Value: String);
   function GetRightItemsHTML: String;
   procedure SetRightItemsHTML(const Value: String);
   function GetAccessoryItemsHTML: String;
   procedure SetAccessoryItemsHTML(const Value: String);
   function GetMenuAlign: TPrismAlignment;
   procedure SetMenuAlign(const Value: TPrismAlignment);
   function MenuAlignCSS: string;
   function GetTransparent: Boolean;
   procedure SetTransparent(const Value: Boolean);
   function GetPanelBottomItemsHTML: String;
   procedure SetPanelBottomItemsHTML(const Value: String);
  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   function AlwaysInitialize: Boolean; override;
  public
   constructor Create(AOwner: TObject); override;
   destructor Destroy; override;

   function IsMainMenu: Boolean; override;

   function PanelTop: IPrismMenuPanel;
   function PanelBottom: IPrismMenuPanel;

   property RightItemsHTML: String read GetRightItemsHTML write SetRightItemsHTML;
   property AccessoryItemsHTML: String read GetAccessoryItemsHTML write SetAccessoryItemsHTML;
   property PanelTopItemsHTML: String read GetPanelTopItemsHTML write SetPanelTopItemsHTML;
   property PanelBottomItemsHTML: String read GetPanelBottomItemsHTML write SetPanelBottomItemsHTML;
   property MenuAlign: TPrismAlignment read GetMenuAlign write SetMenuAlign;
   property Transparent: Boolean read GetTransparent write SetTransparent;
 end;

implementation

uses
  Prism.Menu.SubMenu, Prism.Forms, D2Bridge.Util, Prism.Menu.Panel,
  D2Bridge.ServerControllerBase;

{ TPrismMainMenu }

function TPrismMainMenu.AlwaysInitialize: Boolean;
begin
 result:= true;
end;

constructor TPrismMainMenu.Create(AOwner: TObject);
begin
 inherited;

 FTransparent:= false;

 FMenuAlign:= TPrismAlignment.PrismAlignLeft;

 FPanelTop:= TPrismMenuPanel.Create(Self);
 FPanelBottom:= TPrismMenuPanel.Create(Self);
end;

destructor TPrismMainMenu.Destroy;
var
 vPanelTop: TPrismMenuPanel;
 vPanelBottom: TPrismMenuPanel;
begin
 vPanelTop:= FPanelTop as TPrismMenuPanel;
 FPanelTop:= nil;
 vPanelTop.Free;

 vPanelBottom:= FPanelBottom as TPrismMenuPanel;
 FPanelBottom:= nil;
 vPanelBottom.Free;

 inherited;
end;

function TPrismMainMenu.GetAccessoryItemsHTML: String;
begin
 Result:= FAccessoryItemsHTML;
end;

function TPrismMainMenu.GetEnableComponentState: Boolean;
begin

end;

function TPrismMainMenu.GetMenuAlign: TPrismAlignment;
begin
 if FMenuAlign in [TPrismAlignment.PrismAlignNone, TPrismAlignment.PrismAlignLeft] then
  Result:= TPrismAlignment.PrismAlignLeft
 else
  if FMenuAlign in [TPrismAlignment.PrismAlignCenter, TPrismAlignment.PrismAlignJustified] then
   Result:= TPrismAlignment.PrismAlignCenter
  else
   Result:= FMenuAlign;
end;

function TPrismMainMenu.GetRightItemsHTML: String;
begin
 Result:= FRightItemsHTML;
end;

function TPrismMainMenu.GetPanelBottomItemsHTML: String;
begin
 Result:= FPanelBottomItemsHTML;
end;

function TPrismMainMenu.GetPanelTopItemsHTML: String;
begin
 Result:= FPanelTopItemsHTML;
end;

function TPrismMainMenu.GetTransparent: Boolean;
begin
 Result:= FTransparent;
end;

procedure TPrismMainMenu.Initialize;
begin
  inherited;

end;

function TPrismMainMenu.IsMainMenu: Boolean;
begin
 Result:= true;
end;

function TPrismMainMenu.MenuAlignCSS: string;
begin
 result:= 'menualign-left';

 if MenuAlign = TPrismAlignment.PrismAlignLeft then
  result:= 'menualign-left'
 else
  if MenuAlign = TPrismAlignment.PrismAlignCenter then
   result:= 'menualign-center'
  else
   if MenuAlign = TPrismAlignment.PrismAlignRight then
    result:= 'menualign-right';
end;

function TPrismMainMenu.PanelBottom: IPrismMenuPanel;
begin
 Result:= FPanelBottom;
end;

function TPrismMainMenu.PanelTop: IPrismMenuPanel;
begin
 Result:= FPanelTop;
end;

procedure TPrismMainMenu.ProcessComponentState(const ComponentStateInfo: TJSONObject);
begin
  inherited;

end;

procedure TPrismMainMenu.ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings);
begin
  inherited;

end;

procedure TPrismMainMenu.ProcessHTML;
var
 vMenuHTML: TStrings;
 I: Integer;
 vExistMenuItem: boolean;
begin
 inherited;

 HTMLControl := '';

 vMenuHTML:= TStringList.Create;

 //Begin Menu Container
 vMenuHTML.Add('<div class="d2bridgemainmenucontainer" id="' + AnsiUpperCase(NamePrefix) + 'container">');

 //CSS
 vMenuHTML.Add('<style type="text/css">');
 vMenuHTML.Add('/* Margin */');
 vMenuHTML.Add('.d2bridgecontainer > *:first-child:not(img) {');
 vMenuHTML.Add('    margin-top: 20px;');
 vMenuHTML.Add('}');
 vMenuHTML.Add('/* BackGround Color */');
 vMenuHTML.Add('.d2bridgemainmenu.navbar {');
 vMenuHTML.Add('  background-color: ' + ColorToHex(Color) + ' !important;');
 vMenuHTML.Add('}');
 vMenuHTML.Add('.d2bridgemainmenu {');
 vMenuHTML.Add('  color: ' + ColorToHex(MenuTextColor) + ' !important;');
 vMenuHTML.Add('}');
 vMenuHTML.Add('/* Title Color */');
 vMenuHTML.Add('.d2bridgemainmenu .d2bridgemainmenutitle {');
 vMenuHTML.Add('  color: ' + ColorToHex(TitleColor) + ';');
 vMenuHTML.Add('}');
 vMenuHTML.Add('.d2bridgemainmenu .dropdown-item {');
 vMenuHTML.Add('  color: ' + ColorToHex(MenuTextColor) + ';');
 vMenuHTML.Add('}');
 vMenuHTML.Add('.d2bridgemainmenu .navbar-nav .nav-link,');
 vMenuHTML.Add('.d2bridgemainmenu .d2bridgemenuitemlink {');
 vMenuHTML.Add('  color: ' + ColorToHex(MenuTextColor) + ';');
 vMenuHTML.Add('}');
 vMenuHTML.Add('.d2bridgemainmenupaneltop {');
 vMenuHTML.Add('  background-color: ' + ColorToHex(PanelTop.Color) + ';');
 vMenuHTML.Add('}');
 vMenuHTML.Add('.d2bridgemainmenupanelbottom {');
 vMenuHTML.Add('  background-color: ' + ColorToHex(PanelBottom.Color) + ';');
 vMenuHTML.Add('}');
 vMenuHTML.Add('/* Button Ico */');
 vMenuHTML.Add('.d2bridgemainmenu .navbar-toggler-icon {');
 vMenuHTML.Add('  color: ' + ColorToHex(MenuTextColor) + ';');
 vMenuHTML.Add('}');
 vMenuHTML.Add('.d2bridgemainmenu .navbar-toggler:focus {');
 vMenuHTML.Add('    color: ' + ColorToHex(MenuTextColor) + ';');
 vMenuHTML.Add('}');
 vMenuHTML.Add('@media screen and (min-width:992px) {');
 vMenuHTML.Add('  .d2bridgemainmenu .dropdown .dropdown-menu {');
 vMenuHTML.Add('    background: ' + ColorToHex(LightenColor(Color, 15)) + ';');
 vMenuHTML.Add('  }');
 vMenuHTML.Add('}');
 vMenuHTML.Add('@media screen and (max-width:991px) {');
 vMenuHTML.Add('  /* BackGround Button DropDown in Right */');
 vMenuHTML.Add('  .d2bridgemainmenu .d2bridgemenuright .dropdown .dropdown-menu {');
 vMenuHTML.Add('    background-color: ' + ColorToHex(LightenColor(Color, 15)) + ';');
 vMenuHTML.Add('    transform: translateX(10px);');
 vMenuHTML.Add('  }');
 vMenuHTML.Add('}');


 vMenuHTML.Add('</style>');


 try
  try
   //Panel TOP
   if PanelTopItemsHTML <> '' then
    vMenuHTML.Add(PanelTopItemsHTML);


   //Begin
   vMenuHTML.Add('<nav '+ HTMLCore + ifThen(Transparent, ' transparent') +'>');
   vMenuHTML.Add('<div class="d2bridgemainmenucontent container-fluid">');

   if not Image.IsEmpty then
   begin
    if Image.IsBase64 then
     vMenuHTML.Add('<div class="d2bridgemainmenulogo"><a href="#" class="navbar-brand" onclick="{{CallBack=CallBackHome}}"><img class="img-fluid" src="data:image/jpeg;base64, '+ Image.ImageToBase64 +'" alt="header-logo" id="' + AnsiUpperCase(NamePrefix) + 'image"></a></div>')
    else
     vMenuHTML.Add('<div class="d2bridgemainmenulogo"><a href="#" class="navbar-brand" onclick="{{CallBack=CallBackHome}}"><img class="img-fluid" src="' + Image.URL +'" alt="header-logo" id="' + AnsiUpperCase(NamePrefix) + 'image"></a></div>')
   end;

   if Title <> '' then
    vMenuHTML.Add('<a class="d2bridgemainmenutitle navbar-brand" href="#" onclick="{{CallBack=CallBackHome}}">' + Title + '</a>')
   else
   if Image.IsEmpty then
    vMenuHTML.Add('<a class="d2bridgemainmenutitle navbar-brand" href="#" onclick="{{CallBack=CallBackHome}}">' + D2BridgeServerControllerBase.APPName + '</a>');


   //Toggle Button and Accessory
   vMenuHTML.Add('<div class="d-flex order-lg-last align-items-center">');

   //Button
   vMenuHTML.Add('<button class="d2bridgemainmenubutton navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#' + AnsiUpperCase(NamePrefix) + 'Content" aria-controls="' + AnsiUpperCase(NamePrefix) + 'Content" aria-expanded="false" aria-label="Toggle navigation" id="' + AnsiUpperCase(NamePrefix) + 'button">');
   vMenuHTML.Add('    <svg class="navbar-toggler-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 30 30" width="30" height="30">');
   vMenuHTML.Add('       <path d="M4 7h22M4 15h22M4 23h22" stroke="currentColor" stroke-width="2" linecap="round" linejoin="round"></path>');
   vMenuHTML.Add('    </svg>');
   vMenuHTML.Add('</button>');

   //Accessory Items
   if AccessoryItemsHTML <> '' then
    vMenuHTML.Add(AccessoryItemsHTML);

   //End Toggle Button and Accessory
   vMenuHTML.Add('</div>');



   //Begin Navbar
   vMenuHTML.Add('<div class="d2bridgemenuarea collapse navbar-collapse ' + MenuAlignCSS + '" id="' + AnsiUpperCase(NamePrefix) + 'Content">');
   vMenuHTML.Add('<div class="col">');


   vExistMenuItem:= false;
   for I := 0 to Pred(MenuItems.Items.Count) do
   begin
    if MenuItems.Items[I].Visible and MenuItems.Items[I].Enabled then
    begin
     vExistMenuItem:= true;
     break;
    end;
   end;
   if vExistMenuItem then
   begin
    vMenuHTML.Add('<ul class="d2bridgemainmenubox navbar-nav me-auto mb-2 mb-lg-0">');
    for I := 0 to Pred(MenuItems.Items.Count) do
    begin
     if MenuItems.Items[I].Visible and MenuItems.Items[I].Enabled then
      RenderHTMLMenuItem(MenuItems, MenuItems.Items[I], vMenuHTML);
    end;
    //End Navbar
    vMenuHTML.Add('</ul>');
   end;


   //End Col
   vMenuHTML.Add('</div>');



   //Right Items
   if RightItemsHTML <> '' then
    vMenuHTML.Add(RightItemsHTML);



   //End Navbar
   vMenuHTML.Add('</div>');
   vMenuHTML.Add('</nav>');


   //Panel Bottom
   if PanelBottomItemsHTML <> '' then
    vMenuHTML.Add(PanelBottomItemsHTML);


   //Script
   vMenuHTML.Add('<script type="text/javascript">');
   vMenuHTML.Add('{');
   vMenuHTML.Add('   let _menu'+AnsiUpperCase(NamePrefix)+' = document.querySelector("#'+AnsiUpperCase(NamePrefix)+'container");');
   vMenuHTML.Add('   if (_menu'+AnsiUpperCase(NamePrefix)+') {');
   vMenuHTML.Add('      let _d2bridgecontent'+AnsiUpperCase(NamePrefix)+' = document.querySelector("#'+(Form as TPrismForm).D2BridgeForm.D2Bridge.HTML.Render.idDIVContent+'");');
   vMenuHTML.Add('      document.body.insertBefore(_menu'+AnsiUpperCase(NamePrefix)+', _d2bridgecontent'+AnsiUpperCase(NamePrefix)+');');
   vMenuHTML.Add('   }');
   if ((Form as TPrismForm).D2BridgeForm.D2Bridge.FrameworkExportType.TemplateMasterHTMLFile = '') and
      ((Form as TPrismForm).D2BridgeForm.D2Bridge.FrameworkExportType.TemplatePageHTMLFile = '') then
   //vMenuHTML.Add('document.body.style.backgroundColor = "#f0f0f0";');
   vMenuHTML.Add('  function adjustMainMenuNavbarPosition() {');
   vMenuHTML.Add('    const scrollLeft = window.scrollX;');
   vMenuHTML.Add('    const navbar = document.getElementById("'+AnsiUpperCase(NamePrefix)+'");');
   vMenuHTML.Add('    navbar.style.transform = `translateX(${scrollLeft}px)`;');
   vMenuHTML.Add('  }');
   vMenuHTML.Add('  window.addEventListener("scroll", adjustMainMenuNavbarPosition);');
   vMenuHTML.Add('}');
   vMenuHTML.Add('</script>');


   //End Menu Container
   vMenuHTML.Add('</div>');


   HTMLControl := vMenuHTML.Text;
  except
  end;
 finally
  vMenuHTML.Free;
 end;


end;

procedure TPrismMainMenu.RenderHTMLMenuItem(APrismMenuItems: IPrismMenuItems; APrismMenuItem: IPrismMenuItem; var AMenuHTML: TStrings);
var
 I: integer;
 vDisabledItemMenu: string;
 vExistMenuItem: boolean;
begin
 vDisabledItemMenu:= '';

 if not APrismMenuItem.Enabled then
  vDisabledItemMenu:= ' menuitemdisable';

 if APrismMenuItem.IsLink then
 begin
  if APrismMenuItem.Owner is TPrismMenu then
  begin
   AMenuHTML.Add('<li class="d2bridgemainmenuitem nav-item' + vDisabledItemMenu + '">');
   AMenuHTML.Add('<a class="d2bridgemainmenuitemlink nav-link" href="#" id="' + APrismMenuItem.Name + '" onclick="' + Events.Item(EventOnSelect).EventJS(ExecEventProc, 'this.id', true) + '">' + APrismMenuItem.Caption + '</a>');
   AMenuHTML.Add('</li>');
  end else
  if APrismMenuItem.Owner is TPrismMenuItemSubMenu then
  begin
   AMenuHTML.Add('<li class="d2bridgemainmenudropdownmenuitem' + vDisabledItemMenu + '">');
   AMenuHTML.Add('<a class="d2bridgemainmenuitemlink dropdown-item" href="#" id="' + APrismMenuItem.Name + '" onclick="' + Events.Item(EventOnSelect).EventJS(ExecEventProc, 'this.id', true) + '">' + APrismMenuItem.Caption + '</a>');
   AMenuHTML.Add('</li>');
  end;
 end else
 if APrismMenuItem.IsSubMenu then
 begin
  if APrismMenuItems.Owner is TPrismMenu then
  begin
   AMenuHTML.Add('<li class="d2bridgemainmenudropdownitem nav-item dropdown' + vDisabledItemMenu + '">');
   AMenuHTML.Add('<a class="d2bridgemainmenuitemlink nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">');
   AMenuHTML.Add(APrismMenuItem.Caption);
   AMenuHTML.Add('</a>');
  end else
  if APrismMenuItems.Owner is TPrismMenuItemSubMenu then
  begin
   AMenuHTML.Add('<li class="d2bridgemainmenuitemsubmenu nav-item dropend' + vDisabledItemMenu + '">');
   AMenuHTML.Add('<a class="d2bridgemainmenusubdropdown nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">');
   AMenuHTML.Add(APrismMenuItem.Caption);
   AMenuHTML.Add('</a>');
  end;


  //Checa se existe submenu visivel e habilitado
  vExistMenuItem:= false;
  for I := 0 to Pred((APrismMenuItem as TPrismMenuItemSubMenu).MenuItems.Items.Count) do
  begin
   if ((APrismMenuItem as TPrismMenuItemSubMenu).MenuItems.Items[I].Visible) then
   begin
    vExistMenuItem:= true;
    break;
   end;
  end;
  if vExistMenuItem then
  begin
   AMenuHTML.Add('<ul class="d2bridgemainmenudropdownmenu dropdown-menu' + vDisabledItemMenu + '">');
   for I := 0 to Pred((APrismMenuItem as TPrismMenuItemSubMenu).MenuItems.Items.Count) do
   begin
    if ((APrismMenuItem as TPrismMenuItemSubMenu).MenuItems.Items[I].Visible) then
     RenderHTMLMenuItem((APrismMenuItem as TPrismMenuItemSubMenu).MenuItems, (APrismMenuItem as TPrismMenuItemSubMenu).MenuItems.Items[I], AMenuHTML);
   end;
   AMenuHTML.Add('</ul>');
  end;

 end;
end;

procedure TPrismMainMenu.SetAccessoryItemsHTML(const Value: String);
begin
 FAccessoryItemsHTML:= Value;
end;

procedure TPrismMainMenu.SetMenuAlign(const Value: TPrismAlignment);
begin
 FMenuAlign:= Value;
end;

procedure TPrismMainMenu.SetRightItemsHTML(const Value: String);
begin
 FRightItemsHTML:= Value;
end;

procedure TPrismMainMenu.SetPanelBottomItemsHTML(const Value: String);
begin
 FPanelBottomItemsHTML:= Value;
end;

procedure TPrismMainMenu.SetPanelTopItemsHTML(const Value: String);
begin
 FPanelTopItemsHTML:= Value;
end;

procedure TPrismMainMenu.SetTransparent(const Value: Boolean);
begin
 FTransparent:= Value;
end;

procedure TPrismMainMenu.UpdateServerControls(var ScriptJS: TStrings;
  AForceUpdate: Boolean);
begin
  inherited;

  if (AForceUpdate) then
  begin

  end;

// NewText:= Text;
// if (AForceUpdate) or (FStoredText <> NewText) then
// begin
//  FStoredText := NewText;
//  ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").textContent = `'+  FStoredText +'`;');
// end;

end;

end.
