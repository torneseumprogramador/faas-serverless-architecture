const AWS = require('aws-sdk');

// Configurar DynamoDB
const dynamodb = new AWS.DynamoDB.DocumentClient();
const TABLE_NAME = process.env.DYNAMODB_TABLE;

class ProductRepository {
  // Buscar todos os produtos
  async findAll() {
    const params = {
      TableName: TABLE_NAME
    };
    
    try {
      const result = await dynamodb.scan(params).promise();
      return result.Items || [];
    } catch (error) {
      console.error('Erro ao buscar produtos:', error);
      throw error;
    }
  }

  // Buscar produto por ID
  async findById(id) {
    const params = {
      TableName: TABLE_NAME,
      Key: {
        id: parseInt(id)
      }
    };
    
    try {
      const result = await dynamodb.get(params).promise();
      return result.Item;
    } catch (error) {
      console.error('Erro ao buscar produto:', error);
      throw error;
    }
  }

  // Criar produto
  async create(product) {
    const params = {
      TableName: TABLE_NAME,
      Item: {
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        category: product.category,
        inStock: product.inStock,
        image: product.image,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
      }
    };
    
    try {
      await dynamodb.put(params).promise();
      return params.Item;
    } catch (error) {
      console.error('Erro ao criar produto:', error);
      throw error;
    }
  }

  // Atualizar produto
  async update(id, updates) {
    const updateExpression = [];
    const expressionAttributeNames = {};
    const expressionAttributeValues = {};
    
    // Construir expressão de atualização dinamicamente
    Object.keys(updates).forEach(key => {
      if (key !== 'id') { // Não permitir atualizar o ID
        updateExpression.push(`#${key} = :${key}`);
        expressionAttributeNames[`#${key}`] = key;
        expressionAttributeValues[`:${key}`] = updates[key];
      }
    });
    
    // Adicionar updatedAt
    updateExpression.push('#updatedAt = :updatedAt');
    expressionAttributeNames['#updatedAt'] = 'updatedAt';
    expressionAttributeValues[':updatedAt'] = new Date().toISOString();
    
    const params = {
      TableName: TABLE_NAME,
      Key: {
        id: parseInt(id)
      },
      UpdateExpression: `SET ${updateExpression.join(', ')}`,
      ExpressionAttributeNames: expressionAttributeNames,
      ExpressionAttributeValues: expressionAttributeValues,
      ReturnValues: 'ALL_NEW'
    };
    
    try {
      const result = await dynamodb.update(params).promise();
      return result.Attributes;
    } catch (error) {
      console.error('Erro ao atualizar produto:', error);
      throw error;
    }
  }

  // Deletar produto
  async delete(id) {
    const params = {
      TableName: TABLE_NAME,
      Key: {
        id: parseInt(id)
      }
    };
    
    try {
      await dynamodb.delete(params).promise();
      return { success: true, message: 'Produto deletado com sucesso' };
    } catch (error) {
      console.error('Erro ao deletar produto:', error);
      throw error;
    }
  }

  // Gerar ID único
  async generateId() {
    const products = await this.findAll();
    const maxId = products.length > 0 ? Math.max(...products.map(p => p.id)) : 0;
    return maxId + 1;
  }
}

module.exports = ProductRepository;
