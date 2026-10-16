# Instalação do D2Bridge Wizard

Versão em inglês: [D2Bridge_Wizard_Install_EN.md](D2Bridge_Wizard_Install_EN.md)

Há um resumo bilíngue em `Wizard\readMe.txt`.

## Por que não usar o InstallD2BridgeWizard.exe

O `InstallD2BridgeWizard.exe` copia uma BPL pré-compilada de `Wizard\BPL\<versão da IDE>`. Cada pasta só é válida para **uma** Delphi:

| Pasta | Delphi |
|---|---|
| `17.0` | Seattle 10.0 |
| `18.0` | Berlin 10.1 |
| `19.0` | Tokyo 10.2 |
| `20.0` | Rio 10.3 |
| `21.0` | Sydney 10.4 |
| `22.0` | Alexandria 11 |
| `23.0` | Athens 12 |
| `37.0` | Florence 13 |

A BPL gerada no Sydney não funciona nas outras IDEs (erro de GUID / pacote incompatível). Sem todas as Delphis no mesmo ambiente, essas pastas ficam desatualizadas. Por isso a instalação oficial deste trunk é **pelo pacote**, compilado na Delphi de cada desenvolvedor.

Não use o `InstallD2BridgeWizard.exe`.

---

## Delphi

1. Feche as instâncias extras da IDE (deixe só aquela em que vai instalar).
2. Abra o pacote:

   `Wizard\Package\D2BridgeFrameworkWizard.dproj`
3. Plataforma: **Win32**.
4. Menu **Project → Compile**, depois **Install** (ou Compile + Install no menu de contexto do pacote).
5. Confira em **Component → Install Packages** se aparece **D2Bridge Framework Wizard**.
6. Em **Tools → Options → Language → Delphi → Library**, inclua (se ainda não estiver):

   - `...\d2bridgeframework\Beta\D2Bridge Framework`
   - `...\d2bridgeframework\Beta\D2Bridge Framework\Prism`
   - `...\d2bridgeframework\Beta\D2Bridge Framework\Others VCL`

O menu **File → New → Other → D2Bridge Framework** deve listar o projeto, forms e CRUD.

A BPL dessa compilação fica em `Wizard\BPL\<ProductVersion>\` (Sydney = `21.0`). Isso atualiza **só** a pasta da IDE que compilou. Não copie essa BPL para as outras pastas.

---

## Lazarus

1. Feche o Lazarus.
2. Abra `Wizard\Package\d2bridgeframeworkwizard.lpk`.
3. **Use → Install** e deixe o IDE rebuildar.

---

## Problemas comuns

| Sintoma | O que fazer |
|---|---|
| Erro de GUID ao instalar | Você usou o `.exe` ou uma BPL de outra Delphi. Instale pelo `.dproj` desta IDE. |
| Pacote não aparece no menu New | Compile **e** Install no Win32. Pacote é design-only. |
| Projeto novo não acha units do D2Bridge | Library path incompleto. Inclua as três pastas acima. |
| Já havia um wizard antigo | Remova o pacote velho em **Install Packages**, depois instale de novo pelo `.dproj`. |
