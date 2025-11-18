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

unit D2Bridge.Instance;

interface

uses
  Classes, SysUtils, Generics.Collections, RTTI,
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
{$IFDEF FMX}
  FMX.Forms,
{$ELSE}
  Forms,
{$ENDIF}
  D2Bridge, D2Bridge.Interfaces, D2Bridge.Types,
  Prism.Session, Prism.Interfaces;


{$IFDEF FMX}
type
  TFormClass = class of TForm;
{$ENDIF}

{$IFNDEF FPC}
type
  TDataModuleClass = class of TDataModule;
{$ENDIF}

type
 TD2BridgeInstance = class(TInterfacedPersistent, ID2BridgeInstance)
  strict private
   function FixInstanceObjectName(AObject: TObject): string;
   procedure Exec_CreateInstanceDMClass(varDMClass: TValue);
   procedure Exec_DestroyInstance(varObject: TValue);
  private
   FObjectInstance: TDictionary<TClass, TObject>;
   FPrismSession: IPrismSession;
   FOwner: TComponent;
   procedure CreateInstanceComponent(AComponent: TComponent); overload;
   procedure CreateInstanceComponent(AObject: TObject); overload;
   procedure CreateInstance(AForm: TForm); overload;
   procedure DestroyInstance(AObject: TObject); overload;
  protected

  public
   constructor Create(AOwner: TComponent);
   destructor Destroy; override;

   function GetPrismSession: IPrismSession; deprecated 'Use just Session';

   function GetSession: IPrismSession;

   function GetInstanceByObjectName(AName: String): TObject;

   procedure AddInstace(AObject: TObject);
   procedure RemoveInstance(AForm: TForm); overload;
   procedure RemoveInstance(ADM: TDataModule); overload;

   function GetInstance(AForm: TFormClass): TForm; overload;
   function GetInstance(ADM: TDataModuleClass): TDataModule; overload;
{$IFNDEF FPC}
   function GetInstance(AClass: TClass): TClass; overload;
{$ENDIF}

   procedure CreateInstance(ADMClass: TDataModuleClass); overload;
{$IFNDEF FPC}
   procedure CreateInstance(AClass: TClass); overload;
{$ENDIF}
   procedure CreateInstance(ADM: TDataModule); overload;
   procedure CreateInstance(AFormClass: TFormClass); overload;
   procedure CreateInstance(AFormClass: TFormClass; AOwner: TComponent); overload;

   procedure DestroyInstance(ADMClass: TDataModuleClass); overload;
   procedure DestroyInstance(AFormClass: TFormClass); overload;
   procedure DestroyInstance(ADM: TDataModule); overload;
   procedure DestroyInstance(AForm: TForm); overload;


   Function IsD2BridgeContext: Boolean;

   property Owner: TComponent read FOwner;
   property PrismSession: IPrismSession read GetPrismSession;
   property Session: IPrismSession read GetSession;
 end;


 {$IFDEF D2BRIDGE}
  function D2BridgeInstance: TD2BridgeInstance;
 {$ELSE}
  var
   D2BridgeInstance: TD2BridgeInstance;
 {$ENDIF}

 function PrismSession: TPrismSession;
 function IsD2BridgeContext: Boolean;


implementation

Uses
{$IFDEF D2BRIDGE}
 D2Bridge.BaseClass,
 D2Bridge.Manager,
 Prism.BaseClass,
 D2Bridge.Instance.Wrapper,
{$ELSE}

{$ENDIF}
 Prism.Session.Thread.Proc,
 D2Bridge.Forms
;


{ TD2BridgeInstance }

{$IFDEF D2BRIDGE}
function D2BridgeInstance: TD2BridgeInstance;
var
 vPrismSession: IPrismSession;
begin
 result:= nil;

 vPrismSession:= PrismBaseClass.Sessions.FromThreadID(TThread.CurrentThread.ThreadID);

 try
  if Assigned(vPrismSession) then
   Result:= TD2BridgeInstance(vPrismSession.D2BridgeInstance);
  except
  end;

 if Result = nil then
  Abort;
end;
{$ENDIF}

function PrismSession: TPrismSession;
var
 vPrismSession: IPrismSession;
begin
 Result:= nil;

 vPrismSession:= D2BridgeInstance.PrismSession;

 if Assigned(vPrismSession) then
  Result:= vPrismSession as TPrismSession;
end;

function IsD2BridgeContext: Boolean;
begin
 {$IFDEF D2BRIDGE}
 Result := True;
 {$ELSE}
 Result := False;
 {$ENDIF}
end;

procedure TD2BridgeInstance.AddInstace(AObject: TObject);
begin
 CreateInstanceComponent(AObject);

 if AObject is TD2BridgeForm then
  TD2BridgeForm(AObject).UsedD2BridgeInstance:= true;
end;

constructor TD2BridgeInstance.Create(AOwner: TComponent);
begin
 FOwner:= AOwner;

 FObjectInstance:= TDictionary<TClass, TObject>.create;

 {$IFDEF D2BRIDGE}
  FPrismSession:= TPrismSession(AOwner);
 {$ELSE}
  D2BridgeInstance:= self;
  FPrismSession:= TPrismSession.Create(nil);
 {$ENDIF}

 //FD2Bridge:= nil;
end;

procedure TD2BridgeInstance.CreateInstance(AFormClass: TFormClass);
begin
 CreateInstance(AFormClass, FOwner);
end;

procedure TD2BridgeInstance.CreateInstance(AForm: TForm);
begin
// //Precisa checar se já existe;
// if FObjectInstance.ContainsKey(AForm.ClassType) then
// begin
//  //Ja existe
// end else
// if not FObjectInstance.TryAdd(AForm.ClassType, AForm) then
// begin
//  //Algum erro ao incluir
// end;

 CreateInstanceComponent(AForm);

 if AForm is TD2BridgeForm then
 TD2BridgeForm(AForm).UsedD2BridgeInstance:= true;
end;

procedure TD2BridgeInstance.CreateInstanceComponent(AObject: TObject);
begin
 //Precisa checar se já existe;
 if FObjectInstance.ContainsKey(AObject.ClassType) then
 begin
  //Ja existe
 end else
 begin
  FObjectInstance.Add(AObject.ClassType, AObject);
 end;
end;

{$IFNDEF FPC}
procedure TD2BridgeInstance.CreateInstance(AClass: TClass);
begin
 CreateInstanceComponent(AClass.Create);
end;
{$ENDIF}

procedure TD2BridgeInstance.CreateInstanceComponent(
  AComponent: TComponent);
begin
 //Precisa checar se já existe;
 if FObjectInstance.ContainsKey(AComponent.ClassType) then
 begin
  //Ja existe
 end else
 begin
  FObjectInstance.Add(AComponent.ClassType, AComponent);
 end;

end;

procedure TD2BridgeInstance.CreateInstance(ADM: TDataModule);
begin
 CreateInstanceComponent(ADM);
end;

procedure TD2BridgeInstance.CreateInstance(ADMClass: TDataModuleClass);
begin
 {$IFDEF D2BRIDGE}
  PrismSession.ExecThread(true,
   Exec_CreateInstanceDMClass,
   TValue.From<TDataModuleClass>(ADMClass),
   PrismBaseClass.Options.UseMainThread
  );
 {$ELSE}
  CreateInstance(ADMClass.Create(FOwner));
 {$ENDIF}
end;

destructor TD2BridgeInstance.Destroy;
begin
 //DestroyAllInstances;

 {$IFNDEF D2BRIDGE}
  (FPrismSession as TPrismSession).Destroy;
 {$ENDIF}

 FObjectInstance.Clear;
 FObjectInstance.Free;

 inherited;

 {$IFNDEF D2BRIDGE}
  //{ #todo : This metod is temporary * Review }Temporary
  ExitProcess(0);
 {$ENDIF}
end;


procedure TD2BridgeInstance.DestroyInstance(AFormClass: TFormClass);
begin
 DestroyInstance(AFormClass);
end;

procedure TD2BridgeInstance.DestroyInstance(ADMClass: TDataModuleClass);
begin
 DestroyInstance(ADMClass);
end;

procedure TD2BridgeInstance.Exec_CreateInstanceDMClass(varDMClass: TValue);
var
 vDMClass: TDataModuleClass;
 vDM: TDataModule;
begin
 try
  vDMClass:= TDataModuleClass(varDMClass.AsClass);

{$IFDEF D2BRIDGE}
  vDM:= vDMClass.CreateNew(FOwner);
  CreateInstance(vDM);
  TD2BridgeInstanceWrapper.Create(vDM, self);
  InitInheritedComponent(vDM, TDataModule);
  if Assigned(vDM.OnCreate) then
   vDM.OnCreate(vDM);
{$ELSE}
  vDM:= vDMClass.Create(FOwner);
  CreateInstance(vDM);
{$ENDIF}
 except
 end;
end;

procedure TD2BridgeInstance.Exec_DestroyInstance(varObject: TValue);
var
 vObject: TObject;
begin
 try
  vObject:= varObject.AsObject;

  vObject.Free;
 except
 end;
end;

function TD2BridgeInstance.FixInstanceObjectName(AObject: TObject): string;
var
 vInstanceNumberStr: String;
 vInstanceNumber: Integer;
 vName, vNamebyClass, vPosName: String;
begin
 Result:= '';
 if AObject.InheritsFrom(TComponent) then
 begin
  vName:= TComponent(AObject).Name;
  Result:= vName;
  vNamebyClass:= Copy(TComponent(AObject).ClassName, 2);

  vPosName:= Copy(vName, Length(vNamebyClass)+1);
  vInstanceNumberStr:= Copy(vPosName, Length(vPosName));

  if (AnsiPos('_', vPosName) = 1) and (TryStrToInt(vInstanceNumberStr, vInstanceNumber)) then
  begin
   //TCOmponent(AObject).Name:= vNamebyClass;
   Result:= vNamebyClass;
  end;
 end;
end;

{$IFNDEF FPC}
function TD2BridgeInstance.GetInstance(AClass: TClass): TClass;
begin
 if not FObjectInstance.TryGetValue(AClass, TObject(Result)) then
 begin
//   Result := AForm.Create(Application);
//   FObjectInstance.Add(AForm, Result);
  Result:= nil;
 end;

end;
{$ENDIF}

function TD2BridgeInstance.GetInstanceByObjectName(AName: String): TObject;
var
 I: integer;
 vComponentName: string;
begin
 Result:= nil;

 for I := 0 to Pred(FObjectInstance.Count) do
 begin
  if FObjectInstance.ToArray[I].Value.InheritsFrom(TComponent) then
  begin
   vComponentName:= TComponent(FObjectInstance.ToArray[I].Value).Name;
   if SameText(AName, vComponentName) then
   begin
    Result:= FObjectInstance.ToArray[I].Value;
    Break;
   end;
  end;
 end;

 if Result = nil then
 for I := 0 to Pred(FObjectInstance.Count) do
 begin
  if FObjectInstance.ToArray[I].Value.InheritsFrom(TComponent) then
  begin
   vComponentName:= FixInstanceObjectName(TComponent(FObjectInstance.ToArray[I].Value));
   if SameText(AName, vComponentName) then
   begin
    Result:= FObjectInstance.ToArray[I].Value;
    Break;
   end;
  end;
 end;

end;

function TD2BridgeInstance.GetPrismSession: IPrismSession;
begin
 Result:= FPrismSession;
end;

function TD2BridgeInstance.GetSession: IPrismSession;
begin
 Result:= FPrismSession;
end;

function TD2BridgeInstance.IsD2BridgeContext: Boolean;
begin
 {$IFDEF D2BRIDGE}
 Result := True;
 {$ELSE}
 Result := False;
 {$ENDIF}
end;

procedure TD2BridgeInstance.RemoveInstance(ADM: TDataModule);
begin
 if FObjectInstance.ContainsKey(ADM.ClassType) then
 FObjectInstance.Remove(ADM.ClassType);
end;

procedure TD2BridgeInstance.RemoveInstance(AForm: TForm);
begin
 if FObjectInstance.ContainsKey(AForm.ClassType) then
 FObjectInstance.Remove(AForm.ClassType);
end;

function TD2BridgeInstance.GetInstance(ADM: TDataModuleClass): TDataModule;
begin
 if not FObjectInstance.TryGetValue(ADM, TObject(Result)) then
 begin
//   Result := AForm.Create(Application);
//   FObjectInstance.Add(AForm, Result);
  Result:= nil;
 end;

end;

function TD2BridgeInstance.GetInstance(AForm: TFormClass): TForm;
begin
 if not FObjectInstance.TryGetValue(AForm, TObject(Result)) then
 begin
  Result:= nil;
 end;
end;

procedure TD2BridgeInstance.CreateInstance(AFormClass: TFormClass; AOwner: TComponent);
begin
 CreateInstance(AFormClass.Create(AOwner));
end;

procedure TD2BridgeInstance.DestroyInstance(ADM: TDataModule);
begin
 DestroyInstance(TObject(ADM));
end;

procedure TD2BridgeInstance.DestroyInstance(AForm: TForm);
begin
 DestroyInstance(TObject(AForm));
end;

procedure TD2BridgeInstance.DestroyInstance(AObject: TObject);
var
 ObjectDestroy: TObject;
 vClass: TClass;
begin
 {$IFDEF D2BRIDGE}
 vClass:= AObject.ClassType;
 if FObjectInstance.TryGetValue(vClass, ObjectDestroy) then
 begin
  try
   TPrismSessionThreadProc.Create(FPrismSession,
     Exec_DestroyInstance,
     TValue.From<TObject>(ObjectDestroy),
     true,
     true
   ).Exec;
  finally
   FObjectInstance.Remove(vClass);
  end;
 end;
 {$ELSE}
  AObject.Free;
 {$ENDIF}
end;

{$IFDEF D2BRIDGE}

{$ELSE}
initialization
 D2BridgeInstance:= TD2BridgeInstance.Create(Application);
finalization
 D2BridgeInstance.Destroy;
{$ENDIF}

end.

