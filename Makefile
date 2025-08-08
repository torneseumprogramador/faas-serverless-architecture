# Makefile para FaaS Serverless Architecture
# Uso: make [comando]

.PHONY: help install deploy-dev deploy-staging deploy-prod destroy-dev destroy-staging destroy-prod logs test clean

# Cores para output
GREEN := \033[0;32m
YELLOW := \033[1;33m
RED := \033[0;31m
NC := \033[0m # No Color

help: ## Mostrar esta ajuda
	@echo "$(GREEN)Comandos disponíveis:$(NC)"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  $(YELLOW)%-20s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: ## Instalar dependências
	@echo "$(GREEN)Instalando dependências...$(NC)"
	npm install

deploy-dev: ## Deploy para ambiente de desenvolvimento
	@echo "$(GREEN)Fazendo deploy para desenvolvimento...$(NC)"
	cd terraform && ./deploy.sh dev

deploy-staging: ## Deploy para ambiente de staging
	@echo "$(GREEN)Fazendo deploy para staging...$(NC)"
	cd terraform && ./deploy.sh staging

deploy-prod: ## Deploy para ambiente de produção
	@echo "$(RED)Fazendo deploy para PRODUÇÃO...$(NC)"
	cd terraform && ./deploy.sh prod

destroy-dev: ## Destruir infraestrutura de desenvolvimento
	@echo "$(YELLOW)Destruindo infraestrutura de desenvolvimento...$(NC)"
	cd terraform && ./destroy.sh dev

destroy-staging: ## Destruir infraestrutura de staging
	@echo "$(YELLOW)Destruindo infraestrutura de staging...$(NC)"
	cd terraform && ./destroy.sh staging

destroy-prod: ## Destruir infraestrutura de produção
	@echo "$(RED)Destruindo infraestrutura de PRODUÇÃO...$(NC)"
	cd terraform && ./destroy.sh prod

logs: ## Ver logs das funções Lambda
	@echo "$(GREEN)Mostrando logs das funções Lambda...$(NC)"
	@echo "Para ver logs em tempo real:"
	@echo "  aws logs tail /aws/lambda/faas-products-api-get-products"
	@echo "  aws logs tail /aws/lambda/faas-products-api-get-product-by-id"

test: ## Testar a API localmente
	@echo "$(GREEN)Testando API localmente...$(NC)"
	@echo "Para testar localmente, use:"
	@echo "  curl http://localhost:3000/dev/products"
	@echo "  curl http://localhost:3000/dev/products/1"

clean: ## Limpar arquivos temporários
	@echo "$(GREEN)Limpando arquivos temporários...$(NC)"
	rm -rf terraform/.terraform
	rm -rf terraform/*.tfstate*
	rm -rf terraform/lambda.zip
	rm -rf node_modules

terraform-init: ## Inicializar Terraform
	@echo "$(GREEN)Inicializando Terraform...$(NC)"
	cd terraform && terraform init

terraform-plan: ## Verificar plano do Terraform
	@echo "$(GREEN)Verificando plano do Terraform...$(NC)"
	cd terraform && terraform plan

terraform-apply: ## Aplicar mudanças do Terraform
	@echo "$(GREEN)Aplicando mudanças do Terraform...$(NC)"
	cd terraform && terraform apply

terraform-destroy: ## Destruir infraestrutura Terraform
	@echo "$(YELLOW)Destruindo infraestrutura Terraform...$(NC)"
	cd terraform && terraform destroy

terraform-output: ## Mostrar outputs do Terraform
	@echo "$(GREEN)Mostrando outputs do Terraform...$(NC)"
	cd terraform && terraform output

status: ## Verificar status da infraestrutura
	@echo "$(GREEN)Verificando status da infraestrutura...$(NC)"
	@echo "Funções Lambda:"
	@aws lambda list-functions --region sa-east-1 --query 'Functions[?contains(FunctionName, `faas-products-api`)].FunctionName' --output table 2>/dev/null || echo "Nenhuma função encontrada"
	@echo ""
	@echo "API Gateway:"
	@aws apigateway get-rest-apis --region sa-east-1 --query 'items[?contains(name, `faas-products-api`)].name' --output table 2>/dev/null || echo "Nenhuma API encontrada"
