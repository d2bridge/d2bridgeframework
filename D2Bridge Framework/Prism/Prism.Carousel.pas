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

unit Prism.Carousel;

interface

uses
  Classes, SysUtils, D2Bridge.JSON, Generics.Collections, StrUtils,
  Prism.Forms.Controls, Prism.Interfaces, Prism.Types
{$IFDEF FMX}

{$ELSE}
  , DBCtrls, DB, Prism.DataLink.Field
{$ENDIF}
;


type
 TPrismCarousel = class(TPrismControl, IPrismCarousel)
  private
   FAutoSlide: boolean;
   FInterval: integer;
   FShowButtons: boolean;
   FShowIndicator: boolean;
   FImageFiles: TList<string>;
{$IFNDEF FMX}
   FDataLinkField: TPrismDataLinkField;
{$ENDIF}
   FRefreshData: Boolean;
   FMaxRecords: integer;
   function GetAutoSlide: boolean;
   procedure SetAutoSlide(Value: boolean);
   function GetInterval: integer;
   procedure SetInterval(Value: integer);
   function GetShowButtons: boolean;
   procedure SetShowButtons(Value: boolean);
   function GetShowIndicator: boolean;
   procedure SetShowIndicator(Value: boolean);
{$IFNDEF FMX}
   procedure SetDataSource(const Value: TDataSource);
   function GetDataSource: TDataSource;
   procedure SetDataFieldImagePath(AValue: String);
   function GetDataFieldImagePath: String;
   //Dataware Event
   procedure DataWareEvent(const ADataWareEvent: TPrismDataLinkEvent);
{$ENDIF}
   function GetMaxRecords: integer;
   Procedure SetMaxRecords(AMaxRecords: Integer);
   procedure UpdateData; override;
   function RenderCarouselHTMLContent: string;
   function QtyItems: integer;
   procedure PopuleImageFiles;
  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   function IsCarousel: Boolean; override;
  public
   constructor Create(AOwner: TObject); override;
   destructor Destroy; override;

   function ImageFiles: TList<string>;

   property AutoSlide: boolean read GetAutoSlide write SetAutoSlide;
   property ShowButtons: boolean read GetShowButtons write SetShowButtons;
   property ShowIndicator: boolean read GetShowIndicator write SetShowIndicator;
   property Interval: integer read GetInterval write SetInterval;
{$IFNDEF FMX}
   property DataSource: TDataSource read GetDataSource write SetDataSource;
   property DataFieldImagePath: String read GetDataFieldImagePath write SetDataFieldImagePath;
{$ENDIF}
   property MaxRecords: Integer read GetMaxRecords write SetMaxRecords;
 end;



implementation

uses
  Prism.Util, D2Bridge.Util;


constructor TPrismCarousel.Create(AOwner: TObject);
begin
 inherited;

 FImageFiles:= TList<string>.Create;
 FRefreshData:= false;

{$IFNDEF FMX}
 FDataLinkField:= TPrismDataLinkField.Create(self);
 FDataLinkField.OnDataWareEvent:= DataWareEvent;
{$ENDIF}

 FMaxRecords:= 25;
end;

destructor TPrismCarousel.Destroy;
begin
 FreeAndNil(FImageFiles);
{$IFNDEF FMX}
 FreeAndNil(FDataLinkField);
{$ENDIF}
 inherited;
end;

function TPrismCarousel.GetAutoSlide: boolean;
begin
 result:= FAutoSlide;
end;

{$IFNDEF FMX}
function TPrismCarousel.GetDataFieldImagePath: String;
begin
 Result:= FDataLinkField.FieldName;
end;

function TPrismCarousel.GetDataSource: TDataSource;
begin
 Result:= FDataLinkField.DataSource;
end;
{$ENDIF}

function TPrismCarousel.GetEnableComponentState: Boolean;
begin
 Result:= true;
end;

function TPrismCarousel.GetInterval: integer;
begin
 result:= FInterval;
end;

function TPrismCarousel.GetMaxRecords: integer;
begin
 result:= FMaxRecords;
end;

function TPrismCarousel.GetShowButtons: boolean;
begin
 result:= FShowButtons;
end;

function TPrismCarousel.GetShowIndicator: boolean;
begin
 result:= FShowIndicator;
end;

function TPrismCarousel.ImageFiles: TList<string>;
begin
 Result:= FImageFiles;
end;

procedure TPrismCarousel.Initialize;
begin
 inherited;
end;

function TPrismCarousel.IsCarousel: Boolean;
begin
 result:= true;
end;

procedure TPrismCarousel.PopuleImageFiles;
var
 vPos: integer;
begin
{$IFNDEF FMX}
  FImageFiles.Clear;

  if Assigned(FDataLinkField.DataSource) then
  if Assigned(FDataLinkField.DataSet) then
  if FDataLinkField.DataSet.Active then
  begin
   vPos:= FDataLinkField.DataSet.RecNo;
   FDataLinkField.DataSet.DisableControls;
   FDataLinkField.DataSet.First;

   try
    try
     repeat
      FImageFiles.Add(FDataLinkField.Field.AsString);
      FDataLinkField.DataSet.Next;
     until FDataLinkField.DataSet.Eof or (FImageFiles.Count = MaxRecords);
    except

    end;
   finally
    if Assigned(FDataLinkField.DataSource) then
    if Assigned(FDataLinkField.DataSet) then
    if FDataLinkField.DataSet.Active then
    begin
     FDataLinkField.DataSet.RecNo:= vPos;

     FDataLinkField.DataSet.EnableControls;
    end;
   end;
  end;
{$ENDIF}
end;

procedure TPrismCarousel.ProcessComponentState(const ComponentStateInfo: TJSONObject);
begin
 inherited;

end;

procedure TPrismCarousel.ProcessEventParameters(Event: IPrismControlEvent;
  Parameters: TStrings);
begin
  inherited;

end;

procedure TPrismCarousel.ProcessHTML;
begin
 inherited;

{$IFNDEF FMX}
 if Assigned(FDataLinkField.DataSource) and Assigned(FDataLinkField.DataSet) and (FDataLinkField.DataSet.Active) then
 begin
  PopuleImageFiles;
 end;
{$ENDIF}

 HTMLControl:= '<div '+HTMLCore;
 if AutoSlide then
  HTMLControl:= HTMLControl + ' data-bs-ride="carousel"';
 if Interval > 0 then
  HTMLControl:= HTMLControl + ' data-interval="' + IntToStr(Interval) + '"';

 HTMLControl:= HTMLControl + '>' + sLineBreak;

 HTMLControl:= HTMLControl + RenderCarouselHTMLContent + sLineBreak;

 HTMLControl:= HTMLControl + '</div>';
end;

function TPrismCarousel.QtyItems: integer;
begin
 result:= ImageFiles.Count;
end;

function TPrismCarousel.RenderCarouselHTMLContent: string;
var
 vHTMLContent: TStrings;
 I: integer;
begin
 vHTMLContent:= TStringList.Create;

 with vHTMLContent do
 begin
  if ShowIndicator and (QtyItems > 1) then
  begin
   Add('  <div id="'+AnsiUpperCase(NamePrefix)+'INDICATOR" class="d2bridgecarousel-indicators carousel-indicators">');
   for I := 0 to Pred(QtyItems) do
   begin
    Add('    <button type="button" data-bs-target="#'+AnsiUpperCase(NamePrefix)+'" data-bs-slide-to="' + IntToStr(I) + '" ' + ifThen(I = 0, 'class="active" ') +'aria-current="true" aria-label="Slide ' + IntToStr(I+1) + '"></button>');
   end;
   Add('  </div>');
  end;
  Add('  <div class="carousel-inner">');
  for I := 0 to Pred(QtyItems) do
  begin
   Add('    <div class="carousel-item ' + ifThen(I = 0, 'active') +'">');
   Add('      <img src="' + D2Bridge.Util.Base64ImageFromFile(ImageFiles[I]) + '" class="d2bridgecarousel-image d-block w-100" alt="">');
   Add('    </div>');
  end;
  Add('  </div>');
  if ShowButtons and (QtyItems > 1) then
  begin
   Add('  <button id="'+AnsiUpperCase(NamePrefix)+'BUTTONPREV" class="carousel-control-prev" type="button" data-bs-target="#'+AnsiUpperCase(NamePrefix)+'" data-bs-slide="prev">');
   Add('    <span class="carousel-control-prev-icon" aria-hidden="true"></span>');
   Add('    <span class="visually-hidden">Previous</span>');
   Add('  </button>');
   Add('  <button id="'+AnsiUpperCase(NamePrefix)+'BUTTONNEXT" class="carousel-control-next" type="button" data-bs-target="#'+AnsiUpperCase(NamePrefix)+'" data-bs-slide="next">');
   Add('    <span class="carousel-control-next-icon" aria-hidden="true"></span>');
   Add('    <span class="visually-hidden">Next</span>');
   Add('  </button>');
  end;
 end;

 result:= vHTMLContent.Text;

 vHTMLContent.Free;
end;

procedure TPrismCarousel.SetAutoSlide(Value: boolean);
begin
 FAutoSlide:= Value;
end;

{$IFNDEF FMX}
procedure TPrismCarousel.DataWareEvent(const ADataWareEvent: TPrismDataLinkEvent);
begin
 if Assigned(Form) and (Form.FormPageState in [PageStateLoaded, PageStateLoading]) then
 begin
  //Active/Deactive
  if ADataWareEvent in [TPrismDataLinkEvent.Activate, TPrismDataLinkEvent.Deactivate, TPrismDataLinkEvent.NewRow, TPrismDataLinkEvent.Deleted, TPrismDataLinkEvent.Updated] then
  begin
   UpdateData;
  end;
 end;
end;

procedure TPrismCarousel.SetDataFieldImagePath(AValue: String);
begin
 FDataLinkField.FieldName:= AValue;
end;

procedure TPrismCarousel.SetDataSource(const Value: TDataSource);
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

procedure TPrismCarousel.SetInterval(Value: integer);
begin
 FInterval:= Value;
end;

procedure TPrismCarousel.SetMaxRecords(AMaxRecords: Integer);
begin
 FMaxRecords:= AMaxRecords;
end;

procedure TPrismCarousel.SetShowButtons(Value: boolean);
begin
 FShowButtons:= Value;
end;

procedure TPrismCarousel.SetShowIndicator(Value: boolean);
begin
 FShowIndicator:= Value;
end;

procedure TPrismCarousel.UpdateData;
begin
 inherited;

 if (Assigned(Form)) and (Form.FormPageState = PageStateLoaded) and (not Form.ComponentsUpdating) then
 begin
  FRefreshData:= true;
 end;
end;

procedure TPrismCarousel.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
begin
 inherited;

 if (FRefreshData) or (AForceUpdate) then
 begin
  PopuleImageFiles;

  FRefreshData:= false;

  //ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").innerHTML = '+ FormatValueHTML(RenderCarouselHTMLContent) +';');

  ScriptJS.Add('let temp'+AnsiUpperCase(NamePrefix)+' = document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]");');
  ScriptJS.Add('temp'+AnsiUpperCase(NamePrefix)+'.innerHTML = ' + FormatValueHTML(RenderCarouselHTMLContent) +';');

  ScriptJS.Add('var carousel = new bootstrap.Carousel(temp'+AnsiUpperCase(NamePrefix)+');');
 end;
end;



end.