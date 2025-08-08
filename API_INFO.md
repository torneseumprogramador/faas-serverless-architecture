# API FaaS - Informações de Deploy

## 🚀 Status: **DEPLOYADO COM SUCESSO**

### 📍 Endpoints Disponíveis

**Base URL:** `https://4nqep63060.execute-api.sa-east-1.amazonaws.com/dev`

#### 1. Listar Todos os Produtos
- **URL:** `GET /products`
- **Endpoint Completo:** `https://4nqep63060.execute-api.sa-east-1.amazonaws.com/dev/products`
- **Status:** ✅ Funcionando

#### 2. Buscar Produto por ID
- **URL:** `GET /products/{id}`
- **Endpoint Completo:** `https://4nqep63060.execute-api.sa-east-1.amazonaws.com/dev/products/{id}`
- **Status:** ✅ Funcionando

### 🧪 Testes Realizados

#### ✅ Teste 1: Listar Produtos
```bash
curl -X GET https://4nqep63060.execute-api.sa-east-1.amazonaws.com/dev/products
```
**Resultado:** Retornou 5 produtos com sucesso

#### ✅ Teste 2: Buscar Produto Específico
```bash
curl -X GET https://4nqep63060.execute-api.sa-east-1.amazonaws.com/dev/products/1
```
**Resultado:** Retornou iPhone 15 Pro com sucesso

#### ✅ Teste 3: Produto Não Encontrado
```bash
curl -X GET https://4nqep63060.execute-api.sa-east-1.amazonaws.com/dev/products/999
```
**Resultado:** Retornou erro 404 corretamente

### 📊 Recursos AWS Criados

- **Lambda Functions:** 2 funções (getProducts, getProductById)
- **API Gateway:** REST API configurada
- **CloudWatch Logs:** Logs configurados
- **IAM Roles:** Permissões configuradas
- **S3 Bucket:** Bucket de deployment criado

### 🔧 Comandos Úteis

#### Ver Logs
```bash
serverless logs -f getProducts
serverless logs -f getProductById
```

#### Remover Deploy
```bash
serverless remove
```

#### Fazer Novo Deploy
```bash
serverless deploy
```

### 📈 Monitoramento

- **CloudWatch:** Logs disponíveis para cada função
- **API Gateway:** Métricas de requisições
- **Lambda:** Métricas de execução e duração

### 🔒 Segurança

- **CORS:** Configurado para permitir requisições cross-origin
- **IAM:** Permissões mínimas necessárias
- **HTTPS:** Endpoints seguros via API Gateway

### 💰 Custos

- **Lambda:** Cobrança por execução (100ms)
- **API Gateway:** Cobrança por requisição
- **CloudWatch:** Logs gratuitos (primeiros 5GB)

### 🎯 Próximos Passos

1. **Adicionar Autenticação** (se necessário)
2. **Conectar com Banco de Dados** (DynamoDB/RDS)
3. **Adicionar Cache** (ElastiCache)
4. **Implementar Rate Limiting**
5. **Adicionar Monitoramento Avançado**

---

**Deploy realizado em:** 08/08/2025  
**Região AWS:** sa-east-1 (São Paulo)  
**Stack:** faas-products-api-dev
