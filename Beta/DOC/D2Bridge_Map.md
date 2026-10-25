# D2Bridge Map

The map runs in the browser. Delphi, Lazarus and Linux share the same units. The server does not read GPS. The browser does, after the user allows it.

Outside `localhost`, the browser requires HTTPS before it shares the location.

## Free use

No provider and no API key. `Route` draws a straight line and fills `DistanceKm`. It does not call an external service.

### Export

```pascal
with D2Bridge.Items.Add do
  Map('DeliveryMap');
```

`Map` returns the item. Keep it when the form needs the map later:

```pascal
FMap := Map('DeliveryMap').PrismMap;
```

### InitControlsD2Bridge

```pascal
if PrismControl.IsMap then
begin
  PrismControl.AsMap.Latitude := -21.1767;
  PrismControl.AsMap.Longitude := -47.8208;
  PrismControl.AsMap.Zoom := 13;
  PrismControl.AsMap.Height := 480;
  PrismControl.AsMap.RequestLocation := True;
  PrismControl.AsMap.OnLocation := MapLocation;
end;
```

| Member | Meaning |
|---|---|
| `Latitude`, `Longitude` | Marker position. Default `-21.1767`, `-47.8208` when the browser does not return a location. |
| `Zoom` | Initial zoom. Default `13`. |
| `Height` | Map height in pixels. Default `480`. |
| `RequestLocation` | When `True`, the browser asks for the current position and moves the marker. Assign `True` again later to ask once more. |
| `OnLocation` | Called when a position arrives, when the user clicks the map, or when the location is denied. |
| `LocationError` | Text set when the browser refuses or cannot read the position. Empty on success. |
| `DistanceKm` | Straight-line distance in kilometres after `Route`. |
| `HasRoute` | `True` after `Route` draws a line. |
| `DestLatitude`, `DestLongitude` | Last destination passed to `Route`. |

### Origin and destination

The map has one origin marker.

1. `RequestLocation` or `SetMarker` places that marker.
2. `LockOrigin` keeps it fixed.
3. The next click on the map is the destination. The map draws the line, adds the destination marker and fills `DistanceKm`.
4. Another click replaces only the destination.
5. `ClearRoute` removes the line, the destination marker and the lock.

```pascal
FMap.SetMarker(Lat, Lng);
FMap.LockOrigin;
```

A click before `LockOrigin` moves the origin marker. It does not draw a route.

`Route(Lat, Lng)` can also be called from code. The line starts at the current marker and ends at the given coordinates.

### Return to the current location

```pascal
FMap.RequestLocation := True;
```

### Files

The page uses `/js/leaflet.js`, `/css/leaflet.css` and `/css/images/marker-icon.png` when those files exist in `wwwroot`. Otherwise the browser loads Leaflet and the marker icon from the public Leaflet address. Tiles come from OpenStreetMap and need a network connection.

## API parameters

Street routing is not active. The console keeps the parameter path commented so the key never reaches the page. An empty key must not call a provider.

```pascal
// D2BridgeServerController.Prism.Options.Map.Provider := 'openrouteservice';
// D2BridgeServerController.Prism.Options.Map.ApiKey := '';
// D2BridgeServerController.Prism.Options.Map.BaseURL := 'https://api.openrouteservice.org';
// D2BridgeServerController.Prism.Options.Map.Profile := 'driving-car';
```

| Parameter | Meaning |
|---|---|
| `Provider` | `openrouteservice` is the open default. `google` and `mapbox` are the paid alternatives. |
| `ApiKey` | Server-side key. Empty means the map stays in free mode. |
| `BaseURL` | Provider endpoint. The default OpenRouteService address is `https://api.openrouteservice.org`. |
| `Profile` | Travel mode sent to the provider, such as `driving-car`, `foot-walking` or `cycling-regular`. |

Do not place the key in the form, in JavaScript or in the HTML. The core asks for origin and destination. The provider stays behind the server.

## Demo

`Beta/Demos/Maps`

- Delphi: open `Maps.dproj`.
- Lazarus and Linux: open `Maps.lpi`. The project already defines `D2BRIDGE`.

The server listens on `http://localhost:8888`. The form has latitude, longitude, **Mark point**, **Clear points** and **Return to location**.
