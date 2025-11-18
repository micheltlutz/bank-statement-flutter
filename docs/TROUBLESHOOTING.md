# Guia de Solução de Problemas

## Problema: Emulador Android Offline

Se você receber o erro:
```
Error -2 retrieving device properties for sdk gphone64 x86 64
emulator-5554	offline
```

### Soluções

#### 1. Reiniciar ADB
```bash
adb kill-server
adb start-server
adb devices
```

#### 2. Reiniciar o Emulador
```bash
# No Android Studio, feche o emulador e reabra
# Ou via linha de comando:
flutter emulators --launch Medium_Phone_API_36.1
```

#### 3. Usar Dispositivo Alternativo
Você pode usar outros dispositivos disponíveis:
```bash
# Listar dispositivos
flutter devices

# iPhone/iPad (físicos conectados)
flutter run -d 00008110-0008193226BA201E

# macOS (desktop)
flutter run -d macos

# Chrome (web)
flutter run -d chrome
```

#### 4. Limpar Cache do Android
```bash
# Limpar cache do emulador
rm -rf ~/.android/avd/*/cache/*
```

#### 5. Verificar se o Emulador está totalmente inicializado
Aguarde alguns minutos após iniciar o emulador antes de rodar `flutter run`.

## Problema: No Space Left on Device

Se você receber:
```
No space left on device
```

### Soluções

#### 1. Limpar Cache do Flutter
```bash
flutter clean
rm -rf ~/.flutter/bin/cache
rm -rf ~/.pub-cache
```

#### 2. Limpar Builds
```bash
cd /Users/michel/Developer/BankStatementModular
find . -name "build" -type d -exec rm -rf {} + 2>/dev/null
find . -name ".dart_tool" -type d -exec rm -rf {} + 2>/dev/null
```

#### 3. Limpar Cache do Gradle
```bash
rm -rf ~/.gradle/caches
```

#### 4. Verificar Espaço Disponível
```bash
df -h
```

## Problema: Dependências Não Resolvidas

Se houver erros de dependências:

```bash
# No diretório raiz do projeto
cd /Users/michel/Developer/BankStatementModular

# Instalar dependências de todos os packages
cd packages/core && flutter pub get
cd ../network && flutter pub get
cd ../auth && flutter pub get
cd ../balance && flutter pub get
cd ../statement && flutter pub get
cd ../../app && flutter pub get
```

## Comandos Úteis

```bash
# Verificar dispositivos conectados
flutter devices

# Verificar configuração do Flutter
flutter doctor -v

# Analisar código
flutter analyze

# Limpar projeto
flutter clean

# Verificar espaço em disco
df -h
du -sh ~/.flutter
du -sh ~/.gradle
du -sh ~/.android
```

## Próximos Passos

Se o emulador Android continuar offline:

1. **Use macOS temporariamente**: `flutter run -d macos`
2. **Use Chrome para testes**: `flutter run -d chrome`
3. **Use dispositivo iOS físico**: `flutter run -d [device-id]`
4. **Reinicie o emulador**: Feche e abra novamente no Android Studio

