# D2Bridge Wizard installation

## Why not to use InstallD2BridgeWizard.exe

`InstallD2BridgeWizard.exe` copies a prebuilt BPL from `Wizard\BPL\<IDE version>`. Each folder is valid for **one** Delphi only:

| Folder | Delphi |
|---|---|
| `17.0` | Seattle 10.0 |
| `18.0` | Berlin 10.1 |
| `19.0` | Tokyo 10.2 |
| `20.0` | Rio 10.3 |
| `21.0` | Sydney 10.4 |
| `22.0` | Alexandria 11 |
| `23.0` | Athens 12 |
| `37.0` | Florence 13 |

A BPL built with Sydney does not load in the other IDEs (GUID / incompatible package). Without every Delphi on the same machine, those folders go stale. Installation for this trunk is **the package**, compiled in each developer’s IDE.

Do not use `InstallD2BridgeWizard.exe`.

A short bilingual note also lives in `Wizard\readMe.txt`.

---

## Delphi

1. Close extra IDE instances (keep the one you will install into).
2. Open the package:

   `Wizard\Package\D2BridgeFrameworkWizard.dproj`
3. Platform: **Win32**.
4. **Project → Compile**, then **Install** (or Compile + Install on the package context menu).
5. In **Component → Install Packages**, confirm **D2Bridge Framework Wizard** is listed.
6. In **Tools → Options → Language → Delphi → Library**, add these paths if missing:

   - `...\d2bridgeframework\Beta\D2Bridge Framework`
   - `...\d2bridgeframework\Beta\D2Bridge Framework\Prism`
   - `...\d2bridgeframework\Beta\D2Bridge Framework\Others VCL`

**File → New → Other → D2Bridge Framework** should list the project, forms, and CRUD wizards.

The BPL from that compile is written to `Wizard\BPL\<ProductVersion>\` (Sydney = `21.0`). That updates **only** the IDE you compiled with. Do not copy that BPL into the other version folders.

---

## Lazarus

1. Close Lazarus.
2. Open `Wizard\Package\d2bridgeframeworkwizard.lpk`.
3. **Use → Install** and let the IDE rebuild.

---

## Common issues

| Symptom | What to do |
|---|---|
| GUID error on install | You used the `.exe` or a BPL from another Delphi. Install from the `.dproj` in this IDE. |
| Package missing from New menu | Compile **and** Install on Win32. This is a design-only package. |
| New project cannot find D2Bridge units | Library path incomplete. Add the three folders above. |
| An older wizard was already installed | Remove it under **Install Packages**, then install again from the `.dproj`. |

Portuguese version: [D2Bridge_Wizard_Install.md](D2Bridge_Wizard_Install.md)
