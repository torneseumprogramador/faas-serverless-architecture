const ProductRepository = require('../repositories/productRepository');
const { validateProduct, normalizeProductData } = require('../utils/validation');

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
      // Normalizar dados
      const normalizedData = normalizeProductData(productData);
      
      // Validar dados do produto
      const validation = validateProduct(normalizedData, false);
      if (!validation.isValid) {
        throw new Error(`Dados inválidos: ${validation.errors.join(', ')}`);
      }
      
      // Gerar ID único
      const id = await this.productRepository.generateId();
      
      // Preparar dados do produto
      const product = {
        id,
        name: normalizedData.name,
        description: normalizedData.description,
        price: normalizedData.price,
        category: normalizedData.category,
        inStock: normalizedData.inStock !== undefined ? normalizedData.inStock : true,
        image: normalizedData.image || null
      };
      
      // Criar produto
      const createdProduct = await this.productRepository.create(product);
      
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
      const allowedFields = ['name', 'description', 'price', 'category', 'inStock', 'image'];
      const fieldsToUpdate = Object.keys(updateData).filter(field => allowedFields.includes(field));
      
      if (fieldsToUpdate.length === 0) {
        throw new Error('Nenhum campo válido para atualização fornecido');
      }

      // Normalizar dados
      const normalizedData = normalizeProductData(updateData);
      
      // Validar dados do produto (apenas os campos que estão sendo atualizados)
      const validationData = {};
      fieldsToUpdate.forEach(field => {
        validationData[field] = normalizedData[field];
      });
      
      const validation = validateProduct(validationData, true);
      if (!validation.isValid) {
        throw new Error(`Dados inválidos: ${validation.errors.join(', ')}`);
      }
      
      // Preparar dados para atualização
      const updates = {};
      fieldsToUpdate.forEach(field => {
        updates[field] = normalizedData[field];
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
