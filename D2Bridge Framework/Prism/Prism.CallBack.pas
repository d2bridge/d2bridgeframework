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

unit Prism.CallBack;

interface

uses
  Classes, Generics.Collections, SysUtils,
  Prism.Interfaces, Prism.Types;


type
 TPrismCallBack = class(TInterfacedPersistent, IPrismCallBack)
  private
   FName: String;
   FCallBackEvent: TCallBackEvent;
   FID: String;
   FCallBackJS: String;
   FResponse: String;
   FPrismForm: IPrismForm;
   FParameters: string;
   procedure SetName(AName: String);
   function GetName: String;
   function GetCallBackEvent: TCallBackEvent;
   procedure SetCallBackEvent(AValue: TCallBackEvent);
   function GetCallBackID: String;
   function GetPrismForm: IPrismForm;
   procedure SetPrismForm(APrismForm: IPrismForm);
  public
   constructor Create(AName: String; AParameters: string; APrismForm: IPrismForm; ACallBackEventProc: TCallBackEvent);
   destructor Destroy; override;

   function Execute(EventParams: TStrings): string;
   function GetResponse: string;
   function DefaultParameters: string;

   property Name: String read GetName write SetName;
   property CallBackEvent: TCallBackEvent read GetCallBackEvent write SetCallBackEvent;
   property ID: String read GetCallBackID;
   property Response: String read GetResponse;
   property PrismForm: IPrismForm read GetPrismForm write SetPrismForm;
 end;


 TPrismCallBacks = class(TInterfacedPersistent, IPrismCallBacks)
  private
   FItems: TDictionary<string, IPrismCallBack>;
   FSession: IPrismSession;
   FLock: TMultiReadExclusiveWriteSynchronizer;
   Function GetCallBacks: TDictionary<string, IPrismCallBack>; overload;
  public
   constructor Create(APrismSession: IPrismSession);
   destructor Destroy; override;

   procedure Clear;

   procedure Add(APrismCallBack: IPrismCallBack);
   function Register(AName: String; APrismForm: IPrismForm; ACallBackEventProc: TCallBackEvent): IPrismCallBack; overload;
   function Register(AName: String; APrismForm: IPrismForm): IPrismCallBack; overload;
   function Register(AName: String; Parameters: String; APrismForm: IPrismForm): IPrismCallBack; overload;
   function Register(ACallback: IPrismCallBack; APrismForm: IPrismForm): IPrismCallBack; overload;
   procedure Unregister(AName: String);
   procedure UnRegisterAll(APrismForm: IPrismForm);
   function GetCallBack(AName: String; APrismForm: IPrismForm): IPrismCallBack; overload;
   function GetCallBack(AName, FormUUID: String): IPrismCallBack; overload;
   function GetCallBacks(APrismForm: IPrismForm): TList<IPrismCallBack>; overload;
   function Execute(AName, FormUUID: String; EventParams: TStrings): string;
   function CallBackJS(ACallBackName: String; AFormUUID: String = ''; Parameters: String = ''; LockClient: Boolean = false): string; overload;
   function CallBackJS(ACallBackName: String; AReturnFalse: Boolean = true; AFormUUID: String = ''; Parameters: String = ''; LockClient: Boolean = false): string; overload;
   function CallBackDirectJS(ACallBackName, AFormUUID: String; Parameters: String = ''; LockClient: Boolean = false): string; overload;
   function CallBackDirectJS(ACallBack: IPrismCallBack; AFormUUID: String; Parameters: String = ''; LockCLient: Boolean = false): string; overload;

   property Items: TDictionary<string, IPrismCallBack> read GetCallBacks;
 end;


 TPrismFormCallBacks = class(TInterfacedPersistent, IPrismFormCallBacks)
  private
   FPrismForm: IPrismForm;
   FFormUUID: string;
   FPrismSession: IPrismSession;
   FTempCallBacks: TDictionary<string, IPrismCallBack>;
   FLock: TMultiReadExclusiveWriteSynchronizer;
  public
   constructor Create(AFormUUID: string; APrismForm: IPrismForm; APrismSession: IPrismSession);
   destructor Destroy; override;

   procedure Clear;

   function Register(AName: String; ACallBackEventProc: TCallBackEvent): IPrismCallBack; overload;
   function Register(AName: String; Parameters: String = ''): IPrismCallBack; overload;
   function GetCallBack(AName: String): IPrismCallBack;
   procedure Unregister(AName: String);

   function CallBackJS(ACallBackName: String; Parameters: String = ''; LockClient: Boolean = false): string;

   function TempCallBacks: TDictionary<string, IPrismCallBack>;
   procedure ConsolideTempCallBacks(APrismFormToConsolide: IPrismForm);
 end;



implementation

uses
  Prism.Util,
  D2Bridge.Manager;

{ TPrismCallBack }


constructor TPrismCallBack.Create(AName: String; AParameters: string; APrismForm: IPrismForm; ACallBackEventProc: TCallBackEvent);
begin
 FName:= AName;
 FCallBackEvent:= ACallBackEventProc;
 FParameters:= AParameters;
 FPrismForm:= APrismForm;
 FID:= GenerateRandomString(18);
end;

function TPrismCallBack.Execute(EventParams: TStrings): string;
begin
 if Assigned(FCallBackEvent) then
  Result:= FCallBackEvent(EventParams)
 else
 if Assigned(FPrismForm) then
  FPrismForm.DoCallBack(FName, EventParams);

 FResponse:= Result;
end;

function TPrismCallBack.GetCallBackEvent: TCallBackEvent;
begin
 Result:= FCallBackEvent;
end;

function TPrismCallBack.GetCallBackID: String;
begin
 Result:= FID;
end;

function TPrismCallBack.GetName: String;
begin
 Result:= FName;
end;

function TPrismCallBack.GetPrismForm: IPrismForm;
begin
 Result:= FPrismForm;
end;

function TPrismCallBack.GetResponse: string;
begin
 Result:= FResponse;
end;

function TPrismCallBack.DefaultParameters: string;
begin
 Result:= FParameters;
end;

destructor TPrismCallBack.Destroy;
begin
 if Assigned(FPrismForm) then
  FPrismForm:= nil;

 inherited;
end;

procedure TPrismCallBack.SetCallBackEvent(AValue: TCallBackEvent);
begin
 FCallBackEvent:= AValue;
end;

procedure TPrismCallBack.SetName(AName: String);
begin
 FName:= AName;
end;


procedure TPrismCallBack.SetPrismForm(APrismForm: IPrismForm);
begin
 FPrismForm:= APrismForm;
end;

{ TPrismCallBacks }



procedure TPrismCallBacks.Add(APrismCallBack: IPrismCallBack);
begin
 FLock.BeginWrite;

 try
  FItems.AddOrSetValue(APrismCallBack.ID, APrismCallBack);
 finally
  FLock.EndWrite;
 end;
end;


function TPrismCallBacks.CallBackDirectJS(ACallBackName, AFormUUID: String; Parameters: String = ''; LockClient: Boolean = false): string;
var
 vCallBack: IPrismCallBack;
begin
 Result:= '';

 vCallBack:= GetCallBack(ACallBackName, AFormUUID);

 Result:= CallBackDirectJS(vCallBack, AFormUUID, Parameters, LockClient);
end;


function TPrismCallBacks.CallBackDirectJS(ACallBack: IPrismCallBack; AFormUUID, Parameters: String; LockCLient: Boolean): string;
begin
 Result:= '';

 if Parameters <> '' then
 begin
  if (POS('''[',Parameters) = 1) and (POS(']''',Parameters) = (Length(Parameters)-1)) then
   Parameters:= Copy(Parameters, 3, Length(Parameters)-4);
 end;

 if Assigned(ACallBack) then
 if Parameters = '' then
  Parameters:= QuotedStr(ACallBack.DefaultParameters);

 if Parameters = '' then
  Parameters:= QuotedStr(Parameters);

 if Assigned(ACallBack) then
 begin
  Result:= Result + 'PrismServer().CallBack('''+FSession.UUID+''', '''+ FSession.Token +''', '''+ AFormUUID +''', ''' + ACallBack.ID + ''', ' + Parameters + ', '+ LowerCase(BoolToStr(LockClient, true)) +');  return false;' ;
 end;

end;

function TPrismCallBacks.CallBackJS(ACallBackName, AFormUUID, Parameters: String; LockClient: Boolean): string;
begin
 result:= CallBackJS(ACallBackName, true, AFormUUID, Parameters, LockClient);
end;

function TPrismCallBacks.CallBackJS(ACallBackName: String; AReturnFalse: Boolean = true; AFormUUID: String = ''; Parameters: String = ''; LockClient: Boolean = false): string;
begin
 if AFormUUID = '' then
  AFormUUID:= FSession.ActiveForm.FormUUID;

 Result:= CallBackDirectJS(ACallBackName, AFormUUID, Parameters, LockClient);

 if not AReturnFalse then
  Result:= StringReplace(Result, ' return false;', '', []);
end;

procedure TPrismCallBacks.Clear;
var
 vPrismCallBackIntf: IPrismCallBack;
 vPrismCallBack: TPrismCallBack;
 vKeys: TList<string>;
 vKey: string;
begin
 FLock.BeginWrite;
 try
  if FItems.Count > 0 then
  begin
   vKeys:= TList<string>.Create(FItems.Keys);

   try
    while vKeys.Count > 0 do
    begin
     vKey:= vKeys.Last;
     vKeys.Remove(vKey);

     try
      vPrismCallBackIntf:= FItems[vKey];

      FItems.Remove(vKey);

      vPrismCallBack:= vPrismCallBackIntf as TPrismCallBack;
      vPrismCallBackIntf:= nil;
      vPrismCallBack.Free;
     except
     end;
    end;
   except
   end;

   vKeys.Free;
  end;
 finally
  FLock.EndWrite;
 end;
end;

constructor TPrismCallBacks.Create(APrismSession: IPrismSession);
begin
 FSession:= APrismSession;

 FItems:= TDictionary<string, IPrismCallBack>.Create;

 FLock:= TMultiReadExclusiveWriteSynchronizer.Create;
end;

destructor TPrismCallBacks.Destroy;
begin
 Clear;

 FreeAndNil(FItems);

 if Assigned(FSession) then
  FSession:= nil;

 FLock.Free;

 inherited;
end;

function TPrismCallBacks.Execute(AName, FormUUID: String; EventParams: TStrings): string;
var
 vPrismCallBack: IPrismCallBack;
begin
 vPrismCallBack:= GetCallBack(AName, FormUUID);

 if Assigned(vPrismCallBack) then
 begin
  Result:= vPrismCallBack.Execute(EventParams);
 end;
end;

function TPrismCallBacks.GetCallBack(AName: String;
  APrismForm: IPrismForm): IPrismCallBack;
begin
 Result:= GetCallBack(AName, APrismForm.FormUUID);
end;

function TPrismCallBacks.GetCallBack(AName, FormUUID: String): IPrismCallBack;
var
 I: Integer;
begin
 FLock.BeginRead;
 try
  for I := 0 to Pred(Items.Count) do
   if SameText(AName, Items.Values.ToArray[I].Name) and (FormUUID = Items.Values.ToArray[I].PrismForm.FormUUID) then
   begin
    Result:= Items.Values.ToArray[I];
    break;
   end;
 finally
  FLock.EndRead;
 end;
end;

function TPrismCallBacks.GetCallBacks(APrismForm: IPrismForm): TList<IPrismCallBack>;
var
 I: Integer;
begin
 result:= TList<IPrismCallBack>.Create;

 FLock.BeginRead;
 try
  for I := 0 to Pred(Items.Count) do
   if Items.Values.ToArray[I].PrismForm = APrismForm then
   begin
    Result.Add(Items.Values.ToArray[I]);
   end;
 finally
  FLock.EndRead;
 end;

end;

function TPrismCallBacks.GetCallBacks: TDictionary<string, IPrismCallBack>;
begin
 Result:= FItems;
end;

function TPrismCallBacks.Register(ACallback: IPrismCallBack; APrismForm: IPrismForm): IPrismCallBack;
var
 vPrismCallBack: TPrismCallBack;
begin
 vPrismCallBack:= TPrismCallBack.Create(ACallback.Name, '', APrismForm, ACallback.CallBackEvent);
 vPrismCallBack.FID:= ACallback.ID;

 FLock.BeginWrite;
 try
  FItems.AddOrSetValue(vPrismCallBack.ID, vPrismCallBack);
 finally
  FLock.EndWrite;
 end;

 result:= vPrismCallBack;
end;

function TPrismCallBacks.Register(AName: String; APrismForm: IPrismForm): IPrismCallBack;
begin
 result:= Register(AName, '', APrismForm);
end;

function TPrismCallBacks.Register(AName: String; APrismForm: IPrismForm; ACallBackEventProc: TCallBackEvent): IPrismCallBack;
var
 vPrismCallBack: TPrismCallBack;
begin
 vPrismCallBack := GetCallBack(AName, APrismForm) as TPrismCallBack;

 if not Assigned(vPrismCallBack) then
  vPrismCallBack:= TPrismCallBack.Create(AName, '', APrismForm, ACallBackEventProc)
 else
 if Assigned(ACallBackEventProc) then
  vPrismCallBack.CallBackEvent:= ACallBackEventProc
 else
  vPrismCallBack.CallBackEvent:= Nil;

 FLock.BeginWrite;
 try
  FItems.AddOrSetValue(vPrismCallBack.ID, vPrismCallBack);
 finally
  FLock.EndWrite;
 end;

 result:= vPrismCallBack;
end;

procedure TPrismCallBacks.Unregister(AName: String);
var
 vPrismCallBackIntf: IPrismCallBack;
 vPrismCallBack: TPrismCallBack;
 vNames: TList<string>;
 I: Integer;
begin
 try
  vNames:= TList<string>.Create(FItems.Keys);

  FLock.BeginWrite;

  try
   for I := 0 to Pred(vNames.Count) do
   begin
    if FItems.ContainsKey(vNames[I]) then
    begin
     vPrismCallBackIntf:= FItems[vNames[I]];
     if (vPrismCallBackIntf.Name = AName) then
     begin
      FItems.Remove(vNames[I]);

      try
       vPrismCallBack:= vPrismCallBackIntf as TPrismCallBack;
       vPrismCallBackIntf:= nil;

       vPrismCallBack.Destroy;
      except
      end;

      Break;
     end;
    end;
   end;
  finally
   FLock.EndWrite;
  end;

  vNames.Free;
 except
 end;

end;

procedure TPrismCallBacks.UnRegisterAll(APrismForm: IPrismForm);
var
 vPrismCallBackIntf: IPrismCallBack;
 vPrismCallBack: TPrismCallBack;
 vNames: TList<string>;
 vKey: string;
 I: Integer;
begin
 try
  FLock.BeginWrite;

  try
   if Assigned(APrismForm) then
   begin
    vNames:= TList<string>.Create(FItems.Keys);

    for I := 0 to Pred(vNames.Count) do
    begin
     vKey:= vNames[I];

     if FItems.ContainsKey(vKey) then
     begin
      vPrismCallBackIntf:= FItems[vKey];
      if Assigned(vPrismCallBackIntf.PrismForm) and (vPrismCallBackIntf.PrismForm = APrismForm) then
      begin
       FItems.Remove(vKey);

       try
        vPrismCallBack:= vPrismCallBackIntf as TPrismCallBack;
        vPrismCallBackIntf:= nil;
        vPrismCallBack.Free;
       except
       end;
      end;
     end;
    end;

    vNames.Free;
   end;
  except
  end;
 finally
  FLock.EndWrite;
 end;
end;

function TPrismCallBacks.Register(AName, Parameters: String; APrismForm: IPrismForm): IPrismCallBack;
var
 vPrismCallBack: TPrismCallBack;
begin
 vPrismCallBack:= TPrismCallBack.Create(AName, Parameters, APrismForm, nil);

 FLock.BeginWrite;
 try
  FItems.AddOrSetValue(vPrismCallBack.ID, vPrismCallBack);
 finally
  FLock.EndWrite;
 end;

 result:= vPrismCallBack;
end;

{ TPrismFormCallBacks }

function TPrismFormCallBacks.CallBackJS(ACallBackName, Parameters: String;
  LockClient: Boolean): string;
begin
 if Assigned(FPrismForm) then
  result:= FPrismForm.Session.CallBacks.CallBackJS(ACallBackName, true, FPrismForm.FormUUID, Parameters, LockClient)
 else
 begin
  FLock.BeginRead;
  try
  if (not (FTempCallBacks.Count <= 0)) then
   if FTempCallBacks.ContainsKey(ACallBackName) then
   begin
    result:= FPrismSession.CallBacks.CallBackDirectJS(FTempCallBacks[ACallBackName], FFormUUID, Parameters, LockClient);
   end;
  finally
   FLock.EndRead;
  end;
 end;
end;

procedure TPrismFormCallBacks.Clear;
var
 vPrismCallBackIntf: IPrismCallBack;
 vPrismCallBack: TPrismCallBack;
 vKeys: TList<string>;
 vKey: string;
begin
 try
  FLock.BeginWrite;
  try
   if FTempCallBacks.Count > 0 then
   begin
    vKeys:= TList<string>.Create(FTempCallBacks.Keys);

    try
     while vKeys.Count > 0 do
     begin
      vKey:= vKeys.Last;
      vKeys.Remove(vKey);

      try
       vPrismCallBackIntf:= FTempCallBacks[vKey];

       FTempCallBacks.Remove(vKey);

       vPrismCallBack:= vPrismCallBackIntf as TPrismCallBack;
       vPrismCallBackIntf:= nil;
       vPrismCallBack.Free;
      except
      end;
     end;
    except
    end;

    vKeys.Free;
   end;
  except
  end;

  FTempCallBacks.Clear;
 finally
  FLock.EndWrite;
 end;
end;

procedure TPrismFormCallBacks.ConsolideTempCallBacks(APrismFormToConsolide: IPrismForm);
var
 vIPrismCallBack: IPrismCallBack;
begin
 if Assigned(APrismFormToConsolide) then
 begin
  // Percorrendo o dicionário
  FLock.BeginRead;
  try
   for vIPrismCallBack in FTempCallBacks.Values do
   begin
    FPrismSession.CallBacks.Register(vIPrismCallBack, APrismFormToConsolide);
 //   if Assigned(vIPrismCallBack.CallBackEvent) then
 //    APrismFormToConsolide.CallBacks.Register(vIPrismCallBack.Name, vIPrismCallBack.CallBackEvent)
 //   else
 //    APrismFormToConsolide.CallBacks.Register(vIPrismCallBack.Name, vIPrismCallBack.DefaultParameters);
   end;
  finally
   FLock.EndRead;
  end;

  Clear;
 end;
end;

constructor TPrismFormCallBacks.Create(AFormUUID: string; APrismForm: IPrismForm; APrismSession: IPrismSession);
begin
 FFormUUID:= AFormUUID;

 if APrismForm <> nil then
   FPrismForm:= APrismForm;

 if APrismSession <> nil then
   FPrismSession:= APrismSession;

 FTempCallBacks:= TDictionary<string, IPrismCallBack>.Create;

 FLock:= TMultiReadExclusiveWriteSynchronizer.Create;
end;

function TPrismFormCallBacks.Register(AName: String; ACallBackEventProc: TCallBackEvent): IPrismCallBack;
var
 vPrismCallBack: TPrismCallBack;
begin
 if Assigned(FPrismForm) then
 result:= FPrismForm.Session.CallBacks.Register(AName, FPrismForm, ACallBackEventProc)
 else
 begin
  vPrismCallBack:= TPrismCallBack.Create(AName, '', nil, ACallBackEventProc);

  FLock.BeginWrite;
  try
   FTempCallBacks.Add(AName, vPrismCallBack);
  finally
   FLock.EndWrite;
  end;

  result:= vPrismCallBack;
 end;
end;

destructor TPrismFormCallBacks.Destroy;
begin
 Clear;

 FreeAndNil(FTempCallBacks);

 if Assigned(FPrismForm) then
  FPrismForm:= nil;

 if Assigned(FPrismSession) then
  FPrismSession:= nil;

 FLock.Free;

 inherited;
end;

function TPrismFormCallBacks.GetCallBack(AName: String): IPrismCallBack;
begin
 result:= FPrismForm.Session.CallBacks.GetCallBack(AName, FPrismForm);
end;

function TPrismFormCallBacks.Register(AName: String; Parameters: String = ''): IPrismCallBack;
var
 vPrismCallBack: IPrismCallBack;
begin
 if Assigned(FPrismForm) then
  FPrismForm.Session.CallBacks.Register(AName, Parameters, FPrismForm)
 else
 begin
  vPrismCallBack:= TPrismCallBack.Create(AName, Parameters, nil, nil);

  FLock.BeginWrite;
  try
   FTempCallBacks.Add(AName, vPrismCallBack);
  finally
   FLock.EndWrite;
  end;

  result:= vPrismCallBack;
 end;
end;

function TPrismFormCallBacks.TempCallBacks: TDictionary<string, IPrismCallBack>;
begin
 Result:= FTempCallBacks;
end;

procedure TPrismFormCallBacks.Unregister(AName: String);
begin
 FPrismForm.Session.CallBacks.Unregister(AName);
end;

end.