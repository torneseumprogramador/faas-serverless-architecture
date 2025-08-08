const { updateProduct, getProductById } = require('../utils/dynamodb');

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
    
    // Extrair o ID do path parameter
    const productId = parseInt(event.pathParameters?.id);
    
    if (!productId) {
      return createResponse(400, {
        success: false,
        message: 'ID do produto é obrigatório'
      });
    }
    
    // Verificar se o produto existe
    const existingProduct = await getProductById(productId);
    if (!existingProduct) {
      return createResponse(404, {
        success: false,
        message: `Produto com ID ${productId} não encontrado`
      });
    }
    
    // Verificar se há body na requisição
    if (!event.body) {
      return createResponse(400, {
        success: false,
        message: 'Body da requisição é obrigatório'
      });
    }
    
    // Parse do JSON
    let updateData;
    try {
      updateData = JSON.parse(event.body);
    } catch (error) {
      return createResponse(400, {
        success: false,
        message: 'JSON inválido no body da requisição'
      });
    }
    
    // Validar se há pelo menos um campo para atualizar
    const allowedFields = ['name', 'description', 'price', 'category', 'inStock', 'image'];
    const fieldsToUpdate = Object.keys(updateData).filter(field => allowedFields.includes(field));
    
    if (fieldsToUpdate.length === 0) {
      return createResponse(400, {
        success: false,
        message: 'Nenhum campo válido para atualização fornecido'
      });
    }
    
    // Preparar dados para atualização
    const updates = {};
    fieldsToUpdate.forEach(field => {
      if (field === 'price') {
        updates[field] = parseFloat(updateData[field]);
      } else if (field === 'inStock') {
        updates[field] = Boolean(updateData[field]);
      } else {
        updates[field] = updateData[field];
      }
    });
    
    // Atualizar produto no DynamoDB
    const updatedProduct = await updateProduct(productId, updates);
    
    const response = {
      success: true,
      message: 'Produto atualizado com sucesso',
      data: {
        product: updatedProduct,
        timestamp: new Date().toISOString()
      }
    };
    
    return createResponse(200, response);
    
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
