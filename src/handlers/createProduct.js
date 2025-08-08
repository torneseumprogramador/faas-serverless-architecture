const { createProduct, generateId } = require('../utils/dynamodb');

const createResponse = (statusCode, body) => ({
  statusCode,
  headers: {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token',
    'Access-Control-Allow-Methods': 'GET,POST,PUT,DELETE,OPTIONS'
  },
  body: JSON.stringify(body)
});

exports.handler = async (event) => {
  try {
    console.log('Event:', JSON.stringify(event, null, 2));
    
    // Verificar se há body na requisição
    if (!event.body) {
      return createResponse(400, {
        success: false,
        message: 'Body da requisição é obrigatório'
      });
    }
    
    // Parse do JSON
    let productData;
    try {
      productData = JSON.parse(event.body);
    } catch (error) {
      return createResponse(400, {
        success: false,
        message: 'JSON inválido no body da requisição'
      });
    }
    
    // Validar campos obrigatórios
    const requiredFields = ['name', 'description', 'price', 'category'];
    const missingFields = requiredFields.filter(field => !productData[field]);
    
    if (missingFields.length > 0) {
      return createResponse(400, {
        success: false,
        message: `Campos obrigatórios faltando: ${missingFields.join(', ')}`
      });
    }
    
    // Gerar ID único
    const id = await generateId();
    
    // Preparar dados do produto
    const product = {
      id,
      name: productData.name,
      description: productData.description,
      price: parseFloat(productData.price),
      category: productData.category,
      inStock: productData.inStock !== undefined ? productData.inStock : true,
      image: productData.image || null
    };
    
    // Criar produto no DynamoDB
    const createdProduct = await createProduct(product);
    
    const response = {
      success: true,
      message: 'Produto criado com sucesso',
      data: {
        product: createdProduct,
        timestamp: new Date().toISOString()
      }
    };
    
    return createResponse(201, response);
    
  } catch (error) {
    console.error('Erro ao processar requisição:', error);
    
    const errorResponse = {
      success: false,
      message: 'Erro interno do servidor',
      error: process.env.NODE_ENV === 'dev' ? error.message : 'Erro interno'
    };
    
    return createResponse(500, errorResponse);
  }
};
