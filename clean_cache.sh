#!/bin/bash
echo "Limpando cache do Flutter..."
flutter clean

echo "Limpando cache do pub..."
rm -rf ~/.pub-cache

echo "Limpando cache do Flutter SDK..."
rm -rf ~/.flutter/bin/cache
sudo rm -rf /usr/local/share/flutter/bin/cache 2>/dev/null

echo "Limpando builds do projeto..."
cd /<Path to your project>/BankStatementModular
find . -name "build" -type d -exec rm -rf {} + 2>/dev/null
find . -name ".dart_tool" -type d -exec rm -rf {} + 2>/dev/null

echo "Limpando cache do Gradle..."
rm -rf ~/.gradle/caches

echo "Limpeza concluída!"