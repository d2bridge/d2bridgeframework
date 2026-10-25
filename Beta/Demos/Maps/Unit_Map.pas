unit Unit_Map;

{ Map demo.
  Free use needs no API key: the browser provides the location and
  Route draws a straight line. See Beta/DOC/D2Bridge_Map.md. }

interface

uses
  Classes, SysUtils,
{$IFDEF FPC}
  Controls, Forms, StdCtrls, Dialogs,
{$ELSE}
  Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.Dialogs,
{$ENDIF}
  D2Bridge.Forms, Prism.Interfaces;

type
  TFormMap = class(TD2BridgeForm)
    LabelLatitude: TLabel;
    LabelLongitude: TLabel;
    EditLatitude: TEdit;
    EditLongitude: TEdit;
    BtnMarkPoint: TButton;
    BtnClear: TButton;
    BtnMyLocation: TButton;
    MemoResult: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure BtnMarkPointClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
    procedure BtnMyLocationClick(Sender: TObject);
  private
    FMap: IPrismMap;
    function ReadCoordinates(out ALat, ALng: Double): Boolean;
    function FormatCoord(AValue: Double): string;
    procedure ShowResult(const AText: string);
    procedure MapLocation(Sender: TObject);
  protected
    procedure ExportD2Bridge; override;
    procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
  public
  end;

function FormMap: TFormMap;

implementation

uses
  D2BridgeFormTemplate;

const
  CLatDefault = -21.176700;
  CLngDefault = -47.820800;

{$IFNDEF FPC}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

function FormMap: TFormMap;
begin
  Result := TFormMap(TFormMap.GetInstance);
end;

function TFormMap.FormatCoord(AValue: Double): string;
var
  LFS: TFormatSettings;
begin
{$IFNDEF FPC}
  LFS := TFormatSettings.Create;
{$ELSE}
  LFS := DefaultFormatSettings;
{$ENDIF}
  LFS.DecimalSeparator := '.';
  LFS.ThousandSeparator := #0;
  Result := FormatFloat('0.000000', AValue, LFS);
end;

function TFormMap.ReadCoordinates(out ALat, ALng: Double): Boolean;
var
  LFS: TFormatSettings;
  LLat, LLng: string;
begin
  ALat := 0;
  ALng := 0;
  LLat := Trim(EditLatitude.Text);
  LLng := Trim(EditLongitude.Text);
  if (LLat = '') or (LLng = '') then
    Exit(False);

{$IFNDEF FPC}
  LFS := TFormatSettings.Create;
{$ELSE}
  LFS := DefaultFormatSettings;
{$ENDIF}
  LFS.ThousandSeparator := #0;
  if Pos('.', LLat) > 0 then
    LFS.DecimalSeparator := '.'
  else
    LFS.DecimalSeparator := ',';

  Result := TryStrToFloat(LLat, ALat, LFS) and TryStrToFloat(LLng, ALng, LFS);
end;

procedure TFormMap.ShowResult(const AText: string);
begin
  MemoResult.Text := AText;
  if Assigned(D2Bridge) then
    D2Bridge.UpdateD2BridgeControl(MemoResult);
end;

procedure TFormMap.FormCreate(Sender: TObject);
begin
  Caption := 'Map';
  LabelLatitude.Caption := 'Latitude';
  LabelLongitude.Caption := 'Longitude';
  EditLatitude.Text := FormatCoord(CLatDefault);
  EditLongitude.Text := FormatCoord(CLngDefault);
  BtnMarkPoint.Caption := 'Mark point';
  BtnClear.Caption := 'Clear points';
  BtnMyLocation.Caption := 'Return to location';
  MemoResult.ReadOnly := True;
  MemoResult.ScrollBars := ssVertical;
  MemoResult.Text := 'Allow the browser location, or type a latitude and longitude and click Mark point.';
end;

procedure TFormMap.ExportD2Bridge;
begin
  inherited;

  Title := 'Map';
  SubTitle := 'Location, origin and destination';
  TemplateClassForm := TD2BridgeFormTemplate;

  with D2Bridge.Items.Add do
  begin
    with Row.Items.Add do
    begin
      FormGroup('Latitude', CSSClass.Col.colsize3).AddVCLObj(EditLatitude);
      FormGroup('Longitude', CSSClass.Col.colsize3).AddVCLObj(EditLongitude);
      FormGroup('', CSSClass.Col.colsize2).AddVCLObj(BtnMarkPoint, CSSClass.Button.search);
      FormGroup('', CSSClass.Col.colsize2).AddVCLObj(BtnClear, CSSClass.Button.clean);
      FormGroup('', CSSClass.Col.colsize2).AddVCLObj(BtnMyLocation, CSSClass.Button.list);
    end;

    FMap := Map('DeliveryMap').PrismMap;

    with Row.Items.Add do
      FormGroup('Result', CSSClass.Col.colsize12).AddVCLObj(MemoResult);
  end;
end;

procedure TFormMap.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
  inherited;

  if PrismControl.IsMap then
  begin
    { Free map. No provider and no API key. }
    PrismControl.AsMap.Latitude := CLatDefault;
    PrismControl.AsMap.Longitude := CLngDefault;
    PrismControl.AsMap.Zoom := 13;
    PrismControl.AsMap.Height := 480;
    PrismControl.AsMap.RequestLocation := True;
    PrismControl.AsMap.OnLocation := MapLocation;
    FMap := PrismControl.AsMap;
  end;
end;

procedure TFormMap.MapLocation(Sender: TObject);
var
  LMap: IPrismMap;
begin
  if not Supports(Sender, IPrismMap, LMap) then
    Exit;

  if LMap.LocationError <> '' then
  begin
    ShowMessage(LMap.LocationError);
    ShowResult(LMap.LocationError);
    Exit;
  end;

  if LMap.HasRoute then
  begin
    EditLatitude.Text := FormatCoord(LMap.DestLatitude);
    EditLongitude.Text := FormatCoord(LMap.DestLongitude);
    ShowResult(
      'Origin: ' + FormatCoord(LMap.Latitude) + ', ' + FormatCoord(LMap.Longitude) + sLineBreak +
      'Destination: ' + FormatCoord(LMap.DestLatitude) + ', ' + FormatCoord(LMap.DestLongitude) + sLineBreak +
      'Distance: ' + FormatFloat('0.00', LMap.DistanceKm) + ' km');
  end
  else
  begin
    EditLatitude.Text := FormatCoord(LMap.Latitude);
    EditLongitude.Text := FormatCoord(LMap.Longitude);
    if Assigned(D2Bridge) then
    begin
      D2Bridge.UpdateD2BridgeControl(EditLatitude);
      D2Bridge.UpdateD2BridgeControl(EditLongitude);
    end;
    ShowResult('Location: ' + FormatCoord(LMap.Latitude) + ', ' + FormatCoord(LMap.Longitude));
  end;
end;

procedure TFormMap.BtnMarkPointClick(Sender: TObject);
var
  LLat, LLng: Double;
begin
  if not Assigned(FMap) then
  begin
    ShowMessage('The map is not ready.');
    Exit;
  end;

  if not ReadCoordinates(LLat, LLng) then
  begin
    ShowMessage('Enter a valid latitude and longitude.');
    Exit;
  end;

  { The typed point becomes the origin. The next map click is the destination. }
  FMap.SetMarker(LLat, LLng);
  FMap.LockOrigin;
  ShowResult(
    'Origin locked at ' + FormatCoord(LLat) + ', ' + FormatCoord(LLng) + sLineBreak +
    'Click the map to choose the destination.');
end;

procedure TFormMap.BtnClearClick(Sender: TObject);
begin
  if not Assigned(FMap) then
    Exit;

  FMap.ClearRoute;
  ShowResult('Markers cleared. Mark a point to start again.');
end;

procedure TFormMap.BtnMyLocationClick(Sender: TObject);
begin
  if not Assigned(FMap) then
  begin
    ShowMessage('The map is not ready.');
    Exit;
  end;

  { Asks the browser again and moves the marker to the current position. }
  FMap.RequestLocation := True;
  ShowResult('Requesting the current location...');
end;

end.
