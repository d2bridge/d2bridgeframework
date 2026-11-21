# D2Bridge Framework – Utilizando o mORMot2 como motor de servidor

Olá, pessoal!

## Objetivo

Nesta versão da D2Bridge Framework, foi introduzida a possibilidade de utilizar o **mORMot2 como motor para renderização de páginas e comunicação com o navegador**.

É importante destacar que o **Indy não foi removido da framework**. Ele continua disponível e permanece como o **motor padrão da D2Bridge** para comunicação com o servidor.

Para quem deseja utilizar o mORMot2, preparei este pequeno tutorial com as etapas necessárias para configurar o ambiente e habilitar seu uso em um projeto D2Bridge.

O exemplo será feito utilizando o Lazarus, mas os conceitos e as configurações são semelhantes no Delphi.

---

## 1. Preparação do ambiente

### 1.1. Baixar o mORMot2

Acesse o repositório oficial:

[https://github.com/synopse/mormot2](https://github.com/synopse/mormot2)

Você também pode baixar o código-fonte utilizando o Git:

```
git clone https://github.com/synopse/mORMot2.git
```

### 1.2. Baixar os arquivos estáticos do mORMot2

Baixe o pacote de arquivos estáticos pelo link:

[https://synopse.info/files/mormot2static.7z](https://synopse.info/files/mormot2static.7z)

Após o download, descompacte o conteúdo dentro do diretório:

```
..\mORMot2\static
```

**Atenção:** esta etapa é muito importante. Os arquivos estáticos são necessários para o funcionamento correto do mORMot2.

### 1.3. Baixar a D2Bridge Framework

Baixe o código-fonte da D2Bridge Framework:

```
git clone https://github.com/d2bridge/d2bridgeframework.git
```

---

## 2. Instalação do Wizard

### 2.1. Lazarus

1. Abra o Lazarus.
2. Acesse o menu **Package → Open Package File**.
3. Localize e abra o arquivo `D2BridgeFrameworkWizard.lpk`.
4. Clique em **Use → Install**.
5. Aguarde o Lazarus recompilar a IDE e concluir a instalação do pacote.

### 2.2. Delphi

No Delphi, o procedimento é semelhante:

1. Acesse **File → Open**.
2. Navegue até:

```
..\D2Bridge Framework\source\Wizard\Package
```

3. Abra o arquivo `D2BridgeFrameworkWizard.dproj`.
4. Compile e instale o pacote utilizando a opção **Install**.

---

## 3. Configuração do projeto para utilizar o mORMot2

Após instalar o Wizard, é necessário configurar o projeto para que o Lazarus ou Delphi consiga localizar as units e os arquivos do mORMot2.

### 3.1. Configurar os caminhos (Search Paths)

Nas opções do projeto, acesse **Project Options → Paths**.

A D2Bridge já possui os seguintes diretórios configurados:

```
D2Bridge Framework
D2Bridge Framework\Prism
D2Bridge Framework\OthersLCL
```

Agora, adicione os seguintes diretórios do mORMot2:

```
mORMot2\src
mORMot2\src\core
mORMot2\src\net
mORMot2\src\lib
mORMot2\src\crypt
mORMot2\static\x86_64-win64
```

Esses caminhos permitem que o compilador encontre as units e os arquivos necessários para utilizar o mORMot2.

### 3.2. Configurar as diretivas de compilação

Nas opções do projeto, localize **Custom Options** e adicione as seguintes diretivas:

```
-dD2Bridge
-dD2BridgeCustomRestSession
-dFORCE_OPENSSL
-dUSE_MORMOT2
```

Essas diretivas habilitam a compilação da D2Bridge com suporte ao mORMot2.

---

## 4. Ajustes necessários na Unit_D2Bridge_Server_Console

Ao realizar a primeira compilação do projeto, poderá ocorrer um erro na unit `Unit_D2Bridge_Server_Console`.

Isso acontece porque ainda são necessários alguns ajustes manuais para inicializar corretamente o servidor utilizando o mORMot2.

As alterações estão descritas abaixo.

### 4.1. Ajustar a cláusula Uses

No início da unit, ajuste a cláusula `uses` para incluir as units necessárias:

```
uses
  Classes, SysUtils, IniFiles, D2Bridge.DebugUtils,
{$IFDEF MSWINDOWS}
  {$IFDEF HAS_UNIT_SYSTEM_THREADING}
    System.Threading,
  {$ENDIF}
  Windows,
{$ENDIF}
  {$IFDEF USE_MORMOT2}
  Prism.MormotCompat, mormot.core.base,
  {$ENDIF}
  DateUtils;
```

### 4.2. Declarar a variável TLS

Na linha aproximada 365, dentro do método:

```
class procedure TD2BridgeServerConsole.Run;
```

Adicione a variável abaixo na seção `var`:

```
ltyTLSContext: TMormotTlsConfig;
```

### 4.3. Ajustar a configuração SSL/TLS

Na linha aproximada 452, localize a configuração do servidor e ajuste o trecho conforme o exemplo:

```
// Uncomment to Dual Mode force HTTP just in Debug Mode
if IsDebuggerPresent then
  D2BridgeServerController.Prism.Options.SSL := false
else
  D2BridgeServerController.Prism.Options.SSL := false;

D2BridgeServerController.Languages :=
  [TD2BridgeLang.Portuguese];

if D2BridgeServerController.Prism.Options.SSL then
begin
  {$IFNDEF USE_MORMOT2}
    // Cert File
    D2BridgeServerController.Prism.SSLOptions.CertFile := '';

    // Cert Key Domain File
    D2BridgeServerController.Prism.SSLOptions.KeyFile := '';

    // Cert Intermediate (case Lets Encrypt)
    D2BridgeServerController.Prism.SSLOptions.RootCertFile := '';
  {$ELSE}
    ltyTLSContext.Enabled := true;
    ltyTLSContext.CertificateFile := 'localhost.crt';
    ltyTLSContext.PrivateKeyFile := 'localhost.key';
    ltyTLSContext.CACertificatesFile := 'ca.crt';
    ltyTLSContext.PrivateKeyPassword := '';
    ltyTLSContext.IgnoreCertificateErrors := true;

    D2BridgeServerController.Prism.PrismServer.TLSContext :=
      ltyTLSContext;
  {$ENDIF}
end;
```

**Observação:** os arquivos de certificado (`localhost.crt`, `localhost.key` e `ca.crt`) são exemplos para configuração local. Em produção, utilize certificados válidos e configure adequadamente a validação TLS.

---

## 5. Considerações finais

Após realizar essas configurações, o projeto estará preparado para utilizar o mORMot2 como motor de servidor da D2Bridge Framework.

Por enquanto, alguns desses ajustes precisam ser realizados manualmente. **Nas próximas versões, essas configurações serão incorporadas automaticamente ao Wizard**, simplificando o processo de criação e configuração dos projetos.

A ideia é tornar a utilização do mORMot2 cada vez mais transparente, permitindo que o desenvolvedor escolha o mecanismo que deseja utilizar sem precisar realizar ajustes manuais.

Espero que aproveitem essa novidade e que se divirtam explorando as possibilidades!

Fico a disposição no for preciso.

\*\*Obrigado a todos!

