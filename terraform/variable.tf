provider "aws" {
  region = "us-east-1"
}
variable "DB_password" {
  description = "RDS database password"
  type        = string
}
