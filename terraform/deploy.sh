#!/bin/bash

# Script de deploy para Terraform
# Uso: ./deploy.sh [dev|staging|prod]

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
    echo -e "${BLUE}  Deploy Terraform - FaaS API${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Verificar se o ambiente foi especificado
ENVIRONMENT=${1:-dev}

if [[ ! "$ENVIRONMENT" =~ ^(dev|staging|prod)$ ]]; then
    print_error "Ambiente inválido. Use: dev, staging ou prod"
    exit 1
fi

print_header
print_message "Iniciando deploy para ambiente: $ENVIRONMENT"

# Verificar se o Terraform está instalado
if ! command -v terraform &> /dev/null; then
    print_error "Terraform não está instalado. Instale primeiro."
    exit 1
fi

# Verificar se o AWS CLI está configurado
if ! aws sts get-caller-identity &> /dev/null; then
    print_error "AWS CLI não está configurado. Configure suas credenciais primeiro."
    exit 1
fi

print_message "Verificando dependências..."

# Verificar se o Node.js está instalado
if ! command -v node &> /dev/null; then
    print_error "Node.js não está instalado."
    exit 1
fi

# Verificar se as dependências estão instaladas
if [ ! -d "../node_modules" ]; then
    print_warning "Dependências Node.js não encontradas. Instalando..."
    cd ..
    npm install
    cd terraform
fi

print_message "Dependências verificadas com sucesso!"

# Inicializar Terraform
print_message "Inicializando Terraform..."
terraform init

# Aplicar configurações baseadas no ambiente
if [ "$ENVIRONMENT" = "dev" ]; then
    print_message "Aplicando configurações de desenvolvimento..."
    terraform plan
    terraform apply -auto-approve
elif [ "$ENVIRONMENT" = "staging" ]; then
    print_message "Aplicando configurações de staging..."
    terraform plan -var-file="staging.tfvars"
    terraform apply -var-file="staging.tfvars" -auto-approve
elif [ "$ENVIRONMENT" = "prod" ]; then
    print_message "Aplicando configurações de produção..."
    print_warning "Você está fazendo deploy para PRODUÇÃO!"
    read -p "Tem certeza? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        terraform plan -var-file="prod.tfvars"
        terraform apply -var-file="prod.tfvars" -auto-approve
    else
        print_message "Deploy cancelado."
        exit 0
    fi
fi

# Mostrar outputs
print_message "Deploy concluído! Mostrando informações da API..."
terraform output

print_message "✅ Deploy concluído com sucesso!"
print_message "🌐 Sua API está disponível nos endpoints mostrados acima."
print_message "📊 Para ver logs: aws logs tail /aws/lambda/[nome-da-funcao]"
