# Bank Statement Modular

Aplicativo Flutter com arquitetura modular para exibição de extratos bancários.

## Configurações

- **Bundle ID**: `me.micheltlutz.bankstatement`
- **Nome do App**: `Bank Statement`
- **Namespace**: `me.micheltlutz.bankstatement`

## Versões

- **Flutter SDK**: 3.38.1
- **Dart SDK**: 3.10.0
- **Min SDK**: 24 (Android 7.0)
- **Target SDK**: 36 (Android 16)
- **Gradle**: 8.9
- **Android Gradle Plugin**: 8.7.0
- **Kotlin**: 2.1.0

## Estrutura do Projeto

```
BankStatementModular/
├── packages/
│   ├── core/           # Package base com interfaces e utilitários
│   ├── network/        # Package de rede HTTP
│   ├── auth/           # Package de autenticação
│   ├── balance/        # Package de saldo
│   └── statement/      # Package de extratos
├── app/                # Aplicativo principal
└── docs/               # Documentação
```

## 🚀 Primeiros Passos (Novos Colaboradores)

Se você é novo no projeto, siga estes passos para configurar seu ambiente de desenvolvimento:

### 1. Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- **Flutter 3.38.1 ou superior** - [Instalar Flutter](https://docs.flutter.dev/get-started/install)
- **Dart 3.10.0 ou superior** (vem com o Flutter)
- **Android Studio** com Android SDK 36
- **Git** (para controle de versão)

### 2. Clonar o Repositório

```bash
git clone <url-do-repositorio>
cd BankStatementModular
```

### 3. Executar Script de Setup

O projeto inclui um script automatizado que configura tudo para você:

**macOS/Linux:**
```bash
./setup.sh
```

**Windows:**
```cmd
setup.bat
```

O script irá:
- ✅ Verificar se Flutter e Dart estão instalados
- ✅ Instalar o Melos (gerenciador de monorepo)
- ✅ Instalar todas as dependências dos packages
- ✅ Verificar análise estática do código
- ✅ Verificar se o projeto compila corretamente

### 4. Configuração Manual (Alternativa)

Se preferir configurar manualmente ou se o script não funcionar:

```bash
# 1. Instalar Melos globalmente
dart pub global activate melos

# 2. Adicionar Melos ao PATH (se necessário)
# macOS/Linux: export PATH="$PATH:$HOME/.pub-cache/bin"
# Windows: Adicionar %USERPROFILE%\AppData\Local\Pub\Cache\bin ao PATH

# 3. Instalar dependências de todos os packages
melos bootstrap

# 4. Verificar se tudo está funcionando
melos analyze
cd app && flutter run
```

### 5. Configurar Firebase (Opcional)

Se você precisar usar recursos do Firebase (Analytics, Crashlytics, etc.):

1. **Obter o arquivo `google-services.json`**:
   - Acesse o [Firebase Console](https://console.firebase.google.com/)
   - Selecione o projeto `bank-statement-ml`
   - Vá em **Configurações do Projeto** (ícone de engrenagem)
   - Na aba **Seus apps**, selecione o app Android
   - Baixe o arquivo `google-services.json`

2. **Colocar o arquivo no local correto**:
   ```
   app/android/app/google-services.json
   ```

3. **Verificar se está funcionando**:
   ```bash
   cd app
   flutter build apk --debug
   ```

> **⚠️ Importante**: O arquivo `google-services.json` contém informações sensíveis e **não está versionado** no repositório (está no `.gitignore`). Cada desenvolvedor deve baixar seu próprio arquivo do Firebase Console.

### 6. Próximos Passos

Após o setup, recomendamos:

1. 📖 Ler a [documentação de arquitetura](docs/ARCHITECTURE.md)
2. 📝 Revisar o [guia de estilo de código](docs/CODE_STYLE_GUIDE.md)
3. 🔧 Configurar seu editor (VS Code ou Android Studio)
4. 🧪 Executar os testes: `melos test`

## Configuração Inicial (Referência)

### Pré-requisitos Detalhados

- Flutter 3.38.1 ou superior
- Dart 3.10.0 ou superior
- Android Studio com SDK 36
- Melos (para gerenciamento do monorepo)

### Instalação Manual

```bash
# Instalar Melos globalmente
dart pub global activate melos

# Instalar dependências de todos os packages
melos bootstrap

# Ou manualmente package por package
cd packages/core && flutter pub get
cd ../network && flutter pub get
cd ../auth && flutter pub get
cd ../balance && flutter pub get
cd ../statement && flutter pub get
cd ../../app && flutter pub get
```

## Executar o App

```bash
cd app
flutter run
```

## Builds

### Debug
```bash
cd app
flutter build apk --debug
```

### Release
```bash
cd app
flutter build apk --release
```

## 🔥 Configuração do Firebase

### Arquivo google-services.json

O projeto usa Firebase para Analytics, Crashlytics e outras funcionalidades. Para configurar:

#### Localização do Arquivo

O arquivo `google-services.json` deve estar localizado em:
```
app/android/app/google-services.json
```

#### Como Obter o Arquivo

1. Acesse o [Firebase Console](https://console.firebase.google.com/)
2. Selecione o projeto: **bank-statement-ml**
3. Vá em **Configurações do Projeto** (ícone de engrenagem no canto superior esquerdo)
4. Na aba **Seus apps**, localize o app Android com package name `me.micheltlutz.bankstatement`
5. Clique em **Baixar google-services.json**
6. Coloque o arquivo em `app/android/app/google-services.json`

#### Verificação

Após colocar o arquivo, verifique se está funcionando:

```bash
cd app
flutter build apk --debug
```

Se o build for bem-sucedido, o Firebase está configurado corretamente.

#### Segurança

- ⚠️ **O arquivo `google-services.json` NÃO está versionado** no repositório (está no `.gitignore`)
- ⚠️ **Cada desenvolvedor deve baixar seu próprio arquivo** do Firebase Console
- ⚠️ **Não compartilhe o arquivo** via email ou mensagens
- ✅ O arquivo é protegido no build de release através de:
  - ProGuard/R8 obfuscation
  - Resource shrinking
  - Network security config

#### Arquivo de Exemplo

Existe um arquivo `google-services-demo.json` na raiz do projeto como referência da estrutura, mas **não use este arquivo** - ele não contém as credenciais reais.

## Segurança

### Firebase Protection

O `google-services.json` é protegido através de:
- ProGuard/R8 obfuscation
- Resource shrinking
- Network security config

### Outras Medidas

- `screen_protector`: Prevenção de captura de tela
- `flutter_security_checker`: Verificação de root/jailbreak
- `flutter_secure_storage`: Armazenamento criptografado de tokens
- Network security config: Apenas conexões HTTPS permitidas

## Scripts Melos

```bash
# Analisar todos os packages
melos analyze

# Testar todos os packages
melos test

# Build isolado por package
melos run build:core
melos run build:network
melos run build:auth
melos run build:balance
melos run build:statement
```

## 📚 Documentação

- [Arquitetura](docs/ARCHITECTURE.md) - Visão geral da arquitetura modular
- [Code Style Guide](docs/CODE_STYLE_GUIDE.md) - Padrões de código e convenções
- [Project Setup](docs/PROJECT_SETUP.md) - Configurações detalhadas do projeto
- [Build Optimization](docs/BUILD_OPTIMIZATION.md) - Otimizações de build
- [ProGuard/R8](docs/PROGUARD_R8.md) - Proteção de código e otimização
- [Troubleshooting](docs/TROUBLESHOOTING.md) - Solução de problemas comuns

## API

Base URL: `https://dev-challenge.micheltlutz.me`

Endpoints:
- `POST /auth/` - Login
- `GET /statements/` - Lista de extratos
- `GET /balance/` - Saldo calculado

