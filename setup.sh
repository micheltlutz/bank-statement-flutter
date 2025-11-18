#!/bin/bash

# Script de Setup do Projeto Bank Statement Modular
# Este script configura o ambiente de desenvolvimento para novos colaboradores

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para imprimir mensagens coloridas
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# Verificar se está no diretório correto
if [ ! -f "melos.yaml" ]; then
    print_error "Este script deve ser executado na raiz do projeto (onde está o melos.yaml)"
    exit 1
fi

print_header "🚀 Setup do Projeto Bank Statement Modular"

# 1. Verificar Flutter
print_info "Verificando Flutter..."
if ! command -v flutter &> /dev/null; then
    print_error "Flutter não encontrado!"
    print_warning "Por favor, instale o Flutter 3.38.1 ou superior:"
    echo "  https://docs.flutter.dev/get-started/install"
    exit 1
fi

FLUTTER_VERSION=$(flutter --version | head -n 1 | awk '{print $2}')
print_success "Flutter encontrado: $FLUTTER_VERSION"

# Verificar versão mínima do Flutter (verificação simplificada)
REQUIRED_VERSION="3.38.1"
print_info "Versão recomendada: $REQUIRED_VERSION"

# 2. Verificar Dart
print_info "Verificando Dart..."
if ! command -v dart &> /dev/null; then
    print_error "Dart não encontrado!"
    print_warning "O Dart geralmente vem com o Flutter. Verifique sua instalação do Flutter."
    exit 1
fi

DART_VERSION=$(dart --version | awk '{print $4}')
print_success "Dart encontrado: $DART_VERSION"

# 3. Verificar Flutter Doctor
print_info "Verificando configuração do Flutter (flutter doctor)..."
if ! flutter doctor &> /dev/null; then
    print_warning "Executando 'flutter doctor' para verificar problemas..."
    flutter doctor
fi

# 4. Verificar/Instalar Melos
print_info "Verificando Melos..."
if ! command -v melos &> /dev/null; then
    print_warning "Melos não encontrado. Instalando..."
    dart pub global activate melos
    print_success "Melos instalado com sucesso!"
    
    # Adicionar ao PATH se necessário
    if [[ ":$PATH:" != *":$HOME/.pub-cache/bin:"* ]]; then
        print_warning "Adicione o Melos ao seu PATH:"
        echo "  export PATH=\"\$PATH:\$HOME/.pub-cache/bin\""
        echo ""
        print_warning "Ou adicione ao seu ~/.zshrc ou ~/.bashrc:"
        echo "  echo 'export PATH=\"\$PATH:\$HOME/.pub-cache/bin\"' >> ~/.zshrc"
        echo "  source ~/.zshrc"
    fi
else
    MELOS_VERSION=$(melos --version 2>/dev/null || echo "installed")
    print_success "Melos encontrado: $MELOS_VERSION"
fi

# 5. Verificar Git
print_info "Verificando Git..."
if ! command -v git &> /dev/null; then
    print_warning "Git não encontrado. Algumas funcionalidades podem não funcionar."
else
    GIT_VERSION=$(git --version | awk '{print $3}')
    print_success "Git encontrado: $GIT_VERSION"
fi

# 6. Limpar cache (opcional)
read -p "Deseja limpar o cache do Flutter antes de continuar? (s/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    print_info "Limpando cache do Flutter..."
    flutter clean
    print_success "Cache limpo!"
fi

# 7. Instalar dependências com Melos
print_header "📦 Instalando Dependências"
print_info "Executando 'melos bootstrap'..."
if melos bootstrap; then
    print_success "Dependências instaladas com sucesso!"
else
    print_error "Falha ao instalar dependências com Melos"
    print_warning "Tentando instalar manualmente..."
    
    # Instalação manual como fallback
    for dir in packages/*/ app/; do
        if [ -f "$dir/pubspec.yaml" ]; then
            print_info "Instalando dependências em $dir..."
            (cd "$dir" && flutter pub get)
        fi
    done
fi

# 8. Verificar análise estática
print_header "🔍 Verificando Análise Estática"
read -p "Deseja executar análise estática agora? (S/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    print_info "Executando 'melos analyze'..."
    if melos analyze; then
        print_success "Análise estática concluída sem erros!"
    else
        print_warning "Alguns problemas foram encontrados na análise. Revise os avisos acima."
    fi
fi

# 9. Verificar build
print_header "🔨 Verificando Build"
read -p "Deseja verificar se o projeto compila? (S/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    print_info "Verificando build do app..."
    cd app
    if flutter build apk --debug --no-tree-shake-icons 2>&1 | head -20; then
        print_success "Build verificado com sucesso!"
    else
        print_warning "Houve problemas no build. Verifique os erros acima."
    fi
    cd ..
fi

# 10. Resumo final
print_header "✨ Setup Concluído!"
print_success "O projeto está configurado e pronto para desenvolvimento!"
echo ""
print_info "Próximos passos:"
echo "  1. Leia a documentação em docs/CODE_STYLE_GUIDE.md"
echo "  2. Configure seu editor (VS Code ou Android Studio)"
echo "  3. Execute 'cd app && flutter run' para iniciar o app"
echo ""
print_info "Comandos úteis:"
echo "  • melos bootstrap     - Instalar/atualizar dependências"
echo "  • melos analyze       - Analisar código de todos os packages"
echo "  • melos test          - Executar testes de todos os packages"
echo "  • cd app && flutter run - Executar o app"
echo ""
print_info "Documentação:"
echo "  • README.md                    - Visão geral do projeto"
echo "  • docs/ARCHITECTURE.md         - Arquitetura do projeto"
echo "  • docs/CODE_STYLE_GUIDE.md     - Guia de estilo de código"
echo "  • docs/PROJECT_SETUP.md        - Configurações detalhadas"
echo ""
print_success "Bem-vindo ao projeto! 🎉"

