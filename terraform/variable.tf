variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "app_name" {
  description = "Name prefix for resources"
  default     = "medusa"
}

variable "container_port" {
  default = 9000
}

variable "desired_count" {
  default = 1
}

variable "db_password" {
  description = "Postgres DB password"
  sensitive   = true
}
