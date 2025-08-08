const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const { DynamoDBDocumentClient, ScanCommand, GetCommand, PutCommand, UpdateCommand, DeleteCommand } = require('@aws-sdk/lib-dynamodb');

// Configurar DynamoDB
const client = new DynamoDBClient({ region: process.env.AWS_REGION || 'sa-east-1' });
const dynamodb = DynamoDBDocumentClient.from(client);
const TABLE_NAME = process.env.DYNAMODB_TABLE;

class ProductRepository {
  // Buscar todos os produtos
  async findAll() {
    const params = {
      TableName: TABLE_NAME
    };
    
    try {
      const result = await dynamodb.send(new ScanCommand(params));
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
      const result = await dynamodb.send(new GetCommand(params));
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
      await dynamodb.send(new PutCommand(params));
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
      const result = await dynamodb.send(new UpdateCommand(params));
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
      await dynamodb.send(new DeleteCommand(params));
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
