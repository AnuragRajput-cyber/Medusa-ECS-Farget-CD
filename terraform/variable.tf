variable "aws_region"{
    default="us-east-1"
}

variable "DB_PASSWORD" {
  description = "DataBase Password"
  sensitive = true
}