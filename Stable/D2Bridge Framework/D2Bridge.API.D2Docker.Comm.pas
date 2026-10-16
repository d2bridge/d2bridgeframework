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

unit D2Bridge.API.D2Docker.Comm;

interface

{$IFDEF D2DOCKER}

Uses
  Classes, Generics.Collections, SysUtils, Windows, RTTI, Variants, TypInfo,
  {$IFDEF FMX}

  {$ELSE}
   {$IFDEF FPC}
   fpjson,
   {$ELSE}
   JSON,
   {$ENDIF}
  {$ENDIF}
  D2Bridge.JSON,
  D2Bridge.API.D2Docker.Types
  ;


type
  TD2DockerProcedure0 = procedure of object;
  TD2DockerProcedureBool1 = procedure(A1: Boolean) of object;
  TD2DockerProcedureStr1 = procedure(A1: string) of object;
  TD2DockerProcedureInt1 = procedure(A1: integer) of object;
  TD2DockerProcedureStrInt = procedure(A1: string; A2: integer) of object;
  TD2DockerProcedureIntStr = procedure(A1: integer; A2: string) of object;

  TD2DockerFuncBool0 = function: Boolean of object;
  TD2DockerFuncBool1 = function(A1: Boolean): Boolean of object;
  TD2DockerFuncStr0 = function: string of object;
  TD2DockerFuncStr1 = function(A1: string): string of object;
  TD2DockerFuncInt0 = function: Integer of object;
  TD2DockerFuncInt1 = function(A1: integer): Integer of object;
  TD2DockerFuncStrIntStr = function(A1: string; A2: integer): string of object;
  TD2DockerFuncStrIntInt = function(A1: string; A2: integer): integer of object;
  TD2DockerFuncIntStrStr = function(A1: integer; A2: string): string of object;
  TD2DockerFuncIntStrInt = function(A1: integer; A2: string): integer of object;


procedure ProcExchange(const CommandJson: PAnsiChar); stdcall;
procedure FuncExchange(const CommandJson: PAnsiChar; OutputBuffer: PChar; OutputBufferSize: Integer); stdcall;

procedure RegisterCBServerStarted(ACBServerStarted: TD2DockerCBServerStarted); stdcall;
procedure RegisterCBLog(ACBLog: TD2DockerCBLog); stdcall;
procedure RegisterCBSession(ACBSession: TD2DockerCBSession); stdcall;

{$IFDEF FPC}
procedure LinkerLaz;
{$ENDIF}

implementation

Uses
 D2Bridge.ServerControllerBase,
 D2Bridge.Manager,
 D2Bridge.API.D2Docker;




function Exchange(const AJSON: PAnsiChar): string;
var
  jObj: TJSONObject;
  jParameter0, jParameter1: TJSONObject;
  jParams: TJSONArray;
  ObjName, MemberName, KindStr, ResultType: string;
  Instance: TObject;
  MethodPtr: Pointer;
  Method: TMethod;
  OutputJSON: TJSONObject;
  PropInfo: PPropInfo;
  ArgStr, ArgStr2: string;
  ArgInt, ArgInt2: Integer;
  ArgBool, ArgBool2: boolean;
  ParamTypeName, ParamTypeName2: string;
  IsFunction: Boolean;
  PropTypeInfo: {$IFnDEF FPC}PPTypeInfo{$ELSE}PTypeInfo{$ENDIF};
  PropKind: TTypeKind;
begin
  Result := '';
  OutputJSON := TJSONObject.Create;
  try
    try
      jObj := TJSONObject.ParseJSONValue(AJSON) as TJSONObject;
      try
        ObjName := jObj.GetValue('object', '');
        MemberName := jObj.GetValue('method', '');
        KindStr := LowerCase(jObj.GetValue('kind', 'procedure'));
        ResultType := LowerCase(jObj.GetValue('result', 'string'));
        IsFunction := KindStr = 'function';
        jParams := TJSONArray(jObj.GetValue('params'));


        Instance:= D2BridgeManager.API.D2Docker.RTTIObject(ObjName);

        if not Assigned(Instance) then
        begin
          OutputJSON.AddPair('error', 'Objeto "' + ObjName + '" não registrado.');
          Exit(Result);
        end;

        PropInfo := GetPropInfo(Instance.ClassInfo, MemberName);
        if Assigned(PropInfo) then
        begin
          PropTypeInfo := PropInfo^.PropType;
          if Assigned(PropTypeInfo) then
            PropKind := PropTypeInfo^.Kind
          else
            PropKind := tkUnknown;

          if (jParams = nil) or (jParams.Count = 0) then
          begin
            OutputJSON.AddPair('status','ok');
            OutputJSON.AddPair('result', VarToStr(GetPropValue(Instance, PropInfo)));
            OutputJSON.AddPair('success', TJSONBool.Create(true));
            OutputJSON.AddPair('property', MemberName);
            Result := OutputJSON.ToJSON;
            Exit;
          end else
          if Assigned(jParams) and (jParams.Count = 1) then
          begin
            jParameter0:= jParams.Items[0] as TJSONObject;
            case PropKind of
              tkInteger: SetPropValue(Instance, PropInfo, TJSONIntegerNumber(jParameter0.GetJsonValue(0)).{$IFnDEF FPC}AsInt{$ELSE}AsInteger{$ENDIF});
              tkFloat:   SetPropValue(Instance, PropInfo, TJSONIntegerNumber(jParameter0.GetJsonValue(0)).{$IFnDEF FPC}AsDouble{$ELSE}AsFloat{$ENDIF});
              {$IFDEF FPC}tkAString,{$ENDIF} tkString, tkLString, tkUString, tkWString: SetPropValue(Instance, PropInfo, jParameter0.GetJsonValue(0).Value);
              {$IFDEF FPC}
              tkBool :    SetPropValue(Instance, PropInfo, TJSONBool(jParameter0.GetJsonValue(0)).AsBoolean);
              {$ELSE}
              tkEnumeration:
                if SameText(GetEnumName(PropInfo^.PropType^, 0), 'False') and
                   SameText(GetEnumName(PropInfo^.PropType^, 1), 'True') then
                  SetPropValue(Instance, PropInfo, SameText(jParameter0.GetJsonValue(0).Value, 'true'))
                else
                begin
                  OutputJSON.AddPair('error', 'Enun not supported: ' + PropInfo^.Name);
                  Exit(Result);
                end;
              {$ENDIF}
            else
              OutputJSON.AddPair('error', 'Tipo de propriedade não suportado.');
              Exit(Result);
            end;
            OutputJSON.AddPair('status','ok');
            OutputJSON.AddPair('property_set', MemberName);
            Result := OutputJSON.ToJSON;
            Exit;
          end;
        end;

        MethodPtr := Instance.MethodAddress(MemberName);
        if not Assigned(MethodPtr) then
        begin
          OutputJSON.AddPair('status','error');
          OutputJSON.AddPair('error', 'Método não encontrado.');
          Exit(Result);
        end;

        Method.Code := MethodPtr;
        Method.Data := Instance;

        if Assigned(jParams) then
        begin
          if jParams.Count = 2 then
          begin
            jParameter0:= jParams.Items[0] as TJSONObject;
            jParameter1:= jParams.Items[1] as TJSONObject;
            ParamTypeName := LowerCase(jParameter0.GetJsonStringValue(0));
            ParamTypeName2 := LowerCase(jParameter1.GetJsonStringValue(0));

            if ParamTypeName = 'string' then
              ArgStr := jParameter0.GetJsonValue(0).Value
            else
            if ParamTypeName = 'integer' then
              ArgInt := TJSONIntegerNumber(jParameter0.GetJsonValue(0)).{$IFnDEF FPC}AsInt{$ELSE}AsInteger{$ENDIF}
            else
            if ParamTypeName = 'boolean' then
              ArgBool := TJSONBool(jParameter0.GetJsonValue(0)).AsBoolean;

            if ParamTypeName2 = 'string' then
              ArgStr2 := jParameter1.GetJsonValue(0).Value
            else
            if ParamTypeName2 = 'integer' then
              ArgInt2 := TJSONIntegerNumber(jParameter1.GetJsonValue(0)).{$IFnDEF FPC}AsInt{$ELSE}AsInteger{$ENDIF}
            else
            if ParamTypeName = 'boolean' then
              ArgBool2 := TJSONBool(jParameter1.GetJsonValue(0)).AsBoolean;


            { TODO : Falta implementar Boolean }
            if not IsFunction then
            begin
              if (ParamTypeName = 'string') and (ParamTypeName2 = 'integer') then
                TD2DockerProcedureStrInt(Method)(ArgStr, ArgInt2)
              else
              if (ParamTypeName = 'integer') and (ParamTypeName2 = 'string') then
                TD2DockerProcedureIntStr(Method)(ArgInt, ArgStr2);
            end
            else
            begin
              if (ParamTypeName = 'string') and (ParamTypeName2 = 'integer') then
              begin
                if ResultType = 'string' then
                  OutputJSON.AddPair('result', TD2DockerFuncStrIntStr(Method)(ArgStr, ArgInt2))
                else
                if ResultType = 'integer' then
                  OutputJSON.AddPair('result',
                    {$IFnDEF FPC}
                     TJSONNumber.Create(TD2DockerFuncStrIntInt(Method)(ArgStr, ArgInt2))
                    {$ELSE}
                     TD2DockerFuncStrIntInt(Method)(ArgStr, ArgInt2)
                    {$ENDIF});
              end
              else
              if (ParamTypeName = 'integer') and (ParamTypeName2 = 'string') then
              begin
                if ResultType = 'string' then
                  OutputJSON.AddPair('result', TD2DockerFuncIntStrStr(Method)(ArgInt, ArgStr2))
                else
                if ResultType = 'integer' then
                  OutputJSON.AddPair('result',
                    {$IFnDEF FPC}
                     TJSONNumber.Create(TD2DockerFuncIntStrInt(Method)(ArgInt, ArgStr2))
                    {$ELSE}
                     TD2DockerFuncIntStrInt(Method)(ArgInt, ArgStr2)
                    {$ENDIF});
              end;
            end;
          end else
          if jParams.Count = 1 then
          begin
            jParameter0:= jParams.Items[0] as TJSONObject;
            ParamTypeName := LowerCase(jParameter0.GetJsonStringValue(0));
            if ParamTypeName = 'string' then
            begin
              ArgStr := jParameter0.GetJsonValue(0).Value;
              if IsFunction then
                OutputJSON.AddPair('result', TD2DockerFuncStr1(Method)(ArgStr))
              else
                TD2DockerProcedureStr1(Method)(ArgStr);
            end else
            if ParamTypeName = 'integer' then
            begin
              ArgInt := TJSONIntegerNumber(jParameter0.GetJsonValue(0)).{$IFnDEF FPC}AsInt{$ELSE}AsInteger{$ENDIF};
              if IsFunction then
                OutputJSON.AddPair('result',
                 {$IFnDEF FPC}
                  TJSONNumber.Create(TD2DockerFuncInt1(Method)(ArgInt))
                 {$ELSE}
                  TD2DockerFuncInt1(Method)(ArgInt)
                 {$ENDIF})
              else
                TD2DockerProcedureInt1(Method)(ArgInt);
            end else
            if ParamTypeName = 'boolean' then
            begin
              ArgBool := TJSONBool(jParameter0.GetJsonValue(0)).AsBoolean;
              if IsFunction then
                OutputJSON.AddPair('result', TJSONBool.Create(TD2DockerFuncBool1(Method)(ArgBool)))
              else
                TD2DockerProcedureBool1(Method)(ArgBool);
            end;
          end
          else
          if jParams.Count = 0 then
          begin
            if IsFunction then
            begin
              if ResultType = 'string' then
                OutputJSON.AddPair('result', TD2DockerFuncStr0(Method)())
              else
              if ResultType = 'integer' then
                OutputJSON.AddPair('result',
                 {$IFnDEF FPC}
                  TJSONNumber.Create(TD2DockerFuncInt0(Method)())
                 {$ELSE}
                  TD2DockerFuncInt0(Method)()
                 {$ENDIF})
              else
              if ResultType = 'boolean' then
                OutputJSON.AddPair('result', TJSONBool.Create(TD2DockerFuncBool0(Method)()));
            end
            else
              TD2DockerProcedure0(Method)();
          end;
        end
        else
        begin
          if IsFunction then
          begin
            if ResultType = 'string' then
              OutputJSON.AddPair('result', TD2DockerFuncStr0(Method)())
            else
            if ResultType = 'integer' then
              OutputJSON.AddPair('result',
               {$IFnDEF FPC}
                TJSONNumber.Create(TD2DockerFuncInt0(Method)())
               {$ELSE}
                TD2DockerFuncInt0(Method)()
               {$ENDIF})
            else
            if ResultType = 'boolean' then
              OutputJSON.AddPair('result', TJSONBool.Create(TD2DockerFuncBool0(Method)()));
          end
          else
            TD2DockerProcedure0(Method)();
        end;

        OutputJSON.AddPair('status', 'ok');
        OutputJSON.AddPair('method', MemberName);
      finally
        jObj.Free;
      end;
    except
      on E: Exception do
      begin
        OutputJSON.AddPair('status', 'error');
        OutputJSON.AddPair('error', E.Message);
        OutputJSON.AddPair('original', AJSON);
      end;
    end;
  finally
    if Assigned(OutputJSON) then
    begin
      Result := OutputJSON.ToJSON;
      OutputJSON.Free;
    end else
      Result := '';
  end;
end;


procedure FuncExchange(const CommandJson: PAnsiChar; OutputBuffer: PChar; OutputBufferSize: Integer); stdcall;
var
  Resp: string;
  LenResp: integer;
begin
  Resp:= Exchange(CommandJson);

  LenResp:= Length(Resp);

  if LenResp >= OutputBufferSize then
    LenResp := OutputBufferSize - 1;

  Move(PAnsiChar(AnsiString(Resp))^, OutputBuffer^, LenResp);
  OutputBuffer[LenResp] := #0;
end;


procedure ProcExchange(const CommandJson: PAnsiChar); stdcall;
begin
 Exchange(CommandJson);
end;


//CallBack
procedure RegisterCBServerStarted(ACBServerStarted: TD2DockerCBServerStarted); stdcall;
begin
 (D2BridgeManager.API.D2Docker as TD2BridgeAPIDocker).CallBackServerStarted:= ACBServerStarted;
end;

procedure RegisterCBLog(ACBLog: TD2DockerCBLog); stdcall;
begin
 (D2BridgeManager.API.D2Docker as TD2BridgeAPIDocker).CallBackLog:= ACBLog;
end;

procedure RegisterCBSession(ACBSession: TD2DockerCBSession); stdcall;
begin
 (D2BridgeManager.API.D2Docker as TD2BridgeAPIDocker).CallBackSession:= ACBSession;
end;


{$IFDEF FPC}
procedure LinkerLaz;
begin
end;
{$ENDIF}


exports
  FuncExchange              name 'FuncExchange',
  ProcExchange              name 'ProcExchange',

  RegisterCBServerStarted   name 'RegisterCBServerStarted',
  RegisterCBLog             name 'RegisterCBLog',
  RegisterCBSession         name 'RegisterCBSession';


{$ELSE}
implementation
{$ENDIF}


end.