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

{$I ..\D2Bridge.inc}

unit Prism.SideMenu;

interface

uses
  Classes,
  Prism.Interfaces, Prism.Menu, D2Bridge.JSON;

type
 TPrismSideMenu = class(TPrismMenu, IPrismSideMenu)
  private
   vGroupIndex: Integer;
   FAccessoryItemsHTML: string;
   procedure RenderHTMLMenuItem(APrismMenuItems: IPrismMenuItems; APrismMenuItem: IPrismMenuItem; var AMenuHTML: TStrings);
   function GetAccessoryItemsHTML: String;
   procedure SetAccessoryItemsHTML(const Value: String);
  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   function AlwaysInitialize: Boolean; override;
  public
   destructor Destroy; override;

   function IsSideMenu: Boolean; override;

   property AccessoryItemsHTML: String read GetAccessoryItemsHTML write SetAccessoryItemsHTML;
 end;

const
   FCSSIconLink = 'fa-solid fa-share-nodes';
   FCSSIconDropDown = 'fa-solid fa-layer-group';

implementation

uses
  SysUtils,
  D2Bridge.Util,
  Prism.Menu.SubMenu, Prism.Types, Prism.Forms, D2Bridge.ServerControllerBase;

{ TPrismSideMenu }

function TPrismSideMenu.AlwaysInitialize: Boolean;
begin
 result:= true;
end;

destructor TPrismSideMenu.Destroy;
begin

  inherited;
end;

function TPrismSideMenu.GetAccessoryItemsHTML: String;
begin
 Result:= FAccessoryItemsHTML;
end;

function TPrismSideMenu.GetEnableComponentState: Boolean;
begin
 HTMLControl := '';
end;

procedure TPrismSideMenu.Initialize;
begin
  inherited;

end;

function TPrismSideMenu.IsSideMenu: Boolean;
begin
 Result:= true;
end;

procedure TPrismSideMenu.ProcessComponentState(
  const ComponentStateInfo: TJSONObject);
begin
  inherited;

end;

procedure TPrismSideMenu.ProcessEventParameters(Event: IPrismControlEvent;
  Parameters: TStrings);
begin
  inherited;

end;

procedure TPrismSideMenu.ProcessHTML;
var
 vMenuHTML: TStrings;
 I: Integer;
 vSubTitleAPP: string;
begin
 inherited;

 vGroupIndex:= -1;

 HTMLControl := '';

 vSubTitleAPP:= (Form as TPrismForm).D2BridgeForm.SubTitle;

 vMenuHTML:= TStringList.Create;

 try
  try
   {$REGION 'Menu'}
    //Begin
    vMenuHTML.Add('<nav '+ HTMLCore +'>');
    vMenuHTML.Add('<div class="h-100">');

    //Logo SideMenu
    vMenuHTML.Add('<div class="d2bridgesidemenulogo text-center">');

    if not Image.IsEmpty then
    begin
     if Image.IsBase64 then
      vMenuHTML.Add('<img class="d2bridgesidemenulogoimage img-fluid" src="data:image/jpeg;base64, '+ Image.ImageToBase64 +'" alt="header-logo" id="' + AnsiUpperCase(NamePrefix) + 'image">')
     else
      vMenuHTML.Add('<img class="d2bridgesidemenulogoimage img-fluid" src="' + Image.URL +'" alt="header-logo" id="' + AnsiUpperCase(NamePrefix) + 'image">')
    end;

    if Title <> '' then
     vMenuHTML.Add('<span class="d2bridgesidemenulogotitle">' + Title + '</span>')
    else
    if Image.IsEmpty then
     vMenuHTML.Add('<span class="d2bridgesidemenulogotitle">' + D2BridgeServerControllerBase.APPName + '</span>');

    vMenuHTML.Add('</div>');

    //Begin Menu Render
    vMenuHTML.Add('<div class="d2bridgesidemenu-scrollable">');
    vMenuHTML.Add('<ul class="d2bridgesidemenuitem-nav">');

    for I := 0 to Pred(MenuItems.Items.Count) do
    begin
     if MenuItems.Items[I].Enabled and MenuItems.Items[I].Visible then
      RenderHTMLMenuItem(MenuItems, MenuItems.Items[I], vMenuHTML);
    end;

    //End Menu Render
    vMenuHTML.Add('</ul>');
    vMenuHTML.Add('</div>');

    //End
    vMenuHTML.Add('</div>');
    vMenuHTML.Add('</nav>');
   {$ENDREGION}


   {$REGION 'Page Content'}
    //Page Content
    vMenuHTML.Add('<div class="d2bridgesidemenucontent" id="' + AnsiUpperCase(NamePrefix) + 'content"></div>');


    //CSS
    vMenuHTML.Add('<style type="text/css">');

    vMenuHTML.Add('/* Body BackGround */');
    vMenuHTML.Add('.d2bridgesidemenucontent {');
    vMenuHTML.Add('  background-color: ' + (Form as TPrismForm).D2BridgeForm.D2Bridge.HTML.Render.BackGroundColor  + ' !important;');
    vMenuHTML.Add('}');
    vMenuHTML.Add('/* BackGround Color */');
    vMenuHTML.Add('nav.d2bridgesidemenu {');
    vMenuHTML.Add('  background-color: ' + ColorToHex(Color) + ' !important;');
    vMenuHTML.Add('}');
    vMenuHTML.Add('.d2bridgesidemenu {');
    vMenuHTML.Add('  color: ' + ColorToHex(MenuTextColor) + ' !important;');
    vMenuHTML.Add('}');
    vMenuHTML.Add('/* Title Color */');
    vMenuHTML.Add('.d2bridgesidemenu .d2bridgesidemenutitle {');
    vMenuHTML.Add('  color: ' + ColorToHex(TitleColor) + ';');
    vMenuHTML.Add('}');
    vMenuHTML.Add('.d2bridgesidemenu .d2bridgesidemenu-link {');
    vMenuHTML.Add('  color: ' + ColorToHex(MenuTextColor) + ';');
    vMenuHTML.Add('}');
    vMenuHTML.Add('.d2bridgesidemenu-header {');
    vMenuHTML.Add('  color: ' + ColorToHex(MenuTextColor) + ';');
    vMenuHTML.Add('}');
    vMenuHTML.Add('/* Button Ico */');
    vMenuHTML.Add('.d2bridgsidemenu .navbar-toggler-icon {');
    vMenuHTML.Add('  color: ' + ColorToHex(MenuTextColor) + ';');
    vMenuHTML.Add('}');
    vMenuHTML.Add('.d2bridgesidemenu .navbar-toggler:focus {');
    vMenuHTML.Add('    color: ' + ColorToHex(MenuTextColor) + ';');
    vMenuHTML.Add('}');
    vMenuHTML.Add('</style>');


    //Nav
    vMenuHTML.Add('<nav class="navbar navbar-expand d2bridgesidemenutop border-bottom" id="' + AnsiUpperCase(NamePrefix) + 'navtop">');
    vMenuHTML.Add('<div class="px-3">');
    vMenuHTML.Add('<button class="btn d2bridgesidemenubutton" id="' + AnsiUpperCase(NamePrefix) + 'button" type="button">');
    vMenuHTML.Add('<span class="navbar-toggler-icon"></span>');
    vMenuHTML.Add('</button>');
    vMenuHTML.Add('</div>');
    vMenuHTML.Add('<div id="' + AnsiUpperCase(NamePrefix) + 'title" class="navbar-brand">');
    vMenuHTML.Add('<span class="navbar-brand d2bridgesidemenutitle">' + (Form as TPrismForm).D2BridgeForm.Title + '</span>');
    vMenuHTML.Add('</div>');
//    vMenuHTML.Add('<div class="d2bridgesidemenulogo">');
//    if Title <> '' then
//     vMenuHTML.Add('<a href="#">' + Title + '</a>')
//    else
//     vMenuHTML.Add('<a href="#">D2Bridge</a>');
//    vMenuHTML.Add('</div>');
    vMenuHTML.Add('<div class="navbar-collapse navbar d-flex justify-content-end gap-2 px-3">');
    vMenuHTML.Add('<div class="d2bridgesidemenutopbox">');

    //Accessory Items
    if AccessoryItemsHTML <> '' then
     vMenuHTML.Add(AccessoryItemsHTML);

    vMenuHTML.Add('</div>');
    vMenuHTML.Add('</div>');
    vMenuHTML.Add('</nav>');

    //SubTitle
    if vSubTitleAPP <> '' then
     vMenuHTML.Add('<div id="' + AnsiUpperCase(NamePrefix) + 'subtitle" class="row d2bridgesidemenusubtitlebox pb-2"><span class="d2bridgesidemenusubtitle">' + vSubTitleAPP + '</span></div>');
   {$ENDREGION}


   //Script
   vMenuHTML.Add('<script type="text/javascript">');

   vMenuHTML.Add('const _' + AnsiUpperCase(NamePrefix)+ 'button = document.querySelector("#' + AnsiUpperCase(NamePrefix)+ 'button");');
   vMenuHTML.Add('_'+AnsiUpperCase(NamePrefix)+ 'button.addEventListener("click",function(){');
   vMenuHTML.Add('document.querySelector("#' + AnsiUpperCase(NamePrefix)+ '").classList.toggle("collapsed");');
   vMenuHTML.Add('});');

   vMenuHTML.Add('{');
   vMenuHTML.Add('   let _menu'+AnsiUpperCase(NamePrefix)+' = document.querySelector("#'+AnsiUpperCase(NamePrefix)+'");');
   vMenuHTML.Add('   if (_menu'+AnsiUpperCase(NamePrefix)+') {');
   vMenuHTML.Add('      let _menu'+AnsiUpperCase(NamePrefix)+'content = document.querySelector("#'+AnsiUpperCase(NamePrefix)+'content");');
   vMenuHTML.Add('      document.body.insertBefore(_menu'+AnsiUpperCase(NamePrefix)+'content, document.body.firstChild);');
   vMenuHTML.Add('      document.body.insertBefore(_menu'+AnsiUpperCase(NamePrefix)+', document.body.firstChild);');
   vMenuHTML.Add('      let _d2bridgecontent = document.querySelector("#'+(Form as TPrismForm).D2BridgeForm.D2Bridge.HTML.Render.idDIVContent+'");');
   vMenuHTML.Add('      _menu'+AnsiUpperCase(NamePrefix)+'content = document.querySelector("#'+AnsiUpperCase(NamePrefix)+'content");');
   vMenuHTML.Add('      _menu'+AnsiUpperCase(NamePrefix)+'content.insertBefore(_d2bridgecontent, _menu'+AnsiUpperCase(NamePrefix)+'content.firstChild);');
   vMenuHTML.Add('      let _menu'+AnsiUpperCase(NamePrefix)+'navtop = document.querySelector("#'+AnsiUpperCase(NamePrefix)+'navtop");');
   vMenuHTML.Add('      _menu'+AnsiUpperCase(NamePrefix)+'content.insertBefore(_menu'+AnsiUpperCase(NamePrefix)+'navtop, _menu'+AnsiUpperCase(NamePrefix)+'content.firstChild);');
   vMenuHTML.Add('      let _d2bridgecontainer = document.querySelector("#'+(Form as TPrismForm).D2BridgeForm.D2Bridge.HTML.Render.idDIVContainer+'");');
   if vSubTitleAPP <> '' then
   begin
    vMenuHTML.Add('      let _menu'+AnsiUpperCase(NamePrefix)+'subtitle = document.querySelector("#'+AnsiUpperCase(NamePrefix)+'subtitle");');
    vMenuHTML.Add('      if (_d2bridgecontainer) {');
    vMenuHTML.Add('         _d2bridgecontainer.insertBefore(_menu'+AnsiUpperCase(NamePrefix)+'subtitle, _d2bridgecontainer.firstChild);');
    vMenuHTML.Add('      } else {');
    vMenuHTML.Add('         _d2bridgecontent.insertBefore(_menu'+AnsiUpperCase(NamePrefix)+'subtitle, _d2bridgecontent.firstChild);');
    vMenuHTML.Add('      }');
   end;
   vMenuHTML.Add('   }');
   vMenuHTML.Add('}');
   vMenuHTML.Add('</script>');



   //Script
//   vMenuHTML.Add('<script type="text/javascript">');
//   vMenuHTML.Add('   let _menu'+AnsiUpperCase(NamePrefix)+' = document.querySelector("#'+AnsiUpperCase(NamePrefix)+'");');
//   vMenuHTML.Add('   if (_menu'+AnsiUpperCase(NamePrefix)+') {');
//   vMenuHTML.Add('      document.body.insertBefore(_menu'+AnsiUpperCase(NamePrefix)+', document.body.firstChild);');
//   vMenuHTML.Add('   }');
//   vMenuHTML.Add('</script>');

   HTMLControl := vMenuHTML.Text;
  except
  end;
 finally
  vMenuHTML.Free;
 end;
end;

procedure TPrismSideMenu.RenderHTMLMenuItem(APrismMenuItems: IPrismMenuItems; APrismMenuItem: IPrismMenuItem; var AMenuHTML: TStrings);
var
 I: integer;
 vMenuItemGroup: IPrismMenuItemGroup;
begin
 //Group
 if APrismMenuItem.GroupIndex > vGroupIndex then
 begin
  vGroupIndex:= APrismMenuItem.GroupIndex;
  AMenuHTML.Add('<li class="d2bridgesidemenu-header">');
  if Assigned(APrismMenuItem.MenuItemGroup) and (APrismMenuItem.MenuItemGroup.Caption <> '') then
  begin
   if APrismMenuItem.MenuItemGroup.Icon <> '' then
    AMenuHTML.Add('<i class="'+ APrismMenuItem.MenuItemGroup.Icon +' pe-2"></i>');

   AMenuHTML.Add(APrismMenuItem.MenuItemGroup.Caption)
  end else
   AMenuHTML.Add('Menu');
  AMenuHTML.Add('</li>');
 end;

 if APrismMenuItem.IsLink then
 begin
  if APrismMenuItem.Owner is TPrismMenu then
  begin
   AMenuHTML.Add('<li class="d2bridgesidemenu-item">');
   AMenuHTML.Add('<a class="d2bridgesidemenu-link" href="#" id="' + APrismMenuItem.Name + '" onclick="' + Events.Item(EventOnSelect).EventJS(ExecEventProc, 'this.id', true) + '">');
   if APrismMenuItem.Icon <> '' then
    AMenuHTML.Add('<i class="'+ APrismMenuItem.Icon +' pe-2"></i>')
   else
    AMenuHTML.Add('<i class="'+ FCSSIconLink +' pe-2"></i>');
   AMenuHTML.Add(APrismMenuItem.Caption);
   AMenuHTML.Add('</a>');
   AMenuHTML.Add('</li>');
  end else
  if APrismMenuItem.Owner is TPrismMenuItemSubMenu then
  begin
   AMenuHTML.Add('<li class="d2bridgesidemenu-item">');
   AMenuHTML.Add('<a class="d2bridgesidemenu-link d2bridgesidebarmenulevel' + IntToStr(APrismMenuItem.Level) + '" href="#" id="' + APrismMenuItem.Name + '" onclick="' + Events.Item(EventOnSelect).EventJS(ExecEventProc, 'this.id', true) + '">');
   if APrismMenuItem.Icon <> '' then
    AMenuHTML.Add('<i class="'+ APrismMenuItem.Icon +' pe-2"></i>')
   else
    AMenuHTML.Add('<i class="'+ FCSSIconLink +' pe-2"></i>');
   AMenuHTML.Add(APrismMenuItem.Caption);
   AMenuHTML.Add('</a>');
   AMenuHTML.Add('</li>');
  end;
 end else
 if APrismMenuItem.IsSubMenu then
 begin
  if APrismMenuItems.Owner is TPrismMenu then
  begin
   AMenuHTML.Add('<li class="d2bridgesidemenu-item">');
   AMenuHTML.Add('<a class="d2bridgesidemenu-link collapsed" href="#" role="button" data-bs-target="#' + APrismMenuItem.Name + '" data-bs-toggle="collapse" aria-expanded="false">');
   if APrismMenuItem.Icon <> '' then
    AMenuHTML.Add('<i class="'+ APrismMenuItem.Icon +' pe-2"></i>')
   else
    AMenuHTML.Add('<i class="'+ FCSSIconDropDown +' pe-2"></i>');
   AMenuHTML.Add(APrismMenuItem.Caption);
   AMenuHTML.Add('</a>');
  end else
  if APrismMenuItems.Owner is TPrismMenuItemSubMenu then
  begin
   AMenuHTML.Add('<li class="d2bridgesidemenu-item">');
   AMenuHTML.Add('<a class="d2bridgesidemenu-link d2bridgesidebarmenulevel' + IntToStr(APrismMenuItem.Level) + ' collapsed" href="#" data-bs-target="#' + APrismMenuItem.Name + '" data-bs-toggle="collapse" aria-expanded="false">');
   if APrismMenuItem.Icon <> '' then
    AMenuHTML.Add('<i class="'+ APrismMenuItem.Icon +' pe-2"></i>')
   else
    AMenuHTML.Add('<i class="'+ FCSSIconDropDown +' pe-2"></i>');
   AMenuHTML.Add(APrismMenuItem.Caption);
   AMenuHTML.Add('</a>');
  end;

  AMenuHTML.Add('<ul class="d2bridgesidemenu-dropdown list-unstyled collapse" id="' + APrismMenuItem.Name + '" data-bs-parent="' + AnsiUpperCase(NamePrefix) + '">');
  for I := 0 to Pred((APrismMenuItem as TPrismMenuItemSubMenu).MenuItems.Items.Count) do
  begin
   if ((APrismMenuItem as TPrismMenuItemSubMenu).MenuItems.Items[I].Visible) and ((APrismMenuItem as TPrismMenuItemSubMenu).MenuItems.Items[I].Enabled) then
    RenderHTMLMenuItem((APrismMenuItem as TPrismMenuItemSubMenu).MenuItems, (APrismMenuItem as TPrismMenuItemSubMenu).MenuItems.Items[I], AMenuHTML);
  end;

  AMenuHTML.Add('</ul>');
 end;
end;

procedure TPrismSideMenu.SetAccessoryItemsHTML(const Value: String);
begin
 FAccessoryItemsHTML:= Value;
end;

procedure TPrismSideMenu.UpdateServerControls(var ScriptJS: TStrings;
  AForceUpdate: Boolean);
begin
  inherited;

end;

end.