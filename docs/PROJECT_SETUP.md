# Configuração do Projeto Flutter - Android

Este documento contém todas as versões e configurações utilizadas em um projeto Flutter focado em Android. Use como referência para criar novos projetos.

## 📱 Flutter & Dart

### Versões
- **Flutter SDK**: 3.38.1 (stable channel)
- **Dart SDK**: 3.10.0
- **Flutter Embedding**: 2

### Configuração do Ambiente Dart
```yaml
environment:
  sdk: '>=3.5.0 <4.0.0'
```

### Localização do Flutter SDK
```
/usr/local/share/flutter (macOS/Linux)
C:\src\flutter (Windows - exemplo)
```

---

## 🤖 Android

### Android SDK
- **Android SDK Location**: `~/Library/Android/sdk` (macOS) ou `%LOCALAPPDATA%\Android\Sdk` (Windows)
- **Android SDK Version**: 36.1.0
- **Build Tools**: 36.1.0
- **Platform**: android-36

### Configurações do App
- **Namespace**: `com.meu.app` (substitua pelo seu package)
- **Application ID**: `com.meu.app` (substitua pelo seu package)
- **Min SDK**: 24 (Android 7.0 - Nougat)
- **Target SDK**: 36 (Android 16)
- **Compile SDK**: 36

### Configuração no `build.gradle` (app)
```gradle
android {
    namespace "com.meu.app"
    compileSdk 36
    
    defaultConfig {
        applicationId "com.meu.app"
        minSdk 24
        targetSdk 36
    }
    
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
    
    kotlinOptions {
        jvmTarget = '1.8'
    }
}
```

---

## ☕ Java

### Versão
- **Java Version**: OpenJDK Runtime Environment (build 21.0.8+)
- **Java Binary**: Bundled with Android Studio (JBR - JetBrains Runtime)
- **JDK**: Incluído no Android Studio ou JDK 21 standalone

### Configuração
- **Source Compatibility**: Java 8 (VERSION_1_8)
- **Target Compatibility**: Java 8 (VERSION_1_8)

---

## 🔧 Gradle

### Versões
- **Gradle**: 8.9
- **Android Gradle Plugin (AGP)**: 8.7.0
- **Kotlin Gradle Plugin**: 2.1.0

### Configuração do Gradle Wrapper
**Arquivo**: `android/gradle/wrapper/gradle-wrapper.properties`
```properties
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.9-all.zip
```

### Configuração do `settings.gradle`
```gradle
plugins {
    id "dev.flutter.flutter-plugin-loader"
    id "com.android.application" version "8.7.0" apply false
    id "org.jetbrains.kotlin.android" version "2.1.0" apply false
}
```

### Configuração do `build.gradle` (root)
```gradle
buildscript {
    ext.kotlin_version = '2.1.0'
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:8.7.0'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
}
```

---

## 📦 Kotlin

### Versão
- **Kotlin**: 2.1.0
- **JVM Target**: 1.8

---

## 🎨 Recursos Android

### Estrutura de Recursos
```
android/app/src/main/res/
├── drawable/
│   ├── ic_launcher_foreground.xml
│   └── launch_background.xml
├── mipmap-mdpi/
│   └── ic_launcher.xml
├── mipmap-hdpi/
│   └── ic_launcher.xml
├── mipmap-xhdpi/
│   └── ic_launcher.xml
├── mipmap-xxhdpi/
│   └── ic_launcher.xml
├── mipmap-xxxhdpi/
│   └── ic_launcher.xml
└── values/
    └── styles.xml
```

### Temas
- **LaunchTheme**: Tema aplicado durante o carregamento inicial
- **NormalTheme**: Tema aplicado após o Flutter inicializar

---

## 📋 AndroidManifest.xml

### Permissões Essenciais
```xml
<!-- Permissões básicas (adicione outras conforme necessário) -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

<!-- Exemplo: Permissão NFC (se necessário) -->
<!-- <uses-permission android:name="android.permission.NFC" /> -->
<!-- <uses-feature android:name="android.hardware.nfc" android:required="true" /> -->
```

### Configuração da Activity
```xml
<activity
    android:name=".MainActivity"
    android:exported="true"
    android:launchMode="singleTop"
    android:theme="@style/LaunchTheme"
    android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
    android:hardwareAccelerated="true"
    android:windowSoftInputMode="adjustResize">
</activity>
```

---

## 🔍 Análise de Código

### Linter
- **Flutter Lints**: 6.0.0
- **Arquivo**: `analysis_options.yaml`

### Regras Configuradas
```yaml
linter:
  rules:
    prefer_const_constructors: true
    prefer_const_literals_to_create_immutables: true
    avoid_print: false
```

---

## 📚 Dependências Principais (Exemplos)

### State Management
- `provider: ^6.1.1` - Gerenciamento de estado

### Database
- `sqflite: ^2.3.0` - Banco de dados SQLite
- `path: ^1.9.0` - Manipulação de caminhos
- `shared_preferences: ^2.2.2` - Armazenamento de preferências

### Firebase (Opcional)
- `firebase_core: ^4.2.1` - Core do Firebase
- `firebase_analytics: ^12.0.4` - Analytics
- `firebase_crashlytics: ^5.0.5` - Crashlytics
- `firebase_messaging: ^16.0.4` - Cloud Messaging

### Utilities
- `url_launcher: ^6.2.2` - Abrir URLs
- `share_plus: ^12.0.1` - Compartilhamento
- `clipboard: ^2.0.2` - Área de transferência
- `intl: ^0.20.2` - Internacionalização

### Dev Dependencies
- `flutter_lints: ^6.0.0` - Regras de linting

**Nota**: Adicione apenas as dependências necessárias para seu projeto.

---

## 🚀 Comandos Úteis

### Verificar Versões
```bash
flutter --version
flutter doctor -v
```

### Limpar e Reconstruir
```bash
flutter clean
flutter pub get
flutter build apk --debug
```

### Executar no Emulador/Dispositivo
```bash
flutter run
```

---

## ⚠️ Notas Importantes

1. **Compatibilidade de Versões**:
   - AGP 8.7.0 requer Gradle 8.9+
   - Kotlin 2.1.0 requer AGP 8.6.0+
   - compileSdk 36 requer AGP 8.6.0+

2. **Java Version**:
   - O projeto usa Java 8 para compatibilidade
   - O JDK 21 do Android Studio é usado para compilação

3. **Min SDK 24**:
   - Suporta Android 7.0 (Nougat) e superior
   - ~95% dos dispositivos Android ativos

4. **Recursos Android**:
   - Ícones adaptativos requerem SDK 26+
   - Para minSdk 24, use `<bitmap>` em vez de `<adaptive-icon>`

5. **Flutter Embedding**:
   - Usa Flutter Embedding v2 (padrão desde Flutter 1.12)

---

## 📝 Checklist para Novo Projeto

- [ ] Instalar Flutter 3.38.1 (stable)
- [ ] Configurar Android SDK 36
- [ ] Instalar Android Studio com JDK 21
- [ ] Configurar Gradle 8.9
- [ ] Configurar AGP 8.7.0
- [ ] Configurar Kotlin 2.1.0
- [ ] Definir minSdk 24, targetSdk 36, compileSdk 36
- [ ] Configurar Java 8 compatibility
- [ ] Criar estrutura de recursos (drawable, mipmap, values)
- [ ] Configurar AndroidManifest.xml com permissões necessárias
- [ ] Configurar analysis_options.yaml com flutter_lints 6.0.0
- [ ] Substituir `com.meu.app` pelo package name real do seu projeto
- [ ] Configurar nome do aplicativo no AndroidManifest.xml
- [ ] Criar ícones do aplicativo (ic_launcher)

---

## 📝 Personalização do Projeto

### Substituir Package Name
1. Substitua todas as ocorrências de `com.meu.app` pelo seu package name
2. Arquivos a modificar:
   - `android/app/build.gradle` (namespace e applicationId)
   - `android/app/src/main/AndroidManifest.xml` (se necessário)
   - `android/app/src/main/kotlin/com/meu/app/` (estrutura de pastas)

### Nome do Aplicativo
Edite `android/app/src/main/AndroidManifest.xml`:
```xml
<application
    android:label="Nome do Seu App"
    ...
```

### Ícones do Aplicativo
- Substitua os arquivos em `android/app/src/main/res/mipmap-*/ic_launcher.xml`
- Ou use o pacote `flutter_launcher_icons` para gerar automaticamente

---

**Última atualização**: Novembro 2024
**Template genérico para projetos Flutter Android**

