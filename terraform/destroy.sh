#!/bin/bash

# Script para destruir infraestrutura Terraform
# Uso: ./destroy.sh [dev|staging|prod]

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para imprimir mensagens coloridas
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  Destroy Terraform - FaaS API${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Verificar se o ambiente foi especificado
ENVIRONMENT=${1:-dev}

if [[ ! "$ENVIRONMENT" =~ ^(dev|staging|prod)$ ]]; then
    print_error "Ambiente inválido. Use: dev, staging ou prod"
    exit 1
fi

print_header
print_warning "⚠️  ATENÇÃO: Você está prestes a DESTRUIR a infraestrutura!"
print_message "Ambiente: $ENVIRONMENT"

# Confirmação
read -p "Tem certeza que deseja continuar? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_message "Operação cancelada."
    exit 0
fi

# Verificar se o Terraform está instalado
if ! command -v terraform &> /dev/null; then
    print_error "Terraform não está instalado."
    exit 1
fi

# Verificar se o AWS CLI está configurado
if ! aws sts get-caller-identity &> /dev/null; then
    print_error "AWS CLI não está configurado."
    exit 1
fi

print_message "Inicializando Terraform..."
terraform init

# Destruir baseado no ambiente
if [ "$ENVIRONMENT" = "dev" ]; then
    print_message "Destruindo infraestrutura de desenvolvimento..."
    terraform destroy -auto-approve
elif [ "$ENVIRONMENT" = "staging" ]; then
    print_message "Destruindo infraestrutura de staging..."
    terraform destroy -var-file="staging.tfvars" -auto-approve
elif [ "$ENVIRONMENT" = "prod" ]; then
    print_warning "🚨 DESTRUINDO INFRAESTRUTURA DE PRODUÇÃO!"
    read -p "Você tem CERTEZA ABSOLUTA? Digite 'DESTROY' para confirmar: " -r
    if [[ "$REPLY" == "DESTROY" ]]; then
        terraform destroy -var-file="prod.tfvars" -auto-approve
    else
        print_message "Operação cancelada."
        exit 0
    fi
fi

print_message "✅ Infraestrutura destruída com sucesso!"
print_message "🗑️  Todos os recursos AWS foram removidos."
