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

unit Prism.Tabs;

interface

uses
  Classes, SysUtils, D2Bridge.JSON, StrUtils,
{$IFDEF FMX}

{$ELSE}

{$ENDIF}
  Prism.Forms.Controls, Prism.Interfaces, Prism.Types;


type
 TPrismTabs = class(TPrismControl, IPrismTabs)
  private
   FActiveTabIndex: integer;
   FShowTabs: Boolean;
   function GetActiveTabIndex: integer;
   procedure SetActiveTabIndex(Value: integer);
   procedure OnTabChange(EventParams: TStrings);
   procedure SetTabVisible(Index: Integer; Value: Boolean);
   function GetShowTabs: Boolean;
   procedure SetShowTabs(const Value: Boolean);
  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
  public
   constructor Create(AOwner: TObject); override;

   function IsTabs: boolean; override;

   property ActiveTabIndex: integer read GetActiveTabIndex write SetActiveTabIndex;
   property TabVisible[Index: Integer]: Boolean write SetTabVisible;
   property ShowTabs: Boolean read GetShowTabs write SetShowTabs;
 end;



implementation

uses
  Prism.Util, Prism.Events;


constructor TPrismTabs.Create(AOwner: TObject);
var
 vTabChange: TPrismControlEvent;
begin
 inherited;

 FShowTabs:= true;
 FActiveTabIndex:= 0;

 vTabChange := TPrismControlEvent.Create(self, EventOnChange);
 vTabChange.AutoPublishedEvent:= false;
 vTabChange.SetOnEvent(OnTabChange);
 Events.Add(vTabChange);
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

procedure TPrismTabs.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
begin
 inherited;

end;

end.
