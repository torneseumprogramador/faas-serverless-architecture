#!/bin/bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Variáveis globais
API_URL=""
API_ID=""

# Função para exibir banner
show_banner() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    API INTERACTIVE TESTER                    ║"
    echo "║                FaaS Serverless Architecture                 ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Função para exibir menu principal
show_menu() {
    echo -e "\n${BLUE}=== MENU PRINCIPAL ===${NC}"
    echo -e "${YELLOW}1.${NC} Configurar URL da API"
    echo -e "${YELLOW}2.${NC} Listar todos os produtos"
    echo -e "${YELLOW}3.${NC} Buscar produto por ID"
    echo -e "${YELLOW}4.${NC} Criar novo produto"
    echo -e "${YELLOW}5.${NC} Atualizar produto"
    echo -e "${YELLOW}6.${NC} Deletar produto"
    echo -e "${YELLOW}7.${NC} Testar todos os endpoints"
    echo -e "${YELLOW}8.${NC} Mostrar URL atual"
    echo -e "${YELLOW}9.${NC} Sair"
    echo -e "\n${BLUE}Escolha uma opção:${NC} "
}

# Função para configurar URL da API
configure_api_url() {
    echo -e "\n${CYAN}=== CONFIGURAR URL DA API ===${NC}"
    
    if [ -z "$API_URL" ]; then
        echo -e "${YELLOW}URL da API não configurada.${NC}"
        echo -e "Exemplo: https://abc123.execute-api.sa-east-1.amazonaws.com/dev"
        echo -e "Digite a URL da API: "
        read -r API_URL
    else
        echo -e "${GREEN}URL atual:${NC} $API_URL"
        echo -e "Digite a nova URL da API (ou pressione Enter para manter): "
        read -r new_url
        if [ ! -z "$new_url" ]; then
            API_URL="$new_url"
        fi
    fi
    
    echo -e "${GREEN}URL configurada:${NC} $API_URL"
}

# Função para testar se a API está acessível
test_api_connection() {
    if [ -z "$API_URL" ]; then
        echo -e "${RED}Erro: URL da API não configurada.${NC}"
        return 1
    fi
    
    echo -e "\n${CYAN}Testando conexão com a API...${NC}"
    response=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL/products")
    
    if [ "$response" = "200" ] || [ "$response" = "404" ]; then
        echo -e "${GREEN}✓ API está acessível (HTTP $response)${NC}"
        return 0
    else
        echo -e "${RED}✗ Erro ao conectar com a API (HTTP $response)${NC}"
        return 1
    fi
}

# Função para listar todos os produtos
list_products() {
    echo -e "\n${CYAN}=== LISTAR TODOS OS PRODUTOS ===${NC}"
    
    if ! test_api_connection; then
        return
    fi
    
    echo -e "${YELLOW}Fazendo requisição GET /products...${NC}"
    response=$(curl -s "$API_URL/products")
    
    echo -e "${GREEN}Resposta:${NC}"
    echo "$response" | jq '.' 2>/dev/null || echo "$response"
}

# Função para buscar produto por ID
get_product_by_id() {
    echo -e "\n${CYAN}=== BUSCAR PRODUTO POR ID ===${NC}"
    
    if ! test_api_connection; then
        return
    fi
    
    echo -e "Digite o ID do produto: "
    read -r product_id
    
    if [ -z "$product_id" ]; then
        echo -e "${RED}ID do produto é obrigatório.${NC}"
        return
    fi
    
    echo -e "${YELLOW}Fazendo requisição GET /products/$product_id...${NC}"
    response=$(curl -s "$API_URL/products/$product_id")
    
    echo -e "${GREEN}Resposta:${NC}"
    echo "$response" | jq '.' 2>/dev/null || echo "$response"
}

# Função para criar produto
create_product() {
    echo -e "\n${CYAN}=== CRIAR NOVO PRODUTO ===${NC}"
    
    if ! test_api_connection; then
        return
    fi
    
    echo -e "${YELLOW}Digite os dados do produto:${NC}"
    
    echo -e "Nome: "
    read -r name
    
    echo -e "Descrição: "
    read -r description
    
    echo -e "Preço: "
    read -r price
    
    echo -e "Categoria: "
    read -r category
    
    echo -e "Em estoque? (true/false): "
    read -r in_stock
    
    echo -e "URL da imagem (opcional): "
    read -r image
    
    # Criar JSON do produto
    product_json=$(cat <<EOF
{
  "name": "$name",
  "description": "$description",
  "price": $price,
  "category": "$category",
  "inStock": $in_stock,
  "image": "$image"
}
EOF
)
    
    echo -e "\n${YELLOW}Produto a ser criado:${NC}"
    echo "$product_json" | jq '.' 2>/dev/null || echo "$product_json"
    
    echo -e "\n${YELLOW}Confirmar criação? (y/n):${NC} "
    read -r confirm
    
    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
        echo -e "${YELLOW}Fazendo requisição POST /products...${NC}"
        response=$(curl -s -X POST \
            -H "Content-Type: application/json" \
            -d "$product_json" \
            "$API_URL/products")
        
        echo -e "${GREEN}Resposta:${NC}"
        echo "$response" | jq '.' 2>/dev/null || echo "$response"
    else
        echo -e "${YELLOW}Operação cancelada.${NC}"
    fi
}

# Função para atualizar produto
update_product() {
    echo -e "\n${CYAN}=== ATUALIZAR PRODUTO ===${NC}"
    
    if ! test_api_connection; then
        return
    fi
    
    echo -e "Digite o ID do produto: "
    read -r product_id
    
    if [ -z "$product_id" ]; then
        echo -e "${RED}ID do produto é obrigatório.${NC}"
        return
    fi
    
    echo -e "${YELLOW}Digite os campos a serem atualizados (deixe vazio para pular):${NC}"
    
    echo -e "Nome: "
    read -r name
    
    echo -e "Descrição: "
    read -r description
    
    echo -e "Preço: "
    read -r price
    
    echo -e "Categoria: "
    read -r category
    
    echo -e "Em estoque? (true/false): "
    read -r in_stock
    
    echo -e "URL da imagem: "
    read -r image
    
    # Criar JSON de atualização
    update_json="{"
    first=true
    
    if [ ! -z "$name" ]; then
        update_json="$update_json\"name\": \"$name\""
        first=false
    fi
    
    if [ ! -z "$description" ]; then
        if [ "$first" = false ]; then
            update_json="$update_json, "
        fi
        update_json="$update_json\"description\": \"$description\""
        first=false
    fi
    
    if [ ! -z "$price" ]; then
        if [ "$first" = false ]; then
            update_json="$update_json, "
        fi
        update_json="$update_json\"price\": $price"
        first=false
    fi
    
    if [ ! -z "$category" ]; then
        if [ "$first" = false ]; then
            update_json="$update_json, "
        fi
        update_json="$update_json\"category\": \"$category\""
        first=false
    fi
    
    if [ ! -z "$in_stock" ]; then
        if [ "$first" = false ]; then
            update_json="$update_json, "
        fi
        update_json="$update_json\"inStock\": $in_stock"
        first=false
    fi
    
    if [ ! -z "$image" ]; then
        if [ "$first" = false ]; then
            update_json="$update_json, "
        fi
        update_json="$update_json\"image\": \"$image\""
    fi
    
    update_json="$update_json}"
    
    echo -e "\n${YELLOW}Campos a serem atualizados:${NC}"
    echo "$update_json" | jq '.' 2>/dev/null || echo "$update_json"
    
    echo -e "\n${YELLOW}Confirmar atualização? (y/n):${NC} "
    read -r confirm
    
    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
        echo -e "${YELLOW}Fazendo requisição PUT /products/$product_id...${NC}"
        response=$(curl -s -X PUT \
            -H "Content-Type: application/json" \
            -d "$update_json" \
            "$API_URL/products/$product_id")
        
        echo -e "${GREEN}Resposta:${NC}"
        echo "$response" | jq '.' 2>/dev/null || echo "$response"
    else
        echo -e "${YELLOW}Operação cancelada.${NC}"
    fi
}

# Função para deletar produto
delete_product() {
    echo -e "\n${CYAN}=== DELETAR PRODUTO ===${NC}"
    
    if ! test_api_connection; then
        return
    fi
    
    echo -e "Digite o ID do produto: "
    read -r product_id
    
    if [ -z "$product_id" ]; then
        echo -e "${RED}ID do produto é obrigatório.${NC}"
        return
    fi
    
    echo -e "${RED}ATENÇÃO: Esta operação não pode ser desfeita!${NC}"
    echo -e "Confirmar exclusão do produto ID $product_id? (y/n): "
    read -r confirm
    
    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
        echo -e "${YELLOW}Fazendo requisição DELETE /products/$product_id...${NC}"
        response=$(curl -s -X DELETE "$API_URL/products/$product_id")
        
        echo -e "${GREEN}Resposta:${NC}"
        echo "$response" | jq '.' 2>/dev/null || echo "$response"
    else
        echo -e "${YELLOW}Operação cancelada.${NC}"
    fi
}

# Função para testar todos os endpoints
test_all_endpoints() {
    echo -e "\n${CYAN}=== TESTAR TODOS OS ENDPOINTS ===${NC}"
    
    if ! test_api_connection; then
        return
    fi
    
    echo -e "${YELLOW}1. Testando GET /products...${NC}"
    response=$(curl -s "$API_URL/products")
    echo "$response" | jq '.' 2>/dev/null || echo "$response"
    
    echo -e "\n${YELLOW}2. Testando POST /products (criando produto de teste)...${NC}"
    test_product='{
      "name": "Produto Teste",
      "description": "Produto criado pelo script de teste",
      "price": 99.99,
      "category": "Teste",
      "inStock": true,
      "image": "https://example.com/test.jpg"
    }'
    
    response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -d "$test_product" \
        "$API_URL/products")
    echo "$response" | jq '.' 2>/dev/null || echo "$response"
    
    # Extrair ID do produto criado
    product_id=$(echo "$response" | jq -r '.data.product.id' 2>/dev/null)
    
    if [ ! -z "$product_id" ] && [ "$product_id" != "null" ]; then
        echo -e "\n${YELLOW}3. Testando GET /products/$product_id...${NC}"
        response=$(curl -s "$API_URL/products/$product_id")
        echo "$response" | jq '.' 2>/dev/null || echo "$response"
        
        echo -e "\n${YELLOW}4. Testando PUT /products/$product_id...${NC}"
        update_data='{
          "name": "Produto Teste Atualizado",
          "price": 149.99
        }'
        
        response=$(curl -s -X PUT \
            -H "Content-Type: application/json" \
            -d "$update_data" \
            "$API_URL/products/$product_id")
        echo "$response" | jq '.' 2>/dev/null || echo "$response"
        
        echo -e "\n${YELLOW}5. Testando DELETE /products/$product_id...${NC}"
        response=$(curl -s -X DELETE "$API_URL/products/$product_id")
        echo "$response" | jq '.' 2>/dev/null || echo "$response"
    else
        echo -e "${RED}Erro: Não foi possível extrair o ID do produto criado.${NC}"
    fi
    
    echo -e "\n${GREEN}✓ Teste de todos os endpoints concluído!${NC}"
}

# Função para mostrar URL atual
show_current_url() {
    echo -e "\n${CYAN}=== URL ATUAL ===${NC}"
    if [ -z "$API_URL" ]; then
        echo -e "${RED}URL da API não configurada.${NC}"
    else
        echo -e "${GREEN}URL atual:${NC} $API_URL"
    fi
}

# Função principal
main() {
    show_banner
    
    # Verificar se jq está instalado
    if ! command -v jq &> /dev/null; then
        echo -e "${YELLOW}Aviso: jq não está instalado. As respostas JSON não serão formatadas.${NC}"
        echo -e "Para instalar no macOS: brew install jq"
        echo -e "Para instalar no Ubuntu: sudo apt-get install jq"
        echo -e ""
    fi
    
    # Loop principal
    while true; do
        show_menu
        read -r choice
        
        case $choice in
            1)
                configure_api_url
                ;;
            2)
                list_products
                ;;
            3)
                get_product_by_id
                ;;
            4)
                create_product
                ;;
            5)
                update_product
                ;;
            6)
                delete_product
                ;;
            7)
                test_all_endpoints
                ;;
            8)
                show_current_url
                ;;
            9)
                echo -e "\n${GREEN}Obrigado por usar o API Interactive Tester! 👋${NC}"
                exit 0
                ;;
            *)
                echo -e "\n${RED}Opção inválida. Tente novamente.${NC}"
                ;;
        esac
        
        echo -e "\n${BLUE}Pressione Enter para continuar...${NC}"
        read -r
    done
}

# Executar função principal
main
