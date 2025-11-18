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

{$I ..\D2Bridge.inc}

unit Prism.QRCode;

interface

uses
  Classes, SysUtils, D2Bridge.JSON,
  Types,
{$IFDEF HAS_UNIT_SYSTEM_UITYPES}
  System.UITypes,
{$ENDIF}
{$IFNDEF FPC}
  {$IFDEF HAS_UNIT_SYSTEM_NETENCODING}
  System.NetEncoding,
  {$ELSE}
  EncdDecd,
  {$ENDIF}
{$ELSE}
  base64,
{$ENDIF}
{$IFDEF FMX}
  FMX.Graphics, FMX.Types,
{$ELSE}
  DBCtrls, DB, Graphics,
{$ENDIF}
{$IFnDEF FMX}
  Prism.DataLink.Field,
{$ENDIF}
  Prism.Forms.Controls, Prism.Interfaces, Prism.Types,
  D2Bridge.Vendor.DelphiZXIngQRCode;


type
 TPrismQRCode = class(TPrismControl, IPrismQRCode)
  private
   FRefreshData: boolean;
{$IFNDEF FMX}
   FDataLinkField: TPrismDataLinkField;
{$ENDIF}
   FText: string;
   FSize: integer;
   FColorCode: string;
   FColorBackground: string;
   FQRCode: TDelphiZXingQRCode;
   FStoredText: string;
{$IFNDEF FMX}
   procedure SetDataSource(const Value: TDataSource);
   function GetDataSource: TDataSource;
   procedure SetDataField(Value: String);
   function GetDataField: String;
{$ENDIF}
   function GetText: string;
   procedure SetText(const Value: string);
   function GetSize: integer;
   procedure SetSize(const Value: integer);
   function GetColorCode: string;
   procedure SetColorCode(const Value: string);
   function GetColorBackground: string;
   procedure SetColorBackground(const Value: string);
   function Base64FromBitmap(ABitmap: TBitmap): string;
   function Base64FromQRCode: string;
   procedure UpdateData; override;
  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   function IsQRCode: Boolean; override;
  public
   constructor Create(AOwner: TObject); override;
   destructor Destroy; override;

{$IFNDEF FMX}
   property DataSource: TDataSource read GetDataSource write SetDataSource;
   property DataField: String read GetDataField write SetDataField;
{$ENDIF}
   property Text: string read GetText write SetText;
   property Size: integer read GetSize write SetSize;
   property ColorCode: string read GetColorCode write SetColorCode;
   property ColorBackground: string read GetColorBackground write SetColorBackground;
 end;



implementation

uses
  Prism.Util, D2Bridge.Util;


constructor TPrismQRCode.Create(AOwner: TObject);
begin
 inherited;

 FRefreshData:= false;
{$IFNDEF FMX}
 FDataLinkField:= TPrismDataLinkField.Create(self);
{$ENDIF}
 FSize:= 500;
 FColorCode:= '#000000';
 FColorBackground:= '#ffffff';

 FQRCode:= TDelphiZXingQRCode.Create;
 FQRCode.Encoding:= qrAuto;
 FQRCode.QuietZone:= 0;

end;

destructor TPrismQRCode.Destroy;
begin
{$IFNDEF FMX}
 FreeAndNil(FDataLinkField);
{$ENDIF}
 FreeAndNil(FQRCode);

 inherited;
end;

function TPrismQRCode.GetColorBackground: string;
begin
 Result:= FColorBackground;
end;

function TPrismQRCode.GetColorCode: string;
begin
 Result:= FColorCode;
end;

{$IFNDEF FMX}
function TPrismQRCode.GetDataField: String;
begin
 Result:= FDataLinkField.FieldName;
end;

function TPrismQRCode.GetDataSource: TDataSource;
begin
 Result:= FDataLinkField.DataSource;
end;
{$ENDIF}

function TPrismQRCode.GetEnableComponentState: Boolean;
begin
 Result:= true;
end;

function TPrismQRCode.GetSize: integer;
begin
 Result:= FSize;
end;

function TPrismQRCode.GetText: string;
begin
{$IFNDEF FMX}
 if Assigned(FDataLinkField.DataSource) and Assigned(FDataLinkField.DataSet) and (FDataLinkField.DataSet.Active) then
  Result:= FDataLinkField.Field.AsString
 else
{$ENDIF}
  Result:= FText;
end;

function TPrismQRCode.Base64FromBitmap(ABitmap: TBitmap): string;
var
  Output, Input: TStringStream;
{$IFDEF FPC}
  Encoder:       TBase64EncodingStream;
{$ENDIF}
begin
  Result:= '';

  try
    if Assigned(ABitmap) then
    begin

     try
      Input := TStringStream.Create;
      Output := TStringStream.Create;

      ABitmap.SaveToStream(Input);
      Input.Position := 0;

{$IFNDEF FPC}
  {$IFDEF HAS_UNIT_SYSTEM_NETENCODING}
      TNetEncoding.Base64.Encode(Input, Output);
  {$ELSE}
      EncodeStream(Input, Output);
  {$ENDIF}
{$ELSE}
      Encoder:= TBase64EncodingStream.Create(Output);
      Encoder.CopyFrom(Input, Input.Size);
      Encoder.Flush;
{$ENDIF}

      Output.Position := 0;

      Result := Output.DataString;
     finally
      Input.Free;
      Output.Free;
{$IFDEF FPC}
      Encoder.Free;
{$ENDIF}
     end;
    end;
  except
  end;
end;

function TPrismQRCode.Base64FromQRCode: string;
var
 vRow, vColumn: Integer;
 vScale:        Double;
 vQRCodeBitmap: TBitmap;
 pixelColor:    {$IFNDEF FMX}TColor{$ELSE}TAlphaColor{$ENDIF};
begin
 Result:= '';

 FQRCode.Data:= Text;

 try
  try
   vQRCodeBitmap:= TBitmap.Create;

{$IFNDEF FMX}
   vQRCodeBitmap.SetSize(FQRCode.Rows, FQRCode.Columns);
{$ELSE}
   vQRCodeBitmap.SetSize(FSize, FSize);

   vScale:= FSize / FQRCode.Rows;
{$ENDIF}

   for vRow := 0 to FQRCode.Rows-1 do
   begin
    for vColumn := 0 to FQRCode.Columns-1 do
    begin
     if (FQRCode.IsBlack[vRow, vColumn]) then
       pixelColor := HexToTColor(ColorCode)
     else
       pixelColor := HexToTColor(ColorBackground);

{$IFNDEF FMX}
      vQRCodeBitmap.Canvas.Pixels[vColumn, vRow]:= pixelColor;
{$ELSE}
      vQRCodeBitmap.ClearRect(TRectF.Create(PointF(vColumn, vRow) * vScale, vScale, vScale), pixelColor);
{$ENDIF}
    end;
   end;

{$IFNDEF FMX}
   if (vQRCodeBitmap.Width>0) and (vQRCodeBitmap.Height>0) then
   begin
    if FSize > vQRCodeBitmap.Width then
     vScale := FSize / vQRCodeBitmap.Width
    else
     vScale := vQRCodeBitmap.Width / FSize;
   end;

   vQRCodeBitmap.SetSize(FSize, FSize);
   vQRCodeBitmap.Canvas.StretchDraw(Rect(0,0, Trunc(vScale * vQRCodeBitmap.Width), Trunc(vScale * vQRCodeBitmap.Height)), vQRCodeBitmap);
{$ENDIF}

   Result:= Base64FromBitmap(vQRCodeBitmap);
  except
  end;
 finally
  if Assigned(vQRCodeBitmap) then
   vQRCodeBitmap.Free;
 end;
end;

procedure TPrismQRCode.Initialize;
begin
 inherited;

 FStoredText:= Text;
end;

function TPrismQRCode.IsQRCode: Boolean;
begin
 result:= true;
end;

procedure TPrismQRCode.ProcessComponentState(const ComponentStateInfo: TJSONObject);
begin
 inherited;

end;

procedure TPrismQRCode.ProcessEventParameters(Event: IPrismControlEvent;
  Parameters: TStrings);
begin
  inherited;

end;

procedure TPrismQRCode.ProcessHTML;
begin
 inherited;

{$IFNDEF FMX}
 if Assigned(FDataLinkField.DataSource) and Assigned(FDataLinkField.DataSet) and (FDataLinkField.DataSet.Active) then
  UpdateData;
{$ENDIF}

 if FStoredText <> '' then
 begin
  HTMLControl := '<img '+ HTMLCore+' src="data:image/jpeg;base64, '+ Base64FromQRCode +'"/>';
 end else
 begin
  HTMLControl := '<img ' + HTMLCore+' />';
 end;
end;

procedure TPrismQRCode.SetColorBackground(const Value: string);
begin

end;

procedure TPrismQRCode.SetColorCode(const Value: string);
begin
 FColorCode:= Value;
end;

{$IFNDEF FMX}
procedure TPrismQRCode.SetDataField(Value: String);
begin
 FDataLinkField.FieldName:= Value;
end;

procedure TPrismQRCode.SetDataSource(const Value: TDataSource);
begin
 if FDataLinkField.DataSource <> Value then
 begin
//  if Assigned(FDataLink.DataSource) then
//   FDataLink.DataSource.RemoveFreeNotification(Self);

  FDataLinkField.DataSource := Value;

//  if Assigned(FDataLink.DataSource) then
//    FDataLink.DataSource.FreeNotification(Self);
 end;
end;
{$ENDIF}

procedure TPrismQRCode.SetSize(const Value: integer);
begin
 FSize:= Value;
end;

procedure TPrismQRCode.SetText(const Value: string);
begin
 FText:= Value;
end;

procedure TPrismQRCode.UpdateData;
begin
 inherited;

 if Assigned(Form) then
  if (Form.FormPageState = PageStateLoaded) and (not Form.ComponentsUpdating) then
   FRefreshData:= true;
end;

procedure TPrismQRCode.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
var
 NewText: string;
begin
 inherited;

 NewText:= Text;
 if (FStoredText <> NewText) or (AForceUpdate) then
 begin
  FStoredText:= NewText;

  ScriptJS.Add('setTimeout(function() {');
  ScriptJS.Add('   document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").src = `data:image/jpeg;base64, '+ Base64FromQRCode +'`;');
  ScriptJS.Add('}, 100)');
 end;
end;

end.
