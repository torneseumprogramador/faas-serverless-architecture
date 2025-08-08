# 📜 Scripts

Esta pasta contém scripts úteis para interagir com a API.

## 🚀 Scripts Disponíveis

### `interactive-api.sh`

Script interativo para testar a API de produtos.

#### 🎯 Funcionalidades

- **Menu interativo** com interface colorida
- **Teste de todos os endpoints** CRUD
- **Validação de conexão** com a API
- **Formatação JSON** das respostas (requer `jq`)
- **Confirmação de operações** destrutivas

#### 📋 Opções do Menu

1. **Configurar URL da API** - Define a URL base da API
2. **Listar todos os produtos** - GET /products
3. **Buscar produto por ID** - GET /products/{id}
4. **Criar novo produto** - POST /products
5. **Atualizar produto** - PUT /products/{id}
6. **Deletar produto** - DELETE /products/{id}
7. **Testar todos os endpoints** - Executa todos os testes automaticamente
8. **Mostrar URL atual** - Exibe a URL configurada
9. **Sair** - Encerra o script

#### 🛠️ Pré-requisitos

- **curl** - Para fazer requisições HTTP
- **jq** (opcional) - Para formatar JSON
  ```bash
  # macOS
  brew install jq
  
  # Ubuntu/Debian
  sudo apt-get install jq
  ```

#### 🚀 Como Usar

```bash
# Executar o script
./scripts/interactive-api.sh

# Ou navegar para a pasta scripts
cd scripts
./interactive-api.sh
```

#### 📝 Exemplo de Uso

```bash
# 1. Execute o script
./scripts/interactive-api.sh

# 2. Configure a URL da API (opção 1)
# Digite: https://abc123.execute-api.sa-east-1.amazonaws.com/dev

# 3. Teste todos os endpoints (opção 7)
# O script irá:
# - Listar produtos existentes
# - Criar um produto de teste
# - Buscar o produto criado
# - Atualizar o produto
# - Deletar o produto

# 4. Teste operações individuais
# - Opção 2: Listar produtos
# - Opção 4: Criar produto manualmente
# - Opção 5: Atualizar produto específico
```

#### 🎨 Interface

O script possui uma interface colorida e amigável:

- 🔵 **Azul** - Títulos e menus
- 🟢 **Verde** - Sucessos e informações positivas
- 🟡 **Amarelo** - Avisos e prompts
- 🔴 **Vermelho** - Erros e alertas
- 🟣 **Roxo** - Destaques especiais

#### ⚠️ Segurança

- **Confirmação obrigatória** para operações destrutivas (DELETE)
- **Validação de entrada** para IDs e dados
- **Teste de conexão** antes de cada operação
- **Tratamento de erros** com mensagens claras

#### 🔧 Personalização

Você pode modificar o script para:

- Adicionar novos endpoints
- Alterar cores da interface
- Modificar dados de teste
- Adicionar validações específicas

#### 📊 Logs

O script exibe:
- **Status das requisições** (sucesso/erro)
- **Códigos HTTP** das respostas
- **Dados enviados** e recebidos
- **Tempo de resposta** (implícito)

---

## 🤝 Contribuindo

Para adicionar novos scripts:

1. Crie o arquivo na pasta `scripts/`
2. Torne-o executável: `chmod +x scripts/nome-do-script.sh`
3. Documente no README.md
4. Teste com diferentes cenários
5. Faça commit das mudanças
