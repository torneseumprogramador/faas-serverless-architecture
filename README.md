# API Serverless - Lista de Produtos

Uma API serverless construída com AWS Lambda e API Gateway para gerenciar uma lista de produtos.

## 🚀 Tecnologias

- **AWS Lambda** - Funções serverless
- **API Gateway** - Gerenciamento de APIs
- **Serverless Framework** - Framework para deploy
- **Node.js** - Runtime

## 📋 Pré-requisitos

- Node.js 18+
- AWS CLI configurado
- Serverless Framework

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

### Deploy para AWS
```bash
npm run deploy
```

### Deploy para ambiente específico
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
├── serverless.yml
├── package.json
└── README.md
```

## 🔧 Comandos Úteis

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

Para remover todos os recursos da AWS:
```bash
npm run remove
```
