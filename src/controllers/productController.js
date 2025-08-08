const ProductService = require('../services/productService');

class ProductController {
  constructor() {
    this.productService = new ProductService();
  }

  // Helper para criar resposta HTTP
  createResponse(statusCode, body) {
    return {
      statusCode,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token',
        'Access-Control-Allow-Methods': 'GET,POST,PUT,DELETE,OPTIONS'
      },
      body: JSON.stringify(body)
    };
  }

  // Helper para parse do JSON do body
  parseBody(event) {
    if (!event.body) {
      throw new Error('Body da requisição é obrigatório');
    }

    try {
      return JSON.parse(event.body);
    } catch (error) {
      throw new Error('JSON inválido no body da requisição');
    }
  }

  // Helper para extrair ID dos path parameters
  extractId(event) {
    const id = parseInt(event.pathParameters?.id);
    if (!id) {
      throw new Error('ID do produto é obrigatório');
    }
    return id;
  }

  // GET /products - Listar todos os produtos
  async getAllProducts(event) {
    try {
      console.log('Event:', JSON.stringify(event, null, 2));
      
      const result = await this.productService.getAllProducts();
      return this.createResponse(200, result);
      
    } catch (error) {
      console.error('Erro ao processar requisição:', error);
      
      const errorResponse = {
        success: false,
        message: 'Erro interno do servidor',
        error: process.env.NODE_ENV === 'dev' ? error.message : 'Erro interno'
      };
      
      return this.createResponse(500, errorResponse);
    }
  }

  // GET /products/{id} - Buscar produto por ID
  async getProductById(event) {
    try {
      console.log('Event:', JSON.stringify(event, null, 2));
      
      const id = this.extractId(event);
      const result = await this.productService.getProductById(id);
      
      return this.createResponse(200, result);
      
    } catch (error) {
      console.error('Erro ao processar requisição:', error);
      
      let statusCode = 500;
      let message = 'Erro interno do servidor';
      
      if (error.message.includes('ID do produto é obrigatório')) {
        statusCode = 400;
        message = error.message;
      } else if (error.message.includes('não encontrado')) {
        statusCode = 404;
        message = error.message;
      }
      
      const errorResponse = {
        success: false,
        message,
        error: process.env.NODE_ENV === 'dev' ? error.message : 'Erro interno'
      };
      
      return this.createResponse(statusCode, errorResponse);
    }
  }

  // POST /products - Criar produto
  async createProduct(event) {
    try {
      console.log('Event:', JSON.stringify(event, null, 2));
      
      const productData = this.parseBody(event);
      const result = await this.productService.createProduct(productData);
      
      return this.createResponse(201, result);
      
    } catch (error) {
      console.error('Erro ao processar requisição:', error);
      
      let statusCode = 500;
      let message = 'Erro interno do servidor';
      
      if (error.message.includes('Body da requisição é obrigatório') || 
          error.message.includes('JSON inválido') ||
          error.message.includes('Dados inválidos')) {
        statusCode = 400;
        message = error.message;
      }
      
      const errorResponse = {
        success: false,
        message,
        error: process.env.NODE_ENV === 'dev' ? error.message : 'Erro interno'
      };
      
      return this.createResponse(statusCode, errorResponse);
    }
  }

  // PUT /products/{id} - Atualizar produto
  async updateProduct(event) {
    try {
      console.log('Event:', JSON.stringify(event, null, 2));
      
      const id = this.extractId(event);
      const updateData = this.parseBody(event);
      const result = await this.productService.updateProduct(id, updateData);
      
      return this.createResponse(200, result);
      
    } catch (error) {
      console.error('Erro ao processar requisição:', error);
      
      let statusCode = 500;
      let message = 'Erro interno do servidor';
      
      if (error.message.includes('ID do produto é obrigatório') ||
          error.message.includes('Body da requisição é obrigatório') ||
          error.message.includes('JSON inválido') ||
          error.message.includes('Dados inválidos') ||
          error.message.includes('Nenhum campo válido')) {
        statusCode = 400;
        message = error.message;
      } else if (error.message.includes('não encontrado')) {
        statusCode = 404;
        message = error.message;
      }
      
      const errorResponse = {
        success: false,
        message,
        error: process.env.NODE_ENV === 'dev' ? error.message : 'Erro interno'
      };
      
      return this.createResponse(statusCode, errorResponse);
    }
  }

  // DELETE /products/{id} - Deletar produto
  async deleteProduct(event) {
    try {
      console.log('Event:', JSON.stringify(event, null, 2));
      
      const id = this.extractId(event);
      const result = await this.productService.deleteProduct(id);
      
      return this.createResponse(200, result);
      
    } catch (error) {
      console.error('Erro ao processar requisição:', error);
      
      let statusCode = 500;
      let message = 'Erro interno do servidor';
      
      if (error.message.includes('ID do produto é obrigatório')) {
        statusCode = 400;
        message = error.message;
      } else if (error.message.includes('não encontrado')) {
        statusCode = 404;
        message = error.message;
      }
      
      const errorResponse = {
        success: false,
        message,
        error: process.env.NODE_ENV === 'dev' ? error.message : 'Erro interno'
      };
      
      return this.createResponse(statusCode, errorResponse);
    }
  }
}

module.exports = ProductController;
