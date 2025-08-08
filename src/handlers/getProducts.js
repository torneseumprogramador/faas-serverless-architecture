const products = require('../data/products');

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
    
    // Simular um pequeno delay para demonstrar a natureza assíncrona
    await new Promise(resolve => setTimeout(resolve, 100));
    
    const response = {
      success: true,
      message: 'Produtos recuperados com sucesso',
      data: {
        products,
        total: products.length,
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
