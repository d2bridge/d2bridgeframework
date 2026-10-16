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

unit Prism.Types;

interface

uses
  Classes, SysUtils, TypInfo, Rtti
{$IFDEF FMX}
  , FMX.Graphics
{$ENDIF}
  ;

type
 TPrismEventType = (EventNone, EventOnClick, EventOnDblClick, EventOnSelectAll, EventOnUnselectAll, EventOnLoadJSON, EventOnSelect, EventOnCellClick,
                    EventOnCheckChange, EventOnCheck, EventOnUncheck, EventOnEnter, EventOnExit, EventOnChange, EventOnKeyDown, EventOnKeyUp,
                    EventOnKeyPress, EventOnButtonClick,
                    EventOnFocused, EventOnCellPost, EventOnCellButtonClick,
                    EventOnItemClick,
                    EventOnShowPopup, EventOnClosePopup,
                    EventOnLeftClick, EventOnRightClick,
                    EventOnDragStart, EventOnDragEnd,
                    EventOnLoad, EventOnUnload,
                    EventOnRead, EventOnWrite, EventOnError,
                    EventOnPrismControlEvent);

 TPrismWebMethod = (wmtGET, wmtPOST, wmtPUT, wmtDELETE, wmtPATCH, wmtHEAD);

{$IFDEF FMX}
type
  TPicture = TBitmap;

  TJPEGImage = TBitmap;
{$ENDIF}

type
{$IFDEF FPC}
  TProc = {$IFDEF SUPPORTS_FUNCTION_REFERENCES}reference to {$ENDIF}procedure{$IFNDEF SUPPORTS_FUNCTION_REFERENCES} of object{$ENDIF};
{$ENDIF}
  TProc1 = {$IFDEF SUPPORTS_FUNCTION_REFERENCES}reference to {$ENDIF}procedure(Arg1: TValue){$IFNDEF SUPPORTS_FUNCTION_REFERENCES} of object{$ENDIF};
  TProc2 = {$IFDEF SUPPORTS_FUNCTION_REFERENCES}reference to {$ENDIF}procedure(Arg1: TValue; Arg2: TValue){$IFNDEF SUPPORTS_FUNCTION_REFERENCES} of object{$ENDIF};
  TProc3 = {$IFDEF SUPPORTS_FUNCTION_REFERENCES}reference to {$ENDIF}procedure(Arg1: TValue; Arg2: TValue; Arg3: TValue){$IFNDEF SUPPORTS_FUNCTION_REFERENCES} of object{$ENDIF};
  TProc4 = {$IFDEF SUPPORTS_FUNCTION_REFERENCES}reference to {$ENDIF}procedure(Arg1: TValue; Arg2: TValue; Arg3: TValue; Arg4: TValue){$IFNDEF SUPPORTS_FUNCTION_REFERENCES} of object{$ENDIF};

{$IFNDEF SUPPORTS_FUNCTION_REFERENCES}
  TThreadProcedure = procedure of object;
{$ENDIF}


type
 TOnServerEvent = procedure of object;


type
  TOnEventProc = {$IFDEF SUPPORTS_FUNCTION_REFERENCES}reference to {$ENDIF}procedure(EventParams: TStrings){$IFNDEF SUPPORTS_FUNCTION_REFERENCES} of object{$ENDIF};
  TNotifyEventStr = {$IFDEF SUPPORTS_FUNCTION_REFERENCES}reference to {$ENDIF}procedure(Value: string){$IFNDEF SUPPORTS_FUNCTION_REFERENCES} of object{$ENDIF};
  TOnSetValue = {$IFDEF SUPPORTS_FUNCTION_REFERENCES}reference to {$ENDIF}procedure(AValue: Variant){$IFNDEF SUPPORTS_FUNCTION_REFERENCES} of object{$ENDIF};
  TOnGetValue = {$IFDEF SUPPORTS_FUNCTION_REFERENCES}reference to {$ENDIF}function: Variant{$IFNDEF SUPPORTS_FUNCTION_REFERENCES} of object{$ENDIF};
  TOnGetStrings = {$IFDEF SUPPORTS_FUNCTION_REFERENCES}reference to {$ENDIF}function: TStrings{$IFNDEF SUPPORTS_FUNCTION_REFERENCES} of object{$ENDIF};
  TCallBackEvent = {$IFDEF SUPPORTS_FUNCTION_REFERENCES}reference to {$ENDIF}function(EventParams: TStrings): string{$IFNDEF SUPPORTS_FUNCTION_REFERENCES} of object{$ENDIF};
  TCallBackEventResponse = {$IFDEF SUPPORTS_FUNCTION_REFERENCES}reference to {$ENDIF}procedure(EventParams: TStrings; out vRespose: string){$IFNDEF SUPPORTS_FUNCTION_REFERENCES} of object{$ENDIF};

type
  TPrismGetEvent = function: Variant of object;
  TPrismGetStrEvent = function: String of object;
  TPrismMethodEvent = procedure of object;
  TOnTagHTML = procedure(const TagString: string; var ReplaceTag: string) of object;
  TOnPopup = {$IFDEF SUPPORTS_FUNCTION_REFERENCES}reference to {$ENDIF}function(APopupName: String): string{$IFNDEF SUPPORTS_FUNCTION_REFERENCES} of object{$ENDIF};
  TOnUpload = procedure(AFiles: TStrings; Sender: TObject) of object;

type
 TPrismAlignment =
   (PrismAlignNone = 0,
   PrismAlignLeft,
   PrismAlignRight,
   PrismAlignCenter,
   PrismAlignJustified);

type
 TPrismPosition =
   (PrismPositionLeft = 0,
   PrismPositionRight,
   PrismPositionTop,
   PrismPositionBottom);

type
 TPrismPageState =
   (PageStateUnloaded = 0,
    PageStateLoading,
    PageStateLoaded);

 type
  TEventProcType =
    (ExecEventProc = 0,
     GetFromEventProc);

 type
  TPrismFieldType =
   (PrismFieldTypeAuto = 0,
    PrismFieldTypeString,
    PrismFieldTypePassword,
    PrismFieldTypeInteger,
    PrismFieldTypeNumber,
    PrismFieldTypeDate,
    PrismFieldTypeDateTime,
    PrismFieldTypeTime);

 type
  TPrismFieldModel =
   (PrismFieldModelNone = 0,
    PrismFieldModelField,
    PrismFieldModelCombobox,
    PrismFieldModelCheckbox,
    PrismFieldModelLookup,
    PrismFieldModelButton,
    PrismFieldModelHTML);

 type
  TPrismScreenOrientation =
   (PrismScreenUnknown = 0,
    PrismScreenPortrait,
    PrismScreenLandscape);


 type
  TWebSocketMessageType =
    (wsNone = 0,
     wsMsgCallBack,
     wsMsgFunction,
     wsMsgProcedure,
     wsMsgText,
     wsMsgHeartbeat);

  type
   TSessionConnectionStatus =
    (scsNone = 0,
     scsNewSession,
     scsCloseSession,
     scsActiveSession,
     scsClosingSession,
     scsExpireSession,
     scsStabilizedConnectioSession,
     scsLostConnectioSession,
     scsReconnectedSession,
     scsIdleSession,
     scsActivitySession,
     scsDestroySession);
   TSessionChangeType =  TSessionConnectionStatus;


 type
  TPrismDataLinkEvent =
    (Activate = 0,
     Deactivate,
     BeginEditing,
     EndEditting,
     BeginInsert,
     EndInsert,
     Updated,
     Deleted,
     NewRow,
     Canceled,
     Scrolled);

 type
  TOnPrismDataWvent = procedure(const DataWareEvent: TPrismDataLinkEvent) of object;

 type
  TextMaskModel =
    (TextMaskModelCNPJ = 0,
     TextMaskModelCPF);

 type
  TSecurityEvent =
    (secBlockBlackList = 0,
     secDelistIPBlackList,
     secNotDelistIPBlackList,
     secBlockUserAgent,
     secBlockIPLimitConn,
     secBlockIPLimitSession);

 type
  TPrismLogFileMode =
    (lfmPerSession = 0,
     lfmDaily);

type
 TSecuritEventInfo = record
  IP: string;
  IsIPV6: boolean;
  UserAgent: string;
  Event: TSecurityEvent;
 end;


type
 TSecurityJWTAlgorithm =
   (JWTHS256 = 0);

type
 TSecurityJWTTokenType =
   (JWTTokenAccess,
    JWTTokenRefresh);


type
 TPrismChatLegendIcon =
  (
    ChartLegendIconNone = 0,
    ChartLegendIconCircle,
    ChartLegendIconRect,
    ChartLegendIconRoundRect,
    ChartLegendIconTriangle,
    ChartLegendIconDiamond,
    ChartLegendIconPin,
    ChartLegendIconArrow
  );


type
 TPrismChatToolTipTrigger =
  (
    ChartToolTipTriggerItem = 0,
    ChartToolTipTriggerAxis,
    ChartToolTipTriggerNone
  );


function EventJSName(PrismEventType: TPrismEventType): string;


//Enum
function EnumToString(EnumType: PTypeInfo; Value: Integer): string;

function StringToEnum(EnumType: PTypeInfo; const Str: string): Integer;

function EventTypeToName(AEventType: TPrismEventType): string;

function GetLocaleLang(aLanguage: String): Integer;


implementation

Uses
 D2Bridge.Lang.Util;


function EventJSName(PrismEventType: TPrismEventType): string;
begin
 if PrismEventType = EventOnClick then
  result:= 'click'
 else
 if PrismEventType = EventOnDblClick then
  result:= 'dblclick'
 else
 if PrismEventType = EventOnKeyDown then
  result:= 'keydown'
 else
 if PrismEventType = EventOnKeyUp then
  result:= 'keyup'
 else
 if PrismEventType = EventOnKeyPress then
  result:= 'keypress'
 else
 if PrismEventType = EventOnChange then
  result:= 'input'
 else
 if PrismEventType = EventOnCheckChange then
  result:= 'change'
 else
 if PrismEventType = EventOnSelect then
  result:= 'input'
end;


function EnumToString(EnumType: PTypeInfo; Value: Integer): string;
begin
  Result := GetEnumName(EnumType, Value);
  //uses EnumToString(TypeInfo(TPrismEventType), Ord(APrismForm.Controls[I].Events.Item(Z).EventType))
end;

function StringToEnum(EnumType: PTypeInfo; const Str: string): Integer;
begin
  Result := GetEnumValue(EnumType, Str);
end;


function EventTypeToName(AEventType: TPrismEventType): string;
var
  nPosicao: Integer;
begin
  nPosicao:= 0;
  System.Move(AEventType, nPosicao, System.SizeOf(AEventType));

  Result:= GetEnumName(TypeInfo(TPrismEventType), nPosicao);

  if Pos('Event', Result) = 1 then
    Result:= Copy(Result, 6);
end;

function GetLocaleLang(aLanguage: String): Integer;
var
  i: Integer;
  Lang: string;
begin
  Lang := LowerCase(aLanguage);
  for i := Low(D2Bridge.Lang.Util.LANGUAGESCodeInfo) to High(D2Bridge.Lang.Util.LANGUAGESCodeInfo) do
    if D2Bridge.Lang.Util.LANGUAGESCodeInfo[i].Code = Lang then
      Exit(D2Bridge.Lang.Util.LANGUAGESCodeInfo[i].LCID);
  Result := 0; // Not found
end;

end.