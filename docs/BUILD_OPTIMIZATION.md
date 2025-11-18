# Estratégias de Build Otimizado

## Builds Incrementais por Módulo

### 1. Core Package
- Compilado uma vez, reutilizado por todos
- Cache compartilhado entre todos os módulos dependentes
- Alterações raras, alto impacto de cache

### 2. Network Package
- Recompilado apenas quando `core` ou `network` mudarem
- Cache persistente entre compilações

### 3. Auth/Balance/Statement Packages
- Recompilados apenas quando suas dependências diretas mudarem
- Compilação isolada evita rebuilds desnecessários

### 4. App
- Compilado apenas quando qualquer módulo usado mudar
- Build final agrega todos os packages

## Uso do Melos

### Scripts Disponíveis

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

# Validar dependências
melos run validate:dependencies
```

## Path Dependencies

Todos os packages usam `path: ../package_name`, permitindo:
- Resolução incremental pelo Flutter
- Hot reload funcionando por módulo
- Não requer publicação no pub.dev

## CI/CD

Os módulos podem ser testados em paralelo:

```yaml
# Exemplo de pipeline
- name: Test Core
  run: melos run build:core

- name: Test Network
  run: melos run build:network

- name: Test Auth
  run: melos run build:auth

- name: Test Balance
  run: melos run build:balance

- name: Test Statement
  run: melos run build:statement
```

## Otimizações Implementadas

1. **ProGuard/R8**: Obfuscação de código em builds release
2. **Resource Shrinking**: Remoção de recursos não utilizados
3. **Code Shrinking**: Remoção de código não utilizado
4. **Build Cache**: Compilação incremental do Dart
5. **Dart Dev Tools**: Análise de performance e tamanho

