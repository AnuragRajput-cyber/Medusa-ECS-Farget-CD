variable "aws_region"{
    default="us-east-1"
}

variable "DB_password" {
  description = "DataBase Password"
  sensitive = true
}