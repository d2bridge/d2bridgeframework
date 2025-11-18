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

unit Prism.Card;

interface

uses
  Classes, SysUtils, D2Bridge.JSON, StrUtils,
{$IFDEF FMX}

{$ELSE}

{$ENDIF}
  Prism.Forms.Controls, Prism.Interfaces, Prism.Types;


type
 TPrismCard = class(TPrismControl, IPrismCard)
  private
   FOnExit: TNotifyEvent;
   FExitProc: TProc;
   FCloseFormOnExit: Boolean;
   FTitle: string;
   FTitleHeader: string;
   FSubTitle: string;
   FText: string;
{$IFDEF FPC}
  protected
{$ENDIF}
   procedure OnExitEvent(EventParams: TStrings);
   function GetExitProc: TProc;
   function GetOnExit: TNotifyEvent;
   procedure SetExitProc(const Value: TProc);
   procedure SetOnExit(const Value: TNotifyEvent);
   function GetCloseFormOnExit: Boolean;
   procedure SetCloseFormOnExit(const Value: Boolean);
   function GetTitle: string;
   procedure SetTitle(ATitle: string);
   function GetTitleHeader: string;
   procedure SetTitleHeader(Value: string);
   function GetSubTitle: string;
   procedure SetSubTitle(ASubTitle: string);
   function GetText: string;
   procedure SetText(Value: string);
  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   function IsCard: Boolean; override;
  public
   constructor Create(AOwner: TObject); override;

   property CloseFormOnExit: Boolean read GetCloseFormOnExit write SetCloseFormOnExit;
   property OnExit: TNotifyEvent read GetOnExit write SetOnExit;
   property ExitProc: TProc read GetExitProc write SetExitProc;
   property Title: string read GetTitle write SetTitle;
   property TitleHeader: string read GetTitleHeader write SetTitleHeader;
   property SubTitle: string read GetSubTitle write SetSubTitle;
   property Text: string read GetText write SetText;
 end;



implementation

uses
  Prism.Util, Prism.Events, Prism.Forms;


constructor TPrismCard.Create(AOwner: TObject);
var
 vCardExit: TPrismControlEvent;
begin
 inherited;

 FCloseFormOnExit:= false;

 vCardExit := TPrismControlEvent.Create(self, EventOnExit);
 vCardExit.AutoPublishedEvent:= false;
 vCardExit.SetOnEvent(OnExitEvent);
 Events.Add(vCardExit);
end;

function TPrismCard.GetCloseFormOnExit: Boolean;
begin
 Result:= FCloseFormOnExit;
end;

function TPrismCard.GetEnableComponentState: Boolean;
begin
 Result:= true;
end;

function TPrismCard.GetExitProc: TProc;
begin
 Result:= FExitProc;
end;

function TPrismCard.GetOnExit: TNotifyEvent;
begin
 Result:= FOnExit;
end;

function TPrismCard.GetSubTitle: string;
begin
 result:= FSubTitle;
end;

function TPrismCard.GetText: string;
begin
 Result:= FText;
end;

function TPrismCard.GetTitle: string;
begin
 result:= FTitle;
end;

function TPrismCard.GetTitleHeader: string;
begin
 result:= FTitleHeader;
end;

procedure TPrismCard.Initialize;
begin
 inherited;
end;

function TPrismCard.IsCard: Boolean;
begin
 result:= true;
end;

procedure TPrismCard.OnExitEvent(EventParams: TStrings);
begin
 if FCloseFormOnExit and Assigned(Form) and ((Form as TPrismForm).D2BridgeForm <> nil) then
 begin
  (Form as TPrismForm).D2BridgeForm.Close;
 end else
  if Assigned(FOnExit) then
   FOnExit(VCLComponent)
  else
   if Assigned(FExitProc) then
    FExitProc;
end;

procedure TPrismCard.ProcessComponentState(const ComponentStateInfo: TJSONObject);
begin
 inherited;

end;

procedure TPrismCard.ProcessEventParameters(Event: IPrismControlEvent;
  Parameters: TStrings);
begin
  inherited;

end;

procedure TPrismCard.ProcessHTML;
begin
 inherited;

end;

procedure TPrismCard.SetCloseFormOnExit(const Value: Boolean);
begin
 FCloseFormOnExit:= Value;
end;

procedure TPrismCard.SetExitProc(const Value: TProc);
begin
 FExitProc:= Value;
end;

procedure TPrismCard.SetOnExit(const Value: TNotifyEvent);
begin
 FOnExit:= Value;
end;

procedure TPrismCard.SetSubTitle(ASubTitle: string);
begin
 FSubTitle:= ASubTitle;
end;

procedure TPrismCard.SetText(Value: string);
begin
 FText:= Value;
end;

procedure TPrismCard.SetTitle(ATitle: string);
begin
 FTitle:= ATitle;
end;

procedure TPrismCard.SetTitleHeader(Value: string);
begin
 FTitleHeader:= Value;
end;

procedure TPrismCard.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
begin
 inherited;

end;

end.
