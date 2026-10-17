unit Unit_GetEP;

{ D2Bridge screen that only displays data from an external Horse or D2Bridge or Others API.
  This unit does not register D2Bridge REST routes.

  Expected End point contract (change BaseURL if your paths differ):}

  //  POST   http://localhost:8888/api/auth/login   Basic UserD2Bridge:123456 -> accessToken
  //  GET    http://localhost:8888/api/products
  //  POST   http://localhost:8888/api/products          {"name":"Keyboard","price":150}
  //  PUT    http://localhost:8888/api/products/{id}     {"id":1,"name":"Notebook","price":4200}
  //  DELETE http://localhost:8888/api/products/{id}
  {
  Login fills EditToken. Load, Insert, Update and Delete send Authorization: Bearer.
  GET may return a JSON array, or an object with "items" or "data".
  Each row uses id, name and price. nome and preco are also accepted.
}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids,
  Data.DB, Datasnap.DBClient, D2Bridge.Forms;

type
  TForm_GetEP = class(TD2BridgeForm)
    LabelTitle: TLabel;
    LabelUrl: TLabel;
    LabelStatus: TLabel;
    EditId: TEdit;
    EditName: TEdit;
    EditPrice: TEdit;
    LabelId: TLabel;
    LabelName: TLabel;
    LabelPrice: TLabel;
    LabelUser: TLabel;
    LabelPassword: TLabel;
    LabelToken: TLabel;
    EditUser: TEdit;
    EditPassword: TEdit;
    EditToken: TEdit;
    ButtonGetToken: TButton;
    ButtonLoad: TButton;
    ButtonInsert: TButton;
    ButtonUpdate: TButton;
    ButtonDelete: TButton;
    DBGrid1: TDBGrid;
    CDSProducts: TClientDataSet;
    DSProducts: TDataSource;
    CDSProductsId: TIntegerField;
    CDSProductsName: TStringField;
    CDSProductsPrice: TFloatField;
    procedure ButtonGetTokenClick(Sender: TObject);
    procedure ButtonLoadClick(Sender: TObject);
    procedure ButtonInsertClick(Sender: TObject);
    procedure ButtonUpdateClick(Sender: TObject);
    procedure ButtonDeleteClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure FormCreate(Sender: TObject);
  private
    function EpUrl(const AId: string = ''): string;
    function CallEp(const AMethod, AUrl, ABody: string; ABasicAuth: Boolean = False): string;
    procedure FillGrid(const ABody: string);
    procedure ShowEpError(const AMessage: string);
    function SelectedId: string;
    function PriceJson: string;
    procedure ReloadFromEp;
  protected
    procedure ExportD2Bridge; override;
  end;

function Form_GetEP: TForm_GetEP;

implementation

uses
  System.JSON, System.Net.HttpClient, System.NetEncoding;

const
  BaseURL = 'http://localhost:8888';

function Form_GetEP: TForm_GetEP;
begin
  Result := TForm_GetEP(TForm_GetEP.GetInstance);
end;

{$R *.dfm}

procedure TForm_GetEP.FormCreate(Sender: TObject);
begin
  CDSProducts.Close;
  CDSProducts.FieldDefs.Clear;
  CDSProducts.FieldDefs.Add('Id', ftInteger);
  CDSProducts.FieldDefs.Add('Name', ftString, 80);
  CDSProducts.FieldDefs.Add('Price', ftFloat);
  CDSProducts.CreateDataSet;
end;

function TForm_GetEP.PriceJson: string;
begin
  Result := StringReplace(Trim(EditPrice.Text), ',', '.', [rfReplaceAll]);
  if Result = '' then
    Result := '0';
end;

procedure TForm_GetEP.ReloadFromEp;
begin
  FillGrid(CallEp('GET', EpUrl, ''));
end;

function TForm_GetEP.EpUrl(const AId: string): string;
begin
  Result := BaseURL + '/api/products';
  if AId <> '' then
    Result := Result + '/' + AId;
end;

function TForm_GetEP.CallEp(const AMethod, AUrl, ABody: string; ABasicAuth: Boolean): string;
var
  LClient: THTTPClient;
  LResponse: IHTTPResponse;
  LStream: TStringStream;
  LBasic: string;
begin
  LClient := THTTPClient.Create;
  LStream := TStringStream.Create(ABody, TEncoding.UTF8);
  try
    LClient.ConnectionTimeout := 5000;
    LClient.ResponseTimeout := 5000;
    LClient.ContentType := 'application/json';
    if ABasicAuth then
    begin
      LBasic := TNetEncoding.Base64.Encode(Trim(EditUser.Text) + ':' + EditPassword.Text);
      LBasic := StringReplace(LBasic, #13, '', [rfReplaceAll]);
      LBasic := StringReplace(LBasic, #10, '', [rfReplaceAll]);
      LClient.CustomHeaders['Authorization'] := 'Basic ' + LBasic;
    end
    else if Trim(EditToken.Text) <> '' then
      LClient.CustomHeaders['Authorization'] := 'Bearer ' + Trim(EditToken.Text)
    else
      raise Exception.Create('Access token is empty. Click Get token first.');

    if SameText(AMethod, 'GET') then
      LResponse := LClient.Get(AUrl)
    else if SameText(AMethod, 'POST') then
      LResponse := LClient.Post(AUrl, LStream)
    else if SameText(AMethod, 'PUT') then
      LResponse := LClient.Put(AUrl, LStream)
    else
      LResponse := LClient.Delete(AUrl);

    Result := LResponse.ContentAsString(TEncoding.UTF8);
    if LResponse.StatusCode >= 400 then
      raise Exception.CreateFmt('Endpoint responded %d. %s', [LResponse.StatusCode, Result]);
  finally
    LStream.Free;
    LClient.Free;
  end;
end;

procedure TForm_GetEP.ShowEpError(const AMessage: string);
begin
  LabelStatus.Caption := AMessage;
  ShowMessage(AMessage, True, 5000, mtError);
end;

function JsonText(AObj: TJSONObject; const ANames: array of string): string;
var
  LValue: TJSONValue;
  LName: string;
begin
  Result := '';
  for LName in ANames do
  begin
    LValue := AObj.GetValue(LName);
    if LValue <> nil then
      Exit(LValue.Value);
  end;
end;

procedure TForm_GetEP.FillGrid(const ABody: string);
var
  LRoot: TJSONValue;
  LArray: TJSONArray;
  LRow: TJSONObject;
  I: Integer;
  LPrice: string;
begin
  CDSProducts.DisableControls;
  try
    CDSProducts.EmptyDataSet;
    LRoot := TJSONObject.ParseJSONValue(ABody);
    if LRoot = nil then
      raise Exception.Create('The endpoint response is not JSON.');
    try
      LArray := nil;
      if LRoot is TJSONArray then
        LArray := TJSONArray(LRoot)
      else if LRoot is TJSONObject then
      begin
        if TJSONObject(LRoot).GetValue('items') is TJSONArray then
          LArray := TJSONArray(TJSONObject(LRoot).GetValue('items'))
        else if TJSONObject(LRoot).GetValue('data') is TJSONArray then
          LArray := TJSONArray(TJSONObject(LRoot).GetValue('data'));
      end;
      if LArray = nil then
        raise Exception.Create('The endpoint JSON has no product list.');

      for I := 0 to LArray.Count - 1 do
      begin
        if not (LArray.Items[I] is TJSONObject) then
          Continue;
        LRow := TJSONObject(LArray.Items[I]);
        LPrice := StringReplace(JsonText(LRow, ['price', 'preco']), ',', '.', []);
        CDSProducts.Append;
        CDSProductsId.AsInteger := StrToIntDef(JsonText(LRow, ['id']), 0);
        CDSProductsName.AsString := JsonText(LRow, ['name', 'nome']);
        CDSProductsPrice.AsFloat := StrToFloatDef(LPrice, 0, TFormatSettings.Invariant);
        CDSProducts.Post;
      end;
    finally
      LRoot.Free;
    end;
  finally
    CDSProducts.EnableControls;
  end;
  LabelStatus.Caption := Format('%d product(s) received from the endpoint.', [CDSProducts.RecordCount]);
end;

procedure TForm_GetEP.ButtonGetTokenClick(Sender: TObject);
var
  LJson: TJSONValue;
  LToken: TJSONValue;
begin
  try
    LJson := TJSONObject.ParseJSONValue(CallEp('POST', BaseURL + '/api/auth/login', '', True));
    if LJson = nil then
      raise Exception.Create('Login response is not JSON.');
    try
      LToken := nil;
      if LJson is TJSONObject then
        LToken := TJSONObject(LJson).GetValue('accessToken');
      if LToken = nil then
        raise Exception.Create('Login response has no accessToken.');
      EditToken.Text := LToken.Value;
    finally
      LJson.Free;
    end;
    LabelStatus.Caption := 'Access token received.';
    ShowMessage('Access token received.', True, 3000, mtInformation);
  except
    on E: Exception do
      ShowEpError('Could not get the access token. ' + E.Message);
  end;
end;

procedure TForm_GetEP.ButtonLoadClick(Sender: TObject);
begin
  try
    ReloadFromEp;
  except
    on E: Exception do
      ShowEpError('Could not load the endpoint at ' + EpUrl + '. ' + E.Message);
  end;
end;

function TForm_GetEP.SelectedId: string;
begin
  Result := Trim(EditId.Text);
  if (Result = '') and (not CDSProducts.IsEmpty) then
    Result := CDSProductsId.AsString;
end;

procedure TForm_GetEP.ButtonInsertClick(Sender: TObject);
var
  LBody: string;
begin
  if Trim(EditName.Text) = '' then
  begin
    ShowEpError('Enter the name.');
    Exit;
  end;
  LBody := Format('{"name":"%s","price":%s}',
    [StringReplace(Trim(EditName.Text), '"', '', [rfReplaceAll]),
     PriceJson]);
  try
    CallEp('POST', EpUrl, LBody);
    ReloadFromEp;
    ShowMessage('Product sent to the endpoint.', True, 3000, mtInformation);
  except
    on E: Exception do
      ShowEpError('Could not insert on the endpoint. ' + E.Message);
  end;
end;

procedure TForm_GetEP.ButtonUpdateClick(Sender: TObject);
var
  LId, LBody: string;
begin
  LId := SelectedId;
  if LId = '' then
  begin
    ShowEpError('Select a product in the grid.');
    Exit;
  end;
  LBody := Format('{"id":%s,"name":"%s","price":%s}',
    [LId,
     StringReplace(Trim(EditName.Text), '"', '', [rfReplaceAll]),
     PriceJson]);
  try
    CallEp('PUT', EpUrl(LId), LBody);
    ReloadFromEp;
    ShowMessage('Product updated on the endpoint.', True, 3000, mtInformation);
  except
    on E: Exception do
      ShowEpError('Could not update the endpoint. ' + E.Message);
  end;
end;

procedure TForm_GetEP.ButtonDeleteClick(Sender: TObject);
var
  LId: string;
begin
  LId := SelectedId;
  if LId = '' then
  begin
    ShowEpError('Select a product in the grid.');
    Exit;
  end;
  try
    CallEp('DELETE', EpUrl(LId), '');
    ReloadFromEp;
    ShowMessage('Product deleted on the endpoint.', True, 3000, mtInformation);
  except
    on E: Exception do
      ShowEpError('Could not delete on the endpoint. ' + E.Message);
  end;
end;

procedure TForm_GetEP.DBGrid1CellClick(Column: TColumn);
begin
  if CDSProducts.IsEmpty then
    Exit;
  EditId.Text := CDSProductsId.AsString;
  EditName.Text := CDSProductsName.AsString;
  EditPrice.Text := CDSProductsPrice.AsString;
end;

procedure TForm_GetEP.ExportD2Bridge;
begin
  inherited;
  Title := 'Endpoint data';
  D2Bridge.FrameworkExportType.TemplateMasterHTMLFile := '';
  D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

  with D2Bridge.Items.Add do
  begin
    VCLObj(LabelTitle);
    VCLObj(LabelUrl);
    VCLObj(LabelStatus);
    VCLObj(LabelUser);
    VCLObj(EditUser);
    VCLObj(LabelPassword);
    VCLObj(EditPassword);
    VCLObj(ButtonGetToken);
    VCLObj(LabelToken);
    VCLObj(EditToken);
    VCLObj(LabelId);
    VCLObj(EditId);
    VCLObj(LabelName);
    VCLObj(EditName);
    VCLObj(LabelPrice);
    VCLObj(EditPrice);
    VCLObj(ButtonLoad);
    VCLObj(ButtonInsert);
    VCLObj(ButtonUpdate);
    VCLObj(ButtonDelete);
    VCLObj(DBGrid1);
  end;
end;

end.
