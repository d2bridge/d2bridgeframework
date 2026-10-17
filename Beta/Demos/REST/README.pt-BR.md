# Demo REST do D2Bridge

English: [README.md](README.md)

Abra `RESTDemo.dproj` no Delphi, execute e aceite a porta padrão (`8888`, salvo outra no `Config.ini`). A página inicial só lista as rotas. As chamadas são feitas com curl ou Postman.

Login de demonstração: usuário `UserD2Bridge`, senha `123456`. Os segredos JWT em `Unit_D2Bridge_Server_Console.pas` valem só para este demo.

Os produtos ficam em memória. Ao reiniciar o servidor voltam Notebook, Mouse e Headset. O exemplo com Firebird está comentado no final de `API.Products.pas`.

## Público

```bash
curl http://127.0.0.1:8888/api/health
curl "http://127.0.0.1:8888/api/ping?message=hello"
```

`/api/ping` sem `message` responde 400.

## Login e sessão

O login usa autenticação Basic:

```bash
curl -u UserD2Bridge:123456 -X POST http://127.0.0.1:8888/api/auth/login
```

O JSON devolve `accessToken` e `refreshToken`.

```bash
curl http://127.0.0.1:8888/api/auth/currentuser -H "Authorization: Bearer ACCESS_TOKEN"
curl -X POST http://127.0.0.1:8888/api/auth/refreshtoken -H "Authorization: Bearer REFRESH_TOKEN"
```

`currentuser` espera o access token. `refreshtoken` espera o refresh token. Token ausente ou inválido responde 401.

## Produtos

Todas as rotas de produto exigem o access token.

```bash
curl http://127.0.0.1:8888/api/products -H "Authorization: Bearer ACCESS_TOKEN"
curl "http://127.0.0.1:8888/api/products?name=mouse&limit=10" -H "Authorization: Bearer ACCESS_TOKEN"
curl http://127.0.0.1:8888/api/products/1 -H "Authorization: Bearer ACCESS_TOKEN"
curl -X POST http://127.0.0.1:8888/api/products -H "Authorization: Bearer ACCESS_TOKEN" -H "Content-Type: application/json" -d "{\"name\":\"Keyboard\",\"price\":150}"
curl -X PUT http://127.0.0.1:8888/api/products/1 -H "Authorization: Bearer ACCESS_TOKEN" -H "Content-Type: application/json" -d "{\"id\":1,\"name\":\"Notebook Pro\",\"price\":4200}"
curl -X DELETE http://127.0.0.1:8888/api/products/2 -H "Authorization: Bearer ACCESS_TOKEN"
```

`limit` não passa de `Prism.Rest.Options.MaxRecord` (50 neste demo). Com `ShowMetadata` ligado, a lista traz um objeto `metadata`.

## Onde olhar no código

| Arquivo | O que mostra |
|---|---|
| `Unit_D2Bridge_Server_Console.pas` | JWT, `MaxRecord`, `ShowMetadata`, `FieldNameLowerCase`, formato de data, `EnableRESTServerExternal` |
| `API.Auth.pas` | Rotas públicas, login, refresh e usuário atual |
| `API.Products.pas` | CRUD, filtro e o caminho comentado de Firebird/FireDAC |
