variable "aws_region" {
  description = "Região AWS onde os recursos serão criados"
  type        = string
  default     = "sa-east-1"
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "faas-products-api"
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment deve ser dev, staging ou prod."
  }
}

variable "lambda_runtime" {
  description = "Runtime do Lambda"
  type        = string
  default     = "nodejs18.x"
}

variable "lambda_timeout" {
  description = "Timeout das funções Lambda em segundos"
  type        = number
  default     = 30
}

variable "lambda_memory_size" {
  description = "Memória das funções Lambda em MB"
  type        = number
  default     = 128
}

variable "api_gateway_stage_name" {
  description = "Nome do stage do API Gateway"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Tags para os recursos"
  type        = map(string)
  default = {
    Project     = "faas-products-api"
    Environment = "dev"
    ManagedBy   = "Terraform"
    Owner       = "Danilo"
  }
}
