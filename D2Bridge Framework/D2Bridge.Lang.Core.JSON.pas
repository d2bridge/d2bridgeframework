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

{$I D2Bridge.inc}

unit D2Bridge.Lang.Core.JSON;

interface

uses
  Classes, SysUtils, D2Bridge.JSON, Rtti, TypInfo,
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  D2Bridge.Lang.Interfaces;

 procedure GenerateJSON(Translate: TObject; var JSONObject : TJSONObject);
 procedure GenerateSubJSON(const Instance: IInterface; JsonObject: TJSONObject);


implementation

{ GenerateJSON }

procedure GenerateJSON(Translate: TObject; var JSONObject : TJSONObject);
var
  Ctx: TRttiContext;
  Typ: TRttiType;
  Meth: TRttiMethod;
{$IFDEF HAS_RTTI_FIELD}
  Field: TRttiField;
{$ENDIF}
  SubJson: TJSONObject;
  ReturnValue: TValue;
  vID2BridgeTermItem: IInterface;
begin
  JSONObject := TJSONObject.Create;

  try
    Ctx := TRttiContext.Create;

    try
      Typ := Ctx.GetType(TObject(Translate).ClassType);

{$IFDEF HAS_RTTI_FIELD}
      for Field in Typ.GetDeclaredFields do
      begin
        if Field.Visibility = mvPublic then
        begin
         if Field.FieldType.TypeKind in [tkUString, tkWString, tkLString] then
         begin
          JSONObject.AddPair(Field.Name, '');
         end else
         if Supports(Field.FieldType.AsInstance.MetaclassType, ID2BridgeTermItem) then
         begin
          ReturnValue:= Field.GetValue(TObject(Translate));
          SubJson := TJSONObject.Create;
          JSONObject.AddPair(Field.Name, SubJson);
          GenerateSubJSON(ReturnValue.AsInterface, SubJson);
         end;
        end;
      end;
{$ENDIF}

      for Meth in Typ.GetDeclaredMethods do
      begin
        if Meth.Visibility = mvPublic then
        begin
          if Meth.MethodKind = mkFunction then
          begin
           if not (Meth.ReturnType is TRttiInterfaceType) then
           begin
            if Meth.ReturnType.TypeKind <> tkInterface then
            begin
             if Meth.ReturnType.TypeKind in [tkUString, tkWString, tkLString] then
             begin
              JSONObject.AddPair(Meth.Name, '');
             end else
             begin
              ReturnValue := Meth.Invoke(TObject(Translate), []);
              //if ReturnValue.IsObjectInstance then
              if Supports(ReturnValue.AsInterface, ID2BridgeTermItem, vID2BridgeTermItem) then
              begin
               SubJson := TJSONObject.Create;
               JSONObject.AddPair(Meth.Name, SubJson);
               GenerateSubJSON(vID2BridgeTermItem, SubJson);
              end;
             end;
            end;
           end;
          end;
        end;
      end;
    finally
      Ctx.Free;
    end;
  finally

  end;
end;

procedure GenerateSubJSON(const Instance: IInterface; JsonObject: TJSONObject);
var
  Ctx: TRttiContext;
  Typ: TRttiType;
  Meth: TRttiMethod;
{$IFDEF HAS_RTTI_FIELD}
  Field: TRttiField;
{$ENDIF}
  ReturnValue: TValue;
begin
  Ctx := TRttiContext.Create;

  try
    Typ := Ctx.GetType((Instance as TObject).ClassType);

{$IFDEF HAS_RTTI_FIELD}
    for Field in Typ.GetDeclaredFields do
    begin
      if Field.Visibility = mvPublic then
      begin
       if Field.FieldType.TypeKind in [tkUString, tkWString, tkLString] then
       begin
        JSONObject.AddPair(Field.Name, '');
       end;
      end;
    end;
{$ENDIF}

    for Meth in Typ.GetDeclaredMethods  do
    begin
      if Meth.Visibility = mvPublic then
      begin
        if Meth.MethodKind = mkFunction then
        begin
          JsonObject.AddPair(Meth.Name, '');

          if Meth.ReturnType is TRttiInterfaceType then
          begin
           ReturnValue := Meth.Invoke(Typ.ClassType, []);

           if Meth.ReturnType.TypeKind = tkInterface then
           begin
            GenerateSubJSON(ReturnValue.AsInterface, JsonObject.GetValue(Meth.Name) as TJSONObject);
           end;
          end;
        end;
      end;
    end;
  finally
    Ctx.Free;
  end;
end;

end.