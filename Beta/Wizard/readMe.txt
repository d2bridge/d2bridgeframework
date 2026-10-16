================================================================================
D2Bridge Wizard - Installation / Instalacao
================================================================================

Do NOT use InstallD2BridgeWizard.exe
Nao use o InstallD2BridgeWizard.exe

That installer copies a prebuilt BPL from Wizard\BPL\<IDE version>.
Each BPL works only with the Delphi that compiled it. An outdated BPL
causes a GUID / incompatible package error.
O instalador copia uma BPL pre-compilada de Wizard\BPL\<versao da IDE>.
Cada BPL so funciona na Delphi que a compilou. BPL desatualizada gera
erro de GUID / pacote incompativel.

Install the package in YOUR IDE instead.
Instale o pacote na SUA IDE.

--------------------------------------------------------------------------------
ENGLISH
--------------------------------------------------------------------------------

Delphi
1. Close extra IDE instances.
2. Open:  Wizard\Package\D2BridgeFrameworkWizard.dproj
3. Platform: Win32
4. Project -> Compile, then Install
5. Check Component -> Install Packages for "D2Bridge Framework Wizard"
6. Add these folders to Tools -> Options -> Language -> Delphi -> Library
   if they are missing:
   - ..\d2bridgeframework\Beta\D2Bridge Framework
   - ..\d2bridgeframework\Beta\D2Bridge Framework\Prism
   - ..\d2bridgeframework\Beta\D2Bridge Framework\Others VCL

Lazarus
1. Close Lazarus.
2. Open:  Wizard\Package\d2bridgeframeworkwizard.lpk
3. Use -> Install and let the IDE rebuild.

BPL folders (do not copy a BPL from one folder to another)
  17.0  Seattle 10.0
  18.0  Berlin 10.1
  19.0  Tokyo 10.2
  20.0  Rio 10.3
  21.0  Sydney 10.4
  22.0  Alexandria 11
  23.0  Athens 12
  37.0  Florence 13

The BPL from this compile goes to Wizard\BPL\<ProductVersion> (Sydney = 21.0)
and updates ONLY that IDE.

If you get a GUID error: you used the .exe or a BPL from another Delphi.
Install again from the .dproj / .lpk in this IDE.

Longer guide: ..\DOC\D2Bridge_Wizard_Install_EN.md

--------------------------------------------------------------------------------
PORTUGUES
--------------------------------------------------------------------------------

Delphi
1. Feche instancias extras da IDE.
2. Abra:  Wizard\Package\D2BridgeFrameworkWizard.dproj
3. Plataforma: Win32
4. Project -> Compile e depois Install
5. Em Component -> Install Packages deve aparecer "D2Bridge Framework Wizard"
6. Em Tools -> Options -> Language -> Delphi -> Library, inclua se faltar:
   - ..\d2bridgeframework\Beta\D2Bridge Framework
   - ..\d2bridgeframework\Beta\D2Bridge Framework\Prism
   - ..\d2bridgeframework\Beta\D2Bridge Framework\Others VCL

Lazarus
1. Feche o Lazarus.
2. Abra:  Wizard\Package\d2bridgeframeworkwizard.lpk
3. Use -> Install e deixe o IDE rebuildar.

Pastas BPL (nao copie BPL de uma pasta para outra)
  17.0  Seattle 10.0
  18.0  Berlin 10.1
  19.0  Tokyo 10.2
  20.0  Rio 10.3
  21.0  Sydney 10.4
  22.0  Alexandria 11
  23.0  Athens 12
  37.0  Florence 13

A BPL desta compilacao vai para Wizard\BPL\<ProductVersion> (Sydney = 21.0)
e atualiza SOMENTE essa IDE.

Erro de GUID: voce usou o .exe ou uma BPL de outra Delphi.
Instale de novo pelo .dproj / .lpk nesta IDE.

Guia completo: ..\DOC\D2Bridge_Wizard_Install.md

================================================================================
