# D2Bridge REST Demo

Portuguese: [README.pt-BR.md](README.pt-BR.md)

Open `RESTDemo.dproj` in Delphi, run it, and accept the default port (`8888` unless `Config.ini` says otherwise). The home page only lists the routes. Call them with curl or Postman.

Demo login: user `UserD2Bridge`, password `123456`. The JWT secrets in `Unit_D2Bridge_Server_Console.pas` are for this demo only.

Products live in memory. Restarting the server restores Notebook, Mouse and Headset. A commented Firebird example is at the bottom of `API.Products.pas`.

The **Endpoint data** button opens a second page. It calls `http://127.0.0.1:8888/produtos` with `GET/POST/PUT/DELETE`. The URL and the expected JSON are at the top of `Unit_GetEP.pas`. If that call fails, the page shows the error and the local `/api` routes keep working.

## Public

```bash
curl http://127.0.0.1:8888/api/health
curl "http://127.0.0.1:8888/api/ping?message=hello"
```

`/api/ping` without `message` returns 400.

## Login and session

Send HTTP Basic credentials on login:

```bash
curl -u UserD2Bridge:123456 -X POST http://127.0.0.1:8888/api/auth/login
```

The JSON returns `accessToken` and `refreshToken`.

```bash
curl http://127.0.0.1:8888/api/auth/currentuser -H "Authorization: Bearer ACCESS_TOKEN"
curl -X POST http://127.0.0.1:8888/api/auth/refreshtoken -H "Authorization: Bearer REFRESH_TOKEN"
```

`currentuser` expects the access token. `refreshtoken` expects the refresh token. A missing or wrong token returns 401.

## Products

Every product route requires the access token.

```bash
curl http://127.0.0.1:8888/api/products -H "Authorization: Bearer ACCESS_TOKEN"
curl "http://127.0.0.1:8888/api/products?name=mouse&limit=10" -H "Authorization: Bearer ACCESS_TOKEN"
curl http://127.0.0.1:8888/api/products/1 -H "Authorization: Bearer ACCESS_TOKEN"
curl -X POST http://127.0.0.1:8888/api/products -H "Authorization: Bearer ACCESS_TOKEN" -H "Content-Type: application/json" -d "{\"name\":\"Keyboard\",\"price\":150}"
curl -X PUT http://127.0.0.1:8888/api/products/1 -H "Authorization: Bearer ACCESS_TOKEN" -H "Content-Type: application/json" -d "{\"id\":1,\"name\":\"Notebook Pro\",\"price\":4200}"
curl -X DELETE http://127.0.0.1:8888/api/products/2 -H "Authorization: Bearer ACCESS_TOKEN"
```

`limit` cannot go above `Prism.Rest.Options.MaxRecord` (50 in this demo). With `ShowMetadata` on, the list includes a `metadata` object.

## Where to look in code

| File | What it shows |
|---|---|
| `Unit_D2Bridge_Server_Console.pas` | JWT, `MaxRecord`, `ShowMetadata`, `FieldNameLowerCase`, date format, `EnableRESTServerExternal` |
| `API.Auth.pas` | Public routes, login, refresh, current user |
| `API.Products.pas` | CRUD, query filter, and the commented Firebird/FireDAC path |
