# Guia de Estilo de Código e Padronização

Este documento estabelece os padrões de código e convenções de escrita para o projeto Bank Statement Modular. Seguir estas diretrizes garante consistência, legibilidade e manutenibilidade do código.

## 📋 Índice

1. [Convenções de Nomenclatura](#convenções-de-nomenclatura)
2. [Formatação e Estrutura](#formatação-e-estrutura)
3. [Organização de Arquivos](#organização-de-arquivos)
4. [Comentários e Documentação](#comentários-e-documentação)
5. [Imports](#imports)
6. [Classes e Estruturas](#classes-e-estruturas)
7. [Funções e Métodos](#funções-e-métodos)
8. [Widgets Flutter](#widgets-flutter)
9. [Tratamento de Erros](#tratamento-de-erros)
10. [Testes](#testes)
11. [Análise Estática](#análise-estática)

---

## Convenções de Nomenclatura

### Classes e Tipos

- **PascalCase** para nomes de classes, enums, mixins, extensions e typedefs
- Use nomes descritivos e substantivos
- Evite abreviações desnecessárias

```dart
// ✅ Correto
class StatementRepository {}
class AuthenticationException {}
enum StatementType {}
typedef HttpClientFactory = HttpClient Function();

// ❌ Incorreto
class StmtRepo {}
class AuthEx {}
enum StmtType {}
```

### Variáveis, Parâmetros e Funções

- **camelCase** para variáveis, parâmetros, funções e métodos
- Use nomes descritivos que indiquem propósito
- Para booleanos, use prefixos como `is`, `has`, `should`, `can`

```dart
// ✅ Correto
final statementList = <Statement>[];
final isLoading = true;
final hasMoreData = false;
void loadStatements() {}
bool canLoadMore() {}

// ❌ Incorreto
final stmtList = <Statement>[];
final loading = true;
final more = false;
void load() {}
bool more() {}
```

### Constantes

- **lowerCamelCase** para constantes locais e de instância
- **SCREAMING_SNAKE_CASE** para constantes de classe/package

```dart
// ✅ Correto
class ApiConstants {
  static const String BASE_URL = 'https://api.example.com';
  static const int DEFAULT_TIMEOUT = 30;
}

final const maxRetries = 3;
const defaultLimit = 10;

// ❌ Incorreto
class ApiConstants {
  static const String baseUrl = 'https://api.example.com';
}
```

### Arquivos e Diretórios

- **snake_case** para nomes de arquivos
- Use nomes descritivos que reflitam o conteúdo

```
// ✅ Correto
statement_repository.dart
statement_list_page.dart
auth_remote_datasource.dart

// ❌ Incorreto
StatementRepository.dart
statementListPage.dart
authRemoteDatasource.dart
```

### Packages

- **lowercase** com underscores apenas quando necessário
- Nomes curtos e descritivos

```yaml
# ✅ Correto
name: statement
name: auth
name: balance

# ❌ Incorreto
name: Statement
name: AuthPackage
name: balance-module
```

---

## Formatação e Estrutura

### Indentação e Espaçamento

- Use **2 espaços** para indentação (não tabs)
- Linha em branco entre métodos e classes
- Linha em branco antes de comentários de bloco

```dart
// ✅ Correto
class StatementRepository {
  Future<List<Statement>> getStatements() async {
    // Implementação
  }

  Future<Statement> getStatementById(int id) async {
    // Implementação
  }
}

// ❌ Incorreto
class StatementRepository {
Future<List<Statement>> getStatements() async {
// Implementação
}
Future<Statement> getStatementById(int id) async {
// Implementação
}
}
```

### Quebra de Linha

- Máximo de **100 caracteres** por linha
- Quebre linhas longas de forma legível
- Alinhe parâmetros quando necessário

```dart
// ✅ Correto
Future<List<Statement>> getStatements({
  int skip = 0,
  int limit = 10,
  String? searchQuery,
}) async {
  // Implementação
}

// Quebra de linha para chamadas longas
final statements = await repository.getStatements(
  skip: 0,
  limit: 10,
  searchQuery: query,
);

// ❌ Incorreto
Future<List<Statement>> getStatements({int skip = 0, int limit = 10, String? searchQuery}) async {}

final statements = await repository.getStatements(skip: 0, limit: 10, searchQuery: query);
```

### Chaves e Parênteses

- Use chaves `{}` mesmo para blocos de uma linha em funções e métodos
- Omita chaves apenas em funções de seta simples

```dart
// ✅ Correto
if (condition) {
  doSomething();
}

final result = items.map((item) => item.toString()).toList();

// ❌ Incorreto
if (condition)
  doSomething();

final result = items.map((item) {
  return item.toString();
}).toList();
```

---

## Organização de Arquivos

### Estrutura de Packages

Cada package deve seguir a estrutura Clean Architecture:

```
package_name/
├── lib/
│   └── package_name/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       └── presentation/
│           ├── pages/
│           ├── widgets/
│           └── bloc/
└── test/
```

### Arquivo Principal do Package

Cada package deve ter um arquivo principal (`lib/package_name.dart`) que exporta apenas as APIs públicas:

```dart
// ✅ Correto - packages/statement/lib/statement.dart
library statement;

export 'statement/domain/entities/statement.dart';
export 'statement/domain/repositories/statement_repository.dart';
export 'statement/presentation/pages/statement_list_page.dart';
// ... outros exports públicos

// ❌ Incorreto - exportar implementações internas
export 'statement/data/repositories/statement_repository_impl.dart';
```

---

## Comentários e Documentação

### Documentação de Classes e Métodos

- Use **DartDoc** (`///`) para documentação pública
- Documente parâmetros, retornos e exceções
- Use `@param`, `@returns`, `@throws` quando necessário

```dart
// ✅ Correto
/// Repository responsável por gerenciar extratos bancários.
///
/// Este repositório fornece métodos para buscar e manipular
/// extratos do servidor e cache local.
class StatementRepository {
  /// Busca uma lista de extratos do servidor.
  ///
  /// [skip] - Número de itens a pular (para paginação)
  /// [limit] - Número máximo de itens a retornar
  /// [searchQuery] - Query opcional para filtrar extratos
  ///
  /// Retorna uma lista de [Statement] ou lança [ServerException]
  /// em caso de erro no servidor.
  Future<List<Statement>> getStatements({
    int skip = 0,
    int limit = 10,
    String? searchQuery,
  }) async {
    // Implementação
  }
}

// ❌ Incorreto
// Repository de statements
class StatementRepository {
  // Busca statements
  Future<List<Statement>> getStatements() async {}
}
```

### Comentários Inline

- Use `//` para comentários inline
- Comente código complexo ou não óbvio
- Evite comentários óbvios que apenas repetem o código

```dart
// ✅ Correto
// Calcula o saldo total somando todos os extratos de crédito
final totalBalance = statements
    .where((s) => s.isCredit)
    .fold(0.0, (sum, s) => sum + s.amount);

// ❌ Incorreto
// Loop através dos statements
for (final statement in statements) {
  // Adiciona ao total
  total += statement.amount;
}
```

### Comentários TODO/FIXME

- Use `TODO:` para tarefas futuras
- Use `FIXME:` para código que precisa ser corrigido
- Inclua contexto e, se possível, issue relacionada

```dart
// ✅ Correto
// TODO(#123): Implementar cache local para melhorar performance
// FIXME: Tratar caso quando response é null

// ❌ Incorreto
// TODO: fazer isso depois
// FIXME: bug aqui
```

---

## Imports

### Ordem de Imports

1. Imports do Dart SDK
2. Imports de packages externos (Flutter, pub.dev)
3. Imports de packages do projeto
4. Imports relativos (evitar quando possível)

```dart
// ✅ Correto
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:core/core.dart';
import 'package:network/network.dart';
import 'package:statement/statement.dart';

// ❌ Incorreto - ordem incorreta
import 'package:core/core.dart';
import 'dart:async';
import 'package:flutter/material.dart';
```

### Agrupamento de Imports

- Agrupe imports relacionados
- Linha em branco entre grupos
- Use `show` e `hide` para importar apenas o necessário

```dart
// ✅ Correto
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder, BlocProvider;

import 'package:core/core.dart' show AppException, AppTheme;
import 'package:statement/statement.dart' hide StatementModel;

// ❌ Incorreto - imports desnecessários
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // não usado
```

---

## Classes e Estruturas

### Construtores

- Use construtores nomeados para diferentes formas de criação
- Use `const` quando possível
- Documente construtores complexos

```dart
// ✅ Correto
class Statement {
  const Statement({
    required this.id,
    required this.description,
    required this.amount,
    this.createdAt,
  });

  Statement.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        description = json['description'] as String,
        amount = json['amount'] as String,
        createdAt = DateTime.parse(json['created_at'] as String);

  final int id;
  final String description;
  final String amount;
  final DateTime? createdAt;
}

// ❌ Incorreto
class Statement {
  Statement(this.id, this.description, this.amount, this.createdAt);
  // Sem const, sem construtor nomeado
}
```

### Propriedades

- Use `final` sempre que possível
- Declare propriedades privadas com `_`
- Use getters para propriedades computadas

```dart
// ✅ Correto
class Statement {
  final int id;
  final String description;
  final String _internalId; // privado

  bool get isCredit => type == StatementType.deposit;
  bool get isDebit => !isCredit;
}

// ❌ Incorreto
class Statement {
  int id; // não final
  String description;
  String internalId; // deveria ser privado
}
```

### Equatable

- Use `Equatable` para classes de valor (entities, models)
- Implemente `props` corretamente

```dart
// ✅ Correto
import 'package:equatable/equatable.dart';

class Statement extends Equatable {
  const Statement({
    required this.id,
    required this.description,
  });

  final int id;
  final String description;

  @override
  List<Object?> get props => [id, description];
}

// ❌ Incorreto
class Statement {
  // Sem Equatable, comparação manual necessária
}
```

---

## Funções e Métodos

### Assinaturas

- Use tipos explícitos para parâmetros e retornos
- Use parâmetros nomeados para clareza
- Use valores padrão quando apropriado

```dart
// ✅ Correto
Future<List<Statement>> getStatements({
  int skip = 0,
  int limit = 10,
  String? searchQuery,
}) async {
  // Implementação
}

// ❌ Incorreto
getStatements(skip, limit, query) async { // tipos implícitos
  // Implementação
}
```

### Funções Assíncronas

- Use `async/await` em vez de `.then()`
- Trate erros com `try-catch`
- Use `FutureOr` quando apropriado

```dart
// ✅ Correto
Future<List<Statement>> loadStatements() async {
  try {
    final response = await httpClient.get('/statements');
    return parseStatements(response);
  } on NetworkException catch (e) {
    throw ServerException(e.message, 500);
  }
}

// ❌ Incorreto
Future<List<Statement>> loadStatements() {
  return httpClient.get('/statements').then((response) {
    return parseStatements(response);
  }).catchError((e) {
    // tratamento genérico
  });
}
```

### Funções Privadas

- Use `_` para funções e métodos privados
- Organize métodos privados após métodos públicos

```dart
// ✅ Correto
class StatementRepository {
  Future<List<Statement>> getStatements() async {
    final data = await _fetchFromRemote();
    return _parseStatements(data);
  }

  Future<Map<String, dynamic>> _fetchFromRemote() async {
    // Implementação privada
  }

  List<Statement> _parseStatements(Map<String, dynamic> data) {
    // Implementação privada
  }
}
```

---

## Widgets Flutter

### Nomenclatura de Widgets

- Use sufixos descritivos: `Page`, `Screen`, `Widget`, `Card`, `Item`
- Widgets privados começam com `_`

```dart
// ✅ Correto
class StatementListPage extends StatelessWidget {}
class StatementCard extends StatelessWidget {}
class _StatementListItem extends StatelessWidget {} // privado

// ❌ Incorreto
class StatementList extends StatelessWidget {}
class Statement extends StatelessWidget {}
```

### Estrutura de Widgets

- Separe lógica de apresentação
- Use métodos privados para construir partes do widget
- Extraia widgets reutilizáveis

```dart
// ✅ Correto
class StatementListPage extends StatefulWidget {
  const StatementListPage({super.key});

  @override
  State<StatementListPage> createState() => _StatementListPageState();
}

class _StatementListPageState extends State<StatementListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Extratos'),
    );
  }

  Widget _buildBody() {
    return ListView(
      children: [
        _buildHeader(),
        _buildStatementList(),
      ],
    );
  }

  Widget _buildHeader() {
    // Implementação
  }

  Widget _buildStatementList() {
    // Implementação
  }
}
```

### Const e Performance

- Use `const` para widgets estáticos
- Evite reconstruções desnecessárias

```dart
// ✅ Correto
const Text('Extratos')
const SizedBox(height: 16)
const Icon(Icons.list)

// ❌ Incorreto
Text('Extratos') // não const
SizedBox(height: 16) // não const
```

### Keys

- Use keys apenas quando necessário (listas, animações)
- Use `ValueKey`, `ObjectKey`, `UniqueKey` apropriadamente

```dart
// ✅ Correto
ListView.builder(
  itemBuilder: (context, index) {
    return StatementCard(
      key: ValueKey(statements[index].id),
      statement: statements[index],
    );
  },
)

// ❌ Incorreto
ListView.builder(
  itemBuilder: (context, index) {
    return StatementCard(
      key: UniqueKey(), // desnecessário, gera nova key a cada build
      statement: statements[index],
    );
  },
)
```

---

## Tratamento de Erros

### Exceções Customizadas

- Crie exceções específicas que estendem `AppException`
- Use códigos de status HTTP apropriados
- Inclua mensagens descritivas

```dart
// ✅ Correto
class NetworkException extends AppException {
  const NetworkException(String message) : super(message, 0);
}

class AuthenticationException extends AppException {
  const AuthenticationException(String message) : super(message, 401);
}

// Uso
try {
  await httpClient.get('/statements');
} on NetworkException catch (e) {
  // Tratamento específico
} on AuthenticationException catch (e) {
  // Tratamento específico
} on AppException catch (e) {
  // Tratamento genérico
}
```

### Failures

- Use `Failure` para erros de domínio
- Converta exceções em failures no repository

```dart
// ✅ Correto
class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

// No repository
Future<Either<Failure, List<Statement>>> getStatements() async {
  try {
    final statements = await remoteDataSource.getStatements();
    return Right(statements);
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  }
}
```

---

## Testes

### Nomenclatura de Testes

- Use descrições claras do comportamento testado
- Use `group` para agrupar testes relacionados

```dart
// ✅ Correto
void main() {
  group('StatementRepository', () {
    test('deve retornar lista de extratos quando a requisição é bem-sucedida', () async {
      // Teste
    });

    test('deve lançar ServerException quando ocorre erro no servidor', () async {
      // Teste
    });
  });
}

// ❌ Incorreto
void main() {
  test('test1', () {
    // Teste sem descrição clara
  });
}
```

### Mocks e Fakes

- Use `mockito` ou `mocktail` para mocks
- Crie fakes para classes simples

```dart
// ✅ Correto
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements HttpClientInterface {}

void main() {
  late MockHttpClient mockHttpClient;
  late StatementRepository repository;

  setUp(() {
    mockHttpClient = MockHttpClient();
    repository = StatementRepository(mockHttpClient);
  });

  test('deve retornar lista de extratos', () async {
    when(() => mockHttpClient.get(any())).thenAnswer(
      (_) async => {'items': []},
    );

    final result = await repository.getStatements();

    expect(result, isA<List<Statement>>());
    verify(() => mockHttpClient.get(any())).called(1);
  });
}
```

---

## Análise Estática

### Analysis Options

- Use `flutter_lints` como base
- Habilite regras adicionais conforme necessário
- Mantenha `analysis_options.yaml` consistente entre packages

```yaml
# ✅ Correto - packages/core/analysis_options.yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    prefer_const_constructors: true
    prefer_const_literals_to_create_immutables: true
    avoid_print: false
```

### Regras Importantes

- `prefer_const_constructors`: Use const quando possível
- `avoid_print`: Use logging apropriado em produção
- `prefer_single_quotes`: Use aspas simples para strings
- `always_declare_return_types`: Sempre declare tipos de retorno

### Executar Análise

```bash
# Analisar todos os packages
melos analyze

# Analisar package específico
cd packages/core && flutter analyze
```

---

## Checklist de Code Review

Antes de submeter código, verifique:

- [ ] Código segue as convenções de nomenclatura
- [ ] Imports estão organizados corretamente
- [ ] Comentários e documentação estão atualizados
- [ ] Widgets usam `const` quando possível
- [ ] Erros são tratados apropriadamente
- [ ] Testes foram adicionados/atualizados
- [ ] `flutter analyze` não retorna erros
- [ ] Código está formatado (`dart format`)
- [ ] Não há código comentado ou não utilizado
- [ ] Segue a arquitetura modular do projeto

---

## Ferramentas Recomendadas

### Formatação Automática

```bash
# Formatar código
dart format .

# Formatar package específico
dart format packages/core
```

### Extensões VS Code / Android Studio

- **Dart**: Formatação e análise automática
- **Flutter**: Suporte completo ao Flutter
- **Error Lens**: Mostra erros inline
- **Better Comments**: Destaque para comentários TODO/FIXME

### Pre-commit Hooks (Opcional)

Considere usar `pre-commit` para executar formatação e análise antes de commits:

```yaml
# .pre-commit-config.yaml
repos:
  - repo: local
    hooks:
      - id: dart-format
        name: Dart Format
        entry: dart format
        language: system
        types: [dart]
      - id: flutter-analyze
        name: Flutter Analyze
        entry: flutter analyze
        language: system
        types: [dart]
```

---

## Referências

- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Style Guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)
- [Dart Linter Rules](https://dart.dev/lints)
- [Flutter Lints Package](https://pub.dev/packages/flutter_lints)

---

**Última atualização**: 2024

