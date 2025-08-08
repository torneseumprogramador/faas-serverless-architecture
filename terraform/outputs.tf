output "api_gateway_url" {
  description = "URL da API Gateway"
  value       = aws_api_gateway_stage.api.invoke_url
}

output "api_gateway_stage_url" {
  description = "URL completa da API com stage"
  value       = aws_api_gateway_stage.api.invoke_url
}

output "lambda_functions" {
  description = "Informações das funções Lambda"
  value = {
    get_products = {
      function_name = aws_lambda_function.get_products.function_name
      arn          = aws_lambda_function.get_products.arn
      invoke_arn   = aws_lambda_function.get_products.invoke_arn
    }
    get_product_by_id = {
      function_name = aws_lambda_function.get_product_by_id.function_name
      arn          = aws_lambda_function.get_product_by_id.arn
      invoke_arn   = aws_lambda_function.get_product_by_id.invoke_arn
    }
    create_product = {
      function_name = aws_lambda_function.create_product.function_name
      arn          = aws_lambda_function.create_product.arn
      invoke_arn   = aws_lambda_function.create_product.invoke_arn
    }
    update_product = {
      function_name = aws_lambda_function.update_product.function_name
      arn          = aws_lambda_function.update_product.arn
      invoke_arn   = aws_lambda_function.update_product.invoke_arn
    }
    delete_product = {
      function_name = aws_lambda_function.delete_product.function_name
      arn          = aws_lambda_function.delete_product.arn
      invoke_arn   = aws_lambda_function.delete_product.invoke_arn
    }
  }
}

output "api_endpoints" {
  description = "Endpoints da API"
  value = {
    get_products     = "${aws_api_gateway_stage.api.invoke_url}/products"
    create_product   = "${aws_api_gateway_stage.api.invoke_url}/products"
    get_product_by_id = "${aws_api_gateway_stage.api.invoke_url}/products/{id}"
    update_product   = "${aws_api_gateway_stage.api.invoke_url}/products/{id}"
    delete_product   = "${aws_api_gateway_stage.api.invoke_url}/products/{id}"
  }
}

output "cloudwatch_log_groups" {
  description = "Log Groups do CloudWatch"
  value = {
    get_products_logs     = aws_cloudwatch_log_group.get_products_logs.name
    get_product_by_id_logs = aws_cloudwatch_log_group.get_product_by_id_logs.name
    create_product_logs   = aws_cloudwatch_log_group.create_product_logs.name
    update_product_logs   = aws_cloudwatch_log_group.update_product_logs.name
    delete_product_logs   = aws_cloudwatch_log_group.delete_product_logs.name
  }
}



output "dynamodb_table" {
  description = "Informações da tabela DynamoDB"
  value = {
    table_name = aws_dynamodb_table.products.name
    arn        = aws_dynamodb_table.products.arn
    id         = aws_dynamodb_table.products.id
  }
}

output "iam_role_arn" {
  description = "ARN do IAM Role"
  value       = aws_iam_role.lambda_role.arn
}
