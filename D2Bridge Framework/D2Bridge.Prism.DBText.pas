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

{$I D2Bridge.inc}

unit D2Bridge.Prism.DBText;

interface

{$IFNDEF FMX}
uses
  Classes, SysUtils,
  D2Bridge.Interfaces, D2Bridge.Prism, D2Bridge.FrameworkItem.DataWare, D2Bridge.Prism.Item,
  Prism.Types;


type
 PrismDBText = class(TD2BridgePrismItem, ID2BridgeFrameworkItemDBText)
  private
   FD2BridgeDatawareDataSource: TD2BridgeDatawareDataSource;
   FDataType: TPrismFieldType;
   procedure SetDataType(Value: TPrismFieldType);
   function GetDataType: TPrismFieldType;
  public
   constructor Create(AD2BridgePrismFramework: TD2BridgePrismFramework); reintroduce;
   destructor Destroy; override;

   procedure Clear; override;
   function FrameworkClass: TClass; override;
   procedure ProcessPropertyClass(VCLObj, NewObj: TObject); override;
   procedure ProcessEventClass(VCLObj, NewObj: TObject); override;
   procedure ProcessPropertyByName(VCLObj, NewObj: TObject; PropertyName: string; PropertyValue: Variant); override;

   function DataWare: ID2BridgeDatawareDataSource;
   property DataType: TPrismFieldType read GetDataType write SetDataType;
  end;



implementation

uses
  Prism.DBText;


{ PrismDBText }

procedure PrismDBText.Clear;
begin
 inherited;

 FDataType:= PrismFieldTypeAuto;
 Dataware.Clear;
end;

constructor PrismDBText.Create(AD2BridgePrismFramework: TD2BridgePrismFramework);
begin
 inherited Create(AD2BridgePrismFramework);

 FD2BridgeDatawareDataSource:= TD2BridgeDatawareDataSource.Create;
end;

function PrismDBText.DataWare: ID2BridgeDatawareDataSource;
begin
 Result:= FD2BridgeDatawareDataSource;
end;

destructor PrismDBText.Destroy;
begin
 FreeAndNil(FD2BridgeDatawareDataSource);

 inherited;
end;

function PrismDBText.FrameworkClass: TClass;
begin
 inherited;

 Result:= TPrismDBText;
end;

function PrismDBText.GetDataType: TPrismFieldType;
begin
 Result:= FDataType;
end;

procedure PrismDBText.ProcessEventClass(VCLObj, NewObj: TObject);
begin
 inherited;

end;

procedure PrismDBText.ProcessPropertyByName(VCLObj, NewObj: TObject;
  PropertyName: string; PropertyValue: Variant);
begin
 inherited;

end;

procedure PrismDBText.ProcessPropertyClass(VCLObj, NewObj: TObject);
begin
 inherited;

 TPrismDBText(NewObj).DataType:= DataType;

 if Assigned(Dataware.DataSource) then
 TPrismDBText(NewObj).DataWare.DataSource:= Dataware.DataSource;

 if Dataware.DataField <> '' then
 TPrismDBText(NewObj).DataWare.FieldName:= Dataware.DataField;

end;
procedure PrismDBText.SetDataType(Value: TPrismFieldType);
begin
 FDataType:= Value;
end;

{$ELSE}
implementation
{$ENDIF}

end.
