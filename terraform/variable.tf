variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "app_name" {
  description = "Prefix for resource names"
  default     = "medusa"
}

variable "db_password" {
  description = "Database password"
  sensitive   = true
}

variable "container_port" {
  description = "Container port"
  default     = 9000
}

variable "desired_count" {
  description = "Number of ECS tasks"
  default     = 1
}

variable "ecr_repo" {
  description = "ECR repository URI (without tag)"
}
