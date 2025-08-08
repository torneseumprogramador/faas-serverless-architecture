# Configurações para ambiente de staging
aws_region = "sa-east-1"
project_name = "faas-products-api"
environment = "staging"
lambda_runtime = "nodejs18.x"
lambda_timeout = 45
lambda_memory_size = 192
api_gateway_stage_name = "staging"

tags = {
  Project     = "faas-products-api"
  Environment = "staging"
  ManagedBy   = "Terraform"
  Owner       = "Danilo"
  Team        = "QA"
}
