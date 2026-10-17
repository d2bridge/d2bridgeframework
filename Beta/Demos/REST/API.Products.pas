unit API.Products;

{ Copyright 2026 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Classes, SysUtils, JSON, System.SyncObjs, System.Generics.Collections,
  Prism.Types,
  D2Bridge.JSON,
  D2Bridge.Rest.Server.Functions;

implementation

type
  TProduct = record
    Id: Integer;
    Name: string;
    Price: Double;
  end;

var
  FLock: TCriticalSection;
  FProducts: TList<TProduct>;
  FNextId: Integer;

procedure SeedProducts;
var
  vItem: TProduct;
begin
  vItem.Id := 1;
  vItem.Name := 'Notebook';
  vItem.Price := 3500;
  FProducts.Add(vItem);

  vItem.Id := 2;
  vItem.Name := 'Mouse';
  vItem.Price := 80;
  FProducts.Add(vItem);

  vItem.Id := 3;
  vItem.Name := 'Headset';
  vItem.Price := 220;
  FProducts.Add(vItem);

  FNextId := 4;
end;

function FindProduct(AId: Integer; out AIndex: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
  AIndex := -1;
  for I := 0 to FProducts.Count - 1 do
    if FProducts[I].Id = AId then
    begin
      AIndex := I;
      Exit(True);
    end;
end;

function JsonText(AObj: TJSONObject; const AName, ADefault: string): string;
var
  vValue: TJSONValue;
begin
  Result := ADefault;
  if AObj = nil then
    Exit;
  vValue := AObj.GetValue(AName);
  if vValue <> nil then
    Result := vValue.Value;
end;

function JsonFloat(AObj: TJSONObject; const AName: string; ADefault: Double): Double;
var
  vValue: TJSONValue;
begin
  Result := ADefault;
  if AObj = nil then
    Exit;
  vValue := AObj.GetValue(AName);
  if vValue <> nil then
    Result := StrToFloatDef(StringReplace(vValue.Value, ',', '.', []), ADefault, TFormatSettings.Invariant);
end;

function ProductJSON(const AItem: TProduct): TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('id', TJSONNumber.Create(AItem.Id));
  Result.AddPair('name', AItem.Name);
  Result.AddPair('price', TJSONNumber.Create(AItem.Price));
end;

procedure AddMetadata(Response: TPrismHTTPResponse; ACount: Integer);
var
  vMeta: TJSONObject;
begin
  if not RestOptions.ShowMetadata then
    Exit;
  vMeta := TJSONObject.Create;
  vMeta.AddPair('count', TJSONNumber.Create(ACount));
  vMeta.AddPair('maxRecord', TJSONNumber.Create(RestOptions.MaxRecord));
  Response.JSON.AddPair('metadata', vMeta);
end;

procedure GetProductList(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest; Response: TPrismHTTPResponse);
var
  vName, vLimitText: string;
  vLimit, vAdded, I: Integer;
  vItems: TJSONArray;
  vItem: TProduct;
begin
  vName := LowerCase(Request.Query('name'));
  vLimitText := Request.Query('limit');
  vLimit := RestOptions.MaxRecord;
  if vLimitText <> '' then
    vLimit := StrToIntDef(vLimitText, vLimit);
  if vLimit < 1 then
    vLimit := 1;
  if (RestOptions.MaxRecord > 0) and (vLimit > RestOptions.MaxRecord) then
    vLimit := RestOptions.MaxRecord;

  vItems := TJSONArray.Create;
  vAdded := 0;
  FLock.Enter;
  try
    for I := 0 to FProducts.Count - 1 do
    begin
      if vAdded >= vLimit then
        Break;
      vItem := FProducts[I];
      if (vName <> '') and (Pos(vName, LowerCase(vItem.Name)) = 0) then
        Continue;
      vItems.AddElement(ProductJSON(vItem));
      Inc(vAdded);
    end;
  finally
    FLock.Leave;
  end;

  Response.StatusCode := HTTPStatus.SuccessOK;
  Response.JSON.AddPair('items', vItems);
  AddMetadata(Response, vAdded);
end;

procedure GetProduct(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest; Response: TPrismHTTPResponse);
var
  vId, vIndex: Integer;
  vItem: TProduct;
begin
  vId := Request.ParamInt('id');
  FLock.Enter;
  try
    if not FindProduct(vId, vIndex) then
    begin
      Response.StatusCode := HTTPStatus.ErrorNotFound;
      Response.JSON.AddPair('error', 'Product not found');
      Exit;
    end;
    vItem := FProducts[vIndex];
  finally
    FLock.Leave;
  end;

  Response.StatusCode := HTTPStatus.SuccessOK;
  Response.JSON.AddPair('item', ProductJSON(vItem));
end;

procedure PostProduct(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest; Response: TPrismHTTPResponse);
var
  vItem: TProduct;
begin
  if not Request.BodyIsJSONValue then
  begin
    Response.StatusCode := HTTPStatus.ErrorBadRequest;
    Response.JSON.AddPair('error', 'Invalid JSON body');
    Exit;
  end;

  vItem.Name := Trim(JsonText(Request.BodyJSON, 'name', ''));
  vItem.Price := JsonFloat(Request.BodyJSON, 'price', 0);
  if vItem.Name = '' then
  begin
    Response.StatusCode := HTTPStatus.ErrorBadRequest;
    Response.JSON.AddPair('error', 'Field name is required');
    Exit;
  end;

  FLock.Enter;
  try
    vItem.Id := FNextId;
    Inc(FNextId);
    FProducts.Add(vItem);
  finally
    FLock.Leave;
  end;

  Response.StatusCode := HTTPStatus.SuccessCreated;
  Response.JSON.AddPair('item', ProductJSON(vItem));
end;

procedure PutProduct(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest; Response: TPrismHTTPResponse);
var
  vId, vIndex, vBodyId: Integer;
  vItem: TProduct;
begin
  vId := Request.ParamInt('id');
  if not Request.BodyIsJSONValue then
  begin
    Response.StatusCode := HTTPStatus.ErrorBadRequest;
    Response.JSON.AddPair('error', 'Invalid JSON body');
    Exit;
  end;

  vBodyId := StrToIntDef(JsonText(Request.BodyJSON, 'id', '0'), 0);
  if (vBodyId <> 0) and (vBodyId <> vId) then
  begin
    Response.StatusCode := HTTPStatus.ErrorBadRequest;
    Response.JSON.AddPair('error', 'Id mismatch');
    Exit;
  end;

  FLock.Enter;
  try
    if not FindProduct(vId, vIndex) then
    begin
      Response.StatusCode := HTTPStatus.ErrorNotFound;
      Response.JSON.AddPair('error', 'Product not found');
      Exit;
    end;
    vItem := FProducts[vIndex];
    if Trim(JsonText(Request.BodyJSON, 'name', '')) <> '' then
      vItem.Name := Trim(JsonText(Request.BodyJSON, 'name', vItem.Name));
    if Request.BodyJSON.GetValue('price') <> nil then
      vItem.Price := JsonFloat(Request.BodyJSON, 'price', vItem.Price);
    FProducts[vIndex] := vItem;
  finally
    FLock.Leave;
  end;

  Response.StatusCode := HTTPStatus.SuccessOK;
  Response.JSON.AddPair('item', ProductJSON(vItem));
end;

procedure DeleteProduct(const RestSession: TD2BridgeRestSession; Request: TPrismHTTPRequest; Response: TPrismHTTPResponse);
var
  vId, vIndex: Integer;
begin
  vId := Request.ParamInt('id');
  FLock.Enter;
  try
    if not FindProduct(vId, vIndex) then
    begin
      Response.StatusCode := HTTPStatus.ErrorNotFound;
      Response.JSON.AddPair('error', 'Product not found');
      Exit;
    end;
    FProducts.Delete(vIndex);
  finally
    FLock.Leave;
  end;

  Response.StatusCode := HTTPStatus.SuccessOK;
  Response.JSON.AddPair('deletedId', TJSONNumber.Create(vId));
end;

{
  Firebird example. This block is not compiled.
  The running demo keeps products in memory so it does not need a database.

  Table:

    CREATE TABLE PRODUCT (
      ID INTEGER NOT NULL PRIMARY KEY,
      NAME VARCHAR(80) NOT NULL,
      PRICE NUMERIC(15,2) NOT NULL
    );

  Point a FireDAC connection at the database (TFDConnection + TFDPhysFBDriverLink)
  and use it from the route, for example on RestSession.DM.FDConnection.

  GET /api/products

    Q := TFDQuery.Create(nil);
    try
      Q.Connection := RestSession.DM.FDConnection;
      Q.SQL.Text := 'select ID, NAME, PRICE from PRODUCT order by ID';
      Q.Open;
      Response.JSON.AddPair('items', Q.ToJSON(RestOptions.MaxRecord, 0, RestOptions.ShowMetadata));
    finally
      Q.Free;
    end;

  GET /api/products/:id

    Q.SQL.Text := 'select ID, NAME, PRICE from PRODUCT where ID = :ID';
    Q.ParamByName('ID').AsInteger := Request.ParamInt('id');
    Q.Open;
    if Q.IsEmpty then
      Response.StatusCode := HTTPStatus.ErrorNotFound
    else
      Response.JSON.AddPair('item', Q.ToJSON(1));

  POST /api/products

    Q.SQL.Text :=
      'insert into PRODUCT (ID, NAME, PRICE) values (:ID, :NAME, :PRICE) returning ID';
    Q.ParamByName('NAME').AsString := Request.BodyJSON.GetValue('name').Value;
    Q.ParamByName('PRICE').AsFloat := StrToFloat(Request.BodyJSON.GetValue('price').Value);
    Q.ExecSQL;

  FieldNameLowerCase and FormatSettings, set in the console unit, apply when a
  dataset is serialized with ToJSON. The in-memory sample writes lowercase keys itself.
}

initialization
  FLock := TCriticalSection.Create;
  FProducts := TList<TProduct>.Create;
  SeedProducts;

  AddGet('/api/products', GetProductList, True);
  AddGet('/api/products/:id', GetProduct, True);
  AddPost('/api/products', PostProduct, True);
  AddPut('/api/products/:id', PutProduct, True);
  AddDelete('/api/products/:id', DeleteProduct, True);

finalization
  FreeAndNil(FProducts);
  FreeAndNil(FLock);

end.
