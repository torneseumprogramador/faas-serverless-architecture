const { deleteProduct, getProductById } = require('../utils/dynamodb');

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
    
    // Deletar produto do DynamoDB
    await deleteProduct(productId);
    
    const response = {
      success: true,
      message: 'Produto deletado com sucesso',
      data: {
        deletedProduct: existingProduct,
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
