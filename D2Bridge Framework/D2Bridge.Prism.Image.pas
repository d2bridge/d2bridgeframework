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

{$I D2Bridge.inc}

unit D2Bridge.Prism.Image;

interface

uses
  Classes,
{$IFDEF FMX}
{$ELSE}
  StdCtrls, Controls, Graphics,
{$ENDIF}
  D2Bridge.Interfaces, D2Bridge.Prism, D2Bridge.Prism.Item;



type
 PrismImage = class(TD2BridgePrismItem, ID2BridgeFrameworkItemImage)
  private
   FPicture: TPicture;
  public
   procedure Clear; override;
   function FrameworkClass: TClass; override;
   procedure ProcessPropertyClass(VCLObj, NewObj: TObject); override;
   procedure ProcessEventClass(VCLObj, NewObj: TObject); override;
   procedure ProcessPropertyByName(VCLObj, NewObj: TObject; PropertyName: string; PropertyValue: Variant); override;

   procedure SetPicture(APicture: TPicture);
   function GetPicture: TPicture;

   property Picture: TPicture read GetPicture write SetPicture;
  end;


implementation

uses
  SysUtils, Prism.Image;



{ PrismImage }

procedure PrismImage.Clear;
begin
  inherited;
  FPicture := nil;
end;

function PrismImage.FrameworkClass: TClass;
begin
  Result := TPrismImage;
end;

function PrismImage.GetPicture: TPicture;
begin
   Result := FPicture;
end;

procedure PrismImage.ProcessEventClass(VCLObj, NewObj: TObject);
begin
  inherited;

end;

procedure PrismImage.ProcessPropertyByName(VCLObj, NewObj: TObject;
  PropertyName: string; PropertyValue: Variant);
begin
  inherited;

end;

procedure PrismImage.ProcessPropertyClass(VCLObj, NewObj: TObject);
begin
  inherited;
  TPrismImage(NewObj).Picture := Picture;
end;

procedure PrismImage.SetPicture(APicture: TPicture);
begin
  FPicture := APicture;
end;

end.
