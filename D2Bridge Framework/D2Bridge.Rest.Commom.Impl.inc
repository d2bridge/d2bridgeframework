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

{ TPrismHTTPResponseHelper }

procedure TPrismHTTPResponseHelper.JSON(ADataset: TDataSet);
begin
 JSON(ADataset, PrismBaseClass.Rest.Options.MaxRecord, 0);
end;

procedure TPrismHTTPResponseHelper.JSON(AStatusCode: Integer; AMessage: string);
begin
 StatusCode:= AStatusCode;
 JSON(AStatusCode);
 if AMessage <> '' then
  JSON.AddPair('message', AMessage);
end;

procedure TPrismHTTPResponseHelper.JSON(ADataset: TDataSet; AMaxRecords, AOffSet: Integer; AShowMetaData: Boolean);
var
 vDataSetJSON: TJSONObject;
 vPair: {$IFnDEF FPC}TJSONPair{$ELSE}TJSONEnum{$ENDIF};
begin
 vDataSetJSON:= ADataSet.ToJSON(AMaxRecords, AOffSet, AShowMetaData);

 for vPair in vDataSetJSON do
  JSON.AddPair(vPair.{$IFnDEF FPC}JsonString.Value{$ELSE}key{$ENDIF}, vPair.{$IFnDEF FPC}JsonValue{$ELSE}Value{$ENDIF}.Clone as TJSONValue);

 vDataSetJSON.Free;
end;

procedure TPrismHTTPResponseHelper.JSON(ADataset: TDataSet; AMaxRecords, AOffSet: Integer);
begin
 JSON.AddPair('data', ADataSet.ToJSON(AMaxRecords, AOffSet));
end;

procedure TPrismHTTPResponseHelper.JSON(ADataset: TDataSet;
  AShowMetaData: Boolean);
begin
  JSON(ADataset, PrismBaseClass.Rest.Options.MaxRecord, 0, AShowMetaData);
end;


procedure TPrismHTTPResponseHelper.RowToJSON(ADataset: TDataSet);
var
 vJSON: TJSONObject;
 vJSONArray: TJSONArray;
 vKey: String;
 I: integer;
begin
 if Assigned(ADataset) and (not ADataset.IsEmpty) then
 begin
  vJSONArray:= ADataset.TOJSON(1, ADataSet.RecNo);

  if Assigned(vJSONArray) then
  begin
   if vJSONArray.Count > 0 then
   begin
    vJSON:= vJSONArray.{$IFnDEF FPC}Get(0){$ELSE}Items[0]{$ENDIF} as TJSONObject;

    for I := 0 to vJSON.Count - 1 do
    begin
     vKey := vJSON.{$IFnDEF FPC}Pairs[I].JsonString.Value{$ELSE}Names[I]{$ENDIF};

     //if JSON.GetValue(vKey) <> nil then
     //  JSON.RemovePair(vKey).Free;

     {$IFnDEF FPC}
     JSON.AddPair(vKey,
                  vJSON.Pairs[I].JsonValue.Clone as TJSONValue);
     {$ELSE}
     JSON.AddPair(vKey, vJSON.Items[I].Clone);
     {$ENDIF}
    end;
   end;

   vJSONArray.Free;
  end;
 end;
end;


procedure TPrismHTTPResponseHelper.JSON(AStatusCode: Integer; AProperty, AValue: string);
begin
 JSON(AStatusCode);

 JSON.AddPair(AProperty, AValue);
end;

procedure TPrismHTTPResponseHelper.JSON(AStatusCode: Integer;
  AProperty: string; AValue: boolean);
begin
 JSON(AStatusCode);

 JSON.AddPair(AProperty, {$IFnDEF FPC}TJSONBool.Create(AValue){$ELSE}AValue{$ENDIF});
end;

procedure TPrismHTTPResponseHelper.JSONArray(ADataset: TDataSet;
  AMaxRecords, AOffSet: Integer);
begin
 IsJSONArray:= true;

 JSON.AddPair('jsonarray', ADataset.ToJSON(AMaxRecords, AOffSet));
end;

procedure TPrismHTTPResponseHelper.StatusSuccessAccepted(const AMessage: string);
begin
 StatusCode:= HTTPStatus.SuccessAccepted;
 StatusMessage:= AMessage;
end;

procedure TPrismHTTPResponseHelper.StatusErrorBadRequest(const AMessage: string = '');
begin
 StatusCode:= HTTPStatus.ErrorBadRequest;
 StatusMessage:= AMessage;
 JSON(StatusCode, StatusMessage);
end;

procedure TPrismHTTPResponseHelper.StatusErrorConflict(const AMessage: string = '');
begin
 StatusCode:= HTTPStatus.ErrorConflict;
 StatusMessage:= AMessage;
 JSON(StatusCode, StatusMessage);
end;

procedure TPrismHTTPResponseHelper.StatusSuccessCreated(const AMessage: string);
begin
 StatusCode:= HTTPStatus.SuccessCreated;
 StatusMessage:= AMessage;
end;

procedure TPrismHTTPResponseHelper.StatusErrorForbidden(const AMessage: string = '');
begin
 StatusCode:= HTTPStatus.ErrorForbidden;
 StatusMessage:= AMessage;
 JSON(StatusCode, StatusMessage);
end;

procedure TPrismHTTPResponseHelper.StatusErrorMethodNotAllowed(const AMessage: string = '');
begin
 StatusCode:= HTTPStatus.ErrorMethodNotAllowed;
 StatusMessage:= AMessage;
 JSON(StatusCode, StatusMessage);
end;

procedure TPrismHTTPResponseHelper.StatusSuccessNoContent;
begin
 StatusCode:= HTTPStatus.SuccessNoContent;
 StatusMessage:= '';
end;

procedure TPrismHTTPResponseHelper.StatusErrorNotFound(const AMessage: string = '');
begin
 StatusCode:= HTTPStatus.ErrorNotFound;
 StatusMessage:= AMessage;
 JSON(StatusCode, StatusMessage);
end;

procedure TPrismHTTPResponseHelper.StatusSuccessOK(const AMessage: string);
begin
 StatusCode:= HTTPStatus.SuccessOK;
 StatusMessage:= AMessage;
end;

procedure TPrismHTTPResponseHelper.StatusSuccessPartialContent;
begin
 StatusCode:= HTTPStatus.SuccessPartialContent;
 StatusMessage:= '';
end;

procedure TPrismHTTPResponseHelper.StatusErrorRequestTimeout(const AMessage: string = '');
begin
 StatusCode:= HTTPStatus.ErrorRequestTimeout;
 StatusMessage:= AMessage;
 JSON(StatusCode, StatusMessage);
end;

procedure TPrismHTTPResponseHelper.StatusSuccessResetContent;
begin
 StatusCode:= HTTPStatus.SuccessResetContent;
 StatusMessage:= '';
end;

procedure TPrismHTTPResponseHelper.StatusErrorTooManyRequests(const AMessage: string = '');
begin
 StatusCode:= HTTPStatus.ErrorTooManyRequests;
 StatusMessage:= AMessage;
 JSON(StatusCode, StatusMessage);
end;

procedure TPrismHTTPResponseHelper.StatusErrorUnauthorized(const AMessage: string = '');
begin
 StatusCode:= HTTPStatus.ErrorUnauthorized;
 StatusMessage:= AMessage;
 JSON(StatusCode, StatusMessage);
end;

procedure TPrismHTTPResponseHelper.StatusErrorUnprocessableEntity(const AMessage: string = '');
begin
 StatusCode:= HTTPStatus.ErrorUnprocessableEntity;
 StatusMessage:= AMessage;
 JSON(StatusCode, StatusMessage);
end;

procedure TPrismHTTPResponseHelper.JSONArray(ADataset: TDataSet);
begin
 IsJSONArray:= true;

 JSON.AddPair('jsonarray', ADataset.ToJSON);
end;

procedure TPrismHTTPResponseHelper.JSON(AStatusCode: Integer; AProperty: string; AValue: Extended);
begin
 JSON(AStatusCode);

 JSON.AddPair(AProperty, {$IFnDEF FPC}TJSONNumber.Create(AValue){$ELSE}AValue{$ENDIF});
end;

procedure TPrismHTTPResponseHelper.JSON(AStatusCode: Integer; AProperty: string; AValue: Integer);
begin
 JSON(AStatusCode);

 JSON.AddPair(AProperty, {$IFnDEF FPC}TJSONNumber.Create(AValue){$ELSE}AValue{$ENDIF});
end;

procedure TPrismHTTPResponseHelper.JSONArray(AJSONArray: TJSONArray);
begin
 IsJSONArray:= true;

 JSON.AddPair('jsonarray', AJSONArray);
end;


procedure TPrismHTTPResponseHelper.JSON(AStatusCode: Integer;
  AProperty: string; AValue: TJSONValue);
begin
 JSON(AStatusCode);

 if Assigned(AValue) then
 begin
  JSON.AddPair(AProperty, AValue);

  IsJSONArray:= (AValue is TJSONArray);
 end;
end;

procedure TPrismHTTPResponseHelper.JSON(AStatusCode: Integer; ADataset: TDataSet);
begin
 StatusCode:= AStatusCode;
 JSON(AStatusCode);
 JSON(ADataset);
end;

procedure TPrismHTTPResponseHelper.JSON(AStatusCode: Integer; ADataset: TDataSet; AShowMetaData: Boolean);
begin
 StatusCode:= AStatusCode;
 JSON(AStatusCode);
 JSON(ADataset, AShowMetaData);
end;

procedure TPrismHTTPResponseHelper.JSON(AStatusCode: Integer; ADataset: TDataSet; AMaxRecords, AOffSet: Integer);
begin
 StatusCode:= AStatusCode;
 JSON(AStatusCode);
 JSON(ADataset, AMaxRecords, AOffSet);
end;

procedure TPrismHTTPResponseHelper.JSON(AStatusCode: Integer; ADataset: TDataSet; AMaxRecords, AOffSet: Integer;
  AShowMetaData: Boolean);
begin
 StatusCode:= AStatusCode;
 JSON(AStatusCode);
 JSON(ADataset, AMaxRecords, AOffSet, AShowMetaData);
end;

procedure TPrismHTTPResponseHelper.JSON(AStatusCode: Integer);
begin
 StatusCode := AStatusCode;
 JSON.AddPair('status', {$IFnDEF FPC}TJSONNumber.Create(AStatusCode){$ELSE}AStatusCode{$ENDIF});
 JSON.AddPair('success', {$IFnDEF FPC}TJSONBool.Create(AStatusCode in [200..226]){$ELSE}(AStatusCode in [200..226]){$ENDIF});
end;



{ TPrismHTTPRequestHelper }

function TPrismHTTPRequestHelper.BodyRawToFile(AFileName: string): boolean;
var
 vBodyContent: TBytes;
 vArrayLines: TArray<string>;
 I: Integer;
 vContentLength: integer;
 vFileStream: TFileStream;
begin
 result:= false;

 if TryStrToInt(ContentLength, vContentLength) then
 begin
  if vContentLength > 0 then
  begin
   if FileExists(AFileName) then
    DeleteFile(AFileName);

   vFileStream:= TFileStream.Create(AFileName, fmCreate);

   IOHandler.ReadBytes(TIDBytes(vBodyContent), vContentLength);

   vFileStream.WriteBuffer(vBodyContent[0], vContentLength);
   vFileStream.Position := 0;
   vFileStream.Free;
  end;
 end;

end;

