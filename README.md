# API Serverless - Lista de Produtos

Uma API serverless construída com AWS Lambda e API Gateway para gerenciar uma lista de produtos. **Agora com suporte a Terraform para portabilidade entre provedores de nuvem!**

## 🚀 Tecnologias

- **AWS Lambda** - Funções serverless
- **API Gateway** - Gerenciamento de APIs
- **Terraform** - Infraestrutura como Código (IaC)
- **Serverless Framework** - Framework para deploy (legado)
- **Node.js** - Runtime

## 📋 Pré-requisitos

- Node.js 18+
- AWS CLI configurado
- Terraform (versão >= 1.0) - **Recomendado**
- Serverless Framework - **Legado**

## 🛠️ Instalação

1. **Instalar dependências:**
```bash
npm install
```

2. **Instalar Serverless Framework globalmente:**
```bash
npm install -g serverless
```

## 🚀 Deploy

### 🆕 Deploy com Terraform (Recomendado)

#### Deploy Rápido com Scripts
```bash
# Deploy para desenvolvimento
./terraform/deploy.sh dev

# Deploy para staging
./terraform/deploy.sh staging

# Deploy para produção
./terraform/deploy.sh prod
```

#### Deploy com Makefile
```bash
# Ver todos os comandos disponíveis
make help

# Deploy para desenvolvimento
make deploy-dev

# Deploy para staging
make deploy-staging

# Deploy para produção
make deploy-prod
```

#### Deploy Manual
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 🔄 Deploy com Serverless Framework (Legado)

#### Deploy para AWS
```bash
npm run deploy
```

#### Deploy para ambiente específico
```bash
serverless deploy --stage prod
```

## 🧪 Teste Local

### Executar localmente
```bash
serverless offline
```

A API estará disponível em: `http://localhost:3000`

## 📡 Endpoints

### GET /products
Retorna a lista completa de produtos.

**Resposta:**
```json
{
  "success": true,
  "message": "Produtos recuperados com sucesso",
  "data": {
    "products": [...],
    "total": 5,
    "timestamp": "2024-01-15T10:30:00.000Z"
  }
}
```

### GET /products/{id}
Retorna um produto específico pelo ID.

**Exemplo:** `GET /products/1`

**Resposta:**
```json
{
  "success": true,
  "message": "Produto encontrado com sucesso",
  "data": {
    "product": {
      "id": 1,
      "name": "iPhone 15 Pro",
      "description": "Smartphone Apple com chip A17 Pro e câmera tripla",
      "price": 8999.00,
      "category": "Eletrônicos",
      "inStock": true,
      "image": "https://example.com/iphone15pro.jpg"
    },
    "timestamp": "2024-01-15T10:30:00.000Z"
  }
}
```

## 📊 Estrutura do Projeto

```
faas-serverless-architecture/
├── src/
│   ├── handlers/
│   │   ├── getProducts.js
│   │   └── getProductById.js
│   └── data/
│       └── products.js
├── terraform/           # 🆕 Infraestrutura como Código
│   ├── main.tf
│   ├── variables.tf
│   ├── lambda.tf
│   ├── outputs.tf
│   ├── prod.tfvars
│   ├── staging.tfvars
│   └── README.md
├── serverless.yml       # 🔄 Legado
├── package.json
└── README.md
```

## 🔧 Comandos Úteis

### 🆕 Terraform (Recomendado)

#### Scripts Automatizados
- `./terraform/deploy.sh [dev|staging|prod]` - Deploy automatizado
- `./terraform/destroy.sh [dev|staging|prod]` - Destruir infraestrutura

#### Makefile
- `make help` - Ver todos os comandos disponíveis
- `make deploy-dev` - Deploy para desenvolvimento
- `make deploy-staging` - Deploy para staging
- `make deploy-prod` - Deploy para produção
- `make destroy-dev` - Destruir desenvolvimento
- `make destroy-staging` - Destruir staging
- `make destroy-prod` - Destruir produção
- `make status` - Verificar status da infraestrutura
- `make logs` - Ver logs das funções
- `make clean` - Limpar arquivos temporários

#### Comandos Terraform Diretos
- `terraform init` - Inicializar Terraform
- `terraform plan` - Verificar plano de mudanças
- `terraform apply` - Aplicar mudanças
- `terraform destroy` - Remover recursos
- `terraform output` - Ver outputs

### 🔄 Serverless Framework (Legado)
- `npm run deploy` - Deploy para AWS
- `npm run remove` - Remover recursos da AWS
- `npm run logs` - Ver logs das funções
- `serverless offline` - Executar localmente

## 📝 Logs

Para ver os logs das funções:
```bash
serverless logs -f getProducts
serverless logs -f getProductById
```

## 🗑️ Limpeza

### 🆕 Terraform (Recomendado)

#### Limpeza Rápida com Scripts
```bash
# Destruir infraestrutura de desenvolvimento
./terraform/destroy.sh dev

# Destruir infraestrutura de staging
./terraform/destroy.sh staging

# Destruir infraestrutura de produção
./terraform/destroy.sh prod
```

#### Limpeza com Makefile
```bash
# Destruir infraestrutura de desenvolvimento
make destroy-dev

# Destruir infraestrutura de staging
make destroy-staging

# Destruir infraestrutura de produção
make destroy-prod
```

#### Limpeza Manual
```bash
cd terraform
terraform destroy
```

### 🔄 Serverless Framework (Legado)
Para remover todos os recursos da AWS:
```bash
npm run remove
```

## 🌍 Portabilidade entre Provedores

Com o Terraform, você pode facilmente migrar para outros provedores:

### Azure Functions
- Substituir provider `aws` por `azurerm`
- Adaptar recursos para Azure Functions
- Usar Azure API Management

### Google Cloud Functions
- Substituir provider `aws` por `google`
- Adaptar para Cloud Functions
- Usar Cloud Run ou Cloud Functions

### Benefícios da Migração
- ✅ **Código reutilizável** entre provedores
- ✅ **Configuração consistente** de ambientes
- ✅ **Versionamento** da infraestrutura
- ✅ **Rollback** fácil de mudanças
- ✅ **Colaboração** em equipe
