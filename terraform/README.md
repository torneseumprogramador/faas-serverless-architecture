# Terraform - Infraestrutura como Código

Este diretório contém a configuração Terraform para provisionar a infraestrutura serverless da API de produtos.

## 🏗️ Arquitetura

### Recursos Provisionados
- **Lambda Functions:** 2 funções (getProducts, getProductById)
- **API Gateway:** REST API com endpoints configurados
- **CloudWatch:** Log Groups para monitoramento
- **IAM:** Roles e políticas de segurança

### Estrutura de Arquivos
```
terraform/
├── main.tf              # Configuração principal
├── variables.tf         # Definição de variáveis
├── lambda.tf           # Recursos Lambda
├── outputs.tf          # Outputs da infraestrutura
├── prod.tfvars         # Configuração produção
├── staging.tfvars      # Configuração staging
└── README.md           # Esta documentação
```

## 🚀 Deploy

### Pré-requisitos
1. **Terraform** instalado (versão >= 1.0)
2. **AWS CLI** configurado

### Deploy para Desenvolvimento
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### Deploy para Staging
```bash
cd terraform
terraform init
terraform plan -var-file="staging.tfvars"
terraform apply -var-file="staging.tfvars"
```

### Deploy para Produção
```bash
cd terraform
terraform init
terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
```

## 🔧 Comandos Úteis

### Inicializar Terraform
```bash
terraform init
```

### Verificar Plano
```bash
terraform plan
terraform plan -var-file="prod.tfvars"
```

### Aplicar Mudanças
```bash
terraform apply
terraform apply -var-file="prod.tfvars"
```

### Ver Outputs
```bash
terraform output
```

### Destruir Infraestrutura
```bash
terraform destroy
terraform destroy -var-file="prod.tfvars"
```

### Ver Estado
```bash
terraform show
terraform state list
```

## 📊 Variáveis Configuráveis

| Variável | Descrição | Padrão |
|----------|-----------|--------|
| `aws_region` | Região AWS | sa-east-1 |
| `project_name` | Nome do projeto | faas-products-api |
| `environment` | Ambiente (dev/staging/prod) | dev |
| `lambda_runtime` | Runtime do Lambda | nodejs18.x |
| `lambda_timeout` | Timeout em segundos | 30 |
| `lambda_memory_size` | Memória em MB | 128 |

## 🔒 Segurança

### IAM Roles
- **Lambda Role:** Permissões mínimas para execução
- **CloudWatch:** Acesso para logs
- **API Gateway:** Permissões para invocar Lambda

### Tags
Todos os recursos são taggeados com:
- `Project`: Nome do projeto
- `Environment`: Ambiente (dev/staging/prod)
- `ManagedBy`: "Terraform"
- `Owner`: Responsável

## 📈 Monitoramento

### CloudWatch Logs
- Logs automáticos para todas as funções Lambda
- Retenção configurável (padrão: 14 dias)
- Logs estruturados para fácil análise

### Métricas Disponíveis
- **Lambda:** Duração, erros, invocações
- **API Gateway:** Requisições, latência, erros
- **CloudWatch:** Logs, métricas customizadas

## 💰 Custos

### Estimativa Mensal (dev)
- **Lambda:** ~$1-5/mês (dependendo do uso)
- **API Gateway:** ~$1-3/mês
- **CloudWatch:** Gratuito (primeiros 5GB)

### Otimizações
- **Timeout:** Configurado adequadamente
- **Memory:** Otimizado para performance
- **Logs:** Retenção limitada

## 🔄 Migração entre Provedores

### Para Azure Functions
1. Criar provider `azurerm`
2. Substituir `aws_lambda_function` por `azurerm_function_app`
3. Adaptar API Gateway para Azure API Management
4. Ajustar IAM para Azure RBAC

### Para Google Cloud Functions
1. Criar provider `google`
2. Substituir por `google_cloudfunctions_function`
3. Adaptar para Cloud Run ou Cloud Functions
4. Ajustar permissões para IAM do GCP

## 🛠️ Troubleshooting

### Erro de Permissões
```bash
# Verificar credenciais AWS
aws sts get-caller-identity

# Verificar permissões
aws iam get-user
```

### Erro de State
```bash
# Reimportar recursos
terraform import aws_lambda_function.get_products nome-da-funcao

# Limpar state local
rm -rf .terraform
terraform init
```

### Erro de Backend
```bash
# Configurar backend local
terraform init -backend=false
terraform init -reconfigure
```

## 📝 Próximos Passos

1. **Adicionar CI/CD** com GitHub Actions
2. **Implementar Workspaces** para múltiplos ambientes
3. **Adicionar Validações** de variáveis
4. **Configurar Alertas** CloudWatch
5. **Implementar Backup** automático
