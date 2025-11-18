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

{$I ..\D2Bridge.inc}

unit Prism.Server.HTTP.Commom.StatusCode;

interface


type
  THTTPStatus = record
  public
    // 1xx Informational
//    const Continue_ = 100;
//    const SwitchingProtocols = 101;
//    const Processing = 102;
//    const EarlyHints = 103;

    // 2xx Success
    const SuccessOK = 200;
    const SuccessCreated = 201;
    const SuccessAccepted = 202;
    const SuccessNonAuthoritativeInformation = 203;
    const SuccessNoContent = 204;
    const SuccessResetContent = 205;
    const SuccessPartialContent = 206;
    const SuccessMultiStatus = 207;
    const SuccessAlreadyReported = 208;
    const SuccessIMUsed = 226;

    // 3xx Redirection
//    const MultipleChoices = 300;
//    const MovedPermanently = 301;
//    const Found = 302;
//    const SeeOther = 303;
//    const NotModified = 304;
//    const UseProxy = 305;
//    const SwitchProxy = 306; // Unused
//    const TemporaryRedirect = 307;
//    const PermanentRedirect = 308;

    // 4xx Client Error
    const ErrorBadRequest = 400;
    const ErrorUnauthorized = 401;
    const ErrorPaymentRequired = 402;
    const ErrorForbidden = 403;
    const ErrorNotFound = 404;
    const ErrorMethodNotAllowed = 405;
    const ErrorNotAcceptable = 406;
    const ErrorProxyAuthenticationRequired = 407;
    const ErrorRequestTimeout = 408;
    const ErrorConflict = 409;
    const ErrorGone = 410;
    const ErrorLengthRequired = 411;
    const ErrorPreconditionFailed = 412;
    const ErrorPayloadTooLarge = 413;
    const ErrorURITooLong = 414;
    const ErrorUnsupportedMediaType = 415;
    const ErrorRangeNotSatisfiable = 416;
    const ErrorExpectationFailed = 417;
    const ErrorImATeapot = 418;
    const ErrorMisdirectedRequest = 421;
    const ErrorUnprocessableEntity = 422;
    const ErrorLocked = 423;
    const ErrorFailedDependency = 424;
    const ErrorTooEarly = 425;
    const ErrorUpgradeRequired = 426;
    const ErrorPreconditionRequired = 428;
    const ErrorTooManyRequests = 429;
    const ErrorRequestHeaderFieldsTooLarge = 431;
    const ErrorUnavailableForLegalReasons = 451;

    // 5xx Server Error
//    const InternalServerError = 500;
//    const NotImplemented = 501;
//    const BadGateway = 502;
//    const ServiceUnavailable = 503;
//    const GatewayTimeout = 504;
//    const HTTPVersionNotSupported = 505;
//    const VariantAlsoNegotiates = 506;
//    const InsufficientStorage = 507;
//    const LoopDetected = 508;
//    const NotExtended = 510;
//    const NetworkAuthenticationRequired = 511;
  end;


const
  HTTPStatus: THTTPStatus = (); // Instância global


implementation


end.