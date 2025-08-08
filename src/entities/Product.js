/**
 * Entidade Product - Define a estrutura e validações para produtos
 * 
 * @typedef {Object} Product
 * @property {number} id - ID único do produto (gerado automaticamente)
 * @property {string} name - Nome do produto (2-100 caracteres)
 * @property {string} description - Descrição do produto (10-500 caracteres)
 * @property {number} price - Preço do produto (maior que 0)
 * @property {string} category - Categoria do produto (2-50 caracteres)
 * @property {boolean} inStock - Status de estoque (padrão: true)
 * @property {string|null} image - URL da imagem (opcional)
 * @property {string} createdAt - Data de criação (ISO string)
 * @property {string} updatedAt - Data de atualização (ISO string)
 */

class Product {
  /**
   * Construtor da entidade Product
   * @param {Object} data - Dados do produto
   * @param {number} [data.id] - ID do produto
   * @param {string} data.name - Nome do produto
   * @param {string} data.description - Descrição do produto
   * @param {number} data.price - Preço do produto
   * @param {string} data.category - Categoria do produto
   * @param {boolean} [data.inStock=true] - Status de estoque
   * @param {string|null} [data.image=null] - URL da imagem
   * @param {string} [data.createdAt] - Data de criação
   * @param {string} [data.updatedAt] - Data de atualização
   */
  constructor(data = {}) {
    this.id = data.id || null;
    this.name = data.name || '';
    this.description = data.description || '';
    this.price = data.price || 0;
    this.category = data.category || '';
    this.inStock = data.inStock !== undefined ? data.inStock : true;
    this.image = data.image || null;
    this.createdAt = data.createdAt || new Date().toISOString();
    this.updatedAt = data.updatedAt || new Date().toISOString();
  }

  /**
   * Valida se a entidade está completa e válida
   * @returns {Object} Resultado da validação
   */
  validate() {
    const errors = [];

    // Validação do nome
    if (!this.name || typeof this.name !== 'string') {
      errors.push('Nome é obrigatório e deve ser uma string');
    } else if (this.name.trim().length < 2) {
      errors.push('Nome deve ter pelo menos 2 caracteres');
    } else if (this.name.trim().length > 100) {
      errors.push('Nome deve ter no máximo 100 caracteres');
    }

    // Validação da descrição
    if (!this.description || typeof this.description !== 'string') {
      errors.push('Descrição é obrigatória e deve ser uma string');
    } else if (this.description.trim().length < 10) {
      errors.push('Descrição deve ter pelo menos 10 caracteres');
    } else if (this.description.trim().length > 500) {
      errors.push('Descrição deve ter no máximo 500 caracteres');
    }

    // Validação do preço
    if (this.price === undefined || this.price === null) {
      errors.push('Preço é obrigatório');
    } else {
      const price = parseFloat(this.price);
      if (isNaN(price)) {
        errors.push('Preço deve ser um número válido');
      } else if (price <= 0) {
        errors.push('Preço deve ser maior que zero');
      } else if (price > 999999.99) {
        errors.push('Preço deve ser menor que 1.000.000');
      }
    }

    // Validação da categoria
    if (!this.category || typeof this.category !== 'string') {
      errors.push('Categoria é obrigatória e deve ser uma string');
    } else if (this.category.trim().length < 2) {
      errors.push('Categoria deve ter pelo menos 2 caracteres');
    } else if (this.category.trim().length > 50) {
      errors.push('Categoria deve ter no máximo 50 caracteres');
    }

    // Validação do estoque
    if (typeof this.inStock !== 'boolean') {
      errors.push('Estoque deve ser um valor booleano');
    }

    // Validação da imagem (opcional)
    if (this.image !== null && this.image !== '') {
      try {
        const url = new URL(this.image);
        if (!['http:', 'https:'].includes(url.protocol)) {
          errors.push('URL da imagem deve usar protocolo HTTP ou HTTPS');
        }
      } catch (error) {
        errors.push('URL da imagem deve ser uma URL válida');
      }
    }

    return {
      isValid: errors.length === 0,
      errors
    };
  }

  /**
   * Normaliza os dados da entidade
   * @returns {Product} Instância normalizada
   */
  normalize() {
    // Normalizar strings (trim)
    this.name = this.name.trim();
    this.description = this.description.trim();
    this.category = this.category.trim();
    
    if (this.image) {
      this.image = this.image.trim();
    }

    // Normalizar preço
    this.price = parseFloat(this.price);

    // Normalizar estoque
    if (typeof this.inStock === 'string') {
      this.inStock = ['true', '1'].includes(this.inStock.toLowerCase());
    } else {
      this.inStock = Boolean(this.inStock);
    }

    // Atualizar timestamps
    this.updatedAt = new Date().toISOString();

    return this;
  }

  /**
   * Converte a entidade para objeto plano
   * @returns {Object} Objeto com os dados da entidade
   */
  toObject() {
    return {
      id: this.id,
      name: this.name,
      description: this.description,
      price: this.price,
      category: this.category,
      inStock: this.inStock,
      image: this.image,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt
    };
  }

  /**
   * Converte a entidade para JSON
   * @returns {string} JSON da entidade
   */
  toJSON() {
    return JSON.stringify(this.toObject());
  }

  /**
   * Cria uma instância de Product a partir de um objeto
   * @param {Object} data - Dados do produto
   * @returns {Product} Nova instância de Product
   */
  static fromObject(data) {
    return new Product(data);
  }

  /**
   * Cria uma instância de Product a partir de JSON
   * @param {string} json - JSON do produto
   * @returns {Product} Nova instância de Product
   */
  static fromJSON(json) {
    try {
      const data = JSON.parse(json);
      return new Product(data);
    } catch (error) {
      throw new Error('JSON inválido para criar Product');
    }
  }

  /**
   * Retorna a estrutura esperada da entidade
   * @returns {Object} Schema da entidade
   */
  static getSchema() {
    return {
      id: { type: 'number', required: false, description: 'ID único do produto' },
      name: { type: 'string', required: true, min: 2, max: 100, description: 'Nome do produto' },
      description: { type: 'string', required: true, min: 10, max: 500, description: 'Descrição do produto' },
      price: { type: 'number', required: true, min: 0.01, max: 999999.99, description: 'Preço do produto' },
      category: { type: 'string', required: true, min: 2, max: 50, description: 'Categoria do produto' },
      inStock: { type: 'boolean', required: false, default: true, description: 'Status de estoque' },
      image: { type: 'string', required: false, description: 'URL da imagem do produto' },
      createdAt: { type: 'string', required: false, description: 'Data de criação (ISO)' },
      updatedAt: { type: 'string', required: false, description: 'Data de atualização (ISO)' }
    };
  }

  /**
   * Retorna os campos obrigatórios
   * @returns {Array} Lista de campos obrigatórios
   */
  static getRequiredFields() {
    return ['name', 'description', 'price', 'category'];
  }

  /**
   * Retorna os campos opcionais
   * @returns {Array} Lista de campos opcionais
   */
  static getOptionalFields() {
    return ['id', 'inStock', 'image', 'createdAt', 'updatedAt'];
  }

  /**
   * Retorna todos os campos da entidade
   * @returns {Array} Lista de todos os campos
   */
  static getAllFields() {
    return [...this.getRequiredFields(), ...this.getOptionalFields()];
  }
}

module.exports = Product;
