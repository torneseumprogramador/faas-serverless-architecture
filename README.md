# API Serverless - Lista de Produtos

Uma API serverless construída com AWS Lambda e API Gateway para gerenciar uma lista de produtos. **Agora com suporte a Terraform para portabilidade entre provedores de nuvem!**

## 🚀 Tecnologias

- **AWS Lambda** - Funções serverless
- **API Gateway** - Gerenciamento de APIs
- **Terraform** - Infraestrutura como Código (IaC)
- **Node.js** - Runtime

## 📋 Pré-requisitos

- Node.js 18+
- AWS CLI configurado
- Terraform (versão >= 1.0)

## 🛠️ Instalação

1. **Instalar Terraform:**
```bash
# macOS
brew install terraform

# Ubuntu/Debian
sudo apt-get install terraform

# Windows
# Baixe de https://www.terraform.io/downloads.html
```

2. **Configurar AWS CLI:**
```bash
aws configure
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



## 🧪 Teste Local

### Script Interativo (Recomendado)
```bash
# Executar script interativo
./scripts/interactive-api.sh
```

O script oferece uma interface amigável para testar todos os endpoints da API.

### Testar API Deployada (Manual)
```bash
# Listar produtos
curl -X GET https://[api-id].execute-api.sa-east-1.amazonaws.com/dev/products

# Buscar produto por ID
curl -X GET https://[api-id].execute-api.sa-east-1.amazonaws.com/dev/products/1
```

Substitua `[api-id]` pelo ID da sua API (mostrado no output do Terraform).

### 📜 Scripts Disponíveis

- **`scripts/interactive-api.sh`** - Script interativo para testar a API
- **`scripts/README.md`** - Documentação detalhada dos scripts

Veja a documentação completa em: [scripts/README.md](scripts/README.md)

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
      "image": "https://example.com/iphone15pro.jpg",
      "createdAt": "2024-01-15T10:30:00.000Z",
      "updatedAt": "2024-01-15T10:30:00.000Z"
    },
    "timestamp": "2024-01-15T10:30:00.000Z"
  }
}
```

### POST /products
Cria um novo produto.

**Exemplo:** `POST /products`

**Body:**
```json
{
  "name": "MacBook Pro M3",
  "description": "Notebook Apple com chip M3 e tela Retina",
  "price": 15999.00,
  "category": "Eletrônicos",
  "inStock": true,
  "image": "https://example.com/macbook-pro.jpg"
}
```

**Resposta:**
```json
{
  "success": true,
  "message": "Produto criado com sucesso",
  "data": {
    "product": {
      "id": 6,
      "name": "MacBook Pro M3",
      "description": "Notebook Apple com chip M3 e tela Retina",
      "price": 15999.00,
      "category": "Eletrônicos",
      "inStock": true,
      "image": "https://example.com/macbook-pro.jpg",
      "createdAt": "2024-01-15T10:30:00.000Z",
      "updatedAt": "2024-01-15T10:30:00.000Z"
    },
    "timestamp": "2024-01-15T10:30:00.000Z"
  }
}
```

### PUT /products/{id}
Atualiza um produto existente.

**Exemplo:** `PUT /products/1`

**Body:**
```json
{
  "name": "iPhone 15 Pro Max",
  "price": 9999.00,
  "inStock": false
}
```

**Resposta:**
```json
{
  "success": true,
  "message": "Produto atualizado com sucesso",
  "data": {
    "product": {
      "id": 1,
      "name": "iPhone 15 Pro Max",
      "description": "Smartphone Apple com chip A17 Pro e câmera tripla",
      "price": 9999.00,
      "category": "Eletrônicos",
      "inStock": false,
      "image": "https://example.com/iphone15pro.jpg",
      "createdAt": "2024-01-15T10:30:00.000Z",
      "updatedAt": "2024-01-15T10:35:00.000Z"
    },
    "timestamp": "2024-01-15T10:35:00.000Z"
  }
}
```

### DELETE /products/{id}
Remove um produto.

**Exemplo:** `DELETE /products/1`

**Resposta:**
```json
{
  "success": true,
  "message": "Produto deletado com sucesso",
  "data": {
    "deletedProduct": {
      "id": 1,
      "name": "iPhone 15 Pro",
      "description": "Smartphone Apple com chip A17 Pro e câmera tripla",
      "price": 8999.00,
      "category": "Eletrônicos",
      "inStock": true,
      "image": "https://example.com/iphone15pro.jpg",
      "createdAt": "2024-01-15T10:30:00.000Z",
      "updatedAt": "2024-01-15T10:30:00.000Z"
    },
    "timestamp": "2024-01-15T10:35:00.000Z"
  }
}
```

## ✅ Validações

A API inclui validações robustas para todos os campos:

### Campos Obrigatórios (POST)
- **name**: String com 2-100 caracteres
- **description**: String com 10-500 caracteres  
- **price**: Número maior que 0 e menor que 1.000.000
- **category**: String com 2-50 caracteres

### Campos Opcionais
- **inStock**: Boolean (padrão: true)
- **image**: URL válida com protocolo HTTP/HTTPS

### Validações Específicas
- **Preço**: Deve ser um número válido maior que zero
- **Estoque**: Aceita boolean, string "true"/"false", ou números 0/1
- **Imagem**: Se fornecida, deve ser uma URL válida
- **Strings**: São automaticamente normalizadas (trim)

### Exemplo de Erro de Validação
```json
{
  "success": false,
  "message": "Dados inválidos",
  "errors": [
    "Nome deve ter pelo menos 2 caracteres",
    "Preço deve ser maior que zero",
    "URL da imagem deve ser uma URL válida"
  ]
}
```

## 🏗️ Arquitetura

O projeto segue uma arquitetura em camadas bem definida:

### 📋 Camadas da Aplicação

1. **Handlers** (`src/handlers/`)
   - Ponto de entrada das funções Lambda
   - Delegam para os controllers
   - Mantêm-se simples e focados

2. **Controllers** (`src/controllers/`)
   - Gerenciam requisições HTTP
   - Tratam parsing de dados e respostas
   - Delegam lógica de negócio para services

3. **Services** (`src/services/`)
   - Contêm a lógica de negócio
   - Implementam validações e regras
   - Orquestram operações complexas

4. **Repositories** (`src/repositories/`)
   - Abstraem acesso a dados
   - Implementam operações CRUD
   - Isolam detalhes do DynamoDB

5. **Utils** (`src/utils/`)
   - Funções utilitárias reutilizáveis
   - Validações e normalizações
   - Helpers compartilhados

### 🔄 Fluxo de Dados
```
HTTP Request → Handler → Controller → Service → Repository → DynamoDB
```

### 🎯 Benefícios da Arquitetura
- **Separação de Responsabilidades**: Cada camada tem uma função específica
- **Testabilidade**: Fácil de testar cada camada isoladamente
- **Manutenibilidade**: Código organizado e fácil de manter
- **Escalabilidade**: Fácil de adicionar novas funcionalidades
- **Reutilização**: Services e repositories podem ser reutilizados

## 📊 Estrutura do Projeto

```
faas-serverless-architecture/
├── src/
│   ├── handlers/          # Handlers das funções Lambda
│   │   ├── getProducts.js
│   │   ├── getProductById.js
│   │   ├── createProduct.js
│   │   ├── updateProduct.js
│   │   └── deleteProduct.js
│   ├── controllers/       # Controllers para gerenciar requisições HTTP
│   │   └── productController.js
│   ├── services/          # Services para lógica de negócio
│   │   └── productService.js
│   ├── repositories/      # Repositories para acesso a dados
│   │   └── productRepository.js
│   └── utils/             # Utilitários
│       └── productValidation.js
├── scripts/               # Scripts de teste e automação
│   ├── interactive-api.sh # Script interativo para testar API
│   └── README.md          # Documentação dos scripts
├── terraform/             # Infraestrutura como Código
│   ├── main.tf
│   ├── variables.tf
│   ├── lambda.tf
│   ├── dynamodb.tf
│   ├── outputs.tf
│   ├── prod.tfvars
│   ├── staging.tfvars
│   ├── terraform.tfvars
│   ├── terraform.tfvars.example
│   ├── deploy.sh
│   ├── destroy.sh
│   ├── .gitignore
│   └── README.md
├── Makefile            # Comandos automatizados
├── package.json
└── README.md
```

## 🔧 Comandos Úteis

### 🚀 Terraform

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

## 📝 Logs

Para ver os logs das funções:
```bash
aws logs tail /aws/lambda/faas-products-api-get-products
aws logs tail /aws/lambda/faas-products-api-get-product-by-id
```

## 🗑️ Limpeza

### 🚀 Terraform

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
