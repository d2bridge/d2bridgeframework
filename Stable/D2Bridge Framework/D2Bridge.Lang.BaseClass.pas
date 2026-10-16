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

unit D2Bridge.Lang.BaseClass;

interface

uses
  Classes, SysUtils, D2Bridge.JSON, Rtti, TypInfo,
{$IFDEF HAS_UNIT_SYSTEM_IOUTILS}
  System.IOUtils,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  D2Bridge.Lang.Interfaces, D2Bridge.Lang.Term.BaseClass, Prism.JSONHelper, Prism.Types;

type
 TD2BridgeLangBaseClass = class(TInterfacedPersistent, ID2BridgeLangBaseClass)
  private
   FD2BridgeLangCoreBaseClass: ID2BridgeLangCoreBaseClass;
   FD2BridgeLang: ID2BridgeLang;
   FD2BridgeTerm: ID2BridgeTerm;
   FJSONResourceLang: TJSONObject;
   FJSONLang: TJSONObject;
   FFormatSettings: TFormatSettings;
{$IFDEF FPC}
  protected
{$ENDIF}
   procedure LoadJSONfromResource;
   procedure ProcessJSONLang;
   procedure PopuleFieldTerms;
  public
   constructor Create(AD2BridgeLangCoreBaseClass: ID2BridgeLangCoreBaseClass; AD2BridgeTermClass: TD2BridgeTermClass; AD2BridgeLang: ID2BridgeLang);
   destructor Destroy; override;

   function Translate(ATerm: string): string; overload; virtual;
  published
   function FormatSettings: TFormatSettings;

   function IsRTL: Boolean; virtual;
   function HTMLLangGeneric: string;

   function D2BridgeTerm: ID2BridgeTerm;
   function Translate(AContext: string; ATerm: string): string; overload; virtual;
 end;

implementation

uses
  D2Bridge.Manager, D2Bridge.Util;

{ TD2BridgeLangBaseClass }

constructor TD2BridgeLangBaseClass.Create(AD2BridgeLangCoreBaseClass: ID2BridgeLangCoreBaseClass; AD2BridgeTermClass: TD2BridgeTermClass; AD2BridgeLang: ID2BridgeLang);
var
 D2BridgeTermObject: TObject;
begin
 FD2BridgeLangCoreBaseClass:= AD2BridgeLangCoreBaseClass;

 if Supports(AD2BridgeTermClass, ID2BridgeTerm) then
 begin
   D2BridgeTermObject:= TD2BridgeTermClass(AD2BridgeTermClass).Create(AD2BridgeLang);
   Supports(D2BridgeTermObject, ID2BridgeTerm, FD2BridgeTerm);
 end;

 FD2BridgeLang:= AD2BridgeLang;

{$IFNDEF FPC}
 FFormatSettings:= TFormatSettings.Create(FD2BridgeLang.HTMLLang);
{$ELSE}
 FFormatSettings:= DefaultFormatSettings;

 {$IFDEF MSWINDOWS}
 GetLocaleFormatSettings(GetLocaleLang(FD2BridgeLang.HTMLLang), FFormatSettings);
 {$ENDIF}
{$ENDIF}

 FD2BridgeLang.DoConfigFormatSettings;

 LoadJSONfromResource;

{$IFDEF MSWINDOWS}
 if FD2BridgeLangCoreBaseClass.ExportJSON and IsDebuggerPresent then
 begin
  FJSONLang:= FD2BridgeLangCoreBaseClass.JSONDefaultLang.NewClone as TJSONObject;
  ProcessJSONLang;
 end else
 begin

 end;
{$ENDIF}

 PopuleFieldTerms;
end;

function TD2BridgeLangBaseClass.D2BridgeTerm: ID2BridgeTerm;
begin
 Result:= FD2BridgeTerm;
end;

destructor TD2BridgeLangBaseClass.Destroy;
var
 vD2BridgeTerm: TD2BridgeTermBaseClass;
begin
 if Assigned(FD2BridgeTerm) then
 begin
  vD2BridgeTerm:= FD2BridgeTerm as TD2BridgeTermBaseClass;
  FD2BridgeTerm:= nil;
  vD2BridgeTerm.Free;
 end;

 try
  if Assigned(FJSONResourceLang) then
   FJSONResourceLang.Destroy;
 except
 end;

 inherited;
end;

function TD2BridgeLangBaseClass.FormatSettings: TFormatSettings;
begin
 Result:= FFormatSettings;
end;

function TD2BridgeLangBaseClass.HTMLLangGeneric: string;
begin
 result:= Copy(FD2BridgeLang.HTMLLang,1,2);
end;

function TD2BridgeLangBaseClass.IsRTL: Boolean;
begin
 result:= false;
end;

procedure TD2BridgeLangBaseClass.LoadJSONfromResource;
var
  JSONResouceName: String;
  ResInfo:           {$IFNDEF FPC}HRSRC{$ELSE}TLResource{$ENDIF};
  ResStream:         {$IFNDEF FPC}TResourceStream{$ELSE}TLazarusResourceStream{$ENDIF};
  JSONContent:       TStringStream;
  sFile:             TStringStream;
  json_file_to_load: string;
begin
 try
  {$REGION 'Embed JSON (Resource)'}
   if FD2BridgeLangCoreBaseClass.EmbedJSON then
   begin
    try
     JSONResouceName:= FD2BridgeLangCoreBaseClass.ResourcePrefix + StringReplace(FD2BridgeLang.HTMLLang, '-', '_', [rfReplaceAll]);

{$IFNDEF FPC}
     ResInfo := FindResource(HInstance, PWideChar(JSONResouceName), RT_RCDATA);

     if ResInfo <> 0 then
{$ELSE}
     ResInfo:= LazarusResources.Find(JSONResouceName);

     if ResInfo <> nil then
{$ENDIF}
     begin
{$IFNDEF FPC}
      ResStream := TResourceStream.Create(HInstance, JSONResouceName, RT_RCDATA);
{$ELSE}
      ResStream := TLazarusResourceStream.Create(JSONResouceName, nil);
{$ENDIF}

      JSONContent := TStringStream.Create('', TEncoding.UTF8);

      try
       JSONContent.CopyFrom(ResStream, ResStream.Size);

       JSONContent.Position := 0;

       FJSONResourceLang := TJSONObject.ParseJSONValue(JSONContent.DataString) as TJSONObject;
      finally
       JSONContent.Free;
      end;
     end else
     begin
      { #todo -c'Lazarus Error' : Cannot use this code in Lazarus - need review }
      {$IFNDEF FPC}
      FJSONResourceLang:= TJSONObject.ParseJSONValue(FD2BridgeLangCoreBaseClass.JSONDefaultLang.Value) as TJSONObject;
      {$ENDIF}
     end;
    finally
     { #todo -c'Lazarus Error' : Cannot use this code in Lazarus - need review }
     {$IFNDEF FPC}
     ResStream.Free;
     {$ENDIF}
    end;
   end;
  {$ENDREGION}

  {$REGION 'Load JSON from File PATH'}
   if not FD2BridgeLangCoreBaseClass.EmbedJSON then
   begin
    json_file_to_load:=FD2BridgeLangCoreBaseClass.PathJSON + FD2BridgeLang.HTMLLang + '.json';
    if FileExists(json_file_to_load) then
    begin
     sFile:= TStringStream.Create('', TEncoding.UTF8);
     sFile.LoadFromFile(json_file_to_load);
     
     FJSONResourceLang := TJSONObject.ParseJSONValue(sFile.DataString) as TJSONObject;

     sFile.Clear;
     sFile.Free;
    end else
     FJSONResourceLang:= FD2BridgeLangCoreBaseClass.JSONDefaultLang;
   end;
  {$ENDREGION}
 except
  FJSONResourceLang := TJSONObject.Create;
 end;

end;

procedure TD2BridgeLangBaseClass.PopuleFieldTerms;
var
  Ctx: TRttiContext;
  Typ, TypContext: TRttiType;
{$IFDEF HAS_RTTI_FIELD}
  Field, FieldContext: TRttiField;
{$ENDIF}
  ReturnValue: TValue;
  vTranslateResult: string;
  D2BridgeTermObject: TObject;
begin
{$IFDEF HAS_RTTI_FIELD}
  try
    Ctx := TRttiContext.Create;

    try
      D2BridgeTermObject:= FD2BridgeTerm as TObject;
      Typ:= Ctx.GetType(D2BridgeTermObject.ClassType);

      for Field in Typ.GetDeclaredFields do
      begin
        if Field.Visibility = mvPublic then
        begin
         if Field.FieldType.TypeKind in [tkUString, tkWString, tkLString] then
         begin
          vTranslateResult:= FD2BridgeLang.Translate(Field.Name);
          if vTranslateResult = '' then
           vTranslateResult:= '{{_'+Field.Name+'_}}';

          Field.SetValue((FD2BridgeTerm as TObject), vTranslateResult);
         end else
         if Supports(Field.FieldType.AsInstance.MetaclassType, ID2BridgeTermItem) then
         begin
          ReturnValue:= Field.GetValue((FD2BridgeTerm as TObject));

          TypContext:= Ctx.GetType((ReturnValue.AsInterface as TObject).ClassType);

          for FieldContext in TypContext.GetDeclaredFields do
          begin
            if FieldContext.Visibility = mvPublic then
            begin
             if FieldContext.FieldType.TypeKind in [tkUString, tkWString, tkLString] then
             begin
              vTranslateResult:= FD2BridgeLang.Translate(Field.Name, FieldContext.Name);
              if vTranslateResult = '' then
               if Field.Name <> '' then
                vTranslateResult:= '{{_'+Field.Name+'.'+FieldContext.Name+'_}}'
               else
                vTranslateResult:= '{{_'+FieldContext.Name+'_}}';

              FieldContext.SetValue((ReturnValue.AsInterface as TObject), vTranslateResult);
             end;
            end;
          end;
         end;
        end;
      end;
    except

    end;
  except

  end;
{$ENDIF}
end;

procedure TD2BridgeLangBaseClass.ProcessJSONLang;
var
 I, J: integer;
 vKey: string;
 vTranslatedText: string;
 vContext: string;
 vJSONLangContext, vJSONResourceLang: TJSONObject;
begin
 for I := 0 to Pred(FJSONLang.Count) do
 begin
  if FJSONLang.GetJsonValue(I) is TJSONObject then //Context
  begin
   vContext:= FJSONLang.GetJsonStringValue(I);
   vJSONLangContext:= (FJSONLang.GetJsonValue(I) as TJSONObject);
   vJSONResourceLang:= (FJSONResourceLang.GetValue(vContext) as TJSONObject);
   if Assigned(vJSONResourceLang)  then
   for J := 0 to Pred(vJSONLangContext.Count) do
   begin
    vKey:= vJSONLangContext.GetJsonStringValue(J);
    vJSONLangContext.SetJsonValue(J, vJSONResourceLang.GetValue(vKey));
   end;
  end else
  begin
   vKey:= FJSONLang.GetJsonStringValue(I);
   FJSONLang.SetJsonValue(I, FJSONResourceLang.GetValue(vKey));
  end;
 end;

 if not DirectoryExists(FD2BridgeLangCoreBaseClass.PathExportJSON) then
{$IFDEF HAS_UNIT_SYSTEM_IOUTILS}
   TDirectory.CreateDirectory(FD2BridgeLangCoreBaseClass.PathExportJSON);
{$ELSE}
   CreateDir(FD2BridgeLangCoreBaseClass.PathExportJSON);
{$ENDIF}

 if DirectoryExists(FD2BridgeLangCoreBaseClass.PathExportJSON) then
{$IFDEF HAS_UNIT_SYSTEM_IOUTILS}
   TFile.WriteAllText(FD2BridgeLangCoreBaseClass.PathExportJSON+FD2BridgeLang.HTMLLang+'.json', FJSONLang.ToJSON, TEncoding.UTF8);
{$ELSE}
   WriteAllText(FD2BridgeLangCoreBaseClass.PathExportJSON+FD2BridgeLang.HTMLLang+'.json', FJSONLang.ToJSON, TEncoding.UTF8, True);
{$ENDIF}
end;

function TD2BridgeLangBaseClass.Translate(ATerm: string): string;
begin
 result:= Translate((FD2BridgeTerm as TD2BridgeTermBaseClass).Context, ATerm);
end;

function TD2BridgeLangBaseClass.Translate(AContext, ATerm: string): string;
var
 vFJSONResourceLangContext: TJSONObject;
 vJSONExistTerm: boolean;
begin
 Result:= '';

 FD2BridgeLang.DoTranslate(AContext, ATerm, Result);

 if Result = '' then
  FD2BridgeLang.DoTranslate(ATerm, Result);

 if Result = '' then
 begin
  vJSONExistTerm:= false;

  if AContext <> '' then
  begin
   vFJSONResourceLangContext:= FJSONResourceLang.GetValue(AContext) as TJSONObject;
   if Assigned(vFJSONResourceLangContext) then
    if Assigned(vFJSONResourceLangContext.GetValue(ATerm)) then
    begin
     vJSONExistTerm:= true;
     Result:= vFJSONResourceLangContext.GetValue(ATerm).Value;
    end;
  end else
   if FJSONResourceLang.GetValue(ATerm) <> nil then
    if Assigned(FJSONResourceLang.GetValue(ATerm)) then
    begin
     vJSONExistTerm:= true;
     Result:= FJSONResourceLang.GetValue(ATerm).Value;
    end;

  if not vJSONExistTerm then
   FD2BridgeLangCoreBaseClass.IncludeLogMissing(AContext, ATerm);
 end;


end;

end.
