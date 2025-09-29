#!/bin/bash

# Script de deploy para Roda Rico Experience
# Uso: ./scripts/deploy.sh [beta|release]

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para imprimir mensagens coloridas
print_message() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar argumentos
if [ $# -eq 0 ]; then
    print_error "Uso: $0 [beta|release]"
    echo "  beta    - Deploy para TestFlight"
    echo "  release - Deploy para App Store"
    exit 1
fi

DEPLOY_TYPE=$1

# Verificar se estamos no diretório correto
if [ ! -f "RodaRicoExperience.xcodeproj/project.pbxproj" ]; then
    print_error "Execute este script a partir do diretório raiz do projeto"
    exit 1
fi

# Verificar se o Fastlane está configurado
if [ ! -f "fastlane/Fastfile" ]; then
    print_error "Fastlane não está configurado. Execute ./scripts/setup.sh primeiro"
    exit 1
fi

print_message "Iniciando deploy para $DEPLOY_TYPE..."

# Verificar se o bundle ID está correto
BUNDLE_ID=$(grep -o 'PRODUCT_BUNDLE_IDENTIFIER = [^;]*' RodaRicoExperience.xcodeproj/project.pbxproj | head -1 | cut -d' ' -f3)
if [[ $BUNDLE_ID == *".."* ]]; then
    print_warning "Bundle ID parece estar incorreto: $BUNDLE_ID"
    print_warning "Corrija o bundle ID no Xcode antes de continuar"
    read -p "Deseja continuar mesmo assim? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Executar deploy baseado no tipo
case $DEPLOY_TYPE in
    "beta")
        print_message "Fazendo deploy para TestFlight..."
        bundle exec fastlane beta
        print_success "Deploy para TestFlight concluído!"
        ;;
    "release")
        print_message "Fazendo deploy para App Store..."
        bundle exec fastlane release
        print_success "Deploy para App Store concluído!"
        ;;
    *)
        print_error "Tipo de deploy inválido: $DEPLOY_TYPE"
        echo "Use 'beta' ou 'release'"
        exit 1
        ;;
esac

print_success "Deploy concluído com sucesso! 🎉"
