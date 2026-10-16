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

unit Prism.Tabs;

interface

uses
  Classes, SysUtils, D2Bridge.JSON, StrUtils, Generics.Collections,
{$IFDEF FMX}

{$ELSE}

{$ENDIF}
  Prism.Forms.Controls, Prism.Interfaces, Prism.Types;


type
 TPrismTabs = class(TPrismControl, IPrismTabs)
  private
   FActiveTabIndex: integer;
   FShowTabs: Boolean;
   FTabsCaption: TDictionary<integer,string>;
   function GetActiveTabIndex: integer;
   procedure SetActiveTabIndex(Value: integer);
   procedure OnTabChange(EventParams: TStrings);
   procedure SetTabVisible(Index: Integer; Value: Boolean);
   function GetShowTabs: Boolean;
   procedure SetShowTabs(const Value: Boolean);
   procedure SetTabVisibleFromCaption(ACaption: string; const Value: Boolean);
  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
  public
   constructor Create(AOwner: TObject); override;
   destructor Destroy; override;

   function IsTabs: boolean; override;

   procedure AddTab(AIndex: integer; ATitle: String);

   property ActiveTabIndex: integer read GetActiveTabIndex write SetActiveTabIndex;
   property TabVisible[Index: Integer]: Boolean write SetTabVisible;
   property TabVisibleFromCaption[ACaption: string]: Boolean write SetTabVisibleFromCaption;
   property ShowTabs: Boolean read GetShowTabs write SetShowTabs;
 end;



implementation

uses
  Prism.Util, Prism.Events;


procedure TPrismTabs.AddTab(AIndex: integer; ATitle: String);
begin
 if not FTabsCaption.ContainsKey(AIndex) then
  FTabsCaption.Add(AIndex, '');

 FTabsCaption[AIndex]:= ATitle;
end;

constructor TPrismTabs.Create(AOwner: TObject);
var
 vTabChange: TPrismControlEvent;
begin
 inherited;

 FTabsCaption:= TDictionary<integer,string>.Create;

 FShowTabs:= true;
 FActiveTabIndex:= 0;

 vTabChange := TPrismControlEvent.Create(self, EventOnChange);
 vTabChange.AutoPublishedEvent:= false;
 vTabChange.SetOnEvent(OnTabChange);
 Events.Add(vTabChange);
end;

destructor TPrismTabs.Destroy;
begin
 FTabsCaption.Free;

 inherited;
end;

function TPrismTabs.GetActiveTabIndex: integer;
begin
 Result:= FActiveTabIndex;
end;

function TPrismTabs.GetEnableComponentState: Boolean;
begin
 Result:= true;
end;

function TPrismTabs.GetShowTabs: Boolean;
begin
 result:= FShowTabs;
end;

procedure TPrismTabs.Initialize;
begin
 inherited;
end;

function TPrismTabs.IsTabs: boolean;
begin
 result:= true
end;

procedure TPrismTabs.OnTabChange(EventParams: TStrings);
var
 vTabIndex: integer;
begin
 if TryStrToInt(EventParams.Values['tabindex'], vTabIndex) then
 begin
  FActiveTabIndex:= vTabIndex;

 end;
end;

procedure TPrismTabs.ProcessComponentState(const ComponentStateInfo: TJSONObject);
begin
 inherited;

end;

procedure TPrismTabs.ProcessEventParameters(Event: IPrismControlEvent;
  Parameters: TStrings);
begin
  inherited;

end;

procedure TPrismTabs.ProcessHTML;
begin
 inherited;

 if ShowTabs then
  HTMLControl:= StringReplace(HTMLControl, 'd2bridgetabs-invisible', 'd2bridgetabs', [rfReplaceAll])
 else
  HTMLControl:= StringReplace(HTMLControl, 'd2bridgetabs', 'd2bridgetabs-invisible', [rfReplaceAll]);
end;

procedure TPrismTabs.SetActiveTabIndex(Value: integer);
begin
  FActiveTabIndex:= Value;

// if FShowTabs then
//  Session.ExecJS(
//   'if ($("#TABS_' + UpperCase(NamePrefix) + '_BUTTON' + IntToStr(FActiveTabIndex) + '").is(":visible")) { ' +
//   '   document.querySelector(''[data-bs-target="#TABS_' + UpperCase(NamePrefix) + '_ITEM' + IntToStr(FActiveTabIndex) + '"]'').click(); '+
//   '}'
//  )
// else
//  Session.ExecJS(
//   'document.querySelector(''[data-bs-target="#TABS_' + UpperCase(NamePrefix) + '_ITEM' + IntToStr(FActiveTabIndex) + '"]'').click();'
//  )

  Session.ExecJS(
   'document.querySelector(''[data-bs-target="#TABS_' + UpperCase(NamePrefix) + '_ITEM' + IntToStr(FActiveTabIndex) + '"]'').click();'
  )
end;

procedure TPrismTabs.SetShowTabs(const Value: Boolean);
begin
 FShowTabs:= Value;

 if Initilized then
 begin
  if Value then
  begin
   Session.ExecJS(
    '$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix+'tabs')+'";}).removeClass("d2bridgetabs-invisible"); ' + sLineBreak +
    '$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix+'tabs')+'";}).addClass("d2bridgetabs");'
   );
  end else
  begin
   Session.ExecJS(
    '$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix+'tabs')+'";}).removeClass("d2bridgetabs"); ' + sLineBreak +
    '$("[id]").filter(function() {return this.id.toUpperCase() === "'+AnsiUpperCase(NamePrefix+'tabs')+'";}).addClass("d2bridgetabs-invisible");'
   );
  end;
 end;
end;

procedure TPrismTabs.SetTabVisible(Index: Integer; Value: Boolean);
begin
 if Index <> ActiveTabIndex then
  Session.ExecJS(
   '$("#TABS_' + UpperCase(NamePrefix) + '_BUTTON' + IntToStr(Index) + '").' + ifthen(Value, 'show()', 'hide()') + '; '
  );
end;

procedure TPrismTabs.SetTabVisibleFromCaption(ACaption: string; const Value: Boolean);
var
 vIndex: integer;
 I: integer;
 vKeys: TArray<integer>;
begin
 vIndex:= -1;

 if FTabsCaption.Count <= 0 then
  exit;

 vKeys:= FTabsCaption.Keys.ToArray;

 for I := 0 to Pred(Length(vKeys)) do
  if SameText(FTabsCaption[vKeys[I]], ACaption) then
  begin
   vIndex:= vKeys[I];
   break;
  end;

 if vIndex > 0 then
  SetTabVisible(vIndex, Value);
end;

procedure TPrismTabs.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
begin
 inherited;

end;

end.