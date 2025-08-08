const ProductRepository = require('../repositories/productRepository');
const { Product } = require('../entities');

class ProductService {
  constructor() {
    this.productRepository = new ProductRepository();
  }

  // Buscar todos os produtos
  async getAllProducts() {
    try {
      const products = await this.productRepository.findAll();
      return {
        success: true,
        message: 'Produtos recuperados com sucesso',
        data: {
          products,
          total: products.length,
          timestamp: new Date().toISOString()
        }
      };
    } catch (error) {
      throw new Error(`Erro ao buscar produtos: ${error.message}`);
    }
  }

  // Buscar produto por ID
  async getProductById(id) {
    try {
      if (!id) {
        throw new Error('ID do produto é obrigatório');
      }

      const product = await this.productRepository.findById(id);
      
      if (!product) {
        throw new Error(`Produto com ID ${id} não encontrado`);
      }

      return {
        success: true,
        message: 'Produto encontrado com sucesso',
        data: {
          product,
          timestamp: new Date().toISOString()
        }
      };
    } catch (error) {
      throw error;
    }
  }

  // Criar produto
  async createProduct(productData) {
    try {
      // Gerar ID único
      const id = await this.productRepository.generateId();
      
      // Criar instância da entidade Product
      const product = new Product({
        ...productData,
        id
      });
      
      // Normalizar e validar
      product.normalize();
      const validation = product.validate();
      
      if (!validation.isValid) {
        throw new Error(`Dados inválidos: ${validation.errors.join(', ')}`);
      }
      
      // Criar produto no repositório
      const createdProduct = await this.productRepository.create(product.toObject());
      
      return {
        success: true,
        message: 'Produto criado com sucesso',
        data: {
          product: createdProduct,
          timestamp: new Date().toISOString()
        }
      };
    } catch (error) {
      throw error;
    }
  }

  // Atualizar produto
  async updateProduct(id, updateData) {
    try {
      if (!id) {
        throw new Error('ID do produto é obrigatório');
      }

      // Verificar se o produto existe
      const existingProduct = await this.productRepository.findById(id);
      if (!existingProduct) {
        throw new Error(`Produto com ID ${id} não encontrado`);
      }

      // Validar se há pelo menos um campo para atualizar
      const allowedFields = Product.getOptionalFields().filter(field => field !== 'id');
      const fieldsToUpdate = Object.keys(updateData).filter(field => allowedFields.includes(field));
      
      if (fieldsToUpdate.length === 0) {
        throw new Error('Nenhum campo válido para atualização fornecido');
      }

      // Criar instância da entidade com dados existentes + atualizações
      const product = new Product({
        ...existingProduct,
        ...updateData
      });
      
      // Normalizar e validar apenas os campos que estão sendo atualizados
      product.normalize();
      
      // Validar apenas os campos que estão sendo atualizados
      const validationData = new Product();
      fieldsToUpdate.forEach(field => {
        validationData[field] = product[field];
      });
      
      const validation = validationData.validate();
      if (!validation.isValid) {
        throw new Error(`Dados inválidos: ${validation.errors.join(', ')}`);
      }
      
      // Preparar dados para atualização
      const updates = {};
      fieldsToUpdate.forEach(field => {
        updates[field] = product[field];
      });
      
      // Atualizar produto
      const updatedProduct = await this.productRepository.update(id, updates);
      
      return {
        success: true,
        message: 'Produto atualizado com sucesso',
        data: {
          product: updatedProduct,
          timestamp: new Date().toISOString()
        }
      };
    } catch (error) {
      throw error;
    }
  }

  // Deletar produto
  async deleteProduct(id) {
    try {
      if (!id) {
        throw new Error('ID do produto é obrigatório');
      }

      // Verificar se o produto existe
      const existingProduct = await this.productRepository.findById(id);
      if (!existingProduct) {
        throw new Error(`Produto com ID ${id} não encontrado`);
      }
      
      // Deletar produto
      await this.productRepository.delete(id);
      
      return {
        success: true,
        message: 'Produto deletado com sucesso',
        data: {
          deletedProduct: existingProduct,
          timestamp: new Date().toISOString()
        }
      };
    } catch (error) {
      throw error;
    }
  }
}

module.exports = ProductService;
