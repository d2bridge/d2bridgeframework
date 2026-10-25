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

unit Prism.Map;

interface

uses
  Classes, SysUtils, D2Bridge.JSON,
  Prism.Types, Prism.Interfaces, Prism.Forms.Controls;

type
  TPrismMap = class(TPrismControl, IPrismMap)
  private
   FLatitude: Double;
   FLongitude: Double;
   FZoom: Integer;
   FHeight: Integer;
   FRequestLocation: Boolean;
   FDistanceKm: Double;
   FLocationError: string;
   FOnLocation: TNotifyEvent;
   FRendered: Boolean;
   FHasRoute: Boolean;
   FOriginLocked: Boolean;
   FDestLatitude: Double;
   FDestLongitude: Double;
   function ElementId: string;
   function BuildScript: string;
   procedure ExecMapJS(const ACall: string);
   procedure NotifyLocation;
  protected
   procedure ProcessHTML; override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   function IsMap: Boolean; override;
  public
   constructor Create(AOwner: TObject); override;

   function GetLatitude: Double;
   procedure SetLatitude(const Value: Double);
   function GetLongitude: Double;
   procedure SetLongitude(const Value: Double);
   function GetZoom: Integer;
   procedure SetZoom(const Value: Integer);
   function GetHeight: Integer;
   procedure SetHeight(const Value: Integer);
   function GetRequestLocation: Boolean;
   procedure SetRequestLocation(const Value: Boolean);
   function GetDistanceKm: Double;
   function GetLocationError: string;
   function GetOnLocation: TNotifyEvent;
   procedure SetOnLocation(const Value: TNotifyEvent);
   function GetHasRoute: Boolean;
   function GetDestLatitude: Double;
   function GetDestLongitude: Double;

   procedure SetMarker(ALatitude, ALongitude: Double);
   procedure Route(ALatitude, ALongitude: Double);
   procedure LockOrigin;
   procedure ClearRoute;

   property Latitude: Double read GetLatitude write SetLatitude;
   property Longitude: Double read GetLongitude write SetLongitude;
   property Zoom: Integer read GetZoom write SetZoom;
   property Height: Integer read GetHeight write SetHeight;
   property RequestLocation: Boolean read GetRequestLocation write SetRequestLocation;
   property DistanceKm: Double read GetDistanceKm;
   property LocationError: string read GetLocationError;
   property OnLocation: TNotifyEvent read GetOnLocation write SetOnLocation;
   property HasRoute: Boolean read GetHasRoute;
   property DestLatitude: Double read GetDestLatitude;
   property DestLongitude: Double read GetDestLongitude;
  end;

implementation

uses
  Math, Prism.Events, Prism.Util;

function MapCoord(AValue: Double): string;
var
  FS: TFormatSettings;
begin
 {$IFNDEF FPC}
  FS := TFormatSettings.Create;
 {$ELSE}
  FS := DefaultFormatSettings;
 {$ENDIF}
  FS.DecimalSeparator := '.';
  FS.ThousandSeparator := ',';
  Result := FormatFloat('0.000000', AValue, FS);
end;

function ParseCoord(const AValue: string; ADefault: Double): Double;
var
  FS: TFormatSettings;
begin
 {$IFNDEF FPC}
  FS := TFormatSettings.Create;
 {$ELSE}
  FS := DefaultFormatSettings;
 {$ENDIF}
  FS.DecimalSeparator := '.';
  FS.ThousandSeparator := ',';
  if not TryStrToFloat(StringReplace(Trim(AValue), ',', '.', [rfReplaceAll]), Result, FS) then
   Result := ADefault;
end;

function MapDistanceKm(ALat1, ALng1, ALat2, ALng2: Double): Double;
var
  vDLat, vDLng, vA, vC: Double;
begin
  vDLat := DegToRad(ALat2 - ALat1);
  vDLng := DegToRad(ALng2 - ALng1);
  vA := Sin(vDLat / 2) * Sin(vDLat / 2) +
        Cos(DegToRad(ALat1)) * Cos(DegToRad(ALat2)) *
        Sin(vDLng / 2) * Sin(vDLng / 2);
  vC := 2 * ArcTan2(Sqrt(vA), Sqrt(1 - vA));
  Result := 6371.0 * vC;
end;

{ TPrismMap }

function TPrismMap.BuildScript: string;
var
  vId, vEvent, vLat, vLng, vZoom, vHeight, vReq, vRoute: string;
begin
  vId := ElementId;
  vLat := MapCoord(FLatitude);
  vLng := MapCoord(FLongitude);
  vZoom := IntToStr(FZoom);
  vHeight := IntToStr(FHeight);

  if Assigned(Events.Item(EventOnMapLocation)) then
   vEvent := Events.Item(EventOnMapLocation).EventJS(ExecEventProc, 'd2bMapParam', False)
  else
   vEvent := '';

  if FRequestLocation then
   vReq := 'obj.requestLocation();'
  else
   vReq := '';

  if FHasRoute then
   vRoute := 'obj.route(' + MapCoord(FDestLatitude) + ',' + MapCoord(FDestLongitude) + ');'
  else
   vRoute := '';

  Result :=
    '(function(){' +
    'var d2bMapId="' + vId + '";' +
    'function d2bMapBoot(){' +
    'var el=document.getElementById(d2bMapId);' +
    'if(!window.L||!el)return;' +
    'if(window.D2BMap&&window.D2BMap[d2bMapId]&&window.D2BMap[d2bMapId].map){try{window.D2BMap[d2bMapId].map.remove();}catch(ex){}delete window.D2BMap[d2bMapId];}' +
    'window.D2BMap=window.D2BMap||{};' +
    'el.style.height="' + vHeight + 'px";el.style.width="100%";' +
    'var obj={map:null,marker:null,line:null};' +
    'obj.map=L.map(d2bMapId).setView([' + vLat + ',' + vLng + '],' + vZoom + ');' +
    'L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",{maxZoom:19,attribution:"OpenStreetMap"}).addTo(obj.map);' +
    'obj.setMarker=function(lat,lng){var ll=L.latLng(lat,lng);if(!obj.marker)obj.marker=L.marker(ll).addTo(obj.map);else obj.marker.setLatLng(ll);obj.map.setView(ll,obj.map.getZoom());};' +
    'obj.route=function(lat,lng){var from=obj.marker?obj.marker.getLatLng():L.latLng(' + vLat + ',' + vLng + ');' +
    'if(obj.line){obj.map.removeLayer(obj.line);obj.line=null;}' +
    'obj.line=L.polyline([[from.lat,from.lng],[lat,lng]],{color:"#0d6efd",weight:4}).addTo(obj.map);' +
    'var dll=L.latLng(lat,lng);' +
    'if(!obj.destMarker)obj.destMarker=L.marker(dll).addTo(obj.map);' +
    'else obj.destMarker.setLatLng(dll);' +
    'if(obj.line.getBounds().isValid())obj.map.fitBounds(obj.line.getBounds(),{padding:[24,24]});};' +
    'obj.send=function(param){var d2bMapParam=param;' + vEvent + '};' +
    'obj.originLocked=false;obj.destMarker=null;' +
    'obj.lockOrigin=function(){obj.originLocked=true;};' +
    'obj.clearRoute=function(){obj.originLocked=false;' +
    'if(obj.line){obj.map.removeLayer(obj.line);obj.line=null;}' +
    'if(obj.destMarker){obj.map.removeLayer(obj.destMarker);obj.destMarker=null;}};' +
    'obj.requestLocation=function(){' +
    'if(!navigator.geolocation){obj.send("err=1&msg=Geolocation indisponivel");return;}' +
    'navigator.geolocation.getCurrentPosition(function(pos){' +
    'obj.setMarker(pos.coords.latitude,pos.coords.longitude);' +
    'obj.send("lat="+pos.coords.latitude+"&lng="+pos.coords.longitude+"&src=gps");' +
    '},function(err){' +
    'var msg=(err&&err.message)?String(err.message):"Localizacao negada";' +
    'obj.send("err=1&msg="+msg.split("&").join(" "));' +
    '},{enableHighAccuracy:true,timeout:15000,maximumAge:0});};' +
    'obj.map.on("click",function(e){' +
    'if(obj.originLocked){obj.send("lat="+e.latlng.lat+"&lng="+e.latlng.lng+"&src=dest");}' +
    'else{obj.setMarker(e.latlng.lat,e.latlng.lng);obj.send("lat="+e.latlng.lat+"&lng="+e.latlng.lng+"&src=click");}' +
    '});' +
    'window.D2BMap[d2bMapId]=obj;' +
    'function d2bMarkerIcons(base){' +
    'delete L.Icon.Default.prototype._getIconUrl;' +
    'L.Icon.Default.mergeOptions({iconUrl:base+"marker-icon.png",' +
    'iconRetinaUrl:base+"marker-icon-2x.png",shadowUrl:base+"marker-shadow.png"});}' +
    'function d2bShowMarkers(){' +
    'obj.setMarker(' + vLat + ',' + vLng + ');' +
    vRoute +
    'setTimeout(function(){obj.map.invalidateSize();},250);' +
    vReq +
    '}' +
    'var d2bIconProbe=new Image();' +
    'd2bIconProbe.onload=function(){d2bMarkerIcons("/css/images/");d2bShowMarkers();};' +
    'd2bIconProbe.onerror=function(){d2bMarkerIcons("https://unpkg.com/leaflet@1.9.4/dist/images/");d2bShowMarkers();};' +
    'd2bIconProbe.src="/css/images/marker-icon.png";' +
    '};' +
    'function d2bLoadCss(href,id){if(document.getElementById(id))return;var c=document.createElement("link");c.id=id;c.rel="stylesheet";c.href=href;document.head.appendChild(c);}' +
    'function d2bLoadJs(src,ok,fail){var s=document.createElement("script");s.src=src;s.onload=ok;s.onerror=fail||function(){};document.head.appendChild(s);}' +
    'function d2bEnsureLeaflet(done){' +
    'if(window.L&&window.L.map){done();return;}' +
    'd2bLoadCss("/css/leaflet.css","d2b-leaflet-css");' +
    'd2bLoadJs("/js/leaflet.js",done,function(){' +
    'd2bLoadCss("https://unpkg.com/leaflet@1.9.4/dist/leaflet.css","d2b-leaflet-css-cdn");' +
    'd2bLoadJs("https://unpkg.com/leaflet@1.9.4/dist/leaflet.js",done,null);' +
    '});' +
    '}' +
    'd2bEnsureLeaflet(d2bMapBoot);' +
    '})();';
end;

constructor TPrismMap.Create(AOwner: TObject);
begin
 inherited;

 FLatitude := -21.176700;
 FLongitude := -47.820800;
 FZoom := 13;
 FHeight := 480;
 FRequestLocation := False;
 FDistanceKm := 0;
 FLocationError := '';
 FRendered := False;
 FHasRoute := False;
 FOriginLocked := False;

 Events.Add(TPrismControlEvent.Create(Self, EventOnMapLocation));
end;

function TPrismMap.ElementId: string;
begin
 Result := AnsiUpperCase(NamePrefix);
end;

procedure TPrismMap.ExecMapJS(const ACall: string);
begin
 if FRendered and Session.Active then
  Session.ExecJS('if(window.D2BMap&&window.D2BMap["' + ElementId + '"])window.D2BMap["' + ElementId + '"].' + ACall + ';', True);
end;

function TPrismMap.GetDistanceKm: Double;
begin
 Result := FDistanceKm;
end;

function TPrismMap.GetDestLatitude: Double;
begin
 Result := FDestLatitude;
end;

function TPrismMap.GetDestLongitude: Double;
begin
 Result := FDestLongitude;
end;

function TPrismMap.GetHasRoute: Boolean;
begin
 Result := FHasRoute;
end;

procedure TPrismMap.LockOrigin;
begin
 FOriginLocked := True;
 ExecMapJS('lockOrigin()');
end;

procedure TPrismMap.ClearRoute;
begin
 FHasRoute := False;
 FOriginLocked := False;
 FDistanceKm := 0;
 ExecMapJS('clearRoute()');
end;

function TPrismMap.GetHeight: Integer;
begin
 Result := FHeight;
end;

function TPrismMap.GetLatitude: Double;
begin
 Result := FLatitude;
end;

function TPrismMap.GetLocationError: string;
begin
 Result := FLocationError;
end;

function TPrismMap.GetLongitude: Double;
begin
 Result := FLongitude;
end;

function TPrismMap.GetOnLocation: TNotifyEvent;
begin
 Result := FOnLocation;
end;

function TPrismMap.GetRequestLocation: Boolean;
begin
 Result := FRequestLocation;
end;

function TPrismMap.GetZoom: Integer;
begin
 Result := FZoom;
end;

function TPrismMap.GetEnableComponentState: Boolean;
begin
 Result := True;
end;

function TPrismMap.IsMap: Boolean;
begin
 Result := True;
end;

procedure TPrismMap.NotifyLocation;
begin
 if Assigned(FOnLocation) then
  FOnLocation(Self);
end;

procedure TPrismMap.ProcessComponentState(const ComponentStateInfo: TJSONObject);
begin
end;

procedure TPrismMap.ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings);
begin
 inherited;

 if Event.EventType <> EventOnMapLocation then
  Exit;

 if Parameters.Values['err'] = '1' then
 begin
  FLocationError := Parameters.Values['msg'];
  NotifyLocation;
  Exit;
 end;

 if Parameters.Values['lat'] <> '' then
 begin
  FLocationError := '';

  if SameText(Parameters.Values['src'], 'dest') then
  begin
   Route(ParseCoord(Parameters.Values['lat'], FDestLatitude), ParseCoord(Parameters.Values['lng'], FDestLongitude));
   NotifyLocation;
   Exit;
  end;

  FLatitude := ParseCoord(Parameters.Values['lat'], FLatitude);
  FLongitude := ParseCoord(Parameters.Values['lng'], FLongitude);

  if FHasRoute then
  begin
   FDistanceKm := MapDistanceKm(FLatitude, FLongitude, FDestLatitude, FDestLongitude);
   ExecMapJS('route(' + MapCoord(FDestLatitude) + ',' + MapCoord(FDestLongitude) + ')');
  end;

  NotifyLocation;
 end;
end;

procedure TPrismMap.ProcessHTML;
var
 vCore: string;
begin
 inherited;

 vCore := HTMLCore;
 if Pos('id="', LowerCase(vCore)) = 0 then
  vCore := Trim(vCore) + ' id="' + ElementId + '"';
 if Pos(' style="', LowerCase(vCore)) = 0 then
  vCore := Trim(vCore) + ' style=""';
 vCore := HTMLAddItemFromStyle(vCore, 'height', IntToStr(FHeight) + 'px');
 vCore := HTMLAddItemFromStyle(vCore, 'width', '100%');
 vCore := HTMLAddItemFromStyle(vCore, 'min-height', IntToStr(FHeight) + 'px');
 vCore := HTMLAddItemFromStyle(vCore, 'background', '#dce6d4');

 HTMLControl := '<div ' + vCore + '></div><script>' + BuildScript + '</script>';
 FRendered := True;
end;

procedure TPrismMap.Route(ALatitude, ALongitude: Double);
begin
 FDestLatitude := ALatitude;
 FDestLongitude := ALongitude;
 FHasRoute := True;
 FDistanceKm := MapDistanceKm(FLatitude, FLongitude, ALatitude, ALongitude);
 ExecMapJS('route(' + MapCoord(ALatitude) + ',' + MapCoord(ALongitude) + ')');
end;

procedure TPrismMap.SetHeight(const Value: Integer);
begin
 if Value > 0 then
  FHeight := Value
 else
  FHeight := 480;
end;

procedure TPrismMap.SetLatitude(const Value: Double);
begin
 FLatitude := Value;
end;

procedure TPrismMap.SetLongitude(const Value: Double);
begin
 FLongitude := Value;
end;

procedure TPrismMap.SetMarker(ALatitude, ALongitude: Double);
begin
 FLatitude := ALatitude;
 FLongitude := ALongitude;
 FLocationError := '';
 ExecMapJS('setMarker(' + MapCoord(ALatitude) + ',' + MapCoord(ALongitude) + ')');
end;

procedure TPrismMap.SetOnLocation(const Value: TNotifyEvent);
begin
 FOnLocation := Value;
end;

procedure TPrismMap.SetRequestLocation(const Value: Boolean);
begin
 FRequestLocation := Value;
 if Value then
  ExecMapJS('requestLocation()');
end;

procedure TPrismMap.SetZoom(const Value: Integer);
begin
 if Value > 0 then
  FZoom := Value
 else
  FZoom := 13;
end;

end.
