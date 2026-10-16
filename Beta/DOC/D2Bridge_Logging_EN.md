# D2Bridge logging (Prism.Log)

Portuguese version: [D2Bridge_Logging.md](D2Bridge_Logging.md)

## Table of Contents

* [Overview](#overview)
* [How to enable (console)](#how-to-enable-console)
* [Parameters](#parameters)
* [Where the file is written](#where-the-file-is-written)
* [Line types in the log](#line-types-in-the-log)
* [How to read the log (troubleshooting)](#how-to-read-the-log-troubleshooting)
* [What a hang is (and is not)](#what-a-hang-is-and-is-not)
* [Custom logging in your code](#custom-logging-in-your-code)
* [INI](#ini)

---

## Overview

`Prism.Log` only **writes** to disk. Flags live on `Prism.Options` and must be set **before** `StartServer`.

Everything that controls logging (access, exception, security, hang, file mode, and Resource Monitor) is configured in the **console / service / compact** unit, the same way as `DataSetLog`: the Beta Wizard ships the lines **commented out**; uncomment what you need.

Do not use `Config.ini` to turn these on. The `[D2Bridge Log]` section is **no longer read** by the core.

---

## How to enable (console)

Typical file: `Unit_D2Bridge_Server_Console.pas` (or `Unit_D2Bridge_Server_Core.pas` for a Windows service).

In the Beta Wizard the lines are already commented. Uncomment and adjust:

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

Rebuild and restart the server after changing these lines.

You can also set them in `OnBeforeServerStart` of the ServerController, still before `StartServer` runs.

**Production:** keep `LogHang` and `ResourceMonitor` off (commented / `False`) and enable them only for diagnostics. `LogException` / `LogSecurity` are usually left on.

---

## Parameters

| Property | Type | Default | Purpose |
|---|---|---|---|
| `LogAccess` | Boolean | `False` | One line per **new session** (browser opens the app). IP, UserAgent, User, Identity. Not one line per click. |
| `LogException` | Boolean | Windows: `True` when **not** attached to the debugger; otherwise `False` | Framework-caught errors (session, form, component, event, message). |
| `LogSecurity` | Boolean | Same as `LogException` | Blocked IP, blocked user-agent, connection/session limit. |
| `LogHang` | Boolean | `False` | Freeze diagnostics: `BEGIN`/`END` spans, `WaitFor`/`Spin` timeouts, and extra Resource Monitor fields (`OpenSpans`, etc.). |
| `LogFileMode` | `TPrismLogFileMode` | `lfmPerSession` | `lfmDaily` = one file per day (`yyyy_mm_dd.txt`). Otherwise each server start creates a file named with the start timestamp. |
| `PathLogException` | string | `log\` (next to the `.exe`) | Log folder. |
| `ResourceMonitor` | Boolean | `False` | Periodic CPU/RAM/session snapshots in the same log file. |
| `ResourceMonitorIntervalSec` | Integer | `300` | Seconds between snapshots (effective minimum: **15**). |
| `ResourceMonitorTopProcessCount` | Integer | `3` | How many processes to list in TopCPU / TopMemory. |
| `ResourceMonitorCPUAlertPercent` | Integer | `70` | App CPU % that raises the snapshot to `Level = Warning`. Use `0` to disable CPU alerts. |
| `ResourceMonitorMemoryAlertMB` | Integer | `2048` | App Working Set (MB) that raises Warning. Use `0` to disable memory alerts. |

The logger object is created only if at least one of `LogException`, `LogSecurity`, `LogAccess`, `LogHang` is true, **or** the Resource Monitor is enabled. If all stay off, **no file is created**.

`DataSetLog` is independent (dataset debug in the UI); it does not write to the daily log file.

More on the monitor: [D2Bridge_Resource_Monitor_EN.md](D2Bridge_Resource_Monitor_EN.md).

---

## Where the file is written

Default folder: `<folder of the .exe>\log\` (`PathLogException`).

| Mode | File name |
|---|---|
| `lfmDaily` | `log\2026_10_06.txt` |
| `lfmPerSession` (default) | `log\<start date_time>.txt` |

At bootstrap (when Resource Monitor or Hang is on) you should see `Diagnostic = ... | Bootstrap | ...` confirming path and flags.

---

## Line types in the log

Every line starts with the local date/time (`DateTimeToStr(Now)`), then fields separated by ` | `. Empty fields are omitted.

### New session (`LogAccess`)

```
06/10/2026 22:51:25 | New Access | IP = 127.0.0.1 | UserAgent = Mozilla/5.0 (...) | User = anonymous | Identity = main
```

`User` may be empty or `anonymous` before login. `Identity` identifies the session.

### Hang span (`LogHang`)

One pair per request that actually runs work (heartbeat is not logged):

```
06/10/2026 22:53:00 | Identy = main | Form = FormClientes | Component = Crud_DBGrid_Search | Event = OnCellButtonClick | Error = BEGIN
06/10/2026 22:53:00 | Identy = main | Form = FormClientes | Component = Crud_DBGrid_Search | Event = OnCellButtonClick | Error = END elapsedMs=297
```

The field name in the file is `Identy` (framework spelling).  
`Error = BEGIN` / `Error = END elapsedMs=...` are **not errors** — they are request start/end markers.

| Typical `Event` | Meaning |
|---|---|
| `GetHTML` | New session + primary form |
| `GetHTML.Render` | Page Clear/Render |
| `CallBack` | Registered callback |
| `OnClick`, `OnSelect`, `OnLoadJSON`, ... | VCL event from the browser |
| `ThreadProc.SpinTimeout` / `WaitTimeout` | Thread did not finish in ~60 s (possible hang) |

Spans can be **nested** (e.g. grid button opens a tab → `OnChange` inside `OnCellButtonClick`). Both must close with `END`.

### Exception (`LogException` / `Prism.Log`)

```
06/10/2026 17:24:05 | Identy = main | Event = ThreadProc | Error = EAccessViolation: Access violation at address ...
```

Here `Error` holds the real exception message. With Resource Monitor on, the core may append a resource suffix on the same line.

### Security (`LogSecurity`)

```
24/09/2026 18:06:00 | Event = Blocked IP Limit Session | IP = 200.10.1.8 | UserAgent = ... | IPV6 = False
```

| `Event` | Meaning |
|---|---|
| `Blocked BlackList` | IP on the blacklist |
| `Blocked Agent` | User-agent blocked |
| `Blocked IP Limit Conn` | Too many new connections from that IP |
| `Blocked IP Limit Session` | Too many active sessions from that IP |

### Resource Monitor

```
06/10/2026 22:52:01 | Diagnostic = ResourceMonitor | Level = Info | MachineName = DELLNOTEDEUX | Sessions = 1 | ... | AppCPU = 0.09% | AppWorkingSetMB = 45 | OpenSpans = 0 | LastRequestEvent = GetHTML.Render | LastRequestAgeSec = 6 | LastSessionTimerAgeSec = n/a
```

| Field | How to read it |
|---|---|
| `Level` | `Info` or `Warning` (CPU/RAM alert crossed) |
| `Sessions` | Active sessions |
| `AppCPU` / `AppWorkingSetMB` / `AppCommitMB` | App process |
| `OpenSpans` | (with `LogHang`) BEGIN without END still open |
| `LastRequestEvent` / `LastRequestAgeSec` | (Hang) last span and age in seconds |
| `LastSessionTimerAgeSec` | (Hang) age of last session timer; `n/a` = never fired |

The first snapshot after start may show `AppCPU = collecting`.

---

## How to read the log (troubleshooting)

1. Open the file for the day of the incident (`lfmDaily`) or the file whose start time matches that server process.
2. Scan the **marker** after the first ` | `:
   - `New Access` → new session
   - `Identy` + `Error = BEGIN`/`END` → Hang span (normal flow)
   - `Identy` + `Error = E...` → exception
   - `Event = Blocked ...` → security
   - `Diagnostic = ResourceMonitor` → process health (+ Hang fields when enabled)
3. Group by `Identy` to follow one user/session.
4. Read `Event` as the **step** (button, menu, `GetHTML`, `CallBack`).
5. Read `Error` as the **reason** (`BEGIN`/`END elapsedMs=`, exception text, or timeout).
6. On Resource Monitor lines, watch:
   - `Sessions` only going up → sessions not released
   - `OpenSpans` > 0 across several ticks → a request did not return
   - High `LastRequestAgeSec` with `OpenSpans = 0` → idle user, **not** a hang
   - `LastSessionTimerAgeSec` growing forever → session timer stopped
   - `AppWorkingSetMB` only going up → possible leak
   - snapshots **stop** at time T → the process (or the logger) froze at T

Example:

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

Session `main` logged in, opened Customers, edited via the grid (nested spans closed). At idle, `OpenSpans = 0` — healthy.

---

## What a hang is (and is not)

A hang is **not** an exception. The file can look “healthy” until the last successful write.

**Is a hang / suspicious:**
- Span with `BEGIN` and no matching `END`
- `OpenSpans` > 0 across several Resource Monitor ticks
- `ThreadProc.SpinTimeout` or `ThreadProc.WaitTimeout`
- Resource Monitor stops writing at time T

**Is not a hang:**
- `Error = BEGIN` / `END` (normal `LogHang` markers)
- High `elapsedMs` on an `END` (slow work that finished)
- High `LastRequestAgeSec` with `OpenSpans = 0` (idle user)

---

## Custom logging in your code

Core logs do not cover business login, posting a document, or a specific query. For those, call the same logger around the block.

Need a flag that creates `FPrismLog` (e.g. `LogException`) already on.

### Exception in a button / save

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
    ShowMessage('Could not save the order.', True, 4000, mtError);
  end;
end;
```

### Form helper

```pascal
on E: Exception do
  LogHandledException(Sender, E, 'ButtonEntrarClick');
```

### Milestone without an exception (manual BEGIN/END)

```pascal
Session.D2Bridge.Prism.Log(..., 'CarregaGrid', 'BEGIN Open query');
try
  QR_Pedido.Open;
finally
  Session.D2Bridge.Prism.Log(..., 'CarregaGrid', 'END Open query');
end;
```

If `BEGIN` appears and `END` does not, that block hung — the built-in Hang logger will not invent that line for your code.

---

## INI

`Config.ini` remains valid for **port, server name, and database**.  
The `[D2Bridge Log]` section can (and should) be **removed**: the core no longer uses it for Resource Monitor, Hang, or `LogFileMode`.

All log configuration: **console only**, via `Prism.Options`.
