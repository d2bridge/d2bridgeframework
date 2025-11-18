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

unit Prism.Link;

interface

uses
  Classes, SysUtils, D2Bridge.JSON,
{$IFDEF FMX}
  FMX.StdCtrls, FMX.Edit, FMX.Memo,
{$ELSE}
  StdCtrls, DBCtrls,
{$ENDIF}
  Prism.Forms.Controls, Prism.Interfaces, Prism.Types;


type
 TPrismLink = class(TPrismControl, IPrismLink)
  private
   FText: string;
   FOnClickCallBack: string;
   Fhref: string;
   FHint: string;
   FOnClick: TNotifyEvent;
   FLabel: TComponent;
   function GetText: String;
   procedure SetText(Value: string);
   function GetOnClickCallBack: String;
   procedure SetOnClickCallBack(Value: string);
   function Gethref: String;
   procedure Sethref(Value: string);
   function GetHint: String;
   procedure SetHint(Value: string);
   function GetOnClick: TNotifyEvent;
   procedure SetOnclick(Value: TNotifyEvent);
   function GetLabelHTMLElement: TComponent;
   procedure SetLabelHTMLElement(AComponent: TComponent);
  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessEvent(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   function IsLink: Boolean; override;
   function GetVisible: Boolean; override;
   function GetEnabled: Boolean; override;
  public
   FStoredText: string;
   FStoredOnClickCallBack: string;
   FStoredhref: string;
   FStoredHint: string;
   constructor Create(AOwner: TObject); override;

   property Text: String read GetText write SetText;
   property OnClickCallBack: String read GetOnClickCallBack write SetOnClickCallBack;
   property OnClick: TNotifyEvent read GetOnClick write SetOnclick;
   property href: String read Gethref write Sethref;
   property Hint: String read GetHint write SetHint;
   property LabelHTMLElement: TComponent read GetLabelHTMLElement write SetLabelHTMLElement;
 end;



implementation

uses
  Prism.Util, Prism.Events
  {$IFDEF DEVEXPRESS_AVAILABLE}
  , cxTextEdit, cxMemo, cxLabel, cxDBEdit, cxDBLabel
  {$ENDIF}
  ;


constructor TPrismLink.Create(AOwner: TObject);
begin
 inherited;

 href:= '#';

 Events.Add(TPrismControlEvent.Create(self, EventOnClick));
end;

function TPrismLink.GetEnableComponentState: Boolean;
begin
 Result:= true;
end;

function TPrismLink.GetEnabled: Boolean;
var
 vResult: boolean;
begin
 Result:= Inherited;
 vResult:= Result;

 if Assigned(LabelHTMLElement) then
 begin
  if (LabelHTMLElement is TLabel) //Label's
{$IFDEF DEVEXPRESS_AVAILABLE}
   or (LabelHTMLElement is TcxLabel)
   or (LabelHTMLElement is TcxDBLabel)
{$ENDIF}
{$IFNDEF FMX} or (LabelHTMLElement is TDBText){$ENDIF} then
   vResult:= TLabel(LabelHTMLElement).Enabled
  else
  if (LabelHTMLElement is TEdit) //Edit's
{$IFDEF DEVEXPRESS_AVAILABLE}
   or (LabelHTMLElement is TcxTextEdit)
   or (LabelHTMLElement is TcxDBTextEdit)
{$ENDIF}
{$IFNDEF FMX} or (LabelHTMLElement is TDBEdit){$ENDIF} then
   vResult:= TEdit(LabelHTMLElement).Enabled
  else
  if (LabelHTMLElement is TMemo) //Memo's
{$IFDEF DEVEXPRESS_AVAILABLE}
   or (LabelHTMLElement is TcxMemo)
   or (LabelHTMLElement is TcxDBMemo)
{$ENDIF}
{$IFNDEF FMX} or (LabelHTMLElement is TDBMemo){$ENDIF} then
   vResult:= TMemo(LabelHTMLElement).Enabled;

  if vResult <> Result then
   Enabled:= vResult;
 end;
end;

function TPrismLink.GetHint: String;
begin
 result:= FHint;
end;

function TPrismLink.Gethref: String;
begin
 result:= Fhref;
end;

function TPrismLink.GetLabelHTMLElement: TComponent;
begin
 result:= FLabel;
end;

function TPrismLink.GetOnClick: TNotifyEvent;
begin
 Result:= FOnClick;
end;

function TPrismLink.GetOnClickCallBack: String;
begin
 Result:= FOnClickCallBack;
end;

function TPrismLink.GetText: String;
begin
 if Assigned(LabelHTMLElement) then
 begin
  if (LabelHTMLElement is TLabel) //Label's
{$IFDEF DEVEXPRESS_AVAILABLE}
   or (LabelHTMLElement is TcxLabel)
   or (LabelHTMLElement is TcxDBLabel)
{$ENDIF}
{$IFNDEF FMX} or (LabelHTMLElement is TDBText){$ENDIF} then
   Result:= TLabel(LabelHTMLElement).{$IFNDEF FMX}Caption{$ELSE}Text{$ENDIF}
  else
  if (LabelHTMLElement is TEdit) //Edit's
{$IFDEF DEVEXPRESS_AVAILABLE}
   or (LabelHTMLElement is TcxTextEdit)
   or (LabelHTMLElement is TcxDBTextEdit)
{$ENDIF}
{$IFNDEF FMX} or (LabelHTMLElement is TDBEdit){$ENDIF} then
   Result:= TEdit(LabelHTMLElement).Text
  else
  if (LabelHTMLElement is TMemo) //Memo's
{$IFDEF DEVEXPRESS_AVAILABLE}
   or (LabelHTMLElement is TcxMemo)
   or (LabelHTMLElement is TcxDBMemo)
{$ENDIF}
{$IFNDEF FMX} or (LabelHTMLElement is TDBMemo){$ENDIF} then
   Result:= TrimRight(TMemo(LabelHTMLElement).Text)
 end else
  result:= FText;
end;

function TPrismLink.GetVisible: Boolean;
var
 vResult: boolean;
begin
 Result:= Inherited;

 if Assigned(LabelHTMLElement) then
 begin
  if (LabelHTMLElement is TLabel) //Label's
{$IFDEF DEVEXPRESS_AVAILABLE}
   or (LabelHTMLElement is TcxLabel)
   or (LabelHTMLElement is TcxDBLabel)
{$ENDIF}
{$IFNDEF FMX} or (LabelHTMLElement is TDBText){$ENDIF} then
   vResult:= TLabel(LabelHTMLElement).Visible
  else
  if (LabelHTMLElement is TEdit) //Edit's
{$IFDEF DEVEXPRESS_AVAILABLE}
   or (LabelHTMLElement is TcxTextEdit)
   or (LabelHTMLElement is TcxDBTextEdit)
{$ENDIF}
{$IFNDEF FMX} or (LabelHTMLElement is TDBEdit){$ENDIF} then
   vResult:= TEdit(LabelHTMLElement).Visible
  else
  if (LabelHTMLElement is TMemo) //Memo's
{$IFDEF DEVEXPRESS_AVAILABLE}
   or (LabelHTMLElement is TcxMemo)
   or (LabelHTMLElement is TcxDBMemo)
{$ENDIF}
{$IFNDEF FMX} or (LabelHTMLElement is TDBMemo){$ENDIF} then
   vResult:= TMemo(LabelHTMLElement).Visible;

  if vResult <> Result then
   Visible:= vResult;
 end;
end;

procedure TPrismLink.Initialize;
begin
 inherited;

// FStoredText:= Text;
// FStoredOnClickCallBack:= OnClickCallBack;
// FStoredhref:= href;
// FStoredHint:= Hint;

end;

function TPrismLink.IsLink: Boolean;
begin
 result:= true;
end;

procedure TPrismLink.ProcessComponentState(const ComponentStateInfo: TJSONObject);
begin
 inherited;

end;

procedure TPrismLink.ProcessEvent(Event: IPrismControlEvent; Parameters: TStrings);
begin
 inherited;

 if Event.EventType = EventOnClick then
 begin
  if Assigned(FOnClick) then
   FOnClick(Self)
  else
   if Assigned(LabelHTMLElement) then
   begin
    if (LabelHTMLElement is TLabel) //Label's
  {$IFDEF DEVEXPRESS_AVAILABLE}
     or (LabelHTMLElement is TcxLabel)
     or (LabelHTMLElement is TcxDBLabel)
  {$ENDIF}
  {$IFNDEF FMX} or (LabelHTMLElement is TDBText){$ENDIF} then
    begin
     if Assigned(TLabel(LabelHTMLElement).OnClick) then
      TLabel(LabelHTMLElement).OnClick(LabelHTMLElement);
    end else
    if (LabelHTMLElement is TEdit) //Edit's
  {$IFDEF DEVEXPRESS_AVAILABLE}
     or (LabelHTMLElement is TcxTextEdit)
     or (LabelHTMLElement is TcxDBTextEdit)
  {$ENDIF}
  {$IFNDEF FMX} or (LabelHTMLElement is TDBEdit){$ENDIF} then
    begin
     if Assigned(TEdit(LabelHTMLElement).OnClick) then
      TEdit(LabelHTMLElement).OnClick(LabelHTMLElement);
    end else
    if (LabelHTMLElement is TMemo) //Memo's
  {$IFDEF DEVEXPRESS_AVAILABLE}
     or (LabelHTMLElement is TcxMemo)
     or (LabelHTMLElement is TcxDBMemo)
  {$ENDIF}
  {$IFNDEF FMX} or (LabelHTMLElement is TDBMemo){$ENDIF} then
    begin
     if Assigned(TMemo(LabelHTMLElement).OnClick) then
      TMemo(LabelHTMLElement).OnClick(LabelHTMLElement)
    end;
   end else
    if OnClickCallBack = '' then
    begin
     Form.DoCallBack(self.Name, Parameters);
    end;
 end;

end;

procedure TPrismLink.ProcessEventParameters(Event: IPrismControlEvent;
  Parameters: TStrings);
begin
 inherited;

end;

procedure TPrismLink.ProcessHTML;
begin
 inherited;

end;

procedure TPrismLink.SetHint(Value: string);
begin
 FHint:= Value;
end;

procedure TPrismLink.Sethref(Value: string);
begin
 FhRef:= Value;
end;

procedure TPrismLink.SetLabelHTMLElement(AComponent: TComponent);
begin
 FLabel:= AComponent;
end;

procedure TPrismLink.SetOnclick(Value: TNotifyEvent);
begin
 FOnClick:= Value;
end;

procedure TPrismLink.SetOnClickCallBack(Value: string);
begin
 FOnClickCallBack:= Value;
end;

procedure TPrismLink.SetText(Value: string);
begin
 FText:= Value;
end;

procedure TPrismLink.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
var
 NewText: string;
 NewOnClickCallBack: string;
 NewHref: string;
 NewHint: string;
begin
 inherited;

 NewText:= Text;
 NewOnClickCallBack:= OnClickCallBack;
 NewHref:= href;
 NewHint:= Hint;

 if (AForceUpdate) or (NewText <> FStoredText) then
 begin
  FStoredText:= NewText;
  ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+'text i]").textContent = "'+ FStoredText +'";');
 end;

 if (NewOnClickCallBack <> FOnClickCallBack) then
 begin
  FStoredOnClickCallBack:= NewOnClickCallBack;

  if NewOnClickCallBack <> '' then
  begin
   if Pos('{{', NewOnClickCallBack) <= 0 then
   begin
    if Pos('CallBack=', NewOnClickCallBack) <= 0 then
     NewOnClickCallBack:= 'CallBack=' + NewOnClickCallBack;

    NewOnClickCallBack:= '{{' + NewOnClickCallBack + '}}';
   end;
  end;

  ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").setAttribute("onClick","'+ FStoredOnClickCallBack +'");');
 end;

 if (NewHref <> FStoredHref) then
 begin
  FStoredhref:= NewHref;
  ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").setAttribute("href","'+ FStoredhref +'");');
 end;

 if (NewHint <> FStoredHint) then
 begin
  FStoredHint:= NewHint;
  ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").setAttribute("title","'+ FStoredHint +'");');
 end;
end;

end.
