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

unit D2Bridge.Forms.Helper;

interface

uses
  Classes, Rtti, Generics.Collections, SysUtils,
  D2Bridge.Interfaces, Prism.interfaces, Prism.Types;

type
 TD2BridgeFormComponentHelperItems = class;
 TD2BridgeFormComponentHelperProp = class;

 TD2BridgeFormComponentHelper = class(TObject)
  private
   FComponent: TObject;
   FComponentHelperProps: TDictionary<string, TD2BridgeFormComponentHelperProp>;
   FD2BridgeFormComponentHelperItems: TD2BridgeFormComponentHelperItems;
   FOnDestroy: TProc;
   procedure SetValue(APropertyName: string; APropertyValue: TValue);
   function GetValue(APropertyName: string): TValue;
    procedure SetFormComponentHelperItems(const Value: TD2BridgeFormComponentHelperItems);
  public
   constructor Create(AComponentHelperItems: TD2BridgeFormComponentHelperItems; AComponent: TObject);
   destructor Destroy; override;

   function Prop(APropertyName: string): TD2BridgeFormComponentHelperProp;

   property Component: TObject read FComponent;
   property Value[APropertyName: string]: TValue read GetValue write SetValue;
   property OnDestroy: TProc read FOnDestroy write FOnDestroy;

   property D2BridgeFormComponentHelperItems: TD2BridgeFormComponentHelperItems
    read FD2BridgeFormComponentHelperItems write SetFormComponentHelperItems;
 end;


 TD2BridgeFormComponentHelperProp = class(TObject)
  private
   FPropertyName: string;
   FPropertyValue: TValue;
   FComponentHelper: TD2BridgeFormComponentHelper;
  public
   constructor Create(AComponentHelper: TD2BridgeFormComponentHelper; APropertyName: String);
   destructor Destroy; override;

   property PropertyName: string read FPropertyName;
   property PropertyValue: TValue read FPropertyValue write FPropertyValue;
 end;


 TD2BridgeFormComponentHelperItems = class(TObject)
  private
   FD2BridgeForm: TObject;
   FSession: IPrismSession;
   FFormComponentHelpers: TDictionary<TObject, TD2BridgeFormComponentHelper>;
   procedure SetValue(AComponent: TOBject; APropertyName: string; APropertyValue: TValue);
   function GetValue(AComponent: TOBject; APropertyName: string): TValue;
  public
   constructor Create(AD2BridgeForm: TObject);
   destructor Destroy; override;

   function PropValues(AComponent: TOBject): TD2BridgeFormComponentHelper;

   property Value[AComponent: TOBject; APropertyName: string]: TValue read GetValue write SetValue;
   property D2BridgeForm: TObject read FD2BridgeForm;
   property Session: IPrismSession read FSession;
 end;

function TagIsD2BridgeFormComponentHelper(ATag: NativeInt): Boolean; overload;
function TagIsD2BridgeFormComponentHelper(ATag: NativeInt; APropName: string): Boolean; overload;

implementation

uses
  D2Bridge.Forms;


{ TD2BridgeFormComponentHelperItems }

constructor TD2BridgeFormComponentHelperItems.Create(AD2BridgeForm: TObject);
begin
 FD2BridgeForm:= AD2BridgeForm;
 FSession:= TD2BridgeForm(AD2BridgeForm).PrismSession;

 FFormComponentHelpers:= TDictionary<TObject, TD2BridgeFormComponentHelper>.Create;
end;

destructor TD2BridgeFormComponentHelperItems.Destroy;
var
 vFormComponentHelper: TD2BridgeFormComponentHelper;
 vKeys: TList<TObject>;
 vKey: TObject;
begin
 try
  if FFormComponentHelpers.Count > 0 then
  begin
   vKeys:= TList<TObject>.Create(FFormComponentHelpers.Keys);

   try
    while vKeys.Count > 0 do
    begin
     vKey:= vKeys.Last;
     vKeys.Remove(vKey);

     try
      vFormComponentHelper:= FFormComponentHelpers[vKey];
      vFormComponentHelper.Free;
     except
     end;
    end;
   except
   end;

   vKeys.Free;
  end;
  FFormComponentHelpers.Free;
 except
 end;

 if Assigned(FSession) then
  FSession:= nil;

 inherited;
end;

function TD2BridgeFormComponentHelperItems.GetValue(AComponent: TOBject; APropertyName: string): TValue;
begin
 result:= PropValues(AComponent).Value[APropertyName];
end;

function TD2BridgeFormComponentHelperItems.PropValues(AComponent: TOBject): TD2BridgeFormComponentHelper;
var
 vComponentHelper: TD2BridgeFormComponentHelper;
begin
 if not FFormComponentHelpers.TryGetValue(AComponent, vComponentHelper) then
 begin
  vComponentHelper:= TD2BridgeFormComponentHelper.Create(self, AComponent);
  FFormComponentHelpers.Add(AComponent, vComponentHelper);
 end;

 Result:= vComponentHelper;
end;

procedure TD2BridgeFormComponentHelperItems.SetValue(AComponent: TOBject; APropertyName: string; APropertyValue: TValue);
begin
 PropValues(AComponent).Value[APropertyName]:= APropertyValue;
end;

{ TD2BridgeFormComponentHelper }

constructor TD2BridgeFormComponentHelper.Create(AComponentHelperItems: TD2BridgeFormComponentHelperItems; AComponent: TObject);
begin
 FD2BridgeFormComponentHelperItems:= AComponentHelperItems;
 FComponent:= AComponent;

 FComponentHelperProps:= TDictionary<string, TD2BridgeFormComponentHelperProp>.Create;
end;

destructor TD2BridgeFormComponentHelper.Destroy;
var
 vProp: TD2BridgeFormComponentHelperProp;
 vKeys: TList<string>;
 vKey: string;
 vObject: TObject;
begin
 if Assigned(FOnDestroy) then
  FOnDestroy;

 try
  if FComponentHelperProps.Count > 0 then
  begin
   vKeys:= TList<string>.Create(FComponentHelperProps.Keys);

   try
    while vKeys.Count > 0 do
    begin
     vKey:= vKeys.Last;
     vKeys.Remove(vKey);

     try
      vProp:= FComponentHelperProps[vKey];
      vProp.Free;
     except
     end;
    end;
   except
   end;

   vKeys.Free;
  end;
  FComponentHelperProps.Free;
 except
 end;

 inherited;
end;

function TD2BridgeFormComponentHelper.GetValue(APropertyName: string): TValue;
begin
 result:= Prop(APropertyName).PropertyValue;
end;

function TD2BridgeFormComponentHelper.Prop(APropertyName: string): TD2BridgeFormComponentHelperProp;
var
 vComponentHelperProp: TD2BridgeFormComponentHelperProp;
begin
 if not FComponentHelperProps.TryGetValue(APropertyName, vComponentHelperProp) then
 begin
  vComponentHelperProp:= TD2BridgeFormComponentHelperProp.Create(self, APropertyName);
  FComponentHelperProps.Add(APropertyName, vComponentHelperProp);
 end;

 Result:= vComponentHelperProp;
end;

procedure TD2BridgeFormComponentHelper.SetFormComponentHelperItems(const Value: TD2BridgeFormComponentHelperItems);
begin
 FD2BridgeFormComponentHelperItems := Value;

 Value.FFormComponentHelpers.AddOrSetValue(FComponent, self);
end;

procedure TD2BridgeFormComponentHelper.SetValue(APropertyName: string; APropertyValue: TValue);
begin
 Prop(APropertyName).PropertyValue:= APropertyValue;
end;

{ TD2BridgeFormComponentHelperProp }

constructor TD2BridgeFormComponentHelperProp.Create(AComponentHelper: TD2BridgeFormComponentHelper; APropertyName: String);
begin
 FComponentHelper:= AComponentHelper;
 FPropertyName:= APropertyName;
end;

function TagIsD2BridgeFormComponentHelper(ATag: NativeInt): Boolean;
begin
 Result:= TObject(ATag) is TD2BridgeFormComponentHelper;
end;

function TagIsD2BridgeFormComponentHelper(ATag: NativeInt; APropName: string): Boolean;
var
 vD2BridgeFormComponent: TD2BridgeFormComponentHelper;
begin
 result:= false;

 if TagIsD2BridgeFormComponentHelper(ATag) then
 begin
  vD2BridgeFormComponent:= TD2BridgeFormComponentHelper(ATag);
  if vD2BridgeFormComponent.FComponentHelperProps.Count > 0 then
   result:= vD2BridgeFormComponent.FComponentHelperProps.ContainsKey(APropName);
 end;
end;

destructor TD2BridgeFormComponentHelperProp.Destroy;
begin
 try
 if FPropertyValue.IsObject then
  if (FPropertyValue.AsObject <> nil) and (not FPropertyValue.IsEmpty) then
   FPropertyValue.AsObject.Free;
 except
 end;

 inherited;
end;

end.
