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
  Thank for contribution to this Unit to:
    Edvanio Jancy
    edvanio@ideiasistemas.com.br
 +--------------------------------------------------------------------------+
}

{$I ..\D2Bridge.inc}

unit Prism.Image;

interface

uses
  Classes, SysUtils, D2Bridge.JSON,
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
  FMX.Graphics,
{$ELSE}
  Graphics,
{$ENDIF}
  Prism, Prism.Types, Prism.Interfaces, Prism.Events, Prism.Forms.Controls;

type
 TPrismImage = class(TPrismControl, IPrismImage)
  private
   FPicture: TPicture;
   FURLImage: string;
   function Base64FromBitmap(Picture: TPicture): string;
   procedure OnChangePicture(Sender: TObject);
  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   function IsImage: Boolean; override;
   function NeedCheckValidation: Boolean; override;
   procedure SetPicture(APicture: TPicture);
   function GetPicture: TPicture;
   procedure SetURLImage(AURL: string);
   function GetURLImage: string;
  public
   constructor Create(AOwner: TObject); override;
   destructor Destroy; override;

  published
   property Picture: TPicture read GetPicture write setPicture;
   property URLImage: String read GetURLImage write SetURLImage;
 end;

implementation

uses
  Prism.Util;

{ TPrismImage }

function TPrismImage.Base64FromBitmap(Picture: TPicture): string;
var
  Output, Input: TStringStream;
{$IFDEF FPC}
  Encoder:       TBase64EncodingStream;
{$ENDIF}
begin
  Result:= '';

  try
    if Assigned(Picture) then
    begin
{$IFNDEF FMX}
      if Assigned(Picture.Graphic) then
      begin
{$ENDIF}
        if Picture.Width = 0 then
          Exit;

        try
          Input := TStringStream.Create;
          Output := TStringStream.Create;

          Picture.{$IFNDEF FMX}Graphic.{$ENDIF}SaveToStream(Input);
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
{$IFNDEF FMX}
      end;
{$ENDIF}
    end;
  except
  end;
end;

constructor TPrismImage.Create(AOwner: TObject);
begin
 inherited;
 FPicture := nil;
end;

destructor TPrismImage.Destroy;
begin
 try
  if Assigned(FPicture) then
   FPicture.OnChange:= nil;
 except
 end;

 inherited;
end;

function TPrismImage.GetEnableComponentState: Boolean;
begin

end;

function TPrismImage.GetPicture: TPicture;
begin
 Result := FPicture;
end;

function TPrismImage.GetURLImage: string;
begin
 Result:= FURLImage;
end;

procedure TPrismImage.Initialize;
begin
 inherited;
end;

function TPrismImage.IsImage: Boolean;
begin
  Result := True;
end;

function TPrismImage.NeedCheckValidation: Boolean;
begin
  Result := true;
end;

procedure TPrismImage.OnChangePicture(Sender: TObject);
begin
 Refresh;
end;

procedure TPrismImage.ProcessComponentState(
  const ComponentStateInfo: TJSONObject);
begin
 inherited;

end;

procedure TPrismImage.ProcessEventParameters(Event: IPrismControlEvent;
  Parameters: TStrings);
begin
  inherited;

end;

procedure TPrismImage.ProcessHTML;
var
 FBase64Picture: string;
begin
 inherited;

 if Assigned(Events.Item(EventOnClick)) then
 begin
  HTMLCore:= HTMLAddItemFromClass(HTMLCore, 'cursor-pointer');
 end;


 if FURLImage <> '' then
 begin
  //HTMLControl := '<div>';
  HTMLControl := '<img '+ HTMLCore+' src="' + FURLImage + '" />';
  //HTMLControl := HTMLControl + '</div>';
 end else
 begin
  FBase64Picture := Base64FromBitmap(FPicture);

  if FBase64Picture <> '' then
  begin
   //HTMLControl := '<div>';
   HTMLControl := '<img '+ HTMLCore+' src="data:image/jpeg;base64, '+ FBase64Picture +'"/>';
   //HTMLControl := HTMLControl + '</div>';
  end else
  begin
   //HTMLControl := '<div>';
   HTMLControl := '<img ' + HTMLCore+' />';
   //HTMLControl := HTMLControl + '</div>';
  end;
 end;
end;

procedure TPrismImage.SetPicture(APicture: TPicture);
begin
 FPicture := APicture;
 FPicture.OnChange:= OnChangePicture;
end;

procedure TPrismImage.SetURLImage(AURL: string);
begin
 FURLImage:= AURL;
end;

procedure TPrismImage.UpdateServerControls(var ScriptJS: TStrings;
  AForceUpdate: Boolean);
var
 FBase64Picture: string;
begin
 inherited;

 if AForceUpdate then
 begin
  FBase64Picture := Base64FromBitmap(Picture);

  if FBase64Picture <> '' then
  ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").src = `data:image/jpeg;base64, '+ FBase64Picture +'`;')
  else
  if URLImage <> '' then
  ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").src= "' + URLImage + '";')
  else
  ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").src= "";');
 end;
end;

end.
