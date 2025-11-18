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
  Thanks for contribution to this Unit to:
   João B. S. Junior
   Phone +55 69 99250-3445
   Email jr.playsoft@gmail.com
 +--------------------------------------------------------------------------+
}

{$I D2Bridge.inc}

unit D2Bridge.API.Storage.AmazonS3;

interface

{$IFNDEF FPC}
uses
  IdHTTP,
  IdSSLOpenSSL,
  StrUtils,
  Classes, SysUtils, System.UITypes, D2Bridge.JSON,
  Rest.Utils, System.Net.HttpClient, System.Net.HttpClientComponent,System.Net.URLClient,System.NetEncoding,
  D2Bridge.Interfaces,
  Prism.Interfaces,
  D2Bridge.API.Storage
  {$IFDEF FMX}

  {$ELSE}

  {$ENDIF}
  ;

type
  TD2BridgeAPIStorageAmazonS3 = class(TInterfacedPersistent, ID2BridgeAPIStorageAmazonS3)
   private

    FIdHTTP: TIdHTTP;
    FIdSSL: TIdSSLIOHandlerSocketOpenSSL;
    FDataStream: TStringStream;
    FResponseJSON,
    FKeyJSON: TJSONObject;

    FEvolutionAPI_Endpoint,
    FMessageJson:string;
    FCreateInstance:Boolean;
    FError:String;
    FResponseRUN: String;

    FAccountKey:String;
    FAccountName:String;
    FStorageEndPoint:string;
    FBucket:string;
    FFileStoragePath:String;
    FFileName: string;
    FContentType: string;
    FFileStream: TStream;
    FURL_File:string;



    function GetAccountKey: string;
    procedure SetAccountKey(const Value: string);
    function GetAccountName: string;
    procedure SetAccountName(const Value: string);
    function GetStorageEndPoint: string;
    procedure SetStorageEndPoint(const Value: string);
    function GetBucket: string;
    procedure SetBucket(const Value: string);
    function GetFileStoragePath: string;
    procedure SetFileStoragePath(const Value: string);
    function GetFileName: string;
    procedure SetFileName(const Value: string);
    function GetContentType: string;
    procedure SetContentType(const Value: string);
    function GetFileStream: TStream;
    procedure SetFileStream(const Value: TStream);
    function GetError: String;
    procedure SetError(const Value: string);
    function GetURL_File: String;
    procedure SetURL_File(const Value: string);


    function _GetContentType(const AFileName: string): string;
    function _FileToStream(const AFileName: string):TBytesStream;

    function UploadFile: boolean;

   public
    constructor Create;
    destructor Destroy; override;

    property AccountKey: string read GetAccountKey write SetAccountKey;
    property AccountName: string read GetAccountName write SetAccountName;
    property StorageEndPoint: string read GetStorageEndPoint write SetStorageEndPoint;
    property Bucket: string read GetBucket write SetBucket;

    property FileStoragePath: string read GetFileStoragePath write SetFileStoragePath;
    property FileName: string read GetFileName write SetFileName;
    property ContentType: string read GetContentType write SetContentType;
    property FileStream: TStream read GetFileStream write SetFileStream;
    property URL_File: string read GetURL_File write SetURL_File;
    property Error: string read GetError write SetError;
  end;

implementation

uses
  Data.Cloud.CloudAPI, Data.Cloud.AmazonAPI, D2Bridge.Instance;

{ TD2BridgeAPIStorageAmazonS3 }


constructor TD2BridgeAPIStorageAmazonS3.Create;
begin

end;


function TD2BridgeAPIStorageAmazonS3._GetContentType(const AFileName: string): string;
var
  FileExt: string;
begin
  FileExt := ExtractFileExt(FileName).ToLower;

  // Verifica a extensão e define o ContentType
  if FileExt = '.txt' then
    Result := 'text/plain'
  else if FileExt = '.html' then
    Result := 'text/html'
  else if FileExt = '.css' then
    Result := 'text/css'
  else if FileExt = '.csv' then
    Result := 'text/csv'
  else if FileExt = '.json' then
    Result := 'application/json'
  else if FileExt = '.xml' then
    Result := 'application/xml'
  else if (FileExt = '.jpg') or (FileExt = '.jpeg') then
    Result := 'image/jpeg'
  else if FileExt = '.png' then
    Result := 'image/png'
  else if FileExt = '.gif' then
    Result := 'image/gif'
  else if FileExt = '.svg' then
    Result := 'image/svg+xml'
  else if FileExt = '.webp' then
    Result := 'image/webp'
  else if FileExt = '.mp4' then
    Result := 'video/mp4'
  else if FileExt = '.webm' then
    Result := 'video/webm'
  else if FileExt = '.avi' then
    Result := 'video/x-msvideo'
  else if FileExt = '.mkv' then
    Result := 'video/x-matroska'
  else if FileExt = '.mp3' then
    Result := 'audio/mpeg'
  else if FileExt = '.wav' then
    Result := 'audio/wav'
  else if FileExt = '.ogg' then
    Result := 'audio/ogg'
  else if FileExt = '.pdf' then
    Result := 'application/pdf'
  else if FileExt = '.zip' then
    Result := 'application/zip'
  else if FileExt = '.tar' then
    Result := 'application/x-tar'
  else if (FileExt = '.xls') or (FileExt = '.xlsx') then
    Result := 'application/vnd.ms-excel'
  else if (FileExt = '.doc') or (FileExt = '.docx') then
    Result := 'application/msword'
  else if (FileExt = '.ppt') or (FileExt = '.pptx') then
    Result := 'application/vnd.ms-powerpoint'
  else if FileExt = '.otf' then
    Result := 'font/otf'
  else if FileExt = '.ttf' then
    Result := 'font/ttf'
  else if FileExt = '.woff' then
    Result := 'font/woff'
  else if FileExt = '.woff2' then
    Result := 'font/woff2'
  else
    // Default para tipos binários ou desconhecidos
    Result := 'application/octet-stream';
end;

function TD2BridgeAPIStorageAmazonS3._FileToStream(const AFileName: string):TBytesStream;
var
    lReader: TBinaryReader;
begin
    lReader:= TBinaryReader.create(AFileName);
    try
        Result:=TBytesStream.Create(lReader.ReadBytes(lReader.BaseStream.Size));
    finally
       lReader.Free;
    end;
end;

function TD2BridgeAPIStorageAmazonS3.UploadFile:boolean;
var

  Header : TStringList;
  AMCInfo: TAmazonConnectionInfo;
  Storage: TAmazonStorageService;
  Response : TCloudResponseInfo;
  vFileName:String;

begin
    if not FileExists(FFileName) then
    begin
          FError:='File not found. '+FFileName;
          Result:=false;
          exit;
    end;

  Try
    Header   := TStringList.Create;
    AMCInfo  := TAmazonConnectionInfo.Create(nil);
    Storage  := TAmazonStorageService.Create(AMCInfo);
    Response := TCloudResponseInfo.Create;

    if FFileStoragePath = '' then
    begin
       vFileName:=ExtractFileName(FFileName);
    end
    else
    begin
       vFileName:=StringReplace(FFileStoragePath+'/'+ExtractFileName(FFileName),'//','/',[rfReplaceAll]);
    end;

    try
      if FContentType <> '' then
      begin
         Header.Values['Content-Type'] := FContentType;
      end
      else
      begin
         Header.Values['Content-Type'] := _GetContentType(FFileName);
      end;

      AMCInfo.StorageEndpoint := FStorageEndPoint;
      AMCInfo.AccountName := FAccountName;
      AMCInfo.AccountKey := FAccountKey;
      AMCInfo.UseDefaultEndpoints := False;

      if Storage.
          UploadObject(
                       FBucket, vFileName,
                        _FileToStream(FFileName).Bytes,
                        False,
                        nil,
                        Header,
                        amzbaPublicReadWrite,
                        Response
      )then
      FURL_File:='https://' + FBucket + '.' + FStorageEndPoint + '/' + vFileName;//FFileName;

      FError:=Response.StatusCode.ToString+': '+Response.StatusMessage;
    finally
      Result:=true;
      Header.Free;
      Response.Free;
      Storage.Free;
      AMCInfo.Free;
    end;
  Except
    on E: Exception do
    begin
       Result := false;
       Error:='Error: ' + e.Message;
    end;
  End;
end;

destructor TD2BridgeAPIStorageAmazonS3.Destroy;
begin
 inherited;
end;

function TD2BridgeAPIStorageAmazonS3.GetAccountKey: string;
begin
  Result := FAccountKey;
end;

procedure TD2BridgeAPIStorageAmazonS3.SetAccountKey(const Value: string);
begin
  FAccountKey := Value;
end;

function TD2BridgeAPIStorageAmazonS3.GetAccountName: string;
begin
  Result := FAccountName;
end;

procedure TD2BridgeAPIStorageAmazonS3.SetAccountName(const Value: string);
begin
  FAccountName := Value;
end;

function TD2BridgeAPIStorageAmazonS3.GetStorageEndPoint: string;
begin
  Result := FStorageEndPoint;
end;

function TD2BridgeAPIStorageAmazonS3.GetURL_File: String;
begin
 Result:=FURL_File;
end;

procedure TD2BridgeAPIStorageAmazonS3.SetStorageEndPoint(const Value: string);
begin
  FStorageEndPoint := Value;
end;

procedure TD2BridgeAPIStorageAmazonS3.SetURL_File(const Value: string);
begin
 FURL_File:=Value;
end;

function TD2BridgeAPIStorageAmazonS3.GetBucket: string;
begin
  Result := FBucket;
end;

procedure TD2BridgeAPIStorageAmazonS3.SetBucket(const Value: string);
begin
  FBucket := Value;
end;

function TD2BridgeAPIStorageAmazonS3.GetFileName: string;
begin
  Result := FFileName;
end;

procedure TD2BridgeAPIStorageAmazonS3.SetFileName(const Value: string);
begin
  FFileName := Value;
end;

function TD2BridgeAPIStorageAmazonS3.GetContentType: string;
begin
  Result := FContentType;
end;

function TD2BridgeAPIStorageAmazonS3.GetError: String;
begin
 Result:=FError;
end;

procedure TD2BridgeAPIStorageAmazonS3.SetContentType(const Value: string);
begin
  FContentType := Value;
end;

procedure TD2BridgeAPIStorageAmazonS3.SetError(const Value: string);
begin
  FError:=Value;
end;

function TD2BridgeAPIStorageAmazonS3.GetFileStoragePath: string;
begin
  Result:=FFileStoragePath;
end;

function TD2BridgeAPIStorageAmazonS3.GetFileStream: TStream;
begin
  Result := FFileStream;
end;

procedure TD2BridgeAPIStorageAmazonS3.SetFileStoragePath(const Value: string);
begin
  FFileStoragePath:=Value;
end;

procedure TD2BridgeAPIStorageAmazonS3.SetFileStream(const Value: TStream);
begin
  FFileStream := Value;
end;
{$ELSE}
implementation
{$ENDIF}



end.

