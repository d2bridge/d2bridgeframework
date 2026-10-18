# D2Bridge Resource Monitor

Versão em inglês: [D2Bridge_Resource_Monitor_EN.md](D2Bridge_Resource_Monitor_EN.md)

Documentação completa de logs (Hang, Access, Exception, Security): [D2Bridge_Logging.md](D2Bridge_Logging.md).

## O que é

Módulo de telemetria do D2Bridge que captura periodicamente CPU, memória e sessões e grava no **mesmo arquivo** de log da aplicação (`Prism.Log`).

Opera de forma independente dos logs funcionais, mas compartilha o arquivo e, com `LogHang` ligado, acrescenta `OpenSpans`, `LastRequestAgeSec` e `LastSessionTimerAgeSec`.

## Como habilitar

Somente via `Prism.Options` no console (ou service/compact), **antes** de `StartServer`. O Wizard Beta já traz as linhas comentadas.

```pascal
D2BridgeServerController.Prism.Options.ResourceMonitor:= true;
D2BridgeServerController.Prism.Options.ResourceMonitorIntervalSec:= 60;
D2BridgeServerController.Prism.Options.ResourceMonitorTopProcessCount:= 3;
D2BridgeServerController.Prism.Options.ResourceMonitorCPUAlertPercent:= 70;
D2BridgeServerController.Prism.Options.ResourceMonitorMemoryAlertMB:= 2048;
D2BridgeServerController.Prism.Options.LogFileMode:= lfmDaily; // recomendado
```

Recompile e reinicie. **Não** use `Config.ini` / `[D2Bridge Log]` — o core não lê mais essa seção para o monitor.

## Parâmetros

| Propriedade | Tipo | Default | Função |
|---|---|---|---|
| `ResourceMonitor` | Boolean | `False` | Liga/desliga o monitor |
| `ResourceMonitorIntervalSec` | Integer | `300` | Intervalo entre snapshots (mín. efetivo 15 s) |
| `ResourceMonitorTopProcessCount` | Integer | `3` | Processos em TopCPU / TopMemory |
| `ResourceMonitorCPUAlertPercent` | Integer | `70` | % CPU do app → `Level = Warning` (`0` = sem alerta) |
| `ResourceMonitorMemoryAlertMB` | Integer | `2048` | Working Set MB do app → Warning (`0` = sem alerta) |

## Onde grava

Pasta: `<pasta do .exe>\log\` (`PathLogException`).  
Com `LogFileMode := lfmDaily`: `log\yyyy_mm_dd.txt`.

O logger é criado automaticamente se o Resource Monitor estiver ligado, mesmo com Access/Exception/Security/Hang desligados.

No start: `Diagnostic = ResourceMonitor | Bootstrap | LogFile=... | IntervalSec=...`

## Campos do snapshot

* **Level** — `Info` ou `Warning`
* **MachineName**, **App**, **PID**
* **AppCPU**, **AppWorkingSetMB**, **AppCommitMB**
* **SystemMemoryLoad**, **SystemAvailableMemoryMB**, **SystemTotalPhysicalMemoryMB**
* **Sessions**
* **TopCPU**, **TopMemory**
* Com `LogHang`: **OpenSpans**, **LastRequestEvent**, **LastRequestAgeSec**, **LastSessionTimerAgeSec**

No primeiro intervalo, `AppCPU` / `TopCPU` podem aparecer como `collecting`.

## Notas

* Windows coleta contadores nativos; em Linux o módulo compila, mas a coleta de processos Windows não se aplica da mesma forma.
* O timer do monitor é **independente** do timer de sessão.
* Um snapshot inicial é gerado no fim do `StartServer`, antes do primeiro intervalo.
* Em produção, use intervalo maior (ex.: 300 s) e ligue Hang só em diagnóstico.
