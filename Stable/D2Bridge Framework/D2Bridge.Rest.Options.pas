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

unit D2Bridge.Rest.Options;

interface

uses
  Classes, SysUtils,
  D2Bridge.Rest.Interfaces;


type
 TD2BridgeRestOptions = class(TInterfacedPersistent, ID2BridgeRestOptions)
  private
   FEnableRESTServerExternal: Boolean;
   FFieldNameLowerCase: Boolean;
   FFormatSettings: TFormatSettings;
   FMaxRecord: Integer;
   FShowMetadata: Boolean;
   function GetEnableRESTServerExternal: Boolean;
   function GetFieldNameLowerCase: Boolean;
   function GetFormatSettings: TFormatSettings;
   function GetMaxRecord: Integer;
   procedure SetFieldNameLowerCase(const Value: Boolean);
   procedure SetFormatSettings(const Value: TFormatSettings);
   procedure SetMaxRecord(const Value: Integer);
   procedure SetShowMetadata(const Value: Boolean);
   function GetShowMetadata: Boolean;
   procedure SetEnableRESTServerExternal(const Value: Boolean);
  public
   constructor Create;
   destructor Destroy; override;

   function Security: ID2BridgeRestSecurity;

   property EnableRESTServerExternal: Boolean read GetEnableRESTServerExternal write SetEnableRESTServerExternal;
   property FieldNameLowerCase: Boolean read GetFieldNameLowerCase write SetFieldNameLowerCase;
   property FormatSettings: TFormatSettings read GetFormatSettings write SetFormatSettings;
   property MaxRecord: Integer read GetMaxRecord write SetMaxRecord;
   property ShowMetadata: Boolean read GetShowMetadata write SetShowMetadata;

 end;


implementation

Uses
 Prism.BaseClass;

{ TD2BridgeRestOptions }

constructor TD2BridgeRestOptions.Create;
begin
 inherited;

 FFieldNameLowerCase:= true;

 FFormatSettings:= {$IFnDEF FPC}TFormatSettings.Create('en-US'){$ELSE}DefaultFormatSettings{$ENDIF};
 FFormatSettings.ShortDateFormat := 'yyyy-mm-dd';
 FFormatSettings.DateSeparator:= '-';
 FFormatSettings.DecimalSeparator:= '.';
 FFormatSettings.ThousandSeparator:= ',';
 FFormatSettings.TimeSeparator:= ':';
 FFormatSettings.ShortTimeFormat:= 'hh:nn';
 FFormatSettings.LongTimeFormat:= 'hh:nn:ss';


 FMaxRecord:= 2000;
 FShowMetadata:= false;
 FEnableRESTServerExternal:= true;
end;

destructor TD2BridgeRestOptions.Destroy;
begin

 inherited;
end;

function TD2BridgeRestOptions.GetEnableRESTServerExternal: Boolean;
begin
 Result := FEnableRESTServerExternal;
end;

function TD2BridgeRestOptions.GetFieldNameLowerCase: Boolean;
begin
 Result := FFieldNameLowerCase;
end;

function TD2BridgeRestOptions.GetFormatSettings: TFormatSettings;
begin
 Result := FFormatSettings;
end;

function TD2BridgeRestOptions.GetMaxRecord: Integer;
begin
 Result := FMaxRecord;
end;

function TD2BridgeRestOptions.GetShowMetadata: Boolean;
begin
 result:= FShowMetadata;
end;

function TD2BridgeRestOptions.Security: ID2BridgeRestSecurity;
begin
 result:= PrismBaseClass.Rest.Security;
end;

procedure TD2BridgeRestOptions.SetEnableRESTServerExternal(const Value:
    Boolean);
begin
 FEnableRESTServerExternal := Value;
end;

procedure TD2BridgeRestOptions.SetFieldNameLowerCase(const Value: Boolean);
begin
 FFieldNameLowerCase := Value;
end;

procedure TD2BridgeRestOptions.SetFormatSettings(const Value: TFormatSettings);
begin
 FFormatSettings := Value;
end;

procedure TD2BridgeRestOptions.SetMaxRecord(const Value: Integer);
begin
 FMaxRecord := Value;
end;

procedure TD2BridgeRestOptions.SetShowMetadata(const Value: Boolean);
begin
 FShowMetadata := Value;
end;

end.