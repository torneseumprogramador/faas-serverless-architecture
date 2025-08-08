# 🚀 FaaS Serverless Architecture - API de Produtos

## 📚 Sobre o Projeto

Este projeto foi desenvolvido como uma **API de Produtos** utilizando **Function as a Service (FaaS)** com **AWS Lambda** e **API Gateway**, demonstrando arquitetura serverless moderna e boas práticas de desenvolvimento.

### 🎯 Objetivo

Implementar uma API REST completa para gerenciamento de produtos utilizando arquitetura serverless, com funcionalidades CRUD (Create, Read, Update, Delete) e validações robustas.

## 🏗️ Arquitetura

O projeto segue uma **arquitetura serverless** com separação clara de responsabilidades:

```
┌─────────────────────────────────────┐
│           API Gateway               │ ← Endpoints REST
├─────────────────────────────────────┤
│         Lambda Functions            │ ← Handlers (HTTP)
├─────────────────────────────────────┤
│         Controllers                 │ ← Lógica de requisições
├─────────────────────────────────────┤
│          Services                   │ ← Lógica de negócio
├─────────────────────────────────────┤
│        Repositories                 │ ← Acesso a dados
├─────────────────────────────────────┤
│         Entities                    │ ← Validações e estrutura
├─────────────────────────────────────┤
│         DynamoDB                   │ ← Banco de dados NoSQL
└─────────────────────────────────────┘
```

### 📁 Estrutura do Projeto

```
faas-serverless-architecture/
├── src/
│   ├── handlers/                     # Handlers das funções Lambda
│   │   ├── getProducts.js
│   │   ├── getProductById.js
│   │   ├── createProduct.js
│   │   ├── updateProduct.js
│   │   └── deleteProduct.js
│   ├── controllers/                  # Controllers para gerenciar requisições HTTP
│   │   └── productController.js
│   ├── services/                     # Services para lógica de negócio
│   │   └── productService.js
│   ├── repositories/                 # Repositories para acesso a dados
│   │   └── productRepository.js
│   ├── entities/                     # Entidades com estrutura e validações
│   │   ├── Product.js
│   │   └── index.js
│   └── utils/                        # Utilitários
├── scripts/                          # Scripts de teste e automação
│   ├── interactive-api.sh           # Script interativo para testar API
│   └── README.md                     # Documentação dos scripts
├── terraform/                        # Infraestrutura como Código
│   ├── main.tf
│   ├── variables.tf
│   ├── lambda.tf
│   ├── dynamodb.tf
│   ├── outputs.tf
│   ├── prod.tfvars
│   ├── deploy.sh
│   └── destroy.sh
├── package.json                      # Dependências Node.js
├── Makefile                          # Comandos de automação
└── README.md                         # Esta documentação
```

## 🚀 Tecnologias Utilizadas

- **AWS Lambda** - Computação serverless
- **API Gateway** - Gerenciamento de APIs REST
- **DynamoDB** - Banco de dados NoSQL
- **Terraform** - Infrastructure as Code (IaC)
- **Node.js** - Runtime JavaScript
- **AWS SDK v3** - SDK oficial da AWS
- **Shell Scripting** - Automação de deploy

## 📋 Pré-requisitos

- [AWS CLI](https://aws.amazon.com/cli/) configurado
- [Terraform](https://www.terraform.io/) instalado
- [Node.js](https://nodejs.org/) (versão 18+)
- [Make](https://www.gnu.org/software/make/) (opcional, para automação)
- [curl](https://curl.se/) e [jq](https://jqlang.github.io/jq/) (para testes)

## ⚡ Como Executar

### Método Rápido (Recomendado)

```bash
# Clone o repositório
git clone <url-do-repositorio>
cd faas-serverless-architecture

# Instalar dependências
make install

# Deploy para desenvolvimento
make deploy-dev

# Testar a API
make test-interactive
```

### Método Manual

```bash
# 1. Instalar dependências
npm install

# 2. Deploy da infraestrutura
cd terraform
./deploy.sh dev
cd ..

# 3. Testar a API
./scripts/interactive-api.sh
```

### Comandos Disponíveis no Makefile

```bash
make help              # Mostrar ajuda
make install           # Instalar dependências
make deploy-dev        # Deploy para desenvolvimento
make deploy-staging    # Deploy para staging
make deploy-prod       # Deploy para produção
make destroy-dev       # Destruir infraestrutura de desenvolvimento
make test-interactive  # Executar script interativo
make test-url          # Mostrar URL da API
make test-endpoints    # Mostrar todos os endpoints
make logs              # Ver logs das funções Lambda
make clean             # Limpar arquivos temporários
```

## 🌐 Acessando a API

Após o deploy, a API estará disponível em:

- **API Base**: `https://[api-id].execute-api.sa-east-1.amazonaws.com/dev`
- **Endpoints**: Veja a seção de endpoints abaixo

## 📖 Endpoints da API

### 📦 Produtos (Products)

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/products` | Listar todos os produtos |
| GET | `/products/{id}` | Buscar produto por ID |
| POST | `/products` | Criar novo produto |
| PUT | `/products/{id}` | Atualizar produto |
| DELETE | `/products/{id}` | Remover produto |

## 🏛️ Arquitetura Implementada

### 📦 Entidades de Domínio

- **Product** - Entidade principal com validações
  - Validação de nome (2-100 caracteres)
  - Validação de preço (positivo)
  - Validação de estoque (boolean)
  - Normalização automática de dados

### 🔄 Camadas da Aplicação

- **Handlers** - Ponto de entrada das funções Lambda
- **Controllers** - Gerenciamento de requisições HTTP
- **Services** - Lógica de negócio
- **Repositories** - Acesso a dados (DynamoDB)
- **Entities** - Estrutura e validações

### 🛡️ Validações Implementadas

- **Nome**: 2-100 caracteres, obrigatório
- **Preço**: Número positivo, obrigatório
- **Estoque**: Boolean, opcional (padrão: true)
- **Categoria**: String, opcional
- **Imagem**: URL, opcional

## 🧪 Exemplos de Uso

### Listar Todos os Produtos

```bash
curl -X GET "https://[api-id].execute-api.sa-east-1.amazonaws.com/dev/products"
```

### Buscar Produto por ID

```bash
curl -X GET "https://[api-id].execute-api.sa-east-1.amazonaws.com/dev/products/1"
```

### Criar Produto

```bash
curl -X POST "https://[api-id].execute-api.sa-east-1.amazonaws.com/dev/products" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "iPhone 15 Pro",
    "description": "Smartphone Apple com chip A17 Pro",
    "price": 8999,
    "category": "Eletrônicos",
    "inStock": true,
    "image": "https://example.com/iphone15pro.jpg"
  }'
```

### Atualizar Produto

```bash
curl -X PUT "https://[api-id].execute-api.sa-east-1.amazonaws.com/dev/products/1" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "iPhone 15 Pro Max",
    "price": 9999
  }'
```

### Deletar Produto

```bash
curl -X DELETE "https://[api-id].execute-api.sa-east-1.amazonaws.com/dev/products/1"
```

## 🛠️ Scripts de Teste

### 📊 Script Interativo

Para facilitar os testes, criamos um script interativo completo:

```bash
# Executar script interativo
make test-interactive

# Ou diretamente
./scripts/interactive-api.sh
```

### 🎯 Funcionalidades do Script

- **Detecção automática da URL** via Terraform
- **Interface colorida e profissional**
- **Teste de conectividade** antes das operações
- **Validação de entrada** e formatação JSON
- **Menu completo** com todas as operações CRUD

### 📋 Opções Disponíveis

1. **Configurar URL da API** - Configuração manual
2. **Listar todos os produtos** - GET /products
3. **Buscar produto por ID** - GET /products/{id}
4. **Criar novo produto** - POST /products
5. **Atualizar produto** - PUT /products/{id}
6. **Deletar produto** - DELETE /products/{id}
7. **Testar todos os endpoints** - Teste completo
8. **Mostrar URL atual** - Informações da API
9. **Sair** - Encerrar script

## 🛡️ Tratamento de Erros

A API possui um sistema robusto de tratamento de erros que garante respostas consistentes:

### 📋 Tipos de Erro

| Código | Tipo | Descrição |
|--------|------|-----------|
| 400 | `ValidationError` | Erro de validação (nome inválido, preço negativo, etc.) |
| 404 | `NotFoundError` | Produto não encontrado |
| 500 | `InternalServerError` | Erro interno do servidor |

### 📝 Formato da Resposta de Erro

```json
{
  "success": false,
  "message": "Dados inválidos: Nome deve ter entre 2 e 100 caracteres",
  "error": "ValidationError",
  "timestamp": "2025-08-08T11:00:00.000Z"
}
```

### 📝 Formato da Resposta de Sucesso

```json
{
  "success": true,
  "message": "Produto criado com sucesso",
  "data": {
    "id": 6,
    "name": "iPhone 15 Pro",
    "description": "Smartphone Apple com chip A17 Pro",
    "price": 8999,
    "category": "Eletrônicos",
    "inStock": true,
    "image": "https://example.com/iphone15pro.jpg",
    "createdAt": "2025-08-08T11:00:00.000Z",
    "updatedAt": "2025-08-08T11:00:00.000Z"
  }
}
```

## 🔧 Configuração da Infraestrutura

O projeto utiliza **Terraform** para gerenciar toda a infraestrutura na AWS:

### 🏗️ Recursos Criados

- **API Gateway** - Endpoints REST
- **Lambda Functions** - 5 funções (CRUD + listagem)
- **DynamoDB Table** - Armazenamento de produtos
- **IAM Roles & Policies** - Permissões de acesso
- **CloudWatch Logs** - Monitoramento e logs

### 📊 Variáveis de Ambiente

```bash
NODE_ENV=dev                    # Ambiente de execução
DYNAMODB_TABLE=products         # Nome da tabela DynamoDB
AWS_REGION=sa-east-1           # Região AWS
```

## 🚀 Deploy e Infraestrutura

### 📦 Deploy Automatizado

```bash
# Deploy para desenvolvimento
make deploy-dev

# Deploy para staging
make deploy-staging

# Deploy para produção
make deploy-prod
```

### 🗑️ Destruir Infraestrutura

```bash
# Destruir ambiente de desenvolvimento
make destroy-dev

# Destruir ambiente de staging
make destroy-staging

# Destruir ambiente de produção
make destroy-prod
```

### 📊 Monitoramento

```bash
# Ver logs das funções Lambda
make logs

# Ver status da infraestrutura
make status
```

## 🎓 Aprendizados do Projeto

Este projeto demonstra os seguintes conceitos:

1. **Serverless Architecture**
   - Function as a Service (FaaS)
   - Event-driven programming
   - Pay-per-use model

2. **Infrastructure as Code (IaC)**
   - Terraform para provisionamento
   - Versionamento de infraestrutura
   - Multi-environment deployment

3. **Arquitetura em Camadas**
   - Separação de responsabilidades
   - Clean Architecture principles
   - Dependency injection

4. **Boas Práticas**
   - Error handling robusto
   - Input validation
   - Logging e monitoring
   - Security best practices

## 👨‍🏫 Sobre o Professor

**Prof. Danilo Aparecido** é instrutor na plataforma [Torne-se um Programador](https://www.torneseumprogramador.com.br/), especializado em arquiteturas de software, desenvolvimento de sistemas escaláveis e tecnologias modernas como serverless computing.

## 📚 Curso Completo

Para aprender mais sobre arquiteturas de software, serverless computing e aprofundar seus conhecimentos, acesse o curso completo:

**[Arquiteturas de Software Modernas](https://www.torneseumprogramador.com.br/cursos/arquiteturas_software)**

## 🎓 Aprendizados do Curso

Este projeto demonstra os seguintes conceitos aprendidos no curso:

1. **Serverless Architecture**
   - Function as a Service (FaaS)
   - Event-driven programming
   - Pay-per-use model
   - AWS Lambda e API Gateway

2. **Infrastructure as Code (IaC)**
   - Terraform para provisionamento
   - Versionamento de infraestrutura
   - Multi-environment deployment
   - Cloud-agnostic approach

3. **Arquitetura em Camadas**
   - Separação de responsabilidades
   - Clean Architecture principles
   - Dependency injection
   - Domain-driven design concepts

4. **Boas Práticas**
   - Error handling robusto
   - Input validation
   - Logging e monitoring
   - Security best practices
   - Code organization

## 🤝 Contribuição

Este projeto foi desenvolvido como parte do curso de Arquiteturas de Software Modernas. Contribuições são bem-vindas através de issues e pull requests.

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

**Desenvolvido com ❤️ para o curso de Arquiteturas de Software do [Torne-se um Programador](https://www.torneseumprogramador.com.br/)** 🚀
