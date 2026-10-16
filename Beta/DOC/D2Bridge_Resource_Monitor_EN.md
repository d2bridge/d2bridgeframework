# D2Bridge Resource Monitor

Portuguese version: [D2Bridge_Resource_Monitor.md](D2Bridge_Resource_Monitor.md)

Full logging docs (Hang, Access, Exception, Security): [D2Bridge_Logging_EN.md](D2Bridge_Logging_EN.md).

## What it is

D2Bridge telemetry that periodically captures CPU, memory, and sessions and writes to the **same** application log file (`Prism.Log`).

It runs independently from functional logs, but shares the file and, when `LogHang` is on, adds `OpenSpans`, `LastRequestAgeSec`, and `LastSessionTimerAgeSec`.

## How to enable

Only via `Prism.Options` in the console (or service/compact), **before** `StartServer`. The Beta Wizard already ships the lines commented out.

```pascal
D2BridgeServerController.Prism.Options.ResourceMonitor:= true;
D2BridgeServerController.Prism.Options.ResourceMonitorIntervalSec:= 60;
D2BridgeServerController.Prism.Options.ResourceMonitorTopProcessCount:= 3;
D2BridgeServerController.Prism.Options.ResourceMonitorCPUAlertPercent:= 70;
D2BridgeServerController.Prism.Options.ResourceMonitorMemoryAlertMB:= 2048;
D2BridgeServerController.Prism.Options.LogFileMode:= lfmDaily; // recommended
```

Rebuild and restart. **Do not** use `Config.ini` / `[D2Bridge Log]` — the core no longer reads that section for the monitor.

## Parameters

| Property | Type | Default | Purpose |
|---|---|---|---|
| `ResourceMonitor` | Boolean | `False` | Enables/disables the monitor |
| `ResourceMonitorIntervalSec` | Integer | `300` | Seconds between snapshots (effective min. 15) |
| `ResourceMonitorTopProcessCount` | Integer | `3` | Processes in TopCPU / TopMemory |
| `ResourceMonitorCPUAlertPercent` | Integer | `70` | App CPU % → `Level = Warning` (`0` = no alert) |
| `ResourceMonitorMemoryAlertMB` | Integer | `2048` | App Working Set MB → Warning (`0` = no alert) |

## Where it writes

Folder: `<folder of the .exe>\log\` (`PathLogException`).  
With `LogFileMode := lfmDaily`: `log\yyyy_mm_dd.txt`.

The logger is created automatically if the Resource Monitor is on, even when Access/Exception/Security/Hang are off.

At start: `Diagnostic = ResourceMonitor | Bootstrap | LogFile=... | IntervalSec=...`

## Snapshot fields

* **Level** — `Info` or `Warning`
* **MachineName**, **App**, **PID**
* **AppCPU**, **AppWorkingSetMB**, **AppCommitMB**
* **SystemMemoryLoad**, **SystemAvailableMemoryMB**, **SystemTotalPhysicalMemoryMB**
* **Sessions**
* **TopCPU**, **TopMemory**
* With `LogHang`: **OpenSpans**, **LastRequestEvent**, **LastRequestAgeSec**, **LastSessionTimerAgeSec**

On the first interval, `AppCPU` / `TopCPU` may show as `collecting`.

## Notes

* Windows collects native counters; on Linux the module compiles, but Windows process collection does not apply the same way.
* The monitor timer is **independent** from the session timer.
* An initial snapshot is written at the end of `StartServer`, before the first interval.
* In production, use a larger interval (e.g. 300 s) and enable Hang only for diagnostics.
