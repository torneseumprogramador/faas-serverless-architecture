# Configurações para ambiente de produção
aws_region = "sa-east-1"
project_name = "faas-products-api"
environment = "prod"
lambda_runtime = "nodejs18.x"
lambda_timeout = 60
lambda_memory_size = 256
api_gateway_stage_name = "prod"

tags = {
  Project     = "faas-products-api"
  Environment = "prod"
  ManagedBy   = "Terraform"
  Owner       = "Danilo"
  Team        = "Production"
  CostCenter  = "IT-001"
}
