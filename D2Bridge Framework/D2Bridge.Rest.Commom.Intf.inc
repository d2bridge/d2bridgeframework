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


type
 HTTPStatus = Prism.Server.HTTP.Commom.StatusCode.THTTPStatus;


type
 TPrismHTTPResponseHelper = class helper for TPrismHTTPResponse
  public
   procedure JSON(ADataset: TDataSet); overload;
   procedure JSON(ADataset: TDataSet; AShowMetaData: Boolean); overload;
   procedure JSON(ADataset: TDataSet; AMaxRecords: Integer; AOffSet: Integer = 0); overload;
   procedure JSON(ADataset: TDataSet; AMaxRecords: Integer; AOffSet: Integer; AShowMetaData: Boolean); overload;

   procedure RowToJSON(ADataset: TDataSet);

   procedure JSON(AStatusCode: Integer; ADataset: TDataSet); overload;
   procedure JSON(AStatusCode: Integer; ADataset: TDataSet; AShowMetaData: Boolean); overload;
   procedure JSON(AStatusCode: Integer; ADataset: TDataSet; AMaxRecords: Integer; AOffSet: Integer = 0); overload;
   procedure JSON(AStatusCode: Integer; ADataset: TDataSet; AMaxRecords: Integer; AOffSet: Integer; AShowMetaData: Boolean); overload;

   procedure JSONArray(AJSONArray: TJSONArray); overload;
   procedure JSONArray(ADataset: TDataSet); overload;
   procedure JSONArray(ADataset: TDataSet; AMaxRecords: Integer; AOffSet: Integer = 0); overload;

   procedure JSON(AStatusCode: Integer); overload;
   procedure JSON(AStatusCode: Integer; AMessage: string); overload;
   procedure JSON(AStatusCode: Integer; AProperty: string; AValue: string); overload;
   procedure JSON(AStatusCode: Integer; AProperty: string; AValue: Integer); overload;
   procedure JSON(AStatusCode: Integer; AProperty: string; AValue: Extended); overload;
   procedure JSON(AStatusCode: Integer; AProperty: string; AValue: boolean); overload;
   procedure JSON(AStatusCode: Integer; AProperty: string; AValue: TJSONValue); overload;


   // === 2xx: Sucesso ===
   procedure StatusSuccessOK(const AMessage: string = ''); overload;                       // 200
   procedure StatusSuccessCreated(const AMessage: string = ''); overload;                 // 201
   procedure StatusSuccessAccepted(const AMessage: string = ''); overload;                // 202
   procedure StatusSuccessNoContent; overload;                                            // 204
   procedure StatusSuccessResetContent; overload;                                         // 205
   procedure StatusSuccessPartialContent; overload; // 206

   // === 4xx: Erros do cliente ===
   procedure StatusErrorBadRequest(const AMessage: string = ''); overload;                   // 400
   procedure StatusErrorUnauthorized(const AMessage: string = ''); overload;                 // 401
   procedure StatusErrorForbidden(const AMessage: string = ''); overload;                    // 403
   procedure StatusErrorNotFound(const AMessage: string = ''); overload;                     // 404
   procedure StatusErrorMethodNotAllowed(const AMessage: string = ''); overload;            // 405
   procedure StatusErrorRequestTimeout(const AMessage: string = ''); overload;              // 408
   procedure StatusErrorConflict(const AMessage: string = ''); overload;                    // 409
   procedure StatusErrorUnprocessableEntity(const AMessage: string = ''); overload;         // 422
   procedure StatusErrorTooManyRequests(const AMessage: string = ''); overload;             // 429
 end;



type
 TPrismHTTPRequestHelper = class helper for TPrismHTTPRequest
  public
   function BodyRawToFile(AFileName: string): boolean;
 end;
