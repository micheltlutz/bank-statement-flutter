# Documentação da API

## Base URL

```
https://dev-challenge.micheltlutz.me
```

## Autenticação

A API utiliza autenticação via **Bearer Token** (JWT). Todas as rotas protegidas requerem o header:

```
Authorization: Bearer <access_token>
```

### Fluxo de Autenticação

1. **Login** - Obter token de acesso via `POST /auth/`
2. **Armazenar Token** - Salvar o `access_token` retornado
3. **Usar Token** - Incluir o token no header `Authorization` de todas as requisições protegidas

## Endpoints

### 🔓 Públicos (Não Requerem Autenticação)

#### POST `/auth/` - Login

Autentica o usuário e retorna um token de acesso.

**Request Body:**
```json
{
  "userid": "string (email)",
  "password": "string"
}
```

**Response 200:**
```json
{
  "access_token": "string",
  "token_type": "bearer"
}
```

**Response 422:** Erro de validação

---

#### GET `/health-check` - Health Check

Verifica o status da API.

**Response 200:**
```json
{}
```

---

#### GET `/version` - Versão

Retorna a versão da API.

**Response 200:**
```json
{}
```

---

#### POST `/users/` - Criar Usuário

Cria um novo usuário no sistema.

**Request Body:**
```json
{
  "userid": "string (email)",
  "password": "string",
  "fullname": "string",
  "birthdate": "string (date)"
}
```

**Response 201:** Usuário criado com sucesso

**Response 422:** Erro de validação

---

#### POST `/contact/` - Criar Contato

Envia uma mensagem de contato.

**Request Body:**
```json
{
  "name": "string",
  "email": "string (email)",
  "message": "string",
  "interest": "string"
}
```

**Response 200:** Contato criado com sucesso

**Response 422:** Erro de validação

---

### 🔒 Protegidos (Requerem Autenticação Bearer Token)

#### GET `/statements/` - Listar Extratos

Retorna a lista de extratos do usuário autenticado.

**Headers:**
```
Authorization: Bearer <access_token>
```

**Query Parameters:**
- `skip` (integer, opcional, default: 0) - Número de registros a pular (paginação)
- `limit` (integer, opcional, default: 10) - Número máximo de registros a retornar

**Exemplo:**
```
GET /statements/?skip=0&limit=10
```

**Response 200:**
```json
{
  "items": [
    {
      "id": 1,
      "description": "string",
      "type": "deposit|withdrawal|transfer",
      "created_at": "2024-01-01T00:00:00Z",
      "amount": "string",
      "to_user": "string",
      "from_user": "string",
      "bank_name": "string"
    }
  ]
}
```

**Response 401:** Token inválido ou expirado

**Response 422:** Erro de validação

---

#### GET `/balance/` - Obter Saldo Calculado

Retorna o saldo calculado do usuário autenticado baseado em todas as transações.

**Headers:**
```
Authorization: Bearer <access_token>
```

**Regras de Cálculo:**
- **Deposit**: Se `from_user == to_user`, o valor é adicionado ao saldo
- **Deposit**: Se `from_user != to_user`, o valor é adicionado ao saldo
- **Withdrawal**: Se o usuário retira da própria conta, o valor é subtraído do saldo
- **Transfer**: Se `to_user == from_user`, o valor é adicionado ao saldo
- **Transfer**: Se `to_user != from_user`, o valor é subtraído do saldo

**Response 200:**
```json
{
  "amount": 0.0
}
```

**Response 401:** Token inválido ou expirado

---

#### POST `/statement/` - Criar Extrato

Cria um novo extrato (requer autenticação).

**Headers:**
```
Authorization: Bearer <access_token>
```

**Request Body:**
```json
{
  "id": 0,
  "description": "string",
  "type": "string",
  "created_at": "2024-01-01T00:00:00Z",
  "amount": "string",
  "to_user": "string",
  "from_user": "string",
  "bank_name": "string",
  "authentication": "string"
}
```

**Response 201:** Extrato criado com sucesso

**Response 401:** Token inválido ou expirado

**Response 422:** Erro de validação

---

#### GET `/generate-random-statement/{registers_to_generate}` - Gerar Extratos Aleatórios

Gera extratos aleatórios para o usuário autenticado.

**Headers:**
```
Authorization: Bearer <access_token>
```

**Path Parameters:**
- `registers_to_generate` (integer, obrigatório) - Número de extratos a gerar

**Exemplo:**
```
GET /generate-random-statement/10
```

**Response 200:** Extratos gerados com sucesso

**Response 401:** Token inválido ou expirado

**Response 422:** Erro de validação

---

#### PUT `/users/{user_id}` - Atualizar Usuário

Atualiza informações do usuário.

**Headers:**
```
Authorization: Bearer <access_token>
```

**Path Parameters:**
- `user_id` (integer, obrigatório) - ID do usuário

**Request Body:**
```json
{
  "password": "string",
  "fullname": "string",
  "birthdate": "string (date)"
}
```

**Response 200:**
```json
{
  "password": "string",
  "fullname": "string",
  "birthdate": "string (date)"
}
```

**Response 401:** Token inválido ou expirado

**Response 422:** Erro de validação

---

## Segurança da API

### ✅ Verificação de Autenticação

**Todas as rotas relacionadas a extratos e saldo requerem autenticação Bearer Token:**

- ✅ `/statements/` (GET) - **PROTEGIDA**
- ✅ `/balance/` (GET) - **PROTEGIDA**
- ✅ `/statement/` (POST) - **PROTEGIDA**
- ✅ `/generate-random-statement/{registers_to_generate}` (GET) - **PROTEGIDA**
- ✅ `/users/{user_id}` (PUT) - **PROTEGIDA**

### ❌ Não Há Bypass de Autenticação

**Análise da API OpenAPI:**
- Todas as rotas de extratos possuem `"security":[{"HTTPBearer":[]}]` no schema
- A rota `/auth/` é a única forma de obter um token válido
- Não existem rotas alternativas ou endpoints de desenvolvimento que permitam acesso sem autenticação

### Implementação no Projeto

O projeto implementa corretamente a autenticação através de:

1. **AuthInterceptor** (`packages/network/lib/network/data/interceptors/auth_interceptor.dart`):
   - Adiciona automaticamente o header `Authorization: Bearer <token>` em todas as requisições
   - Remove o token automaticamente em caso de erro 401 (token inválido/expirado)

2. **AuthStorage** (`packages/auth/lib/auth/data/datasources/auth_local_datasource.dart`):
   - Armazena o token de forma segura usando `flutter_secure_storage`
   - O token é criptografado e armazenado localmente

3. **Tratamento de Erros**:
   - Erros 401 são tratados e o usuário é redirecionado para login
   - Tokens expirados são removidos automaticamente

## Códigos de Status HTTP

- **200** - Sucesso
- **201** - Criado com sucesso
- **401** - Não autorizado (token inválido ou expirado)
- **422** - Erro de validação
- **500** - Erro interno do servidor

## Exemplos de Uso

### Login

```dart
final response = await httpClient.post(
  '/auth/',
  data: {
    'userid': 'user@example.com',
    'password': 'password123',
  },
);

final token = response['access_token'];
await authStorage.saveToken(token);
```

### Listar Extratos

```dart
final response = await httpClient.get(
  '/statements/',
  queryParameters: {
    'skip': 0,
    'limit': 10,
  },
);

final statements = response['items'] as List;
```

### Obter Saldo

```dart
final response = await httpClient.get('/balance/');
final balance = response['amount'] as double;
```

## Referências

- **OpenAPI Specification**: [https://dev-challenge.micheltlutz.me/openapi.json](https://dev-challenge.micheltlutz.me/openapi.json)
- **Documentação Interativa**: [https://dev-challenge.micheltlutz.me/docs](https://dev-challenge.micheltlutz.me/docs)

---

**Última atualização**: Baseado na OpenAPI 3.1.0 da API

