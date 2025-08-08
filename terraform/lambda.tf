# Data source para obter o arquivo ZIP das funções
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../src"
  output_path = "${path.module}/lambda.zip"
}

# Função Lambda para listar produtos
resource "aws_lambda_function" "get_products" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "${var.project_name}-get-products"
  role            = aws_iam_role.lambda_role.arn
  handler         = "handlers/getProducts.handler"
  runtime         = var.lambda_runtime
  timeout         = var.lambda_timeout
  memory_size     = var.lambda_memory_size
  
  environment {
    variables = {
      NODE_ENV = var.environment
      DYNAMODB_TABLE = aws_dynamodb_table.products.name
    }
  }
  
  tags = var.tags
}

# Função Lambda para buscar produto por ID
resource "aws_lambda_function" "get_product_by_id" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "${var.project_name}-get-product-by-id"
  role            = aws_iam_role.lambda_role.arn
  handler         = "handlers/getProductById.handler"
  runtime         = var.lambda_runtime
  timeout         = var.lambda_timeout
  memory_size     = var.lambda_memory_size
  
  environment {
    variables = {
      NODE_ENV = var.environment
      DYNAMODB_TABLE = aws_dynamodb_table.products.name
    }
  }
  
  tags = var.tags
}

# Função Lambda para criar produto
resource "aws_lambda_function" "create_product" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "${var.project_name}-create-product"
  role            = aws_iam_role.lambda_role.arn
  handler         = "handlers/createProduct.handler"
  runtime         = var.lambda_runtime
  timeout         = var.lambda_timeout
  memory_size     = var.lambda_memory_size
  
  environment {
    variables = {
      NODE_ENV = var.environment
      DYNAMODB_TABLE = aws_dynamodb_table.products.name
    }
  }
  
  tags = var.tags
}

# Função Lambda para atualizar produto
resource "aws_lambda_function" "update_product" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "${var.project_name}-update-product"
  role            = aws_iam_role.lambda_role.arn
  handler         = "handlers/updateProduct.handler"
  runtime         = var.lambda_runtime
  timeout         = var.lambda_timeout
  memory_size     = var.lambda_memory_size
  
  environment {
    variables = {
      NODE_ENV = var.environment
      DYNAMODB_TABLE = aws_dynamodb_table.products.name
    }
  }
  
  tags = var.tags
}

# Função Lambda para deletar produto
resource "aws_lambda_function" "delete_product" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "${var.project_name}-delete-product"
  role            = aws_iam_role.lambda_role.arn
  handler         = "handlers/deleteProduct.handler"
  runtime         = var.lambda_runtime
  timeout         = var.lambda_timeout
  memory_size     = var.lambda_memory_size
  
  environment {
    variables = {
      NODE_ENV = var.environment
      DYNAMODB_TABLE = aws_dynamodb_table.products.name
    }
  }
  
  tags = var.tags
}

# CloudWatch Log Group para get_products
resource "aws_cloudwatch_log_group" "get_products_logs" {
  name              = "/aws/lambda/${aws_lambda_function.get_products.function_name}"
  retention_in_days = 14
  
  tags = var.tags
}

# CloudWatch Log Group para get_product_by_id
resource "aws_cloudwatch_log_group" "get_product_by_id_logs" {
  name              = "/aws/lambda/${aws_lambda_function.get_product_by_id.function_name}"
  retention_in_days = 14
  
  tags = var.tags
}

# CloudWatch Log Group para create_product
resource "aws_cloudwatch_log_group" "create_product_logs" {
  name              = "/aws/lambda/${aws_lambda_function.create_product.function_name}"
  retention_in_days = 14
  
  tags = var.tags
}

# CloudWatch Log Group para update_product
resource "aws_cloudwatch_log_group" "update_product_logs" {
  name              = "/aws/lambda/${aws_lambda_function.update_product.function_name}"
  retention_in_days = 14
  
  tags = var.tags
}

# CloudWatch Log Group para delete_product
resource "aws_cloudwatch_log_group" "delete_product_logs" {
  name              = "/aws/lambda/${aws_lambda_function.delete_product.function_name}"
  retention_in_days = 14
  
  tags = var.tags
}

# API Gateway Resources e Methods para produtos
resource "aws_api_gateway_resource" "products" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "products"
}

# Método GET para /products
resource "aws_api_gateway_method" "products_get" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.products.id
  http_method   = "GET"
  authorization = "NONE"
}

# Integração Lambda para GET /products
resource "aws_api_gateway_integration" "products_get_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.products.id
  http_method = aws_api_gateway_method.products_get.http_method

  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.get_products.invoke_arn
}

# Método POST para /products
resource "aws_api_gateway_method" "products_post" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.products.id
  http_method   = "POST"
  authorization = "NONE"
}

# Integração Lambda para POST /products
resource "aws_api_gateway_integration" "products_post_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.products.id
  http_method = aws_api_gateway_method.products_post.http_method

  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.create_product.invoke_arn
}

# Recurso para /products/{id}
resource "aws_api_gateway_resource" "products_id" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.products.id
  path_part   = "{id}"
}

# Método GET para /products/{id}
resource "aws_api_gateway_method" "products_id_get" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.products_id.id
  http_method   = "GET"
  authorization = "NONE"
}

# Integração Lambda para GET /products/{id}
resource "aws_api_gateway_integration" "products_id_get_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.products_id.id
  http_method = aws_api_gateway_method.products_id_get.http_method

  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.get_product_by_id.invoke_arn
}

# Método PUT para /products/{id}
resource "aws_api_gateway_method" "products_id_put" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.products_id.id
  http_method   = "PUT"
  authorization = "NONE"
}

# Integração Lambda para PUT /products/{id}
resource "aws_api_gateway_integration" "products_id_put_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.products_id.id
  http_method = aws_api_gateway_method.products_id_put.http_method

  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.update_product.invoke_arn
}

# Método DELETE para /products/{id}
resource "aws_api_gateway_method" "products_id_delete" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.products_id.id
  http_method   = "DELETE"
  authorization = "NONE"
}

# Integração Lambda para DELETE /products/{id}
resource "aws_api_gateway_integration" "products_id_delete_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.products_id.id
  http_method = aws_api_gateway_method.products_id_delete.http_method

  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.delete_product.invoke_arn
}

# Permissão para API Gateway invocar get_products
resource "aws_lambda_permission" "api_gateway_get_products" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_products.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

# Permissão para API Gateway invocar get_product_by_id
resource "aws_lambda_permission" "api_gateway_get_product_by_id" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_product_by_id.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

# Permissão para API Gateway invocar create_product
resource "aws_lambda_permission" "api_gateway_create_product" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_product.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

# Permissão para API Gateway invocar update_product
resource "aws_lambda_permission" "api_gateway_update_product" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update_product.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

# Permissão para API Gateway invocar delete_product
resource "aws_lambda_permission" "api_gateway_delete_product" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_product.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}
