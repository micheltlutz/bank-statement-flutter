# Arquitetura Modular - Bank Statement App

## Visão Geral

O aplicativo Bank Statement foi desenvolvido seguindo uma arquitetura modular com packages Dart independentes. Cada módulo pode ser compilado, testado e mantido de forma isolada, garantindo builds incrementais e otimizados.

## Diagrama de Arquitetura

```mermaid
graph TB
    subgraph "packages/app"
        APP[Main App]
        ROUTER[Router]
    end
    
    subgraph "packages/core"
        CORE[Core]
        DI[Dependency Injection]
        ERRORS[Error Handling]
        CONSTANTS[Constants]
        INTERFACES[Interfaces/Contracts]
    end
    
    subgraph "packages/network"
        NETWORK[Network Package]
        HTTP_CLIENT[HTTP Client]
        INTERCEPTOR[Auth Interceptor]
        API_BASE[API Base Config]
    end
    
    subgraph "packages/auth"
        AUTH_PKG[Auth Package]
        AUTH_UI[Auth UI]
        AUTH_REPO[Auth Repository]
        AUTH_SERVICE[Auth Service]
        AUTH_STORAGE[Secure Storage]
        AUTH_DOMAIN[Auth Domain]
    end
    
    subgraph "packages/statement"
        STATEMENT_PKG[Statement Package]
        STATEMENT_UI[Statement UI]
        STATEMENT_LIST[Statement List Screen]
        STATEMENT_DETAIL[Statement Detail Screen]
        STATEMENT_REPO[Statement Repository]
        STATEMENT_DOMAIN[Statement Domain]
    end
    
    subgraph "packages/balance"
        BALANCE_PKG[Balance Package]
        BALANCE_UI[Balance UI]
        BALANCE_REPO[Balance Repository]
        BALANCE_DOMAIN[Balance Domain]
    end
    
    APP -->|depends on| CORE
    APP -->|depends on| AUTH_PKG
    APP -->|depends on| STATEMENT_PKG
    APP -->|depends on| ROUTER
    
    ROUTER -->|depends on| CORE
    ROUTER -->|uses interfaces| AUTH_PKG
    ROUTER -->|uses interfaces| STATEMENT_PKG
    
    STATEMENT_PKG -->|depends on| CORE
    STATEMENT_PKG -->|depends on| NETWORK
    STATEMENT_PKG -->|uses interface| BALANCE_PKG
    STATEMENT_PKG -.->|no direct dep| AUTH_PKG
    
    BALANCE_PKG -->|depends on| CORE
    BALANCE_PKG -->|depends on| NETWORK
    BALANCE_PKG -.->|no direct dep| AUTH_PKG
    BALANCE_PKG -.->|no direct dep| STATEMENT_PKG
    
    AUTH_PKG -->|depends on| CORE
    AUTH_PKG -->|depends on| NETWORK
    AUTH_PKG -.->|no direct dep| STATEMENT_PKG
    AUTH_PKG -.->|no direct dep| BALANCE_PKG
    
    NETWORK -->|depends on| CORE
    NETWORK -.->|no direct dep| AUTH_PKG
    NETWORK -.->|no direct dep| STATEMENT_PKG
    NETWORK -.->|no direct dep| BALANCE_PKG
    
    CORE -.->|no dependencies| OTHER
    
    style CORE fill:#90EE90
    style NETWORK fill:#87CEEB
    style AUTH_PKG fill:#FFB6C1
    style STATEMENT_PKG fill:#DDA0DD
    style BALANCE_PKG fill:#F0E68C
    style APP fill:#FFA07A
```

![Diagrama de Arquitetura do Projeto](ARCH-PROJ.png)

## Estrutura de Packages

### Core Package (`packages/core`)
- **Responsabilidade**: Fundação do sistema, interfaces, contratos, DI
- **Independência**: ✅ Zero dependências de outros packages
- **Arquivos principais**:
  - `lib/core/di/injection_container.dart` - Configuração de DI
  - `lib/core/constants/api_constants.dart` - URL base da API
  - `lib/core/errors/` - Classes de exceção e falhas
  - `lib/core/interfaces/` - Interfaces/contratos

### Network Package (`packages/network`)
- **Responsabilidade**: Comunicação HTTP, interceptores
- **Independência**: ✅ Depende apenas de `core`
- **Arquivos principais**:
  - `lib/network/data/datasources/api_client.dart` - Cliente HTTP com Dio
  - `lib/network/data/interceptors/auth_interceptor.dart` - Interceptor de autenticação

### Auth Package (`packages/auth`)
- **Responsabilidade**: Autenticação, armazenamento seguro de tokens
- **Independência**: ✅ Depende apenas de `core` e `network`
- **Arquivos principais**:
  - `lib/auth/data/datasources/auth_remote_datasource.dart` - Endpoint `/auth/`
  - `lib/auth/data/datasources/auth_local_datasource.dart` - Secure storage

### Balance Package (`packages/balance`)
- **Responsabilidade**: Obter e gerenciar saldo calculado
- **Independência**: ✅ Depende apenas de `core` e `network`
- **Arquivos principais**:
  - `lib/balance/data/datasources/balance_remote_datasource.dart` - Endpoint `/balance/`

### Statement Package (`packages/statement`)
- **Responsabilidade**: Lista e detalhe de extratos
- **Independência**: ✅ Depende de `core`, `network` e `balance`
- **Arquivos principais**:
  - `lib/statement/presentation/pages/statement_list_page.dart` - Tela de lista
  - `lib/statement/presentation/pages/statement_detail_page.dart` - Tela de detalhe

### App (`app/`)
- **Responsabilidade**: Orquestração, roteamento, DI final
- **Dependências**: Todos os packages

## Vantagens da Arquitetura Modular

1. **Builds Incrementais**: Apenas módulos modificados são recompilados
2. **Testes Isolados**: Cada package pode ser testado independentemente
3. **Paralelização**: Módulos podem ser compilados/testados em paralelo no CI/CD
4. **Reutilização**: Packages podem ser usados em outros projetos
5. **Desacoplamento**: Módulos não dependem uns dos outros diretamente

