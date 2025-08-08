// Validações para produtos
const validateProduct = (productData, isUpdate = false) => {
  const errors = [];
  
  // Validação do nome
  if (!isUpdate || productData.name !== undefined) {
    if (!productData.name || typeof productData.name !== 'string') {
      errors.push('Nome é obrigatório e deve ser uma string');
    } else if (productData.name.trim().length < 2) {
      errors.push('Nome deve ter pelo menos 2 caracteres');
    } else if (productData.name.trim().length > 100) {
      errors.push('Nome deve ter no máximo 100 caracteres');
    }
  }
  
  // Validação da descrição
  if (!isUpdate || productData.description !== undefined) {
    if (!productData.description || typeof productData.description !== 'string') {
      errors.push('Descrição é obrigatória e deve ser uma string');
    } else if (productData.description.trim().length < 10) {
      errors.push('Descrição deve ter pelo menos 10 caracteres');
    } else if (productData.description.trim().length > 500) {
      errors.push('Descrição deve ter no máximo 500 caracteres');
    }
  }
  
  // Validação do preço
  if (!isUpdate || productData.price !== undefined) {
    if (productData.price === undefined || productData.price === null) {
      errors.push('Preço é obrigatório');
    } else {
      const price = parseFloat(productData.price);
      if (isNaN(price)) {
        errors.push('Preço deve ser um número válido');
      } else if (price <= 0) {
        errors.push('Preço deve ser maior que zero');
      } else if (price > 999999.99) {
        errors.push('Preço deve ser menor que 1.000.000');
      }
    }
  }
  
  // Validação da categoria
  if (!isUpdate || productData.category !== undefined) {
    if (!productData.category || typeof productData.category !== 'string') {
      errors.push('Categoria é obrigatória e deve ser uma string');
    } else if (productData.category.trim().length < 2) {
      errors.push('Categoria deve ter pelo menos 2 caracteres');
    } else if (productData.category.trim().length > 50) {
      errors.push('Categoria deve ter no máximo 50 caracteres');
    }
  }
  
  // Validação do estoque (opcional, mas se fornecido deve ser booleano)
  if (productData.inStock !== undefined) {
    if (typeof productData.inStock !== 'boolean' && 
        !(typeof productData.inStock === 'string' && ['true', 'false', '0', '1'].includes(productData.inStock.toLowerCase()))) {
      errors.push('Estoque deve ser um valor booleano (true/false)');
    }
  }
  
  // Validação da imagem (opcional, mas se fornecida deve ser URL válida)
  if (productData.image !== undefined && productData.image !== null && productData.image !== '') {
    try {
      const url = new URL(productData.image);
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
};

// Função para normalizar dados do produto
const normalizeProductData = (productData) => {
  const normalized = { ...productData };
  
  // Normalizar preço
  if (normalized.price !== undefined) {
    normalized.price = parseFloat(normalized.price);
  }
  
  // Normalizar estoque
  if (normalized.inStock !== undefined) {
    if (typeof normalized.inStock === 'string') {
      normalized.inStock = ['true', '1'].includes(normalized.inStock.toLowerCase());
    } else {
      normalized.inStock = Boolean(normalized.inStock);
    }
  }
  
  // Normalizar strings (trim)
  if (normalized.name) normalized.name = normalized.name.trim();
  if (normalized.description) normalized.description = normalized.description.trim();
  if (normalized.category) normalized.category = normalized.category.trim();
  if (normalized.image) normalized.image = normalized.image.trim();
  
  return normalized;
};

module.exports = {
  validateProduct,
  normalizeProductData
};
