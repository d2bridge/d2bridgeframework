# Logs do D2Bridge (Prism.Log)

Versão em inglês: [D2Bridge_Logging_EN.md](D2Bridge_Logging_EN.md)

## Sumário

* [Visão geral](#visão-geral)
* [Como habilitar (console)](#como-habilitar-console)
* [Parâmetros](#parâmetros)
* [Onde o arquivo é gravado](#onde-o-arquivo-é-gravado)
* [Tipos de linha no log](#tipos-de-linha-no-log)
* [Como ler o log (rastreio)](#como-ler-o-log-rastreio)
* [O que é (e não é) um hang](#o-que-é-e-não-é-um-hang)
* [Log customizado no seu código](#log-customizado-no-seu-código)
* [INI](#ini)

---

## Visão geral

`Prism.Log` **apenas grava** em disco. Os flags ficam em `Prism.Options` e devem ser definidos **antes** de `StartServer`.

Tudo que controla log (acesso, exceção, segurança, hang, modo de arquivo e Resource Monitor) é configurado **no console / service / compact**, no mesmo estilo de `DataSetLog`: o Wizard Beta gera as linhas **comentadas**; o desenvolvedor descomenta o que quiser.

Não use o `Config.ini` para ligar esses itens. A seção `[D2Bridge Log]` **não é mais lida** pelo core.

---

## Como habilitar (console)

Arquivo típico: `Unit_D2Bridge_Server_Console.pas` (ou `Unit_D2Bridge_Server_Core.pas` no serviço).

No Wizard Beta as linhas já vêm comentadas. Descomente e ajuste:

```pascal
//D2BridgeServerController.Prism.Options.DataSetLog:= true;
D2BridgeServerController.Prism.Options.LogAccess:= true;
D2BridgeServerController.Prism.Options.LogException:= true;
D2BridgeServerController.Prism.Options.LogSecurity:= true;
D2BridgeServerController.Prism.Options.LogHang:= true;
D2BridgeServerController.Prism.Options.LogFileMode:= lfmDaily;
D2BridgeServerController.Prism.Options.ResourceMonitor:= true;
D2BridgeServerController.Prism.Options.ResourceMonitorIntervalSec:= 60;
D2BridgeServerController.Prism.Options.ResourceMonitorTopProcessCount:= 3;
D2BridgeServerController.Prism.Options.ResourceMonitorCPUAlertPercent:= 70;
D2BridgeServerController.Prism.Options.ResourceMonitorMemoryAlertMB:= 2048;
```

Recompile e reinicie o servidor após alterar.

Também pode setar em `OnBeforeServerStart` do ServerController, ainda **antes** de `StartServer`.

**Produção:** deixe `LogHang` e `ResourceMonitor` desligados (comentados / `False`) e ligue só para diagnóstico. `LogException` / `LogSecurity` costumam ficar ligados.

---

## Parâmetros

| Propriedade | Tipo | Default | Função |
|---|---|---|---|
| `LogAccess` | Boolean | `False` | Uma linha por **nova sessão** (browser abre o app). IP, UserAgent, User, Identity. Não é um log por clique. |
| `LogException` | Boolean | Windows: `True` se **não** estiver no debugger; senão `False` | Erros capturados pelo framework (sessão, form, componente, evento, mensagem). |
| `LogSecurity` | Boolean | Igual ao `LogException` | IP bloqueado, user-agent bloqueado, limite de conexão/sessão. |
| `LogHang` | Boolean | `False` | Diagnóstico de travamento: spans `BEGIN`/`END`, timeouts de `WaitFor`/`Spin`, e campos extras no Resource Monitor (`OpenSpans`, etc.). |
| `LogFileMode` | `TPrismLogFileMode` | `lfmPerSession` | `lfmDaily` = um arquivo por dia (`yyyy_mm_dd.txt`). Sem isso, cada start gera arquivo com data/hora de início. |
| `PathLogException` | string | `log\` (ao lado do `.exe`) | Pasta dos arquivos de log. |
| `ResourceMonitor` | Boolean | `False` | Liga snapshots periódicos de CPU/RAM/sessões no mesmo arquivo de log. |
| `ResourceMonitorIntervalSec` | Integer | `300` | Intervalo entre snapshots (mínimo efetivo: **15** s). |
| `ResourceMonitorTopProcessCount` | Integer | `3` | Quantos processos listar em TopCPU / TopMemory. |
| `ResourceMonitorCPUAlertPercent` | Integer | `70` | % de CPU do app que eleva o snapshot para `Level = Warning`. Use `0` para desligar alerta de CPU. |
| `ResourceMonitorMemoryAlertMB` | Integer | `2048` | Working Set (MB) do app que eleva para Warning. Use `0` para desligar alerta de memória. |

O objeto de log só é criado se pelo menos um de `LogException`, `LogSecurity`, `LogAccess`, `LogHang` estiver ligado **ou** o Resource Monitor estiver habilitado. Se tudo ficar off, **nenhum arquivo é criado**.

`DataSetLog` é independente (debug de dataset na UI); não grava no arquivo de log diário.

Detalhes extras do monitor: [D2Bridge_Resource_Monitor.md](D2Bridge_Resource_Monitor.md).

---

## Onde o arquivo é gravado

Pasta padrão: `<pasta do .exe>\log\` (`PathLogException`).

| Modo | Nome do arquivo |
|---|---|
| `lfmDaily` | `log\2026_10_06.txt` |
| `lfmPerSession` (default) | `log\<data_hora_do_start>.txt` |

No bootstrap (com Resource Monitor ou Hang ligados) aparecem linhas `Diagnostic = ... | Bootstrap | ...` confirmando caminho e flags.

---

## Tipos de linha no log

Toda linha começa com data/hora local (`DateTimeToStr(Now)`), depois campos separados por ` | `. Campos vazios são omitidos.

### Nova sessão (`LogAccess`)

```
06/10/2026 22:51:25 | New Access | IP = 127.0.0.1 | UserAgent = Mozilla/5.0 (...) | User = anonymous | Identity = main
```

`User` pode estar vazio ou `anonymous` antes do login. `Identity` identifica a sessão.

### Hang span (`LogHang`)

Um par por request que executa trabalho (heartbeat não gera span):

```
06/10/2026 22:53:00 | Identy = main | Form = FormClientes | Component = Crud_DBGrid_Search | Event = OnCellButtonClick | Error = BEGIN
06/10/2026 22:53:00 | Identy = main | Form = FormClientes | Component = Crud_DBGrid_Search | Event = OnCellButtonClick | Error = END elapsedMs=297
```

O campo no arquivo chama-se `Identy` (grafia do framework).  
`Error = BEGIN` / `Error = END elapsedMs=...` **não são erros** — são marcadores de início/fim do request.

| `Event` típico | Significado |
|---|---|
| `GetHTML` | Nova sessão + form primário |
| `GetHTML.Render` | Clear/Render da página |
| `CallBack` | Callback registrado |
| `OnClick`, `OnSelect`, `OnLoadJSON`, ... | Evento VCL disparado pelo browser |
| `ThreadProc.SpinTimeout` / `WaitTimeout` | Thread não terminou em ~60 s (possível travamento) |

Spans podem ser **aninhados** (ex.: botão da grid abre aba → `OnChange` dentro de `OnCellButtonClick`). Ambos devem fechar com `END`.

### Exceção (`LogException` / `Prism.Log`)

```
06/10/2026 17:24:05 | Identy = main | Event = ThreadProc | Error = EAccessViolation: Access violation at address ...
```

Aqui `Error` traz a mensagem real da exception. Com Resource Monitor ligado, o core pode anexar um sufixo de recursos na mesma linha.

### Segurança (`LogSecurity`)

```
24/09/2026 18:06:00 | Event = Blocked IP Limit Session | IP = 200.10.1.8 | UserAgent = ... | IPV6 = False
```

| `Event` | Significado |
|---|---|
| `Blocked BlackList` | IP na blacklist |
| `Blocked Agent` | User-agent bloqueado |
| `Blocked IP Limit Conn` | Muitas conexões novas daquele IP |
| `Blocked IP Limit Session` | Muitas sessões ativas daquele IP |

### Resource Monitor

```
06/10/2026 22:52:01 | Diagnostic = ResourceMonitor | Level = Info | MachineName = DELLNOTEDEUX | Sessions = 1 | ... | AppCPU = 0.09% | AppWorkingSetMB = 45 | OpenSpans = 0 | LastRequestEvent = GetHTML.Render | LastRequestAgeSec = 6 | LastSessionTimerAgeSec = n/a
```

| Campo | Como ler |
|---|---|
| `Level` | `Info` ou `Warning` (cruzou alerta de CPU/RAM) |
| `Sessions` | Sessões ativas |
| `AppCPU` / `AppWorkingSetMB` / `AppCommitMB` | Processo do app |
| `OpenSpans` | (só com `LogHang`) BEGIN sem END ainda abertos |
| `LastRequestEvent` / `LastRequestAgeSec` | (Hang) último span e idade em segundos |
| `LastSessionTimerAgeSec` | (Hang) idade do último timer de sessão; `n/a` = ainda não rodou |

Primeiro snapshot após o start pode mostrar `AppCPU = collecting`.

---

## Como ler o log (rastreio)

1. Abra o arquivo do dia do incidente (`lfmDaily`) ou o arquivo cujo horário de start bate com aquele processo.
2. Identifique o **marcador** após o primeiro ` | `:
   - `New Access` → sessão nova
   - `Identy` + `Error = BEGIN`/`END` → span Hang (fluxo normal)
   - `Identy` + `Error = E...` → exception
   - `Event = Blocked ...` → segurança
   - `Diagnostic = ResourceMonitor` → saúde do processo (+ campos Hang se ligados)
3. Agrupe por `Identy` para seguir um usuário/sessão.
4. Leia `Event` como a **etapa** (botão, menu, `GetHTML`, `CallBack`).
5. Leia `Error` como o **motivo** (`BEGIN`/`END elapsedMs=`, texto de exception, ou timeout).
6. Nos snapshots do Resource Monitor, observe:
   - `Sessions` só sobe → sessões não liberadas
   - `OpenSpans` > 0 em vários ticks → request não retornou
   - `LastRequestAgeSec` alto com `OpenSpans = 0` → idle (usuário parado), **não** hang
   - `LastSessionTimerAgeSec` crescendo sem parar → timer de sessão parado
   - `AppWorkingSetMB` só sobe → possível vazamento
   - snapshots **param** no horário T → processo (ou logger) congelou em T

Exemplo:

```
22:51:25 | New Access | Identity = main
22:51:54 | Form = Form_Login | Event = OnClick | Error = BEGIN
22:51:55 | Form = Form_Login | Event = OnClick | Error = END elapsedMs=609
22:53:00 | Form = FormClientes | Event = OnCellButtonClick | Error = BEGIN
22:53:00 | Form = FormClientes | Event = OnChange | Error = BEGIN
22:53:00 | Form = FormClientes | Event = OnChange | Error = END elapsedMs=0
22:53:00 | Form = FormClientes | Event = OnCellButtonClick | Error = END elapsedMs=297
22:54:01 | Diagnostic = ResourceMonitor | OpenSpans = 0 | LastRequestAgeSec = 5
```

Sessão `main` logou, abriu Clientes, editou pela grid (nested spans fechados). Em idle, `OpenSpans = 0` — saudável.

---

## O que é (e não é) um hang

Um hang **não** é uma exception. O arquivo pode parecer “saudável” até a última gravação bem-sucedida.

**É hang / suspeito:**
- Span com `BEGIN` e sem `END` correspondente
- `OpenSpans` > 0 em vários Resource Monitors seguidos
- `ThreadProc.SpinTimeout` ou `ThreadProc.WaitTimeout`
- Resource Monitor para de escrever no horário T

**Não é hang:**
- `Error = BEGIN` / `END` (marcadores normais do `LogHang`)
- `elapsedMs` alto em um `END` (operação lenta, mas concluiu)
- `LastRequestAgeSec` alto com `OpenSpans = 0` (usuário idle)

---

## Log customizado no seu código

O core não cobre login de negócio, gravação de documento ou query específica. Para isso, chame o mesmo logger em volta do bloco.

É preciso ter algum flag que crie `FPrismLog` (ex.: `LogException`) já ligado.

### Exception em botão / save

```pascal
try
  GravaPedido;
except
  on E: Exception do
  begin
    Session.D2Bridge.Prism.Log(
      Session.InfoConnection.Identity,
      Name,
      'ButtonGravar',
      'ButtonGravarClick',
      E.ClassName + ': ' + E.Message
    );
    ShowMessage('Não foi possível gravar o pedido.', True, 4000, mtError);
  end;
end;
```

### Helper do form

```pascal
on E: Exception do
  LogHandledException(Sender, E, 'ButtonEntrarClick');
```

### Marco sem exception (BEGIN/END manual)

```pascal
Session.D2Bridge.Prism.Log(..., 'CarregaGrid', 'BEGIN Open query');
try
  QR_Pedido.Open;
finally
  Session.D2Bridge.Prism.Log(..., 'CarregaGrid', 'END Open query');
end;
```

Se aparecer `BEGIN` e não `END`, aquele bloco travou — o logger embutido do Hang **não** inventa essa linha para o seu código.

---

## INI

O `Config.ini` continua válido para **porta, nome do servidor e banco**.  
A seção `[D2Bridge Log]` pode (e deve) ser **removida**: o core não a usa mais para Resource Monitor, Hang nem `LogFileMode`.

Toda configuração de log: **somente no console**, via `Prism.Options`.
