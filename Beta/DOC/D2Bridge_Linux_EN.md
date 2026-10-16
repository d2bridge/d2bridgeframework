# Running D2Bridge on Linux

## Table of Contents

* [Overview](#overview)
* [Why these packages](#why-these-packages)
* [Server packages](#server-packages)
* [Deploy the application](#deploy-the-application)
* [Run the project](#run-the-project)
* [Usage notes](#usage-notes)
* [Run in the background](#run-in-the-background)
* [Troubleshooting](#troubleshooting)

---

## Overview

A D2Bridge Web App compiled for Linux still uses the VCL/LCL widget set. On a typical server there is no monitor and no desktop session, so the process needs:

* **GTK 2** — native UI libraries used by the Linux binary
* **Xvfb** (X Virtual Framebuffer) — a virtual display so the app can start without a physical screen

Install the packages on the server, copy the compiled binary, then start it with `xvfb-run`.

Replace `D2BrigdeProject` in the examples with the name of your compiled executable.

---

## Why these packages

| Package | Role |
|---|---|
| `libgtk2.0-0` | GTK 2 runtime. Required by the D2Bridge Linux binary. Without it the process fails on missing `.so` libraries. |
| `xvfb` | Virtual X server. Required on headless hosts (cloud VM, Docker, CI). Without it the app exits because `DISPLAY` is not set. |

You do not need a full desktop environment (GNOME, KDE, etc.).

---

## Server packages

On Debian / Ubuntu (or compatible), as root or with `sudo`:

```bash
sudo apt install libgtk2.0-0
apt install xvfb -y
```

If you are not already root, use `sudo` on both lines:

```bash
sudo apt install libgtk2.0-0
sudo apt install xvfb -y
```

Confirm the tools are available:

```bash
dpkg -l libgtk2.0-0 xvfb
which xvfb-run
```

---

## Deploy the application

1. Compile the D2Bridge project for Linux (Lazarus or the Delphi Linux target you use).
2. Copy to the server:
   * the executable (`D2BrigdeProject` in this document)
   * the `www` (or equivalent) folder with HTML, CSS, JS, and images
   * any `.ini`, language, or certificate files the app reads from its working directory
3. Make the binary executable:

```bash
chmod +x ./D2BrigdeProject
```

Run the command from the folder that contains the executable and its web assets. D2Bridge resolves templates and static files relative to the current working directory.

---

## Run the project

```bash
xvfb-run ./D2BrigdeProject
```

`xvfb-run` starts a temporary X display, launches the process, and keeps that display alive while the app is running.

Open the browser at the host and port configured in the project (for example `http://SERVER_IP:8888`).

---

## Usage notes

* Always start the app with `xvfb-run` on a machine without a graphical session. Calling `./D2BrigdeProject` alone usually fails with a display / GTK error.
* Keep the terminal (or service) attached to the process. Closing it stops the web server.
* If the binary is not in the current directory, pass the full path:

```bash
xvfb-run /opt/d2bridge/D2BrigdeProject
```

* Optional extra screen size (useful if a form expects a minimum resolution):

```bash
xvfb-run --server-args="-screen 0 1280x720x24" ./D2BrigdeProject
```

* To reuse a fixed display instead of `xvfb-run`:

```bash
Xvfb :99 -screen 0 1280x720x24 &
export DISPLAY=:99
./D2BrigdeProject
```

---

## Run in the background

Example with `nohup` (logs go to `d2bridge.out`):

```bash
nohup xvfb-run ./D2BrigdeProject > d2bridge.out 2>&1 &
```

Example `systemd` unit (`/etc/systemd/system/d2bridge.service`). Adjust `User`, `WorkingDirectory`, and the executable name:

```ini
[Unit]
Description=D2Bridge Web Application
After=network.target

[Service]
Type=simple
User=www-data
WorkingDirectory=/opt/d2bridge
ExecStart=/usr/bin/xvfb-run /opt/d2bridge/D2BrigdeProject
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now d2bridge
```

---

## Troubleshooting

| Symptom | What to check |
|---|---|
| `error while loading shared libraries: libgtk-x11-2.0.so.0` | `libgtk2.0-0` is missing. Install it and retry. |
| `cannot open display` / GTK abort | The process was started without `xvfb-run` (or without `DISPLAY`). |
| Port already in use | Another instance is running. `ss -lptn` or `ps aux \| grep D2BrigdeProject`. |
| Page opens but static files 404 | Working directory is wrong. Start the app from the folder that contains `www`. |
| Permission denied | `chmod +x ./D2BrigdeProject` and confirm the user can read the asset folders. |
