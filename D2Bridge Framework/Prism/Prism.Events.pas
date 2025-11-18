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

unit Prism.Events;

interface

uses
  Classes, SysUtils, SyncObjs, Generics.Collections, Rtti,
  Prism.Interfaces, Prism.Types, DateUtils;

type
 TPrismDefaultEvent = procedure(Sender: TObject; EventParams: TStringList) of object;
 TProcessHTMLNotify = procedure(Sender: TObject; var AHTMLText: string) of object;
 TEventProcType = Prism.Types.TEventProcType;


type
 TPrismControlEvent = class(TInterfacedPersistent, IPrismControlEvent)
  private
   FEventID: String;
   FNotifyEvent: TNotifyEvent;
   FGetStrEvent: TPrismGetStrEvent;
   FEventType: TPrismEventType;
   FPrismControl: IPrismControl;
   FAutoPublishedEvent: Boolean;
   FOnEventProc: TOnEventProc;
   FCriticalSession: TCriticalSection;
   function GetEventType: TPrismEventType;
   function GetEventID: String;
   function GetPrismControl: IPrismControl;
   procedure SetAutoPublishedEvent(AAutoPublished: Boolean);
   function GetAutoPublishedEvent: Boolean;
  public
   constructor Create(AOwner: IPrismControl; AEventType: TPrismEventType);
   destructor Destroy; override;

   procedure SetOnEvent(AOnEvent: TNotifyEvent); overload;
   procedure SetOnEvent(AOnEvent: TPrismGetStrEvent); overload;
   procedure SetOnEvent(AOnEventProc: TOnEventProc); overload;
   procedure CallEvent(Parameters: TStrings);
   function CallEventResponse(Parameters: TStrings): string;
   function EventJS(EventProc: TEventProcType = ExecEventProc; Parameters: String = ''; LockCLient: Boolean = false): string; overload;
   function EventJS(ASession: IPrismSession; FormUUID: string; EventProc: TEventProcType = ExecEventProc; Parameters: String = ''; LockCLient: Boolean = false): string; overload;

   function EventTypeName: string;

   property AutoPublishedEvent: Boolean read GetAutoPublishedEvent write SetAutoPublishedEvent;
   property EventType: TPrismEventType read GetEventType;
   property EventID: string read GetEventID;
   property PrismControl: IPrismControl read GetPrismControl;
 end;


type
 TPrismControlEvents = class(TInterfacedPersistent, IPrismControlEvents)
  private
   FEvents: TList<IPrismControlEvent>;
   FIPrismControl: IPrismControl;
  public
   constructor Create(AOwner: IPrismControl);
   destructor Destroy; override;

   procedure Add(AEvent: IPrismControlEvent); overload;
   procedure Add(AEventType: TPrismEventType; AEvent: TNotifyEvent); overload;
   procedure Add(AEventType: TPrismEventType; AOnEventProc: TOnEventProc); overload;
   procedure Add(AEventType: TPrismEventType; AOnEventProc: TOnEventProc; AAutoPublishedEvent: Boolean); overload;

   procedure Delete(AIndex: Integer);
   function Count: integer;
   function Item(AIndex: Integer): IPrismControlEvent; overload;
   function Item(AEventType: TPrismEventType): IPrismControlEvent; overload;
 end;


implementation

uses
  Prism.Util, Prism.Forms.Controls, Prism.Forms, Prism.Session;

{ TPrismControlEvents }

procedure TPrismControlEvents.Add(AEvent: IPrismControlEvent);
begin
 if not Assigned(Item(AEvent.EventType)) then
 FEvents.Add(AEvent);
end;

procedure TPrismControlEvents.Add(AEventType: TPrismEventType;
  AEvent: TNotifyEvent);
var
 Event: TPrismControlEvent;
begin
 if not Assigned(Item(AEventType)) then
 begin
  Event:= TPrismControlEvent.Create(FIPrismControl, AEventType);
  Event.SetOnEvent(AEvent);
  Add(Event);
 end;
end;

procedure TPrismControlEvents.Add(AEventType: TPrismEventType;
  AOnEventProc: TOnEventProc);
var
 Event: TPrismControlEvent;
begin
 if not Assigned(Item(AEventType)) then
 begin
  Event:= TPrismControlEvent.Create(FIPrismControl, AEventType);
  Event.SetOnEvent(AOnEventProc);
  Add(Event);
 end;
end;

procedure TPrismControlEvents.Add(AEventType: TPrismEventType;
  AOnEventProc: TOnEventProc; AAutoPublishedEvent: Boolean);
var
 Event: TPrismControlEvent;
begin
 if not Assigned(Item(AEventType)) then
 begin
  Event:= TPrismControlEvent.Create(FIPrismControl, AEventType);
  Event.SetOnEvent(AOnEventProc);
  Event.AutoPublishedEvent:= AAutoPublishedEvent;
  Add(Event);
 end;
end;

function TPrismControlEvents.Count: integer;
begin
 Result:= FEvents.Count;
end;

constructor TPrismControlEvents.Create(AOwner: IPrismControl);
begin
 FIPrismControl:= AOwner;

 FEvents:= TList<IPrismControlEvent>.Create;
end;

procedure TPrismControlEvents.Delete(AIndex: Integer);
begin
 FEvents.Delete(AIndex);
end;

destructor TPrismControlEvents.Destroy;
var
 vEventIntf: IPrismControlEvent;
 vEvent: TPrismControlEvent;
begin
 try
  while FEvents.Count > 0 do
  begin
   vEventIntf:= FEvents.Last;
   FEvents.Delete(Pred(FEvents.Count));

   try
    vEvent:= vEventIntf as TPrismControlEvent;
    vEventIntf:= nil;
    vEvent.Free;
   except
   end;
  end;

  FEvents.Free;
 except
 end;

 if Assigned(FIPrismControl) then
  FIPrismControl:= nil;

 inherited;
end;

function TPrismControlEvents.Item(AEventType: TPrismEventType): IPrismControlEvent;
var I: integer;
begin
 System.Initialize(Result);

 for I := 0 to FEvents.Count-1 do
 if FEvents[I].EventType = AEventType then
 begin
  Result:= FEvents[I];
  break;
 end;
end;

function TPrismControlEvents.Item(AIndex: Integer): IPrismControlEvent;
begin
 Result:= FEvents.Items[AIndex];
end;


{ TPrismControlEvent }

procedure TPrismControlEvent.CallEvent(Parameters: TStrings);
begin
 if Assigned(FNotifyEvent) and Assigned(FPrismControl.VCLComponent) then
 begin
  FCriticalSession.Enter;

  try
   FNotifyEvent(FPrismControl.VCLComponent)
  finally
   FCriticalSession.Leave;
  end;
 end else
 begin
  if Assigned(FOnEventProc) then
  begin
   FCriticalSession.Enter;

   try
    FOnEventProc(Parameters);
   finally
    FCriticalSession.Leave;
   end;
  end else
  begin
   FCriticalSession.Enter;

   try
    FPrismControl.ProcessEvent(self, Parameters);
   finally
    FCriticalSession.Leave;
   end;
  end;

  if self <> nil then
   if Assigned(FPrismControl) and
      Assigned(FPrismControl.Form) and
      Assigned(FPrismControl.Session) and
      (not FPrismControl.Session.Closing) and
      (not (csDestroying in (FPrismControl.Session as TPrismSession).ComponentState)) then
    begin
     (FPrismControl.Form as TPrismForm).DoEventD2Bridge(FPrismControl as TPrismControl, EventType, Parameters);
    end;
 end;
end;

function TPrismControlEvent.CallEventResponse(Parameters: TStrings): string;
begin
 if Assigned(FGetStrEvent) then
 begin
  FCriticalSession.Enter;

  try
   Result:= FGetStrEvent;
  finally
   FCriticalSession.Leave;
  end;
 end;

end;

constructor TPrismControlEvent.Create(AOwner: IPrismControl; AEventType: TPrismEventType);
begin
 FEventType := AEventType;
 FPrismControl := AOwner;

 if AEventType in [EventOnClick, EventOnDblClick, EventOnChange, EventOnPrismControlEvent] then
  FAutoPublishedEvent:= true
 else
  FAutoPublishedEvent:= false;

 FEventID:= GenerateRandomString(19);

 FCriticalSession:= TCriticalSection.Create;
end;

destructor TPrismControlEvent.Destroy;
begin
 if Assigned(FPrismControl) then
  FPrismControl:= nil;

 FCriticalSession.Free;

 inherited;
end;

function TPrismControlEvent.EventJS(EventProc: TEventProcType = ExecEventProc; Parameters: String = ''; LockCLient: Boolean = false): string;
begin
 Result:= EventJS(FPrismControl.Session, FPrismControl.Form.FormUUID, EventProc, Parameters, LockCLient);
end;

function TPrismControlEvent.EventJS(ASession: IPrismSession; FormUUID: string; EventProc: TEventProcType; Parameters: String; LockCLient: Boolean): string;
var
 vEventProc : string;
begin
 Result:= '';

 if Parameters = '' then
  Parameters:= QuotedStr(Parameters);

 if ExecEventProc = EventProc then
  vEventProc:= 'ExecEvent'
 else
  vEventProc:= 'GetFromEventProc';

 Result:= Result + 'PrismServer().'+vEventProc + '(''' + ASession.UUID + ''', '''+ ASession.Token +''', '''+ FormUUID +''', ''' + FPrismControl.Name + ''', ''' + EventID + ''', ' + Parameters + ', '''+ BoolToStr(LockCLient, true) +''');' ;

end;

function TPrismControlEvent.EventTypeName: string;
begin
 Result:= EventTypeToName(FEventType);
end;

function TPrismControlEvent.GetAutoPublishedEvent: Boolean;
begin
 result:= FAutoPublishedEvent;
end;

function TPrismControlEvent.GetEventID: String;
begin
 Result:= FEventID;
end;

function TPrismControlEvent.GetEventType: TPrismEventType;
begin
 Result:= FEventType;
end;


function TPrismControlEvent.GetPrismControl: IPrismControl;
begin
 Result:= FPrismControl;
end;

procedure TPrismControlEvent.SetAutoPublishedEvent(AAutoPublished: Boolean);
begin
 FAutoPublishedEvent:= AAutoPublished;
end;

procedure TPrismControlEvent.SetOnEvent(AOnEventProc: TOnEventProc);
begin
 FOnEventProc:= AOnEventProc;
end;


procedure TPrismControlEvent.SetOnEvent(AOnEvent: TPrismGetStrEvent);
begin
 FGetStrEvent:= AOnEvent;
end;

procedure TPrismControlEvent.SetOnEvent(AOnEvent: TNotifyEvent);
begin
 FNotifyEvent:= AOnEvent;
end;

end.