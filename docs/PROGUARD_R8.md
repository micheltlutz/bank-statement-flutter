# ProGuard/R8 - Proteção de Código Android

## O que é ProGuard/R8?

**R8** é a ferramenta de ofuscação e otimização de código do Android que substituiu o ProGuard. Ela é executada automaticamente durante o build do Android e serve para:

1. **Obfuscar código**: Renomeia classes, métodos e variáveis com nomes curtos e sem sentido, dificultando engenharia reversa
2. **Otimizar código**: Remove código não utilizado e otimiza o desempenho
3. **Reduzir tamanho**: Remove recursos não utilizados, diminuindo o tamanho do APK

## Por que usar no nosso projeto?

### Proteção do Firebase (`google-services.json`)

O arquivo `google-services.json` contém informações sensíveis do Firebase que podem ser extraídas do APK via engenharia reversa. O R8 ajuda a:

- Ofuscar referências ao Firebase no código compilado
- Dificultar a extração de strings e configurações
- Reduzir informações que podem ser obtidas via análise estática

**⚠️ Importante**: O R8 não criptografa o arquivo `google-services.json` em si, mas dificulta muito a extração das informações dele do código compilado.

## Como está configurado no projeto?

### 1. Ativação no `build.gradle.kts`

```kotlin
buildTypes {
    release {
        // Habilita ofuscação e otimização
        isMinifyEnabled = true
        isShrinkResources = true  // Remove recursos não usados
        
        // Arquivo de regras do ProGuard
        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )
    }
}
```

**Localização**: `app/android/app/build.gradle.kts`

### 2. Regras personalizadas (`proguard-rules.pro`)

O arquivo `app/android/app/proguard-rules.pro` contém regras que instruem o R8 sobre:

- O que **manter** (não ofuscar)
- O que **otimizar**
- O que **remover**

#### Regras principais do nosso projeto:

**Arquivo**: `app/android/app/proguard-rules.pro`

```proguard
# Proteger classes do Firebase (mantém, não ofusca)
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Manter MainActivity (necessário para o Flutter funcionar)
-keep class me.micheltlutz.bankstatement.MainActivity { *; }

# Manter classes Flutter (necessárias para funcionamento)
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Manter classes Parcelable e Serializable (necessário para passar dados)
-keep class * implements android.os.Parcelable {
    public static final ** CREATOR;
}
-keepnames class * implements java.io.Serializable
```

**Nota**: A regra `-keep` instrui o R8 a **manter** a classe/método sem ofuscar. Isso é necessário para:
- Firebase funcionar corretamente
- Flutter funcionar corretamente
- Classes que usam reflection ou serialização

## Como funciona?

### Durante o build (Release)

```
Código Original (Dart/Kotlin)
    ↓
Compilação
    ↓
Código Compilado (.class/.dex)
    ↓
R8 Processa:
  - Remove código não usado
  - Otimiza instruções
  - Obfusca nomes
    ↓
APK Otimizado e Ofuscado
```

### Exemplo de ofuscação

**Antes**:
```kotlin
class AuthRepository {
    fun login(username: String, password: String) {
        // código...
    }
}
```

**Depois (ofuscado)**:
```kotlin
class a {
    fun b(c: String, d: String) {
        // código...
    }
}
```

## Testando o build com R8

### Build Debug (sem R8)
```bash
cd app
flutter build apk --debug
```
- Sem ofuscação
- APK maior
- Fácil de analisar

### Build Release (com R8)
```bash
cd app
flutter build apk --release
```
- Com ofuscação ativa
- APK otimizado e menor
- Difícil de analisar

## Verificando se R8 está ativo

Após um build release, você pode verificar:

1. **Tamanho do APK**: Deve ser menor que o debug (geralmente 30-50% menor)
2. **Logs do build**: Procure por mensagens como "R8 full mode" ou "R8 shrinking" nos logs
3. **Análise do APK**: Use ferramentas como `jadx` ou `apktool` para tentar descompilar e verificar se o código está ofuscado

### Exemplo prático

```bash
# Build debug (sem R8)
flutter build apk --debug
# Tamanho: ~80MB

# Build release (com R8)
flutter build apk --release
# Tamanho: ~45MB (menor!)

# Verificar ofuscação (opcional - requer jadx)
jadx app.apk
# Código ofuscado terá nomes como: a, b, c, aa, ab, etc.
```

**Diferença esperada**: Build release deve ser significativamente menor que debug devido à remoção de código não utilizado.

## Adicionando novas regras

Se você adicionar novas bibliotecas ou classes que precisam ser mantidas (não ofuscadas), adicione regras no `proguard-rules.pro`:

```proguard
# Exemplo: manter uma classe específica
-keep class com.minha.biblioteca.ClasseImportante { *; }

# Exemplo: manter métodos com anotações específicas
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
```

## Limitações e Considerações

1. **Não é criptografia**: R8 ofusca, mas não criptografa. Dados sensíveis ainda podem ser extraídos com esforço significativo.

2. **Testes**: Sempre teste builds release, pois ofuscação pode quebrar código que usa reflection ou acesso dinâmico.

3. **Firebase**: O `google-services.json` ainda estará no APK. R8 dificulta, mas não impede totalmente a extração.

4. **Desempenho**: R8 pode adicionar alguns segundos ao tempo de build, mas o resultado é um APK menor e mais rápido.

## Recursos Adicionais

- [Documentação oficial do R8](https://developer.android.com/studio/build/shrink-code)
- [Guia do ProGuard](https://www.guardsquare.com/manual/configuration/usage)
- [Best Practices](https://developer.android.com/studio/build/shrink-code#keep-code)

## Checklist de Segurança

- [x] R8 habilitado em builds release
- [x] Regras para Firebase configuradas
- [x] Regras para Flutter configuradas
- [x] MainActivity mantida
- [x] Testes em build release realizados

---

**Resumo**: R8 é uma ferramenta essencial para proteger e otimizar apps Android. No nosso projeto, ela ajuda a proteger informações do Firebase e reduzir o tamanho do APK, tornando a engenharia reversa muito mais difícil.

