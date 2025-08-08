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
  }
}

output "api_endpoints" {
  description = "Endpoints da API"
  value = {
    get_products     = "${aws_api_gateway_stage.api.invoke_url}/products"
    get_product_by_id = "${aws_api_gateway_stage.api.invoke_url}/products/{id}"
  }
}

output "cloudwatch_log_groups" {
  description = "Log Groups do CloudWatch"
  value = {
    get_products_logs     = aws_cloudwatch_log_group.get_products_logs.name
    get_product_by_id_logs = aws_cloudwatch_log_group.get_product_by_id_logs.name
  }
}



output "iam_role_arn" {
  description = "ARN do IAM Role"
  value       = aws_iam_role.lambda_role.arn
}
