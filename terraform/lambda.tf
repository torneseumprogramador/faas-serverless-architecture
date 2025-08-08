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
