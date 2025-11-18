@echo off
REM Script de Setup do Projeto Bank Statement Modular (Windows)
REM Este script configura o ambiente de desenvolvimento para novos colaboradores

setlocal enabledelayedexpansion

echo.
echo ================================================================================
echo   Setup do Projeto Bank Statement Modular
echo ================================================================================
echo.

REM Verificar se está no diretório correto
if not exist "melos.yaml" (
    echo [ERRO] Este script deve ser executado na raiz do projeto (onde está o melos.yaml)
    exit /b 1
)

REM 1. Verificar Flutter
echo [INFO] Verificando Flutter...
where flutter >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERRO] Flutter não encontrado!
    echo [AVISO] Por favor, instale o Flutter 3.38.1 ou superior:
    echo   https://docs.flutter.dev/get-started/install
    exit /b 1
)

for /f "tokens=2" %%i in ('flutter --version ^| findstr /r "Flutter"') do set FLUTTER_VERSION=%%i
echo [OK] Flutter encontrado: %FLUTTER_VERSION%

REM 2. Verificar Dart
echo [INFO] Verificando Dart...
where dart >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERRO] Dart não encontrado!
    echo [AVISO] O Dart geralmente vem com o Flutter. Verifique sua instalação do Flutter.
    exit /b 1
)

for /f "tokens=4" %%i in ('dart --version') do set DART_VERSION=%%i
echo [OK] Dart encontrado: %DART_VERSION%

REM 3. Verificar Flutter Doctor
echo [INFO] Verificando configuração do Flutter (flutter doctor)...
flutter doctor

REM 4. Verificar/Instalar Melos
echo [INFO] Verificando Melos...
where melos >nul 2>&1
if %errorlevel% neq 0 (
    echo [AVISO] Melos não encontrado. Instalando...
    dart pub global activate melos
    if %errorlevel% equ 0 (
        echo [OK] Melos instalado com sucesso!
        echo [AVISO] Certifique-se de que o diretório pub-cache está no PATH:
        echo   %USERPROFILE%\AppData\Local\Pub\Cache\bin
    ) else (
        echo [ERRO] Falha ao instalar Melos
        exit /b 1
    )
) else (
    echo [OK] Melos encontrado
)

REM 5. Verificar Git
echo [INFO] Verificando Git...
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo [AVISO] Git não encontrado. Algumas funcionalidades podem não funcionar.
) else (
    for /f "tokens=3" %%i in ('git --version') do set GIT_VERSION=%%i
    echo [OK] Git encontrado: %GIT_VERSION%
)

REM 6. Limpar cache (opcional)
set /p CLEAN_CACHE="Deseja limpar o cache do Flutter antes de continuar? (s/N): "
if /i "%CLEAN_CACHE%"=="s" (
    echo [INFO] Limpando cache do Flutter...
    flutter clean
    echo [OK] Cache limpo!
)

REM 7. Instalar dependências com Melos
echo.
echo ================================================================================
echo   Instalando Dependências
echo ================================================================================
echo.
echo [INFO] Executando 'melos bootstrap'...
melos bootstrap
if %errorlevel% neq 0 (
    echo [AVISO] Falha ao instalar dependências com Melos
    echo [INFO] Tentando instalar manualmente...
    
    REM Instalação manual como fallback
    for /d %%d in (packages\*) do (
        if exist "%%d\pubspec.yaml" (
            echo [INFO] Instalando dependências em %%d...
            cd %%d
            flutter pub get
            cd ..\..
        )
    )
    
    if exist "app\pubspec.yaml" (
        echo [INFO] Instalando dependências em app...
        cd app
        flutter pub get
        cd ..
    )
)

REM 8. Verificar análise estática
echo.
set /p RUN_ANALYZE="Deseja executar análise estática agora? (S/n): "
if /i not "%RUN_ANALYZE%"=="n" (
    echo.
    echo ================================================================================
    echo   Verificando Análise Estática
    echo ================================================================================
    echo.
    echo [INFO] Executando 'melos analyze'...
    melos analyze
    if %errorlevel% equ 0 (
        echo [OK] Análise estática concluída sem erros!
    ) else (
        echo [AVISO] Alguns problemas foram encontrados na análise. Revise os avisos acima.
    )
)

REM 9. Verificar build
echo.
set /p CHECK_BUILD="Deseja verificar se o projeto compila? (S/n): "
if /i not "%CHECK_BUILD%"=="n" (
    echo.
    echo ================================================================================
    echo   Verificando Build
    echo ================================================================================
    echo.
    echo [INFO] Verificando build do app...
    cd app
    flutter build apk --debug --no-tree-shake-icons
    if %errorlevel% equ 0 (
        echo [OK] Build verificado com sucesso!
    ) else (
        echo [AVISO] Houve problemas no build. Verifique os erros acima.
    )
    cd ..
)

REM 10. Resumo final
echo.
echo ================================================================================
echo   Setup Concluído!
echo ================================================================================
echo.
echo [OK] O projeto está configurado e pronto para desenvolvimento!
echo.
echo [INFO] Próximos passos:
echo   1. Leia a documentação em docs\CODE_STYLE_GUIDE.md
echo   2. Configure seu editor (VS Code ou Android Studio)
echo   3. Execute 'cd app ^&^& flutter run' para iniciar o app
echo.
echo [INFO] Comandos úteis:
echo   • melos bootstrap     - Instalar/atualizar dependências
echo   • melos analyze       - Analisar código de todos os packages
echo   • melos test          - Executar testes de todos os packages
echo   • cd app ^&^& flutter run - Executar o app
echo.
echo [INFO] Documentação:
echo   • README.md                    - Visão geral do projeto
echo   • docs\ARCHITECTURE.md         - Arquitetura do projeto
echo   • docs\CODE_STYLE_GUIDE.md     - Guia de estilo de código
echo   • docs\PROJECT_SETUP.md        - Configurações detalhadas
echo.
echo [OK] Bem-vindo ao projeto! 🎉
echo.

endlocal

