#!/bin/bash

# Script de configuração inicial do Fastlane
# Execute este script para configurar o ambiente

echo "🚀 Configurando Fastlane para Roda Rico Experience..."

# Verificar se o Ruby está instalado
if ! command -v ruby &> /dev/null; then
    echo "❌ Ruby não encontrado. Instale o Ruby primeiro."
    exit 1
fi

# Verificar se o Bundler está instalado
if ! command -v bundle &> /dev/null; then
    echo "📦 Instalando Bundler..."
    gem install bundler
fi

# Instalar dependências
echo "📦 Instalando dependências do Ruby..."
bundle install

# Verificar se o Xcode está instalado
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode não encontrado. Instale o Xcode primeiro."
    exit 1
fi

# Verificar se o Fastlane está instalado
if ! command -v fastlane &> /dev/null; then
    echo "📦 Instalando Fastlane..."
    bundle exec fastlane install
fi

echo "✅ Configuração concluída!"
echo ""
echo "📋 Próximos passos:"
echo "1. Configure seu Apple ID no arquivo fastlane/Appfile"
echo "2. Configure o bundle ID correto no Xcode"
echo "3. Execute: bundle exec fastlane certificates"
echo "4. Execute: bundle exec fastlane beta (para TestFlight)"
echo "5. Execute: bundle exec fastlane release (para App Store)"
